Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab1FASTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 14:19:08 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40081 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab1FASTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 14:19:05 -0400
Date: Wed, 1 Jun 2011 11:19:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Damien Wyart <damien.wyart@free.fr>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: Very high CPU load when idle with 3.0-rc1
Message-ID: <20110601181900.GI2274@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110530055924.GA9169@brouette>
 <1306755291.1200.2872.camel@twins>
 <20110530162354.GQ2668@linux.vnet.ibm.com>
 <1306775989.2497.527.camel@laptop>
 <20110530212833.GS2668@linux.vnet.ibm.com>
 <1306791219.23844.12.camel@twins>
 <20110531014543.GU2668@linux.vnet.ibm.com>
 <1306926339.2353.191.camel@twins>
 <20110601143743.GA2274@linux.vnet.ibm.com>
 <1306947513.2497.624.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306947513.2497.624.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 06:58:33PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-06-01 at 07:37 -0700, Paul E. McKenney wrote:
> 
> > > > I considered that, but working out when it is OK to deboost them is
> > > > decidedly non-trivial. 
> > > 
> > > Where exactly is the problem there? The boost lasts for as long as it
> > > takes to finish the grace period, right? There's a distinct set of
> > > callbacks associated with each grace-period, right? In which case you
> > > can de-boost your thread the moment you're done processing that set.
> > > 
> > > Or am I simply confused about how all this is supposed to work?
> > 
> > The main complications are: (1) the fact that it is hard to tell exactly
> > which grace period to wait for, this one or the next one, and (2) the
> > fact that callbacks get shuffled when CPUs go offline.
> 
> I can't say I would worry too much about 2, hotplug and RT don't really
> go hand-in-hand anyway.

Perhaps not, but I do need to handle the combination.

> On 1 however, is that due to the boost condition? 

The boost condition is straightforward.  By default, if a grace period
lasts for more than 500 milliseconds, boosting starts.  So the obvious
answer is "deboost when the grace period ends", but different CPUs become
aware of the end at different times, so it is still a bit fuzzy.

> I must admit that my thought there is somewhat fuzzy since I just
> realized I don't actually know the exact condition to start boosting,
> but suppose we boost because the queue is too large, then waiting for
> the current grace period might not reduce the queue length, as most
> callbacks might actually be for the next.
> 
> If however the condition is grace period duration, then completion of
> the current grace period is sufficient, since the whole boost condition
> is defined as such. [ if the next is also exceeding the time limit,
> that's a whole next boost ]

Don't get me wrong -- it can be done.  Just a bit ugly due to the
fact that different CPUs have different views of when the grace period
ends.

> > That said, it might be possible if we are willing to live with some
> > approximate behavior.  For example, always waiting for the next grace
> > period (rather than the current one) to finish, and boosting through the
> > extra callbacks in case where a given CPU "adopts" callbacks that must
> > be boosted when that CPU also has some callbacks whose priority must be
> > boosted and some that need not be.
> 
> That might make sense, but I must admit to not fully understanding the
> whole current/next thing yet.

And I cannot claim to have thought it through thoroughly, for that
matter.

> > The reason I am not all that excited about taking this approach is that
> > it doesn't help worst-case latency.
> 
> Well, not running at the top most prio does help those tasks running at
> a higher priority, so in that regard it does reduce the jitter for a
> number of tasks.

By default, boosting is to RT prio 1, so shouldn't bother most RT
processes.

> Also, I guess there's the whole question of what prio to boost to which
> I somehow totally forgot about, which is a non-trivial thing in its own
> right, since there isn't really someone blocked on grace period
> completion (although in the special case of someone calling sync_rcu it
> is clear).

I am not all that excited about synchronize_rcu() controlling the boost
priority, but having synchronize_rcu_expedited() do so might make sense.
But I would want someone to come up with a situation needing this first.

Other than that, it is similar to working out what priority softirq
should run at in PREEMPT_RT.

> > Plus the current implementation is just a less-precise approximation.
> > (Sorry, couldn't resist!)
> 
> Appreciated, on a similar note I still need to actually look at all this
> (preempt) tree-rcu stuff to learn how exactly it works.

And I do need to document it.  For one thing, I usually find a few bugs
when I do that.  For another, the previous documentation is getting quite
dated.

							Thanx, Paul
