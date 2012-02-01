Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab2BAACl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 19:02:41 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61468 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2BAACk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 19:02:40 -0500
Date: Tue, 31 Jan 2012 17:02:32 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        shawn.guo@linaro.org, b-cousson@ti.com,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 1/2] irq: add irq_domain support to generic-chip
Message-ID: <20120201000232.GK22611@ponder.secretlab.ca>
References: <1327944699-29882-1-git-send-email-robherring2@gmail.com>
 <1327944699-29882-2-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327944699-29882-2-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 11:31:38AM -0600, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Add irq domain support to irq generic-chip. This enables users of
> generic-chip to support dynamic irq assignment needed for DT interrupt
> binding.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
> @@ -39,7 +40,7 @@ void irq_gc_noop(struct irq_data *d)
>  void irq_gc_mask_disable_reg(struct irq_data *d)
>  {
>  	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> -	u32 mask = 1 << (d->irq - gc->irq_base);
> +	u32 mask = 1 << d->hwirq;

As discussed on IRC, there needs to be a 1:N relationship between
an irq_domain and generic chips, but doing that means that hwirq no
longer directly maps to the bit in the register.

This could be solved however if a mod is applied to the hwirq number
and if we're careful to line up hwirqs to those mod boundaries:

u32 mask = 1 << (d->hwirq % gc->bank_size);

>  	}
>  	gc->irq_cnt = i - gc->irq_base;
>  }
>  EXPORT_SYMBOL_GPL(irq_setup_generic_chip);
>  
> +#ifdef CONFIG_IRQ_DOMAIN
> +static int irq_gc_irq_domain_match(struct irq_domain *d, struct device_node *np)
> +{
> +	struct irq_chip_generic *gc;
> +
> +	if (d->of_node != NULL && d->of_node == np) {
> +		list_for_each_entry(gc, &gc_list, list) {
> +			if ((gc == d->host_data) && (d == gc->domain))
> +				return 1;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static int irq_gc_irq_domain_map(struct irq_domain *d, unsigned int irq,
> +				 irq_hw_number_t hw)
> +{
> +	struct irq_chip_generic *gc = d->host_data;
> +	struct irq_chip_type *ct = gc->chip_types;
> +
> +	if (gc->flags & IRQ_GC_INIT_NESTED_LOCK)
> +		irq_set_lockdep_class(irq, &irq_nested_lock_class);
> +
> +	irq_set_chip_and_handler(irq, &ct->chip, ct->handler);
> +	irq_set_chip_data(irq, gc);
> +	irq_modify_status(irq, gc->irq_clr, gc->irq_set);
> +
> +	return 0;
> +}
> +
> +static struct irq_domain_ops irq_gc_irq_domain_ops = {
> +	.match = irq_gc_irq_domain_match,
> +	.map = irq_gc_irq_domain_map,
> +	.xlate = irq_domain_xlate_onetwocell,
> +};
> +
> +/*
> + * irq_setup_generic_chip_domain - Setup a range of interrupts with a generic chip and domain
> + * @gc:		Generic irq chip holding all data
> + * @node:	Device tree node pointer for domain
> + * @msk:	Bitmask holding the irqs to initialize relative to gc->irq_base
> + * @flags:	Flags for initialization
> + * @clr:	IRQ_* bits to clear
> + * @set:	IRQ_* bits to set
> + *
> + * Set up max. 32 interrupts starting from gc->irq_base using an irq domain.
> + * Note, this initializes all interrupts to the primary irq_chip_type and its
> + * associated handler.
> + */
> +void irq_setup_generic_chip_domain(struct irq_chip_generic *gc,
> +			    struct device_node *node, u32 msk,
> +			    enum irq_gc_flags flags, unsigned int clr,
> +			    unsigned int set)
> +{
> +	struct irq_chip_type *ct = gc->chip_types;
> +
> +	if (!node) {
> +		irq_setup_generic_chip(gc, msk, flags, clr, set);
> +		return;
> +	}

Calling irq_setup_generic_chip() should always be performed,
regardless of whether or not a node is passed in.  However, the msk
field should be passed as 0 so that none of the irqs get configured
before they are allocated.  I'd like to see all the domain code paths
look the same, regardless of whether a node pointer is provided.

The only quirk here is that if a node isn't provided, then that
probably means the range of irqs needs to be fixed; which means using
the legacy map in the current implementation.  We should sit down and
talk about this next week at Connect.

g.
