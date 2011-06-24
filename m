Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab1FXNVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:21:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50818 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab1FXNVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:21:43 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=IG6JThDNBpcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1UNt5rM2R5ei1DgHqGoA:9 a=5cDr5WZ9eAeI7j4PjmEA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC] sched: use plist in pulling RT task
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTi=qf7Dm6U+3B9qL+gYThe4oQXp3tg@mail.gmail.com>
References: <BANLkTi=qf7Dm6U+3B9qL+gYThe4oQXp3tg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 24 Jun 2011 09:21:41 -0400
Message-ID: <1308921701.17580.9.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-24 at 20:53 +0800, Hillf Danton wrote:
> Hi Steven
> 
> It is pushable tasks that are pulled, and they are maintained by runqueue with
> plist, so the plist can be also used by puller for free.
> 
> Thanks
> 
> Hillf
> ---
>  kernel/sched_rt.c |   35 ++++++++++++++++++++++-------------
>  1 files changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index b03cd89..f4eecf9 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1471,6 +1471,7 @@ static int pull_rt_task(struct rq *this_rq)
>  	int this_cpu = this_rq->cpu, ret = 0, cpu;
>  	struct task_struct *p;
>  	struct rq *src_rq;
> +	int pulled_prio = MAX_RT_PRIO;

Set pulled_prio = this_rq->rt.highest_prio.curr

> 
>  	if (likely(!rt_overloaded(this_rq)))
>  		return 0;
> @@ -1481,6 +1482,8 @@ static int pull_rt_task(struct rq *this_rq)
> 
>  		src_rq = cpu_rq(cpu);
> 
> +		if (src_rq->rt.highest_prio.next >= pulled_prio)
> +			continue;

Have this replace the if statement below the following comment. Keep the
comment though (move it above this if statement).

>  		/*
>  		 * Don't bother taking the src_rq->lock if the next highest
>  		 * task is known to be lower-priority than our current task.
> @@ -1502,18 +1505,19 @@ static int pull_rt_task(struct rq *this_rq)
>  		/*
>  		 * Are there still pullable RT tasks?
>  		 */
> -		if (src_rq->rt.rt_nr_running <= 1)
> +		if (! has_pushable_tasks(src_rq))
                       ^
                       |
                Stop putting in these spaces, they don't belong.


>  			goto skip;
> 
> -		p = pick_next_highest_task_rt(src_rq, this_cpu);
> -
>  		/*
>  		 * Do we have an RT task that preempts
>  		 * the to-be-scheduled task?
>  		 */
> -		if (p && (p->prio < this_rq->rt.highest_prio.curr)) {
> -			WARN_ON(p == src_rq->curr);
> -			WARN_ON(!p->on_rq);
> +		plist_for_each_entry(p, &src_rq->rt.pushable_tasks,
> +						    pushable_tasks) {
> +			if (p->prio >= pulled_prio)
> +				break;
> +			if (! (p->prio < this_rq->rt.highest_prio.curr))

Again, remove the space after the '!'. Better yet, why the '!'? A more
readable statement would be (p->prio >= this_rq->rt.highest_prio.curr).
But because you'll change pulled_prio to start at curr anyway, we can
remove this second condition altogether.

> +				break;
> 
>  			/*
>  			 * There's a chance that p is higher in priority
> @@ -1524,22 +1528,27 @@ static int pull_rt_task(struct rq *this_rq)
>  			 * current task on the run queue
>  			 */
>  			if (p->prio < src_rq->curr->prio)
> -				goto skip;
> +				continue;

The above will take some testing. Keep it out for now and add it as a
second patch. If a higher RT task is about to run, it will soon
schedule, and if there's more RT tasks, it will do the pushing. Lets let
the other rq do the work. But it may end up being that doing it now may
be better. This is something that will require testing and benchmarking
to figure out what to do.

> +
> +			if (! cpumask_test_cpu(this_cpu, &p->cpus_allowed))
> +				continue;
> 
> +			pulled_prio = p->prio;
>  			ret = 1;
> 
>  			deactivate_task(src_rq, p, 0);
>  			set_task_cpu(p, this_cpu);
>  			activate_task(this_rq, p, 0);
> -			/*
> -			 * We continue with the search, just in
> -			 * case there's an even higher prio task
> -			 * in another runqueue. (low likelihood
> -			 * but possible)
> -			 */
> +			break;
>  		}
>  skip:
>  		double_unlock_balance(this_rq, src_rq);
> +		/*
> +		 * We continue with the search, just in
> +		 * case there's an even higher prio task
> +		 * in another runqueue. (low likelihood
> +		 * but possible)

Since the above comment is no longer indented, fix it to not be so
condensed.

-- Steve

> +		 */
>  	}
> 
>  	return ret;


