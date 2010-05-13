Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab0EMGwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 02:52:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:56674 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709Ab0EMGwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 02:52:22 -0400
Date: Thu, 13 May 2010 06:51:50 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eparis@redhat.com, peterz@infradead.org, randy.dunlap@oracle.com,
       gorcunov@gmail.com, fweisbec@gmail.com, tglx@linutronix.de,
       dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eparis@redhat.com, peterz@infradead.org, gorcunov@gmail.com,
       randy.dunlap@oracle.com, fweisbec@gmail.com, tglx@linutronix.de,
       dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1273266711-18706-2-git-send-email-dzickus@redhat.com>
References: <1273266711-18706-2-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] lockup_detector: Combine nmi_watchdog and softlockup detector
Message-ID: <tip-58687acba59266735adb8ccd9b5b9aa2c7cd205b@git.kernel.org>
Git-Commit-ID: 58687acba59266735adb8ccd9b5b9aa2c7cd205b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 06:51:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58687acba59266735adb8ccd9b5b9aa2c7cd205b
Gitweb:     http://git.kernel.org/tip/58687acba59266735adb8ccd9b5b9aa2c7cd205b
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Fri, 7 May 2010 17:11:44 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 12 May 2010 23:55:33 +0200

lockup_detector: Combine nmi_watchdog and softlockup detector

The new nmi_watchdog (which uses the perf event subsystem) is very
similar in structure to the softlockup detector.  Using Ingo's
suggestion, I combined the two functionalities into one file:
kernel/watchdog.c.

Now both the nmi_watchdog (or hardlockup detector) and softlockup
detector sit on top of the perf event subsystem, which is run every
60 seconds or so to see if there are any lockups.

To detect hardlockups, cpus not responding to interrupts, I
implemented an hrtimer that runs 5 times for every perf event
overflow event.  If that stops counting on a cpu, then the cpu is
most likely in trouble.

To detect softlockups, tasks not yielding to the scheduler, I used the
previous kthread idea that now gets kicked every time the hrtimer fires.
If the kthread isn't being scheduled neither is anyone else and the
warning is printed to the console.

I tested this on x86_64 and both the softlockup and hardlockup paths
work.

V2:
- cleaned up the Kconfig and softlockup combination
- surrounded hardlockup cases with #ifdef CONFIG_PERF_EVENTS_NMI
- seperated out the softlockup case from perf event subsystem
- re-arranged the enabling/disabling nmi watchdog from proc space
- added cpumasks for hardlockup failure cases
- removed fallback to soft events if no PMU exists for hard events

V3:
- comment cleanups
- drop support for older softlockup code
- per_cpu cleanups
- completely remove software clock base hardlockup detector
- use per_cpu masking on hard/soft lockup detection
- #ifdef cleanups
- rename config option NMI_WATCHDOG to LOCKUP_DETECTOR
- documentation additions

V4:
- documentation fixes
- convert per_cpu to __get_cpu_var
- powerpc compile fixes

V5:
- split apart warn flags for hard and soft lockups

TODO:
- figure out how to make an arch-agnostic clock2cycles call
  (if possible) to feed into perf events as a sample period

[fweisbec: merged conflict patch]

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
LKML-Reference: <1273266711-18706-2-git-send-email-dzickus@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 Documentation/kernel-parameters.txt |    2 +
 arch/x86/include/asm/nmi.h          |    2 +-
 arch/x86/kernel/apic/Makefile       |    4 +-
 arch/x86/kernel/apic/hw_nmi.c       |    2 +-
 arch/x86/kernel/traps.c             |    4 +-
 include/linux/nmi.h                 |    8 +-
 include/linux/sched.h               |    6 +
 init/Kconfig                        |    5 +-
 kernel/Makefile                     |    3 +-
 kernel/sysctl.c                     |   21 +-
 kernel/watchdog.c                   |  592 +++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug                   |   30 ++-
 12 files changed, 650 insertions(+), 29 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 839b21b..dfe8d1c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1777,6 +1777,8 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	nousb		[USB] Disable the USB subsystem
 
+	nowatchdog	[KNL] Disable the lockup detector.
+
 	nowb		[ARM]
 
 	nox2apic	[X86-64,APIC] Do not enable x2APIC mode.
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 5b41b0f..932f0f8 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -17,7 +17,7 @@ int do_nmi_callback(struct pt_regs *regs, int cpu);
 
 extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int check_nmi_watchdog(void);
-#if !defined(CONFIG_NMI_WATCHDOG)
+#if !defined(CONFIG_LOCKUP_DETECTOR)
 extern int nmi_watchdog_enabled;
 #endif
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index 1a4512e..52f32e0 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -3,10 +3,10 @@
 #
 
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o probe_$(BITS).o ipi.o
-ifneq ($(CONFIG_NMI_WATCHDOG),y)
+ifneq ($(CONFIG_LOCKUP_DETECTOR),y)
 obj-$(CONFIG_X86_LOCAL_APIC)	+= nmi.o
 endif
-obj-$(CONFIG_NMI_WATCHDOG)	+= hw_nmi.o
+obj-$(CONFIG_LOCKUP_DETECTOR)	+= hw_nmi.o
 
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_SMP)		+= ipi.o
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
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index bdc7fab..bd347c2 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -406,7 +406,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 							== NOTIFY_STOP)
 			return;
 
-#ifndef CONFIG_NMI_WATCHDOG
+#ifndef CONFIG_LOCKUP_DETECTOR
 		/*
 		 * Ok, so this is none of the documented NMI sources,
 		 * so it must be the NMI watchdog.
@@ -414,7 +414,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		if (nmi_watchdog_tick(regs, reason))
 			return;
 		if (!do_nmi_callback(regs, cpu))
-#endif /* !CONFIG_NMI_WATCHDOG */
+#endif /* !CONFIG_LOCKUP_DETECTOR */
 			unknown_nmi_error(reason, regs);
 #else
 		unknown_nmi_error(reason, regs);
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 22cc796..abd48aa 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -20,7 +20,7 @@ extern void touch_nmi_watchdog(void);
 extern void acpi_nmi_disable(void);
 extern void acpi_nmi_enable(void);
 #else
-#ifndef CONFIG_NMI_WATCHDOG
+#ifndef CONFIG_LOCKUP_DETECTOR
 static inline void touch_nmi_watchdog(void)
 {
 	touch_softlockup_watchdog();
@@ -51,12 +51,12 @@ static inline bool trigger_all_cpu_backtrace(void)
 }
 #endif
 
-#ifdef CONFIG_NMI_WATCHDOG
+#ifdef CONFIG_LOCKUP_DETECTOR
 int hw_nmi_is_cpu_stuck(struct pt_regs *);
 u64 hw_nmi_get_sample_period(void);
-extern int nmi_watchdog_enabled;
+extern int watchdog_enabled;
 struct ctl_table;
-extern int proc_nmi_enabled(struct ctl_table *, int ,
+extern int proc_dowatchdog_enabled(struct ctl_table *, int ,
 			void __user *, size_t *, loff_t *);
 #endif
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index dad7f66..37efe8f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -346,6 +346,12 @@ extern int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
 					 size_t *lenp, loff_t *ppos);
 #endif
 
+#ifdef CONFIG_LOCKUP_DETECTOR
+extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
+				  void __user *buffer,
+				  size_t *lenp, loff_t *ppos);
+#endif
+
 /* Attach to any functions which should be ignored in wchan output. */
 #define __sched		__attribute__((__section__(".sched.text")))
 
diff --git a/init/Kconfig b/init/Kconfig
index c6c8903..e44e254 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -944,8 +944,11 @@ config PERF_USE_VMALLOC
 
 config PERF_EVENTS_NMI
 	bool
+	depends on PERF_EVENTS
 	help
-	  Arch has support for nmi_watchdog
+	  System hardware can generate an NMI using the perf event
+	  subsystem.  Also has support for calculating CPU cycle events
+	  to determine how many clock cycles in a given period.
 
 menu "Kernel Performance Events And Counters"
 
diff --git a/kernel/Makefile b/kernel/Makefile
index d5c3006..6adeafc 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -76,9 +76,8 @@ obj-$(CONFIG_GCOV_KERNEL) += gcov/
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
 obj-$(CONFIG_KGDB) += kgdb.o
-obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
-obj-$(CONFIG_NMI_WATCHDOG) += nmi_watchdog.o
 obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
+obj-$(CONFIG_LOCKUP_DETECTOR) += watchdog.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index a38af43..0f9adda 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -74,7 +74,7 @@
 #include <scsi/sg.h>
 #endif
 
-#ifdef CONFIG_NMI_WATCHDOG
+#ifdef CONFIG_LOCKUP_DETECTOR
 #include <linux/nmi.h>
 #endif
 
@@ -686,16 +686,25 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
 	},
-#if defined(CONFIG_NMI_WATCHDOG)
+#if defined(CONFIG_LOCKUP_DETECTOR)
 	{
-		.procname       = "nmi_watchdog",
-		.data           = &nmi_watchdog_enabled,
+		.procname       = "watchdog",
+		.data           = &watchdog_enabled,
 		.maxlen         = sizeof (int),
 		.mode           = 0644,
-		.proc_handler   = proc_nmi_enabled,
+		.proc_handler   = proc_dowatchdog_enabled,
+	},
+	{
+		.procname	= "watchdog_thresh",
+		.data		= &softlockup_thresh,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dowatchdog_thresh,
+		.extra1		= &neg_one,
+		.extra2		= &sixty,
 	},
 #endif
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86) && !defined(CONFIG_NMI_WATCHDOG)
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86) && !defined(CONFIG_LOCKUP_DETECTOR)
 	{
 		.procname       = "unknown_nmi_panic",
 		.data           = &unknown_nmi_panic,
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
new file mode 100644
index 0000000..6b7fad8
--- /dev/null
+++ b/kernel/watchdog.c
@@ -0,0 +1,592 @@
+/*
+ * Detect hard and soft lockups on a system
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
+static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
+static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
+static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
+static DEFINE_PER_CPU(bool, softlockup_touch_sync);
+static DEFINE_PER_CPU(bool, hard_watchdog_warn);
+static DEFINE_PER_CPU(bool, soft_watchdog_warn);
+#ifdef CONFIG_PERF_EVENTS_NMI
+static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
+static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
+static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
+#endif
+
+static int __read_mostly did_panic;
+static int __initdata no_watchdog;
+
+
+/* boot commands */
+/*
+ * Should we panic when a soft-lockup or hard-lockup occurs:
+ */
+#ifdef CONFIG_PERF_EVENTS_NMI
+static int hardlockup_panic;
+
+static int __init hardlockup_panic_setup(char *str)
+{
+	if (!strncmp(str, "panic", 5))
+		hardlockup_panic = 1;
+	return 1;
+}
+__setup("nmi_watchdog=", hardlockup_panic_setup);
+#endif
+
+unsigned int __read_mostly softlockup_panic =
+			CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE;
+
+static int __init softlockup_panic_setup(char *str)
+{
+	softlockup_panic = simple_strtoul(str, NULL, 0);
+
+	return 1;
+}
+__setup("softlockup_panic=", softlockup_panic_setup);
+
+static int __init nowatchdog_setup(char *str)
+{
+	no_watchdog = 1;
+	return 1;
+}
+__setup("nowatchdog", nowatchdog_setup);
+
+/* deprecated */
+static int __init nosoftlockup_setup(char *str)
+{
+	no_watchdog = 1;
+	return 1;
+}
+__setup("nosoftlockup", nosoftlockup_setup);
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
+	__get_cpu_var(watchdog_touch_ts) = get_timestamp(this_cpu);
+}
+
+void touch_watchdog(void)
+{
+	__get_cpu_var(watchdog_touch_ts) = 0;
+}
+EXPORT_SYMBOL(touch_watchdog);
+
+void touch_all_watchdog(void)
+{
+	int cpu;
+
+	/*
+	 * this is done lockless
+	 * do we care if a 0 races with a timestamp?
+	 * all it means is the softlock check starts one cycle later
+	 */
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
+
+void touch_softlockup_watchdog(void)
+{
+	touch_watchdog();
+}
+
+void touch_all_softlockup_watchdogs(void)
+{
+	touch_all_watchdog();
+}
+
+void touch_softlockup_watchdog_sync(void)
+{
+	__raw_get_cpu_var(softlockup_touch_sync) = true;
+	__raw_get_cpu_var(watchdog_touch_ts) = 0;
+}
+
+void softlockup_tick(void)
+{
+}
+
+#ifdef CONFIG_PERF_EVENTS_NMI
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
+#endif
+
+static int is_softlockup(unsigned long touch_ts, int cpu)
+{
+	unsigned long now = get_timestamp(cpu);
+
+	/* Warn about unreasonable delays: */
+	if (time_after(now, touch_ts + softlockup_thresh))
+		return now - touch_ts;
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
+#ifdef CONFIG_PERF_EVENTS_NMI
+static struct perf_event_attr wd_hw_attr = {
+	.type		= PERF_TYPE_HARDWARE,
+	.config		= PERF_COUNT_HW_CPU_CYCLES,
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
+		/* only print hardlockups once */
+		if (__get_cpu_var(hard_watchdog_warn) == true)
+			return;
+
+		if (hardlockup_panic)
+			panic("Watchdog detected hard LOCKUP on cpu %d", this_cpu);
+		else
+			WARN(1, "Watchdog detected hard LOCKUP on cpu %d", this_cpu);
+
+		__get_cpu_var(hard_watchdog_warn) = true;
+		return;
+	}
+
+	__get_cpu_var(hard_watchdog_warn) = false;
+	return;
+}
+static void watchdog_interrupt_count(void)
+{
+	__get_cpu_var(hrtimer_interrupts)++;
+}
+#else
+static inline void watchdog_interrupt_count(void) { return; }
+#endif /* CONFIG_PERF_EVENTS_NMI */
+
+/* watchdog kicker functions */
+static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
+{
+	int this_cpu = smp_processor_id();
+	unsigned long touch_ts = __get_cpu_var(watchdog_touch_ts);
+	struct pt_regs *regs = get_irq_regs();
+	int duration;
+
+	/* kick the hardlockup detector */
+	watchdog_interrupt_count();
+
+	/* kick the softlockup detector */
+	wake_up_process(__get_cpu_var(softlockup_watchdog));
+
+	/* .. and repeat */
+	hrtimer_forward_now(hrtimer, ns_to_ktime(get_sample_period()));
+
+	if (touch_ts == 0) {
+		if (unlikely(per_cpu(softlockup_touch_sync, this_cpu))) {
+			/*
+			 * If the time stamp was touched atomically
+			 * make sure the scheduler tick is up to date.
+			 */
+			per_cpu(softlockup_touch_sync, this_cpu) = false;
+			sched_clock_tick();
+		}
+		__touch_watchdog();
+		return HRTIMER_RESTART;
+	}
+
+	/* check for a softlockup
+	 * This is done by making sure a high priority task is
+	 * being scheduled.  The task touches the watchdog to
+	 * indicate it is getting cpu time.  If it hasn't then
+	 * this is a good indication some task is hogging the cpu
+	 */
+	duration = is_softlockup(touch_ts, this_cpu);
+	if (unlikely(duration)) {
+		/* only warn once */
+		if (__get_cpu_var(soft_watchdog_warn) == true)
+			return HRTIMER_RESTART;
+
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
+		__get_cpu_var(soft_watchdog_warn) = true;
+	} else
+		__get_cpu_var(soft_watchdog_warn) = false;
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
+#ifdef CONFIG_PERF_EVENTS_NMI
+static int watchdog_nmi_enable(int cpu)
+{
+	struct perf_event_attr *wd_attr;
+	struct perf_event *event = per_cpu(watchdog_ev, cpu);
+
+	/* is it already setup and enabled? */
+	if (event && event->state > PERF_EVENT_STATE_OFF)
+		goto out;
+
+	/* it is setup but not enabled */
+	if (event != NULL)
+		goto out_enable;
+
+	/* Try to register using hardware perf events */
+	wd_attr = &wd_hw_attr;
+	wd_attr->sample_period = hw_nmi_get_sample_period();
+	event = perf_event_create_kernel_counter(wd_attr, cpu, -1, watchdog_overflow_callback);
+	if (!IS_ERR(event)) {
+		printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
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
+	return 0;
+}
+
+static void watchdog_nmi_disable(int cpu)
+{
+	struct perf_event *event = per_cpu(watchdog_ev, cpu);
+
+	if (event) {
+		perf_event_disable(event);
+		per_cpu(watchdog_ev, cpu) = NULL;
+
+		/* should be in cleanup, but blocks oprofile */
+		perf_event_release_kernel(event);
+	}
+	return;
+}
+#else
+static int watchdog_nmi_enable(int cpu) { return 0; }
+static void watchdog_nmi_disable(int cpu) { return; }
+#endif /* CONFIG_PERF_EVENTS_NMI */
+
+/* prepare/enable/disable routines */
+static int watchdog_prepare_cpu(int cpu)
+{
+	struct hrtimer *hrtimer = &per_cpu(watchdog_hrtimer, cpu);
+
+	WARN_ON(per_cpu(softlockup_watchdog, cpu));
+	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer->function = watchdog_timer_fn;
+
+	return 0;
+}
+
+static int watchdog_enable(int cpu)
+{
+	struct task_struct *p = per_cpu(softlockup_watchdog, cpu);
+
+	/* enable the perf event */
+	if (watchdog_nmi_enable(cpu) != 0)
+		return -1;
+
+	/* create the watchdog thread */
+	if (!p) {
+		p = kthread_create(watchdog, (void *)(unsigned long)cpu, "watchdog/%d", cpu);
+		if (IS_ERR(p)) {
+			printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
+			return -1;
+		}
+		kthread_bind(p, cpu);
+		per_cpu(watchdog_touch_ts, cpu) = 0;
+		per_cpu(softlockup_watchdog, cpu) = p;
+		wake_up_process(p);
+	}
+
+	return 0;
+}
+
+static void watchdog_disable(int cpu)
+{
+	struct task_struct *p = per_cpu(softlockup_watchdog, cpu);
+	struct hrtimer *hrtimer = &per_cpu(watchdog_hrtimer, cpu);
+
+	/*
+	 * cancel the timer first to stop incrementing the stats
+	 * and waking up the kthread
+	 */
+	hrtimer_cancel(hrtimer);
+
+	/* disable the perf event */
+	watchdog_nmi_disable(cpu);
+
+	/* stop the watchdog thread */
+	if (p) {
+		per_cpu(softlockup_watchdog, cpu) = NULL;
+		kthread_stop(p);
+	}
+
+	/* if any cpu succeeds, watchdog is considered enabled for the system */
+	watchdog_enabled = 1;
+}
+
+static void watchdog_enable_all_cpus(void)
+{
+	int cpu;
+	int result;
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
+int proc_dowatchdog_enabled(struct ctl_table *table, int write,
+		     void __user *buffer, size_t *length, loff_t *ppos)
+{
+	proc_dointvec(table, write, buffer, length, ppos);
+
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
+	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+}
+
+/* stub functions */
+int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
+			     void __user *buffer,
+			     size_t *lenp, loff_t *ppos)
+{
+	return proc_dowatchdog_thresh(table, write, buffer, lenp, ppos);
+}
+/* end of stub functions */
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
+	WARN_ON(err == NOTIFY_BAD);
+
+	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
+	register_cpu_notifier(&cpu_nfb);
+
+	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
+
+	return 0;
+}
+early_initcall(spawn_watchdog_task);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 220ae60..49e285d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -153,7 +153,7 @@ config DEBUG_SHIRQ
 	  points; some don't and need to be caught.
 
 config DETECT_SOFTLOCKUP
-	bool "Detect Soft Lockups"
+	bool
 	depends on DEBUG_KERNEL && !S390
 	default y
 	help
@@ -171,17 +171,27 @@ config DETECT_SOFTLOCKUP
 	   can be detected via the NMI-watchdog, on platforms that
 	   support it.)
 
-config NMI_WATCHDOG
-	bool "Detect Hard Lockups with an NMI Watchdog"
-	depends on DEBUG_KERNEL && PERF_EVENTS && PERF_EVENTS_NMI
+config LOCKUP_DETECTOR
+	bool "Detect Hard and Soft Lockups"
+	depends on DEBUG_KERNEL
+	default DETECT_SOFTLOCKUP
 	help
-	  Say Y here to enable the kernel to use the NMI as a watchdog
-	  to detect hard lockups.  This is useful when a cpu hangs for no
-	  reason but can still respond to NMIs.  A backtrace is displayed
-	  for reviewing and reporting.
+	  Say Y here to enable the kernel to act as a watchdog to detect
+	  hard and soft lockups.
+
+	  Softlockups are bugs that cause the kernel to loop in kernel
+	  mode for more than 60 seconds, without giving other tasks a
+	  chance to run.  The current stack trace is displayed upon
+	  detection and the system will stay locked up.
+
+	  Hardlockups are bugs that cause the CPU to loop in kernel mode
+	  for more than 60 seconds, without letting other interrupts have a
+	  chance to run.  The current stack trace is displayed upon detection
+	  and the system will stay locked up.
 
-	  The overhead should be minimal, just an extra NMI every few
-	  seconds.
+	  The overhead should be minimal.  A periodic hrtimer runs to
+	  generate interrupts and kick the watchdog task every 10-12 seconds.
+	  An NMI is generated every 60 seconds or so to check for hardlockups.
 
 config BOOTPARAM_SOFTLOCKUP_PANIC
 	bool "Panic (Reboot) On Soft Lockups"
