Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2G3Rcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:32:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38517 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab2G3Rcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:32:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>
Subject: [ 09/41] mm: reduce the amount of work done when updating min_free_kbytes
Date: Mon, 30 Jul 2012 10:31:08 -0700
Message-Id: <20120730172902.043408198@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120730172901.306897424@linuxfoundation.org>
References: <20120730172901.306897424@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 938929f14cb595f43cd1a4e63e22d36cab1e4a1f upstream.

Stable note: Fixes https://bugzilla.novell.com/show_bug.cgi?id=726210 .
        Large machines with 1TB or more of RAM take a long time to boot
        without this patch and may spew out soft lockup warnings.

When min_free_kbytes is updated, some pageblocks are marked
MIGRATE_RESERVE.  Ordinarily, this work is unnoticable as it happens early
in boot but on large machines with 1TB of memory, this has been reported
to delay boot times, probably due to the NUMA distances involved.

The bulk of the work is due to calling calling pageblock_is_reserved() an
unnecessary amount of times and accessing far more struct page metadata
than is necessary.  This patch significantly reduces the amount of work
done by setup_zone_migrate_reserve() improving boot times on 1TB machines.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |   40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3418,25 +3418,33 @@ static void setup_zone_migrate_reserve(s
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
+			/*
+			 * Blocks with reserved pages will never free, skip
+			 * them.
+			 */
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
+				set_pageblock_migratetype(page,
+							MIGRATE_RESERVE);
+				move_freepages_block(zone, page,
+							MIGRATE_RESERVE);
+				reserve--;
+				continue;
+			}
 		}
 
 		/*


