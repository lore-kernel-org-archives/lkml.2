Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab1EXNbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:31:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34652 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab1EXNbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:31:14 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=G1dXN-r5QsUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=ZfUuFlCtmpj_9wFjj3wA:9 a=F30VYG4NC6kjMf6TNocA:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v0] sched: change how run-queue is selected for RT task
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <BANLkTimF2d93VVGKHDdFTn=V-1h9nWrs_w@mail.gmail.com>
References: <BANLkTimF2d93VVGKHDdFTn=V-1h9nWrs_w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 24 May 2011 09:31:12 -0400
Message-ID: <1306243872.1465.55.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-21 at 23:28 +0800, Hillf Danton wrote:
> When selecting run-queue for a given RT task, we have to take a few
> factors, such as task priority and CPU cache affinity, into
> consideration. In this work, a simpler method is proposed, which is
> focusing on the relation between the current run-queue of the given
> task and the given run-queue.
> 
> If the current run-queue of task is the given run-queue, the run-queue
> of task keeps unchanged, so the CPU cache affinities of both task and
> the current task of run-queue remain unchanged. Then there are at
> least two tasks competing one CPU, and in the worst case that both
> competitors are RT tasks the victim will be selected and processed by
> pusher later.
> 
> On other hand, if the current run-queue of task is different from the
> given run-queue, task is simply delivered to its current run-queue,
> since pusher is always willing to do hard works.
> 
> In summary, the burden of RT task is always processed first by the
> pusher of its current run-queue.

Why? Why should we preempt a high prio task to make it push off a task
that has just woken up on its CPU? If we know that we are about to
preempt a high prio RT task, why interrupt it, when we could simply make
this task wake up on another CPU?

-- Steve

> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/kernel/sched_rt.c	2011-04-27 11:48:50.000000000 +0800
> +++ b/kernel/sched_rt.c	2011-05-21 22:19:52.000000000 +0800
> @@ -998,14 +998,12 @@ select_task_rq_rt(struct rq *rq, struct
>  	 *
>  	 * For equal prio tasks, we just let the scheduler sort it out.
>  	 */
> -	if (unlikely(rt_task(rq->curr)) &&
> -	    (rq->curr->rt.nr_cpus_allowed < 2 ||
> -	     rq->curr->prio < p->prio) &&
> -	    (p->rt.nr_cpus_allowed > 1)) {
> -		int cpu = find_lowest_rq(p);
> 
> -		return (cpu == -1) ? task_cpu(p) : cpu;
> -	}
> +	if (task_cpu(p) == rq->cpu)
> +		return rq->cpu;
> +
> +	if (likely(!rt_task(rq->curr)))
> +		return rq->cpu;
> 
>  	/*
>  	 * Otherwise, just let it ride on the affined RQ and the


