Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab2GJAZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 20:25:11 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53214 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab2GJAZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 20:25:10 -0400
X-AuditID: 9c93016f-b7c7eae0000025c5-78-4ffb7662adc9
Date: Tue, 10 Jul 2012 09:25:10 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v2] mm: Warn about costly page allocation
Message-ID: <20120710002510.GB5935@bbox>
References: <1341878153-10757-1-git-send-email-minchan@kernel.org>
 <20120709170856.ca67655a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120709170856.ca67655a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Mon, Jul 09, 2012 at 05:08:56PM -0700, Andrew Morton wrote:
> On Tue, 10 Jul 2012 08:55:53 +0900
> Minchan Kim <minchan@kernel.org> wrote:
> 
> > ...
> >
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -2276,6 +2276,29 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
> >  	return alloc_flags;
> >  }
> >  
> > +#if defined(CONFIG_DEBUG_VM) && !defined(CONFIG_COMPACTION)
> > +static inline void check_page_alloc_costly_order(unsigned int order, gfp_t flags)
> > +{
> > +	if (likely(order <= PAGE_ALLOC_COSTLY_ORDER))
> > +		return;
> > +
> > +	if (!printk_ratelimited())
> > +		return;
> > +
> > +	pr_warn("%s: page allocation high-order stupidity: "
> > +		"order:%d, mode:0x%x\n", current->comm, order, flags);
> > +	pr_warn("Enable compaction if high-order allocations are "
> > +		"very few and rare.\n");
> > +	pr_warn("If you need regular high-order allocation, "
> > +		"compaction wouldn't help it.\n");
> > +	dump_stack();
> > +}
> > +#else
> > +static inline void check_page_alloc_costly_order(unsigned int order)
> > +{
> > +}
> > +#endif
> 
> Let's remember that plain old "inline" is ignored by the compiler.  If
> we really really want to inline something then we should use
> __always_inline.

I didn't know about that. Thanks for the pointing out.

> 
> And inlining this function would be a bad thing to do - it causes the
> outer function to have an increased cache footprint.  A good way to
> optimise this function is probably to move the unlikely stuff
> out-of-line:

Okay. will do.

> 
> 	if (unlikely(order > PAGE_ALLOC_COSTLY_ORDER))
> 		check_page_alloc_costly_order(...);
> 
> or
> 
> static noinline void __check_page_alloc_costly_order(...)
> {
> }
> 
> static __always_inline void check_page_alloc_costly_order(...)
> {
> 	if (unlikely(order > PAGE_ALLOC_COSTLY_ORDER))
> 		__check_page_alloc_costly_order(...);
> }
> 	
> 
> Also, the displayed messages don't seem very, umm, professional.  Who
> was stupid - us or the kernel-configurer?  And "Enable
> CONFIG_COMPACTION" would be more specific (and hence helpful) than
> "Enable compaction").

Okay.

> 
> And how on earth is the user, or the person who is configuring kernels
> for customers to determine whether the kernel will be frequently
> performing higher-order allocations?
> 
> 
> So I dunno, this all looks like we have a kernel problem and we're
> throwing our problem onto hopelessly ill-equipped users of that kernel?

As you know, this patch isn't for solving regular high-order allocations.
As I wrote down, The problem is that we removed lumpy reclaim without any
notification for user who might have used it implicitly.
If such user disable compaction which is a replacement of lumpy reclaim,
their system might be broken in real practice while test is passing.
So, the goal is that let them know it in advance so that I expect they can
test it stronger than old.

Although they see the page allocation failure with compaction, it would
be very helpful reports. It means we need to make compaction more
aggressive about reclaiming pages.

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
