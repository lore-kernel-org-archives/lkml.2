Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab2BBBny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:43:54 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57941 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab2BBBnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:43:23 -0500
Subject: [RFC PATCH 05/14] sched: account for blocked load waking back up
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 01 Feb 2012 17:38:26 -0800
Message-ID: <20120202013826.20844.47587.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
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
 include/linux/sched.h |    2 +
 kernel/sched/fair.c   |   98 +++++++++++++++++++++++++++++++++++++++++--------
 kernel/sched/sched.h  |    7 +++-
 3 files changed, 90 insertions(+), 17 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 70eae51..09b8c45 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1160,6 +1160,8 @@ struct sched_avg {
 	u64 runnable_avg_sum, runnable_avg_period;
 	u64 last_runnable_update, decay_count;
 	unsigned long load_avg_contrib;
+
+	int contributes_blocked_load;
 };
 
 #ifdef CONFIG_SCHEDSTATS
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cc4ec4b..c9a8f6d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1081,17 +1081,19 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
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
@@ -1144,20 +1146,26 @@ static inline void update_entity_load_avg(struct sched_entity *se,
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
@@ -1170,14 +1178,34 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 						  struct sched_entity *se,
 						  int wakeup)
 {
-	__synchronize_entity_decay(se);
+	/* we track migrations using entity decay_count == 0 */
+	if (unlikely(se->avg.decay_count <= 0)) {
+		se->avg.last_runnable_update = rq_of(cfs_rq)->clock_task;
+		if (se->avg.decay_count) {
+			/*
+			 * In a wake-up migration we have to approximate the
+			 * time sleeping.
+			 */
+			se->avg.last_runnable_update -= (-se->avg.decay_count)
+							<< 20;
+			update_entity_load_avg(se, 0);
+		}
+		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
+		wakeup = 0;
+	} else {
+		__synchronize_entity_decay(se);
+	}
 
-	if (wakeup)
+	/* migrated tasks did not contribute to our blocked load */
+	if (wakeup) {
+		se->avg.contributes_blocked_load = 0;
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
@@ -1190,14 +1218,38 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 						  int sleep)
 {
 	update_entity_load_avg(se, 1);
+	/* we force update consideration on load-balancer moves */
+	update_cfs_rq_blocked_load(cfs_rq, !sleep);
 
 	cfs_rq->runnable_load_avg -= se->avg.load_avg_contrib;
 	if (sleep) {
+		se->avg.contributes_blocked_load = 1;
 		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
 		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
+	} else {
+		se->avg.contributes_blocked_load = 0;
+		se->avg.decay_count = 0;
 	}
 }
 
+/*
+ * Accumulate removed load so that it can be processed when we next update
+ * owning cfs_rq under rq->lock.
+ */
+inline void remove_task_load_avg_async(struct task_struct *p)
+{
+	struct sched_entity *se = &p->se;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+	if (!se->avg.contributes_blocked_load)
+		return;
+
+	se->avg.contributes_blocked_load = 0;
+	__synchronize_entity_decay(se);
+	se->avg.decay_count = 0;
+	atomic64_add(se->avg.load_avg_contrib, &cfs_rq->removed_load);
+}
+
 #else
 static inline update_entity_load_avg(struct sched_entity *se,
 				     int update_cfs_rq) {}
@@ -1208,6 +1260,7 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 						  struct sched_entity *se,
 						  int sleep) {}
+inline void remove_task_load_avg_async(struct task_struct *p) {}
 #endif
 
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -1599,7 +1652,7 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	 */
 	if (likely(curr->avg.last_runnable_update)) {
 		update_entity_load_avg(curr, 1);
-		update_cfs_rq_blocked_load(cfs_rq);
+		update_cfs_rq_blocked_load(cfs_rq, 1);
 	}
 #endif
 
@@ -3547,7 +3600,7 @@ static int update_shares_cpu(struct task_group *tg, int cpu)
 
 	update_rq_clock(rq);
 	update_cfs_load(cfs_rq, 1);
-	update_cfs_rq_blocked_load(cfs_rq);
+	update_cfs_rq_blocked_load(cfs_rq, 1);
 
 	/*
 	 * We need to update shares after updating tg->load_weight in
@@ -5617,12 +5670,14 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
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
@@ -5654,8 +5709,19 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
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
index 2c19c26..9f45b49 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -272,7 +272,7 @@ struct cfs_rq {
 	unsigned long load_contribution;
 
 	u64 runnable_load_avg, blocked_load_avg;
-	atomic64_t decay_counter;
+	atomic64_t decay_counter, removed_load;
 	u64 last_decay;
 #endif /* CONFIG_SMP */
 #ifdef CONFIG_CFS_BANDWIDTH
@@ -570,6 +570,8 @@ static inline struct task_group *task_group(struct task_struct *p)
 	return autogroup_task_group(p, tg);
 }
 
+inline void remove_task_load_avg_async(struct task_struct *p);
+
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
@@ -578,6 +580,9 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 #endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	/* if we're migrating a sleeping task we need to remove its load */
+	remove_task_load_avg_async(p);
+
 	p->se.cfs_rq = tg->cfs_rq[cpu];
 	p->se.parent = tg->se[cpu];
 #endif


