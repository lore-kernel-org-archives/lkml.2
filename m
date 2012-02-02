Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab2BBBp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:45:27 -0500
Received: from mail-ey0-f202.google.com ([209.85.215.202]:65479 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab2BBBnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:43:23 -0500
Subject: [RFC PATCH 02/14] sched: maintain per-rq runnable averages
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 01 Feb 2012 17:38:26 -0800
Message-ID: <20120202013826.20844.63141.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Segall <bsegall@google.com>

Since runqueues do not have a corresponding sched_entity we instead embed a
sched_avg structure directly.

Signed-off-by: Ben Segall <bsegall@google.com>
Signed-off-by: Paul Turner <pjt@google.com>
---
 kernel/sched/debug.c |   10 ++++++++--
 kernel/sched/fair.c  |   18 ++++++++++++++++--
 kernel/sched/sched.h |    2 ++
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index d89db32..43e3162 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -61,14 +61,20 @@ static unsigned long nsec_low(unsigned long long nsec)
 static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group *tg)
 {
 	struct sched_entity *se = tg->se[cpu];
-	if (!se)
-		return;
 
 #define P(F) \
 	SEQ_printf(m, "  .%-30s: %lld\n", #F, (long long)F)
 #define PN(F) \
 	SEQ_printf(m, "  .%-30s: %lld.%06ld\n", #F, SPLIT_NS((long long)F))
 
+	if (!se) {
+		struct sched_avg *avg = &cpu_rq(cpu)->avg;
+		P(avg->runnable_avg_sum);
+		P(avg->runnable_avg_period);
+		return;
+	}
+
+
 	PN(se->exec_start);
 	PN(se->vruntime);
 	PN(se->sum_exec_runtime);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a570e9c..8fa199f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1086,8 +1086,14 @@ static inline void update_entity_load_avg(struct sched_entity *se)
 	__update_entity_runnable_avg(rq_of(cfs_rq_of(se))->clock_task, &se->avg,
 				     se->on_rq);
 }
+
+static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
+{
+	__update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable);
+}
 #else
 static inline void update_entity_load_avg(struct sched_entity *se) {}
+static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
 #endif
 
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -2340,8 +2346,10 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		update_cfs_shares(cfs_rq);
 	}
 
-	if (!se)
+	if (!se) {
+		update_rq_runnable_avg(rq, rq->nr_running);
 		inc_nr_running(rq);
+	}
 	hrtick_update(rq);
 }
 
@@ -2399,8 +2407,10 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		update_cfs_shares(cfs_rq);
 	}
 
-	if (!se)
+	if (!se) {
 		dec_nr_running(rq);
+		update_rq_runnable_avg(rq, 1);
+	}
 	hrtick_update(rq);
 }
 
@@ -4749,6 +4759,8 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
 		return;
 
+	update_rq_runnable_avg(this_rq, 1);
+
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
 	 */
@@ -5328,6 +5340,8 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 		cfs_rq = cfs_rq_of(se);
 		entity_tick(cfs_rq, se, queued);
 	}
+
+	update_rq_runnable_avg(rq, 1);
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 8a2c768..42b6df6 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -473,6 +473,8 @@ struct rq {
 #ifdef CONFIG_SMP
 	struct llist_head wake_list;
 #endif
+
+	struct sched_avg avg;
 };
 
 static inline int cpu_of(struct rq *rq)


