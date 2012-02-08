Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab2BHWzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 17:55:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52304 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab2BHWzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 17:55:38 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Shawn Guo <shawn.guo@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, b-cousson@ti.com,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v6] irq: add irq_domain support to generic-chip
Date: Wed,  8 Feb 2012 16:55:22 -0600
Message-Id: <1328741722-1254-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1328308512-22594-1-git-send-email-robherring2@gmail.com>
References: <1328308512-22594-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Add irq domain support to irq generic-chip. This enables users of
generic-chip to support dynamic irq assignment needed for DT interrupt
binding.

Thanks to Shawn Guo for fixes and testing.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
Here's the latest version. This has fixes from Shawn Guo, so should be
working. This version is also available here:

git://sources.calxeda.com/kernel/linux.git pl061-domain-v6.

 include/linux/irq.h       |   15 +++++
 kernel/irq/generic-chip.c |  152 ++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 145 insertions(+), 22 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index bff29c5..d721abc 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -664,7 +664,12 @@ struct irq_chip_generic {
 	raw_spinlock_t		lock;
 	void __iomem		*reg_base;
 	unsigned int		irq_base;
+	unsigned int		hwirq_base;
 	unsigned int		irq_cnt;
+	struct irq_domain	*domain;
+	unsigned int		flags;
+	unsigned int		irq_set;
+	unsigned int		irq_clr;
 	u32			mask_cache;
 	u32			type_cache;
 	u32			polarity_cache;
@@ -707,6 +712,16 @@ irq_alloc_generic_chip(const char *name, int nr_ct, unsigned int irq_base,
 void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
 			    enum irq_gc_flags flags, unsigned int clr,
 			    unsigned int set);
+
+struct device_node;
+int irq_setup_generic_chip_domain(const char *name, struct device_node *node,
+				  int num_ct, unsigned int irq_base,
+				  void __iomem *reg_base,
+				  irq_flow_handler_t handler, u32 hwirq_cnt,
+				  enum irq_gc_flags flags,
+				  unsigned int clr, unsigned int set,
+				  void (*gc_init_cb)(struct irq_chip_generic *),
+				  void *private);
 int irq_setup_alt_chip(struct irq_data *d, unsigned int type);
 void irq_remove_generic_chip(struct irq_chip_generic *gc, u32 msk,
 			     unsigned int clr, unsigned int set);
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index c89295a..3ac7fa1 100644
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
+	u32 mask = 1 << (d->hwirq % 32);
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->disable);
@@ -57,7 +58,7 @@ void irq_gc_mask_disable_reg(struct irq_data *d)
 void irq_gc_mask_set_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = 1 << (d->hwirq % 32);
 
 	irq_gc_lock(gc);
 	gc->mask_cache |= mask;
@@ -75,7 +76,7 @@ void irq_gc_mask_set_bit(struct irq_data *d)
 void irq_gc_mask_clr_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = 1 << (d->hwirq % 32);
 
 	irq_gc_lock(gc);
 	gc->mask_cache &= ~mask;
@@ -93,7 +94,7 @@ void irq_gc_mask_clr_bit(struct irq_data *d)
 void irq_gc_unmask_enable_reg(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = 1 << (d->hwirq % 32);
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->enable);
@@ -108,7 +109,7 @@ void irq_gc_unmask_enable_reg(struct irq_data *d)
 void irq_gc_ack_set_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = 1 << (d->hwirq % 32);
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->ack);
@@ -122,10 +123,10 @@ void irq_gc_ack_set_bit(struct irq_data *d)
 void irq_gc_ack_clr_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = ~(1 << (d->irq - gc->irq_base));
+	u32 mask = 1 << (d->hwirq % 32);
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->ack);
+	irq_reg_writel(~mask, gc->reg_base + cur_regs(d)->ack);
 	irq_gc_unlock(gc);
 }
 
@@ -136,7 +137,7 @@ void irq_gc_ack_clr_bit(struct irq_data *d)
 void irq_gc_mask_disable_reg_and_ack(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = 1 << (d->hwirq % 32);
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->mask);
@@ -151,7 +152,7 @@ void irq_gc_mask_disable_reg_and_ack(struct irq_data *d)
 void irq_gc_eoi(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = 1 << (d->hwirq % 32);
 
 	irq_gc_lock(gc);
 	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->eoi);
@@ -169,7 +170,7 @@ void irq_gc_eoi(struct irq_data *d)
 int irq_gc_set_wake(struct irq_data *d, unsigned int on)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = 1 << (d->hwirq % 32);
 
 	if (!(mask & gc->wake_enabled))
 		return -EINVAL;
@@ -220,6 +221,18 @@ EXPORT_SYMBOL_GPL(irq_alloc_generic_chip);
  */
 static struct lock_class_key irq_nested_lock_class;
 
+static void irq_gc_setup_irq(struct irq_chip_generic *gc, int irq)
+{
+	struct irq_chip_type *ct = gc->chip_types;
+
+	if (gc->flags & IRQ_GC_INIT_NESTED_LOCK)
+		irq_set_lockdep_class(irq, &irq_nested_lock_class);
+
+	irq_set_chip_and_handler(irq, &ct->chip, ct->handler);
+	irq_set_chip_data(irq, gc);
+	irq_modify_status(irq, gc->irq_clr, gc->irq_set);
+}
+
 /**
  * irq_setup_generic_chip - Setup a range of interrupts with a generic chip
  * @gc:		Generic irq chip holding all data
@@ -247,21 +260,113 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
 	if (flags & IRQ_GC_INIT_MASK_CACHE)
 		gc->mask_cache = irq_reg_readl(gc->reg_base + ct->regs.mask);
 
+	gc->flags = flags;
+	gc->irq_clr = clr;
+	gc->irq_set = set;
+
 	for (i = gc->irq_base; msk; msk >>= 1, i++) {
 		if (!(msk & 0x01))
 			continue;
 
-		if (flags & IRQ_GC_INIT_NESTED_LOCK)
-			irq_set_lockdep_class(i, &irq_nested_lock_class);
-
-		irq_set_chip_and_handler(i, &ct->chip, ct->handler);
-		irq_set_chip_data(i, gc);
-		irq_modify_status(i, clr, set);
+		irq_gc_setup_irq(gc, i);
+		irq_get_irq_data(i)->hwirq = i - gc->irq_base;
 	}
 	gc->irq_cnt = i - gc->irq_base;
 }
 EXPORT_SYMBOL_GPL(irq_setup_generic_chip);
 
+#ifdef CONFIG_IRQ_DOMAIN
+static int irq_gc_irq_domain_map(struct irq_domain *d, unsigned int irq,
+				 irq_hw_number_t hw)
+{
+	struct irq_chip_generic **gc_array = d->host_data;
+	struct irq_chip_generic *gc = gc_array[hw / 32];
+
+	/* We need a valid irq number for suspend/resume functions */
+	if ((int)gc->irq_base == -1)
+		gc->irq_base = irq;
+	irq_gc_setup_irq(gc, irq);
+	return 0;
+}
+
+static const struct irq_domain_ops irq_gc_irq_domain_ops = {
+	.map = irq_gc_irq_domain_map,
+	.xlate = irq_domain_xlate_onetwocell,
+};
+
+/*
+ * irq_setup_generic_chip_domain - Setup a domain and N generic chips
+ * @name:	Name of the irq chip
+ * @node:	Device tree node pointer for domain
+ * @num_ct:	Number of irq_chip_type instances associated with this
+ * @irq_base:	Interrupt base nr for this chip
+ * @reg_base:	Register base address (virtual)
+ * @handler:	Default flow handler associated with this chip
+ * @hwirq_cnt:	Number of hw irqs for the domain
+ * @flags:	Flags for initialization
+ * @clr:	IRQ_* bits to clear
+ * @set:	IRQ_* bits to set
+ * @gc_init_cb:	Init callback function called for each generic irq chip created
+ * @private	Ptr to caller private data
+ *
+ * Set up an irq domain and N banks of 32 interrupts starting from gc->irq_base.
+ * Note, this initializes all interrupts to the primary irq_chip_type and its
+ * associated handler.
+ */
+int irq_setup_generic_chip_domain(const char *name, struct device_node *node,
+				int num_ct, unsigned int irq_base,
+				void __iomem *reg_base,
+				irq_flow_handler_t handler, u32 hwirq_cnt,
+				enum irq_gc_flags flags, unsigned int clr,
+				unsigned int set,
+				void (*gc_init_cb)(struct irq_chip_generic *),
+				void *private)
+{
+	int ret, i;
+	struct irq_chip_generic **gc;
+	struct irq_domain *d;
+	int num_gc = ALIGN(hwirq_cnt, 32) / 32;
+
+	gc = kzalloc(num_gc * sizeof(struct irq_chip_generic *), GFP_KERNEL);
+	if (!gc)
+		return -ENOMEM;
+
+	for (i = 0; i < num_gc; i++) {
+		gc[i] = irq_alloc_generic_chip(name, num_ct, irq_base,
+			       reg_base, handler);
+		if (!gc[i]) {
+			ret = -ENOMEM;
+			goto err;
+		}
+		gc[i]->hwirq_base = i * 32;
+		gc[i]->private = private;
+
+		gc_init_cb(gc[i]);
+
+		irq_setup_generic_chip(gc[i], 0, flags, clr, set);
+	}
+
+	if (node)
+		d = irq_domain_add_linear(node, hwirq_cnt,
+					  &irq_gc_irq_domain_ops, gc);
+	else
+		d = irq_domain_add_legacy(node, hwirq_cnt, irq_base, 0,
+					  &irq_gc_irq_domain_ops, gc);
+
+	for (i = 0; i < num_gc; i++)
+		gc[i]->domain = d;
+
+	return 0;
+
+ err:
+	for ( ; i >= 0; i--)
+		kfree(gc[i]);
+	kfree(gc);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(irq_setup_generic_chip_domain);
+#endif
+
 /**
  * irq_setup_alt_chip - Switch to alternative chip
  * @d:		irq_data for this interrupt
@@ -324,9 +429,10 @@ static int irq_gc_suspend(void)
 
 	list_for_each_entry(gc, &gc_list, list) {
 		struct irq_chip_type *ct = gc->chip_types;
+		struct irq_data *data = irq_get_irq_data(gc->irq_base);
 
-		if (ct->chip.irq_suspend)
-			ct->chip.irq_suspend(irq_get_irq_data(gc->irq_base));
+		if (ct->chip.irq_suspend && data)
+			ct->chip.irq_suspend(data);
 	}
 	return 0;
 }
@@ -337,9 +443,10 @@ static void irq_gc_resume(void)
 
 	list_for_each_entry(gc, &gc_list, list) {
 		struct irq_chip_type *ct = gc->chip_types;
+		struct irq_data *data = irq_get_irq_data(gc->irq_base);
 
-		if (ct->chip.irq_resume)
-			ct->chip.irq_resume(irq_get_irq_data(gc->irq_base));
+		if (ct->chip.irq_resume && data)
+			ct->chip.irq_resume(data);
 	}
 }
 #else
@@ -353,9 +460,10 @@ static void irq_gc_shutdown(void)
 
 	list_for_each_entry(gc, &gc_list, list) {
 		struct irq_chip_type *ct = gc->chip_types;
+		struct irq_data *data = irq_get_irq_data(gc->irq_base);
 
-		if (ct->chip.irq_pm_shutdown)
-			ct->chip.irq_pm_shutdown(irq_get_irq_data(gc->irq_base));
+		if (ct->chip.irq_pm_shutdown && data)
+			ct->chip.irq_pm_shutdown(data);
 	}
 }
 
-- 
1.7.5.4

