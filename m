Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab0G1Fhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 01:37:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:59267 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab0G1Fh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 01:37:27 -0400
Subject: Re: [PATCH 31/31] memblock: Add memblock_find_in_range()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <1279822864-17154-32-git-send-email-yinghai@kernel.org>
References: <1279822864-17154-1-git-send-email-yinghai@kernel.org>
	 <1279822864-17154-32-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 15:36:55 +1000
Message-ID: <1280295415.1970.245.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 11:21 -0700, Yinghai Lu wrote:
> it is a wrapper for memblock_find_base
> 
> make it more easy for x86 to use memblock. ( rebase )
> x86 early_res is using find/reserve pattern instead of alloc.
> 
> keep it in weak version, so later We can use x86 own version if needed.
> also We need it in mm/memblock.c, so one caller mm/page_alloc.c could get compiled
> 
> -v2: Change name to memblock_find_in_range() according to Michael Ellerman
> -v3: Add generic weak version __memblock_find_in_range()
>      so keep the path for fallback to x86 version that handle from low
> -v4: use 0 for failing path
> -v5: use MEMBLOCK_ERROR again
> -v6: remove __memblock_find_in_range()

It's very gross to have this weak and not memblock_find_base()... IE. 

You create a new function defined as a wrapper on an existing one to
provide an easier set of arguments ... but also make it weak so the
arch can completely change its semantics without actually changing
the semantics of the function it wraps.

This is going to cause confusion and bugs. I'm adding the patch without
the weak bit to my branch for now, we need to discuss what is the best
approach for x86 here. Might be to use a different function. I don't
understand yet -why- x86 needs to override it, maybe the right way is
to reserve things more intelligently on x86 ?

In any case, you can always use your own wrapper there if needed

Cheers,
Ben.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  include/linux/memblock.h |    2 ++
>  mm/memblock.c            |    8 ++++++++
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index 751a4eb..61b22eb 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -48,6 +48,8 @@ extern struct memblock_region memblock_reserved_init_regions[];
>  #define memblock_dbg(fmt, ...) \
>  	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
>  
> +u64 memblock_find_in_range(u64 start, u64 end, u64 size, u64 align);
> +
>  extern void __init memblock_init(void);
>  extern void __init memblock_analyze(void);
>  extern long memblock_add(phys_addr_t base, phys_addr_t size);
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 7471dac..ca7de91 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -156,6 +156,14 @@ static phys_addr_t __init memblock_find_base(phys_addr_t size, phys_addr_t align
>  	return MEMBLOCK_ERROR;
>  }
>  
> +/*
> + * Find a free area with specified alignment in a specific range.
> + */
> +u64 __init __weak memblock_find_in_range(u64 start, u64 end, u64 size, u64 align)
> +{
> +	return memblock_find_base(size, align, start, end);
> +}
> +
>  static void __init_memblock memblock_remove_region(struct memblock_type *type, unsigned long r)
>  {
>  	unsigned long i;


