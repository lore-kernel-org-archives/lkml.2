Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab0IGBhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 21:37:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49409 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab0IGBhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 21:37:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 7 Sep 2010 10:32:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, fengguang.wu@intel.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, andi.kleen@intel.com,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 1/3] [BUGFIX] memory hotplug: fix next block calculation in
 is_removable
Message-Id: <20100907103244.35eb6b71.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100907102813.d633b8ef.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100906144019.946d3c49.kamezawa.hiroyu@jp.fujitsu.com>
	<20100907102813.d633b8ef.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

next_active_pageblock() is for finding next _used_ freeblock. It skips
several blocks when it finds there are a chunk of free pages lager than
pageblock. But it has 2 bugs.

  1. We have no lock. page_order(page) - pageblock_order can be minus.
  2. pageblocks_stride += is wrong. it should skip page_order(p) of pages.

Changelog: 2010/09/07
 - fix range check of order returned by page_order().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memory_hotplug.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: kametest/mm/memory_hotplug.c
===================================================================
--- kametest.orig/mm/memory_hotplug.c
+++ kametest/mm/memory_hotplug.c
@@ -584,19 +584,19 @@ static inline int pageblock_free(struct 
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

