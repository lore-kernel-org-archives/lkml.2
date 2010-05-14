Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab0ENCiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:38:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:55299 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169Ab0ENCiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:38:16 -0400
Subject: Re: [PATCH 24/35] lmb: Move __alloc_memory_core_early() to
 nobootmem.c
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1273796396-29649-25-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-25-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 12:36:24 +1000
Message-ID: <1273804584.21352.404.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 17:19 -0700, Yinghai Lu wrote:
> We can remove #ifdef in mm/page_alloc.c
> 
> and change that function to static

Don't forget that nid allocation using your early_node_map[] will not
work properly on sparc due to the scattered nature of page locality.

Cheers,
Ben.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  include/linux/mm.h |    2 --
>  mm/nobootmem.c     |   21 +++++++++++++++++++++
>  mm/page_alloc.c    |   24 ------------------------
>  3 files changed, 21 insertions(+), 26 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 7774e1d..2a14361 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1161,8 +1161,6 @@ int add_from_early_node_map(struct range *range, int az,
>  				   int nr_range, int nid);
>  u64 __init find_memory_core_early(int nid, u64 size, u64 align,
>  					u64 goal, u64 limit);
> -void *__alloc_memory_core_early(int nodeid, u64 size, u64 align,
> -				 u64 goal, u64 limit);
>  typedef int (*work_fn_t)(unsigned long, unsigned long, void *);
>  extern void work_with_active_regions(int nid, work_fn_t work_fn, void *data);
>  extern void sparse_memory_present_with_active_regions(int nid);
> diff --git a/mm/nobootmem.c b/mm/nobootmem.c
> index abaec96..e3cbde7 100644
> --- a/mm/nobootmem.c
> +++ b/mm/nobootmem.c
> @@ -40,6 +40,27 @@ unsigned long max_pfn;
>  unsigned long saved_max_pfn;
>  #endif
>  
> +static void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
> +					u64 goal, u64 limit)
> +{
> +	void *ptr;
> +
> +	u64 addr;
> +
> +	if (limit > lmb.current_limit)
> +		limit = lmb.current_limit;
> +
> +	addr = find_memory_core_early(nid, size, align, goal, limit);
> +
> +	if (addr == LMB_ERROR)
> +		return NULL;
> +
> +	ptr = phys_to_virt(addr);
> +	memset(ptr, 0, size);
> +	lmb_reserve_area(addr, addr + size, "BOOTMEM");
> +	return ptr;
> +}
> +
>  /*
>   * free_bootmem_late - free bootmem pages directly to page allocator
>   * @addr: starting address of the range
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 867a3a8..3449811 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3437,30 +3437,6 @@ int __init add_from_early_node_map(struct range *range, int az,
>  	return nr_range;
>  }
>  
> -#ifdef CONFIG_NO_BOOTMEM
> -void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
> -					u64 goal, u64 limit)
> -{
> -	void *ptr;
> -
> -	u64 addr;
> -
> -	if (limit > lmb.current_limit)
> -		limit = lmb.current_limit;
> -
> -	addr = find_memory_core_early(nid, size, align, goal, limit);
> -
> -	if (addr == LMB_ERROR)
> -		return NULL;
> -
> -	ptr = phys_to_virt(addr);
> -	memset(ptr, 0, size);
> -	lmb_reserve_area(addr, addr + size, "BOOTMEM");
> -	return ptr;
> -}
> -#endif
> -
> -
>  void __init work_with_active_regions(int nid, work_fn_t work_fn, void *data)
>  {
>  	int i;


