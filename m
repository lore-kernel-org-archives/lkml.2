Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab1IQXxd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 19:53:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58404 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab1IQXxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 19:53:32 -0400
Date: Sat, 17 Sep 2011 17:53:28 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, jamie@jamieiles.com, b-cousson@ti.com,
        shawn.guo@linaro.org, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/5] of/irq: introduce of_irq_init
Message-ID: <20110917235328.GA3523@ponder.secretlab.ca>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
 <1316017900-19918-4-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316017900-19918-4-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 11:31:38AM -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> of_irq_init will scan the devicetree for matching interrupt controller
> nodes. Then it calls an initialization function for each found controller
> in the proper order with parent nodes initialized before child nodes.
> 
> Based on initial pseudo code from Grant Likely.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
>  drivers/of/irq.c       |   96 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_irq.h |    1 +
>  2 files changed, 97 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index 9f689f1..a0cd7e8 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -19,10 +19,13 @@
>   */
>  
>  #include <linux/errno.h>
> +#include <linux/list.h>
> +#include <linux/list_sort.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_irq.h>
>  #include <linux/string.h>
> +#include <linux/slab.h>
>  
>  /* For archs that don't support NO_IRQ (such as x86), provide a dummy value */
>  #ifndef NO_IRQ
> @@ -386,3 +389,96 @@ int of_irq_to_resource_table(struct device_node *dev, struct resource *res,
>  
>  	return i;
>  }
> +
> +struct intc_desc {
> +	struct list_head	list;
> +	struct device_node	*dev;
> +	struct device_node	*parent;
> +};
> +
> +typedef void (*irq_init_cb_t)(struct device_node *, struct device_node *);
> +
> +static int __init irq_cmp_intc_desc(void *unused, struct list_head *a,
> +				    struct list_head *b)
> +{
> +	const struct intc_desc *da = list_entry(a, typeof(*da), list);
> +	const struct intc_desc *db = list_entry(b, typeof(*db), list);
> +
> +	/* same parent, so order doesn't matter */
> +	if (da->parent == db->parent)
> +		return 0;
> +
> +	/* NULL parent comes first */
> +	if (!da->parent && db->parent)
> +		return -1;
> +	if (!db->parent && da->parent)
> +		return 1;
> +
> +	/* parent node must be before child node */
> +	if (da->dev == db->parent)
> +		return -1;
> +	if (db->dev == da->parent)
> +		return 1;

Does sort_list work for relationships 4 or more levels deep?  ie. if
there was a relationship of A <- B <- C <- D, then B compared with D
would return 0 from this function which could potentially result in an
incorrectly ordered list.

The other option for implementing this would be to take the probe
deferral approach and not try to sort the list, but instead allow
probe functions to fail & request retry if the parent hasn't yet been
probed.  I haven't thought enough about it though to say which would
be the best approach.

> +
> +	return 0;
> +}
> +
> +/**
> + * of_irq_init - Scan the device tree for matching interrupt controllers and
> + * call their initialization functions in order with parents first.
> + * @matches: 0 terminated array of nodes to match and initialization function
> + * to call on match
> + */
> +void __init of_irq_init(const struct of_device_id *matches)
> +{
> +	struct device_node *np;
> +	const struct of_device_id *match;
> +	struct intc_desc *desc;
> +	struct intc_desc *temp_desc;
> +	struct list_head intc_desc_list;
> +
> +	INIT_LIST_HEAD(&intc_desc_list);
> +
> +	for_each_matching_node(np, matches) {
> +		if (!of_find_property(np, "interrupt-controller", NULL))
> +			continue;
> +		/* Here, we allocate and populate an intc_desc with the node
> +		* pointer, interrupt-parent device_node etc. */
> +		desc = kzalloc(sizeof(*desc), GFP_KERNEL);
> +		if (!desc) {
> +			WARN_ON(1);
> +			goto err;
> +		}
> +		desc->dev = np;
> +		desc->parent = of_irq_find_parent(np);
> +		list_add(&desc->list, &intc_desc_list);
> +	}
> +	if (list_empty(&intc_desc_list))
> +		return;
> +
> +	/*
> +	 * The root irq controller is the one without an interrupt-parent.
> +	 * That one goes first, followed by the controllers that reference it,
> +	 * followed by the ones that reference the 2nd level controllers, etc
> +	 */

I don't believe that this actually turns out to be true (and yes I
know it is how I originally described it).  :-)  When the
interrupt-parent property is at the root of the tree, then the root
interrupt controller may very well inherit itself as it's interrupt
parent, and of_irq_find_parent() will still return a value.  This
should probably be considered a bug in of_irq_find_parent(), and it
should return NULL if the parent is itself.

of_irq_find_parent should probably be implemented thusly (completely
untested); although the only functional change is the line:
	return (p == child) ? NULL : p;

/**
 * of_irq_find_parent - Given a device node, find its interrupt parent node
 * @child: pointer to device node
 *
 * Returns a pointer to the interrupt parent node, or NULL if the
 * interrupt parent could not be determined.
 */
struct device_node *of_irq_find_parent(struct device_node *child)
{
	struct device_node *p, *c = child;
	const __be32 *parp;

	if (!of_node_get(c))
		return NULL;

	do {
		p = of_parse_phandle(c, "interrupt-parent", 0);

		if (!p && (of_irq_workarounds & OF_IMAP_NO_PHANDLE) &&
		    of_find_property(c, "interrupt-parent", NULL))
			p = of_node_get(of_irq_dflt_pic);

		if (!p)
			p = of_get_parent(c);

		of_node_put(c);
		c = p;
	} while (p && !of_find_property(p, "#interrupt-cells", NULL));

	return (p == child) ? NULL : p;
}


> +	list_sort(NULL, &intc_desc_list, irq_cmp_intc_desc);
> +
> +	list_for_each_entry_safe(desc, temp_desc, &intc_desc_list, list) {
> +		match = of_match_node(matches, desc->dev);
> +		if (match && match->data) {
> +			irq_init_cb_t irq_init_cb = match->data;
> +			pr_debug("of_irq_init: init %s @ %p, parent %p\n",
> +				 match->compatible, desc->dev, desc->parent);
> +			irq_init_cb(desc->dev, desc->parent);
> +		}
> +		list_del(&desc->list);
> +		kfree(desc);
> +	}
> +	return;
> +
> +err:
> +	list_for_each_entry_safe(desc, temp_desc, &intc_desc_list, list) {
> +		list_del(&desc->list);
> +		kfree(desc);
> +	}
> +}

Overall, I'm pretty happy with how this is looking.  Great job!

g.

> diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
> index cd2e61c..032d76c 100644
> --- a/include/linux/of_irq.h
> +++ b/include/linux/of_irq.h
> @@ -73,6 +73,7 @@ extern int of_irq_to_resource_table(struct device_node *dev,
>  		struct resource *res, int nr_irqs);
>  extern struct device_node *of_irq_find_parent(struct device_node *child);
>  
> +extern void of_irq_init(const struct of_device_id *matches);
>  
>  #endif /* CONFIG_OF_IRQ */
>  #endif /* CONFIG_OF */
> -- 
> 1.7.5.4
> 
