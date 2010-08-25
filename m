Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab0HYWdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 18:33:10 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:56950 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984Ab0HYWdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 18:33:08 -0400
Subject: Re: [PATCH -v3] x86, tsc: Remove CPU frequency calibration on AMD
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "greg@kroah.com" <greg@kroah.com>,
        "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100825162823.GE26438@aftab>
References: <20100817185634.GA10597@liondog.tnic>
	 <20100818161639.GF9880@aftab> <4C6C08EC.2080404@zytor.com>
	 <20100818173401.GG9880@aftab>
	 <1282153895.15158.45.camel@ank32.eng.vmware.com>
	 <20100818184534.GA12842@aftab> <20100824155305.GA18220@aftab>
	 <4C7448A3.2030309@zytor.com> <20100825070653.GA25672@aftab>
	 <20100825130454.GB4891@loge.amd.com>  <20100825162823.GE26438@aftab>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 25 Aug 2010 15:33:08 -0700
Message-Id: <1282775588.4486.11.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2010-08-25 at 09:28 -0700, Borislav Petkov wrote:
> 6b37f5a20c0e5c334c010a587058354215433e92 introduced the CPU frequency
> calibration code for AMD CPUs whose TSCs didn't increment with the
> core's P0 frequency. From F10h, revB onward, however, the TSC increment
> rate is denoted by MSRC001_0015[24] and when this bit is set (which
> should be done by the BIOS) the TSC increments with the P0 frequency
> so the calibration is not needed and booting can be a couple of mcecs
> faster on those machines.
> 
> Besides, there should be virtually no machines out there which don't
> have this bit set, therefore this calibration can be safely removed. It
> is a shaky hack anyway since it assumes implicitly that the core is in
> P0 when BIOS hands off to the OS, which might not always be the case.

Nice... this works for us too, we don't muck with that MSR bit either,
its directly passed as is from the h/w to the guest. So no additional
changes would be needed for us with this.

Hope that the 3rd time is a charm for you too :)

Thanks,
Alok

> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/kernel/cpu/amd.c |   17 +++++++++++++
>  arch/x86/kernel/tsc.c     |   58 ---------------------------------------------
>  2 files changed, 17 insertions(+), 58 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index ba5f62f..fc563fa 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -412,6 +412,23 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
>  			set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
>  	}
>  #endif
> +
> +	/* We need to do the following only once */
> +	if (c != &boot_cpu_data)
> +		return;
> +
> +	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
> +
> +		if (c->x86 > 0x10 ||
> +		    (c->x86 == 0x10 && c->x86_model >= 0x2)) {
> +			u64 val;
> +
> +			rdmsrl(MSR_K7_HWCR, val);
> +			if (!(val & BIT(24)))
> +				printk(KERN_WARNING FW_BUG "TSC doesn't count "
> +					"with P0 frequency!\n");
> +		}
> +	}
>  }
>  
>  static void __cpuinit init_amd(struct cpuinfo_x86 *c)
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index ce8e502..13b6a6c 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -854,60 +854,6 @@ static void __init init_tsc_clocksource(void)
>  	clocksource_register_khz(&clocksource_tsc, tsc_khz);
>  }
>  
> -#ifdef CONFIG_X86_64
> -/*
> - * calibrate_cpu is used on systems with fixed rate TSCs to determine
> - * processor frequency
> - */
> -#define TICK_COUNT 100000000
> -static unsigned long __init calibrate_cpu(void)
> -{
> -	int tsc_start, tsc_now;
> -	int i, no_ctr_free;
> -	unsigned long evntsel3 = 0, pmc3 = 0, pmc_now = 0;
> -	unsigned long flags;
> -
> -	for (i = 0; i < 4; i++)
> -		if (avail_to_resrv_perfctr_nmi_bit(i))
> -			break;
> -	no_ctr_free = (i == 4);
> -	if (no_ctr_free) {
> -		WARN(1, KERN_WARNING "Warning: AMD perfctrs busy ... "
> -		     "cpu_khz value may be incorrect.\n");
> -		i = 3;
> -		rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
> -		wrmsrl(MSR_K7_EVNTSEL3, 0);
> -		rdmsrl(MSR_K7_PERFCTR3, pmc3);
> -	} else {
> -		reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
> -		reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
> -	}
> -	local_irq_save(flags);
> -	/* start measuring cycles, incrementing from 0 */
> -	wrmsrl(MSR_K7_PERFCTR0 + i, 0);
> -	wrmsrl(MSR_K7_EVNTSEL0 + i, 1 << 22 | 3 << 16 | 0x76);
> -	rdtscl(tsc_start);
> -	do {
> -		rdmsrl(MSR_K7_PERFCTR0 + i, pmc_now);
> -		tsc_now = get_cycles();
> -	} while ((tsc_now - tsc_start) < TICK_COUNT);
> -
> -	local_irq_restore(flags);
> -	if (no_ctr_free) {
> -		wrmsrl(MSR_K7_EVNTSEL3, 0);
> -		wrmsrl(MSR_K7_PERFCTR3, pmc3);
> -		wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
> -	} else {
> -		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
> -		release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
> -	}
> -
> -	return pmc_now * tsc_khz / (tsc_now - tsc_start);
> -}
> -#else
> -static inline unsigned long calibrate_cpu(void) { return cpu_khz; }
> -#endif
> -
>  void __init tsc_init(void)
>  {
>  	u64 lpj;
> @@ -926,10 +872,6 @@ void __init tsc_init(void)
>  		return;
>  	}
>  
> -	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
> -			(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
> -		cpu_khz = calibrate_cpu();
> -
>  	printk("Detected %lu.%03lu MHz processor.\n",
>  			(unsigned long)cpu_khz / 1000,
>  			(unsigned long)cpu_khz % 1000);
> -- 
> 1.7.1
> 

