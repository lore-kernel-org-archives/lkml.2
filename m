Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab0EXTD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 15:03:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37025 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979Ab0EXTDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 15:03:25 -0400
Date: Mon, 24 May 2010 21:02:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] Unified lockup detector
Message-ID: <20100524190258.GA12408@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the lockup-detector-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git lockup-detector-for-linus

This tree unifies the various lockup detection facilities 
(kernel/softlockup.c for hung tasks and hung kernels, and 
arch/x86/../nmi_watchdog.c for hard lockups) into a single 
entity: kernel/watchdog.c.

There's a single .config variable controlling this 
functionality:

  Detect Hard and Soft Lockups (LOCKUP_DETECTOR) [N/y/?] (NEW) 

Defaulting to off.

We thought to keep it simple to users - under X there's 
little sign to the user whether a particular lockup is a 
hard or soft one.

The lockup detector uses NMI perf events to detect hard 
lockups, and is thus both more compatible with perf events 
(they were exclusive to each other before these changes), 
and also more portable to other architectures.

 Thanks,

	Ingo

------------------>
Don Zickus (19):
      x86: Move notify_die from nmi.c to traps.c
      nmi_watchdog: Add new, generic implementation, using perf events
      nmi_watchdog: Config option to enable new nmi_watchdog
      nmi_watchdog: Use a boolean config flag for compiling
      nmi_watchdog: Compile and portability fixes
      nmi_watchdog: Fallback to software events when no hardware pmu detected
      nmi_watchdog: support for oprofile
      nmi_watchdog: Properly configure for software events
      nmi_watchdog: Fix undefined 'apic' build bug
      nmi_watchdog: Clean up various small details
      lockup_detector: Combine nmi_watchdog and softlockup detector
      lockup_detector: Touch_softlockup cleanups and softlockup_tick removal
      lockup_detector: Remove old softlockup code
      lockup_detector: Remove nmi_watchdog.c file
      x86: Move trigger_all_cpu_backtrace to its own die_notifier
      x86: Cleanup hw_nmi.c cruft
      lockup_detector: Separate touch_nmi_watchdog code path from touch_watchdog
      lockup_detector: Cross arch compile fixes
      lockup_detector: Convert per_cpu to __get_cpu_var for readability

Frederic Weisbecker (6):
      lockup_detector: Make BOOTPARAM_SOFTLOCKUP_PANIC depend on LOCKUP_DETECTOR
      lockup_detector: Fix forgotten config conversion
      lockup_detector: Update some config
      lockup_detector: Adapt CONFIG_PERF_EVENT_NMI to other archs
      lockup_detector: Introduce CONFIG_HARDLOCKUP_DETECTOR
      lockup_detector: Don't enable the lockup detector by default

Ingo Molnar (4):
      nmi_watchdog: Only enable on x86 for now
      nmi_watchdog: Turn it off by default
      watchdog: Export touch_softlockup_watchdog
      x86, watchdog: Fix build error in hw_nmi.c

Peter Zijlstra (1):
      nmi_watchdog: Tell the world we're active


 Documentation/kernel-parameters.txt |    2 +
 arch/Kconfig                        |    7 +
 arch/x86/Kconfig                    |    1 +
 arch/x86/include/asm/nmi.h          |    2 +
 arch/x86/kernel/apic/Makefile       |    7 +-
 arch/x86/kernel/apic/hw_nmi.c       |  107 +++++++
 arch/x86/kernel/apic/nmi.c          |    7 -
 arch/x86/kernel/traps.c             |    7 +
 include/linux/nmi.h                 |   13 +
 include/linux/sched.h               |   12 +-
 kernel/Makefile                     |    2 +-
 kernel/softlockup.c                 |  293 ------------------
 kernel/sysctl.c                     |   55 ++--
 kernel/timer.c                      |    1 -
 kernel/watchdog.c                   |  567 +++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug                   |   35 ++-
 16 files changed, 770 insertions(+), 348 deletions(-)
 create mode 100644 arch/x86/kernel/apic/hw_nmi.c
 delete mode 100644 kernel/softlockup.c
 create mode 100644 kernel/watchdog.c

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
diff --git a/arch/Kconfig b/arch/Kconfig
index e5eb133..35084f2 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -145,4 +145,11 @@ config HAVE_HW_BREAKPOINT
 config HAVE_USER_RETURN_NOTIFIER
 	bool
 
+config HAVE_PERF_EVENTS_NMI
+	bool
+	help
+	  System hardware can generate an NMI using the perf event
+	  subsystem.  Also has support for calculating CPU cycle events
+	  to determine how many clock cycles in a given period.
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9458685..3cb5bb0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -54,6 +54,7 @@ config X86
 	select HAVE_KERNEL_LZO
 	select HAVE_HW_BREAKPOINT
 	select PERF_EVENTS
+	select HAVE_PERF_EVENTS_NMI
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 93da9c3..932f0f8 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -17,7 +17,9 @@ int do_nmi_callback(struct pt_regs *regs, int cpu);
 
 extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int check_nmi_watchdog(void);
+#if !defined(CONFIG_LOCKUP_DETECTOR)
 extern int nmi_watchdog_enabled;
+#endif
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
 extern int reserve_perfctr_nmi(unsigned int);
 extern void release_perfctr_nmi(unsigned int);
diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index 565c1bf..910f20b 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -2,7 +2,12 @@
 # Makefile for local APIC drivers and for the IO-APIC code
 #
 
-obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o probe_$(BITS).o ipi.o nmi.o
+obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o probe_$(BITS).o ipi.o
+ifneq ($(CONFIG_HARDLOCKUP_DETECTOR),y)
+obj-$(CONFIG_X86_LOCAL_APIC)	+= nmi.o
+endif
+obj-$(CONFIG_HARDLOCKUP_DETECTOR)	+= hw_nmi.o
+
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_SMP)		+= ipi.o
 
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
new file mode 100644
index 0000000..cefd694
--- /dev/null
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -0,0 +1,107 @@
+/*
+ *  HW NMI watchdog support
+ *
+ *  started by Don Zickus, Copyright (C) 2010 Red Hat, Inc.
+ *
+ *  Arch specific calls to support NMI watchdog
+ *
+ *  Bits copied from original nmi.c file
+ *
+ */
+#include <asm/apic.h>
+
+#include <linux/cpumask.h>
+#include <linux/kdebug.h>
+#include <linux/notifier.h>
+#include <linux/kprobes.h>
+#include <linux/nmi.h>
+#include <linux/module.h>
+
+/* For reliability, we're prepared to waste bits here. */
+static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
+
+u64 hw_nmi_get_sample_period(void)
+{
+	return (u64)(cpu_khz) * 1000 * 60;
+}
+
+#ifdef ARCH_HAS_NMI_WATCHDOG
+void arch_trigger_all_cpu_backtrace(void)
+{
+	int i;
+
+	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
+
+	printk(KERN_INFO "sending NMI to all CPUs:\n");
+	apic->send_IPI_all(NMI_VECTOR);
+
+	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
+	for (i = 0; i < 10 * 1000; i++) {
+		if (cpumask_empty(to_cpumask(backtrace_mask)))
+			break;
+		mdelay(1);
+	}
+}
+
+static int __kprobes
+arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
+			 unsigned long cmd, void *__args)
+{
+	struct die_args *args = __args;
+	struct pt_regs *regs;
+	int cpu = smp_processor_id();
+
+	switch (cmd) {
+	case DIE_NMI:
+	case DIE_NMI_IPI:
+		break;
+
+	default:
+		return NOTIFY_DONE;
+	}
+
+	regs = args->regs;
+
+	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
+		static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
+
+		arch_spin_lock(&lock);
+		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
+		show_regs(regs);
+		dump_stack();
+		arch_spin_unlock(&lock);
+		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
+		return NOTIFY_STOP;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static __read_mostly struct notifier_block backtrace_notifier = {
+	.notifier_call          = arch_trigger_all_cpu_backtrace_handler,
+	.next                   = NULL,
+	.priority               = 1
+};
+
+static int __init register_trigger_all_cpu_backtrace(void)
+{
+	register_die_notifier(&backtrace_notifier);
+	return 0;
+}
+early_initcall(register_trigger_all_cpu_backtrace);
+#endif
+
+/* STUB calls to mimic old nmi_watchdog behaviour */
+#if defined(CONFIG_X86_LOCAL_APIC)
+unsigned int nmi_watchdog = NMI_NONE;
+EXPORT_SYMBOL(nmi_watchdog);
+void acpi_nmi_enable(void) { return; }
+void acpi_nmi_disable(void) { return; }
+#endif
+atomic_t nmi_active = ATOMIC_INIT(0);           /* oprofile uses this */
+EXPORT_SYMBOL(nmi_active);
+int unknown_nmi_panic;
+void cpu_nmi_set_wd_enabled(void) { return; }
+void stop_apic_nmi_watchdog(void *unused) { return; }
+void setup_apic_nmi_watchdog(void *unused) { return; }
+int __init check_nmi_watchdog(void) { return 0; }
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index 1edaf15..a43f71c 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -401,13 +401,6 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 	int cpu = smp_processor_id();
 	int rc = 0;
 
-	/* check for other users first */
-	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
-			== NOTIFY_STOP) {
-		rc = 1;
-		touched = 1;
-	}
-
 	sum = get_timer_irqs(cpu);
 
 	if (__get_cpu_var(nmi_touch)) {
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 1168e44..bd347c2 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -400,7 +400,13 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
 								== NOTIFY_STOP)
 			return;
+
 #ifdef CONFIG_X86_LOCAL_APIC
+		if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
+							== NOTIFY_STOP)
+			return;
+
+#ifndef CONFIG_LOCKUP_DETECTOR
 		/*
 		 * Ok, so this is none of the documented NMI sources,
 		 * so it must be the NMI watchdog.
@@ -408,6 +414,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		if (nmi_watchdog_tick(regs, reason))
 			return;
 		if (!do_nmi_callback(regs, cpu))
+#endif /* !CONFIG_LOCKUP_DETECTOR */
 			unknown_nmi_error(reason, regs);
 #else
 		unknown_nmi_error(reason, regs);
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index b752e80..06aab5e 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -20,10 +20,14 @@ extern void touch_nmi_watchdog(void);
 extern void acpi_nmi_disable(void);
 extern void acpi_nmi_enable(void);
 #else
+#ifndef CONFIG_HARDLOCKUP_DETECTOR
 static inline void touch_nmi_watchdog(void)
 {
 	touch_softlockup_watchdog();
 }
+#else
+extern void touch_nmi_watchdog(void);
+#endif
 static inline void acpi_nmi_disable(void) { }
 static inline void acpi_nmi_enable(void) { }
 #endif
@@ -47,4 +51,13 @@ static inline bool trigger_all_cpu_backtrace(void)
 }
 #endif
 
+#ifdef CONFIG_LOCKUP_DETECTOR
+int hw_nmi_is_cpu_stuck(struct pt_regs *);
+u64 hw_nmi_get_sample_period(void);
+extern int watchdog_enabled;
+struct ctl_table;
+extern int proc_dowatchdog_enabled(struct ctl_table *, int ,
+			void __user *, size_t *, loff_t *);
+#endif
+
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index dad7f66..3958e0c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -311,20 +311,16 @@ extern void scheduler_tick(void);
 
 extern void sched_show_task(struct task_struct *p);
 
-#ifdef CONFIG_DETECT_SOFTLOCKUP
-extern void softlockup_tick(void);
+#ifdef CONFIG_LOCKUP_DETECTOR
 extern void touch_softlockup_watchdog(void);
 extern void touch_softlockup_watchdog_sync(void);
 extern void touch_all_softlockup_watchdogs(void);
-extern int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
-				    void __user *buffer,
-				    size_t *lenp, loff_t *ppos);
+extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
+				  void __user *buffer,
+				  size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
 extern int softlockup_thresh;
 #else
-static inline void softlockup_tick(void)
-{
-}
 static inline void touch_softlockup_watchdog(void)
 {
 }
diff --git a/kernel/Makefile b/kernel/Makefile
index a987aa1..6adeafc 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -76,8 +76,8 @@ obj-$(CONFIG_GCOV_KERNEL) += gcov/
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
 obj-$(CONFIG_KGDB) += kgdb.o
-obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
 obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
+obj-$(CONFIG_LOCKUP_DETECTOR) += watchdog.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
deleted file mode 100644
index 4b493f6..0000000
--- a/kernel/softlockup.c
+++ /dev/null
@@ -1,293 +0,0 @@
-/*
- * Detect Soft Lockups
- *
- * started by Ingo Molnar, Copyright (C) 2005, 2006 Red Hat, Inc.
- *
- * this code detects soft lockups: incidents in where on a CPU
- * the kernel does not reschedule for 10 seconds or more.
- */
-#include <linux/mm.h>
-#include <linux/cpu.h>
-#include <linux/nmi.h>
-#include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/freezer.h>
-#include <linux/kthread.h>
-#include <linux/lockdep.h>
-#include <linux/notifier.h>
-#include <linux/module.h>
-#include <linux/sysctl.h>
-
-#include <asm/irq_regs.h>
-
-static DEFINE_SPINLOCK(print_lock);
-
-static DEFINE_PER_CPU(unsigned long, softlockup_touch_ts); /* touch timestamp */
-static DEFINE_PER_CPU(unsigned long, softlockup_print_ts); /* print timestamp */
-static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
-static DEFINE_PER_CPU(bool, softlock_touch_sync);
-
-static int __read_mostly did_panic;
-int __read_mostly softlockup_thresh = 60;
-
-/*
- * Should we panic (and reboot, if panic_timeout= is set) when a
- * soft-lockup occurs:
- */
-unsigned int __read_mostly softlockup_panic =
-				CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE;
-
-static int __init softlockup_panic_setup(char *str)
-{
-	softlockup_panic = simple_strtoul(str, NULL, 0);
-
-	return 1;
-}
-__setup("softlockup_panic=", softlockup_panic_setup);
-
-static int
-softlock_panic(struct notifier_block *this, unsigned long event, void *ptr)
-{
-	did_panic = 1;
-
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block panic_block = {
-	.notifier_call = softlock_panic,
-};
-
-/*
- * Returns seconds, approximately.  We don't need nanosecond
- * resolution, and we don't need to waste time with a big divide when
- * 2^30ns == 1.074s.
- */
-static unsigned long get_timestamp(int this_cpu)
-{
-	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
-}
-
-static void __touch_softlockup_watchdog(void)
-{
-	int this_cpu = raw_smp_processor_id();
-
-	__raw_get_cpu_var(softlockup_touch_ts) = get_timestamp(this_cpu);
-}
-
-void touch_softlockup_watchdog(void)
-{
-	__raw_get_cpu_var(softlockup_touch_ts) = 0;
-}
-EXPORT_SYMBOL(touch_softlockup_watchdog);
-
-void touch_softlockup_watchdog_sync(void)
-{
-	__raw_get_cpu_var(softlock_touch_sync) = true;
-	__raw_get_cpu_var(softlockup_touch_ts) = 0;
-}
-
-void touch_all_softlockup_watchdogs(void)
-{
-	int cpu;
-
-	/* Cause each CPU to re-update its timestamp rather than complain */
-	for_each_online_cpu(cpu)
-		per_cpu(softlockup_touch_ts, cpu) = 0;
-}
-EXPORT_SYMBOL(touch_all_softlockup_watchdogs);
-
-int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
-			     void __user *buffer,
-			     size_t *lenp, loff_t *ppos)
-{
-	touch_all_softlockup_watchdogs();
-	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
-}
-
-/*
- * This callback runs from the timer interrupt, and checks
- * whether the watchdog thread has hung or not:
- */
-void softlockup_tick(void)
-{
-	int this_cpu = smp_processor_id();
-	unsigned long touch_ts = per_cpu(softlockup_touch_ts, this_cpu);
-	unsigned long print_ts;
-	struct pt_regs *regs = get_irq_regs();
-	unsigned long now;
-
-	/* Is detection switched off? */
-	if (!per_cpu(softlockup_watchdog, this_cpu) || softlockup_thresh <= 0) {
-		/* Be sure we don't false trigger if switched back on */
-		if (touch_ts)
-			per_cpu(softlockup_touch_ts, this_cpu) = 0;
-		return;
-	}
-
-	if (touch_ts == 0) {
-		if (unlikely(per_cpu(softlock_touch_sync, this_cpu))) {
-			/*
-			 * If the time stamp was touched atomically
-			 * make sure the scheduler tick is up to date.
-			 */
-			per_cpu(softlock_touch_sync, this_cpu) = false;
-			sched_clock_tick();
-		}
-		__touch_softlockup_watchdog();
-		return;
-	}
-
-	print_ts = per_cpu(softlockup_print_ts, this_cpu);
-
-	/* report at most once a second */
-	if (print_ts == touch_ts || did_panic)
-		return;
-
-	/* do not print during early bootup: */
-	if (unlikely(system_state != SYSTEM_RUNNING)) {
-		__touch_softlockup_watchdog();
-		return;
-	}
-
-	now = get_timestamp(this_cpu);
-
-	/*
-	 * Wake up the high-prio watchdog task twice per
-	 * threshold timespan.
-	 */
-	if (time_after(now - softlockup_thresh/2, touch_ts))
-		wake_up_process(per_cpu(softlockup_watchdog, this_cpu));
-
-	/* Warn about unreasonable delays: */
-	if (time_before_eq(now - softlockup_thresh, touch_ts))
-		return;
-
-	per_cpu(softlockup_print_ts, this_cpu) = touch_ts;
-
-	spin_lock(&print_lock);
-	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
-			this_cpu, now - touch_ts,
-			current->comm, task_pid_nr(current));
-	print_modules();
-	print_irqtrace_events(current);
-	if (regs)
-		show_regs(regs);
-	else
-		dump_stack();
-	spin_unlock(&print_lock);
-
-	if (softlockup_panic)
-		panic("softlockup: hung tasks");
-}
-
-/*
- * The watchdog thread - runs every second and touches the timestamp.
- */
-static int watchdog(void *__bind_cpu)
-{
-	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
-
-	sched_setscheduler(current, SCHED_FIFO, &param);
-
-	/* initialize timestamp */
-	__touch_softlockup_watchdog();
-
-	set_current_state(TASK_INTERRUPTIBLE);
-	/*
-	 * Run briefly once per second to reset the softlockup timestamp.
-	 * If this gets delayed for more than 60 seconds then the
-	 * debug-printout triggers in softlockup_tick().
-	 */
-	while (!kthread_should_stop()) {
-		__touch_softlockup_watchdog();
-		schedule();
-
-		if (kthread_should_stop())
-			break;
-
-		set_current_state(TASK_INTERRUPTIBLE);
-	}
-	__set_current_state(TASK_RUNNING);
-
-	return 0;
-}
-
-/*
- * Create/destroy watchdog threads as CPUs come and go:
- */
-static int __cpuinit
-cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
-{
-	int hotcpu = (unsigned long)hcpu;
-	struct task_struct *p;
-
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		BUG_ON(per_cpu(softlockup_watchdog, hotcpu));
-		p = kthread_create(watchdog, hcpu, "watchdog/%d", hotcpu);
-		if (IS_ERR(p)) {
-			printk(KERN_ERR "watchdog for %i failed\n", hotcpu);
-			return NOTIFY_BAD;
-		}
-		per_cpu(softlockup_touch_ts, hotcpu) = 0;
-		per_cpu(softlockup_watchdog, hotcpu) = p;
-		kthread_bind(p, hotcpu);
-		break;
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		wake_up_process(per_cpu(softlockup_watchdog, hotcpu));
-		break;
-#ifdef CONFIG_HOTPLUG_CPU
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-		if (!per_cpu(softlockup_watchdog, hotcpu))
-			break;
-		/* Unbind so it can run.  Fall thru. */
-		kthread_bind(per_cpu(softlockup_watchdog, hotcpu),
-			     cpumask_any(cpu_online_mask));
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		p = per_cpu(softlockup_watchdog, hotcpu);
-		per_cpu(softlockup_watchdog, hotcpu) = NULL;
-		kthread_stop(p);
-		break;
-#endif /* CONFIG_HOTPLUG_CPU */
-	}
-	return NOTIFY_OK;
-}
-
-static struct notifier_block __cpuinitdata cpu_nfb = {
-	.notifier_call = cpu_callback
-};
-
-static int __initdata nosoftlockup;
-
-static int __init nosoftlockup_setup(char *str)
-{
-	nosoftlockup = 1;
-	return 1;
-}
-__setup("nosoftlockup", nosoftlockup_setup);
-
-static int __init spawn_softlockup_task(void)
-{
-	void *cpu = (void *)(long)smp_processor_id();
-	int err;
-
-	if (nosoftlockup)
-		return 0;
-
-	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
-	if (err == NOTIFY_BAD) {
-		BUG();
-		return 1;
-	}
-	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
-	register_cpu_notifier(&cpu_nfb);
-
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
-
-	return 0;
-}
-early_initcall(spawn_softlockup_task);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8686b0f..04bcd8a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -74,6 +74,10 @@
 #include <scsi/sg.h>
 #endif
 
+#ifdef CONFIG_LOCKUP_DETECTOR
+#include <linux/nmi.h>
+#endif
+
 
 #if defined(CONFIG_SYSCTL)
 
@@ -104,7 +108,7 @@ extern int blk_iopoll_enabled;
 #endif
 
 /* Constants used for minimum and  maximum */
-#ifdef CONFIG_DETECT_SOFTLOCKUP
+#ifdef CONFIG_LOCKUP_DETECTOR
 static int sixty = 60;
 static int neg_one = -1;
 #endif
@@ -682,7 +686,34 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
 	},
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
+#if defined(CONFIG_LOCKUP_DETECTOR)
+	{
+		.procname       = "watchdog",
+		.data           = &watchdog_enabled,
+		.maxlen         = sizeof (int),
+		.mode           = 0644,
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
+	},
+	{
+		.procname	= "softlockup_panic",
+		.data		= &softlockup_panic,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86) && !defined(CONFIG_LOCKUP_DETECTOR)
 	{
 		.procname       = "unknown_nmi_panic",
 		.data           = &unknown_nmi_panic,
@@ -785,26 +816,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
-#ifdef CONFIG_DETECT_SOFTLOCKUP
-	{
-		.procname	= "softlockup_panic",
-		.data		= &softlockup_panic,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
-	},
-	{
-		.procname	= "softlockup_thresh",
-		.data		= &softlockup_thresh,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dosoftlockup_thresh,
-		.extra1		= &neg_one,
-		.extra2		= &sixty,
-	},
-#endif
 #ifdef CONFIG_DETECT_HUNG_TASK
 	{
 		.procname	= "hung_task_panic",
diff --git a/kernel/timer.c b/kernel/timer.c
index aeb6a54..e8de5eb 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1225,7 +1225,6 @@ void run_local_timers(void)
 {
 	hrtimer_run_queues();
 	raise_softirq(TIMER_SOFTIRQ);
-	softlockup_tick();
 }
 
 /*
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
new file mode 100644
index 0000000..91b0b26
--- /dev/null
+++ b/kernel/watchdog.c
@@ -0,0 +1,567 @@
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
+static DEFINE_PER_CPU(bool, soft_watchdog_warn);
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+static DEFINE_PER_CPU(bool, hard_watchdog_warn);
+static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
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
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
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
+	int this_cpu = smp_processor_id();
+
+	__get_cpu_var(watchdog_touch_ts) = get_timestamp(this_cpu);
+}
+
+void touch_softlockup_watchdog(void)
+{
+	__get_cpu_var(watchdog_touch_ts) = 0;
+}
+EXPORT_SYMBOL(touch_softlockup_watchdog);
+
+void touch_all_softlockup_watchdogs(void)
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
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+void touch_nmi_watchdog(void)
+{
+	__get_cpu_var(watchdog_nmi_touch) = true;
+	touch_softlockup_watchdog();
+}
+EXPORT_SYMBOL(touch_nmi_watchdog);
+
+#endif
+
+void touch_softlockup_watchdog_sync(void)
+{
+	__raw_get_cpu_var(softlockup_touch_sync) = true;
+	__raw_get_cpu_var(watchdog_touch_ts) = 0;
+}
+
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+/* watchdog detector functions */
+static int is_hardlockup(void)
+{
+	unsigned long hrint = __get_cpu_var(hrtimer_interrupts);
+
+	if (__get_cpu_var(hrtimer_interrupts_saved) == hrint)
+		return 1;
+
+	__get_cpu_var(hrtimer_interrupts_saved) = hrint;
+	return 0;
+}
+#endif
+
+static int is_softlockup(unsigned long touch_ts)
+{
+	unsigned long now = get_timestamp(smp_processor_id());
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
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
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
+	if (__get_cpu_var(watchdog_nmi_touch) == true) {
+		__get_cpu_var(watchdog_nmi_touch) = false;
+		return;
+	}
+
+	/* check for a hardlockup
+	 * This is done by making sure our timer interrupt
+	 * is incrementing.  The timer interrupt should have
+	 * fired multiple times before we overflow'd.  If it hasn't
+	 * then this is a good indication the cpu is stuck
+	 */
+	if (is_hardlockup()) {
+		int this_cpu = smp_processor_id();
+
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
+#endif /* CONFIG_HARDLOCKUP_DETECTOR */
+
+/* watchdog kicker functions */
+static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
+{
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
+		if (unlikely(__get_cpu_var(softlockup_touch_sync))) {
+			/*
+			 * If the time stamp was touched atomically
+			 * make sure the scheduler tick is up to date.
+			 */
+			__get_cpu_var(softlockup_touch_sync) = false;
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
+	duration = is_softlockup(touch_ts);
+	if (unlikely(duration)) {
+		/* only warn once */
+		if (__get_cpu_var(soft_watchdog_warn) == true)
+			return HRTIMER_RESTART;
+
+		printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
+			smp_processor_id(), duration,
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
+static int watchdog(void *unused)
+{
+	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
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
+	 * debug-printout triggers in watchdog_timer_fn().
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
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
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
+#endif /* CONFIG_HARDLOCKUP_DETECTOR */
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
index 935248b..63968a9 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -152,28 +152,33 @@ config DEBUG_SHIRQ
 	  Drivers ought to be able to handle interrupts coming in at those
 	  points; some don't and need to be caught.
 
-config DETECT_SOFTLOCKUP
-	bool "Detect Soft Lockups"
+config LOCKUP_DETECTOR
+	bool "Detect Hard and Soft Lockups"
 	depends on DEBUG_KERNEL && !S390
-	default y
 	help
-	  Say Y here to enable the kernel to detect "soft lockups",
-	  which are bugs that cause the kernel to loop in kernel
+	  Say Y here to enable the kernel to act as a watchdog to detect
+	  hard and soft lockups.
+
+	  Softlockups are bugs that cause the kernel to loop in kernel
 	  mode for more than 60 seconds, without giving other tasks a
-	  chance to run.
+	  chance to run.  The current stack trace is displayed upon
+	  detection and the system will stay locked up.
 
-	  When a soft-lockup is detected, the kernel will print the
-	  current stack trace (which you should report), but the
-	  system will stay locked up. This feature has negligible
-	  overhead.
+	  Hardlockups are bugs that cause the CPU to loop in kernel mode
+	  for more than 60 seconds, without letting other interrupts have a
+	  chance to run.  The current stack trace is displayed upon detection
+	  and the system will stay locked up.
+
+	  The overhead should be minimal.  A periodic hrtimer runs to
+	  generate interrupts and kick the watchdog task every 10-12 seconds.
+	  An NMI is generated every 60 seconds or so to check for hardlockups.
 
-	  (Note that "hard lockups" are separate type of bugs that
-	   can be detected via the NMI-watchdog, on platforms that
-	   support it.)
+config HARDLOCKUP_DETECTOR
+	def_bool LOCKUP_DETECTOR && PERF_EVENTS && HAVE_PERF_EVENTS_NMI
 
 config BOOTPARAM_SOFTLOCKUP_PANIC
 	bool "Panic (Reboot) On Soft Lockups"
-	depends on DETECT_SOFTLOCKUP
+	depends on LOCKUP_DETECTOR
 	help
 	  Say Y here to enable the kernel to panic on "soft lockups",
 	  which are bugs that cause the kernel to loop in kernel
@@ -190,7 +195,7 @@ config BOOTPARAM_SOFTLOCKUP_PANIC
 
 config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 	int
-	depends on DETECT_SOFTLOCKUP
+	depends on LOCKUP_DETECTOR
 	range 0 1
 	default 0 if !BOOTPARAM_SOFTLOCKUP_PANIC
 	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC

