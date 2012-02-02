Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab2BBBn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:43:57 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:39999 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab2BBBnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:43:23 -0500
Subject: [RFC PATCH 01/14] sched: track the runnable average on a per-task
	entitiy basis
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 01 Feb 2012 17:38:26 -0800
Message-ID: <20120202013826.20844.8708.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of tracking averaging the load parented by a cfs_rq, we can track
entity load directly.  With the load for a given cfs_Rq then being the sum of
its children.

To do this we represent the historical contribution to runnable average within each
trailing 1024us of execution as the coefficients of a geometric series.

We can express this for a given task t as:
  runnable_sum(t) = \Sum u_i * y^i ,
  load(t) = weight_t * runnable_sum(t) / (\Sum 1024 * y^i)

Where: u_i is the usage in the last i`th 1024us period (approximately 1ms) ~ms
and y is chosen such that y^k = 1/2.  We currently choose k to be 32 which
roughly translates to about a sched period.

Signed-off-by: Paul Turner <pjt@google.com>
---
 include/linux/sched.h |    7 +++
 kernel/sched/debug.c  |    2 +
 kernel/sched/fair.c   |  114 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 123 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a5be381..91599c8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1156,6 +1156,11 @@ struct load_weight {
 	unsigned long weight, inv_weight;
 };
 
+struct sched_avg {
+	u64 runnable_avg_sum, runnable_avg_period;
+	u64 last_runnable_update;
+};
+
 #ifdef CONFIG_SCHEDSTATS
 struct sched_statistics {
 	u64			wait_start;
@@ -1215,6 +1220,8 @@ struct sched_entity {
 	struct cfs_rq		*cfs_rq;
 	/* rq "owned" by this entity/group: */
 	struct cfs_rq		*my_q;
+
+	struct sched_avg	avg;
 #endif
 };
 
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 09acaa1..d89db32 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -85,6 +85,8 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
 	P(se->statistics.wait_count);
 #endif
 	P(se->load.weight);
+	P(se->avg.runnable_avg_sum);
+	P(se->avg.runnable_avg_period);
 #undef PN
 #undef P
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8e77a6b..a570e9c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -988,6 +988,108 @@ static inline void update_entity_shares_tick(struct cfs_rq *cfs_rq)
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
+/*
+ * Approximate:
+ *   val * y^n,    where y^32 ~= 0.5 (~1 scheduling period)
+ */
+static __always_inline u64 decay_load(u64 val, int n)
+{
+	for (;n && val;n--) {
+		val *= 4008;
+		val >>= 12;
+	}
+
+	return val;
+}
+
+/* We can represent the historical contribution to runnable average as the
+ * coefficients of a geometric series.  To do this we sub-divide our runnable
+ * history into segments of approximately 1ms (1024us); label the segment that
+ * occurred N-ms ago p_N, with p_0 corresponding to the current period, e.g.
+ *
+ * [<- 1024us ->|<- 1024us ->|<- 1024us ->| ...
+ *      p0            p1           p1
+ *     (now)       (~1ms ago)  (~2ms ago)
+ *
+ * Let u_i denote the fraction of p_i that the entity was runnable.
+ *
+ * We can then represent historical load-average using u_i as the co-efficients
+ * to for a geometric series.
+ *   u_0 + u_1*y + u_2*y^2 + u_3*y^3 + ...
+ *  (Taking the sum over the equivalently decayed period)
+ *
+ * We choose k to be approximately the width of a scheduling period, that is:
+ *   y^32 = 0.5
+ * This means that the contribution to load ~32ms ago will be weighted
+ * approximately half as much as the contribution to load within the last ms.
+ *
+ * When a period "rolls over" and we have new u_0`, we can multiply the
+ * previous sum again by k to update:
+ *   load_avg = u_0` + y*(u_0 + u_1*y + u_2*y^2 + ... )
+ *            = u_0 + u_1*y + u_2*y^2 + ... [re-labeling u_i --> u_{i+1]
+ */
+static __always_inline int __update_entity_runnable_avg(u64 now,
+							struct sched_avg *sa,
+							int runnable)
+{
+	u64 delta;
+	int delta_w, decayed = 0;
+
+	delta = now - sa->last_runnable_update;
+	if((s64)delta < 0) {
+		sa->last_runnable_update = now;
+		return 0;
+	}
+
+	/*
+	 * Use 1024us as the unit of measurement since it's a reasonable
+	 * approximation of 1ms and fast to compute.
+	 */
+	delta >>= 10;
+	if (!delta)
+		return 0;
+	sa->last_runnable_update = now;
+
+	delta_w = sa->runnable_avg_period % 1024;
+	if (delta + delta_w >= 1024) {
+		/* period roll-over */
+		decayed = 1;
+
+		delta_w = 1024 - delta_w;
+		BUG_ON(delta_w > delta);
+		do {
+			if (runnable)
+				sa->runnable_avg_sum += delta_w;
+			sa->runnable_avg_period += delta_w;
+
+			sa->runnable_avg_sum =
+				decay_load(sa->runnable_avg_sum, 1);
+			sa->runnable_avg_period =
+				decay_load(sa->runnable_avg_period, 1);
+
+			delta -= delta_w;
+			delta_w = 1024;
+		} while (delta >= 1024);
+	}
+
+	if (runnable)
+		sa->runnable_avg_sum += delta;
+	sa->runnable_avg_period += delta;
+
+	return decayed;
+}
+
+/* Update a sched_entity's runnable average */
+static inline void update_entity_load_avg(struct sched_entity *se)
+{
+	__update_entity_runnable_avg(rq_of(cfs_rq_of(se))->clock_task, &se->avg,
+				     se->on_rq);
+}
+#else
+static inline void update_entity_load_avg(struct sched_entity *se) {}
+#endif
+
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 #ifdef CONFIG_SCHEDSTATS
@@ -1112,6 +1214,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 */
 	update_curr(cfs_rq);
 	update_cfs_load(cfs_rq, 0);
+	update_entity_load_avg(se);
 	account_entity_enqueue(cfs_rq, se);
 	update_cfs_shares(cfs_rq);
 
@@ -1186,6 +1289,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
+	update_entity_load_avg(se);
 
 	update_stats_dequeue(cfs_rq, se);
 	if (flags & DEQUEUE_SLEEP) {
@@ -1355,6 +1459,8 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 		update_stats_wait_start(cfs_rq, prev);
 		/* Put 'current' back into the tree. */
 		__enqueue_entity(cfs_rq, prev);
+		/* in !on_rq case, update occurred at dequeue */
+		update_entity_load_avg(prev);
 	}
 	cfs_rq->curr = NULL;
 }
@@ -1367,6 +1473,14 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	 */
 	update_curr(cfs_rq);
 
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
+	/*
+	 * Ensure that runnable average is periodically updated.
+	 */
+	if (likely(curr->avg.last_runnable_update)) {
+		update_entity_load_avg(curr);
+	}
+#endif
 	/*
 	 * Update share accounting for long-running entities.
 	 */


