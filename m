Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab2EAAEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:04:32 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:41691 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768Ab2EAAE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:04:29 -0400
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
Subject: [PATCH 20/41] nohz/cpuset: New API to flush cputimes on nohz cpusets
Date: Tue,  1 May 2012 01:54:54 +0200
Message-Id: <1335830115-14335-21-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a new API that sends an IPI to every CPUs included
in nohz cpusets in order to flush their cputimes. It's going
to be useful for those that want to see accurate cputimes
on a nohz cpuset.

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
 include/linux/cpuset.h   |    2 ++
 include/linux/tick.h     |    1 +
 kernel/cpuset.c          |   34 +++++++++++++++++++++++++++++++++-
 kernel/time/tick-sched.c |   21 ++++++++++++++++-----
 4 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 89ef5f3..ccbc2fd 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -265,9 +265,11 @@ static inline bool cpuset_adaptive_nohz(void)
 }
 
 extern void cpuset_exit_nohz_interrupt(void *unused);
+extern void cpuset_nohz_flush_cputimes(void);
 #else
 static inline bool cpuset_cpu_adaptive_nohz(int cpu) { return false; }
 static inline bool cpuset_adaptive_nohz(void) { return false; }
+static inline void cpuset_nohz_flush_cputimes(void) { }
 
 #endif /* CONFIG_CPUSETS_NO_HZ */
 
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 598b492..3c31d6e 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -161,6 +161,7 @@ extern void tick_nohz_check_adaptive(void);
 extern void tick_nohz_pre_schedule(void);
 extern void tick_nohz_post_schedule(void);
 extern bool tick_nohz_account_tick(void);
+extern void tick_nohz_flush_current_times(bool restart_tick);
 #else /* !CPUSETS_NO_HZ */
 static inline void tick_nohz_enter_kernel(void) { }
 static inline void tick_nohz_exit_kernel(void) { }
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 00864a0..aa8304d 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -59,6 +59,7 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 #include <linux/cgroup.h>
+#include <linux/tick.h>
 
 /*
  * Workqueue for cpuset related tasks.
@@ -1221,6 +1222,23 @@ static void cpuset_change_flag(struct task_struct *tsk,
 
 DEFINE_PER_CPU(int, cpu_adaptive_nohz_ref);
 
+static cpumask_t nohz_cpuset_mask;
+
+static void flush_cputime_interrupt(void *unused)
+{
+	tick_nohz_flush_current_times(false);
+}
+
+void cpuset_nohz_flush_cputimes(void)
+{
+	preempt_disable();
+	smp_call_function_many(&nohz_cpuset_mask, flush_cputime_interrupt,
+			       NULL, true);
+	preempt_enable();
+	/* Make the utime/stime updates visible */
+	smp_mb();
+}
+
 static void cpu_exit_nohz(int cpu)
 {
 	preempt_disable();
@@ -1245,7 +1263,15 @@ static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
 
 		val = per_cpu(cpu_adaptive_nohz_ref, cpu);
 
-		if (!val) {
+		if (val == 1) {
+			cpumask_set_cpu(cpu, &nohz_cpuset_mask);
+			/*
+			 * The mask update needs to be visible right away
+			 * so that this CPU is part of the cputime IPI
+			 * update right now.
+			 */
+			 smp_mb();
+		} else if (!val) {
 			/*
 			 * The update to cpu_adaptive_nohz_ref must be
 			 * visible right away. So that once we restart the tick
@@ -1256,6 +1282,12 @@ static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
 			 */
 			smp_mb();
 			cpu_exit_nohz(cpu);
+			/*
+			 * Now that the tick has been restarted and cputimes
+			 * flushed, we don't need anymore to be part of the
+			 * cputime flush IPI.
+			 */
+			cpumask_clear_cpu(cpu, &nohz_cpuset_mask);
 		}
 	}
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a68909a..5933506 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -705,7 +705,6 @@ static void tick_nohz_account_ticks(struct tick_sched *ts)
 			WARN_ON_ONCE(1);
 		}
 	}
-	ts->saved_jiffies_whence = JIFFIES_SAVED_NONE;
 }
 
 /**
@@ -739,6 +738,7 @@ void tick_nohz_idle_exit(void)
 		__tick_nohz_restart_sched_tick(ts, now);
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 		tick_nohz_account_ticks(ts);
+		ts->saved_jiffies_whence = JIFFIES_SAVED_NONE;
 #endif
 	}
 
@@ -983,9 +983,7 @@ static void tick_do_timer_check_handler(int cpu)
 
 static void tick_nohz_restart_adaptive(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
-
-	tick_nohz_account_ticks(ts);
+	tick_nohz_flush_current_times(true);
 	tick_nohz_restart_sched_tick();
 	clear_thread_flag(TIF_NOHZ);
 }
@@ -1023,7 +1021,7 @@ void tick_nohz_pre_schedule(void)
 	 * on the prev task.
 	 */
 	if (ts->tick_stopped) {
-		tick_nohz_account_ticks(ts);
+		tick_nohz_flush_current_times(true);
 		clear_thread_flag(TIF_NOHZ);
 	}
 }
@@ -1040,6 +1038,19 @@ void tick_nohz_post_schedule(void)
 	if (ts->tick_stopped)
 		tick_nohz_restart_sched_tick();
 }
+
+void tick_nohz_flush_current_times(bool restart_tick)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+	if (ts->tick_stopped) {
+		tick_nohz_account_ticks(ts);
+		if (restart_tick)
+			ts->saved_jiffies_whence = JIFFIES_SAVED_NONE;
+		else
+			ts->saved_jiffies = jiffies;
+	}
+}
 #else
 
 static void tick_do_timer_check_handler(int cpu)
-- 
1.7.5.4

