Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab2EAAEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:04:15 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:41691 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680Ab2EAAEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:04:12 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 40/41] nohz: Exit RCU idle mode when we schedule before resuming userspace
Date: Tue,  1 May 2012 01:55:14 +0200
Message-Id: <1335830115-14335-41-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a CPU running tickless resumes userspace, it enters into
RCU idle mode. But if we are preempted on kernel exit, after we
entered RCU idle mode but before we actually resumed userspace,
through an explicit call to schedule, we need to re-enable RCU in
case this function makes use of RCU read side critical section
and also for the next task to be scheduled.

NOTE: If we are preempted while running adaptive tickless, it means
we will receive an IPI that will escape the RCU idle mode for us. So
this patch is useful only when such IPI arrives too late.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/entry_64.S |    8 ++++----
 include/linux/tick.h       |    3 ++-
 kernel/sched/core.c        |   14 ++++++++++++++
 kernel/time/tick-sched.c   |    9 ++++++---
 4 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 54f269c..c86d963 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -522,7 +522,7 @@ sysret_careful:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq_cfi %rdi
-	call schedule
+	call schedule_user
 	popq_cfi %rdi
 	jmp sysret_check
 
@@ -630,7 +630,7 @@ int_careful:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq_cfi %rdi
-	call schedule
+	call schedule_user
 	popq_cfi %rdi
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
@@ -898,7 +898,7 @@ retint_careful:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq_cfi %rdi
-	call  schedule
+	call  schedule_user
 	popq_cfi %rdi
 	GET_THREAD_INFO(%rcx)
 	DISABLE_INTERRUPTS(CLBR_NONE)
@@ -1398,7 +1398,7 @@ paranoid_userspace:
 paranoid_schedule:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_ANY)
-	call schedule
+	call schedule_user
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
 	jmp paranoid_userspace
diff --git a/include/linux/tick.h b/include/linux/tick.h
index e2a49ad..93add37 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -162,7 +162,7 @@ extern void tick_nohz_exit_exception(struct pt_regs *regs);
 extern void tick_nohz_check_adaptive(void);
 extern void tick_nohz_pre_schedule(void);
 extern void tick_nohz_post_schedule(void);
-extern void tick_nohz_cpu_exit_qs(void);
+extern void tick_nohz_cpu_exit_qs(bool irq);
 extern bool tick_nohz_account_tick(void);
 extern void tick_nohz_flush_current_times(bool restart_tick);
 #else /* !CPUSETS_NO_HZ */
@@ -173,6 +173,7 @@ static inline void tick_nohz_exit_exception(struct pt_regs *regs) { }
 static inline void tick_nohz_check_adaptive(void) { }
 static inline void tick_nohz_pre_schedule(void) { }
 static inline void tick_nohz_post_schedule(void) { }
+static inline void tick_nohz_cpu_exit_qs(bool irq) { }
 static inline bool tick_nohz_account_tick(void) { return false; }
 #endif /* CPUSETS_NO_HZ */
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 949158a..c8d3793 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3379,6 +3379,20 @@ int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
 }
 #endif
 
+asmlinkage void __sched schedule_user(void)
+{
+	/*
+	 * We may arrive here before resuming userspace.
+	 * If we are running tickless, RCU may be in idle
+	 * mode. We need to reenable RCU for the next task
+	 * and also in case schedule() make use of RCU itself.
+	 */
+	preempt_disable();
+	tick_nohz_cpu_exit_qs(false);
+	preempt_enable_no_resched();
+	schedule();
+}
+
 #ifdef CONFIG_PREEMPT
 /*
  * this is the entry point to schedule() from in-kernel preemption
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index b15ab5e..586f970 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -964,10 +964,13 @@ void tick_nohz_enter_kernel(void)
 	local_irq_restore(flags);
 }
 
-void tick_nohz_cpu_exit_qs(void)
+void tick_nohz_cpu_exit_qs(bool irq)
 {
 	if (__get_cpu_var(nohz_task_ext_qs)) {
-		rcu_user_exit_irq();
+		if (irq)
+			rcu_user_exit_irq();
+		else
+			rcu_user_exit();
 		__get_cpu_var(nohz_task_ext_qs) = 0;
 	}
 }
@@ -1007,7 +1010,7 @@ static void tick_nohz_restart_adaptive(void)
 	tick_nohz_flush_current_times(true);
 	tick_nohz_restart_sched_tick();
 	clear_thread_flag(TIF_NOHZ);
-	tick_nohz_cpu_exit_qs();
+	tick_nohz_cpu_exit_qs(true);
 }
 
 void tick_nohz_check_adaptive(void)
-- 
1.7.5.4

