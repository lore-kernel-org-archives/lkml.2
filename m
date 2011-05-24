Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab1EXNeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:34:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58232 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab1EXNeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=koytzyioOEHBFKL2ljHC64I7VMEDMLA81J15kdDd/qZh0yMSGL9SvRFIcR+BH/DvtJ
         w4p3v0MwSgORcOHmv/UUI/7MKyPq7NjPPYKU/Bf6xlXFG8O94kqBJzcdS4x8erR/LQbY
         h4QYrrsrKD63F4Bqhn7NSvovArz4yHRT8KZAg=
MIME-Version: 1.0
Date: Tue, 24 May 2011 21:34:05 +0800
Message-ID: <BANLkTinrHfVT43Evto3GqN8venDrLXoMbg@mail.gmail.com>
Subject: [PATCH] sched: remove starvation in check_preempt_equal_prio()
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there are pushable tasks and they are high enough in priority, in which
case task p is covered, the current could keep holding its CPU.

Even if current task has to release its CPU, requeuing task p could result in
starvation of tasks that are of same priority and have been waiting on RQ for
a couple of hours:/

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- tip-git/kernel/sched_rt.c	Sun May 22 20:12:01 2011
+++ sched_rt.c	Tue May 24 21:01:51 2011
@@ -1028,24 +1028,23 @@ select_task_rq_rt(struct task_struct *p,
 	return cpu;
 }

+static struct task_struct *pick_next_pushable_task(struct rq *);
+
 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 {
-	if (rq->curr->rt.nr_cpus_allowed == 1)
-		return;
-
-	if (p->rt.nr_cpus_allowed != 1
-	    && cpupri_find(&rq->rd->cpupri, p, NULL))
+	if (rq->curr->rt.nr_cpus_allowed > 1) {
+		struct task_struct *push = pick_next_pushable_task(rq);
+		/*
+		 * Though curr is pushable, if there are other pushable tasks,
+		 * we keep curr busy.
+		 */
+		if (push && !(push->prio > p->prio))
+			return;
+	} else
 		return;

-	if (!cpupri_find(&rq->rd->cpupri, rq->curr, NULL))
-		return;
-
-	/*
-	 * There appears to be other cpus that can accept
-	 * current and none to run 'p', so lets reschedule
-	 * to try and push current away:
-	 */
-	requeue_task_rt(rq, p, 1);
+	/* yield curr */
+	requeue_task_rt(rq, rq->curr, 0);
 	resched_task(rq->curr);
 }

@@ -1091,7 +1090,7 @@ static struct sched_rt_entity *pick_next
 	BUG_ON(idx >= MAX_RT_PRIO);

 	queue = array->queue + idx;
-	next = list_entry(queue->next, struct sched_rt_entity, run_list);
+	next = list_first_entry(queue, struct sched_rt_entity, run_list);

 	return next;
 }
