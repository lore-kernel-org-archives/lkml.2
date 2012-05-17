Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab2EQE5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 00:57:40 -0400
Received: from mail-yw0-f74.google.com ([209.85.213.74]:44404 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab2EQE5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 00:57:38 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: Colin Cross <ccross@android.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] sched/rt: fix SCHED_RR across cgroups
Date: Wed, 16 May 2012 21:34:23 -0700
Message-Id: <1337229266-15798-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_tick_rt has an optimization to only reschedule SCHED_RR tasks
if they were the only element on their rq.  However, with cgroups
a SCHED_RR task could be the only element on its per-cgroup rq but
still be competing with other SCHED_RR tasks in its parent's
cgroup.  In this case, the SCHED_RR task in the child cgroup would
never yield at the end of its timeslice.  If the child cgroup
rt_runtime_us was the same as the parent cgroup rt_runtime_us,
the task in the parent cgroup would starve completely.

Modify task_tick_rt to check that the task is the only task on its
rq, and that the each of the scheduling entities of its ancestors
is also the only entity on its rq.

Signed-off-by: Colin Cross <ccross@android.com>
---
 kernel/sched/rt.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 44af55e..8f32475 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1983,6 +1983,8 @@ static void watchdog(struct rq *rq, struct task_struct *p)
 
 static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 {
+	struct sched_rt_entity *rt_se = &p->rt;
+
 	update_curr_rt(rq);
 
 	watchdog(rq, p);
@@ -2000,12 +2002,15 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 	p->rt.time_slice = RR_TIMESLICE;
 
 	/*
-	 * Requeue to the end of queue if we are not the only element
-	 * on the queue:
+	 * Requeue to the end of queue if we (and all of our ancestors) are the
+	 * only element on the queue
 	 */
-	if (p->rt.run_list.prev != p->rt.run_list.next) {
-		requeue_task_rt(rq, p, 0);
-		set_tsk_need_resched(p);
+	for_each_sched_rt_entity(rt_se) {
+		if (rt_se->run_list.prev != rt_se->run_list.next) {
+			requeue_task_rt(rq, p, 0);
+			set_tsk_need_resched(p);
+			return;
+		}
 	}
 }
 
-- 
1.7.7.3

