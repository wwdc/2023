import Foundation

struct Submission {
    let name: String
    let status: Status
    let technologies: [String]
    
    let aboutMeUrl: URL?
    let sourceUrl: URL?
    let videoUrl: URL?
    
    enum Status: String {
        case submitted = "Submitted"
        case accepted = "Accepted"
        case winner = "Winner"
        case distinguished = "Distinguished"
        case rejected = "Rejected"
        case unknown = "Unknown"
        
        var iconURLString: String {
            switch self {
            case .submitted:
                "https://img.shields.io/badge/submitted-slategrey?style=for-the-badge"
            case .accepted:
                "https://img.shields.io/badge/accepted-green?style=for-the-badge"
            case .winner:
                "https://img.shields.io/badge/winner-green?style=for-the-badge"
            case .distinguished:
                "https://img.shields.io/badge/distinguished-goldenrod?style=for-the-badge"
            case .rejected:
                "https://img.shields.io/badge/rejected-firebrick?style=for-the-badge"
            case .unknown:
                "https://img.shields.io/badge/unknown-grey?style=for-the-badge"
            }
        }
    }
    
    var row: String {
        let nameRow = if let aboutMeUrl {
            "[\(name)](\(aboutMeUrl.absoluteString))"
        } else {
            "\(name)"
        }
        
        let sourceRow: String = if let sourceUrl {
            "[GitHub](\(sourceUrl.absoluteString))"
        } else {
            "-"
        }
        
        let videoUrl = if let videoUrl {
            "[YouTube](\(videoUrl.absoluteString))"
        } else {
            "-"
        }
        
        let technologiesRow = technologies.joined(separator: ", ")
        
        let statusRow: String = "![\(status.rawValue)](\(status.iconURLString))"
        
        return "|" + [
            nameRow,
            sourceRow,
            videoUrl,
            technologiesRow,
            statusRow
        ].joined(separator: "|") + "|"
    }
}

let migration = """
|[Alperen Örence](https://github.com/alperenorence)|[GitHub](https://github.com/alperenorence/HandSignal)||SwiftUI, CoreML|Accepted|
|[Amelia While](https://github.com/elihwyma) | [GitHub](https://github.com/elihwyma/WWDC2023-Semaphores) | | UIKit, AVFoundation, Vision |Submitted|
|[Chongin Jeong](https://github.com/chongin12) | [GitHub](https://github.com/chongin12/Sometimes) | [YouTube](https://www.youtube.com/watch?v=qT3PcCvPN44) | SwiftUI, AVFoundation, SpriteKit | Submitted |
|[Daniel Riege](https://github.com/danielriege)| [GitHub](https://github.com/danielriege/WWDC23-Submission) | | simd, SceneKit, SwiftUI | Accepted |
|David Mazzeo|[GitHub](https://github.com/TheIntelCorei9/Swift-Student-Challenge-23)|[YouTube](https://www.youtube.com/watch?v=ViGDWfh0ViA)|UIKit, SpriteKit, Core Motion|Submitted|
|[Henri Bredt](https://twitter.com/henricreates) | [GitHub](https://github.com/henribredt) | [YouTube](https://www.youtube.com/watch?v=0ZGPRZ1uUi0) | SwiftUI |Accepted|
|[John Seong](https://johnseong.info) | [GitHub](https://github.com/wonmor/Atomizer-Swift-Challenge) | [YouTube](https://www.youtube.com/watch?v=kHcdvyaqslU) | SwiftUI, SceneKit, ARKit, Vision |Submitted|
|[Jose Adolfo Talactac](https://twitter.com/devjoseadolfo) | [GitHub](https://github.com/devjoseadolfo/LogicBoard) | [YouTube](https://youtu.be/Pg_R5nvF2Tw) | SwiftUI, SpriteKit, UIKit |Accepted|
|[Juraj Kebis](https://github.com/vector23) | [GitHub](https://github.com/vector23/Planties) | | SwiftUI, SpriteKit, UIKit |Submitted|
|[Myung Geun Choi](https://github.com/mgdgc)|[Github](https://github.com/mgdgc/earth-debugger)|[YouTube](https://youtu.be/prc4jeNdFfA)|SwiftUI|Accepted|
|[Riccardo Persello](https://github.com/persello) | [GitHub](https://github.com/persello/ssc23) | | Accelerate, AVFoundation, SwiftUI, Vision | Submitted |
|[Vincent Cai](https://www.instagram.com/vince14genius_0/) | [GitHub](https://github.com/Vince14Genius/My-WWDC-Swift-Student-Challenge-submissions) | | SwiftUI | Accepted |
|[Rithul Kamesh](https://github.com/rithulkamesh) | [GitHub](https://github.com/rithulkamesh/fitness) | | SwiftUI | Submitted |
|[Yanan Li](https://github.com/liyanan2004) | | [YouTube](https://youtu.be/2CStbcJK0qM) | SwiftUI, Swift Charts | Submitted |
|[Yi Cao](https://github.com/xiaoyu2006)|[GitHub](https://github.com/xiaoyu2006/IFS)| |SwiftUI, UIKit|Rejected|
|[Yujin Lee](https://github.com/yujinnee) | [GitHub](https://github.com/yujinnee/WorldHunter) | [YouTube](https://www.youtube.com/watch?v=rlxRgopwPkE) | SwiftUI, UIKit, SceneKit, ARKit |Accepted|

"""

let lines = migration.split(separator: "\n")

func getNameAndAboutMeUrl(for line: String?) -> (name: String, aboutMeUrl: URL?)? {
    guard let line else { return nil }
    let pattern = "\\[(.*?)\\]\\((.*?)\\)"
    
    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return nil }
    
    if let match = regex.firstMatch(in: line, options: [], range: NSRange(line.startIndex..., in: line)) {
        if let nameRange = Range(match.range(at: 1), in: line),
           let urlRange = Range(match.range(at: 2), in: line) {
            let name = String(line[nameRange])
            let url = String(line[urlRange])
            return (name: name, aboutMeUrl: URL(string: url))
        }
    }
    
    return nil
}

func getUrl(from line: String?) -> URL? {
    guard let line else { return nil }
    let pattern = "\\[.*?\\]\\((.*?)\\)"
    
    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return nil }
    
    if let match = regex.firstMatch(in: line, options: [], range: NSRange(line.startIndex..., in: line)) {
        if let urlRange = Range(match.range(at: 1), in: line) {
            return URL(string: String(line[urlRange]))
        }
    }
    
    return nil
}

func getStatus(from line: String?) -> Submission.Status {
    guard let line else { return .unknown }
    return .init(rawValue: line) ?? .unknown
}

var submissions = [Submission]()
for line in lines {
    let columns = line
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .split(separator: "|", omittingEmptySubsequences: false)
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .dropFirst().dropLast()
    let values = getNameAndAboutMeUrl(for: columns.first)
    let sourceUrl = getUrl(from: columns[2])
    let videoUrl = getUrl(from: columns[3])
    let technologies = columns[4].split(separator: ", ")
    let status = getStatus(from: columns.last)
    
    guard let name = values?.name else { continue }
    let submission = Submission(
        name: name,
        status: status,
        technologies: technologies.map { String($0) },
        aboutMeUrl: values?.aboutMeUrl,
        sourceUrl: sourceUrl,
        videoUrl: videoUrl
    )
    
    submissions.append(submission)
}

extension Submission {
    var entityFile: String {
"""
Name: \(name)
Status: \(status.rawValue)
Technologies: \(technologies.joined(separator: ", "))

AboutMeUrl: \(aboutMeUrl == nil ? "" : aboutMeUrl!.absoluteString)
SourceUrl: \(sourceUrl == nil ? "" : sourceUrl!.absoluteString)
VideoUrl: \(videoUrl == nil ? "" : videoUrl!.absoluteString)

<!---
EXAMPLE
Name: John Appleseed
Status: Submitted <or> Winner <or> Distinguished <or> Rejected
Technologies: SwiftUI, RealityKit, CoreGraphic

AboutMeUrl: https://linkedin.com/in/johnappleseed
SourceUrl: https://github.com/johnappleseed/wwdc2025
VideoUrl: https://youtu.be/ABCDE123456
-->

"""
    }
}

for submission in submissions {
    let filename = submission.name
        .replacingOccurrences(of: "Name:", with: "")
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .lowercased()
        .replacingOccurrences(of: " ", with: "") + ".md"
    
    try? submission.entityFile.write(toFile: "Submission/\(filename)", atomically: true, encoding: .utf8)
}
