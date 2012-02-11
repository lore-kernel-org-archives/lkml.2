Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab2BKHn5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 02:43:57 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52959 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2BKHn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 02:43:56 -0500
Subject: [PATCH 5/4] shmem: put shmem_delete_from_page_cache under CONFIG_SWAP
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 11 Feb 2012 11:43:52 +0400
Message-ID: <20120211074321.30852.66207.stgit@zurg>
In-Reply-To: <20120210193249.6492.18768.stgit@zurg>
References: <20120210193249.6492.18768.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix warning added in patch "shmem: tag swap entries in radix tree"

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/shmem.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 7a3fe08..709e3d8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -302,25 +302,6 @@ static int shmem_add_to_page_cache(struct page *page,
 }
 
 /*
- * Like delete_from_page_cache, but substitutes swap for page.
- */
-static void shmem_delete_from_page_cache(struct page *page, void *radswap)
-{
-	struct address_space *mapping = page->mapping;
-	int error;
-
-	spin_lock_irq(&mapping->tree_lock);
-	error = shmem_radix_tree_replace(mapping, page->index, page, radswap);
-	page->mapping = NULL;
-	mapping->nrpages--;
-	__dec_zone_page_state(page, NR_FILE_PAGES);
-	__dec_zone_page_state(page, NR_SHMEM);
-	spin_unlock_irq(&mapping->tree_lock);
-	page_cache_release(page);
-	BUG_ON(error);
-}
-
-/*
  * Like find_get_pages, but collecting swap entries as well as pages.
  */
 static unsigned shmem_find_get_pages_and_swap(struct address_space *mapping,
@@ -718,6 +699,25 @@ out:
 }
 
 /*
+ * Like delete_from_page_cache, but substitutes swap for page.
+ */
+static void shmem_delete_from_page_cache(struct page *page, void *radswap)
+{
+	struct address_space *mapping = page->mapping;
+	int error;
+
+	spin_lock_irq(&mapping->tree_lock);
+	error = shmem_radix_tree_replace(mapping, page->index, page, radswap);
+	page->mapping = NULL;
+	mapping->nrpages--;
+	__dec_zone_page_state(page, NR_FILE_PAGES);
+	__dec_zone_page_state(page, NR_SHMEM);
+	spin_unlock_irq(&mapping->tree_lock);
+	page_cache_release(page);
+	BUG_ON(error);
+}
+
+/*
  * Move the page from the page cache to the swap cache.
  */
 static int shmem_writepage(struct page *page, struct writeback_control *wbc)

