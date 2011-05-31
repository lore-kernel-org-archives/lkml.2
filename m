Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab1EaNEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:04:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40081 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab1EaNEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:04:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=TO37Z79wdR+a3y7YN3Oo3QGwKXH75gG+ha8lR/xNNCa75Go7vOoa/c3XxeJC76GDnj
         7OHAMczYBIfXmb87hZWrswEYqqzy0lN7ZNt/zSQP/53cX6Br0BzSEyWerMVXpYrAET3L
         LHXv63TyDFEjQv1OaKuXcw1EXy+FeU0MooE2s=
MIME-Version: 1.0
Date: Tue, 31 May 2011 21:04:36 +0800
Message-ID: <BANLkTikG4v6xPGcKU6YVTYhXCnxWaWwoKg@mail.gmail.com>
Subject: [PATCH] sched: check and preempt the current task at right place
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When switching a task to RT, it is the right place to preempt the current
running task if the task is not running. Same scenario also rises when the
priority of task has changed.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 kernel/sched_rt.c |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 88725c9..4a9553e 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1671,25 +1671,13 @@ static inline void init_sched_rt_class(void)
  */
 static void switched_to_rt(struct rq *rq, struct task_struct *p)
 {
-	int check_resched = 1;
-
 	/*
 	 * If we are already running, then there's nothing
 	 * that needs to be done. But if we are not running
 	 * we may need to preempt the current running task.
-	 * If that current running task is also an RT task
-	 * then see if we can move to another run queue.
 	 */
-	if (p->on_rq && rq->curr != p) {
-#ifdef CONFIG_SMP
-		if (rq->rt.overloaded && push_rt_task(rq) &&
-		    /* Don't resched if we changed runqueues */
-		    rq != task_rq(p))
-			check_resched = 0;
-#endif /* CONFIG_SMP */
-		if (check_resched && p->prio < rq->curr->prio)
-			resched_task(rq->curr);
-	}
+	if (p->on_rq && rq->curr != p)
+		check_preempt_curr_rt(rq, p, 0);
 }

 /*
@@ -1729,8 +1717,7 @@ prio_changed_rt(struct rq *rq, struct
task_struct *p, int oldprio)
 		 * greater than the current running task
 		 * then reschedule.
 		 */
-		if (p->prio < rq->curr->prio)
-			resched_task(rq->curr);
+		check_preempt_curr_rt(rq, p, 0);
 	}
 }
