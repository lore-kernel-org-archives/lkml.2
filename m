Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab1KRX2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:28:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53248 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab1KRX2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:28:41 -0500
Date: Fri, 18 Nov 2011 15:28:23 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-cf5f0acf3935c91379e709a71ecf68805d366659@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1318518057.27731.2.camel@twins>
References: <1318518057.27731.2.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add a comment to effective_load() since it's a pain
Git-Commit-ID: cf5f0acf3935c91379e709a71ecf68805d366659
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:28:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf5f0acf3935c91379e709a71ecf68805d366659
Gitweb:     http://git.kernel.org/tip/cf5f0acf3935c91379e709a71ecf68805d366659
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 13 Oct 2011 16:52:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Nov 2011 12:50:32 +0100

sched: Add a comment to effective_load() since it's a pain

Every time I have to stare at this function I need to completely
reverse engineer its workings, about time I write a comment
explaining the thing.

Collected bits and pieces from previous changelogs, mostly:

  4be9daaa1b33701f011f4117f22dc1e45a3e6e34
  83378269a5fad98f562ebc0f09c349575e6cbfe1

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1318518057.27731.2.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |  113 ++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 95 insertions(+), 18 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5c9e679..aba20f4 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -772,19 +772,32 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
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
@@ -2036,36 +2049,100 @@ static void task_waking_fair(struct task_struct *p)
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
 
