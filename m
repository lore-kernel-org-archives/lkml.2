Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab2JIQN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:13:26 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38096 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2JIQNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:13:21 -0400
Date: Tue, 9 Oct 2012 12:01:34 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] x86, mm: get early page table from BRK
Message-ID: <20121009160133.GF7639@phenom.dumpdata.com>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
 <1349757558-10856-4-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349757558-10856-4-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 09:39:11PM -0700, Yinghai Lu wrote:
> Get pgt_buf early from BRK, and use it to map page table at first.
> 
> also use the left at first, then use new one.

Left?
> 
> -v2: extra xen call back for that new range.
> -v3: fix compiling about #llx in print out that is reported by Fengguang
> -v4: remove the early_pgt_buf_* stuff, because xen interface is ready yet.
>      still need to run x86_init.mapping.pagetable_reserve separately.
>      so we will waste some pages in BRK, will address that later.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/include/asm/pgtable.h |    1 +
>  arch/x86/kernel/setup.c        |    2 ++
>  arch/x86/mm/init.c             |   26 +++++++++++++++++++++++++-
>  3 files changed, 28 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index 52d40a1..25fa5bb 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -599,6 +599,7 @@ static inline int pgd_none(pgd_t pgd)
>  
>  extern int direct_gbpages;
>  void init_mem_mapping(void);
> +void early_alloc_pgt_buf(void);
>  
>  /* local pte updates need not use xchg for locking */
>  static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 4989f80..7eb6855 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -896,6 +896,8 @@ void __init setup_arch(char **cmdline_p)
>  
>  	reserve_ibft_region();
>  
> +	early_alloc_pgt_buf();
> +
>  	/*
>  	 * Need to conclude brk, before memblock_x86_fill()
>  	 *  it could use memblock_find_in_range, could overlap with
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 0c58f2d..a89f485 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -317,12 +317,22 @@ static void __init find_early_table_space(unsigned long start,
>  					  unsigned long good_end,
>  					  unsigned long tables)
>  {
> -	phys_addr_t base;
> +	unsigned long base;
>  
>  	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
>  	if (!base)
>  		panic("Cannot find space for the kernel page tables");
>  
> +	init_memory_mapping(base, base + tables);
> +	if (pgt_buf_end > pgt_buf_start) {
> +		printk(KERN_DEBUG "kernel direct mapping tables from %#lx to %#lx @ [mem %#010lx-%#010lx]\n",
> +			base, base + tables - 1, pgt_buf_start << PAGE_SHIFT,
> +			(pgt_buf_end << PAGE_SHIFT) - 1);
> +
> +		x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
> +						PFN_PHYS(pgt_buf_end));
> +	}
> +
>  	pgt_buf_start = base >> PAGE_SHIFT;
>  	pgt_buf_end = pgt_buf_start;
>  	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
> @@ -469,6 +479,20 @@ void __init init_mem_mapping(void)
>  	early_memtest(0, max_pfn_mapped << PAGE_SHIFT);
>  }
>  
> +RESERVE_BRK(early_pgt_alloc, 16384);

How did you come up with 16KB being the right size? What is this
based on? Can you provide a comment explaining why 16KB is the
right value on 32-bit and 64-bit machines?
> +
> +void  __init early_alloc_pgt_buf(void)
> +{
> +	unsigned long tables = 16384;
> +	phys_addr_t base;
> +
> +	base = __pa(extend_brk(tables, PAGE_SIZE));
> +
> +	pgt_buf_start = base >> PAGE_SHIFT;
> +	pgt_buf_end = pgt_buf_start;
> +	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
> +}
> +
>  /*
>   * devmem_is_allowed() checks to see if /dev/mem access to a certain address
>   * is valid. The argument is a physical page number.
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
