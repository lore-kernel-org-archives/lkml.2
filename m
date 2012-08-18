Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab2HRJtF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 05:49:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37280 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2HRJtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 05:49:02 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: fengguang.wu@intel.com, chris.mason@fusionio.com, mfasheh@suse.com,
        jlbec@evilplan.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Vivek Trivedi <vtrivedi018@gmail.com>
Subject: [PATCH 1/3] writeback: change nr_pages_dirtied argument into local variable
Date: Sat, 18 Aug 2012 05:48:29 -0400
Message-Id: <1345283309-7768-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason nr_pages_dirtied is argument anymore.
because nr_pages_dirtied value from caller is not used in
balance_dirty_pages_ratelimited_nr function.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Vivek Trivedi <vtrivedi018@gmail.com>
---
 fs/btrfs/disk-io.c        |    8 ++++----
 fs/btrfs/file.c           |    3 +--
 fs/btrfs/ioctl.c          |    2 +-
 fs/ocfs2/file.c           |    5 +----
 fs/splice.c               |    5 +----
 include/linux/writeback.h |    9 +--------
 mm/page-writeback.c       |   11 +++++------
 7 files changed, 14 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 62e0caf..10b6128 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3344,8 +3344,8 @@ void btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr)
 	num_dirty = root->fs_info->dirty_metadata_bytes;
 
 	if (num_dirty > thresh) {
-		balance_dirty_pages_ratelimited_nr(
-				   root->fs_info->btree_inode->i_mapping, 1);
+		balance_dirty_pages_ratelimited(
+				   root->fs_info->btree_inode->i_mapping);
 	}
 	return;
 }
@@ -3365,8 +3365,8 @@ void __btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr)
 	num_dirty = root->fs_info->dirty_metadata_bytes;
 
 	if (num_dirty > thresh) {
-		balance_dirty_pages_ratelimited_nr(
-				   root->fs_info->btree_inode->i_mapping, 1);
+		balance_dirty_pages_ratelimited(
+				   root->fs_info->btree_inode->i_mapping);
 	}
 	return;
 }
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f6b40e8..0dae684 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1314,8 +1314,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 
 		cond_resched();
 
-		balance_dirty_pages_ratelimited_nr(inode->i_mapping,
-						   dirty_pages);
+		balance_dirty_pages_ratelimited(inode->i_mapping);
 		if (dirty_pages < (root->leafsize >> PAGE_CACHE_SHIFT) + 1)
 			btrfs_btree_balance_dirty(root, 1);
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7bb7556..df2e9fb 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1199,7 +1199,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		}
 
 		defrag_count += ret;
-		balance_dirty_pages_ratelimited_nr(inode->i_mapping, ret);
+		balance_dirty_pages_ratelimited(inode->i_mapping);
 		mutex_unlock(&inode->i_mutex);
 
 		if (newer_than) {
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 46a1f6d..a83c964 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2515,18 +2515,15 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 		ret = sd.num_spliced;
 
 	if (ret > 0) {
-		unsigned long nr_pages;
 		int err;
 
-		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-
 		err = generic_write_sync(out, *ppos, ret);
 		if (err)
 			ret = err;
 		else
 			*ppos += ret;
 
-		balance_dirty_pages_ratelimited_nr(mapping, nr_pages);
+		balance_dirty_pages_ratelimited(mapping);
 	}
 
 	return ret;
diff --git a/fs/splice.c b/fs/splice.c
index 41514dd..36b6c17 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1024,17 +1024,14 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 		ret = sd.num_spliced;
 
 	if (ret > 0) {
-		unsigned long nr_pages;
 		int err;
 
-		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-
 		err = generic_write_sync(out, *ppos, ret);
 		if (err)
 			ret = err;
 		else
 			*ppos += ret;
-		balance_dirty_pages_ratelimited_nr(mapping, nr_pages);
+		balance_dirty_pages_ratelimited(mapping);
 	}
 	sb_end_write(inode->i_sb);
 
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 50c3e8f..b82a83a 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -161,14 +161,7 @@ void __bdi_update_bandwidth(struct backing_dev_info *bdi,
 			    unsigned long start_time);
 
 void page_writeback_init(void);
-void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
-					unsigned long nr_pages_dirtied);
-
-static inline void
-balance_dirty_pages_ratelimited(struct address_space *mapping)
-{
-	balance_dirty_pages_ratelimited_nr(mapping, 1);
-}
+void balance_dirty_pages_ratelimited(struct address_space *mapping);
 
 typedef int (*writepage_t)(struct page *page, struct writeback_control *wbc,
 				void *data);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 5ad5ce2..49133b6 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1069,7 +1069,7 @@ static void bdi_update_bandwidth(struct backing_dev_info *bdi,
 }
 
 /*
- * After a task dirtied this many pages, balance_dirty_pages_ratelimited_nr()
+ * After a task dirtied this many pages, balance_dirty_pages_ratelimited()
  * will look to see if it needs to start dirty throttling.
  *
  * If dirty_poll_interval is too low, big NUMA machines will call the expensive
@@ -1436,9 +1436,8 @@ static DEFINE_PER_CPU(int, bdp_ratelimits);
 DEFINE_PER_CPU(int, dirty_throttle_leaks) = 0;
 
 /**
- * balance_dirty_pages_ratelimited_nr - balance dirty memory state
+ * balance_dirty_pages_ratelimited - balance dirty memory state
  * @mapping: address_space which was dirtied
- * @nr_pages_dirtied: number of pages which the caller has just dirtied
  *
  * Processes which are dirtying memory should call in here once for each page
  * which was newly dirtied.  The function will periodically check the system's
@@ -1449,8 +1448,7 @@ DEFINE_PER_CPU(int, dirty_throttle_leaks) = 0;
  * limit we decrease the ratelimiting by a lot, to prevent individual processes
  * from overshooting the limit by (ratelimit_pages) each.
  */
-void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
-					unsigned long nr_pages_dirtied)
+void balance_dirty_pages_ratelimited(struct address_space *mapping)
 {
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	int ratelimit;
@@ -1484,6 +1482,7 @@ void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
 	 */
 	p = &__get_cpu_var(dirty_throttle_leaks);
 	if (*p > 0 && current->nr_dirtied < ratelimit) {
+		unsigned long nr_pages_dirtied;
 		nr_pages_dirtied = min(*p, ratelimit - current->nr_dirtied);
 		*p -= nr_pages_dirtied;
 		current->nr_dirtied += nr_pages_dirtied;
@@ -1493,7 +1492,7 @@ void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
 	if (unlikely(current->nr_dirtied >= ratelimit))
 		balance_dirty_pages(mapping, current->nr_dirtied);
 }
-EXPORT_SYMBOL(balance_dirty_pages_ratelimited_nr);
+EXPORT_SYMBOL(balance_dirty_pages_ratelimited);
 
 void throttle_vm_writeout(gfp_t gfp_mask)
 {
-- 
1.7.9.5

