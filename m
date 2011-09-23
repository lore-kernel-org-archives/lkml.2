Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1IWXEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:04:30 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43130 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab1IWXEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:04:12 -0400
Date: Thu, 22 Sep 2011 23:14:03 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, jamie@jamieiles.com, b-cousson@ti.com,
        shawn.guo@linaro.org, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v3] of/irq: introduce of_irq_init
Message-ID: <20110923051403.GC24631@ponder.secretlab.ca>
References: <1316550244-3655-3-git-send-email-robherring2@gmail.com>
 <1316744473-13158-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316744473-13158-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 09:21:13PM -0500, Rob Herring wrote:
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

Looking really good, comments below...

> ---
> Changes from v2:
> - add missing kfree's found by Jamie
> - Implement Grant's comments to simplify the init loop
> - fix function comments

Nit: put changelog above the s-o-b lines so that it appears in the git
commit text.

> 
>  drivers/of/irq.c       |  106 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_irq.h |    3 +
>  2 files changed, 109 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index 6a5b5e7..aedd39b 100644
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
> @@ -386,3 +388,107 @@ int of_irq_to_resource_table(struct device_node *dev, struct resource *res,
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
> +/**
> + * of_irq_init - Scan and init matching interrupt controllers in DT
> + * @matches: 0 terminated array of nodes to match and init function to call
> + *
> + * This function scans the device tree for matching interrupt controller nodes,
> + * and calls their initialization functions in order with parents first.
> + */
> +void __init of_irq_init(const struct of_device_id *matches)
> +{
> +	struct device_node *np, *parent = NULL;
> +	struct intc_desc *desc, *temp_desc;
> +	struct list_head intc_desc_list, intc_parent_list;
> +
> +	INIT_LIST_HEAD(&intc_desc_list);
> +	INIT_LIST_HEAD(&intc_parent_list);
> +
> +	for_each_matching_node(np, matches) {
> +		if (!of_find_property(np, "interrupt-controller", NULL))
> +			continue;
> +		/* Here, we allocate and populate an intc_desc with the node
> +		* pointer, interrupt-parent device_node etc. */

nit: weird indenting

> +		desc = kzalloc(sizeof(*desc), GFP_KERNEL);
> +		if (!desc) {
> +			WARN_ON(1);
> +			goto err;
> +		}
> +		desc->dev = np;
> +		desc->interrupt_parent = of_irq_find_parent(np);
> +		list_add_tail(&desc->list, &intc_desc_list);
> +	}
> +	if (list_empty(&intc_desc_list))
> +		return;

This test in unnecessary

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
> +			of_irq_init_cb_t irq_init_cb;
> +
> +			if (desc->interrupt_parent != parent)
> +				continue;
> +
> +			list_del(&desc->list);
> +			match = of_match_node(matches, desc->dev);
> +			if (!match || !match->data) {

match will always be !NULL.  If match_data is NULL; something is
seriously wrong and the code should WARN().

> +				kfree(desc);
> +				continue;
> +			}
> +
> +			pr_debug("of_irq_init: init %s @ %p, parent %p\n",
> +				 match->compatible,
> +				 desc->dev, desc->interrupt_parent);
> +			irq_init_cb = match->data;
> +			ret = irq_init_cb(desc->dev, desc->interrupt_parent);
> +			if (ret) {
> +				kfree(desc);
> +				continue;
> +			}
> +
> +			/*
> +			 * This one is now set up; add it to the parent list so
> +			 * its children can get processed in a subsequent pass.
> +			 */
> +			list_add_tail(&desc->list, &intc_parent_list);
> +		}
> +
> +		/* Get the next pending parent that might have children */
> +		desc = list_first_entry(&intc_parent_list, typeof(*desc), list);
> +		if (list_empty(&intc_parent_list) || !desc) {
> +			pr_debug("of_irq_init: children remain, but no parents\n");

This is an error condition.  Use pr_err()

> +			break;
> +		}
> +		list_del(&desc->list);
> +		parent = desc->dev;
> +		kfree(desc);
> +	}
> +
> +	list_for_each_entry_safe(desc, temp_desc, &intc_parent_list, list) {
> +		list_del(&desc->list);
> +		kfree(desc);
> +	}
> +err:
> +	list_for_each_entry_safe(desc, temp_desc, &intc_desc_list, list) {
> +		list_del(&desc->list);
> +		kfree(desc);
> +	}
> +}
> diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
> index cd2e61c..d0307ee 100644
> --- a/include/linux/of_irq.h
> +++ b/include/linux/of_irq.h
> @@ -33,6 +33,8 @@ struct of_irq {
>  	u32 specifier[OF_MAX_IRQ_SPEC]; /* Specifier copy */
>  };
>  
> +typedef int (*of_irq_init_cb_t)(struct device_node *, struct device_node *);
> +
>  /*
>   * Workarounds only applied to 32bit powermac machines
>   */
> @@ -73,6 +75,7 @@ extern int of_irq_to_resource_table(struct device_node *dev,
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
