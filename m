Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab2BBBpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:45:33 -0500
Received: from mail-yw0-f74.google.com ([209.85.213.74]:54106 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab2BBBnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:43:22 -0500
Subject: [RFC PATCH 11/14] sched: refactor update_shares_cpu() ->
	update_blocked_avgs()
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 01 Feb 2012 17:38:27 -0800
Message-ID: <20120202013827.20844.69770.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that running entities maintain their own load-averages the work we must do
in update_shares() is largely restricted to the periodic decay of blocked
entities.  This allows us to be a little less pessimistic regarding our
occupancy on rq->lock and the associated rq->clock updates required.

We also no longer use the instantaneous load to calculate group-entity
load-weight.  This was previously required as a compromise since migrated load
would remain in the parenting average while it decayed, however it leads to
over-allocation of shares.

Signed-off-by: Paul Turner <pjt@google.com>
---
 kernel/sched/fair.c |   57 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 46b3f98..5b6ee7a4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -823,7 +823,7 @@ static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
 	 */
 	tg_weight = atomic64_read(&tg->load_avg);
 	tg_weight -= cfs_rq->tg_load_contrib;
-	tg_weight += cfs_rq->load.weight;
+	tg_weight += cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
 
 	return tg_weight;
 }
@@ -833,7 +833,7 @@ static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
 	long tg_weight, load, shares;
 
 	tg_weight = calc_tg_weight(tg, cfs_rq);
-	load = cfs_rq->load.weight;
+	load = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
 
 	shares = (tg->shares * load);
 	if (tg_weight)
@@ -3559,21 +3559,16 @@ out:
 /*
  * update tg->load_weight by folding this cpu's load_avg
  */
-static int update_shares_cpu(struct task_group *tg, int cpu)
+static void __update_blocked_averages_cpu(struct task_group *tg, int cpu)
 {
-	struct sched_entity *se;
-	struct cfs_rq *cfs_rq;
-	unsigned long flags;
+	struct sched_entity *se = tg->se[cpu];
+	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu];
 	struct rq *rq;
 
+	/* throttled entities do not contribute to load */
+	if (throttled_hierarchy(cfs_rq))
+		return;
 
-	rq = cpu_rq(cpu);
-	se = tg->se[cpu];
-	cfs_rq = tg->cfs_rq[cpu];
-
-	raw_spin_lock_irqsave(&rq->lock, flags);
-
-	update_rq_clock(rq);
 	update_cfs_rq_blocked_load(cfs_rq, 1);
 
 	if (se) {
@@ -3586,29 +3581,39 @@ static int update_shares_cpu(struct task_group *tg, int cpu)
 		else
 			list_del_leaf_cfs_rq(cfs_rq);
 	}
-
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-
-	return 0;
 }
 
-static void update_shares(int cpu)
+static void update_blocked_averages(int cpu)
 {
-	struct cfs_rq *cfs_rq;
 	struct rq *rq = cpu_rq(cpu);
+	struct cfs_rq *cfs_rq;
+
+	unsigned long flags;
+	int num_updates = 0;
 
 	rcu_read_lock();
+	raw_spin_lock_irqsave(&rq->lock, flags);
+	update_rq_clock(rq);
 	/*
 	 * Iterates the task_group tree in a bottom up fashion, see
 	 * list_add_leaf_cfs_rq() for details.
 	 */
 	for_each_leaf_cfs_rq(rq, cfs_rq) {
-		/* throttled entities do not contribute to load */
-		if (throttled_hierarchy(cfs_rq))
-			continue;
+		__update_blocked_averages_cpu(cfs_rq->tg, rq->cpu);
 
-		update_shares_cpu(cfs_rq->tg, cpu);
+		/*
+		 * Periodically release the lock so that a cfs_rq with many
+		 * children cannot hold it for an arbitrary period of time.
+		 */
+		if (num_updates++ % 20 == 0) {
+			raw_spin_unlock_irqrestore(&rq->lock, flags);
+			cpu_relax();
+			raw_spin_lock_irqsave(&rq->lock, flags);
+			update_rq_clock(rq);
+		}
 	}
+
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
 	rcu_read_unlock();
 }
 
@@ -3689,7 +3694,7 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	return max_load_move - rem_load_move;
 }
 #else
-static inline void update_shares(int cpu)
+static inline void update_blocked_averages(int cpu)
 {
 }
 
@@ -4917,7 +4922,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	 */
 	raw_spin_unlock(&this_rq->lock);
 
-	update_shares(this_cpu);
+	update_blocked_averages(this_cpu);
 	rcu_read_lock();
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
@@ -5258,7 +5263,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 	int update_next_balance = 0;
 	int need_serialize;
 
-	update_shares(cpu);
+	update_blocked_averages(cpu);
 
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {


