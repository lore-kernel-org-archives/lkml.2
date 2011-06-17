Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab1FQCdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 22:33:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:47974 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752013Ab1FQCda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 22:33:30 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+suP51giassAvTcOTMXbM4Mz9FCMWXXHPEexplYY
	xMKDCgzjmzgQ8K
Subject: Re: [RFC][PATCH 4/7] sched, rt: Fix rq->rt.pushable_tasks bug in
 push_rt_task()
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Yong Zhang <yong.zhang0@gmail.com>, Hillf Danton <dhillf@gmail.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20110617015919.136959032@goodmis.org>
References: <20110617015516.301117218@goodmis.org>
	 <20110617015919.136959032@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jun 2011 04:33:25 +0200
Message-ID: <1308278005.15063.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 21:55 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0004-sched-rt-Fix-rq-rt.pushable_tasks-bug-in-push_rt_tas.patch)
> From: Hillf Danton <dhillf@gmail.com>
> 
> Do not call dequeue_pushable_task() when failing to push an eligible
> task, as it remains pushable, merely not at this particular moment.
> 
> Cc: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> Signed-off-by: Mike Galbraith <mgalbraith@gmx.de>

Mixing addresses doesn't work.  Less bouncy SOB.

Signed-off-by: Mike Galbraith <efault@gmx.de>


> Link: http://lkml.kernel.org/r/1306895385.4791.26.camel@marge.simson.net
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/sched_rt.c |   15 ++++++++-------
>  1 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index a6f1f64..7737d41 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1378,6 +1378,7 @@ static int push_rt_task(struct rq *rq)
>  {
>  	struct task_struct *next_task;
>  	struct rq *lowest_rq;
> +	int ret = 0;
>  
>  	if (!rq->rt.overloaded)
>  		return 0;
> @@ -1410,7 +1411,7 @@ retry:
>  	if (!lowest_rq) {
>  		struct task_struct *task;
>  		/*
> -		 * find lock_lowest_rq releases rq->lock
> +		 * find_lock_lowest_rq releases rq->lock
>  		 * so it is possible that next_task has migrated.
>  		 *
>  		 * We need to make sure that the task is still on the same
> @@ -1420,12 +1421,11 @@ retry:
>  		task = pick_next_pushable_task(rq);
>  		if (task_cpu(next_task) == rq->cpu && task == next_task) {
>  			/*
> -			 * If we get here, the task hasn't moved at all, but
> -			 * it has failed to push.  We will not try again,
> -			 * since the other cpus will pull from us when they
> -			 * are ready.
> +			 * The task hasn't migrated, and is still the next
> +			 * eligible task, but we failed to find a run-queue
> +			 * to push it to.  Do not retry in this case, since
> +			 * other cpus will pull from us when ready.
>  			 */
> -			dequeue_pushable_task(rq, next_task);
>  			goto out;
>  		}
>  
> @@ -1444,6 +1444,7 @@ retry:
>  	deactivate_task(rq, next_task, 0);
>  	set_task_cpu(next_task, lowest_rq->cpu);
>  	activate_task(lowest_rq, next_task, 0);
> +	ret = 1;
>  
>  	resched_task(lowest_rq->curr);
>  
> @@ -1452,7 +1453,7 @@ retry:
>  out:
>  	put_task_struct(next_task);
>  
> -	return 1;
> +	return ret;
>  }
>  
>  static void push_rt_tasks(struct rq *rq)


