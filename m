Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab2FMQUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 12:20:45 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40424 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab2FMQUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 12:20:16 -0400
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
Subject: [PATCH 3/7] nohz: Generalize tickless cpu time accounting
Date: Wed, 13 Jun 2012 18:19:53 +0200
Message-Id: <1339604397-8758-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1339604397-8758-1-git-send-email-fweisbec@gmail.com>
References: <1339604397-8758-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the CPU enters idle, it saves the jiffies stamp into
ts->idle_jiffies, increment this value by one every time
there is a timer interrupt and accounts "jiffies - ts->idle_jiffies"
idle ticks when we exit idle. This way we still account the
idle CPU time even if the tick is stopped.

This patch settles the ground to generalize this for user
and system accounting. ts->idle_jiffies becomes ts->saved_jiffies and
a new member ts->saved_jiffies_whence indicates from which domain
we saved the jiffies: user, system or idle.

This is one more step toward making the tickless infrastructure usable
further idle contexts.

For now this is only used by idle but further patches make use of
it for user and system.

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
 include/linux/kernel_stat.h |    2 +
 include/linux/tick.h        |   45 +++++++++++++++++++-------------
 kernel/sched/core.c         |   26 ++++++++++++++++++
 kernel/time/tick-sched.c    |   60 ++++++++++++++++++++++++++++--------------
 kernel/time/timer_list.c    |    3 +-
 5 files changed, 97 insertions(+), 39 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 2fbd905..be90056 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -122,7 +122,9 @@ static inline unsigned int kstat_cpu_irqs_sum(unsigned int cpu)
 extern unsigned long long task_delta_exec(struct task_struct *);
 
 extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
+extern void account_user_ticks(struct task_struct *, unsigned long);
 extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
+extern void account_system_ticks(struct task_struct *, unsigned long);
 extern void account_steal_time(cputime_t);
 extern void account_idle_time(cputime_t);
 
diff --git a/include/linux/tick.h b/include/linux/tick.h
index f37fceb..0578207 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -27,25 +27,33 @@ enum tick_nohz_mode {
 	NOHZ_MODE_HIGHRES,
 };
 
+enum tick_saved_jiffies {
+	JIFFIES_SAVED_NONE,
+	JIFFIES_SAVED_IDLE,
+	JIFFIES_SAVED_USER,
+	JIFFIES_SAVED_SYS,
+};
+
 /**
  * struct tick_sched - sched tick emulation and no idle tick control/stats
- * @sched_timer:	hrtimer to schedule the periodic tick in high
- *			resolution mode
- * @last_tick:		Store the last tick expiry time when the tick
- *			timer is modified for nohz sleeps. This is necessary
- *			to resume the tick timer operation in the timeline
- *			when the CPU returns from nohz sleep.
- * @tick_stopped:	Indicator that the idle tick has been stopped
- * @idle_jiffies:	jiffies at the entry to idle for idle time accounting
- * @idle_calls:		Total number of idle calls
- * @idle_sleeps:	Number of idle calls, where the sched tick was stopped
- * @idle_entrytime:	Time when the idle call was entered
- * @idle_waketime:	Time when the idle was interrupted
- * @idle_exittime:	Time when the idle state was left
- * @idle_sleeptime:	Sum of the time slept in idle with sched tick stopped
- * @iowait_sleeptime:	Sum of the time slept in idle with sched tick stopped, with IO outstanding
- * @sleep_length:	Duration of the current idle sleep
- * @do_timer_lst:	CPU was the last one doing do_timer before going idle
+ * @sched_timer:		hrtimer to schedule the periodic tick in high
+ *				resolution mode
+ * @last_tick:			Store the last tick expiry time when the tick
+ *				timer is modified for nohz sleeps. This is necessary
+ *				to resume the tick timer operation in the timeline
+ *				when the CPU returns from nohz sleep.
+ * @tick_stopped:		Indicator that the idle tick has been stopped
+ * @idle_calls:			Total number of idle calls
+ * @idle_sleeps:		Number of idle calls, where the sched tick was stopped
+ * @idle_entrytime:		Time when the idle call was entered
+ * @idle_waketime:		Time when the idle was interrupted
+ * @idle_exittime:		Time when the idle state was left
+ * @idle_sleeptime:		Sum of the time slept in idle with sched tick stopped
+ * @saved_jiffies:		Jiffies snapshot on tick stop for cpu time accounting
+ * @saved_jiffies_whence:	Area where we saved @saved_jiffies
+ * @iowait_sleeptime:		Sum of the time slept in idle with sched tick stopped, with IO outstanding
+ * @sleep_length:		Duration of the current idle sleep
+ * @do_timer_lst:		CPU was the last one doing do_timer before going idle
  */
 struct tick_sched {
 	struct hrtimer			sched_timer;
@@ -54,7 +62,6 @@ struct tick_sched {
 	ktime_t				last_tick;
 	int				inidle;
 	int				tick_stopped;
-	unsigned long			idle_jiffies;
 	unsigned long			idle_calls;
 	unsigned long			idle_sleeps;
 	int				idle_active;
@@ -62,6 +69,8 @@ struct tick_sched {
 	ktime_t				idle_waketime;
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
+	enum tick_saved_jiffies		saved_jiffies_whence;
+	unsigned long			saved_jiffies;
 	ktime_t				iowait_sleeptime;
 	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d5594a4..013e6f2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2740,6 +2740,19 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 	acct_update_integrals(p);
 }
 
+#ifdef CONFIG_NO_HZ_FULL
+void account_user_ticks(struct task_struct *p, unsigned long ticks)
+{
+	cputime_t delta_cputime, delta_scaled;
+
+	if (ticks) {
+		delta_cputime = jiffies_to_cputime(ticks);
+		delta_scaled = cputime_to_scaled(ticks);
+		account_user_time(p, delta_cputime, delta_scaled);
+	}
+}
+#endif
+
 /*
  * Account guest cpu time to a process.
  * @p: the process that the cpu time gets accounted to
@@ -2817,6 +2830,19 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	__account_system_time(p, cputime, cputime_scaled, index);
 }
 
+#ifdef CONFIG_NO_HZ_FULL
+void account_system_ticks(struct task_struct *p, unsigned long ticks)
+{
+	cputime_t delta_cputime, delta_scaled;
+
+	if (ticks) {
+		delta_cputime = jiffies_to_cputime(ticks);
+		delta_scaled = cputime_to_scaled(ticks);
+		account_system_time(p, 0, delta_cputime, delta_scaled);
+	}
+}
+#endif
+
 /*
  * Account for involuntary wait time.
  * @cputime: the cpu time spent in involuntary wait
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 60c9c60..66ae73a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -460,8 +460,10 @@ static void __tick_nohz_idle_enter(struct tick_sched *ts)
 			ts->idle_expires = expires;
 		}
 
-		if (!was_stopped && ts->tick_stopped)
-			ts->idle_jiffies = ts->last_jiffies;
+		if (!was_stopped && ts->tick_stopped) {
+			ts->saved_jiffies = ts->last_jiffies;
+			ts->saved_jiffies_whence = JIFFIES_SAVED_IDLE;
+		}
 	}
 }
 
@@ -578,22 +580,38 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 	tick_nohz_restart(ts, now);
 }
 
-static void tick_nohz_account_idle_ticks(struct tick_sched *ts)
+static void tick_nohz_account_ticks(struct tick_sched *ts)
 {
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	unsigned long ticks;
 	/*
-	 * We stopped the tick in idle. Update process times would miss the
-	 * time we slept as update_process_times does only a 1 tick
-	 * accounting. Enforce that this is accounted to idle !
+	 * We stopped the tick. Update process times would miss the
+	 * time we ran tickless as update_process_times does only a 1 tick
+	 * accounting. Enforce that this is accounted to nohz timeslices.
 	 */
-	ticks = jiffies - ts->idle_jiffies;
+	ticks = jiffies - ts->saved_jiffies;
 	/*
 	 * We might be one off. Do not randomly account a huge number of ticks!
 	 */
-	if (ticks && ticks < LONG_MAX)
-		account_idle_ticks(ticks);
+	if (ticks && ticks < LONG_MAX) {
+		switch (ts->saved_jiffies_whence) {
+		case JIFFIES_SAVED_IDLE:
+			account_idle_ticks(ticks);
+			break;
+#ifdef CONFIG_NO_HZ_FULL
+		case JIFFIES_SAVED_USER:
+			account_user_ticks(current, ticks);
+			break;
+		case JIFFIES_SAVED_SYS:
+			account_system_ticks(current, ticks);
+			break;
+		case JIFFIES_SAVED_NONE:
+			break;
 #endif
+		default:
+			WARN_ON_ONCE(1);
+		}
+	}
+	ts->saved_jiffies_whence = JIFFIES_SAVED_NONE;
 }
 
 /**
@@ -623,7 +641,9 @@ void tick_nohz_idle_exit(void)
 
 	if (ts->tick_stopped) {
 		tick_nohz_restart_sched_tick(ts, now);
-		tick_nohz_account_idle_ticks(ts);
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+		tick_nohz_account_ticks(ts);
+#endif
 	}
 
 	local_irq_enable();
@@ -671,7 +691,7 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 	 */
 	if (ts->tick_stopped) {
 		touch_softlockup_watchdog();
-		ts->idle_jiffies++;
+		ts->saved_jiffies++;
 	}
 
 	update_process_times(user_mode(regs));
@@ -820,17 +840,17 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 	 */
 	if (regs) {
 		/*
-		 * When we are idle and the tick is stopped, we have to touch
-		 * the watchdog as we might not schedule for a really long
-		 * time. This happens on complete idle SMP systems while
-		 * waiting on the login prompt. We also increment the "start of
-		 * idle" jiffy stamp so the idle accounting adjustment we do
-		 * when we go busy again does not account too much ticks.
+		 * When the tick is stopped, we have to touch the watchdog
+		 * as we might not schedule for a really long time. This
+		 * happens on complete idle SMP systems while waiting on
+		 * the login prompt. We also increment the last jiffy stamp
+		 * recorded when we stopped the tick so the cpu time accounting
+		 * adjustment does not account too much ticks when we flush them.
 		 */
 		if (ts->tick_stopped) {
+			/* CHECKME: may be this is only needed in idle */
 			touch_softlockup_watchdog();
-			if (idle_cpu(cpu))
-				ts->idle_jiffies++;
+			ts->saved_jiffies++;
 		}
 		update_process_times(user_mode(regs));
 		profile_tick(CPU_PROFILING);
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index af5a7e9..54705e3 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -169,7 +169,8 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 		P(nohz_mode);
 		P_ns(last_tick);
 		P(tick_stopped);
-		P(idle_jiffies);
+		/* CHECKME: Do we want saved_jiffies_whence as well? */
+		P(saved_jiffies);
 		P(idle_calls);
 		P(idle_sleeps);
 		P_ns(idle_entrytime);
-- 
1.7.5.4

