Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab1FPQwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:52:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45573 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab1FPQwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:52:04 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=LNPuZ-ntsc0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=r-BWzVmcDX1c6V8RMDMA:9 a=0LQOZpJ_b5C0SublwokA:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: find all lowest run-queues for RT task
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTikNYY3zKM+VUF3AbTTD0idZnt3w=Q@mail.gmail.com>
References: <BANLkTikNYY3zKM+VUF3AbTTD0idZnt3w=Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 16 Jun 2011 12:52:02 -0400
Message-ID: <1308243122.9218.143.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 22:11 +0800, Hillf Danton wrote:
> When finding the lowest run-queue for a given RT task, as seen in cases such as
> select_task_rq_rt() and find_lock_lowest_rq(), RQs with no RT tasks are also
> eligible for both RR and FIFO RT tasks.
> 
> Minor change is added, when initializing cpupri, to record non-RT RQs which are
> upated automatically, due to the cool design and implementation of cpupri, when
> RT RQs are set and unset. Then they could be included in the selected CPUs by
> cpupri_find().
> 
> A call for cpupri_set() is also added when a RQ has no RT task to run.

I just analyzed the code, and only the first part of the patch seems OK.


> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>  kernel/sched_cpupri.c |    4 +++-
>  kernel/sched_rt.c     |    4 ++++
>  2 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
> index 2722dc1..d4c0b46 100644
> --- a/kernel/sched_cpupri.c
> +++ b/kernel/sched_cpupri.c
> @@ -181,8 +181,10 @@ int cpupri_init(struct cpupri *cp)
>  			goto cleanup;
>  	}
> 
> -	for_each_possible_cpu(i)
> +	for_each_possible_cpu(i) {
>  		cp->cpu_to_pri[i] = CPUPRI_INVALID;
> +		cpupri_set(cp, i, MAX_RT_PRIO);
> +	}

This is OK, and I may add it. It's just an initialization, and because
things like the migration thread run on all CPUs, the first time an RT
task is run on a CPU and dequeued, it will have the cpupri_set() to
MX_RT_PRIO anyway. But for clean up sake, it may be good to initialize
it to a valid mask and not be ZERO.


>  	return 0;
> 
>  cleanup:
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 88725c9..4dd6e45 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1158,6 +1158,10 @@ static struct task_struct
> *pick_next_task_rt(struct rq *rq)
>  	 * lock again later if there is no need to push
>  	 */
>  	rq->post_schedule = has_pushable_tasks(rq);
> +
> +	/* this CPU is no longer RT if no task picked to feed it */
> +	if (! p)
> +		cpupri_set(&rq->rd->cpupri, rq->cpu, MAX_RT_PRIO);

Now this is where things are not needed, because when we dequeue the
last RT task, this is already done by the dequeue code.

-- Steve


>  #endif
> 
>  	return p;


