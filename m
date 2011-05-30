Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab1E3Mih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:38:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab1E3Mig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:38:36 -0400
Date: Mon, 30 May 2011 14:38:31 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: fix special case -1 order check in compact_finished
Message-ID: <20110530123831.GG20166@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

56de7263 (mm: compaction: direct compact when a high-order allocation
fails) introduced a check for cc->order == -1 in compact_finished. We
should continue compacting in that case because the request came from
userspace and there is no particular order to compact for.

The check is, however, done after zone_watermark_ok which uses order as
a right hand argument for shifts. Not only watermark check is pointless
if we can break out without it but it also uses 1 << -1 which is not
well defined (at least from C standard). Let's move the -1 check above
zone_watermark_ok.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
---
 compaction.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)
Index: linus_tree/mm/compaction.c
===================================================================
--- linus_tree.orig/mm/compaction.c	2011-05-30 14:19:58.000000000 +0200
+++ linus_tree/mm/compaction.c	2011-05-30 14:20:40.000000000 +0200
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
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
