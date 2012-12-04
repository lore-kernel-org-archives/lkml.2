Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab2LDXFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 18:05:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61318 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2LDXFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 18:05:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Eli Billauer <eli.billauer@gmail.com>
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA (programmable logic)
Date: Tue, 4 Dec 2012 23:05:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com> <201212042043.18221.arnd@arndb.de> <50BE6E61.9000509@gmail.com>
In-Reply-To: <50BE6E61.9000509@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212042305.19180.arnd@arndb.de>
X-Provags-ID: V02:K0:k0qh7Ex9hdpreB0k4dJmiKFLiMabQ0u2TivKi8PLGyM
 mt6krdVFZccVGaDSa6P7GTNsv0p2uWdKD3wcLbMCjKYFwASkVk
 zEKj1KSZTr3OxWcYytEXTeGV2AKvNvk0u4w9+YG8JwESOwO2QP
 N3XahZ41i3y5/EQ9JtMhZSFs+Azcct3WE9/rc2LBKgPb9VMQPA
 41dMTHF9LpnFjcSBEzAK7xfo9kNXxOkhp30q7VWDtI28wK0qrk
 /Zgl80p5eZASN9A9qgRmoopt5k/w4C3QLxbQ4SdCc3aXIam32c
 JczxVUmu/s6+ML/jJSIAzcC6Yr3wl2t7ysajTOYQsU184Oas0P
 nRlgFYkbYiofh7HJ/Tjo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 December 2012, Eli Billauer wrote:
> On 12/04/2012 10:43 PM, Arnd Bergmann wrote:
> > On Tuesday 04 December 2012, Eli Billauer wrote:
> >   It's also a bit confusing because it doesn't appear
> > to be a "bus" in the Linux sense of being something that provides
> > an abstract interface between hardware and kernel device drivers.
> >
> > Instead, you just have a user interface for those FPGA models that
> > don't need a kernel level driver themselves.
>
> I'm not sure I would agree on that. Xillybus consists of an IP core 
> (sort-of library function for an FPGA), and a driver. At the OS level, 
> it's no different than any PCI card and its driver. I call it "generic" 
> because it's not tailored to transport a certain kind of data (say, 
> audio samples or video frames).
>
> In the FPGA world, passing data to or from a processor is a project in 
> itself, in particular if the latter runs a fullblown operating system. 
> What Xillybus does, is supplying a simple interface on both sides: A 
> hardware FIFO on the logic side for the FPGA designer to interface with, 
> and a plain device file on the host's side. The whole point of this 
> project is to make everything simple and intuitive.

The problem with this approach is that it cannot be used to
provide standard OS interfaces: when you have an audio/video device
implemented in an FPGA, all Linux applications expect to use the
alsa and v4l interfaces, not xillybus, which means you need a
kernel-level driver. For special-purpose applications, having
a generic kernel-level driver and a custom user application works
fine, but you don't save any complexity for a lot of other use
cases, you just move it somewhere else by requiring a redesign
of existing user applications, which is often not a reasonable
approach.

> >   This is something
> > that sits on a somewhat higher level -- if we want a generic FPGA
> > interface, this would not be directly connected to a PCI or AMBA
> > bus, but instead connect to an FPGA bus that still needs to be
> > invented.
> >    
> For what it's worth, the driver is now divided into three parts: A 
> xillybus_core, a module for PCIe and a module for Open Firmware 
> interface. The two latter depend on the first, of course.

Ok, that is certainly a good step in the right direction.

> > In the user interface side that you provide seems to be on the
> > same interface level as the USB passthrough interface implemented
> > in drivers/usb/core/devio.c, which has a complex set of ioctls
> > but does serve a very similar purpose. Greg may want to comment
> > on whether that is actually a good interface or not, since I assume
> > he has some experience with how well it worked for USB.
> >
> > My feeling for now is that we actually need both an in-kernel
> > interface and a user interface, with the complication that the
> > hardware should not care which of the two is used for a particular
> > instance.
>
> I'm not sure what you meant here, but I'll mention this: FPGA designers 
> using the IP core don't need to care what the transport is, PCIe, AMBA 
> or anything else. They just see a FIFO. Neither is the host influenced 
> by this, except for loading a different front end module.

I mean some IP cores can use your driver just fine, while other IP
cores require a driver that interfaces with a kernel subsystem
(alsa, v4l, network, iio, etc). Whether xillybus is a good design
choice for those IP cores is a different question, but for all
I can tell, it would be entirely possible to implement an
ethernet adapter based on this, as long as it can interface to
the kernel.

> >   For the user interface, something that is purely read/write
> > based is really nice, though I wonder if using debugfs or sysfs
> > for this would be more appropriate than having lots of character
> > devices for a single piece of hardware.
> >    
> And this is where the term "hardware" becomes elusive with an FPGA: One 
> could look at the entire FPGA chip as a single piece of hardware, and 
> expect everything to be packed into a few device nodes.
> 
> Or, one could look at each of the hardware FIFOs in the FPGA as 
> something like a sound card, an independent piece of hardware, which is 
> the way I chose to look at it. That's why I allocated a character device 
> for each.

Most interfaces we have in the kernel are on a larger scale. E.g. a network
adapter is a single instance rather than an input and an output queue.

> Since the project has been in use by others for about a year (academic 
> users and in the industry), I know at this point that the user interface 
> is convenient to work with (judging from feedback I received). So I 
> would be quite reluctant to make radical changes in the user interface, 
> in particular knowing that it works well and makes UNIX guys feel at home.

Changing to sysfs or debugfs is not a radical change: you would still have
multiple nodes in a file system that each represent a queue, but rather
than using a flat name space under /dev, they would be hierarchical with
a directory per physical device (e.g. one FPGA).

	Arnd
