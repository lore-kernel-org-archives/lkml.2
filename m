Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab1EXNps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:45:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49054 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab1EXNpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:45:46 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=2hPWuqIl968A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=geYySl4QpmlhNwi82joA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: remove starvation in check_preempt_equal_prio()
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <BANLkTinrHfVT43Evto3GqN8venDrLXoMbg@mail.gmail.com>
References: <BANLkTinrHfVT43Evto3GqN8venDrLXoMbg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 24 May 2011 09:45:45 -0400
Message-ID: <1306244745.1465.62.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 21:34 +0800, Hillf Danton wrote:
> If there are pushable tasks and they are high enough in priority, in which
> case task p is covered, the current could keep holding its CPU.
> 
> Even if current task has to release its CPU, requeuing task p could result in
> starvation of tasks that are of same priority and have been waiting on RQ for
> a couple of hours:/

Can you explain this better? Sounds like you are describing the
definition of FIFO. You are *not* suppose to preempt a FIFO task just
because another task of equal priority woke up on its run queue.

Yes, if you queue two FIFO tasks of the same priority on the same run
queue, and one runs for hours without calling schedule. The other one
will have to wait.

-- Steve


> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- tip-git/kernel/sched_rt.c	Sun May 22 20:12:01 2011
> +++ sched_rt.c	Tue May 24 21:01:51 2011
> @@ -1028,24 +1028,23 @@ select_task_rq_rt(struct task_struct *p,
>  	return cpu;
>  }
> 
> +static struct task_struct *pick_next_pushable_task(struct rq *);
> +
>  static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
>  {
> -	if (rq->curr->rt.nr_cpus_allowed == 1)
> -		return;
> -
> -	if (p->rt.nr_cpus_allowed != 1
> -	    && cpupri_find(&rq->rd->cpupri, p, NULL))
> +	if (rq->curr->rt.nr_cpus_allowed > 1) {
> +		struct task_struct *push = pick_next_pushable_task(rq);
> +		/*
> +		 * Though curr is pushable, if there are other pushable tasks,
> +		 * we keep curr busy.
> +		 */
> +		if (push && !(push->prio > p->prio))
> +			return;
> +	} else
>  		return;
> 
> -	if (!cpupri_find(&rq->rd->cpupri, rq->curr, NULL))
> -		return;
> -
> -	/*
> -	 * There appears to be other cpus that can accept
> -	 * current and none to run 'p', so lets reschedule
> -	 * to try and push current away:
> -	 */
> -	requeue_task_rt(rq, p, 1);
> +	/* yield curr */
> +	requeue_task_rt(rq, rq->curr, 0);
>  	resched_task(rq->curr);
>  }
> 
> @@ -1091,7 +1090,7 @@ static struct sched_rt_entity *pick_next
>  	BUG_ON(idx >= MAX_RT_PRIO);
> 
>  	queue = array->queue + idx;
> -	next = list_entry(queue->next, struct sched_rt_entity, run_list);
> +	next = list_first_entry(queue, struct sched_rt_entity, run_list);
> 
>  	return next;
>  }


