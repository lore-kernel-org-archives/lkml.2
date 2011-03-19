Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab1CSUv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 16:51:26 -0400
Received: from www.tglx.de ([62.245.132.106]:46253 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757469Ab1CSUvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 16:51:24 -0400
Date: Sat, 19 Mar 2011 21:51:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Daney <ddaney@caviumnetworks.com>
cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] genirq: Add chip hooks for taking CPUs on/off
 line.
In-Reply-To: <1300484916-11133-2-git-send-email-ddaney@caviumnetworks.com>
Message-ID: <alpine.LFD.2.00.1103192050400.2787@localhost6.localdomain6>
References: <1300484916-11133-1-git-send-email-ddaney@caviumnetworks.com> <1300484916-11133-2-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011, David Daney wrote:
> --- a/include/linux/irqdesc.h
> +++ b/include/linux/irqdesc.h
> @@ -178,6 +178,12 @@ static inline int irq_has_action(unsigned int irq)
>  	return desc->action != NULL;
>  }
>  
> +/* Test to see if the irq is currently enabled */
> +static inline int irq_desc_is_enabled(struct irq_desc *desc)
> +{
> +	return desc->depth == 0;
> +}

That want's to go into kernel/irq/internal.h

>  #ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
>  static inline int irq_balancing_disabled(unsigned int irq)
>  {
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index c9c0601..40736f7 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -689,3 +689,38 @@ void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set)
>  
>  	irq_put_desc_unlock(desc, flags);
>  }
> +
> +void irq_cpu_online(unsigned int irq)

Odd function name. It does not reflect that this is for per cpu
interrupts. So something like irq_xxx_per_cpu_irq(irq)
might be a bit more descriptive.

> +{

So that's called on the cpu which goes online, right?

I wonder whether we can add any sanity check to verify this.

Though I would not worry too much about it. Calling that from a cpu
which is not going offline should have enough nasty side effects that
it's noticed during development. :)

> +	unsigned long flags;
> +	struct irq_chip *chip;
> +	struct irq_desc *desc = irq_to_desc(irq);

Needs to check !desc

> +	raw_spin_lock_irqsave(&desc->lock, flags);
> +
> +	chip = irq_data_get_irq_chip(&desc->irq_data);
> +
> +	if (chip && chip->irq_cpu_online)
> +		chip->irq_cpu_online(&desc->irq_data,
> +				     irq_desc_is_enabled(desc));
> +
> +	raw_spin_unlock_irqrestore(&desc->lock, flags);
> +}
> +
> +void irq_cpu_offline(unsigned int irq)
> +{
> +	unsigned long flags;
> +	struct irq_chip *chip;
> +	struct irq_desc *desc = irq_to_desc(irq);

See above. 

Style nit: I prefer ordering:

+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_chip *chip;
+	unsigned long flags;

For some reason, probably because I'm used to it, that's easier to
parse. But don't worry about that, I'll turn it around before sticking
it into git. :)

Otherwise I'm fine with the approach itself. 

Though one question remains: should we just iterate over the irq space
and call the online/offline callbacks when available instead of having
the arch code do the iteration.

Thanks,

	tglx
