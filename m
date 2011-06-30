Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab1F3Q6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 12:58:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52741 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1F3Q6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 12:58:53 -0400
Date: Thu, 30 Jun 2011 18:58:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] perf, x86: Add Intel Nehalem/Westmere uncore pmu
Message-ID: <20110630165849.GE23059@one.firstfloor.org>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com> <1309421396-17438-2-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309421396-17438-2-git-send-email-ming.m.lin@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 08:09:53AM +0000, Lin Ming wrote:
> +static u64 uncore_perf_event_update(struct perf_event *event)
> +{
> +	struct hw_perf_event *hwc = &event->hw;
> +	int shift = 64 - intel_uncore_pmu.cntval_bits;
> +	u64 prev_raw_count, new_raw_count;
> +	s64 delta;
> +
> +	/*
> +	 * Careful: an NMI might modify the previous event value.

There are no NMIs without sampling, so at least the comment seems bogus.
Perhaps the code could be a bit simplified now without atomics.

> +static int uncore_pmu_event_init(struct perf_event *event)
> +{
> +	struct hw_perf_event *hwc = &event->hw;
> +
> +	if (!uncore_pmu_initialized)
> +		return -ENOENT;
> +
> +	if (event->attr.type != uncore_pmu.type)
> +		return -ENOENT;
> +
> +	/*
> +	 * Uncore PMU does measure at all privilege level all the time.
> +	 * So it doesn't make sense to specify any exclude bits.
> +	 */
> +	if (event->attr.exclude_user || event->attr.exclude_kernel
> +	    || event->attr.exclude_hv || event->attr.exclude_idle)
> +		return -ENOENT;
> +
> +	/* Sampling not supported yet */
> +	if (hwc->sample_period)
> +		return -EINVAL;

Don't we need a "is root" check here? uncore counts everything, so
it cannot be limited to a single process.

> +static void uncore_pmu_cpu_starting(int cpu)
> +{
> +	struct cpu_uncore_events *cpuc = &per_cpu(cpu_uncore_events, cpu);
> +	struct intel_uncore *uncore;
> +	int i, uncore_id;
> +
> +	if (boot_cpu_data.x86_max_cores < 2)
> +		return;

Why that check? uncore counting should work on a single core system too.

I think you should remove all of those.

> +
> +	uncore_id = topology_physical_package_id(cpu);
> +	WARN_ON_ONCE(uncore_id == BAD_APICID);
> +
> +	raw_spin_lock(&intel_uncore_lock);

Does this really need to be a raw spinlock? 

> +#define NHM_MSR_UNCORE_PERF_GLOBAL_CTRL    	0x391
> +#define NHM_MSR_UNCORE_PMC0			0x3b0
> +#define NHM_MSR_UNCORE_PERFEVTSEL0		0x3c0

These should be in msr-index.h


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
