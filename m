Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab2GWNrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 09:47:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab2GWNiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 09:38:51 -0400
From: Mel Gorman <mgorman@suse.de>
To: Stable <stable@vger.kernel.org>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 03/34] mm: Reduce the amount of work done when updating min_free_kbytes
Date: Mon, 23 Jul 2012 14:38:16 +0100
Message-Id: <1343050727-3045-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1343050727-3045-1-git-send-email-mgorman@suse.de>
References: <1343050727-3045-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 938929f14cb595f43cd1a4e63e22d36cab1e4a1f upstream.

Stable note: Fixes https://bugzilla.novell.com/show_bug.cgi?id=726210 .
	Large machines with 1TB or more of RAM take a long time to boot
	without this patch and may spew out soft lockup warnings.

When min_free_kbytes is updated blocks marked MIGRATE_RESERVE are
updated. Ordinarily, this work is unnoticable as it happens early
in boot. However, on large machines with 1TB of memory, this can take
a considerable time when NUMA distances are taken into account. The bulk
of the work is done by pageblock_is_reserved() which examines the
metadata for almost every page in the system. Currently, we are doing
this far more than necessary as it is only required while there are
still blocks to be marked MIGRATE_RESERVE. This patch significantly
reduces the amount of work done by setup_zone_migrate_reserve()
improving boot times on 1TB machines.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 947a7e9..e568b80 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3418,25 +3418,28 @@ static void setup_zone_migrate_reserve(struct zone *zone)
 		if (page_to_nid(page) != zone_to_nid(zone))
 			continue;
 
-		/* Blocks with reserved pages will never free, skip them. */
-		block_end_pfn = min(pfn + pageblock_nr_pages, end_pfn);
-		if (pageblock_is_reserved(pfn, block_end_pfn))
-			continue;
-
 		block_migratetype = get_pageblock_migratetype(page);
 
-		/* If this block is reserved, account for it */
-		if (reserve > 0 && block_migratetype == MIGRATE_RESERVE) {
-			reserve--;
-			continue;
-		}
+		/* Only test what is necessary when the reserves are not met */
+		if (reserve > 0) {
+			/* Blocks with reserved pages will never free, skip them. */
+			block_end_pfn = min(pfn + pageblock_nr_pages, end_pfn);
+			if (pageblock_is_reserved(pfn, block_end_pfn))
+				continue;
 
-		/* Suitable for reserving if this block is movable */
-		if (reserve > 0 && block_migratetype == MIGRATE_MOVABLE) {
-			set_pageblock_migratetype(page, MIGRATE_RESERVE);
-			move_freepages_block(zone, page, MIGRATE_RESERVE);
-			reserve--;
-			continue;
+			/* If this block is reserved, account for it */
+			if (block_migratetype == MIGRATE_RESERVE) {
+				reserve--;
+				continue;
+			}
+
+			/* Suitable for reserving if this block is movable */
+			if (block_migratetype == MIGRATE_MOVABLE) {
+				set_pageblock_migratetype(page, MIGRATE_RESERVE);
+				move_freepages_block(zone, page, MIGRATE_RESERVE);
+				reserve--;
+				continue;
+			}
 		}
 
 		/*
-- 
1.7.9.2

