Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab2KZMPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 07:15:34 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49534 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab2KZMPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 07:15:33 -0500
Date: Mon, 26 Nov 2012 13:15:24 +0100
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
Message-ID: <20121126121524.GB1877@rric.localhost>
References: <1353015113-13262-1-git-send-email-jacob.shin@amd.com>
 <1353015113-13262-5-git-send-email-jacob.shin@amd.com>
 <20121116184344.GR2504@rric.localhost>
 <20121116190030.GA21468@jshin-Toonie>
 <20121116193224.GS2504@rric.localhost>
 <20121116215718.GB21468@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121116215718.GB21468@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacob,

On 16.11.12 15:57:18, Jacob Shin wrote:
> > It looks like the paths should be defined more clearly.
> 
> Per comments above the function, I was logically going down the cases,
> 1. is this a legacy counter?
> 2. is this a perfctr_core counter?
> 3. is this a perfctr_nb counter?
> 
> To me it seems clear ..

See below...

> So here is v3, how does this look? If okay, could you add Reviewed-by or
> Acked-by ? After that, I'll send out the patchbomb again with review/ack
> on patch [3/4] and [4/4]

I will ack your resent patches if they are looking good to me and we
leave it at the maintainers to add my acked-by after your
signed-off-by.

The direction looks good to me know, but see my comments below.

> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index 4fabcdf..df97186 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -29,9 +29,14 @@
>  #define ARCH_PERFMON_EVENTSEL_INV			(1ULL << 23)
>  #define ARCH_PERFMON_EVENTSEL_CMASK			0xFF000000ULL
>  
> +#define AMD_PERFMON_EVENTSEL_INT_CORE_ENABLE		(1ULL << 36)
>  #define AMD_PERFMON_EVENTSEL_GUESTONLY			(1ULL << 40)
>  #define AMD_PERFMON_EVENTSEL_HOSTONLY			(1ULL << 41)
>  
> +#define AMD_PERFMON_EVENTSEL_INT_CORE_SEL_SHIFT		37
> +#define AMD_PERFMON_EVENTSEL_INT_CORE_SEL_MASK		\
> +	(0xFULL << AMD_PERFMON_EVENTSEL_INT_CORE_SEL_SHIFT)
> +

This is a bit shorter:

 AMD64_EVENTSEL_INT_CORE_SEL_*

AMD64_* refers to AMD architectural definitions in the AMD64 manuals.
AMD_PERFMON_* is actually not consistent here. Arghh, Joerg.

>  #define AMD64_EVENTSEL_EVENT	\
>  	(ARCH_PERFMON_EVENTSEL_EVENT | (0x0FULL << 32))
>  #define INTEL_ARCH_EVENT_MASK	\
> @@ -46,8 +51,12 @@
>  #define AMD64_RAW_EVENT_MASK		\
>  	(X86_RAW_EVENT_MASK          |  \
>  	 AMD64_EVENTSEL_EVENT)
> +#define AMD64_NB_EVENT_MASK		\
> +	(AMD64_EVENTSEL_EVENT        |  \
> +	 ARCH_PERFMON_EVENTSEL_UMASK)

Since this is equivalent to AMD64_RAW_EVENT_MASK a better name would
be AMD64_RAW_EVENT_MASK_NB.

>  #define AMD64_NUM_COUNTERS				4
>  #define AMD64_NUM_COUNTERS_CORE				6
> +#define AMD64_NUM_COUNTERS_NB				4
>  
>  #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		0x3c
>  #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)

>  static inline int amd_pmu_addr_offset(int index)
>  {
>  	int offset;
> +	int ncore;
>  
>  	if (!index)
>  		return index;
> @@ -156,31 +163,27 @@ static inline int amd_pmu_addr_offset(int index)
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

We still go in a block above even if we have a nb counter. See
solution below.

> +
> +	/* find offset of NB counters with respect to x86_pmu.eventsel */
> +	if (amd_nb_event_constraint &&
> +	    test_bit(index, amd_nb_event_constraint->idxmsk))
> +		offset = (MSR_F15H_NB_PERF_CTL - x86_pmu.eventsel) +
> +			 ((index - ncore) << 1);

I prefer the following paths:

	if (amd_nb_event_constraint && ...) {
		/* nb counter */
		...
	} else if (!cpu_has_perfctr_core) {
		/* core counter */
		...
	} else {
		/* legacy counter */
		...
	}

>  
>  	addr_offsets[index] = offset;
>  
>  	return offset;
>  }
>  
> -static int amd_pmu_hw_config(struct perf_event *event)
> +static int __amd_core_hw_config(struct perf_event *event)

No need for underscores...

> +/*
> + * NB counters do not support the following event select bits:
> + *   Host/Guest only
> + *   Counter mask
> + *   Invert counter mask
> + *   Edge detect
> + *   OS/User mode
> + */
> +static int __amd_nb_hw_config(struct perf_event *event)

No need for underscores...

> +{
> +	if (event->attr.exclude_user || event->attr.exclude_kernel ||
> +	    event->attr.exclude_host || event->attr.exclude_guest)
> +		return -EINVAL;
> +
> +	/* set up interrupts to be delivered only to this core */
> +	if (cpu_has_perfctr_nb) {
> +		struct cpuinfo_x86 *c = &cpu_data(event->cpu);
> +
> +		event->hw.config |= AMD_PERFMON_EVENTSEL_INT_CORE_ENABLE;
> +		event->hw.config &= ~AMD_PERFMON_EVENTSEL_INT_CORE_SEL_MASK;
> +		event->hw.config |= (0ULL | (c->cpu_core_id)) <<

Better make the cast visible:

	(u64)(c->cpu_core_id) << AMD_PERFMON_EVENTSEL_INT_CORE_SEL_SHIFT

> +			AMD_PERFMON_EVENTSEL_INT_CORE_SEL_SHIFT;
> +	}
> +
> +	event->hw.config &= ~(ARCH_PERFMON_EVENTSEL_USR |
> +			      ARCH_PERFMON_EVENTSEL_OS);
>  
> -	event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;

Since this is calculated before ...

> +	if (event->hw.config & ~(AMD64_NB_EVENT_MASK                  |
> +				 ARCH_PERFMON_EVENTSEL_INT            |
> +				 AMD_PERFMON_EVENTSEL_INT_CORE_ENABLE |
> +				 AMD_PERFMON_EVENTSEL_INT_CORE_SEL_MASK))

... we can check:

	if (event->hw.config & ~AMD64_NB_EVENT_MASK)

if we move core_sel setup after the check.

Move comment from above here too.

> +		return -EINVAL;
>  
>  	return 0;

> @@ -422,7 +485,10 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
>  	if (!(amd_has_nb(cpuc) && amd_is_nb_event(&event->hw)))
>  		return &unconstrained;
>  
> -	return __amd_get_nb_event_constraints(cpuc, event, &unconstrained);
> +	return __amd_get_nb_event_constraints(cpuc, event,
> +					      amd_nb_event_constraint ? 
> +					      amd_nb_event_constraint :
> +					      &unconstrained);

An option would be to always set amd_nb_event_constraint to
&unconstrained per default. Or, move the check to
__amd_get_nb_event_constraints().

-Robert
