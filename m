Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1K2Jrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 04:47:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35070 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab1K2Jru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 04:47:50 -0500
Message-ID: <1322559859.2921.190.camel@twins>
Subject: Re: [patch 3/6] sched, nohz: sched group, domain aware nohz idle
 load balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>,
        "Shi, Alex" <alex.shi@intel.com>
Date: Tue, 29 Nov 2011 10:44:19 +0100
In-Reply-To: <1322524316.21329.64.camel@sbsiddha-desk.sc.intel.com>
References: <20111118230323.592022417@sbsiddha-desk.sc.intel.com>
	 <20111118230553.995756330@sbsiddha-desk.sc.intel.com>
	 <1322135263.2921.12.camel@twins>
	 <1322524316.21329.64.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 15:51 -0800, Suresh Siddha wrote:
> On Thu, 2011-11-24 at 03:47 -0800, Peter Zijlstra wrote:
> > On Fri, 2011-11-18 at 15:03 -0800, Suresh Siddha wrote:
> > > +       for_each_domain(cpu, sd) {
> > > +               struct sched_group *sg = sd->groups;
> > > +               struct sched_group_power *sgp = sg->sgp;
> > > +               int nr_busy = atomic_read(&sgp->nr_busy_cpus);
> > > +
> > > +               if (nr_busy > 1 && (nr_busy * SCHED_LOAD_SCALE > sgp->power))
> > > +                       goto need_kick;
> > 
> > This looks wrong, its basically always true for a box with HT.
> 
> In the presence of two busy HT siblings, we need to do the idle load
> balance to figure out if the load from the busy core can be migrated to
> any other idle core/sibling in the platform. And at this point, we
> already know there are idle cpu's in the platform.

might have to, this nr_busy doesn't mean its actually busy, just that
its not nohz, it might very well be idle.

> But you are right. using group power like the above is not right. For
> example in the case of two sockets with each socket having dual core
> with no HT, if one socket is completely busy with another completely
> idle, we would like to identify this. But the group power of that socket
> will be 2 * SCHED_POWER_SCALE.

Right, minus whatever time was taken by interrupts and RT tasks.

> In the older kernels, for the domains which was sharing package
> resources, we were setting the group power to SCHED_POWER_SCALE for the
> default performance mode. And I has that old code in the mind, while
> doing the above check.
> 
> I will modify the above check to:
> 
> if (sd->flags & SD_SHARE_PKG_RESOURCES && nr_busy > 1)
> 	goto need_kick;
> 
> This way, if there is a SMT/MC domain with more than one busy cpu in the
> group, then we will request for the idle load balancing.

Potentially 1 more than 1 busy, right? And we do the balancing just in
case there are indeed busy cpus.

I think its useful to mention that somewhere near, that this nr_busy
measure we use is an upper bound on actual busy.

> Current mainline code kicks the idle load balancer if there are two busy
> cpus in the system. Above mentioned modification makes this decision
> some what better. For example, two busy cpu's in two different sockets
> or two busy cpu's in a dual-core single socket system will never kick
> idle load balancer (as there is no need).

Except in power balance mode (although that's probably busted anyway),
where we want to aggregate the two tasks over two sockets onto one
socket.

> In future we can add more heuristics to kick the idle load balancer only
> when it is really necessary (for example when there is a real imbalance
> between the highest and lowest loaded groups etc). Only catch is to
> identify those scenarios with out adding much penality to the busy cpu
> which is identifying the imbalance and kicking the idle load balancer.
> Above proposed approach is the simplest approach that is trying to do
> better than the current logic we have in the kernel now.

Fair enough, and yeah, each patch only needs to do better and eventually
we'll get somewhere ;-)

> Any more thoughts in making the kick decisions (for doing idle load
> balancing) more robust are welcome.

Ha, I'll certainly share them if I have any.. I'd still love to split
this up somehow, but I've yet to figure out how to do so without
observing the whole machine.
