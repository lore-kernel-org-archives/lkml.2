Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab0LVPdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 10:33:37 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58930 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab0LVPdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 10:33:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PCe536mj+uVnmWDGBKpKdjEbOYaiBSgPdaEOZwVI2OfbgNeXH1R3R/vjK0fPNgquse
         lyDnQYKiHjf+37CPHnkyR4pJorQgxaiz4lUOCpYUekfuRAyFm0/LKjdUnxXecUqcxkBL
         PwY4mqH1tUij/qF9pO2uvOFBbKk5QOvhpUgn8=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 1/7] Introduce delete_from_page_cache
Date: Thu, 23 Dec 2010 00:32:43 +0900
Message-Id: <d44334d280990190eaf9e2159c72ff3c034fa7ec.1293031046.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1293031046.git.minchan.kim@gmail.com>
References: <cover.1293031046.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1293031046.git.minchan.kim@gmail.com>
References: <cover.1293031046.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function works as just wrapper remove_from_page_cache.
The difference is that it decreases page references in itself.
So caller have to make sure it has a page reference before calling.

This patch is ready for removing remove_from_page_cache.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 include/linux/pagemap.h |    1 +
 mm/filemap.c            |   17 +++++++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 9c66e99..7a1cb49 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -457,6 +457,7 @@ int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
 extern void remove_from_page_cache(struct page *page);
 extern void __remove_from_page_cache(struct page *page);
+extern void delete_from_page_cache(struct page *page);
 
 /*
  * Like add_to_page_cache_locked, but used to add newly allocated pages:
diff --git a/mm/filemap.c b/mm/filemap.c
index 095c393..1ca7475 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -166,6 +166,23 @@ void remove_from_page_cache(struct page *page)
 }
 EXPORT_SYMBOL(remove_from_page_cache);
 
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
+{
+	remove_from_page_cache(page);
+	page_cache_release(page);
+}
+EXPORT_SYMBOL(delete_from_page_cache);
+
 static int sync_page(void *word)
 {
 	struct address_space *mapping;
-- 
1.7.0.4

