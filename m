Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1HQPqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 11:46:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:58649 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab1HQPqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 11:46:06 -0400
Date: Wed, 17 Aug 2011 17:46:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, mingo@kernel.org
Subject: [GIT pull] irq fixes for 3.1
Message-ID: <alpine.LFD.2.02.1108171744410.2807@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-urgent-for-linus

Thanks,

	tglx

------------------>
Sebastian Andrzej Siewior (2):
      irq: Always set IRQF_ONESHOT if no primary handler is specified
      irq: Track the owner of irq descriptor

jhbird.choi@samsung.com (1):
      genirq: Fix wrong bit operation


 include/linux/irq.h       |   11 ++++++++++-
 include/linux/irqdesc.h   |    1 +
 kernel/irq/generic-chip.c |    4 ++--
 kernel/irq/irqdesc.c      |   36 ++++++++++++++++++++++++------------
 kernel/irq/manage.c       |   18 ++++++++++++++----
 5 files changed, 51 insertions(+), 19 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index baa397e..16d6f54 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -23,6 +23,7 @@
 #include <linux/errno.h>
 #include <linux/topology.h>
 #include <linux/wait.h>
+#include <linux/module.h>
 
 #include <asm/irq.h>
 #include <asm/ptrace.h>
@@ -546,7 +547,15 @@ static inline struct msi_desc *irq_data_get_msi(struct irq_data *d)
 	return d->msi_desc;
 }
 
-int irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node);
+int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
+		struct module *owner);
+
+static inline int irq_alloc_descs(int irq, unsigned int from, unsigned int cnt,
+		int node)
+{
+	return __irq_alloc_descs(irq, from, cnt, node, THIS_MODULE);
+}
+
 void irq_free_descs(unsigned int irq, unsigned int cnt);
 int irq_reserve_irqs(unsigned int from, unsigned int cnt);
 
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 2d921b3..150134a 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -66,6 +66,7 @@ struct irq_desc {
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry	*dir;
 #endif
+	struct module		*owner;
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 3a2cab4..e38544d 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -246,7 +246,7 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
 		gc->mask_cache = irq_reg_readl(gc->reg_base + ct->regs.mask);
 
 	for (i = gc->irq_base; msk; msk >>= 1, i++) {
-		if (!msk & 0x01)
+		if (!(msk & 0x01))
 			continue;
 
 		if (flags & IRQ_GC_INIT_NESTED_LOCK)
@@ -301,7 +301,7 @@ void irq_remove_generic_chip(struct irq_chip_generic *gc, u32 msk,
 	raw_spin_unlock(&gc_lock);
 
 	for (; msk; msk >>= 1, i++) {
-		if (!msk & 0x01)
+		if (!(msk & 0x01))
 			continue;
 
 		/* Remove handler first. That will mask the irq line */
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 4c60a50..cb65d03 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -70,7 +70,8 @@ static inline void desc_smp_init(struct irq_desc *desc, int node) { }
 static inline int desc_node(struct irq_desc *desc) { return 0; }
 #endif
 
-static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node)
+static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node,
+		struct module *owner)
 {
 	int cpu;
 
@@ -86,6 +87,7 @@ static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node)
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
 	desc->name = NULL;
+	desc->owner = owner;
 	for_each_possible_cpu(cpu)
 		*per_cpu_ptr(desc->kstat_irqs, cpu) = 0;
 	desc_smp_init(desc, node);
@@ -128,7 +130,7 @@ static void free_masks(struct irq_desc *desc)
 static inline void free_masks(struct irq_desc *desc) { }
 #endif
 
-static struct irq_desc *alloc_desc(int irq, int node)
+static struct irq_desc *alloc_desc(int irq, int node, struct module *owner)
 {
 	struct irq_desc *desc;
 	gfp_t gfp = GFP_KERNEL;
@@ -147,7 +149,7 @@ static struct irq_desc *alloc_desc(int irq, int node)
 	raw_spin_lock_init(&desc->lock);
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 
-	desc_set_defaults(irq, desc, node);
+	desc_set_defaults(irq, desc, node, owner);
 
 	return desc;
 
@@ -173,13 +175,14 @@ static void free_desc(unsigned int irq)
 	kfree(desc);
 }
 
-static int alloc_descs(unsigned int start, unsigned int cnt, int node)
+static int alloc_descs(unsigned int start, unsigned int cnt, int node,
+		       struct module *owner)
 {
 	struct irq_desc *desc;
 	int i;
 
 	for (i = 0; i < cnt; i++) {
-		desc = alloc_desc(start + i, node);
+		desc = alloc_desc(start + i, node, owner);
 		if (!desc)
 			goto err;
 		mutex_lock(&sparse_irq_lock);
@@ -227,7 +230,7 @@ int __init early_irq_init(void)
 		nr_irqs = initcnt;
 
 	for (i = 0; i < initcnt; i++) {
-		desc = alloc_desc(i, node);
+		desc = alloc_desc(i, node, NULL);
 		set_bit(i, allocated_irqs);
 		irq_insert_desc(i, desc);
 	}
@@ -261,7 +264,7 @@ int __init early_irq_init(void)
 		alloc_masks(&desc[i], GFP_KERNEL, node);
 		raw_spin_lock_init(&desc[i].lock);
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
-		desc_set_defaults(i, &desc[i], node);
+		desc_set_defaults(i, &desc[i], node, NULL);
 	}
 	return arch_early_irq_init();
 }
@@ -276,8 +279,16 @@ static void free_desc(unsigned int irq)
 	dynamic_irq_cleanup(irq);
 }
 
-static inline int alloc_descs(unsigned int start, unsigned int cnt, int node)
+static inline int alloc_descs(unsigned int start, unsigned int cnt, int node,
+			      struct module *owner)
 {
+	u32 i;
+
+	for (i = 0; i < cnt; i++) {
+		struct irq_desc *desc = irq_to_desc(start + i);
+
+		desc->owner = owner;
+	}
 	return start;
 }
 
@@ -337,7 +348,8 @@ EXPORT_SYMBOL_GPL(irq_free_descs);
  * Returns the first irq number or error code
  */
 int __ref
-irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node)
+__irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
+		  struct module *owner)
 {
 	int start, ret;
 
@@ -366,13 +378,13 @@ irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node)
 
 	bitmap_set(allocated_irqs, start, cnt);
 	mutex_unlock(&sparse_irq_lock);
-	return alloc_descs(start, cnt, node);
+	return alloc_descs(start, cnt, node, owner);
 
 err:
 	mutex_unlock(&sparse_irq_lock);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(irq_alloc_descs);
+EXPORT_SYMBOL_GPL(__irq_alloc_descs);
 
 /**
  * irq_reserve_irqs - mark irqs allocated
@@ -440,7 +452,7 @@ void dynamic_irq_cleanup(unsigned int irq)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	desc_set_defaults(irq, desc, desc_node(desc));
+	desc_set_defaults(irq, desc, desc_node(desc), NULL);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0a7840ae..2e94258 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -883,6 +883,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 
 	if (desc->irq_data.chip == &no_irq_chip)
 		return -ENOSYS;
+	if (!try_module_get(desc->owner))
+		return -ENODEV;
 	/*
 	 * Some drivers like serial.c use request_irq() heavily,
 	 * so we have to be careful not to interfere with a
@@ -906,8 +908,10 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	 */
 	nested = irq_settings_is_nested_thread(desc);
 	if (nested) {
-		if (!new->thread_fn)
-			return -EINVAL;
+		if (!new->thread_fn) {
+			ret = -EINVAL;
+			goto out_mput;
+		}
 		/*
 		 * Replace the primary handler which was provided from
 		 * the driver for non nested interrupt handling by the
@@ -929,8 +933,10 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 
 		t = kthread_create(irq_thread, new, "irq/%d-%s", irq,
 				   new->name);
-		if (IS_ERR(t))
-			return PTR_ERR(t);
+		if (IS_ERR(t)) {
+			ret = PTR_ERR(t);
+			goto out_mput;
+		}
 		/*
 		 * We keep the reference to the task struct even if
 		 * the thread dies to avoid that the interrupt code
@@ -1095,6 +1101,8 @@ out_thread:
 			kthread_stop(t);
 		put_task_struct(t);
 	}
+out_mput:
+	module_put(desc->owner);
 	return ret;
 }
 
@@ -1203,6 +1211,7 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 		put_task_struct(action->thread);
 	}
 
+	module_put(desc->owner);
 	return action;
 }
 
@@ -1322,6 +1331,7 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 		if (!thread_fn)
 			return -EINVAL;
 		handler = irq_default_primary_handler;
+		irqflags |= IRQF_ONESHOT;
 	}
 
 	action = kzalloc(sizeof(struct irqaction), GFP_KERNEL);
