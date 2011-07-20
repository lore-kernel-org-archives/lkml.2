Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab1GTKs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 06:48:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab1GTKsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 06:48:55 -0400
Date: Wed, 20 Jul 2011 11:48:47 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        P?draig Brady <P@draigBrady.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Colin King <colin.king@canonical.com>,
        Andrew Lutomirski <luto@mit.edu>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] mm: vmscan: Only read new_classzone_idx from pgdat
 when reclaiming successfully
Message-ID: <20110720104847.GI5349@suse.de>
References: <1308926697-22475-1-git-send-email-mgorman@suse.de>
 <1308926697-22475-5-git-send-email-mgorman@suse.de>
 <20110719160903.GA2978@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110719160903.GA2978@barrios-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 01:09:03AM +0900, Minchan Kim wrote:
> Hi Mel,
> 
> Too late review.

Never too late.

> At that time, I had no time to look into this patch.
> 
> On Fri, Jun 24, 2011 at 03:44:57PM +0100, Mel Gorman wrote:
> > During allocator-intensive workloads, kswapd will be woken frequently
> > causing free memory to oscillate between the high and min watermark.
> > This is expected behaviour.  Unfortunately, if the highest zone is
> > small, a problem occurs.
> > 
> > When balance_pgdat() returns, it may be at a lower classzone_idx than
> > it started because the highest zone was unreclaimable. Before checking
> 
> Yes.
> 
> > if it should go to sleep though, it checks pgdat->classzone_idx which
> > when there is no other activity will be MAX_NR_ZONES-1. It interprets
> 
> Yes.
> 
> > this as it has been woken up while reclaiming, skips scheduling and
> 
> Hmm. I can't understand this part.
> If balance_pgdat returns lower classzone and there is no other activity,
> new_classzone_idx is always MAX_NR_ZONES - 1 so that classzone_idx would be less than
> new_classzone_idx. It means it doesn't skip scheduling.
> 
> Do I miss something?
> 

It was a few weeks ago so I don't rememember if this is the exact
sequence I had in mind at the time of writing but an example sequence
of events is for a node whose highest populated zone is ZONE_NORMAL,
very small, and gets set all_unreclaimable by balance_pgdat() looks
is below. The key is the "very small" part because pages are getting
freed in the zone but the small size means that unreclaimable gets
set easily.

/*
 * kswapd is woken up for ZONE_NORMAL (as this is the preferred zone
 * as ZONE_HIGHMEM is not populated.
 */

order = pgdat->kswapd_max_order;
classzone_idx = pgdat->classzone_idx;				/* classzone_idx == ZONE_NORMAL */
pgdat->kswapd_max_order = 0;
pgdat->classzone_idx = MAX_NR_ZONES - 1;
order = balance_pgdat(pgdat, order, &classzone_idx);		/* classzone_idx == ZONE_NORMAL even though
								 * the highest zone was set unreclaimable
								 * and it exited scanning ZONE_DMA32
								 * because we did not communicate that
								 * information back
								 */
new_order = pgdat->kswapd_max_order;				/* new_order = 0 */
new_classzone_idx = pgdat->classzone_idx;			/* new_classzone_idx == ZONE_HIGHMEM
								 * because that is what classzone_idx
								 * gets reset to
								 */
if (order < new_order || classzone_idx > new_classzone_idx) {
	/* does not sleep, this branch not taken */
} else {
	/* tries to sleep, goes here */
	try_to_sleep(ZONE_NORMAL)
		sleeping_prematurely(ZONE_NORMAL)		/* finds zone unbalanced so skips scheduling */
        order = pgdat->kswapd_max_order;
        classzone_idx = pgdat->classzone_idx;			/* classzone_idx == ZONE_HIGHMEM now which
								 * is higher than what it was originally
								 * woken for
								 */
}

/* Looped around to balance_pgdat() again */
order = balance_pgdat()

Between when all_unreclaimable is set and before before kswapd
goes fully to sleep, a page is freed clearing all_reclaimable so
it rechecks all the zones, find the highest one is not balanced and
skip scheduling.

A variation is that it the lower zones are above the low watermark so
the page allocator is not waking kswapd and it should sleep on the
waitqueue. However, it only schedules for HZ/10 during which a page
is freed, the highest zone gets all_unreclaimable cleared and so it
stays awake. In this case, it has reached a scheduling point but it
is not going fully to sleep on the waitqueue as it should.

I see now the problem with the changelog, it sucks and could have
been a lot better at explaining why kswapd stays awake when the
information is not communicated back and why classzone_idx being set
to MAX_NR_ZONES-1 is sloppy :(

-- 
Mel Gorman
SUSE Labs
