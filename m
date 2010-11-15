Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab0KOSfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:35:06 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47776 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab0KOSfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:35:05 -0500
Date: Mon, 15 Nov 2010 18:34:43 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/20] ARM: LPAE: Introduce the 3-level page table
	format definitions
Message-ID: <20101115183443.GE31421@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <1289584840-18097-7-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289584840-18097-7-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 06:00:26PM +0000, Catalin Marinas wrote:
> This patch introduces the pgtable-3level*.h files with definitions
> specific to the LPAE page table format (3 levels of page tables).
> 
> Each table is 4KB and has 512 64-bit entries. An entry can point to a
> 40-bit physical address. The young, write and exec software bits share
> the corresponding hardware bits (negated). Other software bits use spare
> bits in the PTE.
> 
> The patch also changes some variable types from unsigned long or int to
> pteval_t or pgprot_t.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm/include/asm/page.h                 |    4 +
>  arch/arm/include/asm/pgtable-3level-hwdef.h |   78 ++++++++++++++++++
>  arch/arm/include/asm/pgtable-3level-types.h |   55 +++++++++++++
>  arch/arm/include/asm/pgtable-3level.h       |  113 +++++++++++++++++++++++++++
>  arch/arm/include/asm/pgtable-hwdef.h        |    4 +
>  arch/arm/include/asm/pgtable.h              |    6 +-
>  arch/arm/mm/mm.h                            |    8 +-
>  arch/arm/mm/mmu.c                           |    2 +-
>  8 files changed, 264 insertions(+), 6 deletions(-)
>  create mode 100644 arch/arm/include/asm/pgtable-3level-hwdef.h
>  create mode 100644 arch/arm/include/asm/pgtable-3level-types.h
>  create mode 100644 arch/arm/include/asm/pgtable-3level.h
> 
> diff --git a/arch/arm/include/asm/page.h b/arch/arm/include/asm/page.h
> index 3848105..e5124db 100644
> --- a/arch/arm/include/asm/page.h
> +++ b/arch/arm/include/asm/page.h
> @@ -151,7 +151,11 @@ extern void __cpu_copy_user_highpage(struct page *to, struct page *from,
>  #define clear_page(page)	memset((void *)(page), 0, PAGE_SIZE)
>  extern void copy_page(void *to, const void *from);
>  
> +#ifdef CONFIG_ARM_LPAE
> +#include <asm/pgtable-3level-types.h>
> +#else
>  #include <asm/pgtable-2level-types.h>
> +#endif
>  
>  #endif /* CONFIG_MMU */
>  
> diff --git a/arch/arm/include/asm/pgtable-3level-hwdef.h b/arch/arm/include/asm/pgtable-3level-hwdef.h
> new file mode 100644
> index 0000000..2f99c3c
> --- /dev/null
> +++ b/arch/arm/include/asm/pgtable-3level-hwdef.h
> @@ -0,0 +1,78 @@
> +/*
> + * arch/arm/include/asm/pgtable-3level-hwdef.h
> + *
> + * Copyright (C) 2010 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +#ifndef _ASM_PGTABLE_3LEVEL_HWDEF_H
> +#define _ASM_PGTABLE_3LEVEL_HWDEF_H
> +
> +#include <linux/const.h>
> +#include <asm/pgtable-3level-types.h>
> +
> +/*
> + * Hardware page table definitions.
> + *
> + * + Level 1/2 descriptor
> + *   - common
> + */
> +#define PMD_TYPE_MASK		(_AT(pmd_t, 3) << 0)
> +#define PMD_TYPE_FAULT		(_AT(pmd_t, 0) << 0)
> +#define PMD_TYPE_TABLE		(_AT(pmd_t, 3) << 0)
> +#define PMD_TYPE_SECT		(_AT(pmd_t, 1) << 0)
> +#define PMD_BIT4		(_AT(pmd_t, 0))
> +#define PMD_DOMAIN(x)		(_AT(pmd_t, 0))

It is really not correct to have these constants type'd as pmd_t.
The idea behind pmd_t et.al. is to detect when normal arithmetic or
logical operations are performed on page table entries when the
accessors instead should be used.

By typing these as pmd_t, it means operations need to be:

	u32 pmdval = pmd_val(foo) | pmd_val(PMD_TYE_TABLE);

which is obviously more complicated than is needed.

> diff --git a/arch/arm/mm/mm.h b/arch/arm/mm/mm.h
> index 6630620..a62f093 100644
> --- a/arch/arm/mm/mm.h
> +++ b/arch/arm/mm/mm.h
> @@ -16,10 +16,10 @@ static inline pmd_t *pmd_off_k(unsigned long virt)
>  }
>  
>  struct mem_type {
> -	unsigned int prot_pte;
> -	unsigned int prot_l1;
> -	unsigned int prot_sect;
> -	unsigned int domain;
> +	pgprot_t prot_pte;
> +	pgprot_t prot_l1;
> +	pgprot_t prot_sect;
> +	pgprot_t domain;

Again, this is wrong.  There's an accessor for pgprot_t typed data.  This
causes code to violate it.

> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index 0ca33dd..7c803c4 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -292,7 +292,7 @@ static void __init build_mem_type_table(void)
>  {
>  	struct cachepolicy *cp;
>  	unsigned int cr = get_cr();
> -	unsigned int user_pgprot, kern_pgprot, vecs_pgprot;
> +	pgprot_t user_pgprot, kern_pgprot, vecs_pgprot;

Ditto.
