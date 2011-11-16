Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab1KPSeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 13:34:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:63634 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab1KPSeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 13:34:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,522,1315206000"; 
   d="scan'208";a="91455072"
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Date: Wed, 16 Nov 2011 10:37:26 -0800
In-Reply-To: <1321435455.5072.64.camel@marge.simson.net>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 01:24 -0800, Mike Galbraith wrote:
> On Tue, 2011-11-15 at 17:14 -0800, Suresh Siddha wrote:
> 
> > How about this patch which is more self explanatory?
> 
> Actually, after further testing/reading, it looks to me like both of
> these patches have a problem.  They'll never select SMT siblings (so a
> skip SIBLING should accomplish the same).
> 
> This patch didn't select an idle core either though, where Peter's did.
> 
> Tested by pinning a hog to cores 1-3, then starting up an unpinned
> tbench pair.  Peter's patch didn't do the BadThing (as in bad for
> TCP_RR/tbench) in that case, but should have.
> 
> > +		sg = sd->groups;
> > +		do {
> > +			if (!cpumask_intersects(sched_group_cpus(sg),
> > +						tsk_cpus_allowed(p)))
> > +				goto next;
> >  
> > +			for_each_cpu(i, sched_group_cpus(sg)) {
> > +				if (!idle_cpu(i))
> > +					goto next;
> 
> Say target is CPU0.  Groups are 0,4 1,5 2,6 3,7.  0-3 are first CPUs
> encountered in MC groups, all were busy.  At SIBLING level, the only
> group is 0,4.  First encountered CPU of sole group is busy target, so
> we're done.. so we return busy target.
> 
> > +			target = cpumask_first_and(sched_group_cpus(sg),
> > +					tsk_cpus_allowed(p));
> 
> At SIBLING, group = 0,4 = 0x5, 0x5 & 0xff = 1 = target.

Mike, At the sibling level, domain span will be 0,4 which is 0x5. But
there are two individual groups. First group just contains cpu0 and the
second group contains cpu4.

So if cpu0 is busy, we will check the next group to see if it is idle
(which is cpu4 in your example). So we will return cpu-4.

It should be ok. Isn't it?

thanks,
suresh

