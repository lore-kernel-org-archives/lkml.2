Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab1EaOkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:40:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51368 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab1EaOkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:40:07 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=8qa4WLNxHRAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=tjpJsivIsf-D1w3Sf8oA:9 a=QBax_KeRdqG1Epfzn90A:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: remove the next highest_prio in RT scheduling
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang0@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTimQ67180HxCx5vgMqumqw1EkFh3qg@mail.gmail.com>
References: <BANLkTimQ67180HxCx5vgMqumqw1EkFh3qg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 31 May 2011 10:40:04 -0400
Message-ID: <1306852804.11899.19.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-28 at 22:25 +0800, Hillf Danton wrote:
> The next highest_prio element in rt_rq structure, is only used when pulling
> RT task. As shown by the following snippet (in diff format for clearity),
> 
> -		if (src_rq->rt.highest_prio.next >=
> +		if (src_rq->rt.highest_prio.curr >=
>  		    this_rq->rt.highest_prio.curr)
>  			continue;
> 
> the "next" could be replaced with "curr" in the above comparison, since
> the next is no less than curr by definition.

But it completely misses the point of what we are doing. We will never
pull a running task, but we can pull a waiting task. That's the point of
the "next" field. We want to know if a high priority task is waiting to
run, and if so, then we will pull it over to this CPU because this CPU
is about to switch to a task with a lower priority. If a waiting task of
higher priority than this CPU is on another CPU, we want to pull it
over.

This patch totally breaks this. We don't care about "curr" we care about
"next".

-- Steve

> 
> Then operations for updating the element are deleted accordingly.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- tip-git/kernel/sched.c	Sun May 22 18:21:46 2011
> +++ sched.c	Sat May 28 20:53:24 2011
> @@ -384,9 +384,6 @@ struct rt_rq {
>  #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
>  	struct {
>  		int curr; /* highest queued rt task prio */
> -#ifdef CONFIG_SMP
> -		int next; /* next highest */
> -#endif
>  	} highest_prio;
>  #endif
>  #ifdef CONFIG_SMP
> @@ -7718,9 +7715,6 @@ static void init_rt_rq(struct rt_rq *rt_
> 
>  #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
>  	rt_rq->highest_prio.curr = MAX_RT_PRIO;
> -#ifdef CONFIG_SMP
> -	rt_rq->highest_prio.next = MAX_RT_PRIO;
> -#endif
>  #endif
>  #ifdef CONFIG_SMP
>  	rt_rq->rt_nr_migratory = 0;
> --- tip-git/kernel/sched_rt.c	Sun May 22 20:12:01 2011
> +++ sched_rt.c	Sat May 28 21:00:04 2011
> @@ -664,67 +664,19 @@ static void update_curr_rt(struct rq *rq
> 
>  #if defined CONFIG_SMP
> 
> -static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu);
> -
> -static inline int next_prio(struct rq *rq)
> -{
> -	struct task_struct *next = pick_next_highest_task_rt(rq, rq->cpu);
> -
> -	if (next && rt_prio(next->prio))
> -		return next->prio;
> -	else
> -		return MAX_RT_PRIO;
> -}
> -
> -static void
> -inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
> -{
> -	struct rq *rq = rq_of_rt_rq(rt_rq);
> -
> -	if (prio < prev_prio) {
> -
> -		/*
> -		 * If the new task is higher in priority than anything on the
> -		 * run-queue, we know that the previous high becomes our
> -		 * next-highest.
> -		 */
> -		rt_rq->highest_prio.next = prev_prio;
> -
> -		if (rq->online)
> -			cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
> -
> -	} else if (prio == rt_rq->highest_prio.curr)
> -		/*
> -		 * If the next task is equal in priority to the highest on
> -		 * the run-queue, then we implicitly know that the next highest
> -		 * task cannot be any lower than current
> -		 */
> -		rt_rq->highest_prio.next = prio;
> -	else if (prio < rt_rq->highest_prio.next)
> -		/*
> -		 * Otherwise, we need to recompute next-highest
> -		 */
> -		rt_rq->highest_prio.next = next_prio(rq);
> -}
> -
>  static void
> -dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
> +update_rt_prio_smp(struct rt_rq *rt_rq, int prev_prio)
>  {
>  	struct rq *rq = rq_of_rt_rq(rt_rq);
> 
> -	if (rt_rq->rt_nr_running && (prio <= rt_rq->highest_prio.next))
> -		rt_rq->highest_prio.next = next_prio(rq);
> -
>  	if (rq->online && rt_rq->highest_prio.curr != prev_prio)
>  		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
>  }
> 
>  #else /* CONFIG_SMP */
> 
> -static inline
> -void inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio) {}
> -static inline
> -void dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio) {}
> +static inline void
> +update_rt_prio_smp(struct rt_rq *rt_rq, int prev_prio) {}
> 
>  #endif /* CONFIG_SMP */
> 
> @@ -737,7 +689,7 @@ inc_rt_prio(struct rt_rq *rt_rq, int pri
>  	if (prio < prev_prio)
>  		rt_rq->highest_prio.curr = prio;
> 
> -	inc_rt_prio_smp(rt_rq, prio, prev_prio);
> +	update_rt_prio_smp(rt_rq, prev_prio);
>  }
> 
>  static void
> @@ -763,7 +715,7 @@ dec_rt_prio(struct rt_rq *rt_rq, int pri
>  	} else
>  		rt_rq->highest_prio.curr = MAX_RT_PRIO;
> 
> -	dec_rt_prio_smp(rt_rq, prio, prev_prio);
> +	update_rt_prio_smp(rt_rq, prev_prio);
>  }
> 
>  #else
> @@ -1456,7 +1408,7 @@ static int pull_rt_task(struct rq *this_
>  		 * logically higher, the src_rq will push this task away.
>  		 * And if its going logically lower, we do not care
>  		 */
> -		if (src_rq->rt.highest_prio.next >=
> +		if (src_rq->rt.highest_prio.curr >=
>  		    this_rq->rt.highest_prio.curr)
>  			continue;


