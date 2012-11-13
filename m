Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab2KMQx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:53:27 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:62714 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab2KMQxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:53:25 -0500
X-IronPort-AV: E=Sophos;i="4.80,768,1344211200"; 
   d="scan'208";a="214360198"
Date: Tue, 13 Nov 2012 16:37:46 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 27/46] x86, mm: Add alloc_low_pages(num)
In-Reply-To: <1352755122-25660-28-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.02.1211131637240.28049@kaball.uk.xensource.com>
References: <20121112193044.GA11615@phenom.dumpdata.com> <1352755122-25660-1-git-send-email-yinghai@kernel.org> <1352755122-25660-28-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012, Yinghai Lu wrote:
> 32bit kmap mapping needs pages to be used for low to high.
> At this point those pages are still from pgt_buf_* from BRK, so it is
> ok now.
> But we want to move early_ioremap_page_table_range_init() out of
> init_memory_mapping() and only call it one time later, that will
> make page_table_range_init/page_table_kmap_check/alloc_low_page to
> use memblock to get page.
> 
> memblock allocation for pages are from high to low.
> So will get panic from page_table_kmap_check() that has BUG_ON to do
> ordering checking.
> 
> This patch add alloc_low_pages to make it possible to allocate serveral
> pages at first, and hand out pages one by one from low to high.
> 
> -v2: add one line comment about xen requirements.

where is it?

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  arch/x86/mm/init.c        |   33 +++++++++++++++++++++------------
>  arch/x86/mm/mm_internal.h |    6 +++++-
>  2 files changed, 26 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 9d51af72..f5e0120 100644
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
