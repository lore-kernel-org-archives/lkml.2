Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab1CHBAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 20:00:36 -0500
Received: from smtp-out.google.com ([74.125.121.67]:28415 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab1CHBAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 20:00:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XXEu/xd85PZmr30cwios/cBXIrORnUSe5VsHzoG5lH6n77CtO9JVeLP6PnOmdHcXt+
         XnEEoeJhwFzDFiLeWMag==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Rik van Riel <riel@redhat.com>, Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] sched: next buddy hint on sleep and preempt path - v1
Date: Mon,  7 Mar 2011 16:59:57 -0800
Message-Id: <1299545997-26304-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <AANLkTi=hy8mHp=RLkKbfc2nw0VGX65ZCmk89r3U-rb4-@mail.gmail.com>
References: <AANLkTi=hy8mHp=RLkKbfc2nw0VGX65ZCmk89r3U-rb4-@mail.gmail.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a task in a taskgroup sleeps, pick_next_task starts all the way back at
the root and picks the task/taskgroup with the min vruntime across all
runnable tasks. But, when there are many frequently sleeping tasks
across different taskgroups, it makes better sense to stay with same taskgroup
for its slice period (or until all tasks in the taskgroup sleeps) instead of
switching cross taskgroup on each sleep after a short runtime.
This helps specifically where taskgroups corresponds to a process with
multiple threads. The change reduces the number of CR3 switches in this case.

Example:
Two taskgroups with 2 threads each which are running for 2ms and
sleeping for 1ms. Looking at sched:sched_switch shows -

BEFORE: taskgroup_1 threads [5004, 5005], taskgroup_2 threads [5016, 5017]
      cpu-soaker-5004  [003]  3683.391089
      cpu-soaker-5016  [003]  3683.393106
      cpu-soaker-5005  [003]  3683.395119
      cpu-soaker-5017  [003]  3683.397130
      cpu-soaker-5004  [003]  3683.399143
      cpu-soaker-5016  [003]  3683.401155
      cpu-soaker-5005  [003]  3683.403168
      cpu-soaker-5017  [003]  3683.405170

AFTER: taskgroup_1 threads [21890, 21891], taskgroup_2 threads [21934, 21935]
      cpu-soaker-21890 [003]   865.895494
      cpu-soaker-21935 [003]   865.897506
      cpu-soaker-21934 [003]   865.899520
      cpu-soaker-21935 [003]   865.901532
      cpu-soaker-21934 [003]   865.903543
      cpu-soaker-21935 [003]   865.905546
      cpu-soaker-21891 [003]   865.907548
      cpu-soaker-21890 [003]   865.909560
      cpu-soaker-21891 [003]   865.911571
      cpu-soaker-21890 [003]   865.913582
      cpu-soaker-21891 [003]   865.915594
      cpu-soaker-21934 [003]   865.917606

Similar problem is there when there are multiple taskgroups and say a task A
preempts currently running task B of taskgroup_1. On schedule, pick_next_task
can pick an unrelated task on taskgroup_2. Here it would be better to give some
preference to task B on pick_next_task.

A simple (may be extreme case) benchmark I tried was tbench with 2 tbench
client processes with 2 threads each running on a single CPU. Avg throughput
across 5 50 sec runs was -
BEFORE: 105.84 MB/sec
AFTER: 112.42 MB/sec

Changes from v0:
* Always pass task se to set_next_buddy
* Avoid repeated set_next_buddy in check_preempt_wakeup
* Minor flag cleanup in dequeue_task_fair

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched_fair.c |   41 ++++++++++++++++++++++++++++++++++++++---
 1 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3a88dee..cbe442e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1339,6 +1339,20 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	hrtick_update(rq);
 }
 
+static struct sched_entity *pick_next_taskse_on_cfsrq(struct cfs_rq *cfs_rq)
+{
+	struct sched_entity *se;
+
+	do {
+		se = pick_next_entity(cfs_rq);
+		cfs_rq = group_cfs_rq(se);
+	} while (cfs_rq);
+
+	return se;
+}
+
+static void set_next_buddy(struct sched_entity *se);
+
 /*
  * The dequeue_task method is called before nr_running is
  * decreased. We remove the task from the rbtree and
@@ -1348,14 +1362,25 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
+	int task_sleep = flags & DEQUEUE_SLEEP;
 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, flags);
 
 		/* Don't dequeue parent if it has other entities besides us */
-		if (cfs_rq->load.weight)
+		if (cfs_rq->load.weight) {
+			/*
+			 * Bias pick_next to pick a task from this cfs_rq, as
+			 * p is sleeping when it is within its sched_slice.
+			 */
+			if (task_sleep) {
+				struct sched_entity *next_se;
+				next_se = pick_next_taskse_on_cfsrq(cfs_rq);
+				set_next_buddy(next_se);
+			}
 			break;
+		}
 		flags |= DEQUEUE_SLEEP;
 	}
 
@@ -1856,12 +1881,15 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	struct sched_entity *se = &curr->se, *pse = &p->se;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 	int scale = cfs_rq->nr_running >= sched_nr_latency;
+	int next_buddy_marked = 0;
 
 	if (unlikely(se == pse))
 		return;
 
-	if (sched_feat(NEXT_BUDDY) && scale && !(wake_flags & WF_FORK))
+	if (sched_feat(NEXT_BUDDY) && scale && !(wake_flags & WF_FORK)) {
 		set_next_buddy(pse);
+		next_buddy_marked = 1;
+	}
 
 	/*
 	 * We can come here with TIF_NEED_RESCHED already set from new task
@@ -1887,8 +1915,15 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	update_curr(cfs_rq);
 	find_matching_se(&se, &pse);
 	BUG_ON(!pse);
-	if (wakeup_preempt_entity(se, pse) == 1)
+	if (wakeup_preempt_entity(se, pse) == 1) {
+		/*
+		 * Bias pick_next to pick the task that is
+		 * triggering this preemption.
+		 */
+		if (!next_buddy_marked)
+			set_next_buddy(&p->se);
 		goto preempt;
+	}
 
 	return;
 
-- 
1.7.3.1

