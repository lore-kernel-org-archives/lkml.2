Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab1IKSOo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 14:14:44 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:40617 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752601Ab1IKSOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 14:14:42 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19nkSwJRZZneTQ90mxuJk8L7q9Z1I5wxVasi4Vcif
	cV8IUpsoNRwfcY
Subject: Re: [ANNOUNCE] 3.0.4-rt13
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.02.1109101052340.2723@ionos>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Sep 2011 20:14:36 +0200
Message-ID: <1315764876.6352.61.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm very definitely missing sirq threads from the wakeup latency POV.

(Other things are muddying the water, eg. rcu boost, if wired up and
selected always ramming boosted threads through the roof instead of
configured boost prio.. etc etc, but this definitely improves my latency
woes a lot)

This is a giant step backward from "let's improve abysmal throughput",
so I'm wondering if anyone has better ideas.

WRT below: "fixes" are dinky, this is not...

sched, rt, sirq: resurrect sirq threads for RT_FULL

Not-signed-off-by: Mike Galbraith <efault@gmx.de>
---
 include/linux/interrupt.h |   46 +++++++
 kernel/irq/Kconfig        |    7 +
 kernel/sched.c            |    4 
 kernel/softirq.c          |  268 ++++++++++++++++++++++++++++------------------
 4 files changed, 219 insertions(+), 106 deletions(-)

Index: linux-3.0-tip/include/linux/interrupt.h
===================================================================
--- linux-3.0-tip.orig/include/linux/interrupt.h
+++ linux-3.0-tip/include/linux/interrupt.h
@@ -423,6 +423,9 @@ enum
 	NR_SOFTIRQS
 };
 
+/* Update when adding new softirqs. */
+#define SOFTIRQ_MASK_ALL 0x3ff
+
 /* map softirq index to softirq name. update 'softirq_to_name' in
  * kernel/softirq.c when adding a new softirq.
  */
@@ -438,10 +441,16 @@ struct softirq_action
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
 
@@ -467,12 +476,43 @@ extern void softirq_check_pending_idle(v
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
Index: linux-3.0-tip/kernel/sched.c
===================================================================
--- linux-3.0-tip.orig/kernel/sched.c
+++ linux-3.0-tip/kernel/sched.c
@@ -2079,7 +2079,7 @@ void account_system_vtime(struct task_st
 	 */
 	if (hardirq_count())
 		__this_cpu_add(cpu_hardirq_time, delta);
-	else if (in_serving_softirq() && curr != this_cpu_ksoftirqd())
+	else if (in_serving_softirq() && !this_cpu_ksoftirqd(curr))
 		__this_cpu_add(cpu_softirq_time, delta);
 
 	irq_time_write_end();
@@ -4098,7 +4098,7 @@ static void irqtime_account_process_tick
 		cpustat->irq = cputime64_add(cpustat->irq, tmp);
 	} else if (irqtime_account_si_update()) {
 		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
-	} else if (this_cpu_ksoftirqd() == p) {
+	} else if (this_cpu_ksoftirqd(p)) {
 		/*
 		 * ksoftirqd time do not get accounted in cpu_softirq_time.
 		 * So, we have to handle it separately here.
Index: linux-3.0-tip/kernel/softirq.c
===================================================================
--- linux-3.0-tip.orig/kernel/softirq.c
+++ linux-3.0-tip/kernel/softirq.c
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
+	[SCHED_SOFTIRQ]		= "sirq-sched",
+	[TIMER_SOFTIRQ]		= "sirq-timer",
+	[NET_TX_SOFTIRQ]	= "sirq-net-tx",
+	[NET_RX_SOFTIRQ]	= "sirq-net-rx",
+	[BLOCK_SOFTIRQ]		= "sirq-block",
+	[BLOCK_IOPOLL_SOFTIRQ]	= "sirq-block-iopoll",
+	[TASKLET_SOFTIRQ]	= "sirq-tasklet",
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
@@ -77,32 +95,39 @@ char *softirq_to_name[NR_SOFTIRQS] = {
 void softirq_check_pending_idle(void)
 {
 	static int rate_limit;
-	u32 warnpending = 0, pending = local_softirq_pending();
+	u32 warnpending = 0, pending = local_softirq_pending(), mask;
+	int curr = 0;
 
 	if (rate_limit >= 10)
 		return;
 
-	if (pending) {
-		struct task_struct *tsk;
+	while (pending) {
+		mask =  __get_cpu_var(ksoftirqd)[curr].mask;
 
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
+			tsk = __get_cpu_var(ksoftirqd)[curr].tsk;
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
+		curr++;
 	}
 
 	if (warnpending) {
 		printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
-		       pending);
+		       warnpending);
 		rate_limit++;
 	}
 }
@@ -131,11 +156,17 @@ void softirq_check_pending_idle(void)
  */
 static void wakeup_softirqd(void)
 {
-	/* Interrupts are disabled: no need to stop preemption */
-	struct task_struct *tsk = __this_cpu_read(ksoftirqd);
+	struct task_struct *tsk;
+	u32 pending = local_softirq_pending(), mask, i;
 
-	if (tsk && tsk->state != TASK_RUNNING)
-		wake_up_process(tsk);
+	for (i = 0; pending && i < NR_SOFTIRQ_THREADS; i++) {
+		mask = __get_cpu_var(ksoftirqd)[i].mask;
+		if (!(pending & mask))
+			continue;
+		tsk = __get_cpu_var(ksoftirqd)[i].tsk;
+		if (tsk && tsk->state != TASK_RUNNING)
+			wake_up_process(tsk);
+	}
 }
 
 static void handle_pending_softirqs(u32 pending, int cpu)
@@ -378,16 +409,19 @@ static inline void ksoftirqd_clr_sched_p
 #else /* !PREEMPT_RT_FULL */
 
 /*
- * On RT we serialize softirq execution with a cpu local lock
+ * On RT we serialize softirq execution with cpu local locks
  */
-static DEFINE_LOCAL_IRQ_LOCK(local_softirq_lock);
-static DEFINE_PER_CPU(struct task_struct *, local_softirq_runner);
+static DEFINE_PER_CPU(struct local_irq_lock, local_softirq_lock[NR_SOFTIRQ_THREADS]);
+static DEFINE_PER_CPU(struct task_struct *, local_softirq_runner[NR_SOFTIRQ_THREADS]);
 
-static void __do_softirq(void);
+static void __do_softirq(u32 mask);
 
 void __init softirq_early_init(void)
 {
-	local_irq_lock_init(local_softirq_lock);
+	int i;
+
+	for (i = 0; i < NR_SOFTIRQ_THREADS; i++)
+		local_irq_lock_init(local_softirq_lock[i]);
 }
 
 void local_bh_disable(void)
@@ -399,20 +433,32 @@ EXPORT_SYMBOL(local_bh_disable);
 
 void local_bh_enable(void)
 {
+	u32 mask = SOFTIRQ_MASK_ALL, i;
+
 	if (WARN_ON(current->softirq_nestcnt == 0))
-		return;
+		goto out;
 
-	if ((current->softirq_nestcnt == 1) &&
-	    local_softirq_pending() &&
-	    local_trylock(local_softirq_lock)) {
+	if (current->softirq_nestcnt != 1)
+		goto out;
+
+	for (i = 0; i < NR_SOFTIRQ_THREADS; i++) {
+		if (NR_SOFTIRQ_THREADS > 1)
+			mask = 1 << i;
+		if (!(local_softirq_pending() & mask))
+			continue;
+		if (!local_trylock(local_softirq_lock[i]))
+			continue;
 
 		local_irq_disable();
-		if (local_softirq_pending())
-			__do_softirq();
-		local_unlock(local_softirq_lock);
+		if (local_softirq_pending() & mask)
+			__do_softirq(local_softirq_pending() & mask);
+		local_unlock(local_softirq_lock[i]);
 		local_irq_enable();
 		WARN_ON(current->softirq_nestcnt != 1);
 	}
+
+out:
+	wakeup_softirqd();
 	current->softirq_nestcnt--;
 	migrate_enable();
 }
@@ -427,17 +473,22 @@ EXPORT_SYMBOL(local_bh_enable_ip);
 /* For tracing */
 int notrace __in_softirq(void)
 {
-	if (__get_cpu_var(local_softirq_lock).owner == current)
-		return __get_cpu_var(local_softirq_lock).nestcnt;
+	int i;
+
+	for (i = 0; i < NR_SOFTIRQ_THREADS; i++) {
+		if (__get_cpu_var(local_softirq_lock)[i].owner == current)
+			return __get_cpu_var(local_softirq_lock)[i].nestcnt;
+	}
 	return 0;
 }
 
 int in_serving_softirq(void)
 {
-	int res;
+	int res = 0, i;
 
 	preempt_disable();
-	res = __get_cpu_var(local_softirq_runner) == current;
+	for (i = 0; i < NR_SOFTIRQ_THREADS && !res; i++)
+		res = __get_cpu_var(local_softirq_runner)[i] == current;
 	preempt_enable();
 	return res;
 }
@@ -446,34 +497,36 @@ int in_serving_softirq(void)
  * Called with bh and local interrupts disabled. For full RT cpu must
  * be pinned.
  */
-static void __do_softirq(void)
+static void __do_softirq(u32 mask)
 {
 	u32 pending = local_softirq_pending();
-	int cpu = smp_processor_id();
+	int cpu = smp_processor_id(), i = 0;
 
 	current->softirq_nestcnt++;
 
-	/* Reset the pending bitmask before enabling irqs */
-	set_softirq_pending(0);
+	/* Reset the pending bit[s] before enabling irqs */
+	set_softirq_pending(pending & ~mask);
 
-	__get_cpu_var(local_softirq_runner) = current;
+	/* If threaded, find which sirq we're processing */
+	while (NR_SOFTIRQ_THREADS > 1 && !(mask & (1 << i)))
+		i++;
 
-	lockdep_softirq_enter();
+	__get_cpu_var(local_softirq_runner)[i] = current;
 
-	handle_pending_softirqs(pending, cpu);
+	lockdep_softirq_enter();
 
-	pending = local_softirq_pending();
-	if (pending)
-		wakeup_softirqd();
+	handle_pending_softirqs(mask, cpu);
 
 	lockdep_softirq_exit();
-	__get_cpu_var(local_softirq_runner) = NULL;
+	__get_cpu_var(local_softirq_runner)[i] = NULL;
 
 	current->softirq_nestcnt--;
 }
 
 static int __thread_do_softirq(int cpu)
 {
+	u32 mask, my_mask, i;
+
 	/*
 	 * Prevent the current cpu from going offline.
 	 * pin_current_cpu() can reenable preemption and block on the
@@ -491,19 +544,27 @@ static int __thread_do_softirq(int cpu)
 		unpin_current_cpu();
 		return -1;
 	}
-	preempt_enable();
-	local_lock(local_softirq_lock);
-	local_irq_disable();
-	/*
-	 * We cannot switch stacks on RT as we want to be able to
-	 * schedule!
-	 */
-	if (local_softirq_pending())
-		__do_softirq();
-	local_unlock(local_softirq_lock);
+
+	mask = my_mask = task_sirq_mask(current);
+
+	for (i = 0; my_mask && i < NR_SOFTIRQ_THREADS; i++) {
+		if (NR_SOFTIRQ_THREADS > 1) {
+			mask = 1 << i;
+			my_mask &= ~mask;
+			if (!(local_softirq_pending() & mask))
+				continue;
+		}
+		preempt_enable();
+		local_lock(local_softirq_lock[i]);
+		local_irq_disable();
+		if (local_softirq_pending() & mask)
+			__do_softirq(local_softirq_pending() & mask);
+		local_unlock(local_softirq_lock[i]);
+		preempt_disable();
+		local_irq_enable();
+	}
 	unpin_current_cpu();
-	preempt_disable();
-	local_irq_enable();
+
 	return 0;
 }
 
@@ -512,11 +573,11 @@ static int __thread_do_softirq(int cpu)
  */
 void thread_do_softirq(void)
 {
-	if (!in_serving_softirq()) {
-		preempt_disable();
+	preempt_disable();
+	if (!in_serving_softirq())
 		__thread_do_softirq(-1);
-		preempt_enable();
-	}
+	wakeup_softirqd();
+	preempt_enable();
 }
 
 static int ksoftirqd_do_softirq(int cpu)
@@ -563,28 +624,15 @@ void irq_enter(void)
 	__irq_enter();
 }
 
-#ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
 static inline void invoke_softirq(void)
 {
 #ifndef CONFIG_PREEMPT_RT_FULL
 	if (!force_irqthreads)
+#ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
 		__do_softirq();
-	else {
-		__local_bh_disable((unsigned long)__builtin_return_address(0),
-				SOFTIRQ_OFFSET);
-		wakeup_softirqd();
-		__local_bh_enable(SOFTIRQ_OFFSET);
-	}
-#else
-	wakeup_softirqd();
-#endif
-}
 #else
-static inline void invoke_softirq(void)
-{
-#ifndef CONFIG_PREEMPT_RT_FULL
-	if (!force_irqthreads)
 		do_softirq();
+#endif
 	else {
 		__local_bh_disable((unsigned long)__builtin_return_address(0),
 				SOFTIRQ_OFFSET);
@@ -595,7 +643,6 @@ static inline void invoke_softirq(void)
 	wakeup_softirqd();
 #endif
 }
-#endif
 
 /*
  * Exit an interrupt context. Process softirqs if needed and possible:
@@ -1000,18 +1047,20 @@ void __init softirq_init(void)
 
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
@@ -1101,45 +1150,62 @@ static int __cpuinit cpu_callback(struct
 				  unsigned long action,
 				  void *hcpu)
 {
-	int hotcpu = (unsigned long)hcpu;
+	int hotcpu = (unsigned long)hcpu, i;
 	struct task_struct *p;
 
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
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
- 		break;
+		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		wake_up_process(per_cpu(ksoftirqd, hotcpu));
+		for (i = 0; i < NR_SOFTIRQ_THREADS; i++)
+			wake_up_process(per_cpu(ksoftirqd, hotcpu)[i].tsk);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-		if (!per_cpu(ksoftirqd, hotcpu))
-			break;
-		/* Unbind so it can run.  Fall thru. */
-		kthread_bind(per_cpu(ksoftirqd, hotcpu),
-			     cpumask_any(cpu_online_mask));
+	case CPU_UP_CANCELED_FROZEN: {
+		for (i = 0; i < NR_SOFTIRQ_THREADS; i++) {
+			p = per_cpu(ksoftirqd, hotcpu)[i].tsk;
+			if (!p)
+				continue;
+			/* Unbind so it can run. */
+			kthread_bind(p, cpumask_any(cpu_online_mask));
+		}
+	}
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN: {
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
Index: linux-3.0-tip/kernel/irq/Kconfig
===================================================================
--- linux-3.0-tip.orig/kernel/irq/Kconfig
+++ linux-3.0-tip/kernel/irq/Kconfig
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


