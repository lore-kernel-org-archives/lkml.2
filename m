Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab2FOSff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:35:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55994 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab2FOSfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:35:25 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] irqdomain: Support one-shot tear down of domain mappings.
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <1339572841-26175-2-git-send-email-lethal@linux-sh.org>
References: <1339572841-26175-1-git-send-email-lethal@linux-sh.org> <1339572841-26175-2-git-send-email-lethal@linux-sh.org>
Date: Fri, 15 Jun 2012 12:35:18 -0600
Message-Id: <20120615183518.514853E0ACE@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012 16:34:01 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> This implements a sledgehammer approach for batched domain unmapping
> regardless of domain type. In the linear revmap case it's fairly easy to
> track state and iterate over the IRQs disposing of them one at a time,
> but it's not always so straightforward in the radix tree case.
> 
> A new irq_domain_dispose_mappings() is added to ensure all of the
> mappings are appropriately discarded, and is to be used prior to domain
> removal. Gang lookups are batched, presently 16 at a time, for no reason
> other than it seemed like a good number at the time.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> ---
>  include/linux/irqdomain.h |    1 +
>  kernel/irq/irqdomain.c    |   43 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index 58defd5..6f27c55 100644
> --- a/include/linux/irqdomain.h
> +++ b/include/linux/irqdomain.h
> @@ -149,6 +149,7 @@ static inline int irq_domain_associate(struct irq_domain *domain, unsigned int i
>  extern unsigned int irq_create_mapping(struct irq_domain *host,
>  				       irq_hw_number_t hwirq);
>  extern void irq_dispose_mapping(unsigned int virq);
> +extern void irq_domain_dispose_mappings(struct irq_domain *domain);
>  extern unsigned int irq_find_mapping(struct irq_domain *host,
>  				     irq_hw_number_t hwirq);
>  extern unsigned int irq_create_direct_mapping(struct irq_domain *host);
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 8591cb6..40c9ba1 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -546,6 +546,49 @@ void irq_dispose_mapping(unsigned int virq)
>  }
>  EXPORT_SYMBOL_GPL(irq_dispose_mapping);
>  
> +#define IRQ_DOMAIN_BATCH_IRQS	16
> +
> +/**
> + * irq_domain_dispose_mappings() - Dispose of all mappings in a domain
> + * @domain: domain to tear down
> + */
> +void irq_domain_dispose_mappings(struct irq_domain *domain)
> +{
> +	if (domain->revmap_type == IRQ_DOMAIN_MAP_NOMAP)
> +		return;
> +
> +	if (domain->linear_size) {
> +		int i;
> +
> +		for (i = 0; i < domain->linear_size; i++)
> +			irq_dispose_mapping(domain->linear_revmap[i]);
> +	} else {

The 'else' should be dropped I think.  With the merge of linear and
tree mappings into the same domain type, it is possible for a domain
to have both linear and tree mappings in the same instance.  So tree
needs to be cleared even if linear_size is non-zero.

> +		struct irq_data *irq_data_batch[IRQ_DOMAIN_BATCH_IRQS];
> +		unsigned int nr_found;
> +		unsigned long index = 0;
> +
> +		rcu_read_lock();
> +
> +		for (;;) {

Nit; while not 'while(1)'?

> +			int i;

Nit; move 'i' up with nr_found above.

> +
> +			nr_found = radix_tree_gang_lookup(&domain->radix_tree,
> +					(void **)irq_data_batch, index,
> +					ARRAY_SIZE(irq_data_batch));
> +			if (!nr_found)
> +				break;

Or better:

	while (nr_found = radix_tree_gang_lookup(&domain->radix_tree,
				(void **)irq_data_batch, index,
				ARRAY_SIZE(irq_data_batch))) {

Otherwise seems okay... though the gang lookup feels more complex than
it needs to be.

g.

> +
> +			for (i = 0; i < nr_found; i++)
> +				irq_dispose_mapping(irq_data_batch[i]->irq);
> +
> +			index += nr_found;
> +		}
> +
> +		rcu_read_unlock();
> +	}
> +}
> +EXPORT_SYMBOL_GPL(irq_domain_dispose_mappings);
> +
>  /**
>   * irq_find_mapping() - Find a linux irq from an hw irq number.
>   * @domain: domain owning this hardware interrupt
> -- 
> 1.7.9.rc0.28.g0e1cf
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
