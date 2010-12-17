Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab0LQNCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 08:02:37 -0500
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:50296 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab0LQNCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 08:02:35 -0500
X-AuditID: c1b4fb3d-b7b89ae0000036a3-54-4d0b5f698a72
From: Harald Gustafsson <harald.gustafsson@ericsson.com>
To: Dario Faggioli <faggioli@gandalf.sssup.it>,
        Peter Zijlstra <peterz@infradead.org>,
        Harald Gustafsson <hgu1972@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>
Subject: [PATCH 2/3] cpufreq normalized runtime to enforce runtime cycles also at lower frequencies.
Date: Fri, 17 Dec 2010 14:02:03 +0100
Message-ID: <a20c9f9531de85fc32008275d3fb89dac34ceb66.1292578808.git.harald.gustafsson@ericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch do the actual changes to sched deadline v3 to
utilize the normalized runtime clock. Note that the 
deadline/periods still use the regular runtime clock. 

Change-Id: I75c88676e9e18a71d94d6c4e779b376a7ac0615f

Signed-off-by: Harald Gustafsson <harald.gustafsson@ericsson.com>
---
 include/linux/sched.h |    6 +++
 kernel/sched.c        |    2 +
 kernel/sched_dl.c     |   82 +++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 84 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 89a158e..167771c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1301,6 +1301,12 @@ struct sched_dl_entity {
 	u64 deadline;		/* absolute deadline for this instance	*/
 	unsigned int flags;	/* specifying the scheduler behaviour   */
 
+        /*
+	 * CPU frequency normalized start time.
+	 * Put it inside DL since only one using it.
+	 */
+        u64 exec_start_norm;
+
 	/*
 	 * Some bool flags:
 	 *
diff --git a/kernel/sched.c b/kernel/sched.c
index 2816371..ddb18d2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2671,6 +2671,7 @@ static void __sched_fork(struct task_struct *p)
 	p->dl.dl_deadline = p->dl.deadline = 0;
 	p->dl.dl_period = 0;
 	p->dl.flags = 0;
+	p->dl.exec_start_norm = 0;
 
 	INIT_LIST_HEAD(&p->rt.run_list);
 	p->se.on_rq = 0;
@@ -8475,6 +8476,7 @@ void normalize_rt_tasks(void)
 			continue;
 
 		p->se.exec_start		= 0;
+		p->dl.exec_start_norm		= 0;
 #ifdef CONFIG_SCHEDSTATS
 		p->se.wait_start		= 0;
 		p->se.sleep_start		= 0;
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
index 5aa5a52..049c001 100644
--- a/kernel/sched_dl.c
+++ b/kernel/sched_dl.c
@@ -333,6 +333,40 @@ static bool dl_entity_overflow(struct sched_dl_entity *dl_se,
 }
 
 /*
+ * A cpu freq normalized overflow check, see dl_entity_overflow
+ * function for details. Check against current cpu frequency.
+ * For this to hold, we must check if:
+ *   runtime / (norm_factor * (deadline - t)) < dl_runtime / dl_deadline .
+ */
+static bool dl_entity_overflow_norm(struct sched_dl_entity *dl_se,
+				    struct sched_dl_entity *pi_se, u64 t,
+				    struct rq *rq)
+{
+	u64 left, right;
+
+	/*
+	 * left and right are the two sides of the equation above,
+	 * after a bit of shuffling to use multiplications instead
+	 * of divisions.
+	 *
+	 * Note that none of the time values involved in the two
+	 * multiplications are absolute: dl_deadline and dl_runtime
+	 * are the relative deadline and the maximum runtime of each
+	 * instance, runtime is the runtime left for the last instance
+	 * and (deadline - t), since t is rq->clock, is the time left
+	 * to the (absolute) deadline. Therefore, overflowing the u64
+	 * type is very unlikely to occur in both cases.
+	 * Likewise the runtime multiplied with the norm factor is
+	 * for the same reasons unlikely to overflow u64 and since
+	 * norm factor is max 1<<32.
+	 */
+	left = pi_se->dl_deadline * dl_se->runtime;
+	right = (dl_se->deadline - t) * ((pi_se->dl_runtime * rq->norm_factor) >> 32);
+
+	return dl_time_before(right, left);
+}
+
+/*
  * When a -deadline entity is queued back on the runqueue, its runtime and
  * deadline might need updating.
  *
@@ -358,12 +392,16 @@ static void update_dl_entity(struct sched_dl_entity *dl_se,
 	}
 
 	if (dl_time_before(dl_se->deadline, rq->clock) ||
-	    dl_entity_overflow(dl_se, pi_se, rq->clock)) {
+	    dl_entity_overflow_norm(dl_se, pi_se, rq->clock, rq)) {
 		dl_se->deadline = rq->clock + pi_se->dl_deadline;
 		dl_se->runtime = pi_se->dl_runtime;
 		overflow = 1;
 	}
 #ifdef CONFIG_SCHEDSTATS
+	if(dl_entity_overflow(dl_se, pi_se, rq->clock))
+	    overflow |= 2;
+	if(dl_entity_overflow_norm(dl_se, pi_se, rq->clock, rq))
+	    overflow |= 4;
 	trace_sched_stat_updt_dl(dl_task_of(dl_se), rq->clock, overflow);
 #endif
 }
@@ -549,10 +587,15 @@ int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
 	 * executing, then we have already used some of the runtime of
 	 * the next instance. Thus, if we do not account that, we are
 	 * stealing bandwidth from the system at each deadline miss!
+	 *
+	 * Use normalization of deadline and clock to compensate the
+	 * runtime. Here assuming that the whole exceeded runtime is
+	 * done with current cpu frequency.
 	 */
 	if (dmiss) {
 		dl_se->runtime = rorun ? dl_se->runtime : 0;
-		dl_se->runtime -= rq->clock - dl_se->deadline;
+		dl_se->runtime -= ((rq->clock - dl_se->deadline)
+				   * rq->norm_factor) >> 32;
 	}
 
 	return 1;
@@ -576,31 +619,46 @@ static void update_curr_dl(struct rq *rq)
 {
 	struct task_struct *curr = rq->curr;
 	struct sched_dl_entity *dl_se = &curr->dl;
-	u64 delta_exec;
+	u64 delta_exec, delta_exec_norm;
 
 	if (!dl_task(curr) || !on_dl_rq(dl_se))
 		return;
 
+	/*
+	 * Maintaine the unnormalized execution statistics
+	 * to keep user space happy.
+	 *
+	 * Do cpu frequency normalized runtime handling for
+	 * the actual DL scheduling to enforce the CPU
+	 * max frequency runtime cycles even at lower freq.
+	 */
+
 	delta_exec = rq->clock - curr->se.exec_start;
 	if (unlikely((s64)delta_exec < 0))
 		delta_exec = 0;
 
+	delta_exec_norm = rq->clock_norm - curr->dl.exec_start_norm;
+	if (unlikely((s64)delta_exec_norm < 0))
+		delta_exec_norm = 0;
+
 	schedstat_set(curr->se.exec_max,
 		      max(curr->se.exec_max, delta_exec));
 
 	curr->se.sum_exec_runtime += delta_exec;
 	schedstat_add(&rq->dl, exec_clock, delta_exec);
 	account_group_exec_runtime(curr, delta_exec);
-	trace_sched_stat_runtime_dl(curr, rq->clock, delta_exec);
+	trace_sched_stat_runtime_dl(curr, rq->clock, delta_exec_norm);
 
 	curr->se.exec_start = rq->clock;
+	curr->dl.exec_start_norm = rq->clock_norm;
 	cpuacct_charge(curr, delta_exec);
 	cg_cpufreq_charge(curr, delta_exec, curr->se.exec_start);
 
 	sched_dl_avg_update(rq, delta_exec);
 
 	dl_se->stats.tot_rtime += delta_exec;
-	dl_se->runtime -= delta_exec;
+
+	dl_se->runtime -= delta_exec_norm;
 	if (dl_runtime_exceeded(rq, dl_se)) {
 		__dequeue_task_dl(rq, curr, 0);
 		if (likely(start_dl_timer(dl_se, !!curr->pi_top_task)))
@@ -865,10 +923,12 @@ static long wait_interval_dl(struct task_struct *p, struct timespec *rqtp,
 	 * instant. This involves a division (to calculate the reverse of the
 	 * task's bandwidth), but it is worth to notice that it is quite
 	 * unlikely that we get into here very often.
+	 * Use normalized overflow check since used for setting the timer.
 	 */
+
 	wakeup = timespec_to_ns(rqtp);
 	if (dl_time_before(wakeup, dl_se->deadline) &&
-	    !dl_entity_overflow(dl_se, dl_se, wakeup)) {
+	    !dl_entity_overflow_norm(dl_se, dl_se, wakeup, rq)) {
 		u64 ibw = (u64)dl_se->runtime * dl_se->dl_period;
 
 		ibw = div_u64(ibw, dl_se->dl_runtime);
@@ -989,6 +1049,13 @@ static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
 #ifdef CONFIG_SCHED_HRTICK
 static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
 {
+        /*
+	 * Don't use normalized runtime to calculate the
+	 * delta, since the clock frequency might increase
+	 * and we then misses our needed tick time.
+	 * Worst case we will be ticked an extra time.
+	 * We also don't need to do a u64 division.
+	 */
 	s64 delta = p->dl.dl_runtime - p->dl.runtime;
 
 	if (delta > 10000)
@@ -1037,6 +1104,7 @@ struct task_struct *pick_next_task_dl(struct rq *rq)
 
 	p = dl_task_of(dl_se);
 	p->se.exec_start = rq->clock;
+	p->dl.exec_start_norm = rq->clock_norm;
 
 	/* Running task will never be pushed. */
 	if (p)
@@ -1061,6 +1129,7 @@ static void put_prev_task_dl(struct rq *rq, struct task_struct *p)
 
 	update_curr_dl(rq);
 	p->se.exec_start = 0;
+	p->dl.exec_start_norm = 0;
 
 	if (on_dl_rq(&p->dl) && p->dl.nr_cpus_allowed > 1)
 		enqueue_pushable_dl_task(rq, p);
@@ -1102,6 +1171,7 @@ static void set_curr_task_dl(struct rq *rq)
 	struct task_struct *p = rq->curr;
 
 	p->se.exec_start = rq->clock;
+	p->dl.exec_start_norm = rq->clock_norm;
 
 	/* You can't push away the running task */
 	dequeue_pushable_dl_task(rq, p);
-- 
1.7.0.4

