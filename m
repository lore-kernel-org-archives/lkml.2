Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab1GROVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 10:21:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:48380 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1GROVM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 10:21:12 -0400
Subject: Re: [PATCH v2 2/6] perf, x86: Add Intel Nehalem/Westmere uncore pmu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1310740503-15608-3-git-send-email-ming.m.lin@intel.com>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
	 <1310740503-15608-3-git-send-email-ming.m.lin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Jul 2011 16:20:51 +0200
Message-ID: <1310998851.13765.106.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 14:34 +0000, Lin Ming wrote:
> Add Intel Nehalem/Westmere uncore pmu support.
> And also the generic data structure to support uncore pmu.
> 
> Uncore pmu interrupt does not work, so hrtimer is used to pull counters.

s/pull/poll/

> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> new file mode 100644
> index 0000000..79a501e
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -0,0 +1,450 @@
> +#include "perf_event_intel_uncore.h"
> +
> +static DEFINE_PER_CPU(struct cpu_uncore_events, cpu_uncore_events);
> +static DEFINE_RAW_SPINLOCK(intel_uncore_lock);
> +
> +static bool uncore_pmu_initialized;
> +static struct intel_uncore_pmu intel_uncore_pmu __read_mostly;
> +
> +/*
> + * Uncore pmu interrupt does not work.
> + * Use hrtimer to pull the counter every 10 seconds.
> + */
> +#define UNCORE_PMU_HRTIMER_INTERVAL (10000000000ULL)

 10 * NSEC_PER_SEC

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

-EINVAL, the PMU exists and is the right one, we just don't support
this.

> +	/* Sampling not supported yet */
> +	if (hwc->sample_period)
> +		return -EINVAL;
> +
> +	return 0;
> +}

> +static int uncore_pmu_add(struct perf_event *event, int flags)
> +{
> +	struct cpu_uncore_events *cpuc = &__get_cpu_var(cpu_uncore_events);
> +	struct intel_uncore *uncore = cpuc->intel_uncore;
> +	int ret = 1;
> +	int i;
> +
> +	raw_spin_lock(&uncore->lock);
> +
> +	if (event->attr.config == UNCORE_FIXED_EVENT) {
> +		i = X86_PMC_IDX_FIXED;
> +		goto fixed_event;

Can the GP counters also count that event? If so, what happens if I
start 2 of them?

> +	}
> +
> +	for (i = 0; i < X86_PMC_IDX_FIXED; i++) {
> +fixed_event:
> +		if (!uncore->events[i]) {
> +			uncore->events[i] = event;
> +			uncore->n_events++;
> +			event->hw.idx = i;
> +			__set_bit(i, uncore->active_mask);
> +
> +			intel_uncore_pmu.hw_config(event);
> +
> +			if (flags & PERF_EF_START)
> +				uncore_pmu_start(event, flags);
> +			ret = 0;
> +			break;
> +		}
> +	}
> +
> +	if (uncore->n_events == 1) {
> +		uncore_pmu_start_hrtimer(uncore);
> +		intel_uncore_pmu.enable_all();
> +	}
> +
> +	raw_spin_unlock(&uncore->lock);
> +
> +	return ret;
> +}

uncore is fully symmetric and doesn't have any constraints other than
the fixed counter?

I guess we can start with this, there is still the issue of mapping the
events to a single active cpu in the node, but I guess we can do that a
little later.
