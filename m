Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab2ECSsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:48:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52775 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab2ECSsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:48:03 -0400
Date: Thu, 3 May 2012 11:47:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: Re: proper struct device selection for dev_printk()
Message-ID: <20120503184756.GA21032@core.coreip.homeip.net>
References: <20120503171058.GA20605@core.coreip.homeip.net>
 <Pine.LNX.4.44L0.1205031317070.1232-100000@iolanthe.rowland.org>
 <CAPXgP13XJeuTvhP1RoipFn2fOTb+XN+CxHSJc-hPy+YLEHH1_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPXgP13XJeuTvhP1RoipFn2fOTb+XN+CxHSJc-hPy+YLEHH1_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 07:50:52PM +0200, Kay Sievers wrote:
> On Thu, May 3, 2012 at 7:21 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Thu, 3 May 2012, Dmitry Torokhov wrote:
> >> On Thu, May 03, 2012 at 09:09:37AM -0700, Greg KH wrote:
> >> > I've been working on removing the old err() and dbg() functions in usb.h
> >> > that have been there since the 2.2 kernel and replace them with calls to
> >> > dev_err() and dev_dbg(), as that's what we want to have, especially with
> >> > your dev_printk() reworks.
> >> >
> >> > In some recent changes in the input drivers, Dmitry noted that I was
> >> > picking the "wrong" struct device to pass to these functions.  I was
> >> > using the "farthest down the tree" struct device that I could get to, in
> >> > the USB input driver's case, the struct device for the input device, a
> >> > "class" device.
> >> >
> >> > But that seems to produce an output that is less than helpful.  Dmitry
> >> > used this as an example output to show this for a serio device:
> >> >     dev_warn(&input_dev->dev, "warning using input device\n");
> >> >     dev_warn(&serio->dev, "warning using parent serio device\n");
> >> >
> >> > Produces:
> >> >     [    1.903608] input input6: warning using input device
> >> >     [    1.903612] psmouse serio1: warning using parent serio device
> >> >
> >> > Here it seems that the "one up from the lowest struct device" works
> >> > best.
> >> >
> >> > So I tried this out with a usb to serial device, and got the following
> >> > results.  With the code:
> >> >     dev_err(&port->dev, "dev_err port->dev output\n");
> >> >     dev_err(&serial->dev->dev, "dev_err serial->dev->dev output\n");
> >> >     dev_err(&serial->interface->dev, "dev_err serial->interface->dev output\n");
> >> >     dev_err(port->port.tty->dev, "dev_err port->port.tty->dev output\n");
> >> >
> >> > I get:
> >> >     [   68.519639] pl2303 ttyUSB0: dev_err port->dev output
> >> >     [   68.519645] usb 2-1.2: dev_err serial->dev->dev output
> >> >     [   68.519649] pl2303 2-1.2:1.0: dev_err serial->interface->dev output
> >> >     [   68.519653] tty ttyUSB0: dev_err port->port.tty->dev output
> >> >
> >> > All of these "describe" the device being operated on in one fashion or
> >> > the other, as they are struct devices that are easily accessable from
> >> > the driver.
> >> >
> >> > My question is, what is the "best" thing to be doing here?
> >> >
> >> > I still think the "lowest" struct device would be best (in this case,
> >> > the last line above from the port->port.tty->dev pointer), but what do
> >> > you think is best for userspace to have here?
> >>
> >> My $.02:
> >>
> >> In general, drivers should emit messages for the devices they bind to.
> >> This way driver like psmouse (which is serio subsystem driver) will emit
> >> messages using serio port it is bound (or attempting to bind to):
> 
> >> The benefit of using the device we are binding to is that it allows us
> >> to crearly identify the driver that emits the error and we are using the
> >> same device throughout (leaf device might not have been created yet and
> >> we already need to emit an error or a warning).
> >
> > That's just what I was going to say.
> >
> > So for example, in the USB-serial example, the
> >
> >        usb 2-1.2: dev_err serial->dev->dev output
> >
> > line isn't specific enough because it doesn't say which interface it
> > applies to.  The
> >
> >        tty ttyUSB0: dev_err port->port.tty->dev output
> >
> > line is appropriate for a message emanating from the tty core, but not
> > from a usb-serial driver.
> >
> > As for the other two:
> >
> >        pl2303 ttyUSB0: dev_err port->dev output
> >        pl2303 2-1.2:1.0: dev_err serial->interface->dev output
> >
> > either one would be okay.  You could choose between them depending on
> > what part of the driver is involved.  A part that handles the tty
> > functions would use the first and a part that handles the USB
> > communication would use the second.
> 
> Well, it's easy for userspace to find the parent devices and the
> drivers and the buses of all involved chained parent devices, but
> often impossible to find the child device which is interesting, if
> only a parent is given.
> 
> As long as there is only one child, it might all work to guess that
> from userspace, but in general userspace does not care about any bus
> devices, but only about the stuff that is visible to userspace.
> 
> I don't think such rules about using the parent device can really be
> made, regarding the general usefulness of log messages. The driver and
> all the kernel internals really does not matter at all for the
> (generic) userspace consumption side; all that matters is the device
> providing the interface that is accessed by userspace.
> 
> In short: "psmouse serio1" is entirely worthless for userspace, unless
> you are debugging the kernel input stack; while "event6" is all
> userspace cares about and what it can make sense of.
> 
> I guess it all depends who is the consumer of the messages, and I
> would say if userspace is the intended consumer, always use the device
> that provides the access/interface to userspace. It's easy to walk up
> the tree and find out about the other things.

This would be:

1. Impossible in most cases
2. If it was possible it woudl have to be layer violation.

Taking psmouse as an example you have no idea which interface to use to
report errors - mouse2, event6 or js1 - these are what visible from
userspace and all of them could report to the same input device. We
however know exactly what serio port we had trouble with.

Now consider error happending on i8042 level. Do we descend into
serio layer and reportan error there? Why? Serio layer is perfectly
fine, and besides why would we confuse user that psmouse driver had an
issue whereas it was i8042 that needs to be looked at?

Also, I do not think that vague "userspace" is consumer for these
messages; this is really something a human needs to look at and analyze.

Thanks.

-- 
Dmitry
