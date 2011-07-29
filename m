Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab1G2MBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 08:01:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36210 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab1G2MBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 08:01:22 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=Uu7TN7fTZm8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=s0YjXp7eAAAA:8 a=X9Wdzp9d1pZMfoGI6BQA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] Fix to excess pre-schedule migrating during Real Time 
 overload on multiple CPUs.
From: Steven Rostedt <rostedt@goodmis.org>
To: uberj@onid.orst.edu
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110728175625.1595581wucy2hvr4@webmail.oregonstate.edu>
References: <20110728175625.1595581wucy2hvr4@webmail.oregonstate.edu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Jul 2011 08:01:20 -0400
Message-ID: <1311940880.21143.32.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 07:30 +0200, uberj@onid.orst.edu wrote:
> From cf87d70969357f46e5c28804ac39c2139652af8f Mon Sep 17 00:00:00 2001
> From: Jacques Uber <uberj@onid.orst.edu>
> Date: Thu, 28 Jul 2011 17:49:38 -0700
> Subject: [PATCH] Fix to excess pre-schedule migrating during Real Time
>   overload on multiple CPUs.
> 
> If multiple processors are under real time overload there are situations where
> a processor will pull multiple tasks from multiple CPU's while trying to
> schedule the highest priority task within it's root domain. As an example, if
> there are four CPU's all under overload and the highest priority task on CPU3
> yields its time slice, CPU3 will try to pull the next highest priority  
> task onto
> its the runqueue. Without the patch, if tasks were ordered in ascending order
> on CPU[0-2], CPU3 would pull all the tasks, ruining any possibility of using
> cached data.

As I stated on IRC, this is a theoretical situation, as real RT systems
would bind important RT tasks to CPUs, and those non-RT systems that
happen to run a bunch of RT tasks, usually have those RT tasks set up at
the same priority. If this situation were to happen, it would seldom
happen. It is likely that a bunch of overloaded RT tasks, would bounce
anyway regardless how you do this.

> 
> The simple solution to this scenario is to maintain a "best choice"  
> for CPU3 to
> pull to it's run queue. Only after checking all the queued tasks and choosing
> which one should be ran, will it deactivate, set_task, and reactivate the task
> onto it's runqueue.

There's a major bug in this solution. You have to release the rq locks,
which means that once you found your "best" task, it may no longer be
available to pull.

Also, your patch is broken because it tests for the pull inside the if
statement, and it looks like you just pulled all tasks.


> 
> This patch was inspired by a Linux Journal article about the Real Time  
> Scheduler.
> http://www.linuxjournal.com/magazine/real-time-linux-kernel-scheduler?page=0,3
> 
> Signed-off-by: Jacques Uber <uberj@onid.orst.edu>
> Signed-off-by: Kevin Strasser <strassek@onid.orst.edu>
> ---
>   kernel/sched_rt.c |   11 ++++++++---
>   1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 97540f0..067f159 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1482,6 +1482,7 @@ static int pull_rt_task(struct rq *this_rq)
>   {
>          int this_cpu = this_rq->cpu, ret = 0, cpu;
>          struct task_struct *p;
> +       struct task_struct *best = NULL;

broken whitespace throughout.

>          struct rq *src_rq;
> 
>          if (likely(!rt_overloaded(this_rq)))
> @@ -1540,9 +1541,10 @@ static int pull_rt_task(struct rq *this_rq)
> 
>                          ret = 1;
> 
> -                       deactivate_task(src_rq, p, 0);
> -                       set_task_cpu(p, this_cpu);
> -                       activate_task(this_rq, p, 0);
> +            if(!best)
> +                best = p;
> +            else if(p->prio > best->prio)
> +                best = p;
>                          /*
>                           * We continue with the search, just in
>                           * case there's an even higher prio task
> @@ -1550,6 +1552,9 @@ static int pull_rt_task(struct rq *this_rq)
>                           * but possible)
>                           */
>                  }
> +        deactivate_task(src_rq, p, 0);
> +        set_task_cpu(p, this_cpu);
> +        activate_task(this_rq, p, 0);

This is still inside the loop. You just pulled p without checking
anything. 'best' is not used at all. You just made things worse.

Before touching the scheduler, always have a test case that shows the
problem, and can show that a patch solves that problem. The scheduler is
too critical to the entire system to just apply random patches.

-- Steve

>   skip:
>                  double_unlock_balance(this_rq, src_rq);
>          }


