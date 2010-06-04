Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab0FDVrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 17:47:15 -0400
Received: from www.tglx.de ([62.245.132.106]:37990 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab0FDVrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 17:47:14 -0400
Date: Fri, 4 Jun 2010 23:46:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Esben Haabendal <eha@doredevelopment.dk>
cc: linux-kernel@vger.kernel.org, maz@misterjones.org, mingo@elte.hu,
       joachim.eastwood@jotron.com
Subject: Re: [RFC][PATCH] irq: support IRQ_NESTED_THREAD with non-threaded
 interrupt handlers
In-Reply-To: <1275686352.2970.2.camel@eha.doredevelopment.dk>
Message-ID: <alpine.LFD.2.00.1006042343150.2933@localhost.localdomain>
References: <1275686352.2970.2.camel@eha.doredevelopment.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010, Esben Haabendal wrote:

> set_irq_nested_thread() might be called by interrupt controller to
> supported nested irq thread handling, and with this change, drivers
> with non-threaded irq handlers can still use the irqs.

What's the problem you are trying to solve ? The above changelog is
not very useful ?

Thanks,

	tglx
 
> Signed-off-by: Esben Haabendal <eha@doredevelopment.dk>
> ---
>  kernel/irq/chip.c   |    9 ++++++++-
>  kernel/irq/manage.c |    4 +---
>  2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index b7091d5..8202993 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -405,7 +405,14 @@ void handle_nested_irq(unsigned int irq)
>  	desc->status |= IRQ_INPROGRESS;
>  	raw_spin_unlock_irq(&desc->lock);
>  
> -	action_ret = action->thread_fn(action->irq, action->dev_id);
> +	if (desc->status & IRQ_NESTED_THREAD && action->thread_fn)
> +		action_ret = action->thread_fn(action->irq, action->dev_id);
> +	else {
> +		local_irq_disable();
> +		action_ret = action->handler(action->irq, action->dev_id);
> +		local_irq_enable();
> +	}
> +
>  	if (!noirqdebug)
>  		note_interrupt(irq, desc, action_ret);
>  
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 3164ba7..e7bca04 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -681,10 +681,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  	 * Check whether the interrupt nests into another interrupt
>  	 * thread.
>  	 */
> -	nested = desc->status & IRQ_NESTED_THREAD;
> +	nested = (desc->status & IRQ_NESTED_THREAD) && new->thread_fn;
>  	if (nested) {
> -		if (!new->thread_fn)
> -			return -EINVAL;
>  		/*
>  		 * Replace the primary handler which was provided from
>  		 * the driver for non nested interrupt handling by the
> -- 
> 1.7.1
> 
> 
> 
