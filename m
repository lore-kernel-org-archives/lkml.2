Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab2AYBuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 20:50:40 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62806 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab2AYBuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 20:50:37 -0500
Message-ID: <4F1F5FE0.9090901@gmail.com>
Date: Tue, 24 Jan 2012 19:50:24 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC 1/2] irq_domain: Create common xlate functions that device
 drivers can use
References: <1327450719-25590-1-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1327450719-25590-1-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/24/2012 06:18 PM, Grant Likely wrote:
> Rather than having each interrupt controller driver creating its own barely
> unique .xlate function for irq_domain, create a library of translators which
> any driver can use directly.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> This builds on top of my irq_domain series and will be included with it when
> I post v3.  Rob, does this serve your needs for generic irq controller DT
> support?
> 

Yes, but comments below.

> g.
> 
>  include/linux/irqdomain.h |   15 ++++++++++
>  kernel/irq/irqdomain.c    |   69 +++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 76 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index e7379a3..5e497a0 100644
> --- a/include/linux/irqdomain.h
> +++ b/include/linux/irqdomain.h
> @@ -110,6 +110,9 @@ struct irq_domain {
>  	void *host_data;
>  	irq_hw_number_t inval_irq;
>  
> +	/* Data for common irq xlate functions */
> +	unsigned int xlate_type;
> +

How does this get set? Do we want interrupt controllers messing with the
domain struct directly long term?

>  	/* Optional device node pointer */
>  	struct device_node *of_node;
>  };
> @@ -163,6 +166,18 @@ extern unsigned int irq_linear_revmap(struct irq_domain *host,
>  				      irq_hw_number_t hwirq);
>  
>  extern struct irq_domain_ops irq_domain_simple_ops;
> +
> +/* stock xlate functions */
> +int irq_domain_xlate_onecell(struct irq_domain *d, struct device_node *ctrlr,
> +			const u32 *intspec, unsigned int intsize,
> +			irq_hw_number_t *out_hwirq, unsigned int *out_type);
> +int irq_domain_xlate_twocell(struct irq_domain *d, struct device_node *ctrlr,
> +			const u32 *intspec, unsigned int intsize,
> +			irq_hw_number_t *out_hwirq, unsigned int *out_type);
> +int irq_domain_xlate_onetwocell(struct irq_domain *d, struct device_node *ctrlr,
> +			const u32 *intspec, unsigned int intsize,
> +			irq_hw_number_t *out_hwirq, unsigned int *out_type);
> +
>  #if defined(CONFIG_OF_IRQ)
>  extern void irq_domain_generate_simple(const struct of_device_id *match,
>  					u64 phys_base, unsigned int irq_start);
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index def8e7b..df80205 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -53,6 +53,7 @@ static struct irq_domain *irq_domain_alloc(struct device_node *of_node,
>  	domain->ops = ops;
>  	domain->host_data = host_data;
>  	domain->of_node = of_node_get(of_node);
> +	domain->xlate_type = IRQ_TYPE_NONE;
>  
>  	if (domain->ops->match == NULL)
>  		domain->ops->match = default_irq_domain_match;
> @@ -690,25 +691,77 @@ int irq_domain_simple_map(struct irq_domain *d, unsigned int irq,
>  	return 0;
>  }
>  
> -int irq_domain_simple_xlate(struct irq_domain *d,
> -			    struct device_node *controller,
> -			    const u32 *intspec, unsigned int intsize,
> -			    unsigned long *out_hwirq, unsigned int *out_type)
> +/**
> + * irq_domain_xlate_onecell() - Generic xlate for direct one cell bindings
> + *
> + * Device Tree IRQ specifier translation function which works with one cell
> + * bindings where the cell value maps directly to the hwirq number.
> + */
> +int irq_domain_xlate_onecell(struct irq_domain *d, struct device_node *ctrlr,
> +			     const u32 *intspec, unsigned int intsize,
> +			     unsigned long *out_hwirq, unsigned int *out_type)
> +{
> +	if (WARN(intsize < 1, "Bad intspec for %s: intsize=%i < 1\n",
> +		 ctrlr->full_name, intsize))
> +		return -EINVAL;
> +	*out_hwirq = intspec[0];
> +	*out_type = d->xlate_type;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(irq_domain_xlate_onecell);
> +
> +/**
> + * irq_domain_xlate_twocell() - Generic xlate for direct two cell bindings
> + *
> + * Device Tree IRQ specifier translation function which works with two cell
> + * bindings where the cell values map directly to the hwirq number
> + * and linux irq flags.
> + */
> +int irq_domain_xlate_twocell(struct irq_domain *d, struct device_node *ctrlr,
> +			const u32 *intspec, unsigned int intsize,
> +			irq_hw_number_t *out_hwirq, unsigned int *out_type)
>  {
> -	if (d->of_node != controller)
> +	if (WARN(intsize < 2, "Bad intspec for %s: intsize=%i < 2\n",
> +		 ctrlr->full_name, intsize))
> +		return -EINVAL;
> +	if (intsize < 2)

You've already checked this...

>  		return -EINVAL;
> -	if (intsize < 1)
> +	*out_hwirq = intspec[0];
> +	*out_type = intspec[1] & IRQ_TYPE_SENSE_MASK;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(irq_domain_xlate_twocell);
> +
> +/**
> + * irq_domain_xlate_onetwocell() - Generic xlate for one or two cell bindings
> + *
> + * Device Tree IRQ specifier translation function which works with either one
> + * or two cell bindings where the cell values map directly to the hwirq number
> + * and linux irq flags.
> + *
> + * Note: don't use this function unless your interrupt controller explicitly
> + * supports both one and two cell bindings.  For the majority of controllers
> + * the _onecell() or _twocell() variants above should be used.

This comment is confusing since you turn around and use it for simple
ops below.

> + */
> +int irq_domain_xlate_onetwocell(struct irq_domain *d,
> +				struct device_node *ctrlr,
> +				const u32 *intspec, unsigned int intsize,
> +				unsigned long *out_hwirq, unsigned int *out_type)
> +{
> +	if (WARN(intsize < 1, "Bad intspec for %s: intsize=%i < 1\n",
> +		 ctrlr->full_name, intsize))
>  		return -EINVAL;

Isn't this check redundant with the check in of_irq_map_raw:

	if (ointsize != intsize)
		return -EINVAL;

The only diff in these functions is really checking the size. So I
really don't think we need 3 versions if that can be factored out where
you know value of #interrupt-cells.

Rob

>  	*out_hwirq = intspec[0];
> -	*out_type = IRQ_TYPE_NONE;
> +	*out_type = d->xlate_type;
>  	if (intsize > 1)
>  		*out_type = intspec[1] & IRQ_TYPE_SENSE_MASK;
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(irq_domain_xlate_onetwocell);
>  
>  struct irq_domain_ops irq_domain_simple_ops = {
>  	.map = irq_domain_simple_map,
> -	.xlate = irq_domain_simple_xlate,
> +	.xlate = irq_domain_xlate_onetwocell,
>  };
>  EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
>  
