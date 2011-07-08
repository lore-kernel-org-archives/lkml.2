Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab1GHTVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 15:21:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41335 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab1GHTVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 15:21:43 -0400
Date: Fri, 8 Jul 2011 20:21:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 00/18] ARM: Add support for the Large Physical
	Address Extensions
Message-ID: <20110708192126.GP4812@n2100.arm.linux.org.uk>
References: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com> <20110701162419.GA3990@1n450.cable.virginmedia.net> <20110702121928.GG21898@n2100.arm.linux.org.uk> <20110704172300.GB30189@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704172300.GB30189@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 06:23:00PM +0100, Catalin Marinas wrote:
> On Sat, Jul 02, 2011 at 01:19:28PM +0100, Russell King - ARM Linux wrote:
> > On Fri, Jul 01, 2011 at 05:24:19PM +0100, Catalin Marinas wrote:
> > > On Tue, May 24, 2011 at 10:39:06PM +0100, Catalin Marinas wrote:
> > > > Catalin Marinas (14):
> > > >   ARM: LPAE: Use unsigned long for __phys_to_virt and __virt_to_phys
> > 
> > I don't like this; these macros are supposed to take unsigned long
> > arguments (the hint is in their non-__ versions and __[vp]a, which
> > contain the explicit casts.)  I'd much rather have their callers
> > reduced in number, especially as this is a macro which platform classes
> > may (and do) define.
> > 
> > There are five places which use __phys_to_virt and one place which uses
> > __virt_to_phys.
> > 
> > Of the __virt_to_phys, this takes a u32 argument anyway, so that won't
> > cause any concerns.
> > 
> > Of the __phys_to_virt, the L2 cache handing files can use a void * for
> > vaddr and use the standard phys_to_virt().  That leaves three in the core
> > arch code, which can be dealt with by local casting.
> 
> The error actually comes via the default __bus_to_virt. I can change the
> default dma_to_virt() to do the casting (and the other places that you
> mentioned).

Is that because of:

static inline void *dma_to_virt(struct device *dev, dma_addr_t addr)
{
        return (void *)__bus_to_virt(addr);
}

?  In theory, we should never be passed a dma_addr_t > 32-bit here, but
we probably want a check in there just in case.  On the other hand, it's
only used (after this merge window) in dma_sync_single_range_for_cpu
and dma_sync_single_range_for_device.  I'm not sure its worth keeping
just for those.

> > > >   ARM: LPAE: Use PMD_(SHIFT|SIZE|MASK) instead of PGDIR_*
> > 
> > This one I think is fine, except the dependency on what we do about the
> > dma coherent code...
> 
> Is this in -next already?

Yes it is, but as I've been saying I think I'm dropping it for this merge
window because it causes regressions on existing platforms to the extent
that they fail to boot.  We could move forward by getting everywhere else
fixed up...

> > Also, see the patch below which is something I've
> > been thinking about to avoid the multiple-walking of the page table tree.
> 
> I'll comment on the patch below.
> 
> > However, can we guarantee what the L1 page table in LPAE will contain?
> 
> The L1 can either be empty or point to the L2 page table. What other
> guarantees do you mean?

That.  So unused L1 entries won't contain garbage.

> > > >   ARM: LPAE: Factor out 2-level page table definitions into separate
> > > >     files
> > > >   ARM: LPAE: Add (pte|pmd|pgd|pgprot)val_t type definitions as u32
> > 
> > I'm unconvinced that this is the right solution to add all these val_t
> > types, especially as u32.  
> 
> Well, they are u32 in hardware. We can leave them as unsigned long but
> it shouldn't make any difference. We introduce the LPAE once as u64, so
> it makes sense to have some consistent definition.
> 
> And there are places where we want some common type names rather than
> using ifdef's.

While I realize the whole point of using the typedefs, I don't think
the conversion is entirely correct - there were certainly some things
that raised an eyebrow here, but at the moment I can't put my finger
on them immediately without going back over the patch.

> > It also creates some nonsense like assigning
> > pmdval_t values to pgprotval_t, and misses converting some other stuff
> > too.
> 
> An inconsistency I noticed is early_pte_alloc(). Are there others?

I couldn't say without looking at the patch again.

> > > >   ARM: LPAE: Use a mask for physical addresses in page table entries
> > > [...]
> > > > Will Deacon (4):
> > > >   ARM: LPAE: add ISBs around MMU enabling code
> > 
> > I still don't like this one - and I do think there's a solution without
> > having to resort to isb there.
> 
> And without exception return (which had it's own problems with the
> execution state bits).
> 
> > This also affects the cpu resume code too.
> 
> I fixed the sleep.S file but there wasn't a decision on this patch yet.

I didn't notice it as part of this patch set.

> > diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> > index 6e7f67f..1892c3d 100644
> > --- a/arch/arm/mm/mmu.c
> > +++ b/arch/arm/mm/mmu.c
> > @@ -862,6 +862,29 @@ static void __init sanity_check_meminfo(void)
> >  	meminfo.nr_banks = j;
> >  }
> >  
> > +static inline void pmd_clear_range(pgd_t *pgd, unsigned long addr, unsigned long end)
> > +{
> > +	pmd_t *pmd;
> > +
> > +	pmd = pmd_offset(pgd, addr);
> > +	do {
> > +		addr = pmd_addr_end(addr, end);
> > +		pmd_clear(pmd);
> > +	} while (pmd++, addr != end);
> > +}
> > +
> > +static void pgd_clear_range(unsigned long addr, unsigned long end)
> > +{
> > +	unsigned long next;
> > +	pgd_t *pgd;
> > +
> > +	pgd = pgd_offset_k(addr);
> > +	do {
> > +		next = pgd_addr_end(addr, end);
> > +		pmd_clear_range(pgd, addr, next);
> > +	} while (pgd++, addr = next, addr != end);
> > +}
> 
> You need to go through the pud here as pmd_offset takes a pud. We can
> assume that there is one pud folded into the pgd and call
> pmd_clear_range with a pud directly (similar to the fixup I posted some
> time ago to your patch converting to nopud).

Of course, this patch was written pre-PUD and used to be patched by the
PUD stuff.  As I was uncertain about how L1/L2 works on LPAE, it got
dropped out... Hence I've only the pre-PUD version now.
