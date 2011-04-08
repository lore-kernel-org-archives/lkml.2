Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab1DHATx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 20:19:53 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:36066 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757161Ab1DHATw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 20:19:52 -0400
Date: Thu, 7 Apr 2011 17:19:42 -0700
From: Johannes Weiner <hannes@cmpxchg.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] print vmalloc() state after allocation failures
Message-ID: <20110408001942.GC2874@cmpxchg.org>
References: <20110407172302.3B7546DA@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110407172302.3B7546DA@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 10:23:02AM -0700, Dave Hansen wrote:
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

I agree with this in general, but have some nitpicks.

> @@ -1579,6 +1579,18 @@ static void *__vmalloc_area_node(struct 
>  	return area->addr;
>  
>  fail:
> +	if (!(gfp_mask & __GFP_NOWARN) && printk_ratelimit()) {

There is a comment above the declaration of printk_ratelimit:

/*
 * Please don't use printk_ratelimit(), because it shares ratelimiting state
 * with all other unrelated printk_ratelimit() callsites.  Instead use
 * printk_ratelimited() or plain old __ratelimit().
 */

I realize that the page allocator does it the same way, but I think it
should probably be fixed in there, rather than spread any further.

> +		/*
> +		 * We probably did a show_mem() and a stack dump above
> +		 * inside of alloc_page*().  This is only so we can
> +		 * tell how big the vmalloc() really was.  This will
> +		 * also not be exactly the same as what was passed
> +		 * to vmalloc() due to alignment and the guard page.
> +		 */
> +		printk(KERN_WARNING "%s: vmalloc: allocation failure, "
> +			"allocated %ld of %ld bytes\n", current->comm,
> +			(area->nr_pages*PAGE_SIZE), area->size);
> +	}

To me, this does not look like something that should just be appended
to the whole pile spewed out by dump_stack() and show_mem().  What do
you think about doing the page allocation with __GFP_NOWARN and have
the full report come from this place, with the line you introduce as
leader?

	Hannes
