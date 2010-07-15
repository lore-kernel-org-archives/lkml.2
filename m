Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933825Ab0GORBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 13:01:18 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:29470
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933753Ab0GORBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 13:01:16 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zz1102K1432N98dNzz1202hzz15d4Rz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L5LZ4I-02-FB0-02
X-M-MSG: 
Date: Thu, 15 Jul 2010 18:57:48 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Michal Schmidt <mschmidt@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
Message-ID: <20100715165748.GF20469@aftab>
References: <20100713185816.2866.17837.stgit@localhost.localdomain>
 <20100713185957.2866.50995.stgit@localhost.localdomain>
 <20100714160704.GA10473@kryptos.osrc.amd.com>
 <20100714232201.00433aa9@hammerfall>
 <20100714233102.0f64614b@hammerfall>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100714233102.0f64614b@hammerfall>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Schmidt <mschmidt@redhat.com>
Date: Wed, Jul 14, 2010 at 05:31:02PM -0400

> On Wed, 14 Jul 2010 23:22:01 +0200 Michal Schmidt wrote:
> > identify_cpu: before ANDing, c1e_detected: 0, boot_cpu_has(C1E): 0
> > identify_cpu:  after ANDing, c1e_detected: 0, boot_cpu_has(C1E): 0
> > c1e_idle: cpu: 1, bits 0x10000000, c1e_detected: 0,
> > boot_cpu_has(C1E): 0 lockdep: fixing up alternatives.

[..]

> This suggests that another way to fix my problem would be this (tested):

Ok, there is a difference in how the BIOS sets bit 28. But this version
of the fix should take care of both cases as it works on my machine too.
You could also add this hunk to your patch:

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 4681459..353154e 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -89,7 +89,7 @@
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* "" Lfence synchronizes RDTSC */
 #define X86_FEATURE_11AP       (3*32+19) /* "" Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL       (3*32+20) /* The NOPL (0F 1F) instructions */
-#define X86_FEATURE_AMDC1E     (3*32+21) /* AMD C1E detected */
+                                         /* 21 missing, was AMD_C1E workaround */
 #define X86_FEATURE_XTOPOLOGY  (3*32+22) /* cpu topology enum extensions */
 #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
 #define X86_FEATURE_NONSTOP_TSC        (3*32+24) /* TSC does not stop in C states */

so that we get rid of that simulated CPUID flag completely and use
c1e_detected only.

I'll test it on my other AMD boxes to make sure we don't regress on
older machines...

Thanks.

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
> index e7e3521..7667977 100644
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
> @@ -589,7 +591,6 @@ static void c1e_idle(void)
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
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

