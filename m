Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab2JWNHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:07:37 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:62088 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932624Ab2JWNHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:07:36 -0400
X-IronPort-AV: E=Sophos;i="4.80,634,1344211200"; 
   d="scan'208";a="15334663"
Date: Tue, 23 Oct 2012 14:07:06 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "mukesh.rathor@oracle.com" <mukesh.rathor@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH 4/6] xen/pvh: bootup and setup related changes.
In-Reply-To: <20121022155717.GB25200@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1210231406490.2689@kaball.uk.xensource.com>
References: <1350695882-12820-1-git-send-email-konrad.wilk@oracle.com> <1350695882-12820-5-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1210221428050.2689@kaball.uk.xensource.com> <20121022155717.GB25200@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012, Konrad Rzeszutek Wilk wrote:
> On Mon, Oct 22, 2012 at 02:34:44PM +0100, Stefano Stabellini wrote:
> > On Sat, 20 Oct 2012, Konrad Rzeszutek Wilk wrote:
> > > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > 
> > > In enlighten.c for PVH we can trap cpuid via vmexit, so don't
> > > need to use emulated prefix call. We also check for vector callback
> > > early on, as it is a required feature. PVH also runs at default kernel
> > > IOPL.
> > > 
> > > In setup.c, in xen_add_extra_mem() we can skip updating P2M as it's managed
> > > by Xen. PVH maps the entire IO space, but only RAM pages need to be repopulated.
> > > 
> > > Finally, pure PV settings are moved to a separate function that is only called
> > > for pure PV, ie, pv with pvmmu.
> > > 
> > > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > >
> > > diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> > > index 8971a26..8cce47b 100644
> > > --- a/arch/x86/xen/setup.c
> > > +++ b/arch/x86/xen/setup.c
> > > @@ -27,6 +27,7 @@
> > >  #include <xen/interface/memory.h>
> > >  #include <xen/interface/physdev.h>
> > >  #include <xen/features.h>
> > > +#include "mmu.h"
> > >  #include "xen-ops.h"
> > >  #include "vdso.h"
> > >  
> > > @@ -78,6 +79,9 @@ static void __init xen_add_extra_mem(u64 start, u64 size)
> > >  
> > >  	memblock_reserve(start, size);
> > >  
> > > +	if (xen_feature(XENFEAT_auto_translated_physmap))
> > > +		return;
> > > +
> > >  	xen_max_p2m_pfn = PFN_DOWN(start + size);
> > >  	for (pfn = PFN_DOWN(start); pfn < xen_max_p2m_pfn; pfn++) {
> > >  		unsigned long mfn = pfn_to_mfn(pfn);
> > > @@ -100,6 +104,7 @@ static unsigned long __init xen_do_chunk(unsigned long start,
> > >  		.domid        = DOMID_SELF
> > >  	};
> > >  	unsigned long len = 0;
> > > +	int xlated_phys = xen_feature(XENFEAT_auto_translated_physmap);
> > >  	unsigned long pfn;
> > >  	int ret;
> > >  
> > > @@ -113,7 +118,7 @@ static unsigned long __init xen_do_chunk(unsigned long start,
> > >  				continue;
> > >  			frame = mfn;
> > >  		} else {
> > > -			if (mfn != INVALID_P2M_ENTRY)
> > > +			if (!xlated_phys && mfn != INVALID_P2M_ENTRY)
> > >  				continue;
> > >  			frame = pfn;
> > >  		}
> > 
> > Shouldn't we add a "!xlated_phys &&" to the other case as well?
> 
> No. That is handled in xen_pvh_identity_map_chunk which
> just does a xen_set_clr_mmio_pvh_pte call for the "released"
> pages. But that is a bit of ... well, extra logic. I think
> if we did this it would work and look much nicer:

Yes, I think that this version looks better

> 
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 8cce47b..b451a77 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -114,9 +114,15 @@ static unsigned long __init xen_do_chunk(unsigned long start,
>  
>  		if (release) {
>  			/* Make sure pfn exists to start with */
> -			if (mfn == INVALID_P2M_ENTRY || mfn_to_pfn(mfn) != pfn)
> +			if (mfn == INVALID_P2M_ENTRY || (!xlated_phys && (mfn_to_pfn(mfn) != pfn)))
>  				continue;
>  			frame = mfn;
> +			/* The hypercall PHYSDEVOP_map_iomem to release memory has already
> +			 * happend, so we just do a nop here. */
> +			if (xlated_phys) {
> +				len++;
> +				continue;
> +			}
>  		} else {
>  			if (!xlated_phys && mfn != INVALID_P2M_ENTRY)
>  				continue;
> @@ -219,15 +225,24 @@ static void __init xen_set_identity_and_release_chunk(
>  {
>  	unsigned long pfn;
>  
> +	/* For PVH, the pfns [0..MAX] are mapped to mfn's in the EPT/NPT. The mfns
> +	 * are released as part of this 1:1 mapping hypercall back to the dom heap.
> +	 * Also, we map the entire IO space, ie, beyond max_pfn_mapped.
> +	 */
> +	int xlated_phys = xen_feature(XENFEAT_auto_translated_physmap);
> +
>  	/*
>  	 * If the PFNs are currently mapped, the VA mapping also needs
>  	 * to be updated to be 1:1.
>  	 */
> -	for (pfn = start_pfn; pfn <= max_pfn_mapped && pfn < end_pfn; pfn++)
> -		(void)HYPERVISOR_update_va_mapping(
> -			(unsigned long)__va(pfn << PAGE_SHIFT),
> -			mfn_pte(pfn, PAGE_KERNEL_IO), 0);
> -
> +	for (pfn = start_pfn; pfn <= max_pfn_mapped && pfn < end_pfn; pfn++) {
> +		if (xlated_phys)
> +			xen_set_clr_mmio_pvh_pte(pfn, pfn, 1 /* one pfn */, 1 /* add mapping */);
> +		else
> +			(void)HYPERVISOR_update_va_mapping(
> +				(unsigned long)__va(pfn << PAGE_SHIFT),
> +				mfn_pte(pfn, PAGE_KERNEL_IO), 0);
> +	}
>  	if (start_pfn < nr_pages)
>  		*released += xen_release_chunk(
>  			start_pfn, min(end_pfn, nr_pages));
> @@ -235,27 +250,6 @@ static void __init xen_set_identity_and_release_chunk(
>  	*identity += set_phys_range_identity(start_pfn, end_pfn);
>  }
>  
> -/* For PVH, the pfns [0..MAX] are mapped to mfn's in the EPT/NPT. The mfns
> - * are released as part of this 1:1 mapping hypercall back to the dom heap.
> - * Also, we map the entire IO space, ie, beyond max_pfn_mapped.
> - */
> -static void __init xen_pvh_identity_map_chunk(unsigned long start_pfn,
> -		unsigned long end_pfn, unsigned long *released,
> -		unsigned long *identity, unsigned long max_pfn)
> -{
> -	unsigned long pfn;
> -	int numpfns = 1, add_mapping = 1;
> -
> -	for (pfn = start_pfn; pfn < end_pfn; pfn++)
> -		xen_set_clr_mmio_pvh_pte(pfn, pfn, numpfns, add_mapping);
> -
> -	if (start_pfn <= max_pfn) {
> -		unsigned long end = min(max_pfn_mapped, end_pfn);
> -		*released += end - start_pfn;
> -	}
> -	*identity += end_pfn - start_pfn;
> -}
> -
>  static unsigned long __init xen_set_identity_and_release(
>  	const struct e820entry *list, size_t map_size, unsigned long nr_pages)
>  {
> @@ -286,17 +280,10 @@ static unsigned long __init xen_set_identity_and_release(
>  			if (entry->type == E820_RAM)
>  				end_pfn = PFN_UP(entry->addr);
>  
> -			if (start_pfn < end_pfn) {
> -				if (xlated_phys) {
> -					xen_pvh_identity_map_chunk(start_pfn,
> -						end_pfn, &released, &identity,
> -						nr_pages);
> -				} else {
> -					xen_set_identity_and_release_chunk(
> +			if (start_pfn < end_pfn)
> +				xen_set_identity_and_release_chunk(
>  						start_pfn, end_pfn, nr_pages,
>  						&released, &identity);
> -				}
> -			}
>  			start = end;
>  		}
>  	}
> 
