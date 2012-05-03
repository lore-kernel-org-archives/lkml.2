Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab2ECRvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:51:15 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39191 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945Ab2ECRvN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:51:13 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1205031317070.1232-100000@iolanthe.rowland.org>
References: <20120503171058.GA20605@core.coreip.homeip.net> <Pine.LNX.4.44L0.1205031317070.1232-100000@iolanthe.rowland.org>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 3 May 2012 19:50:52 +0200
Message-ID: <CAPXgP13XJeuTvhP1RoipFn2fOTb+XN+CxHSJc-hPy+YLEHH1_g@mail.gmail.com>
Subject: Re: proper struct device selection for dev_printk()
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 7:21 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 3 May 2012, Dmitry Torokhov wrote:
>> On Thu, May 03, 2012 at 09:09:37AM -0700, Greg KH wrote:
>> > I've been working on removing the old err() and dbg() functions in usb.h
>> > that have been there since the 2.2 kernel and replace them with calls to
>> > dev_err() and dev_dbg(), as that's what we want to have, especially with
>> > your dev_printk() reworks.
>> >
>> > In some recent changes in the input drivers, Dmitry noted that I was
>> > picking the "wrong" struct device to pass to these functions.  I was
>> > using the "farthest down the tree" struct device that I could get to, in
>> > the USB input driver's case, the struct device for the input device, a
>> > "class" device.
>> >
>> > But that seems to produce an output that is less than helpful.  Dmitry
>> > used this as an example output to show this for a serio device:
>> >     dev_warn(&input_dev->dev, "warning using input device\n");
>> >     dev_warn(&serio->dev, "warning using parent serio device\n");
>> >
>> > Produces:
>> >     [    1.903608] input input6: warning using input device
>> >     [    1.903612] psmouse serio1: warning using parent serio device
>> >
>> > Here it seems that the "one up from the lowest struct device" works
>> > best.
>> >
>> > So I tried this out with a usb to serial device, and got the following
>> > results.  With the code:
>> >     dev_err(&port->dev, "dev_err port->dev output\n");
>> >     dev_err(&serial->dev->dev, "dev_err serial->dev->dev output\n");
>> >     dev_err(&serial->interface->dev, "dev_err serial->interface->dev output\n");
>> >     dev_err(port->port.tty->dev, "dev_err port->port.tty->dev output\n");
>> >
>> > I get:
>> >     [   68.519639] pl2303 ttyUSB0: dev_err port->dev output
>> >     [   68.519645] usb 2-1.2: dev_err serial->dev->dev output
>> >     [   68.519649] pl2303 2-1.2:1.0: dev_err serial->interface->dev output
>> >     [   68.519653] tty ttyUSB0: dev_err port->port.tty->dev output
>> >
>> > All of these "describe" the device being operated on in one fashion or
>> > the other, as they are struct devices that are easily accessable from
>> > the driver.
>> >
>> > My question is, what is the "best" thing to be doing here?
>> >
>> > I still think the "lowest" struct device would be best (in this case,
>> > the last line above from the port->port.tty->dev pointer), but what do
>> > you think is best for userspace to have here?
>>
>> My $.02:
>>
>> In general, drivers should emit messages for the devices they bind to.
>> This way driver like psmouse (which is serio subsystem driver) will emit
>> messages using serio port it is bound (or attempting to bind to):

>> The benefit of using the device we are binding to is that it allows us
>> to crearly identify the driver that emits the error and we are using the
>> same device throughout (leaf device might not have been created yet and
>> we already need to emit an error or a warning).
>
> That's just what I was going to say.
>
> So for example, in the USB-serial example, the
>
>        usb 2-1.2: dev_err serial->dev->dev output
>
> line isn't specific enough because it doesn't say which interface it
> applies to.  The
>
>        tty ttyUSB0: dev_err port->port.tty->dev output
>
> line is appropriate for a message emanating from the tty core, but not
> from a usb-serial driver.
>
> As for the other two:
>
>        pl2303 ttyUSB0: dev_err port->dev output
>        pl2303 2-1.2:1.0: dev_err serial->interface->dev output
>
> either one would be okay.  You could choose between them depending on
> what part of the driver is involved.  A part that handles the tty
> functions would use the first and a part that handles the USB
> communication would use the second.

Well, it's easy for userspace to find the parent devices and the
drivers and the buses of all involved chained parent devices, but
often impossible to find the child device which is interesting, if
only a parent is given.

As long as there is only one child, it might all work to guess that
from userspace, but in general userspace does not care about any bus
devices, but only about the stuff that is visible to userspace.

I don't think such rules about using the parent device can really be
made, regarding the general usefulness of log messages. The driver and
all the kernel internals really does not matter at all for the
(generic) userspace consumption side; all that matters is the device
providing the interface that is accessed by userspace.

In short: "psmouse serio1" is entirely worthless for userspace, unless
you are debugging the kernel input stack; while "event6" is all
userspace cares about and what it can make sense of.

I guess it all depends who is the consumer of the messages, and I
would say if userspace is the intended consumer, always use the device
that provides the access/interface to userspace. It's easy to walk up
the tree and find out about the other things.

If there is no clear definition to make, messages should just be
emitted for the device where the context of the emitted message
applies closest to.

General rules like: always use the parent, or always the bus device,
don't sound right to me.

Kay
