Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555Ab2BOJUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 04:20:33 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:55665 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab2BOJUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:20:30 -0500
Message-ID: <4F3B78C2.7040709@linux.vnet.ibm.com>
Date: Wed, 15 Feb 2012 14:50:02 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/12] arch/mips: remove references to cpu_*_map.
References: <1329281884.26321.rusty@rustcorp.com.au>
In-Reply-To: <1329281884.26321.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12021423-5490-0000-0000-000000BDFF0C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2012 10:28 AM, Rusty Russell wrote:

> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> This has been obsolescent for a while; time for the final push.
> 
> Also took the chance to get rid of old cpus_* in favor of cpumask_*.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: linux-mips@linux-mips.org
> ---
[...]


> diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
> --- a/arch/mips/kernel/smp.c
> +++ b/arch/mips/kernel/smp.c
> @@ -148,7 +148,7 @@ static void stop_this_cpu(void *dummy)
>  	/*
>  	 * Remove this CPU:
>  	 */
> -	cpu_clear(smp_processor_id(), cpu_online_map);
> +	set_cpu_online(smp_processor_id(), false);
>  	for (;;) {
>  		if (cpu_wait)
>  			(*cpu_wait)();		/* Wait if available. */
> @@ -174,7 +174,7 @@ void __init smp_prepare_cpus(unsigned in
>  	mp_ops->prepare_cpus(max_cpus);
>  	set_cpu_sibling_map(0);
>  #ifndef CONFIG_HOTPLUG_CPU
> -	init_cpu_present(&cpu_possible_map);
> +	init_cpu_present(cpu_possible_mask);
>  #endif
>  }
>  
> @@ -248,7 +248,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
>  	while (!cpu_isset(cpu, cpu_callin_map))
>  		udelay(100);
>  
> -	cpu_set(cpu, cpu_online_map);
> +	set_cpu_online(cpu, true);
>  
>  	return 0;
>  }
> @@ -320,13 +320,12 @@ void flush_tlb_mm(struct mm_struct *mm)
>  	if ((atomic_read(&mm->mm_users) != 1) || (current->mm != mm)) {
>  		smp_on_other_tlbs(flush_tlb_mm_ipi, mm);
>  	} else {
> -		cpumask_t mask = cpu_online_map;
>  		unsigned int cpu;
>  
> -		cpu_clear(smp_processor_id(), mask);
> -		for_each_cpu_mask(cpu, mask)
> -			if (cpu_context(cpu, mm))
> +		for_each_online_cpu(cpu) {
> +			if (cpu != smp_processor_id() && cpu_context(cpu, mm))
>  				cpu_context(cpu, mm) = 0;
> +		}


Strictly speaking, this one is not a mere cleanup. It causes a subtle change in
behaviour: earlier, it used to iterate over a local copy of cpu_online_mask, which
wouldn't change. However, with this patch, it will iterate directly over
cpu_online_mask, which can change underneath. (The preempt_disable() won't stop
new CPUs from coming in.. it only prevents CPUs from going offline, that too
provided that we use stop_machine stuff for CPU offline, which we do currently.)

>  	}
>  	local_flush_tlb_mm(mm);
>  
> @@ -360,13 +359,12 @@ void flush_tlb_range(struct vm_area_stru
>  
>  		smp_on_other_tlbs(flush_tlb_range_ipi, &fd);
>  	} else {
> -		cpumask_t mask = cpu_online_map;
>  		unsigned int cpu;
>  
> -		cpu_clear(smp_processor_id(), mask);
> -		for_each_cpu_mask(cpu, mask)
> -			if (cpu_context(cpu, mm))
> +		for_each_online_cpu(cpu) {
> +			if (cpu != smp_processor_id() && cpu_context(cpu, mm))
>  				cpu_context(cpu, mm) = 0;
> +		}
>  	}


Same here.

>  	local_flush_tlb_range(vma, start, end);
>  	preempt_enable();
> @@ -407,13 +405,12 @@ void flush_tlb_page(struct vm_area_struc
>  
>  		smp_on_other_tlbs(flush_tlb_page_ipi, &fd);
>  	} else {
> -		cpumask_t mask = cpu_online_map;
>  		unsigned int cpu;
>  
> -		cpu_clear(smp_processor_id(), mask);
> -		for_each_cpu_mask(cpu, mask)
> -			if (cpu_context(cpu, vma->vm_mm))
> +		for_each_online_cpu(cpu) {
> +			if (cpu != smp_processor_id() && cpu_context(cpu, vma->vm_mm))
>  				cpu_context(cpu, vma->vm_mm) = 0;
> +		}
>  	}


And here too.

>  	local_flush_tlb_page(vma, page);
>  	preempt_enable();
> diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
> --- a/arch/mips/kernel/smtc.c
> +++ b/arch/mips/kernel/smtc.c
> @@ -292,7 +292,7 @@ static void smtc_configure_tlb(void)
>   * possibly leave some TCs/VPEs as "slave" processors.
>   *
>   * Use c0_MVPConf0 to find out how many TCs are available, setting up
> - * cpu_possible_map and the logical/physical mappings.
> + * cpu_possible_mask and the logical/physical mappings.
>   */
>  
>  int __init smtc_build_cpu_map(int start_cpu_slot)
> diff --git a/arch/mips/mm/c-octeon.c b/arch/mips/mm/c-octeon.c
> --- a/arch/mips/mm/c-octeon.c
> +++ b/arch/mips/mm/c-octeon.c
> @@ -81,9 +81,9 @@ static void octeon_flush_icache_all_core
>  	if (vma)
>  		mask = *mm_cpumask(vma->vm_mm);
>  	else
> -		mask = cpu_online_map;
> -	cpu_clear(cpu, mask);
> -	for_each_cpu_mask(cpu, mask)
> +		mask = *cpu_online_mask;
> +	cpumask_clear(&mask, cpu);


This should be cpumask_clear_cpu(cpu, &mask);

> +	for_each_cpu(cpu, &mask)
>  		octeon_send_ipi_single(cpu, SMP_ICACHE_FLUSH);
>  
>  	preempt_enable();
 

Regards,
Srivatsa S. Bhat

