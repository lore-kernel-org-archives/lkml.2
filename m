Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab2FEWJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 18:09:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:47834 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab2FEWJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 18:09:24 -0400
Date: Wed, 6 Jun 2012 00:09:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: "Luck, Tony" <tony.luck@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: RE: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
In-Reply-To: <1338931856.2749.57.camel@twins>
Message-ID: <alpine.LFD.2.02.1206052337300.3086@ionos>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>    <alpine.LFD.2.02.1206042203590.3086@ionos>    <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au>    <1338881971.28282.150.camel@twins>   
 <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>   <1338912565.2749.9.camel@twins>    <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>    <1338913190.2749.10.camel@twins>   
 <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>  <1338918625.2749.29.camel@twins> <alpine.LFD.2.02.1206052106440.3086@ionos>  <1338925756.2749.36.camel@twins> <alpine.LFD.2.02.1206052153200.3086@ionos>
 <1338931856.2749.57.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2012, Peter Zijlstra wrote:
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

That's possible, but that wants a well coordinated mechanism which
takes the user space steering into account.

I'm not saying it's impossible, I'm just trying to imagine the extra
user space interfaces needed for that.
 
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

No it's not. It's silly. I've observed the very issue more than once
and others have done as well. 

If you have a process which has N threads where each thread is pinned
to a core. Only one of them is doing file operations, which result in
mmap/munmap and therefor in TLB shoot down IPIs even if it's ensured
that the other pinned threads will never ever touch that
mapping. That's a PITA as the workaround is to use NFS (how
performant) or split the process into separate processes with shared
memory to avoid the sane design of a single process where the
housekeeping thread just writes to disk.

This is exactly one of the issues where the application has more
knowlegde than the kernel and there is no way to deal with it.

I know, it's a hen and egg problem, but a very real one.

> resched-IPIs or any other kind of kernel work that needs doing. Its even

resched IPIs are a different issue. They cause a real state transition
as does any other kind of work which needs to be scheduled on that
CPU. What I'm talking about is stuff which should not happen on an
isolated cpu. We have no mechanism to exclude those cpus from general
"oh you should do X and Y" tasks which are not really necessary at all.

> I just don't see a way to hard-wall interrupt sources, esp. when they
> might be perfectly fine or even required for the correct operation of
> the machine and desired workload.

You can't steer away interrupts which are willingly targeted at an
isolated CPU. So yes, we need mechanisms for that as well. I don;t
claim that hotplug states are the cure of all problems.

> kstopmachine -- however much we all love that thing -- will need to stop
> all cpus and violate isolation barriers.

Yup. Though we really should sit down and figure out how much we need
it really. If code patching needs it on a given architecture, then
this particular arch has to cope with it, but all others which can
deal with other mechanisms should not care about it. Yes, that's not
how the kernel looks like ATM, but that's how it should look like in
the near future.

> RCU has similar nasties.

Why?
 
> > What's wrong with making a 'hotplug' model which provides the
> > following states:
> 
> For one calling it hotplug ;-)

Bah. Call it what you want. We can put it on top of the hotplug
mechanism as a separate facility, but that does not change the
semantics at all. Neither does it change the fact that the real
hotplug stuff needs these transitions as well.
 
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

That's an implementation detail, really.

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

Agreed for the naming convention part.
 
> > That puts the burden on the core facility design, but it removes the
> > maintainence burden to chase a gazillion of instances doing IPIs,
> > cross cpu function calls, add_timer_on, add_work_on and whatever
> > nonsense.
> 
> I'd love for something like that to exist and work, I'm just not seeing
> how it could.

Think harder :)

      tglx



