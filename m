Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab2HMPNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 11:13:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60902 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2HMPN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 11:13:29 -0400
Date: Mon, 13 Aug 2012 08:13:05 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-bcd951cf10f24e341defcd002c15a1f4eea13ddb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, namhyung@kernel.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, namhyung@kernel.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20120716103948.563736676@linutronix.de>
References: <20120716103948.563736676@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] watchdog: Use hotplug thread infrastructure
Git-Commit-ID: bcd951cf10f24e341defcd002c15a1f4eea13ddb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 13 Aug 2012 08:13:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bcd951cf10f24e341defcd002c15a1f4eea13ddb
Gitweb:     http://git.kernel.org/tip/bcd951cf10f24e341defcd002c15a1f4eea13ddb
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 16 Jul 2012 10:42:38 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 13 Aug 2012 17:01:07 +0200

watchdog: Use hotplug thread infrastructure

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20120716103948.563736676@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/watchdog.c |  263 ++++++++++++++++++-----------------------------------
 1 files changed, 89 insertions(+), 174 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 4b1dfba..9d4c8d5 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
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
@@ -248,13 +251,15 @@ static void watchdog_overflow_callback(struct perf_event *event,
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
@@ -327,49 +332,68 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
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
 }
 
+static int watchdog_should_run(unsigned int cpu)
+{
+	return __this_cpu_read(hrtimer_interrupts) !=
+		__this_cpu_read(soft_lockup_hrtimer_cnt);
+}
+
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
 /*
@@ -379,7 +403,7 @@ static int watchdog(void *unused)
  */
 static unsigned long cpu0_err;
 
-static int watchdog_nmi_enable(int cpu)
+static int watchdog_nmi_enable(unsigned int cpu)
 {
 	struct perf_event_attr *wd_attr;
 	struct perf_event *event = per_cpu(watchdog_ev, cpu);
@@ -433,7 +457,7 @@ out:
 	return 0;
 }
 
-static void watchdog_nmi_disable(int cpu)
+static void watchdog_nmi_disable(unsigned int cpu)
 {
 	struct perf_event *event = per_cpu(watchdog_ev, cpu);
 
@@ -447,107 +471,35 @@ static void watchdog_nmi_disable(int cpu)
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
@@ -557,73 +509,36 @@ int proc_dowatchdog(struct ctl_table *table, int write,
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
