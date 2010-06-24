Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab0FXD0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:26:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:48478 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab0FXDPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:53 -0400
Message-Id: <20100624030730.615983250@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:43 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 31/52] fs: icache atomic inodes_stat
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-inode_lock-scale-5.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect inodes_stat statistics with atomic ops rather than inode_lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/fs-writeback.c  |    6 ++++--
 fs/inode.c         |   28 +++++++++++++++-------------
 include/linux/fs.h |    5 +++--
 3 files changed, 22 insertions(+), 17 deletions(-)

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -924,7 +924,8 @@ static long wb_check_old_data_flush(stru
 	wb->last_old_flush = jiffies;
 	nr_pages = global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) +
-			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
+			(atomic_read(&inodes_stat.nr_inodes) -
+			atomic_read(&inodes_stat.nr_unused));
 
 	if (nr_pages) {
 		struct wb_writeback_args args = {
@@ -1285,7 +1286,8 @@ void writeback_inodes_sb(struct super_bl
 	long nr_to_write;
 
 	nr_to_write = nr_dirty + nr_unstable +
-			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
+			(atomic_read(&inodes_stat.nr_inodes) -
+			atomic_read(&inodes_stat.nr_unused));
 
 	bdi_start_writeback(sb->s_bdi, sb, nr_to_write);
 }
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -123,7 +123,10 @@ static DECLARE_RWSEM(iprune_sem);
 /*
  * Statistics gathering..
  */
-struct inodes_stat_t inodes_stat;
+struct inodes_stat_t inodes_stat = {
+	.nr_inodes = ATOMIC_INIT(0),
+	.nr_unused = ATOMIC_INIT(0),
+};
 
 static struct kmem_cache *inode_cachep __read_mostly;
 
@@ -318,7 +321,7 @@ void __iget(struct inode *inode)
 		list_move(&inode->i_list, &inode_in_use);
 		spin_unlock(&wb_inode_list_lock);
 	}
-	inodes_stat.nr_unused--;
+	atomic_dec(&inodes_stat.nr_unused);
 }
 
 /**
@@ -382,9 +385,7 @@ static void dispose_list(struct list_hea
 		destroy_inode(inode);
 		nr_disposed++;
 	}
-	spin_lock(&inode_lock);
-	inodes_stat.nr_inodes -= nr_disposed;
-	spin_unlock(&inode_lock);
+	atomic_sub(nr_disposed, &inodes_stat.nr_inodes);
 }
 
 /*
@@ -433,7 +434,7 @@ static int invalidate_list(struct list_h
 		busy = 1;
 	}
 	/* only unused inodes may be cached with i_count zero */
-	inodes_stat.nr_unused -= count;
+	atomic_sub(count, &inodes_stat.nr_unused);
 	return busy;
 }
 
@@ -551,7 +552,7 @@ again2:
 		spin_unlock(&inode->i_lock);
 		nr_pruned++;
 	}
-	inodes_stat.nr_unused -= nr_pruned;
+	atomic_sub(nr_pruned, &inodes_stat.nr_unused);
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
@@ -584,7 +585,8 @@ static int shrink_icache_memory(int nr,
 			return -1;
 		prune_icache(nr);
 	}
-	return (inodes_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
+	return (atomic_read(&inodes_stat.nr_unused) / 100) *
+					sysctl_vfs_cache_pressure;
 }
 
 static struct shrinker icache_shrinker = {
@@ -677,7 +679,7 @@ static inline void
 __inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
 			struct inode *inode)
 {
-	inodes_stat.nr_inodes++;
+	atomic_inc(&inodes_stat.nr_inodes);
 	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
@@ -1321,8 +1323,8 @@ void generic_delete_inode(struct inode *
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
-	inodes_stat.nr_inodes--;
 	spin_unlock(&inode_lock);
+	atomic_dec(&inodes_stat.nr_inodes);
 
 	if (op->delete_inode) {
 		void (*delete)(struct inode *) = op->delete_inode;
@@ -1365,7 +1367,7 @@ int generic_detach_inode(struct inode *i
 			list_move(&inode->i_list, &inode_unused);
 			spin_unlock(&wb_inode_list_lock);
 		}
-		inodes_stat.nr_unused++;
+		atomic_inc(&inodes_stat.nr_unused);
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&sb_inode_list_lock);
@@ -1383,7 +1385,7 @@ int generic_detach_inode(struct inode *i
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		inodes_stat.nr_unused--;
+		atomic_dec(&inodes_stat.nr_unused);
 		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
@@ -1395,9 +1397,9 @@ int generic_detach_inode(struct inode *i
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
-	inodes_stat.nr_inodes--;
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
+	atomic_dec(&inodes_stat.nr_inodes);
 	return 1;
 }
 EXPORT_SYMBOL_GPL(generic_detach_inode);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -38,13 +38,6 @@ struct files_stat_struct {
 	int max_files;		/* tunable */
 };
 
-struct inodes_stat_t {
-	int nr_inodes;
-	int nr_unused;
-	int dummy[5];		/* padding for sysctl ABI compatibility */
-};
-
-
 #define NR_FILE  8192	/* this can well be larger on a larger system */
 
 #define MAY_EXEC 1
@@ -418,6 +411,12 @@ typedef int (get_block_t)(struct inode *
 typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 			ssize_t bytes, void *private);
 
+struct inodes_stat_t {
+	atomic_t nr_inodes;
+	atomic_t nr_unused;
+	int dummy[5];		/* padding for sysctl ABI compatibility */
+};
+
 /*
  * Attribute flags.  These should be or-ed together to figure out what
  * has been changed!
Index: linux-2.6/drivers/staging/pohmelfs/inode.c
===================================================================
--- linux-2.6.orig/drivers/staging/pohmelfs/inode.c
+++ linux-2.6/drivers/staging/pohmelfs/inode.c
@@ -1283,11 +1283,11 @@ static void pohmelfs_put_super(struct su
 		dprintk("%s: ino: %llu, pi: %p, inode: %p, count: %u.\n",
 				__func__, pi->ino, pi, inode, count);
 
-		if (atomic_read(&inode->i_count) != count) {
+		if (inode->i_count != count) {
 			printk("%s: ino: %llu, pi: %p, inode: %p, count: %u, i_count: %d.\n",
 					__func__, pi->ino, pi, inode, count,
-					atomic_read(&inode->i_count));
-			count = atomic_read(&inode->i_count);
+					inode->i_count);
+			count = inode->i_count;
 			in_drop_list++;
 		}
 
@@ -1299,7 +1299,7 @@ static void pohmelfs_put_super(struct su
 		pi = POHMELFS_I(inode);
 
 		dprintk("%s: ino: %llu, pi: %p, inode: %p, i_count: %u.\n",
-				__func__, pi->ino, pi, inode, atomic_read(&inode->i_count));
+				__func__, pi->ino, pi, inode, inode->i_count);
 
 		/*
 		 * These are special inodes, they were created during
@@ -1307,7 +1307,7 @@ static void pohmelfs_put_super(struct su
 		 * so they live here with reference counter being 1 and prevent
 		 * umount from succeed since it believes that they are busy.
 		 */
-		count = atomic_read(&inode->i_count);
+		count = inode->i_count;
 		if (count) {
 			list_del_init(&inode->i_sb_list);
 			while (count--)
Index: linux-2.6/fs/btrfs/inode.c
===================================================================
--- linux-2.6.orig/fs/btrfs/inode.c
+++ linux-2.6/fs/btrfs/inode.c
@@ -1964,8 +1964,13 @@ void btrfs_add_delayed_iput(struct inode
 	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 	struct delayed_iput *delayed;
 
-	if (atomic_add_unless(&inode->i_count, -1, 1))
+	spin_lock(&inode->i_lock);
+	if (inode->i_count > 1) {
+		inode->i_count--;
+		spin_unlock(&inode->i_lock);
 		return;
+	}
+	spin_unlock(&inode->i_lock);
 
 	delayed = kmalloc(sizeof(*delayed), GFP_NOFS | __GFP_NOFAIL);
 	delayed->inode = inode;
@@ -2718,10 +2723,10 @@ static struct btrfs_trans_handle *__unli
 		return ERR_PTR(-ENOSPC);
 
 	/* check if there is someone else holds reference */
-	if (S_ISDIR(inode->i_mode) && atomic_read(&inode->i_count) > 1)
+	if (S_ISDIR(inode->i_mode) && inode->i_count > 1)
 		return ERR_PTR(-ENOSPC);
 
-	if (atomic_read(&inode->i_count) > 2)
+	if (inode->i_count > 2)
 		return ERR_PTR(-ENOSPC);
 
 	if (xchg(&root->fs_info->enospc_unlink, 1))
@@ -3934,7 +3939,7 @@ again:
 		inode = igrab(&entry->vfs_inode);
 		if (inode) {
 			spin_unlock(&root->inode_lock);
-			if (atomic_read(&inode->i_count) > 1)
+			if (inode->i_count > 1)
 				d_prune_aliases(inode);
 			/*
 			 * btrfs_drop_inode will remove it from
Index: linux-2.6/fs/ceph/mds_client.c
===================================================================
--- linux-2.6.orig/fs/ceph/mds_client.c
+++ linux-2.6/fs/ceph/mds_client.c
@@ -1028,7 +1028,7 @@ static int trim_caps_cb(struct inode *in
 		spin_unlock(&inode->i_lock);
 		d_prune_aliases(inode);
 		dout("trim_caps_cb %p cap %p  pruned, count now %d\n",
-		     inode, cap, atomic_read(&inode->i_count));
+		     inode, cap, inode->i_count);
 		return 0;
 	}
 
Index: linux-2.6/fs/logfs/dir.c
===================================================================
--- linux-2.6.orig/fs/logfs/dir.c
+++ linux-2.6/fs/logfs/dir.c
@@ -566,7 +566,9 @@ static int logfs_link(struct dentry *old
 		return -EMLINK;
 
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	inode->i_nlink++;
 	mark_inode_dirty_sync(inode);
 
Index: linux-2.6/fs/logfs/readwrite.c
===================================================================
--- linux-2.6.orig/fs/logfs/readwrite.c
+++ linux-2.6/fs/logfs/readwrite.c
@@ -1002,7 +1002,7 @@ static int __logfs_is_valid_block(struct
 {
 	struct logfs_inode *li = logfs_inode(inode);
 
-	if ((inode->i_nlink == 0) && atomic_read(&inode->i_count) == 1)
+	if (inode->i_nlink == 0 && inode->i_count == 1)
 		return 0;
 
 	if (bix < I0_BLOCKS)


