Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab2JXJzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:55:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55024 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab2JXJzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:55:53 -0400
Date: Wed, 24 Oct 2012 02:54:40 -0700
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-48a1675323fa1b7844e479ad2a4469f4558c0f79@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
In-Reply-To: <20120823141507.133999170@google.com>
References: <20120823141507.133999170@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Refactor update_shares_cpu() ->
  update_blocked_avgs()
Git-Commit-ID: 48a1675323fa1b7844e479ad2a4469f4558c0f79
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 02:54:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48a1675323fa1b7844e479ad2a4469f4558c0f79
Gitweb:     http://git.kernel.org/tip/48a1675323fa1b7844e479ad2a4469f4558c0f79
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 4 Oct 2012 13:18:31 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:27:28 +0200

sched: Refactor update_shares_cpu() -> update_blocked_avgs()

Now that running entities maintain their own load-averages the work we must do
in update_shares() is largely restricted to the periodic decay of blocked
entities.  This allows us to be a little less pessimistic regarding our
occupancy on rq->lock and the associated rq->clock updates required.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Ben Segall <bsegall@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120823141507.133999170@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |   50 +++++++++++++++++++++++---------------------------
 1 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 57fae95..dcc27d8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3639,20 +3639,15 @@ next:
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
@@ -3669,32 +3664,33 @@ static int update_shares_cpu(struct task_group *tg, int cpu)
 		if (!se->avg.runnable_avg_sum && !cfs_rq->nr_running)
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
@@ -3746,7 +3742,7 @@ static unsigned long task_h_load(struct task_struct *p)
 	return load;
 }
 #else
-static inline void update_shares(int cpu)
+static inline void update_blocked_averages(int cpu)
 {
 }
 
@@ -4813,7 +4809,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	 */
 	raw_spin_unlock(&this_rq->lock);
 
-	update_shares(this_cpu);
+	update_blocked_averages(this_cpu);
 	rcu_read_lock();
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
@@ -5068,7 +5064,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 	int update_next_balance = 0;
 	int need_serialize;
 
-	update_shares(cpu);
+	update_blocked_averages(cpu);
 
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
