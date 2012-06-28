Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab2F1C5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:57:23 -0400
Received: from mail-lb0-f202.google.com ([209.85.217.202]:41858 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758130Ab2F1C40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:56:26 -0400
Subject: [PATCH 02/16] sched: maintain per-rq runnable averages
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 27 Jun 2012 19:24:14 -0700
Message-ID: <20120628022414.30496.62298.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
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
index cd5ef23..5d4a7dd 100644
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
index 864a122..08bd3e0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1091,8 +1091,14 @@ static inline void update_entity_load_avg(struct sched_entity *se)
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
@@ -2344,8 +2350,10 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		update_cfs_shares(cfs_rq);
 	}
 
-	if (!se)
+	if (!se) {
+		update_rq_runnable_avg(rq, rq->nr_running);
 		inc_nr_running(rq);
+	}
 	hrtick_update(rq);
 }
 
@@ -2403,8 +2411,10 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		update_cfs_shares(cfs_rq);
 	}
 
-	if (!se)
+	if (!se) {
 		dec_nr_running(rq);
+		update_rq_runnable_avg(rq, 1);
+	}
 	hrtick_update(rq);
 }
 
@@ -4732,6 +4742,8 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
 		return;
 
+	update_rq_runnable_avg(this_rq, 1);
+
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
 	 */
@@ -5230,6 +5242,8 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 		cfs_rq = cfs_rq_of(se);
 		entity_tick(cfs_rq, se, queued);
 	}
+
+	update_rq_runnable_avg(rq, 1);
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4134d37..bfdb119 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -469,6 +469,8 @@ struct rq {
 #ifdef CONFIG_SMP
 	struct llist_head wake_list;
 #endif
+
+	struct sched_avg avg;
 };
 
 static inline struct list_head *offnode_tasks(struct rq *rq)


