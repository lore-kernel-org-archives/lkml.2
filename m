Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285Ab2HLETS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 00:19:18 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41141 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab2HLETR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 00:19:17 -0400
Date: Sun, 12 Aug 2012 00:19:14 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, catalin.marinas@arm.com, grant.likely@secretlab.ca,
        linux@arm.linux.org.uk, will.deacon@arm.com,
        Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH v2 13/22] ARM: LPAE: factor out T1SZ and TTBR1
 computations
In-Reply-To: <1344648306-15619-14-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1208120016010.5231@xanadu.home>
References: <1344648306-15619-1-git-send-email-cyril@ti.com> <1344648306-15619-14-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2012, Cyril Chemparathy wrote:

> This patch moves the TTBR1 offset calculation and the T1SZ calculation out
> of the TTB setup assembly code.  This should not affect functionality in
> any way, but improves code readability as well as readability of subsequent
> patches in this series.
> 
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>

Acked-by: Nicolas Pitre <nico@linaro.org>


> ---
>  arch/arm/include/asm/pgtable-3level-hwdef.h |   10 ++++++++++
>  arch/arm/mm/proc-v7-3level.S                |   16 ++++------------
>  2 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm/include/asm/pgtable-3level-hwdef.h b/arch/arm/include/asm/pgtable-3level-hwdef.h
> index d795282..b501650 100644
> --- a/arch/arm/include/asm/pgtable-3level-hwdef.h
> +++ b/arch/arm/include/asm/pgtable-3level-hwdef.h
> @@ -74,4 +74,14 @@
>  #define PHYS_MASK_SHIFT		(40)
>  #define PHYS_MASK		((1ULL << PHYS_MASK_SHIFT) - 1)
>  
> +#if defined CONFIG_VMSPLIT_2G
> +#define TTBR1_OFFSET	(1 << 4)		/* skip two L1 entries */
> +#elif defined CONFIG_VMSPLIT_3G
> +#define TTBR1_OFFSET	(4096 * (1 + 3))	/* only L2, skip pgd + 3*pmd */
> +#else
> +#define TTBR1_OFFSET	0
> +#endif
> +
> +#define TTBR1_SIZE	(((PAGE_OFFSET >> 30) - 1) << 16)
> +
>  #endif
> diff --git a/arch/arm/mm/proc-v7-3level.S b/arch/arm/mm/proc-v7-3level.S
> index 78bd88c..e28383f 100644
> --- a/arch/arm/mm/proc-v7-3level.S
> +++ b/arch/arm/mm/proc-v7-3level.S
> @@ -137,18 +137,10 @@ ENDPROC(cpu_v7_set_pte_ext)
>  	 * booting secondary CPUs would end up using TTBR1 for the identity
>  	 * mapping set up in TTBR0.
>  	 */
> -	bhi	9001f				@ PHYS_OFFSET > PAGE_OFFSET?
> -	orr	\tmp, \tmp, #(((PAGE_OFFSET >> 30) - 1) << 16) @ TTBCR.T1SZ
> -#if defined CONFIG_VMSPLIT_2G
> -	/* PAGE_OFFSET == 0x80000000, T1SZ == 1 */
> -	add	\ttbr1, \ttbr1, #1 << 4		@ skip two L1 entries
> -#elif defined CONFIG_VMSPLIT_3G
> -	/* PAGE_OFFSET == 0xc0000000, T1SZ == 2 */
> -	add	\ttbr1, \ttbr1, #4096 * (1 + 3)	@ only L2 used, skip pgd+3*pmd
> -#endif
> -	/* CONFIG_VMSPLIT_1G does not need TTBR1 adjustment */
> -9001:	mcr	p15, 0, \tmp, c2, c0, 2		@ TTB control register
> -	mcrr	p15, 1, \ttbr1, \zero, c2	@ load TTBR1
> +	orrls	\tmp, \tmp, #TTBR1_SIZE				@ TTBCR.T1SZ
> +	mcr	p15, 0, \tmp, c2, c0, 2				@ TTBCR
> +	addls	\ttbr1, \ttbr1, #TTBR1_OFFSET
> +	mcrr	p15, 1, \ttbr1, \zero, c2			@ load TTBR1
>  	.endm
>  
>  	__CPUINIT
> -- 
> 1.7.9.5
> 
