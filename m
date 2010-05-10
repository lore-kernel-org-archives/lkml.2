Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab0EJGiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 02:38:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:46453 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322Ab0EJGiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 02:38:21 -0400
Subject: Re: [PATCH 13/22] lmb: Add lmb_free_memory_size()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1273331860-14325-14-git-send-email-yinghai@kernel.org>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
	 <1273331860-14325-14-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 16:24:46 +1000
Message-ID: <1273472686.23699.39.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-08 at 08:17 -0700, Yinghai Lu wrote:
> It will return free memory size in specified range.
> 
> We can not use memory_size - reserved_size here, because some reserved area
> may not be in the scope of lmb.memory.region.
> 
> Use lmb.memory.region subtracting lmb.reserved.region to get free range array.
> then count size of all free ranges.

The name sucks. Something like lmb_free_memory_in_range() would be
better, but why do you need that in the first place ? You often tend to
fail to explain why you introduce a given function, it's not always
obvious and in many case I suspect they are added layers that aren't
actually useful.

Cheers,
Ben.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  include/linux/lmb.h |    1 +
>  mm/lmb.c            |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 52 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/lmb.h b/include/linux/lmb.h
> index c75d0c9..22be96d 100644
> --- a/include/linux/lmb.h
> +++ b/include/linux/lmb.h
> @@ -101,6 +101,7 @@ int get_free_all_memory_range(struct range **rangep, int nodeid);
>  void lmb_register_active_regions(int nid, unsigned long start_pfn,
>  					 unsigned long last_pfn);
>  u64 lmb_hole_size(u64 start, u64 end);
> +u64 lmb_free_memory_size(u64 addr, u64 limit);
>  
>  #include <asm/lmb.h>
>  
> diff --git a/mm/lmb.c b/mm/lmb.c
> index 36b3f63..4bc125c 100644
> --- a/mm/lmb.c
> +++ b/mm/lmb.c
> @@ -746,6 +746,57 @@ void __init lmb_to_bootmem(u64 start, u64 end)
>  }
>  #endif
>  
> +u64 __init lmb_free_memory_size(u64 addr, u64 limit)
> +{
> +	int i, count;
> +	struct range *range;
> +	int nr_range;
> +	u64 final_start, final_end;
> +	u64 free_size;
> +
> +	count = lmb.reserved.cnt * 2;
> +
> +	range = find_range_array(count);
> +	nr_range = 0;
> +
> +	addr = PFN_UP(addr);
> +	limit = PFN_DOWN(limit);
> +
> +	for (i = 0; i < lmb.memory.cnt; i++) {
> +		struct lmb_property *r = &lmb.memory.region[i];
> +
> +		final_start = PFN_UP(r->base);
> +		final_end = PFN_DOWN(r->base + r->size);
> +		if (final_start >= final_end)
> +			continue;
> +		if (final_start >= limit || final_end <= addr)
> +			continue;
> +
> +		nr_range = add_range(range, count, nr_range, final_start, final_end);
> +	}
> +	subtract_range(range, count, 0, addr);
> +	subtract_range(range, count, limit, -1ULL);
> +	for (i = 0; i < lmb.reserved.cnt; i++) {
> +		struct lmb_property *r = &lmb.reserved.region[i];
> +
> +		final_start = PFN_DOWN(r->base);
> +		final_end = PFN_UP(r->base + r->size);
> +		if (final_start >= final_end)
> +			continue;
> +		if (final_start >= limit || final_end <= addr)
> +			continue;
> +
> +		subtract_range(range, count, final_start, final_end);
> +	}
> +	nr_range = clean_sort_range(range, count);
> +
> +	free_size = 0;
> +	for (i = 0; i < nr_range; i++)
> +		free_size += range[i].end - range[i].start;
> +
> +	return free_size << PAGE_SHIFT;
> +}
> +
>  u64 __init __weak __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
>  				 u64 size, u64 align)
>  {


