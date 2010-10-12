Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab0JLHzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 03:55:23 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48382 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756643Ab0JLHzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 03:55:22 -0400
Date: Tue, 12 Oct 2010 13:25:16 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Paul Turner <pjt@google.com>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v3 7/7] sched: Return/expire slack quota using generation
	counters
Message-ID: <20101012075516.GH9893@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20101012074910.GA9893@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101012074910.GA9893@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From Paul Turner <pjt@google.com>

sched: Return/expire slack quota using generation counters

This patch adds generation counters to track and expire quotas.

This allows for two useful semantics:

1) On voluntary dequeue quota can be returned to the global pool provided it
   is still "current".  In this patch we return all but one tick's worth of
   quota so that workloads with high rates of turn-over do not incur
   significant contention.

   When returning quota to the global pool, if there are throttled runqueues
   and we have more than a slice of quota available, attempt to unthrottle
   them (again this is to prevent contention in the high turn over case).

2) On period expiration the generation counter is incremented, naturally
   expiring outstanding slack quota in the system.


A separate hrtimer is used to drive the slack quota redistribution and
subsequent unthrottling of throttled entities.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c      |   54 +++++++++++++++++++++++--
 kernel/sched_fair.c |  111 ++++++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 146 insertions(+), 19 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -250,8 +250,10 @@ static LIST_HEAD(task_groups);
 struct cfs_bandwidth {
 	raw_spinlock_t		lock;
 	ktime_t			period;
-	u64			runtime, quota;
+	u64			runtime, quota, generation;
+	int 			throttled_rqs;
 	struct hrtimer		period_timer;
+	struct hrtimer		slack_timer;
 
 	/* throttle statistics */
 	u64			nr_periods;
@@ -391,7 +393,7 @@ struct cfs_rq {
 	unsigned long rq_weight;
 #endif
 #ifdef CONFIG_CFS_BANDWIDTH
-	u64 quota_assigned, quota_used;
+	u64 quota_assigned, quota_used, quota_generation;
 	int throttled;
 	u64 throttled_timestamp;
 #endif
@@ -399,6 +401,17 @@ struct cfs_rq {
 };
 
 #ifdef CONFIG_CFS_BANDWIDTH
+
+static int do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b);
+
+static enum hrtimer_restart sched_cfs_slack_timer(struct hrtimer *timer)
+{
+	struct cfs_bandwidth *cfs_b =
+		container_of(timer, struct cfs_bandwidth, slack_timer);
+	do_sched_cfs_slack_timer(cfs_b);
+	return HRTIMER_NORESTART;
+}
+
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun);
 
 static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
@@ -428,9 +441,11 @@ void init_cfs_bandwidth(struct cfs_bandw
 	raw_spin_lock_init(&cfs_b->lock);
 	cfs_b->quota = cfs_b->runtime = quota;
 	cfs_b->period = ns_to_ktime(period);
-
+	cfs_b->generation = 0;
 	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	cfs_b->period_timer.function = sched_cfs_period_timer;
+	hrtimer_init(&cfs_b->slack_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	cfs_b->slack_timer.function = sched_cfs_slack_timer;
 
 	cfs_b->nr_periods = 0;
 	cfs_b->nr_throttled = 0;
@@ -464,6 +479,35 @@ static void destroy_cfs_bandwidth(struct
 {
 	hrtimer_cancel(&cfs_b->period_timer);
 }
+
+
+/* Should this be a tunable ? */
+#define CFS_SLACK_PERIOD	2000000	/* 2ms */
+
+static void destroy_cfs_slack_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	hrtimer_cancel(&cfs_b->slack_timer);
+}
+
+static void start_cfs_slack_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	if (cfs_b->quota == RUNTIME_INF)
+		return;
+
+	if (hrtimer_active(&cfs_b->slack_timer))
+		return;
+
+	raw_spin_lock(&cfs_b->lock);
+
+	/*
+	 * TODO: Don't start the slack timer if the
+	 * period timer is about to fire.
+	 */
+	start_bandwidth_timer(&cfs_b->slack_timer,
+		ns_to_ktime(CFS_SLACK_PERIOD));
+	raw_spin_unlock(&cfs_b->lock);
+}
+
 #endif
 
 /* Real-Time classes' related field in a runqueue: */
@@ -8182,6 +8226,7 @@ static void free_fair_sched_group(struct
 
 #ifdef CONFIG_CFS_BANDWIDTH
 	destroy_cfs_bandwidth(&tg->cfs_bandwidth);
+	destroy_cfs_slack_bandwidth(&tg->cfs_bandwidth);
 #endif
 
 	for_each_possible_cpu(i) {
@@ -8936,6 +8981,7 @@ static u64 cpu_shares_read_u64(struct cg
 static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 {
 	int i;
+	u64 next_generation;
 	static DEFINE_MUTEX(mutex);
 
 	if (tg == &init_task_group)
@@ -8956,6 +9002,7 @@ static int tg_set_cfs_bandwidth(struct t
 	raw_spin_lock_irq(&tg->cfs_bandwidth.lock);
 	tg->cfs_bandwidth.period = ns_to_ktime(period);
 	tg->cfs_bandwidth.runtime = tg->cfs_bandwidth.quota = quota;
+	next_generation = ++tg->cfs_bandwidth.generation;
 	raw_spin_unlock_irq(&tg->cfs_bandwidth.lock);
 
 	for_each_possible_cpu(i) {
@@ -8964,6 +9011,7 @@ static int tg_set_cfs_bandwidth(struct t
 
 		raw_spin_lock_irq(&rq->lock);
 		init_cfs_rq_quota(cfs_rq);
+		cfs_rq->quota_generation = next_generation;
 		if (cfs_rq_throttled(cfs_rq))
 			unthrottle_cfs_rq(cfs_rq);
 		raw_spin_unlock_irq(&rq->lock);
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -287,6 +287,8 @@ static inline int cfs_rq_throttled(struc
 	return cfs_rq->throttled;
 }
 
+static void cfs_rq_return_unused_quota(struct cfs_rq *cfs_rq);
+
 static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec);
 #else
@@ -912,6 +914,10 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 	 */
 	if (!(flags & DEQUEUE_SLEEP))
 		se->vruntime -= cfs_rq->min_vruntime;
+#ifdef CONFIG_CFS_BANDWIDTH
+	else if (cfs_rq->quota_assigned != RUNTIME_INF)
+		cfs_rq_return_unused_quota(cfs_rq);
+#endif
 }
 
 /*
@@ -1266,6 +1272,7 @@ static void throttle_cfs_rq(struct cfs_r
 out_throttled:
 	cfs_rq->throttled = 1;
 	cfs_rq->throttled_timestamp = rq_of(cfs_rq)->clock;
+	tg_cfs_bandwidth(cfs_rq->tg)->throttled_rqs = 1;
 }
 
 static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
@@ -1304,16 +1311,24 @@ static void unthrottle_cfs_rq(struct cfs
 static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec)
 {
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
 	if (cfs_rq->quota_assigned == RUNTIME_INF)
 		return;
 
 	cfs_rq->quota_used += delta_exec;
 
-	if (cfs_rq_throttled(cfs_rq) ||
-		cfs_rq->quota_used < cfs_rq->quota_assigned)
+	if (cfs_rq_throttled(cfs_rq))
+		return;
+
+	if (cfs_rq->quota_generation != cfs_b->generation)
+		cfs_rq->quota_assigned = min(cfs_rq->quota_used,
+				cfs_rq->quota_assigned);
+
+	if (cfs_rq->quota_used < cfs_rq->quota_assigned)
 		return;
 
 	cfs_rq->quota_assigned += tg_request_cfs_quota(cfs_rq->tg);
+	cfs_rq->quota_generation = cfs_b->generation;
 
 	if (cfs_rq->quota_used >= cfs_rq->quota_assigned) {
 		throttle_cfs_rq(cfs_rq);
@@ -1321,19 +1336,11 @@ static void account_cfs_rq_quota(struct 
 	}
 }
 
-static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
+static int redistribute_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 {
-	int i, idle = 1, num_throttled = 0;
-	u64 delta;
+	int i, idle = 1, num_throttled = 0, throttled_rqs = 0;
 	const struct cpumask *span;
-
-	if (cfs_b->quota == RUNTIME_INF)
-		return 1;
-
-	/* reset group quota */
-	raw_spin_lock(&cfs_b->lock);
-	cfs_b->runtime = cfs_b->quota;
-	raw_spin_unlock(&cfs_b->lock);
+	u64 delta;
 
 	span = sched_bw_period_mask();
 	for_each_cpu(i, span) {
@@ -1346,27 +1353,99 @@ static int do_sched_cfs_period_timer(str
 		if (!cfs_rq_throttled(cfs_rq))
 			continue;
 		num_throttled++;
+		throttled_rqs++;
 
 		delta = tg_request_cfs_quota(cfs_rq->tg);
 
 		if (delta) {
 			raw_spin_lock(&rq->lock);
 			cfs_rq->quota_assigned += delta;
+			cfs_rq->quota_generation = cfs_b->generation;
 
-			if (cfs_rq->quota_used < cfs_rq->quota_assigned)
+			if (cfs_rq->quota_used < cfs_rq->quota_assigned) {
 				unthrottle_cfs_rq(cfs_rq);
+				throttled_rqs--;
+			}
 			raw_spin_unlock(&rq->lock);
 		}
 	}
 
-	/* update throttled stats */
-	cfs_b->nr_periods++;
 	if (num_throttled)
 		cfs_b->nr_throttled++;
 
+	cfs_b->throttled_rqs = throttled_rqs;
 	return idle;
 }
 
+static void cfs_rq_return_unused_quota(struct cfs_rq *cfs_rq)
+{
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+	s64 quota_remaining;
+
+	if (cfs_rq->quota_used > cfs_rq->quota_assigned ||
+	    cfs_rq->quota_generation != cfs_b->generation)
+		return;
+
+	quota_remaining = cfs_rq->quota_assigned - cfs_rq->quota_used;
+	/* hold 1 tick of quota in reserve for workloads with high turnover */
+	if (NS_TO_JIFFIES(quota_remaining) < 1)
+		return;
+
+	quota_remaining -= NSEC_PER_SEC / HZ;
+	BUG_ON(quota_remaining < 0);
+
+	if (!quota_remaining)
+		return;
+
+	raw_spin_lock(&cfs_b->lock);
+	/* previous was speculative */
+	if (cfs_rq->quota_generation == cfs_b->generation) {
+		cfs_b->runtime += quota_remaining;
+		cfs_rq->quota_assigned -= quota_remaining;
+	}
+	raw_spin_unlock(&cfs_b->lock);
+
+	/*
+	 * if we've re-accumulated more than a slice and there are throttled
+	 * rq's, try to unthrottle them.
+	 */
+	if (cfs_b->throttled_rqs &&
+		cfs_b->runtime > sched_cfs_bandwidth_slice())
+		start_cfs_slack_bandwidth(cfs_b);
+}
+
+
+static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
+{
+	int idle = 1;
+
+	if (cfs_b->quota == RUNTIME_INF)
+		return 1;
+
+	/* reset group quota */
+	raw_spin_lock(&cfs_b->lock);
+	idle = cfs_b->runtime == cfs_b->quota;
+	cfs_b->runtime = cfs_b->quota;
+	cfs_b->generation++;
+	raw_spin_unlock(&cfs_b->lock);
+
+	idle = redistribute_cfs_bandwidth(cfs_b);
+
+	/* update throttled stats */
+	cfs_b->nr_periods++;
+
+	return idle;
+}
+
+static int do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
+{
+	if (cfs_b->quota == RUNTIME_INF)
+		return 0;
+
+	redistribute_cfs_bandwidth(cfs_b);
+	return 0;
+}
+
 #endif
 
 #ifdef CONFIG_SMP
