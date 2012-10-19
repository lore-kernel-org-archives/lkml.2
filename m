Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab2JSNTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:19:50 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40643 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2JSNTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:19:49 -0400
Date: Fri, 19 Oct 2012 09:07:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 1/6]: PVH: basic and header changes, elfnote changes,
 ...
Message-ID: <20121019130739.GF26830@phenom.dumpdata.com>
References: <20121017172642.349b2aae@mantra.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121017172642.349b2aae@mantra.us.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 05:26:42PM -0700, Mukesh Rathor wrote:
> [PATCH 1/6] PVH: is a PV linux guest that has extended capabilities. This patch allows it to be configured and enabled. Also, basic header file changes to add new subcalls to physmap hypercall. Lastly, mfn_to_local_pfn must return mfn for paging mode translate.

Usually one splits that description. So you have:

(for title)
"xen/pvh: Introduce ParaVirtualized Hardware support."

And then in the body do (and split it in 80 lines for
easier readability):

ParaVirtualized Hardware (PVH) support allows a PV linux guest that has extended capabilities.

[Q:Like what kind of extended capabilities? Can you explain
what they are?]

This patch allows it to be configured and enabled. Also, basic header file changes to
add new subcalls to physmap hypercall. 

Lastly, mfn_to_local_pfn must return mfn for paging mode translate.

[Q: You should explain why. There is nothing in this description
saying why we do not need the PV MMU anymore]

[note: the verb tense is wrong since I meshed your description
with mine, so it would have to be fixed]
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
> diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
> index 9ce788d..3b9d5b6 100644
> --- a/include/xen/interface/physdev.h
> +++ b/include/xen/interface/physdev.h
> @@ -258,6 +258,16 @@ struct physdev_pci_device {
>      uint8_t devfn;
>  };
>  
> +#define PHYSDEVOP_pvh_map_iomem        30
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
