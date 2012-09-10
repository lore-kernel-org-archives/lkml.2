Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2IJRAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:00:39 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:37997 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab2IJRAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:00:37 -0400
Date: Mon, 10 Sep 2012 22:26:53 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: habanero@linux.vnet.ibm.com,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [RFC][PATCH] Improving directed yield scalability for PLE
 handler
Message-ID: <20120910165653.GA28033@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120718133717.5321.71347.sendpatchset@codeblue.in.ibm.com>
 <500D2162.8010209@redhat.com>
 <1347023509.10325.53.camel@oc6622382223.ibm.com>
 <504A37B0.7020605@linux.vnet.ibm.com>
 <1347046931.7332.51.camel@oc2024037011.ibm.com>
 <20120908084345.GU30238@linux.vnet.ibm.com>
 <1347283005.10325.55.camel@oc6622382223.ibm.com>
 <1347293035.2124.22.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1347293035.2124.22.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12091017-2674-0000-0000-000005EDDD20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-09-10 18:03:55]:

> On Mon, 2012-09-10 at 08:16 -0500, Andrew Theurer wrote:
> > > > @@ -4856,8 +4859,6 @@ again:
> > > >     if (curr->sched_class != p->sched_class)
> > > >             goto out;
> > > > 
> > > > -   if (task_running(p_rq, p) || p->state)
> > > > -           goto out;
> > > 
> > > Is it possible that by this time the current thread takes double rq
> > > lock, thread p could actually be running?  i.e is there merit to keep
> > > this check around even with your similar check above?
> > 
> > I think that's a good idea.  I'll add that back in. 
> 
> Right, it needs to still be there, the test before acquiring p_rq is an
> optimistic test to avoid work, but you have to still test it once you
> acquire p_rq since the rest of the code relies on this not being so.
> 
> How about something like this instead.. ?
> 
> ---
>  kernel/sched/core.c | 35 ++++++++++++++++++++++++++---------
>  1 file changed, 26 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index c46a011..c9ecab2 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4300,6 +4300,23 @@ void __sched yield(void)
>  }
>  EXPORT_SYMBOL(yield);
>  
> +/*
> + * Tests preconditions required for sched_class::yield_to().
> + */
> +static bool __yield_to_candidate(struct task_struct *curr, struct task_struct *p)
> +{
> +	if (!curr->sched_class->yield_to_task)
> +		return false;
> +
> +	if (curr->sched_class != p->sched_class)
> +		return false;


Peter, 

Should we also add a check if the runq has a skip buddy (as pointed out
by Raghu) and return if the skip buddy is already set.  Something akin
to 

	if (p_rq->cfs_rq->skip)
		return false;

So if somebody has already acquired a double run queue lock and almost
set the next buddy, we dont need to take run queue lock and also avoid
overwriting the already set skip buddy.

> +
> +	if (task_running(p_rq, p) || p->state)
> +		return false;
> +
> +	return true;
> +}
> +
>  /**
>   * yield_to - yield the current processor to another thread in
>   * your thread group, or accelerate that thread toward the
> @@ -4323,6 +4340,10 @@ bool __sched yield_to(struct task_struct *p, bool preempt)
>  	rq = this_rq();
>  
>  again:
> +	/* optimistic test to avoid taking locks */
> +	if (!__yield_to_candidate(curr, p))
> +		goto out_irq;
> +
>  	p_rq = task_rq(p);
>  	double_rq_lock(rq, p_rq);
>  	while (task_rq(p) != p_rq) {
> @@ -4330,14 +4351,9 @@ bool __sched yield_to(struct task_struct *p, bool preempt)
>  		goto again;
>  	}
>  
> -	if (!curr->sched_class->yield_to_task)
> -		goto out;
> -
> -	if (curr->sched_class != p->sched_class)
> -		goto out;
> -
> -	if (task_running(p_rq, p) || p->state)
> -		goto out;
> +	/* validate state, holding p_rq ensures p's state cannot change */
> +	if (!__yield_to_candidate(curr, p))
> +		goto out_unlock;
>  
>  	yielded = curr->sched_class->yield_to_task(rq, p, preempt);
>  	if (yielded) {
> @@ -4350,8 +4366,9 @@ bool __sched yield_to(struct task_struct *p, bool preempt)
>  			resched_task(p_rq->curr);
>  	}
>  
> -out:
> +out_unlock:
>  	double_rq_unlock(rq, p_rq);
> +out_irq:
>  	local_irq_restore(flags);
>  
>  	if (yielded)
> 

