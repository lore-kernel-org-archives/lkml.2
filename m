Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463Ab1COUFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:05:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38909 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758191Ab1COUFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:05:43 -0400
Date: Tue, 15 Mar 2011 21:05:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler changes for v2.6.39
Message-ID: <20110315200526.GA15330@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-core-for-linus

 Thanks,

	Ingo

------------------>
Darren Hart (2):
      sched: Allow SCHED_BATCH to preempt SCHED_IDLE tasks
      sched: Allow users with sufficient RLIMIT_NICE to change from SCHED_IDLE policy

Heiko Carstens (1):
      sched: Add #ifdef around irq time accounting functions

Mike Galbraith (2):
      sched: Add yield_to(task, preempt) functionality
      sched, autogroup: Stop claiming ownership of the root task group

Paul Turner (2):
      sched: Simplify update_cfs_shares parameters
      sched: Avoid expensive initial update_cfs_load()

Peter Zijlstra (6):
      sched: Simplify the idle scheduling class
      sched: Fix switch_from_fair()
      sched: Avoid expensive initial update_cfs_load(), on UP too
      sched: Clean up remnants of sd_idle
      sched: Clean up some f_b_g() comments
      sched: Fix the group_imb logic

Rik van Riel (3):
      sched: Check the right ->nr_running in yield_task_fair()
      sched: Limit the scope of clear_buddies
      sched: Use a buddy to implement yield_task_fair()

Venkatesh Pallipadi (8):
      softirqs: Free up pf flag PF_KSOFTIRQD
      time: Add nsecs_to_cputime64 interface for asm-generic
      sched: Refactor account_system_time separating id-update
      sched: Export ns irqtimes through /proc/stat
      softirqs: Account ksoftirqd time as cpustat softirq
      sched: Wholesale removal of sd_idle logic
      sched: Clean up the IRQ_TIME_ACCOUNTING code
      sched: Resched proper CPU on yield_to()

Yong Zhang (2):
      sched, autogroup, sysctl: Use proc_dointvec_minmax() instead
      sched, autogroup: Stop going ahead if autogroup is disabled


 include/asm-generic/cputime.h |    3 +
 include/linux/interrupt.h     |    7 +
 include/linux/jiffies.h       |    1 +
 include/linux/sched.h         |   13 +-
 kernel/sched.c                |  296 +++++++++++++++++++++++++++----
 kernel/sched_autogroup.c      |   15 +-
 kernel/sched_autogroup.h      |    5 +
 kernel/sched_debug.c          |    2 +-
 kernel/sched_fair.c           |  397 ++++++++++++++++++++++++-----------------
 kernel/sched_idletask.c       |   26 +---
 kernel/sched_rt.c             |   19 +-
 kernel/sched_stoptask.c       |    7 +-
 kernel/softirq.c              |    3 +-
 kernel/sysctl.c               |    9 +-
 kernel/time.c                 |   23 +++-
 15 files changed, 565 insertions(+), 261 deletions(-)

diff --git a/include/asm-generic/cputime.h b/include/asm-generic/cputime.h
index 2bcc5c7..61e03dd 100644
--- a/include/asm-generic/cputime.h
+++ b/include/asm-generic/cputime.h
@@ -30,6 +30,9 @@ typedef u64 cputime64_t;
 #define cputime64_to_jiffies64(__ct)	(__ct)
 #define jiffies64_to_cputime64(__jif)	(__jif)
 #define cputime_to_cputime64(__ct)	((u64) __ct)
+#define cputime64_gt(__a, __b)		((__a) >  (__b))
+
+#define nsecs_to_cputime64(__ct)	nsecs_to_jiffies64(__ct)
 
 
 /*
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 55e0d42..a1382b9 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -426,6 +426,13 @@ extern void raise_softirq(unsigned int nr);
  */
 DECLARE_PER_CPU(struct list_head [NR_SOFTIRQS], softirq_work_list);
 
+DECLARE_PER_CPU(struct task_struct *, ksoftirqd);
+
+static inline struct task_struct *this_cpu_ksoftirqd(void)
+{
+	return this_cpu_read(ksoftirqd);
+}
+
 /* Try to send a softirq to a remote cpu.  If this cannot be done, the
  * work will be queued to the local cpu.
  */
diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 6811f4b..922aa31 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -307,6 +307,7 @@ extern clock_t jiffies_to_clock_t(long x);
 extern unsigned long clock_t_to_jiffies(unsigned long x);
 extern u64 jiffies_64_to_clock_t(u64 x);
 extern u64 nsec_to_clock_t(u64 x);
+extern u64 nsecs_to_jiffies64(u64 n);
 extern unsigned long nsecs_to_jiffies(u64 n);
 
 #define TIMESTAMP_SIZE	30
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 777d8a5..755c476 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1058,6 +1058,7 @@ struct sched_class {
 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int flags);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int flags);
 	void (*yield_task) (struct rq *rq);
+	bool (*yield_to_task) (struct rq *rq, struct task_struct *p, bool preempt);
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
 
@@ -1084,12 +1085,10 @@ struct sched_class {
 	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
 	void (*task_fork) (struct task_struct *p);
 
-	void (*switched_from) (struct rq *this_rq, struct task_struct *task,
-			       int running);
-	void (*switched_to) (struct rq *this_rq, struct task_struct *task,
-			     int running);
+	void (*switched_from) (struct rq *this_rq, struct task_struct *task);
+	void (*switched_to) (struct rq *this_rq, struct task_struct *task);
 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
-			     int oldprio, int running);
+			     int oldprio);
 
 	unsigned int (*get_rr_interval) (struct rq *rq,
 					 struct task_struct *task);
@@ -1715,7 +1714,6 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 /*
  * Per process flags
  */
-#define PF_KSOFTIRQD	0x00000001	/* I am ksoftirqd */
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
@@ -1945,8 +1943,6 @@ int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
 
-extern unsigned int sysctl_sched_compat_yield;
-
 #ifdef CONFIG_SCHED_AUTOGROUP
 extern unsigned int sysctl_sched_autogroup_enabled;
 
@@ -1977,6 +1973,7 @@ static inline int rt_mutex_getprio(struct task_struct *p)
 # define rt_mutex_adjust_pi(p)		do { } while (0)
 #endif
 
+extern bool yield_to(struct task_struct *p, bool preempt);
 extern void set_user_nice(struct task_struct *p, long nice);
 extern int task_prio(const struct task_struct *p);
 extern int task_nice(const struct task_struct *p);
diff --git a/kernel/sched.c b/kernel/sched.c
index 18d38e4..61452e8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -324,7 +324,7 @@ struct cfs_rq {
 	 * 'curr' points to currently running entity on this cfs_rq.
 	 * It is set to NULL otherwise (i.e when none are currently running).
 	 */
-	struct sched_entity *curr, *next, *last;
+	struct sched_entity *curr, *next, *last, *skip;
 
 	unsigned int nr_spread_over;
 
@@ -1686,6 +1686,39 @@ static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
 		__release(rq2->lock);
 }
 
+#else /* CONFIG_SMP */
+
+/*
+ * double_rq_lock - safely lock two runqueues
+ *
+ * Note this does not disable interrupts like task_rq_lock,
+ * you need to do so manually before calling.
+ */
+static void double_rq_lock(struct rq *rq1, struct rq *rq2)
+	__acquires(rq1->lock)
+	__acquires(rq2->lock)
+{
+	BUG_ON(!irqs_disabled());
+	BUG_ON(rq1 != rq2);
+	raw_spin_lock(&rq1->lock);
+	__acquire(rq2->lock);	/* Fake it out ;) */
+}
+
+/*
+ * double_rq_unlock - safely unlock two runqueues
+ *
+ * Note this does not restore interrupts like task_rq_unlock,
+ * you need to do so manually after calling.
+ */
+static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
+	__releases(rq1->lock)
+	__releases(rq2->lock)
+{
+	BUG_ON(rq1 != rq2);
+	raw_spin_unlock(&rq1->lock);
+	__release(rq2->lock);
+}
+
 #endif
 
 static void calc_load_account_idle(struct rq *this_rq);
@@ -1880,7 +1913,7 @@ void account_system_vtime(struct task_struct *curr)
 	 */
 	if (hardirq_count())
 		__this_cpu_add(cpu_hardirq_time, delta);
-	else if (in_serving_softirq() && !(curr->flags & PF_KSOFTIRQD))
+	else if (in_serving_softirq() && curr != this_cpu_ksoftirqd())
 		__this_cpu_add(cpu_softirq_time, delta);
 
 	irq_time_write_end();
@@ -1920,8 +1953,40 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 		sched_rt_avg_update(rq, irq_delta);
 }
 
+static int irqtime_account_hi_update(void)
+{
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	unsigned long flags;
+	u64 latest_ns;
+	int ret = 0;
+
+	local_irq_save(flags);
+	latest_ns = this_cpu_read(cpu_hardirq_time);
+	if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat->irq))
+		ret = 1;
+	local_irq_restore(flags);
+	return ret;
+}
+
+static int irqtime_account_si_update(void)
+{
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	unsigned long flags;
+	u64 latest_ns;
+	int ret = 0;
+
+	local_irq_save(flags);
+	latest_ns = this_cpu_read(cpu_softirq_time);
+	if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat->softirq))
+		ret = 1;
+	local_irq_restore(flags);
+	return ret;
+}
+
 #else /* CONFIG_IRQ_TIME_ACCOUNTING */
 
+#define sched_clock_irqtime	(0)
+
 static void update_rq_clock_task(struct rq *rq, s64 delta)
 {
 	rq->clock_task += delta;
@@ -2025,14 +2090,14 @@ inline int task_curr(const struct task_struct *p)
 
 static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 				       const struct sched_class *prev_class,
-				       int oldprio, int running)
+				       int oldprio)
 {
 	if (prev_class != p->sched_class) {
 		if (prev_class->switched_from)
-			prev_class->switched_from(rq, p, running);
-		p->sched_class->switched_to(rq, p, running);
-	} else
-		p->sched_class->prio_changed(rq, p, oldprio, running);
+			prev_class->switched_from(rq, p);
+		p->sched_class->switched_to(rq, p);
+	} else if (oldprio != p->prio)
+		p->sched_class->prio_changed(rq, p, oldprio);
 }
 
 static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
@@ -2566,6 +2631,7 @@ static void __sched_fork(struct task_struct *p)
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.nr_migrations		= 0;
+	p->se.vruntime			= 0;
 
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
@@ -3568,6 +3634,32 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 }
 
 /*
+ * Account system cpu time to a process and desired cpustat field
+ * @p: the process that the cpu time gets accounted to
+ * @cputime: the cpu time spent in kernel space since the last update
+ * @cputime_scaled: cputime scaled by cpu frequency
+ * @target_cputime64: pointer to cpustat field that has to be updated
+ */
+static inline
+void __account_system_time(struct task_struct *p, cputime_t cputime,
+			cputime_t cputime_scaled, cputime64_t *target_cputime64)
+{
+	cputime64_t tmp = cputime_to_cputime64(cputime);
+
+	/* Add system time to process. */
+	p->stime = cputime_add(p->stime, cputime);
+	p->stimescaled = cputime_add(p->stimescaled, cputime_scaled);
+	account_group_system_time(p, cputime);
+
+	/* Add system time to cpustat. */
+	*target_cputime64 = cputime64_add(*target_cputime64, tmp);
+	cpuacct_update_stats(p, CPUACCT_STAT_SYSTEM, cputime);
+
+	/* Account for system time used */
+	acct_update_integrals(p);
+}
+
+/*
  * Account system cpu time to a process.
  * @p: the process that the cpu time gets accounted to
  * @hardirq_offset: the offset to subtract from hardirq_count()
@@ -3578,36 +3670,26 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 			 cputime_t cputime, cputime_t cputime_scaled)
 {
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	cputime64_t tmp;
+	cputime64_t *target_cputime64;
 
 	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
 		account_guest_time(p, cputime, cputime_scaled);
 		return;
 	}
 
-	/* Add system time to process. */
-	p->stime = cputime_add(p->stime, cputime);
-	p->stimescaled = cputime_add(p->stimescaled, cputime_scaled);
-	account_group_system_time(p, cputime);
-
-	/* Add system time to cpustat. */
-	tmp = cputime_to_cputime64(cputime);
 	if (hardirq_count() - hardirq_offset)
-		cpustat->irq = cputime64_add(cpustat->irq, tmp);
+		target_cputime64 = &cpustat->irq;
 	else if (in_serving_softirq())
-		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
+		target_cputime64 = &cpustat->softirq;
 	else
-		cpustat->system = cputime64_add(cpustat->system, tmp);
-
-	cpuacct_update_stats(p, CPUACCT_STAT_SYSTEM, cputime);
+		target_cputime64 = &cpustat->system;
 
-	/* Account for system time used */
-	acct_update_integrals(p);
+	__account_system_time(p, cputime, cputime_scaled, target_cputime64);
 }
 
 /*
  * Account for involuntary wait time.
- * @steal: the cpu time spent in involuntary wait
+ * @cputime: the cpu time spent in involuntary wait
  */
 void account_steal_time(cputime_t cputime)
 {
@@ -3635,6 +3717,73 @@ void account_idle_time(cputime_t cputime)
 
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+/*
+ * Account a tick to a process and cpustat
+ * @p: the process that the cpu time gets accounted to
+ * @user_tick: is the tick from userspace
+ * @rq: the pointer to rq
+ *
+ * Tick demultiplexing follows the order
+ * - pending hardirq update
+ * - pending softirq update
+ * - user_time
+ * - idle_time
+ * - system time
+ *   - check for guest_time
+ *   - else account as system_time
+ *
+ * Check for hardirq is done both for system and user time as there is
+ * no timer going off while we are on hardirq and hence we may never get an
+ * opportunity to update it solely in system time.
+ * p->stime and friends are only updated on system time and not on irq
+ * softirq as those do not count in task exec_runtime any more.
+ */
+static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
+						struct rq *rq)
+{
+	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
+	cputime64_t tmp = cputime_to_cputime64(cputime_one_jiffy);
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+
+	if (irqtime_account_hi_update()) {
+		cpustat->irq = cputime64_add(cpustat->irq, tmp);
+	} else if (irqtime_account_si_update()) {
+		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
+	} else if (this_cpu_ksoftirqd() == p) {
+		/*
+		 * ksoftirqd time do not get accounted in cpu_softirq_time.
+		 * So, we have to handle it separately here.
+		 * Also, p->stime needs to be updated for ksoftirqd.
+		 */
+		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
+					&cpustat->softirq);
+	} else if (user_tick) {
+		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
+	} else if (p == rq->idle) {
+		account_idle_time(cputime_one_jiffy);
+	} else if (p->flags & PF_VCPU) { /* System time or guest time */
+		account_guest_time(p, cputime_one_jiffy, one_jiffy_scaled);
+	} else {
+		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
+					&cpustat->system);
+	}
+}
+
+static void irqtime_account_idle_ticks(int ticks)
+{
+	int i;
+	struct rq *rq = this_rq();
+
+	for (i = 0; i < ticks; i++)
+		irqtime_account_process_tick(current, 0, rq);
+}
+#else /* CONFIG_IRQ_TIME_ACCOUNTING */
+static void irqtime_account_idle_ticks(int ticks) {}
+static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
+						struct rq *rq) {}
+#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
+
 /*
  * Account a single tick of cpu time.
  * @p: the process that the cpu time gets accounted to
@@ -3645,6 +3794,11 @@ void account_process_tick(struct task_struct *p, int user_tick)
 	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
 	struct rq *rq = this_rq();
 
+	if (sched_clock_irqtime) {
+		irqtime_account_process_tick(p, user_tick, rq);
+		return;
+	}
+
 	if (user_tick)
 		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))
@@ -3670,6 +3824,12 @@ void account_steal_ticks(unsigned long ticks)
  */
 void account_idle_ticks(unsigned long ticks)
 {
+
+	if (sched_clock_irqtime) {
+		irqtime_account_idle_ticks(ticks);
+		return;
+	}
+
 	account_idle_time(jiffies_to_cputime(ticks));
 }
 
@@ -4570,11 +4730,10 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
-	if (on_rq) {
+	if (on_rq)
 		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
 
-		check_class_changed(rq, p, prev_class, oldprio, running);
-	}
+	check_class_changed(rq, p, prev_class, oldprio);
 	task_rq_unlock(rq, &flags);
 }
 
@@ -4822,12 +4981,15 @@ recheck:
 			    param->sched_priority > rlim_rtprio)
 				return -EPERM;
 		}
+
 		/*
-		 * Like positive nice levels, dont allow tasks to
-		 * move out of SCHED_IDLE either:
+		 * Treat SCHED_IDLE as nice 20. Only allow a switch to
+		 * SCHED_NORMAL if the RLIMIT_NICE would normally permit it.
 		 */
-		if (p->policy == SCHED_IDLE && policy != SCHED_IDLE)
-			return -EPERM;
+		if (p->policy == SCHED_IDLE && policy != SCHED_IDLE) {
+			if (!can_nice(p, TASK_NICE(p)))
+				return -EPERM;
+		}
 
 		/* can't change other user's priorities */
 		if (!check_same_owner(p))
@@ -4902,11 +5064,10 @@ recheck:
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
-	if (on_rq) {
+	if (on_rq)
 		activate_task(rq, p, 0);
 
-		check_class_changed(rq, p, prev_class, oldprio, running);
-	}
+	check_class_changed(rq, p, prev_class, oldprio);
 	__task_rq_unlock(rq);
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
@@ -5323,6 +5484,65 @@ void __sched yield(void)
 }
 EXPORT_SYMBOL(yield);
 
+/**
+ * yield_to - yield the current processor to another thread in
+ * your thread group, or accelerate that thread toward the
+ * processor it's on.
+ *
+ * It's the caller's job to ensure that the target task struct
+ * can't go away on us before we can do any checks.
+ *
+ * Returns true if we indeed boosted the target task.
+ */
+bool __sched yield_to(struct task_struct *p, bool preempt)
+{
+	struct task_struct *curr = current;
+	struct rq *rq, *p_rq;
+	unsigned long flags;
+	bool yielded = 0;
+
+	local_irq_save(flags);
+	rq = this_rq();
+
+again:
+	p_rq = task_rq(p);
+	double_rq_lock(rq, p_rq);
+	while (task_rq(p) != p_rq) {
+		double_rq_unlock(rq, p_rq);
+		goto again;
+	}
+
+	if (!curr->sched_class->yield_to_task)
+		goto out;
+
+	if (curr->sched_class != p->sched_class)
+		goto out;
+
+	if (task_running(p_rq, p) || p->state)
+		goto out;
+
+	yielded = curr->sched_class->yield_to_task(rq, p, preempt);
+	if (yielded) {
+		schedstat_inc(rq, yld_count);
+		/*
+		 * Make p's CPU reschedule; pick_next_entity takes care of
+		 * fairness.
+		 */
+		if (preempt && rq != p_rq)
+			resched_task(p_rq->curr);
+	}
+
+out:
+	double_rq_unlock(rq, p_rq);
+	local_irq_restore(flags);
+
+	if (yielded)
+		schedule();
+
+	return yielded;
+}
+EXPORT_SYMBOL_GPL(yield_to);
+
 /*
  * This task is about to go to sleep on IO. Increment rq->nr_iowait so
  * that process accounting knows that this is a task in IO wait state.
@@ -7796,6 +8016,10 @@ static void init_cfs_rq(struct cfs_rq *cfs_rq, struct rq *rq)
 	INIT_LIST_HEAD(&cfs_rq->tasks);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	cfs_rq->rq = rq;
+	/* allow initial update_cfs_load() to truncate */
+#ifdef CONFIG_SMP
+	cfs_rq->load_stamp = 1;
+#endif
 #endif
 	cfs_rq->min_vruntime = (u64)(-(1LL << 20));
 }
@@ -8109,6 +8333,8 @@ EXPORT_SYMBOL(__might_sleep);
 #ifdef CONFIG_MAGIC_SYSRQ
 static void normalize_task(struct rq *rq, struct task_struct *p)
 {
+	const struct sched_class *prev_class = p->sched_class;
+	int old_prio = p->prio;
 	int on_rq;
 
 	on_rq = p->se.on_rq;
@@ -8119,6 +8345,8 @@ static void normalize_task(struct rq *rq, struct task_struct *p)
 		activate_task(rq, p, 0);
 		resched_task(rq->curr);
 	}
+
+	check_class_changed(rq, p, prev_class, old_prio);
 }
 
 void normalize_rt_tasks(void)
@@ -8510,7 +8738,7 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 		/* Propagate contribution to hierarchy */
 		raw_spin_lock_irqsave(&rq->lock, flags);
 		for_each_sched_entity(se)
-			update_cfs_shares(group_cfs_rq(se), 0);
+			update_cfs_shares(group_cfs_rq(se));
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
 	}
 
diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index 9fb6562..5946ac5 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -12,7 +12,6 @@ static atomic_t autogroup_seq_nr;
 static void __init autogroup_init(struct task_struct *init_task)
 {
 	autogroup_default.tg = &root_task_group;
-	root_task_group.autogroup = &autogroup_default;
 	kref_init(&autogroup_default.kref);
 	init_rwsem(&autogroup_default.lock);
 	init_task->signal->autogroup = &autogroup_default;
@@ -130,7 +129,7 @@ task_wants_autogroup(struct task_struct *p, struct task_group *tg)
 
 static inline bool task_group_is_autogroup(struct task_group *tg)
 {
-	return tg != &root_task_group && tg->autogroup;
+	return !!tg->autogroup;
 }
 
 static inline struct task_group *
@@ -161,11 +160,15 @@ autogroup_move_group(struct task_struct *p, struct autogroup *ag)
 
 	p->signal->autogroup = autogroup_kref_get(ag);
 
+	if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
+		goto out;
+
 	t = p;
 	do {
 		sched_move_task(t);
 	} while_each_thread(p, t);
 
+out:
 	unlock_task_sighand(p, &flags);
 	autogroup_kref_put(prev);
 }
@@ -247,10 +250,14 @@ void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m)
 {
 	struct autogroup *ag = autogroup_task_get(p);
 
+	if (!task_group_is_autogroup(ag->tg))
+		goto out;
+
 	down_read(&ag->lock);
 	seq_printf(m, "/autogroup-%ld nice %d\n", ag->id, ag->nice);
 	up_read(&ag->lock);
 
+out:
 	autogroup_kref_put(ag);
 }
 #endif /* CONFIG_PROC_FS */
@@ -258,9 +265,7 @@ void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m)
 #ifdef CONFIG_SCHED_DEBUG
 static inline int autogroup_path(struct task_group *tg, char *buf, int buflen)
 {
-	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
-
-	if (!enabled || !tg->autogroup)
+	if (!task_group_is_autogroup(tg))
 		return 0;
 
 	return snprintf(buf, buflen, "%s-%ld", "/autogroup", tg->autogroup->id);
diff --git a/kernel/sched_autogroup.h b/kernel/sched_autogroup.h
index 7b859ff..0557705 100644
--- a/kernel/sched_autogroup.h
+++ b/kernel/sched_autogroup.h
@@ -1,6 +1,11 @@
 #ifdef CONFIG_SCHED_AUTOGROUP
 
 struct autogroup {
+	/*
+	 * reference doesn't mean how many thread attach to this
+	 * autogroup now. It just stands for the number of task
+	 * could use this autogroup.
+	 */
 	struct kref		kref;
 	struct task_group	*tg;
 	struct rw_semaphore	lock;
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index eb6cb8e..7bacd83 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -179,7 +179,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
 	if (cfs_rq->rb_leftmost)
-		MIN_vruntime = (__pick_next_entity(cfs_rq))->vruntime;
+		MIN_vruntime = (__pick_first_entity(cfs_rq))->vruntime;
 	last = __pick_last_entity(cfs_rq);
 	if (last)
 		max_vruntime = last->vruntime;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0c26e2d..3f7ec9e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -69,14 +69,6 @@ static unsigned int sched_nr_latency = 8;
 unsigned int sysctl_sched_child_runs_first __read_mostly;
 
 /*
- * sys_sched_yield() compat mode
- *
- * This option switches the agressive yield implementation of the
- * old scheduler back on.
- */
-unsigned int __read_mostly sysctl_sched_compat_yield;
-
-/*
  * SCHED_OTHER wake-up granularity.
  * (default: 1 msec * (1 + ilog(ncpus)), units: nanoseconds)
  *
@@ -419,7 +411,7 @@ static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
 }
 
-static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
+static struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *left = cfs_rq->rb_leftmost;
 
@@ -429,6 +421,17 @@ static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
 	return rb_entry(left, struct sched_entity, run_node);
 }
 
+static struct sched_entity *__pick_next_entity(struct sched_entity *se)
+{
+	struct rb_node *next = rb_next(&se->run_node);
+
+	if (!next)
+		return NULL;
+
+	return rb_entry(next, struct sched_entity, run_node);
+}
+
+#ifdef CONFIG_SCHED_DEBUG
 static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *last = rb_last(&cfs_rq->tasks_timeline);
@@ -443,7 +446,6 @@ static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
  * Scheduling class statistics methods:
  */
 
-#ifdef CONFIG_SCHED_DEBUG
 int sched_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
@@ -540,7 +542,7 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update);
-static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta);
+static void update_cfs_shares(struct cfs_rq *cfs_rq);
 
 /*
  * Update the current task's runtime statistics. Skip current tasks that
@@ -733,6 +735,7 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 	    now - cfs_rq->load_last > 4 * period) {
 		cfs_rq->load_period = 0;
 		cfs_rq->load_avg = 0;
+		delta = period - 1;
 	}
 
 	cfs_rq->load_stamp = now;
@@ -763,16 +766,15 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 		list_del_leaf_cfs_rq(cfs_rq);
 }
 
-static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg,
-				long weight_delta)
+static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
 {
 	long load_weight, load, shares;
 
-	load = cfs_rq->load.weight + weight_delta;
+	load = cfs_rq->load.weight;
 
 	load_weight = atomic_read(&tg->load_weight);
-	load_weight -= cfs_rq->load_contribution;
 	load_weight += load;
+	load_weight -= cfs_rq->load_contribution;
 
 	shares = (tg->shares * load);
 	if (load_weight)
@@ -790,7 +792,7 @@ static void update_entity_shares_tick(struct cfs_rq *cfs_rq)
 {
 	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
 		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq, 0);
+		update_cfs_shares(cfs_rq);
 	}
 }
 # else /* CONFIG_SMP */
@@ -798,8 +800,7 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 {
 }
 
-static inline long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg,
-				long weight_delta)
+static inline long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
 {
 	return tg->shares;
 }
@@ -824,7 +825,7 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 		account_entity_enqueue(cfs_rq, se);
 }
 
-static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
+static void update_cfs_shares(struct cfs_rq *cfs_rq)
 {
 	struct task_group *tg;
 	struct sched_entity *se;
@@ -838,7 +839,7 @@ static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
 	if (likely(se->load.weight == tg->shares))
 		return;
 #endif
-	shares = calc_cfs_shares(cfs_rq, tg, weight_delta);
+	shares = calc_cfs_shares(cfs_rq, tg);
 
 	reweight_entity(cfs_rq_of(se), se, shares);
 }
@@ -847,7 +848,7 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 {
 }
 
-static inline void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
+static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
 {
 }
 
@@ -978,8 +979,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 */
 	update_curr(cfs_rq);
 	update_cfs_load(cfs_rq, 0);
-	update_cfs_shares(cfs_rq, se->load.weight);
 	account_entity_enqueue(cfs_rq, se);
+	update_cfs_shares(cfs_rq);
 
 	if (flags & ENQUEUE_WAKEUP) {
 		place_entity(cfs_rq, se, 0);
@@ -996,19 +997,49 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 		list_add_leaf_cfs_rq(cfs_rq);
 }
 
-static void __clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static void __clear_buddies_last(struct sched_entity *se)
+{
+	for_each_sched_entity(se) {
+		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+		if (cfs_rq->last == se)
+			cfs_rq->last = NULL;
+		else
+			break;
+	}
+}
+
+static void __clear_buddies_next(struct sched_entity *se)
 {
-	if (!se || cfs_rq->last == se)
-		cfs_rq->last = NULL;
+	for_each_sched_entity(se) {
+		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+		if (cfs_rq->next == se)
+			cfs_rq->next = NULL;
+		else
+			break;
+	}
+}
 
-	if (!se || cfs_rq->next == se)
-		cfs_rq->next = NULL;
+static void __clear_buddies_skip(struct sched_entity *se)
+{
+	for_each_sched_entity(se) {
+		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+		if (cfs_rq->skip == se)
+			cfs_rq->skip = NULL;
+		else
+			break;
+	}
 }
 
 static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	for_each_sched_entity(se)
-		__clear_buddies(cfs_rq_of(se), se);
+	if (cfs_rq->last == se)
+		__clear_buddies_last(se);
+
+	if (cfs_rq->next == se)
+		__clear_buddies_next(se);
+
+	if (cfs_rq->skip == se)
+		__clear_buddies_skip(se);
 }
 
 static void
@@ -1041,7 +1072,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
 	update_min_vruntime(cfs_rq);
-	update_cfs_shares(cfs_rq, 0);
+	update_cfs_shares(cfs_rq);
 
 	/*
 	 * Normalize the entity after updating the min_vruntime because the
@@ -1084,7 +1115,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 		return;
 
 	if (cfs_rq->nr_running > 1) {
-		struct sched_entity *se = __pick_next_entity(cfs_rq);
+		struct sched_entity *se = __pick_first_entity(cfs_rq);
 		s64 delta = curr->vruntime - se->vruntime;
 
 		if (delta < 0)
@@ -1128,13 +1159,27 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static int
 wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
 
+/*
+ * Pick the next process, keeping these things in mind, in this order:
+ * 1) keep things fair between processes/task groups
+ * 2) pick the "next" process, since someone really wants that to run
+ * 3) pick the "last" process, for cache locality
+ * 4) do not run the "skip" process, if something else is available
+ */
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
-	struct sched_entity *se = __pick_next_entity(cfs_rq);
+	struct sched_entity *se = __pick_first_entity(cfs_rq);
 	struct sched_entity *left = se;
 
-	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
-		se = cfs_rq->next;
+	/*
+	 * Avoid running the skip buddy, if running something else can
+	 * be done without getting too unfair.
+	 */
+	if (cfs_rq->skip == se) {
+		struct sched_entity *second = __pick_next_entity(se);
+		if (second && wakeup_preempt_entity(second, left) < 1)
+			se = second;
+	}
 
 	/*
 	 * Prefer last buddy, try to return the CPU to a preempted task.
@@ -1142,6 +1187,12 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1)
 		se = cfs_rq->last;
 
+	/*
+	 * Someone really wants this to run. If it's not unfair, run it.
+	 */
+	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
+		se = cfs_rq->next;
+
 	clear_buddies(cfs_rq, se);
 
 	return se;
@@ -1282,7 +1333,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
 		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq, 0);
+		update_cfs_shares(cfs_rq);
 	}
 
 	hrtick_update(rq);
@@ -1312,58 +1363,12 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
 		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq, 0);
+		update_cfs_shares(cfs_rq);
 	}
 
 	hrtick_update(rq);
 }
 
-/*
- * sched_yield() support is very simple - we dequeue and enqueue.
- *
- * If compat_yield is turned on then we requeue to the end of the tree.
- */
-static void yield_task_fair(struct rq *rq)
-{
-	struct task_struct *curr = rq->curr;
-	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
-	struct sched_entity *rightmost, *se = &curr->se;
-
-	/*
-	 * Are we the only task in the tree?
-	 */
-	if (unlikely(cfs_rq->nr_running == 1))
-		return;
-
-	clear_buddies(cfs_rq, se);
-
-	if (likely(!sysctl_sched_compat_yield) && curr->policy != SCHED_BATCH) {
-		update_rq_clock(rq);
-		/*
-		 * Update run-time statistics of the 'current'.
-		 */
-		update_curr(cfs_rq);
-
-		return;
-	}
-	/*
-	 * Find the rightmost entry in the rbtree:
-	 */
-	rightmost = __pick_last_entity(cfs_rq);
-	/*
-	 * Already in the rightmost position?
-	 */
-	if (unlikely(!rightmost || entity_before(rightmost, se)))
-		return;
-
-	/*
-	 * Minimally necessary key value to be last in the tree:
-	 * Upon rescheduling, sched_class::put_prev_task() will place
-	 * 'current' within the tree based on its new key value.
-	 */
-	se->vruntime = rightmost->vruntime + 1;
-}
-
 #ifdef CONFIG_SMP
 
 static void task_waking_fair(struct rq *rq, struct task_struct *p)
@@ -1834,6 +1839,14 @@ static void set_next_buddy(struct sched_entity *se)
 	}
 }
 
+static void set_skip_buddy(struct sched_entity *se)
+{
+	if (likely(task_of(se)->policy != SCHED_IDLE)) {
+		for_each_sched_entity(se)
+			cfs_rq_of(se)->skip = se;
+	}
+}
+
 /*
  * Preempt the current task with a newly woken task if needed:
  */
@@ -1857,16 +1870,18 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	if (test_tsk_need_resched(curr))
 		return;
 
+	/* Idle tasks are by definition preempted by non-idle tasks. */
+	if (unlikely(curr->policy == SCHED_IDLE) &&
+	    likely(p->policy != SCHED_IDLE))
+		goto preempt;
+
 	/*
-	 * Batch and idle tasks do not preempt (their preemption is driven by
-	 * the tick):
+	 * Batch and idle tasks do not preempt non-idle tasks (their preemption
+	 * is driven by the tick):
 	 */
 	if (unlikely(p->policy != SCHED_NORMAL))
 		return;
 
-	/* Idle tasks are by definition preempted by everybody. */
-	if (unlikely(curr->policy == SCHED_IDLE))
-		goto preempt;
 
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
@@ -1932,6 +1947,51 @@ static void put_prev_task_fair(struct rq *rq, struct task_struct *prev)
 	}
 }
 
+/*
+ * sched_yield() is very simple
+ *
+ * The magic of dealing with the ->skip buddy is in pick_next_entity.
+ */
+static void yield_task_fair(struct rq *rq)
+{
+	struct task_struct *curr = rq->curr;
+	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
+	struct sched_entity *se = &curr->se;
+
+	/*
+	 * Are we the only task in the tree?
+	 */
+	if (unlikely(rq->nr_running == 1))
+		return;
+
+	clear_buddies(cfs_rq, se);
+
+	if (curr->policy != SCHED_BATCH) {
+		update_rq_clock(rq);
+		/*
+		 * Update run-time statistics of the 'current'.
+		 */
+		update_curr(cfs_rq);
+	}
+
+	set_skip_buddy(se);
+}
+
+static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preempt)
+{
+	struct sched_entity *se = &p->se;
+
+	if (!se->on_rq)
+		return false;
+
+	/* Tell the scheduler that we'd really like pse to run next. */
+	set_next_buddy(se);
+
+	yield_task_fair(rq);
+
+	return true;
+}
+
 #ifdef CONFIG_SMP
 /**************************************************
  * Fair scheduling class load-balancing methods:
@@ -2123,7 +2183,7 @@ static int update_shares_cpu(struct task_group *tg, int cpu)
 	 * We need to update shares after updating tg->load_weight in
 	 * order to adjust the weight of groups with long running tasks.
 	 */
-	update_cfs_shares(cfs_rq, 0);
+	update_cfs_shares(cfs_rq);
 
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
@@ -2610,7 +2670,6 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
  * @this_cpu: Cpu for which load balance is currently performed.
  * @idle: Idle status of this_cpu
  * @load_idx: Load index of sched_domain of this_cpu for load calc.
- * @sd_idle: Idle status of the sched_domain containing group.
  * @local_group: Does group contain this_cpu.
  * @cpus: Set of cpus considered for load balancing.
  * @balance: Should we balance.
@@ -2618,7 +2677,7 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
  */
 static inline void update_sg_lb_stats(struct sched_domain *sd,
 			struct sched_group *group, int this_cpu,
-			enum cpu_idle_type idle, int load_idx, int *sd_idle,
+			enum cpu_idle_type idle, int load_idx,
 			int local_group, const struct cpumask *cpus,
 			int *balance, struct sg_lb_stats *sgs)
 {
@@ -2638,9 +2697,6 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	for_each_cpu_and(i, sched_group_cpus(group), cpus) {
 		struct rq *rq = cpu_rq(i);
 
-		if (*sd_idle && rq->nr_running)
-			*sd_idle = 0;
-
 		/* Bias balancing toward cpus of our domain */
 		if (local_group) {
 			if (idle_cpu(i) && !first_idle_cpu) {
@@ -2685,7 +2741,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 
 	/*
 	 * Consider the group unbalanced when the imbalance is larger
-	 * than the average weight of two tasks.
+	 * than the average weight of a task.
 	 *
 	 * APZ: with cgroup the avg task weight can vary wildly and
 	 *      might not be a suitable number - should we keep a
@@ -2695,7 +2751,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	if (sgs->sum_nr_running)
 		avg_load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
 
-	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task && max_nr_running > 1)
+	if ((max_cpu_load - min_cpu_load) >= avg_load_per_task && max_nr_running > 1)
 		sgs->group_imb = 1;
 
 	sgs->group_capacity = DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
@@ -2755,15 +2811,13 @@ static bool update_sd_pick_busiest(struct sched_domain *sd,
  * @sd: sched_domain whose statistics are to be updated.
  * @this_cpu: Cpu for which load balance is currently performed.
  * @idle: Idle status of this_cpu
- * @sd_idle: Idle status of the sched_domain containing sg.
  * @cpus: Set of cpus considered for load balancing.
  * @balance: Should we balance.
  * @sds: variable to hold the statistics for this sched_domain.
  */
 static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
-			enum cpu_idle_type idle, int *sd_idle,
-			const struct cpumask *cpus, int *balance,
-			struct sd_lb_stats *sds)
+			enum cpu_idle_type idle, const struct cpumask *cpus,
+			int *balance, struct sd_lb_stats *sds)
 {
 	struct sched_domain *child = sd->child;
 	struct sched_group *sg = sd->groups;
@@ -2781,7 +2835,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 
 		local_group = cpumask_test_cpu(this_cpu, sched_group_cpus(sg));
 		memset(&sgs, 0, sizeof(sgs));
-		update_sg_lb_stats(sd, sg, this_cpu, idle, load_idx, sd_idle,
+		update_sg_lb_stats(sd, sg, this_cpu, idle, load_idx,
 				local_group, cpus, balance, &sgs);
 
 		if (local_group && !(*balance))
@@ -3033,7 +3087,6 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
  * @imbalance: Variable which stores amount of weighted load which should
  *		be moved to restore balance/put a group to idle.
  * @idle: The idle status of this_cpu.
- * @sd_idle: The idleness of sd
  * @cpus: The set of CPUs under consideration for load-balancing.
  * @balance: Pointer to a variable indicating if this_cpu
  *	is the appropriate cpu to perform load balancing at this_level.
@@ -3046,7 +3099,7 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 static struct sched_group *
 find_busiest_group(struct sched_domain *sd, int this_cpu,
 		   unsigned long *imbalance, enum cpu_idle_type idle,
-		   int *sd_idle, const struct cpumask *cpus, int *balance)
+		   const struct cpumask *cpus, int *balance)
 {
 	struct sd_lb_stats sds;
 
@@ -3056,22 +3109,11 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	 * Compute the various statistics relavent for load balancing at
 	 * this level.
 	 */
-	update_sd_lb_stats(sd, this_cpu, idle, sd_idle, cpus,
-					balance, &sds);
-
-	/* Cases where imbalance does not exist from POV of this_cpu */
-	/* 1) this_cpu is not the appropriate cpu to perform load balancing
-	 *    at this level.
-	 * 2) There is no busy sibling group to pull from.
-	 * 3) This group is the busiest group.
-	 * 4) This group is more busy than the avg busieness at this
-	 *    sched_domain.
-	 * 5) The imbalance is within the specified limit.
-	 *
-	 * Note: when doing newidle balance, if the local group has excess
-	 * capacity (i.e. nr_running < group_capacity) and the busiest group
-	 * does not have any capacity, we force a load balance to pull tasks
-	 * to the local group. In this case, we skip past checks 3, 4 and 5.
+	update_sd_lb_stats(sd, this_cpu, idle, cpus, balance, &sds);
+
+	/*
+	 * this_cpu is not the appropriate cpu to perform load balancing at
+	 * this level.
 	 */
 	if (!(*balance))
 		goto ret;
@@ -3080,41 +3122,55 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	    check_asym_packing(sd, &sds, this_cpu, imbalance))
 		return sds.busiest;
 
+	/* There is no busy sibling group to pull tasks from */
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;
 
-	/*  SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
+	/*
+	 * If the busiest group is imbalanced the below checks don't
+	 * work because they assumes all things are equal, which typically
+	 * isn't true due to cpus_allowed constraints and the like.
+	 */
+	if (sds.group_imb)
+		goto force_balance;
+
+	/* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
 	if (idle == CPU_NEWLY_IDLE && sds.this_has_capacity &&
 			!sds.busiest_has_capacity)
 		goto force_balance;
 
+	/*
+	 * If the local group is more busy than the selected busiest group
+	 * don't try and pull any tasks.
+	 */
 	if (sds.this_load >= sds.max_load)
 		goto out_balanced;
 
+	/*
+	 * Don't pull any tasks if this group is already above the domain
+	 * average load.
+	 */
 	sds.avg_load = (SCHED_LOAD_SCALE * sds.total_load) / sds.total_pwr;
-
 	if (sds.this_load >= sds.avg_load)
 		goto out_balanced;
 
-	/*
-	 * In the CPU_NEWLY_IDLE, use imbalance_pct to be conservative.
-	 * And to check for busy balance use !idle_cpu instead of
-	 * CPU_NOT_IDLE. This is because HT siblings will use CPU_NOT_IDLE
-	 * even when they are idle.
-	 */
-	if (idle == CPU_NEWLY_IDLE || !idle_cpu(this_cpu)) {
-		if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
-			goto out_balanced;
-	} else {
+	if (idle == CPU_IDLE) {
 		/*
 		 * This cpu is idle. If the busiest group load doesn't
 		 * have more tasks than the number of available cpu's and
 		 * there is no imbalance between this and busiest group
 		 * wrt to idle cpu's, it is balanced.
 		 */
-		if ((sds.this_idle_cpus  <= sds.busiest_idle_cpus + 1) &&
+		if ((sds.this_idle_cpus <= sds.busiest_idle_cpus + 1) &&
 		    sds.busiest_nr_running <= sds.busiest_group_weight)
 			goto out_balanced;
+	} else {
+		/*
+		 * In the CPU_NEWLY_IDLE, CPU_NOT_IDLE cases, use
+		 * imbalance_pct to be conservative.
+		 */
+		if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
+			goto out_balanced;
 	}
 
 force_balance:
@@ -3193,7 +3249,7 @@ find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
 /* Working cpumask for load_balance and load_balance_newidle. */
 static DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
 
-static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle,
+static int need_active_balance(struct sched_domain *sd, int idle,
 			       int busiest_cpu, int this_cpu)
 {
 	if (idle == CPU_NEWLY_IDLE) {
@@ -3225,10 +3281,6 @@ static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle,
 		 * move_tasks() will succeed.  ld_moved will be true and this
 		 * active balance code will not be triggered.
 		 */
-		if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
-		    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-			return 0;
-
 		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
 			return 0;
 	}
@@ -3246,7 +3298,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum cpu_idle_type idle,
 			int *balance)
 {
-	int ld_moved, all_pinned = 0, active_balance = 0, sd_idle = 0;
+	int ld_moved, all_pinned = 0, active_balance = 0;
 	struct sched_group *group;
 	unsigned long imbalance;
 	struct rq *busiest;
@@ -3255,20 +3307,10 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 
 	cpumask_copy(cpus, cpu_active_mask);
 
-	/*
-	 * When power savings policy is enabled for the parent domain, idle
-	 * sibling can pick up load irrespective of busy siblings. In this case,
-	 * let the state of idle sibling percolate up as CPU_IDLE, instead of
-	 * portraying it as CPU_NOT_IDLE.
-	 */
-	if (idle != CPU_NOT_IDLE && sd->flags & SD_SHARE_CPUPOWER &&
-	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		sd_idle = 1;
-
 	schedstat_inc(sd, lb_count[idle]);
 
 redo:
-	group = find_busiest_group(sd, this_cpu, &imbalance, idle, &sd_idle,
+	group = find_busiest_group(sd, this_cpu, &imbalance, idle,
 				   cpus, balance);
 
 	if (*balance == 0)
@@ -3330,8 +3372,7 @@ redo:
 		if (idle != CPU_NEWLY_IDLE)
 			sd->nr_balance_failed++;
 
-		if (need_active_balance(sd, sd_idle, idle, cpu_of(busiest),
-					this_cpu)) {
+		if (need_active_balance(sd, idle, cpu_of(busiest), this_cpu)) {
 			raw_spin_lock_irqsave(&busiest->lock, flags);
 
 			/* don't kick the active_load_balance_cpu_stop,
@@ -3386,10 +3427,6 @@ redo:
 			sd->balance_interval *= 2;
 	}
 
-	if (!ld_moved && !sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
-	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		ld_moved = -1;
-
 	goto out;
 
 out_balanced:
@@ -3403,11 +3440,7 @@ out_one_pinned:
 			(sd->balance_interval < sd->max_interval))
 		sd->balance_interval *= 2;
 
-	if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
-	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		ld_moved = -1;
-	else
-		ld_moved = 0;
+	ld_moved = 0;
 out:
 	return ld_moved;
 }
@@ -3831,8 +3864,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 			if (load_balance(cpu, rq, sd, idle, &balance)) {
 				/*
 				 * We've pulled tasks over so either we're no
-				 * longer idle, or one of our SMT siblings is
-				 * not idle.
+				 * longer idle.
 				 */
 				idle = CPU_NOT_IDLE;
 			}
@@ -4079,33 +4111,62 @@ static void task_fork_fair(struct task_struct *p)
  * Priority of the task has changed. Check to see if we preempt
  * the current task.
  */
-static void prio_changed_fair(struct rq *rq, struct task_struct *p,
-			      int oldprio, int running)
+static void
+prio_changed_fair(struct rq *rq, struct task_struct *p, int oldprio)
 {
+	if (!p->se.on_rq)
+		return;
+
 	/*
 	 * Reschedule if we are currently running on this runqueue and
 	 * our priority decreased, or if we are not currently running on
 	 * this runqueue and our priority is higher than the current's
 	 */
-	if (running) {
+	if (rq->curr == p) {
 		if (p->prio > oldprio)
 			resched_task(rq->curr);
 	} else
 		check_preempt_curr(rq, p, 0);
 }
 
+static void switched_from_fair(struct rq *rq, struct task_struct *p)
+{
+	struct sched_entity *se = &p->se;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+	/*
+	 * Ensure the task's vruntime is normalized, so that when its
+	 * switched back to the fair class the enqueue_entity(.flags=0) will
+	 * do the right thing.
+	 *
+	 * If it was on_rq, then the dequeue_entity(.flags=0) will already
+	 * have normalized the vruntime, if it was !on_rq, then only when
+	 * the task is sleeping will it still have non-normalized vruntime.
+	 */
+	if (!se->on_rq && p->state != TASK_RUNNING) {
+		/*
+		 * Fix up our vruntime so that the current sleep doesn't
+		 * cause 'unlimited' sleep bonus.
+		 */
+		place_entity(cfs_rq, se, 0);
+		se->vruntime -= cfs_rq->min_vruntime;
+	}
+}
+
 /*
  * We switched to the sched_fair class.
  */
-static void switched_to_fair(struct rq *rq, struct task_struct *p,
-			     int running)
+static void switched_to_fair(struct rq *rq, struct task_struct *p)
 {
+	if (!p->se.on_rq)
+		return;
+
 	/*
 	 * We were most likely switched from sched_rt, so
 	 * kick off the schedule if running, otherwise just see
 	 * if we can still preempt the current task.
 	 */
-	if (running)
+	if (rq->curr == p)
 		resched_task(rq->curr);
 	else
 		check_preempt_curr(rq, p, 0);
@@ -4171,6 +4232,7 @@ static const struct sched_class fair_sched_class = {
 	.enqueue_task		= enqueue_task_fair,
 	.dequeue_task		= dequeue_task_fair,
 	.yield_task		= yield_task_fair,
+	.yield_to_task		= yield_to_task_fair,
 
 	.check_preempt_curr	= check_preempt_wakeup,
 
@@ -4191,6 +4253,7 @@ static const struct sched_class fair_sched_class = {
 	.task_fork		= task_fork_fair,
 
 	.prio_changed		= prio_changed_fair,
+	.switched_from		= switched_from_fair,
 	.switched_to		= switched_to_fair,
 
 	.get_rr_interval	= get_rr_interval_fair,
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 9fa0f40..c82f26c 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -52,31 +52,15 @@ static void set_curr_task_idle(struct rq *rq)
 {
 }
 
-static void switched_to_idle(struct rq *rq, struct task_struct *p,
-			     int running)
+static void switched_to_idle(struct rq *rq, struct task_struct *p)
 {
-	/* Can this actually happen?? */
-	if (running)
-		resched_task(rq->curr);
-	else
-		check_preempt_curr(rq, p, 0);
+	BUG();
 }
 
-static void prio_changed_idle(struct rq *rq, struct task_struct *p,
-			      int oldprio, int running)
+static void
+prio_changed_idle(struct rq *rq, struct task_struct *p, int oldprio)
 {
-	/* This can happen for hot plug CPUS */
-
-	/*
-	 * Reschedule if we are currently running on this runqueue and
-	 * our priority decreased, or if we are not currently running on
-	 * this runqueue and our priority is higher than the current's
-	 */
-	if (running) {
-		if (p->prio > oldprio)
-			resched_task(rq->curr);
-	} else
-		check_preempt_curr(rq, p, 0);
+	BUG();
 }
 
 static unsigned int get_rr_interval_idle(struct rq *rq, struct task_struct *task)
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 01f75a5..db308cb 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1599,8 +1599,7 @@ static void rq_offline_rt(struct rq *rq)
  * When switch from the rt queue, we bring ourselves to a position
  * that we might want to pull RT tasks from other runqueues.
  */
-static void switched_from_rt(struct rq *rq, struct task_struct *p,
-			   int running)
+static void switched_from_rt(struct rq *rq, struct task_struct *p)
 {
 	/*
 	 * If there are other RT tasks then we will reschedule
@@ -1609,7 +1608,7 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p,
 	 * we may need to handle the pulling of RT tasks
 	 * now.
 	 */
-	if (!rq->rt.rt_nr_running)
+	if (p->se.on_rq && !rq->rt.rt_nr_running)
 		pull_rt_task(rq);
 }
 
@@ -1628,8 +1627,7 @@ static inline void init_sched_rt_class(void)
  * with RT tasks. In this case we try to push them off to
  * other runqueues.
  */
-static void switched_to_rt(struct rq *rq, struct task_struct *p,
-			   int running)
+static void switched_to_rt(struct rq *rq, struct task_struct *p)
 {
 	int check_resched = 1;
 
@@ -1640,7 +1638,7 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p,
 	 * If that current running task is also an RT task
 	 * then see if we can move to another run queue.
 	 */
-	if (!running) {
+	if (p->se.on_rq && rq->curr != p) {
 #ifdef CONFIG_SMP
 		if (rq->rt.overloaded && push_rt_task(rq) &&
 		    /* Don't resched if we changed runqueues */
@@ -1656,10 +1654,13 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p,
  * Priority of the task has changed. This may cause
  * us to initiate a push or pull.
  */
-static void prio_changed_rt(struct rq *rq, struct task_struct *p,
-			    int oldprio, int running)
+static void
+prio_changed_rt(struct rq *rq, struct task_struct *p, int oldprio)
 {
-	if (running) {
+	if (!p->se.on_rq)
+		return;
+
+	if (rq->curr == p) {
 #ifdef CONFIG_SMP
 		/*
 		 * If our priority decreases while running, we
diff --git a/kernel/sched_stoptask.c b/kernel/sched_stoptask.c
index 2bf6b47..84ec9bc 100644
--- a/kernel/sched_stoptask.c
+++ b/kernel/sched_stoptask.c
@@ -59,14 +59,13 @@ static void set_curr_task_stop(struct rq *rq)
 {
 }
 
-static void switched_to_stop(struct rq *rq, struct task_struct *p,
-			     int running)
+static void switched_to_stop(struct rq *rq, struct task_struct *p)
 {
 	BUG(); /* its impossible to change to this class */
 }
 
-static void prio_changed_stop(struct rq *rq, struct task_struct *p,
-			      int oldprio, int running)
+static void
+prio_changed_stop(struct rq *rq, struct task_struct *p, int oldprio)
 {
 	BUG(); /* how!?, what priority? */
 }
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 68eb5ef..0cee504 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -54,7 +54,7 @@ EXPORT_SYMBOL(irq_stat);
 
 static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp;
 
-static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
+DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
 char *softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
@@ -721,7 +721,6 @@ static int run_ksoftirqd(void * __bind_cpu)
 {
 	set_current_state(TASK_INTERRUPTIBLE);
 
-	current->flags |= PF_KSOFTIRQD;
 	while (!kthread_should_stop()) {
 		preempt_disable();
 		if (!local_softirq_pending()) {
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0f1bd83..7b5eead 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -361,20 +361,13 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= sched_rt_handler,
 	},
-	{
-		.procname	= "sched_compat_yield",
-		.data		= &sysctl_sched_compat_yield,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
 #ifdef CONFIG_SCHED_AUTOGROUP
 	{
 		.procname	= "sched_autogroup_enabled",
 		.data		= &sysctl_sched_autogroup_enabled,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
diff --git a/kernel/time.c b/kernel/time.c
index 3217435..55337a8 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -645,7 +645,7 @@ u64 nsec_to_clock_t(u64 x)
 }
 
 /**
- * nsecs_to_jiffies - Convert nsecs in u64 to jiffies
+ * nsecs_to_jiffies64 - Convert nsecs in u64 to jiffies64
  *
  * @n:	nsecs in u64
  *
@@ -657,7 +657,7 @@ u64 nsec_to_clock_t(u64 x)
  *   NSEC_PER_SEC = 10^9 = (5^9 * 2^9) = (1953125 * 512)
  *   ULLONG_MAX ns = 18446744073.709551615 secs = about 584 years
  */
-unsigned long nsecs_to_jiffies(u64 n)
+u64 nsecs_to_jiffies64(u64 n)
 {
 #if (NSEC_PER_SEC % HZ) == 0
 	/* Common case, HZ = 100, 128, 200, 250, 256, 500, 512, 1000 etc. */
@@ -674,6 +674,25 @@ unsigned long nsecs_to_jiffies(u64 n)
 #endif
 }
 
+
+/**
+ * nsecs_to_jiffies - Convert nsecs in u64 to jiffies
+ *
+ * @n:	nsecs in u64
+ *
+ * Unlike {m,u}secs_to_jiffies, type of input is not unsigned int but u64.
+ * And this doesn't return MAX_JIFFY_OFFSET since this function is designed
+ * for scheduler, not for use in device drivers to calculate timeout value.
+ *
+ * note:
+ *   NSEC_PER_SEC = 10^9 = (5^9 * 2^9) = (1953125 * 512)
+ *   ULLONG_MAX ns = 18446744073.709551615 secs = about 584 years
+ */
+unsigned long nsecs_to_jiffies(u64 n)
+{
+	return (unsigned long)nsecs_to_jiffies64(n);
+}
+
 #if (BITS_PER_LONG < 64)
 u64 get_jiffies_64(void)
 {
