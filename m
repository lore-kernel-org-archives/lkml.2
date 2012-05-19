Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab2ESUVo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 16:21:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38720 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab2ESUVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 16:21:42 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 6/8] irqdomain: Support identity mapped VIRQ allocation.
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <1337407908-7421-7-git-send-email-lethal@linux-sh.org>
References: <1337407908-7421-1-git-send-email-lethal@linux-sh.org> <1337407908-7421-7-git-send-email-lethal@linux-sh.org>
Date: Sat, 19 May 2012 14:21:40 -0600
Message-Id: <20120519202140.7B0973E03B8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2012 15:11:46 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> This adds a new irq_create_identity_mapping() routine to permit platforms
> to utilize 1:1 identity mapping between hardware and linux IRQs for
> domain population. The same semantics as irq_create_mapping() apply,
> though in this case we only support irqdesc allocation at a static
> location, rather than falling back on dynamic lookup.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> ---
>  include/linux/irqdomain.h |    2 ++
>  kernel/irq/irqdomain.c    |   41 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index 5abb533..e32d2e7 100644
> --- a/include/linux/irqdomain.h
> +++ b/include/linux/irqdomain.h
> @@ -149,6 +149,8 @@ extern unsigned int irq_create_mapping(struct irq_domain *host,
>  extern void irq_dispose_mapping(unsigned int virq);
>  extern unsigned int irq_find_mapping(struct irq_domain *host,
>  				     irq_hw_number_t hwirq);
> +extern unsigned int irq_create_identity_mapping(struct irq_domain *host,
> +						irq_hw_number_t hwirq);
>  extern unsigned int irq_create_direct_mapping(struct irq_domain *host);
>  extern void irq_radix_revmap_insert(struct irq_domain *host, unsigned int virq,
>  				    irq_hw_number_t hwirq);
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 5f0ca52..ac44781 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -459,6 +459,47 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
>  }
>  EXPORT_SYMBOL_GPL(irq_create_mapping);
>  
> +/**
> + * irq_create_identity_mapping() - Allocate an identity mapped irq
> + * @domain: domain owning this hardware interrupt or NULL for default domain
> + * @hwirq: hardware irq number in that domain space
> + *
> + * This routine is used to allocate IRQs with a 1:1 identity mapping
> + * between the hardware and linux irq.
> + */
> +unsigned int irq_create_identity_mapping(struct irq_domain *domain,
> +					 irq_hw_number_t hwirq)

How about the following for an API (omitting error checking, and the
actual names are up for debate):

int irq_domain_associate_many(struct irq_domain *domain,
				unsigned int irq_base,
				irq_hw_number_t hwirq_base,
				int count)
{
	int i;
	for (i = 0; i < count; i++)
		irq_setup_virq(domain, irq_base + i, hwirq_base + i);
}
int irq_create_strict_mappings(struct irq_domain *domain,
				unsigned int irq_base,
				irq_hw_number_t hwirq_base,
				int count)
{
	/* Allows for non-identity, but still static mappings of a
	 * range of irq numbers */
	irq_alloc_descs(irq_base, irq_base, irq_domain_nid(domain->of_node));
	irq_domain_associate_many(domain, irq_base, hwirq, count);
	...
}

/* in header */
static int irq_create_identity_mapping(struct irq_domain *domain,
					irq_hw_number_t hwirq_base)
{
	irq_create_strict_mappings(domain, hwirq_base, hwirq_base, 1);
}

That would give the ability to either associated for pre-allocated
irq_descs, or strict map for allocating a specific range of irqs.


> +{
> +	int virq;
> +
> +	pr_debug("irq: irq_create_identity_mapping(0x%p, 0x%lx)\n",
> +		 domain, hwirq);
> +
> +	if (domain == NULL)
> +		domain = irq_default_domain;

This is a new API, and I'm not a fan of the irq_default_domain usage
so I'd like just drop the above too lines.  My opinion is that if your
calling into get a mapping, then the code really should know what
domain it is requesting from.  If a default domain really is needed,
then there it should be explicit for the caller to find the default
domain and then pass that in to this function.

> +	if (domain == NULL) {
> +		WARN_ON(1);
> +		return 0;
> +	}
> +
> +	virq = irq_alloc_desc_at(hwirq, irq_domain_nid(domain->of_node));
> +	if (virq < 0) {
> +		pr_debug("irq: -> virq allocation failed\n");
> +		return 0;
> +	}
> +
> +	if (irq_setup_virq(domain, virq, hwirq)) {
> +		if (domain->revmap_type != IRQ_DOMAIN_MAP_LEGACY)
> +			irq_free_desc(virq);
> +		return 0;
> +	}
> +
> +	pr_debug("irq: irq %lu identity mapped\n", hwirq);
> +
> +	return virq;
> +}
> +EXPORT_SYMBOL_GPL(irq_create_identity_mapping);
> +
>  unsigned int irq_create_of_mapping(struct device_node *controller,
>  				   const u32 *intspec, unsigned int intsize)
>  {
> -- 
> 1.7.9.rc0.28.g0e1cf
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
