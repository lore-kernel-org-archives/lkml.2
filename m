Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab1H2Xfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:35:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60797 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab1H2Xf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:35:28 -0400
Date: Tue, 30 Aug 2011 01:35:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [PATCH 05/32] nohz: Move rcu dynticks idle mode handling to idle
 enter/exit APIs
Message-ID: <20110829233521.GK9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-6-git-send-email-fweisbec@gmail.com>
 <1314627922.2816.65.camel@twins>
 <20110829171155.GD9748@somewhere.redhat.com>
 <1314640155.2816.117.camel@twins>
 <20110829175954.GF9748@somewhere.redhat.com>
 <1314641160.2816.128.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314641160.2816.128.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 08:06:00PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-29 at 19:59 +0200, Frederic Weisbecker wrote:
> > On Mon, Aug 29, 2011 at 07:49:15PM +0200, Peter Zijlstra wrote:
> > > On Mon, 2011-08-29 at 19:11 +0200, Frederic Weisbecker wrote:
> > > > On Mon, Aug 29, 2011 at 04:25:22PM +0200, Peter Zijlstra wrote:
> > > > > On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> > > > > > To prepare for nohz / idle logic split, pull out the rcu dynticks
> > > > > > idle mode switching to strict idle entry/exit areas.
> > > > > > 
> > > > > > So we make the dyntick mode possible without always involving rcu
> > > > > > extended quiescent state. 
> > > > > 
> > > > > Why is this a good thing? I would be thinking that if we're a userspace
> > > > > bound task and we disable the tick rcu would be finished on this cpu and
> > > > > thus the extended quiescent state is just what we want?
> > > > 
> > > > But we can stop the tick from the kernel, not just userspace.
> > > 
> > > Humm!? I'm confused, I thought the idea was to only stop the tick when
> > > we're 'stuck' in a user bound task. Now I get that we have to stop the
> > > tick from kernel space (as in the interrupt will clearly run in kernel
> > > space), but assuming the normal return from interrupt path doesn't use
> > > rcu, and using rcu (as per a later patch) re-enables the tick again, it
> > > doesn't matter, right?
> > 
> > Yeah. Either the interrupt returns to userspace and then we call
> > rcu_enter_nohz() or we return to kernel space and then a further
> > use of rcu will restart the tick.
> > 
> > Now this is not any use of rcu. Uses of rcu read side critical section
> > don't need the tick. 
> 
> But but but, then how is it going to stop a grace period from happening?
> The grace period state is per-cpu and the whole state machine is tick
> driven.

But rcu read side critical sections (preemption disabled, rcu_read_lock(),
softirq disabled) don't need the tick to enforce the critical section
itself.

OTOH it is needed to find non-critical sections when asked to cooperate
in a grace period completion. But if no callback have been enqueued on
the whole system we are fine.

> Now some of the new RCU things go kick cpus with IPIs to push grace
> periods along, but I would expect you don't want that to happen either,
> the whole purpose here is to leave a cpu alone, unperturbed.

Sure we want the CPU to be unperturbed but not if that sacrifies correctness.
As long as we run in the kernel we want to receive such IPIs to restart
the tick as needed.

> That means it has to be in an extended grace period when we stop the
> tick.

You mean extended quiescent state?

As a summary here is what we do:

- if we are in the kernel, we can't run into extended quiescent state because
we may make use of rcu anytime there. But if we run nohz we don't have the tick
to notice quiescent states to the RCU machinery and help completing grace periods
so as soon as we receive an rcu IPI from another CPU (due to the grace period
beeing extended because our nohz CPU doesn't report quiescent states), we restart
the tick. We are optimistic enough to consider that we may avoid a lot of ticks
even if there are some risks to be disturbed in some random rates.
So even with the IPI we consider it as an upside.

- if we are in userspace we can run in extended quiescent state.

> 
> > But we need it as long as there is an RCU callback
> > enqueued on some CPU.
> 
> Well, no, only if there's one enqueued on this cpu because then we can't
> enter the extended grace period.

True if we are in userspace. 

> > > Also, RCU needs the tick to drive the state machine, so how can you stop
> > > the tick and not also stop the RCU state machine?
> > 
> > This is why we have rcu_needs_cpu() and rcu_pending() checks before
> > stopping the tick.
> > 
> > rcu_needs_cpu() checks we have no local callback enqueued, in which
> > case the local CPU is responsible of the RCU state machine.
> > 
> > rcu_pending() is there to know if another CPU started a grace period
> > so we need the tick to complete it.
> 
> Hence the extended grace period, so we don't need to complete grace
> periods.

I hope the above explanations made things more clear.
