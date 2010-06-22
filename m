Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869Ab0FVO0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 10:26:54 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:42134 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756212Ab0FVO0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 10:26:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACNkIEzCTtAn/2dsb2JhbACfF3HBMIUbBA
Date: Tue, 22 Jun 2010 16:26:49 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] firewire: core: no need to track irq flags in
	bm_work
Message-ID: <20100622142649.GA18061@frolo.macqel>
References: <tkrat.96072b90a5c06bb3@s5r6.in-berlin.de> <20100622093618.GC26304@frolo.macqel> <4C20A1DE.2040503@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C20A1DE.2040503@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephan,

On Tue, Jun 22, 2010 at 01:43:26PM +0200, Stefan Richter wrote:
> Philippe De Muyter wrote:
> > On Mon, Jun 21, 2010 at 11:23:52PM +0200, Stefan Richter wrote:
> >> This is a workqueue job and always entered with IRQs enabled.
> > 
> > did you mean 'disabled' ?
> 
> I meant enabled.
> 
> [...]
> >> @@ -247,10 +246,10 @@ static void fw_card_bm_work(struct work_
> >>  	bool root_device_is_cmc;
> >>  	bool irm_is_1394_1995_only;
> >>  
> >> -	spin_lock_irqsave(&card->lock, flags);
> >> +	spin_lock_irq(&card->lock);
> 
>   - spin_lock + spin_unlock don't influence whether IRQs on the current
>     CPU are on or off.
> 
>   - spin_lock_irq + spin_unlock_irq always switch IRQs on the current
>     CPU off and back on.  This is necessary if the lock could also be
>     taken by an IRQ handler.  (Well, card->lock is actually only taken
>     by process contexts and by tasklets.  Seems we could switch to
>     spin_lock_bh + spin_unlock_bh for card->lock everywhere in the
>     firewire stack.)
> 
>   - spin_lock_irqsave + spin_unlock_irqrestore switch IRQs on the
>     current CPU off and back on only if used while IRQs are enabled;
>     if used while local IRQs are already disabled they leave them
>     disabled.
> 
> http://lwn.net/images/pdf/LDD3/ch05.pdf#page=14
> 
> Therefore some people prefer to use the safer spin_lock_irqsave()/
> spin_unlock_irqrestore() everywhere.  However, their downsides are the
> need to track IRQ state flags, and --- subjectively --- that their
> appearance in the code could create an impression to a casual reader
> that this code was meant to be able to run in IRQs-on context as well as
> in IRQs-off context.  fw_card_bm_work() however definitely requires to
> be called with IRQs on, notably to be able to wait for IEEE 1394
> transactions to complete.

Thanks for the clear explanation, and sorry for your wasted time.

Philippe
