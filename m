Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab2K1Id3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 03:33:29 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52297 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab2K1Id2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 03:33:28 -0500
From: Hakan Akkan <hakanakkan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hakan Akkan <hakanakkan@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] nohz/cpuset: Make a CPU stick with do_timer() duty in the presence of nohz cpusets
Date: Wed, 28 Nov 2012 01:29:24 -0700
Message-Id: <1354091364-7920-1-git-send-email-hakanakkan@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CAFTL4hw6vWsHa5gqThUpWhC7MQUueXpze=Fyuvoyzy2t=zYrhA@mail.gmail.com>
References: <CAFTL4hw6vWsHa5gqThUpWhC7MQUueXpze=Fyuvoyzy2t=zYrhA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An adaptive nohz (AHZ) CPU may not do do_timer() for a while
despite being non-idle. When all other CPUs are idle, AHZ
CPUs might be using stale jiffies values. To prevent this
always keep a CPU with ticks if there is one or more AHZ
CPUs.

A new function, check_drop_timer_duty, handles the updates
to tick_do_timer_cpu value and makes sure that the jiffies
update is done when there are non-idle adaptive-nohz CPUs.
Also added is a new field in struct tick_sched to indicate
if CPU is ready to run something other than the idle task
without ticks once it drops the do_timer() duty. This also
facilitates the system-wide tick shut down when all CPUs,
including AHZ CPUs, are idle.

Signed-off-by: Hakan Akkan <hakanakkan@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
---
 include/linux/tick.h     |    2 +
 kernel/time/tick-sched.c |  235 ++++++++++++++++++++++++++++++++++++----------
 2 files changed, 188 insertions(+), 49 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 93add37..0a65dfb 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -54,6 +54,7 @@ enum tick_saved_jiffies {
  * @iowait_sleeptime:		Sum of the time slept in idle with sched tick stopped, with IO outstanding
  * @sleep_length:		Duration of the current idle sleep
  * @do_timer_lst:		CPU was the last one doing do_timer before going idle
+ * @user_nohz:			CPU wants to switch to adaptive nohz mode
  */
 struct tick_sched {
 	struct hrtimer			sched_timer;
@@ -77,6 +78,7 @@ struct tick_sched {
 	unsigned long			next_jiffies;
 	ktime_t				idle_expires;
 	int				do_timer_last;
+	int				user_nohz;
 };
 
 extern void __init tick_init(void);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index bdc8aeb..3ff9dc5 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -172,6 +172,130 @@ update_ts_time_stats(int cpu, struct tick_sched *ts, ktime_t now, u64 *last_upda
 
 }
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+/*
+ * This defines the number of CPUs currently in (or wanting to
+ * be in) adaptive nohz mode. Greater than 0 means at least
+ * one CPU is ready to shut down its tick for non-idle purposes.
+ */
+static atomic_t __read_mostly nr_cpus_user_nohz = ATOMIC_INIT(0);
+
+static inline int update_do_timer_cpu(int current_handler,
+			int new_handler)
+{
+	return cmpxchg(&tick_do_timer_cpu, current_handler, new_handler);
+}
+#else
+static inline int update_do_timer_cpu(int current_handler,
+			int new_handler)
+{
+	int tmp = ACCESS_ONCE(tick_do_timer_cpu);
+	tick_do_timer_cpu = new_handler;
+	return tmp;
+}
+#endif
+
+/*
+ * check_drop_timer_duty: Check if this cpu can shut down
+ * ticks without worrying about who is going to handle
+ * timekeeping. The duty is dropped here as well if possible.
+ * When there are adaptive nohz cpus in the system ready to
+ * run user tasks without ticks, this function makes sure
+ * that timekeeping is handled by a cpu. A non-adaptive-nohz
+ * cpu, if any, will claim the duty as soon as it discovers
+ * that some adaptive-nohz cpu is stuck with it.
+ *
+ * Returns
+ *  0 if cpu has to keep ticks on for timekeeping,
+ *  1 if cpu drops the duty inside this function and can shut
+ *    down its ticks,
+ *  2 if cpu did not have the duty anyway.
+ */
+static int check_drop_timer_duty(int cpu)
+{
+	int curr_handler, prev_handler, new_handler;
+	int nrepeat = -1;
+	bool drop_recheck;
+
+repeat:
+	WARN_ON_ONCE(++nrepeat > 1);
+	drop_recheck = false;
+	curr_handler = cpu;
+	new_handler = TICK_DO_TIMER_NONE;
+
+#ifdef CONFIG_CPUSETS_NO_HZ
+	if (atomic_read(&nr_cpus_user_nohz) > 0) {
+		curr_handler = ACCESS_ONCE(tick_do_timer_cpu);
+		/*
+		 * Keep the duty until someone takes it away.
+		 * FIXME: Make nr_cpus_user_nohz an atomic cpumask
+		 * to find an idle CPU to dump the duty at.
+		 */
+		if (curr_handler == cpu)
+			return 0;
+		/*
+		 * This cpu will try to take the duty if 1) there is
+		 * no handler or 2) current handler seems to be an
+		 * adaptive-nohz cpu. We take the duty from others
+		 * only if the we are idle or not part of an
+		 * adaptive-nohz cpuset.
+		 * Once we take the duty, the check above ensures that
+		 * we stick with it.
+		 */
+		if (unlikely(curr_handler == TICK_DO_TIMER_NONE)
+			|| (per_cpu(tick_cpu_sched, curr_handler).user_nohz
+				&& (is_idle_task(current)
+					|| !cpuset_cpu_adaptive_nohz(cpu))))
+			new_handler = cpu;
+		else
+			/*
+			 * A regular CPU is updating the jiffies and we don't
+			 * have to take it away from her.
+			 */
+			new_handler = curr_handler;
+	} else {
+		/*
+		 * We might miss nr_cpus_user_nohz update and drop the duty
+		 * whereas other CPUs think that we keep handling the
+		 * timekeeping. To prevent this, we recheck its value after
+		 * we update the timer_do_timer_cpu and start over if
+		 * necessary.
+		 */
+		drop_recheck = true;
+	}
+#endif
+
+	prev_handler = update_do_timer_cpu(curr_handler, new_handler);
+
+	if (drop_recheck && atomic_read(&nr_cpus_user_nohz) > 0)
+		goto repeat;
+
+	if (likely(new_handler != TICK_DO_TIMER_NONE)) {
+		if (prev_handler == curr_handler) {
+			if (new_handler == cpu) {
+				/* We claimed the duty. */
+				return 0;
+			} else {
+				/*
+				 * We know that the previous handler
+				 * still has the duty. We can sleep
+				 * as long as we want.
+				 */
+				return 2;
+			}
+		}
+		/*
+		 * Handler was probably changed under us. Whoever has
+		 * the duty might just drop it and we wouldn't know.
+		 * So, let's try again...
+		 */
+		goto repeat;
+	} else {
+		/* We either just dropped the duty or didn't have it. */
+		return prev_handler == curr_handler ? 1 : 2;
+	}
+}
+
 static void tick_nohz_stop_idle(int cpu, ktime_t now)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
@@ -187,6 +311,14 @@ static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
 	ktime_t now = ktime_get();
 
 	ts->idle_entrytime = now;
+
+#ifdef CONFIG_CPUSETS_NO_HZ
+	if (ts->user_nohz) {
+		ts->user_nohz = 0;
+		WARN_ON_ONCE(atomic_add_negative(-1, &nr_cpus_user_nohz));
+	}
+#endif
+
 	ts->idle_active = 1;
 	sched_clock_idle_sleep_event();
 	return now;
@@ -280,6 +412,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 	ktime_t last_update, expires, ret = { .tv64 = 0 };
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	u64 time_delta;
+	int can_drop_do_timer;
 
 
 	/* Read jiffies and the time when jiffies were updated last */
@@ -308,28 +441,26 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 
 	/* Schedule the tick, if we are at least one jiffie off */
 	if ((long)delta_jiffies >= 1) {
+		/*
+		 * Check if adaptive nohz needs this CPU to take care
+		 * of the jiffies update. We also drop the duty in this
+		 * function if we can.
+		 */
+		can_drop_do_timer = check_drop_timer_duty(cpu);
+		if (!can_drop_do_timer)
+			goto out;
 
 		/*
-		 * If this cpu is the one which updates jiffies, then
-		 * give up the assignment and let it be taken by the
-		 * cpu which runs the tick timer next, which might be
-		 * this cpu as well. If we don't drop this here the
-		 * jiffies might be stale and do_timer() never
-		 * invoked. Keep track of the fact that it was the one
-		 * which had the do_timer() duty last. If this cpu is
-		 * the one which had the do_timer() duty last, we
-		 * limit the sleep time to the timekeeping
-		 * max_deferement value which we retrieved
+		 * If this cpu is the one which had the do_timer()
+		 * duty last, we limit the sleep time to the
+		 * timekeeping max_deferement value which we retrieved
 		 * above. Otherwise we can sleep as long as we want.
 		 */
-		if (cpu == tick_do_timer_cpu) {
-			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
+		if (can_drop_do_timer == 1) {
 			ts->do_timer_last = 1;
-		} else if (tick_do_timer_cpu != TICK_DO_TIMER_NONE) {
+		} else {
 			time_delta = KTIME_MAX;
 			ts->do_timer_last = 0;
-		} else if (!ts->do_timer_last) {
-			time_delta = KTIME_MAX;
 		}
 
 		/*
@@ -419,6 +550,10 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 	 * invoked.
 	 */
 	if (unlikely(!cpu_online(cpu))) {
+		/*
+		 * FIXME: Might need some sort of protection
+		 * against CPU hotunplug for adaptive nohz.
+		 */
 		if (cpu == tick_do_timer_cpu)
 			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
 	}
@@ -510,19 +645,24 @@ void tick_nohz_idle_enter(void)
 }
 
 #ifdef CONFIG_CPUSETS_NO_HZ
-static bool can_stop_adaptive_tick(void)
+static bool can_stop_adaptive_tick(struct tick_sched *ts)
 {
-	if (!sched_can_stop_tick())
-		return false;
-
-	if (posix_cpu_timers_running(current))
-		return false;
-
-	/* Is there a grace period to complete ? */
-	if (rcu_pending(smp_processor_id()))
-		return false;
+	int ret = true;
+
+	if (!sched_can_stop_tick()
+			|| posix_cpu_timers_running(current)
+			|| rcu_pending(smp_processor_id()))
+		ret = false;
+
+	if (ret && !ts->user_nohz) {
+		ts->user_nohz = 1;
+		atomic_inc(&nr_cpus_user_nohz);
+	} else if (!ret && ts->user_nohz) {
+		ts->user_nohz = 0;
+		WARN_ON_ONCE(atomic_add_negative(-1, &nr_cpus_user_nohz));
+	}
 
-	return true;
+	return ret;
 }
 
 static void tick_nohz_cpuset_stop_tick(struct tick_sched *ts)
@@ -541,7 +681,7 @@ static void tick_nohz_cpuset_stop_tick(struct tick_sched *ts)
 	if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)
 		return;
 
-	if (!can_stop_adaptive_tick())
+	if (!can_stop_adaptive_tick(ts))
 		return;
 
 	/*
@@ -990,27 +1130,14 @@ void tick_nohz_exit_exception(struct pt_regs *regs)
 		tick_nohz_exit_kernel();
 }
 
-/*
- * Take the timer duty if nobody is taking care of it.
- * If a CPU already does and and it's in a nohz cpuset,
- * then take the charge so that it can switch to nohz mode.
- */
-static void tick_do_timer_check_handler(int cpu)
+static void tick_nohz_restart_adaptive(struct tick_sched *ts)
 {
-	int handler = tick_do_timer_cpu;
+	tick_nohz_flush_current_times(true);
 
-	if (unlikely(handler == TICK_DO_TIMER_NONE)) {
-		tick_do_timer_cpu = cpu;
-	} else {
-		if (!cpuset_adaptive_nohz() &&
-		    cpuset_cpu_adaptive_nohz(handler))
-			tick_do_timer_cpu = cpu;
+	if (ts->user_nohz) {
+		ts->user_nohz = 0;
+		WARN_ON_ONCE(atomic_add_negative(-1, &nr_cpus_user_nohz));
 	}
-}
-
-static void tick_nohz_restart_adaptive(void)
-{
-	tick_nohz_flush_current_times(true);
 	tick_nohz_restart_sched_tick();
 	clear_thread_flag(TIF_NOHZ);
 	trace_printk("clear TIF_NOHZ\n");
@@ -1022,8 +1149,8 @@ void tick_nohz_check_adaptive(void)
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 
 	if (ts->tick_stopped && !is_idle_task(current)) {
-		if (!can_stop_adaptive_tick())
-			tick_nohz_restart_adaptive();
+		if (!can_stop_adaptive_tick(ts))
+			tick_nohz_restart_adaptive(ts);
 	}
 }
 
@@ -1033,7 +1160,7 @@ void cpuset_exit_nohz_interrupt(void *unused)
 
 	trace_printk("IPI: Nohz exit\n");
 	if (ts->tick_stopped && !is_idle_task(current))
-		tick_nohz_restart_adaptive();
+		tick_nohz_restart_adaptive(ts);
 }
 
 /*
@@ -1122,7 +1249,17 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 	ktime_t now = ktime_get();
 	int cpu = smp_processor_id();
 
-	tick_do_timer_check_handler(cpu);
+#ifdef CONFIG_NO_HZ
+	/*
+	 * Check if the do_timer duty was dropped. We don't care about
+	 * concurrency: This happens only when the cpu in charge went
+	 * into a long sleep. If two cpus happen to assign themself to
+	 * this duty, then the jiffies update is still serialized by
+	 * xtime_lock.
+	 */
+	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
+		tick_do_timer_cpu = cpu;
+#endif
 
 	/* Check, if the jiffies need an update */
 	if (tick_do_timer_cpu == cpu)
-- 
1.7.10.4

