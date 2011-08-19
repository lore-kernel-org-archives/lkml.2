Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab1HSOiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:38:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55655 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab1HSOio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:38:44 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Sergei Shtylyov" <sshtylyov@mvista.com>,
        "Felipe Balbi" <balbi@ti.com>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "USB list" <linux-usb@vger.kernel.org>,
        "Kernel development list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] usb: gadget: get rid of USB_GADGET_DUALSPEED and
 USB_GADGET_SUPERSPEED
References: <Pine.LNX.4.44L0.1108191009410.2016-100000@iolanthe.rowland.org>
Date: Fri, 19 Aug 2011 16:38:41 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v0gtmri13l0zgt@mnazarewicz-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1108191009410.2016-100000@iolanthe.rowland.org>
User-Agent: Opera Mail/11.50 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 19 Aug 2011, Michal Nazarewicz wrote:
>> OK, I see my mistake.  I misinterpreted gadget->speed as the max speed
>> gadget supports.
>>
>> So in the end, it would seem to me that we need to do the following is
>> usb_gadget_probe_direvr() before passing the usb_gadget_driver to the
>> usb_gadegt's bind:
>>
>> if (driver->speed == USB_SPEED_SUPER &&  
>> !gadget_is_superspeed(udc->gadget))
>> 	driver->speed = USB_SPEED_HIGH;
>> if (driver->speed == USB_SPEED_HIGH &&  
>> !gadget_is_dualspeed(udc->gadget))
>> 	driver->speed = USB_SPEED_FULL;

On Fri, 19 Aug 2011 16:29:15 +0200, Alan Stern <stern@rowland.harvard.edu>  
wrote:
> No, the usb_gadget_driver structure is read-only to the UDC driver
> (except for the .driver field).  .speed is the maximum speed supported
> by the gadget driver -- it doesn't change at runtime.  If the driver
> was written to support speeds up to high speed, then those are the
> speeds it supports, regardless of the UDC's capabilities.

OK.

> Maybe if would help if the .speed field in struct usb_gadget_driver was
> renamed to max_speed.

I'll take a look at how much work that would require.

>> (Although I'm not sure about USB_SPEED_FULL vs. USB_SPEED_LOW.)
>>
>> Either than, or make sure that all UDC drivers handle correctly gadgets
>> that declare speed as highest of what the UDC can handle.

> I don't quite understand that sentence.  However, it is definitely true
> that all UDC drivers _must_ avoid connecting at speeds that are faster
> than the usb_gadget_driver's .speed field.

Yang has brought up an issue that musb_gadget_start() checks if  
driver->speed
equals USB_SPEED_HIGH.  This means that if a gadget driver supports super  
speed
it'll set driver->speed to USB_SPEED_SUPER and musb_gadget_start() will  
complain.

My understanding is that this is a bug in musb driver as it should allow  
the
gadget driver to start but never set super speed.

>> At the moment however, gadget_is_superspeed() is implemented using  
>> #ifdefs (which I missed before) so we need to add a is_superspeed
>> to usb_gadget structure.  Or maybe better yet get rid of
>> is_dualspeed and add max_speed?

> Either one would be okay.  max_speed is simpler, although it would
> require some work to change the existing usages of is_dualspeed.

I'm on it already. ;)

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
