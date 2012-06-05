Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab2FEToQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 15:44:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:47369 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2FEToO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 15:44:14 -0400
Date: Tue, 5 Jun 2012 21:43:53 +0200 (CEST)
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
In-Reply-To: <1338918625.2749.29.camel@twins>
Message-ID: <alpine.LFD.2.02.1206052106440.3086@ionos>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>  <alpine.LFD.2.02.1206042203590.3086@ionos>  <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au>  <1338881971.28282.150.camel@twins>  <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>
  <1338912565.2749.9.camel@twins>  <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>  <1338913190.2749.10.camel@twins>  <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com> <1338918625.2749.29.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2601;0cOn Tue, 5 Jun 2012, Peter Zijlstra wrote:

> On Tue, 2012-06-05 at 17:44 +0000, Luck, Tony wrote:
> > > Like what? Offline is nothing more than a C state on x86. 
> > 
> > Offline is a bigger hammer than idle.
> > 
> > When a core is idle it may take an interrupt which wakes it up to use power.
> > The scheduler may assign a process to run on it, which will wake it up to use power.
> > 
> > When a core is offline we take extra steps (re-routing interrupts, telling the
> > scheduler it is not available for work) to make sure it STAYS in that low
> > power state.
> 
> You also wreck cpusets, cpu affinity and you need some userspace crap to
> poll state trying to figure out when to wake up again.
> 
> (And yes, I've heard stories about userspace hotplug daemons that cause
> machine wakeups themselves and were a main source of power usage at some
> point).
> 
> All the timer/interrupt nonsense needs to be fixed anyhow, the HPC and
> RT people want isolation anyway.
> 
> So shouldn't we all start by fixing the entire
> load-balancer/timer/interrupt madness before we start swinging stupid
> big hammers around that break half the interfaces we have?

My idea of the stateful hotplug is to have a state which just gets rid
of the interrupts, timers and some other crap (mostly IPIs) but allows
an ad hoc resurrection of the cpu. 

Ideally the state transition would be driven by the load-balancer.

I know that the current load balancer is too stupid to do that, but
that's a different problem. Right now we can't fix the load balancer
because we have no mechanisms to solve the other issues and the other
issues are not solved because the stupid load balancer is in the way.

So we have to start somewhere.

IMNSHO providing a stateful hotplug mechanism which allows us to solve
the issues outside of the load balancer in a simple and robust way is
a proper approach. Once we have that we can tackle the load balancer
to control the whole thing.

Vs. the interrupt/timer/other crap madness:

 - We really don't want to have an interrupt balancer in the kernel
   again, but we need a mechanism to prevent the user space balancer
   trainwreck from ruining the power saving party.

 - The timer issue is mostly solved by the existing nohz stuff
   (plus/minus the few bugs in there).

 - The other details (silly IPIs) and cross CPU timer arming) are way
   easier to solve by a proper prohibitive state than by chasing that
   nonsense all over the tree forever.


Thoughts ?

	 tglx
