Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab2BXWdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 17:33:55 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64757 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371Ab2BXWdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:33:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of venki@google.com designates 10.68.134.41 as permitted sender) smtp.mail=venki@google.com; dkim=pass header.i=venki@google.com
MIME-Version: 1.0
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        Yong Zhang <yong.zhang0@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 1/4] tile, ia64, x86: TS_POLLING cleanup
Date: Fri, 24 Feb 2012 14:33:17 -0800
Message-Id: <1330122800-834-2-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1330122800-834-1-git-send-email-venki@google.com>
References: <1330122800-834-1-git-send-email-venki@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Essentially a revert of commit 495ab9c045e1b0e5c82951b762257fe1c9d81564
dependent commit 0888f06ac99f993df2bb4c479f5b9306dafe154f and
some other subsequent dependent changes.

commit 495ab9c mentions memory traffic potentially caused my atomic
set and clear bit in idle entry exit path. But -
* On most of the recent CPUs, there should not be extra memory traffic due to
lock prefix set and clear from local CPU (as long as var is in cache).
* Most of the recent x86 CPUs use mwait based idle variants which do not
set/clear this bit at all.
* With tickless idle we have lot less number of entry exits into idle and
also we do lot more work along the way compared to when these optimization
was done.

So, reverting these changes now seems to makes sense, cleaniny up the code
and leaving all archs in sync wrt TIF_POLLING_NRFLAG.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 arch/ia64/include/asm/thread_info.h |    5 +----
 arch/ia64/kernel/process.c          |   10 +++-------
 arch/tile/include/asm/thread_info.h |    7 +++----
 arch/tile/kernel/process.c          |   13 ++++---------
 arch/x86/include/asm/thread_info.h  |    8 +++-----
 arch/x86/kernel/apm_32.c            |   12 ++++--------
 arch/x86/kernel/process.c           |   10 +++-------
 arch/x86/kernel/process_32.c        |    2 +-
 arch/x86/kernel/process_64.c        |    2 +-
 drivers/acpi/processor_idle.c       |   34 +++++++++++-----------------------
 kernel/sched/core.c                 |    8 ++------
 11 files changed, 36 insertions(+), 75 deletions(-)

diff --git a/arch/ia64/include/asm/thread_info.h b/arch/ia64/include/asm/thread_info.h
index e054bcc..81cb5bb 100644
--- a/arch/ia64/include/asm/thread_info.h
+++ b/arch/ia64/include/asm/thread_info.h
@@ -133,10 +133,7 @@ struct thread_info {
 /* like TIF_ALLWORK_BITS but sans TIF_SYSCALL_TRACE or TIF_SYSCALL_AUDIT */
 #define TIF_WORK_MASK		(TIF_ALLWORK_MASK&~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT))
 
-#define TS_POLLING		1 	/* true if in idle loop and not sleeping */
-#define TS_RESTORE_SIGMASK	2	/* restore signal mask in do_signal() */
-
-#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
+#define TS_RESTORE_SIGMASK	1	/* restore signal mask in do_signal() */
 
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index 6d33c5c..5929104 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -301,14 +301,10 @@ cpu_idle (void)
 	/* endless idle loop with no priority at all */
 	while (1) {
 		if (can_do_pal_halt) {
-			current_thread_info()->status &= ~TS_POLLING;
-			/*
-			 * TS_POLLING-cleared state must be visible before we
-			 * test NEED_RESCHED:
-			 */
-			smp_mb();
+			clear_thread_flag(TIF_POLLING_NRFLAG);
+			smp_mb__after_clear_bit();
 		} else {
-			current_thread_info()->status |= TS_POLLING;
+			set_thread_flag(TIF_POLLING_NRFLAG);
 		}
 
 		if (!need_resched()) {
diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index bc4f562..1386698 100644
--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -126,6 +126,7 @@ extern void cpu_idle_on_new_stack(struct thread_info *old_ti,
 #define TIF_SECCOMP		6	/* secure computing */
 #define TIF_MEMDIE		7	/* OOM killer at work */
 #define TIF_NOTIFY_RESUME	8	/* callback before returning to user */
+#define TIF_POLLING_NRFLAG	9	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
@@ -136,6 +137,7 @@ extern void cpu_idle_on_new_stack(struct thread_info *old_ti,
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_MEMDIE		(1<<TIF_MEMDIE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
+#define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 
 /* Work to do on any return to user space. */
 #define _TIF_ALLWORK_MASK \
@@ -152,10 +154,7 @@ extern void cpu_idle_on_new_stack(struct thread_info *old_ti,
 #ifdef __tilegx__
 #define TS_COMPAT		0x0001	/* 32-bit compatibility mode */
 #endif
-#define TS_POLLING		0x0004	/* in idle loop but not sleeping */
-#define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal */
-
-#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
+#define TS_RESTORE_SIGMASK	0x0002	/* restore signal mask in do_signal */
 
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 4c1ac6e..8725333 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -72,8 +72,7 @@ void cpu_idle(void)
 {
 	int cpu = smp_processor_id();
 
-
-	current_thread_info()->status |= TS_POLLING;
+	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	if (no_idle_nap) {
 		while (1) {
@@ -93,18 +92,14 @@ void cpu_idle(void)
 
 			local_irq_disable();
 			__get_cpu_var(irq_stat).idle_timestamp = jiffies;
-			current_thread_info()->status &= ~TS_POLLING;
-			/*
-			 * TS_POLLING-cleared state must be visible before we
-			 * test NEED_RESCHED:
-			 */
-			smp_mb();
+			clear_thread_flag(TIF_POLLING_NRFLAG);
+			smp_mb__after_clear_bit();
 
 			if (!need_resched())
 				_cpu_idle();
 			else
 				local_irq_enable();
-			current_thread_info()->status |= TS_POLLING;
+			set_thread_flag(TIF_POLLING_NRFLAG);
 		}
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index bc817cd..a4d3888 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -95,6 +95,7 @@ struct thread_info {
 #define TIF_BLOCKSTEP		25	/* set when we want DEBUGCTLMSR_BTF */
 #define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
 #define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
+#define TIF_POLLING_NRFLAG	29	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -116,6 +117,7 @@ struct thread_info {
 #define _TIF_BLOCKSTEP		(1 << TIF_BLOCKSTEP)
 #define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
+#define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
@@ -250,11 +252,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TS_USEDFPU		0x0001	/* FPU was used by this task
 					   this quantum (SMP) */
 #define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
-#define TS_POLLING		0x0004	/* idle task polling need_resched,
-					   skip sending interrupt */
-#define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
-
-#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
+#define TS_RESTORE_SIGMASK	0x0004	/* restore signal mask in do_signal() */
 
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index f76623c..d3e8b4d 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -822,21 +822,17 @@ static int apm_do_idle(void)
 	int polling;
 	int err = 0;
 
-	polling = !!(current_thread_info()->status & TS_POLLING);
+	polling = test_thread_flag(TIF_POLLING_NRFLAG);
 	if (polling) {
-		current_thread_info()->status &= ~TS_POLLING;
-		/*
-		 * TS_POLLING-cleared state must be visible before we
-		 * test NEED_RESCHED:
-		 */
-		smp_mb();
+		clear_thread_flag(TIF_POLLING_NRFLAG);
+		smp_mb__after_clear_bit();
 	}
 	if (!need_resched()) {
 		idled = 1;
 		ret = apm_bios_call_simple(APM_FUNC_IDLE, 0, 0, &eax, &err);
 	}
 	if (polling)
-		current_thread_info()->status |= TS_POLLING;
+		set_thread_flag(TIF_POLLING_NRFLAG);
 
 	if (!idled)
 		return 0;
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 15763af..99a8109 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -379,18 +379,14 @@ void default_idle(void)
 	if (hlt_use_halt()) {
 		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
 		trace_cpu_idle(1, smp_processor_id());
-		current_thread_info()->status &= ~TS_POLLING;
-		/*
-		 * TS_POLLING-cleared state must be visible before we
-		 * test NEED_RESCHED:
-		 */
-		smp_mb();
+		clear_thread_flag(TIF_POLLING_NRFLAG);
+		smp_mb__after_clear_bit();
 
 		if (!need_resched())
 			safe_halt();	/* enables interrupts racelessly */
 		else
 			local_irq_enable();
-		current_thread_info()->status |= TS_POLLING;
+		set_thread_flag(TIF_POLLING_NRFLAG);
 		trace_power_end(smp_processor_id());
 		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
 	} else {
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 324cd72..5de6bb1 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -95,7 +95,7 @@ void cpu_idle(void)
 	 */
 	boot_init_stack_canary();
 
-	current_thread_info()->status |= TS_POLLING;
+	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	/* endless idle loop with no priority at all */
 	while (1) {
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 753e803..98b1854 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -109,7 +109,7 @@ static inline void play_dead(void)
  */
 void cpu_idle(void)
 {
-	current_thread_info()->status |= TS_POLLING;
+	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	/*
 	 * If we're the non-boot CPU, nothing set the stack canary up
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 0e8e2de..b7a0f0d 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -131,17 +131,13 @@ static struct dmi_system_id __cpuinitdata processor_power_dmi_table[] = {
  */
 static void acpi_safe_halt(void)
 {
-	current_thread_info()->status &= ~TS_POLLING;
-	/*
-	 * TS_POLLING-cleared state must be visible before we
-	 * test NEED_RESCHED:
-	 */
-	smp_mb();
+	clear_thread_flag(TIF_POLLING_NRFLAG);
+	smp_mb__after_clear_bit();
 	if (!need_resched()) {
 		safe_halt();
 		local_irq_disable();
 	}
-	current_thread_info()->status |= TS_POLLING;
+	set_thread_flag(TIF_POLLING_NRFLAG);
 }
 
 #ifdef ARCH_APICTIMER_STOPS_ON_C3
@@ -795,15 +791,11 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 	local_irq_disable();
 
 	if (cx->entry_method != ACPI_CSTATE_FFH) {
-		current_thread_info()->status &= ~TS_POLLING;
-		/*
-		 * TS_POLLING-cleared state must be visible before we test
-		 * NEED_RESCHED:
-		 */
-		smp_mb();
+		clear_thread_flag(TIF_POLLING_NRFLAG);
+		smp_mb__after_clear_bit();
 
 		if (unlikely(need_resched())) {
-			current_thread_info()->status |= TS_POLLING;
+			set_thread_flag(TIF_POLLING_NRFLAG);
 			local_irq_enable();
 			return -EINVAL;
 		}
@@ -835,7 +827,7 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 
 	local_irq_enable();
 	if (cx->entry_method != ACPI_CSTATE_FFH)
-		current_thread_info()->status |= TS_POLLING;
+		set_thread_flag(TIF_POLLING_NRFLAG);
 
 	cx->usage++;
 
@@ -887,15 +879,11 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 	local_irq_disable();
 
 	if (cx->entry_method != ACPI_CSTATE_FFH) {
-		current_thread_info()->status &= ~TS_POLLING;
-		/*
-		 * TS_POLLING-cleared state must be visible before we test
-		 * NEED_RESCHED:
-		 */
-		smp_mb();
+		clear_thread_flag(TIF_POLLING_NRFLAG);
+		smp_mb__after_clear_bit();
 
 		if (unlikely(need_resched())) {
-			current_thread_info()->status |= TS_POLLING;
+			set_thread_flag(TIF_POLLING_NRFLAG);
 			local_irq_enable();
 			return -EINVAL;
 		}
@@ -955,7 +943,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 
 	local_irq_enable();
 	if (cx->entry_method != ACPI_CSTATE_FFH)
-		current_thread_info()->status |= TS_POLLING;
+		set_thread_flag(TIF_POLLING_NRFLAG);
 
 	cx->usage++;
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5255c9d..9809c8b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -502,10 +502,6 @@ static inline void init_hrtick(void)
  */
 #ifdef CONFIG_SMP
 
-#ifndef tsk_is_polling
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-#endif
-
 void resched_task(struct task_struct *p)
 {
 	int cpu;
@@ -523,7 +519,7 @@ void resched_task(struct task_struct *p)
 
 	/* NEED_RESCHED must be visible before we test polling */
 	smp_mb();
-	if (!tsk_is_polling(p))
+	if (!test_tsk_thread_flag(p, TIF_POLLING_NRFLAG))
 		smp_send_reschedule(cpu);
 }
 
@@ -602,7 +598,7 @@ void wake_up_idle_cpu(int cpu)
 
 	/* NEED_RESCHED must be visible before we test polling */
 	smp_mb();
-	if (!tsk_is_polling(rq->idle))
+	if (!test_tsk_thread_flag(rq->idle, TIF_POLLING_NRFLAG))
 		smp_send_reschedule(cpu);
 }
 
-- 
1.7.7.3

