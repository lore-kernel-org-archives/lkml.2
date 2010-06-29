Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab0F2R6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 13:58:13 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:41910 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab0F2R6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 13:58:11 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 18/25] x86, lmb: Use lmb_debug to control debug message print out
Date: Tue, 29 Jun 2010 11:58:52 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
References: <1277227614-11581-1-git-send-email-yinghai@kernel.org> <1277227614-11581-19-git-send-email-yinghai@kernel.org>
In-Reply-To: <1277227614-11581-19-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006291158.54280.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 22, 2010 11:26:47 am Yinghai Lu wrote:
> Also let lmb_reserve_range/lmb_free_range could print out name if lmb=debug is
> specified
> 
> will also print ther name when reserve_lmb_area/free_lmb_area are called.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/mm/lmb.c |   24 ++++++++++++++++++------
>  1 files changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
> index bd2f60b..209f25b 100644
> --- a/arch/x86/mm/lmb.c
> +++ b/arch/x86/mm/lmb.c
> @@ -122,10 +122,12 @@ static void __init subtract_lmb_reserved(struct range *range, int az)
>  
>  	count  = lmb.reserved.cnt;
>  
> -	pr_info("Subtract (%d early reservations)\n", count);
> +	if (lmb_debug)
> +		pr_info("Subtract (%d early reservations)\n", count);
>  
>  	for_each_lmb(reserved, r) {
> -		pr_info("  [%010llx - %010llx]\n", (u64)r->base, (u64)r->base + r->size);

Use %pR format (looks like this is rework on top of a previous patch,
so this comment is probably redundant).

> +		if (lmb_debug)
> +			pr_info("  [%010llx - %010llx]\n", (u64)r->base, (u64)r->base + r->size);
>  		final_start = PFN_DOWN(r->base);
>  		final_end = PFN_UP(r->base + r->size);
>  		if (final_start >= final_end)
> @@ -198,16 +200,20 @@ void __init lmb_to_bootmem(u64 start, u64 end)
>  		lmb_free(__pa(lmb.reserved.regions), sizeof(struct lmb_region) * lmb.reserved.max);
>  
>  	count  = lmb.reserved.cnt;
> -	pr_info("(%d early reservations) ==> bootmem [%010llx - %010llx]\n", count, start, end);
> +	if (lmb_debug)
> +		pr_info("(%d early reservations) ==> bootmem [%010llx - %010llx]\n", count, start, end);
>  	for_each_lmb(reserved, r) {
> -		pr_info("  [%010llx - %010llx] ", (u64)r->base, (u64)r->base + r->size);
> +		if (lmb_debug)
> +			pr_info("  [%010llx - %010llx] ", (u64)r->base, (u64)r->base + r->size);
>  		final_start = max(start, r->base);
>  		final_end = min(end, r->base + r->size);
>  		if (final_start >= final_end) {
> -			pr_cont("\n");
> +			if (lmb_debug)
> +				pr_cont("\n");
>  			continue;
>  		}
> -		pr_cont(" ==> [%010llx - %010llx]\n", final_start, final_end);
> +		if (lmb_debug)
> +			pr_cont(" ==> [%010llx - %010llx]\n", final_start, final_end);
>  		reserve_bootmem_generic(final_start, final_end - final_start, BOOTMEM_DEFAULT);
>  	}
>  
> @@ -289,6 +295,9 @@ void __init lmb_reserve_range(u64 start, u64 end, char *name)
>  	if (WARN_ONCE(start > end, "lmb_reserve_range: wrong range [%#llx, %#llx]\n", start, end))
>  		return;
>  
> +	if (lmb_debug)
> +		pr_info("    lmb_reserve_range: [%010llx, %010llx] %16s\n", start, end, name);
> +
>  	lmb_reserve(start, end - start);
>  }
>  
> @@ -300,6 +309,9 @@ void __init lmb_free_range(u64 start, u64 end)
>  	if (WARN_ONCE(start > end, "lmb_free_range: wrong range [%#llx, %#llx]\n", start, end))
>  		return;
>  
> +	if (lmb_debug)
> +		pr_info("       lmb_free_range: [%010llx, %010llx]\n", start, end);
> +
>  	lmb_free(start, end - start);
>  }
>  
> 
