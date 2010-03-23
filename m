Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab0CWVep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 17:34:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab0CWVen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 17:34:43 -0400
Date: Tue, 23 Mar 2010 17:33:38 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu
Cc: peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100323213338.GA29170@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new nmi_watchdog (which uses the perf event subsystem) is very
similar in structure to the softlockup detector.  Using Ingo's suggestion,
I combined the two functionalities into one file, kernel/watchdog.c.

Now both the nmi_watchdog (or hardlockup detector) and softlockup detector
sit on top of the perf event subsystem, which is run every 60 seconds or so
to see if there are any lockups.

To detect hardlockups, cpus not responding to interrupts, I implemented an
hrtimer that runs 5 times for every perf event overflow event.  If that stops
counting on a cpu, then the cpu is most likely in trouble.

To detect softlockups, tasks not yielding to the scheduler, I used the
previous kthread idea that now gets kicked every time the hrtimer fires.
If the kthread isn't being scheduled neither is anyone else and the
warning is printed to the console.

I tested this on x86_64 and both the softlockup and hardlockup paths work.

This patch sits on top of my previous nmi_watchdog work (ingo/perf/nmi).

TODO:
- figure out how to make an arch-agnostic clock2cycles call (if possible)
  to feed into perf events as a sample period
- probably implement some missing procfs stuff

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/apic/hw_nmi.c |    2 +-
 include/linux/nmi.h           |    2 +-
 kernel/Makefile               |    2 +-
 kernel/sysctl.c               |    2 +-
 kernel/watchdog.c             |  526 +++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug             |   24 ++-
 6 files changed, 546 insertions(+), 12 deletions(-)
 create mode 100644 kernel/watchdog.c

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index e8b78a0..79425f9 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -89,7 +89,7 @@ int hw_nmi_is_cpu_stuck(struct pt_regs *regs)
 
 u64 hw_nmi_get_sample_period(void)
 {
-	return cpu_khz * 1000;
+	return (u64)(cpu_khz) * 1000 * 60;
 }
 
 #ifdef ARCH_HAS_NMI_WATCHDOG
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 22cc796..a501de9 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -54,7 +54,7 @@ static inline bool trigger_all_cpu_backtrace(void)
 #ifdef CONFIG_NMI_WATCHDOG
 int hw_nmi_is_cpu_stuck(struct pt_regs *);
 u64 hw_nmi_get_sample_period(void);
-extern int nmi_watchdog_enabled;
+extern int watchdog_enabled;
 struct ctl_table;
 extern int proc_nmi_enabled(struct ctl_table *, int ,
 			void __user *, size_t *, loff_t *);
diff --git a/kernel/Makefile b/kernel/Makefile
index 8a5abe5..c8e3e7c 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -76,7 +76,7 @@ obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
 obj-$(CONFIG_KGDB) += kgdb.o
 obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
-obj-$(CONFIG_NMI_WATCHDOG) += nmi_watchdog.o
+obj-$(CONFIG_NMI_WATCHDOG) += watchdog.o
 obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ac72c9e..6066e3d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -699,7 +699,7 @@ static struct ctl_table kern_table[] = {
 #if defined(CONFIG_NMI_WATCHDOG)
 	{
 		.procname       = "nmi_watchdog",
-		.data           = &nmi_watchdog_enabled,
+		.data           = &watchdog_enabled,
 		.maxlen         = sizeof (int),
 		.mode           = 0644,
 		.proc_handler   = proc_nmi_enabled,
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
new file mode 100644
index 0000000..7334565
--- /dev/null
+++ b/kernel/watchdog.c
@@ -0,0 +1,526 @@
+/*
+ * Detect Hard/Soft Lockups using the NMI
+ *
+ * started by Don Zickus, Copyright (C) 2010 Red Hat, Inc.
+ *
+ * this code detects hard lockups: incidents in where on a CPU
+ * the kernel does not respond to anything except NMI.
+ *
+ * Note: Most of this code is borrowed heavily from softlockup.c,
+ * so thanks to Ingo for the initial implementation.
+ * Some chunks also taken from arch/x86/kernel/apic/nmi.c, thanks
+ * to those contributors as well.
+ */
+
+#include <linux/mm.h>
+#include <linux/cpu.h>
+#include <linux/nmi.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/freezer.h>
+#include <linux/kthread.h>
+#include <linux/lockdep.h>
+#include <linux/notifier.h>
+#include <linux/module.h>
+#include <linux/sysctl.h>
+
+#include <asm/irq_regs.h>
+#include <linux/perf_event.h>
+
+int watchdog_enabled;
+int __read_mostly softlockup_thresh = 60;
+
+static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
+static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
+static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
+static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
+static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
+static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
+
+static int __read_mostly did_panic;
+static int __initdata no_watchdog;
+
+
+/* boot commands */
+/*
+ * Should we panic when a soft-lockup or hard-lockup occurs:
+ */
+static int hardlockup_panic;
+
+unsigned int __read_mostly softlockup_panic =
+			CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE;
+
+static int __init hardlockup_panic_setup(char *str)
+{
+	if (!strncmp(str, "panic", 5))
+		hardlockup_panic = 1;
+	return 1;
+}
+__setup("nmi_watchdog=", hardlockup_panic_setup);
+
+static int __init softlockup_panic_setup(char *str)
+{
+	softlockup_panic = simple_strtoul(str, NULL, 0);
+
+	return 1;
+}
+__setup("softlockup_panic=", softlockup_panic_setup);
+
+static int __init no_watchdog_setup(char *str)
+{
+	no_watchdog = 1;
+	return 1;
+}
+__setup("no_watchdog", no_watchdog_setup);
+
+/* deprecated */
+static int __init nosoftlockup_setup(char *str)
+{
+	no_watchdog = 1;
+	return 1;
+}
+__setup("nosoftlockup", nosoftlockup_setup);
+static int __init nonmi_watchdog_setup(char *str)
+{
+	no_watchdog = 1;
+	return 1;
+}
+__setup("nonmi_watchdog", nonmi_watchdog_setup);
+/*  */
+
+
+/*
+ * Returns seconds, approximately.  We don't need nanosecond
+ * resolution, and we don't need to waste time with a big divide when
+ * 2^30ns == 1.074s.
+ */
+static unsigned long get_timestamp(int this_cpu)
+{
+	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
+}
+
+static unsigned long get_sample_period(void)
+{
+	/*
+	 * convert softlockup_thresh from seconds to ns
+	 * the divide by 5 is to give hrtimer 5 chances to
+	 * increment before the hardlockup detector generates
+	 * a warning
+	 */
+	return softlockup_thresh / 5 * NSEC_PER_SEC;
+}
+
+/* Commands for resetting the watchdog */
+static void __touch_watchdog(void)
+{
+	int this_cpu = raw_smp_processor_id();
+
+	__raw_get_cpu_var(watchdog_touch_ts) = get_timestamp(this_cpu);
+}
+
+void touch_watchdog(void)
+{
+	__raw_get_cpu_var(watchdog_touch_ts) = 0;
+}
+EXPORT_SYMBOL(touch_watchdog);
+
+void touch_all_watchdog(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		per_cpu(watchdog_touch_ts, cpu) = 0;
+}
+
+void touch_nmi_watchdog(void)
+{
+	touch_watchdog();
+}
+EXPORT_SYMBOL(touch_nmi_watchdog);
+
+void touch_all_nmi_watchdog(void)
+{
+	touch_all_watchdog();
+}
+/* end of deprecated functions */
+
+/* watchdog detector functions */
+static int is_hardlockup(int cpu)
+{
+	unsigned long hrint = per_cpu(hrtimer_interrupts, cpu);
+
+	if (per_cpu(hrtimer_interrupts_saved, cpu) == hrint)
+		return 1;
+
+	per_cpu(hrtimer_interrupts_saved, cpu) = hrint;
+	return 0;
+}
+
+static int is_softlockup(unsigned long touch_ts, int cpu)
+{
+	unsigned long now = get_timestamp(cpu);
+
+	/* Warn about unreasonable delays: */
+	if (now > (touch_ts + softlockup_thresh)) {
+		return now - touch_ts;
+	}
+
+	return 0;
+}
+
+static int
+watchdog_panic(struct notifier_block *this, unsigned long event, void *ptr)
+{
+	did_panic = 1;
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block panic_block = {
+	.notifier_call = watchdog_panic,
+};
+
+struct perf_event_attr wd_hw_attr = {
+	.type		= PERF_TYPE_HARDWARE,
+	.config		= PERF_COUNT_HW_CPU_CYCLES,
+	.size		= sizeof(struct perf_event_attr),
+	.pinned		= 1,
+	.disabled	= 1,
+};
+
+struct perf_event_attr wd_sw_attr = {
+	.type		= PERF_TYPE_SOFTWARE,
+	.config		= PERF_COUNT_SW_CPU_CLOCK,
+	.size		= sizeof(struct perf_event_attr),
+	.pinned		= 1,
+	.disabled	= 1,
+};
+
+/* Callback function for perf event subsystem */
+void watchdog_overflow_callback(struct perf_event *event, int nmi,
+		 struct perf_sample_data *data,
+		 struct pt_regs *regs)
+{
+	int this_cpu = smp_processor_id();
+	unsigned long touch_ts = per_cpu(watchdog_touch_ts, this_cpu);
+	int duration;
+
+	if (touch_ts == 0) {
+		__touch_watchdog();
+		return;
+	}
+
+	/* check for a hardlockup
+	 * This is done by making sure our timer interrupt
+	 * is incrementing.  The timer interrupt should have
+	 * fired multiple times before we overflow'd.  If it hasn't
+	 * then this is a good indication the cpu is stuck
+	 */
+	if (is_hardlockup(this_cpu)) {
+		if (hardlockup_panic)
+			panic("Watchdog detected hard LOCKUP on cpu %d", this_cpu);
+		else
+			WARN(1, "Watchdog detected hard LOCKUP on cpu %d", this_cpu);
+	}
+
+	/* check for a softlockup
+	 * This is done by making sure a high priority task is
+	 * being scheduled.  The task touches the watchdog to
+	 * indicate it is getting cpu time.  If it hasn't then
+	 * this is a good indication some task is hogging the cpu
+	 */
+	duration = is_softlockup(touch_ts, this_cpu);
+	if (duration) {
+		printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
+			this_cpu, duration,
+			current->comm, task_pid_nr(current));
+		print_modules();
+		print_irqtrace_events(current);
+		if (regs)
+			show_regs(regs);
+		else
+			dump_stack();
+
+		if (softlockup_panic)
+			panic("softlockup: hung tasks");
+	}
+
+	return;
+}
+
+/* watchdog kicker functions */
+static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
+{
+	/* kick the hardlockup detector */
+	__get_cpu_var(hrtimer_interrupts)++;
+
+	/* kick the softlockup detector */
+	wake_up_process(__get_cpu_var(softlockup_watchdog));
+
+	/* .. and repeat */
+	hrtimer_forward_now(hrtimer, ns_to_ktime(get_sample_period()));
+
+	return HRTIMER_RESTART;
+}
+
+
+/*
+ * The watchdog thread - touches the timestamp.
+ */
+static int watchdog(void *__bind_cpu)
+{
+	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+	struct hrtimer *hrtimer = &per_cpu(watchdog_hrtimer, (unsigned long)__bind_cpu);
+
+	sched_setscheduler(current, SCHED_FIFO, &param);
+
+	/* initialize timestamp */
+	__touch_watchdog();
+
+	/* kick off the timer for the hardlockup detector */
+	/* done here because hrtimer_start can only pin to smp_processor_id() */
+	hrtimer_start(hrtimer, ns_to_ktime(get_sample_period()),
+		      HRTIMER_MODE_REL_PINNED);
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	/*
+	 * Run briefly once per second to reset the softlockup timestamp.
+	 * If this gets delayed for more than 60 seconds then the
+	 * debug-printout triggers in softlockup_tick().
+	 */
+	while (!kthread_should_stop()) {
+		__touch_watchdog();
+		schedule();
+
+		if (kthread_should_stop())
+			break;
+
+		set_current_state(TASK_INTERRUPTIBLE);
+	}
+	__set_current_state(TASK_RUNNING);
+
+	return 0;
+}
+
+
+/* prepare/enable/disable routines */
+static int watchdog_prepare_cpu(int cpu)
+{
+	struct hrtimer *hrtimer = &per_cpu(watchdog_hrtimer, cpu);
+	struct task_struct *p;
+
+	BUG_ON(per_cpu(softlockup_watchdog, cpu));
+	p = kthread_create(watchdog, (void *)(unsigned long)cpu, "watchdog/%d", cpu);
+	if (IS_ERR(p)) {
+		printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
+		return -1;
+	}
+	per_cpu(watchdog_touch_ts, cpu) = 0;
+	per_cpu(softlockup_watchdog, cpu) = p;
+	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer->function = watchdog_timer_fn;
+
+	return 0;
+}
+
+static int watchdog_enable(int cpu)
+{
+	struct perf_event_attr *wd_attr;
+	struct perf_event *event = per_cpu(watchdog_ev, cpu);
+	struct task_struct *p = per_cpu(softlockup_watchdog, cpu);
+
+	/* is it already setup and enabled? */
+	if (event && event->state > PERF_EVENT_STATE_OFF)
+		goto out;
+
+	/* it is setup but not enabled */
+	if (event != NULL)
+		goto out_enable;
+
+	/* Try to register using hardware perf events first */
+	wd_attr = &wd_hw_attr;
+	wd_attr->sample_period = hw_nmi_get_sample_period();
+	event = perf_event_create_kernel_counter(wd_attr, cpu, -1, watchdog_overflow_callback);
+	if (!IS_ERR(event)) {
+		printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
+		goto out_save;
+	}
+
+	/* hardware doesn't exist or not supported, fallback to software events */
+	printk(KERN_INFO "NMI watchdog: hardware not available, trying software events\n");
+	wd_attr = &wd_sw_attr;
+	wd_attr->sample_period = softlockup_thresh * NSEC_PER_SEC;
+	event = perf_event_create_kernel_counter(wd_attr, cpu, -1, watchdog_overflow_callback);
+	if (!IS_ERR(event)) {
+		printk(KERN_INFO "NMI watchdog enabled, takes one software counter.\n");
+		goto out_save;
+	}
+
+	printk(KERN_ERR "NMI watchdog failed to create perf event on cpu%i: %p\n", cpu, event);
+	return -1;
+
+	/* success path */
+out_save:
+	per_cpu(watchdog_ev, cpu) = event;
+out_enable:
+	perf_event_enable(per_cpu(watchdog_ev, cpu));
+out:
+	/* kick the softlockup thread */
+	if (p) {
+		kthread_bind(p, cpu);
+		wake_up_process(p);
+	}
+
+	/* if any cpu succeeds, watchdog is considered enabled for the system */
+	watchdog_enabled = 1;
+
+	return 0;
+}
+
+static void watchdog_disable(int cpu)
+{
+	struct perf_event *event = per_cpu(watchdog_ev, cpu);
+	struct task_struct *p = per_cpu(softlockup_watchdog, cpu);
+	struct hrtimer *hrtimer = &per_cpu(watchdog_hrtimer, cpu);
+
+	/*
+	 * cancel the timer first to stop incrementing the stats
+	 * and waking up the kthread
+	 */
+	hrtimer_cancel(hrtimer);
+
+	if (event) {
+		perf_event_disable(event);
+		per_cpu(watchdog_ev, cpu) = NULL;
+
+		/* should be in cleanup, but blocks oprofile */
+		perf_event_release_kernel(event);
+	}
+
+	if (p) {
+		kthread_bind(p, cpumask_any(cpu_online_mask));
+		kthread_stop(p);
+	}
+}
+
+static void watchdog_cleanup(int cpu)
+{
+	per_cpu(softlockup_watchdog, cpu) = NULL;
+}
+
+static void watchdog_enable_all_cpus(void)
+{
+	int cpu;
+	int result;
+
+	if (watchdog_enabled)
+		return;
+
+	for_each_online_cpu(cpu)
+		result += watchdog_enable(cpu);
+
+	if (result)
+		printk(KERN_ERR "watchdog: failed to be enabled on some cpus\n");
+
+}
+
+static void watchdog_disable_all_cpus(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		watchdog_disable(cpu);
+
+	/* if all watchdogs are disabled, then they are disabled for the system */
+	watchdog_enabled = 0;
+}
+
+
+/* sysctl functions */
+#ifdef CONFIG_SYSCTL
+/*
+ * proc handler for /proc/sys/kernel/nmi_watchdog
+ */
+
+int proc_nmi_enabled(struct ctl_table *table, int write,
+		     void __user *buffer, size_t *length, loff_t *ppos)
+{
+	touch_all_watchdog();
+	proc_dointvec(table, write, buffer, length, ppos);
+	if (watchdog_enabled)
+		watchdog_enable_all_cpus();
+	else
+		watchdog_disable_all_cpus();
+	return 0;
+}
+
+int proc_dowatchdog_thresh(struct ctl_table *table, int write,
+			     void __user *buffer,
+			     size_t *lenp, loff_t *ppos)
+{
+	touch_all_watchdog();
+	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+}
+
+#endif /* CONFIG_SYSCTL */
+
+
+/*
+ * Create/destroy watchdog threads as CPUs come and go:
+ */
+static int __cpuinit
+cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
+{
+	int hotcpu = (unsigned long)hcpu;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		if (watchdog_prepare_cpu(hotcpu))
+			return NOTIFY_BAD;
+		break;
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		if (watchdog_enable(hotcpu))
+			return NOTIFY_BAD;
+		break;
+#ifdef CONFIG_HOTPLUG_CPU
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+		watchdog_disable(hotcpu);
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		watchdog_disable(hotcpu);
+		watchdog_cleanup(hotcpu);
+		break;
+#endif /* CONFIG_HOTPLUG_CPU */
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata cpu_nfb = {
+	.notifier_call = cpu_callback
+};
+
+static int __init spawn_watchdog_task(void)
+{
+	void *cpu = (void *)(long)smp_processor_id();
+	int err;
+
+	if (no_watchdog)
+		return 0;
+
+	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
+	if (err == NOTIFY_BAD) {
+		BUG();
+		return 1;
+	}
+	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
+	register_cpu_notifier(&cpu_nfb);
+
+	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
+
+	return 0;
+}
+early_initcall(spawn_watchdog_task);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e2e73cc..518ec79 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -171,20 +171,28 @@ config DETECT_SOFTLOCKUP
 	   support it.)
 
 config NMI_WATCHDOG
-	bool "Detect Hard Lockups with an NMI Watchdog"
-	depends on DEBUG_KERNEL && PERF_EVENTS && PERF_EVENTS_NMI
+	bool "Detect Hard and Soft Lockups"
+	depends on DEBUG_KERNEL && PERF_EVENTS && PERF_EVENTS_NMI && !DETECT_SOFTLOCKUP
 	help
 	  Say Y here to enable the kernel to use the NMI as a watchdog
-	  to detect hard lockups.  This is useful when a cpu hangs for no
-	  reason but can still respond to NMIs.  A backtrace is displayed
-	  for reviewing and reporting.
+	  to detect hard and soft lockups.
 
-	  The overhead should be minimal, just an extra NMI every few
+	  Softlockups are bugs that cause the kernel to loop in kernel
+	  mode for more than 60 seconds, without giving other tasks a
+	  chance to run.  The current stack trace is displayed upon
+	  detection and the system will stay locked up.
+
+	  Hardlockups are bugs that cause the cpu to loop in kernel mode
+	  for more than 60 seconds, without letting other interrupts a
+	  chance to run.  The current stack trace is displayed upon detection
+	  and the system will stay locked up.
+
+	  The overhead should me minimal, just an extra NMI every few
 	  seconds.
 
 config BOOTPARAM_SOFTLOCKUP_PANIC
 	bool "Panic (Reboot) On Soft Lockups"
-	depends on DETECT_SOFTLOCKUP
+	depends on DETECT_SOFTLOCKUP || NMI_WATCHDOG
 	help
 	  Say Y here to enable the kernel to panic on "soft lockups",
 	  which are bugs that cause the kernel to loop in kernel
@@ -201,7 +209,7 @@ config BOOTPARAM_SOFTLOCKUP_PANIC
 
 config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 	int
-	depends on DETECT_SOFTLOCKUP
+	depends on DETECT_SOFTLOCKUP || NMI_WATCHDOG
 	range 0 1
 	default 0 if !BOOTPARAM_SOFTLOCKUP_PANIC
 	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
-- 
1.6.5.2

