Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab0G0Q7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:59:21 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:48848 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab0G0Q7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:59:20 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz1432N936eMzz1202hzz15d4Rz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L6876K-01-5K0-02
X-M-MSG: 
Date: Tue, 27 Jul 2010 18:58:22 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Michal Schmidt <mschmidt@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>, x86 <x86@kernel.org>
Subject: Re: [RESEND PATCH] x86: fix keeping track of AMD C1E
Message-ID: <20100727165822.GB8003@aftab>
References: <20100727165335.GA11630@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100727165335.GA11630@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Schmidt <mschmidt@redhat.com>
Date: Tue, Jul 27, 2010 at 12:53:35PM -0400

Sorry about the From: mismatch but if you do "mutt -H <patch>", the
From: of the mail gets set to the patch author and not the sender. I'll paste
the formatted patch instead next time.

> Accomodate the original C1E-aware idle routine to the different times
> during boot when the BIOS enables C1E. While at it, remove the synthetic
> CPUID flag in favor of a single global setting which denotes C1E status
> on the system.
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
> 
> Peter, can we please queue this for .36 merge window? Thanks.
> 
>  arch/x86/include/asm/acpi.h       |    2 +-
>  arch/x86/include/asm/cpufeature.h |    2 +-
>  arch/x86/include/asm/processor.h  |    1 +
>  arch/x86/kernel/process.c         |    6 ++++--
>  drivers/acpi/processor_idle.c     |    2 +-
>  5 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
> index aa2c39d..92091de 100644
> --- a/arch/x86/include/asm/acpi.h
> +++ b/arch/x86/include/asm/acpi.h
> @@ -134,7 +134,7 @@ static inline unsigned int acpi_processor_cstate_check(unsigned int max_cstate)
>  	    boot_cpu_data.x86_model <= 0x05 &&
>  	    boot_cpu_data.x86_mask < 0x0A)
>  		return 1;
> -	else if (boot_cpu_has(X86_FEATURE_AMDC1E))
> +	else if (c1e_detected)
>  		return 1;
>  	else
>  		return max_cstate;
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index 4681459..353154e 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -89,7 +89,7 @@
>  #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* "" Lfence synchronizes RDTSC */
>  #define X86_FEATURE_11AP	(3*32+19) /* "" Bad local APIC aka 11AP */
>  #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
> -#define X86_FEATURE_AMDC1E	(3*32+21) /* AMD C1E detected */
> +					  /* 21 missing, was AMD_C1E workaround */
>  #define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum extensions */
>  #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
>  #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 7e5c6a6..336851e 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -762,6 +762,7 @@ extern void init_c1e_mask(void);
>  extern unsigned long		boot_option_idle_override;
>  extern unsigned long		idle_halt;
>  extern unsigned long		idle_nomwait;
> +extern int			c1e_detected;
>  
>  /*
>   * on systems with caches, caches must be flashed as the absolute
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index e7e3521..1b44a5c 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -561,8 +561,10 @@ no_c1e_idle:
>  	return 0;
>  }
>  
> +int c1e_detected;
> +EXPORT_SYMBOL(c1e_detected);
> +
>  static cpumask_var_t c1e_mask;
> -static int c1e_detected;
>  
>  void c1e_remove_cpu(int cpu)
>  {
> @@ -584,12 +586,12 @@ static void c1e_idle(void)
>  		u32 lo, hi;
>  
>  		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
> +
>  		if (lo & K8_INTP_C1E_ACTIVE_MASK) {
>  			c1e_detected = 1;
>  			if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
>  				mark_tsc_unstable("TSC halt in AMD C1E");
>  			printk(KERN_INFO "System has AMD C1E enabled\n");
> -			set_cpu_cap(&boot_cpu_data, X86_FEATURE_AMDC1E);
>  		}
>  	}
>  
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index b1b3856..7cd95eb 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -159,7 +159,7 @@ static void lapic_timer_check_state(int state, struct acpi_processor *pr,
>  	if (cpu_has(&cpu_data(pr->id), X86_FEATURE_ARAT))
>  		return;
>  
> -	if (boot_cpu_has(X86_FEATURE_AMDC1E))
> +	if (c1e_detected)
>  		type = ACPI_STATE_C1;
>  
>  	/*
> -- 
> 1.7.1
> 
> 
> -- 
> Regards/Gruss,
> Boris.
> 
> Advanced Micro Devices GmbH
> Einsteinring 24, 85609 Dornach
> General Managers: Alberto Bozzo, Andrew Bowd
> Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
> Registergericht Muenchen, HRB Nr. 43632

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

