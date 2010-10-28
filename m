Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab0J1SzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:55:25 -0400
Received: from www.tglx.de ([62.245.132.106]:52456 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758731Ab0J1SzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:55:19 -0400
Date: Thu, 28 Oct 2010 20:54:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rabin Vincent <rabin@rab.in>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: handle shared irqs in handle_nested_irq()
In-Reply-To: <1288288718-1188-1-git-send-email-rabin@rab.in>
Message-ID: <alpine.LFD.2.00.1010282053180.2692@localhost6.localdomain6>
References: <1288288718-1188-1-git-send-email-rabin@rab.in>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Oct 2010, Rabin Vincent wrote:

> Allow shared irqs to work when nested threads are used for handling
> threaded interrupts.

Why do we want this ? handle_nested_irq() is called from a interrupt
demultiplexer, so why would we need shared interrupts for this ?

Thanks,

	tglx
 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  kernel/irq/chip.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index baa5c4a..94a45a9 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -418,8 +418,8 @@ static inline void unmask_irq(struct irq_desc *desc)
>  void handle_nested_irq(unsigned int irq)
>  {
>  	struct irq_desc *desc = irq_to_desc(irq);
> +	irqreturn_t action_ret = IRQ_NONE;
>  	struct irqaction *action;
> -	irqreturn_t action_ret;
>  
>  	might_sleep();
>  
> @@ -434,7 +434,10 @@ void handle_nested_irq(unsigned int irq)
>  	desc->status |= IRQ_INPROGRESS;
>  	raw_spin_unlock_irq(&desc->lock);
>  
> -	action_ret = action->thread_fn(action->irq, action->dev_id);
> +	do {
> +		action_ret |= action->thread_fn(action->irq, action->dev_id);
> +		action = action->next;
> +	} while (action);
>  	if (!noirqdebug)
>  		note_interrupt(irq, desc, action_ret);
>  
> -- 
> 1.7.2.3
> 
