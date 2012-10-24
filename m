Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab2JXJx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:53:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54985 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab2JXJxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:53:55 -0400
Date: Wed, 24 Oct 2012 02:52:42 -0700
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-f1b17280efbd21873d1db8631117bdbccbcb39a2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
In-Reply-To: <20120823141506.998912151@google.com>
References: <20120823141506.998912151@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Maintain runnable averages across throttled periods
Git-Commit-ID: f1b17280efbd21873d1db8631117bdbccbcb39a2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 02:52:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1b17280efbd21873d1db8631117bdbccbcb39a2
Gitweb:     http://git.kernel.org/tip/f1b17280efbd21873d1db8631117bdbccbcb39a2
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 4 Oct 2012 13:18:31 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:27:27 +0200

sched: Maintain runnable averages across throttled periods

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120823141506.998912151@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c  |   50 ++++++++++++++++++++++++++++++++++++++++----------
 kernel/sched/sched.h |    3 ++-
 2 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9e49722..873c9f5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1222,15 +1222,26 @@ static inline void subtract_blocked_load_contrib(struct cfs_rq *cfs_rq,
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
@@ -1250,7 +1261,7 @@ static inline void update_entity_load_avg(struct sched_entity *se,
  */
 static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 {
-	u64 now = rq_of(cfs_rq)->clock_task >> 20;
+	u64 now = cfs_rq_clock_task(cfs_rq) >> 20;
 	u64 decays;
 
 	decays = now - cfs_rq->last_decay;
@@ -1841,6 +1852,15 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
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
@@ -1991,6 +2011,10 @@ static int tg_unthrottle_up(struct task_group *tg, void *data)
 		cfs_rq->load_stamp += delta;
 		cfs_rq->load_last += delta;
 
+		/* adjust cfs_rq_clock_task() */
+		cfs_rq->throttled_clock_task_time += rq->clock_task -
+					     cfs_rq->throttled_clock_task;
+
 		/* update entity weight now that we are on_rq again */
 		update_cfs_shares(cfs_rq);
 	}
@@ -2005,8 +2029,10 @@ static int tg_throttle_down(struct task_group *tg, void *data)
 	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu_of(rq)];
 
 	/* group is entering throttled state, record last load */
-	if (!cfs_rq->throttle_count)
+	if (!cfs_rq->throttle_count) {
 		update_cfs_load(cfs_rq, 0);
+		cfs_rq->throttled_clock_task = rq->clock_task;
+	}
 	cfs_rq->throttle_count++;
 
 	return 0;
@@ -2021,7 +2047,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
-	/* account load preceding throttle */
+	/* freeze hierarchy runnable averages while throttled */
 	rcu_read_lock();
 	walk_tg_tree_from(cfs_rq->tg, tg_throttle_down, tg_nop, (void *)rq);
 	rcu_read_unlock();
@@ -2045,7 +2071,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 		rq->nr_running -= task_delta;
 
 	cfs_rq->throttled = 1;
-	cfs_rq->throttled_timestamp = rq->clock;
+	cfs_rq->throttled_clock = rq->clock;
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
 	raw_spin_unlock(&cfs_b->lock);
@@ -2063,10 +2089,9 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 
 	cfs_rq->throttled = 0;
 	raw_spin_lock(&cfs_b->lock);
-	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_timestamp;
+	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_clock;
 	list_del_rcu(&cfs_rq->throttled_list);
 	raw_spin_unlock(&cfs_b->lock);
-	cfs_rq->throttled_timestamp = 0;
 
 	update_rq_clock(rq);
 	/* update hierarchical throttle state */
@@ -2466,8 +2491,13 @@ static void unthrottle_offline_cfs_rqs(struct rq *rq)
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
index 134928d..d13bce7 100644
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
