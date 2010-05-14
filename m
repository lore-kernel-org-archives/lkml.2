Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab0ENCfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:35:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:55261 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169Ab0ENCfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:35:52 -0400
Subject: Re: [PATCH 17/35] x86, lmb: Add x86 version of __lmb_find_area()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1273796396-29649-18-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-18-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 12:34:26 +1000
Message-ID: <1273804466.21352.400.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 17:19 -0700, Yinghai Lu wrote:
> Generic version is going from high to low, and it seems it can not find
> right area compact enough.
> 
> the x86 version will go from goal to limit and just like the way We used
> for early_res
> 
> use ARCH_FIND_LMB_AREA to select from them.

Why the heck ?

So LMB is designed to work top->down and now you replace lmb_find_area()
with a -completely different- implementation that goes bottom->up
without any explanation as to why you are doing so ?

top->down tend to be move efficient at keeping things less fragmented
btw.

Cheers,
Ben.

> -v2: default to no
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/Kconfig  |    8 +++++
>  arch/x86/mm/lmb.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 86 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index d80d2ab..36a5665 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -584,6 +584,14 @@ config PARAVIRT_DEBUG
>  	  Enable to debug paravirt_ops internals.  Specifically, BUG if
>  	  a paravirt_op is missing when it is called.
>  
> +config ARCH_LMB_FIND_AREA
> +	default n
> +	bool "Use x86 own lmb_find_area()"
> +	---help---
> +	  Use lmb_find_area() version instead of generic version, it get free
> +	  area up from low.
> +	  Generic one try to get free area down from limit.
> +
>  config NO_BOOTMEM
>  	default y
>  	bool "Disable Bootmem code"
> diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
> index c0c4220..cf9d488 100644
> --- a/arch/x86/mm/lmb.c
> +++ b/arch/x86/mm/lmb.c
> @@ -435,3 +435,81 @@ u64 __init lmb_hole_size(u64 start, u64 end)
>  	return end - start - ((u64)ram << PAGE_SHIFT);
>  }
>  
> +#ifdef CONFIG_ARCH_LMB_FIND_AREA
> +static int __init find_overlapped_early(u64 start, u64 end)
> +{
> +	int i;
> +	struct lmb_region *r;
> +
> +	for (i = 0; i < lmb.reserved.cnt && lmb.reserved.regions[i].size; i++) {
> +		r = &lmb.reserved.regions[i];
> +		if (end > r->base && start < (r->base + r->size))
> +			break;
> +	}
> +
> +	return i;
> +}
> +
> +/* Check for already reserved areas */
> +static inline bool __init bad_addr(u64 *addrp, u64 size, u64 align)
> +{
> +	int i;
> +	u64 addr = *addrp;
> +	bool changed = false;
> +	struct lmb_region *r;
> +again:
> +	i = find_overlapped_early(addr, addr + size);
> +	r = &lmb.reserved.regions[i];
> +	if (i < lmb.reserved.cnt && r->size) {
> +		*addrp = addr = round_up(r->base + r->size, align);
> +		changed = true;
> +		goto again;
> +	}
> +	return changed;
> +}
> +
> +u64 __init __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
> +				 u64 size, u64 align)
> +{
> +	u64 addr, last;
> +
> +	addr = round_up(ei_start, align);
> +	if (addr < start)
> +		addr = round_up(start, align);
> +	if (addr >= ei_last)
> +		goto out;
> +	while (bad_addr(&addr, size, align) && addr+size <= ei_last)
> +		;
> +	last = addr + size;
> +	if (last > ei_last)
> +		goto out;
> +	if (last > end)
> +		goto out;
> +
> +	return addr;
> +
> +out:
> +	return LMB_ERROR;
> +}
> +
> +/*
> + * Find a free area with specified alignment in a specific range.
> + */
> +u64 __init lmb_find_area(u64 start, u64 end, u64 size, u64 align)
> +{
> +	int i;
> +
> +	for (i = 0; i < lmb.memory.cnt; i++) {
> +		u64 ei_start = lmb.memory.regions[i].base;
> +		u64 ei_last = ei_start + lmb.memory.regions[i].size;
> +		u64 addr;
> +
> +		addr = __lmb_find_area(ei_start, ei_last, start, end,
> +					 size, align);
> +
> +		if (addr != LMB_ERROR)
> +			return addr;
> +	}
> +	return LMB_ERROR;
> +}
> +#endif


