Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab2FPF5H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 01:57:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:60662 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab2FPF5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 01:57:04 -0400
Message-ID: <1339826183.9220.218.camel@pasglop>
Subject: Re: [PATCH 04/12] irqdomain: Eliminate dedicated radix lookup
 functions
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Date: Sat, 16 Jun 2012 15:56:23 +1000
In-Reply-To: <1339822897-15840-5-git-send-email-grant.likely@secretlab.ca>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
	 <1339822897-15840-5-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 23:01 -0600, Grant Likely wrote:
> In preparation to remove the slow revmap path, eliminate the public
> radix revmap lookup functions.  This simplifies the code and makes the
> slowpath removal patch a lot simpler.

The idea here was to avoid a test (performance in the fast path) since
the controller knows the type of revmap it uses. You could just remove
the fallback to the slow path if there's a mismatch and keep the WARN_ON
no ? No biggie, it's just a switch/case with fairly predictable outcome
I suppose ...

A few other nits:

> 	return irq;
> diff --git a/arch/powerpc/sysdev/xics/xics-common.c b/arch/powerpc/sysdev/xics/xics-common.c
> index cd1d18d..9049d9f 100644
> --- a/arch/powerpc/sysdev/xics/xics-common.c
> +++ b/arch/powerpc/sysdev/xics/xics-common.c
> @@ -329,9 +329,6 @@ static int xics_host_map(struct irq_domain *h, unsigned int virq,
>  
>  	pr_devel("xics: map virq %d, hwirq 0x%lx\n", virq, hw);
>  
> -	/* Insert the interrupt mapping into the radix tree for fast lookup */
> -	irq_radix_revmap_insert(xics_host, virq, hw);
> -
>  	/* They aren't all level sensitive but we just don't really know */
>  	irq_set_status_flags(virq, IRQ_LEVEL);

This looks like it belongs in a different patch, possibly "[02/12]
irqdomain: Always update revmap when setting up a virq" no ? 

> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index 3425631..d8b88c5 100644
> --- a/include/linux/irqdomain.h
> +++ b/include/linux/irqdomain.h
> @@ -169,10 +169,6 @@ static inline int irq_create_identity_mapping(struct irq_domain *host,
>  	return irq_create_strict_mappings(host, hwirq, hwirq, 1);
>  }
>  
> -extern void irq_radix_revmap_insert(struct irq_domain *host, unsigned int virq,
> -				    irq_hw_number_t hwirq);
> -extern unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
> -					    irq_hw_number_t hwirq);
>  extern unsigned int irq_linear_revmap(struct irq_domain *host,
>  				      irq_hw_number_t hwirq);
>  
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 1a8f3d2..79a7711 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -415,7 +415,9 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
>  				domain->revmap_data.linear.revmap[hwirq] = virq;
>  			break;
>  		case IRQ_DOMAIN_MAP_TREE:
> -			irq_radix_revmap_insert(domain, virq, hwirq);
> +			mutex_lock(&revmap_trees_mutex);
> +			radix_tree_insert(&domain->revmap_data.tree, hwirq, irq_data);
> +			mutex_unlock(&revmap_trees_mutex);
>  			break;
>  		}

That too looks like it belongs in another patch.

> @@ -688,64 +690,6 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
>  EXPORT_SYMBOL_GPL(irq_find_mapping);
>  
>  /**
> - * irq_radix_revmap_lookup() - Find a linux irq from a hw irq number.
> - * @domain: domain owning this hardware interrupt
> - * @hwirq: hardware irq number in that domain space
> - *
> - * This is a fast path, for use by irq controller code that uses radix tree
> - * revmaps
> - */
> -unsigned int irq_radix_revmap_lookup(struct irq_domain *domain,
> -				     irq_hw_number_t hwirq)
> -{
> -	struct irq_data *irq_data;
> -
> -	if (WARN_ON_ONCE(domain->revmap_type != IRQ_DOMAIN_MAP_TREE))
> -		return irq_find_mapping(domain, hwirq);
> -
> -	/*
> -	 * Freeing an irq can delete nodes along the path to
> -	 * do the lookup via call_rcu.
> -	 */
> -	rcu_read_lock();
> -	irq_data = radix_tree_lookup(&domain->revmap_data.tree, hwirq);
> -	rcu_read_unlock();
> -
> -	/*
> -	 * If found in radix tree, then fine.
> -	 * Else fallback to linear lookup - this should not happen in practice
> -	 * as it means that we failed to insert the node in the radix tree.
> -	 */
> -	return irq_data ? irq_data->irq : irq_find_mapping(domain, hwirq);
> -}
> -EXPORT_SYMBOL_GPL(irq_radix_revmap_lookup);
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
> -}
> -EXPORT_SYMBOL_GPL(irq_radix_revmap_insert);
> -
> -/**
>   * irq_linear_revmap() - Find a linux irq from a hw irq number.
>   * @domain: domain owning this hardware interrupt
>   * @hwirq: hardware irq number in that domain space

Cheers,
Ben.


