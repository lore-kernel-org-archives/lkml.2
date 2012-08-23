Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030461Ab2HWOQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:16:55 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:59152 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757668Ab2HWOPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:15:31 -0400
Message-Id: <20120823141507.133999170@google.com>
User-Agent: quilt/0.48-1
Date: Thu, 23 Aug 2012 07:14:34 -0700
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
Subject: [patch 12/16] sched: refactor update_shares_cpu() -> update_blocked_avgs()
References: <20120823141422.444396696@google.com>
Content-Disposition: inline; filename=sched-improve_update_shares.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Turner <pjt@google.com>

Now that running entities maintain their own load-averages the work we must do
in update_shares() is largely restricted to the periodic decay of blocked
entities.  This allows us to be a little less pessimistic regarding our
occupancy on rq->lock and the associated rq->clock updates required.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Ben Segall <bsegall@google.com>
---
 kernel/sched/fair.c |   50 +++++++++++++++++++++++---------------------------
 1 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3af150f..44cd4be 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3619,20 +3619,15 @@ next:
 /*
  * update tg->load_weight by folding this cpu's load_avg
  */
-static int update_shares_cpu(struct task_group *tg, int cpu)
+static void __update_blocked_averages_cpu(struct task_group *tg, int cpu)
 {
-	struct sched_entity *se;
-	struct cfs_rq *cfs_rq;
-	unsigned long flags;
-	struct rq *rq;
-
-	rq = cpu_rq(cpu);
-	se = tg->se[cpu];
-	cfs_rq = tg->cfs_rq[cpu];
+	struct sched_entity *se = tg->se[cpu];
+	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu];
 
-	raw_spin_lock_irqsave(&rq->lock, flags);
+	/* throttled entities do not contribute to load */
+	if (throttled_hierarchy(cfs_rq))
+		return;
 
-	update_rq_clock(rq);
 	update_cfs_rq_blocked_load(cfs_rq, 1);
 
 	if (se) {
@@ -3647,32 +3642,33 @@ static int update_shares_cpu(struct task_group *tg, int cpu)
 		else
 			list_del_leaf_cfs_rq(cfs_rq);
 	} else {
+		struct rq *rq = rq_of(cfs_rq);
 		update_rq_runnable_avg(rq, rq->nr_running);
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
+	unsigned long flags;
 
-	rcu_read_lock();
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
-
-		update_shares_cpu(cfs_rq->tg, cpu);
+		/*
+		 * Note: We may want to consider periodically releasing
+		 * rq->lock about these updates so that creating many task
+		 * groups does not result in continually extending hold time.
+		 */
+		__update_blocked_averages_cpu(cfs_rq->tg, rq->cpu);
 	}
-	rcu_read_unlock();
+
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
 /*
@@ -3724,7 +3720,7 @@ static unsigned long task_h_load(struct task_struct *p)
 	return load;
 }
 #else
-static inline void update_shares(int cpu)
+static inline void update_blocked_averages(int cpu)
 {
 }
 
@@ -4793,7 +4789,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	 */
 	raw_spin_unlock(&this_rq->lock);
 
-	update_shares(this_cpu);
+	update_blocked_averages(this_cpu);
 	rcu_read_lock();
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
@@ -5053,7 +5049,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 	int update_next_balance = 0;
 	int need_serialize;
 
-	update_shares(cpu);
+	update_blocked_averages(cpu);
 
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {


