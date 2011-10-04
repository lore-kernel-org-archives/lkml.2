Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667Ab1JDUUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:20:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:58217 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933567Ab1JDUT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:19:57 -0400
Date: Tue, 4 Oct 2011 22:19:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.0.6-rt16
Message-ID: <alpine.LFD.2.02.1110042139350.18778@ionos>
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

I'm pleased to announce the 3.0.6-rt16 release.

Changes from 3.0.4-rt14 to 3.0.4-rt15 

   This is an intermediate version to get a rt only delta.
   Please use 3.0.4-rt16!

  * Drop RCU_bh hack (Thanks to Paul McKenney for review and explanation!)

  * Hotplug fix for softirq (Peter Zijlstra) - should fix cpu
    online/offline and poweroff/suspend problems

  * migrate_disable() performance optimizations (Steven Rostedt, Peter Zijlstra)
  
  * workqueue sanitizing (Peter Zijlstra)

  * Reenable adaptive rtmutex spinning

  * ARM split PTL fix (Frank Rowand)

  * MIPS IRQ_NO_THREAD annotations (Venkat Subbiah)

  * x86_64 irq vs. idle_exit fixes (Frederic Weisbecker)

  * tracing fixes (Steven Rostedt)

  * Forced sysrq printing (Frank Rowand)

  * HPET MSI disable for Lenovo W510

  * Raw spinlock annotations (Frank Rowand)

  * !RT compile fix (John Kacur)

  * Rtmutex debug RCU fix

  * Some cherry picked mainline fixes

Delta patch against 3.0.4-rt14

  https://tglx.de/~tglx/rt/older/patch-3.0.4-rt14-rt15.patch.gz

also appended below.


Changes from 3.0.4-rt15 to 3.0.6-rt16

   * Update to 3.0.6 (Dropped a few patches which made it into 3.0.6)


Patch against 3.0.6 can be found here:

  https://tglx.de/~tglx/rt/patch-3.0.6-rt16.patch.gz


The split quilt queue is available at:

  https://tglx.de/~tglx/rt/patches-3.0.6-rt16.tar.gz

Enjoy,

	tglx

--------------->
Index: linux-2.6/arch/arm/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/process.c
+++ linux-2.6/arch/arm/kernel/process.c
@@ -484,6 +484,31 @@ unsigned long arch_randomize_brk(struct 
 }
 
 #ifdef CONFIG_MMU
+
+/*
+ * CONFIG_SPLIT_PTLOCK_CPUS results in a page->ptl lock.  If the lock is not
+ * initialized by pgtable_page_ctor() then a coredump of the vector page will
+ * fail.
+ */
+static int __init vectors_user_mapping_init_page(void)
+{
+	struct page *page;
+	unsigned long addr = 0xffff0000;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	pgd = pgd_offset_k(addr);
+	pud = pud_offset(pgd, addr);
+	pmd = pmd_offset(pud, addr);
+	page = pmd_page(*(pmd));
+
+	pgtable_page_ctor(page);
+
+	return 0;
+}
+late_initcall(vectors_user_mapping_init_page);
+
 /*
  * The vectors page is always readable from user space for the
  * atomic helpers and the signal restart code.  Let's declare a mapping
Index: linux-2.6/arch/arm/plat-mxc/include/mach/iomux-v3.h
===================================================================
--- linux-2.6.orig/arch/arm/plat-mxc/include/mach/iomux-v3.h
+++ linux-2.6/arch/arm/plat-mxc/include/mach/iomux-v3.h
@@ -66,6 +66,7 @@ typedef u64 iomux_v3_cfg_t;
 #define MUX_MODE_MASK		((iomux_v3_cfg_t)0x1f << MUX_MODE_SHIFT)
 #define MUX_PAD_CTRL_SHIFT	41
 #define MUX_PAD_CTRL_MASK	((iomux_v3_cfg_t)0x1ffff << MUX_PAD_CTRL_SHIFT)
+#define NO_PAD_CTRL		((iomux_v3_cfg_t)1 << (MUX_PAD_CTRL_SHIFT + 16))
 #define MUX_SEL_INPUT_SHIFT	58
 #define MUX_SEL_INPUT_MASK	((iomux_v3_cfg_t)0xf << MUX_SEL_INPUT_SHIFT)
 
@@ -84,7 +85,6 @@ typedef u64 iomux_v3_cfg_t;
  * Use to set PAD control
  */
 
-#define NO_PAD_CTRL			(1 << 16)
 #define PAD_CTL_DVS			(1 << 13)
 #define PAD_CTL_HYS			(1 << 8)
 
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -2275,8 +2275,8 @@ asmlinkage void smp_irq_move_cleanup_int
 	unsigned vector, me;
 
 	ack_APIC_irq();
-	exit_idle();
 	irq_enter();
+	exit_idle();
 
 	me = smp_processor_id();
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
@@ -471,8 +471,8 @@ static inline void mce_get_rip(struct mc
 asmlinkage void smp_mce_self_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	mce_notify_irq();
 	mce_schedule_work();
 	irq_exit();
Index: linux-2.6/include/linux/cpu.h
===================================================================
--- linux-2.6.orig/include/linux/cpu.h
+++ linux-2.6/include/linux/cpu.h
@@ -60,14 +60,16 @@ enum {
 	 */
 	CPU_PRI_SCHED_ACTIVE	= INT_MAX,
 	CPU_PRI_CPUSET_ACTIVE	= INT_MAX - 1,
-	CPU_PRI_SCHED_INACTIVE	= INT_MIN + 1,
-	CPU_PRI_CPUSET_INACTIVE	= INT_MIN,
 
 	/* migration should happen before other stuff but after perf */
-	CPU_PRI_PERF		= 20,
-	CPU_PRI_MIGRATION	= 10,
-	/* prepare workqueues for other notifiers */
-	CPU_PRI_WORKQUEUE	= 5,
+	CPU_PRI_PERF			= 20,
+	CPU_PRI_MIGRATION		= 10,
+	CPU_PRI_WORKQUEUE_ACTIVE	= 5,  /* prepare workqueues for others */
+	CPU_PRI_NORMAL			= 0,
+	CPU_PRI_WORKQUEUE_INACTIVE	= -5, /* flush workqueues after others */
+
+	CPU_PRI_SCHED_INACTIVE	= INT_MIN + 1,
+	CPU_PRI_CPUSET_INACTIVE	= INT_MIN,
 };
 
 #ifdef CONFIG_SMP
Index: linux-2.6/include/linux/rcupdate.h
===================================================================
--- linux-2.6.orig/include/linux/rcupdate.h
+++ linux-2.6/include/linux/rcupdate.h
@@ -78,13 +78,7 @@ struct rcu_head {
 extern void call_rcu_sched(struct rcu_head *head,
 			   void (*func)(struct rcu_head *rcu));
 extern void synchronize_sched(void);
-
-#ifdef CONFIG_PREEMPT_RT_FULL
-# define rcu_barrier_bh		rcu_barrier
-#else
 extern void rcu_barrier_bh(void);
-#endif
-
 extern void rcu_barrier_sched(void);
 
 static inline void __rcu_read_lock_bh(void)
@@ -144,13 +138,7 @@ static inline int rcu_preempt_depth(void
 
 /* Internal to kernel */
 extern void rcu_sched_qs(int cpu);
-
-#ifndef CONFIG_PREEMPT_RT_FULL
 extern void rcu_bh_qs(int cpu);
-#else
-static inline void rcu_bh_qs(int cpu) { }
-#endif
-
 extern void rcu_check_callbacks(int cpu, int user);
 struct notifier_block;
 
@@ -241,14 +229,7 @@ static inline int rcu_read_lock_held(voi
  * rcu_read_lock_bh_held() is defined out of line to avoid #include-file
  * hell.
  */
-#ifdef CONFIG_PREEMPT_RT_FULL
-static inline int rcu_read_lock_bh_held(void)
-{
-	return rcu_read_lock_held();
-}
-#else
 extern int rcu_read_lock_bh_held(void);
-#endif
 
 /**
  * rcu_read_lock_sched_held() - might we be in RCU-sched read-side critical section?
@@ -657,13 +638,8 @@ static inline void rcu_read_unlock(void)
 static inline void rcu_read_lock_bh(void)
 {
 	__rcu_read_lock_bh();
-
-#ifdef CONFIG_PREEMPT_RT_FULL
-	rcu_read_lock();
-#else
 	__acquire(RCU_BH);
 	rcu_read_acquire_bh();
-#endif
 }
 
 /*
@@ -673,12 +649,8 @@ static inline void rcu_read_lock_bh(void
  */
 static inline void rcu_read_unlock_bh(void)
 {
-#ifdef CONFIG_PREEMPT_RT_FULL
-	rcu_read_unlock();
-#else
 	rcu_read_release_bh();
 	__release(RCU_BH);
-#endif
 	__rcu_read_unlock_bh();
 }
 
@@ -785,9 +757,6 @@ extern void call_rcu(struct rcu_head *he
 
 #endif /* #else #ifdef CONFIG_PREEMPT_RCU */
 
-#ifdef CONFIG_PREEMPT_RT_FULL
-#define call_rcu_bh	call_rcu
-#else
 /**
  * call_rcu_bh() - Queue an RCU for invocation after a quicker grace period.
  * @head: structure to be used for queueing the RCU updates.
@@ -808,7 +777,6 @@ extern void call_rcu(struct rcu_head *he
  */
 extern void call_rcu_bh(struct rcu_head *head,
 			void (*func)(struct rcu_head *head));
-#endif
 
 /*
  * debug_rcu_head_queue()/debug_rcu_head_unqueue() are used internally
Index: linux-2.6/include/linux/rcutree.h
===================================================================
--- linux-2.6.orig/include/linux/rcutree.h
+++ linux-2.6/include/linux/rcutree.h
@@ -57,11 +57,7 @@ static inline void exit_rcu(void)
 
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
-#ifndef CONFIG_PREEMPT_RT_FULL
 extern void synchronize_rcu_bh(void);
-#else
-# define synchronize_rcu_bh()	synchronize_rcu()
-#endif
 extern void synchronize_sched_expedited(void);
 extern void synchronize_rcu_expedited(void);
 
@@ -75,18 +71,12 @@ extern void rcu_barrier(void);
 extern unsigned long rcutorture_testseq;
 extern unsigned long rcutorture_vernum;
 extern long rcu_batches_completed(void);
+extern long rcu_batches_completed_bh(void);
 extern long rcu_batches_completed_sched(void);
 
 extern void rcu_force_quiescent_state(void);
-extern void rcu_sched_force_quiescent_state(void);
-
-#ifndef CONFIG_PREEMPT_RT_FULL
 extern void rcu_bh_force_quiescent_state(void);
-extern long rcu_batches_completed_bh(void);
-#else
-# define rcu_bh_force_quiescent_state	rcu_force_quiescent_state
-# define rcu_batches_completed_bh	rcu_batches_completed
-#endif
+extern void rcu_sched_force_quiescent_state(void);
 
 /* A context switch is a grace period for RCU-sched and RCU-bh. */
 static inline int rcu_blocking_is_gp(void)
Index: linux-2.6/include/linux/rwlock_types.h
===================================================================
--- linux-2.6.orig/include/linux/rwlock_types.h
+++ linux-2.6/include/linux/rwlock_types.h
@@ -47,6 +47,7 @@ typedef struct {
 				RW_DEP_MAP_INIT(lockname) }
 #endif
 
-#define DEFINE_RWLOCK(x)	rwlock_t x = __RW_LOCK_UNLOCKED(x)
+#define DEFINE_RWLOCK(name) \
+	rwlock_t name __cacheline_aligned_in_smp = __RW_LOCK_UNLOCKED(name)
 
 #endif /* __LINUX_RWLOCK_TYPES_H */
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -87,7 +87,7 @@ int max_threads;		/* tunable limit on nr
 
 DEFINE_PER_CPU(unsigned long, process_counts) = 0;
 
-__cacheline_aligned DEFINE_RWLOCK(tasklist_lock);  /* outer */
+DEFINE_RWLOCK(tasklist_lock);  /* outer */
 
 #ifdef CONFIG_PROVE_RCU
 int lockdep_tasklist_lock_is_held(void)
Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -21,6 +21,7 @@
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/console.h>
+#include <linux/sysrq.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
 #include <linux/nmi.h>
@@ -831,8 +832,8 @@ static int console_trylock_for_printk(un
 	__releases(&logbuf_lock)
 {
 #ifdef CONFIG_PREEMPT_RT_FULL
-	int lock = !early_boot_irqs_disabled && !irqs_disabled_flags(flags) &&
-		!preempt_count();
+	int lock = (!early_boot_irqs_disabled && !irqs_disabled_flags(flags) &&
+		!preempt_count()) || sysrq_in_progress;
 #else
 	int lock = 1;
 #endif
Index: linux-2.6/kernel/rcupdate.c
===================================================================
--- linux-2.6.orig/kernel/rcupdate.c
+++ linux-2.6/kernel/rcupdate.c
@@ -72,7 +72,6 @@ int debug_lockdep_rcu_enabled(void)
 }
 EXPORT_SYMBOL_GPL(debug_lockdep_rcu_enabled);
 
-#ifndef CONFIG_PREEMPT_RT_FULL
 /**
  * rcu_read_lock_bh_held() - might we be in RCU-bh read-side critical section?
  *
@@ -92,7 +91,6 @@ int rcu_read_lock_bh_held(void)
 	return in_softirq() || irqs_disabled();
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
-#endif
 
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
Index: linux-2.6/kernel/rcutree.c
===================================================================
--- linux-2.6.orig/kernel/rcutree.c
+++ linux-2.6/kernel/rcutree.c
@@ -166,7 +166,6 @@ void rcu_sched_qs(int cpu)
 	rdp->passed_quiesc = 1;
 }
 
-#ifndef CONFIG_PREEMPT_RT_FULL
 void rcu_bh_qs(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
@@ -175,7 +174,6 @@ void rcu_bh_qs(int cpu)
 	barrier();
 	rdp->passed_quiesc = 1;
 }
-#endif
 
 /*
  * Note a context switch.  This is a quiescent state for RCU-sched,
@@ -218,7 +216,6 @@ long rcu_batches_completed_sched(void)
 }
 EXPORT_SYMBOL_GPL(rcu_batches_completed_sched);
 
-#ifndef CONFIG_PREEMPT_RT_FULL
 /*
  * Return the number of RCU BH batches processed thus far for debug & stats.
  */
@@ -236,7 +233,6 @@ void rcu_bh_force_quiescent_state(void)
 	force_quiescent_state(&rcu_bh_state, 0);
 }
 EXPORT_SYMBOL_GPL(rcu_bh_force_quiescent_state);
-#endif
 
 /*
  * Record the number of times rcutorture tests have been initiated and
@@ -1583,7 +1579,6 @@ void call_rcu_sched(struct rcu_head *hea
 }
 EXPORT_SYMBOL_GPL(call_rcu_sched);
 
-#ifndef CONFIG_PREEMPT_RT_FULL
 /*
  * Queue an RCU for invocation after a quicker grace period.
  */
@@ -1592,7 +1587,6 @@ void call_rcu_bh(struct rcu_head *head, 
 	__call_rcu(head, func, &rcu_bh_state);
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
-#endif
 
 /**
  * synchronize_sched - wait until an rcu-sched grace period has elapsed.
@@ -1634,7 +1628,6 @@ void synchronize_sched(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_sched);
 
-#ifndef CONFIG_PREEMPT_RT_FULL
 /**
  * synchronize_rcu_bh - wait until an rcu_bh grace period has elapsed.
  *
@@ -1660,7 +1653,6 @@ void synchronize_rcu_bh(void)
 	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
-#endif
 
 /*
  * Check to see if there is any immediate RCU-related work to be done
@@ -1814,7 +1806,6 @@ static void _rcu_barrier(struct rcu_stat
 	mutex_unlock(&rcu_barrier_mutex);
 }
 
-#ifndef CONFIG_PREEMPT_RT_FULL
 /**
  * rcu_barrier_bh - Wait until all in-flight call_rcu_bh() callbacks complete.
  */
@@ -1823,7 +1814,6 @@ void rcu_barrier_bh(void)
 	_rcu_barrier(&rcu_bh_state, call_rcu_bh);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_bh);
-#endif
 
 /**
  * rcu_barrier_sched - Wait for in-flight call_rcu_sched() callbacks.
Index: linux-2.6/kernel/rtmutex-debug.c
===================================================================
--- linux-2.6.orig/kernel/rtmutex-debug.c
+++ linux-2.6/kernel/rtmutex-debug.c
@@ -94,8 +94,10 @@ void debug_rt_mutex_print_deadlock(struc
 		return;
 	}
 
-	if (!debug_locks_off())
+	if (!debug_locks_off()) {
+		rcu_read_unlock();
 		return;
+	}
 
 	printk("\n============================================\n");
 	printk(  "[ BUG: circular locking deadlock detected! ]\n");
Index: linux-2.6/kernel/rtmutex.c
===================================================================
--- linux-2.6.orig/kernel/rtmutex.c
+++ linux-2.6/kernel/rtmutex.c
@@ -659,7 +659,7 @@ static inline void rt_spin_lock_fastunlo
 		slowfn(lock);
 }
 
-#ifdef CONFIG_SMP_X
+#ifdef CONFIG_SMP
 /*
  * Note that owner is a speculative pointer and dereferencing relies
  * on rcu_read_lock() and the check against the lock owner.
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4207,6 +4207,126 @@ static inline void schedule_debug(struct
 	schedstat_inc(this_rq(), sched_count);
 }
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+#define MIGRATE_DISABLE_SET_AFFIN	(1<<30) /* Can't make a negative */
+#define migrate_disabled_updated(p)	((p)->migrate_disable & MIGRATE_DISABLE_SET_AFFIN)
+#define migrate_disable_count(p)	((p)->migrate_disable & ~MIGRATE_DISABLE_SET_AFFIN)
+
+static inline void update_migrate_disable(struct task_struct *p)
+{
+	const struct cpumask *mask;
+
+	if (likely(!p->migrate_disable))
+		return;
+
+	/* Did we already update affinity? */
+	if (unlikely(migrate_disabled_updated(p)))
+		return;
+
+	/*
+	 * Since this is always current we can get away with only locking
+	 * rq->lock, the ->cpus_allowed value can normally only be changed
+	 * while holding both p->pi_lock and rq->lock, but seeing that this
+	 * is current, we cannot actually be waking up, so all code that
+	 * relies on serialization against p->pi_lock is out of scope.
+	 *
+	 * Having rq->lock serializes us against things like
+	 * set_cpus_allowed_ptr() that can still happen concurrently.
+	 */
+	mask = tsk_cpus_allowed(p);
+
+	if (p->sched_class->set_cpus_allowed)
+		p->sched_class->set_cpus_allowed(p, mask);
+	p->rt.nr_cpus_allowed = cpumask_weight(mask);
+
+	/* Let migrate_enable know to fix things back up */
+	p->migrate_disable |= MIGRATE_DISABLE_SET_AFFIN;
+}
+
+void migrate_disable(void)
+{
+	struct task_struct *p = current;
+
+	if (in_atomic() || p->flags & PF_THREAD_BOUND) {
+#ifdef CONFIG_SCHED_DEBUG
+		p->migrate_disable_atomic++;
+#endif
+		return;
+	}
+
+#ifdef CONFIG_SCHED_DEBUG
+	WARN_ON_ONCE(p->migrate_disable_atomic);
+#endif
+
+	preempt_disable();
+	if (p->migrate_disable) {
+		p->migrate_disable++;
+		preempt_enable();
+		return;
+	}
+
+	pin_current_cpu();
+	p->migrate_disable = 1;
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(migrate_disable);
+
+void migrate_enable(void)
+{
+	struct task_struct *p = current;
+	const struct cpumask *mask;
+	unsigned long flags;
+	struct rq *rq;
+
+	if (in_atomic() || p->flags & PF_THREAD_BOUND) {
+#ifdef CONFIG_SCHED_DEBUG
+		p->migrate_disable_atomic--;
+#endif
+		return;
+	}
+
+#ifdef CONFIG_SCHED_DEBUG
+	WARN_ON_ONCE(p->migrate_disable_atomic);
+#endif
+	WARN_ON_ONCE(p->migrate_disable <= 0);
+
+	preempt_disable();
+	if (migrate_disable_count(p) > 1) {
+		p->migrate_disable--;
+		preempt_enable();
+		return;
+	}
+
+	if (unlikely(migrate_disabled_updated(p))) {
+		/*
+		 * Undo whatever update_migrate_disable() did, also see there
+		 * about locking.
+		 */
+		rq = this_rq();
+		raw_spin_lock_irqsave(&rq->lock, flags);
+
+		/*
+		 * Clearing migrate_disable causes tsk_cpus_allowed to
+		 * show the tasks original cpu affinity.
+		 */
+		p->migrate_disable = 0;
+		mask = tsk_cpus_allowed(p);
+		if (p->sched_class->set_cpus_allowed)
+			p->sched_class->set_cpus_allowed(p, mask);
+		p->rt.nr_cpus_allowed = cpumask_weight(mask);
+		raw_spin_unlock_irqrestore(&rq->lock, flags);
+	} else
+		p->migrate_disable = 0;
+
+	unpin_current_cpu();
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(migrate_enable);
+#else
+static inline void update_migrate_disable(struct task_struct *p) { }
+#define migrate_disabled_updated(p)		0
+#endif
+
 static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
 	if (prev->on_rq || rq->skip_clock_update < 0)
@@ -4266,6 +4386,8 @@ need_resched:
 
 	raw_spin_lock_irq(&rq->lock);
 
+	update_migrate_disable(prev);
+
 	switch_count = &prev->nivcsw;
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		if (unlikely(signal_pending_state(prev->state, prev))) {
@@ -4433,7 +4555,16 @@ asmlinkage void __sched notrace preempt_
 
 	do {
 		add_preempt_count_notrace(PREEMPT_ACTIVE);
+		/*
+		 * The add/subtract must not be traced by the function
+		 * tracer. But we still want to account for the
+		 * preempt off latency tracer. Since the _notrace versions
+		 * of add/subtract skip the accounting for latency tracer
+		 * we must force it manually.
+		 */
+		start_critical_timings();
 		__schedule();
+		stop_critical_timings();
 		sub_preempt_count_notrace(PREEMPT_ACTIVE);
 
 		/*
@@ -6058,7 +6189,7 @@ static inline void sched_init_granularit
 #ifdef CONFIG_SMP
 void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 {
-	if (!__migrate_disabled(p)) {
+	if (!migrate_disabled_updated(p)) {
 		if (p->sched_class && p->sched_class->set_cpus_allowed)
 			p->sched_class->set_cpus_allowed(p, new_mask);
 		p->rt.nr_cpus_allowed = cpumask_weight(new_mask);
@@ -6133,124 +6264,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
 
-#ifdef CONFIG_PREEMPT_RT_FULL
-void migrate_disable(void)
-{
-	struct task_struct *p = current;
-	const struct cpumask *mask;
-	unsigned long flags;
-	struct rq *rq;
-
-	if (in_atomic()) {
-#ifdef CONFIG_SCHED_DEBUG
-		p->migrate_disable_atomic++;
-#endif
-		return;
-	}
-
-#ifdef CONFIG_SCHED_DEBUG
-	WARN_ON_ONCE(p->migrate_disable_atomic);
-#endif
-
-	preempt_disable();
-	if (p->migrate_disable) {
-		p->migrate_disable++;
-		preempt_enable();
-		return;
-	}
-
-	pin_current_cpu();
-	if (unlikely(!scheduler_running)) {
-		p->migrate_disable = 1;
-		preempt_enable();
-		return;
-	}
-
-	/*
-	 * Since this is always current we can get away with only locking
-	 * rq->lock, the ->cpus_allowed value can normally only be changed
-	 * while holding both p->pi_lock and rq->lock, but seeing that this
-	 * it current, we cannot actually be waking up, so all code that
-	 * relies on serialization against p->pi_lock is out of scope.
-	 *
-	 * Taking rq->lock serializes us against things like
-	 * set_cpus_allowed_ptr() that can still happen concurrently.
-	 */
-	rq = this_rq();
-	raw_spin_lock_irqsave(&rq->lock, flags);
-	p->migrate_disable = 1;
-	mask = tsk_cpus_allowed(p);
-
-	WARN_ON(!cpumask_test_cpu(smp_processor_id(), mask));
-
-	if (!cpumask_equal(&p->cpus_allowed, mask)) {
-		if (p->sched_class->set_cpus_allowed)
-			p->sched_class->set_cpus_allowed(p, mask);
-		p->rt.nr_cpus_allowed = cpumask_weight(mask);
-	}
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-	preempt_enable();
-}
-EXPORT_SYMBOL_GPL(migrate_disable);
-
-void migrate_enable(void)
-{
-	struct task_struct *p = current;
-	const struct cpumask *mask;
-	unsigned long flags;
-	struct rq *rq;
-
-	if (in_atomic()) {
-#ifdef CONFIG_SCHED_DEBUG
-		p->migrate_disable_atomic--;
-#endif
-		return;
-	}
-
-#ifdef CONFIG_SCHED_DEBUG
-	WARN_ON_ONCE(p->migrate_disable_atomic);
-#endif
-	WARN_ON_ONCE(p->migrate_disable <= 0);
-
-	preempt_disable();
-	if (p->migrate_disable > 1) {
-		p->migrate_disable--;
-		preempt_enable();
-		return;
-	}
-
-	if (unlikely(!scheduler_running)) {
-		p->migrate_disable = 0;
-		unpin_current_cpu();
-		preempt_enable();
-		return;
-	}
-
-	/*
-	 * See comment in migrate_disable().
-	 */
-	rq = this_rq();
-	raw_spin_lock_irqsave(&rq->lock, flags);
-	mask = tsk_cpus_allowed(p);
-	p->migrate_disable = 0;
-
-	WARN_ON(!cpumask_test_cpu(smp_processor_id(), mask));
-
-	if (!cpumask_equal(&p->cpus_allowed, mask)) {
-		/* Get the mask now that migration is enabled */
-		mask = tsk_cpus_allowed(p);
-		if (p->sched_class->set_cpus_allowed)
-			p->sched_class->set_cpus_allowed(p, mask);
-		p->rt.nr_cpus_allowed = cpumask_weight(mask);
-	}
-
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-	unpin_current_cpu();
-	preempt_enable();
-}
-EXPORT_SYMBOL_GPL(migrate_enable);
-#endif /* CONFIG_PREEMPT_RT_FULL */
-
 /*
  * Move (not current) task off this cpu, onto dest cpu. We're doing
  * this because either it can't run here any more (set_cpus_allowed()
Index: linux-2.6/kernel/signal.c
===================================================================
--- linux-2.6.orig/kernel/signal.c
+++ linux-2.6/kernel/signal.c
@@ -1860,15 +1860,7 @@ static void ptrace_stop(int exit_code, i
 		if (gstop_done && !real_parent_is_ptracer(current))
 			do_notify_parent_cldstop(current, false, why);
 
-		/*
-		 * Don't want to allow preemption here, because
-		 * sys_ptrace() needs this task to be inactive.
-		 *
-		 * XXX: implement read_unlock_no_resched().
-		 */
-		preempt_disable();
 		read_unlock(&tasklist_lock);
-		__preempt_enable_no_resched();
 		schedule();
 	} else {
 		/*
Index: linux-2.6/kernel/softirq.c
===================================================================
--- linux-2.6.orig/kernel/softirq.c
+++ linux-2.6/kernel/softirq.c
@@ -1104,9 +1104,8 @@ static int __cpuinit cpu_callback(struct
 	int hotcpu = (unsigned long)hcpu;
 	struct task_struct *p;
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		p = kthread_create_on_node(run_ksoftirqd,
 					   hcpu,
 					   cpu_to_node(hotcpu),
@@ -1119,19 +1118,16 @@ static int __cpuinit cpu_callback(struct
   		per_cpu(ksoftirqd, hotcpu) = p;
  		break;
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		wake_up_process(per_cpu(ksoftirqd, hotcpu));
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 		if (!per_cpu(ksoftirqd, hotcpu))
 			break;
 		/* Unbind so it can run.  Fall thru. */
 		kthread_bind(per_cpu(ksoftirqd, hotcpu),
 			     cpumask_any(cpu_online_mask));
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN: {
+	case CPU_POST_DEAD: {
 		static const struct sched_param param = {
 			.sched_priority = MAX_RT_PRIO-1
 		};
Index: linux-2.6/kernel/time/Kconfig
===================================================================
--- linux-2.6.orig/kernel/time/Kconfig
+++ linux-2.6/kernel/time/Kconfig
@@ -7,7 +7,6 @@ config TICK_ONESHOT
 config NO_HZ
 	bool "Tickless System (Dynamic Ticks)"
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
-	depends on !PREEMPT_RT_FULL
 	select TICK_ONESHOT
 	help
 	  This option enables a tickless system: timer interrupts will
Index: linux-2.6/kernel/trace/ring_buffer.c
===================================================================
--- linux-2.6.orig/kernel/trace/ring_buffer.c
+++ linux-2.6/kernel/trace/ring_buffer.c
@@ -478,7 +478,7 @@ struct ring_buffer_per_cpu {
 	int				cpu;
 	atomic_t			record_disabled;
 	struct ring_buffer		*buffer;
-	raw_spinlock_t			reader_lock;	/* serialize readers */
+	spinlock_t			reader_lock;	/* serialize readers */
 	arch_spinlock_t			lock;
 	struct lock_class_key		lock_key;
 	struct list_head		*pages;
@@ -1040,6 +1040,44 @@ static int rb_allocate_pages(struct ring
 	return -ENOMEM;
 }
 
+static inline int ok_to_lock(void)
+{
+	if (in_nmi())
+		return 0;
+#ifdef CONFIG_PREEMPT_RT_FULL
+	if (in_atomic())
+		return 0;
+#endif
+	return 1;
+}
+
+static int
+read_buffer_lock(struct ring_buffer_per_cpu *cpu_buffer,
+		 unsigned long *flags)
+{
+	/*
+	 * If an NMI die dumps out the content of the ring buffer
+	 * do not grab locks. We also permanently disable the ring
+	 * buffer too. A one time deal is all you get from reading
+	 * the ring buffer from an NMI.
+	 */
+	if (!ok_to_lock()) {
+		if (spin_trylock_irqsave(&cpu_buffer->reader_lock, *flags))
+			return 1;
+		tracing_off_permanent();
+		return 0;
+	}
+	spin_lock_irqsave(&cpu_buffer->reader_lock, *flags);
+	return 1;
+}
+
+static void
+read_buffer_unlock(struct ring_buffer_per_cpu *cpu_buffer,
+		   unsigned long flags, int locked)
+{
+	if (locked)
+		spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+}
 static struct ring_buffer_per_cpu *
 rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 {
@@ -1055,7 +1093,7 @@ rb_allocate_cpu_buffer(struct ring_buffe
 
 	cpu_buffer->cpu = cpu;
 	cpu_buffer->buffer = buffer;
-	raw_spin_lock_init(&cpu_buffer->reader_lock);
+	spin_lock_init(&cpu_buffer->reader_lock);
 	lockdep_set_class(&cpu_buffer->reader_lock, buffer->reader_lock_key);
 	cpu_buffer->lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
@@ -1250,9 +1288,11 @@ rb_remove_pages(struct ring_buffer_per_c
 {
 	struct buffer_page *bpage;
 	struct list_head *p;
+	unsigned long flags;
 	unsigned i;
+	int locked;
 
-	raw_spin_lock_irq(&cpu_buffer->reader_lock);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 	rb_head_page_deactivate(cpu_buffer);
 
 	for (i = 0; i < nr_pages; i++) {
@@ -1270,7 +1310,7 @@ rb_remove_pages(struct ring_buffer_per_c
 	rb_check_pages(cpu_buffer);
 
 out:
-	raw_spin_unlock_irq(&cpu_buffer->reader_lock);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 }
 
 static void
@@ -1279,9 +1319,11 @@ rb_insert_pages(struct ring_buffer_per_c
 {
 	struct buffer_page *bpage;
 	struct list_head *p;
+	unsigned long flags;
 	unsigned i;
+	int locked;
 
-	raw_spin_lock_irq(&cpu_buffer->reader_lock);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 	rb_head_page_deactivate(cpu_buffer);
 
 	for (i = 0; i < nr_pages; i++) {
@@ -1296,7 +1338,7 @@ rb_insert_pages(struct ring_buffer_per_c
 	rb_check_pages(cpu_buffer);
 
 out:
-	raw_spin_unlock_irq(&cpu_buffer->reader_lock);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 }
 
 /**
@@ -2784,15 +2826,16 @@ void ring_buffer_iter_reset(struct ring_
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long flags;
+	int locked;
 
 	if (!iter)
 		return;
 
 	cpu_buffer = iter->cpu_buffer;
 
-	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 	rb_iter_reset(iter);
-	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_iter_reset);
 
@@ -3210,21 +3253,6 @@ rb_iter_peek(struct ring_buffer_iter *it
 }
 EXPORT_SYMBOL_GPL(ring_buffer_iter_peek);
 
-static inline int rb_ok_to_lock(void)
-{
-	/*
-	 * If an NMI die dumps out the content of the ring buffer
-	 * do not grab locks. We also permanently disable the ring
-	 * buffer too. A one time deal is all you get from reading
-	 * the ring buffer from an NMI.
-	 */
-	if (likely(!in_nmi()))
-		return 1;
-
-	tracing_off_permanent();
-	return 0;
-}
-
 /**
  * ring_buffer_peek - peek at the next event to be read
  * @buffer: The ring buffer to read
@@ -3242,22 +3270,17 @@ ring_buffer_peek(struct ring_buffer *buf
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
 	struct ring_buffer_event *event;
 	unsigned long flags;
-	int dolock;
+	int locked;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return NULL;
 
-	dolock = rb_ok_to_lock();
  again:
-	local_irq_save(flags);
-	if (dolock)
-		raw_spin_lock(&cpu_buffer->reader_lock);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 	event = rb_buffer_peek(cpu_buffer, ts, lost_events);
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		rb_advance_reader(cpu_buffer);
-	if (dolock)
-		raw_spin_unlock(&cpu_buffer->reader_lock);
-	local_irq_restore(flags);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		goto again;
@@ -3279,11 +3302,12 @@ ring_buffer_iter_peek(struct ring_buffer
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
 	struct ring_buffer_event *event;
 	unsigned long flags;
+	int locked;
 
  again:
-	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 	event = rb_iter_peek(iter, ts);
-	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		goto again;
@@ -3309,9 +3333,7 @@ ring_buffer_consume(struct ring_buffer *
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event = NULL;
 	unsigned long flags;
-	int dolock;
-
-	dolock = rb_ok_to_lock();
+	int locked;
 
  again:
 	/* might be called in atomic */
@@ -3321,9 +3343,7 @@ ring_buffer_consume(struct ring_buffer *
 		goto out;
 
 	cpu_buffer = buffer->buffers[cpu];
-	local_irq_save(flags);
-	if (dolock)
-		raw_spin_lock(&cpu_buffer->reader_lock);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 
 	event = rb_buffer_peek(cpu_buffer, ts, lost_events);
 	if (event) {
@@ -3331,9 +3351,8 @@ ring_buffer_consume(struct ring_buffer *
 		rb_advance_reader(cpu_buffer);
 	}
 
-	if (dolock)
-		raw_spin_unlock(&cpu_buffer->reader_lock);
-	local_irq_restore(flags);
+	read_buffer_unlock(cpu_buffer, flags, locked);
+
 
  out:
 	preempt_enable();
@@ -3418,17 +3437,18 @@ ring_buffer_read_start(struct ring_buffe
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long flags;
+	int locked;
 
 	if (!iter)
 		return;
 
 	cpu_buffer = iter->cpu_buffer;
 
-	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 	arch_spin_lock(&cpu_buffer->lock);
 	rb_iter_reset(iter);
 	arch_spin_unlock(&cpu_buffer->lock);
-	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_read_start);
 
@@ -3462,8 +3482,9 @@ ring_buffer_read(struct ring_buffer_iter
 	struct ring_buffer_event *event;
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
 	unsigned long flags;
+	int locked;
 
-	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	locked = read_buffer_lock(cpu_buffer, &flags);
  again:
 	event = rb_iter_peek(iter, ts);
 	if (!event)
@@ -3474,7 +3495,7 @@ ring_buffer_read(struct ring_buffer_iter
 
 	rb_advance_iter(iter);
  out:
-	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 
 	return event;
 }
@@ -3537,13 +3558,14 @@ void ring_buffer_reset_cpu(struct ring_b
 {
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
 	unsigned long flags;
+	int locked;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return;
 
 	atomic_inc(&cpu_buffer->record_disabled);
 
-	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 
 	if (RB_WARN_ON(cpu_buffer, local_read(&cpu_buffer->committing)))
 		goto out;
@@ -3555,7 +3577,7 @@ void ring_buffer_reset_cpu(struct ring_b
 	arch_spin_unlock(&cpu_buffer->lock);
 
  out:
-	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 
 	atomic_dec(&cpu_buffer->record_disabled);
 }
@@ -3582,22 +3604,16 @@ int ring_buffer_empty(struct ring_buffer
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long flags;
-	int dolock;
+	int locked;
 	int cpu;
 	int ret;
 
-	dolock = rb_ok_to_lock();
-
 	/* yes this is racy, but if you don't like the race, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
-		local_irq_save(flags);
-		if (dolock)
-			raw_spin_lock(&cpu_buffer->reader_lock);
+		locked = read_buffer_lock(cpu_buffer, &flags);
 		ret = rb_per_cpu_empty(cpu_buffer);
-		if (dolock)
-			raw_spin_unlock(&cpu_buffer->reader_lock);
-		local_irq_restore(flags);
+		read_buffer_unlock(cpu_buffer, flags, locked);
 
 		if (!ret)
 			return 0;
@@ -3616,22 +3632,16 @@ int ring_buffer_empty_cpu(struct ring_bu
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long flags;
-	int dolock;
+	int locked;
 	int ret;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 1;
 
-	dolock = rb_ok_to_lock();
-
 	cpu_buffer = buffer->buffers[cpu];
-	local_irq_save(flags);
-	if (dolock)
-		raw_spin_lock(&cpu_buffer->reader_lock);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 	ret = rb_per_cpu_empty(cpu_buffer);
-	if (dolock)
-		raw_spin_unlock(&cpu_buffer->reader_lock);
-	local_irq_restore(flags);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 
 	return ret;
 }
@@ -3805,6 +3815,7 @@ int ring_buffer_read_page(struct ring_bu
 	unsigned int commit;
 	unsigned int read;
 	u64 save_timestamp;
+	int locked;
 	int ret = -1;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
@@ -3826,7 +3837,7 @@ int ring_buffer_read_page(struct ring_bu
 	if (!bpage)
 		goto out;
 
-	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 
 	reader = rb_get_reader_page(cpu_buffer);
 	if (!reader)
@@ -3949,7 +3960,7 @@ int ring_buffer_read_page(struct ring_bu
 		memset(&bpage->data[commit], 0, BUF_PAGE_SIZE - commit);
 
  out_unlock:
-	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 
  out:
 	return ret;
Index: linux-2.6/kernel/trace/trace_irqsoff.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_irqsoff.c
+++ linux-2.6/kernel/trace/trace_irqsoff.c
@@ -513,14 +513,14 @@ EXPORT_SYMBOL(trace_hardirqs_off_caller)
 void trace_preempt_on(unsigned long a0, unsigned long a1)
 {
 	trace_preemptirqsoff_hist(PREEMPT_ON, 0);
-	if (preempt_trace())
+	if (preempt_trace() && !irq_trace())
 		stop_critical_timing(a0, a1);
 }
 
 void trace_preempt_off(unsigned long a0, unsigned long a1)
 {
-	trace_preemptirqsoff_hist(PREEMPT_OFF, 1);
-	if (preempt_trace())
+	trace_preemptirqsoff_hist(PREEMPT_ON, 1);
+	if (preempt_trace() && !irq_trace())
 		start_critical_timing(a0, a1);
 }
 #endif /* CONFIG_PREEMPT_TRACER */
Index: linux-2.6/kernel/workqueue.c
===================================================================
--- linux-2.6.orig/kernel/workqueue.c
+++ linux-2.6/kernel/workqueue.c
@@ -41,6 +41,7 @@
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
 #include <linux/idr.h>
+#include <linux/delay.h>
 
 #include "workqueue_sched.h"
 
@@ -57,20 +58,10 @@ enum {
 	WORKER_DIE		= 1 << 1,	/* die die die */
 	WORKER_IDLE		= 1 << 2,	/* is idle */
 	WORKER_PREP		= 1 << 3,	/* preparing to run works */
-	WORKER_ROGUE		= 1 << 4,	/* not bound to any cpu */
-	WORKER_REBIND		= 1 << 5,	/* mom is home, come back */
-	WORKER_CPU_INTENSIVE	= 1 << 6,	/* cpu intensive */
-	WORKER_UNBOUND		= 1 << 7,	/* worker is unbound */
-
-	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_ROGUE | WORKER_REBIND |
-				  WORKER_CPU_INTENSIVE | WORKER_UNBOUND,
-
-	/* gcwq->trustee_state */
-	TRUSTEE_START		= 0,		/* start */
-	TRUSTEE_IN_CHARGE	= 1,		/* trustee in charge of gcwq */
-	TRUSTEE_BUTCHER		= 2,		/* butcher workers */
-	TRUSTEE_RELEASE		= 3,		/* release workers */
-	TRUSTEE_DONE		= 4,		/* trustee is done */
+	WORKER_CPU_INTENSIVE	= 1 << 4,	/* cpu intensive */
+	WORKER_UNBOUND		= 1 << 5,	/* worker is unbound */
+
+	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_CPU_INTENSIVE | WORKER_UNBOUND,
 
 	BUSY_WORKER_HASH_ORDER	= 6,		/* 64 pointers */
 	BUSY_WORKER_HASH_SIZE	= 1 << BUSY_WORKER_HASH_ORDER,
@@ -84,7 +75,6 @@ enum {
 						   (min two ticks) */
 	MAYDAY_INTERVAL		= HZ / 10,	/* and then every 100ms */
 	CREATE_COOLDOWN		= HZ,		/* time to breath after fail */
-	TRUSTEE_COOLDOWN	= HZ / 10,	/* for trustee draining */
 
 	/*
 	 * Rescue workers are used only on emergencies and shared by
@@ -136,7 +126,6 @@ struct worker {
 	unsigned long		last_active;	/* L: last active timestamp */
 	unsigned int		flags;		/* X: flags */
 	int			id;		/* I: worker id */
-	struct work_struct	rebind_work;	/* L: rebind worker to cpu */
 	int			sleeping;	/* None */
 };
 
@@ -164,10 +153,8 @@ struct global_cwq {
 
 	struct ida		worker_ida;	/* L: for worker IDs */
 
-	struct task_struct	*trustee;	/* L: for gcwq shutdown */
-	unsigned int		trustee_state;	/* L: trustee state */
-	wait_queue_head_t	trustee_wait;	/* trustee wait */
 	struct worker		*first_idle;	/* L: first idle worker */
+	wait_queue_head_t	idle_wait;
 } ____cacheline_aligned_in_smp;
 
 /*
@@ -971,13 +958,38 @@ static bool is_chained_work(struct workq
 	return false;
 }
 
-static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
-			 struct work_struct *work)
+static void ___queue_work(struct workqueue_struct *wq, struct global_cwq *gcwq,
+			  struct work_struct *work)
 {
-	struct global_cwq *gcwq;
 	struct cpu_workqueue_struct *cwq;
 	struct list_head *worklist;
 	unsigned int work_flags;
+
+	/* gcwq determined, get cwq and queue */
+	cwq = get_cwq(gcwq->cpu, wq);
+	trace_workqueue_queue_work(gcwq->cpu, cwq, work);
+
+	BUG_ON(!list_empty(&work->entry));
+
+	cwq->nr_in_flight[cwq->work_color]++;
+	work_flags = work_color_to_flags(cwq->work_color);
+
+	if (likely(cwq->nr_active < cwq->max_active)) {
+		trace_workqueue_activate_work(work);
+		cwq->nr_active++;
+		worklist = gcwq_determine_ins_pos(gcwq, cwq);
+	} else {
+		work_flags |= WORK_STRUCT_DELAYED;
+		worklist = &cwq->delayed_works;
+	}
+
+	insert_work(cwq, work, worklist, work_flags);
+}
+
+static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
+			 struct work_struct *work)
+{
+	struct global_cwq *gcwq;
 	unsigned long flags;
 
 	debug_work_activate(work);
@@ -1023,27 +1035,32 @@ static void __queue_work(unsigned int cp
 		spin_lock_irqsave(&gcwq->lock, flags);
 	}
 
-	/* gcwq determined, get cwq and queue */
-	cwq = get_cwq(gcwq->cpu, wq);
-	trace_workqueue_queue_work(cpu, cwq, work);
+	___queue_work(wq, gcwq, work);
 
-	BUG_ON(!list_empty(&work->entry));
+	spin_unlock_irqrestore(&gcwq->lock, flags);
+}
 
-	cwq->nr_in_flight[cwq->work_color]++;
-	work_flags = work_color_to_flags(cwq->work_color);
+/**
+ * queue_work_on - queue work on specific cpu
+ * @cpu: CPU number to execute work on
+ * @wq: workqueue to use
+ * @work: work to queue
+ *
+ * Returns 0 if @work was already on a queue, non-zero otherwise.
+ *
+ * We queue the work to a specific CPU, the caller must ensure it
+ * can't go away.
+ */
+static int
+__queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
+{
+	int ret = 0;
 
-	if (likely(cwq->nr_active < cwq->max_active)) {
-		trace_workqueue_activate_work(work);
-		cwq->nr_active++;
-		worklist = gcwq_determine_ins_pos(gcwq, cwq);
-	} else {
-		work_flags |= WORK_STRUCT_DELAYED;
-		worklist = &cwq->delayed_works;
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
+		__queue_work(cpu, wq, work);
+		ret = 1;
 	}
-
-	insert_work(cwq, work, worklist, work_flags);
-
-	spin_unlock_irqrestore(&gcwq->lock, flags);
+	return ret;
 }
 
 /**
@@ -1060,34 +1077,19 @@ int queue_work(struct workqueue_struct *
 {
 	int ret;
 
-	ret = queue_work_on(get_cpu_light(), wq, work);
+	ret = __queue_work_on(get_cpu_light(), wq, work);
 	put_cpu_light();
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(queue_work);
 
-/**
- * queue_work_on - queue work on specific cpu
- * @cpu: CPU number to execute work on
- * @wq: workqueue to use
- * @work: work to queue
- *
- * Returns 0 if @work was already on a queue, non-zero otherwise.
- *
- * We queue the work to a specific CPU, the caller must ensure it
- * can't go away.
- */
 int
 queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
 {
-	int ret = 0;
+	WARN_ON(wq->flags & WQ_NON_AFFINE);
 
-	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
-		__queue_work(cpu, wq, work);
-		ret = 1;
-	}
-	return ret;
+	return __queue_work_on(cpu, wq, work);
 }
 EXPORT_SYMBOL_GPL(queue_work_on);
 
@@ -1133,6 +1135,8 @@ int queue_delayed_work_on(int cpu, struc
 	struct timer_list *timer = &dwork->timer;
 	struct work_struct *work = &dwork->work;
 
+	WARN_ON((wq->flags & WQ_NON_AFFINE) && cpu != -1);
+
 	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
 		unsigned int lcpu;
 
@@ -1198,12 +1202,13 @@ static void worker_enter_idle(struct wor
 	/* idle_list is LIFO */
 	list_add(&worker->entry, &gcwq->idle_list);
 
-	if (likely(!(worker->flags & WORKER_ROGUE))) {
-		if (too_many_workers(gcwq) && !timer_pending(&gcwq->idle_timer))
-			mod_timer(&gcwq->idle_timer,
-				  jiffies + IDLE_WORKER_TIMEOUT);
-	} else
-		wake_up_all(&gcwq->trustee_wait);
+	if (gcwq->nr_idle == gcwq->nr_workers)
+		wake_up_all(&gcwq->idle_wait);
+
+	if (too_many_workers(gcwq) && !timer_pending(&gcwq->idle_timer)) {
+		mod_timer(&gcwq->idle_timer,
+				jiffies + IDLE_WORKER_TIMEOUT);
+	}
 
 	/* sanity check nr_running */
 	WARN_ON_ONCE(gcwq->nr_workers == gcwq->nr_idle &&
@@ -1272,8 +1277,14 @@ __acquires(&gcwq->lock)
 		 * it races with cpu hotunplug operation.  Verify
 		 * against GCWQ_DISASSOCIATED.
 		 */
-		if (!(gcwq->flags & GCWQ_DISASSOCIATED))
+		if (!(gcwq->flags & GCWQ_DISASSOCIATED)) {
+			/*
+			 * Since we're binding to a particular cpu and need to
+			 * stay there for correctness, mark us PF_THREAD_BOUND.
+			 */
+			task->flags |= PF_THREAD_BOUND;
 			set_cpus_allowed_ptr(task, get_cpu_mask(gcwq->cpu));
+		}
 
 		spin_lock_irq(&gcwq->lock);
 		if (gcwq->flags & GCWQ_DISASSOCIATED)
@@ -1295,20 +1306,15 @@ __acquires(&gcwq->lock)
 	}
 }
 
-/*
- * Function for worker->rebind_work used to rebind rogue busy workers
- * to the associated cpu which is coming back online.  This is
- * scheduled by cpu up but can race with other cpu hotplug operations
- * and may be executed twice without intervening cpu down.
- */
-static void worker_rebind_fn(struct work_struct *work)
+static void worker_unbind_and_unlock(struct worker *worker)
 {
-	struct worker *worker = container_of(work, struct worker, rebind_work);
 	struct global_cwq *gcwq = worker->gcwq;
+	struct task_struct *task = worker->task;
 
-	if (worker_maybe_bind_and_lock(worker))
-		worker_clr_flags(worker, WORKER_REBIND);
-
+	/*
+	 * Its no longer required we're PF_THREAD_BOUND, the work is done.
+	 */
+	task->flags &= ~PF_THREAD_BOUND;
 	spin_unlock_irq(&gcwq->lock);
 }
 
@@ -1320,7 +1326,6 @@ static struct worker *alloc_worker(void)
 	if (worker) {
 		INIT_LIST_HEAD(&worker->entry);
 		INIT_LIST_HEAD(&worker->scheduled);
-		INIT_WORK(&worker->rebind_work, worker_rebind_fn);
 		/* on creation a worker is in !idle && prep state */
 		worker->flags = WORKER_PREP;
 	}
@@ -1375,15 +1380,9 @@ static struct worker *create_worker(stru
 	if (IS_ERR(worker->task))
 		goto fail;
 
-	/*
-	 * A rogue worker will become a regular one if CPU comes
-	 * online later on.  Make sure every worker has
-	 * PF_THREAD_BOUND set.
-	 */
 	if (bind && !on_unbound_cpu)
 		kthread_bind(worker->task, gcwq->cpu);
 	else {
-		worker->task->flags |= PF_THREAD_BOUND;
 		if (on_unbound_cpu)
 			worker->flags |= WORKER_UNBOUND;
 	}
@@ -1660,13 +1659,6 @@ static bool manage_workers(struct worker
 
 	gcwq->flags &= ~GCWQ_MANAGING_WORKERS;
 
-	/*
-	 * The trustee might be waiting to take over the manager
-	 * position, tell it we're done.
-	 */
-	if (unlikely(gcwq->trustee))
-		wake_up_all(&gcwq->trustee_wait);
-
 	return ret;
 }
 
@@ -2067,7 +2059,7 @@ repeat:
 		if (keep_working(gcwq))
 			wake_up_worker(gcwq);
 
-		spin_unlock_irq(&gcwq->lock);
+		worker_unbind_and_unlock(rescuer);
 	}
 
 	schedule();
@@ -2963,7 +2955,6 @@ struct workqueue_struct *__alloc_workque
 		if (IS_ERR(rescuer->task))
 			goto err;
 
-		rescuer->task->flags |= PF_THREAD_BOUND;
 		wake_up_process(rescuer->task);
 	}
 
@@ -3177,171 +3168,71 @@ EXPORT_SYMBOL_GPL(work_busy);
  * gcwqs serve mix of short, long and very long running works making
  * blocked draining impractical.
  *
- * This is solved by allowing a gcwq to be detached from CPU, running
- * it with unbound (rogue) workers and allowing it to be reattached
- * later if the cpu comes back online.  A separate thread is created
- * to govern a gcwq in such state and is called the trustee of the
- * gcwq.
- *
- * Trustee states and their descriptions.
- *
- * START	Command state used on startup.  On CPU_DOWN_PREPARE, a
- *		new trustee is started with this state.
- *
- * IN_CHARGE	Once started, trustee will enter this state after
- *		assuming the manager role and making all existing
- *		workers rogue.  DOWN_PREPARE waits for trustee to
- *		enter this state.  After reaching IN_CHARGE, trustee
- *		tries to execute the pending worklist until it's empty
- *		and the state is set to BUTCHER, or the state is set
- *		to RELEASE.
- *
- * BUTCHER	Command state which is set by the cpu callback after
- *		the cpu has went down.  Once this state is set trustee
- *		knows that there will be no new works on the worklist
- *		and once the worklist is empty it can proceed to
- *		killing idle workers.
- *
- * RELEASE	Command state which is set by the cpu callback if the
- *		cpu down has been canceled or it has come online
- *		again.  After recognizing this state, trustee stops
- *		trying to drain or butcher and clears ROGUE, rebinds
- *		all remaining workers back to the cpu and releases
- *		manager role.
- *
- * DONE		Trustee will enter this state after BUTCHER or RELEASE
- *		is complete.
- *
- *          trustee                 CPU                draining
- *         took over                down               complete
- * START -----------> IN_CHARGE -----------> BUTCHER -----------> DONE
- *                        |                     |                  ^
- *                        | CPU is back online  v   return workers |
- *                         ----------------> RELEASE --------------
  */
 
-/**
- * trustee_wait_event_timeout - timed event wait for trustee
- * @cond: condition to wait for
- * @timeout: timeout in jiffies
- *
- * wait_event_timeout() for trustee to use.  Handles locking and
- * checks for RELEASE request.
- *
- * CONTEXT:
- * spin_lock_irq(gcwq->lock) which may be released and regrabbed
- * multiple times.  To be used by trustee.
- *
- * RETURNS:
- * Positive indicating left time if @cond is satisfied, 0 if timed
- * out, -1 if canceled.
- */
-#define trustee_wait_event_timeout(cond, timeout) ({			\
-	long __ret = (timeout);						\
-	while (!((cond) || (gcwq->trustee_state == TRUSTEE_RELEASE)) &&	\
-	       __ret) {							\
-		spin_unlock_irq(&gcwq->lock);				\
-		__wait_event_timeout(gcwq->trustee_wait, (cond) ||	\
-			(gcwq->trustee_state == TRUSTEE_RELEASE),	\
-			__ret);						\
-		spin_lock_irq(&gcwq->lock);				\
-	}								\
-	gcwq->trustee_state == TRUSTEE_RELEASE ? -1 : (__ret);		\
-})
+static int __devinit workqueue_cpu_up_callback(struct notifier_block *nfb,
+						unsigned long action,
+						void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+	struct global_cwq *gcwq = get_gcwq(cpu);
+	struct worker *uninitialized_var(new_worker);
+	unsigned long flags;
 
-/**
- * trustee_wait_event - event wait for trustee
- * @cond: condition to wait for
- *
- * wait_event() for trustee to use.  Automatically handles locking and
- * checks for CANCEL request.
- *
- * CONTEXT:
- * spin_lock_irq(gcwq->lock) which may be released and regrabbed
- * multiple times.  To be used by trustee.
- *
- * RETURNS:
- * 0 if @cond is satisfied, -1 if canceled.
- */
-#define trustee_wait_event(cond) ({					\
-	long __ret1;							\
-	__ret1 = trustee_wait_event_timeout(cond, MAX_SCHEDULE_TIMEOUT);\
-	__ret1 < 0 ? -1 : 0;						\
-})
+	action &= ~CPU_TASKS_FROZEN;
 
-static int __cpuinit trustee_thread(void *__gcwq)
-{
-	struct global_cwq *gcwq = __gcwq;
-	struct worker *worker;
-	struct work_struct *work;
-	struct hlist_node *pos;
-	long rc;
-	int i;
+	switch (action) {
+	case CPU_UP_PREPARE:
+		BUG_ON(gcwq->first_idle);
+		new_worker = create_worker(gcwq, false);
+		if (!new_worker)
+			return NOTIFY_BAD;
+	}
 
-	BUG_ON(gcwq->cpu != smp_processor_id());
+	/* some are called w/ irq disabled, don't disturb irq status */
+	spin_lock_irqsave(&gcwq->lock, flags);
 
-	spin_lock_irq(&gcwq->lock);
-	/*
-	 * Claim the manager position and make all workers rogue.
-	 * Trustee must be bound to the target cpu and can't be
-	 * cancelled.
-	 */
-	BUG_ON(gcwq->cpu != smp_processor_id());
-	rc = trustee_wait_event(!(gcwq->flags & GCWQ_MANAGING_WORKERS));
-	BUG_ON(rc < 0);
+	switch (action) {
+	case CPU_UP_PREPARE:
+		BUG_ON(gcwq->first_idle);
+		gcwq->first_idle = new_worker;
+		break;
 
-	gcwq->flags |= GCWQ_MANAGING_WORKERS;
+	case CPU_UP_CANCELED:
+		destroy_worker(gcwq->first_idle);
+		gcwq->first_idle = NULL;
+		break;
 
-	list_for_each_entry(worker, &gcwq->idle_list, entry)
-		worker->flags |= WORKER_ROGUE;
+	case CPU_ONLINE:
+		spin_unlock_irq(&gcwq->lock);
+		kthread_bind(gcwq->first_idle->task, cpu);
+		spin_lock_irq(&gcwq->lock);
+		gcwq->flags |= GCWQ_MANAGE_WORKERS;
+		start_worker(gcwq->first_idle);
+		gcwq->first_idle = NULL;
+		break;
+	}
 
-	for_each_busy_worker(worker, i, pos, gcwq)
-		worker->flags |= WORKER_ROGUE;
+	spin_unlock_irqrestore(&gcwq->lock, flags);
 
-	/*
-	 * Call schedule() so that we cross rq->lock and thus can
-	 * guarantee sched callbacks see the rogue flag.  This is
-	 * necessary as scheduler callbacks may be invoked from other
-	 * cpus.
-	 */
-	spin_unlock_irq(&gcwq->lock);
-	schedule();
-	spin_lock_irq(&gcwq->lock);
+	return notifier_from_errno(0);
+}
 
-	/*
-	 * Sched callbacks are disabled now.  Zap nr_running.  After
-	 * this, nr_running stays zero and need_more_worker() and
-	 * keep_working() are always true as long as the worklist is
-	 * not empty.
-	 */
-	atomic_set(get_gcwq_nr_running(gcwq->cpu), 0);
+static void flush_gcwq(struct global_cwq *gcwq)
+{
+	struct work_struct *work, *nw;
+	struct worker *worker, *n;
+	LIST_HEAD(non_affine_works);
 
-	spin_unlock_irq(&gcwq->lock);
-	del_timer_sync(&gcwq->idle_timer);
 	spin_lock_irq(&gcwq->lock);
+	list_for_each_entry_safe(work, nw, &gcwq->worklist, entry) {
+		struct workqueue_struct *wq = get_work_cwq(work)->wq;
 
-	/*
-	 * We're now in charge.  Notify and proceed to drain.  We need
-	 * to keep the gcwq running during the whole CPU down
-	 * procedure as other cpu hotunplug callbacks may need to
-	 * flush currently running tasks.
-	 */
-	gcwq->trustee_state = TRUSTEE_IN_CHARGE;
-	wake_up_all(&gcwq->trustee_wait);
-
-	/*
-	 * The original cpu is in the process of dying and may go away
-	 * anytime now.  When that happens, we and all workers would
-	 * be migrated to other cpus.  Try draining any left work.  We
-	 * want to get it over with ASAP - spam rescuers, wake up as
-	 * many idlers as necessary and create new ones till the
-	 * worklist is empty.  Note that if the gcwq is frozen, there
-	 * may be frozen works in freezable cwqs.  Don't declare
-	 * completion while frozen.
-	 */
-	while (gcwq->nr_workers != gcwq->nr_idle ||
-	       gcwq->flags & GCWQ_FREEZING ||
-	       gcwq->trustee_state == TRUSTEE_IN_CHARGE) {
+		if (wq->flags & WQ_NON_AFFINE)
+			list_move(&work->entry, &non_affine_works);
+	}
+
+	while (!list_empty(&gcwq->worklist)) {
 		int nr_works = 0;
 
 		list_for_each_entry(work, &gcwq->worklist, entry) {
@@ -3355,200 +3246,55 @@ static int __cpuinit trustee_thread(void
 			wake_up_process(worker->task);
 		}
 
+		spin_unlock_irq(&gcwq->lock);
+
 		if (need_to_create_worker(gcwq)) {
-			spin_unlock_irq(&gcwq->lock);
-			worker = create_worker(gcwq, false);
-			spin_lock_irq(&gcwq->lock);
-			if (worker) {
-				worker->flags |= WORKER_ROGUE;
+			worker = create_worker(gcwq, true);
+			if (worker)
 				start_worker(worker);
-			}
 		}
 
-		/* give a breather */
-		if (trustee_wait_event_timeout(false, TRUSTEE_COOLDOWN) < 0)
-			break;
-	}
-
-	/*
-	 * Either all works have been scheduled and cpu is down, or
-	 * cpu down has already been canceled.  Wait for and butcher
-	 * all workers till we're canceled.
-	 */
-	do {
-		rc = trustee_wait_event(!list_empty(&gcwq->idle_list));
-		while (!list_empty(&gcwq->idle_list))
-			destroy_worker(list_first_entry(&gcwq->idle_list,
-							struct worker, entry));
-	} while (gcwq->nr_workers && rc >= 0);
-
-	/*
-	 * At this point, either draining has completed and no worker
-	 * is left, or cpu down has been canceled or the cpu is being
-	 * brought back up.  There shouldn't be any idle one left.
-	 * Tell the remaining busy ones to rebind once it finishes the
-	 * currently scheduled works by scheduling the rebind_work.
-	 */
-	WARN_ON(!list_empty(&gcwq->idle_list));
+		wait_event_timeout(gcwq->idle_wait,
+				gcwq->nr_idle == gcwq->nr_workers, HZ/10);
 
-	for_each_busy_worker(worker, i, pos, gcwq) {
-		struct work_struct *rebind_work = &worker->rebind_work;
+		spin_lock_irq(&gcwq->lock);
+	}
 
-		/*
-		 * Rebind_work may race with future cpu hotplug
-		 * operations.  Use a separate flag to mark that
-		 * rebinding is scheduled.
-		 */
-		worker->flags |= WORKER_REBIND;
-		worker->flags &= ~WORKER_ROGUE;
+	WARN_ON(gcwq->nr_workers != gcwq->nr_idle);
 
-		/* queue rebind_work, wq doesn't matter, use the default one */
-		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
-				     work_data_bits(rebind_work)))
-			continue;
+	list_for_each_entry_safe(worker, n, &gcwq->idle_list, entry)
+		destroy_worker(worker);
 
-		debug_work_activate(rebind_work);
-		insert_work(get_cwq(gcwq->cpu, system_wq), rebind_work,
-			    worker->scheduled.next,
-			    work_color_to_flags(WORK_NO_COLOR));
-	}
+	WARN_ON(gcwq->nr_workers || gcwq->nr_idle);
 
-	/* relinquish manager role */
-	gcwq->flags &= ~GCWQ_MANAGING_WORKERS;
-
-	/* notify completion */
-	gcwq->trustee = NULL;
-	gcwq->trustee_state = TRUSTEE_DONE;
-	wake_up_all(&gcwq->trustee_wait);
 	spin_unlock_irq(&gcwq->lock);
-	return 0;
-}
 
-/**
- * wait_trustee_state - wait for trustee to enter the specified state
- * @gcwq: gcwq the trustee of interest belongs to
- * @state: target state to wait for
- *
- * Wait for the trustee to reach @state.  DONE is already matched.
- *
- * CONTEXT:
- * spin_lock_irq(gcwq->lock) which may be released and regrabbed
- * multiple times.  To be used by cpu_callback.
- */
-static void __cpuinit wait_trustee_state(struct global_cwq *gcwq, int state)
-__releases(&gcwq->lock)
-__acquires(&gcwq->lock)
-{
-	if (!(gcwq->trustee_state == state ||
-	      gcwq->trustee_state == TRUSTEE_DONE)) {
-		spin_unlock_irq(&gcwq->lock);
-		__wait_event(gcwq->trustee_wait,
-			     gcwq->trustee_state == state ||
-			     gcwq->trustee_state == TRUSTEE_DONE);
-		spin_lock_irq(&gcwq->lock);
+	gcwq = get_gcwq(get_cpu());
+	spin_lock_irq(&gcwq->lock);
+	list_for_each_entry_safe(work, nw, &non_affine_works, entry) {
+		list_del_init(&work->entry);
+		___queue_work(get_work_cwq(work)->wq, gcwq, work);
 	}
+	spin_unlock_irq(&gcwq->lock);
+	put_cpu();
 }
 
-static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
+static int __devinit workqueue_cpu_down_callback(struct notifier_block *nfb,
 						unsigned long action,
 						void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
 	struct global_cwq *gcwq = get_gcwq(cpu);
-	struct task_struct *new_trustee = NULL;
-	struct worker *uninitialized_var(new_worker);
-	unsigned long flags;
 
 	action &= ~CPU_TASKS_FROZEN;
 
-	switch (action) {
-	case CPU_DOWN_PREPARE:
-		new_trustee = kthread_create(trustee_thread, gcwq,
-					     "workqueue_trustee/%d\n", cpu);
-		if (IS_ERR(new_trustee))
-			return notifier_from_errno(PTR_ERR(new_trustee));
-		kthread_bind(new_trustee, cpu);
-		/* fall through */
-	case CPU_UP_PREPARE:
-		BUG_ON(gcwq->first_idle);
-		new_worker = create_worker(gcwq, false);
-		if (!new_worker) {
-			if (new_trustee)
-				kthread_stop(new_trustee);
-			return NOTIFY_BAD;
-		}
-		break;
-	case CPU_POST_DEAD:
-	case CPU_UP_CANCELED:
-	case CPU_DOWN_FAILED:
-	case CPU_ONLINE:
-		break;
-	case CPU_DYING:
-		/*
-		 * We access this lockless. We are on the dying CPU
-		 * and called from stomp machine.
-		 *
-		 * Before this, the trustee and all workers except for
-		 * the ones which are still executing works from
-		 * before the last CPU down must be on the cpu.  After
-		 * this, they'll all be diasporas.
-		 */
-		gcwq->flags |= GCWQ_DISASSOCIATED;
-	default:
-		goto out;
-	}
-
-	/* some are called w/ irq disabled, don't disturb irq status */
-	spin_lock_irqsave(&gcwq->lock, flags);
-
-	switch (action) {
-	case CPU_DOWN_PREPARE:
-		/* initialize trustee and tell it to acquire the gcwq */
-		BUG_ON(gcwq->trustee || gcwq->trustee_state != TRUSTEE_DONE);
-		gcwq->trustee = new_trustee;
-		gcwq->trustee_state = TRUSTEE_START;
-		wake_up_process(gcwq->trustee);
-		wait_trustee_state(gcwq, TRUSTEE_IN_CHARGE);
-		/* fall through */
-	case CPU_UP_PREPARE:
-		BUG_ON(gcwq->first_idle);
-		gcwq->first_idle = new_worker;
-		break;
+        switch (action) {
+        case CPU_DOWN_PREPARE:
+                flush_gcwq(gcwq);
+                break;
+        }
 
-	case CPU_POST_DEAD:
-		gcwq->trustee_state = TRUSTEE_BUTCHER;
-		/* fall through */
-	case CPU_UP_CANCELED:
-		destroy_worker(gcwq->first_idle);
-		gcwq->first_idle = NULL;
-		break;
 
-	case CPU_DOWN_FAILED:
-	case CPU_ONLINE:
-		gcwq->flags &= ~GCWQ_DISASSOCIATED;
-		if (gcwq->trustee_state != TRUSTEE_DONE) {
-			gcwq->trustee_state = TRUSTEE_RELEASE;
-			wake_up_process(gcwq->trustee);
-			wait_trustee_state(gcwq, TRUSTEE_DONE);
-		}
-
-		/*
-		 * Trustee is done and there might be no worker left.
-		 * Put the first_idle in and request a real manager to
-		 * take a look.
-		 */
-		spin_unlock_irq(&gcwq->lock);
-		kthread_bind(gcwq->first_idle->task, cpu);
-		spin_lock_irq(&gcwq->lock);
-		gcwq->flags |= GCWQ_MANAGE_WORKERS;
-		start_worker(gcwq->first_idle);
-		gcwq->first_idle = NULL;
-		break;
-	}
-
-	spin_unlock_irqrestore(&gcwq->lock, flags);
-
-out:
 	return notifier_from_errno(0);
 }
 
@@ -3745,7 +3491,8 @@ static int __init init_workqueues(void)
 	unsigned int cpu;
 	int i;
 
-	cpu_notifier(workqueue_cpu_callback, CPU_PRI_WORKQUEUE);
+	cpu_notifier(workqueue_cpu_up_callback, CPU_PRI_WORKQUEUE_ACTIVE);
+ 	hotcpu_notifier(workqueue_cpu_down_callback, CPU_PRI_WORKQUEUE_INACTIVE);
 
 	/* initialize gcwqs */
 	for_each_gcwq_cpu(cpu) {
@@ -3768,9 +3515,7 @@ static int __init init_workqueues(void)
 			    (unsigned long)gcwq);
 
 		ida_init(&gcwq->worker_ida);
-
-		gcwq->trustee_state = TRUSTEE_DONE;
-		init_waitqueue_head(&gcwq->trustee_wait);
+		init_waitqueue_head(&gcwq->idle_wait);
 	}
 
 	/* create the initial worker */
Index: linux-2.6/lib/Kconfig.debug
===================================================================
--- linux-2.6.orig/lib/Kconfig.debug
+++ linux-2.6/lib/Kconfig.debug
@@ -62,6 +62,28 @@ config MAGIC_SYSRQ
 	  keys are documented in <file:Documentation/sysrq.txt>. Don't say Y
 	  unless you really know what this hack does.
 
+config MAGIC_SYSRQ_FORCE_PRINTK
+	bool "Force printk from Magic SysRq"
+	depends on MAGIC_SYSRQ && PREEMPT_RT_FULL
+	default n
+	help
+	  Allow the output from Magic SysRq to be output immediately, even if
+	  this causes large latencies.  This can cause performance problems
+	  for real-time processes.
+
+	  If PREEMPT_RT_FULL, printk() will not try to acquire the console lock
+	  when interrupts or preemption are disabled.  If the console lock is
+	  not acquired the printk() output will be buffered, but will not be
+	  output immediately.  Some drivers call into the Magic SysRq code
+	  with interrupts or preemption disabled, so the output of Magic SysRq
+	  will be buffered instead of printing immediately if this option is
+	  not selected.
+
+	  Even with this option selected, Magic SysRq output will be delayed
+	  if the attempt to acquire the console lock fails.
+
+	  Don't say Y unless you really know what this hack does.
+
 config STRIP_ASM_SYMS
 	bool "Strip assembler-generated symbols during link"
 	default n
Index: linux-2.6/localversion-rt
===================================================================
--- linux-2.6.orig/localversion-rt
+++ linux-2.6/localversion-rt
@@ -1 +1 @@
--rt14
+-rt15
Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -856,8 +856,8 @@ void __irq_entry smp_apic_timer_interrup
 	 * Besides, if we don't timer interrupts ignore the global
 	 * interrupt lock, which is the WrongThing (tm) to do.
 	 */
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	local_apic_timer_interrupt();
 	irq_exit();
 
@@ -1790,8 +1790,8 @@ void smp_spurious_interrupt(struct pt_re
 {
 	u32 v;
 
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
 	 * if it is a vectored one.  Just in case...
@@ -1827,8 +1827,8 @@ void smp_error_interrupt(struct pt_regs 
 		"Illegal register address",	/* APIC Error Bit 7 */
 	};
 
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v0 = apic_read(APIC_ESR);
 	apic_write(APIC_ESR, 0);
Index: linux-2.6/arch/x86/kernel/cpu/mcheck/therm_throt.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -396,8 +396,8 @@ static void (*smp_thermal_vector)(void) 
 
 asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
 {
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	inc_irq_stat(irq_thermal_count);
 	smp_thermal_vector();
 	irq_exit();
Index: linux-2.6/arch/x86/kernel/cpu/mcheck/threshold.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/threshold.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/threshold.c
@@ -19,8 +19,8 @@ void (*mce_threshold_vector)(void) = def
 
 asmlinkage void smp_threshold_interrupt(void)
 {
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	inc_irq_stat(irq_threshold_count);
 	mce_threshold_vector();
 	irq_exit();
Index: linux-2.6/arch/x86/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq.c
+++ linux-2.6/arch/x86/kernel/irq.c
@@ -180,8 +180,8 @@ unsigned int __irq_entry do_IRQ(struct p
 	unsigned vector = ~regs->orig_ax;
 	unsigned irq;
 
-	exit_idle();
 	irq_enter();
+	exit_idle();
 
 	irq = __this_cpu_read(vector_irq[vector]);
 
@@ -208,10 +208,10 @@ void smp_x86_platform_ipi(struct pt_regs
 
 	ack_APIC_irq();
 
-	exit_idle();
-
 	irq_enter();
 
+	exit_idle();
+
 	inc_irq_stat(x86_platform_ipis);
 
 	if (x86_platform_ipi_callback)
Index: linux-2.6/kernel/taskstats.c
===================================================================
--- linux-2.6.orig/kernel/taskstats.c
+++ linux-2.6/kernel/taskstats.c
@@ -657,6 +657,7 @@ static struct genl_ops taskstats_ops = {
 	.cmd		= TASKSTATS_CMD_GET,
 	.doit		= taskstats_user_cmd,
 	.policy		= taskstats_cmd_get_policy,
+	.flags		= GENL_ADMIN_PERM,
 };
 
 static struct genl_ops cgroupstats_ops = {
Index: linux-2.6/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/hpet.c
+++ linux-2.6/arch/x86/kernel/hpet.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/hpet.h>
 #include <linux/init.h>
+#include <linux/dmi.h>
 #include <linux/cpu.h>
 #include <linux/pm.h>
 #include <linux/io.h>
@@ -566,6 +567,29 @@ static void init_one_hpet_msi_clockevent
 #define RESERVE_TIMERS 0
 #endif
 
+static int __init dmi_disable_hpet_msi(const struct dmi_system_id *d)
+{
+	hpet_msi_disable = 1;
+}
+
+static struct dmi_system_id __initdata dmi_hpet_table[] = {
+	/*
+	 * MSI based per cpu timers lose interrupts when intel_idle()
+	 * is enabled - independent of the c-state. With idle=poll the
+	 * problem cannot be observed. We have no idea yet, whether
+	 * this is a W510 specific issue or a general chipset oddity.
+	 */
+	{
+	 .callback = dmi_disable_hpet_msi,
+	 .ident = "Lenovo W510",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		     DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad W510"),
+		     },
+	 },
+	{}
+};
+
 static void hpet_msi_capability_lookup(unsigned int start_timer)
 {
 	unsigned int id;
@@ -573,6 +597,8 @@ static void hpet_msi_capability_lookup(u
 	unsigned int num_timers_used = 0;
 	int i;
 
+	dmi_check_system(dmi_hpet_table);
+
 	if (hpet_msi_disable)
 		return;
 
Index: linux-2.6/drivers/watchdog/octeon-wdt-main.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/octeon-wdt-main.c
+++ linux-2.6/drivers/watchdog/octeon-wdt-main.c
@@ -402,7 +402,7 @@ static void octeon_wdt_setup_interrupt(i
 	irq = OCTEON_IRQ_WDOG0 + core;
 
 	if (request_irq(irq, octeon_wdt_poke_irq,
-			IRQF_DISABLED, "octeon_wdt", octeon_wdt_poke_irq))
+			IRQF_NO_THREAD, "octeon_wdt", octeon_wdt_poke_irq))
 		panic("octeon_wdt: Couldn't obtain irq %d", irq);
 
 	cpumask_set_cpu(cpu, &irq_enabled_cpus);
Index: linux-2.6/arch/mips/cavium-octeon/smp.c
===================================================================
--- linux-2.6.orig/arch/mips/cavium-octeon/smp.c
+++ linux-2.6/arch/mips/cavium-octeon/smp.c
@@ -207,8 +207,9 @@ void octeon_prepare_cpus(unsigned int ma
 	 * the other bits alone.
 	 */
 	cvmx_write_csr(CVMX_CIU_MBOX_CLRX(cvmx_get_core_num()), 0xffff);
-	if (request_irq(OCTEON_IRQ_MBOX0, mailbox_interrupt, IRQF_DISABLED,
-			"SMP-IPI", mailbox_interrupt)) {
+	if (request_irq(OCTEON_IRQ_MBOX0, mailbox_interrupt,
+			IRQF_PERCPU | IRQF_NO_THREAD, "SMP-IPI",
+			mailbox_interrupt)) {
 		panic("Cannot request_irq(OCTEON_IRQ_MBOX0)\n");
 	}
 }
Index: linux-2.6/arch/x86/include/asm/irqflags.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/irqflags.h
+++ linux-2.6/arch/x86/include/asm/irqflags.h
@@ -60,23 +60,24 @@ static inline void native_halt(void)
 #include <asm/paravirt.h>
 #else
 #ifndef __ASSEMBLY__
+#include <linux/types.h>
 
-static inline unsigned long arch_local_save_flags(void)
+static inline notrace unsigned long arch_local_save_flags(void)
 {
 	return native_save_fl();
 }
 
-static inline void arch_local_irq_restore(unsigned long flags)
+static inline notrace void arch_local_irq_restore(unsigned long flags)
 {
 	native_restore_fl(flags);
 }
 
-static inline void arch_local_irq_disable(void)
+static inline notrace void arch_local_irq_disable(void)
 {
 	native_irq_disable();
 }
 
-static inline void arch_local_irq_enable(void)
+static inline notrace void arch_local_irq_enable(void)
 {
 	native_irq_enable();
 }
@@ -102,7 +103,7 @@ static inline void halt(void)
 /*
  * For spinlocks, etc:
  */
-static inline unsigned long arch_local_irq_save(void)
+static inline notrace unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags = arch_local_save_flags();
 	arch_local_irq_disable();
Index: linux-2.6/arch/arm/plat-versatile/platsmp.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-versatile/platsmp.c
+++ linux-2.6/arch/arm/plat-versatile/platsmp.c
@@ -37,7 +37,7 @@ static void __cpuinit write_pen_release(
 	outer_clean_range(__pa(&pen_release), __pa(&pen_release + 1));
 }
 
-static DEFINE_SPINLOCK(boot_lock);
+static DEFINE_RAW_SPINLOCK(boot_lock);
 
 void __cpuinit platform_secondary_init(unsigned int cpu)
 {
@@ -57,8 +57,8 @@ void __cpuinit platform_secondary_init(u
 	/*
 	 * Synchronise with the boot thread.
 	 */
-	spin_lock(&boot_lock);
-	spin_unlock(&boot_lock);
+	raw_spin_lock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 }
 
 int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
@@ -69,7 +69,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * Set synchronisation state between this boot processor
 	 * and the secondary one
 	 */
-	spin_lock(&boot_lock);
+	raw_spin_lock(&boot_lock);
 
 	/*
 	 * This is really belt and braces; we hold unintended secondary
@@ -99,7 +99,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * now the secondary core is starting up let it run its
 	 * calibrations, then wait for it to finish
 	 */
-	spin_unlock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 
 	return pen_release != -1 ? -ENOSYS : 0;
 }
Index: linux-2.6/arch/arm/mach-exynos4/platsmp.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-exynos4/platsmp.c
+++ linux-2.6/arch/arm/mach-exynos4/platsmp.c
@@ -56,7 +56,7 @@ static void __iomem *scu_base_addr(void)
 	return (void __iomem *)(S5P_VA_SCU);
 }
 
-static DEFINE_SPINLOCK(boot_lock);
+static DEFINE_RAW_SPINLOCK(boot_lock);
 
 void __cpuinit platform_secondary_init(unsigned int cpu)
 {
@@ -76,8 +76,8 @@ void __cpuinit platform_secondary_init(u
 	/*
 	 * Synchronise with the boot thread.
 	 */
-	spin_lock(&boot_lock);
-	spin_unlock(&boot_lock);
+	raw_spin_lock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 }
 
 int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
@@ -88,7 +88,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * Set synchronisation state between this boot processor
 	 * and the secondary one
 	 */
-	spin_lock(&boot_lock);
+	raw_spin_lock(&boot_lock);
 
 	/*
 	 * The secondary processor is waiting to be released from
@@ -120,7 +120,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * now the secondary core is starting up let it run its
 	 * calibrations, then wait for it to finish
 	 */
-	spin_unlock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 
 	return pen_release != -1 ? -ENOSYS : 0;
 }
Index: linux-2.6/arch/arm/mach-msm/platsmp.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-msm/platsmp.c
+++ linux-2.6/arch/arm/mach-msm/platsmp.c
@@ -38,7 +38,7 @@ extern void msm_secondary_startup(void);
  */
 volatile int pen_release = -1;
 
-static DEFINE_SPINLOCK(boot_lock);
+static DEFINE_RAW_SPINLOCK(boot_lock);
 
 void __cpuinit platform_secondary_init(unsigned int cpu)
 {
@@ -62,8 +62,8 @@ void __cpuinit platform_secondary_init(u
 	/*
 	 * Synchronise with the boot thread.
 	 */
-	spin_lock(&boot_lock);
-	spin_unlock(&boot_lock);
+	raw_spin_lock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 }
 
 static __cpuinit void prepare_cold_cpu(unsigned int cpu)
@@ -100,7 +100,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * set synchronisation state between this boot processor
 	 * and the secondary one
 	 */
-	spin_lock(&boot_lock);
+	raw_spin_lock(&boot_lock);
 
 	/*
 	 * The secondary processor is waiting to be released from
@@ -134,7 +134,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * now the secondary core is starting up let it run its
 	 * calibrations, then wait for it to finish
 	 */
-	spin_unlock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 
 	return pen_release != -1 ? -ENOSYS : 0;
 }
Index: linux-2.6/arch/arm/mach-omap2/omap-smp.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/omap-smp.c
+++ linux-2.6/arch/arm/mach-omap2/omap-smp.c
@@ -29,7 +29,7 @@
 /* SCU base address */
 static void __iomem *scu_base;
 
-static DEFINE_SPINLOCK(boot_lock);
+static DEFINE_RAW_SPINLOCK(boot_lock);
 
 void __cpuinit platform_secondary_init(unsigned int cpu)
 {
@@ -43,8 +43,8 @@ void __cpuinit platform_secondary_init(u
 	/*
 	 * Synchronise with the boot thread.
 	 */
-	spin_lock(&boot_lock);
-	spin_unlock(&boot_lock);
+	raw_spin_lock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 }
 
 int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
@@ -53,7 +53,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * Set synchronisation state between this boot processor
 	 * and the secondary one
 	 */
-	spin_lock(&boot_lock);
+	raw_spin_lock(&boot_lock);
 
 	/*
 	 * Update the AuxCoreBoot0 with boot state for secondary core.
@@ -70,7 +70,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * Now the secondary core is starting up let it run its
 	 * calibrations, then wait for it to finish
 	 */
-	spin_unlock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 
 	return 0;
 }
Index: linux-2.6/arch/arm/mach-tegra/platsmp.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-tegra/platsmp.c
+++ linux-2.6/arch/arm/mach-tegra/platsmp.c
@@ -29,7 +29,7 @@
 
 extern void tegra_secondary_startup(void);
 
-static DEFINE_SPINLOCK(boot_lock);
+static DEFINE_RAW_SPINLOCK(boot_lock);
 static void __iomem *scu_base = IO_ADDRESS(TEGRA_ARM_PERIF_BASE);
 
 #define EVP_CPU_RESET_VECTOR \
@@ -51,8 +51,8 @@ void __cpuinit platform_secondary_init(u
 	/*
 	 * Synchronise with the boot thread.
 	 */
-	spin_lock(&boot_lock);
-	spin_unlock(&boot_lock);
+	raw_spin_lock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 }
 
 int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
@@ -66,7 +66,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * set synchronisation state between this boot processor
 	 * and the secondary one
 	 */
-	spin_lock(&boot_lock);
+	raw_spin_lock(&boot_lock);
 
 
 	/* set the reset vector to point to the secondary_startup routine */
@@ -102,7 +102,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * now the secondary core is starting up let it run its
 	 * calibrations, then wait for it to finish
 	 */
-	spin_unlock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 
 	return 0;
 }
Index: linux-2.6/arch/arm/mach-ux500/platsmp.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ux500/platsmp.c
+++ linux-2.6/arch/arm/mach-ux500/platsmp.c
@@ -57,7 +57,7 @@ static void __iomem *scu_base_addr(void)
 	return NULL;
 }
 
-static DEFINE_SPINLOCK(boot_lock);
+static DEFINE_RAW_SPINLOCK(boot_lock);
 
 void __cpuinit platform_secondary_init(unsigned int cpu)
 {
@@ -77,8 +77,8 @@ void __cpuinit platform_secondary_init(u
 	/*
 	 * Synchronise with the boot thread.
 	 */
-	spin_lock(&boot_lock);
-	spin_unlock(&boot_lock);
+	raw_spin_lock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 }
 
 int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
@@ -89,7 +89,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * set synchronisation state between this boot processor
 	 * and the secondary one
 	 */
-	spin_lock(&boot_lock);
+	raw_spin_lock(&boot_lock);
 
 	/*
 	 * The secondary processor is waiting to be released from
@@ -110,7 +110,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * now the secondary core is starting up let it run its
 	 * calibrations, then wait for it to finish
 	 */
-	spin_unlock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 
 	return pen_release != -1 ? -ENOSYS : 0;
 }
Index: linux-2.6/include/linux/workqueue.h
===================================================================
--- linux-2.6.orig/include/linux/workqueue.h
+++ linux-2.6/include/linux/workqueue.h
@@ -254,9 +254,10 @@ enum {
 	WQ_MEM_RECLAIM		= 1 << 3, /* may be used for memory reclaim */
 	WQ_HIGHPRI		= 1 << 4, /* high priority */
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
+	WQ_NON_AFFINE		= 1 << 6, /* free to move works around cpus */
 
-	WQ_DYING		= 1 << 6, /* internal: workqueue is dying */
-	WQ_RESCUER		= 1 << 7, /* internal: workqueue has rescuer */
+	WQ_DYING		= 1 << 7, /* internal: workqueue is dying */
+	WQ_RESCUER		= 1 << 8, /* internal: workqueue has rescuer */
 
 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
 	WQ_MAX_UNBOUND_PER_CPU	= 4,	  /* 4 * #cpus for unbound wq */
Index: linux-2.6/drivers/tty/serial/cpm_uart/cpm_uart_core.c
===================================================================
--- linux-2.6.orig/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ linux-2.6/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -1225,7 +1225,7 @@ static void cpm_uart_console_write(struc
 {
 	struct uart_cpm_port *pinfo = &cpm_uart_ports[co->index];
 	unsigned long flags;
-	int nolock = oops_in_progress;
+	int nolock = oops_in_progress || sysrq_in_progress;
 
 	if (unlikely(nolock)) {
 		local_irq_save(flags);
Index: linux-2.6/drivers/tty/sysrq.c
===================================================================
--- linux-2.6.orig/drivers/tty/sysrq.c
+++ linux-2.6/drivers/tty/sysrq.c
@@ -492,6 +492,23 @@ static void __sysrq_put_key_op(int key, 
                 sysrq_key_table[i] = op_p;
 }
 
+#ifdef CONFIG_MAGIC_SYSRQ_FORCE_PRINTK
+
+int sysrq_in_progress;
+
+static void set_sysrq_in_progress(int value)
+{
+	sysrq_in_progress = value;
+}
+
+#else
+
+static void set_sysrq_in_progress(int value)
+{
+}
+
+#endif
+
 void __handle_sysrq(int key, bool check_mask)
 {
 	struct sysrq_key_op *op_p;
@@ -500,6 +517,9 @@ void __handle_sysrq(int key, bool check_
 	unsigned long flags;
 
 	spin_lock_irqsave(&sysrq_key_table_lock, flags);
+
+	set_sysrq_in_progress(1);
+
 	/*
 	 * Raise the apparent loglevel to maximum so that the sysrq header
 	 * is shown to provide the user with positive feedback.  We do not
@@ -541,6 +561,9 @@ void __handle_sysrq(int key, bool check_
 		printk("\n");
 		console_loglevel = orig_log_level;
 	}
+
+	set_sysrq_in_progress(0);
+
 	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
 }
 
Index: linux-2.6/include/linux/sysrq.h
===================================================================
--- linux-2.6.orig/include/linux/sysrq.h
+++ linux-2.6/include/linux/sysrq.h
@@ -38,6 +38,11 @@ struct sysrq_key_op {
 	int enable_mask;
 };
 
+#ifdef CONFIG_MAGIC_SYSRQ_FORCE_PRINTK
+extern int sysrq_in_progress;
+#else
+#define sysrq_in_progress 0
+#endif
 #ifdef CONFIG_MAGIC_SYSRQ
 
 /* Generic SysRq interface -- you may call it from any device driver, supplying
