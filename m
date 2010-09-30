Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab0I3XQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:16:15 -0400
Received: from www.tglx.de ([62.245.132.106]:52525 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174Ab0I3XQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:16:10 -0400
Message-Id: <20100930221739.858896807@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:15:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 14/47] genirq: Implement a sane sparse_irq allocator
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline;
	filename=genirq-sparse-implement-sane-allocation-function.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current sparse_irq allocator has several short comings due to
failures in the design or the lack of it:

 - Requires iteration over the number of active irqs to find a free slot
   (Some architectures have grown their own workarounds for this)
 - Removal of entries is not possible
 - Racy between create_irq_nr and destroy_irq (plugged by horrible
   callbacks)
 - Migration of active irq descriptors is not possible
 - No bulk allocation of irq ranges
 - Sprinkeled irq_desc references all over the place outside of kernel/irq/
   (The previous chip functions series is addressing this issue)

Implement a sane allocator which fixes the above short comings (though
migration of active descriptors needs a full tree wide cleanup of the
direct and mostly unlocked access to irq_desc).

The new allocator still uses a radix_tree, but uses a bitmap for
keeping track of allocated irq numbers. That allows:

 - Fast lookup of a free slot
 - Allows the removal of descriptors
 - Prevents the create/destroy race
 - Bulk allocation of consecutive irq ranges
 - Basic design is ready for migration of life descriptors after
   further cleanups

The bitmap is also used in the SPARSE_IRQ=n case for lookup and
raceless (de)allocation of irq numbers. So it removes the requirement
for looping through the descriptor array to find slots.

Right now it uses sparse_irq_lock to protect the bitmap and the radix
tree, but after cleaning up all users we should be able convert that
to a mutex and to switch the radix_tree and decriptor allocations to
GFP_KERNEL.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h  |   25 +++++
 kernel/irq/irqdesc.c |  226 +++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 243 insertions(+), 8 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -276,6 +276,31 @@ static inline struct irq_desc *move_irq_
 
 extern struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node);
 
+int irq_alloc_descs(unsigned int irq, unsigned int from, unsigned int cnt, int node);
+
+static inline int irq_alloc_desc(int node)
+{
+	return irq_alloc_descs(0, 0, 1, node);
+}
+
+static inline int
+irq_alloc_desc_at(unsigned int at, int node)
+{
+	return irq_alloc_descs(at, 0, 1, node);
+}
+
+static inline int
+irq_alloc_desc_from(unsigned int from, int node)
+{
+	return irq_alloc_descs(0, from, 1, node);
+}
+
+void irq_free_descs(unsigned int irq, unsigned int cnt);
+static inline void irq_free_desc(unsigned int irq)
+{
+	irq_free_descs(irq, 1);
+}
+
 /*
  * Pick up the arch-dependent methods:
  */
Index: linux-2.6-tip/kernel/irq/irqdesc.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/irqdesc.c
+++ linux-2.6-tip/kernel/irq/irqdesc.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/radix-tree.h>
+#include <linux/bitmap.h>
 
 #include "internals.h"
 
@@ -33,9 +34,55 @@ static void __init init_irq_default_affi
 }
 #endif
 
+#ifdef CONFIG_SMP
+static int alloc_masks(struct irq_desc *desc, gfp_t gfp, int node)
+{
+	if (!zalloc_cpumask_var_node(&desc->affinity, gfp, node))
+		return -ENOMEM;
+
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	if (!zalloc_cpumask_var_node(&desc->pending_mask, gfp, node)) {
+		free_cpumask_var(desc->affinity);
+		return -ENOMEM;
+	}
+#endif
+	return 0;
+}
+
+static void desc_smp_init(struct irq_desc *desc, int node)
+{
+	desc->node = node;
+	desc->irq_data.affinity = &desc->affinity;
+	cpumask_copy(desc->affinity, irq_default_affinity);
+}
+
+#else
+static inline int
+alloc_masks(struct irq_desc *desc, gfp_t gfp, int node) { return 0; }
+static inline void desc_smp_init(struct irq_desc *desc, int node) { }
+#endif
+
+static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node)
+{
+	memset(&desc->irq_data, 0 , sizeof(desc->irq_data));
+	desc->irq = irq;
+	desc->irq_data.irq = irq;
+	desc->status = IRQ_DEFAULT_INIT_FLAGS;
+	desc->chip = &no_irq_chip;
+	desc->irq_data.chip = &no_irq_chip;
+	desc->handle_irq = handle_bad_irq;
+	desc->depth = 1;
+	desc->name = NULL;
+	memset(desc->kstat_irqs, 0, nr_cpu_ids * sizeof(*(desc->kstat_irqs)));
+	desc_smp_init(desc, node);
+}
+
 int nr_irqs = NR_IRQS;
 EXPORT_SYMBOL_GPL(nr_irqs);
 
+DEFINE_RAW_SPINLOCK(sparse_irq_lock);
+static DECLARE_BITMAP(allocated_irqs, NR_IRQS);
+
 #ifdef CONFIG_SPARSE_IRQ
 
 static struct irq_desc irq_desc_init = {
@@ -90,14 +137,9 @@ static void init_one_irq_desc(int irq, s
 	arch_init_chip_data(desc, node);
 }
 
-/*
- * Protect the sparse_irqs:
- */
-DEFINE_RAW_SPINLOCK(sparse_irq_lock);
-
 static RADIX_TREE(irq_desc_tree, GFP_ATOMIC);
 
-static void set_irq_desc(unsigned int irq, struct irq_desc *desc)
+static void irq_insert_desc(unsigned int irq, struct irq_desc *desc)
 {
 	radix_tree_insert(&irq_desc_tree, irq, desc);
 }
@@ -116,6 +158,93 @@ void replace_irq_desc(unsigned int irq, 
 		radix_tree_replace_slot(ptr, desc);
 }
 
+static void delete_irq_desc(unsigned int irq)
+{
+	radix_tree_delete(&irq_desc_tree, irq);
+}
+
+#ifdef CONFIG_SMP
+static void free_masks(struct irq_desc *desc)
+{
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	free_cpumask_var(desc->pending_mask);
+#endif
+	free_cpumask_var(desc->affinity);
+}
+#else
+static inline void free_masks(struct irq_desc *desc) { }
+#endif
+
+static struct irq_desc *alloc_desc(int irq, int node)
+{
+	struct irq_desc *desc;
+	gfp_t gfp = GFP_KERNEL;
+
+	desc = kzalloc_node(sizeof(*desc), gfp, node);
+	if (!desc)
+		return NULL;
+	desc->kstat_irqs = kzalloc_node(sizeof(*desc->kstat_irqs), gfp, node);
+	if (!desc)
+		goto err_desc;
+
+	if (alloc_masks(desc, gfp, node))
+		goto err_kstat;
+
+	raw_spin_lock_init(&desc->lock);
+	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
+
+	desc_set_defaults(irq, desc, node);
+
+	desc_smp_init(desc, node);
+	return desc;
+
+err_kstat:
+	kfree(desc->kstat_irqs);
+err_desc:
+	kfree(desc);
+	return NULL;
+}
+
+static void free_desc(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
+	delete_irq_desc(irq);
+	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
+
+	free_masks(desc);
+	kfree(desc->kstat_irqs);
+	kfree(desc);
+}
+
+static int alloc_descs(unsigned int start, unsigned int cnt, int node)
+{
+	struct irq_desc *desc;
+	unsigned long flags;
+	int i;
+
+	for (i = 0; i < cnt; i++) {
+		desc = alloc_desc(start + i, node);
+		if (!desc)
+			goto err;
+		raw_spin_lock_irqsave(&sparse_irq_lock, flags);
+		irq_insert_desc(start + i, desc);
+		raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
+	}
+	return start;
+
+err:
+	for (i--; i >= 0; i--)
+		free_desc(start + i);
+
+	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
+	bitmap_clear(allocated_irqs, start, cnt);
+	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
+	return -ENOMEM;
+}
+
 static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS_LEGACY-1] = {
 		.irq	    = -1,
@@ -162,7 +291,7 @@ int __init early_irq_init(void)
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
 		alloc_desc_masks(&desc[i], node, true);
 		init_desc_masks(&desc[i]);
-		set_irq_desc(i, &desc[i]);
+		irq_insert_desc(i, &desc[i]);
 	}
 
 	return arch_early_irq_init();
@@ -199,7 +328,7 @@ struct irq_desc * __ref irq_to_desc_allo
 	}
 	init_one_irq_desc(irq, desc, node);
 
-	set_irq_desc(irq, desc);
+	irq_insert_desc(irq, desc);
 
 out_unlock:
 	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
@@ -257,8 +386,89 @@ struct irq_desc *irq_to_desc_alloc_node(
 {
 	return irq_to_desc(irq);
 }
+
+static void free_desc(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+#ifdef CONFIG_SMP
+	desc_set_defaults(irq, desc, desc->node);
+#else
+	desc_set_defaults(irq, desc, 0);
+#endif
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+}
+
+static inline int alloc_descs(unsigned int start, unsigned int cnt, int node)
+{
+	return start;
+}
 #endif /* !CONFIG_SPARSE_IRQ */
 
+/* Dynamic interrupt handling */
+
+/**
+ * irq_free_descs - free irq descriptors
+ * @from:	Start of descriptor range
+ * @cnt:	Number of consecutive irqs to free
+ */
+void irq_free_descs(unsigned int from, unsigned int cnt)
+{
+	unsigned long flags;
+	int i;
+
+	if (from >= nr_irqs || (from + cnt) > nr_irqs)
+		return;
+
+	for (i = 0; i < cnt; i++)
+		free_desc(from + i);
+
+	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
+	bitmap_clear(allocated_irqs, from, cnt);
+	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
+}
+
+/**
+ * irq_alloc_descs - allocate and initialize a range of irq descriptors
+ * @irq:	Allocate for specific irq number if irq > 0
+ * @from:	Start the search from this irq number
+ * @cnt:	Number of consecutive irqs to allocate.
+ * @node:	Preferred node on which the irq descriptor should be allocated
+ *
+ * Returns the first irq number or error code
+ */
+int __ref
+irq_alloc_descs(unsigned int irq, unsigned int from, unsigned int cnt, int node)
+{
+	unsigned long flags;
+	int start, ret;
+
+	if (!cnt)
+		return -EINVAL;
+
+	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
+
+	start = bitmap_find_next_zero_area(allocated_irqs, nr_irqs, from, cnt, 0);
+	ret = -EEXIST;
+	if (irq && start != irq)
+		goto err;
+
+	ret = -ENOMEM;
+	if (start >= nr_irqs)
+		goto err;
+
+	bitmap_set(allocated_irqs, start, cnt);
+	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
+	return alloc_descs(start, cnt, node);
+
+err:
+	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
+	return ret;
+}
+
+/* Statistics access */
 void clear_kstat_irqs(struct irq_desc *desc)
 {
 	memset(desc->kstat_irqs, 0, nr_cpu_ids * sizeof(*(desc->kstat_irqs)));


