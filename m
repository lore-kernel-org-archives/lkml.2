Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2GIIcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 04:32:41 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:64544 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab2GIIci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 04:32:38 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18XBZS3mTAEdz+H1Mp1Zc4l
Date: Mon, 9 Jul 2012 01:32:33 -0700
From: Tony Lindgren <tony@atomide.com>
To: NeilBrown <neilb@suse.de>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Infinite looping in omap2430.c USB driver
Message-ID: <20120709083233.GY1122@atomide.com>
References: <20120707083949.2cf91eeb@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120707083949.2cf91eeb@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* NeilBrown <neilb@suse.de> [120706 15:44]:
> 
> Hello `./scripts/get_maintainer.pl -f drivers/usb/musb/omap2430.c`
> 
> omap2430_musb_set_vbus in omap2430.c contains:
> 
> 			while (musb_readb(musb->mregs, MUSB_DEVCTL) & 0x80) {
> 
> 				cpu_relax();
> 
> 				if (time_after(jiffies, timeout)) {
> 					dev_err(musb->controller,
> 					"configured as A device timeout");
> 					ret = -EINVAL;
> 					break;
> 				}
> 			}
> 
> having set
> 	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
> 
> so it can busy-loop for up to 1 second.  Probably not ideal, but if it works
> I wouldn't complain.
> 
> The
> 	if (int_usb & MUSB_INTR_SESSREQ) {
> branch of musb_stage0_irq() called from musb_interrupt (from
> generic_interrupt) calls this:
> 
> 	if (musb->int_usb)
> 		retval |= musb_stage0_irq(musb, musb->int_usb,
> 				devctl, power);
> 
> so the busy loop can happen in an interrupt handler (not a threaded interrupt
> handler), which is probably less ideal.
> 
> However this can be called with interrupt disabled, as happens at least
> during resume when resume_irqs() calls:
> 
> 		raw_spin_lock_irqsave(&desc->lock, flags);
> 		__enable_irq(desc, irq, true);
> 		raw_spin_unlock_irqrestore(&desc->lock, flags);
> 
> and an interrupt is found to be IRQS_PENDING.
> 
> In this case interrupts are disabled so 'jiffies' never changes so this loop
> can continue forever.
> 
> This happens on my (GTA04) phone fairly regularly - between 1 in 10 and 1 in
> 30 resumes. The musb-hdrc interrupt is pending and reports
> 
> [ 4957.624176] musb-hdrc musb-hdrc: ** IRQ peripheral usb0040 tx0000 rx0000
> 
> 'usb0040' is MUSB_INTR_SESSREQ.  I think this is triggered by detecting a
> voltage change on the USB ID pin - is that right?  A short-to-earth would be
> a request to switch to host mode, which is why it tries to enable VBUS.
> Maybe there is some electrical noise which is being picked up?

I guess that could happen if the transceiver pins are floating during suspend?
 
> In any case I get the interrupt despite nothing being plugged in, and the 0x80
> bit of MUSB_DEVCTL never gets cleared.

As far as I remember, musb tries to be smart about changing to host mode,
and tries to do the session and vbus detection on it's own.. AFAIK, there's
nothing you can do until musb is done and detects the VBUS is not rising and
gives up. There are all kind of interrupt flag combinations trying to deal
with that mess, maybe you need to add yet another one?
 
> I've added a simple loop counter which aborts the loop after 1000 loops -
> this takes about 5 seconds, but includes some printks which probably slow it
> down.
> 
> In 2 out of 2 cases, subsequent messages show that the hsmmc driver for the
> uSD card that holds my root filesystem is messed up.  It seems to be waiting
> for a request that is never going to complete.
> So maybe the hsmmc is causing the noise that triggers the musb issue.
> 
> I can send a patch which add a loop count if you like, but I suspect you can
> come up with a much better approach.

Sounds like that loop should be fixed.

Regards,

Tony
