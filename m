Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab2JLMbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 08:31:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:54888 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab2JLMbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 08:31:50 -0400
Date: Fri, 12 Oct 2012 14:31:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chuansheng Liu <chuansheng.liu@intel.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with
 irq thread
In-Reply-To: <1350045084.13178.19.camel@cliu38-desktop-build>
Message-ID: <alpine.LFD.2.02.1210121427490.2779@ionos>
References: <1350045084.13178.19.camel@cliu38-desktop-build>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012, Chuansheng Liu wrote:
> 
> In our system, there is one edge interrupt, and we want it to be
> irq thread with IRQS_ONESHOT, and found in handle_edge_irq(),
> even with IRQS_ONESHOT, the irq is still unmasked without care of
> flag IRQS_ONESHOT.
> 
> It causes IRQS_ONESHOT can not work well for edge interrupt, but also
> after the irq thread finished with flag IRQS_ONESHOT, the irq will be
> possible to be unmasked again, it should be messing mask/unmask logic.

This is just wrong. By masking edge interrupts you will run into
situations where you will lose interrupts.

Can you please explain, why you want to mask your edge interrupt?

Thanks,

	tglx

 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  kernel/irq/chip.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index 57d86d0..f23f524 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -497,7 +497,13 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
>  	kstat_incr_irqs_this_cpu(irq, desc);
>  
>  	/* Start handling the irq */
> -	desc->irq_data.chip->irq_ack(&desc->irq_data);
> +	if (desc->istate & IRQS_ONESHOT) {
> +		mask_ack_irq(desc);
> +		handle_irq_event(desc);
> +		cond_unmask_irq(desc);
> +		goto out_unlock;
> +	} else
> +		desc->irq_data.chip->irq_ack(&desc->irq_data);
>  
>  	do {
>  		if (unlikely(!desc->action)) {
> -- 
> 1.7.0.4
> 
> 
> 
> 
