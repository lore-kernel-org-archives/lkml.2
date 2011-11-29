Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab1K2OFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 09:05:30 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54029 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab1K2OF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 09:05:29 -0500
Date: Tue, 29 Nov 2011 15:05:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4 RFC] rcu: New rcu_user_enter_irq() and
 rcu_user_exit_irq() APIs
Message-ID: <20111129140520.GB20387@somewhere>
References: <1322515487-18690-1-git-send-email-fweisbec@gmail.com>
 <1322515487-18690-5-git-send-email-fweisbec@gmail.com>
 <20111128215323.GF30852@leaf>
 <20111129010036.GS2346@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129010036.GS2346@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 05:00:36PM -0800, Paul E. McKenney wrote:
> On Mon, Nov 28, 2011 at 01:53:23PM -0800, Josh Triplett wrote:
> > On Mon, Nov 28, 2011 at 10:24:47PM +0100, Frederic Weisbecker wrote:
> > > A CPU running in adaptive tickless mode wants to enter into
> > > RCU extended quiescent state while running in userspace. This
> > > way we can shut down the tick that is usually needed on each
> > > CPU for the needs of RCU.
> > 
> > Very awesome.  I've wanted to see this change for a long time.  Thanks!
> 
> I am a fan, also.  ;-)
> 
> [ . . . ]
> 
> > > @@ -503,6 +515,18 @@ void rcu_user_exit(void)
> > >  	__rcu_idle_exit();
> > >  }
> > >  
> > > +void rcu_user_exit_irq(void)
> > > +{
> > > +	unsigned long flags;
> > > +	struct rcu_dynticks *rdtp;
> > > +
> > > +	local_irq_save(flags);
> > > +	rdtp = &__get_cpu_var(rcu_dynticks);
> > > +	WARN_ON_ONCE(rdtp->dynticks_nesting != 1);
> > > +	rdtp->dynticks_nesting = (LLONG_MAX / 2) + 1;
> > > +	local_irq_restore(flags);
> > > +}
> > > +
> > 
> > Any chance that either of these two needs a memory barrier of some kind,
> > to prevent leakage of operations from between them?  Or can you count on
> > no RCU-protected operations occurring during (or leaking into) the
> > extended quiescent state?
> 
> There is no need for a memory barrier on rdtp->dynticks_nesting because
> it is used (aside from state dumping) only by the local CPU.  In contrast,
> changes to ->dynticks are visible to other CPUs, hence the memory barriers
> around changes to ->dynticks.
> 
> Information flows within the CPU from ->dynticks_nesting to ->dynticks,
> which is externally visible.
> 
> Frederic, given my hamhandedness on the first patch and given that you
> mentioned its being less time critical, I will let you forward port
> patches #3 and #4.  I have pushed the first two patches to -rcu, branch
> rcu/dyntick.  I will be testing over the evening.

Sure. Also #3 and #4 are not used upstream, so I should probably rather
carry these in my tree once I do a rebase against yours.
