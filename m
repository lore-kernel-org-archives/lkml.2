Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab2C1LYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:24:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:50778 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757521Ab2C1LYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:24:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="82549383"
Message-ID: <4F72F4E0.6010609@intel.com>
Date: Wed, 28 Mar 2012 19:24:16 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: a.p.zijlstra@chello.nl, mingo@elte.hu, eranian@google.com,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Subject: Re: [PATCH 2/5] perf: generic intel uncore support
References: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com> <1332916998-10628-3-git-send-email-zheng.z.yan@intel.com> <20120328092446.GY22197@one.firstfloor.org>
In-Reply-To: <20120328092446.GY22197@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2012 05:24 PM, Andi Kleen wrote:
> Overall the driver looks rather good. Thanks.
> 
> On Wed, Mar 28, 2012 at 02:43:15PM +0800, Yan, Zheng wrote:
>> +static void uncore_perf_event_update(struct intel_uncore_box *box,
>> +				      struct perf_event *event)
>> +{
>> +	raw_spin_lock(&box->lock);
> 
> I think a raw lock would be only needed if the uncore was called
> from the scheduler context switch, which it should not be.
> 
> So you can use a normal lock instead of a raw lock.
>
> 
>> +static void uncore_pmu_start_hrtimer(struct intel_uncore_box *box)
>> +{
>> +	__hrtimer_start_range_ns(&box->hrtimer,
>> +				ns_to_ktime(UNCORE_PMU_HRTIMER_INTERVAL), 0,
>> +				HRTIMER_MODE_REL_PINNED, 0);
>> +}
> 
> Can probably do some slack to be more friendly for power.
> 
>> +static struct intel_uncore_box *
>> +uncore_pmu_find_box(struct intel_uncore_pmu *pmu, int phyid)
>> +{
>> +	struct intel_uncore_box *box;
>> +
>> +	rcu_read_lock();
> 
> I'm not sure RCU is really needed here, are any of those paths
> time critical? But ok shouldn't hurt either.
>
It's not time critical. but using RCU here is as simple as
using lock. So I decided to use RCU.

 
>> +static int __init uncore_cpu_init(void)
>> +{
>> +	int ret, cpu;
>> +
>> +	switch (boot_cpu_data.x86_model) {
>> +	default:
>> +		return 0;
>> +	}
> 
> Needs a case? Always returns?

later patches add code to here

> 
>> +
>> +	ret = uncore_types_init(msr_uncores);
>> +	if (ret)
>> +		return ret;
>> +
>> +	get_online_cpus();
>> +	for_each_online_cpu(cpu)
>> +		uncore_cpu_prepare(cpu);
>> +
>> +	preempt_disable();
>> +	smp_call_function(uncore_cpu_setup, NULL, 1);
>> +	uncore_cpu_setup(NULL);
>> +	preempt_enable();
> 
> That's on_each_cpu()
> 
will switch to on_each_cpu() in later version of patches

Thanks
Yan, Zheng
> 
> -Andi

