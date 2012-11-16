Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab2KPSnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:43:55 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49547 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2KPSnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:43:53 -0500
Date: Fri, 16 Nov 2012 19:43:44 +0100
From: Robert Richter <rric@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] perf, amd: Enable northbridge performance counters
 on AMD family 15h
Message-ID: <20121116184344.GR2504@rric.localhost>
References: <1353015113-13262-1-git-send-email-jacob.shin@amd.com>
 <1353015113-13262-5-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353015113-13262-5-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacob,

On 15.11.12 15:31:53, Jacob Shin wrote:
> On AMD family 15h processors, there are 4 new performance counters
> (in addition to 6 core performance counters) that can be used for
> counting northbridge events (i.e. DRAM accesses). Their bit fields are
> almost identical to the core performance counters. However, unlike the
> core performance counters, these MSRs are shared between multiple
> cores (that share the same northbridge). We will reuse the same code
> path as existing family 10h northbridge event constraints handler
> logic to enforce this sharing.
> 
> These new counters are indexed contiguously right above the existing
> core performance counters, and their indexes correspond to RDPMC ECX
> values.
> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>

your approach looks ok to me in general, but see my comments inline.

> @@ -156,31 +161,28 @@ static inline int amd_pmu_addr_offset(int index)
>  	if (offset)
>  		return offset;
>  
> -	if (!cpu_has_perfctr_core)
> +	if (!cpu_has_perfctr_core) {
>  		offset = index;
> -	else
> +		ncore = AMD64_NUM_COUNTERS;
> +	} else {
>  		offset = index << 1;
> +		ncore = AMD64_NUM_COUNTERS_CORE;
> +	}
> +
> +	/* find offset of NB counters with respect to x86_pmu.eventsel */
> +	if (cpu_has_perfctr_nb) {
> +		if (index >= ncore && index < (ncore + AMD64_NUM_COUNTERS_NB))
> +			offset = (MSR_F15H_NB_PERF_CTL - x86_pmu.eventsel) +
> +				 ((index - ncore) << 1);
> +	}

There is duplicate calculatoin of offset in some cases. Better we
avoid this.

> +static int __amd_nb_hw_config(struct perf_event *event)
> +{
> +	if (event->attr.exclude_user || event->attr.exclude_kernel ||
> +	    event->attr.exclude_host || event->attr.exclude_guest)
> +		return -EINVAL;
>  
> -	event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
> +	event->hw.config &= ~ARCH_PERFMON_EVENTSEL_USR;
> +	event->hw.config &= ~ARCH_PERFMON_EVENTSEL_OS;
> +
> +	if (event->hw.config & ~(AMD64_EVENTSEL_EVENT        |
> +				 ARCH_PERFMON_EVENTSEL_UMASK |
> +				 ARCH_PERFMON_EVENTSEL_INT   |
> +				 AMD_PERFMON_EVENTSEL_INT_CORE_ENABLE |
> +				 AMD_PERFMON_EVENTSEL_INT_CORE_SEL_MASK))
> +		return -EINVAL;
>  
>  	return 0;
>  }

Comments are missing and an AMD64_NB_EVENT_MASK macro should be
defined for the above. See my previous version for reference:

/*
 * AMD NB counters (MSRs 0xc0010240 etc.) do not support the following
 * flags:
 *
 *  Host/Guest Only
 *  Counter Mask
 *  Invert Comparison
 *  Edge Detect
 *  Operating-System Mode
 *  User Mode
 *
 * Try to fix the config for default settings, otherwise fail.
 */
static int amd_nb_event_config(struct perf_event *event)
{
       if (!amd_is_nb_perfctr_event(&event->hw))
               return 0;

       if (event->attr.exclude_host || event->attr.exclude_guest
           || event->attr.exclude_user || event->attr.exclude_kernel)
               goto fail;

       event->hw.config &= ~(ARCH_PERFMON_EVENTSEL_USR | ARCH_PERFMON_EVENTSEL_OS);

       if (event->hw.config & ~(AMD64_NB_EVENT_MASK | ARCH_PERFMON_EVENTSEL_INT))
               goto fail;

       return 0;
fail:
       pr_debug("Invalid nb counter config value: %016Lx\n", event->hw.config);
       return -EINVAL;
}


> @@ -323,6 +368,16 @@ __amd_get_nb_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *ev
>  	if (new == -1)
>  		return &emptyconstraint;
>  
> +	/* set up interrupts to be delivered only to this core */
> +	if (cpu_has_perfctr_nb) {
> +		struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
> +
> +		hwc->config |= AMD_PERFMON_EVENTSEL_INT_CORE_ENABLE;
> +		hwc->config &= ~AMD_PERFMON_EVENTSEL_INT_CORE_SEL_MASK;
> +		hwc->config |= (0ULL | (c->cpu_core_id)) <<
> +			AMD_PERFMON_EVENTSEL_INT_CORE_SEL_SHIFT;
> +	}

Looks like a hack to me. The constaints handler is only supposed to
determine constraints and not to touch anything in the event's
structure. This should be done later when setting up hwc->config in
amd_nb_event_config() or so.

I also do not think that smp_processor_id() is the right thing to do
here. Since cpu_hw_events is per-cpu the cpu is already selected.

> +
>  	return &nb->event_constraints[new];
>  }
>  
> @@ -520,6 +575,7 @@ static struct event_constraint amd_f15_PMC3  = EVENT_CONSTRAINT(0, 0x08, 0);
>  static struct event_constraint amd_f15_PMC30 = EVENT_CONSTRAINT_OVERLAP(0, 0x09, 0);
>  static struct event_constraint amd_f15_PMC50 = EVENT_CONSTRAINT(0, 0x3F, 0);
>  static struct event_constraint amd_f15_PMC53 = EVENT_CONSTRAINT(0, 0x38, 0);
> +static struct event_constraint amd_f15_NBPMC30 = EVENT_CONSTRAINT(0, 0x3C0, 0);

The counter index mask depends on the number of core counters which is
either 4 or 6 (depending on cpu_has_perfctr_core).

>  static int setup_event_constraints(void)
>  {
> -	if (boot_cpu_data.x86 >= 0x15)
> +	if (boot_cpu_data.x86 == 0x15)
>  		x86_pmu.get_event_constraints = amd_get_event_constraints_f15h;

Since this does not cover family 16h anymore, you also need to extend
amd_get_event_ constraints() to setup nb counters with __amd_get_nb_
event_constraints() if cpu_has_perfctr_nb is set.

>  	return 0;
>  }
> @@ -655,6 +714,18 @@ static int setup_perfctr_core(void)
>  	return 0;
>  }
>  
> +static int setup_perfctr_nb(void)
> +{
> +	if (!cpu_has_perfctr_nb)
> +		return -ENODEV;
> +
> +	x86_pmu.num_counters += AMD64_NUM_COUNTERS_NB;

You should add a nb counter mask here which is used for nb counters.

The mask can be either 0x3c0 or 0x0f0 depending on cpu_has_perfctr_
core for later use, you will need it at various locations.

In general I also would try to write the code in a way that make
further cpu_has_perfctr_nb lookups unnecessary. There are many tests
of this your code.

-Robert
