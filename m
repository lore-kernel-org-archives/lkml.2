Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab2BWAhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 19:37:12 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39113 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab2BWAhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 19:37:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of venki@google.com designates 10.68.216.170 as permitted sender) smtp.mail=venki@google.com; dkim=pass header.i=venki@google.com
MIME-Version: 1.0
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] Extend mwait idle to optimize away CAL and RES interrupts to an idle CPU -v1
Date: Wed, 22 Feb 2012 16:36:55 -0800
Message-Id: <1329957415-15239-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smp_call_function_single and ttwu_queue_remote sends unconditional IPI
to target CPU. However, if the target CPU is in mwait based idle, we can
do IPI-less wakeups using the magical powers of monitor-mwait.
Doing this has certain advantages:
* Lower overhead on Async IPI send path. Measurements on Westmere based
  systems show savings on "no wait" smp_call_function_single with idle
  target CPU (as measured on the sender side).
  local socket smp_call_func cost goes from ~1600 to ~1200 cycles
  remote socket smp_call_func cost goes from ~2000 to ~1800 cycles
* Avoiding actual interrupts shows a measurable reduction (10%) in system
  non-idle cycles and cache-references with micro-benchmark sending IPI from
  one CPU to all the other mostly idle CPUs in the system.
* On a mostly idle system, turbostat shows a tiny decrease in C0(active) time
  and a corresponding increase in C6 state (Each row being 10min avg)
          %c0   %c1   %c6
  Before
  Run 1  1.49  2.88 95.63
  Run 2  1.48  2.89 95.63
  Run 3  1.50  2.91 95.59
  After
  Run 1  1.28  2.38 96.33
  Run 2  1.30  2.44 96.26
  Run 3  1.31  2.45 96.24

* As a bonus, we can avoid sched/call IPI overhead altogether in a special case.
  When CPU Y has woken up CPU X (which can take 50-100us to actually wakeup
  from a deep idle state) and CPU Z wants to send IPI to CPU X in this period.
  It can get it for free.

We started looking at this with one of our workloads where system is partially
busy and we noticed some kernel hotspots in find_next_bit and
default_send_IPI_mask_sequence_phys coming from sched wakeup (futex wakeups)
and networking call functions.

Thanks to Suresh for the suggestion of using TIF flags instead of
having a new percpu state variable and complicated update logic.

Notes:
* This only helps when target CPU is idle. When it is busy we will still send
  IPI as before.
* Do we need some accounting for these wakeups exported for powertop?
* We can also eliminate TS_POLLING flag in favor of this. But, that will have
  a lot more touchpoints and better done as a standlone change.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---

Changes since previous versions:
* RFC https://lkml.org/lkml/2012/2/6/357
  Moved the changes into arch specific code as per PeterZ suggestion
  Got rid of new per cpu state logic in favor of TIF flag bits

 arch/x86/include/asm/ipiless_poke.h |   82 +++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/thread_info.h  |    4 ++
 arch/x86/kernel/acpi/cstate.c       |    7 ++-
 arch/x86/kernel/process_32.c        |    2 +
 arch/x86/kernel/process_64.c        |    2 +
 arch/x86/kernel/smp.c               |   16 +++++++
 include/linux/sched.h               |    2 +
 kernel/sched/core.c                 |   13 ++++++
 8 files changed, 126 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/ipiless_poke.h

diff --git a/arch/x86/include/asm/ipiless_poke.h b/arch/x86/include/asm/ipiless_poke.h
new file mode 100644
index 0000000..58670c7
--- /dev/null
+++ b/arch/x86/include/asm/ipiless_poke.h
@@ -0,0 +1,82 @@
+#ifndef _ASM_X86_IPILESS_POKE_H
+#define _ASM_X86_IPILESS_POKE_H
+
+#include <linux/sched.h>
+#include <asm/thread_info.h>
+
+#ifdef CONFIG_SMP
+
+DECLARE_PER_CPU(atomic_t *, idle_task_ti_flags);
+
+/*
+ * Use 2 bits in idle_task's thead info flags:
+ * TIF_IPILESS_IDLE marks enter to and exit from idle states with ipiless
+ * wakeup capability.
+ * TIF_IPI_PENDING set by IPI source CPU if it finds that the IPI target CPU
+ * is in TIF_IPILESS_IDLE state (and TIF_IPI_PENDING is not already set).
+ * Setting of TIF_IPI_PENDING bit brings the target CPU out of idle state.
+ */
+
+static inline void ipiless_idle_enter(void)
+{
+	set_thread_flag(TIF_IPILESS_IDLE);
+}
+
+static inline void ipiless_idle_exit(void)
+{
+	clear_thread_flag(TIF_IPILESS_IDLE);
+}
+
+static inline int is_ipi_pending(void)
+{
+	return unlikely(test_thread_flag(TIF_IPI_PENDING));
+}
+
+static inline int need_wakeup(void)
+{
+	return need_resched() || is_ipi_pending();
+}
+
+static inline void ipiless_pending_work(void)
+{
+	if (is_ipi_pending()) {
+		clear_thread_flag(TIF_IPI_PENDING);
+		local_bh_disable();
+		local_irq_disable();
+		generic_smp_call_function_single_interrupt();
+		__scheduler_ipi();
+		local_irq_enable();
+		local_bh_enable();
+	}
+}
+
+static inline int ipiless_magic_poke(int cpu)
+{
+	int val;
+	atomic_t *idle_flag = per_cpu(idle_task_ti_flags, cpu);
+
+	val = atomic_read(idle_flag);
+	if (unlikely(val & _TIF_IPI_PENDING))
+		return 1;
+
+	if (!(val & _TIF_IPILESS_IDLE))
+		return 0;
+
+	if (val == atomic_cmpxchg(idle_flag, val, val | _TIF_IPI_PENDING))
+		return 1;
+
+	return 0;
+}
+
+#else
+static inline void ipiless_pending_work(void) { }
+static inline void ipiless_idle_enter(void) { }
+static inline void ipiless_idle_exit(void) { }
+
+static inline int need_wakeup(void)
+{
+	return need_resched();
+}
+#endif
+
+#endif /* _ASM_X86_IPILESS_POKE_H */
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index bc817cd..f5cd1b8 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -95,6 +95,8 @@ struct thread_info {
 #define TIF_BLOCKSTEP		25	/* set when we want DEBUGCTLMSR_BTF */
 #define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
 #define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
+#define TIF_IPILESS_IDLE	29	/* IPIless idle bit */
+#define TIF_IPI_PENDING		30	/* IPI pending on the CPU */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -116,6 +118,8 @@ struct thread_info {
 #define _TIF_BLOCKSTEP		(1 << TIF_BLOCKSTEP)
 #define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
+#define _TIF_IPILESS_IDLE	(1 << TIF_IPILESS_IDLE)
+#define _TIF_IPI_PENDING	(1 << TIF_IPI_PENDING)
 
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index f50e7fb..50833ed 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -14,6 +14,7 @@
 #include <acpi/processor.h>
 #include <asm/acpi.h>
 #include <asm/mwait.h>
+#include <asm/ipiless_poke.h>
 
 /*
  * Initialize bm_flags based on the CPU cache properties
@@ -161,15 +162,17 @@ EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
  */
 void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
-	if (!need_resched()) {
+	ipiless_idle_enter();
+	if (!need_wakeup()) {
 		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
-		if (!need_resched())
+		if (!need_wakeup())
 			__mwait(ax, cx);
 	}
+	ipiless_idle_exit();
 }
 
 void acpi_processor_ffh_cstate_enter(struct acpi_processor_cx *cx)
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 324cd72..a963e98 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -44,6 +44,7 @@
 #include <asm/system.h>
 #include <asm/ldt.h>
 #include <asm/processor.h>
+#include <asm/ipiless_poke.h>
 #include <asm/i387.h>
 #include <asm/desc.h>
 #ifdef CONFIG_MATH_EMULATION
@@ -116,6 +117,7 @@ void cpu_idle(void)
 			if (cpuidle_idle_call())
 				pm_idle();
 			start_critical_timings();
+			ipiless_pending_work();
 		}
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 753e803..93b2e5f 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -44,6 +44,7 @@
 #include <asm/processor.h>
 #include <asm/i387.h>
 #include <asm/mmu_context.h>
+#include <asm/ipiless_poke.h>
 #include <asm/prctl.h>
 #include <asm/desc.h>
 #include <asm/proto.h>
@@ -153,6 +154,7 @@ void cpu_idle(void)
 			   has already called exit_idle. But some idle
 			   loops can be woken up without interrupt. */
 			__exit_idle();
+			ipiless_pending_work();
 		}
 
 		tick_nohz_idle_exit();
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index a8ff227..e66a4c8 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -27,6 +27,7 @@
 #include <asm/mtrr.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
+#include <asm/ipiless_poke.h>
 #include <asm/proto.h>
 #include <asm/apic.h>
 #include <asm/nmi.h>
@@ -109,6 +110,14 @@
  *	about nothing of note with C stepping upwards.
  */
 
+DEFINE_PER_CPU(atomic_t *, idle_task_ti_flags);
+
+void __cpuinit thread_idle_state_setup(struct task_struct *idle, int cpu)
+{
+	per_cpu(idle_task_ti_flags, cpu) =
+				(atomic_t *)(&(task_thread_info(idle)->flags));
+}
+
 /*
  * this function sends a 'reschedule' IPI to another CPU.
  * it goes straight through and wastes no time serializing
@@ -120,11 +129,18 @@ static void native_smp_send_reschedule(int cpu)
 		WARN_ON(1);
 		return;
 	}
+
+	if (ipiless_magic_poke(cpu))
+		return;
+
 	apic->send_IPI_mask(cpumask_of(cpu), RESCHEDULE_VECTOR);
 }
 
 void native_send_call_func_single_ipi(int cpu)
 {
+	if (ipiless_magic_poke(cpu))
+		return;
+
 	apic->send_IPI_mask(cpumask_of(cpu), CALL_FUNCTION_SINGLE_VECTOR);
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7d379a6..e07ca62 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2298,9 +2298,11 @@ extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
 void scheduler_ipi(void);
+void __scheduler_ipi(void);
 extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
 #else
 static inline void scheduler_ipi(void) { }
+static inline void __scheduler_ipi(void) { }
 static inline unsigned long wait_task_inactive(struct task_struct *p,
 					       long match_state)
 {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5255c9d..1558316 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1451,6 +1451,14 @@ static void sched_ttwu_pending(void)
 	raw_spin_unlock(&rq->lock);
 }
 
+void __scheduler_ipi(void)
+{
+	if (llist_empty(&this_rq()->wake_list))
+		return;
+
+	sched_ttwu_pending();
+}
+
 void scheduler_ipi(void)
 {
 	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick())
@@ -4827,6 +4835,10 @@ void __cpuinit init_idle_bootup_task(struct task_struct *idle)
 	idle->sched_class = &idle_sched_class;
 }
 
+void __cpuinit __weak thread_idle_state_setup(struct task_struct *idle, int cpu)
+{
+}
+
 /**
  * init_idle - set up an idle thread for a given CPU
  * @idle: task in question
@@ -4869,6 +4881,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 
 	/* Set the preempt count _outside_ the spinlocks! */
 	task_thread_info(idle)->preempt_count = 0;
+	thread_idle_state_setup(idle, cpu);
 
 	/*
 	 * The idle tasks have their own, simple scheduling class:
-- 
1.7.7.3

