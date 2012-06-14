Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab2FNNdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:33:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:53292 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab2FNNdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:33:17 -0400
Message-Id: <20120614133212.690691207@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jun 2012 15:29:04 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, pjt@google.com, venki@google.com, efault@gmx.de,
        rostedt@goodmis.org, glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 2/4] sched: Push put_prev_task() into pick_next_task()
References: <20120614132902.800827488@chello.nl>
Content-Disposition: inline; filename=peter_zijlstra-sched-optimize_cgroup_pick_next_task_fair_2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to avoid having to do put/set on a whole cgroup hierarchy
when we context switch, push the put into pick_next_task() so that
both operations are in the same function. Further changes then allow
us to possibly optimize away redundant work.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h    |    3 ++-
 kernel/sched/core.c      |   13 +++++++------
 kernel/sched/fair.c      |    6 +++++-
 kernel/sched/idle_task.c |    6 +++++-
 kernel/sched/rt.c        |   27 ++++++++++++++++-----------
 kernel/sched/stop_task.c |    9 +++++++--
 6 files changed, 42 insertions(+), 22 deletions(-)
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1093,7 +1093,8 @@ struct sched_class {
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
 
-	struct task_struct * (*pick_next_task) (struct rq *rq);
+	struct task_struct * (*pick_next_task) (struct rq *rq,
+						struct task_struct *prev);
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3176,7 +3176,7 @@ static void put_prev_task(struct rq *rq,
  * Pick up the highest-prio task:
  */
 static inline struct task_struct *
-pick_next_task(struct rq *rq)
+pick_next_task(struct rq *rq, struct task_struct *prev)
 {
 	const struct sched_class *class;
 	struct task_struct *p;
@@ -3186,13 +3186,13 @@ pick_next_task(struct rq *rq)
 	 * the fair class we can call that function directly:
 	 */
 	if (likely(rq->nr_running == rq->cfs.h_nr_running)) {
-		p = fair_sched_class.pick_next_task(rq);
+		p = fair_sched_class.pick_next_task(rq, prev);
 		if (likely(p))
 			return p;
 	}
 
 	for_each_class(class) {
-		p = class->pick_next_task(rq);
+		p = class->pick_next_task(rq, prev);
 		if (p)
 			return p;
 	}
@@ -3253,8 +3253,9 @@ static void __sched __schedule(void)
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
 
-	put_prev_task(rq, prev);
-	next = pick_next_task(rq);
+	if (prev->on_rq || rq->skip_clock_update < 0)
+		update_rq_clock(rq);
+	next = pick_next_task(rq, prev);
 	clear_tsk_need_resched(prev);
 	rq->skip_clock_update = 0;
 
@@ -5200,7 +5201,7 @@ static void migrate_tasks(unsigned int d
 		if (rq->nr_running == 1)
 			break;
 
-		next = pick_next_task(rq);
+		next = pick_next_task(rq, NULL);
 		BUG_ON(!next);
 		next->sched_class->put_prev_task(rq, next);
 
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2990,7 +2990,8 @@ static void check_preempt_wakeup(struct 
 		set_last_buddy(se);
 }
 
-static struct task_struct *pick_next_task_fair(struct rq *rq)
+static struct task_struct *
+pick_next_task_fair(struct rq *rq, struct task_struct *prev)
 {
 	struct task_struct *p;
 	struct cfs_rq *cfs_rq = &rq->cfs;
@@ -2999,6 +3000,9 @@ static struct task_struct *pick_next_tas
 	if (!cfs_rq->nr_running)
 		return NULL;
 
+	if (prev)
+		prev->sched_class->put_prev_task(rq, prev);
+
 	do {
 		se = pick_next_entity(cfs_rq);
 		set_next_entity(cfs_rq, se);
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -22,8 +22,12 @@ static void check_preempt_curr_idle(stru
 	resched_task(rq->idle);
 }
 
-static struct task_struct *pick_next_task_idle(struct rq *rq)
+static struct task_struct *
+pick_next_task_idle(struct rq *rq, struct task_struct *prev)
 {
+	if (prev)
+		prev->sched_class->put_prev_task(rq, prev);
+
 	schedstat_inc(rq, sched_goidle);
 	calc_load_account_idle(rq);
 	return rq->idle;
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1346,15 +1346,7 @@ static struct task_struct *_pick_next_ta
 {
 	struct sched_rt_entity *rt_se;
 	struct task_struct *p;
-	struct rt_rq *rt_rq;
-
-	rt_rq = &rq->rt;
-
-	if (!rt_rq->rt_nr_running)
-		return NULL;
-
-	if (rt_rq_throttled(rt_rq))
-		return NULL;
+	struct rt_rq *rt_rq  = &rq->rt;
 
 	do {
 		rt_se = pick_next_rt_entity(rq, rt_rq);
@@ -1368,9 +1360,22 @@ static struct task_struct *_pick_next_ta
 	return p;
 }
 
-static struct task_struct *pick_next_task_rt(struct rq *rq)
+static struct task_struct *
+pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 {
-	struct task_struct *p = _pick_next_task_rt(rq);
+	struct task_struct *p;
+	struct rt_rq *rt_rq = &rq->rt;
+
+	if (!rt_rq->rt_nr_running)
+		return NULL;
+
+	if (rt_rq_throttled(rt_rq))
+		return NULL;
+
+	if (prev)
+		prev->sched_class->put_prev_task(rq, prev);
+
+	p = _pick_next_task_rt(rq);
 
 	/* The running task is never eligible for pushing */
 	if (p)
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -23,12 +23,17 @@ check_preempt_curr_stop(struct rq *rq, s
 	/* we're never preempted */
 }
 
-static struct task_struct *pick_next_task_stop(struct rq *rq)
+static struct task_struct *
+pick_next_task_stop(struct rq *rq, struct task_struct *prev)
 {
 	struct task_struct *stop = rq->stop;
 
-	if (stop && stop->on_rq)
+	if (stop && stop->on_rq) {
+		if (prev)
+			prev->sched_class->put_prev_task(rq, prev);
+
 		return stop;
+	}
 
 	return NULL;
 }


