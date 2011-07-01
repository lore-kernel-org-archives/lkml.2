Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab1GAVJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 17:09:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56543 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab1GAVJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 17:09:33 -0400
Date: Fri, 1 Jul 2011 22:09:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH v4] Add ARM cpu topology definition
Message-ID: <20110701210915.GE21898@n2100.arm.linux.org.uk>
References: <1309499010-2049-1-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309499010-2049-1-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 07:43:30AM +0200, Vincent Guittot wrote:
> Changes since v3 :
> * Update the format of printk message
> * Remove blank line

Can I trouble you to check the patch for more instances of the 'blank line
at end of function' thing... Also, let's get rid of unnecessary parens.

> diff --git a/arch/arm/include/asm/topology.h b/arch/arm/include/asm/topology.h
> index accbd7c..63a7454 100644
> --- a/arch/arm/include/asm/topology.h
> +++ b/arch/arm/include/asm/topology.h
> @@ -1,6 +1,39 @@
>  #ifndef _ASM_ARM_TOPOLOGY_H
>  #define _ASM_ARM_TOPOLOGY_H
>  
> +#ifdef CONFIG_ARM_CPU_TOPOLOGY
> +
> +#include <linux/cpumask.h>
> +
> +struct cputopo_arm {
> +	int thread_id;
> +	int core_id;
> +	int socket_id;
> +	cpumask_t thread_sibling;
> +	cpumask_t core_sibling;
> +};
> +
> +extern struct cputopo_arm cpu_topology[NR_CPUS];
> +
> +#define topology_physical_package_id(cpu)	(cpu_topology[cpu].socket_id)
> +#define topology_core_id(cpu)		(cpu_topology[cpu].core_id)
> +#define topology_core_cpumask(cpu)	(&(cpu_topology[cpu].core_sibling))
> +#define topology_thread_cpumask(cpu)	(&(cpu_topology[cpu].thread_sibling))

The inner-most parens aren't required.

> +
> +#define mc_capable()	(cpu_topology[0].socket_id != -1)
> +#define smt_capable()	(cpu_topology[0].thread_id != -1)
> +
> +void init_cpu_topology(void);
> +void store_cpu_topology(unsigned int cpuid);
> +const struct cpumask *cpu_coregroup_mask(unsigned int cpu);
> +
> +#else
> +
> +static inline void init_cpu_topology(void) { };
> +static inline void store_cpu_topology(unsigned int cpuid) { };

Functions don't need a ; after the }

> +
> +#endif
> +
>  #include <asm-generic/topology.h>
>  
>  #endif /* _ASM_ARM_TOPOLOGY_H */
> diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
> index a5b31af..816a481 100644
> --- a/arch/arm/kernel/Makefile
> +++ b/arch/arm/kernel/Makefile
> @@ -61,6 +61,7 @@ obj-$(CONFIG_IWMMXT)		+= iwmmxt.o
>  obj-$(CONFIG_CPU_HAS_PMU)	+= pmu.o
>  obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
>  AFLAGS_iwmmxt.o			:= -Wa,-mcpu=iwmmxt
> +obj-$(CONFIG_ARM_CPU_TOPOLOGY)  += topology.o
>  
>  ifneq ($(CONFIG_ARCH_EBSA110),y)
>    obj-y		+= io.o
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index 344e52b..3e8dc3b 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -31,6 +31,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/cpu.h>
>  #include <asm/cputype.h>
> +#include <asm/topology.h>
>  #include <asm/mmu_context.h>
>  #include <asm/pgtable.h>
>  #include <asm/pgalloc.h>
> @@ -268,6 +269,9 @@ static void __cpuinit smp_store_cpu_info(unsigned int cpuid)
>  	struct cpuinfo_arm *cpu_info = &per_cpu(cpu_data, cpuid);
>  
>  	cpu_info->loops_per_jiffy = loops_per_jiffy;
> +
> +	store_cpu_topology(cpuid);
> +

Don't need this blank line.

>  }
>  
>  /*
> @@ -354,6 +358,8 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
>  {
>  	unsigned int ncores = num_possible_cpus();
>  
> +	init_cpu_topology();
> +
>  	smp_store_cpu_info(smp_processor_id());
>  
>  	/*
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> new file mode 100644
> index 0000000..e8f3b95
> --- /dev/null
> +++ b/arch/arm/kernel/topology.c
> @@ -0,0 +1,149 @@
> +/*
> + * arch/arm/kernel/topology.c
> + *
> + * Copyright (C) 2011 Linaro Limited.
> + * Written by: Vincent Guittot
> + *
> + * based on arch/sh/kernel/topology.c
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details.
> + */
> +
> +#include <linux/cpu.h>
> +#include <linux/cpumask.h>
> +#include <linux/init.h>
> +#include <linux/percpu.h>
> +#include <linux/node.h>
> +#include <linux/nodemask.h>
> +#include <linux/sched.h>
> +
> +#include <asm/cputype.h>
> +#include <asm/topology.h>
> +
> +#define MPIDR_SMP_BITMASK (0x3 << 30)
> +#define MPIDR_SMP_VALUE (0x2 << 30)
> +
> +#define MPIDR_MT_BITMASK (0x1 << 24)
> +
> +/*
> + * These masks reflect the current use of the affinity levels.
> + * The affinity level can be up to 16 bits according to ARM ARM
> + */
> +
> +#define MPIDR_LEVEL0_MASK 0x3
> +#define MPIDR_LEVEL0_SHIFT 0
> +
> +#define MPIDR_LEVEL1_MASK 0xF
> +#define MPIDR_LEVEL1_SHIFT 8
> +
> +#define MPIDR_LEVEL2_MASK 0xFF
> +#define MPIDR_LEVEL2_SHIFT 16
> +
> +struct cputopo_arm cpu_topology[NR_CPUS];
> +
> +const struct cpumask *cpu_coregroup_mask(unsigned int cpu)
> +{
> +	return &(cpu_topology[cpu].core_sibling);

These parens aren't required.

> +}
> +
> +/*
> + * store_cpu_topology is called at boot when only one cpu is running
> + * and with the mutex cpu_hotplug.lock locked, when several cpus have booted,
> + * which prevents simultaneous write access to cpu_topology array
> + */
> +void store_cpu_topology(unsigned int cpuid)
> +{
> +	struct cputopo_arm *cpuid_topo = &(cpu_topology[cpuid]);

Neither are these.

> +	unsigned int mpidr;
> +	unsigned int cpu;
> +
> +	/* If the cpu topology has been already set, just return */
> +	if (cpuid_topo->core_id != -1)
> +		return;
> +
> +	mpidr = read_cpuid_mpidr();
> +
> +	/* create cpu topology mapping */
> +	if ((mpidr & MPIDR_SMP_BITMASK) == MPIDR_SMP_VALUE) {
> +		/*
> +		 * This is a multiprocessor system
> +		 * multiprocessor format & multiprocessor mode field are set
> +		 */
> +
> +		if (mpidr & MPIDR_MT_BITMASK) {
> +			/* core performance interdependency */
> +			cpuid_topo->thread_id = ((mpidr >> MPIDR_LEVEL0_SHIFT)
> +				& MPIDR_LEVEL0_MASK);
> +			cpuid_topo->core_id =  ((mpidr >> MPIDR_LEVEL1_SHIFT)
> +				& MPIDR_LEVEL1_MASK);
> +			cpuid_topo->socket_id = ((mpidr >> MPIDR_LEVEL2_SHIFT)
> +				& MPIDR_LEVEL2_MASK);

Outer set aren't required.

> +		} else {
> +			/* largely independent cores */
> +			cpuid_topo->thread_id = -1;
> +			cpuid_topo->core_id = ((mpidr >> MPIDR_LEVEL0_SHIFT)
> +				& MPIDR_LEVEL0_MASK);
> +			cpuid_topo->socket_id = ((mpidr >> MPIDR_LEVEL1_SHIFT)
> +				& MPIDR_LEVEL1_MASK);

Outer set aren't required.

> +		}
> +	} else {
> +		/*
> +		 * This is an uniprocessor system
> +		 * we are in multiprocessor format but uniprocessor system
> +		 * or in the old uniprocessor format
> +		 */
> +

This blank line isn't necessary.

> +		cpuid_topo->thread_id = -1;
> +		cpuid_topo->core_id = 0;
> +		cpuid_topo->socket_id = -1;
> +	}
> +
> +	/* update core and thread sibling masks */
> +	for_each_possible_cpu(cpu) {
> +		struct cputopo_arm *cpu_topo = &(cpu_topology[cpu]);

Parens not required.

> +
> +		if (cpuid_topo->socket_id == cpu_topo->socket_id) {
> +			cpumask_set_cpu(cpuid, &cpu_topo->core_sibling);
> +			if (cpu != cpuid)
> +				cpumask_set_cpu(cpu,
> +					&cpuid_topo->core_sibling);
> +
> +			if (cpuid_topo->core_id == cpu_topo->core_id) {
> +				cpumask_set_cpu(cpuid,
> +					&cpu_topo->thread_sibling);
> +				if (cpu != cpuid)
> +					cpumask_set_cpu(cpu,
> +						&cpuid_topo->thread_sibling);
> +			}
> +		}
> +	}
> +	smp_wmb();
> +
> +	printk(KERN_INFO "CPU%u: thread %d, cpu %d, socket %d, mpidr %x\n",
> +		cpuid, cpu_topology[cpuid].thread_id,
> +		cpu_topology[cpuid].core_id,
> +		cpu_topology[cpuid].socket_id, mpidr);

Thanks for changing that.

> +}
> +
> +/*
> + * init_cpu_topology is called at boot when only one cpu is running
> + * which prevent simultaneous write access to cpu_topology array
> + */
> +void init_cpu_topology(void)
> +{
> +	unsigned int cpu;
> +
> +	/* init core mask */
> +	for_each_possible_cpu(cpu) {
> +		struct cputopo_arm *cpu_topo = &(cpu_topology[cpu]);
> +
> +		cpu_topo->thread_id = -1;
> +		cpu_topo->core_id =  -1;
> +		cpu_topo->socket_id = -1;
> +		cpumask_clear(&cpu_topo->core_sibling);
> +		cpumask_clear(&cpu_topo->thread_sibling);
> +	}
> +	smp_wmb();
> +}
