Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2FEWMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 18:12:51 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:47298 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab2FEWMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 18:12:49 -0400
Date: Tue, 5 Jun 2012 15:12:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "Luck, Tony" <tony.luck@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or nmi
Message-ID: <20120605221240.GW2388@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>
 <1338912565.2749.9.camel@twins>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>
 <1338913190.2749.10.camel@twins>
 <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>
 <1338918625.2749.29.camel@twins>
 <alpine.LFD.2.02.1206052106440.3086@ionos>
 <1338925756.2749.36.camel@twins>
 <alpine.LFD.2.02.1206052153200.3086@ionos>
 <1338931856.2749.57.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338931856.2749.57.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060522-7606-0000-0000-000000E3B80D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 11:30:56PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-05 at 22:47 +0200, Thomas Gleixner wrote:
> > On Tue, 5 Jun 2012, Peter Zijlstra wrote:
> > > On Tue, 2012-06-05 at 21:43 +0200, Thomas Gleixner wrote:
> > > > Vs. the interrupt/timer/other crap madness:
> > > > 
> > > >  - We really don't want to have an interrupt balancer in the kernel
> > > >    again, but we need a mechanism to prevent the user space balancer
> > > >    trainwreck from ruining the power saving party.
> > > 
> > > What's wrong with having an interrupt balancer tied to the scheduler
> > > which optimistically tries to avoid interrupting nohz/isolated/idle
> > > cpus?
> > 
> > You want to run through a boatload of interrupts and change their
> > affinity from the load balancer or something related? Not really.
> 
> Well, no not like that, but I think we could do with some coupling
> there. Like steer active interrupts away when they keep hitting idle
> state.

But the guys who are more fanatic about performance than about energy
efficiency would -want- the interrupts to hit the idle CPUs, right?

> > > >  - The other details (silly IPIs) and cross CPU timer arming) are way
> > > >    easier to solve by a proper prohibitive state than by chasing that
> > > >    nonsense all over the tree forever. 
> > > 
> > > But we need to solve all that without a prohibitibe state anyway for the
> > > isolation stuff to be useful.
> > 
> > And what is preventing us to use a prohibitive state for that purpose?
> > The isolation stuff Frederic is working on is nothing else than
> > dynamically switching in and out of a prohibitive state.
> 
> I don't think so. Its perfectly fine to get TLB invalidate IPIs or
> resched-IPIs or any other kind of kernel work that needs doing. Its even
> fine for timers to happen. What's not fine is getting spurious IPIs when
> there's no work to do, or getting timers from another workload.

One desirable property of CPU hotplug is that it puts the CPU in a state
where it no longer needs to receive TLB invalidations, resched IPIs, etc.

> > I completely understand your reasoning, but I seriously doubt that we
> > can educate the whole crowd to understand the problems at hand. My
> > experience in the last 10+ years tells me that if you do not restrict
> > stuff you enter a never ending "chase the human stupidity^Wcreativity"
> > game. Even if you restrict it massively you end up observing a patch
> > which does:
> > 
> > +       d->core_internal_state__do_not_mess_with_it |= SOME_CONSTANT;
> > 
> > So do you really want to promote a solution which requires brain
> > sanity of all involved parties?
> 
> I just don't see a way to hard-wall interrupt sources, esp. when they
> might be perfectly fine or even required for the correct operation of
> the machine and desired workload.
> 
> kstopmachine -- however much we all love that thing -- will need to stop
> all cpus and violate isolation barriers.
> 
> RCU has similar nasties.

I am working to rid RCU of this sort of thing.  I have rcu_barrier() so
that it avoids messing with CPUs that don't have callbacks, which will
be almost all of the idle CPUs, especially for CONFIG_RCU_FAST_NO_HZ=y.
I believe that I have also removed all of RCU's dependencies on CPU
hotplug's using kstopmachine, though Murphy would say otherwise.

I still need to fix up synchronize_sched_expedited(), but that is on
the list.  I considered getting rid of this one, but I am probably going
to have to make synchronize_sched() map to it during boot time to keep
the boot-speed demons satisfied.

> > What's wrong with making a 'hotplug' model which provides the
> > following states:
> 
> For one calling it hotplug ;-)

OK, what would you want to call it?  CPU quiesce with different levels
of quiescence?  CPU cripple?  CPU curfew?  Something else?

> >   Fully functional
> > 
> >   Isolated functional
> > 
> >   Isolated idle
> 
> I can see the isolated idle, but we can implement that as an idle state
> and have smp_send_reschedule() do the magic wakeup. This should even
> work for crippled hardware.
> 
> What I can't see is the isolated functional, aside from the above
> mentioned things, that's not strictly a per-cpu property, we can have a
> group that's isolated from the rest but not from each other.

I suspect that Thomas is thinking that the CPU is so idle that it no
longer has to participate in TLB invalidation or RCU.  (Thomas will
correct me if I am confused.)  But Peter, is that the level of idle
you are thinking of?

							Thanx, Paul

> > Note, that these upper states are not 'hotplug' by definition, but
> > they have to be traversed by hot(un)plug as well. So why not making
> > them explicit states which we can exploit for the other problems we
> > want to solve?
> 
> I think I can agree with what you call isolated-idle, as long as we
> expose that as a generic idle state and put some magic in
> smp_send_reschedule(). But ideally we'd conceive a better name than
> hotplug for all this and only call the transition to down to 'physical
> hotplug mess' hotplug.
> 
> > That puts the burden on the core facility design, but it removes the
> > maintainence burden to chase a gazillion of instances doing IPIs,
> > cross cpu function calls, add_timer_on, add_work_on and whatever
> > nonsense.
> 
> I'd love for something like that to exist and work, I'm just not seeing
> how it could.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

