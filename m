Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab2IXNy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:54:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38879 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab2IXNy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:54:57 -0400
Date: Mon, 24 Sep 2012 14:54:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Cyril Chemparathy <cyril@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, catalin.marinas@arm.com, davidb@codeaurora.org,
        frank.rowand@am.sony.com, hsweeten@visionengravers.com,
        linus.walleij@linaro.org, marc.zyngier@arm.com, nico@linaro.org,
        paul.gortmaker@windriver.com, plagnioj@jcrosoft.com, rabin@rab.in,
        rmallon@gmail.com, rob.herring@calxeda.com, sboyd@codeaurora.org,
        sjg@chromium.org, tglx@linutronix.de, tj@kernel.org,
        vincent.guittot@linaro.org, vitalya@ti.com, will.deacon@arm.com,
        grant.likely@secretlab.ca
Subject: Re: [PATCH v3 RESEND 06/17] ARM: LPAE: use signed arithmetic for
	mask definitions
Message-ID: <20120924135438.GC26454@n2100.arm.linux.org.uk>
References: <1348242975-19184-1-git-send-email-cyril@ti.com> <1348242975-19184-7-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348242975-19184-7-git-send-email-cyril@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 11:56:04AM -0400, Cyril Chemparathy wrote:
> This patch applies to PAGE_MASK, PMD_MASK, and PGDIR_MASK, where forcing
> unsigned long math truncates the mask at the 32-bits.  This clearly does bad
> things on PAE systems.
> 
> This patch fixes this problem by defining these masks as signed quantities.
> We then rely on sign extension to do the right thing.
> 
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
> Reviewed-by: Nicolas Pitre <nico@linaro.org>
> ---
>  arch/arm/include/asm/page.h           |    2 +-
>  arch/arm/include/asm/pgtable-3level.h |    6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/include/asm/page.h b/arch/arm/include/asm/page.h
> index ecf9019..1e0fe08 100644
> --- a/arch/arm/include/asm/page.h
> +++ b/arch/arm/include/asm/page.h
> @@ -13,7 +13,7 @@
>  /* PAGE_SHIFT determines the page size */
>  #define PAGE_SHIFT		12
>  #define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
> -#define PAGE_MASK		(~(PAGE_SIZE-1))
> +#define PAGE_MASK		(~((1 << PAGE_SHIFT) - 1))

It's strange.  Every other platform in the kernel, including those with
PAE, manage to get away with defining PAGE_MASK as the original above
(see asm-generic/pgtable.h)  Why is ARM any different?

Note that PAGE_MASK gets used at the moment on ARM for both virtual and
physical addresses.  x86 has PHYSICAL_PAGE_MASK for masking physical
addresses.  Maybe we should adopt the same approach?

Whatever, I feel that we should not deviate from the established
definitions across every other architecture.

>  
>  #ifndef __ASSEMBLY__
>  
> diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
> index b249035..ae39d11 100644
> --- a/arch/arm/include/asm/pgtable-3level.h
> +++ b/arch/arm/include/asm/pgtable-3level.h
> @@ -48,16 +48,16 @@
>  #define PMD_SHIFT		21
>  
>  #define PMD_SIZE		(1UL << PMD_SHIFT)
> -#define PMD_MASK		(~(PMD_SIZE-1))
> +#define PMD_MASK		(~((1 << PMD_SHIFT) - 1))
>  #define PGDIR_SIZE		(1UL << PGDIR_SHIFT)
> -#define PGDIR_MASK		(~(PGDIR_SIZE-1))
> +#define PGDIR_MASK		(~((1 << PGDIR_SHIFT) - 1))
>  
>  /*
>   * section address mask and size definitions.
>   */
>  #define SECTION_SHIFT		21
>  #define SECTION_SIZE		(1UL << SECTION_SHIFT)
> -#define SECTION_MASK		(~(SECTION_SIZE-1))
> +#define SECTION_MASK		(~((1 << SECTION_SHIFT) - 1))

These masks are applied to a _virtual_ kernel address, not the physical
addresses,  Even with LPAE, the virtual address space is still 32-bit.

So this is definitely wrong.
