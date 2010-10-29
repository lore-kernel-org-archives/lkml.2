Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759762Ab0J2DZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 23:25:24 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:51679 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760021Ab0J2DYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 23:24:43 -0400
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] fs: Clean up documentation references to inode_lock
Date: Fri, 29 Oct 2010 14:23:40 +1100
Message-Id: <1288322620-8566-9-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288322620-8566-1-git-send-email-david@fromorbit.com>
References: <1288322620-8566-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 Documentation/filesystems/Locking |    2 +-
 Documentation/filesystems/porting |   11 ++++++-----
 Documentation/filesystems/vfs.txt |    2 +-
 fs/buffer.c                       |    2 +-
 fs/logfs/inode.c                  |    2 +-
 fs/notify/inode_mark.c            |    5 ++---
 fs/ntfs/inode.c                   |    4 ++--
 include/linux/fs.h                |    2 +-
 include/linux/quotaops.h          |    2 +-
 mm/filemap.c                      |    8 +++++---
 mm/rmap.c                         |    7 ++++---
 11 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 8a817f6..5478e1f 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -114,7 +114,7 @@ alloc_inode:
 destroy_inode:
 dirty_inode:				(must not sleep)
 write_inode:
-drop_inode:				!!!inode_lock!!!
+drop_inode:				!!!inode->i_lock!!!
 evict_inode:
 put_super:		write
 write_super:		read
diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
index b12c895..2da4b44 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -299,11 +299,12 @@ be used instead.  It gets called whenever the inode is evicted, whether it has
 remaining links or not.  Caller does *not* evict the pagecache or inode-associated
 metadata buffers; getting rid of those is responsibility of method, as it had
 been for ->delete_inode().
-	->drop_inode() returns int now; it's called on final iput() with inode_lock
-held and it returns true if filesystems wants the inode to be dropped.  As before,
-generic_drop_inode() is still the default and it's been updated appropriately.
-generic_delete_inode() is also alive and it consists simply of return 1.  Note that
-all actual eviction work is done by caller after ->drop_inode() returns.
+	->drop_inode() returns int now; it's called on final iput() with
+inode->i_lock held and it returns true if the filesystem wants the inode to be
+dropped.  As before, generic_drop_inode() is still the default and it's been
+updated appropriately.  generic_delete_inode() is also alive and it consists
+simply of return 1.  Note that all actual eviction work is done by caller after
+->drop_inode() returns.
 	clear_inode() is gone; use end_writeback() instead.  As before, it must
 be called exactly once on each call of ->evict_inode() (as it used to be for
 each call of ->delete_inode()).  Unlike before, if you are using inode-associated
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index ed7e5ef..046792a 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -246,7 +246,7 @@ or bottom half).
 	should be synchronous or not, not all filesystems check this flag.
 
   drop_inode: called when the last access to the inode is dropped,
-	with the inode_lock spinlock held.
+	with the inode->i_lock spinlock held.
 
 	This method should be either NULL (normal UNIX filesystem
 	semantics) or "generic_delete_inode" (for filesystems that do not
diff --git a/fs/buffer.c b/fs/buffer.c
index d895d9f..dd24081 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1144,7 +1144,7 @@ __getblk_slow(struct block_device *bdev, sector_t block, int size)
  * inode list.
  *
  * mark_buffer_dirty() is atomic.  It takes bh->b_page->mapping->private_lock,
- * mapping->tree_lock and the global inode_lock.
+ * mapping->tree_lock, inode->i_lock and the global inode_wb_list_lock.
  */
 void mark_buffer_dirty(struct buffer_head *bh)
 {
diff --git a/fs/logfs/inode.c b/fs/logfs/inode.c
index d8c71ec..38c559e 100644
--- a/fs/logfs/inode.c
+++ b/fs/logfs/inode.c
@@ -286,7 +286,7 @@ static int logfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	return ret;
 }
 
-/* called with inode_lock held */
+/* called with inode->i_lock held */
 static int logfs_drop_inode(struct inode *inode)
 {
 	struct logfs_super *super = logfs_super(inode->i_sb);
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index a33b0f9..b6beba0 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -288,10 +288,9 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		}
 
 		/*
-		 * We can safely drop inode_lock here because we hold
+		 * We can safely drop inode_sb_list_lock here because we hold
 		 * references on both inode and next_i.  Also no new inodes
-		 * will be added since the umount has begun.  Finally,
-		 * iprune_mutex keeps shrink_icache_memory() away.
+		 * will be added since the umount has begun.
 		 */
 		spin_unlock(&inode_sb_list_lock);
 
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 93622b1..a7b12d4 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -54,7 +54,7 @@
  *
  * Return 1 if the attributes match and 0 if not.
  *
- * NOTE: This function runs with the inode_lock spin lock held so it is not
+ * NOTE: This function runs with the inode->i_lock spin lock held so it is not
  * allowed to sleep.
  */
 int ntfs_test_inode(struct inode *vi, ntfs_attr *na)
@@ -98,7 +98,7 @@ int ntfs_test_inode(struct inode *vi, ntfs_attr *na)
  *
  * Return 0 on success and -errno on error.
  *
- * NOTE: This function runs with the inode_lock spin lock held so it is not
+ * NOTE: This function runs with the inode->i_lock spin lock held so it is not
  * allowed to sleep. (Hence the GFP_ATOMIC allocation.)
  */
 static int ntfs_init_locked_inode(struct inode *vi, ntfs_attr *na)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f300a65..913f0ad 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1595,7 +1595,7 @@ struct super_operations {
 };
 
 /*
- * Inode state bits.  Protected by inode_lock.
+ * Inode state bits.  Protected by inode->i_lock.
  *
  * Three bits determine the dirty state of the inode, I_DIRTY_SYNC,
  * I_DIRTY_DATASYNC and I_DIRTY_PAGES.
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index d1a9193..bf230b6 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -278,7 +278,7 @@ static inline int dquot_alloc_space(struct inode *inode, qsize_t nr)
 		/*
 		 * Mark inode fully dirty. Since we are allocating blocks, inode
 		 * would become fully dirty soon anyway and it reportedly
-		 * reduces inode_lock contention.
+		 * reduces lock contention.
 		 */
 		mark_inode_dirty(inode);
 	}
diff --git a/mm/filemap.c b/mm/filemap.c
index 3d4df44..ae5b156 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -80,7 +80,7 @@
  *  ->i_mutex
  *    ->i_alloc_sem             (various)
  *
- *  ->inode_lock
+ *  ->inode_wb_list_lock
  *    ->sb_lock			(fs/fs-writeback.c)
  *    ->mapping->tree_lock	(__sync_single_inode)
  *
@@ -98,8 +98,10 @@
  *    ->zone.lru_lock		(check_pte_range->isolate_lru_page)
  *    ->private_lock		(page_remove_rmap->set_page_dirty)
  *    ->tree_lock		(page_remove_rmap->set_page_dirty)
- *    ->inode_lock		(page_remove_rmap->set_page_dirty)
- *    ->inode_lock		(zap_pte_range->set_page_dirty)
+ *    ->inode->i_lock		(page_remove_rmap->set_page_dirty)
+ *    ->inode_wb_list_lock	(page_remove_rmap->set_page_dirty)
+ *    ->inode->i_lock		(zap_pte_range->set_page_dirty)
+ *    ->inode_wb_list_lock	(zap_pte_range->set_page_dirty)
  *    ->private_lock		(zap_pte_range->__set_page_dirty_buffers)
  *
  *  ->task->proc_lock
diff --git a/mm/rmap.c b/mm/rmap.c
index 5f17fad..abdf401 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -31,11 +31,12 @@
  *             swap_lock (in swap_duplicate, swap_info_get)
  *               mmlist_lock (in mmput, drain_mmlist and others)
  *               mapping->private_lock (in __set_page_dirty_buffers)
- *               inode_lock (in set_page_dirty's __mark_inode_dirty)
- *                 sb_lock (within inode_lock in fs/fs-writeback.c)
+ *		 inode->i_lock (in set_page_dirty's __mark_inode_dirty)
+ *		 inode_wb_list_lock (in set_page_dirty's __mark_inode_dirty)
+ *                 sb_lock (within inode_wb_list_lock in fs/fs-writeback.c)
  *                 mapping->tree_lock (widely used, in set_page_dirty,
  *                           in arch-dependent flush_dcache_mmap_lock,
- *                           within inode_lock in __sync_single_inode)
+ *                           within inode_wb_list_lock in __sync_single_inode)
  *
  * (code doesn't rely on that order so it could be switched around)
  * ->tasklist_lock
-- 
1.7.1

