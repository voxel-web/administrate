class DashboardGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)

  def copy_dashboard_file
    template "dashboard.rb.erb", "app/dashboards/#{file_name}_dashboard.rb"
  end

  private

  def attributes
    klass.attribute_names + klass.reflections.keys
  end

  def field_type(attribute)
    klass.type_for_attribute(attribute).type ||
      association_type(attribute)
  end

  def association_type(attribute)
    reflection = klass.reflections[attribute.to_s]
    if reflection.collection?
      :has_many
    elsif reflection.belongs_to?
      :belongs_to
    else
      throw "Unknown association type: #{reflection.inspect}\n" +
        "Please open an issue on the Administrate repo."
    end
  end

  def klass
    @klass ||= Object.const_get(class_name)
  end
end