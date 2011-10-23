Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab1JWMAI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 08:00:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45337 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab1JWMAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 08:00:06 -0400
Date: Sun, 23 Oct 2011 12:59:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v7 15/16] ARM: LPAE: add support for ATAG_MEM64
Message-ID: <20111023115957.GD17912@n2100.arm.linux.org.uk>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com> <1312988619-16804-16-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312988619-16804-16-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 04:03:38PM +0100, Catalin Marinas wrote:
> From: Will Deacon <will.deacon@arm.com>
> 
> LPAE provides support for memory banks with physical addresses of up
> to 40 bits.
> 
> This patch adds a new atag, ATAG_MEM64, so that the Kernel can be
> informed about memory that exists above the 4GB boundary.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm/include/asm/setup.h |    8 ++++++++
>  arch/arm/kernel/setup.c      |   10 ++++++++++
>  2 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
> index 915696d..a3ca303 100644
> --- a/arch/arm/include/asm/setup.h
> +++ b/arch/arm/include/asm/setup.h
> @@ -43,6 +43,13 @@ struct tag_mem32 {
>  	__u32	start;	/* physical start address */
>  };
>  
> +#define ATAG_MEM64	0x54420002
> +
> +struct tag_mem64 {
> +	__u64	size;
> +	__u64	start;	/* physical start address */
> +};
> +
>  /* VGA text type displays */
>  #define ATAG_VIDEOTEXT	0x54410003
>  
> @@ -148,6 +155,7 @@ struct tag {
>  	union {
>  		struct tag_core		core;
>  		struct tag_mem32	mem;
> +		struct tag_mem64	mem64;
>  		struct tag_videotext	videotext;
>  		struct tag_ramdisk	ramdisk;
>  		struct tag_initrd	initrd;
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 70bca64..a126558 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -608,6 +608,16 @@ static int __init parse_tag_mem32(const struct tag *tag)
>  
>  __tagtable(ATAG_MEM, parse_tag_mem32);
>  
> +#ifdef CONFIG_PHYS_ADDR_T_64BIT
> +static int __init parse_tag_mem64(const struct tag *tag)
> +{
> +	/* We only use 32-bits for the size. */
> +	return arm_add_memory(tag->u.mem64.start, (unsigned long)tag->u.mem64.size);
> +}
> +
> +__tagtable(ATAG_MEM64, parse_tag_mem64);
> +#endif /* CONFIG_PHYS_ADDR_T_64BIT */
> +

We should allow this even on 32-bit only kernels - but avoiding adding
>32-bit memory to the system in that case.
