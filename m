Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab1E3PYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 11:24:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:59838 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab1E3PYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 11:24:54 -0400
Date: Mon, 30 May 2011 17:24:50 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] mm: compaction: fix special case -1 order checks
Message-ID: <20110530152450.GH20166@tiehlicka.suse.cz>
References: <20110530123831.GG20166@tiehlicka.suse.cz>
 <20110530151633.GB1505@barrios-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110530151633.GB1505@barrios-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 31-05-11 00:16:33, Minchan Kim wrote:
> >  	/* Direct compactor: Is a suitable page free? */
> >  	for (order = cc->order; order < MAX_ORDER; order++) {
> >  		/* Job done if page is free of the right migratetype */
> 
> It looks good to me.
> Let's think about another place, compaction_suitable.

Good spotted.

> It has same problem so we can move the check right before zone_watermark_ok.
> As I look it more, I thought we need free pages for compaction so we would 
> be better to give up early if we can't get enough free pages. But I changed
> my mind. It's a totally user request and we can get free pages in migration
> progress(ex, other big memory hogger might free his big rss). 
> So my conclusion is that we should do *best effort* than early give up.

Agreed

> If you agree with me, how about resending patch with compaction_suitable fix?

Here we go. Thanks

---
mm: compaction: fix special case -1 order checks

56de7263 (mm: compaction: direct compact when a high-order allocation
fails) introduced a check for cc->order == -1 in compact_finished. We
should continue compacting in that case because the request came from
userspace and there is no particular order to compact for.
Similar check has been added by 82478fb7 (mm: compaction:
prevent division-by-zero during user-requested compaction) for
compaction_suitable.

The check is, however, done after zone_watermark_ok which uses order as
a right hand argument for shifts. Not only watermark check is pointless
if we can break out without it but it also uses 1 << -1 which is not
well defined (at least from C standard). Let's move the -1 check above
zone_watermark_ok.

[Minchan Kim <minchan.kim@gmail.com> - caught compaction_suitable]
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
---
 compaction.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)
Index: linus_tree/mm/compaction.c
===================================================================
--- linus_tree.orig/mm/compaction.c	2011-05-30 14:19:58.000000000 +0200
+++ linus_tree/mm/compaction.c	2011-05-30 17:16:02.000000000 +0200
@@ -420,13 +420,6 @@ static int compact_finished(struct zone
 	if (cc->free_pfn <= cc->migrate_pfn)
 		return COMPACT_COMPLETE;
 
-	/* Compaction run is not finished if the watermark is not met */
-	watermark = low_wmark_pages(zone);
-	watermark += (1 << cc->order);
-
-	if (!zone_watermark_ok(zone, cc->order, watermark, 0, 0))
-		return COMPACT_CONTINUE;
-
 	/*
 	 * order == -1 is expected when compacting via
 	 * /proc/sys/vm/compact_memory
@@ -434,6 +427,13 @@ static int compact_finished(struct zone
 	if (cc->order == -1)
 		return COMPACT_CONTINUE;
 
+	/* Compaction run is not finished if the watermark is not met */
+	watermark = low_wmark_pages(zone);
+	watermark += (1 << cc->order);
+
+	if (!zone_watermark_ok(zone, cc->order, watermark, 0, 0))
+		return COMPACT_CONTINUE;
+
 	/* Direct compactor: Is a suitable page free? */
 	for (order = cc->order; order < MAX_ORDER; order++) {
 		/* Job done if page is free of the right migratetype */
@@ -461,6 +461,13 @@ unsigned long compaction_suitable(struct
 	unsigned long watermark;
 
 	/*
+	 * order == -1 is expected when compacting via
+	 * /proc/sys/vm/compact_memory
+	 */
+	if (order == -1)
+		return COMPACT_CONTINUE;
+
+	/*
 	 * Watermarks for order-0 must be met for compaction. Note the 2UL.
 	 * This is because during migration, copies of pages need to be
 	 * allocated and for a short time, the footprint is higher
@@ -470,13 +477,6 @@ unsigned long compaction_suitable(struct
 		return COMPACT_SKIPPED;
 
 	/*
-	 * order == -1 is expected when compacting via
-	 * /proc/sys/vm/compact_memory
-	 */
-	if (order == -1)
-		return COMPACT_CONTINUE;
-
-	/*
 	 * fragmentation index determines if allocation failures are due to
 	 * low memory or external fragmentation
 	 *

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
