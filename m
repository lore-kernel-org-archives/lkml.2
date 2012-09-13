Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab2IMNDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:03:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58148 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130Ab2IMNDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:03:51 -0400
Date: Thu, 13 Sep 2012 14:03:45 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, a.p.zijlstra@chello.nl,
        rob.herring@calxeda.com, yong.zhang0@gmail.com, namhyung@kernel.org
Subject: Re: [PATCH v4 3/5] ARM: topology: Update cpu_power according to DT
 information
Message-ID: <20120913130345.GE2470@linaro.org>
References: <1341826026-6504-1-git-send-email-vincent.guittot@linaro.org>
 <1341826026-6504-4-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341826026-6504-4-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 11:27:04AM +0200, Vincent Guittot wrote:
> Use cpu compatibility field and clock-frequency field of DT to
> estimate the capacity of each core of the system and to update
> the cpu_power field accordingly.
> This patch enables to put more running tasks on big cores than
> on LITTLE ones. But this patch doesn't ensure that long running
> tasks will run on big cores and short ones on LITTLE cores.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> Reviewed-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  arch/arm/kernel/topology.c |  153 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 153 insertions(+)
> 
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> index eb5fc81..198b084 100644
> --- a/arch/arm/kernel/topology.c
> +++ b/arch/arm/kernel/topology.c
> @@ -17,7 +17,9 @@
>  #include <linux/percpu.h>
>  #include <linux/node.h>
>  #include <linux/nodemask.h>
> +#include <linux/of.h>
>  #include <linux/sched.h>
> +#include <linux/slab.h>
>  
>  #include <asm/cputype.h>
>  #include <asm/topology.h>
> @@ -49,6 +51,152 @@ static void set_power_scale(unsigned int cpu, unsigned long power)
>  	per_cpu(cpu_scale, cpu) = power;
>  }
>  
> +#ifdef CONFIG_OF
> +struct cpu_efficiency {
> +	const char *compatible;
> +	unsigned long efficiency;
> +};
> +
> +/*
> + * Table of relative efficiency of each processors
> + * The efficiency value must fit in 20bit and the final
> + * cpu_scale value must be in the range
> + *   0 < cpu_scale < 3*SCHED_POWER_SCALE/2
> + * in order to return at most 1 when DIV_ROUND_CLOSEST
> + * is used to compute the capacity of a CPU.
> + * Processors that are not defined in the table,
> + * use the default SCHED_POWER_SCALE value for cpu_scale.
> + */
> +struct cpu_efficiency table_efficiency[] = {
> +	{"arm,cortex-a15", 3891},
> +	{"arm,cortex-a7",  2048},
> +	{NULL, },

How accurate would we expect this to be, in general?

How the SoC is integrated will affect things, and throughput is not a
linear function of the clock frequency due to bus and DRAM timing
effects, and so on.

Part of the issue here is that two CPUs can be "compatible" in the DT
sense even when in performance terms there may be significant differences
(different integration options, difference cache sizes, etc.)


If the CPU power estimate doesn't need to be very precise (I suspect it
doesn't?) then then may not be a problem.

Otherwise, could it make sense to put values into the DT itself, or at
least to have the possibility of doing so?

Of course, this can probably be delayed until it proves to be necessary.
Maybe we'll never need it.

Cheers
---Dave

> +};
> +
> +struct cpu_capacity {
> +	unsigned long hwid;
> +	unsigned long capacity;
> +};
> +
> +struct cpu_capacity *cpu_capacity;
> +
> +unsigned long middle_capacity = 1;
> +
> +/*
> + * Iterate all CPUs' descriptor in DT and compute the efficiency
> + * (as per table_efficiency). Also calculate a middle efficiency
> + * as close as possible to  (max{eff_i} - min{eff_i}) / 2
> + * This is later used to scale the cpu_power field such that an
> + * 'average' CPU is of middle power. Also see the comments near
> + * table_efficiency[] and update_cpu_power().
> + */
> +static void __init parse_dt_topology(void)
> +{
> +	struct cpu_efficiency *cpu_eff;
> +	struct device_node *cn = NULL;
> +	unsigned long min_capacity = (unsigned long)(-1);
> +	unsigned long max_capacity = 0;
> +	unsigned long capacity = 0;
> +	int alloc_size, cpu = 0;
> +
> +	alloc_size = nr_cpu_ids * sizeof(struct cpu_capacity);
> +	cpu_capacity = (struct cpu_capacity *)kzalloc(alloc_size, GFP_NOWAIT);
> +
> +	while ((cn = of_find_node_by_type(cn, "cpu"))) {
> +		const u32 *rate, *reg;
> +		int len;
> +
> +		if (cpu >= num_possible_cpus())
> +			break;
> +
> +		for (cpu_eff = table_efficiency; cpu_eff->compatible; cpu_eff++)
> +			if (of_device_is_compatible(cn, cpu_eff->compatible))
> +				break;
> +
> +		if (cpu_eff->compatible == NULL)
> +			continue;
> +
> +		rate = of_get_property(cn, "clock-frequency", &len);
> +		if (!rate || len != 4) {
> +			pr_err("%s missing clock-frequency property\n",
> +				cn->full_name);
> +			continue;
> +		}
> +
> +		reg = of_get_property(cn, "reg", &len);
> +		if (!reg || len != 4) {
> +			pr_err("%s missing reg property\n", cn->full_name);
> +			continue;
> +		}
> +
> +		capacity = ((be32_to_cpup(rate)) >> 20) * cpu_eff->efficiency;
> +
> +		/* Save min capacity of the system */
> +		if (capacity < min_capacity)
> +			min_capacity = capacity;
> +
> +		/* Save max capacity of the system */
> +		if (capacity > max_capacity)
> +			max_capacity = capacity;
> +
> +		cpu_capacity[cpu].capacity = capacity;
> +		cpu_capacity[cpu++].hwid = be32_to_cpup(reg);
> +	}
> +
> +	if (cpu < num_possible_cpus())
> +		cpu_capacity[cpu].hwid = (unsigned long)(-1);
> +
> +	/* If min and max capacities are equals, we bypass the update of the
> +	 * cpu_scale because all CPUs have the same capacity. Otherwise, we
> +	 * compute a middle_capacity factor that will ensure that the capacity
> +	 * of an 'average' CPU of the system will be as close as possible to
> +	 * SCHED_POWER_SCALE, which is the default value, but with the
> +	 * constraint explained near table_efficiency[].
> +	 */
> +	if (min_capacity == max_capacity)
> +		cpu_capacity[0].hwid = (unsigned long)(-1);
> +	else if (4*max_capacity < (3*(max_capacity + min_capacity)))
> +		middle_capacity = (min_capacity + max_capacity)
> +				>> (SCHED_POWER_SHIFT+1);
> +	else
> +		middle_capacity = ((max_capacity / 3)
> +				>> (SCHED_POWER_SHIFT-1)) + 1;
> +
> +}
> +
> +/*
> + * Look for a customed capacity of a CPU in the cpu_capacity table during the
> + * boot. The update of all CPUs is in O(n^2) for heteregeneous system but the
> + * function returns directly for SMP system.
> + */
> +void update_cpu_power(unsigned int cpu, unsigned long hwid)
> +{
> +	unsigned int idx = 0;
> +
> +	/* look for the cpu's hwid in the cpu capacity table */
> +	for (idx = 0; idx < num_possible_cpus(); idx++) {
> +		if (cpu_capacity[idx].hwid == hwid)
> +			break;
> +
> +		if (cpu_capacity[idx].hwid == -1)
> +			return;
> +	}
> +
> +	if (idx == num_possible_cpus())
> +		return;
> +
> +	set_power_scale(cpu, cpu_capacity[idx].capacity / middle_capacity);
> +
> +	printk(KERN_INFO "CPU%u: update cpu_power %lu\n",
> +		cpu, arch_scale_freq_power(NULL, cpu));
> +}
> +
> +#else
> +static inline void parse_dt_topology(void) {}
> +static inline void update_cpu_power(unsigned int cpuid, unsigned int mpidr) {}
> +#endif
> +
> +
>  /*
>   * cpu topology management
>   */
> @@ -62,6 +210,7 @@ static void set_power_scale(unsigned int cpu, unsigned long power)
>   * These masks reflect the current use of the affinity levels.
>   * The affinity level can be up to 16 bits according to ARM ARM
>   */
> +#define MPIDR_HWID_BITMASK 0xFFFFFF
>  
>  #define MPIDR_LEVEL0_MASK 0x3
>  #define MPIDR_LEVEL0_SHIFT 0
> @@ -160,6 +309,8 @@ void store_cpu_topology(unsigned int cpuid)
>  
>  	update_siblings_masks(cpuid);
>  
> +	update_cpu_power(cpuid, mpidr & MPIDR_HWID_BITMASK);
> +
>  	printk(KERN_INFO "CPU%u: thread %d, cpu %d, socket %d, mpidr %x\n",
>  		cpuid, cpu_topology[cpuid].thread_id,
>  		cpu_topology[cpuid].core_id,
> @@ -187,4 +338,6 @@ void init_cpu_topology(void)
>  		set_power_scale(cpu, SCHED_POWER_SCALE);
>  	}
>  	smp_wmb();
> +
> +	parse_dt_topology();
>  }
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev
