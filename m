Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab2LJAIm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 19:08:42 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57262 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab2LJAIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 19:08:41 -0500
Date: Mon, 10 Dec 2012 00:08:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Boojin Kim <boojin.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
Subject: Re: [PATCH 1/3] ARM: MM: Add the workaround of Errata 774769
Message-ID: <20121210000825.GH14363@n2100.arm.linux.org.uk>
References: <001701cdd669$19e8cdd0$4dba6970$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001701cdd669$19e8cdd0$4dba6970$%kim@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 08:58:35AM +0900, Boojin Kim wrote:
> 
> -3:	mov	r10, #0
> +	/* Cortex-A15 Errata */
> +3:	ldr	r10, =0x00000c0f		@ Cortex-A15 primary part number
> +	teq	r0, r10
> +	bne	4f
> +#ifdef CONFIG_ARM_ERRATA_774769

There's not much point testing for the part number of the work-around isn't
enabled.

> +	teq	r6, #0x4			@ present in r0p4
> +	mrceq	p15, 0, r10, c1, c0, 1		@ read aux control register

	tsteq	r10, #1 << 15

to avoid writing to the aux control register if the errata has already been
applied.

> +	orreq	r10, r10, #1 << 25		@ set bit #25
> +	mcreq	p15, 0, r10, c1, c0, 1		@ write aux control register
> +#endif
> +
> +4:	mov	r10, #0
>  	mcr	p15, 0, r10, c7, c5, 0		@ I+BTB cache invalidate
>  	dsb
>  #ifdef CONFIG_MMU
> --
> 1.7.5.4
> 
> 
> 
