Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab1DHUho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 16:37:44 -0400
Received: from smtp-out.google.com ([74.125.121.67]:35971 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757841Ab1DHUhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 16:37:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=s3oTiTr2hOFWy6x8Dw4UcsP7s4EL5NWGHWbwDhz2knx5swrtC3C8t3hFX8302tOQ8V
         2YQwpCXLz6sa7smDjWjw==
Date: Fri, 8 Apr 2011 13:37:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/2] break out page allocation warning code
In-Reply-To: <20110408202253.6D6D231C@kernel>
Message-ID: <alpine.DEB.2.00.1104081333260.12689@chino.kir.corp.google.com>
References: <20110408202253.6D6D231C@kernel>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Apr 2011, Dave Hansen wrote:

> 
> This originally started as a simple patch to give vmalloc()
> some more verbose output on failure on top of the plain
> page allocator messages.  Johannes suggested that it might
> be nicer to lead with the vmalloc() info _before_ the page
> allocator messages.
> 
> But, I do think there's a lot of value in what
> __alloc_pages_slowpath() does with its filtering and so
> forth.
> 
> This patch creates a new function which other allocators
> can call instead of relying on the internal page allocator
> warnings.  It also gives this function private rate-limiting
> which separates it from other printk_ratelimit() users.
> 
> ---
> 
>  linux-2.6.git-dave/include/linux/mm.h |    2 +
>  linux-2.6.git-dave/mm/page_alloc.c    |   65 +++++++++++++++++++++++-----------
>  2 files changed, 46 insertions(+), 21 deletions(-)
> 
> diff -puN include/linux/mm.h~break-out-alloc-failure-messages include/linux/mm.h
> --- linux-2.6.git/include/linux/mm.h~break-out-alloc-failure-messages	2011-04-08 13:07:18.978332687 -0700
> +++ linux-2.6.git-dave/include/linux/mm.h	2011-04-08 13:07:18.990332675 -0700
> @@ -1365,6 +1365,8 @@ extern void si_meminfo(struct sysinfo * 
>  extern void si_meminfo_node(struct sysinfo *val, int nid);
>  extern int after_bootmem;
>  
> +extern void nopage_warning(gfp_t gfp_mask, int order, const char *fmt, ...);
> +
>  extern void setup_per_cpu_pageset(void);
>  
>  extern void zone_pcp_update(struct zone *zone);
> diff -puN mm/page_alloc.c~break-out-alloc-failure-messages mm/page_alloc.c
> --- linux-2.6.git/mm/page_alloc.c~break-out-alloc-failure-messages	2011-04-08 13:07:18.982332683 -0700
> +++ linux-2.6.git-dave/mm/page_alloc.c	2011-04-08 13:07:18.990332675 -0700
> @@ -54,6 +54,7 @@
>  #include <trace/events/kmem.h>
>  #include <linux/ftrace_event.h>
>  #include <linux/memcontrol.h>
> +#include <linux/ratelimit.h>
>  
>  #include <asm/tlbflush.h>
>  #include <asm/div64.h>
> @@ -1734,6 +1735,48 @@ static inline bool should_suppress_show_
>  	return ret;
>  }
>  
> +static DEFINE_RATELIMIT_STATE(nopage_rs,
> +		DEFAULT_RATELIMIT_INTERVAL,
> +		DEFAULT_RATELIMIT_BURST);
> +
> +void nopage_warning(gfp_t gfp_mask, int order, const char *fmt, ...)

I suggest a different name for this, something like warn_alloc_failure() 
or such.

I guess this isn't general enough where it could be used in the oom killer 
as well?

> +{
> +	va_list args;
> +	int r;
> +	unsigned int filter = SHOW_MEM_FILTER_NODES;
> +	const gfp_t wait = gfp_mask & __GFP_WAIT;
> +
> +	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs))
> +		return;
> +
> +	/*
> +	 * This documents exceptions given to allocations in certain
> +	 * contexts that are allowed to allocate outside current's set
> +	 * of allowed nodes.
> +	 */
> +	if (!(gfp_mask & __GFP_NOMEMALLOC))
> +		if (test_thread_flag(TIF_MEMDIE) ||
> +		    (current->flags & (PF_MEMALLOC | PF_EXITING)))
> +			filter &= ~SHOW_MEM_FILTER_NODES;
> +	if (in_interrupt() || !wait)
> +		filter &= ~SHOW_MEM_FILTER_NODES;
> +
> +	if (fmt) {
> +		printk(KERN_WARNING);
> +		va_start(args, fmt);
> +		r = vprintk(fmt, args);
> +		va_end(args);
> +	}
> +
> +	printk(KERN_WARNING);
> +	printk("%s: page allocation failure: order:%d, mode:0x%x\n",
> +			current->comm, order, gfp_mask);

This shouldn't be here, it should have been printed already.

> +
> +	dump_stack();
> +	if (!should_suppress_show_mem())
> +		show_mem(filter);
> +}
> +
>  static inline int
>  should_alloc_retry(gfp_t gfp_mask, unsigned int order,
>  				unsigned long pages_reclaimed)
> @@ -2176,27 +2219,7 @@ rebalance:
>  	}
>  
>  nopage:
> -	if (!(gfp_mask & __GFP_NOWARN) && printk_ratelimit()) {
> -		unsigned int filter = SHOW_MEM_FILTER_NODES;
> -
> -		/*
> -		 * This documents exceptions given to allocations in certain
> -		 * contexts that are allowed to allocate outside current's set
> -		 * of allowed nodes.
> -		 */
> -		if (!(gfp_mask & __GFP_NOMEMALLOC))
> -			if (test_thread_flag(TIF_MEMDIE) ||
> -			    (current->flags & (PF_MEMALLOC | PF_EXITING)))
> -				filter &= ~SHOW_MEM_FILTER_NODES;
> -		if (in_interrupt() || !wait)
> -			filter &= ~SHOW_MEM_FILTER_NODES;
> -
> -		pr_warning("%s: page allocation failure. order:%d, mode:0x%x\n",
> -			current->comm, order, gfp_mask);
> -		dump_stack();
> -		if (!should_suppress_show_mem())
> -			show_mem(filter);
> -	}
> +	nopage_warning(gfp_mask, order, NULL);
>  	return page;
>  got_pg:
>  	if (kmemcheck_enabled)
