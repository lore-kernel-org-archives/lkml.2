Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab2D3X47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 19:56:59 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62757 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab2D3X44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 19:56:56 -0400
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
Subject: [PATCH 19/41] nohz/cpuset: Account user and system times in adaptive nohz mode
Date: Tue,  1 May 2012 01:54:53 +0200
Message-Id: <1335830115-14335-20-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we are not running the tick, we are not anymore regularly counting
the user/system cputime at every jiffies.

To solve this, save a snapshot of the jiffies when we stop the tick
and keep track of where we saved it: user or system. On top of this,
we account the cputime elapsed when we cross the kernel entry/exit
boundaries and when we restart the tick.

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
 include/linux/tick.h     |   12 ++++
 kernel/sched/core.c      |    1 +
 kernel/time/tick-sched.c |  131 +++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 142 insertions(+), 2 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 03b6edd..598b492 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -153,11 +153,23 @@ static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 # endif /* !NO_HZ */
 
 #ifdef CONFIG_CPUSETS_NO_HZ
+extern void tick_nohz_enter_kernel(void);
+extern void tick_nohz_exit_kernel(void);
+extern void tick_nohz_enter_exception(struct pt_regs *regs);
+extern void tick_nohz_exit_exception(struct pt_regs *regs);
 extern void tick_nohz_check_adaptive(void);
+extern void tick_nohz_pre_schedule(void);
 extern void tick_nohz_post_schedule(void);
+extern bool tick_nohz_account_tick(void);
 #else /* !CPUSETS_NO_HZ */
+static inline void tick_nohz_enter_kernel(void) { }
+static inline void tick_nohz_exit_kernel(void) { }
+static inline void tick_nohz_enter_exception(struct pt_regs *regs) { }
+static inline void tick_nohz_exit_exception(struct pt_regs *regs) { }
 static inline void tick_nohz_check_adaptive(void) { }
+static inline void tick_nohz_pre_schedule(void) { }
 static inline void tick_nohz_post_schedule(void) { }
+static inline bool tick_nohz_account_tick(void) { return false; }
 #endif /* CPUSETS_NO_HZ */
 
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index eca842e..5debfd7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1923,6 +1923,7 @@ static inline void
 prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
+	tick_nohz_pre_schedule();
 	sched_info_switch(prev, next);
 	perf_event_task_sched_out(prev, next);
 	fire_sched_out_preempt_notifiers(prev, next);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index b5ad06d..a68909a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -526,7 +526,13 @@ static bool can_stop_adaptive_tick(void)
 
 static void tick_nohz_cpuset_stop_tick(struct tick_sched *ts)
 {
+	struct pt_regs *regs = get_irq_regs();
 	int cpu = smp_processor_id();
+	int was_stopped;
+	int user = 0;
+
+	if (regs)
+		user = user_mode(regs);
 
 	if (!cpuset_adaptive_nohz() || is_idle_task(current))
 		return;
@@ -537,7 +543,36 @@ static void tick_nohz_cpuset_stop_tick(struct tick_sched *ts)
 	if (!can_stop_adaptive_tick())
 		return;
 
+	/*
+	 * If we stop the tick between the syscall exit hook and the actual
+	 * return to userspace, we'll think we are in system space (due to
+	 * user_mode() thinking so). And since we passed the syscall exit hook
+	 * already we won't realize we are in userspace. So the time spent
+	 * tickless would be spuriously accounted as belonging to system.
+	 *
+	 * To avoid this kind of problem, we only stop the tick from userspace
+	 * (until we find a better solution).
+	 * We can later enter the kernel and keep the tick stopped. But the place
+	 * where we stop the tick must be userspace.
+	 * We make an exception for kernel threads since they always execute in
+	 * kernel space.
+	 */
+	if (!user && current->mm)
+		return;
+
+	was_stopped = ts->tick_stopped;
 	tick_nohz_stop_sched_tick(ts, ktime_get(), cpu);
+
+	if (!was_stopped && ts->tick_stopped) {
+		WARN_ON_ONCE(ts->saved_jiffies_whence != JIFFIES_SAVED_NONE);
+		if (user)
+			ts->saved_jiffies_whence = JIFFIES_SAVED_USER;
+		else if (!current->mm)
+			ts->saved_jiffies_whence = JIFFIES_SAVED_SYS;
+
+		ts->saved_jiffies = jiffies;
+		set_thread_flag(TIF_NOHZ);
+	}
 }
 #else
 static void tick_nohz_cpuset_stop_tick(struct tick_sched *ts) { }
@@ -864,6 +899,70 @@ void tick_check_idle(int cpu)
 }
 
 #ifdef CONFIG_CPUSETS_NO_HZ
+void tick_nohz_exit_kernel(void)
+{
+	unsigned long flags;
+	struct tick_sched *ts;
+	unsigned long delta_jiffies;
+
+	local_irq_save(flags);
+
+	ts = &__get_cpu_var(tick_cpu_sched);
+
+	if (!ts->tick_stopped) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	WARN_ON_ONCE(ts->saved_jiffies_whence != JIFFIES_SAVED_SYS);
+
+	delta_jiffies = jiffies - ts->saved_jiffies;
+	account_system_ticks(current, delta_jiffies);
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
+	ts = &__get_cpu_var(tick_cpu_sched);
+
+	if (!ts->tick_stopped) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	WARN_ON_ONCE(ts->saved_jiffies_whence != JIFFIES_SAVED_USER);
+
+	delta_jiffies = jiffies - ts->saved_jiffies;
+	account_user_ticks(current, delta_jiffies);
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
 /*
  * Take the timer duty if nobody is taking care of it.
  * If a CPU already does and and it's in a nohz cpuset,
@@ -882,13 +981,22 @@ static void tick_do_timer_check_handler(int cpu)
 	}
 }
 
+static void tick_nohz_restart_adaptive(void)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+	tick_nohz_account_ticks(ts);
+	tick_nohz_restart_sched_tick();
+	clear_thread_flag(TIF_NOHZ);
+}
+
 void tick_nohz_check_adaptive(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 
 	if (ts->tick_stopped && !is_idle_task(current)) {
 		if (!can_stop_adaptive_tick())
-			tick_nohz_restart_sched_tick();
+			tick_nohz_restart_adaptive();
 	}
 }
 
@@ -900,6 +1008,26 @@ void cpuset_exit_nohz_interrupt(void *unused)
 		tick_nohz_restart_adaptive();
 }
 
+/*
+ * Flush cputime and clear hooks before context switch in case we
+ * haven't yet received the IPI that should take care of that.
+ */
+void tick_nohz_pre_schedule(void)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+	/*
+	 * We are holding the rq lock and if we restart the tick now
+	 * we could deadlock by acquiring the lock twice. Instead
+	 * we do that on post schedule time. For now do the cleanups
+	 * on the prev task.
+	 */
+	if (ts->tick_stopped) {
+		tick_nohz_account_ticks(ts);
+		clear_thread_flag(TIF_NOHZ);
+	}
+}
+
 void tick_nohz_post_schedule(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
@@ -912,7 +1040,6 @@ void tick_nohz_post_schedule(void)
 	if (ts->tick_stopped)
 		tick_nohz_restart_sched_tick();
 }
-
 #else
 
 static void tick_do_timer_check_handler(int cpu)
-- 
1.7.5.4

