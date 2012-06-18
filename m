Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab2FRQD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:03:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:52909 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab2FRQDy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:03:54 -0400
Message-ID: <1340035417.15222.95.camel@twins>
Subject: Re: [PATCH] sched: Folding nohz load accounting more accurate
From: Peter Zijlstra <peterz@infradead.org>
To: Charles Wang <muming.wq@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Tao Ma <tm@tao.ma>,
        =?UTF-8?Q?=E5=90=AB=E9=BB=9B?= <handai.szj@taobao.com>,
        Doug Smythies <dsmythies@telus.net>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 18 Jun 2012 18:03:37 +0200
In-Reply-To: <4FDB4642.5070509@gmail.com>
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>
	  <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com>
	 <1339494970.31548.66.camel@twins> <4FDB4642.5070509@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Charles,

I'm having difficulties understanding your exact meaning, I suspect its
a language thing, so please excuse me for nit-picking through your
email.


On Fri, 2012-06-15 at 22:27 +0800, Charles Wang wrote:

> In our mind 

Are there more people involved?

> per-cpu sampling for cpu idle and non-idle is equal. But
> actually may not.

Are you saying they should be equal but are in fact not so?

I think we can all agree on this. Doug has illustrated this quite
clearly.

The desire is for CONFIG_NOHZ=n,y to function identically, but its been
clearly demonstrated this is currently not the case.

>  For non-idle cpu sampling, it's right the load when
> sampling. 

Agreed, sampling of a busy cpu is identical.

> But for idle, cause of nohz, the sampling will be delayed to
> nohz exit(less than 1 tick after nohz exit). 

I don't think the nohz exit code calls into the load sampling, but I
think you're saying we'll get a sample tick after we leave nohz, right?

This is only so if the busy period covers a tick, that is, if we wake
and go back to idle before a tick happens we'll still not get sampled.


  tick          tick
    |----====-----|
         ^   ^
       wake  sleep


Shows a nohz-exit busy period not sampled.

> Nohz exit is always caused
> by processes woken up--non-idle model. It's not fair here, idle
> calculated to non-idle.
> 
>      time-expect-sampling
>                    |    time-do-sampling
>                    |         |
>                    V         V
> -|-------------------------|--
> start_nohz              stop_nohz

I don't think the delay in sampling is the biggest problem, I think the
problem is the direct interaction between a cpu going idle and another
cpu taking a sample.

So the approach I took was to isolate the going idle before the sample
window from going idle during (and after) the sampling window.

Therefore any going idle activity will not affect the sampled of other
cpus. The only trick is the slight shift in index flip for read vs
write.


  0             5             10            15
    +10           +10           +10           +10
  |-|-----------|-|-----------|-|-----------|-|

r:001           110           001           110
w:011           100           011           100


Shows we'll read the old idle load, but write to the new idle load
during the sample window. Thus including the old idle load in this
sample fold, but leaving new activity for the next.

A cpu waking up and doing a sample is similar to the cpu being busy at
the window start.

However since this window is 10 ticks long and any busy spanning a tick
will make it appear 'busy' we can only accurately sample loads of up to
HZ/(2*10) (2 for the sampling theorem). For a regular HZ=1000 kernel
this ends up being 50 Hz.

Higher frequency workloads will appear to over-account.

Now the whole reason we have this window of 10 ticks is that we're
trying to do a completely asynchronous load computation trying to avoid
as much serialization as possible. So have each cpu account its local
state and hope that 10 ticks is sufficient for all to have reported in,
then process the fold.

The 10 tick window is directly related to the worst irq-off latency on
your machine, if you keep IRQs disabled for a few ticks -- something
that quite easily happens on large machines, even a busy cpu will be
'late' reporting its load. I think the current 10 tick came from an SGI
machine with 4k cpus or so.


Hmmm,.. idea.. OK, so we should also have a hook coming out of NOHZ
state, when we come out of NOHZ state during the sample window, simply
push the whole window fwd to the next time.

This finds another bug in the current code.. A cpu that has idled 'long'
could be multiple LOAD_FREQ intervals behind and will take multiple
samples in quick succession instead of 5s apart.


Can someone please think through the below thing? its been compile
tested only...

---
 kernel/sched/core.c      |  290 ++++++++++++++++++++++++++++++++++------------
 kernel/sched/idle_task.c |    1 -
 kernel/sched/sched.h     |    2 -
 kernel/time/tick-sched.c |    2 +
 4 files changed, 220 insertions(+), 75 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d5594a4..3a49ee1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2161,11 +2161,72 @@ unsigned long this_cpu_load(void)
 }
 
 
+/*
+ * global load-average calculations
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
+ *    This places an upper-bound on the IRQ-off latency of the machine. 
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
@@ -2182,6 +2243,9 @@ static long calc_load_fold_active(struct rq *this_rq)
 	return delta;
 }
 
+/*
+ * a1 = a0 * e + a * (1 - e)
+ */
 static unsigned long
 calc_load(unsigned long load, unsigned long exp, unsigned long active)
 {
@@ -2193,30 +2257,117 @@ calc_load(unsigned long load, unsigned long exp, unsigned long active)
 
 #ifdef CONFIG_NO_HZ
 /*
- * For NO_HZ we delay the active fold to the next LOAD_FREQ update.
+ * Handle NO_HZ for the global load-average.
+ *
+ * Since the above described distributed algorithm to compute the global
+ * load-average relies on per-cpu sampling from the tick, it is affected by
+ * NO_HZ.
+ *
+ * The basic idea is to fold the nr_active delta into a global idle load upon
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
+ *       0             5             10            15
+ *         +10           +10           +10           +10
+ *       |-|-----------|-|-----------|-|-----------|-|
+ *    r:001           110           001           110
+ *    w:011           100           011           100
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
+	 * next idle-load delta.
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
+	int idx;
 
+	/*
+	 * We're going into NOHZ mode, if there's any pending delta, fold it
+	 * into the pending idle delta.
+	 */
 	delta = calc_load_fold_active(this_rq);
-	if (delta)
-		atomic_long_add(delta, &calc_load_tasks_idle);
+	if (delta) {
+		idx = calc_load_write_idx();
+		atomic_long_add(delta, &calc_load_idle[idx]);
+	}
 }
 
-static long calc_load_fold_idle(void)
+void calc_load_exit_idle(void)
 {
-	long delta = 0;
+	struct rq *this_rq = this_rq();
 
 	/*
-	 * Its got a race, we don't care...
+	 * If we're still outside the sample window, we're done.
 	 */
-	if (atomic_long_read(&calc_load_tasks_idle))
-		delta = atomic_long_xchg(&calc_load_tasks_idle, 0);
+	if (time_before(jiffies, this_rq->calc_load_update))
+		return;
+
+	/*
+	 * We woke inside or after the sample window, this means another cpu
+	 * likely already accounted us through the nohz accounting, so skip the
+	 * entire deal and sync up for the next window.
+	 */
+	this_rq->calc_load_update = calc_load_update + LOAD_FREQ;
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
@@ -2302,66 +2453,39 @@ static void calc_global_nohz(void)
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
@@ -2369,11 +2493,35 @@ void get_avenrun(unsigned long *loads, unsigned long offset, int shift)
  */
 void calc_global_load(unsigned long ticks)
 {
-	long active;
+	long active, delta;
 
 	if (time_before(jiffies, calc_load_update + 10))
 		return;
 
+	/*
+	 * Fold the 'old' idle-delta to include all NO_HZ cpus.
+	 *
+	 *	cpu0	cpu1	cpu2	..
+	 *
+	 * >--- [sample A]
+	 *
+	 *			-> NOHZ
+	 *		-> NOHZ
+	 *	->NOHZ
+	 *
+	 * >--- [sample B]
+	 *
+	 * >--- [sample C]
+	 *
+	 *      NOHZ-> (here)
+	 *
+	 * Since all CPUs went into NOHZ state, all 'missed' samples (B, C)
+	 * should include the folded idle-delta.
+	 */
+	delta += calc_load_fold_idle();
+	if (delta)
+		atomic_long_add(delta, &calc_load_tasks);
+
 	active = atomic_long_read(&calc_load_tasks);
 	active = active > 0 ? active * FIXED_1 : 0;
 
@@ -2384,12 +2532,7 @@ void calc_global_load(unsigned long ticks)
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
@@ -2406,7 +2549,6 @@ static void calc_load_account_active(struct rq *this_rq)
 		return;
 
 	delta  = calc_load_fold_active(this_rq);
-	delta += calc_load_fold_idle();
 	if (delta)
 		atomic_long_add(delta, &calc_load_tasks);
 
@@ -2414,6 +2556,10 @@ static void calc_load_account_active(struct rq *this_rq)
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


