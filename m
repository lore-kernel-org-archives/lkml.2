Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab0DRVeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 17:34:21 -0400
Received: from ozlabs.org ([203.10.76.45]:51710 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab0DRVeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 17:34:19 -0400
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH 1/5] sched: fix capacity calculations for SMT4
In-reply-to: <1271426308.1674.429.camel@laptop>
References: <20100409062118.D4096CBB6C@localhost.localdomain> <1271161766.4807.1280.camel@twins> <2906.1271219317@neuling.org> <1271426308.1674.429.camel@laptop>
Comments: In-reply-to Peter Zijlstra <peterz@infradead.org>
   message dated "Fri, 16 Apr 2010 15:58:28 +0200."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Mon, 19 Apr 2010 07:34:17 +1000
Message-ID: <28214.1271626457@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In message <1271426308.1674.429.camel@laptop> you wrote:
> On Wed, 2010-04-14 at 14:28 +1000, Michael Neuling wrote:
> 
> > > Right, so I suspect this will indeed break some things.
> > > 
> > > We initially allowed 0 capacity for when a cpu is consumed by an RT task
> > > and there simply isn't much capacity left, in that case you really want
> > > to try and move load to your sibling cpus if possible.
> > 
> > Changing the CPU power based on what tasks are running on them seems a
> > bit wrong to me.  Shouldn't we keep those concepts separate?
> 
> Well the thing cpu_power represents is a ratio of compute capacity
> available to this cpu as compared to other cpus. By normalizing the
> runqueue weights with this we end up with a fair balance.
> 
> The thing to realize here is that this is solely about SCHED_NORMAL
> tasks, SCHED_FIFO/RR (or the proposed DEADLINE) tasks do not care about
> fairness and available compute capacity.
> 
> So if we were to ignore RT tasks, you'd end up with a situation where,
> assuming 2 cpus and 4 equally weighted NORMAL tasks, and 1 RT task, the
> load-balancer would give each cpu 2 NORMAL tasks, but the tasks that
> would end up on the cpu the RT tasks would be running on would not run
> as fast -- is that fair?
> 
> Since RT tasks do not have a weight (FIFO/RR have no limit at all,
> DEADLINE would have something equivalent to a max weight), it is
> impossible to account them in the normal weight sense.
> 
> Therefore the current model takes them into account by lowering the
> compute capacity according to their (avg) cpu usage. So if the RT task
> would consume 66% cputime, we'd end up with a situation where the cpu
> running the RT task would get 1 NORMAL task, and other cpu would have
> the remaining 3, that way they'd all get 33% cpu.

Thanks for the explanation.  Your last example makes perfect sense for
me.  

> 
> > > However you're right that this goes awry in your case.
> > > 
> > > One thing to look at is if that 15% increase is indeed representative
> > > for the power7 cpu, it having 4 SMT threads seems to suggest there was
> > > significant gains, otherwise they'd not have wasted the silicon.
> > 
> > There are certainly, for most workloads, per core gains for SMT4 over
> > SMT2 on P7.  My kernels certainly compile faster and that's the only
> > workload anyone who matters cares about.... ;-)
> 
> For sure ;-)
> 
> Are there any numbers available on how much they gain? It might be worth
> to stick in real numbers instead of this alleged 15%.

I get some gain numbers but obviously the workloads makes a huge
difference.  From a scheduler perspective, I assume an
average/representative gain is best rather than an optimistic or
pessimistic one?

We'll have different gains for SMT2 and SMT4, so we could change the
gain dynamically based on which SMT mode we are in.  Does that seem like
something we should add as an arch hook?  

> > > One thing we could look at is using the cpu base power to compute
> > > capacity from. We'd have to add another field to sched_group and store
> > > power before we do the scale_rt_power() stuff.
> > 
> > Separating capacity from what RT tasks are running seems like a good
> > idea to me.
> 
> Well, per the above we cannot fully separate them.

Yep.

> 
> > This would fix the RT issue, but it's not clear to me how you are
> > suggesting fixing the rounding down to 0 SMT4 issue.  Are you suggesting
> > we bump smt_gain to say 2048 + 15%?  Or are you suggesting we separate
> > the RT tasks out from capacity and keep the max(1, capacity) that I've
> > added?  Or something else?
> 
> I would think that 4 SMT threads are still slower than two full cores,
> right? So cpu_power=2048 would not be appropriate.

Yes for an average workload, 4 SMT threads are slower than 2 full
cores.  

> 
> > Would another possibility be changing capacity a scaled value (like
> > cpu_power is now) rather than a small integer as it is now.  For
> > example, a scaled capacity of 1024 would be equivalent to a capacity of
> > 1 now.  This might enable us to handle partial capacities better?  We'd
> > probably have to scale a bunch of nr_running too.  
> 
> Right, so my proposal was to scale down the capacity divider (currently
> 1024) to whatever would be the base capacity for that cpu. Trouble seems
> to be that that makes group capacity a lot more complex, as you would
> end up needing to average all the cpu's their base capacity.
> 
> Hrmm, my brain seems muddled but I might have another solution, let me
> ponder this for a bit..

Great!

Mikey
