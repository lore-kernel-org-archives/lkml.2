Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab2BTPE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 10:04:29 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:58073 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab2BTPE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 10:04:28 -0500
Date: Mon, 20 Feb 2012 20:33:49 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
Message-ID: <20120220150348.GC2350@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1329748861.2293.345.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12022015-2674-0000-0000-00000366EBF1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-02-20 15:41:01]:

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
> 
> Also, did anybody ever get an answer from a HW guy on why sharing stuff
> over SMT threads is so much worse than sharing it over proper cores? Its
> not like this workload actually does anything concurrently.
> 
> I was looking at this code due to vatsa wanting to do SD_BALANCE_WAKE.

>From a quick scan of that code, it seems to prefer selecting an idle cpu
in the same cache domain (vs selecting prev_cpu in absence of a core
that is fully idle). 

I can give that a try for my benchmark and see how much it helps. My
suspicion is it will not fully solve the problem I have on hand.

- vatsa

