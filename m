Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab2G3RdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:33:12 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49202 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab2G3RdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:33:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>
Subject: [ 21/41] mm: migration: clean up unmap_and_move()
Date: Mon, 30 Jul 2012 10:31:20 -0700
Message-Id: <20120730172902.969248664@linuxfoundation.org>
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

From: Minchan Kim <minchan.kim@gmail.com>

commit 0dabec93de633a87adfbbe1d800a4c56cd19d73b upstream.

Stable note: Not tracked in Bugzilla. This patch makes later patches
	easier to apply but has no other impact.

unmap_and_move() is one a big messy function.  Clean it up.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/migrate.c |   75 +++++++++++++++++++++++++++++++----------------------------
 1 file changed, 40 insertions(+), 35 deletions(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -621,38 +621,18 @@ static int move_to_new_page(struct page
 	return rc;
 }
 
-/*
- * Obtain the lock on page, remove all ptes and migrate the page
- * to the newly allocated page in newpage.
- */
-static int unmap_and_move(new_page_t get_new_page, unsigned long private,
-			struct page *page, int force, bool offlining, bool sync)
+static int __unmap_and_move(struct page *page, struct page *newpage,
+				int force, bool offlining, bool sync)
 {
-	int rc = 0;
-	int *result = NULL;
-	struct page *newpage = get_new_page(page, private, &result);
+	int rc = -EAGAIN;
 	int remap_swapcache = 1;
 	int charge = 0;
 	struct mem_cgroup *mem;
 	struct anon_vma *anon_vma = NULL;
 
-	if (!newpage)
-		return -ENOMEM;
-
-	if (page_count(page) == 1) {
-		/* page was freed from under us. So we are done. */
-		goto move_newpage;
-	}
-	if (unlikely(PageTransHuge(page)))
-		if (unlikely(split_huge_page(page)))
-			goto move_newpage;
-
-	/* prepare cgroup just returns 0 or -ENOMEM */
-	rc = -EAGAIN;
-
 	if (!trylock_page(page)) {
 		if (!force || !sync)
-			goto move_newpage;
+			goto out;
 
 		/*
 		 * It's not safe for direct compaction to call lock_page.
@@ -668,7 +648,7 @@ static int unmap_and_move(new_page_t get
 		 * altogether.
 		 */
 		if (current->flags & PF_MEMALLOC)
-			goto move_newpage;
+			goto out;
 
 		lock_page(page);
 	}
@@ -785,27 +765,52 @@ uncharge:
 		mem_cgroup_end_migration(mem, page, newpage, rc == 0);
 unlock:
 	unlock_page(page);
+out:
+	return rc;
+}
+
+/*
+ * Obtain the lock on page, remove all ptes and migrate the page
+ * to the newly allocated page in newpage.
+ */
+static int unmap_and_move(new_page_t get_new_page, unsigned long private,
+			struct page *page, int force, bool offlining, bool sync)
+{
+	int rc = 0;
+	int *result = NULL;
+	struct page *newpage = get_new_page(page, private, &result);
+
+	if (!newpage)
+		return -ENOMEM;
 
-move_newpage:
+	if (page_count(page) == 1) {
+		/* page was freed from under us. So we are done. */
+		goto out;
+	}
+
+	if (unlikely(PageTransHuge(page)))
+		if (unlikely(split_huge_page(page)))
+			goto out;
+
+	rc = __unmap_and_move(page, newpage, force, offlining, sync);
+out:
 	if (rc != -EAGAIN) {
- 		/*
- 		 * A page that has been migrated has all references
- 		 * removed and will be freed. A page that has not been
- 		 * migrated will have kepts its references and be
- 		 * restored.
- 		 */
- 		list_del(&page->lru);
+		/*
+		 * A page that has been migrated has all references
+		 * removed and will be freed. A page that has not been
+		 * migrated will have kepts its references and be
+		 * restored.
+		 */
+		list_del(&page->lru);
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				page_is_file_cache(page));
 		putback_lru_page(page);
 	}
-
 	/*
 	 * Move the new page to the LRU. If migration was not successful
 	 * then this will free the page.
 	 */
 	putback_lru_page(newpage);
-
 	if (result) {
 		if (rc)
 			*result = rc;


