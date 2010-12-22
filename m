Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0LVPeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 10:34:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62706 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab0LVPeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 10:34:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=V6QGHDjCS/Jk4UdgMa5VERsR6CKgrCs+eqArqMExJy3sQ5NEPi0A+eiJdRklmq0D/H
         pqo4Fu5DctegXdCXWNmrK14yT30nRJTPjO2knvZNetZTd4t3RiFmFYyB2RsULJVhIWe4
         reEiLYjBUiBdzdCTz5/3vSvTUYEUeVuXcoWxc=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 6/7] Good bye remove_from_page_cache
Date: Thu, 23 Dec 2010 00:32:48 +0900
Message-Id: <958620cb6a73a5633619d7d4a9793bc284260684.1293031047.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1293031046.git.minchan.kim@gmail.com>
References: <cover.1293031046.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1293031046.git.minchan.kim@gmail.com>
References: <cover.1293031046.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now delete_from_page_cache replaces remove_from_page_cache.
So we remove remove_from_page_cache so fs or something out of
mainline will notice it when compile time and can fix it.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 include/linux/pagemap.h |    1 -
 mm/filemap.c            |   27 +++++++++++----------------
 2 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 7a1cb49..7bf6587 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -455,7 +455,6 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
-extern void remove_from_page_cache(struct page *page);
 extern void __remove_from_page_cache(struct page *page);
 extern void delete_from_page_cache(struct page *page);
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 1ca7475..a4c43f7 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -148,7 +148,17 @@ void __remove_from_page_cache(struct page *page)
 	}
 }
 
-void remove_from_page_cache(struct page *page)
+/**
+ * delete_from_page_cache - delete page from page cache
+ *
+ * @page: the page which the kernel is trying to remove from page cache
+ *
+ * This must be called only on pages that have
+ * been verified to be in the page cache and locked.
+ * It will never put the page into the free list,
+ * the caller has a reference on the page.
+ */
+void delete_from_page_cache(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
 	void (*freepage)(struct page *);
@@ -163,22 +173,7 @@ void remove_from_page_cache(struct page *page)
 
 	if (freepage)
 		freepage(page);
-}
-EXPORT_SYMBOL(remove_from_page_cache);
 
-/**
- * delete_from_page_cache - delete page from page cache
- *
- * @page: the page which the kernel is trying to remove from page cache
- *
- * This must be called only on pages that have
- * been verified to be in the page cache and locked.
- * It will never put the page into the free list,
- * the caller has a reference on the page.
- */
-void delete_from_page_cache(struct page *page)
-{
-	remove_from_page_cache(page);
 	page_cache_release(page);
 }
 EXPORT_SYMBOL(delete_from_page_cache);
-- 
1.7.0.4

