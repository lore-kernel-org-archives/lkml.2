Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab2EGSyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 14:54:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45297 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2EGSyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 14:54:08 -0400
Date: Mon, 7 May 2012 14:48:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "JBeulich@suse.com" <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH] auto balloon initial domain and fix
 dom0_mem=X inconsistencies (v5).
Message-ID: <20120507184808.GA7249@phenom.dumpdata.com>
References: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com>
 <20120501163707.GA8741@phenom.dumpdata.com>
 <4FA27084.4030005@citrix.com>
 <4FA2A11E.1060907@cantab.net>
 <4FA2B1EF.8080900@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA2B1EF.8080900@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 05:27:27PM +0100, David Vrabel wrote:
> On 03/05/12 16:15, David Vrabel wrote:
> > 
> > xen: update VA mapping when releasing memory during setup
> > 
> > In xen_memory_setup(), if a page that is being released has a VA
> > mapping this must also be updated.  Otherwise, the page will be not
> > released completely -- it will still be referenced in Xen and won't be
> > freed util the mapping is removed and this prevents it from being
> > reallocated at a different PFN.
> > 
> > This was already being done for the ISA memory region in
> > xen_ident_map_ISA() but on many systems this was omitting a few pages
> > as many systems marked a few pages below the ISA memory region as
> > reserved in the e820 map.
> > 
> > Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> > ---
> [...]
> > --- a/arch/x86/xen/mmu.c
> > +++ b/arch/x86/xen/mmu.c
> > @@ -1929,29 +1929,6 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
> >  #endif
> >  }
> >  
> > -void __init xen_ident_map_ISA(void)
> > -{
> > -	unsigned long pa;
> > -
> > -	/*
> > -	 * If we're dom0, then linear map the ISA machine addresses into
> > -	 * the kernel's address space.
> > -	 */
> > -	if (!xen_initial_domain())
> > -		return;
> 
> It might look like this test has gone, however the new code which
> updates the VA mapping uses the e820 map and for a domU its map will not
> have a ISA region so there's no mapping to be updated.

What if you use e820_hole=1 and the pci=xx in the guest?
> 
> David
> 
> > -
> > -	xen_raw_printk("Xen: setup ISA identity maps\n");
> > -
> > -	for (pa = ISA_START_ADDRESS; pa < ISA_END_ADDRESS; pa += PAGE_SIZE) {
> > -		pte_t pte = mfn_pte(PFN_DOWN(pa), PAGE_KERNEL_IO);
> > -
> > -		if (HYPERVISOR_update_va_mapping(PAGE_OFFSET + pa, pte, 0))
> > -			BUG();
> > -	}
> > -
> > -	xen_flush_tlb();
> > -}
> > -
> >  static void __init xen_post_allocator_init(void)
> >  {
> >  	pv_mmu_ops.set_pte = xen_set_pte;
> > diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> > index 506a3e6..d5f8714 100644
> > --- a/arch/x86/xen/setup.c
> > +++ b/arch/x86/xen/setup.c
> > @@ -139,6 +139,13 @@ static unsigned long __init xen_do_chunk(unsigned long start,
> >  
> >  	return len;
> >  }
> > +
> > +static unsigned long __init xen_release_chunk(unsigned long start,
> > +					      unsigned long end)
> > +{
> > +	return xen_do_chunk(start, end, true);
> > +}
> > +
> >  static unsigned long __init xen_populate_chunk(
> >  	const struct e820entry *list, size_t map_size,
> >  	unsigned long max_pfn, unsigned long *last_pfn,
> > @@ -197,6 +204,29 @@ static unsigned long __init xen_populate_chunk(
> >  	}
> >  	return done;
> >  }
> > +
> > +static void __init xen_set_identity_and_release_chunk(
> > +	unsigned long start_pfn, unsigned long end_pfn, unsigned long nr_pages,
> > +	unsigned long *released, unsigned long *identity)
> > +{
> > +	unsigned long pfn;
> > +
> > +	/*
> > +	 * If the PFNs are currently mapped, the VA mapping also needs
> > +	 * to be updated to be 1:1.
> > +	 */
> > +	for (pfn = start_pfn; pfn <= max_pfn_mapped && pfn < end_pfn; pfn++)
> > +		(void)HYPERVISOR_update_va_mapping(
> > +			(unsigned long)__va(pfn << PAGE_SHIFT),
> > +			mfn_pte(pfn, PAGE_KERNEL_IO), 0);
> > +
> > +	if (start_pfn < nr_pages)
> > +		*released += xen_release_chunk(
> > +			start_pfn, min(end_pfn, nr_pages));
> > +
> > +	*identity += set_phys_range_identity(start_pfn, end_pfn);
> > +}
> > +
> >  static unsigned long __init xen_set_identity_and_release(
> >  	const struct e820entry *list, size_t map_size, unsigned long nr_pages)
> >  {
> > @@ -226,14 +256,11 @@ static unsigned long __init xen_set_identity_and_release(
> >  			if (entry->type == E820_RAM)
> >  				end_pfn = PFN_UP(entry->addr);
> >  
> > -			if (start_pfn < end_pfn) {
> > -				if (start_pfn < nr_pages)
> > -					released += xen_do_chunk(
> > -						start_pfn, min(end_pfn, nr_pages), true);
> > +			if (start_pfn < end_pfn)
> > +				xen_set_identity_and_release_chunk(
> > +					start_pfn, end_pfn, nr_pages,
> > +					&released, &identity);
> >  
> > -				identity += set_phys_range_identity(
> > -					start_pfn, end_pfn);
> > -			}
> >  			start = end;
> >  		}
> >  	}
> > diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
> > index b095739..506fa08 100644
> > --- a/arch/x86/xen/xen-ops.h
> > +++ b/arch/x86/xen/xen-ops.h
> > @@ -28,7 +28,6 @@ void xen_setup_shared_info(void);
> >  void xen_build_mfn_list_list(void);
> >  void xen_setup_machphys_mapping(void);
> >  pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn);
> > -void xen_ident_map_ISA(void);
> >  void xen_reserve_top(void);
> >  extern unsigned long xen_max_p2m_pfn;
> >  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
