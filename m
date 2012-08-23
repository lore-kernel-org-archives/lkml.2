Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990Ab2HWOQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:16:26 -0400
Received: from mail-vb0-f74.google.com ([209.85.212.74]:61556 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757772Ab2HWOPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:15:32 -0400
Message-Id: <20120823141506.998912151@google.com>
User-Agent: quilt/0.48-1
Date: Thu, 23 Aug 2012 07:14:32 -0700
From: pjt@google.com
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ben Segall <bsegall@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [patch 10/16] sched: maintain runnable averages across throttled periods
References: <20120823141422.444396696@google.com>
Content-Disposition: inline; filename=sched-bwc_load.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Turner <pjt@google.com>

With bandwidth control tracked entities may cease execution according to user
specified bandwidth limits.  Charging this time as either throttled or blocked
however, is incorrect and would falsely skew in either direction.

What we actually want is for any throttled periods to be "invisible" to
load-tracking as they are removed from the system for that interval and
contribute normally otherwise.

Do this by moderating the progression of time to omit any periods in which the
entity belonged to a throttled hierarchy.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Ben Segall <bsegall@google.com>
---
 kernel/sched/fair.c  |   50 ++++++++++++++++++++++++++++++++++++++++----------
 kernel/sched/sched.h |    3 ++-
 2 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 47a7998..e7decc9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1216,15 +1216,26 @@ static inline void subtract_blocked_load_contrib(struct cfs_rq *cfs_rq,
 		cfs_rq->blocked_load_avg = 0;
 }
 
+static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq);
+
 /* Update a sched_entity's runnable average */
 static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq)
 {
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 	long contrib_delta;
+	u64 now;
 
-	if (!__update_entity_runnable_avg(rq_of(cfs_rq)->clock_task, &se->avg,
-					  se->on_rq))
+	/*
+	 * For a group entity we need to use their owned cfs_rq_clock_task() in
+	 * case they are the parent of a throttled hierarchy.
+	 */
+	if (entity_is_task(se))
+		now = cfs_rq_clock_task(cfs_rq);
+	else
+		now = cfs_rq_clock_task(group_cfs_rq(se));
+
+	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq))
 		return;
 
 	contrib_delta = __update_entity_load_avg_contrib(se);
@@ -1244,7 +1255,7 @@ static inline void update_entity_load_avg(struct sched_entity *se,
  */
 static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 {
-	u64 now = rq_of(cfs_rq)->clock_task >> 20;
+	u64 now = cfs_rq_clock_task(cfs_rq) >> 20;
 	u64 decays;
 
 	decays = now - cfs_rq->last_decay;
@@ -1835,6 +1846,15 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
 	return &tg->cfs_bandwidth;
 }
 
+/* rq->task_clock normalized against any time this cfs_rq has spent throttled */
+static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq)
+{
+	if (unlikely(cfs_rq->throttle_count))
+		return cfs_rq->throttled_clock_task;
+
+	return rq_of(cfs_rq)->clock_task - cfs_rq->throttled_clock_task_time;
+}
+
 /* returns 0 on failure to allocate runtime */
 static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
@@ -1985,6 +2005,10 @@ static int tg_unthrottle_up(struct task_group *tg, void *data)
 		cfs_rq->load_stamp += delta;
 		cfs_rq->load_last += delta;
 
+		/* adjust cfs_rq_clock_task() */
+		cfs_rq->throttled_clock_task_time += rq->clock_task -
+					     cfs_rq->throttled_clock_task;
+
 		/* update entity weight now that we are on_rq again */
 		update_cfs_shares(cfs_rq);
 	}
@@ -1999,8 +2023,10 @@ static int tg_throttle_down(struct task_group *tg, void *data)
 	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu_of(rq)];
 
 	/* group is entering throttled state, record last load */
-	if (!cfs_rq->throttle_count)
+	if (!cfs_rq->throttle_count) {
 		update_cfs_load(cfs_rq, 0);
+		cfs_rq->throttled_clock_task = rq->clock_task;
+	}
 	cfs_rq->throttle_count++;
 
 	return 0;
@@ -2015,7 +2041,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
-	/* account load preceding throttle */
+	/* freeze hierarchy runnable averages while throttled */
 	rcu_read_lock();
 	walk_tg_tree_from(cfs_rq->tg, tg_throttle_down, tg_nop, (void *)rq);
 	rcu_read_unlock();
@@ -2039,7 +2065,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 		rq->nr_running -= task_delta;
 
 	cfs_rq->throttled = 1;
-	cfs_rq->throttled_timestamp = rq->clock;
+	cfs_rq->throttled_clock = rq->clock;
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
 	raw_spin_unlock(&cfs_b->lock);
@@ -2057,10 +2083,9 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 
 	cfs_rq->throttled = 0;
 	raw_spin_lock(&cfs_b->lock);
-	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_timestamp;
+	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_clock;
 	list_del_rcu(&cfs_rq->throttled_list);
 	raw_spin_unlock(&cfs_b->lock);
-	cfs_rq->throttled_timestamp = 0;
 
 	update_rq_clock(rq);
 	/* update hierarchical throttle state */
@@ -2460,8 +2485,13 @@ void unthrottle_offline_cfs_rqs(struct rq *rq)
 }
 
 #else /* CONFIG_CFS_BANDWIDTH */
-static __always_inline
-void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec) {}
+static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq)
+{
+	return rq_of(cfs_rq)->clock_task;
+}
+
+static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+				     unsigned long delta_exec) {}
 static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
 static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1474bf2..cfb8f1b 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -281,7 +281,8 @@ struct cfs_rq {
 	u64 runtime_expires;
 	s64 runtime_remaining;
 
-	u64 throttled_timestamp;
+	u64 throttled_clock, throttled_clock_task;
+	u64 throttled_clock_task_time;
 	int throttled, throttle_count;
 	struct list_head throttled_list;
 #endif /* CONFIG_CFS_BANDWIDTH */


