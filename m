Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab1KNK2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 05:28:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab1KNK2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 05:28:19 -0500
Date: Mon, 14 Nov 2011 11:29:23 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/4] mm: more intensive memory corruption debug
Message-ID: <20111114102923.GB2513@redhat.com>
References: <1321014994-2426-1-git-send-email-sgruszka@redhat.com>
 <1321014994-2426-2-git-send-email-sgruszka@redhat.com>
 <20111111142953.GM3083@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111111142953.GM3083@suse.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 02:29:53PM +0000, Mel Gorman wrote:
> >  	if (PageBuddy(buddy) && page_order(buddy) == order) {
> >  		VM_BUG_ON(page_count(buddy) != 0);
> >  		return 1;
> > @@ -518,9 +562,15 @@ static inline void __free_one_page(struct page *page,
> >  			break;
> >  
> >  		/* Our buddy is free, merge with it and move up one order. */
> > -		list_del(&buddy->lru);
> > -		zone->free_area[order].nr_free--;
> > -		rmv_page_order(buddy);
> > +		if (page_is_corrupt_dbg(buddy)) {
> > +			clear_page_corrupt_dbg(buddy);
> > +			set_page_private(page, 0);
> > +			__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
> 
> Why are the buddies not merged?
I believe they are merged, but I'll double check.

> >  static inline void expand(struct zone *zone, struct page *page,
> > -	int low, int high, struct free_area *area,
> > +	unsigned int low, unsigned int high, struct free_area *area,
> >  	int migratetype)
> >  {
> >  	unsigned long size = 1 << high;
> > @@ -746,9 +796,16 @@ static inline void expand(struct zone *zone, struct page *page,
> >  		high--;
> >  		size >>= 1;
> >  		VM_BUG_ON(bad_range(zone, &page[size]));
> > -		list_add(&page[size].lru, &area->free_list[migratetype]);
> > -		area->nr_free++;
> > -		set_page_order(&page[size], high);
> > +		if (high < corrupt_dbg()) {
> > +			INIT_LIST_HEAD(&page[size].lru);
> > +			set_page_corrupt_dbg(&page[size]);
> > +			set_page_private(&page[size], high);
> > +			__mod_zone_page_state(zone, NR_FREE_PAGES, -(1 << high));
> > +		} else {
> 
> Because high is a signed integer, I don't think this would necessarily
> optimised away at compile time when DEBUG_PAGEALLOC is not set adding a
> new branch to a heavily executed fast path.
> 
> For the fast paths, you should not add new branches if you can. Move the
> debugging code to inline functions that only exist when DEBUG_PAGEALLOC
> is set so there is no additional overhead in the !CONFIG_DEBUG_PAGEALLOC
> case.

I changed "high" type from int to unsigned int in the patch, and checked
that this branch is removed by compiler in !CONFIG_DEBUG_PAGEALLOC case.
But perhaps having this inside preprocessor checks is cleaner, so I'll do
that.

Thanks for the comments, I'll rework and repost.
Stanislaw
