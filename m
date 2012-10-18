Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab2JRRD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:03:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46730 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab2JRRD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:03:57 -0400
Date: Thu, 18 Oct 2012 10:03:43 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-2sz5f6n058jxkvuwmupjpv7x@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] sched/numa: More NUMA_PULL_BIAS fixes
Git-Commit-ID: bb527e7df7bd5f05dca74868f61b7a9a17ee54c1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 18 Oct 2012 10:03:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bb527e7df7bd5f05dca74868f61b7a9a17ee54c1
Gitweb:     http://git.kernel.org/tip/bb527e7df7bd5f05dca74868f61b7a9a17ee54c1
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 11 Oct 2012 13:06:22 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 15 Oct 2012 13:56:49 +0200

sched/numa: More NUMA_PULL_BIAS fixes

Consider the simple case where 2 runnable tasks, each with a preferred
node (not the same), each running on the wrong node. Weight wise, this
is a well balanced situation and thus the load-balancer will not find
anything to do and is content.

NUMA_PULL_BIAS is the 'force' introduced to break this situation and
promote task movement despite the weight balance so that we might find
the situation where each task runs on its preferred node.

It was (again) observed that this force was too strong and created
undue task movement. In particular, suppose the two runnable tasks
each having the same preferred node, the weight balance will then move
one of them to the other node. This results in one task running on the
right node and one on the wrong node.

NUMA_PULL_BIAS would in this case try and move the off-node task back
to its home-node in order to promote better node-preference. This is
clearly sub-optimal since either we end up moving that same task back,
or worse, we'll move the other task to the now empty node.

This results in endless undue task movement.

Solve this by limiting the NUMA_PULL_BIAS to only allow moving an
offnode task to its home-node when the home-node has either another
offnode task or an non-numa task to trade back for it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-2sz5f6n058jxkvuwmupjpv7x@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  |    1 +
 kernel/sched/fair.c  |   70 +++++++++++++++++++++++++++++++++----------------
 kernel/sched/sched.h |   11 +-------
 3 files changed, 49 insertions(+), 33 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c386297..23ad8b9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6930,6 +6930,7 @@ void __init sched_init(void)
 		INIT_LIST_HEAD(&rq->cfs_tasks);
 #ifdef CONFIG_SCHED_NUMA
 		INIT_LIST_HEAD(&rq->offnode_tasks);
+		rq->onnode_running = 0;
 		rq->offnode_running = 0;
 		rq->offnode_weight = 0;
 #endif
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ab2f11b..7d522d0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -797,17 +797,28 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static unsigned long task_h_load(struct task_struct *p);
 
 #ifdef CONFIG_SCHED_NUMA
-static void account_offnode_enqueue(struct rq *rq, struct task_struct *p)
+static struct list_head *account_numa_enqueue(struct rq *rq, struct task_struct *p)
 {
-	p->numa_contrib = task_h_load(p);
-	rq->offnode_weight += p->numa_contrib;
-	rq->offnode_running++;
+	struct list_head *tasks = &rq->cfs_tasks;
+
+	if (tsk_home_node(p) != cpu_to_node(task_cpu(p))) {
+		p->numa_contrib = task_h_load(p);
+		rq->offnode_weight += p->numa_contrib;
+		rq->offnode_running++;
+		tasks = &rq->offnode_tasks;
+	} else
+		rq->onnode_running++;
+
+	return tasks;
 }
 
-static void account_offnode_dequeue(struct rq *rq, struct task_struct *p)
+static void account_numa_dequeue(struct rq *rq, struct task_struct *p)
 {
-	rq->offnode_weight -= p->numa_contrib;
-	rq->offnode_running--;
+	if (tsk_home_node(p) != cpu_to_node(task_cpu(p))) {
+		rq->offnode_weight -= p->numa_contrib;
+		rq->offnode_running--;
+	} else
+		rq->onnode_running--;
 }
 
 /*
@@ -956,11 +967,11 @@ void task_tick_numa(struct rq *rq, struct task_struct *curr)
 	}
 }
 #else
-static void account_offnode_enqueue(struct rq *rq, struct task_struct *p)
+static struct list_head *account_numa_enqueue(struct rq *rq, struct task_struct *p)
 {
 }
 
-static void account_offnode_dequeue(struct rq *rq, struct task_struct *p)
+static void account_numa_dequeue(struct rq *rq, struct task_struct *p)
 {
 }
 
@@ -985,10 +996,8 @@ account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		struct task_struct *p = task_of(se);
 		struct list_head *tasks = &rq->cfs_tasks;
 
-		if (offnode_task(p)) {
-			account_offnode_enqueue(rq, p);
-			tasks = offnode_tasks(rq);
-		}
+		if (tsk_home_node(p) != -1)
+			tasks = account_numa_enqueue(rq, p);
 
 		list_add(&se->group_node, tasks);
 	}
@@ -1007,8 +1016,8 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 		list_del_init(&se->group_node);
 
-		if (offnode_task(p))
-			account_offnode_dequeue(rq_of(cfs_rq), p);
+		if (tsk_home_node(p) != -1)
+			account_numa_dequeue(rq_of(cfs_rq), p);
 	}
 	cfs_rq->nr_running--;
 }
@@ -3762,6 +3771,9 @@ struct sd_lb_stats {
 	struct sched_group *numa_group; /* group which has offnode_tasks */
 	unsigned long numa_group_weight;
 	unsigned long numa_group_running;
+
+	unsigned long this_offnode_running;
+	unsigned long this_onnode_running;
 #endif
 };
 
@@ -3779,8 +3791,9 @@ struct sg_lb_stats {
 	int group_imb; /* Is there an imbalance in the group ? */
 	int group_has_capacity; /* Is there extra capacity in the group? */
 #ifdef CONFIG_SCHED_NUMA
-	unsigned long numa_weight;
-	unsigned long numa_running;
+	unsigned long numa_offnode_weight;
+	unsigned long numa_offnode_running;
+	unsigned long numa_onnode_running;
 #endif
 };
 
@@ -3813,8 +3826,9 @@ static inline int get_sd_load_idx(struct sched_domain *sd,
 #ifdef CONFIG_SCHED_NUMA
 static inline void update_sg_numa_stats(struct sg_lb_stats *sgs, struct rq *rq)
 {
-	sgs->numa_weight += rq->offnode_weight;
-	sgs->numa_running += rq->offnode_running;
+	sgs->numa_offnode_weight += rq->offnode_weight;
+	sgs->numa_offnode_running += rq->offnode_running;
+	sgs->numa_onnode_running += rq->onnode_running;
 }
 
 /*
@@ -3832,16 +3846,19 @@ static inline void update_sd_numa_stats(struct sched_domain *sd,
 	if (!(sd->flags & SD_NUMA))
 		return;
 
-	if (local_group)
+	if (local_group) {
+		sds->this_offnode_running = sgs->numa_offnode_running;
+		sds->this_onnode_running  = sgs->numa_onnode_running;
 		return;
+	}
 
-	if (!sgs->numa_running)
+	if (!sgs->numa_offnode_running)
 		return;
 
 	if (!sds->numa_group || pick_numa_rand(sd->span_weight / group->group_weight)) {
 		sds->numa_group = group;
-		sds->numa_group_weight = sgs->numa_weight;
-		sds->numa_group_running = sgs->numa_running;
+		sds->numa_group_weight = sgs->numa_offnode_weight;
+		sds->numa_group_running = sgs->numa_offnode_running;
 	}
 }
 
@@ -3878,6 +3895,13 @@ static inline int check_numa_busiest_group(struct lb_env *env, struct sd_lb_stat
 	if (!sds->numa_group)
 		return 0;
 
+	/*
+	 * Only pull an offnode task home if we've got offnode or !numa tasks to trade for it.
+	 */
+	if (!sds->this_offnode_running &&
+	    !(sds->this_nr_running - sds->this_onnode_running - sds->this_offnode_running))
+		return 0;
+
 	env->imbalance = sds->numa_group_weight / sds->numa_group_running;
 	sds->busiest = sds->numa_group;
 	env->find_busiest_queue = find_busiest_numa_queue;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 3060136..e68cef1 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -420,6 +420,7 @@ struct rq {
 	struct list_head cfs_tasks;
 
 #ifdef CONFIG_SCHED_NUMA
+	unsigned long    onnode_running;
 	unsigned long    offnode_running;
 	unsigned long	 offnode_weight;
 	struct list_head offnode_tasks;
@@ -494,11 +495,6 @@ DECLARE_PER_CPU(struct rq, runqueues);
 #define raw_rq()		(&__raw_get_cpu_var(runqueues))
 
 #ifdef CONFIG_SCHED_NUMA
-static inline bool offnode_task(struct task_struct *t)
-{
-	return t->node != -1 && t->node != cpu_to_node(task_cpu(t));
-}
-
 static inline struct list_head *offnode_tasks(struct rq *rq)
 {
 	return &rq->offnode_tasks;
@@ -509,11 +505,6 @@ static inline void task_numa_free(struct task_struct *p)
 	kfree(p->numa_faults);
 }
 #else /* CONFIG_SCHED_NUMA */
-static inline bool offnode_task(struct task_struct *t)
-{
-	return false;
-}
-
 static inline struct list_head *offnode_tasks(struct rq *rq)
 {
 	return NULL;
