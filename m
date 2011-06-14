Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab1FNKuC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 06:50:02 -0400
Received: from smtp-out.google.com ([74.125.121.67]:6832 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab1FNKuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 06:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=oLNU4NvdB0F4V0mnEN5GNZ2wIvzLB98z7NYuSsbSI/4eoTtX8GwMYnXm9+XjsITfHY
         LvsYtwjGubjI/wVaMmeA==
Date: Tue, 14 Jun 2011 03:49:44 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 5/12] tmpfs: copy truncate_inode_pages_range
In-Reply-To: <alpine.LSU.2.00.1106140327550.29206@sister.anvils>
Message-ID: <alpine.LSU.2.00.1106140348330.29206@sister.anvils>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bring truncate.c's code for truncate_inode_pages_range() inline into
shmem_truncate_range(), replacing its first call (there's a followup
call below, but leave that one, it will disappear next).

Don't play with it yet, apart from leaving out the cleancache flush,
and (importantly) the nrpages == 0 skip, and moving shmem_setattr()'s
partial page preparation into its partial page handling.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/shmem.c |   99 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 79 insertions(+), 20 deletions(-)

--- linux.orig/mm/shmem.c	2011-06-13 13:28:25.822786909 -0700
+++ linux/mm/shmem.c	2011-06-13 13:28:44.330878656 -0700
@@ -50,6 +50,7 @@ static struct vfsmount *shm_mnt;
 #include <linux/shmem_fs.h>
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
+#include <linux/pagevec.h>
 #include <linux/percpu_counter.h>
 #include <linux/splice.h>
 #include <linux/security.h>
@@ -242,11 +243,88 @@ void shmem_truncate_range(struct inode *
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	pgoff_t start = (lstart + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	unsigned partial = lstart & (PAGE_CACHE_SIZE - 1);
 	pgoff_t end = (lend >> PAGE_CACHE_SHIFT);
+	struct pagevec pvec;
 	pgoff_t index;
 	swp_entry_t swap;
+	int i;
 
-	truncate_inode_pages_range(mapping, lstart, lend);
+	BUG_ON((lend & (PAGE_CACHE_SIZE - 1)) != (PAGE_CACHE_SIZE - 1));
+
+	pagevec_init(&pvec, 0);
+	index = start;
+	while (index <= end && pagevec_lookup(&pvec, mapping, index,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
+		mem_cgroup_uncharge_start();
+		for (i = 0; i < pagevec_count(&pvec); i++) {
+			struct page *page = pvec.pages[i];
+
+			/* We rely upon deletion not changing page->index */
+			index = page->index;
+			if (index > end)
+				break;
+
+			if (!trylock_page(page))
+				continue;
+			WARN_ON(page->index != index);
+			if (PageWriteback(page)) {
+				unlock_page(page);
+				continue;
+			}
+			truncate_inode_page(mapping, page);
+			unlock_page(page);
+		}
+		pagevec_release(&pvec);
+		mem_cgroup_uncharge_end();
+		cond_resched();
+		index++;
+	}
+
+	if (partial) {
+		struct page *page = NULL;
+		shmem_getpage(inode, start - 1, &page, SGP_READ, NULL);
+		if (page) {
+			zero_user_segment(page, partial, PAGE_CACHE_SIZE);
+			set_page_dirty(page);
+			unlock_page(page);
+			page_cache_release(page);
+		}
+	}
+
+	index = start;
+	for ( ; ; ) {
+		cond_resched();
+		if (!pagevec_lookup(&pvec, mapping, index,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
+			if (index == start)
+				break;
+			index = start;
+			continue;
+		}
+		if (index == start && pvec.pages[0]->index > end) {
+			pagevec_release(&pvec);
+			break;
+		}
+		mem_cgroup_uncharge_start();
+		for (i = 0; i < pagevec_count(&pvec); i++) {
+			struct page *page = pvec.pages[i];
+
+			/* We rely upon deletion not changing page->index */
+			index = page->index;
+			if (index > end)
+				break;
+
+			lock_page(page);
+			WARN_ON(page->index != index);
+			wait_on_page_writeback(page);
+			truncate_inode_page(mapping, page);
+			unlock_page(page);
+		}
+		pagevec_release(&pvec);
+		mem_cgroup_uncharge_end();
+		index++;
+	}
 
 	if (end > SHMEM_NR_DIRECT)
 		end = SHMEM_NR_DIRECT;
@@ -289,24 +367,7 @@ static int shmem_setattr(struct dentry *
 	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
 		loff_t oldsize = inode->i_size;
 		loff_t newsize = attr->ia_size;
-		struct page *page = NULL;
 
-		if (newsize < oldsize) {
-			/*
-			 * If truncating down to a partial page, then
-			 * if that page is already allocated, hold it
-			 * in memory until the truncation is over, so
-			 * truncate_partial_page cannot miss it were
-			 * it assigned to swap.
-			 */
-			if (newsize & (PAGE_CACHE_SIZE-1)) {
-				(void) shmem_getpage(inode,
-					newsize >> PAGE_CACHE_SHIFT,
-						&page, SGP_READ, NULL);
-				if (page)
-					unlock_page(page);
-			}
-		}
 		if (newsize != oldsize) {
 			i_size_write(inode, newsize);
 			inode->i_ctime = inode->i_mtime = CURRENT_TIME;
@@ -318,8 +379,6 @@ static int shmem_setattr(struct dentry *
 			/* unmap again to remove racily COWed private pages */
 			unmap_mapping_range(inode->i_mapping, holebegin, 0, 1);
 		}
-		if (page)
-			page_cache_release(page);
 	}
 
 	setattr_copy(inode, attr);
