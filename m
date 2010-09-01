Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab0IABYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 21:24:47 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48557 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab0IABYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 21:24:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 1 Sep 2010 10:19:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Michal Hocko <mhocko@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>
Subject: Re: [PATCH] Make is_mem_section_removable more conformable with
 offlining code
Message-Id: <20100901101935.c2fedfe4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100831143649.GA31730@localhost>
References: <20100820141400.GD4636@tiehlicka.suse.cz>
	<20100822004232.GA11007@localhost>
	<20100823092246.GA25772@tiehlicka.suse.cz>
	<20100831141942.GA30353@localhost>
	<20100831143649.GA31730@localhost>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Aug 2010 22:36:49 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Tue, Aug 31, 2010 at 10:19:42PM +0800, Wu Fengguang wrote:
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
> Ah a non-movable page allocation could fall back into the movable
> zone. See __rmqueue_fallback() and the fallbacks[][] array. So the
> 
>         if (type != MIGRATE_MOVABLE && !pageblock_free(page))
> 
> check in is_mem_section_removable() is correct. It is
> set_migratetype_isolate() that should be fixed to use the same check.
> 

Here is a patch for set_migratetype_isolate(). This is not a _fix_ but an
improvement.

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

At memory hotplug, we set pageblock's movable-type as ISOLATE. At failure,
we make it back to be MOVABLE. So,
	- pageblock's type shoule be movable before isolation.
	- pageblock's contents should be really movable before isolation.

Add document about it and add pageblock_free() call for fast-path.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/mmzone.h |    4 ++++
 mm/memory_hotplug.c    |    2 +-
 mm/page_alloc.c        |   17 +++++++++++++----
 3 files changed, 18 insertions(+), 5 deletions(-)

Index: mmotm-0827/mm/page_alloc.c
===================================================================
--- mmotm-0827.orig/mm/page_alloc.c
+++ mmotm-0827/mm/page_alloc.c
@@ -5282,19 +5282,28 @@ int set_migratetype_isolate(struct page 
 	unsigned long immobile = 0;
 	struct memory_isolate_notify arg;
 	int notifier_ret;
-	int ret = -EBUSY;
+	int ret = 0;
 	int zone_idx;
 
 	zone = page_zone(page);
 	zone_idx = zone_idx(zone);
 
 	spin_lock_irqsave(&zone->lock, flags);
+	/*
+	 * At failure of hotplug, we turns this block to be MOVABLE if
+	 * isolation has been successfully done. So, if page-block is movable
+	 * or freed, we can try this without check contents..
+	 */
 	if (get_pageblock_migratetype(page) == MIGRATE_MOVABLE ||
-	    zone_idx == ZONE_MOVABLE) {
-		ret = 0;
+	    pageblock_free(page) ||
+	    zone_idx == ZONE_MOVABLE)
 		goto out;
-	}
 
+	ret = -EBUSY;
+	/*
+	 * check contents, because we move this pageblocks type to be MOVABLE
+	 * at failure, the contents should be movable.
+	 */
 	pfn = page_to_pfn(page);
 	arg.start_pfn = pfn;
 	arg.nr_pages = pageblock_nr_pages;
Index: mmotm-0827/include/linux/mmzone.h
===================================================================
--- mmotm-0827.orig/include/linux/mmzone.h
+++ mmotm-0827/include/linux/mmzone.h
@@ -54,6 +54,10 @@ static inline int get_pageblock_migratet
 	return get_pageblock_flags_group(page, PB_migrate, PB_migrate_end);
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+extern int pageblock_free(struct page *page);
+#endif
+
 struct free_area {
 	struct list_head	free_list[MIGRATE_TYPES];
 	unsigned long		nr_free;
Index: mmotm-0827/mm/memory_hotplug.c
===================================================================
--- mmotm-0827.orig/mm/memory_hotplug.c
+++ mmotm-0827/mm/memory_hotplug.c
@@ -576,7 +576,7 @@ EXPORT_SYMBOL_GPL(add_memory);
  * Due to buddy contraints, a free page at least the size of a pageblock will
  * be located at the start of the pageblock
  */
-static inline int pageblock_free(struct page *page)
+int pageblock_free(struct page *page)
 {
 	return PageBuddy(page) && page_order(page) >= pageblock_order;
 }

