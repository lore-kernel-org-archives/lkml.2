Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2FMO4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:56:01 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:56437 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab2FMOz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:55:59 -0400
Date: Wed, 13 Jun 2012 20:25:49 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org, efault@gmx.de,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] sched: balance_cpu to consider other cpus in its
 group as target of (pinned) task
Message-ID: <20120613145549.GB22596@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <4FCF55E3.3020900@linux.vnet.ibm.com>
 <1339590696.8980.21.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1339590696.8980.21.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12061314-2000-0000-0000-000007E7CE05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-06-13 14:31:36]:

> > Current load balance scheme lets one cpu in a sched_group (balance_cpu)
> > look at other peer sched_groups for imbalance and pull tasks to
> > itself from a busy cpu. Tasks thus pulled to balance_cpu will later get
> > picked up by cpus that are in the same sched_group as that of balance_cpu.
> 
> Not strictly true.. but close enough I think.

Do you mean that tasks pulled by balance_cpu could in turn get pulled by a cpu 
outside the balance_cpu's sched_group (before its sibling cpus have had
a chance to pull them)? Yes that's a possibility, but we should less of it in 
practice. Will put a comment to that effect in next version.

> If you can come up with a relatively simple example without rt tasks
> that would be preferred. Also I think the above description could be
> improved.
> 
> The graph only confuses me and I'm not sure the description is maximally
> concise either.

Ok ..we will take a shot at making it more concise and better ..

> > Some solutions that were considered to solve this problem were:
> > 
> > - Have the right sibling cpus to do load balance ignoring balance_cpu
> > 
> > - Modify move_tasks to move a pinned tasks to a sibling cpu in the
> >   same sched_group as env->dst_cpu. This will involve some runqueue
> >   lock juggling (a third runqueue locks needs to be taken when we
> >   already have two locks held). Moreover we may be just fine to ignore
> >   that particular task and meet load balance goals by moving other
> >   tasks.
> > 
> > - Hint that move_tasks should be called with a different env->dst_cpu

I guess another approach is to try a different env->src_cpu, which still
seems to be more invasive than what is proposed here.

> Still no word on why doing a 3-way pull is ok.. (I think it is, I just
> want you to convince me)..

One theroretical problem that can arise with a generic 3-way pull is two cpus 
deciding what load should move towards a given cpu (and not syncing with each 
other in the process). Say that C1 and C2 decide (at nearly same time) that load
X should get moved from C4 to C0.  They don't realize each other's decision and 
together end up moving twice that load to C0.

Now that seems remote as we are restricting who can decide on load movement 
towards a given cpu - essentially the given cpu itself or its balance_cpu with 
this patch applied. The source cpu in each case being different (given
cpu will attempt pulling from sibling cpus while balance_cpu will attempt to 
pull from a cpu in sibling group), I can't see how the two can conflict with 
each other's decisions.

There is however the remotest possibility that load_balance in context of a
given balance_cpu is performed concurrently (and thus lead to the
theoretical problem described above). Let's say that balance_cpu
was nohz-idle and some ilb_cpu started doing load_balance on its behalf. 
Before it could finish (its vcpu got preempted?), balance_cpu became active and 
started running load_balance by itself. These two load_balance() actions could 
lead to conflicting decisions. This may not happen so much in practice though?
Alternately we can validate find_busiest_group and friend's assumption of 
this_cpu's load (once this_rq lock is taken).


> > +#define LBF_NEW_DST_CPU	0x04
> 
> I still don't really like the new_dst_cpu name, I think it is because it
> describes a solution detail, not a problem diagnosis.

LBF_SOME_PINNED? LBF_SOME_TASKS_PINNED?

> > +		} else {
> > +			env->flags |= LBF_NEW_DST_CPU;
> > +			env->new_dst_cpu = new_dst_cpu;
> > +		}

[snip]

> This wants a comment describing why we're doing this.. this also wants a
> comment describing why we do what we do about multiple new_dst.. I think
> we should do the cheap thing and not compute a new dst if we already
> have one.

Yeah given that cpumask can be long in some platforms?

> For bonus points you'll also add a comment for the all pinned muck,
> although that's somewhat more obvious.

Ok!

> > -	int ld_moved, active_balance = 0;
> > +	int ld_moved, cur_ld_moved, active_balance = 0;
> 
> better than the old_ld_moved, but still not really obvious.. maybe we
> can cure this with a comment... 

Ok ..we will take a shot at improving this.

> > @@ -4514,8 +4538,23 @@ more_balance:
> >  		/*
> >  		 * some other cpu did the load balance for us.
> 
> so add something here describing the cur_ld_moved vs ld_moved thing..

Ok ..

> > +		if ((env.flags & LBF_NEW_DST_CPU) && (env.imbalance > 0)) {
> 
> Is this different from the last version?, ISTR only doing the loop again
> when we didn't move anything.

Hmm ..this bit has not changed since last version. We may have moved
some load but still failed short of meeting target (because of some pinned
task), in which case we just retry with a new dst_cpu.

> > +			/*
> > +			 * we could not balance completely as some tasks
> > +			 * were not allowed to move to the dst_cpu, so try
> > +			 * again with new_dst_cpu.
> > +			 */
> > +			this_rq = cpu_rq(env.new_dst_cpu);
> > +			env.dst_rq = this_rq;
> > +			env.dst_cpu = env.new_dst_cpu;
> > +			env.flags &= ~LBF_NEW_DST_CPU;
> > +			env.loop = 0;
> > +			env.loop_break = sched_nr_migrate_break;
> > +			goto more_balance;
> 
> What guarantees there's an end to this iteration?

We clear LBF_NEW_DST_CPU flag each time and so unless someone is
cleverly racing with us by modifying a task's cpus_allowed mask I can't
see how this can lead to a forever loop. Nevertheless I think it's good
that we put a check there for it! Will take a stab at it in next
version.

> Also we explicitly use
> more_balance over redo so that we're sure to iterate the same src cpu
> because otherwise our new dst_cpu is meaningless?

Yep.

> Sounds like something
> that would be good to mention in .. wait for it .. a comment?

Ok!

> > +			.dst_grpmask	= NULL,
> 
> This is superfluous, c99 initialization zeros all unmentioned members.

Ok ...we will fix in next version. Thanks for your feedback!

- vatsa

