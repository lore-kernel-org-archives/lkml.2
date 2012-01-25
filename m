Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab2AYQVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 11:21:17 -0500
Received: from gir.skynet.ie ([193.1.99.77]:42542 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab2AYQVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 11:21:16 -0500
Date: Wed, 25 Jan 2012 16:21:13 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, lkml <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [PATCH v2 -mm 3/3] mm: only defer compaction for failed order
 and higher
Message-ID: <20120125162112.GF3901@csn.ul.ie>
References: <20120124131822.4dc03524@annuminas.surriel.com>
 <20120124132332.0c18d346@annuminas.surriel.com>
 <20120125154108.GD3901@csn.ul.ie>
 <4F2025D9.9050409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4F2025D9.9050409@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 10:55:05AM -0500, Rik van Riel wrote:
> On 01/25/2012 10:41 AM, Mel Gorman wrote:
> 
> >>--- a/mm/compaction.c
> >>+++ b/mm/compaction.c
> >>@@ -673,9 +673,18 @@ static int __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
> >>  		INIT_LIST_HEAD(&cc->freepages);
> >>  		INIT_LIST_HEAD(&cc->migratepages);
> >>
> >>-		if (cc->order<  0 || !compaction_deferred(zone))
> >>+		if (cc->order<  0 || !compaction_deferred(zone, cc->order))
> >>  			compact_zone(zone, cc);
> >>
> >>+		if (cc->order>  0) {
> >>+			int ok = zone_watermark_ok(zone, cc->order,
> >>+						low_wmark_pages(zone), 0, 0);
> >>+			if (ok&&  cc->order>  zone->compact_order_failed)
> >>+				zone->compact_order_failed = cc->order + 1;
> >>+			else if (!ok&&  cc->sync)
> >>+				defer_compaction(zone, cc->order);
> >>+		}
> >>+
> >
> >That needs a comment. I think what you're trying to do is reset
> >compat_order_failed once compaction is successful.
> >
> >The "!ok&&  cc->sync" check may be broken. __compact_pgdat() is
> >called from kswapd, not direct compaction so cc->sync will not be true.
> 
> The problem with doing that is that we would be deferring
> synchronous compaction (by allocators), just because
> asynchronous compaction from kswapd failed...
> 

I should have been clear. I was not suggesting that we defer compaction
here for !cc->sync. I was pointing out that the code as-is is dead.

> That is the reason the code is like it is above.  And
> indeed, it will not defer compaction from this code path
> right now.
> 

Ok, that was my understanding, I just wanted to be sure I understood
your intentions.

> Then again, neither does async compaction from page
> allocators defer compaction - only sync compaction does.
> 

Yep, this is on purpose.

> If it turns out we need a separate compaction deferral
> for async compaction, we can always introduce that later,
> and this code will be ready for it.
> 

Ok, I can accept that.

> If you prefer, I can replace the whole "else if" bit with
> a big fat comment explaining why we cannot currently
> defer compaction from this point.
> 

Explaining that it is dead code for kswapd would also do.

If you do replace the code, add a WARN_ON(cc->sync) in case the
assumption changes in the future so defer_compaction() gets thought
about properly.

-- 
Mel Gorman
SUSE Labs
