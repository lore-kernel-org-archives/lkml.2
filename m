Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab1GDGdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 02:33:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:40774 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab1GDGdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 02:33:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,471,1304319600"; 
   d="scan'208";a="23461869"
Subject: Re: [PATCH 1/4] perf, x86: Add Intel Nehalem/Westmere uncore pmu
From: Lin Ming <ming.m.lin@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110630165849.GE23059@one.firstfloor.org>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
	 <1309421396-17438-2-git-send-email-ming.m.lin@intel.com>
	 <20110630165849.GE23059@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jul 2011 14:39:01 +0800
Message-ID: <1309761541.18875.40.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 00:58 +0800, Andi Kleen wrote:
> On Thu, Jun 30, 2011 at 08:09:53AM +0000, Lin Ming wrote:
> > +static u64 uncore_perf_event_update(struct perf_event *event)
> > +{
> > +	struct hw_perf_event *hwc = &event->hw;
> > +	int shift = 64 - intel_uncore_pmu.cntval_bits;
> > +	u64 prev_raw_count, new_raw_count;
> > +	s64 delta;
> > +
> > +	/*
> > +	 * Careful: an NMI might modify the previous event value.
> 
> There are no NMIs without sampling, so at least the comment seems bogus.
> Perhaps the code could be a bit simplified now without atomics.

I'm not sure if uncore PMU interrupt need to be enabled for counting
only. What do you think?

> 
> > +static int uncore_pmu_event_init(struct perf_event *event)
> > +{
> > +	struct hw_perf_event *hwc = &event->hw;
> > +
> > +	if (!uncore_pmu_initialized)
> > +		return -ENOENT;
> > +
> > +	if (event->attr.type != uncore_pmu.type)
> > +		return -ENOENT;
> > +
> > +	/*
> > +	 * Uncore PMU does measure at all privilege level all the time.
> > +	 * So it doesn't make sense to specify any exclude bits.
> > +	 */
> > +	if (event->attr.exclude_user || event->attr.exclude_kernel
> > +	    || event->attr.exclude_hv || event->attr.exclude_idle)
> > +		return -ENOENT;
> > +
> > +	/* Sampling not supported yet */
> > +	if (hwc->sample_period)
> > +		return -EINVAL;
> 
> Don't we need a "is root" check here? uncore counts everything, so
> it cannot be limited to a single process.

Yes, will add a "is root" check.

Will add .task_ctx_nr = perf_invalid_context to disallow per-process
counting.

> 
> > +static void uncore_pmu_cpu_starting(int cpu)
> > +{
> > +	struct cpu_uncore_events *cpuc = &per_cpu(cpu_uncore_events, cpu);
> > +	struct intel_uncore *uncore;
> > +	int i, uncore_id;
> > +
> > +	if (boot_cpu_data.x86_max_cores < 2)
> > +		return;
> 
> Why that check? uncore counting should work on a single core system too.
> 
> I think you should remove all of those.

Agree, will remove it.

> 
> > +
> > +	uncore_id = topology_physical_package_id(cpu);
> > +	WARN_ON_ONCE(uncore_id == BAD_APICID);
> > +
> > +	raw_spin_lock(&intel_uncore_lock);
> 
> Does this really need to be a raw spinlock? 

I think spinlock is enough.

> 
> > +#define NHM_MSR_UNCORE_PERF_GLOBAL_CTRL    	0x391
> > +#define NHM_MSR_UNCORE_PMC0			0x3b0
> > +#define NHM_MSR_UNCORE_PERFEVTSEL0		0x3c0
> 
> These should be in msr-index.h

Will move these.

Thanks,
Lin Ming

> 
> 
> -Andi


