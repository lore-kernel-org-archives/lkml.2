Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab2LEAEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 19:04:32 -0500
Received: from mxout4.netvision.net.il ([194.90.9.27]:41122 "EHLO
	mxout4.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2LEAEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 19:04:30 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <50BE8F6D.4070305@gmail.com>
Date: Wed, 05 Dec 2012 02:03:57 +0200
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
 <201212042043.18221.arnd@arndb.de> <50BE6E61.9000509@gmail.com>
 <201212042305.19180.arnd@arndb.de>
In-reply-to: <201212042305.19180.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 01:05 AM, Arnd Bergmann wrote:
> On Tuesday 04 December 2012, Eli Billauer wrote:
>    
>> On 12/04/2012 10:43 PM, Arnd Bergmann wrote:
>>      
>>> On Tuesday 04 December 2012, Eli Billauer wrote:
>>>    It's also a bit confusing because it doesn't appear
>>> to be a "bus" in the Linux sense of being something that provides
>>> an abstract interface between hardware and kernel device drivers.
>>>
>>> Instead, you just have a user interface for those FPGA models that
>>> don't need a kernel level driver themselves.
>>>        
>> I'm not sure I would agree on that. Xillybus consists of an IP core
>> (sort-of library function for an FPGA), and a driver. At the OS level,
>> it's no different than any PCI card and its driver. I call it "generic"
>> because it's not tailored to transport a certain kind of data (say,
>> audio samples or video frames).
>>
>> In the FPGA world, passing data to or from a processor is a project in
>> itself, in particular if the latter runs a fullblown operating system.
>> What Xillybus does, is supplying a simple interface on both sides: A
>> hardware FIFO on the logic side for the FPGA designer to interface with,
>> and a plain device file on the host's side. The whole point of this
>> project is to make everything simple and intuitive.
>>      
> The problem with this approach is that it cannot be used to
> provide standard OS interfaces: when you have an audio/video device
> implemented in an FPGA, all Linux applications expect to use the
> alsa and v4l interfaces, not xillybus, which means you need a
> kernel-level driver. For special-purpose applications, having
> a generic kernel-level driver and a custom user application works
> fine, but you don't save any complexity for a lot of other use
> cases, you just move it somewhere else by requiring a redesign
> of existing user applications, which is often not a reasonable
> approach.
>
>    
Xillybus is there exactly for special-purpose applications. In fact, the 
main reason people turn to FPGAs is because there are no general-purpose 
chips to do the job.

Besides, if the FPGA implements a well-known function (e.g. a video 
card) there is no reason to treat it differently IMHO. For example, 
drivers/video/xilinxfb.c, drivers/tty/serial/xilinx_uartps.c work only 
with Xilinx' IP cores, and they're mixed with the "hardware" drivers.

It's when it doesn't make sense to represent the FPGA logic as something 
standard, that Xillybus comes in. Even if the reason is not being ready 
to spend the effort.

>
>> I'm not sure what you meant here, but I'll mention this: FPGA designers
>> using the IP core don't need to care what the transport is, PCIe, AMBA
>> or anything else. They just see a FIFO. Neither is the host influenced
>> by this, except for loading a different front end module.
>>      
> I mean some IP cores can use your driver just fine, while other IP
> cores require a driver that interfaces with a kernel subsystem
> (alsa, v4l, network, iio, etc). Whether xillybus is a good design
> choice for those IP cores is a different question, but for all
> I can tell, it would be entirely possible to implement an
> ethernet adapter based on this, as long as it can interface to
> the kernel.
>
>    
Xillybus' strength is its simplicity in sending plain streams of data. 
If the data is looped back into the kernel to implement a network 
interface, that's indeed possible. As for dedicated interfaces, I'll say 
this: I wrote a simple video adapter for Zynq lately. To some extent, 
the logic is based upon things I took from Xillybus, but no more than 
some basic blocks. As for the driver, I started from a completely 
different one.

What I'm trying to say, is that it's possible to implement dedicated 
functions based upon Xillybus, but in practice it doesn't make much sense.
>>>    For the user interface, something that is purely read/write
>>> based is really nice, though I wonder if using debugfs or sysfs
>>> for this would be more appropriate than having lots of character
>>> devices for a single piece of hardware.
>>>
>>>        
>> And this is where the term "hardware" becomes elusive with an FPGA: One
>> could look at the entire FPGA chip as a single piece of hardware, and
>> expect everything to be packed into a few device nodes.
>>
>> Or, one could look at each of the hardware FIFOs in the FPGA as
>> something like a sound card, an independent piece of hardware, which is
>> the way I chose to look at it. That's why I allocated a character device
>> for each.
>>      
> Most interfaces we have in the kernel are on a larger scale. E.g. a network
> adapter is a single instance rather than an input and an output queue.
>
>    
>> Since the project has been in use by others for about a year (academic
>> users and in the industry), I know at this point that the user interface
>> is convenient to work with (judging from feedback I received). So I
>> would be quite reluctant to make radical changes in the user interface,
>> in particular knowing that it works well and makes UNIX guys feel at home.
>>      
> Changing to sysfs or debugfs is not a radical change: you would still have
> multiple nodes in a file system that each represent a queue, but rather
> than using a flat name space under /dev, they would be hierarchical with
> a directory per physical device (e.g. one FPGA).
>    
Just to make sure we're on the same page: The Xillybus char devices need 
to pass bulks of data efficiently (not just attributes), and also 
support .poll and .llseek methods (I thought that sysfs was for small 
bites of info).

I understand that you suggest that instead of polluting /dev, I should 
relocate my device files to /sys/something...?

Could you please point at a driver in the kernel tree that does this 
correctly, so I can imitate it? And under what directory would it make 
sense to put it? I'm not so familiar with sysfs.

Thanks,
    Eli


