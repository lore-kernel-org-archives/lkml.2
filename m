Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab2JVPYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:24:04 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33589 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2JVPYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:24:02 -0400
Date: Mon, 22 Oct 2012 11:11:50 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/19] x86, mm: Merge alloc_low_page between 64bit and
 32bit
Message-ID: <20121022151149.GD22780@phenom.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
 <1350593430-24470-13-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350593430-24470-13-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 01:50:20PM -0700, Yinghai Lu wrote:
> They are almost same except 64 bit need to handle after_bootmem.
                                                                 ^^ -
case.

> 
> Add mm_internal.h to hide that alloc_low_page out of arch/x86/mm/init*.c

Huh?

I think what you are saying is that you want to expose alloc_low_page
decleration in a header since the function resides in mm/init_[32|64].c ?


> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/mm/init.c        |   34 ++++++++++++++++++++++++++++++++++
>  arch/x86/mm/init_32.c     |   26 ++------------------------
>  arch/x86/mm/init_64.c     |   32 ++------------------------------
>  arch/x86/mm/mm_internal.h |    6 ++++++
>  4 files changed, 44 insertions(+), 54 deletions(-)
>  create mode 100644 arch/x86/mm/mm_internal.h
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 9ff29c1..c398b2c 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -17,10 +17,44 @@
>  #include <asm/proto.h>
>  #include <asm/dma.h>		/* for MAX_DMA_PFN */
>  
> +#include "mm_internal.h"
> +
>  unsigned long __initdata pgt_buf_start;
>  unsigned long __meminitdata pgt_buf_end;
>  unsigned long __meminitdata pgt_buf_top;
>  
> +__ref void *alloc_low_page(void)
> +{
> +	unsigned long pfn;
> +	void *adr;
> +
> +#ifdef CONFIG_X86_64
> +	if (after_bootmem) {
> +		adr = (void *)get_zeroed_page(GFP_ATOMIC | __GFP_NOTRACK);
> +
> +		return adr;
> +	}
> +#endif
> +
> +	if ((pgt_buf_end + 1) >= pgt_buf_top) {
> +		unsigned long ret;
> +		if (min_pfn_mapped >= max_pfn_mapped)
> +			panic("alloc_low_page: ran out of memory");
> +		ret = memblock_find_in_range(min_pfn_mapped << PAGE_SHIFT,
> +					max_pfn_mapped << PAGE_SHIFT,
> +					PAGE_SIZE, PAGE_SIZE);
> +		if (!ret)
> +			panic("alloc_low_page: can not alloc memory");
> +		memblock_reserve(ret, PAGE_SIZE);
> +		pfn = ret >> PAGE_SHIFT;
> +	} else
> +		pfn = pgt_buf_end++;
> +
> +	adr = __va(pfn * PAGE_SIZE);
> +	clear_page(adr);
> +	return adr;
> +}
> +
>  /* need 4 4k for initial PMD_SIZE, 4k for 0-ISA_END_ADDRESS */
>  #define INIT_PGT_BUF_SIZE	(5 * PAGE_SIZE)
>  RESERVE_BRK(early_pgt_alloc, INIT_PGT_BUF_SIZE);
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 7bb1106..a7f2df1 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -53,36 +53,14 @@
>  #include <asm/page_types.h>
>  #include <asm/init.h>
>  
> +#include "mm_internal.h"
> +
>  unsigned long highstart_pfn, highend_pfn;
>  
>  static noinline int do_test_wp_bit(void);
>  
>  bool __read_mostly __vmalloc_start_set = false;
>  
> -static __init void *alloc_low_page(void)
> -{
> -	unsigned long pfn;
> -	void *adr;
> -
> -	if ((pgt_buf_end + 1) >= pgt_buf_top) {
> -		unsigned long ret;
> -		if (min_pfn_mapped >= max_pfn_mapped)
> -			panic("alloc_low_page: ran out of memory");
> -		ret = memblock_find_in_range(min_pfn_mapped << PAGE_SHIFT,
> -					max_pfn_mapped << PAGE_SHIFT,
> -					PAGE_SIZE, PAGE_SIZE);
> -		if (!ret)
> -			panic("alloc_low_page: can not alloc memory");
> -		memblock_reserve(ret, PAGE_SIZE);
> -		pfn = ret >> PAGE_SHIFT;
> -	} else
> -		pfn = pgt_buf_end++;
> -
> -	adr = __va(pfn * PAGE_SIZE);
> -	clear_page(adr);
> -	return adr;
> -}
> -
>  /*
>   * Creates a middle page table and puts a pointer to it in the
>   * given global directory entry. This only returns the gd entry
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index cbf8dbe..aabe8ff 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -54,6 +54,8 @@
>  #include <asm/uv/uv.h>
>  #include <asm/setup.h>
>  
> +#include "mm_internal.h"
> +
>  static int __init parse_direct_gbpages_off(char *arg)
>  {
>  	direct_gbpages = 0;
> @@ -314,36 +316,6 @@ void __init cleanup_highmap(void)
>  	}
>  }
>  
> -static __ref void *alloc_low_page(void)
> -{
> -	unsigned long pfn;
> -	void *adr;
> -
> -	if (after_bootmem) {
> -		adr = (void *)get_zeroed_page(GFP_ATOMIC | __GFP_NOTRACK);
> -
> -		return adr;
> -	}
> -
> -	if ((pgt_buf_end + 1) >= pgt_buf_top) {
> -		unsigned long ret;
> -		if (min_pfn_mapped >= max_pfn_mapped)
> -			panic("alloc_low_page: ran out of memory");
> -		ret = memblock_find_in_range(min_pfn_mapped << PAGE_SHIFT,
> -					max_pfn_mapped << PAGE_SHIFT,
> -					PAGE_SIZE, PAGE_SIZE);
> -		if (!ret)
> -			panic("alloc_low_page: can not alloc memory");
> -		memblock_reserve(ret, PAGE_SIZE);
> -		pfn = ret >> PAGE_SHIFT;
> -	} else
> -		pfn = pgt_buf_end++;
> -
> -	adr = __va(pfn * PAGE_SIZE);
> -	clear_page(adr);
> -	return adr;
> -}
> -
>  static unsigned long __meminit
>  phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
>  	      pgprot_t prot)
> diff --git a/arch/x86/mm/mm_internal.h b/arch/x86/mm/mm_internal.h
> new file mode 100644
> index 0000000..b3f993a
> --- /dev/null
> +++ b/arch/x86/mm/mm_internal.h
> @@ -0,0 +1,6 @@
> +#ifndef __X86_MM_INTERNAL_H
> +#define __X86_MM_INTERNAL_H
> +
> +void *alloc_low_page(void);
> +
> +#endif	/* __X86_MM_INTERNAL_H */
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
