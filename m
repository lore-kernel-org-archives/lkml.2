Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab1FQHnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 03:43:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49679 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab1FQHn1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 03:43:27 -0400
MIME-Version: 1.0
In-Reply-To: <20110616211337.GB32629@n2100.arm.linux.org.uk>
References: <BANLkTinRGRUxKB=C_2Y2F93czWScEUo+Jw@mail.gmail.com>
	<20110616211337.GB32629@n2100.arm.linux.org.uk>
Date: Fri, 17 Jun 2011 09:43:26 +0200
Message-ID: <BANLkTi=FoZ1_RbjTS8RBm-A_qYXVWzKLGQ@mail.gmail.com>
Subject: Re: [RFC] Add Arm cpu topology definition
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 June 2011 23:13, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Thu, Jun 16, 2011 at 10:49:13AM +0200, Vincent Guittot wrote:
>> @@ -219,6 +219,24 @@ source "kernel/Kconfig.freezer"
>>
>>  menu "System Type"
>>
>> +config SCHED_MC
>> +     bool "Multi-core scheduler support"
>> +     depends on SMP && ARM_CPU_TOPOLOGY
>> +     default n
>> +     help
>> +       Multi-core scheduler support improves the CPU scheduler's decision
>> +       making when dealing with multi-core CPU chips at a cost of slightly
>> +       increased overhead in some places. If unsure say N here.
>> +
>> +config SCHED_SMT
>> +     bool "SMT scheduler support"
>> +     depends on SMP && ARM_CPU_TOPOLOGY
>> +     default n
>> +     help
>> +       Improves the CPU scheduler's decision making when dealing with
>> +       MultiThreading at a cost of slightly increased overhead in some
>> +       places. If unsure say N here.
>
> Why place these in the "system type" menu?  Wouldn't it be better to
> place them along side ARM_CPU_TOPOLOGY, and place that along side
> the SMP option too?
>

yes, it's a better place

>> +
>>  config MMU
>>       bool "MMU-based Paged Memory Management Support"
>>       default y
>> @@ -1062,6 +1080,14 @@ if !MMU
>>  source "arch/arm/Kconfig-nommu"
>>  endif
>>
>> +config ARM_CPU_TOPOLOGY
>> +     bool "Support cpu topology definition"
>> +     depends on SMP && CPU_V7
>> +     help
>> +       Support Arm cpu topology definition. The MPIDR register defines
>> +       affinity between processors which is used to set the cpu
>> +       topology of an Arm System.
>
> Is there a reason you'd want to disable this?
>

In fact, I only want to disable sched_mc and sched_smt. I'm going to
add default y for ARM_CPU_TOPOLOGY

> Please also note that it's "ARM" not "Arm".

OK

>
>> diff --git a/arch/arm/include/asm/topology.h b/arch/arm/include/asm/topology.h
>> index accbd7c..cb90d0a 100644
>> --- a/arch/arm/include/asm/topology.h
>> +++ b/arch/arm/include/asm/topology.h
>> @@ -1,6 +1,39 @@
>>  #ifndef _ASM_ARM_TOPOLOGY_H
>>  #define _ASM_ARM_TOPOLOGY_H
>>
>> +#ifdef CONFIG_ARM_CPU_TOPOLOGY
>> +
>> +#include <linux/cpumask.h>
>> +
>> +struct cputopo_arm {
>> +     int thread_id;
>> +     int core_id;
>> +     int socket_id;
>> +     cpumask_t thread_sibling;
>> +     cpumask_t core_sibling;
>> +};
>> +
>> +extern struct cputopo_arm cpu_topology[NR_CPUS];
>> +
>> +#define topology_physical_package_id(cpu)    (cpu_topology[cpu].socket_id)
>> +#define topology_core_id(cpu)                (cpu_topology[cpu].core_id)
>> +#define topology_core_cpumask(cpu)   (&(cpu_topology[cpu].core_sibling))
>> +#define topology_thread_cpumask(cpu) (&(cpu_topology[cpu].thread_sibling))
>
> The thing which naggs me about this is that its a static array, and we
> know from x86 that static arrays of per-cpu data have various issues
> (cache line bouncing, as well as limitations when we end up with large
> numbers of CPUs.)
>

The array is updated sequentially by each processor during boot. Then,
it should be used by one cpu when building the sched_domain and when
calling the topology sysfs entry.
We should not have so many cases where several cpu are accessing
simultaneously the cells of the array.

> Lastly, x86 seems to do this:
>
> #define arch_provides_topology_pointers         yes
>
> and the only effect I can find of that define is in drivers/base/topology.c:
>
> #ifdef arch_provides_topology_pointers
> ...
>        unsigned int cpu = dev->id;                                     \
>        return show_cpumap(0, topology_##name(cpu), buf);               \
> ...
> #else
> ...
>        return show_cpumap(0, topology_##name(dev->id), buf);           \
> ...
> #endif
>
> dev->id is type 'u32' which devolves to 'unsigned int' on all supported
> arches.  So it looks to me like this arch_provides_topology_pointers
> define is completely pointless and we just have useless obfuscation for
> the hell of it.
>
> That's not a criticism of your patch, it's pointing out a difference
> between x86 and our implementation.
>

I haven't set arch_provides_topology_pointers because I can't find a
difference between setting it or not

>> +#include <linux/cpu.h>
>> +#include <linux/cpumask.h>
>> +#include <linux/init.h>
>> +#include <linux/percpu.h>
>> +#include <linux/node.h>
>> +#include <linux/nodemask.h>
>> +#include <linux/sched.h>
>> +
>> +#include <asm/cacheflush.h>
>> +#include <asm/topology.h>
>> +
>> +#define hard_smp_mpidr() \
>> +     ({ \
>> +             unsigned int cpunum; \
>> +             __asm__("mrc p15, 0, %0, c0, c0, 5"     \
>> +                     : "=r" (cpunum)); \
>> +             cpunum; \
>> +     })
>
> Please add a definition for CPUID_MPIDR to arch/arm/include/asm/cputype.h
> and a read_cpuid_mpidr() function, and use that instead.
>

ok
 I can directly use read_cpuid with a definition for CPUID_MPIDR
