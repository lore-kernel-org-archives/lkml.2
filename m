Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab1DNJJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 05:09:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41167 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406Ab1DNJJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 05:09:16 -0400
Date: Thu, 14 Apr 2011 11:08:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86 intel power: Initialize MSR_IA32_ENERGY_PERF_BIAS
Message-ID: <20110414090854.GB9248@elte.hu>
References: <alpine.LFD.2.02.1103301819250.31342@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1103301819250.31342@x980>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> From: Len Brown <len.brown@intel.com>
> 
> Since 2.6.35 (23016bf0d25), Linux prints the existence of "epb" in /proc/cpuinfo,
> Since 2.6.38 (d5532ee7b40), the x86_energy_perf_policy(8) utility is available
> in-tree to update MSR_IA32_ENERGY_PERF_BIAS.
> 
> However, the typical BIOS fails to initialize the MSR,
> and the typical Linux distro neglects to invoke x86_energy_perf_policy(8).
> 
> The result is that some modern hardware is running in hardware default,
> which is "performance" mode, rather than the intended design default
> of "normal" mode.
> 
> Initialize the MSR to the "normal" setting during kernel boot.
> 
> Of course, x86_energy_perf_policy(8) is available to change
> the default after boot, should the user have a policy preference.
> 
> cc: stable@kernel.org
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  arch/x86/include/asm/msr-index.h |    3 +++
>  arch/x86/kernel/cpu/intel.c      |   14 ++++++++++++++
>  2 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 43a18c7..91fedd9 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -250,6 +250,9 @@
>  #define MSR_IA32_TEMPERATURE_TARGET	0x000001a2
>  
>  #define MSR_IA32_ENERGY_PERF_BIAS	0x000001b0
> +#define ENERGY_PERF_BIAS_PERFORMANCE	0
> +#define ENERGY_PERF_BIAS_NORMAL		6
> +#define ENERGY_PERF_BIAS_POWERSWAVE	15
>  
>  #define MSR_IA32_PACKAGE_THERM_STATUS		0x000001b1
>  
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index d16c2c5..48cca4a 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -448,6 +448,20 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
>  
>  	if (cpu_has(c, X86_FEATURE_VMX))
>  		detect_vmx_virtcap(c);
> +
> +	/*
> +	 * Initialize MSR_IA32_ENERGY_PERF_BIAS if BIOS did not.
> +	 * x86_energy_perf_policy(8) is available to change it at run-time
> +	 */
> +	if (cpu_has(c, X86_FEATURE_EPB)) {
> +		u64 epb;
> +
> +		rdmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
> +		if ((epb & 0xF) == 0) {
> +			epb = (epb & ~0xF) | ENERGY_PERF_BIAS_NORMAL;
> +			wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
> +		}
> +	}

Dunno, this patch appears to silently modify the system to be slower than it 
was before under Linux.

Won't people report this as a regression if this change reduces performance for 
them?

They wont be able to see your comments in the code and in the changelog either, 
when this happens to them. They might look into /proc/cpuinfo and see 'epb' 
there but it wont tell them anything. They wont know about a utility available 
in tools/power/x86/ either.

So this patch has 'future trouble' written all over it i'm afraid.

Thanks,

	Ingo
