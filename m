Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab0GHR4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 13:56:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:59310 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652Ab0GHR4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 13:56:06 -0400
Subject: Re: [PATCH] sched: Call update_group_power only for local_group
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>,
       LKML <linux-kernel@vger.kernel.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Michael Neuling <mikey@neuling.org>
In-Reply-To: <1278611416.2834.12.camel@sbs-t61.sc.intel.com>
References: <1278088816.1917.279.camel@laptop>
	 <1278089799-11949-1-git-send-email-venki@google.com>
	 <1278598336.1900.150.camel@laptop>
	 <1278611133.2834.10.camel@sbs-t61.sc.intel.com>
	 <1278611346.1900.165.camel@laptop>
	 <1278611416.2834.12.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Jul 2010 19:55:55 +0200
Message-ID: <1278611755.1900.169.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 10:50 -0700, Suresh Siddha wrote:
> On Thu, 2010-07-08 at 10:49 -0700, Peter Zijlstra wrote:
> > On Thu, 2010-07-08 at 10:45 -0700, Suresh Siddha wrote:
> > >  
> > > @@ -2456,6 +2454,9 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
> > >  	init_sd_power_savings_stats(sd, sds, idle);
> > >  	load_idx = get_sd_load_idx(sd, idle);
> > >  
> > > +	if (this_cpu == smp_processor_id())
> > > +		update_group_power(sd, this_cpu);
> > > +
> > >  	do {
> > >  		int local_group;
> > 
> > Which will break for nohz_idle_balance..
> 
> Then the logic is broken somewhere because update_group_power() reads
> APERF/MPERF MSR's which doesn't make sense when this_cpu !=
> smp_processor_id(). What am I missing?

The APERF/MPERF code is utterly broken.. (and currently disabled by
default) but yeah, that's one aspect of its brokenness I only realized
after your email.

The problem is that it measures current throughput, not current
capacity. So for an idle thread/core it would return 0, instead of the
potential.

I've been meaning to revisit this.. maybe I should simply rip that out
until I get it working.

I was thinking of measuring temporal maxima to approximate capacity
instead of throughput.
