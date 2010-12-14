Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab0LNGIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 01:08:23 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:39171 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751625Ab0LNGIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 01:08:22 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX188uPRSDg48lLLw8x1iPgdNXQ5l0UC9nx4EM3lakD
	wTJIfHkMnehOsG
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <efault@gmx.de>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20101213224657.7e141746@annuminas.surriel.com>
References: <20101213224434.7495edb2@annuminas.surriel.com>
	 <20101213224657.7e141746@annuminas.surriel.com>
Content-Type: text/plain
Date: Tue, 14 Dec 2010 07:08:16 +0100
Message-Id: <1292306896.7448.157.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 22:46 -0500, Rik van Riel wrote:

> diff --git a/kernel/sched.c b/kernel/sched.c
> index dc91a4d..6399641 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5166,6 +5166,46 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
>  	return ret;
>  }
>  
> +/*
> + * Yield the CPU, giving the remainder of our time slice to task p.
> + * Typically used to hand CPU time to another thread inside the same
> + * process, eg. when p holds a resource other threads are waiting for.
> + * Giving priority to p may help get that resource released sooner.
> + */
> +void yield_to(struct task_struct *p)
> +{
> +	unsigned long flags;
> +	struct rq *rq, *p_rq;
> +
> +	local_irq_save(flags);
> +	rq = this_rq();
> +again:
> +	p_rq = task_rq(p);
> +	double_rq_lock(rq, p_rq);
> +	if (p_rq != task_rq(p)) {
> +		double_rq_unlock(rq, p_rq);
> +		goto again;
> +	}
> +
> +	/* We can't yield to a process that doesn't want to run. */
> +	if (!p->se.on_rq)
> +		goto out;
> +
> +	/*
> +	 * We can only yield to a runnable task, in the same schedule class
> +	 * as the current task, if the schedule class implements yield_to_task.
> +	 */
> +	if (!task_running(rq, p) && current->sched_class == p->sched_class &&
> +			current->sched_class->yield_to)
> +		current->sched_class->yield_to(rq, p);
> +
> +out:
> +	double_rq_unlock(rq, p_rq);
> +	local_irq_restore(flags);
> +	yield();
> +}
> +EXPORT_SYMBOL_GPL(yield_to);

That part looks ok, except for the yield cross cpu bit.  Trying to yield
a resource you don't have doesn't make much sense to me.

>  /**
>   * sys_sched_yield - yield the current processor to other threads.
>   *
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 00ebd76..d8c4116 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -980,6 +980,25 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
>   * CFS operations on tasks:
>   */
>  
> +u64 slice_remain(struct task_struct *p)
> +{
> +	unsigned long flags;
> +	struct sched_entity *se = &p->se;
> +	struct cfs_rq *cfs_rq;
> +	struct rq *rq;
> +	u64 slice, ran;
> +	s64 delta;
> +
> +	rq = task_rq_lock(p, &flags);
> +	cfs_rq = cfs_rq_of(se);
> +	slice = sched_slice(cfs_rq, se);
> +	ran = se->sum_exec_runtime - se->prev_sum_exec_runtime;
> +	delta = slice - ran;
> +	task_rq_unlock(rq, &flags);
> +
> +	return max(delta, 0LL);
> +}

<ramble>
slice_remain() measures the distance to your last preemption, which has
no relationship with entitlement.  sched_slice() is not used to issue
entitlement, it's only a ruler.

You have entitlement on your current runqueue only, that entitlement
being the instantaneous distance to min_vruntime in a closed and fluid
system.  You can't inject some instantaneous relationship from one
closed system into an another without making the math go kind of fuzzy,
so you need tight constraints on how fuzzy it can get.

We do that with migrations, inject fuzz.  There is no global fair-stick,
but we invent one by injecting little bits of fuzz.  It's constrained by
chaos and the magnitude constraints of the common engine.  The more you
migrate, the more tightly you couple systems.  As long as we stay fairly
well balanced, we can migrate without the fuzz getting out of hand, and
end up with a globally ~fair system.

What you're injecting isn't instantaneously irrelevant lag-fuzz, which
distributed over time becomes relevant. you're inventing entitlement out
of the void.  Likely not a big hairy deal unless you do it frequently,
but you're doing something completely bogus and seemingly unconstrained.
</ramble>

>  #ifdef CONFIG_SCHED_HRTICK
>  static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
>  {
> @@ -1126,6 +1145,20 @@ static void yield_task_fair(struct rq *rq)
>  	se->vruntime = rightmost->vruntime + 1;
>  }
>  
> +static void yield_to_fair(struct rq *rq, struct task_struct *p)
> +{
> +	struct sched_entity *se = &p->se;
> +	struct cfs_rq *cfs_rq = cfs_rq_of(se);
> +	u64 remain = slice_remain(current);
> +
> +	dequeue_task(rq, p, 0);
> +	se->vruntime -= remain;
> +	if (se->vruntime < cfs_rq->min_vruntime)
> +		se->vruntime = cfs_rq->min_vruntime;

This has an excellent chance of moving the recipient rightward.. and the
yielding task didn't yield anything.  This may achieve the desired
result or may just create a nasty latency spike... but it makes no
arithmetic sense.

	-Mike

