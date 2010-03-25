Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab0CYJOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 05:14:10 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45616 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab0CYJOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 05:14:08 -0400
Date: Thu, 25 Mar 2010 09:13:49 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 07/11] Memory compaction core
Message-ID: <20100325091349.GI2024@csn.ul.ie>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie> <1269347146-7461-8-git-send-email-mel@csn.ul.ie> <20100324133347.9b4b2789.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100324133347.9b4b2789.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 01:33:47PM -0700, Andrew Morton wrote:
> On Tue, 23 Mar 2010 12:25:42 +0000
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > This patch is the core of a mechanism which compacts memory in a zone by
> > relocating movable pages towards the end of the zone.
> > 
> > A single compaction run involves a migration scanner and a free scanner.
> > Both scanners operate on pageblock-sized areas in the zone. The migration
> > scanner starts at the bottom of the zone and searches for all movable pages
> > within each area, isolating them onto a private list called migratelist.
> > The free scanner starts at the top of the zone and searches for suitable
> > areas and consumes the free pages within making them available for the
> > migration scanner. The pages isolated for migration are then migrated to
> > the newly isolated free pages.
> 
> General comment: it looks like there are some codepaths which could
> hold zone->lock for a long time.  It's unclear that they're all
> constrained by COMPACT_CLUSTER_MAX. Is there a a latency issue here?
> 

I don't think so. There are two points where zone-related locks are
held.

zone->lock is held in isolate_freepages() while it gets the free pages
	necessary for migration to complete. The size of the list of pages
	being migrated is constrained by COMPACT_CLUSTER_MAX so it is bounded
	by that. Worst case scenario is the zone is almost fully
	scanned.

zone->lru_lock is held in isolate_migratepages) while it gets pages for
	migration. It's released if COMPACT_CLUSTER_MAX pages are
	isolated. Again, worst case scenario is that the zone is
	almost fully scanned.

The worst-case scenario in both cases is the lock is held while the zone
is scanned. The concern would be if we managed to scan almost a full
zone and that zone is very large. I could add an additional check to
release the lock when a large number of pages has been scanned but I
don't think it's necessary. I find it very unlikely that a large zone
would not have COMPACT_CLUSTER_MAX pages found quickly for isolation.

> >
> > ...
> >
> > +static struct page *compaction_alloc(struct page *migratepage,
> > +					unsigned long data,
> > +					int **result)
> > +{
> > +	struct compact_control *cc = (struct compact_control *)data;
> > +	struct page *freepage;
> > +
> > +	VM_BUG_ON(cc == NULL);
> 
> It's a bit strange to test this when we're about to oops anyway.  The
> oops will tell us the same thing.
> 

It was paranoia after the bugs related to NULL-offsets but unnecessary
paranoia in this case. It would require migration to be very broken for it to
trigger. Even if it was, I cannot imagine a case where it would be exploited
because it's a small structure and not offset by any userspace-supplied
piece of data. I will drop the check.

> > +	/* Isolate free pages if necessary */
> > +	if (list_empty(&cc->freepages)) {
> > +		isolate_freepages(cc->zone, cc);
> > +
> > +		if (list_empty(&cc->freepages))
> > +			return NULL;
> > +	}
> > +
> > +	freepage = list_entry(cc->freepages.next, struct page, lru);
> > +	list_del(&freepage->lru);
> > +	cc->nr_freepages--;
> > +
> > +	return freepage;
> > +}
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
