Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab2JHMK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 08:10:27 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:64346 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2JHMKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:10:24 -0400
X-IronPort-AV: E=Sophos;i="4.80,553,1344211200"; 
   d="scan'208";a="15000035"
Date: Mon, 8 Oct 2012 13:09:18 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86: get early page table from BRK
In-Reply-To: <1349509469-11475-2-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.02.1210081259140.29539@kaball.uk.xensource.com>
References: <CAE9FiQV_xVsHN_+6ui_Vgnn6tk8UBOEKL+0XnoEN9VLw3gcOXA@mail.gmail.com> <1349509469-11475-1-git-send-email-yinghai@kernel.org> <1349509469-11475-2-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Oct 2012, Yinghai Lu wrote:
> set pgt_buf early from BRK, and use it to map page table at first.
> 
> also use the left at first, then use new extend one.
> 
> -v2: extra xen call back for that new range.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/include/asm/init.h    |    4 ++++
>  arch/x86/include/asm/pgtable.h |    1 +
>  arch/x86/kernel/setup.c        |    2 ++
>  arch/x86/mm/init.c             |   25 +++++++++++++++++++++++++
>  arch/x86/mm/init_32.c          |    8 ++++++--
>  arch/x86/mm/init_64.c          |    8 ++++++--
>  6 files changed, 44 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
> index 4f13998..2f32eea 100644
> --- a/arch/x86/include/asm/init.h
> +++ b/arch/x86/include/asm/init.h
> @@ -16,4 +16,8 @@ extern unsigned long __initdata pgt_buf_start;
>  extern unsigned long __meminitdata pgt_buf_end;
>  extern unsigned long __meminitdata pgt_buf_top;
>  
> +extern unsigned long __initdata early_pgt_buf_start;
> +extern unsigned long __meminitdata early_pgt_buf_end;
> +extern unsigned long __meminitdata early_pgt_buf_top;
> +
>  #endif /* _ASM_X86_INIT_32_H */
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
> index cf662ba..c32eed1 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -21,6 +21,10 @@ unsigned long __initdata pgt_buf_start;
>  unsigned long __meminitdata pgt_buf_end;
>  unsigned long __meminitdata pgt_buf_top;
>  
> +unsigned long __initdata early_pgt_buf_start;
> +unsigned long __meminitdata early_pgt_buf_end;
> +unsigned long __meminitdata early_pgt_buf_top;
> +
>  int after_bootmem;
>  
>  int direct_gbpages
> @@ -291,6 +295,11 @@ static void __init find_early_table_space(unsigned long start,
>  	if (!base)
>  		panic("Cannot find space for the kernel page tables");
>  
> +	init_memory_mapping(base, base + tables);
> +	printk(KERN_DEBUG "kernel direct mapping tables from %#llx to %#llx @ [mem %#010lx-%#010lx]\n",
> +		base, base + tables - 1, early_pgt_buf_start << PAGE_SHIFT,
> +		(early_pgt_buf_end << PAGE_SHIFT) - 1);
> +
>  	pgt_buf_start = base >> PAGE_SHIFT;
>  	pgt_buf_end = pgt_buf_start;
>  	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
> @@ -430,6 +439,8 @@ void __init init_mem_mapping(void)
>  		x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
>  				PFN_PHYS(pgt_buf_end));
>  	}
> +	x86_init.mapping.pagetable_reserve(PFN_PHYS(early_pgt_buf_start),
> +					PFN_PHYS(early_pgt_buf_end));

pagetable_reserve is not the right hook: pagetable_reserve tells the
subsystem that the memory range you are passing is going to be used for
pagetable pages. It is used to reserve that range using
memblock_reserve. On Xen is also used to mark RW any pages _outside_
that range that have been marked RO: implicitely we assume that the full
range is pgt_buf_start-pgt_buf_top and we mark it RO (see Xen memory
contraints on pagetable pages, as decribed by Konrad).

Calling pagetable_reserve(real_start, real_end) reserves
real_start-real_end as pagetable pages and frees
pgt_buf_start-real_start and real_end-pgt_buf_top.

So the problem is that at the moment we don't have a hook to say: "the
range of pagetable pages is pgt_buf_start-pgt_buf_top". In fact if you
give a look at arch/x86/xen/mmu.c you'll find few references to
pgt_buf_start, pgt_buf_end, pgt_buf_top, that shouldn't really be there.
