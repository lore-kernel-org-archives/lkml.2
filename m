Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab2BUPje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 10:39:34 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59083 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab2BUPjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 10:39:33 -0500
Date: Tue, 21 Feb 2012 16:39:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86: Remove #ifdef CONFIG_SMP sections by moving
 smp_num_siblings into common.c
Message-ID: <20120221153935.GE2486@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Kevin Winchester <kjwinchester@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Nick Bowler <nbowler@elliptictech.com>,
	linux-kernel@vger.kernel.org
References: <20120217115627.GA25601@elte.hu>
 <1329789966-693-1-git-send-email-kjwinchester@gmail.com>
 <1329789966-693-6-git-send-email-kjwinchester@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1329789966-693-6-git-send-email-kjwinchester@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 10:06:06PM -0400, Kevin Winchester wrote:
> smp_num_siblings was defined in arch/x86/kernel/smpboot.c, making it
> necessary to wrap any UP relevant code referencing it with #ifdef
> CONFIG_SMP.
> 
> Instead, move the definition to arch/x86/kernel/cpu/common.c, thus
> making it available always.
> 
> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
> ---
>  arch/x86/include/asm/perf_event_p4.h |    9 +++------
>  arch/x86/include/asm/smp.h           |    6 +-----
>  arch/x86/include/asm/topology.h      |    4 +---
>  arch/x86/kernel/cpu/amd.c            |    4 ----
>  arch/x86/kernel/cpu/common.c         |    6 ++++--
>  arch/x86/kernel/cpu/proc.c           |    5 ++---
>  arch/x86/kernel/cpu/topology.c       |    2 --
>  arch/x86/kernel/process.c            |    3 +--
>  arch/x86/kernel/smpboot.c            |    4 ----
>  arch/x86/oprofile/nmi_int.c          |    6 ------
>  arch/x86/oprofile/op_model_p4.c      |    6 ------
>  11 files changed, 12 insertions(+), 43 deletions(-)
> 
> diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
> index 29a65c2..0d50f33 100644
> --- a/arch/x86/include/asm/perf_event_p4.h
> +++ b/arch/x86/include/asm/perf_event_p4.h
> @@ -8,6 +8,8 @@
>  #include <linux/cpu.h>
>  #include <linux/bitops.h>
>  
> +#include <asm/smp.h>
> +
>  /*
>   * NetBurst has performance MSRs shared between
>   * threads if HT is turned on, ie for both logical
> @@ -179,18 +181,13 @@ static inline u64 p4_clear_ht_bit(u64 config)
>  
>  static inline int p4_ht_active(void)
>  {
> -#ifdef CONFIG_SMP
>  	return smp_num_siblings > 1;
> -#endif
> -	return 0;
>  }

You could drop this function completely now and use the equal
smt_capable() macro below.

>  
>  static inline int p4_ht_thread(int cpu)
>  {
> -#ifdef CONFIG_SMP
>  	if (smp_num_siblings == 2)
> -		return cpu != cpumask_first(&cpu_data(cpu).sibling_map));
> -#endif
> +		return cpu != cpumask_first(&cpu_data(cpu).sibling_map);
>  	return 0;
>  }
>  
> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index 75aea4d..787127e 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -24,11 +24,7 @@ extern unsigned int num_processors;
>  
>  static inline bool cpu_has_ht_siblings(void)
>  {
> -	bool has_siblings = false;
> -#ifdef CONFIG_SMP
> -	has_siblings = cpu_has_ht && smp_num_siblings > 1;
> -#endif
> -	return has_siblings;
> +	return cpu_has_ht && smp_num_siblings > 1;
>  }
>  
>  DECLARE_PER_CPU(int, cpu_number);
> diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
> index 58438a1b..7250ad1 100644
> --- a/arch/x86/include/asm/topology.h
> +++ b/arch/x86/include/asm/topology.h
> @@ -174,11 +174,9 @@ static inline void arch_fix_phys_package_id(int num, u32 slot)
>  struct pci_bus;
>  void x86_pci_root_bus_resources(int bus, struct list_head *resources);
>  
> -#ifdef CONFIG_SMP
>  #define mc_capable()	((boot_cpu_data.x86_max_cores > 1) && \
>  			(cpumask_weight(&boot_cpu_data.core_map) != nr_cpu_ids))
> -#define smt_capable()			(smp_num_siblings > 1)
> -#endif
> +#define smt_capable()	(smp_num_siblings > 1)
>  
>  #ifdef CONFIG_NUMA
>  extern int get_mp_bus_to_node(int busnum);
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 1cd9d51..a8b46df 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -263,7 +263,6 @@ static int __cpuinit nearby_node(int apicid)
>   *     Assumption: Number of cores in each internal node is the same.
>   * (2) AMD processors supporting compute units
>   */
> -#ifdef CONFIG_X86_HT
>  static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
>  {
>  	u32 nodes, cores_per_cu = 1;
> @@ -307,7 +306,6 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
>  		c->compute_unit_id %= cus_per_node;
>  	}
>  }
> -#endif

I'm assuming all those X86_HT changes have been built and boot-tested
also with CONFIG_X86_HT unset?

Thanks.

-- 
Regards/Gruss,
Boris.
