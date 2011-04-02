Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab1DBIXZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 04:23:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40296 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab1DBIXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 04:23:22 -0400
Date: Sat, 2 Apr 2011 10:23:16 +0200
From: Borislav Petkov <bp@alien8.de>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, x86@kernel.org,
        Hans Rosenfeld <hans.rosenfeld@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, borislav.petkov@amd.com
Subject: Re: [PATCH 07/18] x86 idle: clarify AMD erratum 400 workaround
Message-ID: <20110402082316.GA21804@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Len Brown <lenb@kernel.org>, linux-pm@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
	x86@kernel.org, Hans Rosenfeld <hans.rosenfeld@amd.com>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	borislav.petkov@amd.com
References: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
 <68477f71a39cd0ba9acd40e94e49969cbe1bec79.1301724243.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <68477f71a39cd0ba9acd40e94e49969cbe1bec79.1301724243.git.len.brown@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 02, 2011 at 02:22:49AM -0400, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> The workaround for AMD erratum 400 uses the term "c1e" suggesting:
> 1. All AMD processors with AMD C1E are involved
> 2. Any Intel processors with Intel C1E are involved.
> 
> Both are false.
> 
> Replace occurrences if "c1e" with "amd_e400" in the code to
> clarify that it is specific to AMD processors with AMD erratum 400.
> 
> This patch is text-substitution only, with no functional change.
> 
> cc: x86@kernel.org
> cc: Hans Rosenfeld <hans.rosenfeld@amd.com>
> cc: Andreas Herrmann <andreas.herrmann3@amd.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  arch/x86/include/asm/acpi.h      |    2 +-
>  arch/x86/include/asm/idle.h      |    2 +-
>  arch/x86/include/asm/processor.h |    4 ++--
>  arch/x86/kernel/cpu/common.c     |    2 +-
>  arch/x86/kernel/process.c        |   38 +++++++++++++++++++-------------------
>  arch/x86/kernel/smpboot.c        |    2 +-
>  drivers/acpi/processor_idle.c    |    2 +-
>  7 files changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
> index 4ea15ca..ae5bc1a 100644
> --- a/arch/x86/include/asm/acpi.h
> +++ b/arch/x86/include/asm/acpi.h
> @@ -138,7 +138,7 @@ static inline unsigned int acpi_processor_cstate_check(unsigned int max_cstate)
>  	    boot_cpu_data.x86_model <= 0x05 &&
>  	    boot_cpu_data.x86_mask < 0x0A)
>  		return 1;
> -	else if (c1e_detected)
> +	else if (amd_e400_detected)
>  		return 1;
>  	else
>  		return max_cstate;
> diff --git a/arch/x86/include/asm/idle.h b/arch/x86/include/asm/idle.h
> index 38d8737..f49253d7 100644
> --- a/arch/x86/include/asm/idle.h
> +++ b/arch/x86/include/asm/idle.h
> @@ -16,6 +16,6 @@ static inline void enter_idle(void) { }
>  static inline void exit_idle(void) { }
>  #endif /* CONFIG_X86_64 */
>  
> -void c1e_remove_cpu(int cpu);
> +void amd_e400_remove_cpu(int cpu);
>  
>  #endif /* _ASM_X86_IDLE_H */
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 45636ce..a8c5fed 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -758,10 +758,10 @@ static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
>  extern void mwait_idle_with_hints(unsigned long eax, unsigned long ecx);
>  
>  extern void select_idle_routine(const struct cpuinfo_x86 *c);
> -extern void init_c1e_mask(void);
> +extern void init_amd_e400_mask(void);
>  
>  extern unsigned long		boot_option_idle_override;
> -extern bool			c1e_detected;
> +extern bool			amd_e400_detected;
>  
>  enum idle_boot_override {IDLE_NO_OVERRIDE=0, IDLE_HALT, IDLE_NOMWAIT,
>  			 IDLE_POLL, IDLE_FORCE_MWAIT};
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 1d59834..30ce74c 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -887,7 +887,7 @@ static void vgetcpu_set_mode(void)
>  void __init identify_boot_cpu(void)
>  {
>  	identify_cpu(&boot_cpu_data);
> -	init_c1e_mask();
> +	init_amd_e400_mask();
>  #ifdef CONFIG_X86_32
>  	sysenter_setup();
>  	enable_sep_cpu();
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 1f64501..1c45a9c 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -540,45 +540,45 @@ int mwait_usable(const struct cpuinfo_x86 *c)
>  	return (edx & MWAIT_EDX_C1);
>  }
>  
> -bool c1e_detected;
> -EXPORT_SYMBOL(c1e_detected);
> +bool amd_e400_detected;
> +EXPORT_SYMBOL(amd_e400_detected);
>  
> -static cpumask_var_t c1e_mask;
> +static cpumask_var_t amd_e400_mask;

Actually, the correct name should be IMHO

	amd_e400_c1e_mask


>  
> -void c1e_remove_cpu(int cpu)
> +void amd_e400_remove_cpu(int cpu)
>  {
> -	if (c1e_mask != NULL)
> -		cpumask_clear_cpu(cpu, c1e_mask);
> +	if (amd_e400_mask != NULL)
> +		cpumask_clear_cpu(cpu, amd_e400_mask);
>  }
>  
>  /*
> - * C1E aware idle routine. We check for C1E active in the interrupt
> + * AMD Erratum 400 aware idle routine. We check for C1E active in the interrupt
>   * pending message MSR. If we detect C1E, then we handle it the same
>   * way as C3 power states (local apic timer and TSC stop)
>   */
> -static void c1e_idle(void)
> +static void amd_e400_idle(void)
>  {
>  	if (need_resched())
>  		return;
>  
> -	if (!c1e_detected) {
> +	if (!amd_e400_detected) {
>  		u32 lo, hi;
>  
>  		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
>  
>  		if (lo & K8_INTP_C1E_ACTIVE_MASK) {
> -			c1e_detected = true;
> +			amd_e400_detected = true;

Hmm, c1e_detected is still the correct name since those two bits in
the INT_PENDING MSR mean simply that the system can either generate an
IO read or an SMI to enter C1E irrespective of E400. So I'd leave it
c1e_detected.

The function name amd_e400_idle() OTOH looks fine to me since we denote
that this is a special idle routine for CPUs affected by E400.

>  			if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
>  				mark_tsc_unstable("TSC halt in AMD C1E");
>  			printk(KERN_INFO "System has AMD C1E enabled\n");
>  		}
>  	}
>  
> -	if (c1e_detected) {
> +	if (amd_e400_detected) {
>  		int cpu = smp_processor_id();
>  
> -		if (!cpumask_test_cpu(cpu, c1e_mask)) {
> -			cpumask_set_cpu(cpu, c1e_mask);
> +		if (!cpumask_test_cpu(cpu, amd_e400_mask)) {
> +			cpumask_set_cpu(cpu, amd_e400_mask);
>  			/*
>  			 * Force broadcast so ACPI can not interfere.
>  			 */
> @@ -621,17 +621,17 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
>  		pm_idle = mwait_idle;
>  	} else if (cpu_has_amd_erratum(amd_erratum_400)) {
>  		/* E400: APIC timer interrupt does not wake up CPU from C1e */
> -		printk(KERN_INFO "using C1E aware idle routine\n");
> -		pm_idle = c1e_idle;
> +		printk(KERN_INFO "using E400 aware idle routine\n");
> +		pm_idle = amd_e400_idle;
>  	} else
>  		pm_idle = default_idle;
>  }
>  
> -void __init init_c1e_mask(void)
> +void __init init_amd_e400_mask(void)

Same here, init_amd_e400_c1e_mask.

>  {
> -	/* If we're using c1e_idle, we need to allocate c1e_mask. */
> -	if (pm_idle == c1e_idle)
> -		zalloc_cpumask_var(&c1e_mask, GFP_KERNEL);
> +	/* If we're using amd_e400_idle, we need to allocate amd_e400_mask. */
> +	if (pm_idle == amd_e400_idle)
> +		zalloc_cpumask_var(&amd_e400_mask, GFP_KERNEL);
>  }
>  
>  static int __init idle_setup(char *str)
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 08776a9..2c33633 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1379,7 +1379,7 @@ void play_dead_common(void)
>  {
>  	idle_task_exit();
>  	reset_lazy_tlbstate();
> -	c1e_remove_cpu(raw_smp_processor_id());
> +	amd_e400_remove_cpu(raw_smp_processor_id());
>  
>  	mb();
>  	/* Ack it */
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index d615b7d..53d9f10 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -161,7 +161,7 @@ static void lapic_timer_check_state(int state, struct acpi_processor *pr,
>  	if (cpu_has(&cpu_data(pr->id), X86_FEATURE_ARAT))
>  		return;
>  
> -	if (c1e_detected)
> +	if (amd_e400_detected)
>  		type = ACPI_STATE_C1;
>  
>  	/*
> -- 
> 1.7.5.rc0

Thanks.

-- 
Regards/Gruss,
    Boris.
