Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934644Ab2JXJqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:46:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54870 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934576Ab2JXJp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:45:59 -0400
Date: Wed, 24 Oct 2012 02:44:46 -0700
From: tip-bot for Ben Segall <bsegall@google.com>
Message-ID: <tip-18bf2805d9b30cb823d4919b42cd230f59c7ce1f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
In-Reply-To: <20120823141506.442637130@google.com>
References: <20120823141506.442637130@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Maintain per-rq runnable averages
Git-Commit-ID: 18bf2805d9b30cb823d4919b42cd230f59c7ce1f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 02:44:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18bf2805d9b30cb823d4919b42cd230f59c7ce1f
Gitweb:     http://git.kernel.org/tip/18bf2805d9b30cb823d4919b42cd230f59c7ce1f
Author:     Ben Segall <bsegall@google.com>
AuthorDate: Thu, 4 Oct 2012 12:51:20 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:27:20 +0200

sched: Maintain per-rq runnable averages

Since runqueues do not have a corresponding sched_entity we instead embed a
sched_avg structure directly.

Signed-off-by: Ben Segall <bsegall@google.com>
Reviewed-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120823141506.442637130@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
index 16d67f9..8c5468f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1087,8 +1087,14 @@ static inline void update_entity_load_avg(struct sched_entity *se)
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
 
@@ -4586,6 +4596,8 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
 		return;
 
+	update_rq_runnable_avg(this_rq, 1);
+
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
 	 */
@@ -5083,6 +5095,8 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 		cfs_rq = cfs_rq_of(se);
 		entity_tick(cfs_rq, se, queued);
 	}
+
+	update_rq_runnable_avg(rq, 1);
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7a7db09..14b5719 100644
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
