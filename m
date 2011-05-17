Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab1EQOZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:25:57 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49782 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab1EQOZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:25:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pc9fi5yEu2uzY9JbNlCc0g4tNWhbz3Joeo/nidtc3ToHgkhW5Wfq/jrXX9OQvOiQZc
         KbLdSDr/ICnc1NxJUXcisLlEdeCV28/zImTmxjHMNhC8JuGAL3PcIALsUWn/emgsHj3Z
         y5K9LvbpBw97O7ZX+KBC48RV0G6oEfY4nai4M=
MIME-Version: 1.0
In-Reply-To: <1305555077.12285.63.camel@marge.simson.net>
References: <BANLkTi=_gfo4bZjkoBsxspLxxWSPy=7J+Q@mail.gmail.com>
	<1305441316.7460.40.camel@marge.simson.net>
	<BANLkTino730kar=fEDJGCy8bCSVUe52aOw@mail.gmail.com>
	<1305555077.12285.63.camel@marge.simson.net>
Date: Tue, 17 May 2011 22:25:54 +0800
Message-ID: <BANLkTi=0pe8U6TZsQcXssV3iK_5Y+jRWCA@mail.gmail.com>
Subject: Re: [PATCH] sched: avoid overpull when pulling RT task
From: Hillf Danton <dhillf@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 10:11 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Mon, 2011-05-16 at 21:14 +0800, Hillf Danton wrote:
>
>> In the following patch, pulling is played in two rounds. In the first round,
>> the highest priority task is determined with no pull operation. Pulling is
>> carried out in the second round, and if the highest priority task is pulled,
>> pulling could be stopped when overload detected, to relieve overpull.
>>
>> Please review again, thanks.
>
> Traversing runqueues twice to avoid some potential task bouncing during
> overload situation seems like a really bad trade.  Not to mention that
> between pass one and pass two, the world turns under your feet.
>
> You could do it in one pass by leaving the victim's runqueue locked
> unless you find a better victim I suppose.  Dunno, guess it all depends
> on how much benefit the is to pulling only highest, which I can't answer
> (my gut says "none, only more pain to be had here").
>
Hi Mike

Efforts are put on the puller's side, but bad result is reached:(

Another patch is prepared, in which pusher is asked to do the hard works,
say pushees and tasks are selected.

Unlike puller who only concerns one runqueue that accepts the pulled tasks,
pusher delivers tasks to more runqueues, so the overpull could get bigger.

Please review again, thanks.

Hillf
---

--- a/kernel/sched_rt.c	2011-04-27 11:48:50.000000000 +0800
+++ b/kernel/sched_rt.c	2011-05-17 22:18:20.000000000 +0800
@@ -51,11 +51,6 @@ static inline struct rt_rq *rt_rq_of_se(

 #ifdef CONFIG_SMP

-static inline int rt_overloaded(struct rq *rq)
-{
-	return atomic_read(&rq->rd->rto_count);
-}
-
 static inline void rt_set_overload(struct rq *rq)
 {
 	if (!rq->online)
@@ -1420,83 +1415,14 @@ static void push_rt_tasks(struct rq *rq)
 		;
 }

-static int pull_rt_task(struct rq *this_rq)
+static void pull_rt_task(struct rq *this_rq)
 {
-	int this_cpu = this_rq->cpu, ret = 0, cpu;
-	struct task_struct *p;
-	struct rq *src_rq;
-
-	if (likely(!rt_overloaded(this_rq)))
-		return 0;
+	int this_cpu = this_rq->cpu, cpu;

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
-skip:
-		double_unlock_balance(this_rq, src_rq);
+		if (cpu != this_cpu)
+			push_rt_tasks(cpu_rq(cpu));
 	}
-
-	return ret;
 }

 static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
