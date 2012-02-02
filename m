Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab2BBBpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:45:35 -0500
Received: from mail-gy0-f202.google.com ([209.85.160.202]:63200 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab2BBBnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:43:22 -0500
Subject: [RFC PATCH 09/14] sched: maintain runnable averages across throttled
	periods
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 01 Feb 2012 17:38:27 -0800
Message-ID: <20120202013826.20844.60605.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
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
 kernel/sched/fair.c  |   33 +++++++++++++++++++++++++++------
 kernel/sched/sched.h |    3 ++-
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 803c622..71c7410 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1185,6 +1185,8 @@ static inline void subtract_blocked_load_contrib(struct cfs_rq *cfs_rq,
 		cfs_rq->blocked_load_avg = 0;
 }
 
+static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq);
+
 /* Update a sched_entity's runnable average */
 static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq)
@@ -1213,7 +1215,7 @@ static inline void update_entity_load_avg(struct sched_entity *se,
  */
 static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 {
-	u64 now = rq_of(cfs_rq)->clock_task >> 20;
+	u64 now = cfs_rq_clock_task(cfs_rq) >> 20;
 	u64 decays;
 
 	decays = now - cfs_rq->last_decay;
@@ -1820,6 +1822,15 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
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
@@ -1970,6 +1981,10 @@ static int tg_unthrottle_up(struct task_group *tg, void *data)
 		cfs_rq->load_stamp += delta;
 		cfs_rq->load_last += delta;
 
+		/* adjust cfs_rq_clock_task() */
+		cfs_rq->throttled_clock_task_time += rq->clock_task -
+					     cfs_rq->throttled_clock_task;
+
 		/* update entity weight now that we are on_rq again */
 		update_cfs_shares(cfs_rq);
 	}
@@ -1984,8 +1999,10 @@ static int tg_throttle_down(struct task_group *tg, void *data)
 	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu_of(rq)];
 
 	/* group is entering throttled state, record last load */
-	if (!cfs_rq->throttle_count)
+	if (!cfs_rq->throttle_count) {
 		update_cfs_load(cfs_rq, 0);
+		cfs_rq->throttled_clock_task = rq->clock_task;
+	}
 	cfs_rq->throttle_count++;
 
 	return 0;
@@ -2000,7 +2017,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
-	/* account load preceding throttle */
+	/* freeze hierarchy runnable averages while throttled */
 	rcu_read_lock();
 	walk_tg_tree_from(cfs_rq->tg, tg_throttle_down, tg_nop, (void *)rq);
 	rcu_read_unlock();
@@ -2024,7 +2041,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 		rq->nr_running -= task_delta;
 
 	cfs_rq->throttled = 1;
-	cfs_rq->throttled_timestamp = rq->clock;
+	cfs_rq->throttled_clock = rq->clock;
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
 	raw_spin_unlock(&cfs_b->lock);
@@ -2042,10 +2059,9 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 
 	cfs_rq->throttled = 0;
 	raw_spin_lock(&cfs_b->lock);
-	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_timestamp;
+	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_clock;
 	list_del_rcu(&cfs_rq->throttled_list);
 	raw_spin_unlock(&cfs_b->lock);
-	cfs_rq->throttled_timestamp = 0;
 
 	update_rq_clock(rq);
 	/* update hierarchical throttle state */
@@ -2445,6 +2461,11 @@ void unthrottle_offline_cfs_rqs(struct rq *rq)
 }
 
 #else /* CONFIG_CFS_BANDWIDTH */
+static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq)
+{
+	return rq_of(cfs_rq)->clock_task;
+}
+
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 				     unsigned long delta_exec) {}
 static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 57cc227..a823ca4 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -284,7 +284,8 @@ struct cfs_rq {
 	u64 runtime_expires;
 	s64 runtime_remaining;
 
-	u64 throttled_timestamp;
+	u64 throttled_clock, throttled_clock_task;
+	u64 throttled_clock_task_time;
 	int throttled, throttle_count;
 	struct list_head throttled_list;
 #endif /* CONFIG_CFS_BANDWIDTH */


