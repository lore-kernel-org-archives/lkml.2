Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab2GPKnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 06:43:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:52614 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab2GPKmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 06:42:45 -0400
Message-Id: <20120716103948.563736676@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 16 Jul 2012 10:42:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [Patch 5/7] watchdog: Use hotplug thread infrastructure
References: <20120716103749.122800930@linutronix.de>
Content-Disposition: inline; filename=watchdog-use-smb-kthreads.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/watchdog.c |  264 ++++++++++++++++++------------------------------------
 1 file changed, 89 insertions(+), 175 deletions(-)

Index: tip/kernel/watchdog.c
===================================================================
--- tip.orig/kernel/watchdog.c
+++ tip/kernel/watchdog.c
@@ -22,6 +22,7 @@
 #include <linux/notifier.h>
 #include <linux/module.h>
 #include <linux/sysctl.h>
+#include <linux/smpboot.h>
 
 #include <asm/irq_regs.h>
 #include <linux/kvm_para.h>
@@ -29,16 +30,18 @@
 
 int watchdog_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
+static int __read_mostly watchdog_disabled;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
 static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
 static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
 static DEFINE_PER_CPU(bool, softlockup_touch_sync);
 static DEFINE_PER_CPU(bool, soft_watchdog_warn);
+static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
+static DEFINE_PER_CPU(unsigned long, soft_lockup_hrtimer_cnt);
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 static DEFINE_PER_CPU(bool, hard_watchdog_warn);
 static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
-static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 #endif
@@ -248,13 +251,15 @@ static void watchdog_overflow_callback(s
 	__this_cpu_write(hard_watchdog_warn, false);
 	return;
 }
+#endif /* CONFIG_HARDLOCKUP_DETECTOR */
+
 static void watchdog_interrupt_count(void)
 {
 	__this_cpu_inc(hrtimer_interrupts);
 }
-#else
-static inline void watchdog_interrupt_count(void) { return; }
-#endif /* CONFIG_HARDLOCKUP_DETECTOR */
+
+static int watchdog_nmi_enable(unsigned int cpu);
+static void watchdog_nmi_disable(unsigned int cpu);
 
 /* watchdog kicker functions */
 static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
@@ -327,52 +332,71 @@ static enum hrtimer_restart watchdog_tim
 	return HRTIMER_RESTART;
 }
 
+static void watchdog_set_prio(unsigned int policy, unsigned int prio)
+{
+	struct sched_param param = { .sched_priority = prio };
 
-/*
- * The watchdog thread - touches the timestamp.
- */
-static int watchdog(void *unused)
+	sched_setscheduler(current, policy, &param);
+}
+
+static void watchdog_enable(unsigned int cpu)
 {
-	struct sched_param param = { .sched_priority = 0 };
 	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
-	/* initialize timestamp */
-	__touch_watchdog();
+	if (!watchdog_enabled) {
+		kthread_park(current);
+		return;
+	}
+
+	/* Enable the perf event */
+	watchdog_nmi_enable(cpu);
 
 	/* kick off the timer for the hardlockup detector */
+	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer->function = watchdog_timer_fn;
+
 	/* done here because hrtimer_start can only pin to smp_processor_id() */
 	hrtimer_start(hrtimer, ns_to_ktime(get_sample_period()),
 		      HRTIMER_MODE_REL_PINNED);
 
-	set_current_state(TASK_INTERRUPTIBLE);
-	/*
-	 * Run briefly (kicked by the hrtimer callback function) once every
-	 * get_sample_period() seconds (4 seconds by default) to reset the
-	 * softlockup timestamp. If this gets delayed for more than
-	 * 2*watchdog_thresh seconds then the debug-printout triggers in
-	 * watchdog_timer_fn().
-	 */
-	while (!kthread_should_stop()) {
-		__touch_watchdog();
-		schedule();
+	/* initialize timestamp */
+	watchdog_set_prio(SCHED_FIFO, MAX_RT_PRIO - 1);
+	__touch_watchdog();
+}
 
-		if (kthread_should_stop())
-			break;
+static void watchdog_disable(unsigned int cpu)
+{
+	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
-		set_current_state(TASK_INTERRUPTIBLE);
-	}
-	/*
-	 * Drop the policy/priority elevation during thread exit to avoid a
-	 * scheduling latency spike.
-	 */
-	__set_current_state(TASK_RUNNING);
-	sched_setscheduler(current, SCHED_NORMAL, &param);
-	return 0;
+	watchdog_set_prio(SCHED_NORMAL, 0);
+	hrtimer_cancel(hrtimer);
+	/* disable the perf event */
+	watchdog_nmi_disable(cpu);
+}
+
+static int watchdog_should_run(unsigned int cpu)
+{
+	return __this_cpu_read(hrtimer_interrupts) !=
+		__this_cpu_read(soft_lockup_hrtimer_cnt);
 }
 
+/*
+ * The watchdog thread function - touches the timestamp.
+ *
+ * It only runs once every get_sample_period() seconds (4 seconds by
+ * default) to reset the softlockup timestamp. If this gets delayed
+ * for more than 2*watchdog_thresh seconds then the debug-printout
+ * triggers in watchdog_timer_fn().
+ */
+static void watchdog(unsigned int cpu)
+{
+	__this_cpu_write(soft_lockup_hrtimer_cnt,
+			 __this_cpu_read(hrtimer_interrupts));
+	__touch_watchdog();
+}
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
-static int watchdog_nmi_enable(int cpu)
+static int watchdog_nmi_enable(unsigned int cpu)
 {
 	struct perf_event_attr *wd_attr;
 	struct perf_event *event = per_cpu(watchdog_ev, cpu);
@@ -395,7 +419,6 @@ static int watchdog_nmi_enable(int cpu)
 		goto out_save;
 	}
 
-
 	/* vary the KERN level based on the returned errno */
 	if (PTR_ERR(event) == -EOPNOTSUPP)
 		pr_info("disabled (cpu%i): not supported (no LAPIC?)\n", cpu);
@@ -416,7 +439,7 @@ out:
 	return 0;
 }
 
-static void watchdog_nmi_disable(int cpu)
+static void watchdog_nmi_disable(unsigned int cpu)
 {
 	struct perf_event *event = per_cpu(watchdog_ev, cpu);
 
@@ -430,107 +453,35 @@ static void watchdog_nmi_disable(int cpu
 	return;
 }
 #else
-static int watchdog_nmi_enable(int cpu) { return 0; }
-static void watchdog_nmi_disable(int cpu) { return; }
+static int watchdog_nmi_enable(unsigned int cpu) { return 0; }
+static void watchdog_nmi_disable(unsigned int cpu) { return; }
 #endif /* CONFIG_HARDLOCKUP_DETECTOR */
 
 /* prepare/enable/disable routines */
-static void watchdog_prepare_cpu(int cpu)
-{
-	struct hrtimer *hrtimer = &per_cpu(watchdog_hrtimer, cpu);
-
-	WARN_ON(per_cpu(softlockup_watchdog, cpu));
-	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	hrtimer->function = watchdog_timer_fn;
-}
-
-static int watchdog_enable(int cpu)
-{
-	struct task_struct *p = per_cpu(softlockup_watchdog, cpu);
-	int err = 0;
-
-	/* enable the perf event */
-	err = watchdog_nmi_enable(cpu);
-
-	/* Regardless of err above, fall through and start softlockup */
-
-	/* create the watchdog thread */
-	if (!p) {
-		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
-		p = kthread_create_on_node(watchdog, NULL, cpu_to_node(cpu), "watchdog/%d", cpu);
-		if (IS_ERR(p)) {
-			pr_err("softlockup watchdog for %i failed\n", cpu);
-			if (!err) {
-				/* if hardlockup hasn't already set this */
-				err = PTR_ERR(p);
-				/* and disable the perf event */
-				watchdog_nmi_disable(cpu);
-			}
-			goto out;
-		}
-		sched_setscheduler(p, SCHED_FIFO, &param);
-		kthread_bind(p, cpu);
-		per_cpu(watchdog_touch_ts, cpu) = 0;
-		per_cpu(softlockup_watchdog, cpu) = p;
-		wake_up_process(p);
-	}
-
-out:
-	return err;
-}
-
-static void watchdog_disable(int cpu)
-{
-	struct task_struct *p = per_cpu(softlockup_watchdog, cpu);
-	struct hrtimer *hrtimer = &per_cpu(watchdog_hrtimer, cpu);
-
-	/*
-	 * cancel the timer first to stop incrementing the stats
-	 * and waking up the kthread
-	 */
-	hrtimer_cancel(hrtimer);
-
-	/* disable the perf event */
-	watchdog_nmi_disable(cpu);
-
-	/* stop the watchdog thread */
-	if (p) {
-		per_cpu(softlockup_watchdog, cpu) = NULL;
-		kthread_stop(p);
-	}
-}
-
 /* sysctl functions */
 #ifdef CONFIG_SYSCTL
 static void watchdog_enable_all_cpus(void)
 {
-	int cpu;
-
-	watchdog_enabled = 0;
-
-	for_each_online_cpu(cpu)
-		if (!watchdog_enable(cpu))
-			/* if any cpu succeeds, watchdog is considered
-			   enabled for the system */
-			watchdog_enabled = 1;
-
-	if (!watchdog_enabled)
-		pr_err("failed to be enabled on some cpus\n");
+	unsigned int cpu;
 
+	if (watchdog_disabled) {
+		watchdog_disabled = 0;
+		for_each_online_cpu(cpu)
+			kthread_unpark(per_cpu(softlockup_watchdog, cpu));
+	}
 }
 
 static void watchdog_disable_all_cpus(void)
 {
-	int cpu;
-
-	for_each_online_cpu(cpu)
-		watchdog_disable(cpu);
+	unsigned int cpu;
 
-	/* if all watchdogs are disabled, then they are disabled for the system */
-	watchdog_enabled = 0;
+	if (!watchdog_disabled) {
+		watchdog_disabled = 1;
+		for_each_online_cpu(cpu)
+			kthread_park(per_cpu(softlockup_watchdog, cpu));
+	}
 }
 
-
 /*
  * proc handler for /proc/sys/kernel/nmi_watchdog,watchdog_thresh
  */
@@ -540,73 +491,36 @@ int proc_dowatchdog(struct ctl_table *ta
 {
 	int ret;
 
+	if (watchdog_disabled < 0)
+		return -ENODEV;
+
 	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 	if (ret || !write)
-		goto out;
+		return ret;
 
 	if (watchdog_enabled && watchdog_thresh)
 		watchdog_enable_all_cpus();
 	else
 		watchdog_disable_all_cpus();
 
-out:
 	return ret;
 }
 #endif /* CONFIG_SYSCTL */
 
-
-/*
- * Create/destroy watchdog threads as CPUs come and go:
- */
-static int __cpuinit
-cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
-{
-	int hotcpu = (unsigned long)hcpu;
-
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		watchdog_prepare_cpu(hotcpu);
-		break;
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		if (watchdog_enabled)
-			watchdog_enable(hotcpu);
-		break;
-#ifdef CONFIG_HOTPLUG_CPU
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-		watchdog_disable(hotcpu);
-		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		watchdog_disable(hotcpu);
-		break;
-#endif /* CONFIG_HOTPLUG_CPU */
-	}
-
-	/*
-	 * hardlockup and softlockup are not important enough
-	 * to block cpu bring up.  Just always succeed and
-	 * rely on printk output to flag problems.
-	 */
-	return NOTIFY_OK;
-}
-
-static struct notifier_block __cpuinitdata cpu_nfb = {
-	.notifier_call = cpu_callback
+static struct smp_hotplug_thread watchdog_threads = {
+	.store			= &softlockup_watchdog,
+	.thread_should_run	= watchdog_should_run,
+	.thread_fn		= watchdog,
+	.thread_comm		= "watchdog/%u",
+	.setup			= watchdog_enable,
+	.park			= watchdog_disable,
+	.unpark			= watchdog_enable,
 };
 
 void __init lockup_detector_init(void)
 {
-	void *cpu = (void *)(long)smp_processor_id();
-	int err;
-
-	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
-	WARN_ON(notifier_to_errno(err));
-
-	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
-	register_cpu_notifier(&cpu_nfb);
-
-	return;
+	if (smpboot_register_percpu_thread(&watchdog_threads)) {
+		pr_err("Failed to create watchdog threads, disabled\n");
+		watchdog_disabled = -ENODEV;
+	}
 }


