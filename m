Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab2BTSO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 13:14:29 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:42148 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751975Ab2BTSO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 13:14:28 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/5pJMTFPD5KJhgxFakKMydTI2Nsrlx/shCNDp3RZ
	rJwV/RawKMvmmy
Message-ID: <1329761661.6276.146.camel@marge.simpson.net>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Date: Mon, 20 Feb 2012 19:14:21 +0100
In-Reply-To: <1329748861.2293.345.camel@twins>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
	 <1321629267.7080.13.camel@marge.simson.net>
	 <1329748861.2293.345.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 15:41 +0100, Peter Zijlstra wrote: 
> On Fri, 2011-11-18 at 16:14 +0100, Mike Galbraith wrote:
> 
> > ---
> >  kernel/sched_fair.c |   10 ++--------
> >  1 file changed, 2 insertions(+), 8 deletions(-)
> > 
> > Index: linux-3.0-tip/kernel/sched_fair.c
> > ===================================================================
> > --- linux-3.0-tip.orig/kernel/sched_fair.c
> > +++ linux-3.0-tip/kernel/sched_fair.c
> > @@ -2276,17 +2276,11 @@ static int select_idle_sibling(struct ta
> >  		for_each_cpu_and(i, sched_domain_span(sd), tsk_cpus_allowed(p)) {
> >  			if (idle_cpu(i)) {
> >  				target = i;
> > +				if (sd->flags & SD_SHARE_CPUPOWER)
> > +					continue;
> >  				break;
> >  			}
> >  		}
> > -
> > -		/*
> > -		 * Lets stop looking for an idle sibling when we reached
> > -		 * the domain that spans the current cpu and prev_cpu.
> > -		 */
> > -		if (cpumask_test_cpu(cpu, sched_domain_span(sd)) &&
> > -		    cpumask_test_cpu(prev_cpu, sched_domain_span(sd)))
> > -			break;
> >  	}
> >  	rcu_read_unlock();
> 
> Mike, Suresh, did we ever get this sorted? I was looking at
> select_idle_sibling() and it looks like we dropped this.

I thought this was pretty much sorted.  We want to prefer core over
sibling, because on at laest some modern CPUs with L3, siblings suck
rocks.

> Also, did anybody ever get an answer from a HW guy on why sharing stuff
> over SMT threads is so much worse than sharing it over proper cores?

No.  My numbers on westmere indicated to me that siblings do not share
L2, making them fairly worthless.  Hard facts we never got.

> Its
> not like this workload actually does anything concurrently.
> 
> I was looking at this code due to vatsa wanting to do SD_BALANCE_WAKE.

I really really need to find time to do systematic mainline testing.

Enabling SD_BALANCE_WAKE used to be decidedly too expensive to consider.
Maybe that has changed, but I doubt it.  (general aside: testing with a
bloated distro config is a big mistake)

-Mike

