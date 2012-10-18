Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab2JRK64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:58:56 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:7074 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab2JRK5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:57:43 -0400
X-IronPort-AV: E=Sophos;i="4.80,606,1344211200"; 
   d="scan'208";a="15251514"
Date: Thu, 18 Oct 2012 11:57:18 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 1/6]: PVH: basic and header changes, elfnote changes,
 ...
In-Reply-To: <20121017172642.349b2aae@mantra.us.oracle.com>
Message-ID: <alpine.DEB.2.02.1210181150250.2689@kaball.uk.xensource.com>
References: <20121017172642.349b2aae@mantra.us.oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012, Mukesh Rathor wrote:
> [PATCH 1/6] PVH: is a PV linux guest that has extended capabilities. This patch allows it to be configured and enabled. Also, basic header file changes to add new subcalls to physmap hypercall. Lastly, mfn_to_local_pfn must return mfn for paging mode translate.
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> ---
>  arch/x86/include/asm/xen/page.h |    3 +++
>  arch/x86/xen/Kconfig            |   10 ++++++++++
>  arch/x86/xen/xen-head.S         |   11 ++++++++++-
>  include/xen/interface/memory.h  |   24 +++++++++++++++++++++++-
>  include/xen/interface/physdev.h |   10 ++++++++++
>  5 files changed, 56 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
> index 472b9b7..6af440d 100644
> --- a/arch/x86/include/asm/xen/page.h
> +++ b/arch/x86/include/asm/xen/page.h
> @@ -159,6 +159,9 @@ static inline xpaddr_t machine_to_phys(xmaddr_t machine)
>  static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
>  {
>  	unsigned long pfn = mfn_to_pfn(mfn);
> +
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return mfn;
>  	if (get_phys_to_machine(pfn) != mfn)
>  		return -1; /* force !pfn_valid() */
>  	return pfn;
> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> index fdce49c..822c5a0 100644
> --- a/arch/x86/xen/Kconfig
> +++ b/arch/x86/xen/Kconfig
> @@ -50,3 +50,13 @@ config XEN_DEBUG_FS
>  	  Enable statistics output and various tuning options in debugfs.
>  	  Enabling this option may incur a significant performance overhead.
>  
> +config XEN_X86_PVH
> +	bool "Support for running as a PVH guest (EXPERIMENTAL)"
> +	depends on X86_64 && XEN && EXPERIMENTAL
> +	default n
> +	help
> +	   This option enables support for running as a PVH guest (PV guest
> +	   using hardware extensions) under a suitably capable hypervisor.
> +	   This option is EXPERIMENTAL because the hypervisor interfaces
> +	   which it uses are not yet considered stable therefore backwards and
> +	   forwards compatibility is not yet guaranteed.  If unsure, say N.

Do we really need the kconfig symbol? Why can't we have it always
enabled?


> diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
> index 7faed58..1a6bca1 100644
> --- a/arch/x86/xen/xen-head.S
> +++ b/arch/x86/xen/xen-head.S
> @@ -13,6 +13,15 @@
>  #include <xen/interface/elfnote.h>
>  #include <asm/xen/interface.h>
>  
> +#ifdef CONFIG_XEN_X86_PVH
> +#define FEATURES_PVH "|writable_descriptor_tables" \
> +		     "|auto_translated_physmap" \
> +		     "|supervisor_mode_kernel" \
> +		     "|hvm_callback_vector"
> +#else
> +#define FEATURES_PVH /* Not supported */
> +#endif
> +
>  	__INIT
>  ENTRY(startup_xen)
>  	cld
> @@ -95,7 +104,7 @@ NEXT_HYPERCALL(arch_6)
>  #endif
>  	ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          _ASM_PTR startup_xen)
>  	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, _ASM_PTR hypercall_page)
> -	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb")
> +	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb"FEATURES_PVH)
>  	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "yes")
>  	ELFNOTE(Xen, XEN_ELFNOTE_LOADER,         .asciz "generic")
>  	ELFNOTE(Xen, XEN_ELFNOTE_L1_MFN_VALID,

Considering that the PVH capability ends up in an ELF note, the kconfig
symbol is actually useful at least for debugging: it is the only way to
disable it from the guest side. However I would imaging that Xen would
always provide an option to disable PVH features in a VM or dom0.


> diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
> index d8e33a9..425911f 100644
> --- a/include/xen/interface/memory.h
> +++ b/include/xen/interface/memory.h
> @@ -169,7 +169,13 @@ struct xen_add_to_physmap {
>      /* Source mapping space. */
>  #define XENMAPSPACE_shared_info 0 /* shared info page */
>  #define XENMAPSPACE_grant_table 1 /* grant table page */
> -    unsigned int space;
> +#define XENMAPSPACE_gmfn        2 /* GMFN */
> +#define XENMAPSPACE_gmfn_range  3 /* GMFN range */
> +#define XENMAPSPACE_gmfn_foreign 4 /* GMFN from another guest */
> +    uint16_t space;
> +    domid_t foreign_domid;         /* IFF XENMAPSPACE_gmfn_foreign */
> +
> +#define XENMAPIDX_grant_table_status 0x80000000
>  
>      /* Index into source mapping space. */
>      unsigned long idx;
> @@ -237,4 +243,20 @@ DEFINE_GUEST_HANDLE_STRUCT(xen_memory_map);
>   * during a driver critical region.
>   */
>  extern spinlock_t xen_reservation_lock;
> +
> +/*
> + * Unmaps the page appearing at a particular GPFN from the specified guest's
> + * pseudophysical address space.
> + * arg == addr of xen_remove_from_physmap_t.
> + */
> +#define XENMEM_remove_from_physmap      15
> +struct xen_remove_from_physmap {
> +    /* Which domain to change the mapping for. */
> +    domid_t domid;
> +
> +    /* GPFN of the current mapping of the page. */
> +    xen_pfn_t gpfn;
> +};
> +DEFINE_GUEST_HANDLE_STRUCT(xen_remove_from_physmap);
> +
>  #endif /* __XEN_PUBLIC_MEMORY_H__ */

these bits have been submitted separately by Ian, if I am not mistaken.


> diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
> index 9ce788d..3b9d5b6 100644
> --- a/include/xen/interface/physdev.h
> +++ b/include/xen/interface/physdev.h
> @@ -258,6 +258,16 @@ struct physdev_pci_device {
>      uint8_t devfn;
>  };
>  
> +#define PHYSDEVOP_pvh_map_iomem        30

I would just call this PHYSDEVOP_map_iomem, we might use it on non-PVH
guests as well one day.


> +struct physdev_map_iomem {
> +    /* IN */
> +    uint64_t first_gfn;
> +    uint64_t first_mfn;
> +    uint32_t nr_mfns;
> +    uint32_t add_mapping;        /* 1 == add mapping;  0 == unmap */
> +
> +};
> +
>  /*
>   * Notify that some PIRQ-bound event channels have been unmasked.
>   * ** This command is obsolete since interface version 0x00030202 and is **
> -- 
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
