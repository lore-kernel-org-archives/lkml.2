Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab0EJDOm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 23:14:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:33280 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027Ab0EJDOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 23:14:40 -0400
Subject: Re: [PATCH 07/22] lmb: Add lmb_to_bootmem()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1273331860-14325-8-git-send-email-yinghai@kernel.org>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
	 <1273331860-14325-8-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 13:13:13 +1000
Message-ID: <1273461193.23699.9.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-08 at 08:17 -0700, Yinghai Lu wrote:
> lmb_to_bootmem() will reserve lmb.reserved.region in bootmem after bootmem is
> set up.
> 
> We can use it to with all arches that support lmb later.

This is clumsy. Doesn't work with NUMA either. Also,
reserve_bootmem_generic() only exists on x86 afaik.

I also disagree with the clearing of the region, I'd like
to keep the arrays around for debug purposes, especially since
I'm going to expose them in debugfs, but I suppose we can make
that an option. In any case, I don't think it's the right place
to introduce such a "side effect".

In any case, I'm not convinced there's much interrest at this
stage in putting that code in the generic lmb.c, with my patches
this stuff boils down to:

	for_each_lmb(reserved, reg) {
		unsigned long top = reg->base + reg->size - 1;
		if (top < lowmem_end_addr)
			reserve_bootmem(reg->base, reg->size, BOOTMEM_DEFAULT);
		else if (reg->base < lowmem_end_addr) {
			unsigned long trunc_size = lowmem_end_addr - reg->base;
			reserve_bootmem(reg->base, trunc_size, BOOTMEM_DEFAULT);
		}
	}

In the non-numa case, but let's keep that in arch for now. We might be
able to reconcile the NUMA case, I'm looking at that, it's non trivial,
in which case that stuff would become a better candidate for being in
the generic code, but not for now.

Cheers,
Ben.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  include/linux/lmb.h |    2 ++
>  mm/lmb.c            |   32 ++++++++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/lmb.h b/include/linux/lmb.h
> index b1c1b9b..2c008b9 100644
> --- a/include/linux/lmb.h
> +++ b/include/linux/lmb.h
> @@ -92,6 +92,8 @@ u64 __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
>  			 u64 size, u64 align);
>  u64 lmb_find_area(u64 start, u64 end, u64 size, u64 align);
>  
> +void lmb_to_bootmem(u64 start, u64 end);
> +
>  #include <asm/lmb.h>
>  
>  #endif /* __KERNEL__ */
> diff --git a/mm/lmb.c b/mm/lmb.c
> index e3f87d0..ccbc76d 100644
> --- a/mm/lmb.c
> +++ b/mm/lmb.c
> @@ -630,6 +630,38 @@ void __init lmb_free_area(u64 start, u64 end)
>  	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0]);
>  }
>  
> +#ifndef CONFIG_NO_BOOTMEM
> +void __init lmb_to_bootmem(u64 start, u64 end)
> +{
> +	int i, count;
> +	u64 final_start, final_end;
> +
> +	/* Take out region array itself */
> +	if (lmb.reserved.region != lmb_reserved_region)
> +		lmb_free(__pa(lmb.reserved.region), sizeof(struct lmb_property) * lmb.reserved.nr_regions);
> +
> +	count  = lmb.reserved.cnt;
> +	pr_info("(%d early reservations) ==> bootmem [%010llx - %010llx]\n", count, start, end);
> +	for (i = 0; i < count; i++) {
> +		struct lmb_property *r = &lmb.reserved.region[i];
> +		pr_info("  #%d [%010llx - %010llx] ", i, r->base, r->base + r->size);
> +		final_start = max(start, r->base);
> +		final_end = min(end, r->base + r->size);
> +		if (final_start >= final_end) {
> +			pr_cont("\n");
> +			continue;
> +		}
> +		pr_cont(" ==> [%010llx - %010llx]\n", final_start, final_end);
> +		reserve_bootmem_generic(final_start, final_end - final_start, BOOTMEM_DEFAULT);
> +	}
> +	/* Clear them to avoid misusing ? */
> +	memset(&lmb.reserved.region[0], 0, sizeof(struct lmb_property) * lmb.reserved.nr_regions);
> +	lmb.reserved.region = NULL;
> +	lmb.reserved.nr_regions = 0;
> +	lmb.reserved.cnt = 0;
> +}
> +#endif
> +
>  u64 __init __weak __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
>  				 u64 size, u64 align)
>  {


