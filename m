Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab2BTSZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 13:25:50 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:37191 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751331Ab2BTSZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 13:25:49 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/yZ2g4Rqryd0g4f8VJwhMYxW/1r4gqY6o/dqDlOt
	YaIm6Gmw0nMg0l
Message-ID: <1329762343.6276.156.camel@marge.simpson.net>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Mike Galbraith <efault@gmx.de>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Date: Mon, 20 Feb 2012 19:25:43 +0100
In-Reply-To: <20120220150348.GC2350@linux.vnet.ibm.com>
References: <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
	 <1321629267.7080.13.camel@marge.simson.net>
	 <1329748861.2293.345.camel@twins>
	 <20120220150348.GC2350@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 20:33 +0530, Srivatsa Vaddagiri wrote: 
> * Peter Zijlstra <peterz@infradead.org> [2012-02-20 15:41:01]:
> 
> > On Fri, 2011-11-18 at 16:14 +0100, Mike Galbraith wrote:
> > 
> > > ---
> > >  kernel/sched_fair.c |   10 ++--------
> > >  1 file changed, 2 insertions(+), 8 deletions(-)
> > > 
> > > Index: linux-3.0-tip/kernel/sched_fair.c
> > > ===================================================================
> > > --- linux-3.0-tip.orig/kernel/sched_fair.c
> > > +++ linux-3.0-tip/kernel/sched_fair.c
> > > @@ -2276,17 +2276,11 @@ static int select_idle_sibling(struct ta
> > >  		for_each_cpu_and(i, sched_domain_span(sd), tsk_cpus_allowed(p)) {
> > >  			if (idle_cpu(i)) {
> > >  				target = i;
> > > +				if (sd->flags & SD_SHARE_CPUPOWER)
> > > +					continue;
> > >  				break;
> > >  			}
> > >  		}
> > > -
> > > -		/*
> > > -		 * Lets stop looking for an idle sibling when we reached
> > > -		 * the domain that spans the current cpu and prev_cpu.
> > > -		 */
> > > -		if (cpumask_test_cpu(cpu, sched_domain_span(sd)) &&
> > > -		    cpumask_test_cpu(prev_cpu, sched_domain_span(sd)))
> > > -			break;
> > >  	}
> > >  	rcu_read_unlock();
> > 
> > Mike, Suresh, did we ever get this sorted? I was looking at
> > select_idle_sibling() and it looks like we dropped this.
> > 
> > Also, did anybody ever get an answer from a HW guy on why sharing stuff
> > over SMT threads is so much worse than sharing it over proper cores? Its
> > not like this workload actually does anything concurrently.
> > 
> > I was looking at this code due to vatsa wanting to do SD_BALANCE_WAKE.
> 
> From a quick scan of that code, it seems to prefer selecting an idle cpu
> in the same cache domain (vs selecting prev_cpu in absence of a core
> that is fully idle).

Yes, that was the sole purpose of select_idle_sibling() from square one.
If you can mobilize a CPU without eating cache penalty, this is most
excellent for load ramp-up.  The gain is huge over affine wakeup if
there is any overlap to regain, ie it's not a 100% synchronous load.

> I can give that a try for my benchmark and see how much it helps. My
> suspicion is it will not fully solve the problem I have on hand.

I doubt it will either.  Your problem is when it doesn't succeed, but
you have an idle core available in another domain.  That's a whole
different ball game.  Yeah, you can reap benefit by doing wakeup
balancing, but you'd better look very closely at the cost.  I haven't
been able to do that lately, so dunno what cost is in the here and now,
but it used to be _way_ too expensive to consider, just as unrestricted
idle balancing is, or high frequency load balancing in general is.

-Mike

