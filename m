Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab0I3XSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:18:42 -0400
Received: from www.tglx.de ([62.245.132.106]:43562 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab0I3XSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:18:37 -0400
Message-Id: <20100930221742.618268936@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:18:06 -0000
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
Subject: [patch 42/47] genirq: Remove the now unused sparse irq leftovers
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=genirq-remove-the-gunk.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The move_irq_desc() function was only used due to the problem that the
allocator did not free the old descriptors. So the descriptors had to
be moved in create_irq_nr(). That's history.

The code would have never been able to move active interrupt
descriptors on affinity settings. That can be done in a completely
different way w/o all this horror.

Remove all of it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig          |    1 
 include/linux/irq.h       |   19 -------
 kernel/irq/Kconfig        |    5 -
 kernel/irq/Makefile       |    1 
 kernel/irq/internals.h    |   86 --------------------------------
 kernel/irq/irqdesc.c      |   30 -----------
 kernel/irq/numa_migrate.c |  120 ----------------------------------------------
 7 files changed, 2 insertions(+), 260 deletions(-)

Index: linux-2.6-tip/arch/x86/Kconfig
===================================================================
--- linux-2.6-tip.orig/arch/x86/Kconfig
+++ linux-2.6-tip/arch/x86/Kconfig
@@ -61,7 +61,6 @@ config X86
 	select HAVE_USER_RETURN_NOTIFIER
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
-	select NUMA_IRQ_DESC if (SPARSE_IRQ && NUMA)
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 
Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -257,23 +257,10 @@ struct irq_desc {
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
-extern void arch_init_copy_chip_data(struct irq_desc *old_desc,
-					struct irq_desc *desc, int node);
-extern void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc);
-
 #ifndef CONFIG_SPARSE_IRQ
 extern struct irq_desc irq_desc[NR_IRQS];
 #endif
 
-#ifdef CONFIG_NUMA_IRQ_DESC
-extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int node);
-#else
-static inline struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
-{
-	return desc;
-}
-#endif
-
 extern struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node);
 
 int irq_alloc_descs(unsigned int irq, unsigned int from, unsigned int cnt, int node);
@@ -539,12 +526,6 @@ static inline struct msi_desc *get_irq_m
 	return d ? d->msi_desc : NULL;
 }
 
-/* Needs to die ! */
-static inline void set_irq_desc_chip_data(struct irq_desc *desc, void *data)
-{
-	desc->irq_data.chip_data = data;
-}
-
 #define get_irq_desc_chip(desc)		((desc)->irq_data.chip)
 #define get_irq_desc_chip_data(desc)	((desc)->irq_data.chip_data)
 #define get_irq_desc_data(desc)		((desc)->irq_data.handler_data)
Index: linux-2.6-tip/kernel/irq/Kconfig
===================================================================
--- linux-2.6-tip.orig/kernel/irq/Kconfig
+++ linux-2.6-tip/kernel/irq/Kconfig
@@ -22,11 +22,6 @@ config GENERIC_IRQ_PROBE
 config GENERIC_PENDING_IRQ
 	def_bool n
 
-if SPARSE_IRQ && NUMA
-config NUMA_IRQ_DESC
-	def_bool n
-endif
-
 config AUTO_IRQ_AFFINITY
        def_bool n
 
Index: linux-2.6-tip/kernel/irq/Makefile
===================================================================
--- linux-2.6-tip.orig/kernel/irq/Makefile
+++ linux-2.6-tip/kernel/irq/Makefile
@@ -3,5 +3,4 @@ obj-y := irqdesc.o handle.o manage.o spu
 obj-$(CONFIG_GENERIC_IRQ_PROBE) += autoprobe.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
-obj-$(CONFIG_NUMA_IRQ_DESC) += numa_migrate.o
 obj-$(CONFIG_PM_SLEEP) += pm.o
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -15,14 +15,6 @@ extern int __irq_set_trigger(struct irq_
 extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool susp);
 extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
 
-extern struct lock_class_key irq_desc_lock_class;
-extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
-extern raw_spinlock_t sparse_irq_lock;
-
-#ifdef CONFIG_SPARSE_IRQ
-void replace_irq_desc(unsigned int irq, struct irq_desc *desc);
-#endif
-
 #ifdef CONFIG_PROC_FS
 extern void register_irq_proc(unsigned int irq, struct irq_desc *desc);
 extern void unregister_irq_proc(unsigned int irq, struct irq_desc *desc);
@@ -59,84 +51,6 @@ static inline struct irq_desc *irq_data_
 	return container_of(data, struct irq_desc, irq_data);
 }
 
-#ifdef CONFIG_SMP
-/**
- * alloc_desc_masks - allocate cpumasks for irq_desc
- * @desc:	pointer to irq_desc struct
- * @node:	node which will be handling the cpumasks
- * @boot:	true if need bootmem
- *
- * Allocates affinity and pending_mask cpumask if required.
- * Returns true if successful (or not required).
- */
-static inline bool alloc_desc_masks(struct irq_desc *desc, int node,
-							bool boot)
-{
-#ifdef CONFIG_CPUMASK_OFFSTACK
-	gfp_t gfp = boot ? GFP_NOWAIT : GFP_ATOMIC;
-
-	if (!alloc_cpumask_var_node(&desc->affinity, gfp, node))
-		return false;
-
-#ifdef CONFIG_GENERIC_PENDING_IRQ
-	if (!alloc_cpumask_var_node(&desc->pending_mask, gfp, node)) {
-		free_cpumask_var(desc->affinity);
-		return false;
-	}
-#endif
-#endif
-	return true;
-}
-
-static inline void init_desc_masks(struct irq_desc *desc)
-{
-	cpumask_setall(desc->affinity);
-#ifdef CONFIG_GENERIC_PENDING_IRQ
-	cpumask_clear(desc->pending_mask);
-#endif
-}
-
-/**
- * init_copy_desc_masks - copy cpumasks for irq_desc
- * @old_desc:	pointer to old irq_desc struct
- * @new_desc:	pointer to new irq_desc struct
- *
- * Insures affinity and pending_masks are copied to new irq_desc.
- * If !CONFIG_CPUMASKS_OFFSTACK the cpumasks are embedded in the
- * irq_desc struct so the copy is redundant.
- */
-
-static inline void init_copy_desc_masks(struct irq_desc *old_desc,
-					struct irq_desc *new_desc)
-{
-#ifdef CONFIG_CPUMASK_OFFSTACK
-	cpumask_copy(new_desc->affinity, old_desc->affinity);
-
-#ifdef CONFIG_GENERIC_PENDING_IRQ
-	cpumask_copy(new_desc->pending_mask, old_desc->pending_mask);
-#endif
-#endif
-}
-
-static inline void free_desc_masks(struct irq_desc *old_desc,
-				   struct irq_desc *new_desc)
-{
-	free_cpumask_var(old_desc->affinity);
-#ifdef CONFIG_GENERIC_PENDING_IRQ
-	free_cpumask_var(old_desc->pending_mask);
-#endif
-}
-
-#else /* !CONFIG_SMP */
-static inline bool alloc_desc_masks(struct irq_desc *desc, int node, bool boot)
-{
-	return true;
-}
-static inline void init_desc_masks(struct irq_desc *desc) { }
-static inline void init_copy_desc_masks(struct irq_desc *o, struct irq_desc *n) { }
-static inline void free_desc_masks(struct irq_desc *o, struct irq_desc *n) { }
-#endif	/* CONFIG_SMP */
-
 /*
  * Debugging printout:
  */
Index: linux-2.6-tip/kernel/irq/irqdesc.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/irqdesc.c
+++ linux-2.6-tip/kernel/irq/irqdesc.c
@@ -20,7 +20,7 @@
 /*
  * lockdep: we want to handle all irq_desc locks as a single lock-class:
  */
-struct lock_class_key irq_desc_lock_class;
+static struct lock_class_key irq_desc_lock_class;
 
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
 static void __init init_irq_default_affinity(void)
@@ -85,28 +85,11 @@ static void desc_set_defaults(unsigned i
 int nr_irqs = NR_IRQS;
 EXPORT_SYMBOL_GPL(nr_irqs);
 
-DEFINE_RAW_SPINLOCK(sparse_irq_lock);
+static DEFINE_RAW_SPINLOCK(sparse_irq_lock);
 static DECLARE_BITMAP(allocated_irqs, NR_IRQS);
 
 #ifdef CONFIG_SPARSE_IRQ
 
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
 static RADIX_TREE(irq_desc_tree, GFP_ATOMIC);
 
 static void irq_insert_desc(unsigned int irq, struct irq_desc *desc)
@@ -119,15 +102,6 @@ struct irq_desc *irq_to_desc(unsigned in
 	return radix_tree_lookup(&irq_desc_tree, irq);
 }
 
-void replace_irq_desc(unsigned int irq, struct irq_desc *desc)
-{
-	void **ptr;
-
-	ptr = radix_tree_lookup_slot(&irq_desc_tree, irq);
-	if (ptr)
-		radix_tree_replace_slot(ptr, desc);
-}
-
 static void delete_irq_desc(unsigned int irq)
 {
 	radix_tree_delete(&irq_desc_tree, irq);
Index: linux-2.6-tip/kernel/irq/numa_migrate.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/numa_migrate.c
+++ /dev/null
@@ -1,120 +0,0 @@
-/*
- * NUMA irq-desc migration code
- *
- * Migrate IRQ data structures (irq_desc, chip_data, etc.) over to
- * the new "home node" of the IRQ.
- */
-
-#include <linux/irq.h>
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/random.h>
-#include <linux/interrupt.h>
-#include <linux/kernel_stat.h>
-
-#include "internals.h"
-
-static void init_copy_kstat_irqs(struct irq_desc *old_desc,
-				 struct irq_desc *desc,
-				 int node, int nr)
-{
-	init_kstat_irqs(desc, node, nr);
-
-	if (desc->kstat_irqs != old_desc->kstat_irqs)
-		memcpy(desc->kstat_irqs, old_desc->kstat_irqs,
-			 nr * sizeof(*desc->kstat_irqs));
-}
-
-static void free_kstat_irqs(struct irq_desc *old_desc, struct irq_desc *desc)
-{
-	if (old_desc->kstat_irqs == desc->kstat_irqs)
-		return;
-
-	kfree(old_desc->kstat_irqs);
-	old_desc->kstat_irqs = NULL;
-}
-
-static bool init_copy_one_irq_desc(int irq, struct irq_desc *old_desc,
-		 struct irq_desc *desc, int node)
-{
-	memcpy(desc, old_desc, sizeof(struct irq_desc));
-	if (!alloc_desc_masks(desc, node, false)) {
-		printk(KERN_ERR "irq %d: can not get new irq_desc cpumask "
-				"for migration.\n", irq);
-		return false;
-	}
-	raw_spin_lock_init(&desc->lock);
-	desc->node = node;
-	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
-	init_copy_kstat_irqs(old_desc, desc, node, nr_cpu_ids);
-	init_copy_desc_masks(old_desc, desc);
-	arch_init_copy_chip_data(old_desc, desc, node);
-	return true;
-}
-
-static void free_one_irq_desc(struct irq_desc *old_desc, struct irq_desc *desc)
-{
-	free_kstat_irqs(old_desc, desc);
-	free_desc_masks(old_desc, desc);
-	arch_free_chip_data(old_desc, desc);
-}
-
-static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
-						int node)
-{
-	struct irq_desc *desc;
-	unsigned int irq;
-	unsigned long flags;
-
-	irq = old_desc->irq;
-
-	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
-
-	/* We have to check it to avoid races with another CPU */
-	desc = irq_to_desc(irq);
-
-	if (desc && old_desc != desc)
-		goto out_unlock;
-
-	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
-	if (!desc) {
-		printk(KERN_ERR "irq %d: can not get new irq_desc "
-				"for migration.\n", irq);
-		/* still use old one */
-		desc = old_desc;
-		goto out_unlock;
-	}
-	if (!init_copy_one_irq_desc(irq, old_desc, desc, node)) {
-		/* still use old one */
-		kfree(desc);
-		desc = old_desc;
-		goto out_unlock;
-	}
-
-	replace_irq_desc(irq, desc);
-	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
-
-	/* free the old one */
-	free_one_irq_desc(old_desc, desc);
-	kfree(old_desc);
-
-	return desc;
-
-out_unlock:
-	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
-
-	return desc;
-}
-
-struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
-{
-	/* those static or target node is -1, do not move them */
-	if (desc->irq < NR_IRQS_LEGACY || node == -1)
-		return desc;
-
-	if (desc->node != node)
-		desc = __real_move_irq_desc(desc, node);
-
-	return desc;
-}
-


