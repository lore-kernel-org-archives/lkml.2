Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab2F1C5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:57:15 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40016 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758165Ab2F1C40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:56:26 -0400
Subject: [PATCH 10/16] sched: maintain runnable averages across throttled
	periods
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 27 Jun 2012 19:24:15 -0700
Message-ID: <20120628022414.30496.40891.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With bandwidth control tracked entities may cease execution according to user
specified bandwidth limits.  Charging this time as either throttled or blocked
however, is incorrect and would falsely skew in either direction.

What we actually want is for any throttled periods to be "invisible" to
load-tracking as they are removed from the system for that interval and
contribute normally otherwise.

Do this by moderating the progression of time to omit any periods in which the
entity belonged to a throttled hierarchy.

Signed-off-by: Paul Turner <pjt@google.com>
---
 kernel/sched/fair.c  |   50 ++++++++++++++++++++++++++++++++++++++++----------
 kernel/sched/sched.h |    3 ++-
 2 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 91d0b21..b78d03e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1204,15 +1204,26 @@ static inline void subtract_blocked_load_contrib(struct cfs_rq *cfs_rq,
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
@@ -1232,7 +1243,7 @@ static inline void update_entity_load_avg(struct sched_entity *se,
  */
 static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 {
-	u64 now = rq_of(cfs_rq)->clock_task >> 20;
+	u64 now = cfs_rq_clock_task(cfs_rq) >> 20;
 	u64 decays;
 
 	decays = now - cfs_rq->last_decay;
@@ -1824,6 +1835,15 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
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
@@ -1974,6 +1994,10 @@ static int tg_unthrottle_up(struct task_group *tg, void *data)
 		cfs_rq->load_stamp += delta;
 		cfs_rq->load_last += delta;
 
+		/* adjust cfs_rq_clock_task() */
+		cfs_rq->throttled_clock_task_time += rq->clock_task -
+					     cfs_rq->throttled_clock_task;
+
 		/* update entity weight now that we are on_rq again */
 		update_cfs_shares(cfs_rq);
 	}
@@ -1988,8 +2012,10 @@ static int tg_throttle_down(struct task_group *tg, void *data)
 	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu_of(rq)];
 
 	/* group is entering throttled state, record last load */
-	if (!cfs_rq->throttle_count)
+	if (!cfs_rq->throttle_count) {
 		update_cfs_load(cfs_rq, 0);
+		cfs_rq->throttled_clock_task = rq->clock_task;
+	}
 	cfs_rq->throttle_count++;
 
 	return 0;
@@ -2004,7 +2030,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
-	/* account load preceding throttle */
+	/* freeze hierarchy runnable averages while throttled */
 	rcu_read_lock();
 	walk_tg_tree_from(cfs_rq->tg, tg_throttle_down, tg_nop, (void *)rq);
 	rcu_read_unlock();
@@ -2028,7 +2054,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 		rq->nr_running -= task_delta;
 
 	cfs_rq->throttled = 1;
-	cfs_rq->throttled_timestamp = rq->clock;
+	cfs_rq->throttled_clock = rq->clock;
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
 	raw_spin_unlock(&cfs_b->lock);
@@ -2046,10 +2072,9 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 
 	cfs_rq->throttled = 0;
 	raw_spin_lock(&cfs_b->lock);
-	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_timestamp;
+	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_clock;
 	list_del_rcu(&cfs_rq->throttled_list);
 	raw_spin_unlock(&cfs_b->lock);
-	cfs_rq->throttled_timestamp = 0;
 
 	update_rq_clock(rq);
 	/* update hierarchical throttle state */
@@ -2449,8 +2474,13 @@ void unthrottle_offline_cfs_rqs(struct rq *rq)
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
index b48bbd7..60c0935 100644
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


