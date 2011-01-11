Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1AKFX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 00:23:29 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51175 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab1AKFXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 00:23:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XpzBSH7hoxnADB3WJj8g1ls0fe98bEDulfT+okuSCvSrh5Em/c24YF7LoXoVDgJt2q
         Wk12279mvwP+xi26193Zvse95rytms/igyinKPUXykvHpORudMP3eRXkyE1j4WU4fRgW
         ngxEaKomXo59PtyirGAunlZsmRPPBWQgmYQQk=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 7/7] Change __remove_from_page_cache
Date: Tue, 11 Jan 2011 14:22:11 +0900
Message-Id: <2837eff03ffbb680beaa37d6e94af898ed98ca54.1294723009.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1294723009.git.minchan.kim@gmail.com>
References: <cover.1294723009.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1294723009.git.minchan.kim@gmail.com>
References: <cover.1294723009.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we renamed remove_from_page_cache with delete_from_page_cache.
As consistency of __remove_from_swap_cache and remove_from_swap_cache,
We change internal page cache handling function name, too.

Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 include/linux/pagemap.h |    2 +-
 mm/filemap.c            |    6 +++---
 mm/memory-failure.c     |    2 +-
 mm/truncate.c           |    2 +-
 mm/vmscan.c             |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 7bf6587..b5b21d8 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -455,7 +455,7 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
-extern void __remove_from_page_cache(struct page *page);
+extern void __delete_from_page_cache(struct page *page);
 extern void delete_from_page_cache(struct page *page);
 
 /*
diff --git a/mm/filemap.c b/mm/filemap.c
index a5542fa..313e599 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -109,11 +109,11 @@
  */
 
 /*
- * Remove a page from the page cache and free it. Caller has to make
+ * Delete a page from the page cache and free it. Caller has to make
  * sure the page is locked and that nobody else uses it - or that usage
  * is safe.  The caller must hold the mapping's tree_lock.
  */
-void __remove_from_page_cache(struct page *page)
+void __delete_from_page_cache(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
 
@@ -167,7 +167,7 @@ void delete_from_page_cache(struct page *page)
 
 	freepage = mapping->a_ops->freepage;
 	spin_lock_irq(&mapping->tree_lock);
-	__remove_from_page_cache(page);
+	__delete_from_page_cache(page);
 	spin_unlock_irq(&mapping->tree_lock);
 	mem_cgroup_uncharge_cache_page(page);
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 548fbd7..50ed16f 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1084,7 +1084,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 
 	/*
 	 * Now take care of user space mappings.
-	 * Abort on fail: __remove_from_page_cache() assumes unmapped page.
+	 * Abort on fail: __delete_from_page_cache() assumes unmapped page.
 	 */
 	if (hwpoison_user_mappings(p, pfn, trapno) != SWAP_SUCCESS) {
 		printk(KERN_ERR "MCE %#lx: cannot unmap page, give up\n", pfn);
diff --git a/mm/truncate.c b/mm/truncate.c
index 85404b0..ef97cd2 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -402,7 +402,7 @@ invalidate_complete_page2(struct address_space *mapping, struct page *page)
 
 	clear_page_mlock(page);
 	BUG_ON(page_has_private(page));
-	__remove_from_page_cache(page);
+	__delete_from_page_cache(page);
 	spin_unlock_irq(&mapping->tree_lock);
 	mem_cgroup_uncharge_cache_page(page);
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 47a5096..bdb867f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -515,7 +515,7 @@ static int __remove_mapping(struct address_space *mapping, struct page *page)
 
 		freepage = mapping->a_ops->freepage;
 
-		__remove_from_page_cache(page);
+		__delete_from_page_cache(page);
 		spin_unlock_irq(&mapping->tree_lock);
 		mem_cgroup_uncharge_cache_page(page);
 
-- 
1.7.0.4

