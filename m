Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab2F1C5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:57:12 -0400
Received: from mail-lb0-f202.google.com ([209.85.217.202]:52108 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159Ab2F1C40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:56:26 -0400
Subject: [PATCH 06/16] sched: account for blocked load waking back up
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
Date: Wed, 27 Jun 2012 19:24:14 -0700
Message-ID: <20120628022414.30496.49492.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a running entity blocks we migrate its tracked load to
cfs_rq->blocked_runnable_avg.  In the sleep case this occurs while holding
rq->lock and so is a natural transition.  Wake-ups however, are potentially
asynchronous in the presence of migration and so special care must be taken.

We use an atomic counter to track such migrated load, taking care to match this
with the previously introduced decay counters so that we don't migrate too much
load.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Ben Segall <bsegall@google.com>
---
 kernel/sched/fair.c  |   94 ++++++++++++++++++++++++++++++++++++++++----------
 kernel/sched/sched.h |    2 +
 2 files changed, 77 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 33f582a..ea3d4f5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1086,17 +1086,19 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 }
 
 /* Synchronize an entity's decay with its parentin cfs_rq.*/
-static inline void __synchronize_entity_decay(struct sched_entity *se)
+static inline u64 __synchronize_entity_decay(struct sched_entity *se)
 {
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 	u64 decays = atomic64_read(&cfs_rq->decay_counter);
 
 	decays -= se->avg.decay_count;
 	if (!decays)
-		return;
+		return 0;
 
 	se->avg.load_avg_contrib = decay_load(se->avg.load_avg_contrib, decays);
 	se->avg.decay_count += decays;
+
+	return decays;
 }
 
 /* Compute the current contribution to load_avg by se, return any delta */
@@ -1149,20 +1151,26 @@ static inline void update_entity_load_avg(struct sched_entity *se,
  * Decay the load contributed by all blocked children and account this so that
  * they their contribution may appropriately discounted when they wake up.
  */
-static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq)
+static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 {
 	u64 now = rq_of(cfs_rq)->clock_task >> 20;
 	u64 decays;
 
 	decays = now - cfs_rq->last_decay;
-	if (!decays)
+	if (!decays && !force_update)
 		return;
 
-	cfs_rq->blocked_load_avg = decay_load(cfs_rq->blocked_load_avg,
-					      decays);
-	atomic64_add(decays, &cfs_rq->decay_counter);
+	if (atomic64_read(&cfs_rq->removed_load)) {
+		u64 removed_load = atomic64_xchg(&cfs_rq->removed_load, 0);
+		subtract_blocked_load_contrib(cfs_rq, removed_load);
+	}
 
-	cfs_rq->last_decay = now;
+	if (decays) {
+		cfs_rq->blocked_load_avg = decay_load(cfs_rq->blocked_load_avg,
+						      decays);
+		atomic64_add(decays, &cfs_rq->decay_counter);
+		cfs_rq->last_decay = now;
+	}
 }
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
@@ -1175,21 +1183,41 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 						  struct sched_entity *se,
 						  int wakeup)
 {
-	/* we track migrations using entity decay_count == 0 */
-	if (unlikely(!se->avg.decay_count)) {
+	/*
+	 * We track migrations using entity decay_count <= 0, on a wake-up
+	 * migration we use a negative decay count to track the remote decays
+	 * accumulated while sleeping.
+	 */
+	if (unlikely(se->avg.decay_count <= 0)) {
 		se->avg.last_runnable_update = rq_of(cfs_rq)->clock_task;
+		if (se->avg.decay_count) {
+			/*
+			 * In a wake-up migration we have to approximate the
+			 * time sleeping.  This is because we can't synchronize
+			 * clock_task between the two cpus, and it is not
+			 * guaranteed to be read-safe.  Instead, we can
+			 * approximate this using our carried decays, which are
+			 * explicitly atomically readable.
+			 */
+			se->avg.last_runnable_update -= (-se->avg.decay_count)
+							<< 20;
+			update_entity_load_avg(se, 0);
+		}
 		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
 		wakeup = 0;
 	} else {
 		__synchronize_entity_decay(se);
 	}
 
-	if (wakeup)
+	/* migrated tasks did not contribute to our blocked load */
+	if (wakeup) {
 		subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);
+		update_entity_load_avg(se, 0);
+	}
 
-	update_entity_load_avg(se, 0);
 	cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
-	update_cfs_rq_blocked_load(cfs_rq);
+	/* we force update consideration on load-balancer moves */
+	update_cfs_rq_blocked_load(cfs_rq, !wakeup);
 }
 
 /*
@@ -1202,6 +1230,8 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 						  int sleep)
 {
 	update_entity_load_avg(se, 1);
+	/* we force update consideration on load-balancer moves */
+	update_cfs_rq_blocked_load(cfs_rq, !sleep);
 
 	cfs_rq->runnable_load_avg -= se->avg.load_avg_contrib;
 	if (sleep) {
@@ -1221,7 +1251,8 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 					   struct sched_entity *se,
 					   int sleep) {}
-static inline void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq) {}
+static inline void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
+					      int force_update) {}
 #endif
 
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -1613,7 +1644,7 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	 * Ensure that runnable average is periodically updated.
 	 */
 	update_entity_load_avg(curr, 1);
-	update_cfs_rq_blocked_load(cfs_rq);
+	update_cfs_rq_blocked_load(cfs_rq, 1);
 
 	/*
 	 * Update share accounting for long-running entities.
@@ -3099,7 +3130,21 @@ unlock:
  */
 static void
 migrate_task_rq_fair(struct task_struct *p, int next_cpu) {
+	struct sched_entity *se = &p->se;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+	/*
+	 * Load tracking: accumulate removed load so that it can be processed
+	 * when we next update owning cfs_rq under rq->lock.  Tasks contribute
+	 * to blocked load iff they have a non-zero decay-count.
+	 */
+	if (se->avg.decay_count) {
+		se->avg.decay_count = -__synchronize_entity_decay(se);
+		atomic64_add(se->avg.load_avg_contrib, &cfs_rq->removed_load);
+	}
 }
+
+
 #endif /* CONFIG_SMP */
 
 static unsigned long
@@ -3651,7 +3696,7 @@ static int update_shares_cpu(struct task_group *tg, int cpu)
 
 	update_rq_clock(rq);
 	update_cfs_load(cfs_rq, 1);
-	update_cfs_rq_blocked_load(cfs_rq);
+	update_cfs_rq_blocked_load(cfs_rq, 1);
 
 	/*
 	 * We need to update shares after updating tg->load_weight in
@@ -5537,12 +5582,14 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #endif
 #if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
 	atomic64_set(&cfs_rq->decay_counter, 1);
+	atomic64_set(&cfs_rq->removed_load, 0);
 #endif
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void task_move_group_fair(struct task_struct *p, int on_rq)
 {
+	struct cfs_rq *cfs_rq;
 	/*
 	 * If the task was not on the rq at the time of this cgroup movement
 	 * it must have been asleep, sleeping tasks keep their ->vruntime
@@ -5574,8 +5621,19 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
 	if (!on_rq)
 		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
 	set_task_rq(p, task_cpu(p));
-	if (!on_rq)
-		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
+	if (!on_rq) {
+		cfs_rq = cfs_rq_of(&p->se);
+		p->se.vruntime += cfs_rq->min_vruntime;
+#ifdef CONFIG_SMP
+		/*
+		 * set_task_rq will() have removed our previous contribution,
+		 * but we must synchronize explicitly against further decay
+		 * here.
+		 */
+		p->se.avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
+		cfs_rq->blocked_load_avg += p->se.avg.load_avg_contrib;
+#endif
+	}
 }
 
 void free_fair_sched_group(struct task_group *tg)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index a96adf1..ca1003d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -230,7 +230,7 @@ struct cfs_rq {
 	 * the FAIR_GROUP_SCHED case).
 	 */
 	u64 runnable_load_avg, blocked_load_avg;
-	atomic64_t decay_counter;
+	atomic64_t decay_counter, removed_load;
 	u64 last_decay;
 #endif
 #ifdef CONFIG_FAIR_GROUP_SCHED


