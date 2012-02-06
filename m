Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab2BFUn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 15:43:29 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63043 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab2BFUn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 15:43:27 -0500
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Subject: [RFC] Extend mwait idle to optimize away IPIs when possible
Date: Mon,  6 Feb 2012 12:42:13 -0800
Message-Id: <1328560933-3037-1-git-send-email-venki@google.com>
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
  Run 1  1.51  2.93 95.55
  Run 2  1.48  2.86 95.65
  Run 3  1.46  2.78 95.74
  After
  Run 1  1.35  2.63 96.00
  Run 2  1.46  2.78 95.74
  Run 3  1.37  2.63 95.98

* As a bonus, we can avoid sched/call IPI overhead altogether in a special case.
  When CPU Y has woken up CPU X (which can take 50-100us to actually wakeup
  from a deep idle state) and CPU Z wants to send IPI to CPU X in this period.
  It can get it for free.

We started looking at this with one of our workloads where system is partially
busy and we noticed some kernel hotspots in find_next_bit and
default_send_IPI_mask_sequence_phys coming from sched wakeup (futex wakeups)
and networking call functions. So, this change addresses those two specific
IPI types. This could be extended to nohz_kick, etc.

Note:
* This only helps when target CPU is idle. When it is busy we will still send
  IPI as before.
* Only for X86_64 and mwait_idle_with_hints for now, with limited testing.
* Will need some accounting for these wakeups exported for powertop and friends.

Comments?

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 arch/x86/Kconfig                   |    5 ++++
 arch/x86/include/asm/thread_info.h |    1 +
 arch/x86/kernel/acpi/cstate.c      |   22 ++++++++++++++++
 arch/x86/kernel/process_64.c       |   12 +++++++++
 include/linux/sched.h              |   47 ++++++++++++++++++++++++++++++++++++
 include/linux/thread_info.h        |    2 +
 kernel/sched/core.c                |   40 +++++++++++++++++++++++++++++-
 kernel/smp.c                       |    4 +++
 8 files changed, 132 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e..6a56cb0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -170,6 +170,11 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default X86_64
 
+config AVOID_IPI_ON_IDLE
+	bool
+	depends on X86_64
+	default X86_64
+
 config ARCH_HAS_CPU_RELAX
 	def_bool y
 
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index bc817cd..24e4a56 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -95,6 +95,7 @@ struct thread_info {
 #define TIF_BLOCKSTEP		25	/* set when we want DEBUGCTLMSR_BTF */
 #define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
 #define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
+#define TIF_IPI_PENDING		29	/* pending IPI work on idle exit */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index f50e7fb..340c4e9 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -161,6 +161,14 @@ EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
  */
 void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
+#ifdef CONFIG_AVOID_IPI_ON_IDLE
+	int oldval, cpu = smp_processor_id();
+
+	if (!system_using_cpu_idle_sync)
+		system_using_cpu_idle_sync = 1;
+
+	atomic_set(&per_cpu(cpu_idle_sync, cpu), CPU_STATE_IDLE);
+#endif
 	if (!need_resched()) {
 		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
@@ -170,6 +178,20 @@ void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 		if (!need_resched())
 			__mwait(ax, cx);
 	}
+#ifdef CONFIG_AVOID_IPI_ON_IDLE
+	oldval = atomic_cmpxchg(&per_cpu(cpu_idle_sync, cpu),
+				CPU_STATE_IDLE, CPU_STATE_RUNNING);
+
+	if (oldval != CPU_STATE_IDLE) {
+		oldval = atomic_cmpxchg(&per_cpu(cpu_idle_sync, cpu),
+					CPU_STATE_WOKENUP, CPU_STATE_RUNNING);
+		while (oldval != CPU_STATE_WOKENUP) {
+			rep_nop();
+			oldval = atomic_cmpxchg(&per_cpu(cpu_idle_sync, cpu),
+					CPU_STATE_WOKENUP, CPU_STATE_RUNNING);
+		}
+	}
+#endif
 }
 
 void acpi_processor_ffh_cstate_enter(struct acpi_processor_cx *cx)
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 9b9fe4a..4c6bb4a 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -153,6 +153,18 @@ void cpu_idle(void)
 			   has already called exit_idle. But some idle
 			   loops can be woken up without interrupt. */
 			__exit_idle();
+
+#ifdef CONFIG_AVOID_IPI_ON_IDLE
+			if (ipi_pending()) {
+				clear_ipi_pending();
+				local_bh_disable();
+				local_irq_disable();
+				generic_smp_call_function_single_interrupt();
+				scheduler_wakeup_self_check();
+				local_irq_enable();
+				local_bh_enable();
+			}
+#endif
 		}
 
 		tick_nohz_idle_exit();
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2234985..a612e79 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -249,6 +249,43 @@ extern char ___assert_task_state[1 - 2*!!(
 #include <linux/spinlock.h>
 
 /*
+ * cpu_idle_sync is used to check CPU idle state from remote CPUs. State
+ * transitions go as:
+ * CPU X idle entry
+ * - Prev state CPU_STATE_RUNNING, Next state CPU_STATE_IDLE.
+ * CPU X idle exit
+ * - If Prev state CPU_STATE_IDLE, Next state CPU_STATE_RUNNING
+ * - If Prev state is CPU_STATE_WAKING, wait until state is CPU_STATE_WOKENUP,
+ *   change the state to CPU_STATE_RUNNING and check for pending IPI activity.
+ * - If Prev state is CPU_STATE_WOKENUP, change the state to CPU_STATE_RUNNING
+ *   and check for pending IPI activity.
+ *
+ * CPU Y wants to send IPI to CPU X
+ * - If Prev state is CPU_STATE_RUNNING, send ipi.
+ * - If Prev state is CPU_STATE_IDLE, atomic change to CPU_STATE_WAKING,
+ *   set the flag for pending IPI activity on corresponding idle task and then
+ *   change the state to CPU_STATE_WOKENUP. Continue without IPI.
+ * - If Prev state is CPU_STATE_WAKING or CPU_STATE_WOKENUP, then some CPU Z
+ *   is doing the wakeup of X and Y gets it for free. Continue without IPI.
+ */
+enum cpu_idle_state {
+	CPU_STATE_RUNNING,
+	CPU_STATE_IDLE,
+	CPU_STATE_WAKING,
+	CPU_STATE_WOKENUP
+};
+DECLARE_PER_CPU(atomic_t, cpu_idle_sync);
+extern int system_using_cpu_idle_sync;
+
+#if defined(CONFIG_SMP) && defined(CONFIG_AVOID_IPI_ON_IDLE)
+extern int smp_need_ipi(int cpu);
+extern void scheduler_wakeup_self_check(void);
+#else
+static inline int smp_need_ipi(int cpu) { return 1; }
+static inline void scheduler_wakeup_self_check(void) { }
+#endif
+
+/*
  * This serializes "schedule()" and also protects
  * the run-queue from deletions/modifications (but
  * _adding_ to the beginning of the run-queue has
@@ -2574,6 +2611,16 @@ static inline int need_resched(void)
 	return unlikely(test_thread_flag(TIF_NEED_RESCHED));
 }
 
+static inline void set_tsk_ipi_pending(struct task_struct *tsk)
+{
+	set_tsk_thread_flag(tsk, TIF_IPI_PENDING);
+}
+
+static inline int ipi_pending(void)
+{
+	return unlikely(test_thread_flag(TIF_IPI_PENDING));
+}
+
 /*
  * cond_resched() and cond_resched_lock(): latency reduction via
  * explicit rescheduling in places that are safe. The return
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 8d03f07..9a458e2 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -98,6 +98,8 @@ static inline int test_ti_thread_flag(struct thread_info *ti, int flag)
 #define set_need_resched()	set_thread_flag(TIF_NEED_RESCHED)
 #define clear_need_resched()	clear_thread_flag(TIF_NEED_RESCHED)
 
+#define clear_ipi_pending()	clear_thread_flag(TIF_IPI_PENDING)
+
 #if defined TIF_RESTORE_SIGMASK && !defined HAVE_SET_RESTORE_SIGMASK
 /*
  * An arch can define its own version of set_restore_sigmask() to get the
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index df00cb0..14c9fc8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -492,6 +492,9 @@ static inline void init_hrtick(void)
 }
 #endif	/* CONFIG_SCHED_HRTICK */
 
+DEFINE_PER_CPU(atomic_t, cpu_idle_sync);
+__read_mostly int system_using_cpu_idle_sync;
+
 /*
  * resched_task - mark a task 'to be rescheduled now'.
  *
@@ -505,6 +508,29 @@ static inline void init_hrtick(void)
 #define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
 #endif
 
+#ifdef CONFIG_AVOID_IPI_ON_IDLE
+int smp_need_ipi(int cpu)
+{
+	int oldval;
+
+	if (!system_using_cpu_idle_sync || cpu == smp_processor_id())
+		return 1;
+
+	oldval = atomic_cmpxchg(&per_cpu(cpu_idle_sync, cpu),
+				CPU_STATE_IDLE, CPU_STATE_WAKING);
+
+	if (oldval == CPU_STATE_RUNNING)
+		return 1;
+
+	if (oldval == CPU_STATE_IDLE) {
+		set_tsk_ipi_pending(idle_task(cpu));
+		atomic_set(&per_cpu(cpu_idle_sync, cpu), CPU_STATE_WOKENUP);
+	}
+
+	return 0;
+}
+#endif
+
 void resched_task(struct task_struct *p)
 {
 	int cpu;
@@ -1456,6 +1482,16 @@ static void sched_ttwu_pending(void)
 	raw_spin_unlock(&rq->lock);
 }
 
+#ifdef CONFIG_AVOID_IPI_ON_IDLE
+void scheduler_wakeup_self_check(void)
+{
+	if (llist_empty(&this_rq()->wake_list))
+		return;
+
+	sched_ttwu_pending();
+}
+#endif
+
 void scheduler_ipi(void)
 {
 	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick())
@@ -1490,7 +1526,8 @@ void scheduler_ipi(void)
 static void ttwu_queue_remote(struct task_struct *p, int cpu)
 {
 	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
-		smp_send_reschedule(cpu);
+		if (smp_need_ipi(cpu))
+			smp_send_reschedule(cpu);
 }
 
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
@@ -6943,6 +6980,7 @@ void __init sched_init(void)
 #endif
 		init_rq_hrtick(rq);
 		atomic_set(&rq->nr_iowait, 0);
+		atomic_set(&per_cpu(cpu_idle_sync, i), CPU_STATE_RUNNING);
 	}
 
 	set_load_weight(&init_task);
diff --git a/kernel/smp.c b/kernel/smp.c
index db197d6..48a9c4a 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/percpu.h>
+#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/gfp.h>
 #include <linux/smp.h>
@@ -145,6 +146,9 @@ void generic_exec_single(int cpu, struct call_single_data *data, int wait)
 	list_add_tail(&data->list, &dst->list);
 	raw_spin_unlock_irqrestore(&dst->lock, flags);
 
+	if (ipi)
+		ipi = smp_need_ipi(cpu);
+
 	/*
 	 * The list addition should be visible before sending the IPI
 	 * handler locks the list to pull the entry off it because of
-- 
1.7.7.3

