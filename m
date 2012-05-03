Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787Ab2ECRVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:21:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37877 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752641Ab2ECRVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:21:44 -0400
Date: Thu, 3 May 2012 13:21:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Henrik Rydberg <rydberg@euromail.se>
Subject: Re: proper struct device selection for dev_printk()
In-Reply-To: <20120503171058.GA20605@core.coreip.homeip.net>
Message-ID: <Pine.LNX.4.44L0.1205031317070.1232-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2012, Dmitry Torokhov wrote:

> On Thu, May 03, 2012 at 09:09:37AM -0700, Greg KH wrote:
> > Hi Kay,
> > 
> > I've been working on removing the old err() and dbg() functions in usb.h
> > that have been there since the 2.2 kernel and replace them with calls to
> > dev_err() and dev_dbg(), as that's what we want to have, especially with
> > your dev_printk() reworks.
> > 
> > In some recent changes in the input drivers, Dmitry noted that I was
> > picking the "wrong" struct device to pass to these functions.  I was
> > using the "farthest down the tree" struct device that I could get to, in
> > the USB input driver's case, the struct device for the input device, a
> > "class" device.
> > 
> > But that seems to produce an output that is less than helpful.  Dmitry
> > used this as an example output to show this for a serio device:
> > 	dev_warn(&input_dev->dev, "warning using input device\n");
> > 	dev_warn(&serio->dev, "warning using parent serio device\n");
> > 
> > Produces:
> > 	[    1.903608] input input6: warning using input device
> > 	[    1.903612] psmouse serio1: warning using parent serio device
> > 
> > Here it seems that the "one up from the lowest struct device" works
> > best.
> > 
> > So I tried this out with a usb to serial device, and got the following
> > results.  With the code:
> > 	dev_err(&port->dev, "dev_err port->dev output\n");
> > 	dev_err(&serial->dev->dev, "dev_err serial->dev->dev output\n");
> > 	dev_err(&serial->interface->dev, "dev_err serial->interface->dev output\n");
> > 	dev_err(port->port.tty->dev, "dev_err port->port.tty->dev output\n");
> > 
> > I get:
> > 	[   68.519639] pl2303 ttyUSB0: dev_err port->dev output
> > 	[   68.519645] usb 2-1.2: dev_err serial->dev->dev output
> > 	[   68.519649] pl2303 2-1.2:1.0: dev_err serial->interface->dev output
> > 	[   68.519653] tty ttyUSB0: dev_err port->port.tty->dev output
> > 
> > All of these "describe" the device being operated on in one fashion or
> > the other, as they are struct devices that are easily accessable from
> > the driver.
> > 
> > My question is, what is the "best" thing to be doing here?
> > 
> > I still think the "lowest" struct device would be best (in this case,
> > the last line above from the port->port.tty->dev pointer), but what do
> > you think is best for userspace to have here?
> 
> My $.02:
> 
> In general, drivers should emit messages for the devices they bind to.
> This way driver like psmouse (which is serio subsystem driver) will emit
> messages using serio port it is bound (or attempting to bind to):
> 
> 	[    1.903612] psmouse serio1: warning using parent serio device
> 
> and drivers like wacom which bind to a USB interface will emit messages
> using USB intraface, like:
> 
> 	[    1.234567] wacom 2-1.2:1.0: some error happened
> 
> The benefit of using the device we are binding to is that it allows us
> to crearly identify the driver that emits the error and we are using the
> same device throughout (leaf device might not have been created yet and
> we already need to emit an error or a warning).

That's just what I was going to say.

So for example, in the USB-serial example, the

	usb 2-1.2: dev_err serial->dev->dev output

line isn't specific enough because it doesn't say which interface it 
applies to.  The

	tty ttyUSB0: dev_err port->port.tty->dev output

line is appropriate for a message emanating from the tty core, but not 
from a usb-serial driver.

As for the other two:

	pl2303 ttyUSB0: dev_err port->dev output
	pl2303 2-1.2:1.0: dev_err serial->interface->dev output

either one would be okay.  You could choose between them depending on 
what part of the driver is involved.  A part that handles the tty 
functions would use the first and a part that handles the USB 
communication would use the second.

Alan Stern

