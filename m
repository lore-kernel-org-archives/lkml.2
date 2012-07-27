Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab2G0Kt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 06:49:58 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:25996 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab2G0Kt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 06:49:57 -0400
X-IronPort-AV: E=Sophos;i="4.77,666,1336348800"; 
   d="scan'208";a="13732285"
Date: Fri, 27 Jul 2012 11:49:02 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 2/4] xen/x86: Use memblock_reserve for sensitive areas.
In-Reply-To: <1343334845-5340-3-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1207271139140.26163@kaball.uk.xensource.com>
References: <1343334845-5340-1-git-send-email-konrad.wilk@oracle.com> <1343334845-5340-3-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2012, Konrad Rzeszutek Wilk wrote:
> instead of a big memblock_reserve. This way we can be more
> selective in freeing regions (and it also makes it easier
> to understand where is what).
> 
> [v1: Move the auto_translate_physmap to proper line]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/enlighten.c |   38 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/xen/p2m.c       |    5 +++++
>  arch/x86/xen/setup.c     |    9 ---------
>  3 files changed, 43 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index ff962d4..9b1afa4 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -998,7 +998,44 @@ static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
>  
>  	return ret;
>  }
> +static void __init xen_reserve_mfn(unsigned long mfn)
> +{
> +	unsigned long pfn;
> +
> +	if (!mfn)
> +		return;
> +	pfn = mfn_to_pfn(mfn);
> +	if (phys_to_machine_mapping_valid(pfn))
> +		memblock_reserve(PFN_PHYS(pfn), PAGE_SIZE);
> +}

If the mfn is not in the m2p xen_reserve_mfn won't do anything. It is
worth writing it down in a comment.


> +static void __init xen_reserve_internals(void)
> +{
> +	unsigned long size;
> +
> +	if (!xen_pv_domain())
> +		return;
> +
> +	memblock_reserve(__pa(xen_start_info), PAGE_SIZE);

xen_start_info is not in the m2p, so you cannot use xen_reserve_mfn


> +	xen_reserve_mfn(PFN_DOWN(xen_start_info->shared_info));
> +	xen_reserve_mfn(xen_start_info->store_mfn);

Are we sure that shared_info points to an mfn that is in the m2p (rather
than a special mfn not present in the list)?


> +	if (!xen_initial_domain())
> +		xen_reserve_mfn(xen_start_info->console.domU.mfn);
> +
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return;
> +
> +	/*
> +	 * ALIGN up to compensate for the p2m_page pointing to an array that
> +	 * can partially filled (look in xen_build_dynamic_phys_to_machine).
> +	 */
> +
> +	size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
> +	memblock_reserve(__pa(xen_start_info->mfn_list), size);

I take that here you are using memblock_reserve again, rather than
xen_reserve_mfn, because the corresponding mfn is not in the m2p?


> +	/* The pagetables are reserved in mmu.c */
> +}
>  void xen_setup_shared_info(void)
>  {
>  	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
> @@ -1362,6 +1399,7 @@ asmlinkage void __init xen_start_kernel(void)
>  	xen_raw_console_write("mapping kernel into physical memory\n");
>  	pgd = xen_setup_kernel_pagetable(pgd, xen_start_info->nr_pages);
>  
> +	xen_reserve_internals();
>  	/* Allocate and initialize top and mid mfn levels for p2m structure */
>  	xen_build_mfn_list_list();
>  
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index e4adbfb..6a2bfa4 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -388,6 +388,11 @@ void __init xen_build_dynamic_phys_to_machine(void)
>  	}
>  
>  	m2p_override_init();
> +
> +	/* NOTE: We cannot call memblock_reserve here for the mfn_list as there
> +	 * isn't enough pieces to make it work (for one - we are still using the
> +	 * Xen provided pagetable). Do it later in xen_reserve_internals.
> +	 */
>  }
>  
>  unsigned long get_phys_to_machine(unsigned long pfn)
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index a4790bf..9efca75 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -424,15 +424,6 @@ char * __init xen_memory_setup(void)
>  	e820_add_region(ISA_START_ADDRESS, ISA_END_ADDRESS - ISA_START_ADDRESS,
>  			E820_RESERVED);
>  
> -	/*
> -	 * Reserve Xen bits:
> -	 *  - mfn_list
> -	 *  - xen_start_info
> -	 * See comment above "struct start_info" in <xen/interface/xen.h>
> -	 */
> -	memblock_reserve(__pa(xen_start_info->mfn_list),
> -			 xen_start_info->pt_base - xen_start_info->mfn_list);
> -
>  	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
>  
>  	return "Xen";
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
