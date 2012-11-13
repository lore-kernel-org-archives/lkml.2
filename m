Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab2KMQxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:53:33 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:62714 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab2KMQx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:53:29 -0500
X-IronPort-AV: E=Sophos;i="4.80,768,1344211200"; 
   d="scan'208";a="214360207"
Date: Tue, 13 Nov 2012 16:36:54 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 26/46] x86, mm, Xen: Remove mapping_pagetable_reserve()
In-Reply-To: <1352755122-25660-27-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.02.1211131629230.28049@kaball.uk.xensource.com>
References: <20121112193044.GA11615@phenom.dumpdata.com> <1352755122-25660-1-git-send-email-yinghai@kernel.org> <1352755122-25660-27-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012, Yinghai Lu wrote:
> Page table area are pre-mapped now after
> 	x86, mm: setup page table in top-down
> 	x86, mm: Remove early_memremap workaround for page table accessing on 64bit
> 
> mapping_pagetable_reserve is not used anymore, so remove it.

You should mention in the description of the patch that you are
removing mask_rw_pte too.

The reason why you can do that safely is that you previously modified
allow_low_page to always return pages that are already mapped, moreover
xen_alloc_pte_init, xen_alloc_pmd_init, etc, will mark the page RO
before hooking it into the pagetable automatically.

[ ... ]

> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index dcf5f2d..bbb883f 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1178,20 +1178,6 @@ static void xen_exit_mmap(struct mm_struct *mm)
>  
>  static void xen_post_allocator_init(void);
>  
> -static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
> -{
> -	/* reserve the range used */
> -	native_pagetable_reserve(start, end);
> -
> -	/* set as RW the rest */
> -	printk(KERN_DEBUG "xen: setting RW the range %llx - %llx\n", end,
> -			PFN_PHYS(pgt_buf_top));
> -	while (end < PFN_PHYS(pgt_buf_top)) {
> -		make_lowmem_page_readwrite(__va(end));
> -		end += PAGE_SIZE;
> -	}
> -}
> -
>  #ifdef CONFIG_X86_64
>  static void __init xen_cleanhighmap(unsigned long vaddr,
>  				    unsigned long vaddr_end)
> @@ -1503,19 +1489,6 @@ static pte_t __init mask_rw_pte(pte_t *ptep, pte_t pte)
>  #else /* CONFIG_X86_64 */
>  static pte_t __init mask_rw_pte(pte_t *ptep, pte_t pte)
>  {
> -	unsigned long pfn = pte_pfn(pte);
> -
> -	/*
> -	 * If the new pfn is within the range of the newly allocated
> -	 * kernel pagetable, and it isn't being mapped into an
> -	 * early_ioremap fixmap slot as a freshly allocated page, make sure
> -	 * it is RO.
> -	 */
> -	if (((!is_early_ioremap_ptep(ptep) &&
> -			pfn >= pgt_buf_start && pfn < pgt_buf_top)) ||
> -			(is_early_ioremap_ptep(ptep) && pfn != (pgt_buf_end - 1)))
> -		pte = pte_wrprotect(pte);
> -
>  	return pte;

you should just get rid of mask_rw_pte completely
