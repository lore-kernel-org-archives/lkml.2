Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab0ENCcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:32:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:35418 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169Ab0ENCb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:31:59 -0400
Subject: Re: [PATCH 11/35] lmb: Add find_memory_core_early()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1273796396-29649-12-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-12-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 12:30:38 +1000
Message-ID: <1273804238.21352.389.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 17:19 -0700, Yinghai Lu wrote:
> According to node range in early_node_map[] with __lmb_find_area
> to find free range.
> 
> Will be used by lmb_find_area_node()
> 
> lmb_find_area_node will be used to find right buffer for NODE_DATA
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---

Oh and this wont' work on sparc. You should probably instead add a
lmb_find_in_nid() to lmb which shares code with lmb_alloc_nid().

However, why do you wnat to do this find + separate reserve again ? Why
not lmb_alloc ?

Cheers,
Ben.

>  include/linux/mm.h |    2 ++
>  mm/page_alloc.c    |   29 +++++++++++++++++++++++++++++
>  2 files changed, 31 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index fb19bb9..7774e1d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1159,6 +1159,8 @@ extern void free_bootmem_with_active_regions(int nid,
>  						unsigned long max_low_pfn);
>  int add_from_early_node_map(struct range *range, int az,
>  				   int nr_range, int nid);
> +u64 __init find_memory_core_early(int nid, u64 size, u64 align,
> +					u64 goal, u64 limit);
>  void *__alloc_memory_core_early(int nodeid, u64 size, u64 align,
>  				 u64 goal, u64 limit);
>  typedef int (*work_fn_t)(unsigned long, unsigned long, void *);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d03c946..72afd94 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -21,6 +21,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/jiffies.h>
>  #include <linux/bootmem.h>
> +#include <linux/lmb.h>
>  #include <linux/compiler.h>
>  #include <linux/kernel.h>
>  #include <linux/kmemcheck.h>
> @@ -3393,6 +3394,34 @@ void __init free_bootmem_with_active_regions(int nid,
>  	}
>  }
>  
> +#ifdef CONFIG_HAVE_LMB
> +u64 __init find_memory_core_early(int nid, u64 size, u64 align,
> +					u64 goal, u64 limit)
> +{
> +	int i;
> +
> +	/* Need to go over early_node_map to find out good range for node */
> +	for_each_active_range_index_in_nid(i, nid) {
> +		u64 addr;
> +		u64 ei_start, ei_last;
> +
> +		ei_last = early_node_map[i].end_pfn;
> +		ei_last <<= PAGE_SHIFT;
> +		ei_start = early_node_map[i].start_pfn;
> +		ei_start <<= PAGE_SHIFT;
> +		addr = __lmb_find_area(ei_start, ei_last,
> +					 goal, limit, size, align);
> +
> +		if (addr == LMB_ERROR)
> +			continue;
> +
> +		return addr;
> +	}
> +
> +	return -1ULL;
> +}
> +#endif
> +
>  int __init add_from_early_node_map(struct range *range, int az,
>  				   int nr_range, int nid)
>  {


