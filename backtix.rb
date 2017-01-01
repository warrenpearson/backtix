require 'open3'

module Backtix
  def run(cmd, capture_output = false, allow_failure = false)
    puts "running command:\n\t#{cmd}"
    output = ''
    status = nil

    if capture_output
      output = `#{cmd}`
      status = $?
    else
      Open3.popen2e(cmd) do |_, stdout_stderr, wait_thread|
        Thread.new do
          stdout_stderr.each { |l| puts l }
        end

        status = wait_thread.value
      end
    end

    unless status.success?
      if allow_failure
        puts "Command failed: #{status}"
        return ''
      else
        puts "Command failed: #{status}, exiting"
        exit
      end

    end

    output if capture_output
  end
end
