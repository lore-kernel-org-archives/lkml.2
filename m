Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab2FEVbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 17:31:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:52740 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab2FEVbO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 17:31:14 -0400
Message-ID: <1338931856.2749.57.camel@twins>
Subject: RE: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 05 Jun 2012 23:30:56 +0200
In-Reply-To: <alpine.LFD.2.02.1206052153200.3086@ionos>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
	   <alpine.LFD.2.02.1206042203590.3086@ionos>
	   <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au>
	   <1338881971.28282.150.camel@twins>
	   <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>
	  <1338912565.2749.9.camel@twins>
	   <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>
	   <1338913190.2749.10.camel@twins>
	   <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>
	 <1338918625.2749.29.camel@twins> <alpine.LFD.2.02.1206052106440.3086@ionos>
	 <1338925756.2749.36.camel@twins> <alpine.LFD.2.02.1206052153200.3086@ionos>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 22:47 +0200, Thomas Gleixner wrote:
> On Tue, 5 Jun 2012, Peter Zijlstra wrote:
> > On Tue, 2012-06-05 at 21:43 +0200, Thomas Gleixner wrote:
> > > Vs. the interrupt/timer/other crap madness:
> > > 
> > >  - We really don't want to have an interrupt balancer in the kernel
> > >    again, but we need a mechanism to prevent the user space balancer
> > >    trainwreck from ruining the power saving party.
> > 
> > What's wrong with having an interrupt balancer tied to the scheduler
> > which optimistically tries to avoid interrupting nohz/isolated/idle
> > cpus?
> 
> You want to run through a boatload of interrupts and change their
> affinity from the load balancer or something related? Not really.

Well, no not like that, but I think we could do with some coupling
there. Like steer active interrupts away when they keep hitting idle
state.


> > >  - The other details (silly IPIs) and cross CPU timer arming) are way
> > >    easier to solve by a proper prohibitive state than by chasing that
> > >    nonsense all over the tree forever. 
> > 
> > But we need to solve all that without a prohibitibe state anyway for the
> > isolation stuff to be useful.
> 
> And what is preventing us to use a prohibitive state for that purpose?
> The isolation stuff Frederic is working on is nothing else than
> dynamically switching in and out of a prohibitive state.

I don't think so. Its perfectly fine to get TLB invalidate IPIs or
resched-IPIs or any other kind of kernel work that needs doing. Its even
fine for timers to happen. What's not fine is getting spurious IPIs when
there's no work to do, or getting timers from another workload.

> I completely understand your reasoning, but I seriously doubt that we
> can educate the whole crowd to understand the problems at hand. My
> experience in the last 10+ years tells me that if you do not restrict
> stuff you enter a never ending "chase the human stupidity^Wcreativity"
> game. Even if you restrict it massively you end up observing a patch
> which does:
> 
> +       d->core_internal_state__do_not_mess_with_it |= SOME_CONSTANT;
> 
> So do you really want to promote a solution which requires brain
> sanity of all involved parties?

I just don't see a way to hard-wall interrupt sources, esp. when they
might be perfectly fine or even required for the correct operation of
the machine and desired workload.

kstopmachine -- however much we all love that thing -- will need to stop
all cpus and violate isolation barriers.

RCU has similar nasties.

> What's wrong with making a 'hotplug' model which provides the
> following states:

For one calling it hotplug ;-)

>   Fully functional
> 
>   Isolated functional
> 
>   Isolated idle

I can see the isolated idle, but we can implement that as an idle state
and have smp_send_reschedule() do the magic wakeup. This should even
work for crippled hardware.

What I can't see is the isolated functional, aside from the above
mentioned things, that's not strictly a per-cpu property, we can have a
group that's isolated from the rest but not from each other.

> Note, that these upper states are not 'hotplug' by definition, but
> they have to be traversed by hot(un)plug as well. So why not making
> them explicit states which we can exploit for the other problems we
> want to solve?

I think I can agree with what you call isolated-idle, as long as we
expose that as a generic idle state and put some magic in
smp_send_reschedule(). But ideally we'd conceive a better name than
hotplug for all this and only call the transition to down to 'physical
hotplug mess' hotplug.

> That puts the burden on the core facility design, but it removes the
> maintainence burden to chase a gazillion of instances doing IPIs,
> cross cpu function calls, add_timer_on, add_work_on and whatever
> nonsense.

I'd love for something like that to exist and work, I'm just not seeing
how it could.
