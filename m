Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab1HSO3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:29:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47392 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754324Ab1HSO3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:29:16 -0400
Date: Fri, 19 Aug 2011 10:29:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mina86@mina86.com>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sergei Shtylyov <sshtylyov@mvista.com>, Felipe Balbi <balbi@ti.com>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] usb: gadget: get rid of USB_GADGET_DUALSPEED and
 USB_GADGET_SUPERSPEED
In-Reply-To: <op.v0gmyfhi3l0zgt@mnazarewicz-glaptop>
Message-ID: <Pine.LNX.4.44L0.1108191009410.2016-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Aug 2011, Michal Nazarewicz wrote:

> On Fri, 19 Aug 2011 13:13:41 +0200, Sebastian Andrzej Siewior  
> <bigeasy@linutronix.de> wrote:
> > There are three speeds:
> > - the max speed the UDC supports i.e. HS (no field for that?)
> 
> Yep, the field seems to be missing for that one.  We have is_dualspeed and
> comment in gadget_is_superspeed() says about is_superspeed but that does
> not exist.

Evidently we need is_superspeed.

> > - the max speed the gadget / function driver support i.e. SS
> >    (driver->max_speed ?)
> 
> Actually “max_speed” is only in usb_composite_driver structure.
> usb_gadget_driver has only “speed” and it's description says that it is
> the “highest speed the driver handles.”  Because of that description I've
> assumed that it is UDC driver's responsibility to figure out maximum speed
> it can use.

Correct.

> > - the speed the UDC is connected at the moment i.e. FS. (gadget->speed)
> 
> OK, I see my mistake.  I misinterpreted gadget->speed as the max speed
> gadget supports.
> 
> So in the end, it would seem to me that we need to do the following is
> usb_gadget_probe_direvr() before passing the usb_gadget_driver to the
> usb_gadegt's bind:
> 
> if (driver->speed == USB_SPEED_SUPER && !gadget_is_superspeed(udc->gadget))
> 	driver->speed = USB_SPEED_HIGH;
> if (driver->speed == USB_SPEED_HIGH && !gadget_is_dualspeed(udc->gadget))
> 	driver->speed = USB_SPEED_FULL;

No, the usb_gadget_driver structure is read-only to the UDC driver
(except for the .driver field).  .speed is the maximum speed supported
by the gadget driver -- it doesn't change at runtime.  If the driver
was written to support speeds up to high speed, then those are the
speeds it supports, regardless of the UDC's capabilities.

Maybe if would help if the .speed field in struct usb_gadget_driver was
renamed to max_speed.

> (Although I'm not sure about USB_SPEED_FULL vs. USB_SPEED_LOW.)
> 
> Either than, or make sure that all UDC drivers handle correctly gadgets
> that declare speed as highest of what the UDC can handle.

I don't quite understand that sentence.  However, it is definitely true 
that all UDC drivers _must_ avoid connecting at speeds that are faster 
than the usb_gadget_driver's .speed field.

> At the moment however, gadget_is_superspeed() is implemented using #ifdefs
> (which I missed before) so we need to add a is_superspeed to usb_gadget
> structure.  Or maybe better yet get rid of is_dualspeed and add max_speed?

Either one would be okay.  max_speed is simpler, although it would 
require some work to change the existing usages of is_dualspeed.

Alan Stern

