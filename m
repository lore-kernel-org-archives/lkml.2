Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab2FOS0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:26:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59491 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030Ab2FOSZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:25:48 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] irqdomain: Fix up linear revmap for non-zero hwirq displacement.
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <1339572841-26175-1-git-send-email-lethal@linux-sh.org>
References: <1339572841-26175-1-git-send-email-lethal@linux-sh.org>
Date: Fri, 15 Jun 2012 12:25:40 -0600
Message-Id: <20120615182540.489133E0ACE@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012 16:34:00 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> Presently the linear revmap code assumes that all hwirqs start at 0,
> using the hwirq directly as an index value for the lookup. In the case of
> legacy revmaps this isn't necessarily the case, as the first_hwirq value
> passed in can be non-zero, causing those types of users to silently have
> their IRQs placed in the radix tree instead.
> 
> With this change, hwirq displacement is factored in at association time
> directly. This also makes it possible for non-legacy users to use linear
> revmaps regardless of hwirq base position. This could potentially lead to
> a bug if there's an attempt to associate multiple times in to the linear
> map in a nonsensical and non-linear order, but at that point being
> silently punted to the radix tree is likely to be the least of your
> concerns (in such a case it's fairly trivial to simply extend
> irq_domain_add_linear() to take a hwirq base and move the linear base
> assignment there).

I actually hoped to be rid of the whole hwirq start offset thing.
Doing without it simplifies the code, is slightly faster.  I suspect
very few controllers actually need it, and for those that do I'm
hoping the wasted space is in the order of 0-32 words.

Instead of this, can we change the affected controllers to use the
maximum hwirq number when setting the size of the linear map?

Do you have hardware where the first hwirq is a >32 number?

g.

> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> ---
>  include/linux/irqdomain.h |    1 +
>  kernel/irq/irqdomain.c    |   18 +++++++++++++-----
>  2 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index 775765d..58defd5 100644
> --- a/include/linux/irqdomain.h
> +++ b/include/linux/irqdomain.h
> @@ -97,6 +97,7 @@ struct irq_domain {
>  	/* Reverse mapping data */
>  	unsigned int nomap_max_irq;
>  	struct radix_tree_root radix_tree;
> +	unsigned int linear_start;
>  	unsigned int linear_size;
>  	unsigned int linear_revmap[];
>  };
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 906307b..8591cb6 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -55,6 +55,7 @@ static struct irq_domain *irq_domain_alloc(struct device_node *of_node,
>  	domain->ops = ops;
>  	domain->host_data = host_data;
>  	domain->of_node = of_node_get(of_node);
> +	domain->linear_start = 0;
>  	domain->linear_size = size;
>  
>  	return domain;
> @@ -268,8 +269,8 @@ static void irq_domain_disassociate_many(struct irq_domain *domain,
>  		irq_data->hwirq = 0;
>  
>  		/* Clear reverse map */
> -		if (hwirq < domain->linear_size)
> -			domain->linear_revmap[hwirq] = 0;
> +		if (hwirq - domain->linear_start < domain->linear_size)
> +			domain->linear_revmap[hwirq - domain->linear_start] = 0;
>  		else {
>  			mutex_lock(&revmap_trees_mutex);
>  			radix_tree_delete(&domain->radix_tree, hwirq);
> @@ -288,6 +289,13 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
>  	pr_debug("%s(%s, irqbase=%i, hwbase=%i, count=%i)\n", __func__,
>  		of_node_full_name(domain->of_node), irq_base, (int)hwirq_base, count);
>  
> +	/*
> +	 * The linear revmap may not begin at 0, factor in the hwirq
> +	 * displacement here.
> +	 */
> +	if (domain->linear_size)
> +		domain->linear_start = hwirq_base;
> +
>  	for (i = 0; i < count; i++) {
>  		struct irq_data *irq_data = irq_get_irq_data(virq + i);
>  
> @@ -311,8 +319,8 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
>  			goto err_unmap;
>  		}
>  
> -		if (hwirq < domain->linear_size)
> -			domain->linear_revmap[hwirq] = virq;
> +		if (hwirq - domain->linear_start < domain->linear_size)
> +			domain->linear_revmap[hwirq - domain->linear_start] = virq;
>  		else {
>  			mutex_lock(&revmap_trees_mutex);
>  			radix_tree_insert(&domain->radix_tree, hwirq, irq_data);
> @@ -585,7 +593,7 @@ unsigned int irq_linear_revmap(struct irq_domain *domain,
>  	BUG_ON(domain->revmap_type != IRQ_DOMAIN_MAP_LINEAR);
>  
>  	/* Check revmap bounds; complain if exceeded */
> -	if (hwirq >= domain->linear_size) {
> +	if (hwirq - domain->linear_start >= domain->linear_size) {
>  		rcu_read_lock();
>  		data = radix_tree_lookup(&domain->radix_tree, hwirq);
>  		rcu_read_unlock();
> -- 
> 1.7.9.rc0.28.g0e1cf
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
