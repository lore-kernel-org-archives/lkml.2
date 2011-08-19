Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab1HSMOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:14:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58805 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab1HSMOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:14:33 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
        "Sergei Shtylyov" <sshtylyov@mvista.com>,
        "Felipe Balbi" <balbi@ti.com>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] usb: gadget: get rid of USB_GADGET_DUALSPEED and
 USB_GADGET_SUPERSPEED
References: <Pine.LNX.4.44L0.1108181623390.1628-100000@iolanthe.rowland.org>
 <op.v0gi7koy3l0zgt@mnazarewicz-glaptop> <4E4E4565.70902@linutronix.de>
Date: Fri, 19 Aug 2011 14:14:29 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v0gmyfhi3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <4E4E4565.70902@linutronix.de>
User-Agent: Opera Mail/11.50 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Aug 2011 13:13:41 +0200, Sebastian Andrzej Siewior  
<bigeasy@linutronix.de> wrote:
> There are three speeds:
> - the max speed the UDC supports i.e. HS (no field for that?)

Yep, the field seems to be missing for that one.  We have is_dualspeed and
comment in gadget_is_superspeed() says about is_superspeed but that does
not exist.

> - the max speed the gadget / function driver support i.e. SS
>    (driver->max_speed ?)

Actually “max_speed” is only in usb_composite_driver structure.
usb_gadget_driver has only “speed” and it's description says that it is
the “highest speed the driver handles.”  Because of that description I've
assumed that it is UDC driver's responsibility to figure out maximum speed
it can use.

> - the speed the UDC is connected at the moment i.e. FS. (gadget->speed)

OK, I see my mistake.  I misinterpreted gadget->speed as the max speed
gadget supports.

So in the end, it would seem to me that we need to do the following is
usb_gadget_probe_direvr() before passing the usb_gadget_driver to the
usb_gadegt's bind:

if (driver->speed == USB_SPEED_SUPER && !gadget_is_superspeed(udc->gadget))
	driver->speed = USB_SPEED_HIGH;
if (driver->speed == USB_SPEED_HIGH && !gadget_is_dualspeed(udc->gadget))
	driver->speed = USB_SPEED_FULL;

(Although I'm not sure about USB_SPEED_FULL vs. USB_SPEED_LOW.)

Either than, or make sure that all UDC drivers handle correctly gadgets
that declare speed as highest of what the UDC can handle.


At the moment however, gadget_is_superspeed() is implemented using #ifdefs
(which I missed before) so we need to add a is_superspeed to usb_gadget
structure.  Or maybe better yet get rid of is_dualspeed and add max_speed?


Does what I'm writing make sense at all?

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
