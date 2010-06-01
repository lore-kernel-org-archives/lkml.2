Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab0FAXhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 19:37:48 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:38792 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab0FAXhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 19:37:47 -0400
Date: Wed, 2 Jun 2010 05:07:32 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       Venkatesh Pallipadi <venki@google.com>, ego@in.ibm.com,
       LKML <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [patch 7/7] timers: use nearest busy cpu for migrating timers
 from an idle cpu
Message-ID: <20100601233732.GB7764@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20100517182726.089700767@sbs-t61.sc.intel.com>
 <20100517184028.114595207@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100517184028.114595207@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha <suresh.b.siddha@intel.com> [2010-05-17 11:27:33]:

> Currently we are migrating the unpinned timers from an idle to the cpu
> doing idle load balancing (when all the cpus in the system are idle,
> there is no idle load balacncing cpu and timers get added to the same idle cpu
> where the request was made. So the current optimization works only on semi idle
> system).
> 
> And In semi idle system, we no longer have periodic ticks on the idle cpu
> doing the idle load balancing on behalf of all the cpu's. Using that cpu
> will add more delays to the timers than intended (as that cpu's timer base
> may not be uptodate wrt jiffies etc). This was causing mysterious slowdowns
> during boot etc.

Hi Suresh,

Can please give more info on why this caused delay in bootup or timer
event.  The jiffies should be updated even with the current push model
right.  We will still have some pinned timer on the idle cpu and the
time base will have to be updated when the timer event happens.

> 
> For now, in the semi idle case, use the nearest busy cpu for migrating timers from an
> idle cpu.  This is good for power-savings anyway.

Yes.  This is good solution.  But on a large system the only running
cpu may accumulate too may timers that could affect the performance of
the task running.  We will need to test this out.

> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  include/linux/sched.h |    2 +-
>  kernel/hrtimer.c      |    8 ++------
>  kernel/sched.c        |   13 +++++++++++++
>  kernel/timer.c        |    8 ++------
>  4 files changed, 18 insertions(+), 13 deletions(-)
> 
> Index: tip/kernel/hrtimer.c
> ===================================================================
> --- tip.orig/kernel/hrtimer.c
> +++ tip/kernel/hrtimer.c
> @@ -144,12 +144,8 @@ struct hrtimer_clock_base *lock_hrtimer_
>  static int hrtimer_get_target(int this_cpu, int pinned)
>  {
>  #ifdef CONFIG_NO_HZ
> -	if (!pinned && get_sysctl_timer_migration() && idle_cpu(this_cpu)) {
> -		int preferred_cpu = get_nohz_load_balancer();
> -
> -		if (preferred_cpu < nr_cpu_ids)
> -			return preferred_cpu;
> -	}
> +	if (!pinned && get_sysctl_timer_migration() && idle_cpu(this_cpu))
> +		return get_nohz_timer_target();
>  #endif
>  	return this_cpu;
>  }
> Index: tip/kernel/sched.c
> ===================================================================
> --- tip.orig/kernel/sched.c
> +++ tip/kernel/sched.c
> @@ -1201,6 +1201,19 @@ static void resched_cpu(int cpu)
>  }
> 
>  #ifdef CONFIG_NO_HZ
> +int get_nohz_timer_target(void)
> +{
> +	int cpu = smp_processor_id();
> +	int i;
> +	struct sched_domain *sd;
> +
> +	for_each_domain(cpu, sd) {
> +		for_each_cpu(i, sched_domain_span(sd))
> +			if (!idle_cpu(i))
> +				return i;
> +	}
> +	return cpu;
> +}

We will need a better way of finding the right CPU since this code
will take longer time on a larger system with one or two busy cpus.

We should perhaps pick the cpu from the compliment of the current
nohz.grp_idle_mask or something derived from these masks instead of
searching in the sched domain.  Only advantage I see is that we will
get the busy CPU nearest as in same node which is better.

--Vaidy

[snip]
