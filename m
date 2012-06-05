Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab2FEUsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 16:48:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:47569 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2FEUsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 16:48:04 -0400
Date: Tue, 5 Jun 2012 22:47:47 +0200 (CEST)
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
In-Reply-To: <1338925756.2749.36.camel@twins>
Message-ID: <alpine.LFD.2.02.1206052153200.3086@ionos>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>   <alpine.LFD.2.02.1206042203590.3086@ionos>   <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au>   <1338881971.28282.150.camel@twins>  
 <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>  <1338912565.2749.9.camel@twins>   <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>   <1338913190.2749.10.camel@twins>   <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>
  <1338918625.2749.29.camel@twins> <alpine.LFD.2.02.1206052106440.3086@ionos> <1338925756.2749.36.camel@twins>
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
> On Tue, 2012-06-05 at 21:43 +0200, Thomas Gleixner wrote:
> > Vs. the interrupt/timer/other crap madness:
> > 
> >  - We really don't want to have an interrupt balancer in the kernel
> >    again, but we need a mechanism to prevent the user space balancer
> >    trainwreck from ruining the power saving party.
> 
> What's wrong with having an interrupt balancer tied to the scheduler
> which optimistically tries to avoid interrupting nohz/isolated/idle
> cpus?

You want to run through a boatload of interrupts and change their
affinity from the load balancer or something related? Not really.

> >  - The timer issue is mostly solved by the existing nohz stuff
> >    (plus/minus the few bugs in there).
> 
> Its not.. if you create an isolated domain there's no way to expel
> existing timers from there.

Yep, that's one of the problems which need to be fixed independent of
the solution we come up with.

> >  - The other details (silly IPIs) and cross CPU timer arming) are way
> >    easier to solve by a proper prohibitive state than by chasing that
> >    nonsense all over the tree forever. 
> 
> But we need to solve all that without a prohibitibe state anyway for the
> isolation stuff to be useful.

And what is preventing us to use a prohibitive state for that purpose?
The isolation stuff Frederic is working on is nothing else than
dynamically switching in and out of a prohibitive state.

So do we really need to make the world and some more aware of those
states, instead of having a facility which lets us control what's
allowed/applicable in a given situation? Whether that's controlled by
the load-balancer or by user space or partially by both or something
else is a totally different issue.

I completely understand your reasoning, but I seriously doubt that we
can educate the whole crowd to understand the problems at hand. My
experience in the last 10+ years tells me that if you do not restrict
stuff you enter a never ending "chase the human stupidity^Wcreativity"
game. Even if you restrict it massively you end up observing a patch
which does:

+       d->core_internal_state__do_not_mess_with_it |= SOME_CONSTANT;

So do you really want to promote a solution which requires brain
sanity of all involved parties?

What's wrong with making a 'hotplug' model which provides the
following states:

  Fully functional

  Isolated functional

  Isolated idle

  <the physical hotplug mess>

where you have the ability to control the transitions of the upper 3
(or maybe more) states from the load balancer and/or user space or
whatever instance we come up with?

That puts the burden on the core facility design, but it removes the
maintainence burden to chase a gazillion of instances doing IPIs,
cross cpu function calls, add_timer_on, add_work_on and whatever
nonsense.

Note, that these upper states are not 'hotplug' by definition, but
they have to be traversed by hot(un)plug as well. So why not making
them explicit states which we can exploit for the other problems we
want to solve?

Your idea of tying everything to the scheduler and the load balancer
is just introducing the exacly same states again, just in a different
context.

Thanks,

	tglx
