Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566Ab2EYTR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 15:17:58 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60200 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932774Ab2EYTRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 15:17:55 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 1/4] tmpfs: support fallocate FALLOC_FL_PUNCH_HOLE
Date: Fri, 25 May 2012 12:17:33 -0700
Message-Id: <1337973456-19533-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1337973456-19533-1-git-send-email-john.stultz@linaro.org>
References: <1337973456-19533-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052519-5930-0000-0000-0000083F1C3B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

tmpfs has supported hole-punching since 2.6.16, via madvise(,,MADV_REMOVE).
But nowadays fallocate(,FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE,,) is the
agreed way to punch holes.

So add shmem_fallocate() to support that, and tweak shmem_truncate_range()
to support partial pages at both the beginning and end of range (never
needed for madvise, which demands rounded addr and rounds up length).

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Android Kernel Team <kernel-team@android.com>
CC: Robert Love <rlove@google.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Hugh Dickins <hughd@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Rik van Riel <riel@redhat.com>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Neil Brown <neilb@suse.de>
CC: Andrea Righi <andrea@betterlinux.com>
CC: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
CC: Taras Glek <tgek@mozilla.com>
CC: Mike Hommey <mh@glandium.org>

Based-on-patch-by: Cong Wang <amwang@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 mm/shmem.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 57 insertions(+), 11 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index d7b433a..9b1c6b4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -53,6 +53,7 @@ static struct vfsmount *shm_mnt;
 #include <linux/blkdev.h>
 #include <linux/pagevec.h>
 #include <linux/percpu_counter.h>
+#include <linux/falloc.h>
 #include <linux/splice.h>
 #include <linux/security.h>
 #include <linux/swapops.h>
@@ -429,21 +430,23 @@ void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	pgoff_t start = (lstart + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	unsigned partial = lstart & (PAGE_CACHE_SIZE - 1);
-	pgoff_t end = (lend >> PAGE_CACHE_SHIFT);
+	pgoff_t end = (lend + 1) >> PAGE_CACHE_SHIFT;
+	unsigned int partial_start = lstart & (PAGE_CACHE_SIZE - 1);
+	unsigned int partial_end = (lend + 1) & (PAGE_CACHE_SIZE - 1);
 	struct pagevec pvec;
 	pgoff_t indices[PAGEVEC_SIZE];
 	long nr_swaps_freed = 0;
 	pgoff_t index;
 	int i;
 
-	BUG_ON((lend & (PAGE_CACHE_SIZE - 1)) != (PAGE_CACHE_SIZE - 1));
+	if (lend == -1)
+		end = -1;	/* unsigned, so actually very big */
 
 	pagevec_init(&pvec, 0);
 	index = start;
-	while (index <= end) {
+	while (index < end) {
 		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1,
+				min(end - index, (pgoff_t)PAGEVEC_SIZE),
 							pvec.pages, indices);
 		if (!pvec.nr)
 			break;
@@ -452,7 +455,7 @@ void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
 			struct page *page = pvec.pages[i];
 
 			index = indices[i];
-			if (index > end)
+			if (index >= end)
 				break;
 
 			if (radix_tree_exceptional_entry(page)) {
@@ -476,22 +479,39 @@ void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
 		index++;
 	}
 
-	if (partial) {
+	if (partial_start) {
 		struct page *page = NULL;
 		shmem_getpage(inode, start - 1, &page, SGP_READ, NULL);
 		if (page) {
-			zero_user_segment(page, partial, PAGE_CACHE_SIZE);
+			unsigned int top = PAGE_CACHE_SIZE;
+			if (start > end) {
+				top = partial_end;
+				partial_end = 0;
+			}
+			zero_user_segment(page, partial_start, top);
+			set_page_dirty(page);
+			unlock_page(page);
+			page_cache_release(page);
+		}
+	}
+	if (partial_end) {
+		struct page *page = NULL;
+		shmem_getpage(inode, end, &page, SGP_READ, NULL);
+		if (page) {
+			zero_user_segment(page, 0, partial_end);
 			set_page_dirty(page);
 			unlock_page(page);
 			page_cache_release(page);
 		}
 	}
+	if (start >= end)
+		return;
 
 	index = start;
 	for ( ; ; ) {
 		cond_resched();
 		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1,
+				min(end - index, (pgoff_t)PAGEVEC_SIZE),
 							pvec.pages, indices);
 		if (!pvec.nr) {
 			if (index == start)
@@ -499,7 +519,7 @@ void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
 			index = start;
 			continue;
 		}
-		if (index == start && indices[0] > end) {
+		if (index == start && indices[0] >= end) {
 			shmem_deswap_pagevec(&pvec);
 			pagevec_release(&pvec);
 			break;
@@ -509,7 +529,7 @@ void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
 			struct page *page = pvec.pages[i];
 
 			index = indices[i];
-			if (index > end)
+			if (index >= end)
 				break;
 
 			if (radix_tree_exceptional_entry(page)) {
@@ -1462,6 +1482,31 @@ static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
 	return error;
 }
 
+static long shmem_fallocate(struct file *file, int mode, loff_t offset,
+							 loff_t len)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	int error = -EOPNOTSUPP;
+
+	mutex_lock(&inode->i_mutex);
+
+	if (mode & FALLOC_FL_PUNCH_HOLE) {
+		struct address_space *mapping = file->f_mapping;
+		loff_t unmap_start = round_up(offset, PAGE_SIZE);
+		loff_t unmap_end = round_down(offset + len, PAGE_SIZE) - 1;
+
+		if ((u64)unmap_end > (u64)unmap_start)
+			unmap_mapping_range(mapping, unmap_start,
+					    1 + unmap_end - unmap_start, 0);
+		shmem_truncate_range(inode, offset, offset + len - 1);
+		/* No need to unmap again: hole-punching leaves COWed pages */
+		error = 0;
+	}
+
+	mutex_unlock(&inode->i_mutex);
+	return error;
+}
+
 static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(dentry->d_sb);
@@ -2372,6 +2417,7 @@ static const struct file_operations shmem_file_operations = {
 	.fsync		= noop_fsync,
 	.splice_read	= shmem_file_splice_read,
 	.splice_write	= generic_file_splice_write,
+	.fallocate	= shmem_fallocate,
 #endif
 };
 
-- 
1.7.3.2.146.gca209

