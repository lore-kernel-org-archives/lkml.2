Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab1ERN11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 09:27:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38654 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab1ERN10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 09:27:26 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=9MPN8-DmjYcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=vtbZry4LylSrCPoXhSkA:9 a=cbOxEji3cWl1S-GmknwA:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: change pull_rt_task() to decrease time waiting
 on runqueue
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <BANLkTintLhxVQvbmt6oJQ9Zbcmen7yL3ug@mail.gmail.com>
References: <BANLkTintLhxVQvbmt6oJQ9Zbcmen7yL3ug@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 18 May 2011 09:27:24 -0400
Message-ID: <1305725244.26849.13.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 20:57 +0800, Hillf Danton wrote:
> It is changed to be pushing RT task, then the pushable tasks on other
> runqueus have chances to reach all CPUS whose runqueus are lower in
> priority, which is not covered by pull since only one runqueue is
> considered in pull for accepting tasks on other runqueues. Thus the
> time of pushable tasks waiting on runqueue could be decreased.

Do you have numbers and test cases for this? Or at least traces that
show how this helps?

Basically, you are saying that we want to iterate over all CPUs and have
them go through the algorithm of searching for rqs that they can push
to. But we already know that our run queue has dropped priority.

I'm not fully understanding the benefit of this patch.

-- Steve


> 
> Thanks all comments in preparing this work.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/kernel/sched_rt.c	2011-04-27 11:48:50.000000000 +0800
> +++ b/kernel/sched_rt.c	2011-05-18 20:29:26.000000000 +0800
> @@ -1423,77 +1423,13 @@ static void push_rt_tasks(struct rq *rq)
>  static int pull_rt_task(struct rq *this_rq)
>  {
>  	int this_cpu = this_rq->cpu, ret = 0, cpu;
> -	struct task_struct *p;
> -	struct rq *src_rq;
> 
>  	if (likely(!rt_overloaded(this_rq)))
>  		return 0;
> 
>  	for_each_cpu(cpu, this_rq->rd->rto_mask) {
> -		if (this_cpu == cpu)
> -			continue;
> -
> -		src_rq = cpu_rq(cpu);
> -
> -		/*
> -		 * Don't bother taking the src_rq->lock if the next highest
> -		 * task is known to be lower-priority than our current task.
> -		 * This may look racy, but if this value is about to go
> -		 * logically higher, the src_rq will push this task away.
> -		 * And if its going logically lower, we do not care
> -		 */
> -		if (src_rq->rt.highest_prio.next >=
> -		    this_rq->rt.highest_prio.curr)
> -			continue;
> -
> -		/*
> -		 * We can potentially drop this_rq's lock in
> -		 * double_lock_balance, and another CPU could
> -		 * alter this_rq
> -		 */
> -		double_lock_balance(this_rq, src_rq);
> -
> -		/*
> -		 * Are there still pullable RT tasks?
> -		 */
> -		if (src_rq->rt.rt_nr_running <= 1)
> -			goto skip;
> -
> -		p = pick_next_highest_task_rt(src_rq, this_cpu);
> -
> -		/*
> -		 * Do we have an RT task that preempts
> -		 * the to-be-scheduled task?
> -		 */
> -		if (p && (p->prio < this_rq->rt.highest_prio.curr)) {
> -			WARN_ON(p == src_rq->curr);
> -			WARN_ON(!p->se.on_rq);
> -
> -			/*
> -			 * There's a chance that p is higher in priority
> -			 * than what's currently running on its cpu.
> -			 * This is just that p is wakeing up and hasn't
> -			 * had a chance to schedule. We only pull
> -			 * p if it is lower in priority than the
> -			 * current task on the run queue
> -			 */
> -			if (p->prio < src_rq->curr->prio)
> -				goto skip;
> -
> -			ret = 1;
> -
> -			deactivate_task(src_rq, p, 0);
> -			set_task_cpu(p, this_cpu);
> -			activate_task(this_rq, p, 0);
> -			/*
> -			 * We continue with the search, just in
> -			 * case there's an even higher prio task
> -			 * in another runqueue. (low likelihood
> -			 * but possible)
> -			 */
> -		}
> -skip:
> -		double_unlock_balance(this_rq, src_rq);
> +		if (this_cpu != cpu)
> +			ret += push_rt_task(cpu_rq(cpu));
>  	}
> 
>  	return ret;


