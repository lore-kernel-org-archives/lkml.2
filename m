Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab0DIGsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:48:51 -0400
Received: from ozlabs.org ([203.10.76.45]:49287 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab0DIGsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:48:50 -0400
From: Michael Neuling <michael.neuling@au1.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 3/5] powerpc: enabled asymmetric SMT scheduling on POWER7
In-reply-to: <20100409062118.F04B4CBB70@localhost.localdomain>
References: <20100409062118.F04B4CBB70@localhost.localdomain>
Comments: In-reply-to Michael Neuling <mikey@neuling.org>
   message dated "Fri, 09 Apr 2010 16:21:18 +1000."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Fri, 09 Apr 2010 16:48:48 +1000
Message-ID: <16221.1270795728@neuling.org>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



In message <20100409062118.F04B4CBB70@localhost.localdomain> you wrote:
> The POWER7 core has dynamic SMT mode switching which is controlled by
> the hypervisor.  There are 3 SMT modes:
> 	SMT1 uses thread  0
> 	SMT2 uses threads 0 & 1
> 	SMT4 uses threads 0, 1, 2 & 3
> When in any particular SMT mode, all threads have the same performance
> as each other (ie. at any moment in time, all threads perform the same).  
> 
> The SMT mode switching works such that when linux has threads 2 & 3 idle
> and 0 & 1 active, it will cede (H_CEDE hypercall) threads 2 and 3 in the
> idle loop and the hypervisor will automatically switch to SMT2 for that
> core (independent of other cores).  The opposite is not true, so if
> threads 0 & 1 are idle and 2 & 3 are active, we will stay in SMT4 mode.
> 
> Similarly if thread 0 is active and threads 1, 2 & 3 are idle, we'll go
> into SMT1 mode.  
> 
> If we can get the core into a lower SMT mode (SMT1 is best), the threads
> will perform better (since they share less core resources).  Hence when
> we have idle threads, we want them to be the higher ones.
> 
> This adds a feature bit for asymmetric packing to powerpc and then
> enables it on POWER7. 
> 
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> 
> ---
> 
>  arch/powerpc/include/asm/cputable.h |    3 ++-
>  arch/powerpc/kernel/process.c       |   13 +++++++++++++
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6-ozlabs/arch/powerpc/include/asm/cputable.h
> ===================================================================
> --- linux-2.6-ozlabs.orig/arch/powerpc/include/asm/cputable.h
> +++ linux-2.6-ozlabs/arch/powerpc/include/asm/cputable.h
> @@ -195,6 +195,7 @@ extern const char *powerpc_base_platform
>  #define CPU_FTR_SAO			LONG_ASM_CONST(0x0020000000000000)
>  #define CPU_FTR_CP_USE_DCBTZ		LONG_ASM_CONST(0x0040000000000000)
>  #define CPU_FTR_UNALIGNED_LD_STD	LONG_ASM_CONST(0x0080000000000000)
> +#define CPU_FTR_ASYM_SMT		LONG_ASM_CONST(0x0100000000000000)
>  
>  #ifndef __ASSEMBLY__
>  
> @@ -409,7 +410,7 @@ extern const char *powerpc_base_platform
>  	    CPU_FTR_MMCRA | CPU_FTR_SMT | \
>  	    CPU_FTR_COHERENT_ICACHE | CPU_FTR_LOCKLESS_TLBIE | \
>  	    CPU_FTR_PURR | CPU_FTR_SPURR | CPU_FTR_REAL_LE | \
> -	    CPU_FTR_DSCR | CPU_FTR_SAO)
> +	    CPU_FTR_DSCR | CPU_FTR_SAO  | CPU_FTR_ASYM_SMT)
>  #define CPU_FTRS_CELL	(CPU_FTR_USE_TB | CPU_FTR_LWSYNC | \
>  	    CPU_FTR_PPCAS_ARCH_V2 | CPU_FTR_CTRL | \
>  	    CPU_FTR_ALTIVEC_COMP | CPU_FTR_MMCRA | CPU_FTR_SMT | \
> Index: linux-2.6-ozlabs/arch/powerpc/kernel/process.c
> ===================================================================
> --- linux-2.6-ozlabs.orig/arch/powerpc/kernel/process.c
> +++ linux-2.6-ozlabs/arch/powerpc/kernel/process.c
> @@ -1265,3 +1265,16 @@ unsigned long randomize_et_dyn(unsigned 
>  
>  	return ret;
>  }
> +
> +unsigned char asym_smt_print = 1;
> +int arch_sd_sibiling_asym_packing(void)
> +{
> +	if (cpu_has_feature(CPU_FTR_ASYM_SMT)){
> +		if (asym_smt_print) {
> +			pr_info("Enabling Asymetric SMT scheduling\n");
> +			asym_smt_print = 0;
> +		}

Oops...  before anyone else laughs at me, I'm changing this to use
printk_once.

Mikey

> +		return SD_ASYM_PACKING;
> +	}
> +	return 0;
> +}
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 
