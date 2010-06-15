Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab0FOLLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:11:40 -0400
Received: from gir.skynet.ie ([193.1.99.77]:46393 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757496Ab0FOLLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:11:38 -0400
Date: Tue, 15 Jun 2010 12:11:20 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 11/12] vmscan: Write out dirty pages in batch
Message-ID: <20100615111119.GC26788@csn.ul.ie>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie> <1276514273-27693-12-git-send-email-mel@csn.ul.ie> <20100615105341.GB31051@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100615105341.GB31051@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 06:53:41AM -0400, Christoph Hellwig wrote:
> > +	/*
> > +	 * XXX: This is the Holy Hand Grenade of PotentiallyInvalidMapping. As
> > +	 * the page lock has been dropped by ->writepage, that mapping could
> > +	 * be anything
> > +	 */
> 
> Why is this an XXX comment?
> 

With the page lock released, the mapping may be no longer valid. Nick
posted a patch in relation to it that I need to look at. The comment was
because Andrew highlight that this was buggy and I wanted to make sure I
didn't forget about it.

> > +	/*
> > +	 * Wait on writeback if requested to. This happens when
> > +	 * direct reclaiming a large contiguous area and the
> > +	 * first attempt to free a range of pages fails.
> > +	 */
> > +	if (PageWriteback(page) && sync_writeback == PAGEOUT_IO_SYNC)
> > +		wait_on_page_writeback(page);
> > +
> > +	if (!PageWriteback(page)) {
> > +		/* synchronous write or broken a_ops? */
> > +		ClearPageReclaim(page);
> > +	}
> 
> how about:
> 
> 	if (PageWriteback(page) {
> 		if (sync_writeback == PAGEOUT_IO_SYNC)
> 			wait_on_page_writeback(page);
> 	} else {
> 		/* synchronous write or broken a_ops? */
> 		ClearPageReclaim(page);
> 	}
> 

Sure, that's tidier.

> >  	if (!may_write_to_queue(mapping->backing_dev_info))
> >  		return PAGE_KEEP;
> >  
> >  /*
> > + * Clean a list of pages. It is expected that all the pages on page_list have been
> > + * locked as part of isolation from the LRU.
> 
> A rather pointless line of 80 chars.  I see the point for long string
> literals, but here's it's just a pain.
> 

I'll trim it.

> > + *
> > + * XXX: Is there a problem with holding multiple page locks like this?
> 
> I think there is.  There's quite a few places that do hold multiple
> pages locked, but they always lock pages in increasing page->inxex order.
> Given that this locks basically in random order it could cause problems
> for those places.
> 

Hmm, ok. In that case, I'll have to release the locks on the list and
reacquire them. It was something I would have preferred to avoid. Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
