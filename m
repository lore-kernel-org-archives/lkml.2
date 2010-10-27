Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065Ab0J0ICE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 04:02:04 -0400
Received: from www.tglx.de ([62.245.132.106]:33220 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195Ab0J0ICB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 04:02:01 -0400
Date: Wed, 27 Oct 2010 10:01:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm-owner@vger.kernel.org
Subject: Re: [RFC IRQ] genirq: fix handle_nested_irq for lazy disable
In-Reply-To: <1288144209-28086-1-git-send-email-adharmap@codeaurora.org>
Message-ID: <alpine.LFD.2.00.1010270909590.3100@localhost6.localdomain6>
References: <1288144209-28086-1-git-send-email-adharmap@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, adharmap@codeaurora.org wrote:

> From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
> 
> When lazy disabling is implemented and an interrupt is disabled the
> genirq code ends up marking it as IRQ_DISABLED in the descriptor.
> The interrupt stays enabled in the controller.  If the interrupt
> fires after disabling, the flow handlers namely handle_level_irq and
> handle_edge_irq mask the interrupt in the controller.
> 
> This is not the case with handle_nested_irq. The interrupt stays enabled in
> the controller and if it were a level interrupt it keeps firing only to be
> ignored by handle_nested_irq.
> 
> Update handle_nested_irq to mask such an interrupt.
> 
> Change-Id: Id0fa3280c49a36aa8b8db1d5cc20472bf5e53c5f
> Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
> ---
>  This problem shows up on my hardware because the interrupt controller is
>  over a slow bus and it doesnt deactivate the interrupt line to the processor
>  until an ack or mask operation is carried out for each of its active
>  interrupts.
> 
>  I could have updated the interrupt controller thread itself to check if the
>  interrupt is marked IRQ_DISABLED but didn't seem right to take the
>  desc->lock in there. Instead updating handle_nested_irq to handle this
>  seemed like the right thing to do.
> 
>  kernel/irq/chip.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index baa5c4a..35ccc41 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -419,6 +419,7 @@ void handle_nested_irq(unsigned int irq)
>  {
>  	struct irq_desc *desc = irq_to_desc(irq);
>  	struct irqaction *action;
> +	int mask_this_irq = 0;
>  	irqreturn_t action_ret;
>  
>  	might_sleep();
> @@ -428,8 +429,10 @@ void handle_nested_irq(unsigned int irq)
>  	kstat_incr_irqs_this_cpu(irq, desc);
>  
>  	action = desc->action;
> -	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
> +	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
> +		mask_this_irq = 1;
>  		goto out_unlock;
> +	}
>  
>  	desc->status |= IRQ_INPROGRESS;
>  	raw_spin_unlock_irq(&desc->lock);e
> @@ -443,6 +446,11 @@ void handle_nested_irq(unsigned int irq)
>  
>  out_unlock:
>  	raw_spin_unlock_irq(&desc->lock);
> +	if (unlikely(mask_this_irq)) {
> +		chip_bus_lock(irq, desc);
> +		desc->chip->mask(irq);

That does not work with current mainline due to the irq_chip changes,
can you please respin against linus latest?

Also there is no requirement for irq_chip instances to implement the
mask function, so this might crash the kernel for innocent users of
that infrastructure. mask_irq() is your friend.

Aside of that this wont work for edge triggered interrupts, as you'd
loose the edge, so this needs more thought and a thorough look at the
users of handle_nested_irq().

One possible solution would be to change handle_nested_irq() to return
int. So we could return 0 for the normal case and some sensible error
code when the irq is disabled, so the caller can deal with it. Either
that or we need a separate nested function for level irqs which then
can implement the mask logic.

Thanks,

	tglx
