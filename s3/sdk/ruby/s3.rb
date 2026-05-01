require 'aws-sdk-s3'
require 'pry'
require 'securerandom'

bucket_name=ENV['BUCKET']
puts bucket_name


client = Aws::S3::Client.new()

resp = client.create_bucket({
  bucket: bucket_name, 
  create_bucket_configuration: {
  }, 
})

# binding.pry 

num_files = 1 + rand(6)
puts "Num files: #{num_files}"

num_files.times.each do |i|
    puts "i: #{i}"
    file_name = "file_#{i}.txt"
    output_path = "/tmp/#{file_name}"

    File.open(output_path, "w") do |file|
        file.write SecureRandom.uuid    
    end

    # upload file from disk in a single request, may not exceed 5GB
    File.open(output_path, 'rb') do |file|
        client.put_object(bucket: bucket_name, key: file_name, body: file)
    end
end

