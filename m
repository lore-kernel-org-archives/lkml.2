Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934658Ab2JXJrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:47:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54880 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934576Ab2JXJrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:47:00 -0400
Date: Wed, 24 Oct 2012 02:45:45 -0700
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-2dac754e10a5d41d94d2d2365c0345d4f215a266@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
In-Reply-To: <20120823141506.514678907@google.com>
References: <20120823141506.514678907@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Aggregate load contributed by task entities on parenting cfs_rq
Git-Commit-ID: 2dac754e10a5d41d94d2d2365c0345d4f215a266
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 02:45:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2dac754e10a5d41d94d2d2365c0345d4f215a266
Gitweb:     http://git.kernel.org/tip/2dac754e10a5d41d94d2d2365c0345d4f215a266
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 4 Oct 2012 13:18:30 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:27:21 +0200

sched: Aggregate load contributed by task entities on parenting cfs_rq

For a given task t, we can compute its contribution to load as:

  task_load(t) = runnable_avg(t) * weight(t)

On a parenting cfs_rq we can then aggregate:

  runnable_load(cfs_rq) = \Sum task_load(t), for all runnable children t

Maintain this bottom up, with task entities adding their contributed load to
the parenting cfs_rq sum.  When a task entity's load changes we add the same
delta to the maintained sum.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Ben Segall <bsegall@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120823141506.514678907@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |    1 +
 kernel/sched/debug.c  |    3 ++
 kernel/sched/fair.c   |   51 +++++++++++++++++++++++++++++++++++++++++++++---
 kernel/sched/sched.h  |   10 ++++++++-
 4 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 418fc6d..81d8b1b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1103,6 +1103,7 @@ struct sched_avg {
 	 */
 	u32 runnable_avg_sum, runnable_avg_period;
 	u64 last_runnable_update;
+	unsigned long load_avg_contrib;
 };
 
 #ifdef CONFIG_SCHEDSTATS
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 4240abc..c953a89 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -94,6 +94,7 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
 #ifdef CONFIG_SMP
 	P(se->avg.runnable_avg_sum);
 	P(se->avg.runnable_avg_period);
+	P(se->avg.load_avg_contrib);
 #endif
 #undef PN
 #undef P
@@ -224,6 +225,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			cfs_rq->load_contribution);
 	SEQ_printf(m, "  .%-30s: %d\n", "load_tg",
 			atomic_read(&cfs_rq->tg->load_weight));
+	SEQ_printf(m, "  .%-30s: %lld\n", "runnable_load_avg",
+			cfs_rq->runnable_load_avg);
 #endif
 
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8c5468f..77af759 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1081,20 +1081,63 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 	return decayed;
 }
 
+/* Compute the current contribution to load_avg by se, return any delta */
+static long __update_entity_load_avg_contrib(struct sched_entity *se)
+{
+	long old_contrib = se->avg.load_avg_contrib;
+
+	if (!entity_is_task(se))
+		return 0;
+
+	se->avg.load_avg_contrib = div64_u64(se->avg.runnable_avg_sum *
+					     se->load.weight,
+					     se->avg.runnable_avg_period + 1);
+
+	return se->avg.load_avg_contrib - old_contrib;
+}
+
 /* Update a sched_entity's runnable average */
 static inline void update_entity_load_avg(struct sched_entity *se)
 {
-	__update_entity_runnable_avg(rq_of(cfs_rq_of(se))->clock_task, &se->avg,
-				     se->on_rq);
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+	long contrib_delta;
+
+	if (!__update_entity_runnable_avg(rq_of(cfs_rq)->clock_task, &se->avg,
+					  se->on_rq))
+		return;
+
+	contrib_delta = __update_entity_load_avg_contrib(se);
+	if (se->on_rq)
+		cfs_rq->runnable_load_avg += contrib_delta;
 }
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
 {
 	__update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable);
 }
+
+/* Add the load generated by se into cfs_rq's child load-average */
+static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
+						  struct sched_entity *se)
+{
+	update_entity_load_avg(se);
+	cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
+}
+
+/* Remove se's load from this cfs_rq child load-average */
+static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
+						  struct sched_entity *se)
+{
+	update_entity_load_avg(se);
+	cfs_rq->runnable_load_avg -= se->avg.load_avg_contrib;
+}
 #else
 static inline void update_entity_load_avg(struct sched_entity *se) {}
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
+static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
+						  struct sched_entity *se) {}
+static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
+						  struct sched_entity *se) {}
 #endif
 
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -1223,7 +1266,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 */
 	update_curr(cfs_rq);
 	update_cfs_load(cfs_rq, 0);
-	update_entity_load_avg(se);
+	enqueue_entity_load_avg(cfs_rq, se);
 	account_entity_enqueue(cfs_rq, se);
 	update_cfs_shares(cfs_rq);
 
@@ -1298,7 +1341,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	update_entity_load_avg(se);
+	dequeue_entity_load_avg(cfs_rq, se);
 
 	update_stats_dequeue(cfs_rq, se);
 	if (flags & DEQUEUE_SLEEP) {
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 14b5719..e653973 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -222,6 +222,15 @@ struct cfs_rq {
 	unsigned int nr_spread_over;
 #endif
 
+#ifdef CONFIG_SMP
+	/*
+	 * CFS Load tracking
+	 * Under CFS, load is tracked on a per-entity basis and aggregated up.
+	 * This allows for the description of both thread and group usage (in
+	 * the FAIR_GROUP_SCHED case).
+	 */
+	u64 runnable_load_avg;
+#endif
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */
 
@@ -1214,4 +1223,3 @@ static inline u64 irq_time_read(int cpu)
 }
 #endif /* CONFIG_64BIT */
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
-
