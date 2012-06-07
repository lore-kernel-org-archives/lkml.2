Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab2FGW3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 18:29:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:3413 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933233Ab2FGW3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 18:29:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="109287193"
Subject: Re: [PATCH 6/8] x86/apic: Avoid useless scanning thru a cpumask in
 assign_irq_vector()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>
Date: Thu, 07 Jun 2012 15:28:49 -0700
In-Reply-To: <20120607131542.GE4759@dhcp-26-207.brq.redhat.com>
References: <20120605112353.GA11457@dhcp-26-207.brq.redhat.com>
	 <20120606082231.GD5991@gmail.com>
	 <20120607131542.GE4759@dhcp-26-207.brq.redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1339108129.28766.109.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 15:15 +0200, Alexander Gordeev wrote:
> In case of static vector allocation domains (i.e. flat) if all vector
> numbers are exhausted, an attempt to assign a new vector will lead to
> useless scans through all CPUs in the cpumask, even though it is known
> that each new pass would fail. Make this corner case less painful by
> letting report whether the vector allocation domain depends on passed
> arguments or not and stop scanning early.
> 
> The same could have been achived by introducing a static flag to the
> apic operations. But let's allow vector_allocation_domain() have more
> intelligence here and decide dynamically, in case we would need it in
> the future.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  arch/x86/include/asm/apic.h      |    8 +++++---
>  arch/x86/kernel/apic/apic_noop.c |    3 ++-
>  arch/x86/kernel/apic/io_apic.c   |   12 +++++++++---
>  3 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index feb2dbd..e3fecd5 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -306,7 +306,7 @@ struct apic {
>  	unsigned long (*check_apicid_used)(physid_mask_t *map, int apicid);
>  	unsigned long (*check_apicid_present)(int apicid);
>  
> -	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
> +	bool (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
>  	void (*init_apic_ldr)(void);
>  
>  	void (*ioapic_phys_id_map)(physid_mask_t *phys_map, physid_mask_t *retmap);
> @@ -615,7 +615,7 @@ extern unsigned int
>  default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
>  			       const struct cpumask *andmask);
>  
> -static inline void
> +static inline bool
>  flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
>  {
>  	/* Careful. Some cpus do not strictly honor the set of cpus
> @@ -628,12 +628,14 @@ flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
>  	 */
>  	cpumask_clear(retmask);
>  	cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
> +	return false;
>  }
>  
> -static inline void
> +static inline bool
>  default_vector_allocation_domain(int cpu, struct cpumask *retmask)
>  {
>  	cpumask_copy(retmask, cpumask_of(cpu));
> +	return true;
>  }
>  
>  static inline unsigned long default_check_apicid_used(physid_mask_t *map, int apicid)
> diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
> index 3e43cf5..ac9edf2 100644
> --- a/arch/x86/kernel/apic/apic_noop.c
> +++ b/arch/x86/kernel/apic/apic_noop.c
> @@ -100,11 +100,12 @@ static unsigned long noop_check_apicid_present(int bit)
>  	return physid_isset(bit, phys_cpu_present_map);
>  }
>  
> -static void noop_vector_allocation_domain(int cpu, struct cpumask *retmask)
> +static bool noop_vector_allocation_domain(int cpu, struct cpumask *retmask)
>  {
>  	if (cpu != 0)
>  		pr_warning("APIC: Vector allocated for non-BSP cpu\n");
>  	cpumask_copy(retmask, cpumask_of(cpu));
> +	return true;
>  }
>  
>  static u32 noop_apic_read(u32 reg)
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 05af3d3..4061a7d 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -1137,8 +1137,9 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
>  	for_each_cpu_and(cpu, mask, cpu_online_mask) {
>  		int new_cpu;
>  		int vector, offset;
> +		bool more_domains;
>  
> -		apic->vector_allocation_domain(cpu, tmp_mask);
> +		more_domains = apic->vector_allocation_domain(cpu, tmp_mask);
>  
>  		if (cpumask_subset(tmp_mask, cfg->domain)) {
>  			free_cpumask_var(tmp_mask);
> @@ -1153,8 +1154,13 @@ next:
>  			offset = (offset + 1) % 16;
>  			vector = FIRST_EXTERNAL_VECTOR + offset;
>  		}
> -		if (unlikely(current_vector == vector))
> -			continue;
> +
> +		if (unlikely(current_vector == vector)) {
> +			if (more_domains)
> +				continue;
> +			else
> +				break;
> +		}
>  
>  		if (test_bit(vector, used_vectors))
>  			goto next;
> -- 
> 1.7.7.6
> 


