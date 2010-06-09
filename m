Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab0FIIyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 04:54:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:33487 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553Ab0FIIys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 04:54:48 -0400
Subject: Re: [PATCH 3/3] powerpc: enabled asymmetric SMT scheduling on
 POWER7
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
In-Reply-To: <20100608045702.31FB5CC8C7@localhost.localdomain>
References: <20100608045702.31FB5CC8C7@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 18:54:13 +1000
Message-ID: <1276073653.1242.0.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-08 at 14:57 +1000, Michael Neuling wrote:
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

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> 
> ---
> 
>  arch/powerpc/include/asm/cputable.h |    3 ++-
>  arch/powerpc/kernel/process.c       |    9 +++++++++
>  2 files changed, 11 insertions(+), 1 deletion(-)
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
> @@ -1265,3 +1265,12 @@ unsigned long randomize_et_dyn(unsigned 
>  
>  	return ret;
>  }
> +
> +int arch_sd_sibiling_asym_packing(void)
> +{
> +	if (cpu_has_feature(CPU_FTR_ASYM_SMT)){
> +		printk_once(KERN_INFO "Enabling Asymmetric SMT scheduling\n");
> +		return SD_ASYM_PACKING;
> +	}
> +	return 0;
> +}


