Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab1LKPrk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 10:47:40 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:27439
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042Ab1LKPre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 10:47:34 -0500
X-SpamScore: -2
X-BigFish: VS-2(z1039oz1432N98dKzz1202hzz84d07h8275bh8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 12 Dec 2011 00:00:26 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] irq: convert generic-chip to use irq_domain
Message-ID: <20111211160025.GA9572@S2100-06.ap.freescale.net>
References: <1323470689-6200-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1323470689-6200-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

I installed the patch and played it a little bit, and I some feedback
below.

* It breaks some existing irq_chip_generic users like imx5, which
  is currently numbering irq from 0.  For such users, irq_alloc_descs()
  will fail because it's asked to search irq #0 starting from irq #1.
  Yes, I know numbering irq from 0 is a bad idea and really needs to
  get fixed.  But is it your intention to break such users and force
  them get fixed with this patch?

* I thought your patch is taking care of all irqdomain stuff inside
  irq_chip_generic in a way transparent to its users.  But it really
  took me some time to figure out that users still need to populate
  the .of_node for irq_domain encapsulated in irq_chip_generic.

* If I understand irq_chip_generic correctly, it only supports up to
  32 irqs in a chip.  The imx5 tzic supports 128 interrupt lines, and
  the current driver implements it as 4 generic irq chips.  But from
  hardware and device tree point of view, it's really just one
  controller, so we have only one tzic node in dts, and hence we only
  have the same one .of_node for 4 irq domains.  I'm afraid such
  implementation will break irq_create_of_mapping()?
  (For gpio interrupt controller, it should fit perfectly.)

Regards,
Shawn

On Fri, Dec 09, 2011 at 04:44:49PM -0600, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Add irq domain support to irq generic-chip. This enables users of
> generic-chip to support dynamic irq assignment needed for DT interrupt
> binding. Users must be converted to use irq_data.hwirq for determining
> local interrupt numbers rather than using the Linux irq number.
> 
> irq_base is kept for now as there are a few users of it. Once they
> are converted to use the irq domain, it can be removed.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> ---
>  include/linux/irq.h       |    2 +-
>  kernel/irq/Kconfig        |    1 +
>  kernel/irq/generic-chip.c |   54 +++++++++++++++++++++++++++-----------------
>  3 files changed, 35 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index bff29c5..9ba8a30 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -664,7 +664,7 @@ struct irq_chip_generic {
>  	raw_spinlock_t		lock;
>  	void __iomem		*reg_base;
>  	unsigned int		irq_base;
> -	unsigned int		irq_cnt;
> +	struct irq_domain	*domain;
>  	u32			mask_cache;
>  	u32			type_cache;
>  	u32			polarity_cache;
> diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
> index 5a38bf4..861f2fe 100644
> --- a/kernel/irq/Kconfig
> +++ b/kernel/irq/Kconfig
> @@ -51,6 +51,7 @@ config IRQ_EDGE_EOI_HANDLER
>  # Generic configurable interrupt chip implementation
>  config GENERIC_IRQ_CHIP
>         bool
> +       select IRQ_DOMAIN
>  
>  # Generic irq_domain hw <--> linux irq number translation
>  config IRQ_DOMAIN
> diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
> index c89295a..48eeb29 100644
> --- a/kernel/irq/generic-chip.c
> +++ b/kernel/irq/generic-chip.c
> @@ -5,6 +5,7 @@
>   */
>  #include <linux/io.h>
>  #include <linux/irq.h>
> +#include <linux/irqdomain.h>
>  #include <linux/slab.h>
>  #include <linux/export.h>
>  #include <linux/interrupt.h>
> @@ -39,7 +40,7 @@ void irq_gc_noop(struct irq_data *d)
>  void irq_gc_mask_disable_reg(struct irq_data *d)
>  {
>  	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> -	u32 mask = 1 << (d->irq - gc->irq_base);
> +	u32 mask = 1 << d->hwirq;
>  
>  	irq_gc_lock(gc);
>  	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->disable);
> @@ -57,7 +58,7 @@ void irq_gc_mask_disable_reg(struct irq_data *d)
>  void irq_gc_mask_set_bit(struct irq_data *d)
>  {
>  	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> -	u32 mask = 1 << (d->irq - gc->irq_base);
> +	u32 mask = 1 << d->hwirq;
>  
>  	irq_gc_lock(gc);
>  	gc->mask_cache |= mask;
> @@ -75,7 +76,7 @@ void irq_gc_mask_set_bit(struct irq_data *d)
>  void irq_gc_mask_clr_bit(struct irq_data *d)
>  {
>  	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> -	u32 mask = 1 << (d->irq - gc->irq_base);
> +	u32 mask = 1 << d->hwirq;
>  
>  	irq_gc_lock(gc);
>  	gc->mask_cache &= ~mask;
> @@ -93,7 +94,7 @@ void irq_gc_mask_clr_bit(struct irq_data *d)
>  void irq_gc_unmask_enable_reg(struct irq_data *d)
>  {
>  	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> -	u32 mask = 1 << (d->irq - gc->irq_base);
> +	u32 mask = 1 << d->hwirq;
>  
>  	irq_gc_lock(gc);
>  	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->enable);
> @@ -108,7 +109,7 @@ void irq_gc_unmask_enable_reg(struct irq_data *d)
>  void irq_gc_ack_set_bit(struct irq_data *d)
>  {
>  	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> -	u32 mask = 1 << (d->irq - gc->irq_base);
> +	u32 mask = 1 << d->hwirq;
>  
>  	irq_gc_lock(gc);
>  	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->ack);
> @@ -122,7 +123,7 @@ void irq_gc_ack_set_bit(struct irq_data *d)
>  void irq_gc_ack_clr_bit(struct irq_data *d)
>  {
>  	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> -	u32 mask = ~(1 << (d->irq - gc->irq_base));
> +	u32 mask = ~(1 << d->hwirq);
>  
>  	irq_gc_lock(gc);
>  	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->ack);
> @@ -136,7 +137,7 @@ void irq_gc_ack_clr_bit(struct irq_data *d)
>  void irq_gc_mask_disable_reg_and_ack(struct irq_data *d)
>  {
>  	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> -	u32 mask = 1 << (d->irq - gc->irq_base);
> +	u32 mask = 1 << d->hwirq;
>  
>  	irq_gc_lock(gc);
>  	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->mask);
> @@ -151,7 +152,7 @@ void irq_gc_mask_disable_reg_and_ack(struct irq_data *d)
>  void irq_gc_eoi(struct irq_data *d)
>  {
>  	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> -	u32 mask = 1 << (d->irq - gc->irq_base);
> +	u32 mask = 1 << d->hwirq;
>  
>  	irq_gc_lock(gc);
>  	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->eoi);
> @@ -169,7 +170,7 @@ void irq_gc_eoi(struct irq_data *d)
>  int irq_gc_set_wake(struct irq_data *d, unsigned int on)
>  {
>  	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> -	u32 mask = 1 << (d->irq - gc->irq_base);
> +	u32 mask = 1 << d->hwirq;
>  
>  	if (!(mask & gc->wake_enabled))
>  		return -EINVAL;
> @@ -201,10 +202,13 @@ irq_alloc_generic_chip(const char *name, int num_ct, unsigned int irq_base,
>  	struct irq_chip_generic *gc;
>  	unsigned long sz = sizeof(*gc) + num_ct * sizeof(struct irq_chip_type);
>  
> -	gc = kzalloc(sz, GFP_KERNEL);
> +	gc = kzalloc(sz + sizeof(struct irq_domain), GFP_KERNEL);
>  	if (gc) {
>  		raw_spin_lock_init(&gc->lock);
>  		gc->num_ct = num_ct;
> +		gc->domain = (void *)gc + sz;
> +		gc->domain->irq_base = irq_base;
> +		gc->domain->ops = &irq_domain_simple_ops;
>  		gc->irq_base = irq_base;
>  		gc->reg_base = reg_base;
>  		gc->chip_types->chip.name = name;
> @@ -237,7 +241,7 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
>  			    unsigned int set)
>  {
>  	struct irq_chip_type *ct = gc->chip_types;
> -	unsigned int i;
> +	unsigned int i, irq;
>  
>  	raw_spin_lock(&gc_lock);
>  	list_add_tail(&gc->list, &gc_list);
> @@ -247,18 +251,26 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
>  	if (flags & IRQ_GC_INIT_MASK_CACHE)
>  		gc->mask_cache = irq_reg_readl(gc->reg_base + ct->regs.mask);
>  
> -	for (i = gc->irq_base; msk; msk >>= 1, i++) {
> +	gc->domain->nr_irq = fls(msk);
> +	irq = irq_alloc_descs(gc->domain->irq_base, 1, gc->domain->nr_irq,
> +			      numa_node_id());
> +	if (irq > 0)
> +		gc->domain->irq_base = irq;
> +
> +	irq_domain_add(gc->domain);
> +
> +	for (i = 0; msk; msk >>= 1, i++) {
>  		if (!(msk & 0x01))
>  			continue;
>  
> +		irq = irq_domain_to_irq(gc->domain, i);
>  		if (flags & IRQ_GC_INIT_NESTED_LOCK)
> -			irq_set_lockdep_class(i, &irq_nested_lock_class);
> +			irq_set_lockdep_class(irq, &irq_nested_lock_class);
>  
> -		irq_set_chip_and_handler(i, &ct->chip, ct->handler);
> -		irq_set_chip_data(i, gc);
> -		irq_modify_status(i, clr, set);
> +		irq_set_chip_and_handler(irq, &ct->chip, ct->handler);
> +		irq_set_chip_data(irq, gc);
> +		irq_modify_status(irq, clr, set);
>  	}
> -	gc->irq_cnt = i - gc->irq_base;
>  }
>  EXPORT_SYMBOL_GPL(irq_setup_generic_chip);
>  
> @@ -298,7 +310,7 @@ EXPORT_SYMBOL_GPL(irq_setup_alt_chip);
>  void irq_remove_generic_chip(struct irq_chip_generic *gc, u32 msk,
>  			     unsigned int clr, unsigned int set)
>  {
> -	unsigned int i = gc->irq_base;
> +	unsigned int i = irq_domain_to_irq(gc->domain, 0);
>  
>  	raw_spin_lock(&gc_lock);
>  	list_del(&gc->list);
> @@ -326,7 +338,7 @@ static int irq_gc_suspend(void)
>  		struct irq_chip_type *ct = gc->chip_types;
>  
>  		if (ct->chip.irq_suspend)
> -			ct->chip.irq_suspend(irq_get_irq_data(gc->irq_base));
> +			ct->chip.irq_suspend(irq_get_irq_data(irq_domain_to_irq(gc->domain, 0)));
>  	}
>  	return 0;
>  }
> @@ -339,7 +351,7 @@ static void irq_gc_resume(void)
>  		struct irq_chip_type *ct = gc->chip_types;
>  
>  		if (ct->chip.irq_resume)
> -			ct->chip.irq_resume(irq_get_irq_data(gc->irq_base));
> +			ct->chip.irq_resume(irq_get_irq_data(irq_domain_to_irq(gc->domain, 0)));
>  	}
>  }
>  #else
> @@ -355,7 +367,7 @@ static void irq_gc_shutdown(void)
>  		struct irq_chip_type *ct = gc->chip_types;
>  
>  		if (ct->chip.irq_pm_shutdown)
> -			ct->chip.irq_pm_shutdown(irq_get_irq_data(gc->irq_base));
> +			ct->chip.irq_pm_shutdown(irq_get_irq_data(irq_domain_to_irq(gc->domain, 0)));
>  	}
>  }
>  
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

