Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab2FTJE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:04:59 -0400
Received: from plane.gmane.org ([80.91.229.3]:56940 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab2FTJE6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:04:58 -0400
MIME-Version: 1.0
In-Reply-To: <87fw9qhkl9.fsf@sejong.aot.lge.com>
References: <1340094536-20873-1-git-send-email-vincent.guittot@linaro.org>
	<1340094536-20873-2-git-send-email-vincent.guittot@linaro.org>
	<87fw9qhkl9.fsf@sejong.aot.lge.com>
Date: Wed, 20 Jun 2012 11:04:47 +0200
Message-ID: <CAKfTPtBEGQP4-NUem0WBoyW8PNWi2=9qaO1oOLaKv6ox+5i76A@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] ARM: topology: Add arch_scale_freq_power function
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Vincent Guittot 
	<public-vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@plane.gmane.org>,
        public-a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@plane.gmane.org,
        public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
        public-rob.herring-bsGFqQB8/DxBDgjK7y7TUQ@plane.gmane.org,
        public-linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@plane.gmane.org,
        public-linaro-dev-cunTk1MwBs8s++Sfvej+rw@plane.gmane.org,
        public-devicetree-discuss-uLR06cmDAlY/bJ5BZ2RsiQ@plane.gmane.org,
        public-linux-lFZ/pmaqli7XmaaqVzeoHQ@plane.gmane.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 20 June 2012 02:51, Namhyung Kim <namhyung@kernel.org> wrote:
>
>
>
> Hi, Vincent
>
> Just a couple of nitpicks..
>
>
> On Tue, 19 Jun 2012 10:28:52 +0200, Vincent Guittot wrote:
>> Add infrastructure to be able to modify the cpu_power of each core
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/arm/include/asm/topology.h |    2 ++
>>  arch/arm/kernel/topology.c      |   38 +++++++++++++++++++++++++++++++++++++-
>>  2 files changed, 39 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/include/asm/topology.h b/arch/arm/include/asm/topology.h
>> index 58b8b84..78e4c85 100644
>> --- a/arch/arm/include/asm/topology.h
>> +++ b/arch/arm/include/asm/topology.h
>> @@ -27,11 +27,13 @@ void init_cpu_topology(void);
>>  void store_cpu_topology(unsigned int cpuid);
>>  const struct cpumask *cpu_coregroup_mask(int cpu);
>>
>> +void set_power_scale(unsigned int cpu, unsigned long power);
>>  #else
>>
>>  static inline void init_cpu_topology(void) { }
>>  static inline void store_cpu_topology(unsigned int cpuid) { }
>>
>> +static inline void set_power_scale(unsigned int cpu, unsigned long power) { }
>>  #endif
>>
>>  #include <asm-generic/topology.h>
>> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
>> index 8200dea..37e2e57 100644
>> --- a/arch/arm/kernel/topology.c
>> +++ b/arch/arm/kernel/topology.c
>> @@ -22,6 +22,37 @@
>>  #include <asm/cputype.h>
>>  #include <asm/topology.h>
>>
>> +/*
>> + * cpu power scale management
>> + */
>> +
>> +/*
>> + * cpu power table
>> + * This per cpu data structure describes the relative capacity of each core.
>> + * On a heteregenous system, cores don't have the same computation capacity
>> + * and we reflect that difference in the cpu_power field so the scheduler can
>> + * take this difference into account during load balance. A per cpu structure
>> + * is preferred because each CPU updates its own cpu_power field during the
>> + * load balance except for idle cores. One idle core is selected to run the
>> + * rebalance_domains for all idle cores and the cpu_power can be updated
>> + * during this sequence.
>> + */
>> +static DEFINE_PER_CPU(unsigned long, cpu_scale);
>> +
>> +unsigned long arch_scale_freq_power(struct sched_domain *sd, int cpu)
>> +{
>> +     return per_cpu(cpu_scale, cpu);
>> +}
>> +
>> +void set_power_scale(unsigned int cpu, unsigned long power)
>> +{
>> +     per_cpu(cpu_scale, cpu) = power;
>> +}
>
> Isn't it a static function?

It's not static because the function could also be used outside. This
patchset updates the capacity according to DT information but the
capacity could also be updated depending of other inputs like a
modification of the maximum frequency of a core.

I can make it static for now and could remove the static attribute when needed

>
>
>> +
>> +/*
>> + * cpu topology management
>> + */
>> +
>>  #define MPIDR_SMP_BITMASK (0x3 << 30)
>>  #define MPIDR_SMP_VALUE (0x2 << 30)
>>
>> @@ -41,6 +72,9 @@
>>  #define MPIDR_LEVEL2_MASK 0xFF
>>  #define MPIDR_LEVEL2_SHIFT 16
>>
>> +/*
>> + * cpu topology table
>> + */
>>  struct cputopo_arm cpu_topology[NR_CPUS];
>>
>>  const struct cpumask *cpu_coregroup_mask(int cpu)
>> @@ -134,7 +168,7 @@ void init_cpu_topology(void)
>>  {
>>       unsigned int cpu;
>>
>> -     /* init core mask */
>> +     /* init core mask and power*/
>>       for_each_possible_cpu(cpu) {
>>               struct cputopo_arm *cpu_topo = &(cpu_topology[cpu]);
>>
>> @@ -143,6 +177,8 @@ void init_cpu_topology(void)
>>               cpu_topo->socket_id = -1;
>>               cpumask_clear(&cpu_topo->core_sibling);
>>               cpumask_clear(&cpu_topo->thread_sibling);
>> +
>> +             per_cpu(cpu_scale, cpu) = SCHED_POWER_SCALE;
>
> Wouldn't it be better using:
>
>                set_power_scale(cpu, SCHED_POWER_SCALE);
> ?

Yes

Thanks
>
> Thanks,
> Namhyung
>
>
>>       }
>>       smp_wmb();
>>  }
>
>
>
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev

