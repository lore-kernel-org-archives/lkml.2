Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab1FPLzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:55:10 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58110 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab1FPLzI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:55:08 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinRGRUxKB=C_2Y2F93czWScEUo+Jw@mail.gmail.com>
References: <BANLkTinRGRUxKB=C_2Y2F93czWScEUo+Jw@mail.gmail.com>
Date: Thu, 16 Jun 2011 17:25:06 +0530
Message-ID: <BANLkTinzar2Ex-A4tCMz6JJSHoGvMAoTBg@mail.gmail.com>
Subject: Re: [RFC] Add Arm cpu topology definition
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have some doubts about the bit fields of the MPIDR register.
Comments added below.
On 16 June 2011 14:19, Vincent Guittot <vincent.guittot@linaro.org> wrote:
> The affinity between Arm processors is defined in the MPIDR register.
> We can identify which processors are in the same cluster,
> and which ones have performance interdependency. The cpu topology
>  of an Arm platform can be set thanks to this register and this topology
> is then used by sched_mc and sched_smt.
>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  arch/arm/Kconfig                |   26 ++++++++
>  arch/arm/include/asm/topology.h |   33 ++++++++++
>  arch/arm/kernel/Makefile        |    1 +
>  arch/arm/kernel/smp.c           |    6 ++
>  arch/arm/kernel/topology.c      |  133 +++++++++++++++++++++++++++++++++++++++
>  5 files changed, 199 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/kernel/topology.c
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 9adc278..bacf9af 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -219,6 +219,24 @@ source "kernel/Kconfig.freezer"
>
>  menu "System Type"
>
> +config SCHED_MC
> +       bool "Multi-core scheduler support"
> +       depends on SMP && ARM_CPU_TOPOLOGY
> +       default n
> +       help
> +         Multi-core scheduler support improves the CPU scheduler's decision
> +         making when dealing with multi-core CPU chips at a cost of slightly
> +         increased overhead in some places. If unsure say N here.
> +
> +config SCHED_SMT
> +       bool "SMT scheduler support"
> +       depends on SMP && ARM_CPU_TOPOLOGY
> +       default n
> +       help
> +         Improves the CPU scheduler's decision making when dealing with
> +         MultiThreading at a cost of slightly increased overhead in some
> +         places. If unsure say N here.
> +
>  config MMU
>        bool "MMU-based Paged Memory Management Support"
>        default y
> @@ -1062,6 +1080,14 @@ if !MMU
>  source "arch/arm/Kconfig-nommu"
>  endif
>
> +config ARM_CPU_TOPOLOGY
> +       bool "Support cpu topology definition"
> +       depends on SMP && CPU_V7
> +       help
> +         Support Arm cpu topology definition. The MPIDR register defines
> +         affinity between processors which is used to set the cpu
> +         topology of an Arm System.
> +
>  config ARM_ERRATA_411920
>        bool "ARM errata: Invalidation of the Instruction Cache operation can fail"
>        depends on CPU_V6 || CPU_V6K
> diff --git a/arch/arm/include/asm/topology.h b/arch/arm/include/asm/topology.h
> index accbd7c..cb90d0a 100644
> --- a/arch/arm/include/asm/topology.h
> +++ b/arch/arm/include/asm/topology.h
> @@ -1,6 +1,39 @@
>  #ifndef _ASM_ARM_TOPOLOGY_H
>  #define _ASM_ARM_TOPOLOGY_H
>
> +#ifdef CONFIG_ARM_CPU_TOPOLOGY
> +
> +#include <linux/cpumask.h>
> +
> +struct cputopo_arm {
> +       int thread_id;
> +       int core_id;
> +       int socket_id;
> +       cpumask_t thread_sibling;
> +       cpumask_t core_sibling;
> +};
> +
> +extern struct cputopo_arm cpu_topology[NR_CPUS];
> +
> +#define topology_physical_package_id(cpu)      (cpu_topology[cpu].socket_id)
> +#define topology_core_id(cpu)          (cpu_topology[cpu].core_id)
> +#define topology_core_cpumask(cpu)     (&(cpu_topology[cpu].core_sibling))
> +#define topology_thread_cpumask(cpu)   (&(cpu_topology[cpu].thread_sibling))
> +
> +#define mc_capable()   (cpu_topology[0].socket_id != -1)
> +#define smt_capable()  (cpu_topology[0].thread_id != -1)
> +
> +void init_cpu_topology(void);
> +void store_cpu_topology(unsigned int cpuid);
> +const struct cpumask *cpu_coregroup_mask(unsigned int cpu);
> +
> +#else
> +
> +#define init_cpu_topology() {};
> +#define store_cpu_topology(cpuid) {};
> +
> +#endif
> +
>  #include <asm-generic/topology.h>
>
>  #endif /* _ASM_ARM_TOPOLOGY_H */
> diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
> index a5b31af..816a481 100644
> --- a/arch/arm/kernel/Makefile
> +++ b/arch/arm/kernel/Makefile
> @@ -61,6 +61,7 @@ obj-$(CONFIG_IWMMXT)          += iwmmxt.o
>  obj-$(CONFIG_CPU_HAS_PMU)      += pmu.o
>  obj-$(CONFIG_HW_PERF_EVENTS)   += perf_event.o
>  AFLAGS_iwmmxt.o                        := -Wa,-mcpu=iwmmxt
> +obj-$(CONFIG_ARM_CPU_TOPOLOGY)  += topology.o
>
>  ifneq ($(CONFIG_ARCH_EBSA110),y)
>   obj-y                += io.o
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index 344e52b..3e8dc3b 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -31,6 +31,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/cpu.h>
>  #include <asm/cputype.h>
> +#include <asm/topology.h>
>  #include <asm/mmu_context.h>
>  #include <asm/pgtable.h>
>  #include <asm/pgalloc.h>
> @@ -268,6 +269,9 @@ static void __cpuinit smp_store_cpu_info(unsigned int cpuid)
>        struct cpuinfo_arm *cpu_info = &per_cpu(cpu_data, cpuid);
>
>        cpu_info->loops_per_jiffy = loops_per_jiffy;
> +
> +       store_cpu_topology(cpuid);
> +
>  }
>
>  /*
> @@ -354,6 +358,8 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
>  {
>        unsigned int ncores = num_possible_cpus();
>
> +       init_cpu_topology();
> +
>        smp_store_cpu_info(smp_processor_id());
>
>        /*
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> new file mode 100644
> index 0000000..d61723c
> --- /dev/null
> +++ b/arch/arm/kernel/topology.c
> @@ -0,0 +1,133 @@
> +/*
> + * arch/arm/kernel/topology.c
> + *
> + * Copyright (C) 2011  vincent.guittot@linaro.org
> + *
> + * based on arch/sh/kernel/topology.c
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
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
> +#include <asm/cacheflush.h>
> +#include <asm/topology.h>
> +
> +#define hard_smp_mpidr() \
> +       ({ \
> +               unsigned int cpunum; \
> +               __asm__("mrc p15, 0, %0, c0, c0, 5"     \
> +                       : "=r" (cpunum)); \
> +               cpunum; \
> +       })
> +
> +struct cputopo_arm cpu_topology[NR_CPUS];
> +
> +const struct cpumask *cpu_coregroup_mask(unsigned int cpu)
> +{
> +       return &(cpu_topology[cpu].core_sibling);
> +}
> +
> +/*
> + * store_cpu_topology is called at boot when only one cpu is running
> + * and with the mutex cpu_hotplug.lock locked, when several cpus have booted,
> + * which prevents simultaneous write access to cpu_topology array
> + */
> +void store_cpu_topology(unsigned int cpuid)
> +{
> +       struct cputopo_arm *cpuid_topo = &(cpu_topology[cpuid]);
> +       unsigned int mpidr;
> +       unsigned int cpu;
> +
> +       /* If the cpu topology has been already set, just return */
> +       if (cpuid_topo->core_id != -1)
> +               return;
> +
> +       mpidr = hard_smp_mpidr();
> +
> +       /* create cpu topology mapping */
> +       if (mpidr & (0x3 << 30)) {

I checked the A9 reference manual. It says bit 30 if 0 denotes that processor is
part of multiprocessor system.


> +               /*
> +                * This is a multiprocessor system
> +                * multiprocessor format & multiprocessor mode field are set
> +                */
> +
> +               if (mpidr & (0x1 << 24)) {
> +                       /* core performance interdependency */
> +                       cpuid_topo->thread_id = (mpidr & 0x3);
> +                       cpuid_topo->core_id =  ((mpidr >> 8) & 0xF);
> +                       cpuid_topo->socket_id = ((mpidr >> 16) & 0xFF);
> +               } else {
> +                       /* normal core interdependency */
> +                       cpuid_topo->thread_id = -1;
> +                       cpuid_topo->core_id = (mpidr & 0x3);
> +                       cpuid_topo->socket_id = ((mpidr >> 8) & 0xF);
> +               }
> +       } else {
> +               /*
> +                * This is an uniprocessor system
> +                * we are in multiprocessor format but uniprocessor system
> +                * or in the old uniprocessor format
> +                */
> +
> +               cpuid_topo->thread_id = -1;
> +               cpuid_topo->core_id = 0;
> +               cpuid_topo->socket_id = -1;
> +       }
> +
> +       /* update core and thread sibling masks */
> +       for_each_possible_cpu(cpu) {
> +               struct cputopo_arm *cpu_topo = &(cpu_topology[cpu]);
> +
> +               if (cpuid_topo->socket_id == cpu_topo->socket_id) {
> +                       cpumask_set_cpu(cpuid, &cpu_topo->core_sibling);
> +                       if (cpu != cpuid)
> +                               cpumask_set_cpu(cpu,
> +                                       &cpuid_topo->core_sibling);
> +
> +                       if (cpuid_topo->core_id == cpu_topo->core_id) {
> +                               cpumask_set_cpu(cpuid,
> +                                       &cpu_topo->thread_sibling);
> +                               if (cpu != cpuid)
> +                                       cpumask_set_cpu(cpu,
> +                                               &cpuid_topo->thread_sibling);
> +                       }
> +               }
> +       }
> +       smp_wmb();
> +
> +       printk(KERN_INFO "cpu %u : thread %d cpu %d, socket %d, mpidr %x\n",
> +               cpuid, cpu_topology[cpuid].thread_id,
> +               cpu_topology[cpuid].core_id,
> +               cpu_topology[cpuid].socket_id, mpidr);
> +
> +}
> +
> +/*
> + * init_cpu_topology is called at boot when only one cpu is running
> + * which prevent simultaneous write access to cpu_topology array
> + */
> +void init_cpu_topology(void)
> +{
> +       unsigned int cpu;
> +
> +       /* init core mask */
> +       for_each_possible_cpu(cpu) {
> +               struct cputopo_arm *cpu_topo = &(cpu_topology[cpu]);
> +
> +               cpu_topo->thread_id = -1;
> +               cpu_topo->core_id =  -1;
> +               cpu_topo->socket_id = -1;
> +               cpumask_clear(&cpu_topo->core_sibling);
> +               cpumask_clear(&cpu_topo->thread_sibling);
> +       }
> +       smp_wmb();
> +}
> --
> 1.7.4.1
>
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev
>
