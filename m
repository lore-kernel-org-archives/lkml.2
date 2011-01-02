Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab1ABH6y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:58:54 -0500
Received: from mail.windriver.com ([147.11.1.11]:35248 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab1ABHXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:02 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 073/260] memory hotplug: fix next block calculation in is_removable
Date: Sun,  2 Jan 2011 02:16:09 -0500
Message-Id: <1293952756-15010-74-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:27.0398 (UTC) FILETIME=[AB56B060:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

commit 0dcc48c15f63ee86c2fcd33968b08d651f0360a5 upstream.

next_active_pageblock() is for finding next _used_ freeblock.  It skips
several blocks when it finds there are a chunk of free pages lager than
pageblock.  But it has 2 bugs.

  1. We have no lock. page_order(page) - pageblock_order can be minus.
  2. pageblocks_stride += is wrong. it should skip page_order(p) of pages.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/memory_hotplug.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index be211a5..91f7c26 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -558,19 +558,19 @@ static inline int pageblock_free(struct page *page)
 /* Return the start of the next active pageblock after a given page */
 static struct page *next_active_pageblock(struct page *page)
 {
-	int pageblocks_stride;
-
 	/* Ensure the starting page is pageblock-aligned */
 	BUG_ON(page_to_pfn(page) & (pageblock_nr_pages - 1));
 
-	/* Move forward by at least 1 * pageblock_nr_pages */
-	pageblocks_stride = 1;
-
 	/* If the entire pageblock is free, move to the end of free page */
-	if (pageblock_free(page))
-		pageblocks_stride += page_order(page) - pageblock_order;
+	if (pageblock_free(page)) {
+		int order;
+		/* be careful. we don't have locks, page_order can be changed.*/
+		order = page_order(page);
+		if ((order < MAX_ORDER) && (order >= pageblock_order))
+			return page + (1 << order);
+	}
 
-	return page + (pageblocks_stride * pageblock_nr_pages);
+	return page + pageblock_nr_pages;
 }
 
 /* Checks if this range of memory is likely to be hot-removable. */
-- 
1.7.3.3

