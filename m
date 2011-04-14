Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab1DNRbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:31:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11885 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab1DNRbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:31:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KUwKMeXTjiSrF0BlZ+eK9YW50pSvcqMOKlQOc0xRYqNWZVraEsqYMOmA/JdUbNW5KA
         kZsdCXue3l1TY9OlF+Mg==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Rik van Riel <riel@redhat.com>, Venkatesh Pallipadi <venki@google.com>
Subject: Re: [PATCH 2/2] sched: next buddy hint on sleep and preempt path -v2
Date: Thu, 14 Apr 2011 10:30:53 -0700
Message-Id: <1302802253-25760-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1302778202.2035.23.camel@laptop>
References: <1302778202.2035.23.camel@laptop>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry. My mistake. The below version should fare better.

Thanks,
Venki

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

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched_fair.c |   26 +++++++++++++++++++++++---
 1 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 1b3a4d4..80931f0 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1340,6 +1340,8 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	hrtick_update(rq);
 }
 
+static void set_next_buddy(struct sched_entity *se);
+
 /*
  * The dequeue_task method is called before nr_running is
  * decreased. We remove the task from the rbtree and
@@ -1349,14 +1351,22 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
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
+			if (task_sleep && parent_entity(se))
+				set_next_buddy(parent_entity(se));
 			break;
+		}
 		flags |= DEQUEUE_SLEEP;
 	}
 
@@ -1857,12 +1867,15 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
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
@@ -1890,8 +1903,15 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	update_curr(cfs_rq);
 	find_matching_se(&se, &pse);
 	BUG_ON(!pse);
-	if (wakeup_preempt_entity(se, pse) == 1)
+	if (wakeup_preempt_entity(se, pse) == 1) {
+		/*
+		 * Bias pick_next to pick the sched entity that is
+		 * triggering this preemption.
+		 */
+		if (!next_buddy_marked)
+			set_next_buddy(pse);
 		goto preempt;
+	}
 
 	return;
 
-- 
1.7.3.1

