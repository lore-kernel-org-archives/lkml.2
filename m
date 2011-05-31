Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511Ab1EaUcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:32:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63362 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758495Ab1EaUb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:31:58 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=DyQkDb8ePfQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=oWH7QCMftfZiGsOD6twA:9 a=bYJLwAeIRuB0rfDNpQMA:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=UXVmiyVkT6AA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: check and preempt the current task at right
 place
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTikG4v6xPGcKU6YVTYhXCnxWaWwoKg@mail.gmail.com>
References: <BANLkTikG4v6xPGcKU6YVTYhXCnxWaWwoKg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 31 May 2011 16:31:55 -0400
Message-ID: <1306873915.10135.11.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 21:04 +0800, Hillf Danton wrote:
> When switching a task to RT, it is the right place to preempt the current
> running task if the task is not running. Same scenario also rises when the
> priority of task has changed.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>  kernel/sched_rt.c |   19 +++----------------
>  1 files changed, 3 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 88725c9..4a9553e 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1671,25 +1671,13 @@ static inline void init_sched_rt_class(void)
>   */
>  static void switched_to_rt(struct rq *rq, struct task_struct *p)
>  {
> -	int check_resched = 1;
> -
>  	/*
>  	 * If we are already running, then there's nothing
>  	 * that needs to be done. But if we are not running
>  	 * we may need to preempt the current running task.
> -	 * If that current running task is also an RT task
> -	 * then see if we can move to another run queue.
>  	 */
> -	if (p->on_rq && rq->curr != p) {
> -#ifdef CONFIG_SMP
> -		if (rq->rt.overloaded && push_rt_task(rq) &&
> -		    /* Don't resched if we changed runqueues */
> -		    rq != task_rq(p))
> -			check_resched = 0;
> -#endif /* CONFIG_SMP */
> -		if (check_resched && p->prio < rq->curr->prio)
> -			resched_task(rq->curr);
> -	}
> +	if (p->on_rq && rq->curr != p)
> +		check_preempt_curr_rt(rq, p, 0);


Note, although it works now, there's no guarantee that
check_preempt_curr_rt() will work with something other than an rt task
on the runqueue.

Also, this code removes the push_rt_task(rq) entirely, which means that
if we don't preempt current, and p is an RT task (as it is), we wont
push it off to another rq even if one is available for it to run on.

-- Steve


>  }
> 
>  /*
> @@ -1729,8 +1717,7 @@ prio_changed_rt(struct rq *rq, struct
> task_struct *p, int oldprio)
>  		 * greater than the current running task
>  		 * then reschedule.
>  		 */
> -		if (p->prio < rq->curr->prio)
> -			resched_task(rq->curr);
> +		check_preempt_curr_rt(rq, p, 0);
>  	}
>  }


