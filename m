Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860Ab2HWOQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:16:20 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40215 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757716Ab2HWOPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:15:32 -0400
Message-Id: <20120823141506.442637130@google.com>
User-Agent: quilt/0.48-1
Date: Thu, 23 Aug 2012 07:14:24 -0700
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
Subject: [patch 02/16] sched: maintain per-rq runnable averages
References: <20120823141422.444396696@google.com>
Content-Disposition: inline; filename=sched-root_avg.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Segall <bsegall@google.com>

Since runqueues do not have a corresponding sched_entity we instead embed a
sched_avg structure directly.

Signed-off-by: Ben Segall <bsegall@google.com>
Reviewed-by: Paul Turner <pjt@google.com>
---
 kernel/sched/debug.c |   10 ++++++++--
 kernel/sched/fair.c  |   18 ++++++++++++++++--
 kernel/sched/sched.h |    2 ++
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 61f7097..4240abc 100644
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
index 2c53263..6eb2ce2 100644
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
@@ -2339,8 +2345,10 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		update_cfs_shares(cfs_rq);
 	}
 
-	if (!se)
+	if (!se) {
+		update_rq_runnable_avg(rq, rq->nr_running);
 		inc_nr_running(rq);
+	}
 	hrtick_update(rq);
 }
 
@@ -2398,8 +2406,10 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		update_cfs_shares(cfs_rq);
 	}
 
-	if (!se)
+	if (!se) {
 		dec_nr_running(rq);
+		update_rq_runnable_avg(rq, 1);
+	}
 	hrtick_update(rq);
 }
 
@@ -4573,6 +4583,8 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
 		return;
 
+	update_rq_runnable_avg(this_rq, 1);
+
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
 	 */
@@ -5071,6 +5083,8 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 		cfs_rq = cfs_rq_of(se);
 		entity_tick(cfs_rq, se, queued);
 	}
+
+	update_rq_runnable_avg(rq, 1);
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 804c2e5..eb61c75 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -467,6 +467,8 @@ struct rq {
 #ifdef CONFIG_SMP
 	struct llist_head wake_list;
 #endif
+
+	struct sched_avg avg;
 };
 
 static inline int cpu_of(struct rq *rq)


