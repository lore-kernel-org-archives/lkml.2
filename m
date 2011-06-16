Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab1FPVNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 17:13:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53255 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360Ab1FPVNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 17:13:54 -0400
Date: Thu, 16 Jun 2011 22:13:37 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Subject: Re: [RFC] Add Arm cpu topology definition
Message-ID: <20110616211337.GB32629@n2100.arm.linux.org.uk>
References: <BANLkTinRGRUxKB=C_2Y2F93czWScEUo+Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinRGRUxKB=C_2Y2F93czWScEUo+Jw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 10:49:13AM +0200, Vincent Guittot wrote:
> @@ -219,6 +219,24 @@ source "kernel/Kconfig.freezer"
> 
>  menu "System Type"
> 
> +config SCHED_MC
> +	bool "Multi-core scheduler support"
> +	depends on SMP && ARM_CPU_TOPOLOGY
> +	default n
> +	help
> +	  Multi-core scheduler support improves the CPU scheduler's decision
> +	  making when dealing with multi-core CPU chips at a cost of slightly
> +	  increased overhead in some places. If unsure say N here.
> +
> +config SCHED_SMT
> +	bool "SMT scheduler support"
> +	depends on SMP && ARM_CPU_TOPOLOGY
> +	default n
> +	help
> +	  Improves the CPU scheduler's decision making when dealing with
> +	  MultiThreading at a cost of slightly increased overhead in some
> +	  places. If unsure say N here.

Why place these in the "system type" menu?  Wouldn't it be better to
place them along side ARM_CPU_TOPOLOGY, and place that along side
the SMP option too?

> +
>  config MMU
>  	bool "MMU-based Paged Memory Management Support"
>  	default y
> @@ -1062,6 +1080,14 @@ if !MMU
>  source "arch/arm/Kconfig-nommu"
>  endif
> 
> +config ARM_CPU_TOPOLOGY
> +	bool "Support cpu topology definition"
> +	depends on SMP && CPU_V7
> +	help
> +	  Support Arm cpu topology definition. The MPIDR register defines
> +	  affinity between processors which is used to set the cpu
> +	  topology of an Arm System.

Is there a reason you'd want to disable this?

Please also note that it's "ARM" not "Arm".

> diff --git a/arch/arm/include/asm/topology.h b/arch/arm/include/asm/topology.h
> index accbd7c..cb90d0a 100644
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

The thing which naggs me about this is that its a static array, and we
know from x86 that static arrays of per-cpu data have various issues
(cache line bouncing, as well as limitations when we end up with large
numbers of CPUs.)

Lastly, x86 seems to do this:

#define arch_provides_topology_pointers         yes

and the only effect I can find of that define is in drivers/base/topology.c:

#ifdef arch_provides_topology_pointers
...
        unsigned int cpu = dev->id;                                     \
        return show_cpumap(0, topology_##name(cpu), buf);               \
...
#else
...
        return show_cpumap(0, topology_##name(dev->id), buf);           \
...
#endif

dev->id is type 'u32' which devolves to 'unsigned int' on all supported
arches.  So it looks to me like this arch_provides_topology_pointers
define is completely pointless and we just have useless obfuscation for
the hell of it.

That's not a criticism of your patch, it's pointing out a difference
between x86 and our implementation.

> +#include <linux/cpu.h>
> +#include <linux/cpumask.h>
> +#include <linux/init.h>
> +#include <linux/percpu.h>
> +#include <linux/node.h>
> +#include <linux/nodemask.h>
> +#include <linux/sched.h>
> +
> +#include <asm/cacheflush.h>
> +#include <asm/topology.h>
> +
> +#define hard_smp_mpidr() \
> +	({ \
> +		unsigned int cpunum; \
> +		__asm__("mrc p15, 0, %0, c0, c0, 5"	\
> +			: "=r" (cpunum)); \
> +		cpunum; \
> +	})

Please add a definition for CPUID_MPIDR to arch/arm/include/asm/cputype.h
and a read_cpuid_mpidr() function, and use that instead.
