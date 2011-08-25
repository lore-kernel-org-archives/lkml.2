Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1HYQqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:46:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab1HYQq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:46:29 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, ying.huang@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        Don Zickus <dzickus@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andi Kleen <ak@linux.intel.com>, Corey Minyard <minyard@acm.org>,
        Jack Steiner <steiner@sgi.com>
Subject: [V3][PATCH 3/6] x86, nmi: wire up NMI handlers to new routines
Date: Thu, 25 Aug 2011 12:45:45 -0400
Message-Id: <1314290748-23569-4-git-send-email-dzickus@redhat.com>
In-Reply-To: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
References: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just convert all the files that have an nmi handler to the new routines.
Most of it is straight forward conversion.  A couple of places needed some
tweaking like kgdb which separates the debug notifier from the nmi handler
and mce removes a call to notify_die (as I couldn't figure out why it was
there).

The things that get converted are the registeration/unregistration routines
and the nmi handler itself has its args changed along with code removal
to check which list it is on (most are on one NMI list except for kgdb
which has both an NMI routine and an NMI Unknown routine).

Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Corey Minyard <minyard@acm.org>
Cc: Jack Steiner <steiner@sgi.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/nmi.h              |   20 ----------
 arch/x86/include/asm/reboot.h           |    2 +-
 arch/x86/kernel/apic/hw_nmi.c           |   27 +++-----------
 arch/x86/kernel/apic/x2apic_uv_x.c      |   20 ++--------
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   20 ++++-------
 arch/x86/kernel/cpu/mcheck/mce.c        |    3 --
 arch/x86/kernel/cpu/perf_event.c        |   60 +++----------------------------
 arch/x86/kernel/crash.c                 |    5 +--
 arch/x86/kernel/kgdb.c                  |   60 +++++++++++++++++++++++--------
 arch/x86/kernel/nmi.c                   |   11 ++++--
 arch/x86/kernel/reboot.c                |   23 ++++--------
 arch/x86/oprofile/nmi_int.c             |   40 ++++++--------------
 arch/x86/oprofile/nmi_timer_int.c       |   28 +++-----------
 drivers/acpi/apei/ghes.c                |   22 ++++-------
 drivers/char/ipmi/ipmi_watchdog.c       |   32 +++++-----------
 drivers/watchdog/hpwdt.c                |   23 +++---------
 16 files changed, 125 insertions(+), 271 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 6d04b28..fc74547 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -22,26 +22,6 @@ void arch_trigger_all_cpu_backtrace(void);
 #define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
 #endif
 
-/*
- * Define some priorities for the nmi notifier call chain.
- *
- * Create a local nmi bit that has a higher priority than
- * external nmis, because the local ones are more frequent.
- *
- * Also setup some default high/normal/low settings for
- * subsystems to registers with.  Using 4 bits to separate
- * the priorities.  This can go a lot higher if needed be.
- */
-
-#define NMI_LOCAL_SHIFT		16	/* randomly picked */
-#define NMI_LOCAL_BIT		(1ULL << NMI_LOCAL_SHIFT)
-#define NMI_HIGH_PRIOR		(1ULL << 8)
-#define NMI_NORMAL_PRIOR	(1ULL << 4)
-#define NMI_LOW_PRIOR		(1ULL << 0)
-#define NMI_LOCAL_HIGH_PRIOR	(NMI_LOCAL_BIT | NMI_HIGH_PRIOR)
-#define NMI_LOCAL_NORMAL_PRIOR	(NMI_LOCAL_BIT | NMI_NORMAL_PRIOR)
-#define NMI_LOCAL_LOW_PRIOR	(NMI_LOCAL_BIT | NMI_LOW_PRIOR)
-
 #define NMI_FLAG_FIRST	1
 
 enum {
diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index 3250e3d..92f29706 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -23,7 +23,7 @@ void machine_real_restart(unsigned int type);
 #define MRR_BIOS	0
 #define MRR_APM		1
 
-typedef void (*nmi_shootdown_cb)(int, struct die_args*);
+typedef void (*nmi_shootdown_cb)(int, struct pt_regs*);
 void nmi_shootdown_cpus(nmi_shootdown_cb callback);
 
 #endif /* _ASM_X86_REBOOT_H */
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index d5e57db0..31cb9ae 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -60,22 +60,10 @@ void arch_trigger_all_cpu_backtrace(void)
 }
 
 static int __kprobes
-arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
-			 unsigned long cmd, void *__args)
+arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
 {
-	struct die_args *args = __args;
-	struct pt_regs *regs;
 	int cpu;
 
-	switch (cmd) {
-	case DIE_NMI:
-		break;
-
-	default:
-		return NOTIFY_DONE;
-	}
-
-	regs = args->regs;
 	cpu = smp_processor_id();
 
 	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
@@ -86,21 +74,16 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 		show_regs(regs);
 		arch_spin_unlock(&lock);
 		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
-		return NOTIFY_STOP;
+		return NMI_HANDLED;
 	}
 
-	return NOTIFY_DONE;
+	return NMI_DONE;
 }
 
-static __read_mostly struct notifier_block backtrace_notifier = {
-	.notifier_call          = arch_trigger_all_cpu_backtrace_handler,
-	.next                   = NULL,
-	.priority               = NMI_LOCAL_LOW_PRIOR,
-};
-
 static int __init register_trigger_all_cpu_backtrace(void)
 {
-	register_die_notifier(&backtrace_notifier);
+	register_nmi_handler(NMI_LOCAL, arch_trigger_all_cpu_backtrace_handler,
+				0, "arch_bt");
 	return 0;
 }
 early_initcall(register_trigger_all_cpu_backtrace);
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index adc66c3..88b0dbb 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -673,18 +673,11 @@ void __cpuinit uv_cpu_init(void)
 /*
  * When NMI is received, print a stack trace.
  */
-int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
+int uv_handle_nmi(unsigned int reason, struct pt_regs *regs)
 {
 	unsigned long real_uv_nmi;
 	int bid;
 
-	if (reason != DIE_NMIUNKNOWN)
-		return NOTIFY_OK;
-
-	if (in_crash_kexec)
-		/* do nothing if entering the crash kernel */
-		return NOTIFY_OK;
-
 	/*
 	 * Each blade has an MMR that indicates when an NMI has been sent
 	 * to cpus on the blade. If an NMI is detected, atomically
@@ -705,7 +698,7 @@ int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
 	}
 
 	if (likely(__get_cpu_var(cpu_last_nmi_count) == uv_blade_info[bid].nmi_count))
-		return NOTIFY_DONE;
+		return NMI_DONE;
 
 	__get_cpu_var(cpu_last_nmi_count) = uv_blade_info[bid].nmi_count;
 
@@ -718,17 +711,12 @@ int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
 	dump_stack();
 	spin_unlock(&uv_nmi_lock);
 
-	return NOTIFY_STOP;
+	return NMI_HANDLED;
 }
 
-static struct notifier_block uv_dump_stack_nmi_nb = {
-	.notifier_call	= uv_handle_nmi,
-	.priority = NMI_LOCAL_LOW_PRIOR - 1,
-};
-
 void uv_register_nmi_notifier(void)
 {
-	if (register_die_notifier(&uv_dump_stack_nmi_nb))
+	if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv"))
 		printk(KERN_WARNING "UV NMI handler failed to register\n");
 }
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 0ed633c..6199232 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -78,27 +78,20 @@ static void raise_exception(struct mce *m, struct pt_regs *pregs)
 
 static cpumask_var_t mce_inject_cpumask;
 
-static int mce_raise_notify(struct notifier_block *self,
-			    unsigned long val, void *data)
+static int mce_raise_notify(unsigned int cmd, struct pt_regs *regs)
 {
-	struct die_args *args = (struct die_args *)data;
 	int cpu = smp_processor_id();
 	struct mce *m = &__get_cpu_var(injectm);
-	if (val != DIE_NMI || !cpumask_test_cpu(cpu, mce_inject_cpumask))
-		return NOTIFY_DONE;
+	if (!cpumask_test_cpu(cpu, mce_inject_cpumask))
+		return NMI_DONE;
 	cpumask_clear_cpu(cpu, mce_inject_cpumask);
 	if (m->inject_flags & MCJ_EXCEPTION)
-		raise_exception(m, args->regs);
+		raise_exception(m, regs);
 	else if (m->status)
 		raise_poll(m);
-	return NOTIFY_STOP;
+	return NMI_HANDLED;
 }
 
-static struct notifier_block mce_raise_nb = {
-	.notifier_call = mce_raise_notify,
-	.priority = NMI_LOCAL_NORMAL_PRIOR,
-};
-
 /* Inject mce on current CPU */
 static int raise_local(void)
 {
@@ -216,7 +209,8 @@ static int inject_init(void)
 		return -ENOMEM;
 	printk(KERN_INFO "Machine check injector initialized\n");
 	mce_chrdev_ops.write = mce_write;
-	register_die_notifier(&mce_raise_nb);
+	register_nmi_handler(NMI_LOCAL, mce_raise_notify, 0,
+				"mce_notify");
 	return 0;
 }
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 08363b0..3fc65b6 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -908,9 +908,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 
 	percpu_inc(mce_exception_count);
 
-	if (notify_die(DIE_NMI, "machine check", regs, error_code,
-			   18, SIGKILL) == NOTIFY_STOP)
-		goto out;
 	if (!banks)
 		goto out;
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4ee3abf..767371f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1375,68 +1375,18 @@ struct pmu_nmi_state {
 static DEFINE_PER_CPU(struct pmu_nmi_state, pmu_nmi);
 
 static int __kprobes
-perf_event_nmi_handler(struct notifier_block *self,
-			 unsigned long cmd, void *__args)
+perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 {
-	struct die_args *args = __args;
-	unsigned int this_nmi;
 	int handled;
 
 	if (!atomic_read(&active_events))
-		return NOTIFY_DONE;
+		return NMI_DONE;
 
-	switch (cmd) {
-	case DIE_NMI:
-		break;
-	case DIE_NMIUNKNOWN:
-		this_nmi = percpu_read(irq_stat.__nmi_count);
-		if (this_nmi != __this_cpu_read(pmu_nmi.marked))
-			/* let the kernel handle the unknown nmi */
-			return NOTIFY_DONE;
-		/*
-		 * This one is a PMU back-to-back nmi. Two events
-		 * trigger 'simultaneously' raising two back-to-back
-		 * NMIs. If the first NMI handles both, the latter
-		 * will be empty and daze the CPU. So, we drop it to
-		 * avoid false-positive 'unknown nmi' messages.
-		 */
-		return NOTIFY_STOP;
-	default:
-		return NOTIFY_DONE;
-	}
-
-	handled = x86_pmu.handle_irq(args->regs);
-	if (!handled)
-		return NOTIFY_DONE;
-
-	this_nmi = percpu_read(irq_stat.__nmi_count);
-	if ((handled > 1) ||
-		/* the next nmi could be a back-to-back nmi */
-	    ((__this_cpu_read(pmu_nmi.marked) == this_nmi) &&
-	     (__this_cpu_read(pmu_nmi.handled) > 1))) {
-		/*
-		 * We could have two subsequent back-to-back nmis: The
-		 * first handles more than one counter, the 2nd
-		 * handles only one counter and the 3rd handles no
-		 * counter.
-		 *
-		 * This is the 2nd nmi because the previous was
-		 * handling more than one counter. We will mark the
-		 * next (3rd) and then drop it if unhandled.
-		 */
-		__this_cpu_write(pmu_nmi.marked, this_nmi + 1);
-		__this_cpu_write(pmu_nmi.handled, handled);
-	}
+	handled = x86_pmu.handle_irq(regs);
 
-	return NOTIFY_STOP;
+	return handled;
 }
 
-static __read_mostly struct notifier_block perf_event_nmi_notifier = {
-	.notifier_call		= perf_event_nmi_handler,
-	.next			= NULL,
-	.priority		= NMI_LOCAL_LOW_PRIOR,
-};
-
 static struct event_constraint unconstrained;
 static struct event_constraint emptyconstraint;
 
@@ -1557,7 +1507,7 @@ static int __init init_hw_perf_events(void)
 		((1LL << x86_pmu.num_counters_fixed)-1) << X86_PMC_IDX_FIXED;
 
 	perf_events_lapic_init();
-	register_die_notifier(&perf_event_nmi_notifier);
+	register_nmi_handler(NMI_LOCAL, perf_event_nmi_handler, 0, "PMI");
 
 	unconstrained = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_counters) - 1,
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 764c7c2..13ad899 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -32,15 +32,12 @@ int in_crash_kexec;
 
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
-static void kdump_nmi_callback(int cpu, struct die_args *args)
+static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
 {
-	struct pt_regs *regs;
 #ifdef CONFIG_X86_32
 	struct pt_regs fixed_regs;
 #endif
 
-	regs = args->regs;
-
 #ifdef CONFIG_X86_32
 	if (!user_mode_vm(regs)) {
 		crash_fixup_ss_esp(&fixed_regs, regs);
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 00354d4..faba577 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -511,28 +511,37 @@ single_step_cont(struct pt_regs *regs, struct die_args *args)
 
 static int was_in_debug_nmi[NR_CPUS];
 
-static int __kgdb_notify(struct die_args *args, unsigned long cmd)
+static int kgdb_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 {
-	struct pt_regs *regs = args->regs;
-
 	switch (cmd) {
-	case DIE_NMI:
+	case NMI_LOCAL:
 		if (atomic_read(&kgdb_active) != -1) {
 			/* KGDB CPU roundup */
 			kgdb_nmicallback(raw_smp_processor_id(), regs);
 			was_in_debug_nmi[raw_smp_processor_id()] = 1;
 			touch_nmi_watchdog();
-			return NOTIFY_STOP;
+			return NMI_HANDLED;
 		}
-		return NOTIFY_DONE;
+		break;
 
-	case DIE_NMIUNKNOWN:
+	case NMI_UNKNOWN:
 		if (was_in_debug_nmi[raw_smp_processor_id()]) {
 			was_in_debug_nmi[raw_smp_processor_id()] = 0;
-			return NOTIFY_STOP;
+			return NMI_HANDLED;
 		}
-		return NOTIFY_DONE;
+		break;
+	default:
+		/* do nothing */
+		break;
+	}
+	return NMI_DONE;
+}
+
+static int __kgdb_notify(struct die_args *args, unsigned long cmd)
+{
+	struct pt_regs *regs = args->regs;
 
+	switch (cmd) {
 	case DIE_DEBUG:
 		if (atomic_read(&kgdb_cpu_doing_single_step) != -1) {
 			if (user_mode(regs))
@@ -590,11 +599,6 @@ kgdb_notify(struct notifier_block *self, unsigned long cmd, void *ptr)
 
 static struct notifier_block kgdb_notifier = {
 	.notifier_call	= kgdb_notify,
-
-	/*
-	 * Lowest-prio notifier priority, we want to be notified last:
-	 */
-	.priority	= NMI_LOCAL_LOW_PRIOR,
 };
 
 /**
@@ -605,7 +609,31 @@ static struct notifier_block kgdb_notifier = {
  */
 int kgdb_arch_init(void)
 {
-	return register_die_notifier(&kgdb_notifier);
+	int retval;
+
+	retval = register_die_notifier(&kgdb_notifier);
+	if (retval)
+		goto out;
+
+	retval = register_nmi_handler(NMI_LOCAL, kgdb_nmi_handler,
+					0, "kgdb");
+	if (retval)
+		goto out1;
+
+	retval = register_nmi_handler(NMI_UNKNOWN, kgdb_nmi_handler,
+					0, "kgdb");
+
+	if (retval)
+		goto out2;
+
+	return retval;
+
+out2:
+	unregister_nmi_handler(NMI_LOCAL, "kgdb");
+out1:
+	unregister_die_notifier(&kgdb_notifier);
+out:
+	return retval;
 }
 
 static void kgdb_hw_overflow_handler(struct perf_event *event,
@@ -673,6 +701,8 @@ void kgdb_arch_exit(void)
 			breakinfo[i].pev = NULL;
 		}
 	}
+	unregister_nmi_handler(NMI_UNKNOWN, "kgdb");
+	unregister_nmi_handler(NMI_LOCAL, "kgdb");
 	unregister_die_notifier(&kgdb_notifier);
 }
 
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index e65295c..45fcd82 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -1,6 +1,7 @@
 /*
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
+ *  Copyright (C) 2011	Don Zickus Red Hat, Inc.
  *
  *  Pentium III FXSR, SSE support
  *	Gareth Hughes <gareth@valinux.com>, May 2000
@@ -244,8 +245,10 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 static notrace __kprobes void
 unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 {
-	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
-			NOTIFY_STOP)
+	int handled;
+
+	handled = nmi_handle(NMI_UNKNOWN, regs);
+	if (handled) 
 		return;
 #ifdef CONFIG_MCA
 	/*
@@ -270,13 +273,15 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
+	int handled;
 
 	/*
 	 * CPU-specific NMI must be processed before non-CPU-specific
 	 * NMI, otherwise we may lose it, because the CPU-specific
 	 * NMI can not be detected/processed on other CPUs.
 	 */
-	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
+	handled = nmi_handle(NMI_LOCAL, regs);
+	if (handled)
 		return;
 
 	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 9242436..adab340 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -464,7 +464,7 @@ static inline void kb_wait(void)
 	}
 }
 
-static void vmxoff_nmi(int cpu, struct die_args *args)
+static void vmxoff_nmi(int cpu, struct pt_regs *regs)
 {
 	cpu_emergency_vmxoff();
 }
@@ -736,14 +736,10 @@ static nmi_shootdown_cb shootdown_callback;
 
 static atomic_t waiting_for_crash_ipi;
 
-static int crash_nmi_callback(struct notifier_block *self,
-			unsigned long val, void *data)
+static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
 {
 	int cpu;
 
-	if (val != DIE_NMI)
-		return NOTIFY_OK;
-
 	cpu = raw_smp_processor_id();
 
 	/* Don't do anything if this handler is invoked on crashing cpu.
@@ -751,10 +747,10 @@ static int crash_nmi_callback(struct notifier_block *self,
 	 * an NMI if system was initially booted with nmi_watchdog parameter.
 	 */
 	if (cpu == crashing_cpu)
-		return NOTIFY_STOP;
+		return NMI_HANDLED;
 	local_irq_disable();
 
-	shootdown_callback(cpu, (struct die_args *)data);
+	shootdown_callback(cpu, regs);
 
 	atomic_dec(&waiting_for_crash_ipi);
 	/* Assume hlt works */
@@ -762,7 +758,7 @@ static int crash_nmi_callback(struct notifier_block *self,
 	for (;;)
 		cpu_relax();
 
-	return 1;
+	return NMI_HANDLED;
 }
 
 static void smp_send_nmi_allbutself(void)
@@ -770,12 +766,6 @@ static void smp_send_nmi_allbutself(void)
 	apic->send_IPI_allbutself(NMI_VECTOR);
 }
 
-static struct notifier_block crash_nmi_nb = {
-	.notifier_call = crash_nmi_callback,
-	/* we want to be the first one called */
-	.priority = NMI_LOCAL_HIGH_PRIOR+1,
-};
-
 /* Halt all other CPUs, calling the specified function on each of them
  *
  * This function can be used to halt all other CPUs on crash
@@ -794,7 +784,8 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 
 	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
 	/* Would it be better to replace the trap vector here? */
-	if (register_die_notifier(&crash_nmi_nb))
+	if (register_nmi_handler(NMI_LOCAL, crash_nmi_callback, 
+				 NMI_FLAG_FIRST, "crash"))
 		return;		/* return what? */
 	/* Ensure the new callback function is set before sending
 	 * out the NMI
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 68894fd..adf8fb3 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -61,26 +61,15 @@ u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
 }
 
 
-static int profile_exceptions_notify(struct notifier_block *self,
-				     unsigned long val, void *data)
+static int profile_exceptions_notify(unsigned int val, struct pt_regs *regs)
 {
-	struct die_args *args = (struct die_args *)data;
-	int ret = NOTIFY_DONE;
-
-	switch (val) {
-	case DIE_NMI:
-		if (ctr_running)
-			model->check_ctrs(args->regs, &__get_cpu_var(cpu_msrs));
-		else if (!nmi_enabled)
-			break;
-		else
-			model->stop(&__get_cpu_var(cpu_msrs));
-		ret = NOTIFY_STOP;
-		break;
-	default:
-		break;
-	}
-	return ret;
+	if (ctr_running)
+		model->check_ctrs(regs, &__get_cpu_var(cpu_msrs));
+	else if (!nmi_enabled)
+		return NMI_DONE;
+	else
+		model->stop(&__get_cpu_var(cpu_msrs));
+	return NMI_HANDLED;
 }
 
 static void nmi_cpu_save_registers(struct op_msrs *msrs)
@@ -363,12 +352,6 @@ static void nmi_cpu_setup(void *dummy)
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 }
 
-static struct notifier_block profile_exceptions_nb = {
-	.notifier_call = profile_exceptions_notify,
-	.next = NULL,
-	.priority = NMI_LOCAL_LOW_PRIOR,
-};
-
 static void nmi_cpu_restore_registers(struct op_msrs *msrs)
 {
 	struct op_msr *counters = msrs->counters;
@@ -508,7 +491,8 @@ static int nmi_setup(void)
 	ctr_running = 0;
 	/* make variables visible to the nmi handler: */
 	smp_mb();
-	err = register_die_notifier(&profile_exceptions_nb);
+	err = register_nmi_handler(NMI_LOCAL, profile_exceptions_notify,
+					0, "oprofile");
 	if (err)
 		goto fail;
 
@@ -538,7 +522,7 @@ static void nmi_shutdown(void)
 	put_online_cpus();
 	/* make variables visible to the nmi handler: */
 	smp_mb();
-	unregister_die_notifier(&profile_exceptions_nb);
+	unregister_nmi_handler(NMI_LOCAL, "oprofile");
 	msrs = &get_cpu_var(cpu_msrs);
 	model->shutdown(msrs);
 	free_msrs();
diff --git a/arch/x86/oprofile/nmi_timer_int.c b/arch/x86/oprofile/nmi_timer_int.c
index 720bf5a..7f8052c 100644
--- a/arch/x86/oprofile/nmi_timer_int.c
+++ b/arch/x86/oprofile/nmi_timer_int.c
@@ -18,32 +18,16 @@
 #include <asm/apic.h>
 #include <asm/ptrace.h>
 
-static int profile_timer_exceptions_notify(struct notifier_block *self,
-					   unsigned long val, void *data)
+static int profile_timer_exceptions_notify(unsigned int val, struct pt_regs *regs)
 {
-	struct die_args *args = (struct die_args *)data;
-	int ret = NOTIFY_DONE;
-
-	switch (val) {
-	case DIE_NMI:
-		oprofile_add_sample(args->regs, 0);
-		ret = NOTIFY_STOP;
-		break;
-	default:
-		break;
-	}
-	return ret;
+	oprofile_add_sample(regs, 0);
+	return NMI_HANDLED;
 }
 
-static struct notifier_block profile_timer_exceptions_nb = {
-	.notifier_call = profile_timer_exceptions_notify,
-	.next = NULL,
-	.priority = NMI_LOW_PRIOR,
-};
-
 static int timer_start(void)
 {
-	if (register_die_notifier(&profile_timer_exceptions_nb))
+	if (register_nmi_handler(NMI_LOCAL, profile_timer_exceptions_notify,
+					0, "oprofile-timer"))
 		return 1;
 	return 0;
 }
@@ -51,7 +35,7 @@ static int timer_start(void)
 
 static void timer_stop(void)
 {
-	unregister_die_notifier(&profile_timer_exceptions_nb);
+	unregister_nmi_handler(NMI_LOCAL, "oprofile-timer");
 	synchronize_sched();  /* Allow already-started NMIs to complete. */
 }
 
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 0784f99..b8e08cb 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -50,6 +50,7 @@
 #include <acpi/hed.h>
 #include <asm/mce.h>
 #include <asm/tlbflush.h>
+#include <asm/nmi.h>
 
 #include "apei-internal.h"
 
@@ -749,15 +750,11 @@ static void ghes_proc_in_irq(struct irq_work *irq_work)
 	}
 }
 
-static int ghes_notify_nmi(struct notifier_block *this,
-				  unsigned long cmd, void *data)
+static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 {
 	struct ghes *ghes, *ghes_global = NULL;
 	int sev, sev_global = -1;
-	int ret = NOTIFY_DONE;
-
-	if (cmd != DIE_NMI)
-		return ret;
+	int ret = NMI_DONE;
 
 	raw_spin_lock(&ghes_nmi_lock);
 	list_for_each_entry_rcu(ghes, &ghes_nmi, list) {
@@ -770,10 +767,10 @@ static int ghes_notify_nmi(struct notifier_block *this,
 			sev_global = sev;
 			ghes_global = ghes;
 		}
-		ret = NOTIFY_STOP;
+		ret = NMI_HANDLED;
 	}
 
-	if (ret == NOTIFY_DONE)
+	if (ret == NMI_DONE)
 		goto out;
 
 	if (sev_global >= GHES_SEV_PANIC) {
@@ -825,10 +822,6 @@ static struct notifier_block ghes_notifier_sci = {
 	.notifier_call = ghes_notify_sci,
 };
 
-static struct notifier_block ghes_notifier_nmi = {
-	.notifier_call = ghes_notify_nmi,
-};
-
 static unsigned long ghes_esource_prealloc_size(
 	const struct acpi_hest_generic *generic)
 {
@@ -918,7 +911,8 @@ static int __devinit ghes_probe(struct platform_device *ghes_dev)
 		ghes_estatus_pool_expand(len);
 		mutex_lock(&ghes_list_mutex);
 		if (list_empty(&ghes_nmi))
-			register_die_notifier(&ghes_notifier_nmi);
+			register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0,
+						"ghes");
 		list_add_rcu(&ghes->list, &ghes_nmi);
 		mutex_unlock(&ghes_list_mutex);
 		break;
@@ -964,7 +958,7 @@ static int __devexit ghes_remove(struct platform_device *ghes_dev)
 		mutex_lock(&ghes_list_mutex);
 		list_del_rcu(&ghes->list);
 		if (list_empty(&ghes_nmi))
-			unregister_die_notifier(&ghes_notifier_nmi);
+			unregister_nmi_handler(NMI_LOCAL, "ghes");
 		mutex_unlock(&ghes_list_mutex);
 		/*
 		 * To synchronize with NMI handler, ghes can only be
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 3302586..3dcab56 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -1077,17 +1077,8 @@ static void ipmi_unregister_watchdog(int ipmi_intf)
 
 #ifdef HAVE_DIE_NMI
 static int
-ipmi_nmi(struct notifier_block *self, unsigned long val, void *data)
+ipmi_nmi(unsigned int val, struct pt_regs *regs)
 {
-	struct die_args *args = data;
-
-	if (val != DIE_NMIUNKNOWN)
-		return NOTIFY_OK;
-
-	/* Hack, if it's a memory or I/O error, ignore it. */
-	if (args->err & 0xc0)
-		return NOTIFY_OK;
-
 	/*
 	 * If we get here, it's an NMI that's not a memory or I/O
 	 * error.  We can't truly tell if it's from IPMI or not
@@ -1097,15 +1088,15 @@ ipmi_nmi(struct notifier_block *self, unsigned long val, void *data)
 
 	if (testing_nmi) {
 		testing_nmi = 2;
-		return NOTIFY_STOP;
+		return NMI_HANDLED;
 	}
 
 	/* If we are not expecting a timeout, ignore it. */
 	if (ipmi_watchdog_state == WDOG_TIMEOUT_NONE)
-		return NOTIFY_OK;
+		return NMI_DONE;
 
 	if (preaction_val != WDOG_PRETIMEOUT_NMI)
-		return NOTIFY_OK;
+		return NMI_DONE;
 
 	/*
 	 * If no one else handled the NMI, we assume it was the IPMI
@@ -1120,12 +1111,8 @@ ipmi_nmi(struct notifier_block *self, unsigned long val, void *data)
 			panic(PFX "pre-timeout");
 	}
 
-	return NOTIFY_STOP;
+	return NMI_HANDLED;
 }
-
-static struct notifier_block ipmi_nmi_handler = {
-	.notifier_call = ipmi_nmi
-};
 #endif
 
 static int wdog_reboot_handler(struct notifier_block *this,
@@ -1290,7 +1277,8 @@ static void check_parms(void)
 		}
 	}
 	if (do_nmi && !nmi_handler_registered) {
-		rv = register_die_notifier(&ipmi_nmi_handler);
+		rv = register_nmi_handler(NMI_UNKNOWN, ipmi_nmi, 0,
+						"ipmi");
 		if (rv) {
 			printk(KERN_WARNING PFX
 			       "Can't register nmi handler\n");
@@ -1298,7 +1286,7 @@ static void check_parms(void)
 		} else
 			nmi_handler_registered = 1;
 	} else if (!do_nmi && nmi_handler_registered) {
-		unregister_die_notifier(&ipmi_nmi_handler);
+		unregister_nmi_handler(NMI_UNKNOWN, "ipmi");
 		nmi_handler_registered = 0;
 	}
 #endif
@@ -1336,7 +1324,7 @@ static int __init ipmi_wdog_init(void)
 	if (rv) {
 #ifdef HAVE_DIE_NMI
 		if (nmi_handler_registered)
-			unregister_die_notifier(&ipmi_nmi_handler);
+			unregister_nmi_handler(NMI_UNKNOWN, "ipmi");
 #endif
 		atomic_notifier_chain_unregister(&panic_notifier_list,
 						 &wdog_panic_notifier);
@@ -1357,7 +1345,7 @@ static void __exit ipmi_wdog_exit(void)
 
 #ifdef HAVE_DIE_NMI
 	if (nmi_handler_registered)
-		unregister_die_notifier(&ipmi_nmi_handler);
+		unregister_nmi_handler(NMI_UNKNOWN, "ipmi");
 #endif
 
 	atomic_notifier_chain_unregister(&panic_notifier_list,
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 410fba4..e0f6202 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -477,15 +477,12 @@ static int hpwdt_time_left(void)
 /*
  *	NMI Handler
  */
-static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
+static int hpwdt_pretimeout(unsigned int ulReason, struct pt_regs *regs,
 				void *data)
 {
 	unsigned long rom_pl;
 	static int die_nmi_called;
 
-	if (ulReason != DIE_NMIUNKNOWN)
-		goto out;
-
 	if (!hpwdt_nmi_decoding)
 		goto out;
 
@@ -507,7 +504,7 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 		"Management Log for details.\n");
 
 out:
-	return NOTIFY_OK;
+	return NMI_DONE;
 }
 #endif /* CONFIG_HPWDT_NMI_DECODING */
 
@@ -647,13 +644,6 @@ static struct miscdevice hpwdt_miscdev = {
 	.fops = &hpwdt_fops,
 };
 
-#ifdef CONFIG_HPWDT_NMI_DECODING
-static struct notifier_block die_notifier = {
-	.notifier_call = hpwdt_pretimeout,
-	.priority = 0,
-};
-#endif /* CONFIG_HPWDT_NMI_DECODING */
-
 /*
  *	Init & Exit
  */
@@ -739,10 +729,9 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
 	 * die notify list to handle a critical NMI. The default is to
 	 * be last so other users of the NMI signal can function.
 	 */
-	if (priority)
-		die_notifier.priority = 0x7FFFFFFF;
-
-	retval = register_die_notifier(&die_notifier);
+	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout,
+					(priority) ? NMI_HANDLE_FIRST : 0,
+					"hpwdt");
 	if (retval != 0) {
 		dev_warn(&dev->dev,
 			"Unable to register a die notifier (err=%d).\n",
@@ -762,7 +751,7 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
 
 static void hpwdt_exit_nmi_decoding(void)
 {
-	unregister_die_notifier(&die_notifier);
+	unregister_nmi_handler(NMI_UNKNOWN, "hpwdt");
 	if (cru_rom_addr)
 		iounmap(cru_rom_addr);
 }
-- 
1.7.6

