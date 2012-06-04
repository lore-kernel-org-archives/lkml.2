Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760838Ab2FDPuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:50:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:42101 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab2FDPuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:50:20 -0400
Date: Mon, 4 Jun 2012 17:50:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.4-rt8
Message-ID: <alpine.LFD.2.02.1206041743420.3086@ionos>
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

I'm pleased to announce the 3.4-rt8 release.

Changes since 3.4-rt7:

  * Printk fix (Frank Rowand)

  * mm activate protection fix (Frank Rowand)

  * qla2xxx rt conversion (John Kacur)

  * Networking RT fix (Priyanka Jain)

  * Lockdep selftest fixes (Yong Zhang)

  * Mips remove smp_reserve_lock

  * genirq: Add default irq mask command line parameter

This is the last 3.4-rt release from my side. I'm handing 3.4 over to
Steven and move on to 3.5.

The delta patch to 3.4-rt7 is appended below and can be found
here as incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/incr/patch-3.4-rt7-rt8.patch.xz

The RT patch against 3.4 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4-rt8.patch.xz


The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patches-3.4-rt8.tar.xz


Enjoy,

	tglx
---
Index: linux-3.4/drivers/tty/serial/cpm_uart/cpm_uart_core.c
===================================================================
--- linux-3.4.orig/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ linux-3.4/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -1226,7 +1226,7 @@ static void cpm_uart_console_write(struc
 {
 	struct uart_cpm_port *pinfo = &cpm_uart_ports[co->index];
 	unsigned long flags;
-	int nolock = oops_in_progress || sysrq_in_progress;
+	int nolock = oops_in_progress;
 
 	if (unlikely(nolock)) {
 		local_irq_save(flags);
Index: linux-3.4/drivers/tty/sysrq.c
===================================================================
--- linux-3.4.orig/drivers/tty/sysrq.c
+++ linux-3.4/drivers/tty/sysrq.c
@@ -495,23 +495,6 @@ static void __sysrq_put_key_op(int key, 
                 sysrq_key_table[i] = op_p;
 }
 
-#ifdef CONFIG_MAGIC_SYSRQ_FORCE_PRINTK
-
-int sysrq_in_progress;
-
-static void set_sysrq_in_progress(int value)
-{
-	sysrq_in_progress = value;
-}
-
-#else
-
-static void set_sysrq_in_progress(int value)
-{
-}
-
-#endif
-
 void __handle_sysrq(int key, bool check_mask)
 {
 	struct sysrq_key_op *op_p;
@@ -520,9 +503,6 @@ void __handle_sysrq(int key, bool check_
 	unsigned long flags;
 
 	spin_lock_irqsave(&sysrq_key_table_lock, flags);
-
-	set_sysrq_in_progress(1);
-
 	/*
 	 * Raise the apparent loglevel to maximum so that the sysrq header
 	 * is shown to provide the user with positive feedback.  We do not
@@ -564,9 +544,6 @@ void __handle_sysrq(int key, bool check_
 		printk("\n");
 		console_loglevel = orig_log_level;
 	}
-
-	set_sysrq_in_progress(0);
-
 	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
 }
 
Index: linux-3.4/fs/exec.c
===================================================================
--- linux-3.4.orig/fs/exec.c
+++ linux-3.4/fs/exec.c
@@ -840,12 +840,12 @@ static int exec_mmap(struct mm_struct *m
 		}
 	}
 	task_lock(tsk);
-	local_irq_disable_rt();
+	preempt_disable_rt();
 	active_mm = tsk->active_mm;
 	tsk->mm = mm;
 	tsk->active_mm = mm;
 	activate_mm(active_mm, mm);
-	local_irq_enable_rt();
+	preempt_enable_rt();
 	task_unlock(tsk);
 	arch_pick_mmap_layout(mm);
 	if (old_mm) {
Index: linux-3.4/include/linux/sysrq.h
===================================================================
--- linux-3.4.orig/include/linux/sysrq.h
+++ linux-3.4/include/linux/sysrq.h
@@ -38,11 +38,6 @@ struct sysrq_key_op {
 	int enable_mask;
 };
 
-#ifdef CONFIG_MAGIC_SYSRQ_FORCE_PRINTK
-extern int sysrq_in_progress;
-#else
-#define sysrq_in_progress 0
-#endif
 #ifdef CONFIG_MAGIC_SYSRQ
 
 /* Generic SysRq interface -- you may call it from any device driver, supplying
Index: linux-3.4/kernel/printk.c
===================================================================
--- linux-3.4.orig/kernel/printk.c
+++ linux-3.4/kernel/printk.c
@@ -21,7 +21,6 @@
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/console.h>
-#include <linux/sysrq.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
 #include <linux/nmi.h>
@@ -847,8 +846,8 @@ static int console_trylock_for_printk(un
 {
 	int retval = 0, wake = 0;
 #ifdef CONFIG_PREEMPT_RT_FULL
-	int lock = (!early_boot_irqs_disabled && !irqs_disabled_flags(flags) &&
-		!preempt_count()) || sysrq_in_progress;
+	int lock = !early_boot_irqs_disabled && !irqs_disabled_flags(flags) &&
+		(preempt_count() <= 1);
 #else
 	int lock = 1;
 #endif
Index: linux-3.4/kernel/time/tick-sched.c
===================================================================
--- linux-3.4.orig/kernel/time/tick-sched.c
+++ linux-3.4/kernel/time/tick-sched.c
@@ -812,6 +812,16 @@ static enum hrtimer_restart tick_sched_t
 	return HRTIMER_RESTART;
 }
 
+static int sched_skew_tick;
+
+static int __init skew_tick(char *str)
+{
+	get_option(&str, &sched_skew_tick);
+
+	return 0;
+}
+early_param("skew_tick", skew_tick);
+
 /**
  * tick_setup_sched_timer - setup the tick emulation timer
  */
@@ -830,6 +840,14 @@ void tick_setup_sched_timer(void)
 	/* Get the next period (per cpu) */
 	hrtimer_set_expires(&ts->sched_timer, tick_init_jiffy_update());
 
+	/* Offset the tick to avert xtime_lock contention. */
+	if (sched_skew_tick) {
+		u64 offset = ktime_to_ns(tick_period) >> 1;
+		do_div(offset, num_possible_cpus());
+		offset *= smp_processor_id();
+		hrtimer_add_expires_ns(&ts->sched_timer, offset);
+	}
+
 	for (;;) {
 		hrtimer_forward(&ts->sched_timer, now, tick_period);
 		hrtimer_start_expires(&ts->sched_timer,
Index: linux-3.4/lib/Kconfig.debug
===================================================================
--- linux-3.4.orig/lib/Kconfig.debug
+++ linux-3.4/lib/Kconfig.debug
@@ -62,28 +62,6 @@ config MAGIC_SYSRQ
 	  keys are documented in <file:Documentation/sysrq.txt>. Don't say Y
 	  unless you really know what this hack does.
 
-config MAGIC_SYSRQ_FORCE_PRINTK
-	bool "Force printk from Magic SysRq"
-	depends on MAGIC_SYSRQ && PREEMPT_RT_FULL
-	default n
-	help
-	  Allow the output from Magic SysRq to be output immediately, even if
-	  this causes large latencies.  This can cause performance problems
-	  for real-time processes.
-
-	  If PREEMPT_RT_FULL, printk() will not try to acquire the console lock
-	  when interrupts or preemption are disabled.  If the console lock is
-	  not acquired the printk() output will be buffered, but will not be
-	  output immediately.  Some drivers call into the Magic SysRq code
-	  with interrupts or preemption disabled, so the output of Magic SysRq
-	  will be buffered instead of printing immediately if this option is
-	  not selected.
-
-	  Even with this option selected, Magic SysRq output will be delayed
-	  if the attempt to acquire the console lock fails.
-
-	  Don't say Y unless you really know what this hack does.
-
 config STRIP_ASM_SYMS
 	bool "Strip assembler-generated symbols during link"
 	default n
Index: linux-3.4/localversion-rt
===================================================================
--- linux-3.4.orig/localversion-rt
+++ linux-3.4/localversion-rt
@@ -1 +1 @@
--rt7
+-rt8
Index: linux-3.4/mm/mmu_context.c
===================================================================
--- linux-3.4.orig/mm/mmu_context.c
+++ linux-3.4/mm/mmu_context.c
@@ -26,7 +26,7 @@ void use_mm(struct mm_struct *mm)
 	struct task_struct *tsk = current;
 
 	task_lock(tsk);
-	local_irq_disable_rt();
+	preempt_disable_rt();
 	active_mm = tsk->active_mm;
 	if (active_mm != mm) {
 		atomic_inc(&mm->mm_count);
@@ -34,7 +34,7 @@ void use_mm(struct mm_struct *mm)
 	}
 	tsk->mm = mm;
 	switch_mm(active_mm, mm, tsk);
-	local_irq_enable_rt();
+	preempt_enable_rt();
 	task_unlock(tsk);
 
 	if (active_mm != mm)
Index: linux-3.4/net/core/dev.c
===================================================================
--- linux-3.4.orig/net/core/dev.c
+++ linux-3.4/net/core/dev.c
@@ -2937,7 +2937,7 @@ int netif_rx(struct sk_buff *skb)
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
 		int cpu;
 
-		preempt_disable();
+		migrate_disable();
 		rcu_read_lock();
 
 		cpu = get_rps_cpu(skb->dev, skb, &rflow);
@@ -2947,13 +2947,13 @@ int netif_rx(struct sk_buff *skb)
 		ret = enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
 
 		rcu_read_unlock();
-		preempt_enable();
+		migrate_enable();
 	} else
 #endif
 	{
 		unsigned int qtail;
-		ret = enqueue_to_backlog(skb, get_cpu(), &qtail);
-		put_cpu();
+		ret = enqueue_to_backlog(skb, get_cpu_light(), &qtail);
+		put_cpu_light();
 	}
 	return ret;
 }
Index: linux-3.4/Documentation/kernel-parameters.txt
===================================================================
--- linux-3.4.orig/Documentation/kernel-parameters.txt
+++ linux-3.4/Documentation/kernel-parameters.txt
@@ -1126,6 +1126,15 @@ bytes respectively. Such letter suffixes
 			See comment before ip2_setup() in
 			drivers/char/ip2/ip2base.c.
 
+	irqaffinity=	[SMP] Set the default irq affinity mask
+			Format:
+			<cpu number>,...,<cpu number>
+			or
+			<cpu number>-<cpu number>
+			(must be a positive range in ascending order)
+			or a mixture
+			<cpu number>,...,<cpu number>-<cpu number>
+
 	irqfixup	[HW]
 			When an interrupt is not handled search all handlers
 			for it. Intended to get systems with badly broken
@@ -2426,6 +2435,15 @@ bytes respectively. Such letter suffixes
 
 	sched_debug	[KNL] Enables verbose scheduler debug messages.
 
+	skew_tick=	[KNL] Offset the periodic timer tick per cpu to mitigate
+			xtime_lock contention on larger systems, and/or RCU lock
+			contention on all systems with CONFIG_MAXSMP set.
+			Format: { "0" | "1" }
+			0 -- disable. (may be 1 via CONFIG_CMDLINE="skew_tick=1"
+			1 -- enable.
+			Note: increases power consumption, thus should only be
+			enabled if running jitter sensitive (HPC/RT) workloads.
+
 	security=	[SECURITY] Choose a security module to enable at boot.
 			If this boot parameter is not specified, only the first
 			security module asking for security registration will be
Index: linux-3.4/drivers/scsi/qla2xxx/qla_inline.h
===================================================================
--- linux-3.4.orig/drivers/scsi/qla2xxx/qla_inline.h
+++ linux-3.4/drivers/scsi/qla2xxx/qla_inline.h
@@ -36,12 +36,12 @@ qla2x00_poll(struct rsp_que *rsp)
 {
 	unsigned long flags;
 	struct qla_hw_data *ha = rsp->hw;
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 	if (IS_QLA82XX(ha))
 		qla82xx_poll(0, rsp);
 	else
 		ha->isp_ops->intr_handler(0, rsp);
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 }
 
 static inline uint8_t *
Index: linux-3.4/arch/mips/cavium-octeon/smp.c
===================================================================
--- linux-3.4.orig/arch/mips/cavium-octeon/smp.c
+++ linux-3.4/arch/mips/cavium-octeon/smp.c
@@ -257,8 +257,6 @@ DEFINE_PER_CPU(int, cpu_state);
 
 extern void fixup_irqs(void);
 
-static DEFINE_SPINLOCK(smp_reserve_lock);
-
 static int octeon_cpu_disable(void)
 {
 	unsigned int cpu = smp_processor_id();
@@ -266,8 +264,6 @@ static int octeon_cpu_disable(void)
 	if (cpu == 0)
 		return -EBUSY;
 
-	spin_lock(&smp_reserve_lock);
-
 	set_cpu_online(cpu, false);
 	cpu_clear(cpu, cpu_callin_map);
 	local_irq_disable();
@@ -277,8 +273,6 @@ static int octeon_cpu_disable(void)
 	flush_cache_all();
 	local_flush_tlb_all();
 
-	spin_unlock(&smp_reserve_lock);
-
 	return 0;
 }
 
Index: linux-3.4/lib/locking-selftest.c
===================================================================
--- linux-3.4.orig/lib/locking-selftest.c
+++ linux-3.4/lib/locking-selftest.c
@@ -47,10 +47,10 @@ __setup("debug_locks_verbose=", setup_de
  * Normal standalone locks, for the circular and irq-context
  * dependency tests:
  */
-static DEFINE_SPINLOCK(lock_A);
-static DEFINE_SPINLOCK(lock_B);
-static DEFINE_SPINLOCK(lock_C);
-static DEFINE_SPINLOCK(lock_D);
+static DEFINE_RAW_SPINLOCK(lock_A);
+static DEFINE_RAW_SPINLOCK(lock_B);
+static DEFINE_RAW_SPINLOCK(lock_C);
+static DEFINE_RAW_SPINLOCK(lock_D);
 
 static DEFINE_RWLOCK(rwlock_A);
 static DEFINE_RWLOCK(rwlock_B);
@@ -73,12 +73,12 @@ static DECLARE_RWSEM(rwsem_D);
  * but X* and Y* are different classes. We do this so that
  * we do not trigger a real lockup:
  */
-static DEFINE_SPINLOCK(lock_X1);
-static DEFINE_SPINLOCK(lock_X2);
-static DEFINE_SPINLOCK(lock_Y1);
-static DEFINE_SPINLOCK(lock_Y2);
-static DEFINE_SPINLOCK(lock_Z1);
-static DEFINE_SPINLOCK(lock_Z2);
+static DEFINE_RAW_SPINLOCK(lock_X1);
+static DEFINE_RAW_SPINLOCK(lock_X2);
+static DEFINE_RAW_SPINLOCK(lock_Y1);
+static DEFINE_RAW_SPINLOCK(lock_Y2);
+static DEFINE_RAW_SPINLOCK(lock_Z1);
+static DEFINE_RAW_SPINLOCK(lock_Z2);
 
 static DEFINE_RWLOCK(rwlock_X1);
 static DEFINE_RWLOCK(rwlock_X2);
@@ -107,10 +107,10 @@ static DECLARE_RWSEM(rwsem_Z2);
  */
 #define INIT_CLASS_FUNC(class) 				\
 static noinline void					\
-init_class_##class(spinlock_t *lock, rwlock_t *rwlock, struct mutex *mutex, \
-		 struct rw_semaphore *rwsem)		\
+init_class_##class(raw_spinlock_t *lock, rwlock_t *rwlock, \
+	struct mutex *mutex, struct rw_semaphore *rwsem)\
 {							\
-	spin_lock_init(lock);				\
+	raw_spin_lock_init(lock);			\
 	rwlock_init(rwlock);				\
 	mutex_init(mutex);				\
 	init_rwsem(rwsem);				\
@@ -168,10 +168,10 @@ static void init_shared_classes(void)
  * Shortcuts for lock/unlock API variants, to keep
  * the testcases compact:
  */
-#define L(x)			spin_lock(&lock_##x)
-#define U(x)			spin_unlock(&lock_##x)
+#define L(x)			raw_spin_lock(&lock_##x)
+#define U(x)			raw_spin_unlock(&lock_##x)
 #define LU(x)			L(x); U(x)
-#define SI(x)			spin_lock_init(&lock_##x)
+#define SI(x)			raw_spin_lock_init(&lock_##x)
 
 #define WL(x)			write_lock(&rwlock_##x)
 #define WU(x)			write_unlock(&rwlock_##x)
@@ -911,7 +911,7 @@ GENERATE_PERMUTATIONS_3_EVENTS(irq_read_
 
 #define I2(x)					\
 	do {					\
-		spin_lock_init(&lock_##x);	\
+		raw_spin_lock_init(&lock_##x);	\
 		rwlock_init(&rwlock_##x);	\
 		mutex_init(&mutex_##x);		\
 		init_rwsem(&rwsem_##x);		\
@@ -1175,6 +1175,7 @@ void locking_selftest(void)
 
 	printk("  --------------------------------------------------------------------------\n");
 
+#ifndef CONFIG_PREEMPT_RT_FULL
 	/*
 	 * irq-context testcases:
 	 */
@@ -1187,6 +1188,28 @@ void locking_selftest(void)
 
 	DO_TESTCASE_6x2("irq read-recursion", irq_read_recursion);
 //	DO_TESTCASE_6x2B("irq read-recursion #2", irq_read_recursion2);
+#else
+	/* On -rt, we only do hardirq context test for raw spinlock */
+	DO_TESTCASE_1B("hard-irqs-on + irq-safe-A", irqsafe1_hard_spin, 12);
+	DO_TESTCASE_1B("hard-irqs-on + irq-safe-A", irqsafe1_hard_spin, 21);
+
+	DO_TESTCASE_1B("hard-safe-A + irqs-on", irqsafe2B_hard_spin, 12);
+	DO_TESTCASE_1B("hard-safe-A + irqs-on", irqsafe2B_hard_spin, 21);
+
+	DO_TESTCASE_1B("hard-safe-A + unsafe-B #1", irqsafe3_hard_spin, 123);
+	DO_TESTCASE_1B("hard-safe-A + unsafe-B #1", irqsafe3_hard_spin, 132);
+	DO_TESTCASE_1B("hard-safe-A + unsafe-B #1", irqsafe3_hard_spin, 213);
+	DO_TESTCASE_1B("hard-safe-A + unsafe-B #1", irqsafe3_hard_spin, 231);
+	DO_TESTCASE_1B("hard-safe-A + unsafe-B #1", irqsafe3_hard_spin, 312);
+	DO_TESTCASE_1B("hard-safe-A + unsafe-B #1", irqsafe3_hard_spin, 321);
+
+	DO_TESTCASE_1B("hard-safe-A + unsafe-B #2", irqsafe4_hard_spin, 123);
+	DO_TESTCASE_1B("hard-safe-A + unsafe-B #2", irqsafe4_hard_spin, 132);
+	DO_TESTCASE_1B("hard-safe-A + unsafe-B #2", irqsafe4_hard_spin, 213);
+	DO_TESTCASE_1B("hard-safe-A + unsafe-B #2", irqsafe4_hard_spin, 231);
+	DO_TESTCASE_1B("hard-safe-A + unsafe-B #2", irqsafe4_hard_spin, 312);
+	DO_TESTCASE_1B("hard-safe-A + unsafe-B #2", irqsafe4_hard_spin, 321);
+#endif
 
 	if (unexpected_testcase_failures) {
 		printk("-----------------------------------------------------------------\n");
Index: linux-3.4/kernel/irq/irqdesc.c
===================================================================
--- linux-3.4.orig/kernel/irq/irqdesc.c
+++ linux-3.4/kernel/irq/irqdesc.c
@@ -23,10 +23,27 @@
 static struct lock_class_key irq_desc_lock_class;
 
 #if defined(CONFIG_SMP)
+static int __init irq_affinity_setup(char *str)
+{
+	zalloc_cpumask_var(&irq_default_affinity, GFP_NOWAIT);
+	cpulist_parse(str, irq_default_affinity);
+	/*
+	 * Set at least the boot cpu. We don't want to end up with
+	 * bugreports caused by random comandline masks
+	 */
+	cpumask_set_cpu(smp_processor_id(), irq_default_affinity);
+	return 1;
+}
+__setup("irqaffinity=", irq_affinity_setup);
+
 static void __init init_irq_default_affinity(void)
 {
-	alloc_cpumask_var(&irq_default_affinity, GFP_NOWAIT);
-	cpumask_setall(irq_default_affinity);
+#ifdef CONFIG_CPUMASK_OFFSTACK
+	if (!irq_default_affinity)
+		zalloc_cpumask_var(&irq_default_affinity, GFP_NOWAIT);
+#endif
+	if (cpumask_empty(irq_default_affinity))
+		cpumask_setall(irq_default_affinity);
 }
 #else
 static void __init init_irq_default_affinity(void)
