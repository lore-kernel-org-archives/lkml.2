Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab2HWOQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:16:15 -0400
Received: from mail-ey0-f202.google.com ([209.85.215.202]:63373 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850Ab2HWOPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:15:32 -0400
Message-Id: <20120823141506.792901086@google.com>
User-Agent: quilt/0.48-1
Date: Thu, 23 Aug 2012 07:14:29 -0700
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
Subject: [patch 07/16] sched: aggregate total task_group load
References: <20120823141422.444396696@google.com>
Content-Disposition: inline; filename=sched-compute_tg_load.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Turner <pjt@google.com>

Maintain a global running sum of the average load seen on each cfs_rq belonging
to each task group so that it may be used in calculating an appropriate
shares:weight distribution.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Ben Segall <bsegall@google.com>
---
 kernel/sched/debug.c |    4 ++++
 kernel/sched/fair.c  |   22 ++++++++++++++++++++++
 kernel/sched/sched.h |    4 ++++
 3 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 2d2e2b3..2908923 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -230,6 +230,10 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			cfs_rq->runnable_load_avg);
 	SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
 			cfs_rq->blocked_load_avg);
+	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
+			atomic64_read(&cfs_rq->tg->load_avg));
+	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_contrib",
+			cfs_rq->tg_load_contrib);
 #endif
 
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9c1f090..40259cc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1096,6 +1096,26 @@ static inline u64 __synchronize_entity_decay(struct sched_entity *se)
 	return decays;
 }
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
+						 int force_update)
+{
+	struct task_group *tg = cfs_rq->tg;
+	s64 tg_contrib;
+
+	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
+	tg_contrib -= cfs_rq->tg_load_contrib;
+
+	if (force_update || abs64(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
+		atomic64_add(tg_contrib, &tg->load_avg);
+		cfs_rq->tg_load_contrib += tg_contrib;
+	}
+}
+#else
+static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
+						 int force_update) {}
+#endif
+
 /* Compute the current contribution to load_avg by se, return any delta */
 static long __update_entity_load_avg_contrib(struct sched_entity *se)
 {
@@ -1166,6 +1186,8 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 		atomic64_add(decays, &cfs_rq->decay_counter);
 		cfs_rq->last_decay = now;
 	}
+
+	__update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
 }
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index f282c62..0c453e7 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -112,6 +112,7 @@ struct task_group {
 	unsigned long shares;
 
 	atomic_t load_weight;
+	atomic64_t load_avg;
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -232,6 +233,9 @@ struct cfs_rq {
 	u64 runnable_load_avg, blocked_load_avg;
 	atomic64_t decay_counter, removed_load;
 	u64 last_decay;
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	u64 tg_load_contrib;
+#endif
 #endif
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */


