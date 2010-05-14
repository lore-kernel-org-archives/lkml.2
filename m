Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071Ab0ENWkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 18:40:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:41751 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760028Ab0ENWku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 18:40:50 -0400
Subject: Re: [PATCH 07/37] lmb: Add lmb_find_area()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1273866363-14249-8-git-send-email-yinghai@kernel.org>
References: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
	 <1273866363-14249-8-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 May 2010 08:39:09 +1000
Message-ID: <1273876749.21352.645.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 12:45 -0700, Yinghai Lu wrote:
> it is a wrapper for lmb_find_base
> 
> make it more easy for x86 to use lmb. ( rebase )
> x86 early_res is using find/reserve pattern instead of alloc.
> 
> keep it in weak version, so later We can use x86 own version if needed.
> also We need it in lib/lmb.c, so one called mm/page_alloc.c could get compiled

I seem to have told you that I didn't want to have that thing in the
core :-)

You keep adding those "wrappers" which basically just do prototype
adaptation and in this case a bit of cropping, with a name that is
utterly confusing as to what their intent is.

I might have accepted that one if you had called it something like
lmb_find_in_range() which at least -means- something.

Cheers,
Ben.

> -v2: Change name to lmb_find_area() according to Michael Ellerman
> -v3: Add generic weak version __lmb_find_area()
>      so keep the path for fallback to x86 version that handle from low
> -v4: use 0 for failing path
> -v5: use LMB_ERROR again
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  include/linux/lmb.h |    4 ++++
>  lib/lmb.c           |   23 +++++++++++++++++++++++
>  2 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/lmb.h b/include/linux/lmb.h
> index e54c1d0..c05294f 100644
> --- a/include/linux/lmb.h
> +++ b/include/linux/lmb.h
> @@ -44,6 +44,10 @@ extern struct lmb lmb;
>  extern int lmb_debug;
>  extern struct lmb_region lmb_reserved_init_regions[];
>  
> +u64 __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
> +			u64 size, u64 align);
> +u64 lmb_find_area(u64 start, u64 end, u64 size, u64 align);
> +
>  extern void __init lmb_init(void);
>  extern void __init lmb_analyze(void);
>  extern long lmb_add(phys_addr_t base, phys_addr_t size);
> diff --git a/lib/lmb.c b/lib/lmb.c
> index c92034b..1c46336 100644
> --- a/lib/lmb.c
> +++ b/lib/lmb.c
> @@ -155,6 +155,29 @@ static phys_addr_t __init lmb_find_base(phys_addr_t size, phys_addr_t align,
>  	return LMB_ERROR;
>  }
>  
> +u64 __init __weak __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
> +				 u64 size, u64 align)
> +{
> +	u64 final_start, final_end;
> +	u64 mem;
> +
> +	final_start = max(ei_start, start);
> +	final_end = min(ei_last, end);
> +
> +	if (final_start >= final_end)
> +		return LMB_ERROR;
> +
> +	return  lmb_find_base(size, align, final_start, final_end);
> +}
> +
> +/*
> + * Find a free area with specified alignment in a specific range.
> + */
> +u64 __init __weak lmb_find_area(u64 start, u64 end, u64 size, u64 align)
> +{
> +	return lmb_find_base(size, align, start, end);
> +}
> +
>  static void __init_lmb lmb_remove_region(struct lmb_type *type, unsigned long r)
>  {
>  	unsigned long i;


