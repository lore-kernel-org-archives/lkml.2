Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0IAMlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 08:41:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab0IAMlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 08:41:44 -0400
Date: Wed, 1 Sep 2010 14:41:38 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>
Subject: Re: [PATCH] Make is_mem_section_removable more conformable with
 offlining code
Message-ID: <20100901124138.GD6663@tiehlicka.suse.cz>
References: <20100820141400.GD4636@tiehlicka.suse.cz>
 <20100822004232.GA11007@localhost>
 <20100823092246.GA25772@tiehlicka.suse.cz>
 <20100831141942.GA30353@localhost>
 <20100901121951.GC6663@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100901121951.GC6663@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 01-09-10 14:19:51, Michal Hocko wrote:
> On Tue 31-08-10 22:19:42, Wu Fengguang wrote:
> > On Mon, Aug 23, 2010 at 05:22:46PM +0800, Michal Hocko wrote:
> > > On Sun 22-08-10 08:42:32, Wu Fengguang wrote:
> > > > Hi Michal,
> > > 
> > > Hi,
> > > 
> > > > 
> > > > It helps to explain in changelog/code
> > > > 
> > > > - in what situation a ZONE_MOVABLE will contain !MIGRATE_MOVABLE
> > > >   pages? 
> > > 
> > > page can be MIGRATE_RESERVE IIUC.
> > 
> > Yup, it may also be set to MIGRATE_ISOLATE by soft_offline_page().
> 
> Doesn't it make sense to check for !MIGRATE_UNMOVABLE then?

Something like the following patch.


>From de85f1aa42115678d3340f0448cd798577036496 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 20 Aug 2010 15:39:16 +0200
Subject: [PATCH] Make is_mem_section_removable more conformable with offlining code

Currently is_mem_section_removable checks whether each pageblock from
the given pfn range is of MIGRATE_MOVABLE type or if it is free. If both
are false then the range is considered non removable.

On the other hand, offlining code (more specifically
set_migratetype_isolate) doesn't care whether a page is free and instead
it just checks the migrate type of the page and whether the page's zone
is movable.

This can lead into a situation when we can mark a node as not removable
just because a pageblock is MIGRATE_RESERVE and it is not free.

Let's make a common helper is_page_removable which unifies both tests
at one place. Also let's check for MIGRATE_UNMOVABLE rather than all
possible MIGRATEable types.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/mmzone.h |   26 ++++++++++++++++++++++++++
 mm/memory_hotplug.c    |   19 +------------------
 mm/page_alloc.c        |    5 +----
 3 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6e6e626..7aaa272 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -669,6 +669,32 @@ unsigned long __init node_memmap_size_bytes(int, unsigned long, unsigned long);
  */
 #define zone_idx(zone)		((zone) - (zone)->zone_pgdat->node_zones)
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+/*
+ * A free page on the buddy free lists (not the per-cpu lists) has PageBuddy
+ * set and the size of the free page is given by page_order(). Using this,
+ * the function determines if the pageblock contains only free pages.
+ * Due to buddy contraints, a free page at least the size of a pageblock will
+ * be located at the start of the pageblock
+ */
+static inline int pageblock_free(struct page *page)
+{
+	return PageBuddy(page) && page_order(page) >= pageblock_order;
+}
+
+/*
+ * A free pageblock or the one which is movable or reclaimable is
+ * considered to be removable
+ */
+static inline bool is_page_removable(struct page *page)
+{
+	return get_pageblock_migratetype(page) != MIGRATE_UNMOVABLE
+		|| pageblock_free(page);
+}
+#else
+#define is_page_removable(p) 0
+#endif
+
 static inline int populated_zone(struct zone *zone)
 {
 	return (!!zone->present_pages);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a4cfcdc..66195b8 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -569,17 +569,6 @@ out:
 EXPORT_SYMBOL_GPL(add_memory);
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-/*
- * A free page on the buddy free lists (not the per-cpu lists) has PageBuddy
- * set and the size of the free page is given by page_order(). Using this,
- * the function determines if the pageblock contains only free pages.
- * Due to buddy contraints, a free page at least the size of a pageblock will
- * be located at the start of the pageblock
- */
-static inline int pageblock_free(struct page *page)
-{
-	return PageBuddy(page) && page_order(page) >= pageblock_order;
-}
 
 /* Return the start of the next active pageblock after a given page */
 static struct page *next_active_pageblock(struct page *page)
@@ -608,13 +597,7 @@ int is_mem_section_removable(unsigned long start_pfn, unsigned long nr_pages)
 
 	/* Check the starting page of each pageblock within the range */
 	for (; page < end_page; page = next_active_pageblock(page)) {
-		type = get_pageblock_migratetype(page);
-
-		/*
-		 * A pageblock containing MOVABLE or free pages is considered
-		 * removable
-		 */
-		if (type != MIGRATE_MOVABLE && !pageblock_free(page))
+		if (!is_page_removable(page))
 			return 0;
 
 		/*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a9649f4..c2e2576 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5277,14 +5277,11 @@ int set_migratetype_isolate(struct page *page)
 	struct memory_isolate_notify arg;
 	int notifier_ret;
 	int ret = -EBUSY;
-	int zone_idx;
 
 	zone = page_zone(page);
-	zone_idx = zone_idx(zone);
 
 	spin_lock_irqsave(&zone->lock, flags);
-	if (get_pageblock_migratetype(page) == MIGRATE_MOVABLE ||
-	    zone_idx == ZONE_MOVABLE) {
+	if (is_page_removable(page)) {
 		ret = 0;
 		goto out;
 	}
-- 
1.7.1


-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
