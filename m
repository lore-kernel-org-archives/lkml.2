Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1K2BAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 20:00:44 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60858 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab1K2BAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 20:00:43 -0500
Date: Mon, 28 Nov 2011 17:00:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4 RFC] rcu: New rcu_user_enter_irq() and
 rcu_user_exit_irq() APIs
Message-ID: <20111129010036.GS2346@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1322515487-18690-1-git-send-email-fweisbec@gmail.com>
 <1322515487-18690-5-git-send-email-fweisbec@gmail.com>
 <20111128215323.GF30852@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128215323.GF30852@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112901-7182-0000-0000-000000458DA7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 01:53:23PM -0800, Josh Triplett wrote:
> On Mon, Nov 28, 2011 at 10:24:47PM +0100, Frederic Weisbecker wrote:
> > A CPU running in adaptive tickless mode wants to enter into
> > RCU extended quiescent state while running in userspace. This
> > way we can shut down the tick that is usually needed on each
> > CPU for the needs of RCU.
> 
> Very awesome.  I've wanted to see this change for a long time.  Thanks!

I am a fan, also.  ;-)

[ . . . ]

> > @@ -503,6 +515,18 @@ void rcu_user_exit(void)
> >  	__rcu_idle_exit();
> >  }
> >  
> > +void rcu_user_exit_irq(void)
> > +{
> > +	unsigned long flags;
> > +	struct rcu_dynticks *rdtp;
> > +
> > +	local_irq_save(flags);
> > +	rdtp = &__get_cpu_var(rcu_dynticks);
> > +	WARN_ON_ONCE(rdtp->dynticks_nesting != 1);
> > +	rdtp->dynticks_nesting = (LLONG_MAX / 2) + 1;
> > +	local_irq_restore(flags);
> > +}
> > +
> 
> Any chance that either of these two needs a memory barrier of some kind,
> to prevent leakage of operations from between them?  Or can you count on
> no RCU-protected operations occurring during (or leaking into) the
> extended quiescent state?

There is no need for a memory barrier on rdtp->dynticks_nesting because
it is used (aside from state dumping) only by the local CPU.  In contrast,
changes to ->dynticks are visible to other CPUs, hence the memory barriers
around changes to ->dynticks.

Information flows within the CPU from ->dynticks_nesting to ->dynticks,
which is externally visible.

Frederic, given my hamhandedness on the first patch and given that you
mentioned its being less time critical, I will let you forward port
patches #3 and #4.  I have pushed the first two patches to -rcu, branch
rcu/dyntick.  I will be testing over the evening.

							Thanx, Paul

