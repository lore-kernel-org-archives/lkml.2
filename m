Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab1IRGbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 02:31:41 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42718 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab1IRGbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 02:31:21 -0400
Date: Sun, 18 Sep 2011 00:02:05 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, jamie@jamieiles.com, b-cousson@ti.com,
        shawn.guo@linaro.org, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/5] of/irq: introduce of_irq_init
Message-ID: <20110918060205.GC3523@ponder.secretlab.ca>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
 <1316017900-19918-4-git-send-email-robherring2@gmail.com>
 <20110917235328.GA3523@ponder.secretlab.ca>
 <4E754B56.1010404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E754B56.1010404@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 08:37:26PM -0500, Rob Herring wrote:
> Grant,
> 
> On 09/17/2011 06:53 PM, Grant Likely wrote:
> > On Wed, Sep 14, 2011 at 11:31:38AM -0500, Rob Herring wrote:
> > The other option for implementing this would be to take the probe
> > deferral approach and not try to sort the list, but instead allow
> > probe functions to fail & request retry if the parent hasn't yet been
> > probed.  I haven't thought enough about it though to say which would
> > be the best approach.
> > 
> 
> Considering the list will typically be only a few entries, it is
> probably not so important how efficiently we sort or walk the list.
> 
> The only way I see controller code knowing if it needs to defer init is
> if of_irq_create_mapping fails. The core code could simply do this
> itself. However, I would imagine sorting it would be faster than that path.
> 
> How about something like this (untested):
> 
> int find_order(struct intc_desc *node)
> {
> 	struct intc_desc *d;
> 
> 	list_for_each_entry(d, &intc_desc_list, list) {
> 		if (node->parent != d->dev)
> 			continue;
> 
> 		if (d->order < 0)
> 			find_order(d);
> 
> 		node->order = d->order + 1;
> 		break;
> 	}
> }
> 
> 
> Then rather than sorting, do this:
> 
> 
> 	list_for_each_entry(desc, &intc_desc_list, list)
> 		find_order(desc);
> 
> 	for (order = 0; !list_empty(&intc_desc_list); order++) {
> 		list_for_each_entry_safe(desc, temp_desc, &intc_desc_list, list) {
> 			if (desc->order != order)
> 				continue;
> 			
> 			match = of_match_node(matches, desc->dev);
> 			if (match && match->data) {
> 				irq_init_cb_t irq_init_cb = match->data;
> 				pr_debug("of_irq_init: init %s @ %p, parent %p\n",
> 					 match->compatible, desc->dev, desc->parent);
> 				irq_init_cb(desc->dev, desc->parent);
> 			}
> 			list_del(&desc->list);
> 			kfree(desc);
> 		}
> 	}

I don't think there needs to be a separate pass for calculating order.
What about a breadth-first search with a secondary list for pending
parents?  Something like:


	struct list_head intc_desc_list;
	struct list_head intc_parent_list;
	struct device_node *parent = NULL;

	while (!list_empty(&intc_desc_list)) {
		/*
		 * Process all controllers with the current 'parent'.
		 * First pass will be looking for NULL as the parent.
		 * The assumption is that NULL parent means a root
		 * controller
		 */
		list_for_each_entry_safe(desc, temp_desc, &intc_desc_list, list) {
			if (desc->parent == parent) {
				list_del(&desc->list);
				irq_init_cb_t irq_init_cb = match->data;
				pr_debug("of_irq_init: init %s @ %p, parent %p\n",
					 match->compatible, desc->dev, desc->parent);
				irq_init_cb(desc->dev, desc->parent);

				/*
				 * This one is now set up; add it to
				 * the parent list so its children
				 * can get processed in a subsequent
				 * pass.
				 */
				list_add_tail(&desc->list, &intc_parent_list);
			}
		}

		/* Get the next pending parent that might have children */
		desc = list_first_entry(&intc_parent_list, typeof(*desc), list);
		if (!desc) {
			pr_error("Danger Will Robinson!");
			break;
		}
		list_del(&desc->list);
		parent = desc->list
		kfree(desc);
	}

> >> +	/*
> >> +	 * The root irq controller is the one without an interrupt-parent.
> >> +	 * That one goes first, followed by the controllers that reference it,
> >> +	 * followed by the ones that reference the 2nd level controllers, etc
> >> +	 */
> > 
> > I don't believe that this actually turns out to be true (and yes I
> > know it is how I originally described it).  :-)  When the
> > interrupt-parent property is at the root of the tree, then the root
> > interrupt controller may very well inherit itself as it's interrupt
> > parent, and of_irq_find_parent() will still return a value.  This
> > should probably be considered a bug in of_irq_find_parent(), and it
> > should return NULL if the parent is itself.
> 
> I did hit this exact issue. There is an easy, but not obvious fix to the
> device tree. Simply adding "interupt-parent;" to the root interrupt
> controller node will do the trick and override the value in the tree root.

Hahaha.  Definitely a bug then.

> > of_irq_find_parent should probably be implemented thusly (completely
> > untested); although the only functional change is the line:
> > 	return (p == child) ? NULL : p;
> > 
> > /**
> >  * of_irq_find_parent - Given a device node, find its interrupt parent node
> >  * @child: pointer to device node
> >  *
> >  * Returns a pointer to the interrupt parent node, or NULL if the
> >  * interrupt parent could not be determined.
> >  */
> > struct device_node *of_irq_find_parent(struct device_node *child)
> > {
> > 	struct device_node *p, *c = child;
> > 	const __be32 *parp;
> > 
> > 	if (!of_node_get(c))
> > 		return NULL;
> > 
> > 	do {
> > 		p = of_parse_phandle(c, "interrupt-parent", 0);
> > 
> > 		if (!p && (of_irq_workarounds & OF_IMAP_NO_PHANDLE) &&
> > 		    of_find_property(c, "interrupt-parent", NULL))
> > 			p = of_node_get(of_irq_dflt_pic);
> > 
> > 		if (!p)
> > 			p = of_get_parent(c);
> > 
> > 		of_node_put(c);
> > 		c = p;
> > 	} while (p && !of_find_property(p, "#interrupt-cells", NULL));
> > 
> > 	return (p == child) ? NULL : p;
> > }
> > 
> 
> This change should probably be implemented as well as this is likely a
> common occurrence that will be stumbled over or existing device trees
> won't have this.

Existing device trees probably do have this, but all the powerpc board
support currently hard codes the interrupt controller setup.  They
will hit the same issue if converted to use this approach.

> I'll test and add to the next series.

Awesome, thanks!

g.

