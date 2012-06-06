Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab2FFM4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 08:56:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55373 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab2FFM4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 08:56:30 -0400
X-AuditID: cbfee61b-b7f8f6d000005ca4-b0-4fcf537cc339
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH v9] mm: compaction: handle incorrect MIGRATE_UNMOVABLE type
 pageblocks
Date: Wed, 06 Jun 2012 14:55:28 +0200
User-Agent: KMail/1.13.2 (Linux/3.2.6; KDE/4.4.5; i686; ; )
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
References: <201206041543.56917.b.zolnierkie@samsung.com>
 <op.wfdt8dh53l0zgt@mpn-glaptop>
In-reply-to: <op.wfdt8dh53l0zgt@mpn-glaptop>
MIME-version: 1.0
Message-id: <201206061455.28980.b.zolnierkie@samsung.com>
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jQd2a4PP+Bje65C0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGtcelBecUKrqPf2FtYFwt2cXIwSEhYCJx+Hh4FyMnkCkmceHe
	erYuRi4OIYHpjBLLF01ggXBWM0ksX/mODaSKTcBKYmL7KkYQW0RAU2LRq81MILawQIzE++7F
	YDUsAqoSfWefsoDYogLWEkcv3GMEGcQs8IhZ4vKUPawgCSGBaImNC9rAbE4BHYnJne3sIDav
	gKDEj8n3WCBsS4mnbYvAhjILaEk0v9nECGHLS2xe85Z5AqPALCQts5CUzUJStoCReRWjaGpB
	ckFxUnqukV5xYm5xaV66XnJ+7iZGcAA+k97BuKrB4hCjAAejEg/vAv/z/kKsiWXFlbmHGCU4
	mJVEeOOcgUK8KYmVValF+fFFpTmpxYcYpTlYlMR5+46d8xcSSE8sSc1OTS1ILYLJMnFwSjUw
	aiz49nnCpM3cta/6vjnviAp/6i5SYPVTTGpe29KAZesC9NOFrLqOXQne9pFntdsW/vtdWj6J
	4j87qnmkAzoY/Rf88+Mt+5K7wcz6mejJFMZORT+dmkNsm+YncAg0r2tQSfZJWVD2pDaB5xST
	WmoH79EPQR7vHzHNTf3s9eqRSL9PkreF7AUlluKMREMt5qLiRAB11wIEPAIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 June 2012 16:22:51 Michal Nazarewicz wrote:
> On Mon, 04 Jun 2012 15:43:56 +0200, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:
> > +/*
> > + * Returns true if MIGRATE_UNMOVABLE pageblock can be successfully
> > + * converted to MIGRATE_MOVABLE type, false otherwise.
> > + */
> > +static bool can_rescue_unmovable_pageblock(struct page *page, bool locked)
> > +{
> > +	unsigned long pfn, start_pfn, end_pfn;
> > +	struct page *start_page, *end_page, *cursor_page;
> > +
> > +	pfn = page_to_pfn(page);
> > +	start_pfn = pfn & ~(pageblock_nr_pages - 1);
> > +	end_pfn = start_pfn + pageblock_nr_pages - 1;
> > +
> > +	start_page = pfn_to_page(start_pfn);
> > +	end_page = pfn_to_page(end_pfn);
> > +
> > +	for (cursor_page = start_page, pfn = start_pfn; cursor_page <= end_page;
> > +		pfn++, cursor_page++) {
> > +		struct zone *zone = page_zone(start_page);
> > +		unsigned long flags;
> > +
> > +		if (!pfn_valid_within(pfn))
> > +			continue;
> > +
> > +		/* Do not deal with pageblocks that overlap zones */
> > +		if (page_zone(cursor_page) != zone)
> > +			return false;
> > +
> > +		if (!locked)
> > +			spin_lock_irqsave(&zone->lock, flags);
> > +
> > +		if (PageBuddy(cursor_page)) {
> > +			int order = page_order(cursor_page);
> >-/* Returns true if the page is within a block suitable for migration to */
> > -static bool suitable_migration_target(struct page *page)
> > +			pfn += (1 << order) - 1;
> > +			cursor_page += (1 << order) - 1;
> > +
> > +			if (!locked)
> > +				spin_unlock_irqrestore(&zone->lock, flags);
> > +			continue;
> > +		} else if (page_count(cursor_page) == 0 ||
> > +			   PageLRU(cursor_page)) {
> > +			if (!locked)
> > +				spin_unlock_irqrestore(&zone->lock, flags);
> > +			continue;
> > +		}
> > +
> > +		if (!locked)
> > +			spin_unlock_irqrestore(&zone->lock, flags);
> 
> spin_unlock in three spaces is ugly.  How about adding a flag that holds the
> result of the function which you use as for loop condition and you set it to
> false inside an additional else clause?  Eg.:
> 
> 	bool result = true;
> 	for (...; result && cursor_page <= end_page; ...) {
> 		...
> 		if (!pfn_valid_within(pfn)) continue;
> 		if (page_zone(cursor_page) != zone) return false;
> 		if (!locked) spin_lock_irqsave(...);
> 		
> 		if (PageBuddy(...)) {
> 			...
> 		} else if (page_count(cursor_page) == 0 ||
> 			   PageLRU(cursor_page)) {
> 			...
> 		} else {
> 			result = false;
> 		}
> 		if (!locked) spin_unlock_irqsave(...);
> 	}
> 	return result;

Thanks, I'll use the hint (if still applicable) in the next patch version.

> > +		return false;
> > +	}
> > +
> > +	return true;
> > +}
> 
> How do you make sure that a page is not allocated while this runs?  Or you just
> don't care?  Not that even with zone lock, page may be allocated from pcp list
> on (another) CPU.

Ok, I see the issue (i.e. pcp page can be returned by rmqueue_bulk() in
buffered_rmqueue() and its page count will be increased in prep_new_page()
a bit later with zone lock dropped so while we may not see the page as
"bad" one in can_rescue_unmovable_pageblock() it may end up as unmovable
one in a pageblock that was just changed to MIGRATE_MOVABLE type).

It is basically similar problem to page allocation vs alloc_contig_range()
races present in CMA [*] so we may deal with it in a similar manner as
CMA: isolate pageblock so no new allocations will be allowed from it,
check if we can do pageblock transition to MIGRATE_MOVABLE type and do
it if so, drain pcp lists, check if the transition was successful and
if there are some pages that slipped through just revert the operation..

However I worry that this still won't cover all races as we can have
some page in "transient state" (no longer on pcp list but not yet used,
simply still being processed by buffered_rmqueue() while we count it
as "good" one in the pageblock transition verification code)?

[*] BTW please see http://marc.info/?l=linux-mm&m=133775797022645&w=2
for CMA related fixes

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center
