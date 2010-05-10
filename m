Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab0EJKBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 06:01:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:21670 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184Ab0EJKBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 06:01:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,361,1270450800"; 
   d="scan'208";a="796959222"
Subject: Re: [RFC][PATCH 5/9] perf: arm, convert to new API pmu->init_event
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1273483672.15998.59.camel@minggr.sh.intel.com>
References: <1273483672.15998.59.camel@minggr.sh.intel.com>
Content-Type: text/plain
Date: Mon, 10 May 2010 18:00:37 +0800
Message-Id: <1273485637.15998.67.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 17:38 +0800, Russell King wrote:
> Unfortunately, this seems to clash with a rework of the ARM PMU/oprofile
> code.  You also really need to copy the guys doing this work, eg the
> authors of arch/arm/kernel/perf_event.c - Will Deacon.

(Add Will Deacon)

I'll check the rework of the ARM PMU/oprofile code.

Thanks.

On Mon, 2010-05-10 at 17:27 +0800, Lin Ming wrote:
> perf: arm, convert to new API pmu->init_event
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  arch/arm/kernel/perf_event.c |   28 +++++++++++++++-------------
>  1 files changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> index 8400ddf..565f13a 100644
> --- a/arch/arm/kernel/perf_event.c
> +++ b/arch/arm/kernel/perf_event.c
> @@ -270,13 +270,6 @@ out:
>  	return err;
>  }
>  
> -static struct pmu pmu = {
> -	.enable	    = armpmu_enable,
> -	.disable    = armpmu_disable,
> -	.unthrottle = armpmu_unthrottle,
> -	.read	    = armpmu_read,
> -};
> -
>  static int
>  validate_event(struct cpu_hw_events *cpuc,
>  	       struct perf_event *event)
> @@ -446,20 +439,19 @@ __hw_perf_event_init(struct perf_event *event)
>  	return err;
>  }
>  
> -struct pmu *
> -hw_perf_event_init(struct perf_event *event)
> +static int armpmu_init_event(struct perf_event *event)
>  {
>  	int err = 0;
>  
>  	if (!armpmu)
> -		return ERR_PTR(-ENODEV);
> +		return -ENODEV;
>  
>  	event->destroy = hw_perf_event_destroy;
>  
>  	if (!atomic_inc_not_zero(&active_events)) {
>  		if (atomic_read(&active_events) > perf_max_events) {
>  			atomic_dec(&active_events);
> -			return ERR_PTR(-ENOSPC);
> +			return -ENOSPC;
>  		}
>  
>  		mutex_lock(&pmu_reserve_mutex);
> @@ -473,15 +465,23 @@ hw_perf_event_init(struct perf_event *event)
>  	}
>  
>  	if (err)
> -		return ERR_PTR(err);
> +		return err;
>  
>  	err = __hw_perf_event_init(event);
>  	if (err)
>  		hw_perf_event_destroy(event);
>  
> -	return err ? ERR_PTR(err) : &pmu;
> +	return err;
>  }
>  
> +static struct pmu pmu = {
> +	.enable	    = armpmu_enable,
> +	.disable    = armpmu_disable,
> +	.unthrottle = armpmu_unthrottle,
> +	.read	    = armpmu_read,
> +	.init_event  = armpmu_init_event,
> +};
> +
>  void
>  hw_perf_enable(void)
>  {
> @@ -2138,6 +2138,8 @@ init_hw_perf_events(void)
>  		pr_info("enabled with %s PMU driver, %d counters available\n",
>  			armpmu->name, armpmu->num_events);
>  
> +	perf_event_register_pmu(&pmu);
> +
>  	return 0;
>  }
>  arch_initcall(init_hw_perf_events);
> 

