Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab2C1JYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 05:24:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55822 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736Ab2C1JYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 05:24:47 -0400
Date: Wed, 28 Mar 2012 11:24:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Subject: Re: [PATCH 2/5] perf: generic intel uncore support
Message-ID: <20120328092446.GY22197@one.firstfloor.org>
References: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com> <1332916998-10628-3-git-send-email-zheng.z.yan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332916998-10628-3-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Overall the driver looks rather good. Thanks.

On Wed, Mar 28, 2012 at 02:43:15PM +0800, Yan, Zheng wrote:
> +static void uncore_perf_event_update(struct intel_uncore_box *box,
> +				      struct perf_event *event)
> +{
> +	raw_spin_lock(&box->lock);

I think a raw lock would be only needed if the uncore was called
from the scheduler context switch, which it should not be.

So you can use a normal lock instead of a raw lock.


> +static void uncore_pmu_start_hrtimer(struct intel_uncore_box *box)
> +{
> +	__hrtimer_start_range_ns(&box->hrtimer,
> +				ns_to_ktime(UNCORE_PMU_HRTIMER_INTERVAL), 0,
> +				HRTIMER_MODE_REL_PINNED, 0);
> +}

Can probably do some slack to be more friendly for power.

> +static struct intel_uncore_box *
> +uncore_pmu_find_box(struct intel_uncore_pmu *pmu, int phyid)
> +{
> +	struct intel_uncore_box *box;
> +
> +	rcu_read_lock();

I'm not sure RCU is really needed here, are any of those paths
time critical? But ok shouldn't hurt either.

> +static int __init uncore_cpu_init(void)
> +{
> +	int ret, cpu;
> +
> +	switch (boot_cpu_data.x86_model) {
> +	default:
> +		return 0;
> +	}

Needs a case? Always returns?

> +
> +	ret = uncore_types_init(msr_uncores);
> +	if (ret)
> +		return ret;
> +
> +	get_online_cpus();
> +	for_each_online_cpu(cpu)
> +		uncore_cpu_prepare(cpu);
> +
> +	preempt_disable();
> +	smp_call_function(uncore_cpu_setup, NULL, 1);
> +	uncore_cpu_setup(NULL);
> +	preempt_enable();

That's on_each_cpu()


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
