Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab0KLDe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 22:34:29 -0500
Received: from smtp-out.google.com ([74.125.121.35]:11402 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab0KLDcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 22:32:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
	b=qbbK1+SFSY6uuGnDe4RyWkiwjqV9joPTDPxM57sM098BDdZnD+woEGsln22ooH0Ci
	+kD0/mkBBFm+vHXyGGS4g==
Message-Id: <20101112032701.552656833@google.com>
References: <20101112032405.657789056@google.com>
User-Agent: quilt/0.46-1
Date: Thu, 11 Nov 2010 19:24:08 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>, Paul Turner <pjt@google.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Karl Rister <kmr@us.ibm.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
Subject: [tg_shares_up rewrite v3 03/11] sched: make tg_shares_up() walk on-demand
Content-Disposition: inline; filename=sched-tg-more-ondemand.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Make tg_shares_up() use the active cgroup list, this means we cannot
do a strict bottom-up walk of the hierarchy, but assuming its a very
wide tree with a small number of active groups it should be a win.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched.c      |   67 ----------------------------------------------------
 kernel/sched_fair.c |   58 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 67 deletions(-)

Index: kernel/sched.c
===================================================================
--- kernel/sched.c.orig
+++ kernel/sched.c
@@ -281,13 +281,6 @@ static DEFINE_SPINLOCK(task_group_lock);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
-#ifdef CONFIG_SMP
-static int root_task_group_empty(void)
-{
-	return list_empty(&root_task_group.children);
-}
-#endif
-
 # define INIT_TASK_GROUP_LOAD	NICE_0_LOAD
 
 /*
@@ -1531,48 +1524,6 @@ static unsigned long cpu_avg_load_per_ta
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
-static void update_cfs_load(struct cfs_rq *cfs_rq, int lb);
-static void update_cfs_shares(struct cfs_rq *cfs_rq);
-
-/*
- * update tg->load_weight by folding this cpu's load_avg
- */
-static int tg_shares_up(struct task_group *tg, void *data)
-{
-	long load_avg;
-	struct cfs_rq *cfs_rq;
-	unsigned long flags;
-	int cpu = (long)data;
-	struct rq *rq;
-
-	if (!tg->se[cpu])
-		return 0;
-
-	rq = cpu_rq(cpu);
-	cfs_rq = tg->cfs_rq[cpu];
-
-	raw_spin_lock_irqsave(&rq->lock, flags);
-
-	update_rq_clock(rq);
-	update_cfs_load(cfs_rq, 1);
-
-	load_avg = div64_u64(cfs_rq->load_avg, cfs_rq->load_period+1);
-	load_avg -= cfs_rq->load_contribution;
-
-	atomic_add(load_avg, &tg->load_weight);
-	cfs_rq->load_contribution += load_avg;
-
-	/*
-	 * We need to update shares after updating tg->load_weight in
-	 * order to adjust the weight of groups with long running tasks.
-	 */
-	update_cfs_shares(cfs_rq);
-
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-
-	return 0;
-}
-
 /*
  * Compute the cpu's hierarchical load factor for each task group.
  * This needs to be done in a top-down fashion because the load of a child
@@ -1596,29 +1547,11 @@ static int tg_load_down(struct task_grou
 	return 0;
 }
 
-static void update_shares(long cpu)
-{
-	if (root_task_group_empty())
-		return;
-
-	/*
-	 * XXX: replace with an on-demand list
-	 */
-
-	walk_tg_tree(tg_nop, tg_shares_up, (void *)cpu);
-}
-
 static void update_h_load(long cpu)
 {
 	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
 }
 
-#else
-
-static inline void update_shares(int cpu)
-{
-}
-
 #endif
 
 #ifdef CONFIG_PREEMPT
Index: kernel/sched_fair.c
===================================================================
--- kernel/sched_fair.c.orig
+++ kernel/sched_fair.c
@@ -2000,6 +2000,60 @@ out:
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+/*
+ * update tg->load_weight by folding this cpu's load_avg
+ */
+static int tg_shares_up(struct task_group *tg, int cpu)
+{
+	struct cfs_rq *cfs_rq;
+	unsigned long flags;
+	struct rq *rq;
+	long load_avg;
+
+	if (!tg->se[cpu])
+		return 0;
+
+	rq = cpu_rq(cpu);
+	cfs_rq = tg->cfs_rq[cpu];
+
+	raw_spin_lock_irqsave(&rq->lock, flags);
+
+	update_rq_clock(rq);
+	update_cfs_load(cfs_rq, 1);
+
+	load_avg = div64_u64(cfs_rq->load_avg, cfs_rq->load_period+1);
+	load_avg -= cfs_rq->load_contribution;
+	atomic_add(load_avg, &tg->load_weight);
+	cfs_rq->load_contribution += load_avg;
+
+	/*
+	 * We need to update shares after updating tg->load_weight in
+	 * order to adjust the weight of groups with long running tasks.
+	 */
+	update_cfs_shares(cfs_rq);
+
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
+
+	return 0;
+}
+
+static void update_shares(int cpu)
+{
+	struct cfs_rq *cfs_rq;
+	struct rq *rq = cpu_rq(cpu);
+
+	rcu_read_lock();
+	for_each_leaf_cfs_rq(rq, cfs_rq) {
+		struct task_group *tg = cfs_rq->tg;
+
+		do {
+			tg_shares_up(tg, cpu);
+			tg = tg->parent;
+		} while (tg);
+	}
+	rcu_read_unlock();
+}
+
 static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
@@ -2047,6 +2101,10 @@ load_balance_fair(struct rq *this_rq, in
 	return max_load_move - rem_load_move;
 }
 #else
+static inline void update_shares(int cpu)
+{
+}
+
 static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,

-- 

