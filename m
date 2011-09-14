Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab1INXa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 19:30:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:43241 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1INXa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 19:30:26 -0400
Date: Thu, 15 Sep 2011 01:30:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.0.4-rt14
Message-ID: <alpine.LFD.2.02.1109150047290.2723@ionos>
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

I'm pleased to announce the 3.0.4-rt14 release.

Changes versus 3.0.4-rt13

  * Cherrypicks from the going to be 3.0.5 release

  * ipc/sem workaround (Peter)
  
  * scheduler oddities (Peter/myself)

  * hrtimer reprogramming RT only bug

  * lib/atomic64 fixup (Yong)

  * various compile fixes (several submitters [simply folded back])


Patch against 3.0.4 can be found here:

  https://tglx.de/~tglx/rt/patch-3.0.4-rt14.patch.gz


The split quilt queue is available at:

  https://tglx.de/~tglx/rt/patches-3.0.4-rt14.tar.gz


For those who don't have 3.0.4 around:

  git://tesla.tglx.de/git/linux-2.6-tip rt/3.0
  
  https://tglx.de/~tglx/rt/patch-3.0.4.gz


Delta patch against 3.0.4-rt13

  https://tglx.de/~tglx/rt/patch-3.0.4-rt13-rt14.patch.gz

also included below.


Enjoy,

	tglx

--------------->

Index: linux-2.6/arch/arm/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/perf_event.c
+++ linux-2.6/arch/arm/kernel/perf_event.c
@@ -420,7 +420,7 @@ armpmu_reserve_hardware(void)
 			continue;
 
 		err = request_irq(irq, handle_irq,
-				  IRQF_DISABLED | IRQF_NOBALANCING | IRQF_NO_THREAD,
+				  IRQF_NOBALANCING | IRQF_NO_THREAD,
 				  "armpmu", NULL);
 		if (err) {
 			pr_warning("unable to request IRQ%d for ARM perf "
Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -1314,7 +1314,11 @@ static void hrtimer_rt_reprogram(int res
 		if (!enqueue_hrtimer(timer, base))
 			return;
 
-		if (hrtimer_reprogram(timer, base))
+#ifndef CONFIG_HIGH_RES_TIMERS
+	}
+#else
+		if (base->cpu_base->hres_active &&
+		    hrtimer_reprogram(timer, base))
 			goto requeue;
 
 	} else if (hrtimer_active(timer)) {
@@ -1323,6 +1327,7 @@ static void hrtimer_rt_reprogram(int res
 		 * the event device.
 		 */
 		if (&timer->node == base->active.next &&
+		    base->cpu_base->hres_active &&
 		    hrtimer_reprogram(timer, base))
 			goto requeue;
 	}
@@ -1335,6 +1340,7 @@ requeue:
 	 */
 	__remove_hrtimer(timer, base, timer->state, 0);
 	list_add_tail(&timer->cb_entry, &base->expired);
+#endif
 }
 
 /*
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -5054,7 +5054,13 @@ EXPORT_SYMBOL(task_nice);
  */
 int idle_cpu(int cpu)
 {
-	return cpu_curr(cpu) == cpu_rq(cpu)->idle;
+	struct rq *rq = cpu_rq(cpu);
+
+#ifdef CONFIG_SMP
+	return rq->curr == rq->idle && !rq->nr_running && !rq->wake_list;
+#else
+	return rq->curr == rq->idle && !rq->nr_running;
+#endif
 }
 
 /**
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -235,7 +235,9 @@ void print_rt_rq(struct seq_file *m, int
 	P(rt_throttled);
 	PN(rt_time);
 	PN(rt_runtime);
+#ifdef CONFIG_SMP
 	P(rt_nr_migratory);
+#endif
 
 #undef PN
 #undef P
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -1039,7 +1039,7 @@ select_task_rq_rt(struct task_struct *p,
 	 */
 	if (curr && unlikely(rt_task(curr)) &&
 	    (curr->rt.nr_cpus_allowed < 2 ||
-	     curr->prio < p->prio) &&
+	     curr->prio <= p->prio) &&
 	    (p->rt.nr_cpus_allowed > 1)) {
 		int target = find_lowest_rq(p);
 
@@ -1570,7 +1570,7 @@ static void task_woken_rt(struct rq *rq,
 	    p->rt.nr_cpus_allowed > 1 &&
 	    rt_task(rq->curr) &&
 	    (rq->curr->rt.nr_cpus_allowed < 2 ||
-	     rq->curr->prio < p->prio))
+	     rq->curr->prio <= p->prio))
 		push_rt_tasks(rq);
 }
 
Index: linux-2.6/lib/atomic64.c
===================================================================
--- linux-2.6.orig/lib/atomic64.c
+++ linux-2.6/lib/atomic64.c
@@ -33,7 +33,7 @@ static union {
 	char pad[L1_CACHE_BYTES];
 } atomic64_lock[NR_LOCKS] __cacheline_aligned_in_smp;
 
-static inline spinlock_t *lock_addr(const atomic64_t *v)
+static inline raw_spinlock_t *lock_addr(const atomic64_t *v)
 {
 	unsigned long addr = (unsigned long) v;
 
@@ -45,7 +45,7 @@ static inline spinlock_t *lock_addr(cons
 long long atomic64_read(const atomic64_t *v)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	long long val;
 
 	raw_spin_lock_irqsave(lock, flags);
@@ -58,7 +58,7 @@ EXPORT_SYMBOL(atomic64_read);
 void atomic64_set(atomic64_t *v, long long i)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 
 	raw_spin_lock_irqsave(lock, flags);
 	v->counter = i;
@@ -69,7 +69,7 @@ EXPORT_SYMBOL(atomic64_set);
 void atomic64_add(long long a, atomic64_t *v)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 
 	raw_spin_lock_irqsave(lock, flags);
 	v->counter += a;
@@ -80,7 +80,7 @@ EXPORT_SYMBOL(atomic64_add);
 long long atomic64_add_return(long long a, atomic64_t *v)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	long long val;
 
 	raw_spin_lock_irqsave(lock, flags);
@@ -93,7 +93,7 @@ EXPORT_SYMBOL(atomic64_add_return);
 void atomic64_sub(long long a, atomic64_t *v)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 
 	raw_spin_lock_irqsave(lock, flags);
 	v->counter -= a;
@@ -104,7 +104,7 @@ EXPORT_SYMBOL(atomic64_sub);
 long long atomic64_sub_return(long long a, atomic64_t *v)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	long long val;
 
 	raw_spin_lock_irqsave(lock, flags);
@@ -117,7 +117,7 @@ EXPORT_SYMBOL(atomic64_sub_return);
 long long atomic64_dec_if_positive(atomic64_t *v)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	long long val;
 
 	raw_spin_lock_irqsave(lock, flags);
@@ -132,7 +132,7 @@ EXPORT_SYMBOL(atomic64_dec_if_positive);
 long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	long long val;
 
 	raw_spin_lock_irqsave(lock, flags);
@@ -147,7 +147,7 @@ EXPORT_SYMBOL(atomic64_cmpxchg);
 long long atomic64_xchg(atomic64_t *v, long long new)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	long long val;
 
 	raw_spin_lock_irqsave(lock, flags);
@@ -161,7 +161,7 @@ EXPORT_SYMBOL(atomic64_xchg);
 int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	int ret = 0;
 
 	raw_spin_lock_irqsave(lock, flags);
Index: linux-2.6/localversion-rt
===================================================================
--- linux-2.6.orig/localversion-rt
+++ linux-2.6/localversion-rt
@@ -1 +1 @@
--rt13
+-rt14
Index: linux-2.6/arch/arm/plat-mxc/include/mach/iomux-v3.h
===================================================================
--- linux-2.6.orig/arch/arm/plat-mxc/include/mach/iomux-v3.h
+++ linux-2.6/arch/arm/plat-mxc/include/mach/iomux-v3.h
@@ -66,7 +66,6 @@ typedef u64 iomux_v3_cfg_t;
 #define MUX_MODE_MASK		((iomux_v3_cfg_t)0x1f << MUX_MODE_SHIFT)
 #define MUX_PAD_CTRL_SHIFT	41
 #define MUX_PAD_CTRL_MASK	((iomux_v3_cfg_t)0x1ffff << MUX_PAD_CTRL_SHIFT)
-#define NO_PAD_CTRL		((iomux_v3_cfg_t)1 << (MUX_PAD_CTRL_SHIFT + 16))
 #define MUX_SEL_INPUT_SHIFT	58
 #define MUX_SEL_INPUT_MASK	((iomux_v3_cfg_t)0xf << MUX_SEL_INPUT_SHIFT)
 
@@ -85,6 +84,7 @@ typedef u64 iomux_v3_cfg_t;
  * Use to set PAD control
  */
 
+#define NO_PAD_CTRL			(1 << 16)
 #define PAD_CTL_DVS			(1 << 13)
 #define PAD_CTL_HYS			(1 << 8)
 
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -65,10 +65,14 @@ SCHED_FEAT(OWNER_SPIN, 1)
  */
 SCHED_FEAT(NONIRQ_POWER, 1)
 
+#ifndef CONFIG_PREEMPT_RT_FULL
 /*
  * Queue remote wakeups on the target CPU and process them
  * using the scheduler IPI. Reduces rq->lock contention/bounces.
  */
 SCHED_FEAT(TTWU_QUEUE, 1)
+#else
+SCHED_FEAT(TTWU_QUEUE, 0)
+#endif
 
 SCHED_FEAT(FORCE_SD_OVERLAP, 0)
Index: linux-2.6/ipc/sem.c
===================================================================
--- linux-2.6.orig/ipc/sem.c
+++ linux-2.6/ipc/sem.c
@@ -415,6 +415,13 @@ undo:
 static void wake_up_sem_queue_prepare(struct list_head *pt,
 				struct sem_queue *q, int error)
 {
+#ifdef CONFIG_PREEMPT_RT_BASE
+	struct task_struct *p = q->sleeper;
+	get_task_struct(p);
+	q->status = error;
+	wake_up_process(p);
+	put_task_struct(p);
+#else
 	if (list_empty(pt)) {
 		/*
 		 * Hold preempt off so that we don't get preempted and have the
@@ -426,6 +433,7 @@ static void wake_up_sem_queue_prepare(st
 	q->pid = error;
 
 	list_add_tail(&q->simple_list, pt);
+#endif
 }
 
 /**
@@ -439,6 +447,7 @@ static void wake_up_sem_queue_prepare(st
  */
 static void wake_up_sem_queue_do(struct list_head *pt)
 {
+#ifndef CONFIG_PREEMPT_RT_BASE
 	struct sem_queue *q, *t;
 	int did_something;
 
@@ -451,6 +460,7 @@ static void wake_up_sem_queue_do(struct 
 	}
 	if (did_something)
 		preempt_enable();
+#endif
 }
 
 static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
