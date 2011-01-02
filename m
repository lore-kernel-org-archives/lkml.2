Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab1ABPo6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 10:44:58 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62307 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab1ABPox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 10:44:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ccwijcMm9tqzfG6Cg6QTqXbdds41aUNRSl4RcMbMCIclxbt8G0F7B+Wuy1xjsDqFTx
         MSE8a5KE9SDGxvELqEB+sMCAwA62yPZvq7eZ076n6jwCYAlerDzX9Y/Hwdf+bURK5TyH
         b86ZfhaoI1nTTvxEj7SJhZd3KtF4qlm6UY1+s=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 1/7] Introduce delete_from_page_cache
Date: Mon,  3 Jan 2011 00:44:30 +0900
Message-Id: <39f5e90f69d523d7f69f8ba283e318def6538307.1293982522.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1293982522.git.minchan.kim@gmail.com>
References: <cover.1293982522.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1293982522.git.minchan.kim@gmail.com>
References: <cover.1293982522.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function works as just wrapper remove_from_page_cache.
The difference is that it decreases page references in itself.
So caller have to make sure it has a page reference before calling.

This patch is ready for removing remove_from_page_cache.

Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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

