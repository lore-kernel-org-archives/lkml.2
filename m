Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1HSKxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 06:53:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63323 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab1HSKxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 06:53:36 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Sergei Shtylyov" <sshtylyov@mvista.com>, "Felipe Balbi" <balbi@ti.com>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] usb: gadget: get rid of USB_GADGET_DUALSPEED and
 USB_GADGET_SUPERSPEED
References: <Pine.LNX.4.44L0.1108181623390.1628-100000@iolanthe.rowland.org>
Date: Fri, 19 Aug 2011 12:53:34 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v0gi7koy3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1108181623390.1628-100000@iolanthe.rowland.org>
User-Agent: Opera Mail/11.50 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011 22:30:14 +0200, Alan Stern <stern@rowland.harvard.edu>  
wrote:
> Okay, that line was probably all right, but it seems that something
> else needs to be changed.  In a composite gadget, if none of the
> function drivers support SuperSpeed then we don't want
> composite_driver.speed to be set to USB_SPEED_SUPER.  It would be
> foolish to allow the UDC to connect at a speed which would make the
> gadget useless.

OK, so it seems I was misunderstanding your comment all along, but
that was nothing a good night sleep couldn't fix. :P

So, what you are saying is that when passed to the UDC driver (ie.
by calling usb_gadget_probe_driver()) the usb_gadget_driver structure
must have speed no higher then what the UDC supports, right?  And in
that case, it's not composite specific but affects all the gadgets.

In that case, I think that usb_gadget_probe_driver() itself needs to be
changed since prior to this function we don't know which gadget the
gadget driver will be bound to.  Ie. something as follows could be added
somewhere there:

   driver->speed = min(driver->speed, udc->gadget->speed)

Does that sound like it makes sense?

At this point though, gadget drivers need to be aware that
usb_gadget_probe_driver() may change the speed field.  It should not
be a problem since, as far as I can tell, all gadgets expect for g_ffs
call usb_gadget_probe_driver() only once and in case of g_ffs this can
be solved at composite level.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
