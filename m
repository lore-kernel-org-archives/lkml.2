Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595Ab2INRRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:17:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759508Ab2INRRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:17:17 -0400
Date: Fri, 14 Sep 2012 19:10:38 +0200
From: Andrew Jones <drjones@redhat.com>
To: Andrew Theurer <habanero@linux.vnet.ibm.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [RFC][PATCH] Improving directed yield scalability for PLE handler
Message-ID: <20120914171038.GB8834@turtle.usersys.redhat.com>
References: <20120908084345.GU30238@linux.vnet.ibm.com>
 <1347283005.10325.55.camel@oc6622382223.ibm.com>
 <1347293035.2124.22.camel@twins>
 <20120910165653.GA28033@linux.vnet.ibm.com>
 <1347297124.2124.42.camel@twins>
 <1347307972.7332.78.camel@oc2024037011.ibm.com>
 <504ED54E.6040608@linux.vnet.ibm.com>
 <1347388061.19098.20.camel@oc2024037011.ibm.com>
 <20120913114813.GA11797@linux.vnet.ibm.com>
 <1347571858.5586.44.camel@oc2024037011.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347571858.5586.44.camel@oc2024037011.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 04:30:58PM -0500, Andrew Theurer wrote:
> On Thu, 2012-09-13 at 17:18 +0530, Raghavendra K T wrote:
> > * Andrew Theurer <habanero@linux.vnet.ibm.com> [2012-09-11 13:27:41]:
> > 
> > > On Tue, 2012-09-11 at 11:38 +0530, Raghavendra K T wrote:
> > > > On 09/11/2012 01:42 AM, Andrew Theurer wrote:
> > > > > On Mon, 2012-09-10 at 19:12 +0200, Peter Zijlstra wrote:
> > > > >> On Mon, 2012-09-10 at 22:26 +0530, Srikar Dronamraju wrote:
> > > > >>>> +static bool __yield_to_candidate(struct task_struct *curr, struct task_struct *p)
> > > > >>>> +{
> > > > >>>> +     if (!curr->sched_class->yield_to_task)
> > > > >>>> +             return false;
> > > > >>>> +
> > > > >>>> +     if (curr->sched_class != p->sched_class)
> > > > >>>> +             return false;
> > > > >>>
> > > > >>>
> > > > >>> Peter,
> > > > >>>
> > > > >>> Should we also add a check if the runq has a skip buddy (as pointed out
> > > > >>> by Raghu) and return if the skip buddy is already set.
> > > > >>
> > > > >> Oh right, I missed that suggestion.. the performance improvement went
> > > > >> from 81% to 139% using this, right?
> > > > >>
> > > > >> It might make more sense to keep that separate, outside of this
> > > > >> function, since its not a strict prerequisite.
> > > > >>
> > > > >>>>
> > > > >>>> +     if (task_running(p_rq, p) || p->state)
> > > > >>>> +             return false;
> > > > >>>> +
> > > > >>>> +     return true;
> > > > >>>> +}
> > > > >>
> > > > >>
> > > > >>>> @@ -4323,6 +4340,10 @@ bool __sched yield_to(struct task_struct *p,
> > > > >>> bool preempt)
> > > > >>>>        rq = this_rq();
> > > > >>>>
> > > > >>>>   again:
> > > > >>>> +     /* optimistic test to avoid taking locks */
> > > > >>>> +     if (!__yield_to_candidate(curr, p))
> > > > >>>> +             goto out_irq;
> > > > >>>> +
> > > > >>
> > > > >> So add something like:
> > > > >>
> > > > >> 	/* Optimistic, if we 'raced' with another yield_to(), don't bother */
> > > > >> 	if (p_rq->cfs_rq->skip)
> > > > >> 		goto out_irq;
> > > > >>>
> > > > >>>
> > > > >>>>        p_rq = task_rq(p);
> > > > >>>>        double_rq_lock(rq, p_rq);
> > > > >>>
> > > > >>>
> > > > >> But I do have a question on this optimization though,.. Why do we check
> > > > >> p_rq->cfs_rq->skip and not rq->cfs_rq->skip ?
> > > > >>
> > > > >> That is, I'd like to see this thing explained a little better.
> > > > >>
> > > > >> Does it go something like: p_rq is the runqueue of the task we'd like to
> > > > >> yield to, rq is our own, they might be the same. If we have a ->skip,
> > > > >> there's nothing we can do about it, OTOH p_rq having a ->skip and
> > > > >> failing the yield_to() simply means us picking the next VCPU thread,
> > > > >> which might be running on an entirely different cpu (rq) and could
> > > > >> succeed?
> > > > >
> > > > > Here's two new versions, both include a __yield_to_candidate(): "v3"
> > > > > uses the check for p_rq->curr in guest mode, and "v4" uses the cfs_rq
> > > > > skip check.  Raghu, I am not sure if this is exactly what you want
> > > > > implemented in v4.
> > > > >
> > > > 
> > > > Andrew, Yes that is what I had. I think there was a mis-understanding. 
> > > > My intention was to if there is a directed_yield happened in runqueue 
> > > > (say rqA), do not bother to directed yield to that. But unfortunately as 
> > > > PeterZ pointed that would have resulted in setting next buddy of a 
> > > > different run queue than rqA.
> > > > So we can drop this "skip" idea. Pondering more over what to do? can we 
> > > > use next buddy itself ... thinking..
> > > 
> > > As I mentioned earlier today, I did not have your changes from kvm.git
> > > tree when I tested my changes.  Here are your changes and my changes
> > > compared:
> > > 
> > > 			  throughput in MB/sec
> > > 
> > > kvm_vcpu_on_spin changes:  4636 +/- 15.74%
> > > yield_to changes:	   4515 +/- 12.73%
> > > 
> > > I would be inclined to stick with your changes which are kept in kvm
> > > code.  I did try both combined, and did not get good results:
> > > 
> > > both changes:		   4074 +/- 19.12%
> > > 
> > > So, having both is probably not a good idea.  However, I feel like
> > > there's more work to be done.  With no over-commit (10 VMs), total
> > > throughput is 23427 +/- 2.76%.  A 2x over-commit will no doubt have some
> > > overhead, but a reduction to ~4500 is still terrible.  By contrast,
> > > 8-way VMs with 2x over-commit have a total throughput roughly 10% less
> > > than 8-way VMs with no overcommit (20 vs 10 8-way VMs on 80 cpu-thread
> > > host).  We still have what appears to be scalability problems, but now
> > > it's not so much in runqueue locks for yield_to(), but now
> > > get_pid_task():
> > >
> > 
> > Hi Andrew,
> > IMHO, reducing the double runqueue lock overhead is a good idea,
> > and may be  we see the benefits when we increase the overcommit further.
> > 
> > The explaination for not seeing good benefit on top of PLE handler
> > optimization patch is because we filter the yield_to candidates,
> > and hence resulting in less contention for double runqueue lock.
> > and extra code overhead during genuine yield_to might have resulted in
> > some degradation in the case you tested.
> > 
> > However, did you use cfs.next also?. I hope it helps, when we combine.
> > 
> > Here is the result that is showing positive benefit.
> > I experimented on a 32 core (no HT) PLE machine with 32 vcpu guest(s).
> >   
> > +-----------+-----------+-----------+------------+-----------+
> >         kernbench time in sec, lower is better 
> > +-----------+-----------+-----------+------------+-----------+
> >        base      stddev     patched     stddev      %improve
> > +-----------+-----------+-----------+------------+-----------+
> > 1x    44.3880     1.8699    40.8180     1.9173	   8.04271
> > 2x    96.7580     4.2787    93.4188     3.5150	   3.45108
> > +-----------+-----------+-----------+------------+-----------+
> > 
> > 
> > +-----------+-----------+-----------+------------+-----------+
> >         ebizzy record/sec higher is better
> > +-----------+-----------+-----------+------------+-----------+
> >        base      stddev     patched     stddev      %improve
> > +-----------+-----------+-----------+------------+-----------+
> > 1x  2374.1250    50.9718   3816.2500    54.0681	  60.74343
> > 2x  2536.2500    93.0403   2789.3750   204.7897	   9.98029
> > +-----------+-----------+-----------+------------+-----------+
> > 
> > 
> > Below is the patch which combine suggestions of peterZ on your
> > original approach with cfs.next (already posted by Srikar in the other
> > thread)
> 
> I did get a chance to run with the below patch and your changes in
> kvm.git, but the results were not too different:
> 
> Dbench, 10 x 16-way VMs on 80-way host:
> 
> kvm_vcpu_on_spin changes:  4636 +/- 15.74%
> yield_to changes:	   4515 +/- 12.73%
> both changes from above:   4074 +/- 19.12%
> ...plus cfs.next check:    4418 +/- 16.97%
> 
> Still hovering around 4500 MB/sec
> 
> The concern I have is that even though we have gone through changes to
> help reduce the candidate vcpus we yield to, we still have a very poor
> idea of which vcpu really needs to run.  The result is high cpu usage in
> the get_pid_task and still some contention in the double runqueue lock.
> To make this scalable, we either need to significantly reduce the
> occurrence of the lock-holder preemption, or do a much better job of
> knowing which vcpu needs to run (and not unnecessarily yielding to vcpus
> which do not need to run).
> 
> On reducing the occurrence:  The worst case for lock-holder preemption
> is having vcpus of same VM on the same runqueue.  This guarantees the
> situation of 1 vcpu running while another [of the same VM] is not.  To
> prove the point, I ran the same test, but with vcpus restricted to a
> range of host cpus, such that any single VM's vcpus can never be on the
> same runqueue.  In this case, all 10 VMs' vcpu-0's are on host cpus 0-4,
> vcpu-1's are on host cpus 5-9, and so on.  Here is the result:
> 
> kvm_cpu_spin, and all
> yield_to changes, plus
> restricted vcpu placement:  8823 +/- 3.20%   much, much better
> 
> On picking a better vcpu to yield to:  I really hesitate to rely on
> paravirt hint [telling us which vcpu is holding a lock], but I am not
> sure how else to reduce the candidate vcpus to yield to.  I suspect we
> are yielding to way more vcpus than are prempted lock-holders, and that
> IMO is just work accomplishing nothing.  Trying to think of way to
> further reduce candidate vcpus....
>

wrt to yielding to vcpus for the same cpu, I recently noticed that
there's a bug in yield_to_task_fair. yield_task_fair() calls
clear_buddies(), so if we're yielding to a task that has been running on
the same cpu that we're currently running on, and thus is also on the
current cfs runqueue, then our 'who to pick next' hint is getting cleared
right after we set it.

I had hoped that the patch below would show a general improvement in the
vpu overcommit performance, however the results were variable - no worse,
no better. Based on your results above showing good improvement from
interleaving vcpus across the cpus, then that means there was a decent
percent of these types of yields going on. So since the patch didn't
change much that indicates that the next hinting isn't generally taken
too seriously by the scheduler.  Anyway, the patch should correct the
code per its design, and testing shows that it didn't make anything worse,
so I'll post it soon. Also, in order to try and improve how far set-next
can jump ahead in the queue, I tested a kernel with group scheduling
compiled out (libvirt uses cgroups and I'm not sure autogroups may affect
things). I did get slight improvement with that, but nothing to write home
to mom about.

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c219bf8..7d8a21d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3037,11 +3037,12 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preemp
 	if (!se->on_rq || throttled_hierarchy(cfs_rq_of(se)))
 		return false;
 
+	/* We're yielding, so tell the scheduler we don't want to be picked */
+	yield_task_fair(rq);
+
 	/* Tell the scheduler that we'd really like pse to run next. */
 	set_next_buddy(se);
 
-	yield_task_fair(rq);
-
 	return true;
 }

> 
> > 
> > ----8<----
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index fbf1fd0..8551f57 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -4820,6 +4820,24 @@ void __sched yield(void)
> >  }
> >  EXPORT_SYMBOL(yield);
> > 
> > +/*
> > + * Tests preconditions required for sched_class::yield_to().
> > + */
> > +static bool __yield_to_candidate(struct task_struct *curr, struct task_struct *p,
> > +					 struct rq *p_rq)
> > +{
> > +	if (!curr->sched_class->yield_to_task)
> > +		return false;
> > +
> > +	if (curr->sched_class != p->sched_class)
> > +		return false;
> > +
> > +	if (task_running(p_rq, p) || p->state)
> > +		return false;
> > +
> > +	return true;
> > +}
> > +
> >  /**
> >   * yield_to - yield the current processor to another thread in
> >   * your thread group, or accelerate that thread toward the
> > @@ -4844,20 +4862,24 @@ bool __sched yield_to(struct task_struct *p, bool preempt)
> > 
> >  again:
> >  	p_rq = task_rq(p);
> > +
> > +	/* optimistic test to avoid taking locks */
> > +	if (!__yield_to_candidate(curr, p, p_rq))
> > +		goto out_irq;
> > +
> > +	/* if next buddy is set, assume yield is in progress */
> > +	if (p_rq->cfs.next)
> > +		goto out_irq;
> > +
> >  	double_rq_lock(rq, p_rq);
> >  	while (task_rq(p) != p_rq) {
> >  		double_rq_unlock(rq, p_rq);
> >  		goto again;
> >  	}
> > 
> > -	if (!curr->sched_class->yield_to_task)
> > -		goto out;
> > -
> > -	if (curr->sched_class != p->sched_class)
> > -		goto out;
> > -
> > -	if (task_running(p_rq, p) || p->state)
> > -		goto out;
> > +	/* validate state, holding p_rq ensures p's state cannot change */
> > +	if (!__yield_to_candidate(curr, p, p_rq))
> > +		goto out_unlock;
> > 
> >  	yielded = curr->sched_class->yield_to_task(rq, p, preempt);
> >  	if (yielded) {
> > @@ -4877,8 +4899,9 @@ again:
> >  		rq->skip_clock_update = 0;
> >  	}
> > 
> > -out:
> > +out_unlock:
> >  	double_rq_unlock(rq, p_rq);
> > +out_irq:
> >  	local_irq_restore(flags);
> > 
> >  	if (yielded)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
