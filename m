Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab2FMQUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 12:20:48 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40424 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab2FMQUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 12:20:18 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: [PATCH 4/7] nohz: Account user and system times in adaptive nohz mode
Date: Wed, 13 Jun 2012 18:19:54 +0200
Message-Id: <1339604397-8758-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1339604397-8758-1-git-send-email-fweisbec@gmail.com>
References: <1339604397-8758-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we'll run in adaptive tickless mode, the tick won't be
there anymore to maintain the user/system cputime on every jiffy.

To solve this, save a snapshot of the jiffies on the boundaries of
the kernel and keep track of where we saved it: user or system entry.
On top of this, we account the cputime elapsed when we cross
back the kernel boundaries and when we deschedule the task.

We do this only when requested through the TIF_NOHZ thread flag.
This will later be used by the timer engine when the tick gets
stopped.

This only settles system and user cputime accounting on kernel
boundaries. Further patches will complete the handling of adaptive
tickless cputime by saving and flushing the time on well defined
points: tick stop, tick restart, cputime report to user, etc...

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
 include/linux/tick.h     |   14 ++++++++
 kernel/sched/core.c      |    1 +
 kernel/time/tick-sched.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 0578207..79623fc 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -151,4 +151,18 @@ static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
 static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 # endif /* !NO_HZ */
 
+#ifdef CONFIG_NO_HZ_FULL
+extern void tick_nohz_enter_kernel(void);
+extern void tick_nohz_exit_kernel(void);
+extern void tick_nohz_enter_exception(struct pt_regs *regs);
+extern void tick_nohz_exit_exception(struct pt_regs *regs);
+extern void tick_nohz_pre_schedule(void);
+#else
+static inline void tick_nohz_enter_kernel(void) { }
+static inline void tick_nohz_exit_kernel(void) { }
+static inline void tick_nohz_enter_exception(struct pt_regs *regs) { }
+static inline void tick_nohz_exit_exception(struct pt_regs *regs) { }
+static inline void tick_nohz_pre_schedule(void) { }
+#endif /* !NO_HZ_FULL */
+
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 013e6f2..72acb05 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1910,6 +1910,7 @@ static inline void
 prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
+	tick_nohz_pre_schedule();
 	sched_info_switch(prev, next);
 	perf_event_task_sched_out(prev, next);
 	fire_sched_out_preempt_notifiers(prev, next);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 66ae73a..3807d71 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -786,6 +786,85 @@ static inline void tick_check_nohz(int cpu)
 	}
 }
 
+#ifdef CONFIG_NO_HZ_FULL
+void tick_nohz_exit_kernel(void)
+{
+	unsigned long flags;
+	struct tick_sched *ts;
+	unsigned long delta_jiffies;
+
+	if (!test_thread_flag(TIF_NOHZ))
+		return;
+
+	local_irq_save(flags);
+
+	ts = &__get_cpu_var(tick_cpu_sched);
+
+	WARN_ON_ONCE(!ts->tick_stopped);
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
+	if (!test_thread_flag(TIF_NOHZ))
+		return;
+
+	local_irq_save(flags);
+
+	ts = &__get_cpu_var(tick_cpu_sched);
+
+	WARN_ON_ONCE(!ts->tick_stopped);
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
+/*
+ * Flush cputime and clear hooks before context switch so that
+ * we account the time spent tickless.
+ */
+void tick_nohz_pre_schedule(void)
+{
+	struct tick_sched *ts;
+
+	if (test_thread_flag(TIF_NOHZ)) {
+		ts = &__get_cpu_var(tick_cpu_sched);
+		tick_nohz_account_ticks(ts);
+		clear_thread_flag(TIF_NOHZ);
+	}
+}
+#endif /* CONFIG_NO_HZ_FULL */
+
 #else
 
 static inline void tick_nohz_switch_to_nohz(void) { }
-- 
1.7.5.4

