Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab1HOMJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 08:09:34 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62970 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672Ab1HOMJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 08:09:33 -0400
Date: Mon, 15 Aug 2011 13:09:14 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] Fix non-LPAE boot regression.
Message-ID: <20110815120914.GB21596@e102109-lin.cambridge.arm.com>
References: <201108131556.27301.anarsoul@gmail.com>
 <1313240299-24712-1-git-send-email-anarsoul@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313240299-24712-1-git-send-email-anarsoul@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vasily,

On Sat, Aug 13, 2011 at 01:58:19PM +0100, Vasily Khoruzhick wrote:
> It was introduced by  407f8b4cb07cbc5c1c7cc386f231224e2524ccea
> ARM: LPAE: MMU setup for the 3-level page table format
> 
> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> ---
>  arch/arm/kernel/head.S |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> index 0bdafc4..5add5f5 100644
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -206,7 +206,7 @@ __create_page_tables:
>  1:	orr	r3, r7, r5, lsl #SECTION_SHIFT	@ flags + kernel base
>  	str	r3, [r4, r5, lsl #PMD_ORDER]	@ identity mapping
>  	cmp	r5, r6
> -	addlo	r5, r5, #SECTION_SHIFT >> 20	@ next section
> +	addlo	r5, r5, #1			@ next section
>  	blo	1b

That's correct.

>  	/*
> @@ -217,7 +217,7 @@ __create_page_tables:
>  	mov	r3, r3, lsr #SECTION_SHIFT
>  	orr	r3, r7, r3, lsl #SECTION_SHIFT
>  	add	r0, r4,  #(KERNEL_START & 0xff000000) >> (SECTION_SHIFT - PMD_ORDER)
> -	str	r3, [r0, #(KERNEL_START & 0x00e00000) >> (SECTION_SHIFT - PMD_ORDER)]!
> +	str	r3, [r0, #(KERNEL_START & 0x00f00000) >> (SECTION_SHIFT - PMD_ORDER)]!

The reason for this was that the sections are 2MB with LPAE and a page
table entry is 64-bit wide. We always shift that value by 18 but with
LPAE we don't want to write in the middle of a page table entry if
KERNEL_START is not 2MB aligned.

But if KERNEL_START is not 2MB aligned, I think we get the wrong
physical address by 1MB (with the classic page table format).

There are a few alternatives to fixing this:

1. Different KERNEL_START masking for classic or LPAE page tables.
2. Always force 2MB section and the code above moving the phys addr into
   r3 would need to take this into account.

I would go for 1 with some shifting like below:

+	str	r3, [r0, #((KERNEL_START & 0x00f00000) >> SECTION_SHIFT) << PMD_ORDER]!

This should give us 0x00f00000 with classic page tables and 0x00e00000
with LPAE.

Thanks.

-- 
Catalin
