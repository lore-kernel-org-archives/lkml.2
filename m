Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab0LVPeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 10:34:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62706 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab0LVPeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 10:34:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Leurs8i11f+Wodr24Z/TtRH5ycIdEzg/kUCX8nLTMwbHYDX/mT72iM+KdXNsd1RCx1
         PrEo3MV5tP/htnvtS92yzKZ4XkdqF+RCtf+QlWK9DFRi59+XtnsOEq6LtENg0LbT9ZaG
         ejd1dwdB6OnvBW8EB2TBjslP5ZQll5xnqdc9M=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 7/7] Change __remove_from_page_cache
Date: Thu, 23 Dec 2010 00:32:49 +0900
Message-Id: <6661e5a219276b590365774d90ec8e300956a3ad.1293031047.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1293031046.git.minchan.kim@gmail.com>
References: <cover.1293031046.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1293031046.git.minchan.kim@gmail.com>
References: <cover.1293031046.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we renamed remove_from_page_cache with delete_from_page_cache.
As consistency of __remove_from_swap_cache and remove_from_swap_cache,
We change internal page cache handling function name, too.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 include/linux/pagemap.h |    2 +-
 mm/filemap.c            |    6 +++---
 mm/truncate.c           |    2 +-
 mm/vmscan.c             |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

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
index a4c43f7..9776166 100644
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
 
diff --git a/mm/truncate.c b/mm/truncate.c
index 3adb9c0..687429a 100644
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

