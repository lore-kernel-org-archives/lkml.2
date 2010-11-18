Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab0KROL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:11:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:52043 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758349Ab0KROL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:11:26 -0500
Date: Thu, 18 Nov 2010 14:10:55 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20101115234937.754159484@google.com>
References: <20101115234937.754159484@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Make tg_shares_up() walk on-demand
Message-ID: <tip-9e3081ca61147b29f52fddb4f7c6b6b82ea5eb7a@git.kernel.org>
Git-Commit-ID: 9e3081ca61147b29f52fddb4f7c6b6b82ea5eb7a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:10:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e3081ca61147b29f52fddb4f7c6b6b82ea5eb7a
Gitweb:     http://git.kernel.org/tip/9e3081ca61147b29f52fddb4f7c6b6b82ea5eb7a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 15 Nov 2010 15:47:02 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 13:27:47 +0100

sched: Make tg_shares_up() walk on-demand

Make tg_shares_up() use the active cgroup list, this means we cannot
do a strict bottom-up walk of the hierarchy, but assuming its a very
wide tree with a small number of active groups it should be a win.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101115234937.754159484@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |   67 ---------------------------------------------------
 kernel/sched_fair.c |   58 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 67 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 22436dd..6268d2d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -279,13 +279,6 @@ static DEFINE_SPINLOCK(task_group_lock);
 
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
@@ -1546,48 +1539,6 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 
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
@@ -1611,29 +1562,11 @@ static int tg_load_down(struct task_group *tg, void *data)
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
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0560e72..46ff658 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2004,6 +2004,60 @@ out:
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
@@ -2051,6 +2105,10 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
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
