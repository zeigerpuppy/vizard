# encoding: utf-8

require File.join(File.dirname(__FILE__), 'plantuml.jar')

java_import 'net.sourceforge.plantuml.SourceStringReader'
java_import 'net.sourceforge.plantuml.FileFormatOption'
java_import 'net.sourceforge.plantuml.FileFormat'
java_import 'java.io.ByteArrayOutputStream'
java_import 'java.io.FileOutputStream'

module PlantumlRenderer
  extend self

  FORMAT_MAPPING = {
    'svg'  => FileFormat::SVG,
    'png'  => FileFormat::PNG,
    'txt'  => FileFormat::ATXT,
    'utxt' => FileFormat::UTXT
    # error: PDF, HTML
    # wrong: HTML5
    # untested: EPS, EPS_TEXT, XMI_STANDARD, XMI_STAR, XMI_ARGO, MJPEG
  }

  def decorate(string)
    return string if string =~ /@startuml/
    "@startuml\n #{string}\n @enduml"
  end

  def render(diagram_data, format = 'svg')
    diagram_data = decorate(diagram_data)
    ByteArrayOutputStream.new.tap do |out|
      SourceStringReader.new(diagram_data).generate_image(out, FileFormatOption.new(FORMAT_MAPPING[format.to_s]))
      return out.to_byte_array.to_a.pack('c*')
    end
  end
end