Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab2JVP3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:29:36 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56868 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab2JVP3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:29:35 -0400
Date: Mon, 22 Oct 2012 11:17:23 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/19] x86, mm: Add alloc_low_pages(num)
Message-ID: <20121022151722.GF22780@phenom.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
 <1350593430-24470-16-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350593430-24470-16-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 01:50:23PM -0700, Yinghai Lu wrote:
> 32bit kmap mapping need page table to be used for low to high.
                                    ^-s

> 
> At this point those page table are still from pgt_buf_* from BRK,
                                ^s

> So it is ok now.
> But we want to move early_ioremap_page_table_range_init() out of
> init_memory_mapping() and only call it one time later, that will
> make page_table_range_init/page_table_kmap_check/alloc_low_page to
> use memblock to get page.
> 
> memblock allocation for page table are from high to low.
                                    ^s
> 
> So will get panic from page_table_kmap_check() that has BUG_ON to do
> ordering checking.
> 
> This patch add alloc_low_pages to make it possible to alloc serveral pages
> at first, and hand out pages one by one from low to high.

.. But for right now this patch just makes it by default one.

Right?

> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/mm/init.c        |   33 +++++++++++++++++++++------------
>  arch/x86/mm/mm_internal.h |    6 +++++-
>  2 files changed, 26 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index dd09d20..de71c0d 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -25,36 +25,45 @@ unsigned long __meminitdata pgt_buf_top;
>  
>  static unsigned long min_pfn_mapped;
>  
> -__ref void *alloc_low_page(void)
> +__ref void *alloc_low_pages(unsigned int num)
>  {
>  	unsigned long pfn;
> -	void *adr;
> +	int i;
>  
>  #ifdef CONFIG_X86_64
>  	if (after_bootmem) {
> -		adr = (void *)get_zeroed_page(GFP_ATOMIC | __GFP_NOTRACK);
> +		unsigned int order;
>  
> -		return adr;
> +		order = get_order((unsigned long)num << PAGE_SHIFT);
> +		return (void *)__get_free_pages(GFP_ATOMIC | __GFP_NOTRACK |
> +						__GFP_ZERO, order);
>  	}
>  #endif
>  
> -	if ((pgt_buf_end + 1) >= pgt_buf_top) {
> +	if ((pgt_buf_end + num) >= pgt_buf_top) {
>  		unsigned long ret;
>  		if (min_pfn_mapped >= max_pfn_mapped)
>  			panic("alloc_low_page: ran out of memory");
>  		ret = memblock_find_in_range(min_pfn_mapped << PAGE_SHIFT,
>  					max_pfn_mapped << PAGE_SHIFT,
> -					PAGE_SIZE, PAGE_SIZE);
> +					PAGE_SIZE * num , PAGE_SIZE);
>  		if (!ret)
>  			panic("alloc_low_page: can not alloc memory");
> -		memblock_reserve(ret, PAGE_SIZE);
> +		memblock_reserve(ret, PAGE_SIZE * num);
>  		pfn = ret >> PAGE_SHIFT;
> -	} else
> -		pfn = pgt_buf_end++;
> +	} else {
> +		pfn = pgt_buf_end;
> +		pgt_buf_end += num;
> +	}
> +
> +	for (i = 0; i < num; i++) {
> +		void *adr;
> +
> +		adr = __va((pfn + i) << PAGE_SHIFT);
> +		clear_page(adr);
> +	}
>  
> -	adr = __va(pfn * PAGE_SIZE);
> -	clear_page(adr);
> -	return adr;
> +	return __va(pfn << PAGE_SHIFT);
>  }
>  
>  /* need 4 4k for initial PMD_SIZE, 4k for 0-ISA_END_ADDRESS */
> diff --git a/arch/x86/mm/mm_internal.h b/arch/x86/mm/mm_internal.h
> index b3f993a..7e3b88e 100644
> --- a/arch/x86/mm/mm_internal.h
> +++ b/arch/x86/mm/mm_internal.h
> @@ -1,6 +1,10 @@
>  #ifndef __X86_MM_INTERNAL_H
>  #define __X86_MM_INTERNAL_H
>  
> -void *alloc_low_page(void);
> +void *alloc_low_pages(unsigned int num);
> +static inline void *alloc_low_page(void)
> +{
> +	return alloc_low_pages(1);
> +}
>  
>  #endif	/* __X86_MM_INTERNAL_H */
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
