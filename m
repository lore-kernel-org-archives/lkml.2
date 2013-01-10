Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab3AJRRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:17:31 -0500
Received: from service87.mimecast.com ([91.220.42.44]:44456 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3AJRRa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:17:30 -0500
Date: Thu, 10 Jan 2013 17:17:29 +0000
From: Morten Rasmussen <Morten.Rasmussen@arm.com>
To: Alex Shi <alex.shi@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 17/22] sched: packing small tasks in wake/exec
 balancing
Message-ID: <20130110171728.GG2046@e103034-lin>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
 <1357375071-11793-18-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
In-Reply-To: <1357375071-11793-18-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 10 Jan 2013 17:17:24.0787 (UTC) FILETIME=[5BAC8030:01CDEF56]
X-MC-Unique: 113011017172704201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 08:37:46AM +0000, Alex Shi wrote:
> If the wake/exec task is small enough, utils < 12.5%, it will
> has the chance to be packed into a cpu which is busy but still has space to
> handle it.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 51 +++++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 45 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 8d0d3af..0596e81 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3471,19 +3471,57 @@ static inline int get_sd_sched_policy(struct sched_domain *sd,
>  }
>  
>  /*
> + * find_leader_cpu - find the busiest but still has enough leisure time cpu
> + * among the cpus in group.
> + */
> +static int
> +find_leader_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
> +{
> +	unsigned vacancy, min_vacancy = UINT_MAX;

unsigned int?

> +	int idlest = -1;
> +	int i;
> +	/* percentage the task's util */
> +	unsigned putil = p->se.avg.runnable_avg_sum * 100
> +				/ (p->se.avg.runnable_avg_period + 1);

Alternatively you could use se.avg.load_avg_contrib which is the same
ratio scaled by the task priority (se->load.weight). In the above
expression you don't take priority into account.

> +
> +	/* Traverse only the allowed CPUs */
> +	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
> +		struct rq *rq = cpu_rq(i);
> +		int nr_running = rq->nr_running > 0 ? rq->nr_running : 1;
> +
> +		/* only pack task which putil < 12.5% */
> +		vacancy = FULL_UTIL - (rq->util * nr_running + putil * 8);

I can't follow this expression.

The variables can have the following values:
FULL_UTIL  = 99
rq->util   = [0..99]
nr_running = [1..inf]
putil      = [0..99]

Why multiply rq->util by nr_running?

Let's take an example where rq->util = 50, nr_running = 2, and putil =
10. In this case the value of putil doesn't really matter as vacancy
would be negative anyway since FULL_UTIL - rq->util * nr_running is -1.
However, with rq->util = 50 there should be plenty of spare cpu time to
take another task.

Also, why multiply putil by 8? rq->util must be very close to 0 for
vacancy to be positive if putil is close to 12 (12.5%).

The vacancy variable is declared unsigned, so it will underflow instead
of becoming negative. Is this intentional?

I may be missing something, but could the expression be something like
the below instead?

Create a putil < 12.5% check before the loop. There is no reason to
recheck it every iteration. Then:

vacancy = FULL_UTIL - (rq->util + putil)

should be enough?

> +
> +		/* bias toward local cpu */
> +		if (vacancy > 0 && (i == this_cpu))
> +			return i;
> +
> +		if (vacancy > 0 && vacancy < min_vacancy) {
> +			min_vacancy = vacancy;
> +			idlest = i;

"idlest" may be a bit misleading here as you actually select busiest cpu
that have enough spare capacity to take the task.

Morten

> +		}
> +	}
> +	return idlest;
> +}
> +
> +/*
>   * If power policy is eligible for this domain, and it has task allowed cpu.
>   * we will select CPU from this domain.
>   */
>  static int get_cpu_for_power_policy(struct sched_domain *sd, int cpu,
> -		struct task_struct *p, struct sd_lb_stats *sds)
> +		struct task_struct *p, struct sd_lb_stats *sds, int fork)
>  {
>  	int policy;
>  	int new_cpu = -1;
>  
>  	policy = get_sd_sched_policy(sd, cpu, p, sds);
> -	if (policy != SCHED_POLICY_PERFORMANCE && sds->group_leader)
> -		new_cpu = find_idlest_cpu(sds->group_leader, p, cpu);
> -
> +	if (policy != SCHED_POLICY_PERFORMANCE && sds->group_leader) {
> +		if (!fork)
> +			new_cpu = find_leader_cpu(sds->group_leader, p, cpu);
> +		/* for fork balancing and a little busy task */
> +		if (new_cpu == -1)
> +			new_cpu = find_idlest_cpu(sds->group_leader, p, cpu);
> +	}
>  	return new_cpu;
>  }
>  
> @@ -3534,14 +3572,15 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
>  		if (tmp->flags & sd_flag) {
>  			sd = tmp;
>  
> -			new_cpu = get_cpu_for_power_policy(sd, cpu, p, &sds);
> +			new_cpu = get_cpu_for_power_policy(sd, cpu, p, &sds,
> +						flags & SD_BALANCE_FORK);
>  			if (new_cpu != -1)
>  				goto unlock;
>  		}
>  	}
>  
>  	if (affine_sd) {
> -		new_cpu = get_cpu_for_power_policy(affine_sd, cpu, p, &sds);
> +		new_cpu = get_cpu_for_power_policy(affine_sd, cpu, p, &sds, 0);
>  		if (new_cpu != -1)
>  			goto unlock;
>  
> -- 
> 1.7.12
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

