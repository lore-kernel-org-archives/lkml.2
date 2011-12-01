Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab1LAJMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 04:12:20 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:37640 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751712Ab1LAJMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 04:12:17 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18M6NBrJawMJBQRD+8Hl77ZfCe9StCLg2Qz1Q4WjQ
	NCcBCHR5nixJL/
Subject: PATCH RT] resurrect softirq threads for RT_FULL
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Clark Williams <williams@redhat.com>
In-Reply-To: <alpine.LFD.2.02.1111301117240.2735@ionos>
References: <1322618120.17003.104.camel@frodo>
	 <1322627551.17283.11.camel@marge.simson.net>
	 <alpine.LFD.2.02.1111301117240.2735@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Dec 2011 10:12:11 +0100
Message-ID: <1322730731.6758.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Un-hijack thread.

On Wed, 2011-11-30 at 11:24 +0100, Thomas Gleixner wrote:
> On Wed, 30 Nov 2011, Mike Galbraith wrote:

> > @@ -486,12 +495,43 @@ extern void softirq_check_pending_idle(v
> >   */
> >  DECLARE_PER_CPU(struct list_head [NR_SOFTIRQS], softirq_work_list);
> >  
> > -DECLARE_PER_CPU(struct task_struct *, ksoftirqd);
> > +struct softirqdata {
> > +	int			mask;
> > +	struct task_struct	*tsk;
> > +};
> > +
> > +DECLARE_PER_CPU(struct softirqdata [NR_SOFTIRQ_THREADS], ksoftirqd);
> > +
> > +static inline bool this_cpu_ksoftirqd(struct task_struct *p)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < NR_SOFTIRQ_THREADS; i++) {
> > +		if (p == __get_cpu_var(ksoftirqd)[i].tsk)
> > +			return true;
> 
> You are not serious about that loop, are you ?

After some dainbramaged removal, it might look a little better.

sched, rt: resurrect softirq threads for RT_FULL

Signed-off-by: Mike Galbraith <efault@gmx.de>
---
 include/linux/interrupt.h |   21 ++++-
 kernel/irq/Kconfig        |    7 +
 kernel/sched.c            |    4 -
 kernel/softirq.c          |  168 ++++++++++++++++++++++++++++++++--------------
 4 files changed, 145 insertions(+), 55 deletions(-)

Index: linux-3.2-rt/kernel/irq/Kconfig
===================================================================
--- linux-3.2-rt.orig/kernel/irq/Kconfig
+++ linux-3.2-rt/kernel/irq/Kconfig
@@ -60,6 +60,13 @@ config IRQ_DOMAIN
 config IRQ_FORCED_THREADING
        bool
 
+# Support forced sirq threading
+config SIRQ_FORCED_THREADING
+       bool "Forced Soft IRQ threading"
+       depends on PREEMPT_RT_FULL
+	help
+	  Split ksoftirqd into per SOFTIRQ threads
+
 config SPARSE_IRQ
 	bool "Support sparse irq numbering"
 	depends on HAVE_SPARSE_IRQ
Index: linux-3.2-rt/include/linux/interrupt.h
===================================================================
--- linux-3.2-rt.orig/include/linux/interrupt.h
+++ linux-3.2-rt/include/linux/interrupt.h
@@ -442,6 +442,9 @@ enum
 	NR_SOFTIRQS
 };
 
+/* Update when adding new softirqs. */
+#define SOFTIRQ_MASK_ALL 0x3ff
+
 /* map softirq index to softirq name. update 'softirq_to_name' in
  * kernel/softirq.c when adding a new softirq.
  */
@@ -457,10 +460,16 @@ struct softirq_action
 };
 
 #ifndef CONFIG_PREEMPT_RT_FULL
+#define NR_SOFTIRQ_THREADS 1
 asmlinkage void do_softirq(void);
 asmlinkage void __do_softirq(void);
 static inline void thread_do_softirq(void) { do_softirq(); }
 #else
+#ifdef CONFIG_SIRQ_FORCED_THREADING
+#define NR_SOFTIRQ_THREADS NR_SOFTIRQS
+#else
+#define NR_SOFTIRQ_THREADS 1
+#endif
 extern void thread_do_softirq(void);
 #endif
 
@@ -486,11 +495,17 @@ extern void softirq_check_pending_idle(v
  */
 DECLARE_PER_CPU(struct list_head [NR_SOFTIRQS], softirq_work_list);
 
-DECLARE_PER_CPU(struct task_struct *, ksoftirqd);
+struct softirqdata {
+	int			mask;
+	struct task_struct	*tsk;
+};
+
+DECLARE_PER_CPU(struct softirqdata [NR_SOFTIRQ_THREADS], ksoftirqd);
+DECLARE_PER_CPU(struct task_struct *, local_softirq_thread);
 
-static inline struct task_struct *this_cpu_ksoftirqd(void)
+static inline int task_is_ksoftirqd(struct task_struct *p)
 {
-	return this_cpu_read(ksoftirqd);
+	return p == this_cpu_read(local_softirq_thread);
 }
 
 /* Try to send a softirq to a remote cpu.  If this cannot be done, the
Index: linux-3.2-rt/kernel/sched.c
===================================================================
--- linux-3.2-rt.orig/kernel/sched.c
+++ linux-3.2-rt/kernel/sched.c
@@ -2082,7 +2082,7 @@ void account_system_vtime(struct task_st
 	 */
 	if (hardirq_count())
 		__this_cpu_add(cpu_hardirq_time, delta);
-	else if (in_serving_softirq() && curr != this_cpu_ksoftirqd())
+	else if (in_serving_softirq() && !task_is_ksoftirqd(curr))
 		__this_cpu_add(cpu_softirq_time, delta);
 
 	irq_time_write_end();
@@ -4062,7 +4062,7 @@ static void irqtime_account_process_tick
 		cpustat->irq = cputime64_add(cpustat->irq, tmp);
 	} else if (irqtime_account_si_update()) {
 		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
-	} else if (this_cpu_ksoftirqd() == p) {
+	} else if (task_is_ksoftirqd(p)) {
 		/*
 		 * ksoftirqd time do not get accounted in cpu_softirq_time.
 		 * So, we have to handle it separately here.
Index: linux-3.2-rt/kernel/softirq.c
===================================================================
--- linux-3.2-rt.orig/kernel/softirq.c
+++ linux-3.2-rt/kernel/softirq.c
@@ -56,13 +56,32 @@ EXPORT_SYMBOL(irq_stat);
 
 static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp;
 
-DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
+DEFINE_PER_CPU(struct softirqdata[NR_SOFTIRQ_THREADS], ksoftirqd);
+DEFINE_PER_CPU(struct task_struct *, local_softirq_thread);
 
 char *softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
 	"TASKLET", "SCHED", "HRTIMER", "RCU"
 };
 
+static const char *softirq_to_thread_name [] =
+{
+#ifdef CONFIG_SIRQ_FORCED_THREADING
+	[HI_SOFTIRQ]		= "sirq-high",
+	[TIMER_SOFTIRQ]		= "sirq-timer",
+	[NET_TX_SOFTIRQ]	= "sirq-net-tx",
+	[NET_RX_SOFTIRQ]	= "sirq-net-rx",
+	[BLOCK_SOFTIRQ]		= "sirq-blk",
+	[BLOCK_IOPOLL_SOFTIRQ]	= "sirq-blk-pol",
+	[TASKLET_SOFTIRQ]	= "sirq-tasklet",
+	[SCHED_SOFTIRQ]		= "sirq-sched",
+	[HRTIMER_SOFTIRQ]	= "sirq-hrtimer",
+	[RCU_SOFTIRQ]		= "sirq-rcu",
+#else
+	[HI_SOFTIRQ]		= "ksoftirqd",
+#endif
+};
+
 #ifdef CONFIG_NO_HZ
 # ifdef CONFIG_PREEMPT_RT_FULL
 /*
@@ -78,15 +97,23 @@ char *softirq_to_name[NR_SOFTIRQS] = {
 void softirq_check_pending_idle(void)
 {
 	static int rate_limit;
-	u32 warnpending = 0, pending = local_softirq_pending();
+	u32 pending = local_softirq_pending(), mask = pending;
+	int i = 0;
 
 	if (rate_limit >= 10)
 		return;
 
-	if (pending) {
+	for (i = 0; pending && i < NR_SOFTIRQ_THREADS; i++) {
 		struct task_struct *tsk;
 
-		tsk = __get_cpu_var(ksoftirqd);
+		if (NR_SOFTIRQ_THREADS > 1) {
+			mask = 1 << i;
+
+			if (!(pending & mask))
+				continue;
+		}
+
+		tsk = __get_cpu_var(ksoftirqd)[i].tsk;
 		/*
 		 * The wakeup code in rtmutex.c wakes up the task
 		 * _before_ it sets pi_blocked_on to NULL under
@@ -95,13 +122,13 @@ void softirq_check_pending_idle(void)
 		 */
 		raw_spin_lock(&tsk->pi_lock);
 
-		if (!tsk->pi_blocked_on && !(tsk->state == TASK_RUNNING))
-			warnpending = 1;
+		if (tsk->pi_blocked_on || tsk->state == TASK_RUNNING)
+			pending &= ~mask;
 
 		raw_spin_unlock(&tsk->pi_lock);
 	}
 
-	if (warnpending) {
+	if (pending) {
 		printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
 		       pending);
 		rate_limit++;
@@ -132,11 +159,17 @@ void softirq_check_pending_idle(void)
  */
 static void wakeup_softirqd(void)
 {
-	/* Interrupts are disabled: no need to stop preemption */
-	struct task_struct *tsk = __this_cpu_read(ksoftirqd);
+	struct task_struct *tsk;
+	u32 pending = local_softirq_pending(), i;
 
-	if (tsk && tsk->state != TASK_RUNNING)
-		wake_up_process(tsk);
+	/* Interrupts are disabled: no need to stop preemption */
+	for (i = 0; pending && i < NR_SOFTIRQ_THREADS; i++) {
+		if (NR_SOFTIRQ_THREADS > 1 && !(pending & (1 << i)))
+			continue;
+		tsk = __get_cpu_var(ksoftirqd)[i].tsk;
+		if (tsk && tsk->state != TASK_RUNNING)
+			wake_up_process(tsk);
+	}
 }
 
 static void handle_pending_softirqs(u32 pending, int cpu, int need_rcu_bh_qs)
@@ -385,11 +418,11 @@ static inline void ksoftirqd_clr_sched_p
 static DEFINE_LOCAL_IRQ_LOCK(local_softirq_lock);
 static DEFINE_PER_CPU(struct task_struct *, local_softirq_runner);
 
-static void __do_softirq_common(int need_rcu_bh_qs);
+static void __do_softirq_common(u32 mask, int need_rcu_bh_qs);
 
-void __do_softirq(void)
+void __do_softirq(u32 mask)
 {
-	__do_softirq_common(0);
+	__do_softirq_common(mask, 0);
 }
 
 void __init softirq_early_init(void)
@@ -415,7 +448,7 @@ void local_bh_enable(void)
 
 		local_irq_disable();
 		if (local_softirq_pending())
-			__do_softirq();
+			__do_softirq(SOFTIRQ_MASK_ALL);
 		local_irq_enable();
 		local_unlock(local_softirq_lock);
 		WARN_ON(current->softirq_nestcnt != 1);
@@ -454,7 +487,7 @@ EXPORT_SYMBOL(in_serving_softirq);
  * Called with bh and local interrupts disabled. For full RT cpu must
  * be pinned.
  */
-static void __do_softirq_common(int need_rcu_bh_qs)
+static void __do_softirq_common(u32 mask, int need_rcu_bh_qs)
 {
 	u32 pending = local_softirq_pending();
 	int cpu = smp_processor_id();
@@ -462,17 +495,18 @@ static void __do_softirq_common(int need
 	current->softirq_nestcnt++;
 
 	/* Reset the pending bitmask before enabling irqs */
-	set_softirq_pending(0);
+	set_softirq_pending(pending & ~mask);
 
 	__get_cpu_var(local_softirq_runner) = current;
 
-	lockdep_softirq_enter();
+	/* Tell accounting that we're a softirq thread */
+	if (NR_SOFTIRQ_THREADS > 1 && !need_rcu_bh_qs)
+		__get_cpu_var(local_softirq_thread) = current;
 
-	handle_pending_softirqs(pending, cpu, need_rcu_bh_qs);
+	lockdep_softirq_enter();
 
-	pending = local_softirq_pending();
-	if (pending)
-		wakeup_softirqd();
+	handle_pending_softirqs(pending & mask, cpu, need_rcu_bh_qs);
+	wakeup_softirqd();
 
 	lockdep_softirq_exit();
 	__get_cpu_var(local_softirq_runner) = NULL;
@@ -480,7 +514,7 @@ static void __do_softirq_common(int need
 	current->softirq_nestcnt--;
 }
 
-static int __thread_do_softirq(int cpu)
+static int __thread_do_softirq(u32 mask, int cpu)
 {
 	/*
 	 * Prevent the current cpu from going offline.
@@ -506,8 +540,8 @@ static int __thread_do_softirq(int cpu)
 	 * We cannot switch stacks on RT as we want to be able to
 	 * schedule!
 	 */
-	if (local_softirq_pending())
-		__do_softirq_common(cpu >= 0);
+	if (local_softirq_pending() & mask)
+		__do_softirq_common(mask, cpu >= 0);
 	local_unlock(local_softirq_lock);
 	unpin_current_cpu();
 	preempt_disable();
@@ -522,14 +556,14 @@ void thread_do_softirq(void)
 {
 	if (!in_serving_softirq()) {
 		preempt_disable();
-		__thread_do_softirq(-1);
+		__thread_do_softirq(SOFTIRQ_MASK_ALL, -1);
 		preempt_enable();
 	}
 }
 
-static int ksoftirqd_do_softirq(int cpu)
+static int ksoftirqd_do_softirq(u32 mask, int cpu)
 {
-	return __thread_do_softirq(cpu);
+	return __thread_do_softirq(mask, cpu);
 }
 
 static inline void local_bh_disable_nort(void) { }
@@ -1097,21 +1131,38 @@ void tasklet_unlock_wait(struct tasklet_
 EXPORT_SYMBOL(tasklet_unlock_wait);
 #endif
 
+static inline int ksoftirqd_mask(struct task_struct *p)
+{
+#ifdef CONFIG_SIRQ_FORCED_THREADING
+	int i;
+
+	for (i = 0; i < NR_SOFTIRQ_THREADS; i++) {
+		if (p == __get_cpu_var(ksoftirqd)[i].tsk)
+			return __get_cpu_var(ksoftirqd)[i].mask;
+	}
+
+#endif
+	return SOFTIRQ_MASK_ALL;
+}
+
 static int run_ksoftirqd(void * __bind_cpu)
 {
+	u32 mask = ksoftirqd_mask(current);
+
 	ksoftirqd_set_sched_params();
+	this_cpu_write(local_softirq_thread, current);
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	while (!kthread_should_stop()) {
 		preempt_disable();
-		if (!local_softirq_pending())
+		if (!(local_softirq_pending() & mask))
 			schedule_preempt_disabled();
 
 		__set_current_state(TASK_RUNNING);
 
-		while (local_softirq_pending()) {
-			if (ksoftirqd_do_softirq((long) __bind_cpu))
+		while (local_softirq_pending() & mask) {
+			if (ksoftirqd_do_softirq(mask, (long) __bind_cpu))
 				goto wait_to_die;
 			__preempt_enable_no_resched();
 			cond_resched();
@@ -1200,41 +1251,58 @@ static int __cpuinit cpu_callback(struct
 				  unsigned long action,
 				  void *hcpu)
 {
-	int hotcpu = (unsigned long)hcpu;
+	int hotcpu = (unsigned long)hcpu, i;
 	struct task_struct *p;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-		p = kthread_create_on_node(run_ksoftirqd,
+		for (i = 0; i < NR_SOFTIRQ_THREADS; i++) {
+			per_cpu(ksoftirqd, hotcpu)[i].mask = SOFTIRQ_MASK_ALL;
+			per_cpu(ksoftirqd, hotcpu)[i].tsk = NULL;
+		}
+		for (i = 0; i < NR_SOFTIRQ_THREADS; i++) {
+			p = kthread_create_on_node(run_ksoftirqd,
 					   hcpu,
 					   cpu_to_node(hotcpu),
-					   "ksoftirqd/%d", hotcpu);
-		if (IS_ERR(p)) {
-			printk("ksoftirqd for %i failed\n", hotcpu);
-			return notifier_from_errno(PTR_ERR(p));
+					   "%s/%d", softirq_to_thread_name[i], hotcpu);
+			if (IS_ERR(p)) {
+				printk(KERN_ERR "%s/%d failed\n",
+					   softirq_to_thread_name[i], hotcpu);
+				return notifier_from_errno(PTR_ERR(p));
+			}
+			kthread_bind(p, hotcpu);
+			per_cpu(ksoftirqd, hotcpu)[i].tsk = p;
+			if (NR_SOFTIRQ_THREADS > 1)
+				per_cpu(ksoftirqd, hotcpu)[i].mask = 1 << i;
 		}
-		kthread_bind(p, hotcpu);
-  		per_cpu(ksoftirqd, hotcpu) = p;
  		break;
 	case CPU_ONLINE:
-		wake_up_process(per_cpu(ksoftirqd, hotcpu));
+		for (i = 0; i < NR_SOFTIRQ_THREADS; i++)
+			wake_up_process(per_cpu(ksoftirqd, hotcpu)[i].tsk);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
-	case CPU_UP_CANCELED:
-		if (!per_cpu(ksoftirqd, hotcpu))
-			break;
-		/* Unbind so it can run.  Fall thru. */
-		kthread_bind(per_cpu(ksoftirqd, hotcpu),
-			     cpumask_any(cpu_online_mask));
+	case CPU_UP_CANCELED: {
+		for (i = 0; i < NR_SOFTIRQ_THREADS; i++) {
+			p = per_cpu(ksoftirqd, hotcpu)[i].tsk;
+			if (!p)
+				continue;
+			/* Unbind so it can run. */
+			kthread_bind(p, cpumask_any(cpu_online_mask));
+		}
+	}
 	case CPU_POST_DEAD: {
 		static const struct sched_param param = {
 			.sched_priority = MAX_RT_PRIO-1
 		};
 
-		p = per_cpu(ksoftirqd, hotcpu);
-		per_cpu(ksoftirqd, hotcpu) = NULL;
-		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
-		kthread_stop(p);
+		for (i = 0; i < NR_SOFTIRQ_THREADS; i++) {
+			p = per_cpu(ksoftirqd, hotcpu)[i].tsk;
+			per_cpu(ksoftirqd, hotcpu)[i].tsk = NULL;
+			if (!p)
+				continue;
+			sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
+			kthread_stop(p);
+		}
 		takeover_tasklets(hotcpu);
 		break;
 	}


