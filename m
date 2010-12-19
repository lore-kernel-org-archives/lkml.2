Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab0LSWah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 17:30:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56869 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260Ab0LSWag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 17:30:36 -0500
Date: Sun, 19 Dec 2010 23:30:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL, v2] scheduler fixes
Message-ID: <20101219223026.GA6237@elte.hu>
References: <20101219152713.GA20101@elte.hu>
 <AANLkTinJ8hAG1TpyC+CSYPR47p48+1=E7fiC45hMXT_1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinJ8hAG1TpyC+CSYPR47p48+1=E7fiC45hMXT_1@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, Dec 19, 2010 at 7:27 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > @@ -3943,6 +4128,7 @@ need_resched_nonpreemptible:
> >                rq->nr_switches++;
> >                rq->curr = next;
> >                ++*switch_count;
> > +               WARN_ON_ONCE(test_tsk_need_resched(next));
> >
> >                context_switch(rq, prev, next); /* unlocks the rq */
> >                /*
> > diff --git a/kernel/timer.c b/kern
> 
> Please don't add like this in an -rc. It looks like it's some
> debugging aid, I don't think it should have gone in now.

Yeah - sorry about that. The warning is bogus - please pull the updated tree below. 
(Can also be pulled on top of the previous one.)

Thanks,

	Ingo

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

------------------>
Heiko Carstens (1):
      nohz: Fix get_next_timer_interrupt() vs cpu hotplug

Ingo Molnar (1):
      sched: Remove debugging check

Mike Galbraith (1):
      Sched: fix skip_clock_update optimization

Peter Zijlstra (3):
      sched: Cure more NO_HZ load average woes
      sched: Fix the irqtime code to deal with u64 wraps
      sched: Fix the irqtime code for 32bit


 include/linux/sched.h |    2 +-
 kernel/fork.c         |    1 +
 kernel/sched.c        |  287 ++++++++++++++++++++++++++++++++++++++++---------
 kernel/timer.c        |    8 ++-
 4 files changed, 245 insertions(+), 53 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2c79e92..2238745 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -143,7 +143,7 @@ extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
 
 
-extern void calc_global_load(void);
+extern void calc_global_load(unsigned long ticks);
 
 extern unsigned long get_parent_ip(unsigned long addr);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 3b159c5..5447dc7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -273,6 +273,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 
 	setup_thread_stack(tsk, orig);
 	clear_user_return_notifier(tsk);
+	clear_tsk_need_resched(tsk);
 	stackend = end_of_stack(tsk);
 	*stackend = STACK_END_MAGIC;	/* for overflow detection */
 
diff --git a/kernel/sched.c b/kernel/sched.c
index dc91a4d..297d1a0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -636,22 +636,18 @@ static inline struct task_group *task_group(struct task_struct *p)
 
 #endif /* CONFIG_CGROUP_SCHED */
 
-static u64 irq_time_cpu(int cpu);
-static void sched_irq_time_avg_update(struct rq *rq, u64 irq_time);
+static void update_rq_clock_task(struct rq *rq, s64 delta);
 
-inline void update_rq_clock(struct rq *rq)
+static void update_rq_clock(struct rq *rq)
 {
-	if (!rq->skip_clock_update) {
-		int cpu = cpu_of(rq);
-		u64 irq_time;
+	s64 delta;
 
-		rq->clock = sched_clock_cpu(cpu);
-		irq_time = irq_time_cpu(cpu);
-		if (rq->clock - irq_time > rq->clock_task)
-			rq->clock_task = rq->clock - irq_time;
+	if (rq->skip_clock_update)
+		return;
 
-		sched_irq_time_avg_update(rq, irq_time);
-	}
+	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
+	rq->clock += delta;
+	update_rq_clock_task(rq, delta);
 }
 
 /*
@@ -1924,10 +1920,9 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
  * They are read and saved off onto struct rq in update_rq_clock().
  * This may result in other CPU reading this CPU's irq time and can
  * race with irq/account_system_vtime on this CPU. We would either get old
- * or new value (or semi updated value on 32 bit) with a side effect of
- * accounting a slice of irq time to wrong task when irq is in progress
- * while we read rq->clock. That is a worthy compromise in place of having
- * locks on each irq in account_system_time.
+ * or new value with a side effect of accounting a slice of irq time to wrong
+ * task when irq is in progress while we read rq->clock. That is a worthy
+ * compromise in place of having locks on each irq in account_system_time.
  */
 static DEFINE_PER_CPU(u64, cpu_hardirq_time);
 static DEFINE_PER_CPU(u64, cpu_softirq_time);
@@ -1945,19 +1940,58 @@ void disable_sched_clock_irqtime(void)
 	sched_clock_irqtime = 0;
 }
 
-static u64 irq_time_cpu(int cpu)
+#ifndef CONFIG_64BIT
+static DEFINE_PER_CPU(seqcount_t, irq_time_seq);
+
+static inline void irq_time_write_begin(void)
 {
-	if (!sched_clock_irqtime)
-		return 0;
+	__this_cpu_inc(irq_time_seq.sequence);
+	smp_wmb();
+}
+
+static inline void irq_time_write_end(void)
+{
+	smp_wmb();
+	__this_cpu_inc(irq_time_seq.sequence);
+}
+
+static inline u64 irq_time_read(int cpu)
+{
+	u64 irq_time;
+	unsigned seq;
 
+	do {
+		seq = read_seqcount_begin(&per_cpu(irq_time_seq, cpu));
+		irq_time = per_cpu(cpu_softirq_time, cpu) +
+			   per_cpu(cpu_hardirq_time, cpu);
+	} while (read_seqcount_retry(&per_cpu(irq_time_seq, cpu), seq));
+
+	return irq_time;
+}
+#else /* CONFIG_64BIT */
+static inline void irq_time_write_begin(void)
+{
+}
+
+static inline void irq_time_write_end(void)
+{
+}
+
+static inline u64 irq_time_read(int cpu)
+{
 	return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
 }
+#endif /* CONFIG_64BIT */
 
+/*
+ * Called before incrementing preempt_count on {soft,}irq_enter
+ * and before decrementing preempt_count on {soft,}irq_exit.
+ */
 void account_system_vtime(struct task_struct *curr)
 {
 	unsigned long flags;
+	s64 delta;
 	int cpu;
-	u64 now, delta;
 
 	if (!sched_clock_irqtime)
 		return;
@@ -1965,9 +1999,10 @@ void account_system_vtime(struct task_struct *curr)
 	local_irq_save(flags);
 
 	cpu = smp_processor_id();
-	now = sched_clock_cpu(cpu);
-	delta = now - per_cpu(irq_start_time, cpu);
-	per_cpu(irq_start_time, cpu) = now;
+	delta = sched_clock_cpu(cpu) - __this_cpu_read(irq_start_time);
+	__this_cpu_add(irq_start_time, delta);
+
+	irq_time_write_begin();
 	/*
 	 * We do not account for softirq time from ksoftirqd here.
 	 * We want to continue accounting softirq time to ksoftirqd thread
@@ -1975,33 +2010,55 @@ void account_system_vtime(struct task_struct *curr)
 	 * that do not consume any time, but still wants to run.
 	 */
 	if (hardirq_count())
-		per_cpu(cpu_hardirq_time, cpu) += delta;
+		__this_cpu_add(cpu_hardirq_time, delta);
 	else if (in_serving_softirq() && !(curr->flags & PF_KSOFTIRQD))
-		per_cpu(cpu_softirq_time, cpu) += delta;
+		__this_cpu_add(cpu_softirq_time, delta);
 
+	irq_time_write_end();
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(account_system_vtime);
 
-static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time)
+static void update_rq_clock_task(struct rq *rq, s64 delta)
 {
-	if (sched_clock_irqtime && sched_feat(NONIRQ_POWER)) {
-		u64 delta_irq = curr_irq_time - rq->prev_irq_time;
-		rq->prev_irq_time = curr_irq_time;
-		sched_rt_avg_update(rq, delta_irq);
-	}
+	s64 irq_delta;
+
+	irq_delta = irq_time_read(cpu_of(rq)) - rq->prev_irq_time;
+
+	/*
+	 * Since irq_time is only updated on {soft,}irq_exit, we might run into
+	 * this case when a previous update_rq_clock() happened inside a
+	 * {soft,}irq region.
+	 *
+	 * When this happens, we stop ->clock_task and only update the
+	 * prev_irq_time stamp to account for the part that fit, so that a next
+	 * update will consume the rest. This ensures ->clock_task is
+	 * monotonic.
+	 *
+	 * It does however cause some slight miss-attribution of {soft,}irq
+	 * time, a more accurate solution would be to update the irq_time using
+	 * the current rq->clock timestamp, except that would require using
+	 * atomic ops.
+	 */
+	if (irq_delta > delta)
+		irq_delta = delta;
+
+	rq->prev_irq_time += irq_delta;
+	delta -= irq_delta;
+	rq->clock_task += delta;
+
+	if (irq_delta && sched_feat(NONIRQ_POWER))
+		sched_rt_avg_update(rq, irq_delta);
 }
 
-#else
+#else /* CONFIG_IRQ_TIME_ACCOUNTING */
 
-static u64 irq_time_cpu(int cpu)
+static void update_rq_clock_task(struct rq *rq, s64 delta)
 {
-	return 0;
+	rq->clock_task += delta;
 }
 
-static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time) { }
-
-#endif
+#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
 
 #include "sched_idletask.c"
 #include "sched_fair.c"
@@ -2129,7 +2186,7 @@ static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 	 * A queue event has occurred, and we're going to schedule.  In
 	 * this case, we can save a useless back to back clock update.
 	 */
-	if (test_tsk_need_resched(rq->curr))
+	if (rq->curr->se.on_rq && test_tsk_need_resched(rq->curr))
 		rq->skip_clock_update = 1;
 }
 
@@ -3119,6 +3176,15 @@ static long calc_load_fold_active(struct rq *this_rq)
 	return delta;
 }
 
+static unsigned long
+calc_load(unsigned long load, unsigned long exp, unsigned long active)
+{
+	load *= exp;
+	load += active * (FIXED_1 - exp);
+	load += 1UL << (FSHIFT - 1);
+	return load >> FSHIFT;
+}
+
 #ifdef CONFIG_NO_HZ
 /*
  * For NO_HZ we delay the active fold to the next LOAD_FREQ update.
@@ -3148,6 +3214,128 @@ static long calc_load_fold_idle(void)
 
 	return delta;
 }
+
+/**
+ * fixed_power_int - compute: x^n, in O(log n) time
+ *
+ * @x:         base of the power
+ * @frac_bits: fractional bits of @x
+ * @n:         power to raise @x to.
+ *
+ * By exploiting the relation between the definition of the natural power
+ * function: x^n := x*x*...*x (x multiplied by itself for n times), and
+ * the binary encoding of numbers used by computers: n := \Sum n_i * 2^i,
+ * (where: n_i \elem {0, 1}, the binary vector representing n),
+ * we find: x^n := x^(\Sum n_i * 2^i) := \Prod x^(n_i * 2^i), which is
+ * of course trivially computable in O(log_2 n), the length of our binary
+ * vector.
+ */
+static unsigned long
+fixed_power_int(unsigned long x, unsigned int frac_bits, unsigned int n)
+{
+	unsigned long result = 1UL << frac_bits;
+
+	if (n) for (;;) {
+		if (n & 1) {
+			result *= x;
+			result += 1UL << (frac_bits - 1);
+			result >>= frac_bits;
+		}
+		n >>= 1;
+		if (!n)
+			break;
+		x *= x;
+		x += 1UL << (frac_bits - 1);
+		x >>= frac_bits;
+	}
+
+	return result;
+}
+
+/*
+ * a1 = a0 * e + a * (1 - e)
+ *
+ * a2 = a1 * e + a * (1 - e)
+ *    = (a0 * e + a * (1 - e)) * e + a * (1 - e)
+ *    = a0 * e^2 + a * (1 - e) * (1 + e)
+ *
+ * a3 = a2 * e + a * (1 - e)
+ *    = (a0 * e^2 + a * (1 - e) * (1 + e)) * e + a * (1 - e)
+ *    = a0 * e^3 + a * (1 - e) * (1 + e + e^2)
+ *
+ *  ...
+ *
+ * an = a0 * e^n + a * (1 - e) * (1 + e + ... + e^n-1) [1]
+ *    = a0 * e^n + a * (1 - e) * (1 - e^n)/(1 - e)
+ *    = a0 * e^n + a * (1 - e^n)
+ *
+ * [1] application of the geometric series:
+ *
+ *              n         1 - x^(n+1)
+ *     S_n := \Sum x^i = -------------
+ *             i=0          1 - x
+ */
+static unsigned long
+calc_load_n(unsigned long load, unsigned long exp,
+	    unsigned long active, unsigned int n)
+{
+
+	return calc_load(load, fixed_power_int(exp, FSHIFT, n), active);
+}
+
+/*
+ * NO_HZ can leave us missing all per-cpu ticks calling
+ * calc_load_account_active(), but since an idle CPU folds its delta into
+ * calc_load_tasks_idle per calc_load_account_idle(), all we need to do is fold
+ * in the pending idle delta if our idle period crossed a load cycle boundary.
+ *
+ * Once we've updated the global active value, we need to apply the exponential
+ * weights adjusted to the number of cycles missed.
+ */
+static void calc_global_nohz(unsigned long ticks)
+{
+	long delta, active, n;
+
+	if (time_before(jiffies, calc_load_update))
+		return;
+
+	/*
+	 * If we crossed a calc_load_update boundary, make sure to fold
+	 * any pending idle changes, the respective CPUs might have
+	 * missed the tick driven calc_load_account_active() update
+	 * due to NO_HZ.
+	 */
+	delta = calc_load_fold_idle();
+	if (delta)
+		atomic_long_add(delta, &calc_load_tasks);
+
+	/*
+	 * If we were idle for multiple load cycles, apply them.
+	 */
+	if (ticks >= LOAD_FREQ) {
+		n = ticks / LOAD_FREQ;
+
+		active = atomic_long_read(&calc_load_tasks);
+		active = active > 0 ? active * FIXED_1 : 0;
+
+		avenrun[0] = calc_load_n(avenrun[0], EXP_1, active, n);
+		avenrun[1] = calc_load_n(avenrun[1], EXP_5, active, n);
+		avenrun[2] = calc_load_n(avenrun[2], EXP_15, active, n);
+
+		calc_load_update += n * LOAD_FREQ;
+	}
+
+	/*
+	 * Its possible the remainder of the above division also crosses
+	 * a LOAD_FREQ period, the regular check in calc_global_load()
+	 * which comes after this will take care of that.
+	 *
+	 * Consider us being 11 ticks before a cycle completion, and us
+	 * sleeping for 4*LOAD_FREQ + 22 ticks, then the above code will
+	 * age us 4 cycles, and the test in calc_global_load() will
+	 * pick up the final one.
+	 */
+}
 #else
 static void calc_load_account_idle(struct rq *this_rq)
 {
@@ -3157,6 +3345,10 @@ static inline long calc_load_fold_idle(void)
 {
 	return 0;
 }
+
+static void calc_global_nohz(unsigned long ticks)
+{
+}
 #endif
 
 /**
@@ -3174,24 +3366,17 @@ void get_avenrun(unsigned long *loads, unsigned long offset, int shift)
 	loads[2] = (avenrun[2] + offset) << shift;
 }
 
-static unsigned long
-calc_load(unsigned long load, unsigned long exp, unsigned long active)
-{
-	load *= exp;
-	load += active * (FIXED_1 - exp);
-	return load >> FSHIFT;
-}
-
 /*
  * calc_load - update the avenrun load estimates 10 ticks after the
  * CPUs have updated calc_load_tasks.
  */
-void calc_global_load(void)
+void calc_global_load(unsigned long ticks)
 {
-	unsigned long upd = calc_load_update + 10;
 	long active;
 
-	if (time_before(jiffies, upd))
+	calc_global_nohz(ticks);
+
+	if (time_before(jiffies, calc_load_update + 10))
 		return;
 
 	active = atomic_long_read(&calc_load_tasks);
@@ -3845,7 +4030,6 @@ static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
 	if (prev->se.on_rq)
 		update_rq_clock(rq);
-	rq->skip_clock_update = 0;
 	prev->sched_class->put_prev_task(rq, prev);
 }
 
@@ -3903,7 +4087,6 @@ need_resched_nonpreemptible:
 		hrtick_clear(rq);
 
 	raw_spin_lock_irq(&rq->lock);
-	clear_tsk_need_resched(prev);
 
 	switch_count = &prev->nivcsw;
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
@@ -3935,6 +4118,8 @@ need_resched_nonpreemptible:
 
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
+	clear_tsk_need_resched(prev);
+	rq->skip_clock_update = 0;
 
 	if (likely(prev != next)) {
 		sched_info_switch(prev, next);
diff --git a/kernel/timer.c b/kernel/timer.c
index 68a9ae7..353b922 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1252,6 +1252,12 @@ unsigned long get_next_timer_interrupt(unsigned long now)
 	struct tvec_base *base = __get_cpu_var(tvec_bases);
 	unsigned long expires;
 
+	/*
+	 * Pretend that there is no timer pending if the cpu is offline.
+	 * Possible pending timers will be migrated later to an active cpu.
+	 */
+	if (cpu_is_offline(smp_processor_id()))
+		return now + NEXT_TIMER_MAX_DELTA;
 	spin_lock(&base->lock);
 	if (time_before_eq(base->next_timer, base->timer_jiffies))
 		base->next_timer = __next_timer_interrupt(base);
@@ -1319,7 +1325,7 @@ void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
 	update_wall_time();
-	calc_global_load();
+	calc_global_load(ticks);
 }
 
 #ifdef __ARCH_WANT_SYS_ALARM
