Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab1K3Eck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 23:32:40 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:53442 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751996Ab1K3Eci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 23:32:38 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18WIr4/qeQWLhGt7sERCEM0u4pNFENtwSlctOxZwU
	OuEQGoZm8JIFUR
Subject: Re: [PATCH RT] tasklet/rt: Prevent tasklets from going into
 infinite spin in RT
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Clark Williams <williams@redhat.com>
In-Reply-To: <1322618120.17003.104.camel@frodo>
References: <1322618120.17003.104.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Nov 2011 05:32:31 +0100
Message-ID: <1322627551.17283.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 20:55 -0500, Steven Rostedt wrote:
> Ingo,
> 
> I forward ported this code from 2.6.33.9-rt31, but I think you were the
> original author, as I found most of this code in the
> "tasklet-redesign.patch" from my broken out 2.6.24-rt patches. I
> committed it into my git tree (stable-rt) under your name, and added the
> Signed-off-by that you had in that patch, if you have and objections,
> please let me know. This patch should never see mainline, but it will
> probably be going into the -rt branch. I wrote up this change log, if
> there's something you don't like in it, let me know and I'll fix it.

I'm oh so happy to see this.  I've been going nuts trying to figure out
why the heck 33-rt doesn't go bonkers, but 30+ rt does.

> Luis and Clark (I love saying that),
> 
> I booted this patch against 3.0-rt stable, and it didn't crash ;)
> Could you apply it and see if it fixes the hang that you've been seeing.

I'll most certainly be testing it too.  With the below, and the
conditional yield thingy disabled, all I have to do is boot x3550 M3
box, and it'll hang very frequently, but not always, with sirq-tasklet
going stark raving mad.  Yielding fix^Wmakes it not do the bad thing.

(somewhat less disgusting version of sirq threads patch;)

sched, rt: resurrect softirq threads for RT_FULL

Signed-off-by: Mike Galbraith <efault@gmx.de>
---
 include/linux/interrupt.h |   46 ++++++++++
 kernel/irq/Kconfig        |    7 +
 kernel/sched.c            |    4 
 kernel/softirq.c          |  194 ++++++++++++++++++++++++++++++++--------------
 4 files changed, 191 insertions(+), 60 deletions(-)

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
 
@@ -486,12 +495,43 @@ extern void softirq_check_pending_idle(v
  */
 DECLARE_PER_CPU(struct list_head [NR_SOFTIRQS], softirq_work_list);
 
-DECLARE_PER_CPU(struct task_struct *, ksoftirqd);
+struct softirqdata {
+	int			mask;
+	struct task_struct	*tsk;
+};
+
+DECLARE_PER_CPU(struct softirqdata [NR_SOFTIRQ_THREADS], ksoftirqd);
+
+static inline bool this_cpu_ksoftirqd(struct task_struct *p)
+{
+	int i;
+
+	for (i = 0; i < NR_SOFTIRQ_THREADS; i++) {
+		if (p == __get_cpu_var(ksoftirqd)[i].tsk)
+			return true;
+	}
 
-static inline struct task_struct *this_cpu_ksoftirqd(void)
+	return false;
+}
+
+#ifdef CONFIG_PREEMPT_RT_FULL
+static inline int task_sirq_mask(struct task_struct *p)
+{
+	int i;
+
+	for (i = 0; i < NR_SOFTIRQ_THREADS; i++) {
+		if (p == __get_cpu_var(ksoftirqd)[i].tsk)
+			return __get_cpu_var(ksoftirqd)[i].mask;
+	}
+
+	return SOFTIRQ_MASK_ALL;
+}
+#else
+static inline int task_sirq_mask(struct task_struct *p)
 {
-	return this_cpu_read(ksoftirqd);
+	return SOFTIRQ_MASK_ALL;
 }
+#endif
 
 /* Try to send a softirq to a remote cpu.  If this cannot be done, the
  * work will be queued to the local cpu.
Index: linux-3.2-rt/kernel/sched.c
===================================================================
--- linux-3.2-rt.orig/kernel/sched.c
+++ linux-3.2-rt/kernel/sched.c
@@ -2082,7 +2082,7 @@ void account_system_vtime(struct task_st
 	 */
 	if (hardirq_count())
 		__this_cpu_add(cpu_hardirq_time, delta);
-	else if (in_serving_softirq() && curr != this_cpu_ksoftirqd())
+	else if (in_serving_softirq() && !this_cpu_ksoftirqd(curr))
 		__this_cpu_add(cpu_softirq_time, delta);
 
 	irq_time_write_end();
@@ -4062,7 +4062,7 @@ static void irqtime_account_process_tick
 		cpustat->irq = cputime64_add(cpustat->irq, tmp);
 	} else if (irqtime_account_si_update()) {
 		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
-	} else if (this_cpu_ksoftirqd() == p) {
+	} else if (this_cpu_ksoftirqd(p)) {
 		/*
 		 * ksoftirqd time do not get accounted in cpu_softirq_time.
 		 * So, we have to handle it separately here.
Index: linux-3.2-rt/kernel/softirq.c
===================================================================
--- linux-3.2-rt.orig/kernel/softirq.c
+++ linux-3.2-rt/kernel/softirq.c
@@ -55,13 +55,31 @@ EXPORT_SYMBOL(irq_stat);
 
 static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp;
 
-DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
+DEFINE_PER_CPU(struct softirqdata[NR_SOFTIRQ_THREADS], ksoftirqd);
 
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
@@ -77,32 +95,38 @@ char *softirq_to_name[NR_SOFTIRQS] = {
 void softirq_check_pending_idle(void)
 {
 	static int rate_limit;
-	u32 warnpending = 0, pending = local_softirq_pending();
+	u32 warnpending = 0, pending = local_softirq_pending(), mask;
+	int i = 0;
 
 	if (rate_limit >= 10)
 		return;
 
-	if (pending) {
-		struct task_struct *tsk;
+	for (i = 0; pending && i < NR_SOFTIRQ_THREADS; i++) {
+		mask =  __get_cpu_var(ksoftirqd)[i].mask;
 
-		tsk = __get_cpu_var(ksoftirqd);
-		/*
-		 * The wakeup code in rtmutex.c wakes up the task
-		 * _before_ it sets pi_blocked_on to NULL under
-		 * tsk->pi_lock. So we need to check for both: state
-		 * and pi_blocked_on.
-		 */
-		raw_spin_lock(&tsk->pi_lock);
+		if (pending & mask) {
+			struct task_struct *tsk;
+
+			tsk = __get_cpu_var(ksoftirqd)[i].tsk;
+			/*
+			 * The wakeup code in rtmutex.c wakes up the task
+			 * _before_ it sets pi_blocked_on to NULL under
+			 * tsk->pi_lock. So we need to check for both: state
+			 * and pi_blocked_on.
+			 */
+			raw_spin_lock(&tsk->pi_lock);
 
-		if (!tsk->pi_blocked_on && !(tsk->state == TASK_RUNNING))
-			warnpending = 1;
+			if (!tsk->pi_blocked_on && !(tsk->state == TASK_RUNNING))
+				warnpending |= pending & mask;
 
-		raw_spin_unlock(&tsk->pi_lock);
+			raw_spin_unlock(&tsk->pi_lock);
+			pending &= ~mask;
+		}
 	}
 
 	if (warnpending) {
 		printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
-		       pending);
+		       warnpending);
 		rate_limit++;
 	}
 }
@@ -131,11 +155,18 @@ void softirq_check_pending_idle(void)
  */
 static void wakeup_softirqd(void)
 {
-	/* Interrupts are disabled: no need to stop preemption */
-	struct task_struct *tsk = __this_cpu_read(ksoftirqd);
+	struct task_struct *tsk;
+	u32 pending = local_softirq_pending(), mask, i;
 
-	if (tsk && tsk->state != TASK_RUNNING)
-		wake_up_process(tsk);
+	/* Interrupts are disabled: no need to stop preemption */
+	for (i = 0; pending && i < NR_SOFTIRQ_THREADS; i++) {
+		mask = __get_cpu_var(ksoftirqd)[i].mask;
+		if (!(pending & mask))
+			continue;
+		tsk = __get_cpu_var(ksoftirqd)[i].tsk;
+		if (tsk && tsk->state != TASK_RUNNING)
+			wake_up_process(tsk);
+	}
 }
 
 static void handle_pending_softirqs(u32 pending, int cpu, int need_rcu_bh_qs)
@@ -384,11 +415,11 @@ static inline void ksoftirqd_clr_sched_p
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
@@ -414,7 +445,7 @@ void local_bh_enable(void)
 
 		local_irq_disable();
 		if (local_softirq_pending())
-			__do_softirq();
+			__do_softirq(SOFTIRQ_MASK_ALL);
 		local_irq_enable();
 		local_unlock(local_softirq_lock);
 		WARN_ON(current->softirq_nestcnt != 1);
@@ -453,7 +484,7 @@ EXPORT_SYMBOL(in_serving_softirq);
  * Called with bh and local interrupts disabled. For full RT cpu must
  * be pinned.
  */
-static void __do_softirq_common(int need_rcu_bh_qs)
+static void __do_softirq_common(u32 mask, int need_rcu_bh_qs)
 {
 	u32 pending = local_softirq_pending();
 	int cpu = smp_processor_id();
@@ -461,17 +492,14 @@ static void __do_softirq_common(int need
 	current->softirq_nestcnt++;
 
 	/* Reset the pending bitmask before enabling irqs */
-	set_softirq_pending(0);
+	set_softirq_pending(pending & ~mask);
 
 	__get_cpu_var(local_softirq_runner) = current;
 
 	lockdep_softirq_enter();
 
-	handle_pending_softirqs(pending, cpu, need_rcu_bh_qs);
-
-	pending = local_softirq_pending();
-	if (pending)
-		wakeup_softirqd();
+	handle_pending_softirqs(pending & mask, cpu, need_rcu_bh_qs);
+	wakeup_softirqd();
 
 	lockdep_softirq_exit();
 	__get_cpu_var(local_softirq_runner) = NULL;
@@ -481,6 +509,8 @@ static void __do_softirq_common(int need
 
 static int __thread_do_softirq(int cpu)
 {
+	u32 mask;
+
 	/*
 	 * Prevent the current cpu from going offline.
 	 * pin_current_cpu() can reenable preemption and block on the
@@ -498,6 +528,8 @@ static int __thread_do_softirq(int cpu)
 		unpin_current_cpu();
 		return -1;
 	}
+
+	mask = task_sirq_mask(current);
 	preempt_enable();
 	local_lock(local_softirq_lock);
 	local_irq_disable();
@@ -505,8 +537,8 @@ static int __thread_do_softirq(int cpu)
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
@@ -1005,24 +1037,59 @@ void __init softirq_init(void)
 	open_softirq(HI_SOFTIRQ, tasklet_hi_action);
 }
 
+/* Drop priority and yield() if we may starve other sirq threads. */
+static int ksoftirqd_cond_yield(struct task_struct *p, u32 mask)
+{
+#ifdef CONFIG_SIRQ_FORCED_THREADING
+	u32 pending = local_softirq_pending();
+	struct sched_param param;
+	int prio, policy = p->policy;
+
+	if (!pending || !(pending & mask))
+		return 1;
+
+	if (policy != SCHED_FIFO && policy != SCHED_RR)
+		return 0;
+
+	prio = p->rt_priority;
+
+	if (prio != MAX_RT_PRIO-1) {
+		param.sched_priority = MAX_RT_PRIO-1;
+		sched_setscheduler(p, policy, &param);
+	}
+	yield();
+	if (p->policy == policy && p->rt_priority == MAX_RT_PRIO-1) {
+		param.sched_priority = prio;
+		sched_setscheduler(p, policy, &param);
+	}
+
+	return 1;
+#else
+	return 0;
+#endif
+}
+
 static int run_ksoftirqd(void * __bind_cpu)
 {
+	u32 mask = task_sirq_mask(current);
+
 	ksoftirqd_set_sched_params();
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	while (!kthread_should_stop()) {
 		preempt_disable();
-		if (!local_softirq_pending())
+		if (!(local_softirq_pending() & mask))
 			schedule_preempt_disabled();
 
 		__set_current_state(TASK_RUNNING);
 
-		while (local_softirq_pending()) {
+		while (local_softirq_pending() & mask) {
 			if (ksoftirqd_do_softirq((long) __bind_cpu))
 				goto wait_to_die;
 			__preempt_enable_no_resched();
-			cond_resched();
+			if (!ksoftirqd_cond_yield(current, mask))
+				cond_resched();
 			preempt_disable();
 			rcu_note_context_switch((long)__bind_cpu);
 		}
@@ -1108,41 +1175,58 @@ static int __cpuinit cpu_callback(struct
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


