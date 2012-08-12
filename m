Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229Ab2HLELi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 00:11:38 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54229 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2HLELf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 00:11:35 -0400
Date: Sun, 12 Aug 2012 00:11:33 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, catalin.marinas@arm.com, grant.likely@secretlab.ca,
        linux@arm.linux.org.uk, will.deacon@arm.com,
        Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH v2 11/22] ARM: LPAE: use 64-bit accessors for TTBR
 registers
In-Reply-To: <1344648306-15619-12-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1208120008380.5231@xanadu.home>
References: <1344648306-15619-1-git-send-email-cyril@ti.com> <1344648306-15619-12-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2012, Cyril Chemparathy wrote:

> This patch adds TTBR accessor macros, and modifies cpu_get_pgd() and
> the LPAE version of cpu_set_reserved_ttbr0() to use these instead.
> 
> In the process, we also fix these functions to correctly handle cases
> where the physical address lies beyond the 4G limit of 32-bit addressing.
> 
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
> ---
>  arch/arm/include/asm/proc-fns.h |   24 +++++++++++++++++++-----
>  arch/arm/mm/context.c           |    9 ++-------
>  2 files changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm/include/asm/proc-fns.h b/arch/arm/include/asm/proc-fns.h
> index 75b5f14..24224df 100644
> --- a/arch/arm/include/asm/proc-fns.h
> +++ b/arch/arm/include/asm/proc-fns.h
> @@ -116,13 +116,27 @@ extern void cpu_resume(void);
>  #define cpu_switch_mm(pgd,mm) cpu_do_switch_mm(virt_to_phys(pgd),mm)
>  
>  #ifdef CONFIG_ARM_LPAE
> +
> +#define cpu_get_ttbr(nr)					\
> +	({							\
> +		u64 ttbr;					\
> +		__asm__("mrrc	p15, " #nr ", %Q0, %R0, c2"	\
> +			: "=r" (ttbr)				\
> +			: : "cc");				\
> +		ttbr;						\
> +	})

I don't think you have to clobber the condition code (cc) here.  It has 
been a long while since the ability to pass a condition code inside an 
inline assembly statement was removed from gcc.

Other that that...

Acked-by: Nicolas Pitre <nico@linaro.org>


Nicolas
