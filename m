Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab2BSVY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 16:24:29 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56025 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab2BSVY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 16:24:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.205.120.10 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH 3/3] mm: deprecate pagevec lru-add functions
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 20 Feb 2012 01:24:21 +0400
Message-ID: <20120219212421.16861.48975.stgit@zurg>
In-Reply-To: <20120219212412.16861.36936.stgit@zurg>
References: <20120219212412.16861.36936.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They mostly unused, the last user is fs/cachefiles/rdwr.c
This patch replaces __pagevec_lru_add() with smaller implementation.
It is exported, so we should keep it for a while.

Plus simplify and fix pathetic single-page page-vector operations in
nfs_symlink(), this was second pagevec_lru_add_file() user.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 fs/nfs/dir.c            |   10 +++-------
 include/linux/pagevec.h |    4 +++-
 mm/swap.c               |   27 +++++++--------------------
 3 files changed, 13 insertions(+), 28 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index fd9a872..c789aa4 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1850,7 +1850,6 @@ static int nfs_unlink(struct inode *dir, struct dentry *dentry)
  */
 static int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
 {
-	struct pagevec lru_pvec;
 	struct page *page;
 	char *kaddr;
 	struct iattr attr;
@@ -1890,15 +1889,12 @@ static int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *sym
 	 * No big deal if we can't add this page to the page cache here.
 	 * READLINK will get the missing page from the server if needed.
 	 */
-	pagevec_init(&lru_pvec, 0);
-	if (!add_to_page_cache(page, dentry->d_inode->i_mapping, 0,
+	if (!add_to_page_cache_lru(page, dentry->d_inode->i_mapping, 0,
 							GFP_KERNEL)) {
-		pagevec_add(&lru_pvec, page);
-		pagevec_lru_add_file(&lru_pvec);
 		SetPageUptodate(page);
 		unlock_page(page);
-	} else
-		__free_page(page);
+	}
+	put_page(page);
 
 	return 0;
 }
diff --git a/include/linux/pagevec.h b/include/linux/pagevec.h
index 2aa12b8..4df37fe 100644
--- a/include/linux/pagevec.h
+++ b/include/linux/pagevec.h
@@ -21,7 +21,6 @@ struct pagevec {
 };
 
 void __pagevec_release(struct pagevec *pvec);
-void __pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t start, unsigned nr_pages);
 unsigned pagevec_lookup_tag(struct pagevec *pvec,
@@ -64,6 +63,9 @@ static inline void pagevec_release(struct pagevec *pvec)
 		__pagevec_release(pvec);
 }
 
+/* Use lru_cache_add_list() instead */
+void __deprecated __pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
+
 static inline void __pagevec_lru_add_anon(struct pagevec *pvec)
 {
 	__pagevec_lru_add(pvec, LRU_INACTIVE_ANON);
diff --git a/mm/swap.c b/mm/swap.c
index 2b8d376..8d228d8 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -772,33 +772,20 @@ void lru_add_page_tail(struct zone* zone,
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static void __pagevec_lru_add_fn(struct page *page, void *arg)
-{
-	enum lru_list lru = (enum lru_list)arg;
-	struct zone *zone = page_zone(page);
-	int file = is_file_lru(lru);
-	int active = is_active_lru(lru);
-
-	VM_BUG_ON(PageActive(page));
-	VM_BUG_ON(PageUnevictable(page));
-	VM_BUG_ON(PageLRU(page));
-
-	SetPageLRU(page);
-	if (active)
-		SetPageActive(page);
-	update_page_reclaim_stat(zone, page, file, active);
-	add_page_to_lru_list(zone, page, lru);
-}
-
 /*
  * Add the passed pages to the LRU, then drop the caller's refcount
  * on them.  Reinitialises the caller's pagevec.
  */
 void __pagevec_lru_add(struct pagevec *pvec, enum lru_list lru)
 {
-	VM_BUG_ON(is_unevictable_lru(lru));
+	LIST_HEAD(pages);
+	int i;
 
-	pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn, (void *)lru);
+	VM_BUG_ON(is_unevictable_lru(lru));
+	for ( i = 0 ; i < pvec->nr ; i++ )
+		list_add_tail(&pvec->pages[i]->lru, &pages);
+	pagevec_reinit(pvec);
+	__lru_cache_add_list(&pages, lru);
 }
 EXPORT_SYMBOL(__pagevec_lru_add);
 

