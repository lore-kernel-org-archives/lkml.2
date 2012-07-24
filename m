Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab2GXNd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:33:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:16828 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab2GXNd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:33:57 -0400
Date: Tue, 24 Jul 2012 09:25:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [PATCH 4/5] xen/x86: Use memblock_reserve for
 sensitive areas.
Message-ID: <20120724132502.GA29421@phenom.dumpdata.com>
References: <1343068103-13579-1-git-send-email-konrad.wilk@oracle.com>
 <1343068103-13579-5-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343068103-13579-5-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 02:28:22PM -0400, Konrad Rzeszutek Wilk wrote:
> instead of a big memblock_reserve. This way we can be more
> selective in freeing regions (and it also makes it easier
> to understand where is what).
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/enlighten.c |   36 ++++++++++++++++++++++++++++++++++++
>  arch/x86/xen/p2m.c       |    5 +++++
>  arch/x86/xen/setup.c     |    9 ---------
>  3 files changed, 41 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index ae8a2ab..c986b7f 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -998,7 +998,42 @@ static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
>  
>  	return ret;
>  }
> +static void __init xen_reserve_mfn(unsigned long mfn)
> +{
> +	unsigned long pfn;
>  
> +	if (!mfn)
> +		return;
> +	pfn = mfn_to_pfn(mfn);
> +	if (phys_to_machine_mapping_valid(pfn))
> +		memblock_reserve(PFN_PHYS(pfn), PAGE_SIZE);
> +}
> +static void __init xen_reserve_internals(void)
> +{
> +	unsigned long size;
> +
> +	if (!xen_pv_domain())
> +		return;
> +
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return;

This needs to be redone. On PV guests that do autotranslation the
other areas (xen_start_info for example) are not reserved  - which
is not good.
> +
> +	/* ALIGN up to compensate for the p2m_page pointing to an array that
> +	 * can be partially filled (look in xen_build_dynamic_phys_to_machine).
> +	 */
> +	size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
> +
> +	memblock_reserve(__pa(xen_start_info->mfn_list), size);
> +
> +	memblock_reserve(__pa(xen_start_info), PAGE_SIZE);
> +
> +	xen_reserve_mfn(PFN_DOWN(xen_start_info->shared_info));
> +	xen_reserve_mfn(xen_start_info->store_mfn);
> +
> +	if (!xen_initial_domain())
> +		xen_reserve_mfn(xen_start_info->console.domU.mfn);
> +	/* The pagetables are reserved in mmu.c */
> +}
>  void xen_setup_shared_info(void)
>  {
>  	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
> @@ -1357,6 +1392,7 @@ asmlinkage void __init xen_start_kernel(void)
>  	xen_raw_console_write("mapping kernel into physical memory\n");
>  	xen_setup_kernel_pagetable((pgd_t *)xen_start_info->pt_base, xen_start_info->nr_pages);
>  
> +	xen_reserve_internals();
>  	/* Allocate and initialize top and mid mfn levels for p2m structure */
>  	xen_build_mfn_list_list();
>  
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index e4adbfb..4219f9a 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -388,6 +388,11 @@ void __init xen_build_dynamic_phys_to_machine(void)
>  	}
>  
>  	m2p_override_init();
> +
> +	/* NOTE: We cannot call memblock_reserve here for the mfn_list as there
> +	 * isn't enough pieces to make it work (for one - we are still using the
> +	 * Xen provided pagetable). So we do it a bit later:
> +	 * (xen_reserve_internals).*/
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
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
