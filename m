Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab2G0Rms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 13:42:48 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:52494 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2G0RmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 13:42:13 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2012 13:42:12 EDT
Date: Fri, 27 Jul 2012 13:38:24 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 4/7] xen/mmu: Recycle the Xen provided L4, L3, and L2 pages
Message-ID: <20120727173824.GD17427@andromeda.dapyr.net>
References: <1343335652-5659-1-git-send-email-konrad.wilk@oracle.com> <1343335652-5659-5-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1207271241580.26163@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1207271241580.26163@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 12:45:38PM +0100, Stefano Stabellini wrote:
> On Thu, 26 Jul 2012, Konrad Rzeszutek Wilk wrote:
> > As we are not using them. We end up only using the L1 pagetables
> > and grafting those to our page-tables.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/mmu.c |   38 ++++++++++++++++++++++++++++++++------
> >  1 files changed, 32 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> > index 48bdc9f..7f54b75 100644
> > --- a/arch/x86/xen/mmu.c
> > +++ b/arch/x86/xen/mmu.c
> > @@ -1724,6 +1724,9 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
> >  {
> >  	pud_t *l3;
> >  	pmd_t *l2;
> > +	unsigned long addr[3];
> > +	unsigned long pt_base, pt_end;
> > +	unsigned i;
> >  
> >  	/* max_pfn_mapped is the last pfn mapped in the initial memory
> >  	 * mappings. Considering that on Xen after the kernel mappings we
> > @@ -1731,6 +1734,9 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
> >  	 * set max_pfn_mapped to the last real pfn mapped. */
> >  	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->mfn_list));
> >  
> > +	pt_base = PFN_DOWN(__pa(xen_start_info->pt_base));
> > +	pt_end = PFN_DOWN(__pa(xen_start_info->pt_base + (xen_start_info->nr_pt_frames * PAGE_SIZE)));
> > +
> >  	/* Zap identity mapping */
> >  	init_level4_pgt[0] = __pgd(0);
> >  
> > @@ -1749,6 +1755,9 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
> >  	l3 = m2v(pgd[pgd_index(__START_KERNEL_map)].pgd);
> >  	l2 = m2v(l3[pud_index(__START_KERNEL_map)].pud);
> >  
> > +	addr[0] = (unsigned long)pgd;
> > +	addr[1] = (unsigned long)l2;
> > +	addr[2] = (unsigned long)l3;
> >  	/* Graft it onto L4[272][0]. Note that we creating an aliasing problem:
> >  	 * Both L4[272][0] and L4[511][511] have entries that point to the same
> >  	 * L2 (PMD) tables. Meaning that if you modify it in __va space
> > @@ -1791,12 +1800,29 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
> >  	__xen_write_cr3(true, __pa(init_level4_pgt));
> >  	xen_mc_issue(PARAVIRT_LAZY_CPU);
> >  
> > -	/* Offset by one page since the original pgd is going bye bye */
> > -	memblock_reserve(__pa(xen_start_info->pt_base + PAGE_SIZE),
> > -			 (xen_start_info->nr_pt_frames * PAGE_SIZE) - PAGE_SIZE);
> > -	/* and also RW it so it can actually be used. */
> > -	set_page_prot(pgd, PAGE_KERNEL);
> > -	clear_page(pgd);
> > +	/* We can't that easily rip out L3 and L2, as the Xen pagetables are
> > +	 * set out this way: [L4], [L1], [L2], [L3], [L1], [L1] ...  for
> > +	 * the initial domain. For guests using the toolstack, they are in:
> > +	 * [L4], [L3], [L2], [L1], [L1], order .. */
> > +	for (i = 0; i < ARRAY_SIZE(addr); i++) {
> > +		unsigned j;
> > +		/* No idea about the order the addr are in, so just do them twice. */
> > +		for (j = 0; j < ARRAY_SIZE(addr); j++) {
> 
> I don't think I understand this double loop.

So with Xen toolstack, the order is L4, L3, L2, L1s.. and with
the hypervisor it is L4, L1,... but in the future the order might
be L1, L1 ..., L1, L2, L3, L4 (potentially?) so this double loop
will loop around the addresses twice to catch this in case we get
it like this.

> Shouldn't we be looping on pt_base or pt_end?

So two loops - and it could be put in a seperate function. That
would make this easier to read. Yeah, let me do it that way.
Thanks!
> 
> 
> > +			if (pt_base == PFN_DOWN(__pa(addr[j]))) {
> > +				set_page_prot((void *)addr[j], PAGE_KERNEL);
> > +				clear_page((void *)addr[j]);
> > +				pt_base++;
> > +
> > +			}
> > +			if (pt_end == PFN_DOWN(__pa(addr[j]))) {
> > +				set_page_prot((void *)addr[j], PAGE_KERNEL);
> > +				clear_page((void *)addr[j]);
> > +				pt_end--;
> > +			}
> > +		}
> > +	}
> > +	/* Our (by three pages) smaller Xen pagetable that we are using */
> > +	memblock_reserve(PFN_PHYS(pt_base), (pt_end - pt_base) * PAGE_SIZE);
> 
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
