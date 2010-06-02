Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241Ab0FBWD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:03:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:31101 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933218Ab0FBWDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:03:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,349,1272870000"; 
   d="scan'208";a="804235307"
Subject: Re: [patch 7/7] timers: use nearest busy cpu for migrating timers
 from an idle cpu
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       Venkatesh Pallipadi <venki@google.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Nigel Cunningham <ncunningham@crca.org.au>
In-Reply-To: <20100601233732.GB7764@dirshya.in.ibm.com>
References: <20100517182726.089700767@sbs-t61.sc.intel.com>
	 <20100517184028.114595207@sbs-t61.sc.intel.com>
	 <20100601233732.GB7764@dirshya.in.ibm.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 02 Jun 2010 15:02:30 -0700
Message-Id: <1275516150.2913.276.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 16:37 -0700, Vaidyanathan Srinivasan wrote:
> * Suresh Siddha <suresh.b.siddha@intel.com> [2010-05-17 11:27:33]:
> 
> > Currently we are migrating the unpinned timers from an idle to the cpu
> > doing idle load balancing (when all the cpus in the system are idle,
> > there is no idle load balacncing cpu and timers get added to the same idle cpu
> > where the request was made. So the current optimization works only on semi idle
> > system).
> > 
> > And In semi idle system, we no longer have periodic ticks on the idle cpu
> > doing the idle load balancing on behalf of all the cpu's. Using that cpu
> > will add more delays to the timers than intended (as that cpu's timer base
> > may not be uptodate wrt jiffies etc). This was causing mysterious slowdowns
> > during boot etc.
> 
> Hi Suresh,
> 
> Can please give more info on why this caused delay in bootup or timer
> event.  The jiffies should be updated even with the current push model
> right.  We will still have some pinned timer on the idle cpu and the
> time base will have to be updated when the timer event happens.

with these changes, idle load balancer doesn't have periodic ticks in
idle. So for that cpu, timer_jiffies in timer base won't be uptodate
when another idle cpu adds timer to this cpu. So, we will introduce more
delays for the timers than expected.

> > For now, in the semi idle case, use the nearest busy cpu for migrating timers from an
> > idle cpu.  This is good for power-savings anyway.
> 
> Yes.  This is good solution.  But on a large system the only running
> cpu may accumulate too may timers that could affect the performance of
> the task running.  We will need to test this out.

Yes. It will be good to have an impact of this on big systems. If we see
any performance issues, we can migrate the timers only when
power-savings tunable is selected.

> 
> >  #ifdef CONFIG_NO_HZ
> > +int get_nohz_timer_target(void)
> > +{
> > +	int cpu = smp_processor_id();
> > +	int i;
> > +	struct sched_domain *sd;
> > +
> > +	for_each_domain(cpu, sd) {
> > +		for_each_cpu(i, sched_domain_span(sd))
> > +			if (!idle_cpu(i))
> > +				return i;
> > +	}
> > +	return cpu;
> > +}
> 
> We will need a better way of finding the right CPU since this code
> will take longer time on a larger system with one or two busy cpus.
> 
> We should perhaps pick the cpu from the compliment of the current
> nohz.grp_idle_mask or something derived from these masks instead of
> searching in the sched domain.  Only advantage I see is that we will
> get the busy CPU nearest as in same node which is better.

Yes I wanted to migrate the timers to the nearest busy cpu aswell as
distribute the load among all the busy cpus (if there are multiple cpu's
busy).

thanks,
suresh

