Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409Ab1ESNz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:55:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39832 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933288Ab1ESNzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:55:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VkQHZD8nIbzBmVzdbr+iLb27bqST9fFxKLqebG2PTiwi0pKHRFbrQCYW1/dLBqUjOp
         8eDgh2xRFPj/VOVoDegJ7lPzWS4mK+alMOIgmfO8bD9OOLZ8ENZNQXKq69+pVv8NbIvP
         9JZ1nIWXYkEcA8lFecDjIEgj1XMbwKfDhUnS8=
MIME-Version: 1.0
In-Reply-To: <1305732037.11267.7.camel@gandalf.stny.rr.com>
References: <BANLkTintLhxVQvbmt6oJQ9Zbcmen7yL3ug@mail.gmail.com>
	<1305725244.26849.13.camel@gandalf.stny.rr.com>
	<BANLkTingJ7s5SR+QWuE=_P5tcbuaB_bEwQ@mail.gmail.com>
	<1305732037.11267.7.camel@gandalf.stny.rr.com>
Date: Thu, 19 May 2011 21:55:53 +0800
Message-ID: <BANLkTik=CvykuOhLZmbLsO+9-EDYyuEJLg@mail.gmail.com>
Subject: Re: [PATCH] sched: change pull_rt_task() to decrease time waiting on runqueue
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 11:20 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2011-05-18 at 22:54 +0800, Hillf Danton wrote:
>
>> In short, if there are pushable tasks and if there are RQs,
>> NOT LIMITED TO our RQ, in lower priority, tasks should be pushed to
>> RQs as many as we could.
>
> I understand what you are trying to do. But this change modifies a lot
> of assumptions. Please supply test cases that shows how this helps.
>
> Have a look at:
>
> http://lwn.net/Articles/425583/
>
> Where I did a bit of work just to make sure my change to sched_rt.c was
> appropriate. Just coming up with scenarios may not be good enough.
> Seeing it in practice is worth much more.
>
> For example, you may be making the fast path slower. This may do what
> you expect, with a hit in performance. I'm not sure I like that idea.
>
Hi Steve

The patch is updated with a few changes.

A clone of find_lowest_rq(), find_lowest_rq_for_pushing() is added to select
the best RQ for a given pushable tasks, in a manner that the selected RQ
has to be different from the task's RQ.

It is not the final version, since no test cases check it, but a
target for comments.

Thank you very much for sharing your work.

Hillf
---

--- a/kernel/sched_rt.c	2011-04-27 11:48:50.000000000 +0800
+++ b/kernel/sched_rt.c	2011-05-19 21:26:42.000000000 +0800
@@ -1260,6 +1260,28 @@ static int find_lowest_rq(struct task_st
 	return -1;
 }

+static int find_lowest_rq_for_pushing(struct task_struct *task)
+{
+	struct sched_domain *sd;
+	struct cpumask *lowest_mask = __get_cpu_var(local_cpu_mask);
+	int cpu = task_cpu(task);
+
+	if (task->rt.nr_cpus_allowed == 1 ||
+	    !cpupri_find(&task_rq(task)->rd->cpupri, task, lowest_mask))
+		return -1;
+
+	for_each_domain(cpu, sd) {
+		int best_cpu;
+		best_cpu = cpumask_first_and(lowest_mask,
+					     sched_domain_span(sd));
+
+		if (best_cpu < nr_cpu_ids && best_cpu != cpu)
+			return best_cpu;
+	}
+
+	return -1;
+}
+
 /* Will lock the rq it finds */
 static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 {
@@ -1268,7 +1290,7 @@ static struct rq *find_lock_lowest_rq(st
 	int cpu;

 	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
-		cpu = find_lowest_rq(task);
+		cpu = find_lowest_rq_for_pushing(task);

 		if ((cpu == -1) || (cpu == rq->cpu))
 			break;
@@ -1336,6 +1358,7 @@ static int push_rt_task(struct rq *rq)
 {
 	struct task_struct *next_task;
 	struct rq *lowest_rq;
+	int ret = 0;

 	if (!rq->rt.overloaded)
 		return 0;
@@ -1383,7 +1406,6 @@ retry:
 			 * since the other cpus will pull from us when they
 			 * are ready.
 			 */
-			dequeue_pushable_task(rq, next_task);
 			goto out;
 		}

@@ -1402,7 +1424,7 @@ retry:
 	deactivate_task(rq, next_task, 0);
 	set_task_cpu(next_task, lowest_rq->cpu);
 	activate_task(lowest_rq, next_task, 0);
-
+	ret = 1;
 	resched_task(lowest_rq->curr);

 	double_unlock_balance(rq, lowest_rq);
@@ -1410,7 +1432,7 @@ retry:
 out:
 	put_task_struct(next_task);

-	return 1;
+	return ret;
 }

 static void push_rt_tasks(struct rq *rq)
@@ -1423,77 +1445,20 @@ static void push_rt_tasks(struct rq *rq)
 static int pull_rt_task(struct rq *this_rq)
 {
 	int this_cpu = this_rq->cpu, ret = 0, cpu;
-	struct task_struct *p;
-	struct rq *src_rq;
+	int count = 0;

 	if (likely(!rt_overloaded(this_rq)))
 		return 0;

+again:
 	for_each_cpu(cpu, this_rq->rd->rto_mask) {
-		if (this_cpu == cpu)
-			continue;
-
-		src_rq = cpu_rq(cpu);
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
-		double_lock_balance(this_rq, src_rq);
-
-		/*
-		 * Are there still pullable RT tasks?
-		 */
-		if (src_rq->rt.rt_nr_running <= 1)
-			goto skip;
-
-		p = pick_next_highest_task_rt(src_rq, this_cpu);
-
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
+		if (cpu != this_cpu)
+			count += push_rt_task(cpu_rq(cpu));
+	}

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
-skip:
-		double_unlock_balance(this_rq, src_rq);
+	if (ret != count) {
+		ret = count;
+		goto again;
 	}

 	return ret;
