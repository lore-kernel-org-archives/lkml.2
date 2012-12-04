Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab2LDVoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 16:44:23 -0500
Received: from mxout4.netvision.net.il ([194.90.9.27]:63345 "EHLO
	mxout4.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab2LDVoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 16:44:18 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <50BE6E61.9000509@gmail.com>
Date: Tue, 04 Dec 2012 23:42:57 +0200
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
 <20121204034128.GC911@kroah.com> <50BDCCCA.4000000@gmail.com>
 <201212042043.18221.arnd@arndb.de>
In-reply-to: <201212042043.18221.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2012 10:43 PM, Arnd Bergmann wrote:
> On Tuesday 04 December 2012, Eli Billauer wrote:
>    
>> I'm currently writing some documentation which will cover the API and
>> also help reading the code, I hope. It takes some time...
>>
>> Until it's done, let's look at a usage example: Suppose that the FPGA's
>> application is to receive a high-speed bitstream with time multiplexed
>> data, demultiplex the bitstream into individual channel streams, and
>> send each channel's data to the host. And let's say that there are 64
>> channels in original bitstream. So the FPGA has now 64 independent
>> sources of data.
>>
>> For that purpose, the Xillybus IP core (on the FPGA) is configured to
>> create 64 pipes for FPGA to host communication. The names of these pipes
>> (say, "chan00", "chan01", ...) are also stored in the FPGA.
>>
>> When the driver starts, it queries the FPGA for its Xillybus
>> configuration, and creates 64 device nodes: /dev/xillybus_chan00,
>> /dev/xillybus_chan01, ... /dev/xillybus_chan63.
>>
>> If the user wants to dump the data in channel 43 into a file, it's just:
>>
>> $ cat /dev/xillybus_chan43>  mydump.dat
>>
>> I hope this clarified things a bit.
>>
>> I can't see how the firmware interface would help here.
>>      
> I think a lot of us (including Greg and me) were confused about
> the purpose of the driver, since you did not include much documentation.
>    
I'm really sorry about this. I begin to realize the confusion now, and 
Xillybus is indeed not a bus.
> The request_firmware interface would be useful for loading a model
> into the FPGA, but that doesn't seem to be what your driver is
> concerned with.
Indeed, Xillybus is not about loading the configuration bitstream for 
the FPGA.
>   It's also a bit confusing because it doesn't appear
> to be a "bus" in the Linux sense of being something that provides
> an abstract interface between hardware and kernel device drivers.
>
> Instead, you just have a user interface for those FPGA models that
> don't need a kernel level driver themselves.
I'm not sure I would agree on that. Xillybus consists of an IP core 
(sort-of library function for an FPGA), and a driver. At the OS level, 
it's no different than any PCI card and its driver. I call it "generic" 
because it's not tailored to transport a certain kind of data (say, 
audio samples or video frames).

In the FPGA world, passing data to or from a processor is a project in 
itself, in particular if the latter runs a fullblown operating system. 
What Xillybus does, is supplying a simple interface on both sides: A 
hardware FIFO on the logic side for the FPGA designer to interface with, 
and a plain device file on the host's side. The whole point of this 
project is to make everything simple and intuitive.
>   This is something
> that sits on a somewhat higher level -- if we want a generic FPGA
> interface, this would not be directly connected to a PCI or AMBA
> bus, but instead connect to an FPGA bus that still needs to be
> invented.
>    
For what it's worth, the driver is now divided into three parts: A 
xillybus_core, a module for PCIe and a module for Open Firmware 
interface. The two latter depend on the first, of course.
> In the user interface side that you provide seems to be on the
> same interface level as the USB passthrough interface implemented
> in drivers/usb/core/devio.c, which has a complex set of ioctls
> but does serve a very similar purpose. Greg may want to comment
> on whether that is actually a good interface or not, since I assume
> he has some experience with how well it worked for USB.
>
> My feeling for now is that we actually need both an in-kernel
> interface and a user interface, with the complication that the
> hardware should not care which of the two is used for a particular
> instance.
I'm not sure what you meant here, but I'll mention this: FPGA designers 
using the IP core don't need to care what the transport is, PCIe, AMBA 
or anything else. They just see a FIFO. Neither is the host influenced 
by this, except for loading a different front end module.
>   For the user interface, something that is purely read/write
> based is really nice, though I wonder if using debugfs or sysfs
> for this would be more appropriate than having lots of character
> devices for a single piece of hardware.
>    
And this is where the term "hardware" becomes elusive with an FPGA: One 
could look at the entire FPGA chip as a single piece of hardware, and 
expect everything to be packed into a few device nodes.

Or, one could look at each of the hardware FIFOs in the FPGA as 
something like a sound card, an independent piece of hardware, which is 
the way I chose to look at it. That's why I allocated a character device 
for each.

Since the project has been in use by others for about a year (academic 
users and in the industry), I know at this point that the user interface 
is convenient to work with (judging from feedback I received). So I 
would be quite reluctant to make radical changes in the user interface, 
in particular knowing that it works well and makes UNIX guys feel at home.

Regards,
    Eli


> 	Arnd
>
>    


