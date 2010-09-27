Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355Ab0I0MtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:49:15 -0400
Received: from www.tglx.de ([62.245.132.106]:34538 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759116Ab0I0Mo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:44:58 -0400
Message-Id: <20100927121841.645542300@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 27 Sep 2010 12:44:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 02/19] genirq: Create irq_data
References: <20100927121651.904100669@linutronix.de>
Content-Disposition: inline; filename=genirq-create-irq-data.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Low level chip functions need access to irq_desc->handler_data,
irq_desc->chip_data and irq_desc->msi_desc. We hand down the irq
number to the low level functions, so they need to lookup irq_desc.
With sparse irq this means a radix tree lookup.

We could hand down irq_desc itself, but low level chip functions have
no need to fiddle with it directly and we want to restrict access to
irq_desc further.

Preparatory patch for new chip functions.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |   48 ++++++++++++++++++++++++++++++++----------------
 kernel/irq/chip.c   |   22 +++++++++++++---------
 kernel/irq/handle.c |   11 +++++++++++
 3 files changed, 56 insertions(+), 25 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -84,6 +84,27 @@ struct proc_dir_entry;
 struct msi_desc;
 
 /**
+ * struct irq_data - per irq and irq chip data passed down to chip functions
+ * @irq:		interrupt number
+ * @chip:		low level interrupt hardware access
+ * @handler_data:	per-IRQ data for the irq_chip methods
+ * @chip_data:		platform-specific per-chip private data for the chip
+ *			methods, to allow shared chip implementations
+ * @msi_desc:		MSI descriptor
+ * @affinity:		pointer to irq affinity mask
+ */
+struct irq_data {
+	unsigned int		irq;
+	struct irq_chip		*chip;
+	void			*handler_data;
+	void			*chip_data;
+	struct msi_desc		*msi_desc;
+#ifdef CONFIG_SMP
+	cpumask_var_t		*affinity;
+#endif
+};
+
+/**
  * struct irq_chip - hardware interrupt chip descriptor
  *
  * @name:		name for /proc/interrupts
@@ -146,10 +167,7 @@ struct irq_2_iommu;
  * @irq_2_iommu:	iommu with this irq
  * @handle_irq:		highlevel irq-events handler [if NULL, __do_IRQ()]
  * @chip:		low level interrupt hardware access
- * @msi_desc:		MSI descriptor
- * @handler_data:	per-IRQ data for the irq_chip methods
- * @chip_data:		platform-specific per-chip private data for the chip
- *			methods, to allow shared chip implementations
+ * @irq_data:		per irq and chip data passed down to chip functions
  * @action:		the irq action chain
  * @status:		status information
  * @depth:		disable-depth, for nested irq_disable() calls
@@ -175,9 +193,7 @@ struct irq_desc {
 #endif
 	irq_flow_handler_t	handle_irq;
 	struct irq_chip		*chip;
-	struct msi_desc		*msi_desc;
-	void			*handler_data;
-	void			*chip_data;
+	struct irq_data		irq_data;
 	struct irqaction	*action;	/* IRQ action list */
 	unsigned int		status;		/* IRQ status */
 
@@ -408,18 +424,18 @@ extern int set_irq_msi(unsigned int irq,
 
 static inline void set_irq_desc_chip_data(struct irq_desc *desc, void *data)
 {
-	desc->chip_data = data;
+	desc->irq_data.chip_data = data;
 }
 
 #define get_irq_chip(irq)	(irq_to_desc(irq)->chip)
-#define get_irq_chip_data(irq)	(irq_to_desc(irq)->chip_data)
-#define get_irq_data(irq)	(irq_to_desc(irq)->handler_data)
-#define get_irq_msi(irq)	(irq_to_desc(irq)->msi_desc)
-
-#define get_irq_desc_chip(desc)		((desc)->chip)
-#define get_irq_desc_chip_data(desc)	((desc)->chip_data)
-#define get_irq_desc_data(desc)		((desc)->handler_data)
-#define get_irq_desc_msi(desc)		((desc)->msi_desc)
+#define get_irq_chip_data(irq)	(irq_to_desc(irq)->irq_data.chip_data)
+#define get_irq_data(irq)	(irq_to_desc(irq)->irq_data.handler_data)
+#define get_irq_msi(irq)	(irq_to_desc(irq)->irq_data.msi_desc)
+
+#define get_irq_desc_chip(desc)		((desc)->irq_data.chip)
+#define get_irq_desc_chip_data(desc)	((desc)->irq_data.chip_data)
+#define get_irq_desc_data(desc)		((desc)->irq_data.handler_data)
+#define get_irq_desc_msi(desc)		((desc)->irq_data.msi_desc)
 
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -33,12 +33,13 @@ static void dynamic_irq_init_x(unsigned 
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	desc->status = IRQ_DISABLED;
 	desc->chip = &no_irq_chip;
+	desc->irq_data.chip = &no_irq_chip;
 	desc->handle_irq = handle_bad_irq;
 	desc->depth = 1;
-	desc->msi_desc = NULL;
-	desc->handler_data = NULL;
+	desc->irq_data.msi_desc = NULL;
+	desc->irq_data.handler_data = NULL;
 	if (!keep_chip_data)
-		desc->chip_data = NULL;
+		desc->irq_data.chip_data = NULL;
 	desc->action = NULL;
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
@@ -88,12 +89,13 @@ static void dynamic_irq_cleanup_x(unsign
 			irq);
 		return;
 	}
-	desc->msi_desc = NULL;
-	desc->handler_data = NULL;
+	desc->irq_data.msi_desc = NULL;
+	desc->irq_data.handler_data = NULL;
 	if (!keep_chip_data)
-		desc->chip_data = NULL;
+		desc->irq_data.chip_data = NULL;
 	desc->handle_irq = handle_bad_irq;
 	desc->chip = &no_irq_chip;
+	desc->irq_data.chip = &no_irq_chip;
 	desc->name = NULL;
 	clear_kstat_irqs(desc);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
@@ -141,6 +143,7 @@ int set_irq_chip(unsigned int irq, struc
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	irq_chip_set_defaults(chip);
 	desc->chip = chip;
+	desc->irq_data.chip = chip;
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 	return 0;
@@ -193,7 +196,7 @@ int set_irq_data(unsigned int irq, void 
 	}
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	desc->handler_data = data;
+	desc->irq_data.handler_data = data;
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return 0;
 }
@@ -218,7 +221,7 @@ int set_irq_msi(unsigned int irq, struct
 	}
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	desc->msi_desc = entry;
+	desc->irq_data.msi_desc = entry;
 	if (entry)
 		entry->irq = irq;
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
@@ -249,7 +252,7 @@ int set_irq_chip_data(unsigned int irq, 
 	}
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	desc->chip_data = data;
+	desc->irq_data.chip_data = data;
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 	return 0;
@@ -685,6 +688,7 @@ __set_irq_handler(unsigned int irq, irq_
 		 * dummy_irq_chip for easy transition.
 		 */
 		desc->chip = &dummy_irq_chip;
+		desc->irq_data.chip = &dummy_irq_chip;
 	}
 
 	chip_bus_lock(irq, desc);
Index: linux-2.6-tip/kernel/irq/handle.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/handle.c
+++ linux-2.6-tip/kernel/irq/handle.c
@@ -106,8 +106,11 @@ static void init_one_irq_desc(int irq, s
 
 	raw_spin_lock_init(&desc->lock);
 	desc->irq = irq;
+	desc->irq_data.irq = irq;
+	desc->irq_data.chip = desc->chip;
 #ifdef CONFIG_SMP
 	desc->node = node;
+	desc->irq_data.affinity = &desc->affinity;
 #endif
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 	init_kstat_irqs(desc, node, nr_cpu_ids);
@@ -185,8 +188,11 @@ int __init early_irq_init(void)
 
 	for (i = 0; i < legacy_count; i++) {
 		desc[i].irq = i;
+		desc[i].irq_data.irq = i;
+		desc[i].irq_data.chip = desc[i].chip;
 #ifdef CONFIG_SMP
 		desc[i].node = node;
+		desc[i].irq_data.affinity = &desc[i].affinity;
 #endif
 		desc[i].kstat_irqs = kstat_irqs_legacy + i * nr_cpu_ids;
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
@@ -265,6 +271,11 @@ int __init early_irq_init(void)
 
 	for (i = 0; i < count; i++) {
 		desc[i].irq = i;
+		desc[i].irq_data.irq = i;
+		desc[i].irq_data.chip = desc[i].chip;
+#ifdef CONFIG_SMP
+		desc[i].irq_data.affinity = &desc[i].affinity;
+#endif
 		alloc_desc_masks(&desc[i], 0, true);
 		init_desc_masks(&desc[i]);
 		desc[i].kstat_irqs = kstat_irqs_all[i];


