Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2AXPtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 10:49:36 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58540 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab2AXPtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 10:49:35 -0500
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-mm@kvack.org
Subject: [Patch] tmpfs: clean up shmem_find_get_pages_and_swap()
Date: Tue, 24 Jan 2012 23:48:53 +0800
Message-Id: <1327420133-16551-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up shmem_find_get_pages_and_swap() interface:

a) Pass struct pagevec* instead of ->pages
b) Check if nr_pages is greater than PAGEVEC_SIZE inside the function
c) Return the result via ->nr instead of using return value

Compiling test only.

Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/mm/shmem.c b/mm/shmem.c
index 269d049..c4e08e2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -312,15 +312,19 @@ static void shmem_delete_from_page_cache(struct page *page, void *radswap)
 /*
  * Like find_get_pages, but collecting swap entries as well as pages.
  */
-static unsigned shmem_find_get_pages_and_swap(struct address_space *mapping,
+static void shmem_find_get_pages_and_swap(struct address_space *mapping,
 					pgoff_t start, unsigned int nr_pages,
-					struct page **pages, pgoff_t *indices)
+					struct pagevec *pvec, pgoff_t *indices)
 {
 	unsigned int i;
 	unsigned int ret;
 	unsigned int nr_found;
+	struct page **pages = pvec->pages;
 
 	rcu_read_lock();
+
+	if (nr_pages > PAGEVEC_SIZE)
+		nr_pages = PAGEVEC_SIZE;
 restart:
 	nr_found = radix_tree_gang_lookup_slot(&mapping->page_tree,
 				(void ***)pages, indices, start, nr_pages);
@@ -357,7 +361,7 @@ export:
 	if (unlikely(!ret && nr_found))
 		goto restart;
 	rcu_read_unlock();
-	return ret;
+	pvec->nr = ret;
 }
 
 /*
@@ -409,8 +413,8 @@ void shmem_unlock_mapping(struct address_space *mapping)
 		 * Avoid pagevec_lookup(): find_get_pages() returns 0 as if it
 		 * has finished, if it hits a row of PAGEVEC_SIZE swap entries.
 		 */
-		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
-					PAGEVEC_SIZE, pvec.pages, indices);
+		shmem_find_get_pages_and_swap(mapping, index,
+					PAGEVEC_SIZE, &pvec, indices);
 		if (!pvec.nr)
 			break;
 		index = indices[pvec.nr - 1] + 1;
@@ -442,9 +446,8 @@ void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
 	pagevec_init(&pvec, 0);
 	index = start;
 	while (index <= end) {
-		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1,
-							pvec.pages, indices);
+		shmem_find_get_pages_and_swap(mapping, index,
+			end - index + 1, &pvec, indices);
 		if (!pvec.nr)
 			break;
 		mem_cgroup_uncharge_start();
@@ -490,9 +493,8 @@ void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
 	index = start;
 	for ( ; ; ) {
 		cond_resched();
-		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1,
-							pvec.pages, indices);
+		shmem_find_get_pages_and_swap(mapping, index,
+			end - index + 1, &pvec, indices);
 		if (!pvec.nr) {
 			if (index == start)
 				break;
