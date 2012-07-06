Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab2GFGUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:20:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48963 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab2GFGUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:20:21 -0400
Date: Thu, 5 Jul 2012 23:19:43 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-5167e8d5417bf5c322a703d2927daec727ea40dd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, dsmythies@telus.net, tglx@linutronix.de,
        muming.wq@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, dsmythies@telus.net, tglx@linutronix.de,
        muming.wq@gmail.com
In-Reply-To: <1340373782.18025.74.camel@twins>
References: <1340373782.18025.74.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/nohz:
  Rewrite and fix load-avg computation -- again
Git-Commit-ID: 5167e8d5417bf5c322a703d2927daec727ea40dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 05 Jul 2012 23:19:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5167e8d5417bf5c322a703d2927daec727ea40dd
Gitweb:     http://git.kernel.org/tip/5167e8d5417bf5c322a703d2927daec727ea40dd
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 22 Jun 2012 15:52:09 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jul 2012 20:58:13 +0200

sched/nohz: Rewrite and fix load-avg computation -- again

Thanks to Charles Wang for spotting the defects in the current code:

 - If we go idle during the sample window -- after sampling, we get a
   negative bias because we can negate our own sample.

 - If we wake up during the sample window we get a positive bias
   because we push the sample to a known active period.

So rewrite the entire nohz load-avg muck once again, now adding
copious documentation to the code.

Reported-and-tested-by: Doug Smythies <dsmythies@telus.net>
Reported-and-tested-by: Charles Wang <muming.wq@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@kernel.org
Link: http://lkml.kernel.org/r/1340373782.18025.74.camel@twins
[ minor edits ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h    |    8 ++
 kernel/sched/core.c      |  275 ++++++++++++++++++++++++++++++++++------------
 kernel/sched/idle_task.c |    1 -
 kernel/sched/sched.h     |    2 -
 kernel/time/tick-sched.c |    2 +
 5 files changed, 213 insertions(+), 75 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4059c0f..20cb749 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1909,6 +1909,14 @@ static inline int set_cpus_allowed_ptr(struct task_struct *p,
 }
 #endif
 
+#ifdef CONFIG_NO_HZ
+void calc_load_enter_idle(void);
+void calc_load_exit_idle(void);
+#else
+static inline void calc_load_enter_idle(void) { }
+static inline void calc_load_exit_idle(void) { }
+#endif /* CONFIG_NO_HZ */
+
 #ifndef CONFIG_CPUMASK_OFFSTACK
 static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d5594a4..bb84040 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2161,11 +2161,73 @@ unsigned long this_cpu_load(void)
 }
 
 
+/*
+ * Global load-average calculations
+ *
+ * We take a distributed and async approach to calculating the global load-avg
+ * in order to minimize overhead.
+ *
+ * The global load average is an exponentially decaying average of nr_running +
+ * nr_uninterruptible.
+ *
+ * Once every LOAD_FREQ:
+ *
+ *   nr_active = 0;
+ *   for_each_possible_cpu(cpu)
+ *   	nr_active += cpu_of(cpu)->nr_running + cpu_of(cpu)->nr_uninterruptible;
+ *
+ *   avenrun[n] = avenrun[0] * exp_n + nr_active * (1 - exp_n)
+ *
+ * Due to a number of reasons the above turns in the mess below:
+ *
+ *  - for_each_possible_cpu() is prohibitively expensive on machines with
+ *    serious number of cpus, therefore we need to take a distributed approach
+ *    to calculating nr_active.
+ *
+ *        \Sum_i x_i(t) = \Sum_i x_i(t) - x_i(t_0) | x_i(t_0) := 0
+ *                      = \Sum_i { \Sum_j=1 x_i(t_j) - x_i(t_j-1) }
+ *
+ *    So assuming nr_active := 0 when we start out -- true per definition, we
+ *    can simply take per-cpu deltas and fold those into a global accumulate
+ *    to obtain the same result. See calc_load_fold_active().
+ *
+ *    Furthermore, in order to avoid synchronizing all per-cpu delta folding
+ *    across the machine, we assume 10 ticks is sufficient time for every
+ *    cpu to have completed this task.
+ *
+ *    This places an upper-bound on the IRQ-off latency of the machine. Then
+ *    again, being late doesn't loose the delta, just wrecks the sample.
+ *
+ *  - cpu_rq()->nr_uninterruptible isn't accurately tracked per-cpu because
+ *    this would add another cross-cpu cacheline miss and atomic operation
+ *    to the wakeup path. Instead we increment on whatever cpu the task ran
+ *    when it went into uninterruptible state and decrement on whatever cpu
+ *    did the wakeup. This means that only the sum of nr_uninterruptible over
+ *    all cpus yields the correct result.
+ *
+ *  This covers the NO_HZ=n code, for extra head-aches, see the comment below.
+ */
+
 /* Variables and functions for calc_load */
 static atomic_long_t calc_load_tasks;
 static unsigned long calc_load_update;
 unsigned long avenrun[3];
-EXPORT_SYMBOL(avenrun);
+EXPORT_SYMBOL(avenrun); /* should be removed */
+
+/**
+ * get_avenrun - get the load average array
+ * @loads:	pointer to dest load array
+ * @offset:	offset to add
+ * @shift:	shift count to shift the result left
+ *
+ * These values are estimates at best, so no need for locking.
+ */
+void get_avenrun(unsigned long *loads, unsigned long offset, int shift)
+{
+	loads[0] = (avenrun[0] + offset) << shift;
+	loads[1] = (avenrun[1] + offset) << shift;
+	loads[2] = (avenrun[2] + offset) << shift;
+}
 
 static long calc_load_fold_active(struct rq *this_rq)
 {
@@ -2182,6 +2244,9 @@ static long calc_load_fold_active(struct rq *this_rq)
 	return delta;
 }
 
+/*
+ * a1 = a0 * e + a * (1 - e)
+ */
 static unsigned long
 calc_load(unsigned long load, unsigned long exp, unsigned long active)
 {
@@ -2193,30 +2258,118 @@ calc_load(unsigned long load, unsigned long exp, unsigned long active)
 
 #ifdef CONFIG_NO_HZ
 /*
- * For NO_HZ we delay the active fold to the next LOAD_FREQ update.
+ * Handle NO_HZ for the global load-average.
+ *
+ * Since the above described distributed algorithm to compute the global
+ * load-average relies on per-cpu sampling from the tick, it is affected by
+ * NO_HZ.
+ *
+ * The basic idea is to fold the nr_active delta into a global idle-delta upon
+ * entering NO_HZ state such that we can include this as an 'extra' cpu delta
+ * when we read the global state.
+ *
+ * Obviously reality has to ruin such a delightfully simple scheme:
+ *
+ *  - When we go NO_HZ idle during the window, we can negate our sample
+ *    contribution, causing under-accounting.
+ *
+ *    We avoid this by keeping two idle-delta counters and flipping them
+ *    when the window starts, thus separating old and new NO_HZ load.
+ *
+ *    The only trick is the slight shift in index flip for read vs write.
+ *
+ *        0s            5s            10s           15s
+ *          +10           +10           +10           +10
+ *        |-|-----------|-|-----------|-|-----------|-|
+ *    r:0 0 1           1 0           0 1           1 0
+ *    w:0 1 1           0 0           1 1           0 0
+ *
+ *    This ensures we'll fold the old idle contribution in this window while
+ *    accumlating the new one.
+ *
+ *  - When we wake up from NO_HZ idle during the window, we push up our
+ *    contribution, since we effectively move our sample point to a known
+ *    busy state.
+ *
+ *    This is solved by pushing the window forward, and thus skipping the
+ *    sample, for this cpu (effectively using the idle-delta for this cpu which
+ *    was in effect at the time the window opened). This also solves the issue
+ *    of having to deal with a cpu having been in NOHZ idle for multiple
+ *    LOAD_FREQ intervals.
  *
  * When making the ILB scale, we should try to pull this in as well.
  */
-static atomic_long_t calc_load_tasks_idle;
+static atomic_long_t calc_load_idle[2];
+static int calc_load_idx;
 
-void calc_load_account_idle(struct rq *this_rq)
+static inline int calc_load_write_idx(void)
 {
+	int idx = calc_load_idx;
+
+	/*
+	 * See calc_global_nohz(), if we observe the new index, we also
+	 * need to observe the new update time.
+	 */
+	smp_rmb();
+
+	/*
+	 * If the folding window started, make sure we start writing in the
+	 * next idle-delta.
+	 */
+	if (!time_before(jiffies, calc_load_update))
+		idx++;
+
+	return idx & 1;
+}
+
+static inline int calc_load_read_idx(void)
+{
+	return calc_load_idx & 1;
+}
+
+void calc_load_enter_idle(void)
+{
+	struct rq *this_rq = this_rq();
 	long delta;
 
+	/*
+	 * We're going into NOHZ mode, if there's any pending delta, fold it
+	 * into the pending idle delta.
+	 */
 	delta = calc_load_fold_active(this_rq);
-	if (delta)
-		atomic_long_add(delta, &calc_load_tasks_idle);
+	if (delta) {
+		int idx = calc_load_write_idx();
+		atomic_long_add(delta, &calc_load_idle[idx]);
+	}
 }
 
-static long calc_load_fold_idle(void)
+void calc_load_exit_idle(void)
 {
-	long delta = 0;
+	struct rq *this_rq = this_rq();
+
+	/*
+	 * If we're still before the sample window, we're done.
+	 */
+	if (time_before(jiffies, this_rq->calc_load_update))
+		return;
 
 	/*
-	 * Its got a race, we don't care...
+	 * We woke inside or after the sample window, this means we're already
+	 * accounted through the nohz accounting, so skip the entire deal and
+	 * sync up for the next window.
 	 */
-	if (atomic_long_read(&calc_load_tasks_idle))
-		delta = atomic_long_xchg(&calc_load_tasks_idle, 0);
+	this_rq->calc_load_update = calc_load_update;
+	if (time_before(jiffies, this_rq->calc_load_update + 10))
+		this_rq->calc_load_update += LOAD_FREQ;
+}
+
+static long calc_load_fold_idle(void)
+{
+	int idx = calc_load_read_idx();
+	long delta = 0;
+
+	if (atomic_long_read(&calc_load_idle[idx]))
+		delta = atomic_long_xchg(&calc_load_idle[idx], 0);
 
 	return delta;
 }
@@ -2302,66 +2455,39 @@ static void calc_global_nohz(void)
 {
 	long delta, active, n;
 
-	/*
-	 * If we crossed a calc_load_update boundary, make sure to fold
-	 * any pending idle changes, the respective CPUs might have
-	 * missed the tick driven calc_load_account_active() update
-	 * due to NO_HZ.
-	 */
-	delta = calc_load_fold_idle();
-	if (delta)
-		atomic_long_add(delta, &calc_load_tasks);
-
-	/*
-	 * It could be the one fold was all it took, we done!
-	 */
-	if (time_before(jiffies, calc_load_update + 10))
-		return;
-
-	/*
-	 * Catch-up, fold however many we are behind still
-	 */
-	delta = jiffies - calc_load_update - 10;
-	n = 1 + (delta / LOAD_FREQ);
+	if (!time_before(jiffies, calc_load_update + 10)) {
+		/*
+		 * Catch-up, fold however many we are behind still
+		 */
+		delta = jiffies - calc_load_update - 10;
+		n = 1 + (delta / LOAD_FREQ);
 
-	active = atomic_long_read(&calc_load_tasks);
-	active = active > 0 ? active * FIXED_1 : 0;
+		active = atomic_long_read(&calc_load_tasks);
+		active = active > 0 ? active * FIXED_1 : 0;
 
-	avenrun[0] = calc_load_n(avenrun[0], EXP_1, active, n);
-	avenrun[1] = calc_load_n(avenrun[1], EXP_5, active, n);
-	avenrun[2] = calc_load_n(avenrun[2], EXP_15, active, n);
+		avenrun[0] = calc_load_n(avenrun[0], EXP_1, active, n);
+		avenrun[1] = calc_load_n(avenrun[1], EXP_5, active, n);
+		avenrun[2] = calc_load_n(avenrun[2], EXP_15, active, n);
 
-	calc_load_update += n * LOAD_FREQ;
-}
-#else
-void calc_load_account_idle(struct rq *this_rq)
-{
-}
+		calc_load_update += n * LOAD_FREQ;
+	}
 
-static inline long calc_load_fold_idle(void)
-{
-	return 0;
+	/*
+	 * Flip the idle index...
+	 *
+	 * Make sure we first write the new time then flip the index, so that
+	 * calc_load_write_idx() will see the new time when it reads the new
+	 * index, this avoids a double flip messing things up.
+	 */
+	smp_wmb();
+	calc_load_idx++;
 }
+#else /* !CONFIG_NO_HZ */
 
-static void calc_global_nohz(void)
-{
-}
-#endif
+static inline long calc_load_fold_idle(void) { return 0; }
+static inline void calc_global_nohz(void) { }
 
-/**
- * get_avenrun - get the load average array
- * @loads:	pointer to dest load array
- * @offset:	offset to add
- * @shift:	shift count to shift the result left
- *
- * These values are estimates at best, so no need for locking.
- */
-void get_avenrun(unsigned long *loads, unsigned long offset, int shift)
-{
-	loads[0] = (avenrun[0] + offset) << shift;
-	loads[1] = (avenrun[1] + offset) << shift;
-	loads[2] = (avenrun[2] + offset) << shift;
-}
+#endif /* CONFIG_NO_HZ */
 
 /*
  * calc_load - update the avenrun load estimates 10 ticks after the
@@ -2369,11 +2495,18 @@ void get_avenrun(unsigned long *loads, unsigned long offset, int shift)
  */
 void calc_global_load(unsigned long ticks)
 {
-	long active;
+	long active, delta;
 
 	if (time_before(jiffies, calc_load_update + 10))
 		return;
 
+	/*
+	 * Fold the 'old' idle-delta to include all NO_HZ cpus.
+	 */
+	delta = calc_load_fold_idle();
+	if (delta)
+		atomic_long_add(delta, &calc_load_tasks);
+
 	active = atomic_long_read(&calc_load_tasks);
 	active = active > 0 ? active * FIXED_1 : 0;
 
@@ -2384,12 +2517,7 @@ void calc_global_load(unsigned long ticks)
 	calc_load_update += LOAD_FREQ;
 
 	/*
-	 * Account one period with whatever state we found before
-	 * folding in the nohz state and ageing the entire idle period.
-	 *
-	 * This avoids loosing a sample when we go idle between 
-	 * calc_load_account_active() (10 ticks ago) and now and thus
-	 * under-accounting.
+	 * In case we idled for multiple LOAD_FREQ intervals, catch up in bulk.
 	 */
 	calc_global_nohz();
 }
@@ -2406,7 +2534,6 @@ static void calc_load_account_active(struct rq *this_rq)
 		return;
 
 	delta  = calc_load_fold_active(this_rq);
-	delta += calc_load_fold_idle();
 	if (delta)
 		atomic_long_add(delta, &calc_load_tasks);
 
@@ -2414,6 +2541,10 @@ static void calc_load_account_active(struct rq *this_rq)
 }
 
 /*
+ * End of global load-average stuff
+ */
+
+/*
  * The exact cpuload at various idx values, calculated at every tick would be
  * load = (2^idx - 1) / 2^idx * load + 1 / 2^idx * cur_load
  *
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index b44d604..b6baf37 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -25,7 +25,6 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
 static struct task_struct *pick_next_task_idle(struct rq *rq)
 {
 	schedstat_inc(rq, sched_goidle);
-	calc_load_account_idle(rq);
 	return rq->idle;
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 6d52cea..55844f2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -942,8 +942,6 @@ static inline u64 sched_avg_period(void)
 	return (u64)sysctl_sched_time_avg * NSEC_PER_MSEC / 2;
 }
 
-void calc_load_account_idle(struct rq *this_rq);
-
 #ifdef CONFIG_SCHED_HRTICK
 
 /*
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 8699978..4a08472 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -406,6 +406,7 @@ static void tick_nohz_stop_sched_tick(struct tick_sched *ts)
 		 */
 		if (!ts->tick_stopped) {
 			select_nohz_load_balancer(1);
+			calc_load_enter_idle();
 
 			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
@@ -597,6 +598,7 @@ void tick_nohz_idle_exit(void)
 		account_idle_ticks(ticks);
 #endif
 
+	calc_load_exit_idle();
 	touch_softlockup_watchdog();
 	/*
 	 * Cancel the scheduled timer and restore the tick
