Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab1DKM2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 08:28:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44117 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab1DKM2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 08:28:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=X9xvyTKKzQbNilplEz6mr6R+irnc3k1qXG7vlowpDiceTMNc9Y29T6SYLoFYLDO9Gm
         IitdxzRnraKNTrF1YLOHh4wsZLuoZe7FWA+x/Du5JfqYNM9vrqXHBHo5n29wP7qZOktA
         fTOKjL4b39v6V1MUQ9JfTKy+crbUfdqvnKrGg=
From: Namhyung Kim <namhyung@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] shmem: factor out remove_indirect_page()
Date: Mon, 11 Apr 2011 21:27:59 +0900
Message-Id: <1302524879-4737-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out some common code in shmem_truncate_range() in order to
improve readability (hopefully) and to reduce code duplication.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/shmem.c |   62 ++++++++++++++++++++++++++++++++++-------------------------
 1 files changed, 36 insertions(+), 26 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 58da7c150ba6..58ad1159678f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -531,6 +531,31 @@ static void shmem_free_pages(struct list_head *next)
 	} while (next);
 }
 
+/**
+ * remove_indirect_page - remove a indirect page from upper layer
+ * @dir:	pointer to the indirect page in the upper layer
+ * @page:	indirect page to be removed
+ * @needs_lock:	pointer to spinlock if needed
+ * @free_list:	list which the removed page will be inserted into
+ *
+ * This function removes @page from @dir and insert it into @free_list.
+ * The @page still remains after this function but will not be seen by
+ * other tasks. Finally it will be freed via shmem_free_pages().
+ */
+static void remove_indirect_page(struct page **dir, struct page *page,
+		spinlock_t *needs_lock, struct list_head *free_list)
+{
+	if (needs_lock) {
+		spin_lock(needs_lock);
+		*dir = NULL;
+		spin_unlock(needs_lock);
+	} else {
+		*dir = NULL;
+	}
+
+	list_add(&page->lru, free_list);
+}
+
 static void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -582,9 +607,9 @@ static void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end)
 
 	topdir = info->i_indirect;
 	if (topdir && idx <= SHMEM_NR_DIRECT && !punch_hole) {
-		info->i_indirect = NULL;
+		remove_indirect_page(&info->i_indirect, topdir, NULL,
+				     &pages_to_free);
 		nr_pages_to_free++;
-		list_add(&topdir->lru, &pages_to_free);
 	}
 	spin_unlock(&info->lock);
 
@@ -637,15 +662,10 @@ static void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end)
 			diroff = ((idx - ENTRIES_PER_PAGEPAGE/2) %
 				ENTRIES_PER_PAGEPAGE) / ENTRIES_PER_PAGE;
 			if (!diroff && !offset && upper_limit >= stage) {
-				if (needs_lock) {
-					spin_lock(needs_lock);
-					*dir = NULL;
-					spin_unlock(needs_lock);
-					needs_lock = NULL;
-				} else
-					*dir = NULL;
+				remove_indirect_page(dir, middir, needs_lock,
+						     &pages_to_free);
 				nr_pages_to_free++;
-				list_add(&middir->lru, &pages_to_free);
+				needs_lock = NULL;
 			}
 			shmem_dir_unmap(dir);
 			dir = shmem_dir_map(middir);
@@ -672,15 +692,10 @@ static void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end)
 			if (punch_hole)
 				needs_lock = &info->lock;
 			if (upper_limit >= stage) {
-				if (needs_lock) {
-					spin_lock(needs_lock);
-					*dir = NULL;
-					spin_unlock(needs_lock);
-					needs_lock = NULL;
-				} else
-					*dir = NULL;
+				remove_indirect_page(dir, middir, needs_lock,
+						     &pages_to_free);
 				nr_pages_to_free++;
-				list_add(&middir->lru, &pages_to_free);
+				needs_lock = NULL;
 			}
 			shmem_dir_unmap(dir);
 			cond_resched();
@@ -690,15 +705,10 @@ static void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end)
 		punch_lock = needs_lock;
 		subdir = dir[diroff];
 		if (subdir && !offset && upper_limit-idx >= ENTRIES_PER_PAGE) {
-			if (needs_lock) {
-				spin_lock(needs_lock);
-				dir[diroff] = NULL;
-				spin_unlock(needs_lock);
-				punch_lock = NULL;
-			} else
-				dir[diroff] = NULL;
+			remove_indirect_page(&dir[diroff], subdir, needs_lock,
+					     &pages_to_free);
 			nr_pages_to_free++;
-			list_add(&subdir->lru, &pages_to_free);
+			punch_lock = NULL;
 		}
 		if (subdir && page_private(subdir) /* has swap entries */) {
 			size = limit - idx;
-- 
1.7.4

