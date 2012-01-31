Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab2AaONc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 09:13:32 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33494 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab2AaONb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 09:13:31 -0500
MIME-Version: 1.0
In-Reply-To: <1327944699-29882-2-git-send-email-robherring2@gmail.com>
References: <1327944699-29882-1-git-send-email-robherring2@gmail.com>
	<1327944699-29882-2-git-send-email-robherring2@gmail.com>
Date: Tue, 31 Jan 2012 22:13:29 +0800
Message-ID: <CAAQ0ZWSVgcv2+jD9C=4-JFyuAZEr+DYL=BO=4kmYn1t=AAXn_A@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] irq: add irq_domain support to generic-chip
From: Shawn Guo <shawn.guo@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, b-cousson@ti.com,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 11:31:38AM -0600, Rob Herring wrote:
...
> +#ifdef CONFIG_IRQ_DOMAIN
> +static int irq_gc_irq_domain_match(struct irq_domain *d, struct device_node *np)
> +{
> +	struct irq_chip_generic *gc;
> +
> +	if (d->of_node != NULL && d->of_node == np) {
> +		list_for_each_entry(gc, &gc_list, list) {
> +			if ((gc == d->host_data) && (d == gc->domain))
> +				return 1;
> +		}
> +	}

IIRC, we talked about this a little bit, but I'm still unsure how this
works for imx5 tzic case, where we have the same one tzic device_node
for 4 irqdomains representing 128 irq lines.  It seems to me the match
function here will always find the first irqdomain of the 4 for any
of those 128 tzic irqs.

The following is my code change against your branch for testing.  Am I
missing anything?

8<---
diff --git a/arch/arm/mach-imx/imx51-dt.c b/arch/arm/mach-imx/imx51-dt.c
index e1b5edf..45abf11 100644
--- a/arch/arm/mach-imx/imx51-dt.c
+++ b/arch/arm/mach-imx/imx51-dt.c
@@ -44,13 +44,6 @@ static const struct of_dev_auxdata
imx51_auxdata_lookup[] __initconst = {
        { /* sentinel */ }
 };

-static int __init imx51_tzic_add_irq_domain(struct device_node *np,
-                               struct device_node *interrupt_parent)
-{
-       irq_domain_add_legacy(np, 32, 0, 0, &irq_domain_simple_ops, NULL);
-       return 0;
-}
-
 static int __init imx51_gpio_add_irq_domain(struct device_node *np,
                                struct device_node *interrupt_parent)
 {
@@ -63,7 +56,6 @@ static int __init imx51_gpio_add_irq_domain(struct
device_node *np,
 }

 static const struct of_device_id imx51_irq_match[] __initconst = {
-       { .compatible = "fsl,imx51-tzic", .data = imx51_tzic_add_irq_domain, },
        { .compatible = "fsl,imx51-gpio", .data = imx51_gpio_add_irq_domain, },
        { /* sentinel */ }
 };

diff --git a/arch/arm/plat-mxc/tzic.c b/arch/arm/plat-mxc/tzic.c
index 98308ec..ffb615d 100644
--- a/arch/arm/plat-mxc/tzic.c
+++ b/arch/arm/plat-mxc/tzic.c
@@ -122,7 +122,9 @@ static __init void tzic_init_gc(unsigned int irq_start)
        ct->regs.disable = TZIC_ENCLEAR0(idx);
        ct->regs.enable = TZIC_ENSET0(idx);

-       irq_setup_generic_chip(gc, IRQ_MSK(32), 0, IRQ_NOREQUEST, 0);
+       irq_setup_generic_chip_domain(gc,
+               of_find_compatible_node(NULL, NULL, "fsl,tzic"),
+               IRQ_MSK(32), 0, IRQ_NOREQUEST, 0);
 }

 asmlinkage void __exception_irq_entry tzic_handle_irq(struct pt_regs *regs)
--->8

> +	return 0;
> +}
> +
...
> +void irq_setup_generic_chip_domain(struct irq_chip_generic *gc,
> +			    struct device_node *node, u32 msk,
> +			    enum irq_gc_flags flags, unsigned int clr,
> +			    unsigned int set)
> +{
> +	struct irq_chip_type *ct = gc->chip_types;
> +
> +	if (!node) {
> +		irq_setup_generic_chip(gc, msk, flags, clr, set);
> +		return;
> +	}
> +
> +	raw_spin_lock(&gc_lock);
> +	list_add_tail(&gc->list, &gc_list);
> +	raw_spin_unlock(&gc_lock);
> +
> +	/* Init mask cache ? */
> +	if (flags & IRQ_GC_INIT_MASK_CACHE)
> +		gc->mask_cache = irq_reg_readl(gc->reg_base + ct->regs.mask);
> +
> +	gc->flags = flags;
> +	gc->irq_clr = clr;
> +	gc->irq_set = set;
> +
> +	/* Users of domains should not use irq_base */
> +	if ((int)gc->irq_base > 0)
> +		gc->domain = irq_domain_add_legacy(node, fls(msk),
> +						   gc->irq_base, 0,
> +						   &irq_gc_irq_domain_ops, gc);
> +	else {
> +		gc->irq_base = 0;
> +		gc->domain = irq_domain_add_linear(node, fls(msk),
> +						   &irq_gc_irq_domain_ops, gc);
> +	}

We have 4 generic_chips for tzic with irq_base as 0, 32, 64, 96.  In
this case, we end up with having the first domain as the linear, and
the other 3 as the legacy?

> +}
> +EXPORT_SYMBOL_GPL(irq_setup_generic_chip_domain);
> +#endif

-- 
Regards,
Shawn
