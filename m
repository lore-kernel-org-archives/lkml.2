Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab0EJGiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 02:38:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:46438 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612Ab0EJGiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 02:38:09 -0400
Subject: Re: [PATCH 14/22] lmb: Add lmb_memory_size()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1273331860-14325-15-git-send-email-yinghai@kernel.org>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
	 <1273331860-14325-15-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 16:25:26 +1000
Message-ID: <1273472726.23699.40.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-08 at 08:17 -0700, Yinghai Lu wrote:
> It will return memory size in specified range according to lmb.memory.region
> 
> Try to share some code with lmb_free_memory_size() by passing get_free to
> __lmb_memory_size().

Similar comment about name and purpose.

Cheers,
Ben.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  include/linux/lmb.h |    1 +
>  mm/lmb.c            |   18 +++++++++++++++++-
>  2 files changed, 18 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/lmb.h b/include/linux/lmb.h
> index 22be96d..90022c1 100644
> --- a/include/linux/lmb.h
> +++ b/include/linux/lmb.h
> @@ -102,6 +102,7 @@ void lmb_register_active_regions(int nid, unsigned long start_pfn,
>  					 unsigned long last_pfn);
>  u64 lmb_hole_size(u64 start, u64 end);
>  u64 lmb_free_memory_size(u64 addr, u64 limit);
> +u64 lmb_memory_size(u64 addr, u64 limit);
>  
>  #include <asm/lmb.h>
>  
> diff --git a/mm/lmb.c b/mm/lmb.c
> index 4bc125c..2870dd9 100644
> --- a/mm/lmb.c
> +++ b/mm/lmb.c
> @@ -746,7 +746,7 @@ void __init lmb_to_bootmem(u64 start, u64 end)
>  }
>  #endif
>  
> -u64 __init lmb_free_memory_size(u64 addr, u64 limit)
> +static u64 __init __lmb_memory_size(u64 addr, u64 limit, bool get_free)
>  {
>  	int i, count;
>  	struct range *range;
> @@ -776,6 +776,10 @@ u64 __init lmb_free_memory_size(u64 addr, u64 limit)
>  	}
>  	subtract_range(range, count, 0, addr);
>  	subtract_range(range, count, limit, -1ULL);
> +
> +	/* Subtract lmb.reserved.region in range ? */
> +	if (!get_free)
> +		goto sort_and_count_them;
>  	for (i = 0; i < lmb.reserved.cnt; i++) {
>  		struct lmb_property *r = &lmb.reserved.region[i];
>  
> @@ -788,6 +792,8 @@ u64 __init lmb_free_memory_size(u64 addr, u64 limit)
>  
>  		subtract_range(range, count, final_start, final_end);
>  	}
> +
> +sort_and_count_them:
>  	nr_range = clean_sort_range(range, count);
>  
>  	free_size = 0;
> @@ -797,6 +803,16 @@ u64 __init lmb_free_memory_size(u64 addr, u64 limit)
>  	return free_size << PAGE_SHIFT;
>  }
>  
> +u64 __init lmb_free_memory_size(u64 addr, u64 limit)
> +{
> +	return __lmb_memory_size(addr, limit, true);
> +}
> +
> +u64 __init lmb_memory_size(u64 addr, u64 limit)
> +{
> +	return __lmb_memory_size(addr, limit, false);
> +}
> +
>  u64 __init __weak __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
>  				 u64 size, u64 align)
>  {


