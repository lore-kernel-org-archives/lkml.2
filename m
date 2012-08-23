Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030597Ab2HWP55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:57:57 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:56508 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934087Ab2HWP5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:57:53 -0400
X-IronPort-AV: E=Sophos;i="4.80,300,1344211200"; 
   d="scan'208";a="14151314"
Date: Thu, 23 Aug 2012 16:57:29 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 06/11] xen/mmu: For 64-bit do not call
 xen_map_identity_early
In-Reply-To: <20120823154012.GA18845@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1208231656160.15568@kaball.uk.xensource.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com> <1345133009-21941-7-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1208171839590.15568@kaball.uk.xensource.com> <20120817174549.GA14257@phenom.dumpdata.com>
 <alpine.DEB.2.02.1208201243180.15568@kaball.uk.xensource.com> <1345463624.28762.67.camel@zakaz.uk.xensource.com> <alpine.DEB.2.02.1208201257420.15568@kaball.uk.xensource.com> <20120823154012.GA18845@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2012, Konrad Rzeszutek Wilk wrote:
> >From 43fd7a5d9ecd31c2fc26851523cd4b5f7650fb39 Mon Sep 17 00:00:00 2001
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date: Thu, 12 Jul 2012 13:59:36 -0400
> Subject: [PATCH] xen/mmu: For 64-bit do not call xen_map_identity_early
> 
> B/c we do not need it. During the startup the Xen provides
                                            ^ remove the
> us with all the initial memory mapped that we need to function.
> 
> The initial memory mapped is up to the bootstack, which means
> we can reference using __ka up to 4.f):

Thanks, that is what I was looking for.

> (from xen/interface/xen.h):
> 
>  4. This the order of bootstrap elements in the initial virtual region:
>    a. relocated kernel image
>    b. initial ram disk              [mod_start, mod_len]
>    c. list of allocated page frames [mfn_list, nr_pages]
>    d. start_info_t structure        [register ESI (x86)]
>    e. bootstrap page tables         [pt_base, CR3 (x86)]
>    f. bootstrap stack               [register ESP (x86)]
> 
> (initial ram disk may be ommitted).
> 
> [v1: More comments in git commit]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


> ---
>  arch/x86/xen/mmu.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 7247e5a..a59070b 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -84,6 +84,7 @@
>   */
>  DEFINE_SPINLOCK(xen_reservation_lock);
>  
> +#ifdef CONFIG_X86_32
>  /*
>   * Identity map, in addition to plain kernel map.  This needs to be
>   * large enough to allocate page table pages to allocate the rest.
> @@ -91,7 +92,7 @@ DEFINE_SPINLOCK(xen_reservation_lock);
>   */
>  #define LEVEL1_IDENT_ENTRIES	(PTRS_PER_PTE * 4)
>  static RESERVE_BRK_ARRAY(pte_t, level1_ident_pgt, LEVEL1_IDENT_ENTRIES);
> -
> +#endif
>  #ifdef CONFIG_X86_64
>  /* l3 pud for userspace vsyscall mapping */
>  static pud_t level3_user_vsyscall[PTRS_PER_PUD] __page_aligned_bss;
> @@ -1628,7 +1629,7 @@ static void set_page_prot(void *addr, pgprot_t prot)
>  	if (HYPERVISOR_update_va_mapping((unsigned long)addr, pte, 0))
>  		BUG();
>  }
> -
> +#ifdef CONFIG_X86_32
>  static void __init xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
>  {
>  	unsigned pmdidx, pteidx;
> @@ -1679,7 +1680,7 @@ static void __init xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
>  
>  	set_page_prot(pmd, PAGE_KERNEL_RO);
>  }
> -
> +#endif
>  void __init xen_setup_machphys_mapping(void)
>  {
>  	struct xen_machphys_mapping mapping;
> @@ -1765,14 +1766,12 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
>  	/* Note that we don't do anything with level1_fixmap_pgt which
>  	 * we don't need. */
>  
> -	/* Set up identity map */
> -	xen_map_identity_early(level2_ident_pgt, max_pfn);
> -
>  	/* Make pagetable pieces RO */
>  	set_page_prot(init_level4_pgt, PAGE_KERNEL_RO);
>  	set_page_prot(level3_ident_pgt, PAGE_KERNEL_RO);
>  	set_page_prot(level3_kernel_pgt, PAGE_KERNEL_RO);
>  	set_page_prot(level3_user_vsyscall, PAGE_KERNEL_RO);
> +	set_page_prot(level2_ident_pgt, PAGE_KERNEL_RO);
>  	set_page_prot(level2_kernel_pgt, PAGE_KERNEL_RO);
>  	set_page_prot(level2_fixmap_pgt, PAGE_KERNEL_RO);
>  
> -- 
> 1.7.7.6
> 
