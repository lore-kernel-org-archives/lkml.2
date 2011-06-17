Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab1FQBuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:50:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54640 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667Ab1FQBuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:50:08 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=Caq5pGLvaXcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=D5TY0NKFzBz_0gWAOggA:9 a=VxmldUxG-kBFLGVDwT8A:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: update cpupri for runqueue when its priority
 changes
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTint_00+oHVGpgV4n4E2A9W5O8nJxA@mail.gmail.com>
References: <BANLkTint_00+oHVGpgV4n4E2A9W5O8nJxA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 16 Jun 2011 21:50:05 -0400
Message-ID: <1308275405.9218.156.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-05 at 17:54 +0800, Hillf Danton wrote:
> When the priority of runqueue changes, lower or higer, the info of cpupri
> should be updated, in cases such as pick_next_task_rt() and switched_to_rt().

Why?

We do the calculation on queuing and dequeuing the task, we only care
about the highest priority task that is on the queue, not what is
actually running.

-- Steve

> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>  kernel/sched_rt.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 08e9374..9508168 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1158,6 +1158,8 @@ static struct task_struct
> *pick_next_task_rt(struct rq *rq)
>  	 * lock again later if there is no need to push
>  	 */
>  	rq->post_schedule = has_pushable_tasks(rq);
> +
> +	cpupri_set(&rq->rd->cpupri, rq->cpu, p == NULL ? MAX_RT_PRIO : p->prio);
>  #endif
> 
>  	return p;
> @@ -1673,6 +1675,8 @@ static void switched_to_rt(struct rq *rq, struct
> task_struct *p)
>  {
>  	int check_resched = 1;
> 
> +	if (!p->on_rq)
> +		return;
>  	/*
>  	 * If we are already running, then there's nothing
>  	 * that needs to be done. But if we are not running
> @@ -1680,7 +1684,7 @@ static void switched_to_rt(struct rq *rq, struct
> task_struct *p)
>  	 * If that current running task is also an RT task
>  	 * then see if we can move to another run queue.
>  	 */
> -	if (p->on_rq && rq->curr != p) {
> +	if (rq->curr != p) {
>  #ifdef CONFIG_SMP
>  		if (rq->rt.overloaded && push_rt_task(rq) &&
>  		    /* Don't resched if we changed runqueues */
> @@ -1690,6 +1694,11 @@ static void switched_to_rt(struct rq *rq,
> struct task_struct *p)
>  		if (check_resched && p->prio < rq->curr->prio)
>  			resched_task(rq->curr);
>  	}
> +	else {
> +#ifdef CONFIG_SMP
> +		cpupri_set(&rq->rd->cpupri, rq->cpu, p->prio);
> +#endif
> +	}
>  }
> 
>  /*


