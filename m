Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab1FHAtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 20:49:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:41421 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722Ab1FHAtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 20:49:51 -0400
Subject: Re: [PATCH] [RFC][V3] bluegene: add entry to cpu table
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org
In-Reply-To: <1307472447-1656-1-git-send-email-ericvh@gmail.com>
References: <1307472447-1656-1-git-send-email-ericvh@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 10:49:41 +1000
Message-ID: <1307494181.2874.214.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 13:47 -0500, Eric Van Hensbergen wrote:
> Create an entry for the BG/P chips, include bits to accomodate
> the double fp2 fpu and the special MMU considerations like L1
> writethrough.
> 
> RFC Note: this patch fails scripts/checkpatch.pl because I
> matched coding style of the surrounding existing code.  Would
> you rather have something checkpatch.pl clean or something
> which is consistent with the surrounding code style?

Stay consistent. You're welcome to my next checkpatch burning
ceremony :-)

> The three I got were:
> ERROR: Macros with complex values should be enclosed in parenthesis
> ERROR: "foo* bar" should be "foo *bar"
> WARNING: externs should be avoided in .c files
> and I got these by copying other code as an example.
> 
> Thanks for any feedback.
> 
> Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
> ---
>  arch/powerpc/include/asm/cputable.h |    1 +
>  arch/powerpc/include/asm/mmu.h      |    9 +++++++++
>  arch/powerpc/kernel/cpu_setup_44x.S |    1 +
>  arch/powerpc/kernel/cputable.c      |   16 ++++++++++++++++
>  4 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/cputable.h b/arch/powerpc/include/asm/cputable.h
> index c0d842c..ce709b5 100644
> --- a/arch/powerpc/include/asm/cputable.h
> +++ b/arch/powerpc/include/asm/cputable.h
> @@ -26,6 +26,7 @@
>  #define PPC_FEATURE_POWER6_EXT		0x00000200
>  #define PPC_FEATURE_ARCH_2_06		0x00000100
>  #define PPC_FEATURE_HAS_VSX		0x00000080
> +#define PPC_FEATURE_HAS_FPU_FP2		0x00000040

Any chance for a better name ?

>  #define PPC_FEATURE_PSERIES_PERFMON_COMPAT \
>  					0x00000040
> diff --git a/arch/powerpc/include/asm/mmu.h b/arch/powerpc/include/asm/mmu.h
> index 4138b21..97f9502 100644
> --- a/arch/powerpc/include/asm/mmu.h
> +++ b/arch/powerpc/include/asm/mmu.h
> @@ -56,6 +56,13 @@
>   */
>  #define MMU_FTR_NEED_DTLB_SW_LRU	ASM_CONST(0x00200000)
>  
> +/* This indicates that the processor must using writethrough with
> + * the L1 in order to maintain SMP coherence on systems like the
> + * IBM BlueGene/L and IBM BlueGene/P.
> + */
> +
> +#define MMU_FTR_NEED_L1_WRITETHROUGH	ASM_CONST(0x00400000)
> +
>  /* Enable use of TLB reservation.  Processor should support tlbsrx.
>   * instruction and MAS0[WQ].
>   */
> @@ -112,6 +119,8 @@
>  				MMU_FTR_USE_PAIRED_MAS | \
>  				MMU_FTR_TLBIEL | \
>  				MMU_FTR_16M_PAGE
> +#define MMU_FTRS_BGP		MMU_FTR_TYPE_44x | MMU_FTR_16M_PAGE | \
> +				MMU_FTR_NEED_L1_WRITETHROUGH

Time to add the ALWAYS/NEVER trick to mmu features like CPU feature has

>  #ifndef __ASSEMBLY__
>  #include <asm/cputable.h>
>  
> diff --git a/arch/powerpc/kernel/cpu_setup_44x.S b/arch/powerpc/kernel/cpu_setup_44x.S
> index e32b4a9..920aed6 100644
> --- a/arch/powerpc/kernel/cpu_setup_44x.S
> +++ b/arch/powerpc/kernel/cpu_setup_44x.S
> @@ -35,6 +35,7 @@ _GLOBAL(__setup_cpu_440grx)
>  _GLOBAL(__setup_cpu_460ex)
>  _GLOBAL(__setup_cpu_460gt)
>  _GLOBAL(__setup_cpu_460sx)
> +_GLOBAL(__setup_cpu_bgp)
>  _GLOBAL(__setup_cpu_apm821xx)
>  	mflr	r4
>  	bl	__init_fpu_44x
> diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
> index 34d2722..550a078 100644
> --- a/arch/powerpc/kernel/cputable.c
> +++ b/arch/powerpc/kernel/cputable.c
> @@ -57,6 +57,7 @@ extern void __setup_cpu_750fx(unsigned long offset, struct cpu_spec* spec);
>  extern void __setup_cpu_7400(unsigned long offset, struct cpu_spec* spec);
>  extern void __setup_cpu_7410(unsigned long offset, struct cpu_spec* spec);
>  extern void __setup_cpu_745x(unsigned long offset, struct cpu_spec* spec);
> +extern void __setup_cpu_bgp(unsigned long offset, struct cpu_spec* spec);
>  #endif /* CONFIG_PPC32 */
>  #ifdef CONFIG_PPC64
>  extern void __setup_cpu_ppc970(unsigned long offset, struct cpu_spec* spec);
> @@ -1737,6 +1738,21 @@ static struct cpu_spec __initdata cpu_specs[] = {
>  		.machine_check		= machine_check_440A,
>  		.platform		= "ppc440",
>  	},
> +	{ /* Blue Gene/P */
> +		.pvr_mask		= 0xfffffff0,
> +		.pvr_value		= 0x52131880,
> +		.cpu_name		= "450 Blue Gene/P",
> +		.cpu_features		= CPU_FTRS_440x6,
> +		.cpu_user_features	= COMMON_USER_BOOKE |
> +						PPC_FEATURE_HAS_FPU |
> +						PPC_FEATURE_HAS_FPU_FP2,
> +		.mmu_features		= MMU_FTRS_BGP,
> +		.icache_bsize		= 32,
> +		.dcache_bsize		= 32,
> +		.cpu_setup		= __setup_cpu_bgp,
> +		.machine_check		= machine_check_440A,
> +		.platform		= "ppc440",
> +	},
>  	{ /* 460EX */
>  		.pvr_mask		= 0xffff0006,
>  		.pvr_value		= 0x13020002,

Cheers,
Ben.

> -- 
> 1.7.4.1
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


