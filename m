Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab2BOQhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 11:37:47 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:26100 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab2BOQhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 11:37:45 -0500
Message-ID: <4F3BDF1E.4040506@atmel.com>
Date: Wed, 15 Feb 2012 17:36:46 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
CC: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 25/25] irq_domain: mostly eliminate slow-path revmap
 lookups
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca> <1327700179-17454-26-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1327700179-17454-26-git-send-email-grant.likely@secretlab.ca>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

I do not know if it is the latest revision but I have identified some
issues on error/slow paths...


On 01/27/2012 10:36 PM, Grant Likely :
> With the current state of irq_domain, the reverse map is always used when
> new IRQs get mapped.  This means that the irq_find_mapping() function
> can be simplified to always call out to the revmap-specific lookup function.
> 
> This patch adds lookup functions for the revmaps that don't yet have one
> and removes the slow path lookup from most of the code paths.  The only
> place where the slow path legitimately remains is when the linear map
> is used with a hwirq number larger than the revmap size.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Milton Miller <miltonm@bga.com>
> ---
>  arch/powerpc/sysdev/xics/xics-common.c |    3 -
>  include/linux/irqdomain.h              |    3 +-
>  kernel/irq/irqdomain.c                 |   94 +++++++++++++++++---------------
>  3 files changed, 51 insertions(+), 49 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/xics/xics-common.c b/arch/powerpc/sysdev/xics/xics-common.c
> index ea5e204..1d7067d 100644
> --- a/arch/powerpc/sysdev/xics/xics-common.c
> +++ b/arch/powerpc/sysdev/xics/xics-common.c
> @@ -330,9 +330,6 @@ static int xics_host_map(struct irq_domain *h, unsigned int virq,
>  
>  	pr_devel("xics: map virq %d, hwirq 0x%lx\n", virq, hw);
>  
> -	/* Insert the interrupt mapping into the radix tree for fast lookup */
> -	irq_radix_revmap_insert(xics_host, virq, hw);
> -
>  	/* They aren't all level sensitive but we just don't really know */
>  	irq_set_status_flags(virq, IRQ_LEVEL);
>  
> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index 0b00f83..38314f2 100644
> --- a/include/linux/irqdomain.h
> +++ b/include/linux/irqdomain.h
> @@ -93,6 +93,7 @@ struct irq_domain {
>  	struct list_head link;
>  
>  	/* type of reverse mapping_technique */
> +	unsigned int (*revmap)(struct irq_domain *host, irq_hw_number_t hwirq);
>  	unsigned int revmap_type;
>  	union {
>  		struct {
> @@ -155,8 +156,6 @@ extern void irq_dispose_mapping(unsigned int virq);
>  extern unsigned int irq_find_mapping(struct irq_domain *host,
>  				     irq_hw_number_t hwirq);
>  extern unsigned int irq_create_direct_mapping(struct irq_domain *host);
> -extern void irq_radix_revmap_insert(struct irq_domain *host, unsigned int virq,
> -				    irq_hw_number_t hwirq);
>  extern unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
>  					    irq_hw_number_t hwirq);
>  extern unsigned int irq_linear_revmap(struct irq_domain *host,
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 5b4fc4d..91c1cb7 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -104,6 +104,7 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
>  	domain->revmap_data.legacy.first_irq = first_irq;
>  	domain->revmap_data.legacy.first_hwirq = first_hwirq;
>  	domain->revmap_data.legacy.size = size;
> +	domain->revmap = irq_domain_legacy_revmap;
>  
>  	mutex_lock(&irq_domain_mutex);
>  	/* Verify that all the irqs are available */
> @@ -174,18 +175,35 @@ struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
>  	}
>  	domain->revmap_data.linear.size = size;
>  	domain->revmap_data.linear.revmap = revmap;
> +	domain->revmap = irq_linear_revmap;
>  	irq_domain_add(domain);
>  	return domain;
>  }
>  
> +static unsigned int irq_domain_nomap_revmap(struct irq_domain *domain,
> +					    irq_hw_number_t hwirq)
> +{
> +	struct irq_data *data = irq_get_irq_data(hwirq);
> +
> +	if (WARN_ON_ONCE(domain->revmap_type != IRQ_DOMAIN_MAP_NOMAP))
> +		return irq_find_mapping(domain, hwirq);

Should be:
		return irq_find_mapping_slow(domain, hwirq);

Recursion otherwise...


> +
> +	/* Verify that the map has actually been established */
> +	if (data && (data->domain == domain) && (data->hwirq == hwirq))
> +		return hwirq;
> +	return 0;
> +}
> +
>  struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
>  					 const struct irq_domain_ops *ops,
>  					 void *host_data)
>  {
>  	struct irq_domain *domain = irq_domain_alloc(of_node,
>  					IRQ_DOMAIN_MAP_NOMAP, ops, host_data);
> -	if (domain)
> +	if (domain) {
> +		domain->revmap = irq_domain_nomap_revmap;
>  		irq_domain_add(domain);
> +	}
>  	return domain;
>  }
>  
> @@ -205,6 +223,7 @@ struct irq_domain *irq_domain_add_tree(struct device_node *of_node,
>  					IRQ_DOMAIN_MAP_TREE, ops, host_data);
>  	if (domain) {
>  		INIT_RADIX_TREE(&domain->revmap_data.tree, GFP_KERNEL);
> +		domain->revmap = irq_radix_revmap_lookup;
>  		irq_domain_add(domain);
>  	}
>  	return domain;
> @@ -378,6 +397,19 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
>  		return 0;
>  	}
>  
> +	switch(domain->revmap_type) {
> +	case IRQ_DOMAIN_MAP_LINEAR:
> +		if (hwirq < domain->revmap_data.linear.size)
> +			domain->revmap_data.linear.revmap[hwirq] = irq;
> +		break;
> +	case IRQ_DOMAIN_MAP_TREE:
> +		mutex_lock(&revmap_trees_mutex);
> +		radix_tree_insert(&domain->revmap_data.tree, hwirq,
> +				  irq_get_irq_data(irq));
> +		mutex_unlock(&revmap_trees_mutex);
> +
> +		break;
> +	}
>  	pr_debug("irq: irq %lu on domain %s mapped to virtual irq %u\n",
>  		hwirq, domain->of_node ? domain->of_node->full_name : "null", virq);
>  
> @@ -478,25 +510,27 @@ EXPORT_SYMBOL_GPL(irq_dispose_mapping);
>   * irq_find_mapping() - Find a linux irq from an hw irq number.
>   * @domain: domain owning this hardware interrupt
>   * @hwirq: hardware irq number in that domain space
> - *
> - * This is a slow path, for use by generic code. It's expected that an
> - * irq controller implementation directly calls the appropriate low level
> - * mapping function.
>   */
>  unsigned int irq_find_mapping(struct irq_domain *domain,
>  			      irq_hw_number_t hwirq)
>  {
> -	unsigned int i;
> -
> -	/* Look for default domain if nececssary */
> -	if (domain == NULL)
> +	if (!domain)
>  		domain = irq_default_domain;
> -	if (domain == NULL)
> -		return 0;
> +	return domain ? domain->revmap(domain, hwirq) : 0;
> +}
> +EXPORT_SYMBOL_GPL(irq_find_mapping);
>  
> -	/* legacy -> bail early */
> -	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
> -		return irq_domain_legacy_revmap(domain, hwirq);
> +/**
> + * irq_find_mapping_slow() - slow path for finding the irq mapped to a hwirq
> + *
> + * This is the failsafe slow path for finding an irq mapping.  The only time
> + * this will reasonably get called is when the linear map is used with a
> + * hwirq number larger than the size of the reverse map.
> + */
> +static unsigned int irq_find_mapping_slow(struct irq_domain *domain,
> +					  irq_hw_number_t hwirq)
> +{
> +	int i;
>  
>  	/* Slow path does a linear search of the map */
>  	for (i = 0; i < irq_virq_count; i++)  {
> @@ -506,7 +540,6 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
>  	}
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(irq_find_mapping);
>  
>  /**
>   * irq_radix_revmap_lookup() - Find a linux irq from a hw irq number.
> @@ -537,31 +570,7 @@ unsigned int irq_radix_revmap_lookup(struct irq_domain *domain,
>  	 * Else fallback to linear lookup - this should not happen in practice
>  	 * as it means that we failed to insert the node in the radix tree.
>  	 */
> -	return irq_data ? irq_data->irq : irq_find_mapping(domain, hwirq);
> -}
> -
> -/**
> - * irq_radix_revmap_insert() - Insert a hw irq to linux irq number mapping.
> - * @domain: domain owning this hardware interrupt
> - * @virq: linux irq number
> - * @hwirq: hardware irq number in that domain space
> - *
> - * This is for use by irq controllers that use a radix tree reverse
> - * mapping for fast lookup.
> - */
> -void irq_radix_revmap_insert(struct irq_domain *domain, unsigned int virq,
> -			     irq_hw_number_t hwirq)
> -{
> -	struct irq_data *irq_data = irq_get_irq_data(virq);
> -
> -	if (WARN_ON(domain->revmap_type != IRQ_DOMAIN_MAP_TREE))
> -		return;
> -
> -	if (virq) {
> -		mutex_lock(&revmap_trees_mutex);
> -		radix_tree_insert(&domain->revmap_data.tree, hwirq, irq_data);
> -		mutex_unlock(&revmap_trees_mutex);
> -	}
> +	return irq_data ? irq_data->irq : irq_find_mapping_slow(domain, hwirq);
>  }
>  
>  /**
> @@ -585,14 +594,11 @@ unsigned int irq_linear_revmap(struct irq_domain *domain,
>  	if (unlikely(hwirq >= domain->revmap_data.linear.size))
>  		return irq_find_mapping(domain, hwirq);

Ditto here. And same whith previous one in same function. Check in
irq_radix_revmap_lookup() there is the same issue on the "WARN_ON_ONCE"
path...

>  
> -	/* Check if revmap was allocated */
>  	revmap = domain->revmap_data.linear.revmap;
> -	if (unlikely(revmap == NULL))
> -		return irq_find_mapping(domain, hwirq);
>  
>  	/* Fill up revmap with slow path if no mapping found */
>  	if (unlikely(!revmap[hwirq]))
> -		revmap[hwirq] = irq_find_mapping(domain, hwirq);
> +		revmap[hwirq] = irq_find_mapping_slow(domain, hwirq);
>  
>  	return revmap[hwirq];
>  }

Bye,
-- 
Nicolas Ferre
