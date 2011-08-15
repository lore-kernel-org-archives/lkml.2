Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab1HOP4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:56:14 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58289 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab1HOPyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:54:02 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [PATCH 24/32] nohz/cpuset: Handle kernel entry/exit to account cputime
Date: Mon, 15 Aug 2011 17:52:21 +0200
Message-Id: <1313423549-27093-25-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a few APIs that archs can call to tell they are entering
or exiting the kernel so that when we are in nohz adaptive mode
we know precisely where we need to account the cputime.

The new APIs are:

- tick_nohz_enter_kernel() (called when we enter a syscall)
- tick_nohz_exit_kernel() (called when we exit a syscall)
- tick_nohz_enter_exception() (called when we enter any
  exception, trap, faults...but not irqs)
- tick_nohz_exit_exception() (called when we exit any exception)

Hooks into syscalls are typically driven by the TIF_NOHZ thread
flag.

In addition, we use the value returned by user_mode(regs) from
the timer interrupt to know where we are.
Nonetheless, we can rely on user_mode(regs) != 0 to know
we are in userspace, but we can't rely on user_mode(regs) == 0
to know we are in the system.

Consider the following scenario: we stop the tick after syscall
return, so we set TIF_NOHZ but the syscall exit hook is behind us.
If we haven't yet returned to userspace, then we have
user_mode(regs) == 0. If on top of that we consider we are in
system mode, and later we issue a syscall but restart the tick
right before reaching the syscall entry hook, then we have no clue
that the whole elapsed cputime was not in the system but in the
userspace.

The only way to fix this is to only start entering nohz mode once
we know we are in userspace a first time, like when we reach the
kernel exit hook or when a timer tick with user_mode(regs) == 1
fires. Kernel threads don't have this worry.

This sucks but for now I have no better solution. Let's hope we
can find better.

TODO: wrap operation on jiffies?

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E . McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 include/linux/tick.h     |    8 +++
 kernel/sched.c           |    1 +
 kernel/time/tick-sched.c |  114 ++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 109 insertions(+), 14 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index ea6dfb7..3ad649f 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -139,10 +139,18 @@ extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 #ifdef CONFIG_CPUSETS_NO_HZ
 DECLARE_PER_CPU(int, task_nohz_mode);
 
+extern void tick_nohz_enter_kernel(void);
+extern void tick_nohz_exit_kernel(void);
+extern void tick_nohz_enter_exception(struct pt_regs *regs);
+extern void tick_nohz_exit_exception(struct pt_regs *regs);
 extern int tick_nohz_adaptive_mode(void);
 extern bool tick_nohz_account_tick(void);
 extern void tick_nohz_flush_current_times(void);
 #else /* !CPUSETS_NO_HZ */
+static inline void tick_nohz_enter_kernel(void) { }
+static inline void tick_nohz_exit_kernel(void) { }
+static inline void tick_nohz_enter_exception(struct pt_regs *regs) { }
+static inline void tick_nohz_exit_exception(struct pt_regs *regs) { }
 static inline int tick_nohz_adaptive_mode(void) { return 0; }
 static inline bool tick_nohz_account_tick(void) { return false; }
 #endif /* CPUSETS_NO_HZ */
diff --git a/kernel/sched.c b/kernel/sched.c
index a58f993..c49c1b1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2503,6 +2503,7 @@ static void cpuset_nohz_restart_tick(void)
 	tick_nohz_flush_current_times();
 	__get_cpu_var(task_nohz_mode) = 0;
 	tick_nohz_restart_sched_tick();
+	clear_thread_flag(TIF_NOHZ);
 }
 
 void cpuset_update_nohz(void)
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index c3a8f26..d8f01b8 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -595,8 +595,9 @@ void tick_nohz_irq_exit(void)
 	if (ts->inidle && !need_resched())
 		__tick_nohz_enter_idle(ts, cpu);
 	else if (tick_nohz_adaptive_mode() && !idle_cpu(cpu)) {
-		if (tick_nohz_can_stop_tick(cpu, ts))
-			tick_nohz_stop_sched_tick(ktime_get(), cpu, ts);
+		if (ts->saved_jiffies_whence != JIFFIES_SAVED_NONE
+		    && tick_nohz_can_stop_tick(cpu, ts))
+				tick_nohz_stop_sched_tick(ktime_get(), cpu, ts);
 	}
 }
 
@@ -757,6 +758,74 @@ void tick_check_idle(int cpu)
 
 #ifdef CONFIG_CPUSETS_NO_HZ
 
+void tick_nohz_exit_kernel(void)
+{
+	unsigned long flags;
+	struct tick_sched *ts;
+	unsigned long delta_jiffies;
+
+	local_irq_save(flags);
+
+	if (!tick_nohz_adaptive_mode()) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	ts = &__get_cpu_var(tick_cpu_sched);
+
+	WARN_ON_ONCE(ts->saved_jiffies_whence == JIFFIES_SAVED_USER);
+
+	if (ts->saved_jiffies_whence == JIFFIES_SAVED_SYS) {
+		delta_jiffies = jiffies - ts->saved_jiffies;
+		account_system_jiffies(current, delta_jiffies);
+	}
+
+	ts->saved_jiffies = jiffies;
+	ts->saved_jiffies_whence = JIFFIES_SAVED_USER;
+
+	local_irq_restore(flags);
+}
+
+void tick_nohz_enter_kernel(void)
+{
+	unsigned long flags;
+	struct tick_sched *ts;
+	unsigned long delta_jiffies;
+
+	local_irq_save(flags);
+
+	if (!tick_nohz_adaptive_mode()) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	ts = &__get_cpu_var(tick_cpu_sched);
+
+	WARN_ON_ONCE(ts->saved_jiffies_whence == JIFFIES_SAVED_SYS);
+
+	if (ts->saved_jiffies_whence == JIFFIES_SAVED_USER) {
+		delta_jiffies = jiffies - ts->saved_jiffies;
+		account_user_jiffies(current, delta_jiffies);
+	}
+
+	ts->saved_jiffies = jiffies;
+	ts->saved_jiffies_whence = JIFFIES_SAVED_SYS;
+
+	local_irq_restore(flags);
+}
+
+void tick_nohz_enter_exception(struct pt_regs *regs)
+{
+	if (user_mode(regs))
+		tick_nohz_enter_kernel();
+}
+
+void tick_nohz_exit_exception(struct pt_regs *regs)
+{
+	if (user_mode(regs))
+		tick_nohz_exit_kernel();
+}
+
 int tick_nohz_adaptive_mode(void)
 {
 	return __get_cpu_var(task_nohz_mode);
@@ -766,20 +835,33 @@ static void tick_nohz_cpuset_stop_tick(int user)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 
-	if (!cpuset_adaptive_nohz() || tick_nohz_adaptive_mode())
+	if (!cpuset_adaptive_nohz())
 		return;
 
+	if (tick_nohz_adaptive_mode()) {
+		if (user && ts->saved_jiffies_whence == JIFFIES_SAVED_NONE) {
+			ts->saved_jiffies_whence = JIFFIES_SAVED_USER;
+			ts->saved_jiffies = jiffies;
+		}
+
+		return;
+	}
+
 	if (cpuset_nohz_can_stop_tick()) {
 		__get_cpu_var(task_nohz_mode) = 1;
 		/* Nohz mode must be visible to wake_up_nohz_cpu() */
 		smp_wmb();
 
+		set_thread_flag(TIF_NOHZ);
 		WARN_ON_ONCE(ts->saved_jiffies_whence != JIFFIES_SAVED_NONE);
-		ts->saved_jiffies = jiffies;
-		if (user)
+
+		if (user) {
 			ts->saved_jiffies_whence = JIFFIES_SAVED_USER;
-		else
+			ts->saved_jiffies = jiffies;
+		} else if (!current->mm) {
 			ts->saved_jiffies_whence = JIFFIES_SAVED_SYS;
+			ts->saved_jiffies = jiffies;
+		}
 	}
 }
 
@@ -803,7 +885,7 @@ static void tick_do_timer_check_handler(int cpu)
 
 bool tick_nohz_account_tick(void)
 {
-	struct tick_sched *ts;
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	unsigned long delta_jiffies;
 
 	if (!tick_nohz_adaptive_mode())
@@ -811,11 +893,15 @@ bool tick_nohz_account_tick(void)
 
 	ts = &__get_cpu_var(tick_cpu_sched);
 
+	if (ts->saved_jiffies_whence == JIFFIES_SAVED_NONE)
+		return false;
+
 	delta_jiffies = jiffies - ts->saved_jiffies;
-	if (ts->saved_jiffies_whence == JIFFIES_SAVED_SYS)
-		account_system_jiffies(current, delta_jiffies);
-	else
+
+	if (ts->saved_jiffies_whence == JIFFIES_SAVED_USER)
 		account_user_jiffies(current, delta_jiffies);
+	else
+		account_system_jiffies(current, delta_jiffies);
 
 	ts->saved_jiffies = jiffies;
 
@@ -825,12 +911,12 @@ bool tick_nohz_account_tick(void)
 void tick_nohz_flush_current_times(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	unsigned long delta_jiffies;
+	struct pt_regs *regs;
 
-	tick_nohz_account_tick();
-
-	ts->saved_jiffies_whence = JIFFIES_SAVED_NONE;
+	if (tick_nohz_account_tick())
+		ts->saved_jiffies_whence = JIFFIES_SAVED_NONE;
 }
-
 #else
 
 static void tick_nohz_cpuset_stop_tick(int user) { }
-- 
1.7.5.4

