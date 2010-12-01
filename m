Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab0LAO0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 09:26:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:45321 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0LAO0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 09:26:13 -0500
Subject: Re: [PATCH 2/3] perf-events: Add support for supplementary event
 registers v4
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, eranian@google.com
In-Reply-To: <1291036374-24710-3-git-send-email-andi@firstfloor.org>
References: <1291036374-24710-1-git-send-email-andi@firstfloor.org>
	 <1291036374-24710-3-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Dec 2010 15:26:28 +0100
Message-ID: <1291213588.32004.1560.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 14:12 +0100, Andi Kleen wrote:

> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 817d2b1..a6754ea 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -93,6 +93,8 @@ struct amd_nb {
>  	struct event_constraint event_constraints[X86_PMC_IDX_MAX];
>  };
>  
> +struct intel_percore;
> +
>  #define MAX_LBR_ENTRIES		16
>  
>  struct cpu_hw_events {
> @@ -128,6 +130,13 @@ struct cpu_hw_events {
>  	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
>  
>  	/*
> +	 * Intel percore register state.
> +	 * Coordinate shared resources between HT threads.
> +	 */
> +	int				percore_used; /* Used by this CPU? */
> +	struct intel_percore		*per_core;
> +
> +	/*
>  	 * AMD specific bits
>  	 */
>  	struct amd_nb		*amd_nb;

> +/*
> + * Per core state
> + * This used to coordinate shared registers for HT threads.
> + */
> +struct intel_percore {
> +	raw_spinlock_t		lock;		/* protect structure */
> +	struct er_account	regs[MAX_EXTRA_REGS];
> +	int			refcnt;		/* number of threads */
> +	unsigned		core_id;
> +};
> +
>  /*
>   * Intel PerfMon, used on Core and later.
>   */


> +static int intel_pmu_cpu_prepare(int cpu)
> +{
> +	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
> +	
> +	cpuc->per_core = kzalloc_node(sizeof(struct intel_percore), 
> +				      GFP_KERNEL, cpu_to_node(cpu));
> +	if (!cpuc->per_core)
> +		return NOTIFY_BAD;
> +
> +	raw_spin_lock_init(&cpuc->per_core->lock);
> +	cpuc->per_core->core_id = -1;
> +	return NOTIFY_OK;
> +}
> +
>  static void intel_pmu_cpu_starting(int cpu)
>  {
> +	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
> +	int core_id = topology_core_id(cpu);
> +	int i;
> +
> +	for_each_online_cpu(i) {
> +		struct intel_percore *pc = per_cpu(cpu_hw_events, i).per_core;
> +
> +		if (pc && pc->core_id == core_id) {
> +			kfree(cpuc->per_core);
> +			cpuc->per_core = pc;
> +			break;
> +		}
> +	}
> +
> +	cpuc->per_core->core_id = core_id;
> +	cpuc->per_core->refcnt++;
> +
>  	init_debug_store_on_cpu(cpu);
>  	/*
>  	 * Deal with CPUs that don't clear their LBRs on power-up.
> @@ -868,6 +1049,15 @@ static void intel_pmu_cpu_starting(int cpu)
>  
>  static void intel_pmu_cpu_dying(int cpu)
>  {
> +	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
> +	struct intel_percore *pc = cpuc->per_core;
> +	
> +	if (pc) {
> +		if (pc->core_id == -1 || --pc->refcnt == 0)
> +			kfree(pc);
> +		cpuc->per_core = NULL;
> +	}
> +
>  	fini_debug_store_on_cpu(cpu);
>  }
>  
> @@ -892,7 +1082,9 @@ static __initconst const struct x86_pmu intel_pmu = {
>  	 */
>  	.max_period		= (1ULL << 31) - 1,
>  	.get_event_constraints	= intel_get_event_constraints,
> +	.put_event_constraints	= intel_put_event_constraints,
>  
> +	.cpu_prepare		= intel_pmu_cpu_prepare,
>  	.cpu_starting		= intel_pmu_cpu_starting,
>  	.cpu_dying		= intel_pmu_cpu_dying,
>  };
> @@ -1010,7 +1202,10 @@ static __init int intel_pmu_init(void)
>  		intel_pmu_lbr_init_nhm();
>  
>  		x86_pmu.event_constraints = intel_nehalem_event_constraints;
> +		x86_pmu.percore_constraints =
> +			intel_nehalem_percore_constraints;
>  		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
> +		x86_pmu.extra_regs = intel_nehalem_extra_regs;
>  		pr_cont("Nehalem events, ");
>  		break;
>  
> @@ -1032,7 +1227,10 @@ static __init int intel_pmu_init(void)
>  		intel_pmu_lbr_init_nhm();
>  
>  		x86_pmu.event_constraints = intel_westmere_event_constraints;
> +		x86_pmu.percore_constraints =
> +			intel_westmere_percore_constraints;
>  		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
> +		x86_pmu.extra_regs = intel_westmere_extra_regs;
>  		pr_cont("Westmere events, ");
>  		break;
>  

You seem to have lost the needs_percore stuff.
