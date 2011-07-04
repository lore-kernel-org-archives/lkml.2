Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab1GDRXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:23:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55810 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755061Ab1GDRXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:23:16 -0400
Date: Mon, 4 Jul 2011 18:23:00 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 00/18] ARM: Add support for the Large Physical
 Address Extensions
Message-ID: <20110704172300.GB30189@e102109-lin.cambridge.arm.com>
References: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
 <20110701162419.GA3990@1n450.cable.virginmedia.net>
 <20110702121928.GG21898@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110702121928.GG21898@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 02, 2011 at 01:19:28PM +0100, Russell King - ARM Linux wrote:
> On Fri, Jul 01, 2011 at 05:24:19PM +0100, Catalin Marinas wrote:
> > On Tue, May 24, 2011 at 10:39:06PM +0100, Catalin Marinas wrote:
> > > Catalin Marinas (14):
> > >   ARM: LPAE: Use unsigned long for __phys_to_virt and __virt_to_phys
> 
> I don't like this; these macros are supposed to take unsigned long
> arguments (the hint is in their non-__ versions and __[vp]a, which
> contain the explicit casts.)  I'd much rather have their callers
> reduced in number, especially as this is a macro which platform classes
> may (and do) define.
> 
> There are five places which use __phys_to_virt and one place which uses
> __virt_to_phys.
> 
> Of the __virt_to_phys, this takes a u32 argument anyway, so that won't
> cause any concerns.
> 
> Of the __phys_to_virt, the L2 cache handing files can use a void * for
> vaddr and use the standard phys_to_virt().  That leaves three in the core
> arch code, which can be dealt with by local casting.

The error actually comes via the default __bus_to_virt. I can change the
default dma_to_virt() to do the casting (and the other places that you
mentioned).

> > >   ARM: LPAE: Use PMD_(SHIFT|SIZE|MASK) instead of PGDIR_*
> 
> This one I think is fine, except the dependency on what we do about the
> dma coherent code...

Is this in -next already?

> Also, see the patch below which is something I've
> been thinking about to avoid the multiple-walking of the page table tree.

I'll comment on the patch below.

> However, can we guarantee what the L1 page table in LPAE will contain?

The L1 can either be empty or point to the L2 page table. What other
guarantees do you mean?

> > >   ARM: LPAE: Factor out 2-level page table definitions into separate
> > >     files
> > >   ARM: LPAE: Add (pte|pmd|pgd|pgprot)val_t type definitions as u32
> 
> I'm unconvinced that this is the right solution to add all these val_t
> types, especially as u32.  

Well, they are u32 in hardware. We can leave them as unsigned long but
it shouldn't make any difference. We introduce the LPAE once as u64, so
it makes sense to have some consistent definition.

And there are places where we want some common type names rather than
using ifdef's.

> It also creates some nonsense like assigning
> pmdval_t values to pgprotval_t, and misses converting some other stuff
> too.

An inconsistency I noticed is early_pte_alloc(). Are there others?

> > >   ARM: LPAE: Use a mask for physical addresses in page table entries
> > [...]
> > > Will Deacon (4):
> > >   ARM: LPAE: add ISBs around MMU enabling code
> 
> I still don't like this one - and I do think there's a solution without
> having to resort to isb there.

And without exception return (which had it's own problems with the
execution state bits).

> This also affects the cpu resume code too.

I fixed the sleep.S file but there wasn't a decision on this patch yet.

> > >   ARM: LPAE: Use generic dma_addr_t type definition
> 
> This is already the case since:
>   commit 8547727756a7322b99aa313ce50fe15d8f858872
>   Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>   Date:   Wed Mar 23 16:43:28 2011 -0700
> 
>     remove dma64_addr_t

OK, I think rebasing the patches to the latest -rc would remove this.

> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index 6e7f67f..1892c3d 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -862,6 +862,29 @@ static void __init sanity_check_meminfo(void)
>  	meminfo.nr_banks = j;
>  }
>  
> +static inline void pmd_clear_range(pgd_t *pgd, unsigned long addr, unsigned long end)
> +{
> +	pmd_t *pmd;
> +
> +	pmd = pmd_offset(pgd, addr);
> +	do {
> +		addr = pmd_addr_end(addr, end);
> +		pmd_clear(pmd);
> +	} while (pmd++, addr != end);
> +}
> +
> +static void pgd_clear_range(unsigned long addr, unsigned long end)
> +{
> +	unsigned long next;
> +	pgd_t *pgd;
> +
> +	pgd = pgd_offset_k(addr);
> +	do {
> +		next = pgd_addr_end(addr, end);
> +		pmd_clear_range(pgd, addr, next);
> +	} while (pgd++, addr = next, addr != end);
> +}

You need to go through the pud here as pmd_offset takes a pud. We can
assume that there is one pud folded into the pgd and call
pmd_clear_range with a pud directly (similar to the fixup I posted some
time ago to your patch converting to nopud).

-- 
Catalin
