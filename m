Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab0KLRRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:17:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:33726 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab0KLRRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:17:44 -0500
Subject: Re: [PATCH 1/2] perf-events: Add support for supplementary event
 registers v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: eranian@google.com, linux-kernel@vger.kernel.org,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu, fweisbec@gmail.com,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
References: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 12 Nov 2010 18:17:45 +0100
Message-ID: <1289582265.2084.328.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 17:55 +0100, Andi Kleen wrote:

> @@ -127,6 +129,13 @@ struct cpu_hw_events {
>  	struct perf_branch_stack	lbr_stack;
>  	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
>  
> +	/* 
> +	 * Intel percore register state.
> +	 * Coordinate shared resources between HT threads.
> +	 */
> +	int 				percore_used; /* Used by this CPU? */
> +	struct intel_percore		*per_core;
> +
>  	/*
>  	 * AMD specific bits
>  	 */

> +/* 
> + * Per core state
> + * This used to coordinate shared resources for HT threads.
> + * Exists per CPU, but only the entry for the first CPU
> + * in the core is used.
> + */
> +struct intel_percore {
> +	raw_spinlock_t 		lock;		/* protect structure */
> +	int 			ref;		/* reference count */
> +	u64 			config;	        /* main counter config */
> +	unsigned int 		extra_reg;	/* extra MSR number */
> +	u64 			extra_config;	/* extra MSR config */
> +};
> +static struct intel_percore __percpu *intel_percore;

Why have this pointer?

> @@ -923,6 +1045,35 @@ static void intel_clovertown_quirks(void)
>  	x86_pmu.pebs_constraints = NULL;
>  }
>  
> +static __initdata int needs_percore = 1; /* CHANGEME */
> +
> +static __init int init_intel_percore(void)
> +{
> +	int cpu;
> +
> +	if (!needs_percore)
> +		return 0;
> +
> +	intel_percore = alloc_percpu(struct intel_percore);
> +	if (!intel_percore)
> +		return -ENOMEM;
> +
> +	for_each_possible_cpu(cpu) {
> +		raw_spin_lock_init(&per_cpu_ptr(intel_percore, cpu)->lock);
> +		per_cpu(cpu_hw_events, cpu).per_core =
> +			per_cpu_ptr(intel_percore,
> +			    cpumask_first(topology_thread_cpumask(cpu)));
> +		printk("cpu %d core %d\n", 
> +		       cpu, cpumask_first(topology_thread_cpumask(cpu)));
> +	}
> +
> +	return 0;
> +}
> +/* 
> + * Runs later because per cpu allocations don't work early on.
> + */
> +__initcall(init_intel_percore);

they should, perf is initialized from sched_init() [ I really should
move it into init/main.c some time ], which is after mm_init(), which
should be sufficient for all allocators to work.

Oh, wait, I ran into this a few days ago, the arch specific init call
actually runs before the main perf init, which is mightly strange, I
have this hunk (http://lkml.org/lkml/2010/11/9/530):

-void __init init_hw_perf_events(void)
+static int __init init_hw_perf_events(void)
 {
 	struct event_constraint *c;
 	int err;
@@ -1363,11 +1363,11 @@ void __init init_hw_perf_events(void)
 		err = amd_pmu_init();
 		break;
 	default:
-		return;
+		return 0;
 	}
 	if (err != 0) {
 		pr_cont("no PMU driver, software events only.\n");
-		return;
+		return 0;
 	}
 
 	pmu_check_apic();
@@ -1418,9 +1418,12 @@ void __init init_hw_perf_events(void)
 	pr_info("... fixed-purpose events:   %d\n",     x86_pmu.num_counters_fixed);
 	pr_info("... event mask:             %016Lx\n", x86_pmu.intel_ctrl);
 
	perf_pmu_register(&pmu);
 	perf_cpu_notifier(x86_pmu_notifier);
+
+	return 0;
 }
+early_initcall(init_hw_perf_events);

To cure that.


That said, why not simply:
  kmalloc_node(sizeof(struct intel_percore)), GFP_KERNEL | __GFP_ZERO, 
	       cpu_to_node(cpu))

For each core, just like amd_alloc_nb() does. The amd code even frees
the allocation on cpu-hot-unplug of after all relevant cpus are gone.

