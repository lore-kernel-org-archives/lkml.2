Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744Ab2HQSHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 14:07:52 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:61087 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758697Ab2HQSHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 14:07:47 -0400
X-IronPort-AV: E=Sophos;i="4.77,785,1336348800"; 
   d="scan'208";a="14065042"
Date: Fri, 17 Aug 2012 19:07:28 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 07/11] xen/mmu: Recycle the Xen provided L4,
 L3, and L2 pages
In-Reply-To: <1345133009-21941-8-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1208171902320.15568@kaball.uk.xensource.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com> <1345133009-21941-8-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2012, Konrad Rzeszutek Wilk wrote:
> As we are not using them. We end up only using the L1 pagetables
> and grafting those to our page-tables.
> 
> [v1: Per Stefano's suggestion squashed two commits]
> [v2: Per Stefano's suggestion simplified loop]
> [v3: Fix smatch warnings]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/mmu.c |   40 +++++++++++++++++++++++++++++++++-------
>  1 files changed, 33 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index a59070b..bd92c82 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1708,7 +1708,20 @@ static void convert_pfn_mfn(void *v)
>  	for (i = 0; i < PTRS_PER_PTE; i++)
>  		pte[i] = xen_make_pte(pte[i].pte);
>  }
> -
> +static void __init check_pt_base(unsigned long *pt_base, unsigned long *pt_end,
> +				 unsigned long addr)
> +{
> +	if (*pt_base == PFN_DOWN(__pa(addr))) {
> +		set_page_prot((void *)addr, PAGE_KERNEL);
> +		clear_page((void *)addr);
> +		(*pt_base)++;
> +	}
> +	if (*pt_end == PFN_DOWN(__pa(addr))) {
> +		set_page_prot((void *)addr, PAGE_KERNEL);
> +		clear_page((void *)addr);
> +		(*pt_end)--;
> +	}
> +}
>  /*
>   * Set up the initial kernel pagetable.
>   *
> @@ -1724,6 +1737,9 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
>  {
>  	pud_t *l3;
>  	pmd_t *l2;
> +	unsigned long addr[3];
> +	unsigned long pt_base, pt_end;
> +	unsigned i;
>  
>  	/* max_pfn_mapped is the last pfn mapped in the initial memory
>  	 * mappings. Considering that on Xen after the kernel mappings we
> @@ -1731,6 +1747,9 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
>  	 * set max_pfn_mapped to the last real pfn mapped. */
>  	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->mfn_list));
>  
> +	pt_base = PFN_DOWN(__pa(xen_start_info->pt_base));
> +	pt_end = PFN_DOWN(__pa(xen_start_info->pt_base + (xen_start_info->nr_pt_frames * PAGE_SIZE)));

code style

>  	/* Zap identity mapping */
>  	init_level4_pgt[0] = __pgd(0);
>  
> @@ -1749,6 +1768,9 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
>  	l3 = m2v(pgd[pgd_index(__START_KERNEL_map)].pgd);
>  	l2 = m2v(l3[pud_index(__START_KERNEL_map)].pud);
>  
> +	addr[0] = (unsigned long)pgd;
> +	addr[1] = (unsigned long)l3;
> +	addr[2] = (unsigned long)l2;
>  	/* Graft it onto L4[272][0]. Note that we creating an aliasing problem:
>  	 * Both L4[272][0] and L4[511][511] have entries that point to the same
>  	 * L2 (PMD) tables. Meaning that if you modify it in __va space
> @@ -1782,20 +1804,24 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
>  	/* Unpin Xen-provided one */
>  	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
>  
> -	/* Switch over */
> -	pgd = init_level4_pgt;
> -
>  	/*
>  	 * At this stage there can be no user pgd, and no page
>  	 * structure to attach it to, so make sure we just set kernel
>  	 * pgd.
>  	 */
>  	xen_mc_batch();
> -	__xen_write_cr3(true, __pa(pgd));
> +	__xen_write_cr3(true, __pa(init_level4_pgt));
>  	xen_mc_issue(PARAVIRT_LAZY_CPU);
>  
> -	memblock_reserve(__pa(xen_start_info->pt_base),
> -			 xen_start_info->nr_pt_frames * PAGE_SIZE);
> +	/* We can't that easily rip out L3 and L2, as the Xen pagetables are
> +	 * set out this way: [L4], [L1], [L2], [L3], [L1], [L1] ...  for
> +	 * the initial domain. For guests using the toolstack, they are in:
> +	 * [L4], [L3], [L2], [L1], [L1], order .. */
> +	for (i = 0; i < ARRAY_SIZE(addr); i++)
> +		check_pt_base(&pt_base, &pt_end, addr[i]);

It is much clearer now, but if the comment is correct, doesn't it mean
that we are going to be able to free pgd, l3 and l2 only in the non-dom0
case?
If so it might be worth saying it explicitly.

Other than that, it is fine by me.


> +	/* Our (by three pages) smaller Xen pagetable that we are using */
> +	memblock_reserve(PFN_PHYS(pt_base), (pt_end - pt_base) * PAGE_SIZE);
>  }
>  #else	/* !CONFIG_X86_64 */
>  static RESERVE_BRK_ARRAY(pmd_t, initial_kernel_pmd, PTRS_PER_PMD);
> -- 
> 1.7.7.6
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
> 
