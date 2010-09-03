Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab0ICH7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 03:59:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:36484 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab0ICH7r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 03:59:47 -0400
Subject: Re: [RFC][PATCH 1/3] sched: Rewrite tg_shares_up
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>
In-Reply-To: <AANLkTi=ugQbFNV2h-wQkoTBkQgFvDXEzwctgch8XpWVB@mail.gmail.com>
References: <20100828223025.054328145@chello.nl>
	 <20100828223546.952988054@chello.nl>
	 <AANLkTi=ugQbFNV2h-wQkoTBkQgFvDXEzwctgch8XpWVB@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Sep 2010 09:59:35 +0200
Message-ID: <1283500775.1783.135.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-03 at 04:09 +0100, Paul Turner wrote:

> > @@ -7652,8 +7574,7 @@ static void init_tg_cfs_entry(struct tas
> >                se->cfs_rq = parent->my_q;
> >
> >        se->my_q = cfs_rq;
> > -       se->load.weight = tg->shares;
> > -       se->load.inv_weight = 0;
> > +       update_load_set(&se->load, tg->shares);
> 
> Given now instantaneous update of shares->load on enqueue/dequeue
> initialization to 0 would result in sane(r) sums across tg->se->load.
> Only relevant for debug though.

Ah, indeed.

> > @@ -8375,7 +8291,6 @@ int sched_group_set_shares(struct task_g
> >                /*
> >                 * force a rebalance
> >                 */
> > -               cfs_rq_set_shares(tg->cfs_rq[i], 0);
> >                set_se_shares(tg->se[i], shares);
> 
> I think a update_cfs_shares is wanted instead here, this will
> potentially over-commit everything until we hit tg_shares_up (e.g.
> long running task case).
> 
> Ironically, the heavy weight full enqueue/dequeue in the
> __set_se_shares path will actually fix up the weights ignoring the
> passed weight for the se->on_rq case.
> 
> I think both functions can be knocked out and just replaced with a
> <lock> <update load> <update shares> <unlock>
> 
> Although.. for total correctness this update should probably be hierarchical.

Right, I just didn't want to bother too much with this code yet, getting
it to more or less not explode when changing weights was good 'nuff.

> > +#ifdef CONFIG_FAIR_GROUP_SCHED
> > +static void update_cfs_load(struct cfs_rq *cfs_rq)
> > +{
> > +       u64 period = sched_avg_period();
> 
> This is a pretty large history window; while it should overlap the
> update period for obvious reasons, intuition suggests a smaller window
> (e.g. 2 x sched_latency) would probably be preferable here in terms of
> reducing over-commit and reducing convergence time.
> 
> I'll run some benchmarks and see how it impacts fairness.

Agreed, maybe even as small as 2*TICK_NSEC, its certainly something we
want to play with, which is basically why I picked the variable that
already had a sysctl knob ;-)

> > +       u64 now = rq_of(cfs_rq)->clock;
> > +       u64 delta = now - cfs_rq->load_stamp;
> > +
> 
> Is is meaningful/useful to maintain cfs_rq->load for the rq->cfs_rq case?

Probably not,.. I had ideas of maybe using this load_avg for other
things, but then, maybe not..


> > @@ -771,7 +844,9 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
> >         * Update run-time statistics of the 'current'.
> >         */
> >        update_curr(cfs_rq);
> > +       update_cfs_load(cfs_rq);
> >        account_entity_enqueue(cfs_rq, se);
> > +       update_cfs_shares(group_cfs_rq(se));
> 
> Don't we want to be updating the queuing cfs_rq's shares here?
> 
> The owned cfs_rq's share proportion isn't going to change as a result
> of being enqueued -- and is guaranteed to be hit by a previous queuing
> cfs_rq update in the initial enqueue case.

Right, I had that, that didn't work because,.. uhm,. /me scratches
head.. Ah!, yes, you need the queueing cfs_rq's group to be already
enqueued. So instead of updating ahead, we update backwards.

> > @@ -1055,6 +1134,9 @@ enqueue_task_fair(struct rq *rq, struct
> >                flags = ENQUEUE_WAKEUP;
> >        }
> >
> > +       for_each_sched_entity(se)
> > +               update_cfs_shares(group_cfs_rq(se));
> 
> If the queuing cfs_rq is used above then group_cfs_rq is redundant
> here, cfs_rq_of can be used.
> 
> Also, the respective load should be updated here.

Ah, indeed, that wants a update_cfs_load() as well. /me does

> > @@ -3510,6 +3545,8 @@ static void rebalance_domains(int cpu, e
> >        int update_next_balance = 0;
> >        int need_serialize;
> >
> > +       update_shares(cpu);
> > +
> 
> This may not be frequent enough, especially in the dilated cpus-busy case

Not exactly sure what you mean, but if there's wakeup/sleep activity
that activity will already rebalance for us, its is purely long running
jobs, once a tick should suffice, no?

