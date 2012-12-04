Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab2LDUnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 15:43:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61213 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2LDUnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 15:43:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Eli Billauer <eli.billauer@gmail.com>
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA (programmable logic)
Date: Tue, 4 Dec 2012 20:43:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com> <20121204034128.GC911@kroah.com> <50BDCCCA.4000000@gmail.com>
In-Reply-To: <50BDCCCA.4000000@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212042043.18221.arnd@arndb.de>
X-Provags-ID: V02:K0:gNPBbD1NiA/pjeGgCIVWf20BOOkhOVUA7SeXtsBnfZr
 sp58ZuywVvUUJOnZCqExZJcebBIlTdvl/4xn8HSx13qtZN5qbT
 iD/8yM+2CTuoo1GEerQByUB2SXNVDy8Bn3j2GBAv2rNpTzX1Ci
 zuS/9MzjNtwuIFZY9sBb0ARea+USNlJVfpLY5LhF6NKRXpUvL+
 Be08vfoxLIDFQapzQJOkMMrDmpdcakVVfz6qdqCQpu/EajkxA4
 n8qPiP3Y1uWVaTfAMrSFMGVLgXYOvK9eZ8n1CyA34aakN7WeR3
 TQn6AaaH8BUsnKoz4Dm6IAV1szFmIqjAXAGamY89q1NPCvlgYO
 F+l2frzLxJpFrRzvPrYQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 December 2012, Eli Billauer wrote:
> I'm currently writing some documentation which will cover the API and 
> also help reading the code, I hope. It takes some time...
> 
> Until it's done, let's look at a usage example: Suppose that the FPGA's 
> application is to receive a high-speed bitstream with time multiplexed 
> data, demultiplex the bitstream into individual channel streams, and 
> send each channel's data to the host. And let's say that there are 64 
> channels in original bitstream. So the FPGA has now 64 independent 
> sources of data.
> 
> For that purpose, the Xillybus IP core (on the FPGA) is configured to 
> create 64 pipes for FPGA to host communication. The names of these pipes 
> (say, "chan00", "chan01", ...) are also stored in the FPGA.
> 
> When the driver starts, it queries the FPGA for its Xillybus 
> configuration, and creates 64 device nodes: /dev/xillybus_chan00, 
> /dev/xillybus_chan01, ... /dev/xillybus_chan63.
> 
> If the user wants to dump the data in channel 43 into a file, it's just:
> 
> $ cat /dev/xillybus_chan43 > mydump.dat
> 
> I hope this clarified things a bit.
> 
> I can't see how the firmware interface would help here.

I think a lot of us (including Greg and me) were confused about
the purpose of the driver, since you did not include much documentation.

The request_firmware interface would be useful for loading a model
into the FPGA, but that doesn't seem to be what your driver is
concerned with. It's also a bit confusing because it doesn't appear
to be a "bus" in the Linux sense of being something that provides
an abstract interface between hardware and kernel device drivers.

Instead, you just have a user interface for those FPGA models that
don't need a kernel level driver themselves. This is something
that sits on a somewhat higher level -- if we want a generic FPGA
interface, this would not be directly connected to a PCI or AMBA
bus, but instead connect to an FPGA bus that still needs to be
invented.

In the user interface side that you provide seems to be on the
same interface level as the USB passthrough interface implemented
in drivers/usb/core/devio.c, which has a complex set of ioctls
but does serve a very similar purpose. Greg may want to comment
on whether that is actually a good interface or not, since I assume
he has some experience with how well it worked for USB.

My feeling for now is that we actually need both an in-kernel
interface and a user interface, with the complication that the
hardware should not care which of the two is used for a particular
instance. For the user interface, something that is purely read/write
based is really nice, though I wonder if using debugfs or sysfs
for this would be more appropriate than having lots of character
devices for a single piece of hardware.

	Arnd
