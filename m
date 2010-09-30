Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab0I3XPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:15:39 -0400
Received: from www.tglx.de ([62.245.132.106]:52381 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab0I3XPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:15:36 -0400
Message-Id: <20100930221739.073217449@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:15:06 -0000
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
Subject: [patch 06/47] genirq: Distangle kernel/irq/handle.c
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline;
	filename=genirq-move-irqdesc-management-to-separate-file.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/irq/handle.c has become a dumpground for random code in random
order. Split out the irq descriptor management and the dummy irq_chip
implementation into separate files. Cleanup the include maze while at
it.

No code change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/Makefile    |    2 
 kernel/irq/dummychip.c |   67 +++++++++
 kernel/irq/handle.c    |  344 -------------------------------------------------
 kernel/irq/irqdesc.c   |  281 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 351 insertions(+), 343 deletions(-)

Index: linux-2.6-tip/kernel/irq/Makefile
===================================================================
--- linux-2.6-tip.orig/kernel/irq/Makefile
+++ linux-2.6-tip/kernel/irq/Makefile
@@ -1,5 +1,5 @@
 
-obj-y := handle.o manage.o spurious.o resend.o chip.o devres.o
+obj-y := irqdesc.o handle.o manage.o spurious.o resend.o chip.o dummychip.o devres.o
 obj-$(CONFIG_GENERIC_IRQ_PROBE) += autoprobe.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
Index: linux-2.6-tip/kernel/irq/dummychip.c
===================================================================
--- /dev/null
+++ linux-2.6-tip/kernel/irq/dummychip.c
@@ -0,0 +1,67 @@
+/*
+ * Copyright (C) 1992, 1998-2006 Linus Torvalds, Ingo Molnar
+ * Copyright (C) 2005-2006, Thomas Gleixner, Russell King
+ *
+ * This file contains the dummy interrupt chip implementation
+ */
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+
+#include "internals.h"
+
+/*
+ * What should we do if we get a hw irq event on an illegal vector?
+ * Each architecture has to answer this themself.
+ */
+static void ack_bad(struct irq_data *data)
+{
+	struct irq_desc *desc = irq_data_to_desc(data);
+
+	print_irq_desc(data->irq, desc);
+	ack_bad_irq(data->irq);
+}
+
+/*
+ * NOP functions
+ */
+static void noop(struct irq_data *data)
+{
+}
+
+static unsigned int noop_ret(struct irq_data *data)
+{
+	return 0;
+}
+
+static void compat_noop(unsigned int irq)
+{
+}
+
+/*
+ * Generic no controller implementation
+ */
+struct irq_chip no_irq_chip = {
+	.name		= "none",
+	.irq_startup	= noop_ret,
+	.irq_shutdown	= noop,
+	.irq_enable	= noop,
+	.irq_disable	= noop,
+	.irq_ack	= ack_bad,
+	.end		= compat_noop,
+};
+
+/*
+ * Generic dummy implementation which can be used for
+ * real dumb interrupt sources
+ */
+struct irq_chip dummy_irq_chip = {
+	.name		= "dummy",
+	.irq_startup	= noop_ret,
+	.irq_shutdown	= noop,
+	.irq_enable	= noop,
+	.irq_disable	= noop,
+	.irq_ack	= noop,
+	.irq_mask	= noop,
+	.irq_unmask	= noop,
+	.end		= compat_noop,
+};
Index: linux-2.6-tip/kernel/irq/handle.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/handle.c
+++ linux-2.6-tip/kernel/irq/handle.c
@@ -11,24 +11,15 @@
  */
 
 #include <linux/irq.h>
-#include <linux/sched.h>
-#include <linux/slab.h>
-#include <linux/module.h>
 #include <linux/random.h>
+#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
-#include <linux/rculist.h>
-#include <linux/hash.h>
-#include <linux/radix-tree.h>
+
 #include <trace/events/irq.h>
 
 #include "internals.h"
 
-/*
- * lockdep: we want to handle all irq_desc locks as a single lock-class:
- */
-struct lock_class_key irq_desc_lock_class;
-
 /**
  * handle_bad_irq - handle spurious and unhandled irqs
  * @irq:       the interrupt number
@@ -43,319 +34,6 @@ void handle_bad_irq(unsigned int irq, st
 	ack_bad_irq(irq);
 }
 
-#if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
-static void __init init_irq_default_affinity(void)
-{
-	alloc_cpumask_var(&irq_default_affinity, GFP_NOWAIT);
-	cpumask_setall(irq_default_affinity);
-}
-#else
-static void __init init_irq_default_affinity(void)
-{
-}
-#endif
-
-/*
- * Linux has a controller-independent interrupt architecture.
- * Every controller has a 'controller-template', that is used
- * by the main code to do the right thing. Each driver-visible
- * interrupt source is transparently wired to the appropriate
- * controller. Thus drivers need not be aware of the
- * interrupt-controller.
- *
- * The code is designed to be easily extended with new/different
- * interrupt controllers, without having to do assembly magic or
- * having to touch the generic code.
- *
- * Controller mappings for all interrupt sources:
- */
-int nr_irqs = NR_IRQS;
-EXPORT_SYMBOL_GPL(nr_irqs);
-
-#ifdef CONFIG_SPARSE_IRQ
-
-static struct irq_desc irq_desc_init = {
-	.irq	    = -1,
-	.status	    = IRQ_DISABLED,
-	.chip	    = &no_irq_chip,
-	.handle_irq = handle_bad_irq,
-	.depth      = 1,
-	.lock       = __RAW_SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
-};
-
-void __ref init_kstat_irqs(struct irq_desc *desc, int node, int nr)
-{
-	void *ptr;
-
-	ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs),
-			   GFP_ATOMIC, node);
-
-	/*
-	 * don't overwite if can not get new one
-	 * init_copy_kstat_irqs() could still use old one
-	 */
-	if (ptr) {
-		printk(KERN_DEBUG "  alloc kstat_irqs on node %d\n", node);
-		desc->kstat_irqs = ptr;
-	}
-}
-
-static void init_one_irq_desc(int irq, struct irq_desc *desc, int node)
-{
-	memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
-
-	raw_spin_lock_init(&desc->lock);
-	desc->irq = irq;
-	desc->irq_data.irq = irq;
-	desc->irq_data.chip = desc->chip;
-#ifdef CONFIG_SMP
-	desc->node = node;
-	desc->irq_data.affinity = &desc->affinity;
-#endif
-	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
-	init_kstat_irqs(desc, node, nr_cpu_ids);
-	if (!desc->kstat_irqs) {
-		printk(KERN_ERR "can not alloc kstat_irqs\n");
-		BUG_ON(1);
-	}
-	if (!alloc_desc_masks(desc, node, false)) {
-		printk(KERN_ERR "can not alloc irq_desc cpumasks\n");
-		BUG_ON(1);
-	}
-	init_desc_masks(desc);
-	arch_init_chip_data(desc, node);
-}
-
-/*
- * Protect the sparse_irqs:
- */
-DEFINE_RAW_SPINLOCK(sparse_irq_lock);
-
-static RADIX_TREE(irq_desc_tree, GFP_ATOMIC);
-
-static void set_irq_desc(unsigned int irq, struct irq_desc *desc)
-{
-	radix_tree_insert(&irq_desc_tree, irq, desc);
-}
-
-struct irq_desc *irq_to_desc(unsigned int irq)
-{
-	return radix_tree_lookup(&irq_desc_tree, irq);
-}
-
-void replace_irq_desc(unsigned int irq, struct irq_desc *desc)
-{
-	void **ptr;
-
-	ptr = radix_tree_lookup_slot(&irq_desc_tree, irq);
-	if (ptr)
-		radix_tree_replace_slot(ptr, desc);
-}
-
-static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_smp = {
-	[0 ... NR_IRQS_LEGACY-1] = {
-		.irq	    = -1,
-		.status	    = IRQ_DISABLED,
-		.chip	    = &no_irq_chip,
-		.handle_irq = handle_bad_irq,
-		.depth	    = 1,
-		.lock	    = __RAW_SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
-	}
-};
-
-static unsigned int *kstat_irqs_legacy;
-
-int __init early_irq_init(void)
-{
-	struct irq_desc *desc;
-	int legacy_count;
-	int node;
-	int i;
-
-	init_irq_default_affinity();
-
-	 /* initialize nr_irqs based on nr_cpu_ids */
-	arch_probe_nr_irqs();
-	printk(KERN_INFO "NR_IRQS:%d nr_irqs:%d\n", NR_IRQS, nr_irqs);
-
-	desc = irq_desc_legacy;
-	legacy_count = ARRAY_SIZE(irq_desc_legacy);
-	node = first_online_node;
-
-	/* allocate based on nr_cpu_ids */
-	kstat_irqs_legacy = kzalloc_node(NR_IRQS_LEGACY * nr_cpu_ids *
-					  sizeof(int), GFP_NOWAIT, node);
-
-	for (i = 0; i < legacy_count; i++) {
-		desc[i].irq = i;
-		desc[i].irq_data.irq = i;
-		desc[i].irq_data.chip = desc[i].chip;
-#ifdef CONFIG_SMP
-		desc[i].node = node;
-		desc[i].irq_data.affinity = &desc[i].affinity;
-#endif
-		desc[i].kstat_irqs = kstat_irqs_legacy + i * nr_cpu_ids;
-		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
-		alloc_desc_masks(&desc[i], node, true);
-		init_desc_masks(&desc[i]);
-		set_irq_desc(i, &desc[i]);
-	}
-
-	return arch_early_irq_init();
-}
-
-struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
-{
-	struct irq_desc *desc;
-	unsigned long flags;
-
-	if (irq >= nr_irqs) {
-		WARN(1, "irq (%d) >= nr_irqs (%d) in irq_to_desc_alloc\n",
-			irq, nr_irqs);
-		return NULL;
-	}
-
-	desc = irq_to_desc(irq);
-	if (desc)
-		return desc;
-
-	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
-
-	/* We have to check it to avoid races with another CPU */
-	desc = irq_to_desc(irq);
-	if (desc)
-		goto out_unlock;
-
-	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
-
-	printk(KERN_DEBUG "  alloc irq_desc for %d on node %d\n", irq, node);
-	if (!desc) {
-		printk(KERN_ERR "can not alloc irq_desc\n");
-		BUG_ON(1);
-	}
-	init_one_irq_desc(irq, desc, node);
-
-	set_irq_desc(irq, desc);
-
-out_unlock:
-	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
-
-	return desc;
-}
-
-#else /* !CONFIG_SPARSE_IRQ */
-
-struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
-	[0 ... NR_IRQS-1] = {
-		.status = IRQ_DISABLED,
-		.chip = &no_irq_chip,
-		.handle_irq = handle_bad_irq,
-		.depth = 1,
-		.lock = __RAW_SPIN_LOCK_UNLOCKED(irq_desc->lock),
-	}
-};
-
-static unsigned int kstat_irqs_all[NR_IRQS][NR_CPUS];
-int __init early_irq_init(void)
-{
-	struct irq_desc *desc;
-	int count;
-	int i;
-
-	init_irq_default_affinity();
-
-	printk(KERN_INFO "NR_IRQS:%d\n", NR_IRQS);
-
-	desc = irq_desc;
-	count = ARRAY_SIZE(irq_desc);
-
-	for (i = 0; i < count; i++) {
-		desc[i].irq = i;
-		desc[i].irq_data.irq = i;
-		desc[i].irq_data.chip = desc[i].chip;
-#ifdef CONFIG_SMP
-		desc[i].irq_data.affinity = &desc[i].affinity;
-#endif
-		alloc_desc_masks(&desc[i], 0, true);
-		init_desc_masks(&desc[i]);
-		desc[i].kstat_irqs = kstat_irqs_all[i];
-	}
-	return arch_early_irq_init();
-}
-
-struct irq_desc *irq_to_desc(unsigned int irq)
-{
-	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
-}
-
-struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node)
-{
-	return irq_to_desc(irq);
-}
-#endif /* !CONFIG_SPARSE_IRQ */
-
-void clear_kstat_irqs(struct irq_desc *desc)
-{
-	memset(desc->kstat_irqs, 0, nr_cpu_ids * sizeof(*(desc->kstat_irqs)));
-}
-
-/*
- * What should we do if we get a hw irq event on an illegal vector?
- * Each architecture has to answer this themself.
- */
-static void ack_bad(struct irq_data *data)
-{
-	struct irq_desc *desc = irq_data_to_desc(data);
-
-	print_irq_desc(data->irq, desc);
-	ack_bad_irq(data->irq);
-}
-
-/*
- * NOP functions
- */
-static void noop(struct irq_data *data)
-{
-}
-
-static unsigned int noop_ret(struct irq_data *data)
-{
-	return 0;
-}
-
-static void compat_noop(unsigned int irq)
-{
-}
-
-/*
- * Generic no controller implementation
- */
-struct irq_chip no_irq_chip = {
-	.name		= "none",
-	.irq_startup	= noop_ret,
-	.irq_shutdown	= noop,
-	.irq_enable	= noop,
-	.irq_disable	= noop,
-	.irq_ack	= ack_bad,
-	.end		= compat_noop,
-};
-
-/*
- * Generic dummy implementation which can be used for
- * real dumb interrupt sources
- */
-struct irq_chip dummy_irq_chip = {
-	.name		= "dummy",
-	.irq_startup	= noop_ret,
-	.irq_shutdown	= noop,
-	.irq_enable	= noop,
-	.irq_disable	= noop,
-	.irq_ack	= noop,
-	.irq_mask	= noop,
-	.irq_unmask	= noop,
-	.end		= compat_noop,
-};
-
 /*
  * Special, empty irq handler:
  */
@@ -551,21 +229,3 @@ out:
 	return 1;
 }
 #endif
-
-void early_init_irq_lock_class(void)
-{
-	struct irq_desc *desc;
-	int i;
-
-	for_each_irq_desc(i, desc) {
-		lockdep_set_class(&desc->lock, &irq_desc_lock_class);
-	}
-}
-
-unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-	return desc ? desc->kstat_irqs[cpu] : 0;
-}
-EXPORT_SYMBOL(kstat_irqs_cpu);
-
Index: linux-2.6-tip/kernel/irq/irqdesc.c
===================================================================
--- /dev/null
+++ linux-2.6-tip/kernel/irq/irqdesc.c
@@ -0,0 +1,281 @@
+/*
+ * Copyright (C) 1992, 1998-2006 Linus Torvalds, Ingo Molnar
+ * Copyright (C) 2005-2006, Thomas Gleixner, Russell King
+ *
+ * This file contains the interrupt descriptor management code
+ *
+ * Detailed information is available in Documentation/DocBook/genericirq
+ *
+ */
+#include <linux/irq.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/kernel_stat.h>
+#include <linux/radix-tree.h>
+
+#include "internals.h"
+
+/*
+ * lockdep: we want to handle all irq_desc locks as a single lock-class:
+ */
+struct lock_class_key irq_desc_lock_class;
+
+#if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
+static void __init init_irq_default_affinity(void)
+{
+	alloc_cpumask_var(&irq_default_affinity, GFP_NOWAIT);
+	cpumask_setall(irq_default_affinity);
+}
+#else
+static void __init init_irq_default_affinity(void)
+{
+}
+#endif
+
+int nr_irqs = NR_IRQS;
+EXPORT_SYMBOL_GPL(nr_irqs);
+
+#ifdef CONFIG_SPARSE_IRQ
+
+static struct irq_desc irq_desc_init = {
+	.irq	    = -1,
+	.status	    = IRQ_DISABLED,
+	.chip	    = &no_irq_chip,
+	.handle_irq = handle_bad_irq,
+	.depth      = 1,
+	.lock       = __RAW_SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
+};
+
+void __ref init_kstat_irqs(struct irq_desc *desc, int node, int nr)
+{
+	void *ptr;
+
+	ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs),
+			   GFP_ATOMIC, node);
+
+	/*
+	 * don't overwite if can not get new one
+	 * init_copy_kstat_irqs() could still use old one
+	 */
+	if (ptr) {
+		printk(KERN_DEBUG "  alloc kstat_irqs on node %d\n", node);
+		desc->kstat_irqs = ptr;
+	}
+}
+
+static void init_one_irq_desc(int irq, struct irq_desc *desc, int node)
+{
+	memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
+
+	raw_spin_lock_init(&desc->lock);
+	desc->irq = irq;
+	desc->irq_data.irq = irq;
+	desc->irq_data.chip = desc->chip;
+#ifdef CONFIG_SMP
+	desc->node = node;
+	desc->irq_data.affinity = &desc->affinity;
+#endif
+	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
+	init_kstat_irqs(desc, node, nr_cpu_ids);
+	if (!desc->kstat_irqs) {
+		printk(KERN_ERR "can not alloc kstat_irqs\n");
+		BUG_ON(1);
+	}
+	if (!alloc_desc_masks(desc, node, false)) {
+		printk(KERN_ERR "can not alloc irq_desc cpumasks\n");
+		BUG_ON(1);
+	}
+	init_desc_masks(desc);
+	arch_init_chip_data(desc, node);
+}
+
+/*
+ * Protect the sparse_irqs:
+ */
+DEFINE_RAW_SPINLOCK(sparse_irq_lock);
+
+static RADIX_TREE(irq_desc_tree, GFP_ATOMIC);
+
+static void set_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	radix_tree_insert(&irq_desc_tree, irq, desc);
+}
+
+struct irq_desc *irq_to_desc(unsigned int irq)
+{
+	return radix_tree_lookup(&irq_desc_tree, irq);
+}
+
+void replace_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	void **ptr;
+
+	ptr = radix_tree_lookup_slot(&irq_desc_tree, irq);
+	if (ptr)
+		radix_tree_replace_slot(ptr, desc);
+}
+
+static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_smp = {
+	[0 ... NR_IRQS_LEGACY-1] = {
+		.irq	    = -1,
+		.status	    = IRQ_DISABLED,
+		.chip	    = &no_irq_chip,
+		.handle_irq = handle_bad_irq,
+		.depth	    = 1,
+		.lock	    = __RAW_SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
+	}
+};
+
+static unsigned int *kstat_irqs_legacy;
+
+int __init early_irq_init(void)
+{
+	struct irq_desc *desc;
+	int legacy_count;
+	int node;
+	int i;
+
+	init_irq_default_affinity();
+
+	 /* initialize nr_irqs based on nr_cpu_ids */
+	arch_probe_nr_irqs();
+	printk(KERN_INFO "NR_IRQS:%d nr_irqs:%d\n", NR_IRQS, nr_irqs);
+
+	desc = irq_desc_legacy;
+	legacy_count = ARRAY_SIZE(irq_desc_legacy);
+	node = first_online_node;
+
+	/* allocate based on nr_cpu_ids */
+	kstat_irqs_legacy = kzalloc_node(NR_IRQS_LEGACY * nr_cpu_ids *
+					  sizeof(int), GFP_NOWAIT, node);
+
+	for (i = 0; i < legacy_count; i++) {
+		desc[i].irq = i;
+		desc[i].irq_data.irq = i;
+		desc[i].irq_data.chip = desc[i].chip;
+#ifdef CONFIG_SMP
+		desc[i].node = node;
+		desc[i].irq_data.affinity = &desc[i].affinity;
+#endif
+		desc[i].kstat_irqs = kstat_irqs_legacy + i * nr_cpu_ids;
+		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
+		alloc_desc_masks(&desc[i], node, true);
+		init_desc_masks(&desc[i]);
+		set_irq_desc(i, &desc[i]);
+	}
+
+	return arch_early_irq_init();
+}
+
+struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
+{
+	struct irq_desc *desc;
+	unsigned long flags;
+
+	if (irq >= nr_irqs) {
+		WARN(1, "irq (%d) >= nr_irqs (%d) in irq_to_desc_alloc\n",
+			irq, nr_irqs);
+		return NULL;
+	}
+
+	desc = irq_to_desc(irq);
+	if (desc)
+		return desc;
+
+	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
+
+	/* We have to check it to avoid races with another CPU */
+	desc = irq_to_desc(irq);
+	if (desc)
+		goto out_unlock;
+
+	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
+
+	printk(KERN_DEBUG "  alloc irq_desc for %d on node %d\n", irq, node);
+	if (!desc) {
+		printk(KERN_ERR "can not alloc irq_desc\n");
+		BUG_ON(1);
+	}
+	init_one_irq_desc(irq, desc, node);
+
+	set_irq_desc(irq, desc);
+
+out_unlock:
+	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
+
+	return desc;
+}
+
+#else /* !CONFIG_SPARSE_IRQ */
+
+struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
+	[0 ... NR_IRQS-1] = {
+		.status = IRQ_DISABLED,
+		.chip = &no_irq_chip,
+		.handle_irq = handle_bad_irq,
+		.depth = 1,
+		.lock = __RAW_SPIN_LOCK_UNLOCKED(irq_desc->lock),
+	}
+};
+
+static unsigned int kstat_irqs_all[NR_IRQS][NR_CPUS];
+int __init early_irq_init(void)
+{
+	struct irq_desc *desc;
+	int count;
+	int i;
+
+	init_irq_default_affinity();
+
+	printk(KERN_INFO "NR_IRQS:%d\n", NR_IRQS);
+
+	desc = irq_desc;
+	count = ARRAY_SIZE(irq_desc);
+
+	for (i = 0; i < count; i++) {
+		desc[i].irq = i;
+		desc[i].irq_data.irq = i;
+		desc[i].irq_data.chip = desc[i].chip;
+#ifdef CONFIG_SMP
+		desc[i].irq_data.affinity = &desc[i].affinity;
+#endif
+		alloc_desc_masks(&desc[i], 0, true);
+		init_desc_masks(&desc[i]);
+		desc[i].kstat_irqs = kstat_irqs_all[i];
+	}
+	return arch_early_irq_init();
+}
+
+struct irq_desc *irq_to_desc(unsigned int irq)
+{
+	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
+}
+
+struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node)
+{
+	return irq_to_desc(irq);
+}
+#endif /* !CONFIG_SPARSE_IRQ */
+
+void clear_kstat_irqs(struct irq_desc *desc)
+{
+	memset(desc->kstat_irqs, 0, nr_cpu_ids * sizeof(*(desc->kstat_irqs)));
+}
+
+void early_init_irq_lock_class(void)
+{
+	struct irq_desc *desc;
+	int i;
+
+	for_each_irq_desc(i, desc) {
+		lockdep_set_class(&desc->lock, &irq_desc_lock_class);
+	}
+}
+
+unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	return desc ? desc->kstat_irqs[cpu] : 0;
+}
+EXPORT_SYMBOL(kstat_irqs_cpu);


