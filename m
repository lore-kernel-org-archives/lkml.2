Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1JMPBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:01:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51400 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab1JMPBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:01:12 -0400
Subject: [PATCH] sched: Add a comment to effective_load() since its a pain
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 13 Oct 2011 17:00:57 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318518057.27731.2.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: Add a comment to effective_load() since its a pain
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Oct 13 16:52:28 CEST 2011

Every time I have to stare at this function I need to completely
reverse engineer its workings, about time I write a comment explaining
the thing.

Collected bits and pieces from previous changelogs, mostly:
  4be9daaa1b33701f011f4117f22dc1e45a3e6e34
  83378269a5fad98f562ebc0f09c349575e6cbfe1
  
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |  113 +++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 95 insertions(+), 18 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -752,19 +752,32 @@ static void update_cfs_load(struct cfs_r
 		list_del_leaf_cfs_rq(cfs_rq);
 }
 
+static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
+{
+	long tg_weight;
+
+	/*
+	 * Use this CPU's actual weight instead of the last load_contribution
+	 * to gain a more accurate current total weight. See
+	 * update_cfs_rq_load_contribution().
+	 */
+	tg_weight = atomic_read(&tg->load_weight);
+	tg_weight -= cfs_rq->load_contribution;
+	tg_weight += cfs_rq->load.weight;
+
+	return tg_weight;
+}
+
 static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
 {
-	long load_weight, load, shares;
+	long tg_weight, load, shares;
 
+	tg_weight = calc_tg_weight(tg, cfs_rq);
 	load = cfs_rq->load.weight;
 
-	load_weight = atomic_read(&tg->load_weight);
-	load_weight += load;
-	load_weight -= cfs_rq->load_contribution;
-
 	shares = (tg->shares * load);
-	if (load_weight)
-		shares /= load_weight;
+	if (tg_weight)
+		shares /= tg_weight;
 
 	if (shares < MIN_SHARES)
 		shares = MIN_SHARES;
@@ -1399,36 +1412,100 @@ static void task_waking_fair(struct task
  * Adding load to a group doesn't make a group heavier, but can cause movement
  * of group shares between cpus. Assuming the shares were perfectly aligned one
  * can calculate the shift in shares.
+ *
+ * Calculate the effective load difference if @wl is added (subtracted) to @tg
+ * on this @cpu and results in a total addition (subtraction) of @wg to the
+ * total group weight.
+ *
+ * Given a runqueue weight distribution (rw_i) we can compute a shares
+ * distribution (s_i) using:
+ *
+ *   s_i = rw_i / \Sum rw_j						(1)
+ *
+ * Suppose we have 4 CPUs and our @tg is a direct child of the root group and
+ * has 7 equal weight tasks, distributed as below (rw_i), with the resulting
+ * shares distribution (s_i):
+ *
+ *   rw_i = {   2,   4,   1,   0 }
+ *   s_i  = { 2/7, 4/7, 1/7,   0 }
+ *
+ * As per wake_affine() we're interested in the load of two CPUs (the CPU the
+ * task used to run on and the CPU the waker is running on), we need to
+ * compute the effect of waking a task on either CPU and, in case of a sync
+ * wakeup, compute the effect of the current task going to sleep.
+ *
+ * So for a change of @wl to the local @cpu with an overall group weight change
+ * of @wl we can compute the new shares distribution (s'_i) using:
+ *
+ *   s'_i = (rw_i + @wl) / (@wg + \Sum rw_j)				(2)
+ *
+ * Suppose we're interested in CPUs 0 and 1, and want to compute the load
+ * differences in waking a task to CPU 0. The additional task changes the
+ * weight and shares distributions like:
+ *
+ *   rw'_i = {   3,   4,   1,   0 }
+ *   s'_i  = { 3/8, 4/8, 1/8,   0 }
+ *
+ * We can then compute the difference in effective weight by using:
+ *
+ *   dw_i = S * (s'_i - s_i)						(3)
+ *
+ * Where 'S' is the group weight as seen by its parent.
+ *
+ * Therefore the effective change in loads on CPU 0 would be 5/56 (3/8 - 2/7)
+ * times the weight of the group. The effect on CPU 1 would be -4/56 (4/8 -
+ * 4/7) times the weight of the group.
  */
 static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 {
 	struct sched_entity *se = tg->se[cpu];
 
-	if (!tg->parent)
+	if (!tg->parent)	/* the trivial, non-cgroup case */
 		return wl;
 
 	for_each_sched_entity(se) {
-		long lw, w;
+		long w, W;
 
 		tg = se->my_q->tg;
-		w = se->my_q->load.weight;
 
-		/* use this cpu's instantaneous contribution */
-		lw = atomic_read(&tg->load_weight);
-		lw -= se->my_q->load_contribution;
-		lw += w + wg;
+		/*
+		 * W = @wg + \Sum rw_j
+		 */
+		W = wg + calc_tg_weight(tg, se->my_q);
 
-		wl += w;
+		/*
+		 * w = rw_i + @wl
+		 */
+		w = se->my_q->load.weight + wl;
 
-		if (lw > 0 && wl < lw)
-			wl = (wl * tg->shares) / lw;
+		/*
+		 * wl = S * s'_i; see (2)
+		 */
+		if (W > 0 && w < W)
+			wl = (w * tg->shares) / W;
 		else
 			wl = tg->shares;
 
-		/* zero point is MIN_SHARES */
+		/*
+		 * Per the above, wl is the new se->load.weight value; since
+		 * those are clipped to [MIN_SHARES, ...) do so now. See
+		 * calc_cfs_shares().
+		 */
 		if (wl < MIN_SHARES)
 			wl = MIN_SHARES;
+
+		/*
+		 * wl = dw_i = S * (s'_i - s_i); see (3)
+		 */
 		wl -= se->load.weight;
+
+		/*
+		 * Recursively apply this logic to all parent groups to compute
+		 * the final effective load change on the root group. Since
+		 * only the @tg group gets extra weight, all parent groups can
+		 * only redistribute existing shares. @wl is the shift in shares
+		 * resulting from this level per the above.
+		 */
 		wg = 0;
 	}
 

