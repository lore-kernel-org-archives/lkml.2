Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab0IRTvj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:51:39 -0400
Received: from kroah.org ([198.145.64.141]:51426 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396Ab0IRTBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:45 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:57 2010
Message-Id: <20100918185957.528292144@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: [055/123] memory hotplug: fix next block calculation in is_removable
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=memory-hotplug-fix-next-block-calculation-in-is_removable.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory_hotplug.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -551,19 +551,19 @@ static inline int pageblock_free(struct
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


