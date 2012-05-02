Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab2EBW2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 18:28:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57522 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab2EBW1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 18:27:32 -0400
Date: Wed, 2 May 2012 15:27:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Preston Fick <pffick@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        preston.fick@silabs.com
Subject: Re: [PATCH 3/3] usb: cp210x: Add ioctl for GPIO support
Message-ID: <20120502222728.GA2871@kroah.com>
References: <1335845210-5147-1-git-send-email-preston.fick@silabs.com>
 <1335845210-5147-3-git-send-email-preston.fick@silabs.com>
 <20120502200356.GA25915@kroah.com>
 <20120502214901.6b6e031c@pyramind.ukuu.org.uk>
 <20120502215226.GD27281@kroah.com>
 <20120502231027.1c45105d@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502231027.1c45105d@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 11:10:27PM +0100, Alan Cox wrote:
> On Wed, 2 May 2012 14:52:26 -0700
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Wed, May 02, 2012 at 09:49:01PM +0100, Alan Cox wrote:
> > > > Actually, why can't you use the GPIO subsystem for something like this?
> > > > Can't you export your device as both a usb-serial device and a gpio
> > > > device and have things work properly that way?
> > > 
> > > You still need the ioctls even then in order to discover the gpio
> > > numbers
> > 
> > What discovery?  The device knows what gpio values it has in it, and
> > should be able to register those with the gpio subsystem.
> 
> You open /dev/ttyUSB0
> 
> Ok now in your user application how are you going to find which gpio
> numbers to use that are associated with this specific port,

Just look at the gpio device that has ttyUSB0 as its parent.

> and how is udev going to do that to manage permissions ?

How does udev handle permissions for gpio devices today?

> So you need an ioctl to give you the range that is mapped to this (or a
> sysfs node, but the sysfs node makes the security problem pretty
> much insoluble)

range for what?  Doesn't the gpio interfac provide the size of the gpio
registers to userspace?

As for security, how is that handled today with gpio devices?

> > > and having done that youi've got potential races with unload
> > > when you try and open them. You've also got permissions considerations
> > > and synchronization between gpio and data problems.
> > 
> > That can be handled in the driver itself, if it really is a problem (the
> > existing patch sure didn't handle any of that at all, so I'm guessing
> > either it wasn't considered, or it isn't a problem.)
> 
> Not reliably
> 
> 	open /dev/ttyUSB0 [or sysfs node]
> 	read gpio numbers
> 	close 
> 
> 	open gpio foo
> 
> Oh dear... so random shell scripting user is going to screw up horribly.

What's the odds that the data going across the tty link corrisponds with
the gpio control?

And shell scripting the gpio interface is used today, I've seen it on
the beaglebone machine.

> > > It's not a good way to go. It might make sense in some platforms to
> > > expose them as both but its not a good general model.
> > 
> > Why isn't the gpio subsystem a good general model?  I thought that is
> > what it was created to solve?
> 
> gpio provides a flat abstraction for arbitary pins on a platform. It's
> really oriented to fairly fixed system stuff. It doesn't provide a useful
> abstraction for extra carrier lines.
> 
> Imagine if RTS and DTR were driven by GPIO pins instead of the tty
> layer. Many devices use them as extra magic GPIO lines not as tty control
> lines, so its an equivalent argument.

Ok, fair enough, but RTS and DTR are "well defined" as part of the RS232
specs, and handle flow of the data itself.  These gpio lines are not tty
control, but as you point out, used for other things, so keeping them
separate from the tty node seems to make sense to me.

> > > I'm currently favouring adding some 'additional control line' bits to
> > > termiox.
> > 
> > Yes, but that's only good for usb-serial devices that also have gpio
> > pins on the controller side.  Which seems pretty limited to me.
> > 
> > If I have a userspace program, and I want to use GPIO, I shouldn't have
> > to care/know that the pins are really on the end of a USB->serial
> > bridge, or somewhere hanging off of a SOC, the same userspace api should
> > "just work", right?
> 
> For certain applications that makes more sense, which is why I said you
> may well want to expose it as both. However you still need both, and
> ideally we need a standardised pattern of assignments for line
> disciplines that use the extra control lines (which has come up recently
> for another device with extra lines)
> 
> I think it basically boils down to this
> 
> If you have a serial port with some gpio lines that drive arbitary
> unrelated electronics then the gpio interface is handy because you can
> use the same code logic as if it was wired to other pins elsewhere
> 
> If you are using them as part of the tty interface as extra control lines
> (eg for smartcard protocols) then you want them driven via the tty
> interface and doubly so once we add some of the smartcard/sim ldisc
> support.
> 
> Hence we really need to expose them both ways because end users are doing
> both things with the gpio pins on these ports.
> 
> So I'd suggest we expose them via termiox bits and also via the tty
> providing gpio range info in a standardised way.

Ok, I'll wait for your proposed standardised way before complaining any
more :)

thanks,

greg k-h
