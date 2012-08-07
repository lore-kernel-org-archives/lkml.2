Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab2HGDr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:47:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59779 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757383Ab2HGDik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:40 -0400
Message-Id: <20120807032803.926064645@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, rajman mekaco <rajman.mekaco@gmail.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Minchan Kim <minchan.kim@gmail.com>
Subject: [ 54/70] mm/page_alloc.c: remove pageblock_default_order()
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 955c1cd7401565671b064e499115344ec8067dfd upstream.

This has always been broken: one version takes an unsigned int and the
other version takes no arguments.  This bug was hidden because one
version of set_pageblock_order() was a macro which doesn't evaluate its
argument.

Simplify it all and remove pageblock_default_order() altogether.

Reported-by: rajman mekaco <rajman.mekaco@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/page_alloc.c |   33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8d71ad8..84f2c59 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4300,25 +4300,24 @@ static inline void setup_usemap(struct pglist_data *pgdat,
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
-/* Return a sensible default order for the pageblock size. */
-static inline int pageblock_default_order(void)
-{
-	if (HPAGE_SHIFT > PAGE_SHIFT)
-		return HUGETLB_PAGE_ORDER;
-
-	return MAX_ORDER-1;
-}
-
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
-static inline void __init set_pageblock_order(unsigned int order)
+static inline void __init set_pageblock_order(void)
 {
+	unsigned int order;
+
 	/* Check that pageblock_nr_pages has not already been setup */
 	if (pageblock_order)
 		return;
 
+	if (HPAGE_SHIFT > PAGE_SHIFT)
+		order = HUGETLB_PAGE_ORDER;
+	else
+		order = MAX_ORDER - 1;
+
 	/*
 	 * Assume the largest contiguous order of interest is a huge page.
-	 * This value may be variable depending on boot parameters on IA64
+	 * This value may be variable depending on boot parameters on IA64 and
+	 * powerpc.
 	 */
 	pageblock_order = order;
 }
@@ -4326,15 +4325,13 @@ static inline void __init set_pageblock_order(unsigned int order)
 
 /*
  * When CONFIG_HUGETLB_PAGE_SIZE_VARIABLE is not set, set_pageblock_order()
- * and pageblock_default_order() are unused as pageblock_order is set
- * at compile-time. See include/linux/pageblock-flags.h for the values of
- * pageblock_order based on the kernel config
+ * is unused as pageblock_order is set at compile-time. See
+ * include/linux/pageblock-flags.h for the values of pageblock_order based on
+ * the kernel config
  */
-static inline int pageblock_default_order(unsigned int order)
+static inline void set_pageblock_order(void)
 {
-	return MAX_ORDER-1;
 }
-#define set_pageblock_order(x)	do {} while (0)
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
@@ -4422,7 +4419,7 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 		if (!size)
 			continue;
 
-		set_pageblock_order(pageblock_default_order());
+		set_pageblock_order();
 		setup_usemap(pgdat, zone, size);
 		ret = init_currently_empty_zone(zone, zone_start_pfn,
 						size, MEMMAP_EARLY);


