Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab2IZGrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 02:47:06 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53803 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2IZGrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 02:47:05 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-4b-5062a4e6dd9d
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Michal Nazarewicz <mina86@mina86.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] CMA: decrease cc.nr_migratepages after reclaiming pagelist
Date: Wed, 26 Sep 2012 15:50:12 +0900
Message-Id: <1348642212-29394-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reclaim_clean_pages_from_list reclaims clean pages before
migration so cc.nr_migratepages should be updated.
Currently, there is no problem but it can be wrong if we
try to use the vaule in future.

Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
I found this problem during I develop new feature. :(

 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 296bea9..4b7dced 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5669,7 +5669,7 @@ static unsigned long pfn_max_align_up(unsigned long pfn)
 static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
 {
 	/* This function is based on compact_zone() from compaction.c. */
-
+	unsigned long nr_reclaimed;
 	unsigned long pfn = start;
 	unsigned int tries = 0;
 	int ret = 0;
@@ -5705,7 +5705,9 @@ static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
 			break;
 		}
 
-		reclaim_clean_pages_from_list(cc.zone, &cc.migratepages);
+		nr_reclaimed = reclaim_clean_pages_from_list(cc.zone,
+							&cc.migratepages);
+		cc.nr_migratepages -= nr_reclaimed;
 
 		ret = migrate_pages(&cc.migratepages,
 				    alloc_migrate_target,
-- 
1.7.9.5

