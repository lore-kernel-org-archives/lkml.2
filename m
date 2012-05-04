Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086Ab2EDAHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 20:07:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35161 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab2EDAHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 20:07:45 -0400
Date: Thu, 3 May 2012 17:07:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: Re: proper struct device selection for dev_printk()
Message-ID: <20120504000740.GC32225@kroah.com>
References: <20120503171058.GA20605@core.coreip.homeip.net>
 <Pine.LNX.4.44L0.1205031317070.1232-100000@iolanthe.rowland.org>
 <CAPXgP13XJeuTvhP1RoipFn2fOTb+XN+CxHSJc-hPy+YLEHH1_g@mail.gmail.com>
 <20120503184756.GA21032@core.coreip.homeip.net>
 <CAPXgP11ktmMcLvwYy9PvyZ_J9bmmAzdmqzKCVE6Q0dbKHyG9eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP11ktmMcLvwYy9PvyZ_J9bmmAzdmqzKCVE6Q0dbKHyG9eg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 09:12:43PM +0200, Kay Sievers wrote:
> On Thu, May 3, 2012 at 8:47 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Thu, May 03, 2012 at 07:50:52PM +0200, Kay Sievers wrote:
> 
> >> I guess it all depends who is the consumer of the messages, and I
> >> would say if userspace is the intended consumer, always use the device
> >> that provides the access/interface to userspace. It's easy to walk up
> >> the tree and find out about the other things.
> >
> > This would be:
> >
> > 1. Impossible in most cases
> > 2. If it was possible it woudl have to be layer violation.
> 
> Yeah, if it would be easy, Greg would not have written the mail. :)
> 
> > Taking psmouse as an example you have no idea which interface to use to
> > report errors - mouse2, event6 or js1 - these are what visible from
> > userspace and all of them could report to the same input device.
> 
> True, if the error does not propagate up to the class device, it does
> not sound right to do that. But it's still the case that userspace or
> any automated message consumer cannot make much sense out of the
> message then. It's still targeted at a human.

Yes, that's the point here, what is a human supposed to do with this?

> > We
> > however know exactly what serio port we had trouble with.
> 
> Sure, if the error occurs in that context, it should be logged with
> exactly that context. If it propagates up to the higher devices they
> should log themselves.
> 
> The point I tried to make was, that we should not in general walk up
> to the next bus device for logging, and that the parent devices are
> not more useful in general. I wanted to express that a rule like: "In
> general, drivers should emit messages for the devices they bind to."
> is not the right thing to do, if we *can* establish a context to the
> device that is used in userspace.
> 
> But sure, if the error can not be propagated to the child devices, we
> should not fake anything here either, but the stuff should stay where
> it happened.

Ok, so it is probably best to use the struct device that the piece of
code has control over.  Which sometimes is not the lowest one, but
sometimes it is.  That's a good rule to go by, thanks everyone.

In my original example, out of:
        dev_err(&port->dev, "dev_err port->dev output\n");
        dev_err(&serial->dev->dev, "dev_err serial->dev->dev output\n");
        dev_err(&serial->interface->dev, "dev_err serial->interface->dev output\n");
        dev_err(port->port.tty->dev, "dev_err port->port.tty->dev output\n");
        [   68.519639] pl2303 ttyUSB0: dev_err port->dev output
        [   68.519645] usb 2-1.2: dev_err serial->dev->dev output
        [   68.519649] pl2303 2-1.2:1.0: dev_err serial->interface->dev output
        [   68.519653] tty ttyUSB0: dev_err port->port.tty->dev output

I will choose the first one, "&port->dev" as that is what the driver
controls at this point in time.  Sometimes, it's only the USB interface
that it knows about (like in the probe() and release() USB callbacks),
but for the most part, it will be consistant.

So, Dmitry, this agrees with your original complaint as well, the input
device isn't the right thing to do, but the USB interface is.  I'll go
rework those patches again (third times a charm, right?) to do it that
way.

thanks,

greg k-h
