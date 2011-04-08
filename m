Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab1DHNXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 09:23:21 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41725 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1DHNXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 09:23:20 -0400
Subject: Re: [PATCH] print vmalloc() state after allocation failures
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110408001942.GC2874@cmpxchg.org>
References: <20110407172302.3B7546DA@kernel>
	 <20110408001942.GC2874@cmpxchg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 08 Apr 2011 06:23:08 -0700
Message-ID: <1302268988.8184.6890.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 17:19 -0700, Johannes Weiner wrote:
> On Thu, Apr 07, 2011 at 10:23:02AM -0700, Dave Hansen wrote:
> > @@ -1579,6 +1579,18 @@ static void *__vmalloc_area_node(struct 
> >  	return area->addr;
> >  
> >  fail:
> > +	if (!(gfp_mask & __GFP_NOWARN) && printk_ratelimit()) {
> 
> There is a comment above the declaration of printk_ratelimit:
> 
> /*
>  * Please don't use printk_ratelimit(), because it shares ratelimiting state
>  * with all other unrelated printk_ratelimit() callsites.  Instead use
>  * printk_ratelimited() or plain old __ratelimit().
>  */
> 
> I realize that the page allocator does it the same way, but I think it
> should probably be fixed in there, rather than spread any further.

You're the second person to mention this.  I should have listened the
first time. :)  I'll fix it up and repost.

> > +		/*
> > +		 * We probably did a show_mem() and a stack dump above
> > +		 * inside of alloc_page*().  This is only so we can
> > +		 * tell how big the vmalloc() really was.  This will
> > +		 * also not be exactly the same as what was passed
> > +		 * to vmalloc() due to alignment and the guard page.
> > +		 */
> > +		printk(KERN_WARNING "%s: vmalloc: allocation failure, "
> > +			"allocated %ld of %ld bytes\n", current->comm,
> > +			(area->nr_pages*PAGE_SIZE), area->size);
> > +	}
> 
> To me, this does not look like something that should just be appended
> to the whole pile spewed out by dump_stack() and show_mem().  What do
> you think about doing the page allocation with __GFP_NOWARN and have
> the full report come from this place, with the line you introduce as
> leader?

That sounds fine to me.  

-- Dave

