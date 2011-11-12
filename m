Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1H2Qmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:42:40 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44151 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab1H2Qmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:42:37 -0400
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <jweiner@redhat.com>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 2/3] compaction: compact unevictable page
Date: Sun, 13 Nov 2011 01:37:42 +0900
Message-Id: <8ef02605a7a76b176167d90a285033afa8513326.1321112552.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1321112552.git.minchan.kim@gmail.com>
References: <cover.1321112552.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1321112552.git.minchan.kim@gmail.com>
References: <cover.1321112552.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now compaction doesn't handle mlocked page as it uses __isolate_lru_page
which doesn't consider unevicatable page. It has been used by just lumpy so
it was pointless that it isolates unevictable page. But the situation is
changed. Compaction could handle unevictable page and it can help getting
big contiguos pages in fragment memory by many pinned page with mlock.

I tested this patch with following scenario.

1. A : allocate 80% anon pages in system
2. B : allocate 20% mlocked page in system
/* Maybe, mlocked pages are located in low pfn address */
3. kill A /* high pfn address are free */
4. echo 1 > /proc/sys/vm/compact_memory

old:

compact_blocks_moved 251
compact_pages_moved 44

new:

compact_blocks_moved 258
compact_pages_moved 412

CC: Mel Gorman <mgorman@suse.de>
CC: Johannes Weiner <jweiner@redhat.com>
CC: Rik van Riel <riel@redhat.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 include/linux/mmzone.h |    6 ++++--
 mm/compaction.c        |    3 ++-
 mm/vmscan.c            |    7 +------
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 188cb2f..82b505e 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -169,10 +169,12 @@ static inline int is_unevictable_lru(enum lru_list l)
 #define ISOLATE_INACTIVE	((__force isolate_mode_t)0x1)
 /* Isolate active pages */
 #define ISOLATE_ACTIVE		((__force isolate_mode_t)0x2)
+/* Isolate unevictable pages */
+#define ISOLATE_UNEVICTABLE	((__force isolate_mode_t)0x4)
 /* Isolate clean file */
-#define ISOLATE_CLEAN		((__force isolate_mode_t)0x4)
+#define ISOLATE_CLEAN		((__force isolate_mode_t)0x8)
 /* Isolate unmapped file */
-#define ISOLATE_UNMAPPED	((__force isolate_mode_t)0x8)
+#define ISOLATE_UNMAPPED	((__force isolate_mode_t)0x10)

 /* LRU Isolation modes. */
 typedef unsigned __bitwise__ isolate_mode_t;
diff --git a/mm/compaction.c b/mm/compaction.c
index a0e4202..0e572d1 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -261,7 +261,8 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
	unsigned long last_pageblock_nr = 0, pageblock_nr;
	unsigned long nr_scanned = 0, nr_isolated = 0;
	struct list_head *migratelist = &cc->migratepages;
-	isolate_mode_t mode = ISOLATE_ACTIVE|ISOLATE_INACTIVE;
+	isolate_mode_t mode = ISOLATE_ACTIVE| ISOLATE_INACTIVE |
+				ISOLATE_UNEVICTABLE;

	/* Do not scan outside zone boundaries */
	low_pfn = max(cc->migrate_pfn, zone->zone_start_pfn);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 23256e8..2300342 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1057,12 +1057,7 @@ int __isolate_lru_page(struct page *page, isolate_mode_t mode, int file)
	if (!all_lru_mode && !!page_is_file_cache(page) != file)
		return ret;

-	/*
-	 * When this function is being called for lumpy reclaim, we
-	 * initially look into all LRU pages, active, inactive and
-	 * unevictable; only give shrink_page_list evictable pages.
-	 */
-	if (PageUnevictable(page))
+	if (PageUnevictable(page) && !(mode & ISOLATE_UNEVICTABLE))
		return ret;

	ret = -EBUSY;
--
1.7.6
