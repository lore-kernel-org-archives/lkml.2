Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab0ENCSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:18:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:36586 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab0ENCSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:18:13 -0400
Subject: Re: [PATCH 04/35] lmb: Add lmb_find_area()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1273796396-29649-5-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-5-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 12:16:50 +1000
Message-ID: <1273803410.21352.361.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 17:19 -0700, Yinghai Lu wrote:
> it is a wrapper for lmb_find_base
> 
> make it more easy for x86 to use lmb. ( rebase )
> x86 early_res is using find/reserve pattern instead of alloc.
> 
> -v2: Change name to lmb_find_area() according to Michael Ellerman
> -v3: Add generic weak version __lmb_find_area()
>      so keep the path for fallback to x86 version that handle from low
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  include/linux/lmb.h |    4 ++++
>  lib/lmb.c           |   27 ++++++++++++++++++++++++++-
>  2 files changed, 30 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/lmb.h b/include/linux/lmb.h
> index 0b073a3..3c23dc8 100644
> --- a/include/linux/lmb.h
> +++ b/include/linux/lmb.h
> @@ -44,6 +44,10 @@ extern struct lmb lmb;
>  extern int lmb_debug;
>  extern struct lmb_region lmb_reserved_init_regions[];
>  
> +u64 __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
> +			u64 size, u64 align);
> +u64 lmb_find_area(u64 start, u64 end, u64 size, u64 align);

See my comments about sorting out the return from that function.

Also, I don't understand the need for that __ version. It looks like
something you should keep inside x86, I don't see the need for it in the
generic LMB code, since it just does trivial cropping of the arguments.

Also "ei_last" and "ei_start" are pretty bad names for its arguments
anyways. To some extent I wonder if the caller should be responsible for
doing the cropping in the first place.

Cheers,
Ben.

>  extern void __init lmb_init(void);
>  extern void __init lmb_analyze(void);
>  extern long lmb_add(phys_addr_t base, phys_addr_t size);
> diff --git a/lib/lmb.c b/lib/lmb.c
> index 6d49a17..f917dbf 100644
> --- a/lib/lmb.c
> +++ b/lib/lmb.c
> @@ -155,6 +155,31 @@ static phys_addr_t __init lmb_find_base(phys_addr_t size, phys_addr_t align,
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
> +	mem = lmb_find_base(size, align, final_start, final_end);
> +
> +	return mem;
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
> @@ -199,7 +224,7 @@ static int __init_lmb lmb_double_array(struct lmb_type *type)
>  		new_array = kmalloc(new_size, GFP_KERNEL);
>  		addr = new_array == NULL ? LMB_ERROR : __pa(new_array);
>  	} else
> -		addr = lmb_find_base(new_size, sizeof(struct lmb_region), 0, LMB_ALLOC_ACCESSIBLE);
> +		addr = lmb_find_area(0, lmb.current_limit, new_size, sizeof(struct lmb_region));
>  	if (addr == LMB_ERROR) {
>  		pr_err("lmb: Failed to double %s array from %ld to %ld entries !\n",
>  		       lmb_type_name(type), type->max, type->max * 2);


