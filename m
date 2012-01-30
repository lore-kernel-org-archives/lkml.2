Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab2A3Rb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:31:57 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39903 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2A3Rbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:31:55 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>, shawn.guo@linaro.org,
        b-cousson@ti.com, Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v3 1/2] irq: add irq_domain support to generic-chip
Date: Mon, 30 Jan 2012 11:31:38 -0600
Message-Id: <1327944699-29882-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327944699-29882-1-git-send-email-robherring2@gmail.com>
References: <1327944699-29882-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Add irq domain support to irq generic-chip. This enables users of
generic-chip to support dynamic irq assignment needed for DT interrupt
binding.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h       |   10 +++
 kernel/irq/generic-chip.c |  134 ++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 129 insertions(+), 15 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index bff29c5..482d198 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -665,6 +665,10 @@ struct irq_chip_generic {
 	void __iomem		*reg_base;
 	unsigned int		irq_base;
 	unsigned int		irq_cnt;
+	struct irq_domain	*domain;
+	unsigned int		flags;
+	unsigned int		irq_set;
+	unsigned int		irq_clr;
 	u32			mask_cache;
 	u32			type_cache;
 	u32			polarity_cache;
@@ -707,6 +711,12 @@ irq_alloc_generic_chip(const char *name, int nr_ct, unsigned int irq_base,
 void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
 			    enum irq_gc_flags flags, unsigned int clr,
 			    unsigned int set);
+
+struct device_node;
+void irq_setup_generic_chip_domain(struct irq_chip_generic *gc,
+			    struct device_node *node, u32 msk,
+			    enum irq_gc_flags flags, unsigned int clr,
+			    unsigned int set);
 int irq_setup_alt_chip(struct irq_data *d, unsigned int type);
 void irq_remove_generic_chip(struct irq_chip_generic *gc, u32 msk,
 			     unsigned int clr, unsigned int set);
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index c89295a..2519663 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -5,6 +5,7 @@
  */
 #include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/interrupt.h>
@@ -39,7 +40,7 @@ void irq_gc_noop(struct irq_data *d)
 void irq_gc_mask_disable_reg(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = 1 << d->hwirq;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->disable);
@@ -57,7 +58,7 @@ void irq_gc_mask_disable_reg(struct irq_data *d)
 void irq_gc_mask_set_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = 1 << d->hwirq;
 
 	irq_gc_lock(gc);
 	gc->mask_cache |= mask;
@@ -75,7 +76,7 @@ void irq_gc_mask_set_bit(struct irq_data *d)
 void irq_gc_mask_clr_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = 1 << d->hwirq;
 
 	irq_gc_lock(gc);
 	gc->mask_cache &= ~mask;
@@ -93,7 +94,7 @@ void irq_gc_mask_clr_bit(struct irq_data *d)
 void irq_gc_unmask_enable_reg(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = 1 << d->hwirq;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->enable);
@@ -108,7 +109,7 @@ void irq_gc_unmask_enable_reg(struct irq_data *d)
 void irq_gc_ack_set_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = 1 << d->hwirq;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->ack);
@@ -122,7 +123,7 @@ void irq_gc_ack_set_bit(struct irq_data *d)
 void irq_gc_ack_clr_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = ~(1 << (d->irq - gc->irq_base));
+	u32 mask = ~(1 << d->hwirq);
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->ack);
@@ -136,7 +137,7 @@ void irq_gc_ack_clr_bit(struct irq_data *d)
 void irq_gc_mask_disable_reg_and_ack(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = 1 << d->hwirq;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->mask);
@@ -151,7 +152,7 @@ void irq_gc_mask_disable_reg_and_ack(struct irq_data *d)
 void irq_gc_eoi(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = 1 << d->hwirq;
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->eoi);
@@ -169,7 +170,7 @@ void irq_gc_eoi(struct irq_data *d)
 int irq_gc_set_wake(struct irq_data *d, unsigned int on)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = 1 << d->hwirq;
 
 	if (!(mask & gc->wake_enabled))
 		return -EINVAL;
@@ -257,11 +258,99 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
 		irq_set_chip_and_handler(i, &ct->chip, ct->handler);
 		irq_set_chip_data(i, gc);
 		irq_modify_status(i, clr, set);
+		irq_get_irq_data(i)->hwirq = i - gc->irq_base;
 	}
 	gc->irq_cnt = i - gc->irq_base;
 }
 EXPORT_SYMBOL_GPL(irq_setup_generic_chip);
 
+#ifdef CONFIG_IRQ_DOMAIN
+static int irq_gc_irq_domain_match(struct irq_domain *d, struct device_node *np)
+{
+	struct irq_chip_generic *gc;
+
+	if (d->of_node != NULL && d->of_node == np) {
+		list_for_each_entry(gc, &gc_list, list) {
+			if ((gc == d->host_data) && (d == gc->domain))
+				return 1;
+		}
+	}
+	return 0;
+}
+
+static int irq_gc_irq_domain_map(struct irq_domain *d, unsigned int irq,
+				 irq_hw_number_t hw)
+{
+	struct irq_chip_generic *gc = d->host_data;
+	struct irq_chip_type *ct = gc->chip_types;
+
+	if (gc->flags & IRQ_GC_INIT_NESTED_LOCK)
+		irq_set_lockdep_class(irq, &irq_nested_lock_class);
+
+	irq_set_chip_and_handler(irq, &ct->chip, ct->handler);
+	irq_set_chip_data(irq, gc);
+	irq_modify_status(irq, gc->irq_clr, gc->irq_set);
+
+	return 0;
+}
+
+static struct irq_domain_ops irq_gc_irq_domain_ops = {
+	.match = irq_gc_irq_domain_match,
+	.map = irq_gc_irq_domain_map,
+	.xlate = irq_domain_xlate_onetwocell,
+};
+
+/*
+ * irq_setup_generic_chip_domain - Setup a range of interrupts with a generic chip and domain
+ * @gc:		Generic irq chip holding all data
+ * @node:	Device tree node pointer for domain
+ * @msk:	Bitmask holding the irqs to initialize relative to gc->irq_base
+ * @flags:	Flags for initialization
+ * @clr:	IRQ_* bits to clear
+ * @set:	IRQ_* bits to set
+ *
+ * Set up max. 32 interrupts starting from gc->irq_base using an irq domain.
+ * Note, this initializes all interrupts to the primary irq_chip_type and its
+ * associated handler.
+ */
+void irq_setup_generic_chip_domain(struct irq_chip_generic *gc,
+			    struct device_node *node, u32 msk,
+			    enum irq_gc_flags flags, unsigned int clr,
+			    unsigned int set)
+{
+	struct irq_chip_type *ct = gc->chip_types;
+
+	if (!node) {
+		irq_setup_generic_chip(gc, msk, flags, clr, set);
+		return;
+	}
+
+	raw_spin_lock(&gc_lock);
+	list_add_tail(&gc->list, &gc_list);
+	raw_spin_unlock(&gc_lock);
+
+	/* Init mask cache ? */
+	if (flags & IRQ_GC_INIT_MASK_CACHE)
+		gc->mask_cache = irq_reg_readl(gc->reg_base + ct->regs.mask);
+
+	gc->flags = flags;
+	gc->irq_clr = clr;
+	gc->irq_set = set;
+
+	/* Users of domains should not use irq_base */
+	if ((int)gc->irq_base > 0)
+		gc->domain = irq_domain_add_legacy(node, fls(msk),
+						   gc->irq_base, 0,
+						   &irq_gc_irq_domain_ops, gc);
+	else {
+		gc->irq_base = 0;
+		gc->domain = irq_domain_add_linear(node, fls(msk),
+						   &irq_gc_irq_domain_ops, gc);
+	}
+}
+EXPORT_SYMBOL_GPL(irq_setup_generic_chip_domain);
+#endif
+
 /**
  * irq_setup_alt_chip - Switch to alternative chip
  * @d:		irq_data for this interrupt
@@ -325,8 +414,13 @@ static int irq_gc_suspend(void)
 	list_for_each_entry(gc, &gc_list, list) {
 		struct irq_chip_type *ct = gc->chip_types;
 
-		if (ct->chip.irq_suspend)
-			ct->chip.irq_suspend(irq_get_irq_data(gc->irq_base));
+		if (ct->chip.irq_suspend) {
+			int i;
+			int irq = gc->irq_base;
+			for (i = 0; !irq && i < 32; i++)
+				irq = irq_find_mapping(gc->domain, i);
+			ct->chip.irq_suspend(irq_get_irq_data(irq));
+		}
 	}
 	return 0;
 }
@@ -338,8 +432,13 @@ static void irq_gc_resume(void)
 	list_for_each_entry(gc, &gc_list, list) {
 		struct irq_chip_type *ct = gc->chip_types;
 
-		if (ct->chip.irq_resume)
-			ct->chip.irq_resume(irq_get_irq_data(gc->irq_base));
+		if (ct->chip.irq_resume) {
+			int i;
+			int irq = gc->irq_base;
+			for (i = 0; !irq && i < 32; i++)
+				irq = irq_find_mapping(gc->domain, i);
+			ct->chip.irq_resume(irq_get_irq_data(irq));
+		}
 	}
 }
 #else
@@ -354,8 +453,13 @@ static void irq_gc_shutdown(void)
 	list_for_each_entry(gc, &gc_list, list) {
 		struct irq_chip_type *ct = gc->chip_types;
 
-		if (ct->chip.irq_pm_shutdown)
-			ct->chip.irq_pm_shutdown(irq_get_irq_data(gc->irq_base));
+		if (ct->chip.irq_pm_shutdown) {
+			int i;
+			int irq = gc->irq_base;
+			for (i = 0; !irq && i < 32; i++)
+				irq = irq_find_mapping(gc->domain, i);
+			ct->chip.irq_pm_shutdown(irq_get_irq_data(irq));
+		}
 	}
 }
 
-- 
1.7.5.4

