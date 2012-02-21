Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab2BUPmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 10:42:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59117 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab2BUPml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 10:42:41 -0500
Date: Tue, 21 Feb 2012 16:42:45 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86: Move per cpu cpu_llc_shared_map to a field in
 struct cpuinfo_x86
Message-ID: <20120221154245.GF2486@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Kevin Winchester <kjwinchester@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Nick Bowler <nbowler@elliptictech.com>,
	linux-kernel@vger.kernel.org
References: <20120217115627.GA25601@elte.hu>
 <1329789966-693-1-git-send-email-kjwinchester@gmail.com>
 <1329789966-693-2-git-send-email-kjwinchester@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1329789966-693-2-git-send-email-kjwinchester@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 10:06:02PM -0400, Kevin Winchester wrote:
> Commit 141168c36cde ("x86: Simplify code by removing a !SMP #ifdefs from
> 'struct cpuinfo_x86'") caused the compilation error:
> 
> mce_amd.c:(.cpuinit.text+0x4723): undefined reference to 'cpu_llc_shared_map'
> 
> by removing an #ifdef CONFIG_SMP around a block containing a reference
> to cpu_llc_shared_map.  Rather than replace the #ifdef, move
> cpu_llc_shared_map to be a new cpumask_t field llc_shared_map in
> struct cpuinfo_x86 and adjust all references to cpu_llc_shared_map.
> 
> The size effects on various kernels are as follows:
> 
>    text	   data	    bss	    dec	    hex	filename
> 5281572	 513296	1044480	6839348	 685c34	vmlinux.up
> 5281572	 513296	1044480	6839348	 685c34	vmlinux.up.patched
> 5548860	 516792	1110016	7175668	 6d7df4	vmlinux.smp.2
> 5548837	 516792	1110016	7175645	 6d7ddd	vmlinux.smp.2.patched
> 5595965	 706840	1310720	7613525	 742c55	vmlinux.smp.max
> 5595876	 707880	1310720	7614476	 74300c	vmlinux.smp.max.patched
> 
> It can be seen that this change has no effect on UP, a minor effect for
> SMP with Max 2 CPUs, and a more substantial but still not overly large
> effect for MAXSMP.
> 
> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
> ---
>  arch/x86/include/asm/processor.h      |    1 +
>  arch/x86/include/asm/smp.h            |    6 ------
>  arch/x86/kernel/cpu/intel_cacheinfo.c |    4 ++--
>  arch/x86/kernel/cpu/mcheck/mce_amd.c  |    7 ++++---
>  arch/x86/kernel/smpboot.c             |   15 ++++++---------
>  arch/x86/xen/smp.c                    |    1 -
>  6 files changed, 13 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 4b81258..0c8b574 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -110,6 +110,7 @@ struct cpuinfo_x86 {
>  	/* Index into per_cpu list: */
>  	u16			cpu_index;
>  	u32			microcode;
> +	cpumask_t		llc_shared_map;
>  } __attribute__((__aligned__(SMP_CACHE_BYTES)));
>  
>  #define X86_VENDOR_INTEL	0
> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index 0434c40..f7599d0 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -34,7 +34,6 @@ static inline bool cpu_has_ht_siblings(void)
>  DECLARE_PER_CPU(cpumask_var_t, cpu_sibling_map);
>  DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
>  /* cpus sharing the last level cache: */

You'd need to pull up that comment along with the llc_shared_map
definition above in the struct cpuinfo_x86 so that we know what kind of
map it is.

Thanks.

-- 
Regards/Gruss,
Boris.
