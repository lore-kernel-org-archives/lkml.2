Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab3AILpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:45:40 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:13371 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757558Ab3AILpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:45:38 -0500
From: Glauber Costa <glommer@parallels.com>
To: <cgroups@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>, Glauber Costa <glommer@parallels.com>
Subject: [PATCH v5 08/11] sched: Push put_prev_task() into pick_next_task()
Date: Wed,  9 Jan 2013 15:45:35 +0400
Message-Id: <1357731938-8417-9-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357731938-8417-1-git-send-email-glommer@parallels.com>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

In order to avoid having to do put/set on a whole cgroup hierarchy
when we context switch, push the put into pick_next_task() so that
both operations are in the same function. Further changes then allow
us to possibly optimize away redundant work.

[ glommer@parallels.com: incorporated mailing list feedback ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 include/linux/sched.h    |  8 +++++++-
 kernel/sched/core.c      | 20 +++++++-------------
 kernel/sched/fair.c      |  6 +++++-
 kernel/sched/idle_task.c |  6 +++++-
 kernel/sched/rt.c        | 27 ++++++++++++++++-----------
 kernel/sched/stop_task.c |  5 ++++-
 6 files changed, 44 insertions(+), 28 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 206bb08..31d86e5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1082,7 +1082,13 @@ struct sched_class {
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
 
-	struct task_struct * (*pick_next_task) (struct rq *rq);
+	/*
+	 * It is the responsibility of the pick_next_task() method that will
+	 * return the next task to call put_prev_task() on the @prev task or
+	 * something equivalent.
+	 */
+	struct task_struct * (*pick_next_task) (struct rq *rq,
+						struct task_struct *prev);
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f8a9acf..c36df03 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2807,18 +2807,11 @@ static inline void schedule_debug(struct task_struct *prev)
 	schedstat_inc(this_rq(), sched_count);
 }
 
-static void put_prev_task(struct rq *rq, struct task_struct *prev)
-{
-	if (prev->on_rq || rq->skip_clock_update < 0)
-		update_rq_clock(rq);
-	prev->sched_class->put_prev_task(rq, prev);
-}
-
 /*
  * Pick up the highest-prio task:
  */
 static inline struct task_struct *
-pick_next_task(struct rq *rq)
+pick_next_task(struct rq *rq, struct task_struct *prev)
 {
 	const struct sched_class *class;
 	struct task_struct *p;
@@ -2828,13 +2821,13 @@ pick_next_task(struct rq *rq)
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
@@ -2929,8 +2922,9 @@ need_resched:
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
 
-	put_prev_task(rq, prev);
-	next = pick_next_task(rq);
+	if (prev->on_rq || rq->skip_clock_update < 0)
+		update_rq_clock(rq);
+	next = pick_next_task(rq, prev);
 	clear_tsk_need_resched(prev);
 	rq->skip_clock_update = 0;
 
@@ -4880,7 +4874,7 @@ static void migrate_tasks(unsigned int dead_cpu)
 		if (rq->nr_running == 1)
 			break;
 
-		next = pick_next_task(rq);
+		next = pick_next_task(rq, NULL);
 		BUG_ON(!next);
 		next->sched_class->put_prev_task(rq, next);
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c15bc92..d59a106 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3595,7 +3595,8 @@ preempt:
 		set_last_buddy(se);
 }
 
-static struct task_struct *pick_next_task_fair(struct rq *rq)
+static struct task_struct *
+pick_next_task_fair(struct rq *rq, struct task_struct *prev)
 {
 	struct task_struct *p;
 	struct cfs_rq *cfs_rq = &rq->cfs;
@@ -3604,6 +3605,9 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 	if (!cfs_rq->nr_running)
 		return NULL;
 
+	if (prev)
+		prev->sched_class->put_prev_task(rq, prev);
+
 	do {
 		se = pick_next_entity(cfs_rq);
 		set_next_entity(cfs_rq, se);
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index b6baf37..07e6027 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -22,8 +22,12 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
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
 	return rq->idle;
 }
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 7f6f6c6..80c58fe 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1368,15 +1368,7 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
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
@@ -1390,9 +1382,22 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
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
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index fda1cbe..5f10918 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -23,12 +23,15 @@ check_preempt_curr_stop(struct rq *rq, struct task_struct *p, int flags)
 	/* we're never preempted */
 }
 
-static struct task_struct *pick_next_task_stop(struct rq *rq)
+static struct task_struct *
+pick_next_task_stop(struct rq *rq, struct task_struct *prev)
 {
 	struct task_struct *stop = rq->stop;
 
 	if (stop && stop->on_rq) {
 		stop->se.exec_start = rq->clock_task;
+		if (prev)
+			prev->sched_class->put_prev_task(rq, prev);
 		return stop;
 	}
 
-- 
1.7.11.7

