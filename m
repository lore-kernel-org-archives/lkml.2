Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580Ab2JSN3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:29:21 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18892 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758271Ab2JSN3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:29:19 -0400
Date: Fri, 19 Oct 2012 09:17:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Mukesh Rathor <mukesh.rathor@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 1/6]: PVH: basic and header changes, elfnote changes,
 ...
Message-ID: <20121019131707.GG26830@phenom.dumpdata.com>
References: <20121017172642.349b2aae@mantra.us.oracle.com>
 <alpine.DEB.2.02.1210181150250.2689@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1210181150250.2689@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +config XEN_X86_PVH
> > +	bool "Support for running as a PVH guest (EXPERIMENTAL)"
> > +	depends on X86_64 && XEN && EXPERIMENTAL
> > +	default n
> > +	help
> > +	   This option enables support for running as a PVH guest (PV guest
> > +	   using hardware extensions) under a suitably capable hypervisor.
> > +	   This option is EXPERIMENTAL because the hypervisor interfaces
> > +	   which it uses are not yet considered stable therefore backwards and
> > +	   forwards compatibility is not yet guaranteed.  If unsure, say N.
> 
> Do we really need the kconfig symbol? Why can't we have it always

Yes for right now. That is to make sure that we can test for regressions
PV guests on a hypervisor without PVH extensions - or vice-versa:
PVH hypervisors with an normal PV guest.

Until most bugs and the other work is completed this is a bit of a safety
valve, in case we mess up.

> enabled?

You know what Linus's thinks about the 'y' be default. He usually rips
one's behind for that - especially for this which is still in its infancy
period. Later on when we get bugs and kinks worked out then we can
re-evaluate.

> 
> 
> > diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
> > index 7faed58..1a6bca1 100644
> > --- a/arch/x86/xen/xen-head.S
> > +++ b/arch/x86/xen/xen-head.S
> > @@ -13,6 +13,15 @@
> >  #include <xen/interface/elfnote.h>
> >  #include <asm/xen/interface.h>
> >  
> > +#ifdef CONFIG_XEN_X86_PVH
> > +#define FEATURES_PVH "|writable_descriptor_tables" \
> > +		     "|auto_translated_physmap" \
> > +		     "|supervisor_mode_kernel" \
> > +		     "|hvm_callback_vector"
> > +#else
> > +#define FEATURES_PVH /* Not supported */
> > +#endif
> > +
> >  	__INIT
> >  ENTRY(startup_xen)
> >  	cld
> > @@ -95,7 +104,7 @@ NEXT_HYPERCALL(arch_6)
> >  #endif
> >  	ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          _ASM_PTR startup_xen)
> >  	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, _ASM_PTR hypercall_page)
> > -	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb")
> > +	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb"FEATURES_PVH)
> >  	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "yes")
> >  	ELFNOTE(Xen, XEN_ELFNOTE_LOADER,         .asciz "generic")
> >  	ELFNOTE(Xen, XEN_ELFNOTE_L1_MFN_VALID,
> 
> Considering that the PVH capability ends up in an ELF note, the kconfig
> symbol is actually useful at least for debugging: it is the only way to
> disable it from the guest side. However I would imaging that Xen would
> always provide an option to disable PVH features in a VM or dom0.

Right.
> 
> 
> > diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
> > index d8e33a9..425911f 100644
> > --- a/include/xen/interface/memory.h
> > +++ b/include/xen/interface/memory.h
> > @@ -169,7 +169,13 @@ struct xen_add_to_physmap {
> >      /* Source mapping space. */
> >  #define XENMAPSPACE_shared_info 0 /* shared info page */
> >  #define XENMAPSPACE_grant_table 1 /* grant table page */
> > -    unsigned int space;
> > +#define XENMAPSPACE_gmfn        2 /* GMFN */
> > +#define XENMAPSPACE_gmfn_range  3 /* GMFN range */
> > +#define XENMAPSPACE_gmfn_foreign 4 /* GMFN from another guest */
> > +    uint16_t space;
> > +    domid_t foreign_domid;         /* IFF XENMAPSPACE_gmfn_foreign */
> > +
> > +#define XENMAPIDX_grant_table_status 0x80000000
> >  
> >      /* Index into source mapping space. */
> >      unsigned long idx;
> > @@ -237,4 +243,20 @@ DEFINE_GUEST_HANDLE_STRUCT(xen_memory_map);
> >   * during a driver critical region.
> >   */
> >  extern spinlock_t xen_reservation_lock;
> > +
> > +/*
> > + * Unmaps the page appearing at a particular GPFN from the specified guest's
> > + * pseudophysical address space.
> > + * arg == addr of xen_remove_from_physmap_t.
> > + */
> > +#define XENMEM_remove_from_physmap      15
> > +struct xen_remove_from_physmap {
> > +    /* Which domain to change the mapping for. */
> > +    domid_t domid;
> > +
> > +    /* GPFN of the current mapping of the page. */
> > +    xen_pfn_t gpfn;
> > +};
> > +DEFINE_GUEST_HANDLE_STRUCT(xen_remove_from_physmap);
> > +
> >  #endif /* __XEN_PUBLIC_MEMORY_H__ */
> 
> these bits have been submitted separately by Ian, if I am not mistaken.

I can take of care of doing the merge/conflict resolution.

> 
> 
> > diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
> > index 9ce788d..3b9d5b6 100644
> > --- a/include/xen/interface/physdev.h
> > +++ b/include/xen/interface/physdev.h
> > @@ -258,6 +258,16 @@ struct physdev_pci_device {
> >      uint8_t devfn;
> >  };
> >  
> > +#define PHYSDEVOP_pvh_map_iomem        30
> 
> I would just call this PHYSDEVOP_map_iomem, we might use it on non-PVH
> guests as well one day.

I completely lost track of the naming now :-( Isn't the ARM version
called range something?
> 
> 
> > +struct physdev_map_iomem {
> > +    /* IN */
> > +    uint64_t first_gfn;
> > +    uint64_t first_mfn;
> > +    uint32_t nr_mfns;
> > +    uint32_t add_mapping;        /* 1 == add mapping;  0 == unmap */
> > +
> > +};
> > +
> >  /*
> >   * Notify that some PIRQ-bound event channels have been unmasked.
> >   * ** This command is obsolete since interface version 0x00030202 and is **
> > -- 
> > 1.7.2.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
