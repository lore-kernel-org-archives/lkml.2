Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab0KSIWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 03:22:32 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47489 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0KSIWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 03:22:31 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 19 Nov 2010 17:16:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        minchan.kim@gmail.com, Bob Liu <lliubbo@gmail.com>,
        fujita.tomonori@lab.ntt.co.jp, m.nazarewicz@samsung.com,
        pawel@osciak.com, andi.kleen@intel.com, felipe.contreras@gmail.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 4/4] alloc_contig_pages() use better allocation function for
 migration
Message-Id: <20101119171653.3c476064.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101119171033.a8d9dc8f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101119171033.a8d9dc8f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Old story.
Because we cannot assume which memory section will be offlined next,
hotremove_migrate_alloc() just uses alloc_page(). i.e. make no decision
where the page should be migrate into. Considering memory hotplug's
nature, the next memory section near to a section which is being removed
will be removed in the next. So, migrate pages to the same node of original
page doesn't make sense in many case, it just increases load.
Migration destination page is allocated from the node where offlining script
runs.

Now, contiguous-alloc uses do_migrate_range(). In this case, migration
destination node should be the same node of migration source page.

This patch modifies hotremove_migrate_alloc() and pass "nid" to it.
Memory hotremove will pass -1. So, if the page will be moved to
the node where offlining script runs....no behavior changes.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/page-isolation.h |    3 ++-
 mm/memory_hotplug.c            |    2 +-
 mm/page_isolation.c            |   21 ++++++++++++++++-----
 3 files changed, 19 insertions(+), 7 deletions(-)

Index: mmotm-1117/include/linux/page-isolation.h
===================================================================
--- mmotm-1117.orig/include/linux/page-isolation.h
+++ mmotm-1117/include/linux/page-isolation.h
@@ -41,7 +41,8 @@ extern void alloc_contig_freed_pages(uns
 
 int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn);
 unsigned long scan_lru_pages(unsigned long start, unsigned long end);
-int do_migrate_range(unsigned long start_pfn, unsigned long end_pfn);
+int do_migrate_range(unsigned long start_pfn,
+	unsigned long end_pfn, int node);
 
 /*
  * For large alloc.
Index: mmotm-1117/mm/memory_hotplug.c
===================================================================
--- mmotm-1117.orig/mm/memory_hotplug.c
+++ mmotm-1117/mm/memory_hotplug.c
@@ -724,7 +724,7 @@ repeat:
 
 	pfn = scan_lru_pages(start_pfn, end_pfn);
 	if (pfn) { /* We have page on LRU */
-		ret = do_migrate_range(pfn, end_pfn);
+		ret = do_migrate_range(pfn, end_pfn, numa_node_id());
 		if (!ret) {
 			drain = 1;
 			goto repeat;
Index: mmotm-1117/mm/page_isolation.c
===================================================================
--- mmotm-1117.orig/mm/page_isolation.c
+++ mmotm-1117/mm/page_isolation.c
@@ -193,12 +193,21 @@ unsigned long scan_lru_pages(unsigned lo
 struct page *
 hotremove_migrate_alloc(struct page *page, unsigned long private, int **x)
 {
-	/* This should be improooooved!! */
-	return alloc_page(GFP_HIGHUSER_MOVABLE);
+	return alloc_pages_node(private, GFP_HIGHUSER_MOVABLE, 0);
 }
 
+/*
+ * Migrate pages in the range to somewhere. Migration target page is allocated
+ * by hotremove_migrate_alloc(). If on_node is specicied, new page will be
+ * selected from nearby nodes. At hotremove, this "allocate from near node"
+ * can be harmful because we may remove other pages in the node for removing
+ * more pages in node. contiguous_alloc() uses on_node=true for avoiding
+ * unnecessary migration to far node.
+ */
+
 #define NR_OFFLINE_AT_ONCE_PAGES	(256)
-int do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
+int do_migrate_range(unsigned long start_pfn, unsigned long end_pfn,
+		int node)
 {
 	unsigned long pfn;
 	struct page *page;
@@ -245,7 +254,7 @@ int do_migrate_range(unsigned long start
 			goto out;
 		}
 		/* this function returns # of failed pages */
-		ret = migrate_pages(&source, hotremove_migrate_alloc, 0, 1);
+		ret = migrate_pages(&source, hotremove_migrate_alloc, node, 1);
 		if (ret)
 			putback_lru_pages(&source);
 	}
@@ -463,6 +472,7 @@ struct page *__alloc_contig_pages(unsign
 	struct zonelist *zonelist;
 	enum zone_type highzone_idx = gfp_zone(gfpflag);
 	unsigned long zone_start, zone_end, rs, re, pos;
+	int target_node;
 
 	if (node == -1)
 		node = numa_node_id();
@@ -516,6 +526,7 @@ retry:
 	if (!zone)
 		return NULL;
 
+	target_node = zone->zone_pgdat->node_id;
 	zone_start = ALIGN(zone->zone_start_pfn, 1 << align_order);
 	zone_end = zone->zone_start_pfn + zone->spanned_pages;
 
@@ -548,7 +559,7 @@ next_zone:
 	for (rs = scan_lru_pages(rs, re);
 	     rs && rs < re;
 	     rs = scan_lru_pages(rs, re)) {
-		int rc = do_migrate_range(rs, re);
+		int rc = do_migrate_range(rs, re, target_node);
 		if (!rc)
 			migration_failed = 0;
 		else {

