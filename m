Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0K3ODu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 09:03:50 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42133 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab0K3ODt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 09:03:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JQPA3AFqhGOjQyo+E0QIxGoREoVrf1TcEilsuUOmhyrNWmNw2fX+jTzr8A9WRrAnwB
         uvrT9wQO88CDv6O66Ccnf9mzkEw1fUIEigvDg1ZzPDWzvRrfbPdHwhgk26i2naG8PK8b
         ImvzByhNcQt3GPV6caIcsGuUQuQsP/RzVRuCg=
Date: Tue, 30 Nov 2010 23:03:33 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH 2/3] Reclaim invalidated page ASAP
Message-ID: <20101130140333.GB1528@barrios-desktop>
References: <cover.1291043273.git.minchan.kim@gmail.com>
 <053e6a3308160a8992af5a47fb4163796d033b08.1291043274.git.minchan.kim@gmail.com>
 <20101129165706.GH13268@csn.ul.ie>
 <20101129224130.GA1989@barrios-desktop>
 <20101130112041.GC15564@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130112041.GC15564@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 12:20:41PM +0100, Johannes Weiner wrote:
> On Tue, Nov 30, 2010 at 07:41:30AM +0900, Minchan Kim wrote:
> 
> > diff --git a/mm/swap.c b/mm/swap.c
> > index 19e0812..1f1f435 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -275,28 +275,51 @@ void add_page_to_unevictable_list(struct page *page)
> >   * into inative list's head. Because the VM expects the page would
> >   * be writeout by flusher. The flusher's writeout is much effective
> >   * than reclaimer's random writeout.
> > + *
> > + * If the page isn't page_mapped and dirty/writeback, the page
> > + * could reclaim asap using PG_reclaim.
> > + *
> > + * 1. active, mapped page -> none
> > + * 2. active, dirty/writeback page -> inactive, head, PG_reclaim
> > + * 3. inactive, mapped page -> none
> > + * 4. inactive, dirty/writeback page -> inactive, head, PG_reclaim
> > + * 5. Others -> none
> > + *
> > + * In 4, why it moves inactive's head, the VM expects the page would
> > + * be writeout by flusher. The flusher's writeout is much effective than
> > + * reclaimer's random writeout.
> >   */
> >  static void __lru_deactivate(struct page *page, struct zone *zone)
> >  {
> >  	int lru, file;
> > -	unsigned long vm_flags;
> > +	int active = 0;
> 
> vm_flags is never used in this series.

It's garbage in my old version which is used page_referenced.

> 
> > -	if (!PageLRU(page) || !PageActive(page))
> > +	if (!PageLRU(page))
> >  		return;
> > -
> >  	/* Some processes are using the page */
> >  	if (page_mapped(page))
> >  		return;
> > -
> > -	file = page_is_file_cache(page);
> > -	lru = page_lru_base_type(page);
> > -	del_page_from_lru_list(zone, page, lru + LRU_ACTIVE);
> > -	ClearPageActive(page);
> > -	ClearPageReferenced(page);
> > -	add_page_to_lru_list(zone, page, lru);
> > -	__count_vm_event(PGDEACTIVATE);
> > -
> > -	update_page_reclaim_stat(zone, page, file, 0);
> > +	if (PageActive(page))
> > +		active = 1;
> 
> 	active = PageActive(page)

Will fix. 

> 
> > +	if (PageWriteback(page) || PageDirty(page)) {
> > +		/*
> > +		 * PG_reclaim could be raced with end_page_writeback
> > +		 * It can make readahead confusing.  But race window
> > +		 * is _really_ small and  it's non-critical problem.
> > +		 */
> > +		SetPageReclaim(page);
> > +
> > +		file = page_is_file_cache(page);
> > +		lru = page_lru_base_type(page);
> > +		del_page_from_lru_list(zone, page, lru + active);
> > +		ClearPageActive(page);
> > +		ClearPageReferenced(page);
> > +		add_page_to_lru_list(zone, page, lru);
> > +		if (active)
> > +			__count_vm_event(PGDEACTIVATE);
> > +		update_page_reclaim_stat(zone, page, file, 0);
> > +	}
> 
> If we lose the race with writeback, the completion handler won't see
> PG_reclaim, won't move the page, and we have an unwanted clean cache
> page on the active list.  Given the pagevec caching of those pages it
> could be rather likely that IO completes before the above executes.
> 
> Shouldn't this be
> 
> 	if (PageWriteback() || PageDirty()) {
> 		SetPageReclaim()
> 		move_to_inactive_head()
> 	} else {
> 		move_to_inactive_tail()
> 	}
> 
> instead?

Fair enough.

Thanks, Hannes.
> 
> 	Hannes

-- 
Kind regards,
Minchan Kim
