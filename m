Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab2DIMjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 08:39:11 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43933 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab2DIMjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 08:39:09 -0400
MIME-Version: 1.0
Date: Mon, 9 Apr 2012 20:39:08 +0800
Message-ID: <CAJd=RBAL4ODagH3oEwQMFqRX=1tXy9nQkA1U_ij6Rw7BCEOQHw@mail.gmail.com>
Subject: [PATCH] DLS: fix select_task_rq_dl
From: Hillf Danton <dhillf@gmail.com>
To: Dario Faggioli <raistlin@linux.it>, Juri Lelli <juri.lelli@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for CPU online is added for correct reference of rq->curr, and for the
chance to find another runqueue for given task.

We never find other runqueue if the current task could be peempted, no matter
its migratary or not. IOW, preempt check should never be bypassed.

BTW, SD_BALANCE_XXX matches DLS?

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched_dl.c	Mon Apr  9 19:39:56 2012
+++ b/kernel/sched_dl.c	Mon Apr  9 19:57:12 2012
@@ -806,8 +806,7 @@ static void yield_task_dl(struct rq *rq)

 static int find_later_rq(struct task_struct *task);

-static int
-select_task_rq_dl(struct task_struct *p, int sd_flag, int flags)
+static int select_task_rq_dl(struct task_struct *p, int sd_flag, int flags)
 {
 	struct task_struct *curr;
 	struct rq *rq;
@@ -815,36 +814,40 @@ select_task_rq_dl(struct task_struct *p,

 	cpu = task_cpu(p);

+	if (!cpu_online(cpu))
+		goto find;
+	if (!cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
+		goto find;
+
 	if (sd_flag != SD_BALANCE_WAKE && sd_flag != SD_BALANCE_FORK)
 		goto out;

 	rq = cpu_rq(cpu);

 	rcu_read_lock();
-	curr = ACCESS_ONCE(rq->curr); /* unlocked access */

-	/*
-	 * If we are dealing with a -deadline task, we must
-	 * decide where to wake it up.
-	 * If it has a later deadline and the current task
-	 * on this rq can't move (provided the waking task
-	 * can!) we prefer to send it somewhere else. On the
-	 * other hand, if it has a shorter deadline, we
-	 * try to make it stay here, it might be important.
-	 */
-	if (unlikely(dl_task(curr)) &&
-	    (curr->dl.nr_cpus_allowed < 2 ||
-	     !dl_entity_preempt(&p->dl, &curr->dl)) &&
-	    (p->dl.nr_cpus_allowed > 1)) {
+	curr = ACCESS_ONCE(rq->curr);
+
+	if (!dl_task(curr))
+		goto unlock;
+
+	if (dl_entity_preempt(&p->dl, &curr->dl))
+		goto unlock;
+
+	rcu_read_unlock();
+find:
+	if (p->dl.nr_cpus_allowed > 1) {
 		int target = find_later_rq(p);

 		if (target != -1)
 			cpu = target;
 	}
-	rcu_read_unlock();

 out:
 	return cpu;
+unlock:
+	rcu_read_unlock();
+	goto out;
 }

 static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
--
