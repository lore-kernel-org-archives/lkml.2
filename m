Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab1HSLNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:13:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:49564 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab1HSLNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:13:49 -0400
Message-ID: <4E4E4565.70902@linutronix.de>
Date: Fri, 19 Aug 2011 13:13:41 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Sergei Shtylyov <sshtylyov@mvista.com>, Felipe Balbi <balbi@ti.com>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] usb: gadget: get rid of USB_GADGET_DUALSPEED and USB_GADGET_SUPERSPEED
References: <Pine.LNX.4.44L0.1108181623390.1628-100000@iolanthe.rowland.org> <op.v0gi7koy3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <op.v0gi7koy3l0zgt@mnazarewicz-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Nazarewicz wrote:
> On Thu, 18 Aug 2011 22:30:14 +0200, Alan Stern 
> <stern@rowland.harvard.edu> wrote:
>> Okay, that line was probably all right, but it seems that something
>> else needs to be changed.  In a composite gadget, if none of the
>> function drivers support SuperSpeed then we don't want
>> composite_driver.speed to be set to USB_SPEED_SUPER.  It would be
>> foolish to allow the UDC to connect at a speed which would make the
>> gadget useless.
> 
> OK, so it seems I was misunderstanding your comment all along, but
> that was nothing a good night sleep couldn't fix. :P
> 
> So, what you are saying is that when passed to the UDC driver (ie.
> by calling usb_gadget_probe_driver()) the usb_gadget_driver structure
> must have speed no higher then what the UDC supports, right?  And in
> that case, it's not composite specific but affects all the gadgets.
> 
> In that case, I think that usb_gadget_probe_driver() itself needs to be
> changed since prior to this function we don't know which gadget the
> gadget driver will be bound to.  Ie. something as follows could be added
> somewhere there:
> 
>   driver->speed = min(driver->speed, udc->gadget->speed)
> 
> Does that sound like it makes sense?
> 
> At this point though, gadget drivers need to be aware that
> usb_gadget_probe_driver() may change the speed field.  It should not
> be a problem since, as far as I can tell, all gadgets expect for g_ffs
> call usb_gadget_probe_driver() only once and in case of g_ffs this can
> be solved at composite level.

There are three speeds:
- the max speed the UDC supports i.e. HS (no field for that?)
- the max speed the gadget / function driver support i.e. SS
   (driver->max_speed ?)
- the speed the UDC is connected at the moment i.e. FS. (gadget->speed)

So in this case you have to go down and use FS descriptors. The FS speed
is represented by gadget->speed right? So for now we do FS. On the next
re-plug the user places OHCI controller with XHCI so you can use HS
descriptors now. So changing dirver->speed wouldn't allow you go beyond FS
once you to FS right?

Sebastian
