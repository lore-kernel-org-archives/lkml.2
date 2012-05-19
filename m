Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab2ESSlk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 14:41:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52807 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364Ab2ESSlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 14:41:37 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 4/8] irqdomain: Simple NUMA awareness.
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <1337407908-7421-5-git-send-email-lethal@linux-sh.org>
References: <1337407908-7421-1-git-send-email-lethal@linux-sh.org> <1337407908-7421-5-git-send-email-lethal@linux-sh.org>
Date: Sat, 19 May 2012 12:41:35 -0600
Message-Id: <20120519184135.8CFBD3E03B8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2012 15:11:44 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> While common irqdesc allocation is node aware, the irqdomain code is not.
> 
> This plugs in NUMA node id proliferation across the various allocation
> callsites by way of a new irq_domain_nid() helper. The irq_domain_nid()
> routine takes an of_node pointer instead of an irq_domain as it's also
> used for node placement of the irq domain data structure itself (at which
> point only the of_node is known). For platforms that aren't DT capable,
> we simply wrap in to numa_node_id() unconditionally.
> 
> In order for this to be generally supportable, it's also necessary to
> make of_node_to_nid() generally available. This is accomplished by simply
> bumping it down further in the header.
> 
> Presently we observe a number of regressions/inconsistencies on
> NUMA-capable platforms:
> 
> 	- Platforms using irqdomains with legacy mappings, where the
> 	  irq_descs are allocated node-local and the irqdomain data
> 	  structure is not.
> 
> 	- Drivers implementing irqdomains will lose node locality
> 	  regardless of the underlying struct device's node id.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> ---
>  include/linux/of.h     |   10 +++++-----
>  kernel/irq/irqdomain.c |   18 +++++++++++++-----
>  2 files changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index fa7fb1d..6478859 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -158,11 +158,6 @@ static inline unsigned long of_read_ulong(const __be32 *cell, int size)
>  
>  #define OF_BAD_ADDR	((u64)-1)
>  
> -#ifndef of_node_to_nid
> -static inline int of_node_to_nid(struct device_node *np) { return -1; }
> -#define of_node_to_nid of_node_to_nid
> -#endif
> -
>  extern struct device_node *of_find_node_by_name(struct device_node *from,
>  	const char *name);
>  #define for_each_node_by_name(dn, name) \
> @@ -351,6 +346,11 @@ static inline int of_machine_is_compatible(const char *compat)
>  #define of_match_node(_matches, _node)	NULL
>  #endif /* CONFIG_OF */
>  
> +#ifndef of_node_to_nid
> +static inline int of_node_to_nid(struct device_node *np) { return -1; }
> +#define of_node_to_nid of_node_to_nid
> +#endif
> +
>  /**
>   * of_property_read_bool - Findfrom a property
>   * @np:		device node from which the property value is to be read.
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 92e06442..5f0ca52 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -8,6 +8,7 @@
>  #include <linux/mutex.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> +#include <linux/topology.h>
>  #include <linux/seq_file.h>
>  #include <linux/slab.h>
>  #include <linux/smp.h>
> @@ -25,6 +26,11 @@ static DEFINE_MUTEX(irq_domain_mutex);
>  static DEFINE_MUTEX(revmap_trees_mutex);
>  static struct irq_domain *irq_default_domain;
>  
> +static inline int irq_domain_nid(struct device_node *of_node)
> +{
> +	return of_node ? of_node_to_nid(of_node) : numa_node_id();
> +}
> +

I think this logic should just be rolled into of_node_to_nid()
directly instead of an irq_domain-specific helper.  PowerPC and Sparc
are the only architectures doing anything special with of_node_to_nid
at the moment.  I don't think anyone has bothered to define an
arch-independent binding for NUMA associations.

Otherwise this patch looks good to me.

>  /**
>   * irq_domain_alloc() - Allocate a new irq_domain data structure
>   * @of_node: optional device-tree node of the interrupt controller
> @@ -43,7 +49,8 @@ static struct irq_domain *irq_domain_alloc(struct device_node *of_node,
>  {
>  	struct irq_domain *domain;
>  
> -	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
> +	domain = kzalloc_node(sizeof(*domain), GFP_KERNEL,
> +			      irq_domain_nid(of_node));
>  	if (WARN_ON(!domain))
>  		return NULL;
>  
> @@ -226,7 +233,8 @@ struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
>  	struct irq_domain *domain;
>  	unsigned int *revmap;
>  
> -	revmap = kzalloc(sizeof(*revmap) * size, GFP_KERNEL);
> +	revmap = kzalloc_node(sizeof(*revmap) * size, GFP_KERNEL,
> +			      irq_domain_nid(of_node));
>  	if (WARN_ON(!revmap))
>  		return NULL;
>  
> @@ -364,7 +372,7 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
>  	BUG_ON(domain == NULL);
>  	WARN_ON(domain->revmap_type != IRQ_DOMAIN_MAP_NOMAP);
>  
> -	virq = irq_alloc_desc_from(1, 0);
> +	virq = irq_alloc_desc_from(1, irq_domain_nid(domain->of_node));
>  	if (!virq) {
>  		pr_debug("irq: create_direct virq allocation failed\n");
>  		return 0;
> @@ -430,9 +438,9 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
>  	hint = hwirq % nr_irqs;
>  	if (hint == 0)
>  		hint++;
> -	virq = irq_alloc_desc_from(hint, 0);
> +	virq = irq_alloc_desc_from(hint, irq_domain_nid(domain->of_node));
>  	if (virq <= 0)
> -		virq = irq_alloc_desc_from(1, 0);
> +		virq = irq_alloc_desc_from(1, irq_domain_nid(domain->of_node));
>  	if (virq <= 0) {
>  		pr_debug("irq: -> virq allocation failed\n");
>  		return 0;
> -- 
> 1.7.9.rc0.28.g0e1cf
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
