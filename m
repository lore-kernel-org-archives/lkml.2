Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab0LERaO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:30:14 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43103 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab0LERaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:30:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=K2lxr8QwhoDkvszhsXtX/gvm6Z8iQDmHhv43wMmnu6Mutv8lpR8sZWa6ri+kIQ7KtG
         dQs9Hnbm46hc1f5DCAY+zNcmV4Oh67Ex20+JvMle9AHx01U3VAVOTOknLE5gbhT7pPfJ
         HqfubwESW4kZBMwtuFFET6HDo9suAomk6EEyQ=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Subject: [PATCH v4 4/7] Reclaim invalidated page ASAP
Date: Mon,  6 Dec 2010 02:29:12 +0900
Message-Id: <0724024711222476a0c8deadb5b366265b8e5824.1291568905.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1291568905.git.minchan.kim@gmail.com>
References: <cover.1291568905.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1291568905.git.minchan.kim@gmail.com>
References: <cover.1291568905.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

invalidate_mapping_pages is very big hint to reclaimer.
It means user doesn't want to use the page any more.
So in order to prevent working set page eviction, this patch
move the page into tail of inactive list by PG_reclaim.

Please, remember that pages in inactive list are working set
as well as active list. If we don't move pages into inactive list's
tail, pages near by tail of inactive list can be evicted although
we have a big clue about useless pages. It's totally bad.

Now PG_readahead/PG_reclaim is shared.
fe3cba17 added ClearPageReclaim into clear_page_dirty_for_io for
preventing fast reclaiming readahead marker page.

In this series, PG_reclaim is used by invalidated page, too.
If VM find the page is invalidated and it's dirty, it sets PG_reclaim
to reclaim asap. Then, when the dirty page will be writeback,
clear_page_dirty_for_io will clear PG_reclaim unconditionally.
It disturbs this serie's goal.

I think it's okay to clear PG_readahead when the page is dirty, not
writeback time. So this patch moves ClearPageReadahead.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Piggin <npiggin@kernel.dk>

Changelog since v3:
 - move page which ends up writeback in pagevec on inactive's tail
	- suggested by Johannes

Changelog since v2:
 - put ClearPageReclaim in set_page_dirty - suggested by Wu.

Changelog since v1:
 - make the invalidated page reclaim asap - suggested by Andrew.
---
 mm/page-writeback.c |   12 +++++++++++-
 mm/swap.c           |   39 ++++++++++++++++++++++++++++++++++++---
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index fc93802..88587a5 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1250,6 +1250,17 @@ int set_page_dirty(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
 
+	/*
+	 * readahead/lru_deactivate_page could remain
+	 * PG_readahead/PG_reclaim due to race with end_page_writeback
+	 * About readahead, if the page is written, the flags would be
+	 * reset. So no problem.
+	 * About lru_deactivate_page, if the page is redirty, the flag
+	 * will be reset. So no problem. but if the page is used by readahead
+	 * it will confuse readahead and  make it restart the size rampup
+	 * process. But it's a trivial problem.
+	 */
+	ClearPageReclaim(page);
 	if (likely(mapping)) {
 		int (*spd)(struct page *) = mapping->a_ops->set_page_dirty;
 #ifdef CONFIG_BLOCK
@@ -1307,7 +1318,6 @@ int clear_page_dirty_for_io(struct page *page)
 
 	BUG_ON(!PageLocked(page));
 
-	ClearPageReclaim(page);
 	if (mapping && mapping_cap_account_dirty(mapping)) {
 		/*
 		 * Yes, Virginia, this is indeed insane.
diff --git a/mm/swap.c b/mm/swap.c
index 0fe98e7..0f23998 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -275,26 +275,59 @@ void add_page_to_unevictable_list(struct page *page)
  * head of the list, rather than the tail, to give the flusher
  * threads some time to write it out, as this is much more
  * effective than the single-page writeout from reclaim.
+ *
+ * If the page isn't page_mapped and dirty/writeback, the page
+ * could reclaim asap using PG_reclaim.
+ *
+ * 1. active, mapped page -> none
+ * 2. active, dirty/writeback page -> inactive, head, PG_reclaim
+ * 3. inactive, mapped page -> none
+ * 4. inactive, dirty/writeback page -> inactive, head, PG_reclaim
+ * 5. Others -> none
+ *
+ * In 4, why it moves inactive's head, the VM expects the page would
+ * be write it out by flusher threads as this is much more effective
+ * than the single-page writeout from reclaim.
  */
 static void lru_deactivate(struct page *page, struct zone *zone)
 {
 	int lru, file;
+	bool active;
 
-	if (!PageLRU(page) || !PageActive(page))
+	if (!PageLRU(page))
 		return;
 
 	/* Some processes are using the page */
 	if (page_mapped(page))
 		return;
 
+	active = PageActive(page);
+
 	file = page_is_file_cache(page);
 	lru = page_lru_base_type(page);
-	del_page_from_lru_list(zone, page, lru + LRU_ACTIVE);
+	del_page_from_lru_list(zone, page, lru + active);
 	ClearPageActive(page);
 	ClearPageReferenced(page);
 	add_page_to_lru_list(zone, page, lru);
-	__count_vm_event(PGDEACTIVATE);
 
+	if (PageWriteback(page) || PageDirty(page)) {
+		/*
+		 * PG_reclaim could be raced with end_page_writeback
+		 * It can make readahead confusing.  But race window
+		 * is _really_ small and  it's non-critical problem.
+		 */
+		SetPageReclaim(page);
+	} else {
+		/*
+		 * The page's writeback ends up during pagevec
+		 * We moves tha page into tail of inactive.
+		 */
+		list_move_tail(&page->lru, &zone->lru[lru].list);
+		mem_cgroup_rotate_reclaimable_page(page);
+	}
+
+	if (active)
+		__count_vm_event(PGDEACTIVATE);
 	update_page_reclaim_stat(zone, page, file, 0);
 }
 
-- 
1.7.0.4

