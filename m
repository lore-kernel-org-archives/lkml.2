Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1EaPA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:00:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54632 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1EaPAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:00:25 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=Nw5cNEqeFM4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=h46GdxlYiQ7svRin1IoA:9 a=PNCTqKPa29iX0gTKLcwA:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: change pulling RT task to be pulling the
 highest-prio run-queue first
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang0@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTi=+bcTDTOWEOGcmgNHYrvpnEFqEjA@mail.gmail.com>
References: <BANLkTi=+bcTDTOWEOGcmgNHYrvpnEFqEjA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 31 May 2011 11:00:22 -0400
Message-ID: <1306854022.11899.27.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-28 at 22:34 +0800, Hillf Danton wrote:
> When pulling, RT tasks are pulled from one overloaded run-queue after another,
> which is changed to be pulling tasks from the highest-prio run-queue first.

First off, a change like this requires rational. Preferably, in the
showing of benchmarks, and test cases that demonstrate the problems of
the current scheduler and explains to us that these changes improve the
situation.

There is no rational nor any benchmarks that explain why this is better
than the current method.

> 
> A new function, cpupri_find_prio(), is added to easy pulling in prio sequence.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- tip-git/kernel/sched_rt.c	Sun May 22 20:12:01 2011
> +++ sched_rt.c	Sat May 28 21:24:13 2011
> @@ -1434,18 +1434,33 @@ static void push_rt_tasks(struct rq *rq)
>  		;
>  }
> 
> +static DEFINE_PER_CPU(cpumask_var_t, high_cpu_mask);
> +
>  static int pull_rt_task(struct rq *this_rq)
>  {
>  	int this_cpu = this_rq->cpu, ret = 0, cpu;
>  	struct task_struct *p;
>  	struct rq *src_rq;
> +	struct cpumask *high_mask = __get_cpu_var(high_cpu_mask);
> +	int prio = 0;
> 
>  	if (likely(!rt_overloaded(this_rq)))
>  		return 0;
> +loop:
> +	if (! (prio < this_rq->rt.highest_prio.curr))
> +		return ret;
> +
> +	if (! cpupri_find_prio(&this_rq->rd->cpupri, prio,
> +				this_rq->rd->rto_mask, high_mask)) {
> +		prio++;
> +		goto loop;
> +	}

This loop looks to be expensive in the hot path.

Note, in practice, not many RT tasks are running at the same time. If
this is not the case, then please explain what situation has multiple RT
tasks contending for more than one CPU where RT tasks are forced to
migrate continuously, and this patch fixes the situation.

I understand that the current code looks a bit expensive, as it loops
through the CPUs that are overloaded, and pulls over the RT tasks
waiting to run that are of higher priority than the one currently on
this task. If it picks wrong, it could potentially pull over more than
one task.

But in practice (and I've traced this a while back), it seldom ever
happens.

But if you see that this code is hitting the slow path constantly, and
your code shows better performance, and you can demonstrate this via a
benchmark that I could use to reproduce, then I will consider taking
these changes.

-- Steve


> 
> -	for_each_cpu(cpu, this_rq->rd->rto_mask) {
> -		if (this_cpu == cpu)
> -			continue;
> +	if (cpumask_test_cpu(this_cpu, high_mask))
> +		/* no efforts needed if this RQ is high enough in prio */
> +		return ret;
> +
> +	for_each_cpu(cpu, high_mask) {
> 
>  		src_rq = cpu_rq(cpu);
> 
> @@ -1508,8 +1523,13 @@ static int pull_rt_task(struct rq *this_
>  		}
>  skip:
>  		double_unlock_balance(this_rq, src_rq);
> +		if (ret)
> +			goto done;
>  	}
> 
> +	prio++;
> +	goto loop;
> +done:
>  	return ret;
>  }
> 
> @@ -1630,9 +1650,12 @@ static inline void init_sched_rt_class(v
>  {
>  	unsigned int i;
> 
> -	for_each_possible_cpu(i)
> +	for_each_possible_cpu(i) {
>  		zalloc_cpumask_var_node(&per_cpu(local_cpu_mask, i),
>  					GFP_KERNEL, cpu_to_node(i));
> +		zalloc_cpumask_var_node(&per_cpu(high_cpu_mask, i),
> +					GFP_KERNEL, cpu_to_node(i));
> +	}
>  }
>  #endif /* CONFIG_SMP */
> 
> --- tip-git/kernel/sched_cpupri.h	Sat May 14 15:21:56 2011
> +++ sched_cpupri.h	Sat May 28 21:29:26 2011
> @@ -26,6 +26,7 @@ struct cpupri {
>  #ifdef CONFIG_SMP
>  int  cpupri_find(struct cpupri *cp,
>  		 struct task_struct *p, struct cpumask *lowest_mask);
> +int cpupri_find_prio(struct cpupri *,int, struct cpumask *, struct cpumask *);
>  void cpupri_set(struct cpupri *cp, int cpu, int pri);
>  int cpupri_init(struct cpupri *cp);
>  void cpupri_cleanup(struct cpupri *cp);
> --- tip-git/kernel/sched_cpupri.c	Sat May 14 15:21:56 2011
> +++ sched_cpupri.c	Sat May 28 21:46:51 2011
> @@ -202,3 +202,33 @@ void cpupri_cleanup(struct cpupri *cp)
>  	for (i = 0; i < CPUPRI_NR_PRIORITIES; i++)
>  		free_cpumask_var(cp->pri_to_cpu[i].mask);
>  }
> +
> +/*
> + * cpupri_find_prio - find CPUs for a given prio
> + * @cp: The cpupri context
> + * @task_prio: The given prio for which CPUs are slected
> + * @filter_mask: A mask to filter selected CPUs
> + * @ret_mask: A mask to fill in with selected CPUs
> + *
> + * Returns: (int)bool - CPUs were found
> + */
> +int cpupri_find_prio(struct cpupri *cp, int task_prio,
> +			struct cpumask *filter_mask,
> +			struct cpumask *ret_mask)
> +{
> +	task_prio = convert_prio(task_prio);
> +
> +	if (cp->pri_active[task_prio / BITS_PER_LONG] &
> +		  (1UL << (task_prio % BITS_PER_LONG))) {
> +
> +		struct cpupri_vec *vec  = &cp->pri_to_cpu[task_prio];
> +
> +		cpumask_and(ret_mask, filter_mask, vec->mask);
> +
> +		if (cpumask_any(ret_mask) < nr_cpu_ids)
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +


