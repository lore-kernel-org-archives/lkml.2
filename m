Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab1ITXBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 19:01:01 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35175 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab1ITXA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 19:00:59 -0400
Date: Tue, 20 Sep 2011 17:00:55 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, jamie@jamieiles.com, b-cousson@ti.com,
        shawn.guo@linaro.org, dave.martin@linaro.org, linux@arm.linux.org.uk,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 2/3] of/irq: introduce of_irq_init
Message-ID: <20110920230055.GR7781@ponder.secretlab.ca>
References: <1316550244-3655-1-git-send-email-robherring2@gmail.com>
 <1316550244-3655-3-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316550244-3655-3-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 03:24:03PM -0500, Rob Herring wrote:
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

Thanks Rob.  Looks pretty good.

Comments below.

> ---
>  drivers/of/irq.c       |  114 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_irq.h |    1 +
>  2 files changed, 115 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index 6a5b5e7..1d51bc7 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -19,10 +19,12 @@
>   */
>  
>  #include <linux/errno.h>
> +#include <linux/list.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_irq.h>
>  #include <linux/string.h>
> +#include <linux/slab.h>
>  
>  /* For archs that don't support NO_IRQ (such as x86), provide a dummy value */
>  #ifndef NO_IRQ
> @@ -386,3 +388,115 @@ int of_irq_to_resource_table(struct device_node *dev, struct resource *res,
>  
>  	return i;
>  }
> +
> +struct intc_desc {
> +	struct list_head	list;
> +	struct device_node	*dev;
> +	struct device_node	*interrupt_parent;
> +};
> +
> +typedef int (*irq_init_cb_t)(struct device_node *, struct device_node *);

This typedef should be in a header file.  I'd like to try and find a
way to typecheck the .data parameter in the matches table (maybe with
a macro), but I've not dug into the problem.

> +
> +/**
> + * of_irq_init - Scan the device tree for matching interrupt controllers and

kerneldoc format is:
 * of_irq_init() - ...

And the short description should fit on the one line.  Further
description can appear after the argument list documentation.

> + * call their initialization functions in order with parents first.
> + * @matches: 0 terminated array of nodes to match and initialization function
> + * to call on match
> + */
> +void __init of_irq_init(const struct of_device_id *matches)
> +{
> +	struct device_node *np;
> +	struct intc_desc *desc;
> +	struct intc_desc *temp_desc;
> +	struct intc_desc *parent_desc = NULL;
> +	struct list_head intc_desc_list;
> +	struct list_head intc_parent_list;

Nit: these lines can be collapsed a bit.
	struct intc_desc *desc, *temp_desc, *parent_desc = NULL;
	struct list_head intc_desc_list, intc_parent_list;

> +	INIT_LIST_HEAD(&intc_desc_list);
> +	INIT_LIST_HEAD(&intc_parent_list);
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
> +		desc->interrupt_parent = of_irq_find_parent(np);
> +		list_add(&desc->list, &intc_desc_list);

list_add_tail() would keep things ordered.

> +	}
> +	if (list_empty(&intc_desc_list))
> +		return;

This test can be dropped because the while loop performs the exact
same test.

> +
> +	/*
> +	 * The root irq controller is the one without an interrupt-parent.
> +	 * That one goes first, followed by the controllers that reference it,
> +	 * followed by the ones that reference the 2nd level controllers, etc
> +	 */
> +	while (!list_empty(&intc_desc_list)) {
> +		/*
> +		 * Process all controllers with the current 'parent'.
> +		 * First pass will be looking for NULL as the parent.
> +		 * The assumption is that NULL parent means a root controller.
> +		 */
> +		list_for_each_entry_safe(desc, temp_desc, &intc_desc_list, list) {
> +			const struct of_device_id *match;
> +			int ret;
> +			irq_init_cb_t irq_init_cb;
> +
> +			if (parent_desc &&
> +				(desc->interrupt_parent != parent_desc->dev))
> +				continue;

If you changed
	struct intc_desc *parent_desc = NULL;
to
	struct device_node *parent_np = NULL;

Then this test could be simplified to:
	if (desc->interupt_parent != parent_np)
		continue;

And the kfree could be done immediately after the next parent is
pulled off the intc_desc_list since the only thing actually needed
from the parent_desc is the parent node pointer.

> +
> +			list_del(&desc->list);
> +			match = of_match_node(matches, desc->dev);
> +			if (!match || !match->data)
> +				continue;
> +
> +			pr_debug("of_irq_init: init %s @ %p, parent %p\n",
> +				 match->compatible,
> +				 desc->dev, desc->interrupt_parent);
> +			irq_init_cb = match->data;
> +			ret = irq_init_cb(desc->dev, desc->interrupt_parent);
> +			if (ret)
> +				continue;
> +
> +			/*
> +			 * This one is now set up; add it to the parent list so
> +			 * its children can get processed in a subsequent pass.
> +			 */
> +			list_add_tail(&desc->list, &intc_parent_list);
> +		}
> +		/*
> +		 * All the direct children for the current parent are
> +		 * processed, so free the parent now.
> +		 */
> +		if (parent_desc)
> +			kfree(parent_desc);
> +
> +		/* Get the next pending parent that might have children */
> +		parent_desc = list_first_entry(&intc_parent_list,
> +					       typeof(*parent_desc), list);
> +		if (list_empty(&intc_parent_list) || !parent_desc) {
> +			pr_debug("of_irq_init: children remain, but no parents\n");
> +			goto err;
> +		}
> +
> +		list_del(&parent_desc->list);
> +	}

Need a loop here to clear and free any remaining entries in the
intc_parent_list.  Actually, everything would work fine by simply
removing the below 'return' statement and letting the code fall
through to the free loops unconditionally.  And the "goto err" above
can be simplified to "break".

> +	return;
> +
> +err:
> +	list_for_each_entry_safe(desc, temp_desc, &intc_parent_list, list) {
> +		list_del(&desc->list);
> +		kfree(desc);
> +	}
> +	list_for_each_entry_safe(desc, temp_desc, &intc_desc_list, list) {
> +		list_del(&desc->list);
> +		kfree(desc);
> +	}
> +}
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
