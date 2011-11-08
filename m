Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab1KHNy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 08:54:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab1KHNy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 08:54:57 -0500
Date: Tue, 8 Nov 2011 15:54:32 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Subject: Re: [PATCHv2 6/9] perf: expose perf capability to other modules.
Message-ID: <20111108135432.GP3225@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
 <1320323618-10375-7-git-send-email-gleb@redhat.com>
 <1320674870.18053.37.camel@twins>
 <20111108124906.GO3225@redhat.com>
 <1320758811.11519.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320758811.11519.1.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 02:26:51PM +0100, Peter Zijlstra wrote:
> On Tue, 2011-11-08 at 14:49 +0200, Gleb Natapov wrote:
> > > It might make sense to introduce cpuid10_ebx or so, also I think the
> > cpuid10_ebx will have only one field though (event_mask).
> > 
> > > At the very least add a full ebx iteration to disable unsupported events
> > > in the intel-v1 case.
> > I do not understand what do you mean here, cpuid10_ebx was introduced by
> > intel v1 architectural PMU so it should already contain correct information.
> 
> I meant something like the below
> 
Isn't it better to introduce mapping between ebx bits and architectural
events and do for_each_set_bit loop? But I wouldn't want to introduce
patch as below as part of this series. I do not want to introduce
incidental regressions. For instance the patch below will introduce
regression on my Nehalem cpu. It reports value 0x44 in cpuid10.ebx which
means that unhalted_reference_cycles is not available (bit set means
event is not available), but event still works! Actually it is listed as
supported by the cpu in Table A-4 SDM 3B. Go figure.

> ---
>  arch/x86/include/asm/perf_event.h      |   13 +++++++++++++
>  arch/x86/kernel/cpu/perf_event.c       |    3 +++
>  arch/x86/kernel/cpu/perf_event_intel.c |   21 ++++++++++++++++++---
>  3 files changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index f61c62f..98e397a 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -72,6 +72,19 @@ union cpuid10_eax {
>  	unsigned int full;
>  };
>  
> +union cpuid10_ebx {
> +	struct {
> +		unsigned int unhalted_core_cycles:1;
> +		unsigned int instructions_retired:1;
> +		unsigned int unhalted_reference_cycles:1;
> +		unsigned int llc_reference:1;
> +		unsigned int llc_misses:1;
> +		unsigned int branch_instruction_retired:1;
> +		unsigned int branch_misses_retired:1;
> +	} split;
> +	unsigned int full;
> +};
> +
>  union cpuid10_edx {
>  	struct {
>  		unsigned int num_counters_fixed:5;
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 6408910..e4fdb9d 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -336,6 +336,9 @@ int x86_setup_perfctr(struct perf_event *event)
>  	if (config == -1LL)
>  		return -EINVAL;
>  
> +	if (config == -2LL)
> +		return -EOPNOTSUPP;
> +
>  	/*
>  	 * Branch tracing:
>  	 */
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index e09ca20..aaaed9a 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1547,9 +1547,9 @@ static void intel_clovertown_quirks(void)
>  __init int intel_pmu_init(void)
>  {
>  	union cpuid10_edx edx;
> +	union cpuid10_ebx ebx;
>  	union cpuid10_eax eax;
>  	unsigned int unused;
> -	unsigned int ebx;
>  	int version;
>  
>  	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
> @@ -1566,7 +1566,7 @@ __init int intel_pmu_init(void)
>  	 * Check whether the Architectural PerfMon supports
>  	 * Branch Misses Retired hw_event or not.
>  	 */
> -	cpuid(10, &eax.full, &ebx, &unused, &edx.full);
> +	cpuid(10, &eax.full, &ebx.full, &unused, &edx.full);
>  	if (eax.split.mask_length <= ARCH_PERFMON_BRANCH_MISSES_RETIRED)
>  		return -ENODEV;
>  
> @@ -1598,6 +1598,21 @@ __init int intel_pmu_init(void)
>  		x86_pmu.intel_cap.capabilities = capabilities;
>  	}
>  
> +	if (!ebx.split.unhalted_core_cycles)
0 means event is available 1 it is no.

> +		intel_perfmon_event_map[PERF_COUNT_HW_CPU_CYCLES] = -2;
> +	if (!ebx.split.instructions_retired)
> +		intel_perfmon_event_map[PERF_COUNT_HW_INSTRUCTIONS] = -2;
> +	if (!ebx.split.unhalted_reference_cycles)
> +		intel_perfmon_event_map[PERF_COUNT_HW_BUS_CYCLES] = -2;
> +	if (!ebx.split.llc_reference)
> +		intel_perfmon_event_map[PERF_COUNT_HW_CACHE_REFERENCES] = -2;
> +	if (!ebx.split.llc_misses)
> +		intel_perfmon_event_map[PERF_COUNT_HW_CACHE_MISSES] = -2;
> +	if (!ebx.split.branch_instruction_retired)
> +		intel_perfmon_event_map[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = -2;
> +	if (!ebx.split.branch_misses_retired)
> +		intel_perfmon_event_map[PERF_COUNT_HW_BRANCH_MISSES] = -2;
> +
>  	intel_ds_init();
>  
>  	/*
> @@ -1643,7 +1658,7 @@ __init int intel_pmu_init(void)
>  		/* UOPS_EXECUTED.CORE_ACTIVE_CYCLES,c=1,i=1 */
>  		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x1803fb1;
>  
> -		if (ebx & 0x40) {
> +		if (ebx.split.branch_misses_retired) {
>  			/*
>  			 * Erratum AAJ80 detected, we work it around by using
>  			 * the BR_MISP_EXEC.ANY event. This will over-count

--
			Gleb.
