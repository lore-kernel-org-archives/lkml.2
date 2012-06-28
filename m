Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab2F1C51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:57:27 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:50285 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758152Ab2F1C40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:56:26 -0400
Subject: [PATCH 15/16] sched: implement usage tracking
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
Message-ID: <20120628022415.30496.74768.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the frame-work for runnable tracking now fully in place.  Per-entity usage
tracking is a simple and low-overhead addition.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Ben Segall <bsegall@google.com>
---
 include/linux/sched.h |    1 +
 kernel/sched/debug.c  |    3 +++
 kernel/sched/fair.c   |   33 ++++++++++++++++++++++++++++-----
 kernel/sched/sched.h  |    4 ++--
 4 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index fdfdfab..a65c097 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1142,6 +1142,7 @@ struct sched_avg {
 	u64 last_runnable_update;
 	s64 decay_count;
 	unsigned long load_avg_contrib;
+	u32 usage_avg_sum;
 };
 
 #ifdef CONFIG_SCHEDSTATS
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index fbd1517..e8f8d51 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -94,6 +94,7 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
 #ifdef CONFIG_SMP
 	P(se->avg.runnable_avg_sum);
 	P(se->avg.runnable_avg_period);
+	P(se->avg.usage_avg_sum);
 	P(se->avg.load_avg_contrib);
 	P(se->avg.decay_count);
 #endif
@@ -233,6 +234,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			cfs_rq->tg_runnable_contrib);
 	SEQ_printf(m, "  .%-30s: %d\n", "tg->runnable_avg",
 			atomic_read(&cfs_rq->tg->runnable_avg));
+	SEQ_printf(m, "  .%-30s: %d\n", "tg->usage_avg",
+			atomic_read(&cfs_rq->tg->usage_avg));
 #endif
 
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 89c353c..3d1aaa8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -996,7 +996,8 @@ static u32 __compute_runnable_contrib(int n)
  */
 static __always_inline int __update_entity_runnable_avg(u64 now,
 							struct sched_avg *sa,
-							int runnable)
+							int runnable,
+							int running)
 {
 	u64 delta, periods;
 	u32 runnable_contrib;
@@ -1035,6 +1036,8 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 		delta_w = 1024 - delta_w;
 		if (runnable)
 			sa->runnable_avg_sum += delta_w;
+		if (running)
+			sa->usage_avg_sum += delta_w;
 		sa->runnable_avg_period += delta_w;
 
 		delta -= delta_w;
@@ -1047,17 +1050,22 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 						  periods + 1);
 		sa->runnable_avg_period = decay_load(sa->runnable_avg_period,
 						     periods + 1);
+		sa->usage_avg_sum = decay_load(sa->usage_avg_sum, periods + 1);
 
 		/* Efficiently calculate \sum (1..n_period) 1024*y^i */
 		runnable_contrib = __compute_runnable_contrib(periods);
 		if (runnable)
 			sa->runnable_avg_sum += runnable_contrib;
+		if (running)
+			sa->usage_avg_sum += runnable_contrib;
 		sa->runnable_avg_period += runnable_contrib;
 	}
 
 	/* Remainder of delta accrued against u_0` */
 	if (runnable)
 		sa->runnable_avg_sum += delta;
+	if (running)
+		sa->usage_avg_sum += delta;
 	sa->runnable_avg_period += delta;
 
 	return decayed;
@@ -1103,15 +1111,27 @@ static inline void __update_tg_runnable_avg(struct sched_avg *sa,
 						  struct cfs_rq *cfs_rq)
 {
 	struct task_group *tg = cfs_rq->tg;
-	long contrib;
+	long contrib, usage_contrib;
 
 	contrib = div_u64(sa->runnable_avg_sum << 12,
 			  sa->runnable_avg_period + 1);
 	contrib -= cfs_rq->tg_runnable_contrib;
 
-	if (abs(contrib) > cfs_rq->tg_runnable_contrib / 64) {
+	usage_contrib = div_u64(sa->usage_avg_sum << 12,
+			        sa->runnable_avg_period + 1);
+	usage_contrib -= cfs_rq->tg_usage_contrib;
+
+	/*
+	 * contrib/usage at this point represent deltas, only update if they
+	 * are substantive.
+	 */
+	if ((abs(contrib) > cfs_rq->tg_runnable_contrib / 64) ||
+	    (abs(usage_contrib) > cfs_rq->tg_usage_contrib / 64)) {
 		atomic_add(contrib, &tg->runnable_avg);
 		cfs_rq->tg_runnable_contrib += contrib;
+
+		atomic_add(usage_contrib, &tg->usage_avg);
+		cfs_rq->tg_usage_contrib += usage_contrib;
 	}
 }
 
@@ -1201,7 +1221,8 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 	else
 		now = cfs_rq_clock_task(group_cfs_rq(se));
 
-	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq))
+	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq,
+					  cfs_rq->curr == se))
 		return;
 
 	contrib_delta = __update_entity_load_avg_contrib(se);
@@ -1246,7 +1267,8 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
 {
-	__update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable);
+	__update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable,
+				     runnable);
 	__update_tg_runnable_avg(&rq->avg, &rq->cfs);
 }
 
@@ -1615,6 +1637,7 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		 */
 		update_stats_wait_end(cfs_rq, se);
 		__dequeue_entity(cfs_rq, se);
+		update_entity_load_avg(se, 1);
 	}
 
 	update_stats_curr_start(cfs_rq, se);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 67cc5e1..bb76895 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -113,7 +113,7 @@ struct task_group {
 
 	atomic_t load_weight;
 	atomic64_t load_avg;
-	atomic_t runnable_avg;
+	atomic_t runnable_avg, usage_avg;
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -236,7 +236,7 @@ struct cfs_rq {
 	u64 last_decay;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	u32 tg_runnable_contrib;
+	u32 tg_runnable_contrib, tg_usage_contrib;
 	u64 tg_load_contrib;
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 


