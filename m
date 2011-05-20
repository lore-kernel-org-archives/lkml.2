Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935253Ab1ETQoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 12:44:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44782 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935164Ab1ETQow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 12:44:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=nLwtS1897K+JmwuMJEYftx+qSS25101d5phnuv5OeQ2wJOybUgUvtqUgSs/ysPiFPj
         GYy4MoQwO1fLqjYOAukvi++RSNhiTMD4PKi/zciP+aEmnctKgNtY/9bHJePICfXw8qiE
         f4hMG8oun3EhF2+n1TN0bk6OGNAoUh19dO5xU=
MIME-Version: 1.0
Date: Sat, 21 May 2011 00:44:51 +0800
Message-ID: <BANLkTimPjYmnBjvRc8Q2hUxiAw3bbr3FRA@mail.gmail.com>
Subject: [PATCH v0] sched: change how RT task is picked in pull_rt_task()
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pulling RT task for a given run-queue, the method to pick RT task
is changed from pick_next_highest_task_rt() to
pick_next_pushable_task(). Though job could be done with both, the
former could be replaced since plist_first_entry() is simpler and
faster.
Based on the simplicity, then the racy before and WARN_ON after
run-queue lock could be removed.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched_rt.c	2011-04-27 11:48:50.000000000 +0800
+++ b/kernel/sched_rt.c	2011-05-21 00:34:18.000000000 +0800
@@ -1434,64 +1434,19 @@ static int pull_rt_task(struct rq *this_
 			continue;

 		src_rq = cpu_rq(cpu);
-
-		/*
-		 * Don't bother taking the src_rq->lock if the next highest
-		 * task is known to be lower-priority than our current task.
-		 * This may look racy, but if this value is about to go
-		 * logically higher, the src_rq will push this task away.
-		 * And if its going logically lower, we do not care
-		 */
-		if (src_rq->rt.highest_prio.next >=
-		    this_rq->rt.highest_prio.curr)
-			continue;
-
-		/*
-		 * We can potentially drop this_rq's lock in
-		 * double_lock_balance, and another CPU could
-		 * alter this_rq
-		 */
 		double_lock_balance(this_rq, src_rq);

-		/*
-		 * Are there still pullable RT tasks?
-		 */
-		if (src_rq->rt.rt_nr_running <= 1)
+		p = pick_next_pushable_task(src_rq);
+		if (!p ||
+		    !cpumask_test_cpu(this_cpu, &p->cpus_allowed) ||
+		    !(p->prio < this_rq->rt.highest_prio.curr))
 			goto skip;

-		p = pick_next_highest_task_rt(src_rq, this_cpu);
+		ret++;
+		deactivate_task(src_rq, p, 0);
+		set_task_cpu(p, this_cpu);
+		activate_task(this_rq, p, 0);

-		/*
-		 * Do we have an RT task that preempts
-		 * the to-be-scheduled task?
-		 */
-		if (p && (p->prio < this_rq->rt.highest_prio.curr)) {
-			WARN_ON(p == src_rq->curr);
-			WARN_ON(!p->se.on_rq);
-
-			/*
-			 * There's a chance that p is higher in priority
-			 * than what's currently running on its cpu.
-			 * This is just that p is wakeing up and hasn't
-			 * had a chance to schedule. We only pull
-			 * p if it is lower in priority than the
-			 * current task on the run queue
-			 */
-			if (p->prio < src_rq->curr->prio)
-				goto skip;
-
-			ret = 1;
-
-			deactivate_task(src_rq, p, 0);
-			set_task_cpu(p, this_cpu);
-			activate_task(this_rq, p, 0);
-			/*
-			 * We continue with the search, just in
-			 * case there's an even higher prio task
-			 * in another runqueue. (low likelihood
-			 * but possible)
-			 */
-		}
 skip:
 		double_unlock_balance(this_rq, src_rq);
 	}
