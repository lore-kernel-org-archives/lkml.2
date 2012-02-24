Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab2BXWeC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 17:34:02 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64757 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371Ab2BXWd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:33:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of venki@google.com designates 10.68.211.202 as permitted sender) smtp.mail=venki@google.com; dkim=pass header.i=venki@google.com
MIME-Version: 1.0
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        Yong Zhang <yong.zhang0@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 2/4] x86: Mwait idle optimization to avoid CAL+RES IPIs -v2
Date: Fri, 24 Feb 2012 14:33:18 -0800
Message-Id: <1330122800-834-3-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1330122800-834-1-git-send-email-venki@google.com>
References: <1330122800-834-1-git-send-email-venki@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smp_call_function_single and ttwu_queue_remote sends unconditional IPI
to target CPU. However, if the target CPU is in some form of poll based idle,
we can do IPI-less wakeups.
Doing this has certain advantages:
* Lower overhead on Async IPI send path. Measurements on Westmere based
  systems show savings on "no wait" smp_call_function_single with idle
  target CPU (as measured on the sender side).
  local socket smp_call_func cost goes from ~1600 to ~1100 cycles
  remote socket smp_call_func cost goes from ~2000 to ~1800 cycles
* Avoiding actual interrupts shows a measurable reduction (10%) in system
  non-idle cycles and cache-references with micro-benchmark sending IPI from
  one CPU to all the other mostly idle CPUs in the system.
* On a mostly idle system, turbostat shows a tiny decrease in C0(active) time
  and a corresponding increase in C6 state (Each row being 10min avg)
          %c0   %c1   %c6
  Before
  Run 1  1.51  2.93 95.55
  Run 2  1.48  2.86 95.65
  Run 3  1.46  2.78 95.74
  After
  Run 1  1.35  2.63 96.00
  Run 2  1.46  2.78 95.74
  Run 3  1.37  2.63 95.98

We started looking at this with one of our workloads where system is partially
busy and we noticed some kernel hotspots in find_next_bit and
default_send_IPI_mask_sequence_phys coming from sched wakeup (futex wakeups)
and networking call functions.

Thanks to Suresh for the suggestion of using TIF flags instead of
having a new percpu state variable and complicated update logic.

Notes:
* This only helps when target CPU is idle. When it is busy we will still send
  IPI as before.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 arch/x86/include/asm/ipiless_wake.h |   84 +++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/thread_info.h  |    3 +
 arch/x86/kernel/acpi/cstate.c       |    7 ++-
 arch/x86/kernel/process_32.c        |    2 +
 arch/x86/kernel/process_64.c        |    2 +
 arch/x86/kernel/smp.c               |    8 +++
 6 files changed, 104 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/ipiless_wake.h

diff --git a/arch/x86/include/asm/ipiless_wake.h b/arch/x86/include/asm/ipiless_wake.h
new file mode 100644
index 0000000..a490dd3
--- /dev/null
+++ b/arch/x86/include/asm/ipiless_wake.h
@@ -0,0 +1,84 @@
+#ifndef _ASM_X86_IPILESS_WAKE_H
+#define _ASM_X86_IPILESS_WAKE_H
+
+#include <linux/hardirq.h>
+#include <linux/sched.h>
+#include <asm/thread_info.h>
+
+#ifdef CONFIG_SMP
+
+/*
+ * TIF_IN_IPILESS_IDLE CPU being in a idle state with ipiless wakeup
+ * capability, without any pending IPIs.
+ * It is conditionally reset by an IPI source CPU and the reset automatically
+ * brings the target CPU out of its idle state.
+ *
+ * TS_IPILESS_WAKEUP is only changed by local CPU and is a place to store
+ * the info that there is a pending IPI work needed after complete idle exit.
+ */
+
+static inline void enter_ipiless_idle(void)
+{
+	set_thread_flag(TIF_IN_IPILESS_IDLE);
+}
+
+static inline void exit_ipiless_idle(void)
+{
+	if (!test_and_clear_thread_flag(TIF_IN_IPILESS_IDLE)) {
+		/*
+		 * Flag was already cleared, indicating that there is
+		 * a pending IPIless wakeup.
+		 * Save that info in status for later use.
+		 */
+		current_thread_info()->status |= TS_IPILESS_WAKEUP;
+	}
+}
+
+static inline int is_ipiless_wakeup_pending(void)
+{
+	return need_resched() ||
+		unlikely(!test_thread_flag(TIF_IN_IPILESS_IDLE));
+}
+
+static inline void do_ipiless_pending_work(void)
+{
+	if (unlikely(current_thread_info()->status & TS_IPILESS_WAKEUP)) {
+		current_thread_info()->status &= ~TS_IPILESS_WAKEUP;
+
+		local_bh_disable();
+		local_irq_disable();
+
+		irq_enter();
+		generic_smp_call_function_single_interrupt();
+		irq_exit();
+
+		scheduler_ipi(); /* Does its own irq enter/exit */
+
+		local_irq_enable();
+		local_bh_enable(); /* Needed for bh handling */
+	}
+}
+
+static inline int try_ipiless_wakeup(int cpu)
+{
+	struct thread_info *idle_ti = task_thread_info(idle_task(cpu));
+
+	if (!(idle_ti->flags & _TIF_IN_IPILESS_IDLE))
+		return 0;
+
+	return test_and_clear_bit(TIF_IN_IPILESS_IDLE,
+					(unsigned long *)&idle_ti->flags);
+}
+
+#else
+static inline void do_ipiless_pending_work(void) { }
+static inline void enter_ipiless_idle(void) { }
+static inline void exit_ipiless_idle(void) { }
+
+static inline int is_ipiless_wakeup_pending(void)
+{
+	return need_resched();
+}
+#endif
+
+#endif /* _ASM_X86_IPILESS_WAKE_H */
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index a4d3888..3c5ae3b 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -96,6 +96,7 @@ struct thread_info {
 #define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
 #define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
 #define TIF_POLLING_NRFLAG	29	/* true if poll_idle() is polling TIF_NEED_RESCHED */
+#define TIF_IN_IPILESS_IDLE	30	/* Task in IPIless idle state */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -118,6 +119,7 @@ struct thread_info {
 #define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
+#define _TIF_IN_IPILESS_IDLE	(1 << TIF_IN_IPILESS_IDLE)
 
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
@@ -253,6 +255,7 @@ static inline struct thread_info *current_thread_info(void)
 					   this quantum (SMP) */
 #define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
 #define TS_RESTORE_SIGMASK	0x0004	/* restore signal mask in do_signal() */
+#define TS_IPILESS_WAKEUP	0x0008	/* pending IPI-work on idle exit */
 
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index f50e7fb..30ab435 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -12,6 +12,7 @@
 #include <linux/sched.h>
 
 #include <acpi/processor.h>
+#include <asm/ipiless_wake.h>
 #include <asm/acpi.h>
 #include <asm/mwait.h>
 
@@ -161,15 +162,17 @@ EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
  */
 void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
-	if (!need_resched()) {
+	enter_ipiless_idle();
+	if (!is_ipiless_wakeup_pending()) {
 		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
-		if (!need_resched())
+		if (!is_ipiless_wakeup_pending())
 			__mwait(ax, cx);
 	}
+	exit_ipiless_idle();
 }
 
 void acpi_processor_ffh_cstate_enter(struct acpi_processor_cx *cx)
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 5de6bb1..014e26d 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -44,6 +44,7 @@
 #include <asm/system.h>
 #include <asm/ldt.h>
 #include <asm/processor.h>
+#include <asm/ipiless_wake.h>
 #include <asm/i387.h>
 #include <asm/desc.h>
 #ifdef CONFIG_MATH_EMULATION
@@ -116,6 +117,7 @@ void cpu_idle(void)
 			if (cpuidle_idle_call())
 				pm_idle();
 			start_critical_timings();
+			do_ipiless_pending_work();
 		}
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 98b1854..777bb7d 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -42,6 +42,7 @@
 #include <asm/pgtable.h>
 #include <asm/system.h>
 #include <asm/processor.h>
+#include <asm/ipiless_wake.h>
 #include <asm/i387.h>
 #include <asm/mmu_context.h>
 #include <asm/prctl.h>
@@ -148,6 +149,7 @@ void cpu_idle(void)
 
 			rcu_idle_exit();
 			start_critical_timings();
+			do_ipiless_pending_work();
 
 			/* In many cases the interrupt that ended idle
 			   has already called exit_idle. But some idle
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 66c74f4..4b44bef 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -27,6 +27,7 @@
 #include <asm/mtrr.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
+#include <asm/ipiless_wake.h>
 #include <asm/proto.h>
 #include <asm/apic.h>
 #include <asm/nmi.h>
@@ -120,11 +121,18 @@ static void native_smp_send_reschedule(int cpu)
 		WARN_ON(1);
 		return;
 	}
+
+	if (try_ipiless_wakeup(cpu))
+		return;
+
 	apic->send_IPI_mask(cpumask_of(cpu), RESCHEDULE_VECTOR);
 }
 
 void native_send_call_func_single_ipi(int cpu)
 {
+	if (try_ipiless_wakeup(cpu))
+		return;
+
 	apic->send_IPI_mask(cpumask_of(cpu), CALL_FUNCTION_SINGLE_VECTOR);
 }
 
-- 
1.7.7.3

