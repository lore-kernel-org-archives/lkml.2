Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab1ESF6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 01:58:41 -0400
Received: from ozlabs.org ([203.10.76.45]:51816 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab1ESF6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 01:58:40 -0400
From: Michael Neuling <mikey@neuling.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org
Subject: Re: [PATCH 3/7] [RFC] add support for BlueGene/P FPU
In-reply-to: <1305753895-24845-3-git-send-email-ericvh@gmail.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com> <1305753895-24845-3-git-send-email-ericvh@gmail.com>
Comments: In-reply-to Eric Van Hensbergen <ericvh@gmail.com>
   message dated "Wed, 18 May 2011 16:24:51 -0500."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Thu, 19 May 2011 15:58:38 +1000
Message-ID: <425.1305784718@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

> This patch adds save/restore register support for the BlueGene/P
> double hummer FPU.

What does this mean?  Needs more details here.

> Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
> ---
>  arch/powerpc/include/asm/ppc_asm.h |   39 ++++++++++++++++++++++++----------
-
>  arch/powerpc/kernel/fpu.S          |    8 +++---
>  arch/powerpc/platforms/44x/Kconfig |    9 ++++++++
>  3 files changed, 40 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/ppc_asm.h b/arch/powerpc/include/asm/pp
c_asm.h
> index 9821006..daa22bb 100644
> --- a/arch/powerpc/include/asm/ppc_asm.h
> +++ b/arch/powerpc/include/asm/ppc_asm.h
> @@ -88,6 +88,13 @@ END_FW_FTR_SECTION_IFSET(FW_FEATURE_SPLPAR)
>  				REST_10GPRS(22, base)
>  #endif
>  
> +#ifdef CONFIG_BGP
> +#define LFPDX(frt, ra, rb)	.long (31<<26)|((frt)<<21)|((ra)<<16)| \
> +							((rb)<<11)|(462<<1)
> +#define STFPDX(frt, ra, rb)	.long (31<<26)|((frt)<<21)|((ra)<<16)| \
> +							((rb)<<11)|(974<<1)
> +#endif /* CONFIG_BGP */

Put these in arch/powerpc/include/asm/ppc-opcode.h and reformat to fit
whats there already.  

Also, don't need to put these defines inside a #ifdef.

> +
>  #define SAVE_2GPRS(n, base)	SAVE_GPR(n, base); SAVE_GPR(n+1, base)
>  #define SAVE_4GPRS(n, base)	SAVE_2GPRS(n, base); SAVE_2GPRS(n+2, base)
>  #define SAVE_8GPRS(n, base)	SAVE_4GPRS(n, base); SAVE_4GPRS(n+4, base)
> @@ -97,18 +104,26 @@ END_FW_FTR_SECTION_IFSET(FW_FEATURE_SPLPAR)
>  #define REST_8GPRS(n, base)	REST_4GPRS(n, base); REST_4GPRS(n+4, base)
>  #define REST_10GPRS(n, base)	REST_8GPRS(n, base); REST_2GPRS(n+8, base)
>  
> -#define SAVE_FPR(n, base)	stfd	n,THREAD_FPR0+8*TS_FPRWIDTH*(n)(base)
> -#define SAVE_2FPRS(n, base)	SAVE_FPR(n, base); SAVE_FPR(n+1, base)
> -#define SAVE_4FPRS(n, base)	SAVE_2FPRS(n, base); SAVE_2FPRS(n+2, base)
> -#define SAVE_8FPRS(n, base)	SAVE_4FPRS(n, base); SAVE_4FPRS(n+4, base)
> -#define SAVE_16FPRS(n, base)	SAVE_8FPRS(n, base); SAVE_8FPRS(n+8, base)
> -#define SAVE_32FPRS(n, base)	SAVE_16FPRS(n, base); SAVE_16FPRS(n+16, base)
> -#define REST_FPR(n, base)	lfd	n,THREAD_FPR0+8*TS_FPRWIDTH*(n)(base)
> -#define REST_2FPRS(n, base)	REST_FPR(n, base); REST_FPR(n+1, base)
> -#define REST_4FPRS(n, base)	REST_2FPRS(n, base); REST_2FPRS(n+2, base)
> -#define REST_8FPRS(n, base)	REST_4FPRS(n, base); REST_4FPRS(n+4, base)
> -#define REST_16FPRS(n, base)	REST_8FPRS(n, base); REST_8FPRS(n+8, base)
> -#define REST_32FPRS(n, base)	REST_16FPRS(n, base); REST_16FPRS(n+16, base)
> +#ifdef CONFIG_BGP
> +#define SAVE_FPR(n, b, base)	li b, THREAD_FPR0+(16*(n)); STFPDX(n, base, b)
> +#define REST_FPR(n, b, base)	li b, THREAD_FPR0+(16*(n)); LFPDX(n, base, b)

16*?  Are these FP regs 64 or 128 bits wide?  If 128 you are doing to
have to play with TS_WIDTH to get the size of the FPs correct in the
thread_struct.

I think there's a bug here.

> +#else /* CONFIG_BGP */
> +#define SAVE_FPR(n, b, base)	(stfd	n, THREAD_FPR0+8*TS_FPRWIDTH*(n)(base))
> +#define REST_FPR(n, b, base)	(lfd	n, THREAD_FPR0+8*TS_FPRWIDTH*(n)(base))
> +#endif /* CONFIG_BGP */
> +
> +#define SAVE_2FPRS(n, b, base)	SAVE_FPR(n, b, base); SAVE_FPR(n+1, b, 
base)
> +#define SAVE_4FPRS(n, b, base)	SAVE_2FPRS(n, b, base); SAVE_2FPRS(n+2,
 b, base)
> +#define SAVE_8FPRS(n, b, base)	SAVE_4FPRS(n, b, base); SAVE_4FPRS(n+4,
 b, base)
> +#define SAVE_16FPRS(n, b, base)	SAVE_8FPRS(n, b, base); SAVE_8FPRS(n+8,
 b, base)
> +#define SAVE_32FPRS(n, b, base)	SAVE_16FPRS(n, b, base); \
> +				SAVE_16FPRS(n+16, b, base)
> +#define REST_2FPRS(n, b, base)	REST_FPR(n, b, base); REST_FPR(n+1, b, 
base)
> +#define REST_4FPRS(n, b, base)	REST_2FPRS(n, b, base); REST_2FPRS(n+2,
 b, base)
> +#define REST_8FPRS(n, b, base)	REST_4FPRS(n, b, base); REST_4FPRS(n+4,
 b, base)
> +#define REST_16FPRS(n, b, base)	REST_8FPRS(n, b, base); REST_8FPRS(n+8,
 b, base)
> +#define REST_32FPRS(n, b, base)	REST_16FPRS(n, b, base); \
> +				REST_16FPRS(n+16, b, base)
>  
>  #define SAVE_VR(n,b,base)	li b,THREAD_VR0+(16*(n));  stvx n,base,b
>  #define SAVE_2VRS(n,b,base)	SAVE_VR(n,b,base); SAVE_VR(n+1,b,base)
> diff --git a/arch/powerpc/kernel/fpu.S b/arch/powerpc/kernel/fpu.S
> index de36955..9f11c66 100644
> --- a/arch/powerpc/kernel/fpu.S
> +++ b/arch/powerpc/kernel/fpu.S
> @@ -30,7 +30,7 @@
>  BEGIN_FTR_SECTION							\
>  	b	2f;							\
>  END_FTR_SECTION_IFSET(CPU_FTR_VSX);					\
> -	REST_32FPRS(n,base);						\
> +	REST_32FPRS(n,c,base);						\
>  	b	3f;							\
>  2:	REST_32VSRS(n,c,base);						\
>  3:
> @@ -39,13 +39,13 @@ END_FTR_SECTION_IFSET(CPU_FTR_VSX);		
			\
>  BEGIN_FTR_SECTION							\
>  	b	2f;							\
>  END_FTR_SECTION_IFSET(CPU_FTR_VSX);					\
> -	SAVE_32FPRS(n,base);						\
> +	SAVE_32FPRS(n,c,base);						\
>  	b	3f;							\
>  2:	SAVE_32VSRS(n,c,base);						\
>  3:
>  #else
> -#define REST_32FPVSRS(n,b,base)	REST_32FPRS(n, base)
> -#define SAVE_32FPVSRS(n,b,base)	SAVE_32FPRS(n, base)
> +#define REST_32FPVSRS(n,b,base)	REST_32FPRS(n,b,base)
> +#define SAVE_32FPVSRS(n,b,base)	SAVE_32FPRS(n,b,base)
>  #endif
>  
>  /*
> diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/
Kconfig
> index f485fc5f..24a515e 100644
> --- a/arch/powerpc/platforms/44x/Kconfig
> +++ b/arch/powerpc/platforms/44x/Kconfig
> @@ -169,6 +169,15 @@ config YOSEMITE
>  	help
>  	  This option enables support for the AMCC PPC440EP evaluation board.
>  
> +config	BGP

Does this FPU feature have a specific name like double hammer?  I'd
rather have the BGP defconfig depend on PPC_FPU_DOUBLE_HUMMER, or
something like that...

> +	bool "Blue Gene/P"
> +	depends on 44x
> +	default n
> +	select PPC_FPU
> +	select PPC_DOUBLE_FPU

... in fact, it seem you are doing something like these here but you
don't use PPC_DOUBLE_FPU anywhere?

Mikey

> +	help
> +	  This option enables support for the IBM BlueGene/P supercomputer.
> +
>  config ISS4xx
>  	bool "ISS 4xx Simulator"
>  	depends on (44x || 40x)
> -- 
> 1.7.4.1
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 

