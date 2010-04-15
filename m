Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab0DOHfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:35:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41539 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345Ab0DOHfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:35:45 -0400
Subject: Re: [tip:irq/core] genirq: Run irq handlers with interrupts
 disabled
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org,
       alan@lxorguk.ukuu.org.uk, davem@davemloft.net, torvalds@osdl.org,
       gregkh@suse.de, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-e58aa3d2d0cc01ad8d6f7f640a0670433f794922@git.kernel.org>
References: <20100326000405.758579387@linutronix.de>
	 <tip-e58aa3d2d0cc01ad8d6f7f640a0670433f794922@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Apr 2010 09:35:40 +0200
Message-ID: <1271316940.32749.61.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 19:33 +0000, tip-bot for Ingo Molnar wrote:
> Commit-ID:  e58aa3d2d0cc01ad8d6f7f640a0670433f794922
> Gitweb:     http://git.kernel.org/tip/e58aa3d2d0cc01ad8d6f7f640a0670433f794922
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Fri, 26 Mar 2010 00:06:51 +0000
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Tue, 13 Apr 2010 16:36:40 +0200
> 
> genirq: Run irq handlers with interrupts disabled
> 
> Running interrupt handlers with interrupts enabled can cause stack
> overflows. That has been observed with multiqueue NICs delivering all
> their interrupts to a single core. We might band aid that somehow by
> checking the interrupt stacks, but the real safe fix is to run the irq
> handlers with interrupts disabled.
> 
> Drivers for whacky hardware still can reenable them in the handler
> itself, if the need arises. (They do already due to lockdep)
> 
> The risk of doing this is rather low:
> 
>  - lockdep already enforces this
>  - CONFIG_NOHZ has shaken out the drivers which relied on jiffies updates
>  - time keeping is not longer sensitive to the timer interrupt being delayed

Clearly I don't mind this, but shouldn't we at least first convert the
known problematic drivers to an alternative strategy?

IDE-PIO, that one ancient NIC etc..

> ---
>  kernel/irq/handle.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index 76d5a67..27e5c69 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -370,9 +370,6 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
>  	irqreturn_t ret, retval = IRQ_NONE;
>  	unsigned int status = 0;
>  
> -	if (!(action->flags & IRQF_DISABLED))
> -		local_irq_enable_in_hardirq();
> -
>  	do {
>  		trace_irq_handler_entry(irq, action);
>  		ret = action->handler(irq, action->dev_id);



