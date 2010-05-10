Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab0EJGic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 02:38:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:46459 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab0EJGi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 02:38:29 -0400
Subject: Re: [PATCH 15/22] lmb: Add lmb_reserve_area_overlap_ok()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1273331860-14325-16-git-send-email-yinghai@kernel.org>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
	 <1273331860-14325-16-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 16:34:41 +1000
Message-ID: <1273473281.23699.50.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-08 at 08:17 -0700, Yinghai Lu wrote:
> Some areas from firmware could be reserved several times from different callers.
> 
> If these area are overlapped, We may have overlapped entries in lmb.reserved.
> 
> Try to free the area at first, before rerserve them again.

I explained earlier that name sucked :-)

We just need to make lmb_reserve() capable of dealing with overlaps
instead. I like the idea of implementing that with a free.

Cheers,
Ben.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  include/linux/lmb.h |    1 +
>  mm/lmb.c            |   27 +++++++++++++++++++++++++--
>  2 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/lmb.h b/include/linux/lmb.h
> index 90022c1..47b9d7f 100644
> --- a/include/linux/lmb.h
> +++ b/include/linux/lmb.h
> @@ -87,6 +87,7 @@ lmb_end_pfn(struct lmb_region *type, unsigned long region_nr)
>  }
>  
>  void lmb_reserve_area(u64 start, u64 end, char *name);
> +void lmb_reserve_area_overlap_ok(u64 start, u64 end, char *name);
>  void lmb_free_area(u64 start, u64 end);
>  void lmb_add_memory(u64 start, u64 end);
>  u64 __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
> diff --git a/mm/lmb.c b/mm/lmb.c
> index 2870dd9..decea60 100644
> --- a/mm/lmb.c
> +++ b/mm/lmb.c
> @@ -605,6 +605,12 @@ void __init lmb_add_memory(u64 start, u64 end)
>  	__check_and_double_region_array(&lmb.memory, &lmb_memory_region[0]);
>  }
>  
> +static void __init __lmb_reserve_area(u64 start, u64 end, char *name)
> +{
> +	lmb_add_region(&lmb.reserved, start, end - start);
> +	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0]);
> +}
> +
>  void __init lmb_reserve_area(u64 start, u64 end, char *name)
>  {
>  	if (start == end)
> @@ -613,8 +619,25 @@ void __init lmb_reserve_area(u64 start, u64 end, char *name)
>  	if (WARN_ONCE(start > end, "lmb_reserve_area: wrong range [%#llx, %#llx]\n", start, end))
>  		return;
>  
> -	lmb_add_region(&lmb.reserved, start, end - start);
> -	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0]);
> +	__lmb_reserve_area(start, end, name);
> +}
> +
> +/*
> + * Could be used to avoid having overlap entries in lmb.reserved.region.
> + *  Don't need to use it with area that is from lmb_find_area()
> + *  Only use it for the area that fw hidden area.
> + */
> +void __init lmb_reserve_area_overlap_ok(u64 start, u64 end, char *name)
> +{
> +	if (start == end)
> +		return;
> +
> +	if (WARN_ONCE(start > end, "lmb_reserve_area_overlap_ok: wrong range [%#llx, %#llx]\n", start, end))
> +		return;
> +
> +	/* Free that region at first */
> +	lmb_free(start, end - start);
> +	__lmb_reserve_area(start, end, name);
>  }
>  
>  void __init lmb_free_area(u64 start, u64 end)


