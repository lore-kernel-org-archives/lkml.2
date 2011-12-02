Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab1LBWJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 17:09:53 -0500
Received: from www.linutronix.de ([62.245.132.108]:49442 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab1LBWJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 17:09:51 -0500
Date: Fri, 2 Dec 2011 23:09:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.2-rc4-rt5
Message-ID: <alpine.LFD.2.02.1112022250190.2735@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.2-rc4-rt6 release. 3.2-rc4-rt4 is a not
announced intermediate release, which only updates to 3.2-rc4. No rt
changes except dropping patches which made it into 3.2-rc4.

NOTE: Releases are back to www.kernel.org - the intermediate tglx.de
      release URL is history!

Changes vs. 3.2-rc4-rt4:

  * tasklet fix - port from 2.6.33-rt (Steven)
    	[tasklet-rt-prevent-tasklets-from-going-into-infinite-spin-in-rt.patch] -> stable

  * acpi raw spinlock annotations
    	[acpi-make-gbl-hardware-lock-raw.patch] -> stable

  * pci preemption fix
    	[wait-provide-__wake_up_all_locked.patch] -> stable
	[pci-access-use-__wake_up_all_locked.patch] -> stable

  * a few important fixes which are pending for mainline and should be
    gone with rc5
    	[re-possible-slab-deadlock-while-doing-ifenslave.patch] -> stable
	[re-possible-slab-deadlock-while-doing-ifenslave-1.patch] -> stable

	Yes, I should have renamed them, but now it's too late :)

The incremental patch against 3.2-rc4-rt5 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2-rc4-rt4-rt5.patch.bz2    

and is also appended below.


The RT patch against 3.2-rc4 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2-rc4-rt5.patch.bz2 


The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patches-3.2-rc4-rt5.tar.bz2 


Enjoy,

	tglx
---
Index: linux-3.2/include/linux/interrupt.h
===================================================================
--- linux-3.2.orig/include/linux/interrupt.h
+++ linux-3.2/include/linux/interrupt.h
@@ -517,8 +517,9 @@ extern void __send_remote_softirq(struct
      to be executed on some cpu at least once after this.
    * If the tasklet is already scheduled, but its execution is still not
      started, it will be executed only once.
-   * If this tasklet is already running on another CPU (or schedule is called
-     from tasklet itself), it is rescheduled for later.
+   * If this tasklet is already running on another CPU, it is rescheduled
+     for later.
+   * Schedule must not be called from the tasklet itself (a lockup occurs)
    * Tasklet is strictly serialized wrt itself, but not
      wrt another tasklets. If client needs some intertask synchronization,
      he makes it with spinlocks.
@@ -543,27 +544,36 @@ struct tasklet_struct name = { NULL, 0, 
 enum
 {
 	TASKLET_STATE_SCHED,	/* Tasklet is scheduled for execution */
-	TASKLET_STATE_RUN	/* Tasklet is running (SMP only) */
+	TASKLET_STATE_RUN,	/* Tasklet is running (SMP only) */
+	TASKLET_STATE_PENDING	/* Tasklet is pending */
 };
 
-#ifdef CONFIG_SMP
+#define TASKLET_STATEF_SCHED	(1 << TASKLET_STATE_SCHED)
+#define TASKLET_STATEF_RUN	(1 << TASKLET_STATE_RUN)
+#define TASKLET_STATEF_PENDING	(1 << TASKLET_STATE_PENDING)
+
+#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT_FULL)
 static inline int tasklet_trylock(struct tasklet_struct *t)
 {
 	return !test_and_set_bit(TASKLET_STATE_RUN, &(t)->state);
 }
 
+static inline int tasklet_tryunlock(struct tasklet_struct *t)
+{
+	return cmpxchg(&t->state, TASKLET_STATEF_RUN, 0) == TASKLET_STATEF_RUN;
+}
+
 static inline void tasklet_unlock(struct tasklet_struct *t)
 {
 	smp_mb__before_clear_bit(); 
 	clear_bit(TASKLET_STATE_RUN, &(t)->state);
 }
 
-static inline void tasklet_unlock_wait(struct tasklet_struct *t)
-{
-	while (test_bit(TASKLET_STATE_RUN, &(t)->state)) { barrier(); }
-}
+extern void tasklet_unlock_wait(struct tasklet_struct *t);
+
 #else
 #define tasklet_trylock(t) 1
+#define tasklet_tryunlock(t)	1
 #define tasklet_unlock_wait(t) do { } while (0)
 #define tasklet_unlock(t) do { } while (0)
 #endif
@@ -612,17 +622,8 @@ static inline void tasklet_disable(struc
 	smp_mb();
 }
 
-static inline void tasklet_enable(struct tasklet_struct *t)
-{
-	smp_mb__before_atomic_dec();
-	atomic_dec(&t->count);
-}
-
-static inline void tasklet_hi_enable(struct tasklet_struct *t)
-{
-	smp_mb__before_atomic_dec();
-	atomic_dec(&t->count);
-}
+extern  void tasklet_enable(struct tasklet_struct *t);
+extern  void tasklet_hi_enable(struct tasklet_struct *t);
 
 extern void tasklet_kill(struct tasklet_struct *t);
 extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
Index: linux-3.2/kernel/sched.c
===================================================================
--- linux-3.2.orig/kernel/sched.c
+++ linux-3.2/kernel/sched.c
@@ -4806,9 +4806,9 @@ EXPORT_SYMBOL(__wake_up);
 /*
  * Same as __wake_up but called with the spinlock in wait_queue_head_t held.
  */
-void __wake_up_locked(wait_queue_head_t *q, unsigned int mode)
+void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr)
 {
-	__wake_up_common(q, mode, 1, 0, NULL);
+	__wake_up_common(q, mode, nr, 0, NULL);
 }
 EXPORT_SYMBOL_GPL(__wake_up_locked);
 
Index: linux-3.2/kernel/softirq.c
===================================================================
--- linux-3.2.orig/kernel/softirq.c
+++ linux-3.2/kernel/softirq.c
@@ -21,6 +21,7 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/rcupdate.h>
+#include <linux/delay.h>
 #include <linux/ftrace.h>
 #include <linux/smp.h>
 #include <linux/tick.h>
@@ -670,15 +671,45 @@ struct tasklet_head
 static DEFINE_PER_CPU(struct tasklet_head, tasklet_vec);
 static DEFINE_PER_CPU(struct tasklet_head, tasklet_hi_vec);
 
+static void inline
+__tasklet_common_schedule(struct tasklet_struct *t, struct tasklet_head *head, unsigned int nr)
+{
+	if (tasklet_trylock(t)) {
+again:
+		/* We may have been preempted before tasklet_trylock
+		 * and __tasklet_action may have already run.
+		 * So double check the sched bit while the takslet
+		 * is locked before adding it to the list.
+		 */
+		if (test_bit(TASKLET_STATE_SCHED, &t->state)) {
+			t->next = NULL;
+			*head->tail = t;
+			head->tail = &(t->next);
+			raise_softirq_irqoff(nr);
+			tasklet_unlock(t);
+		} else {
+			/* This is subtle. If we hit the corner case above
+			 * It is possible that we get preempted right here,
+			 * and another task has successfully called
+			 * tasklet_schedule(), then this function, and
+			 * failed on the trylock. Thus we must be sure
+			 * before releasing the tasklet lock, that the
+			 * SCHED_BIT is clear. Otherwise the tasklet
+			 * may get its SCHED_BIT set, but not added to the
+			 * list
+			 */
+			if (!tasklet_tryunlock(t))
+				goto again;
+		}
+	}
+}
+
 void __tasklet_schedule(struct tasklet_struct *t)
 {
 	unsigned long flags;
 
 	local_irq_save(flags);
-	t->next = NULL;
-	*__this_cpu_read(tasklet_vec.tail) = t;
-	__this_cpu_write(tasklet_vec.tail, &(t->next));
-	raise_softirq_irqoff(TASKLET_SOFTIRQ);
+	__tasklet_common_schedule(t, &__get_cpu_var(tasklet_vec), TASKLET_SOFTIRQ);
 	local_irq_restore(flags);
 }
 
@@ -689,10 +720,7 @@ void __tasklet_hi_schedule(struct taskle
 	unsigned long flags;
 
 	local_irq_save(flags);
-	t->next = NULL;
-	*__this_cpu_read(tasklet_hi_vec.tail) = t;
-	__this_cpu_write(tasklet_hi_vec.tail,  &(t->next));
-	raise_softirq_irqoff(HI_SOFTIRQ);
+	__tasklet_common_schedule(t, &__get_cpu_var(tasklet_hi_vec), HI_SOFTIRQ);
 	local_irq_restore(flags);
 }
 
@@ -700,50 +728,119 @@ EXPORT_SYMBOL(__tasklet_hi_schedule);
 
 void __tasklet_hi_schedule_first(struct tasklet_struct *t)
 {
-	BUG_ON(!irqs_disabled());
-
-	t->next = __this_cpu_read(tasklet_hi_vec.head);
-	__this_cpu_write(tasklet_hi_vec.head, t);
-	__raise_softirq_irqoff(HI_SOFTIRQ);
+	__tasklet_hi_schedule(t);
 }
 
 EXPORT_SYMBOL(__tasklet_hi_schedule_first);
 
-static void tasklet_action(struct softirq_action *a)
+void  tasklet_enable(struct tasklet_struct *t)
 {
-	struct tasklet_struct *list;
+	if (!atomic_dec_and_test(&t->count))
+		return;
+	if (test_and_clear_bit(TASKLET_STATE_PENDING, &t->state))
+		tasklet_schedule(t);
+}
 
-	local_irq_disable();
-	list = __this_cpu_read(tasklet_vec.head);
-	__this_cpu_write(tasklet_vec.head, NULL);
-	__this_cpu_write(tasklet_vec.tail, &__get_cpu_var(tasklet_vec).head);
-	local_irq_enable();
+EXPORT_SYMBOL(tasklet_enable);
+
+void  tasklet_hi_enable(struct tasklet_struct *t)
+{
+	if (!atomic_dec_and_test(&t->count))
+		return;
+	if (test_and_clear_bit(TASKLET_STATE_PENDING, &t->state))
+		tasklet_hi_schedule(t);
+}
+
+EXPORT_SYMBOL(tasklet_hi_enable);
+
+static void
+__tasklet_action(struct softirq_action *a, struct tasklet_struct *list)
+{
+	int loops = 1000000;
 
 	while (list) {
 		struct tasklet_struct *t = list;
 
 		list = list->next;
 
-		if (tasklet_trylock(t)) {
-			if (!atomic_read(&t->count)) {
-				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
-					BUG();
-				t->func(t->data);
-				tasklet_unlock(t);
-				continue;
-			}
-			tasklet_unlock(t);
+		/*
+		 * Should always succeed - after a tasklist got on the
+		 * list (after getting the SCHED bit set from 0 to 1),
+		 * nothing but the tasklet softirq it got queued to can
+		 * lock it:
+		 */
+		if (!tasklet_trylock(t)) {
+			WARN_ON(1);
+			continue;
 		}
 
-		local_irq_disable();
 		t->next = NULL;
-		*__this_cpu_read(tasklet_vec.tail) = t;
-		__this_cpu_write(tasklet_vec.tail, &(t->next));
-		__raise_softirq_irqoff(TASKLET_SOFTIRQ);
-		local_irq_enable();
+
+		/*
+		 * If we cannot handle the tasklet because it's disabled,
+		 * mark it as pending. tasklet_enable() will later
+		 * re-schedule the tasklet.
+		 */
+		if (unlikely(atomic_read(&t->count))) {
+out_disabled:
+			/* implicit unlock: */
+			wmb();
+			t->state = TASKLET_STATEF_PENDING;
+			continue;
+		}
+
+		/*
+		 * After this point on the tasklet might be rescheduled
+		 * on another CPU, but it can only be added to another
+		 * CPU's tasklet list if we unlock the tasklet (which we
+		 * dont do yet).
+		 */
+		if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
+			WARN_ON(1);
+
+again:
+		t->func(t->data);
+
+		/*
+		 * Try to unlock the tasklet. We must use cmpxchg, because
+		 * another CPU might have scheduled or disabled the tasklet.
+		 * We only allow the STATE_RUN -> 0 transition here.
+		 */
+		while (!tasklet_tryunlock(t)) {
+			/*
+			 * If it got disabled meanwhile, bail out:
+			 */
+			if (atomic_read(&t->count))
+				goto out_disabled;
+			/*
+			 * If it got scheduled meanwhile, re-execute
+			 * the tasklet function:
+			 */
+			if (test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
+				goto again;
+			if (!--loops) {
+				printk("hm, tasklet state: %08lx\n", t->state);
+				WARN_ON(1);
+				tasklet_unlock(t);
+				break;
+			}
+		}
 	}
 }
 
+static void tasklet_action(struct softirq_action *a)
+{
+	struct tasklet_struct *list;
+
+	local_irq_disable();
+	list = __get_cpu_var(tasklet_vec).head;
+	__get_cpu_var(tasklet_vec).head = NULL;
+	__get_cpu_var(tasklet_vec).tail = &__get_cpu_var(tasklet_vec).head;
+	local_irq_enable();
+
+	__tasklet_action(a, list);
+}
+
 static void tasklet_hi_action(struct softirq_action *a)
 {
 	struct tasklet_struct *list;
@@ -754,29 +851,7 @@ static void tasklet_hi_action(struct sof
 	__this_cpu_write(tasklet_hi_vec.tail, &__get_cpu_var(tasklet_hi_vec).head);
 	local_irq_enable();
 
-	while (list) {
-		struct tasklet_struct *t = list;
-
-		list = list->next;
-
-		if (tasklet_trylock(t)) {
-			if (!atomic_read(&t->count)) {
-				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
-					BUG();
-				t->func(t->data);
-				tasklet_unlock(t);
-				continue;
-			}
-			tasklet_unlock(t);
-		}
-
-		local_irq_disable();
-		t->next = NULL;
-		*__this_cpu_read(tasklet_hi_vec.tail) = t;
-		__this_cpu_write(tasklet_hi_vec.tail, &(t->next));
-		__raise_softirq_irqoff(HI_SOFTIRQ);
-		local_irq_enable();
-	}
+	__tasklet_action(a, list);
 }
 
 
@@ -799,7 +874,7 @@ void tasklet_kill(struct tasklet_struct 
 
 	while (test_and_set_bit(TASKLET_STATE_SCHED, &t->state)) {
 		do {
-			yield();
+			msleep(1);
 		} while (test_bit(TASKLET_STATE_SCHED, &t->state));
 	}
 	tasklet_unlock_wait(t);
@@ -1005,6 +1080,23 @@ void __init softirq_init(void)
 	open_softirq(HI_SOFTIRQ, tasklet_hi_action);
 }
 
+#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT_FULL)
+void tasklet_unlock_wait(struct tasklet_struct *t)
+{
+	while (test_bit(TASKLET_STATE_RUN, &(t)->state)) {
+		/*
+		 * Hack for now to avoid this busy-loop:
+		 */
+#ifdef CONFIG_PREEMPT_RT_FULL
+		msleep(1);
+#else
+		barrier();
+#endif
+	}
+}
+EXPORT_SYMBOL(tasklet_unlock_wait);
+#endif
+
 static int run_ksoftirqd(void * __bind_cpu)
 {
 	ksoftirqd_set_sched_params();
Index: linux-3.2/localversion-rt
===================================================================
--- linux-3.2.orig/localversion-rt
+++ linux-3.2/localversion-rt
@@ -1 +1 @@
--rt4
+-rt5
Index: linux-3.2/mm/slab.c
===================================================================
--- linux-3.2.orig/mm/slab.c
+++ linux-3.2/mm/slab.c
@@ -596,6 +596,7 @@ static enum {
 	PARTIAL_AC,
 	PARTIAL_L3,
 	EARLY,
+	LATE,
 	FULL
 } g_cpucache_up;
 
@@ -607,6 +608,12 @@ int slab_is_available(void)
 	return g_cpucache_up >= EARLY;
 }
 
+/*
+ * Guard access to the cache-chain.
+ */
+static DEFINE_MUTEX(cache_chain_mutex);
+static struct list_head cache_chain;
+
 #ifdef CONFIG_LOCKDEP
 
 /*
@@ -668,38 +675,41 @@ static void slab_set_debugobj_lock_class
 		slab_set_debugobj_lock_classes_node(cachep, node);
 }
 
-static void init_node_lock_keys(int q)
+static void init_lock_keys(struct kmem_cache *cachep, int node)
 {
-	struct cache_sizes *s = malloc_sizes;
+	struct kmem_list3 *l3;
 
-	if (g_cpucache_up != FULL)
+	if (g_cpucache_up < LATE)
 		return;
 
-	for (s = malloc_sizes; s->cs_size != ULONG_MAX; s++) {
-		struct kmem_list3 *l3;
+	l3 = cachep->nodelists[node];
+	if (!l3 || OFF_SLAB(cachep))
+		return;
 
-		l3 = s->cs_cachep->nodelists[q];
-		if (!l3 || OFF_SLAB(s->cs_cachep))
-			continue;
+	slab_set_lock_classes(cachep, &on_slab_l3_key, &on_slab_alc_key, node);
+}
 
-		slab_set_lock_classes(s->cs_cachep, &on_slab_l3_key,
-				&on_slab_alc_key, q);
-	}
+static void init_node_lock_keys(int node)
+{
+	struct kmem_cache *cachep;
+
+	list_for_each_entry(cachep, &cache_chain, next)
+		init_lock_keys(cachep, node);
 }
 
-static inline void init_lock_keys(void)
+static inline void init_cachep_lock_keys(struct kmem_cache *cachep)
 {
 	int node;
 
 	for_each_node(node)
-		init_node_lock_keys(node);
+		init_lock_keys(cachep, node);
 }
 #else
-static void init_node_lock_keys(int q)
+static void init_node_lock_keys(int node)
 {
 }
 
-static inline void init_lock_keys(void)
+static void init_cachep_lock_keys(struct kmem_cache *cachep)
 {
 }
 
@@ -712,12 +722,6 @@ static void slab_set_debugobj_lock_class
 }
 #endif
 
-/*
- * Guard access to the cache-chain.
- */
-static DEFINE_MUTEX(cache_chain_mutex);
-static struct list_head cache_chain;
-
 static DEFINE_PER_CPU(struct delayed_work, slab_reap_work);
 static DEFINE_PER_CPU(struct list_head, slab_free_list);
 static DEFINE_LOCAL_IRQ_LOCK(slab_lock);
@@ -1726,14 +1730,15 @@ void __init kmem_cache_init_late(void)
 {
 	struct kmem_cache *cachep;
 
-	/* Annotate slab for lockdep -- annotate the malloc caches */
-	init_lock_keys();
+	g_cpucache_up = LATE;
 
 	/* 6) resize the head arrays to their final sizes */
 	mutex_lock(&cache_chain_mutex);
-	list_for_each_entry(cachep, &cache_chain, next)
+	list_for_each_entry(cachep, &cache_chain, next) {
+		init_cachep_lock_keys(cachep);
 		if (enable_cpucache(cachep, GFP_NOWAIT))
 			BUG();
+	}
 	mutex_unlock(&cache_chain_mutex);
 
 	/* Done! */
@@ -2545,6 +2550,8 @@ kmem_cache_create (const char *name, siz
 		slab_set_debugobj_lock_classes(cachep);
 	}
 
+	init_cachep_lock_keys(cachep);
+
 	/* cache setup completed, link it into the list */
 	list_add(&cachep->next, &cache_chain);
 oops:
Index: linux-3.2/include/linux/wait.h
===================================================================
--- linux-3.2.orig/include/linux/wait.h
+++ linux-3.2/include/linux/wait.h
@@ -157,7 +157,7 @@ void __wake_up(wait_queue_head_t *q, uns
 void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key);
 void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr,
 			void *key);
-void __wake_up_locked(wait_queue_head_t *q, unsigned int mode);
+void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_bit(wait_queue_head_t *, void *, int);
 int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
@@ -170,7 +170,8 @@ wait_queue_head_t *bit_waitqueue(void *,
 #define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
 #define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
 #define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
-#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL)
+#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL, 1)
+#define wake_up_all_locked(x)		__wake_up_locked((x), TASK_NORMAL, 0)
 
 #define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
 #define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, nr, NULL)
Index: linux-3.2/drivers/pci/access.c
===================================================================
--- linux-3.2.orig/drivers/pci/access.c
+++ linux-3.2/drivers/pci/access.c
@@ -441,7 +441,7 @@ void pci_unblock_user_cfg_access(struct 
 	WARN_ON(!dev->block_ucfg_access);
 
 	dev->block_ucfg_access = 0;
-	wake_up_all(&pci_ucfg_wait);
+	wake_up_all_locked(&pci_ucfg_wait);
 	raw_spin_unlock_irqrestore(&pci_lock, flags);
 }
 EXPORT_SYMBOL_GPL(pci_unblock_user_cfg_access);
Index: linux-3.2/drivers/acpi/acpica/acglobal.h
===================================================================
--- linux-3.2.orig/drivers/acpi/acpica/acglobal.h
+++ linux-3.2/drivers/acpi/acpica/acglobal.h
@@ -235,8 +235,8 @@ ACPI_EXTERN u8 acpi_gbl_global_lock_pend
  * Spinlocks are used for interfaces that can be possibly called at
  * interrupt level
  */
-ACPI_EXTERN acpi_spinlock acpi_gbl_gpe_lock;	/* For GPE data structs and registers */
-ACPI_EXTERN acpi_spinlock acpi_gbl_hardware_lock;	/* For ACPI H/W except GPE registers */
+extern raw_spinlock_t acpi_gbl_gpe_lock;	/* For GPE data structs and registers */
+extern raw_spinlock_t acpi_gbl_hardware_lock;	/* For ACPI H/W except GPE registers */
 
 /*****************************************************************************
  *
Index: linux-3.2/drivers/acpi/acpica/evgpe.c
===================================================================
--- linux-3.2.orig/drivers/acpi/acpica/evgpe.c
+++ linux-3.2/drivers/acpi/acpica/evgpe.c
@@ -357,7 +357,7 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_x
 	 * Note: Not necessary to obtain the hardware lock, since the GPE
 	 * registers are owned by the gpe_lock.
 	 */
-	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 
 	/* Examine all GPE blocks attached to this interrupt level */
 
@@ -440,7 +440,7 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_x
 
       unlock_and_exit:
 
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return (int_status);
 }
 
Index: linux-3.2/drivers/acpi/acpica/evgpeblk.c
===================================================================
--- linux-3.2.orig/drivers/acpi/acpica/evgpeblk.c
+++ linux-3.2/drivers/acpi/acpica/evgpeblk.c
@@ -95,7 +95,7 @@ acpi_ev_install_gpe_block(struct acpi_gp
 
 	/* Install the new block at the end of the list with lock */
 
-	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 	if (gpe_xrupt_block->gpe_block_list_head) {
 		next_gpe_block = gpe_xrupt_block->gpe_block_list_head;
 		while (next_gpe_block->next) {
@@ -109,7 +109,7 @@ acpi_ev_install_gpe_block(struct acpi_gp
 	}
 
 	gpe_block->xrupt_block = gpe_xrupt_block;
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 
       unlock_and_exit:
 	status = acpi_ut_release_mutex(ACPI_MTX_EVENTS);
@@ -156,7 +156,7 @@ acpi_status acpi_ev_delete_gpe_block(str
 	} else {
 		/* Remove the block on this interrupt with lock */
 
-		flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+		raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 		if (gpe_block->previous) {
 			gpe_block->previous->next = gpe_block->next;
 		} else {
@@ -167,7 +167,7 @@ acpi_status acpi_ev_delete_gpe_block(str
 		if (gpe_block->next) {
 			gpe_block->next->previous = gpe_block->previous;
 		}
-		acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+		raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	}
 
 	acpi_current_gpe_count -= gpe_block->gpe_count;
Index: linux-3.2/drivers/acpi/acpica/evgpeutil.c
===================================================================
--- linux-3.2.orig/drivers/acpi/acpica/evgpeutil.c
+++ linux-3.2/drivers/acpi/acpica/evgpeutil.c
@@ -70,7 +70,7 @@ acpi_ev_walk_gpe_list(acpi_gpe_callback 
 
 	ACPI_FUNCTION_TRACE(ev_walk_gpe_list);
 
-	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 
 	/* Walk the interrupt level descriptor list */
 
@@ -101,7 +101,7 @@ acpi_ev_walk_gpe_list(acpi_gpe_callback 
 	}
 
       unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 
@@ -237,7 +237,7 @@ struct acpi_gpe_xrupt_info *acpi_ev_get_
 
 	/* Install new interrupt descriptor with spin lock */
 
-	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 	if (acpi_gbl_gpe_xrupt_list_head) {
 		next_gpe_xrupt = acpi_gbl_gpe_xrupt_list_head;
 		while (next_gpe_xrupt->next) {
@@ -249,7 +249,7 @@ struct acpi_gpe_xrupt_info *acpi_ev_get_
 	} else {
 		acpi_gbl_gpe_xrupt_list_head = gpe_xrupt;
 	}
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 
 	/* Install new interrupt handler if not SCI_INT */
 
@@ -306,7 +306,7 @@ acpi_status acpi_ev_delete_gpe_xrupt(str
 
 	/* Unlink the interrupt block with lock */
 
-	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 	if (gpe_xrupt->previous) {
 		gpe_xrupt->previous->next = gpe_xrupt->next;
 	} else {
@@ -318,7 +318,7 @@ acpi_status acpi_ev_delete_gpe_xrupt(str
 	if (gpe_xrupt->next) {
 		gpe_xrupt->next->previous = gpe_xrupt->previous;
 	}
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 
 	/* Free the block */
 
Index: linux-3.2/drivers/acpi/acpica/evxface.c
===================================================================
--- linux-3.2.orig/drivers/acpi/acpica/evxface.c
+++ linux-3.2/drivers/acpi/acpica/evxface.c
@@ -751,7 +751,7 @@ acpi_install_gpe_handler(acpi_handle gpe
 		goto unlock_and_exit;
 	}
 
-	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 
 	/* Ensure that we have a valid GPE number */
 
@@ -799,14 +799,14 @@ acpi_install_gpe_handler(acpi_handle gpe
 	    ~(ACPI_GPE_XRUPT_TYPE_MASK | ACPI_GPE_DISPATCH_MASK);
 	gpe_event_info->flags |= (u8) (type | ACPI_GPE_DISPATCH_HANDLER);
 
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 
 unlock_and_exit:
 	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
 	return_ACPI_STATUS(status);
 
 free_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	ACPI_FREE(handler);
 	goto unlock_and_exit;
 }
@@ -853,7 +853,7 @@ acpi_remove_gpe_handler(acpi_handle gpe_
 		return_ACPI_STATUS(status);
 	}
 
-	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 
 	/* Ensure that we have a valid GPE number */
 
@@ -904,7 +904,7 @@ acpi_remove_gpe_handler(acpi_handle gpe_
 	ACPI_FREE(handler);
 
 unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 
 	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
 	return_ACPI_STATUS(status);
Index: linux-3.2/drivers/acpi/acpica/evxfgpe.c
===================================================================
--- linux-3.2.orig/drivers/acpi/acpica/evxfgpe.c
+++ linux-3.2/drivers/acpi/acpica/evxfgpe.c
@@ -122,7 +122,7 @@ acpi_status acpi_enable_gpe(acpi_handle 
 
 	ACPI_FUNCTION_TRACE(acpi_enable_gpe);
 
-	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 
 	/* Ensure that we have a valid GPE number */
 
@@ -131,7 +131,7 @@ acpi_status acpi_enable_gpe(acpi_handle 
 		status = acpi_ev_add_gpe_reference(gpe_event_info);
 	}
 
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 ACPI_EXPORT_SYMBOL(acpi_enable_gpe)
@@ -159,7 +159,7 @@ acpi_status acpi_disable_gpe(acpi_handle
 
 	ACPI_FUNCTION_TRACE(acpi_disable_gpe);
 
-	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 
 	/* Ensure that we have a valid GPE number */
 
@@ -168,7 +168,7 @@ acpi_status acpi_disable_gpe(acpi_handle
 		status = acpi_ev_remove_gpe_reference(gpe_event_info) ;
 	}
 
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 ACPI_EXPORT_SYMBOL(acpi_disable_gpe)
@@ -215,7 +215,7 @@ acpi_setup_gpe_for_wake(acpi_handle wake
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
 
-	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 
 	/* Ensure that we have a valid GPE number */
 
@@ -271,7 +271,7 @@ acpi_setup_gpe_for_wake(acpi_handle wake
 	status = AE_OK;
 
  unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 ACPI_EXPORT_SYMBOL(acpi_setup_gpe_for_wake)
@@ -301,7 +301,7 @@ acpi_status acpi_set_gpe_wake_mask(acpi_
 
 	ACPI_FUNCTION_TRACE(acpi_set_gpe_wake_mask);
 
-	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 
 	/*
 	 * Ensure that we have a valid GPE number and that this GPE is in
@@ -347,7 +347,7 @@ acpi_status acpi_set_gpe_wake_mask(acpi_
 	}
 
 unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 
@@ -373,7 +373,7 @@ acpi_status acpi_clear_gpe(acpi_handle g
 
 	ACPI_FUNCTION_TRACE(acpi_clear_gpe);
 
-	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 
 	/* Ensure that we have a valid GPE number */
 
@@ -386,7 +386,7 @@ acpi_status acpi_clear_gpe(acpi_handle g
 	status = acpi_hw_clear_gpe(gpe_event_info);
 
       unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 
@@ -416,7 +416,7 @@ acpi_get_gpe_status(acpi_handle gpe_devi
 
 	ACPI_FUNCTION_TRACE(acpi_get_gpe_status);
 
-	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 
 	/* Ensure that we have a valid GPE number */
 
@@ -434,7 +434,7 @@ acpi_get_gpe_status(acpi_handle gpe_devi
 		*event_status |= ACPI_EVENT_FLAG_HANDLE;
 
       unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 
Index: linux-3.2/drivers/acpi/acpica/hwregs.c
===================================================================
--- linux-3.2.orig/drivers/acpi/acpica/hwregs.c
+++ linux-3.2/drivers/acpi/acpica/hwregs.c
@@ -263,14 +263,14 @@ acpi_status acpi_hw_clear_acpi_status(vo
 			  ACPI_BITMASK_ALL_FIXED_STATUS,
 			  ACPI_FORMAT_UINT64(acpi_gbl_xpm1a_status.address)));
 
-	lock_flags = acpi_os_acquire_lock(acpi_gbl_hardware_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_hardware_lock, lock_flags);
 
 	/* Clear the fixed events in PM1 A/B */
 
 	status = acpi_hw_register_write(ACPI_REGISTER_PM1_STATUS,
 					ACPI_BITMASK_ALL_FIXED_STATUS);
 
-	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_hardware_lock, lock_flags);
 
 	if (ACPI_FAILURE(status))
 		goto exit;
Index: linux-3.2/drivers/acpi/acpica/hwxface.c
===================================================================
--- linux-3.2.orig/drivers/acpi/acpica/hwxface.c
+++ linux-3.2/drivers/acpi/acpica/hwxface.c
@@ -387,7 +387,7 @@ acpi_status acpi_write_bit_register(u32 
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
 
-	lock_flags = acpi_os_acquire_lock(acpi_gbl_hardware_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_hardware_lock, lock_flags);
 
 	/*
 	 * At this point, we know that the parent register is one of the
@@ -448,7 +448,7 @@ acpi_status acpi_write_bit_register(u32 
 
 unlock_and_exit:
 
-	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_hardware_lock, lock_flags);
 	return_ACPI_STATUS(status);
 }
 
Index: linux-3.2/drivers/acpi/acpica/utmutex.c
===================================================================
--- linux-3.2.orig/drivers/acpi/acpica/utmutex.c
+++ linux-3.2/drivers/acpi/acpica/utmutex.c
@@ -52,6 +52,9 @@ static acpi_status acpi_ut_create_mutex(
 
 static void acpi_ut_delete_mutex(acpi_mutex_handle mutex_id);
 
+DEFINE_RAW_SPINLOCK(acpi_gbl_gpe_lock);
+DEFINE_RAW_SPINLOCK(acpi_gbl_hardware_lock);
+
 /*******************************************************************************
  *
  * FUNCTION:    acpi_ut_mutex_initialize
@@ -81,18 +84,6 @@ acpi_status acpi_ut_mutex_initialize(voi
 		}
 	}
 
-	/* Create the spinlocks for use at interrupt level */
-
-	status = acpi_os_create_lock (&acpi_gbl_gpe_lock);
-	if (ACPI_FAILURE (status)) {
-		return_ACPI_STATUS (status);
-	}
-
-	status = acpi_os_create_lock (&acpi_gbl_hardware_lock);
-	if (ACPI_FAILURE (status)) {
-		return_ACPI_STATUS (status);
-	}
-
 	/* Mutex for _OSI support */
 	status = acpi_os_create_mutex(&acpi_gbl_osi_mutex);
 	if (ACPI_FAILURE(status)) {
@@ -132,13 +123,7 @@ void acpi_ut_mutex_terminate(void)
 
 	acpi_os_delete_mutex(acpi_gbl_osi_mutex);
 
-	/* Delete the spinlocks */
-
-	acpi_os_delete_lock(acpi_gbl_gpe_lock);
-	acpi_os_delete_lock(acpi_gbl_hardware_lock);
-
 	/* Delete the reader/writer lock */
-
 	acpi_ut_delete_rw_lock(&acpi_gbl_namespace_rw_lock);
 	return_VOID;
 }
