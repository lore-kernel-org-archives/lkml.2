Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab0FXDZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:25:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36051 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab0FXDP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:59 -0400
Message-Id: <20100624030733.162362903@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:59 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>,
       Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Subject: [patch 47/52] fs: keep inode with backing-dev
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-backing-dev-change.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having inode on writeback lists of a different bdi than
inode->i_mapping->backing_dev_info makes it very difficult to do per-bdi
locking of the writeback lists. Add functions to move these inodes over when
the mapping backing dev is changed.

i_mapping.backing_dev_info is renamed to i_mapping.a_bdi while we're
here. Succinct is nice, and it catches conversion errors.

Signed-off-by: Nick Piggin <npiggin@suse.de>
--
Index: linux-2.6/include/linux/backing-dev.h
===================================================================
--- linux-2.6.orig/include/linux/backing-dev.h
+++ linux-2.6/include/linux/backing-dev.h
@@ -316,19 +316,25 @@ static inline bool bdi_cap_flush_forker(
 	return bdi == &default_backing_dev_info;
 }
 
+void mapping_set_bdi(struct address_space *mapping, struct backing_dev_info *bdi);
+static inline void mapping_new_set_bdi(struct address_space *mapping, struct backing_dev_info *bdi)
+{
+	mapping->a_bdi = bdi;
+}
+
 static inline bool mapping_cap_writeback_dirty(struct address_space *mapping)
 {
-	return bdi_cap_writeback_dirty(mapping->backing_dev_info);
+	return bdi_cap_writeback_dirty(mapping->a_bdi);
 }
 
 static inline bool mapping_cap_account_dirty(struct address_space *mapping)
 {
-	return bdi_cap_account_dirty(mapping->backing_dev_info);
+	return bdi_cap_account_dirty(mapping->a_bdi);
 }
 
 static inline bool mapping_cap_swap_backed(struct address_space *mapping)
 {
-	return bdi_cap_swap_backed(mapping->backing_dev_info);
+	return bdi_cap_swap_backed(mapping->a_bdi);
 }
 
 static inline int bdi_sched_wait(void *word)
@@ -347,7 +353,7 @@ static inline void blk_run_backing_dev(s
 static inline void blk_run_address_space(struct address_space *mapping)
 {
 	if (mapping)
-		blk_run_backing_dev(mapping->backing_dev_info, NULL);
+		blk_run_backing_dev(mapping->a_bdi, NULL);
 }
 
 #endif		/* _LINUX_BACKING_DEV_H */
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -635,7 +635,7 @@ struct address_space {
 	pgoff_t			writeback_index;/* writeback starts here */
 	const struct address_space_operations *a_ops;	/* methods */
 	unsigned long		flags;		/* error bits/gfp mask */
-	struct backing_dev_info *backing_dev_info; /* device readahead, etc */
+	struct backing_dev_info *a_bdi;		/* device readahead, etc */
 	spinlock_t		private_lock;	/* for use by the address_space */
 	struct list_head	private_list;	/* ditto */
 	struct address_space	*assoc_mapping;	/* ditto */
Index: linux-2.6/mm/backing-dev.c
===================================================================
--- linux-2.6.orig/mm/backing-dev.c
+++ linux-2.6/mm/backing-dev.c
@@ -700,6 +700,47 @@ err:
 }
 EXPORT_SYMBOL(bdi_init);
 
+void mapping_set_bdi(struct address_space *mapping, struct backing_dev_info *bdi)
+{
+	struct inode *inode = mapping->host;
+	struct backing_dev_info *old = mapping->a_bdi;
+
+	if (unlikely(old == bdi))
+		return;
+
+	spin_lock(&wb_inode_list_lock);
+	if (!list_empty(&inode->i_io)) {
+		struct inode *i;
+
+		list_for_each_entry(i, &old->wb.b_dirty, i_io) {
+			if (inode == i) {
+				list_del(&inode->i_io);
+				list_add(&inode->i_io, &bdi->wb.b_dirty);
+				goto found;
+			}
+		}
+		list_for_each_entry(i, &old->wb.b_io, i_io) {
+			if (inode == i) {
+				list_del(&inode->i_io);
+				list_add(&inode->i_io, &bdi->wb.b_io);
+				goto found;
+			}
+		}
+		list_for_each_entry(i, &old->wb.b_more_io, i_io) {
+			if (inode == i) {
+				list_del(&inode->i_io);
+				list_add(&inode->i_io, &bdi->wb.b_more_io);
+				goto found;
+			}
+		}
+		BUG();
+	}
+found:
+	mapping->a_bdi = bdi;
+	spin_unlock(&wb_inode_list_lock);
+}
+EXPORT_SYMBOL(mapping_set_bdi);
+
 void bdi_destroy(struct backing_dev_info *bdi)
 {
 	int i;
@@ -710,11 +751,24 @@ void bdi_destroy(struct backing_dev_info
 	 */
 	if (bdi_has_dirty_io(bdi)) {
 		struct bdi_writeback *dst = &default_backing_dev_info.wb;
+		struct inode *i;
 
 		spin_lock(&wb_inode_list_lock);
-		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
-		list_splice(&bdi->wb.b_io, &dst->b_io);
-		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
+		list_for_each_entry(i, &bdi->wb.b_dirty, i_io) {
+			list_del(&i->i_io);
+			list_add(&i->i_io, &dst->b_dirty);
+			i->i_mapping->a_bdi = bdi;
+		}
+		list_for_each_entry(i, &bdi->wb.b_io, i_io) {
+			list_del(&i->i_io);
+			list_add(&i->i_io, &dst->b_io);
+			i->i_mapping->a_bdi = bdi;
+		}
+		list_for_each_entry(i, &bdi->wb.b_more_io, i_io) {
+			list_del(&i->i_io);
+			list_add(&i->i_io, &dst->b_more_io);
+			i->i_mapping->a_bdi = bdi;
+		}
 		spin_unlock(&wb_inode_list_lock);
 	}
 
Index: linux-2.6/drivers/char/mem.c
===================================================================
--- linux-2.6.orig/drivers/char/mem.c
+++ linux-2.6/drivers/char/mem.c
@@ -871,7 +871,7 @@ static int memory_open(struct inode *ino
 
 	filp->f_op = dev->fops;
 	if (dev->dev_info)
-		filp->f_mapping->backing_dev_info = dev->dev_info;
+		mapping_set_bdi(filp->f_mapping, dev->dev_info);
 
 	if (dev->fops->open)
 		return dev->fops->open(inode, filp);
Index: linux-2.6/drivers/char/raw.c
===================================================================
--- linux-2.6.orig/drivers/char/raw.c
+++ linux-2.6/drivers/char/raw.c
@@ -109,7 +109,7 @@ static int raw_release(struct inode *ino
 	if (--raw_devices[minor].inuse == 0) {
 		/* Here  inode->i_mapping == bdev->bd_inode->i_mapping  */
 		inode->i_mapping = &inode->i_data;
-		inode->i_mapping->backing_dev_info = &default_backing_dev_info;
+		mapping_set_bdi(inode->i_mapping, &default_backing_dev_info);
 	}
 	mutex_unlock(&raw_mutex);
 
Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c
+++ linux-2.6/fs/block_dev.c
@@ -539,7 +539,7 @@ struct block_device *bdget(dev_t dev)
 		inode->i_bdev = bdev;
 		inode->i_data.a_ops = &def_blk_aops;
 		mapping_set_gfp_mask(&inode->i_data, GFP_USER);
-		inode->i_data.backing_dev_info = &default_backing_dev_info;
+		mapping_new_set_bdi(&inode->i_data, &default_backing_dev_info);
 		spin_lock(&bdev_lock);
 		list_add(&bdev->bd_list, &all_bdevs);
 		spin_unlock(&bdev_lock);
@@ -1404,7 +1404,7 @@ static int __blkdev_get(struct block_dev
 				bdi = blk_get_backing_dev_info(bdev);
 				if (bdi == NULL)
 					bdi = &default_backing_dev_info;
-				bdev->bd_inode->i_data.backing_dev_info = bdi;
+				mapping_set_bdi(&bdev->bd_inode->i_data, bdi);
 			}
 			if (bdev->bd_invalidated)
 				rescan_partitions(disk, bdev);
@@ -1419,8 +1419,8 @@ static int __blkdev_get(struct block_dev
 			if (ret)
 				goto out_clear;
 			bdev->bd_contains = whole;
-			bdev->bd_inode->i_data.backing_dev_info =
-			   whole->bd_inode->i_data.backing_dev_info;
+			mapping_set_bdi(&bdev->bd_inode->i_data,
+			   whole->bd_inode->i_data.a_bdi);
 			bdev->bd_part = disk_get_part(disk, partno);
 			if (!(disk->flags & GENHD_FL_UP) ||
 			    !bdev->bd_part || !bdev->bd_part->nr_sects) {
@@ -1454,7 +1454,7 @@ static int __blkdev_get(struct block_dev
 	disk_put_part(bdev->bd_part);
 	bdev->bd_disk = NULL;
 	bdev->bd_part = NULL;
-	bdev->bd_inode->i_data.backing_dev_info = &default_backing_dev_info;
+	mapping_set_bdi(&bdev->bd_inode->i_data, &default_backing_dev_info);
 	if (bdev != bdev->bd_contains)
 		__blkdev_put(bdev->bd_contains, mode, 1);
 	bdev->bd_contains = NULL;
@@ -1551,7 +1551,8 @@ static int __blkdev_put(struct block_dev
 		disk_put_part(bdev->bd_part);
 		bdev->bd_part = NULL;
 		bdev->bd_disk = NULL;
-		bdev->bd_inode->i_data.backing_dev_info = &default_backing_dev_info;
+		mapping_set_bdi(&bdev->bd_inode->i_data,
+				&default_backing_dev_info);
 		if (bdev != bdev->bd_contains)
 			victim = bdev->bd_contains;
 		bdev->bd_contains = NULL;
Index: linux-2.6/fs/btrfs/disk-io.c
===================================================================
--- linux-2.6.orig/fs/btrfs/disk-io.c
+++ linux-2.6/fs/btrfs/disk-io.c
@@ -1636,7 +1636,7 @@ struct btrfs_root *open_ctree(struct sup
 	 */
 	fs_info->btree_inode->i_size = OFFSET_MAX;
 	fs_info->btree_inode->i_mapping->a_ops = &btree_aops;
-	fs_info->btree_inode->i_mapping->backing_dev_info = &fs_info->bdi;
+	mapping_new_set_bdi(fs_info->btree_inode->i_mapping, &fs_info->bdi);
 
 	RB_CLEAR_NODE(&BTRFS_I(fs_info->btree_inode)->rb_node);
 	extent_io_tree_init(&BTRFS_I(fs_info->btree_inode)->io_tree,
Index: linux-2.6/fs/btrfs/inode.c
===================================================================
--- linux-2.6.orig/fs/btrfs/inode.c
+++ linux-2.6/fs/btrfs/inode.c
@@ -2480,7 +2480,7 @@ static void btrfs_read_locked_inode(stru
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
 		inode->i_mapping->a_ops = &btrfs_aops;
-		inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
+		mapping_new_set_bdi(inode->i_mapping, &root->fs_info->bdi);
 		BTRFS_I(inode)->io_tree.ops = &btrfs_extent_io_ops;
 		inode->i_fop = &btrfs_file_operations;
 		inode->i_op = &btrfs_file_inode_operations;
@@ -2495,7 +2495,7 @@ static void btrfs_read_locked_inode(stru
 	case S_IFLNK:
 		inode->i_op = &btrfs_symlink_inode_operations;
 		inode->i_mapping->a_ops = &btrfs_symlink_aops;
-		inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
+		mapping_new_set_bdi(inode->i_mapping, &root->fs_info->bdi);
 		break;
 	default:
 		inode->i_op = &btrfs_special_inode_operations;
@@ -4705,7 +4705,7 @@ static int btrfs_create(struct inode *di
 		drop_inode = 1;
 	else {
 		inode->i_mapping->a_ops = &btrfs_aops;
-		inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
+		mapping_new_set_bdi(inode->i_mapping, &root->fs_info->bdi);
 		inode->i_fop = &btrfs_file_operations;
 		inode->i_op = &btrfs_file_inode_operations;
 		BTRFS_I(inode)->io_tree.ops = &btrfs_extent_io_ops;
@@ -6700,7 +6700,7 @@ static int btrfs_symlink(struct inode *d
 		drop_inode = 1;
 	else {
 		inode->i_mapping->a_ops = &btrfs_aops;
-		inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
+		mapping_new_set_bdi(inode->i_mapping, &root->fs_info->bdi);
 		inode->i_fop = &btrfs_file_operations;
 		inode->i_op = &btrfs_file_inode_operations;
 		BTRFS_I(inode)->io_tree.ops = &btrfs_extent_io_ops;
@@ -6740,7 +6740,7 @@ static int btrfs_symlink(struct inode *d
 
 	inode->i_op = &btrfs_symlink_inode_operations;
 	inode->i_mapping->a_ops = &btrfs_symlink_aops;
-	inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
+	mapping_new_set_bdi(inode->i_mapping, &root->fs_info->bdi);
 	inode_set_bytes(inode, name_len);
 	btrfs_i_size_write(inode, name_len - 1);
 	err = btrfs_update_inode(trans, root, inode);
Index: linux-2.6/fs/ceph/inode.c
===================================================================
--- linux-2.6.orig/fs/ceph/inode.c
+++ linux-2.6/fs/ceph/inode.c
@@ -623,8 +623,8 @@ static int fill_inode(struct inode *inod
 	}
 
 	inode->i_mapping->a_ops = &ceph_aops;
-	inode->i_mapping->backing_dev_info =
-		&ceph_sb_to_client(inode->i_sb)->backing_dev_info;
+	mapping_new_set_bdi(inode->i_mapping,
+			&ceph_sb_to_client(inode->i_sb)->backing_dev_info);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
Index: linux-2.6/fs/configfs/inode.c
===================================================================
--- linux-2.6.orig/fs/configfs/inode.c
+++ linux-2.6/fs/configfs/inode.c
@@ -136,7 +136,8 @@ struct inode * configfs_new_inode(mode_t
 	struct inode * inode = new_inode(configfs_sb);
 	if (inode) {
 		inode->i_mapping->a_ops = &configfs_aops;
-		inode->i_mapping->backing_dev_info = &configfs_backing_dev_info;
+		mapping_new_set_bdi(inode->i_mapping,
+				&configfs_backing_dev_info);
 		inode->i_op = &configfs_inode_operations;
 
 		if (sd->s_iattr) {
Index: linux-2.6/fs/gfs2/glock.c
===================================================================
--- linux-2.6.orig/fs/gfs2/glock.c
+++ linux-2.6/fs/gfs2/glock.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/sched.h>
+#include <linux/backing-dev.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/buffer_head.h>
@@ -796,7 +797,7 @@ int gfs2_glock_get(struct gfs2_sbd *sdp,
 		mapping->flags = 0;
 		mapping_set_gfp_mask(mapping, GFP_NOFS);
 		mapping->assoc_mapping = NULL;
-		mapping->backing_dev_info = s->s_bdi;
+		mapping_new_set_bdi(mapping, s->s_bdi);
 		mapping->writeback_index = 0;
 	}
 
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c
+++ linux-2.6/fs/hugetlbfs/inode.c
@@ -476,7 +476,8 @@ static struct inode *hugetlbfs_get_inode
 		inode->i_uid = uid;
 		inode->i_gid = gid;
 		inode->i_mapping->a_ops = &hugetlbfs_aops;
-		inode->i_mapping->backing_dev_info =&hugetlbfs_backing_dev_info;
+		mapping_new_set_bdi(inode->i_mapping,
+				&hugetlbfs_backing_dev_info);
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		INIT_LIST_HEAD(&inode->i_mapping->private_list);
 		info = HUGETLBFS_I(inode);
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -237,7 +237,7 @@ int inode_init_always(struct super_block
 	mapping->flags = 0;
 	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_MOVABLE);
 	mapping->assoc_mapping = NULL;
-	mapping->backing_dev_info = &default_backing_dev_info;
+	mapping_new_set_bdi(mapping, &default_backing_dev_info);
 	mapping->writeback_index = 0;
 
 	/*
@@ -248,8 +248,8 @@ int inode_init_always(struct super_block
 	if (sb->s_bdev) {
 		struct backing_dev_info *bdi;
 
-		bdi = sb->s_bdev->bd_inode->i_mapping->backing_dev_info;
-		mapping->backing_dev_info = bdi;
+		bdi = sb->s_bdev->bd_inode->i_mapping->a_bdi;
+		mapping_new_set_bdi(mapping, bdi);
 	}
 	inode->i_private = NULL;
 	inode->i_mapping = mapping;
Index: linux-2.6/fs/logfs/inode.c
===================================================================
--- linux-2.6.orig/fs/logfs/inode.c
+++ linux-2.6/fs/logfs/inode.c
@@ -258,7 +258,7 @@ struct inode *logfs_new_meta_inode(struc
 		mapping->flags = 0;
 		mapping_set_gfp_mask(mapping, GFP_NOFS);
 		mapping->assoc_mapping = NULL;
-		mapping->backing_dev_info = &default_backing_dev_info;
+		mapping_new_set_bdi(mapping, &default_backing_dev_info);
 		inode->i_mapping = mapping;
 		inode->i_nlink = 1;
 	}
Index: linux-2.6/fs/nilfs2/btnode.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/btnode.c
+++ linux-2.6/fs/nilfs2/btnode.c
@@ -59,7 +59,7 @@ void nilfs_btnode_cache_init(struct addr
 	btnc->flags = 0;
 	mapping_set_gfp_mask(btnc, GFP_NOFS);
 	btnc->assoc_mapping = NULL;
-	btnc->backing_dev_info = bdi;
+	mapping_new_set_bdi(btnc, bdi);
 	btnc->a_ops = &def_btnode_aops;
 }
 
Index: linux-2.6/fs/nilfs2/mdt.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/mdt.c
+++ linux-2.6/fs/nilfs2/mdt.c
@@ -516,7 +516,7 @@ nilfs_mdt_new_common(struct the_nilfs *n
 		mapping->flags = 0;
 		mapping_set_gfp_mask(mapping, gfp_mask);
 		mapping->assoc_mapping = NULL;
-		mapping->backing_dev_info = nilfs->ns_bdi;
+		mapping_new_set_bdi(mapping, nilfs->ns_bdi);
 
 		inode->i_mapping = mapping;
 	}
Index: linux-2.6/fs/ocfs2/dlmfs/dlmfs.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/dlmfs/dlmfs.c
+++ linux-2.6/fs/ocfs2/dlmfs/dlmfs.c
@@ -403,7 +403,7 @@ static struct inode *dlmfs_get_root_inod
 		inode->i_mode = mode;
 		inode->i_uid = current_fsuid();
 		inode->i_gid = current_fsgid();
-		inode->i_mapping->backing_dev_info = &dlmfs_backing_dev_info;
+		mapping_new_set_bdi(inode->i_mapping, &dlmfs_backing_dev_info);
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		inc_nlink(inode);
 
@@ -428,7 +428,7 @@ static struct inode *dlmfs_get_inode(str
 	inode->i_mode = mode;
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
-	inode->i_mapping->backing_dev_info = &dlmfs_backing_dev_info;
+	mapping_new_set_bdi(inode->i_mapping, &dlmfs_backing_dev_info);
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 
 	ip = DLMFS_I(inode);
Index: linux-2.6/fs/ramfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ramfs/inode.c
+++ linux-2.6/fs/ramfs/inode.c
@@ -60,7 +60,7 @@ struct inode *ramfs_get_inode(struct sup
 	if (inode) {
 		inode_init_owner(inode, dir, mode);
 		inode->i_mapping->a_ops = &ramfs_aops;
-		inode->i_mapping->backing_dev_info = &ramfs_backing_dev_info;
+		mapping_new_set_bdi(inode->i_mapping, &ramfs_backing_dev_info);
 		mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
 		mapping_set_unevictable(inode->i_mapping);
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
Index: linux-2.6/fs/sysfs/inode.c
===================================================================
--- linux-2.6.orig/fs/sysfs/inode.c
+++ linux-2.6/fs/sysfs/inode.c
@@ -251,7 +251,7 @@ static void sysfs_init_inode(struct sysf
 
 	inode->i_private = sysfs_get(sd);
 	inode->i_mapping->a_ops = &sysfs_aops;
-	inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
+	mapping_new_set_bdi(inode->i_mapping, &sysfs_backing_dev_info);
 	inode->i_op = &sysfs_inode_operations;
 
 	set_default_inode_attr(inode, sd->s_mode);
Index: linux-2.6/fs/ubifs/dir.c
===================================================================
--- linux-2.6.orig/fs/ubifs/dir.c
+++ linux-2.6/fs/ubifs/dir.c
@@ -109,7 +109,7 @@ struct inode *ubifs_new_inode(struct ubi
 			 ubifs_current_time(inode);
 	inode->i_mapping->nrpages = 0;
 	/* Disable readahead */
-	inode->i_mapping->backing_dev_info = &c->bdi;
+	mapping_new_set_bdi(inode->i_mapping, &c->bdi);
 
 	switch (mode & S_IFMT) {
 	case S_IFREG:
Index: linux-2.6/fs/ubifs/super.c
===================================================================
--- linux-2.6.orig/fs/ubifs/super.c
+++ linux-2.6/fs/ubifs/super.c
@@ -157,7 +157,7 @@ struct inode *ubifs_iget(struct super_bl
 		goto out_invalid;
 
 	/* Disable read-ahead */
-	inode->i_mapping->backing_dev_info = &c->bdi;
+	mapping_new_set_bdi(inode->i_mapping, &c->bdi);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
@@ -636,7 +636,7 @@ xfs_buf_readahead(
 {
 	struct backing_dev_info *bdi;
 
-	bdi = target->bt_mapping->backing_dev_info;
+	bdi = target->bt_mapping->a_bdi;
 	if (bdi_read_congested(bdi))
 		return;
 
@@ -1610,7 +1610,7 @@ xfs_mapping_buftarg(
 		bdi = &default_backing_dev_info;
 	mapping = &inode->i_data;
 	mapping->a_ops = &mapping_aops;
-	mapping->backing_dev_info = bdi;
+	mapping_new_set_bdi(mapping, bdi);
 	mapping_set_gfp_mask(mapping, GFP_NOFS);
 	btp->bt_mapping = mapping;
 	return 0;
Index: linux-2.6/kernel/cgroup.c
===================================================================
--- linux-2.6.orig/kernel/cgroup.c
+++ linux-2.6/kernel/cgroup.c
@@ -782,7 +782,7 @@ static struct inode *cgroup_new_inode(mo
 		inode->i_uid = current_fsuid();
 		inode->i_gid = current_fsgid();
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-		inode->i_mapping->backing_dev_info = &cgroup_backing_dev_info;
+		mapping_new_set_bdi(inode->i_mapping, &cgroup_backing_dev_info);
 	}
 	return inode;
 }
Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c
+++ linux-2.6/mm/shmem.c
@@ -1561,7 +1561,7 @@ static struct inode *shmem_get_inode(str
 	if (inode) {
 		inode_init_owner(inode, dir, mode);
 		inode->i_blocks = 0;
-		inode->i_mapping->backing_dev_info = &shmem_backing_dev_info;
+		mapping_new_set_bdi(inode->i_mapping, &shmem_backing_dev_info);
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		inode->i_generation = get_seconds();
 		info = SHMEM_I(inode);
Index: linux-2.6/fs/afs/write.c
===================================================================
--- linux-2.6.orig/fs/afs/write.c
+++ linux-2.6/fs/afs/write.c
@@ -438,7 +438,7 @@ no_more:
  */
 int afs_writepage(struct page *page, struct writeback_control *wbc)
 {
-	struct backing_dev_info *bdi = page->mapping->backing_dev_info;
+	struct backing_dev_info *bdi = page->mapping->a_bdi;
 	struct afs_writeback *wb;
 	int ret;
 
@@ -469,7 +469,7 @@ static int afs_writepages_region(struct
 				 struct writeback_control *wbc,
 				 pgoff_t index, pgoff_t end, pgoff_t *_next)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	struct backing_dev_info *bdi = mapping->a_bdi;
 	struct afs_writeback *wb;
 	struct page *page;
 	int ret, n;
@@ -548,7 +548,7 @@ static int afs_writepages_region(struct
 int afs_writepages(struct address_space *mapping,
 		   struct writeback_control *wbc)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	struct backing_dev_info *bdi = mapping->a_bdi;
 	pgoff_t start, end, next;
 	int ret;
 
@@ -680,7 +680,7 @@ int afs_writeback_all(struct afs_vnode *
 {
 	struct address_space *mapping = vnode->vfs_inode.i_mapping;
 	struct writeback_control wbc = {
-		.bdi		= mapping->backing_dev_info,
+		.bdi		= mapping->a_bdi,
 		.sync_mode	= WB_SYNC_ALL,
 		.nr_to_write	= LONG_MAX,
 		.range_cyclic	= 1,
Index: linux-2.6/fs/btrfs/extent_io.c
===================================================================
--- linux-2.6.orig/fs/btrfs/extent_io.c
+++ linux-2.6/fs/btrfs/extent_io.c
@@ -2628,7 +2628,7 @@ int extent_write_locked_range(struct ext
 		.sync_io = mode == WB_SYNC_ALL,
 	};
 	struct writeback_control wbc_writepages = {
-		.bdi		= inode->i_mapping->backing_dev_info,
+		.bdi		= inode->i_mapping->a_bdi,
 		.sync_mode	= mode,
 		.older_than_this = NULL,
 		.nr_to_write	= nr_pages * 2,
Index: linux-2.6/fs/btrfs/file.c
===================================================================
--- linux-2.6.orig/fs/btrfs/file.c
+++ linux-2.6/fs/btrfs/file.c
@@ -872,7 +872,7 @@ static ssize_t btrfs_file_aio_write(stru
 		goto out;
 	count = ocount;
 
-	current->backing_dev_info = inode->i_mapping->backing_dev_info;
+	current->backing_dev_info = inode->i_mapping->a_bdi;
 	err = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));
 	if (err)
 		goto out;
Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -3264,7 +3264,7 @@ void block_sync_page(struct page *page)
 	smp_mb();
 	mapping = page_mapping(page);
 	if (mapping)
-		blk_run_backing_dev(mapping->backing_dev_info, page);
+		blk_run_backing_dev(mapping->a_bdi, page);
 }
 EXPORT_SYMBOL(block_sync_page);
 
Index: linux-2.6/mm/fadvise.c
===================================================================
--- linux-2.6.orig/mm/fadvise.c
+++ linux-2.6/mm/fadvise.c
@@ -72,7 +72,7 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 	else
 		endbyte--;		/* inclusive */
 
-	bdi = mapping->backing_dev_info;
+	bdi = mapping->a_bdi;
 
 	switch (advice) {
 	case POSIX_FADV_NORMAL:
@@ -116,7 +116,7 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 	case POSIX_FADV_NOREUSE:
 		break;
 	case POSIX_FADV_DONTNEED:
-		if (!bdi_write_congested(mapping->backing_dev_info))
+		if (!bdi_write_congested(mapping->a_bdi))
 			filemap_flush(mapping);
 
 		/* First and last FULL page! */
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -136,7 +136,7 @@ void __remove_from_page_cache(struct pag
 	 */
 	if (PageDirty(page) && mapping_cap_account_dirty(mapping)) {
 		dec_zone_page_state(page, NR_FILE_DIRTY);
-		dec_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
+		dec_bdi_stat(mapping->a_bdi, BDI_RECLAIMABLE);
 	}
 }
 
@@ -2375,7 +2375,7 @@ ssize_t __generic_file_aio_write(struct
 	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
 
 	/* We can write back this queue in page reclaim */
-	current->backing_dev_info = mapping->backing_dev_info;
+	current->backing_dev_info = mapping->a_bdi;
 	written = 0;
 
 	err = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));
Index: linux-2.6/mm/filemap_xip.c
===================================================================
--- linux-2.6.orig/mm/filemap_xip.c
+++ linux-2.6/mm/filemap_xip.c
@@ -409,7 +409,7 @@ xip_file_write(struct file *filp, const
 	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
 
 	/* We can write back this queue in page reclaim */
-	current->backing_dev_info = mapping->backing_dev_info;
+	current->backing_dev_info = mapping->a_bdi;
 
 	ret = generic_write_checks(filp, &pos, &count, S_ISBLK(inode->i_mode));
 	if (ret)
Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c
+++ linux-2.6/mm/page-writeback.c
@@ -491,7 +491,7 @@ static void balance_dirty_pages(struct a
 	unsigned long pages_written = 0;
 	unsigned long pause = 1;
 
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	struct backing_dev_info *bdi = mapping->a_bdi;
 
 	for (;;) {
 		struct writeback_control wbc = {
@@ -633,7 +633,7 @@ void balance_dirty_pages_ratelimited_nr(
 	unsigned long *p;
 
 	ratelimit = ratelimit_pages;
-	if (mapping->backing_dev_info->dirty_exceeded)
+	if (mapping->a_bdi->dirty_exceeded)
 		ratelimit = 8;
 
 	/*
@@ -1093,7 +1093,7 @@ void account_page_dirtied(struct page *p
 {
 	if (mapping_cap_account_dirty(mapping)) {
 		__inc_zone_page_state(page, NR_FILE_DIRTY);
-		__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
+		__inc_bdi_stat(mapping->a_bdi, BDI_RECLAIMABLE);
 		task_dirty_inc(current);
 		task_io_account_write(PAGE_CACHE_SIZE);
 	}
@@ -1268,8 +1268,7 @@ int clear_page_dirty_for_io(struct page
 		 */
 		if (TestClearPageDirty(page)) {
 			dec_zone_page_state(page, NR_FILE_DIRTY);
-			dec_bdi_stat(mapping->backing_dev_info,
-					BDI_RECLAIMABLE);
+			dec_bdi_stat(mapping->a_bdi, BDI_RECLAIMABLE);
 			return 1;
 		}
 		return 0;
@@ -1284,7 +1283,7 @@ int test_clear_page_writeback(struct pag
 	int ret;
 
 	if (mapping) {
-		struct backing_dev_info *bdi = mapping->backing_dev_info;
+		struct backing_dev_info *bdi = mapping->a_bdi;
 		unsigned long flags;
 
 		spin_lock_irqsave(&mapping->tree_lock, flags);
@@ -1313,7 +1312,7 @@ int test_set_page_writeback(struct page
 	int ret;
 
 	if (mapping) {
-		struct backing_dev_info *bdi = mapping->backing_dev_info;
+		struct backing_dev_info *bdi = mapping->a_bdi;
 		unsigned long flags;
 
 		spin_lock_irqsave(&mapping->tree_lock, flags);
Index: linux-2.6/mm/readahead.c
===================================================================
--- linux-2.6.orig/mm/readahead.c
+++ linux-2.6/mm/readahead.c
@@ -25,7 +25,7 @@
 void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping)
 {
-	ra->ra_pages = mapping->backing_dev_info->ra_pages;
+	ra->ra_pages = mapping->a_bdi->ra_pages;
 	ra->prev_pos = -1;
 }
 EXPORT_SYMBOL_GPL(file_ra_state_init);
@@ -549,7 +549,7 @@ page_cache_async_readahead(struct addres
 	/*
 	 * Defer asynchronous read-ahead on IO congestion.
 	 */
-	if (bdi_read_congested(mapping->backing_dev_info))
+	if (bdi_read_congested(mapping->a_bdi))
 		return;
 
 	/* do read-ahead */
@@ -564,7 +564,7 @@ page_cache_async_readahead(struct addres
 	 * explicitly kick off the IO.
 	 */
 	if (PageUptodate(page))
-		blk_run_backing_dev(mapping->backing_dev_info, NULL);
+		blk_run_backing_dev(mapping->a_bdi, NULL);
 #endif
 }
 EXPORT_SYMBOL_GPL(page_cache_async_readahead);
Index: linux-2.6/mm/swap.c
===================================================================
--- linux-2.6.orig/mm/swap.c
+++ linux-2.6/mm/swap.c
@@ -501,7 +501,7 @@ void __init swap_setup(void)
 	unsigned long megs = totalram_pages >> (20 - PAGE_SHIFT);
 
 #ifdef CONFIG_SWAP
-	bdi_init(swapper_space.backing_dev_info);
+	bdi_init(swapper_space.a_bdi);
 #endif
 
 	/* Use a smaller cluster for small-memory machines */
Index: linux-2.6/mm/swap_state.c
===================================================================
--- linux-2.6.orig/mm/swap_state.c
+++ linux-2.6/mm/swap_state.c
@@ -45,7 +45,7 @@ struct address_space swapper_space = {
 	.tree_lock	= __SPIN_LOCK_UNLOCKED(swapper_space.tree_lock),
 	.a_ops		= &swap_aops,
 	.i_mmap_nonlinear = LIST_HEAD_INIT(swapper_space.i_mmap_nonlinear),
-	.backing_dev_info = &swap_backing_dev_info,
+	.a_bdi		= &swap_backing_dev_info,
 };
 
 #define INC_CACHE_INFO(x)	do { swap_cache_info.x++; } while (0)
Index: linux-2.6/mm/swapfile.c
===================================================================
--- linux-2.6.orig/mm/swapfile.c
+++ linux-2.6/mm/swapfile.c
@@ -116,7 +116,7 @@ void swap_unplug_io_fn(struct backing_de
 		 */
 		WARN_ON(page_count(page) <= 1);
 
-		bdi = bdev->bd_inode->i_mapping->backing_dev_info;
+		bdi = bdev->bd_inode->i_mapping->a_bdi;
 		blk_run_backing_dev(bdi, page);
 	}
 	up_read(&swap_unplug_sem);
Index: linux-2.6/mm/truncate.c
===================================================================
--- linux-2.6.orig/mm/truncate.c
+++ linux-2.6/mm/truncate.c
@@ -75,8 +75,7 @@ void cancel_dirty_page(struct page *page
 		struct address_space *mapping = page->mapping;
 		if (mapping && mapping_cap_account_dirty(mapping)) {
 			dec_zone_page_state(page, NR_FILE_DIRTY);
-			dec_bdi_stat(mapping->backing_dev_info,
-					BDI_RECLAIMABLE);
+			dec_bdi_stat(mapping->a_bdi, BDI_RECLAIMABLE);
 			if (account_size)
 				task_io_account_cancelled_write(account_size);
 		}
Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c
+++ linux-2.6/mm/vmscan.c
@@ -361,7 +361,7 @@ static pageout_t pageout(struct page *pa
 	}
 	if (mapping->a_ops->writepage == NULL)
 		return PAGE_ACTIVATE;
-	if (!may_write_to_queue(mapping->backing_dev_info))
+	if (!may_write_to_queue(mapping->a_bdi))
 		return PAGE_KEEP;
 
 	if (clear_page_dirty_for_io(page)) {
Index: linux-2.6/fs/ext2/ialloc.c
===================================================================
--- linux-2.6.orig/fs/ext2/ialloc.c
+++ linux-2.6/fs/ext2/ialloc.c
@@ -177,7 +177,7 @@ static void ext2_preread_inode(struct in
 	struct ext2_group_desc * gdp;
 	struct backing_dev_info *bdi;
 
-	bdi = inode->i_mapping->backing_dev_info;
+	bdi = inode->i_mapping->a_bdi;
 	if (bdi_read_congested(bdi))
 		return;
 	if (bdi_write_congested(bdi))
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -28,7 +28,7 @@
 #include <linux/buffer_head.h>
 #include "internal.h"
 
-#define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
+#define inode_to_bdi(inode)	((inode)->i_mapping->a_bdi)
 
 /*
  * We don't actually have pdflush, but this one is exported though /proc...
Index: linux-2.6/drivers/mtd/mtdchar.c
===================================================================
--- linux-2.6.orig/drivers/mtd/mtdchar.c
+++ linux-2.6/drivers/mtd/mtdchar.c
@@ -99,7 +99,7 @@ static int mtd_open(struct inode *inode,
 	if (mtd_ino->i_state & I_NEW) {
 		mtd_ino->i_private = mtd;
 		mtd_ino->i_mode = S_IFCHR;
-		mtd_ino->i_data.backing_dev_info = mtd->backing_dev_info;
+		mapping_new_set_bdi(&mtd_ino->i_data, mtd->backing_dev_info);
 		unlock_new_inode(mtd_ino);
 	}
 	file->f_mapping = mtd_ino->i_mapping;
Index: linux-2.6/fs/ceph/addr.c
===================================================================
--- linux-2.6.orig/fs/ceph/addr.c
+++ linux-2.6/fs/ceph/addr.c
@@ -108,8 +108,7 @@ static int ceph_set_page_dirty(struct pa
 
 		if (mapping_cap_account_dirty(mapping)) {
 			__inc_zone_page_state(page, NR_FILE_DIRTY);
-			__inc_bdi_stat(mapping->backing_dev_info,
-					BDI_RECLAIMABLE);
+			__inc_bdi_stat(mapping->a_bdi, BDI_RECLAIMABLE);
 			task_io_account_write(PAGE_CACHE_SIZE);
 		}
 		radix_tree_tag_set(&mapping->page_tree,
@@ -593,7 +592,7 @@ static int ceph_writepages_start(struct
 				 struct writeback_control *wbc)
 {
 	struct inode *inode = mapping->host;
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	struct backing_dev_info *bdi = mapping->a_bdi;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_client *client;
 	pgoff_t index, start, end;
Index: linux-2.6/fs/cifs/file.c
===================================================================
--- linux-2.6.orig/fs/cifs/file.c
+++ linux-2.6/fs/cifs/file.c
@@ -1365,7 +1365,7 @@ static int cifs_partialpagewrite(struct
 static int cifs_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	struct backing_dev_info *bdi = mapping->a_bdi;
 	unsigned int bytes_to_write;
 	unsigned int bytes_written;
 	struct cifs_sb_info *cifs_sb;
Index: linux-2.6/fs/fuse/file.c
===================================================================
--- linux-2.6.orig/fs/fuse/file.c
+++ linux-2.6/fs/fuse/file.c
@@ -945,7 +945,7 @@ static ssize_t fuse_file_aio_write(struc
 	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
 
 	/* We can write back this queue in page reclaim */
-	current->backing_dev_info = mapping->backing_dev_info;
+	current->backing_dev_info = mapping->a_bdi;
 
 	err = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));
 	if (err)
@@ -1133,7 +1133,7 @@ static void fuse_writepage_finish(struct
 {
 	struct inode *inode = req->inode;
 	struct fuse_inode *fi = get_fuse_inode(inode);
-	struct backing_dev_info *bdi = inode->i_mapping->backing_dev_info;
+	struct backing_dev_info *bdi = inode->i_mapping->a_bdi;
 
 	list_del(&req->writepages_entry);
 	dec_bdi_stat(bdi, BDI_WRITEBACK);
@@ -1247,7 +1247,7 @@ static int fuse_writepage_locked(struct
 	req->end = fuse_writepage_end;
 	req->inode = inode;
 
-	inc_bdi_stat(mapping->backing_dev_info, BDI_WRITEBACK);
+	inc_bdi_stat(mapping->a_bdi, BDI_WRITEBACK);
 	inc_zone_page_state(tmp_page, NR_WRITEBACK_TEMP);
 	end_page_writeback(page);
 
Index: linux-2.6/fs/fuse/inode.c
===================================================================
--- linux-2.6.orig/fs/fuse/inode.c
+++ linux-2.6/fs/fuse/inode.c
@@ -254,7 +254,7 @@ struct inode *fuse_iget(struct super_blo
 	if ((inode->i_state & I_NEW)) {
 		inode->i_flags |= S_NOATIME|S_NOCMTIME;
 		inode->i_generation = generation;
-		inode->i_data.backing_dev_info = &fc->bdi;
+		mapping_new_set_bdi(&inode->i_data, &fc->bdi);
 		fuse_init_inode(inode, attr);
 		unlock_new_inode(inode);
 	} else if ((inode->i_mode ^ attr->mode) & S_IFMT) {
Index: linux-2.6/fs/nfs/inode.c
===================================================================
--- linux-2.6.orig/fs/nfs/inode.c
+++ linux-2.6/fs/nfs/inode.c
@@ -280,7 +280,7 @@ nfs_fhget(struct super_block *sb, struct
 		if (S_ISREG(inode->i_mode)) {
 			inode->i_fop = &nfs_file_operations;
 			inode->i_data.a_ops = &nfs_file_aops;
-			inode->i_data.backing_dev_info = &NFS_SB(sb)->backing_dev_info;
+			mapping_new_set_bdi(&inode->i_data, &NFS_SB(sb)->backing_dev_info);
 		} else if (S_ISDIR(inode->i_mode)) {
 			inode->i_op = NFS_SB(sb)->nfs_client->rpc_ops->dir_inode_ops;
 			inode->i_fop = &nfs_dir_operations;
Index: linux-2.6/fs/nfs/write.c
===================================================================
--- linux-2.6.orig/fs/nfs/write.c
+++ linux-2.6/fs/nfs/write.c
@@ -444,7 +444,7 @@ nfs_mark_request_commit(struct nfs_page
 	nfsi->ncommit++;
 	spin_unlock(&inode->i_lock);
 	inc_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
-	inc_bdi_stat(req->wb_page->mapping->backing_dev_info, BDI_RECLAIMABLE);
+	inc_bdi_stat(req->wb_page->mapping->a_bdi, BDI_RECLAIMABLE);
 	__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
 }
 
@@ -455,7 +455,7 @@ nfs_clear_request_commit(struct nfs_page
 
 	if (test_and_clear_bit(PG_CLEAN, &(req)->wb_flags)) {
 		dec_zone_page_state(page, NR_UNSTABLE_NFS);
-		dec_bdi_stat(page->mapping->backing_dev_info, BDI_RECLAIMABLE);
+		dec_bdi_stat(page->mapping->a_bdi, BDI_RECLAIMABLE);
 		return 1;
 	}
 	return 0;
@@ -1307,8 +1307,7 @@ nfs_commit_list(struct inode *inode, str
 		nfs_list_remove_request(req);
 		nfs_mark_request_commit(req);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
-		dec_bdi_stat(req->wb_page->mapping->backing_dev_info,
-				BDI_RECLAIMABLE);
+		dec_bdi_stat(req->wb_page->mapping->a_bdi, BDI_RECLAIMABLE);
 		nfs_clear_page_tag_locked(req);
 	}
 	nfs_commit_clear_lock(NFS_I(inode));
Index: linux-2.6/fs/nilfs2/the_nilfs.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/the_nilfs.c
+++ linux-2.6/fs/nilfs2/the_nilfs.c
@@ -613,7 +613,7 @@ int init_nilfs(struct the_nilfs *nilfs,
 
 	nilfs->ns_mount_state = le16_to_cpu(sbp->s_state);
 
-	bdi = nilfs->ns_bdev->bd_inode->i_mapping->backing_dev_info;
+	bdi = nilfs->ns_bdev->bd_inode->i_mapping->a_bdi;
 	nilfs->ns_bdi = bdi ? : &default_backing_dev_info;
 
 	/* Finding last segment */
Index: linux-2.6/fs/ntfs/file.c
===================================================================
--- linux-2.6.orig/fs/ntfs/file.c
+++ linux-2.6/fs/ntfs/file.c
@@ -2088,7 +2088,7 @@ static ssize_t ntfs_file_aio_write_noloc
 	pos = *ppos;
 	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
 	/* We can write back this queue in page reclaim. */
-	current->backing_dev_info = mapping->backing_dev_info;
+	current->backing_dev_info = mapping->a_bdi;
 	written = 0;
 	err = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));
 	if (err)
Index: linux-2.6/fs/ocfs2/file.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/file.c
+++ linux-2.6/fs/ocfs2/file.c
@@ -2129,7 +2129,7 @@ relock:
 			goto out_dio;
 		}
 	} else {
-		current->backing_dev_info = file->f_mapping->backing_dev_info;
+		current->backing_dev_info = file->f_mapping->a_bdi;
 		written = generic_file_buffered_write(iocb, iov, nr_segs, *ppos,
 						      ppos, count, 0);
 		current->backing_dev_info = NULL;
Index: linux-2.6/fs/romfs/super.c
===================================================================
--- linux-2.6.orig/fs/romfs/super.c
+++ linux-2.6/fs/romfs/super.c
@@ -356,8 +356,8 @@ static struct inode *romfs_iget(struct s
 		i->i_fop = &romfs_ro_fops;
 		i->i_data.a_ops = &romfs_aops;
 		if (i->i_sb->s_mtd)
-			i->i_data.backing_dev_info =
-				i->i_sb->s_mtd->backing_dev_info;
+			mapping_new_set_bdi(&i->i_data,
+				i->i_sb->s_mtd->backing_dev_info);
 		if (nextfh & ROMFH_EXEC)
 			mode |= S_IXUGO;
 		break;
Index: linux-2.6/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_file.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_file.c
@@ -756,7 +756,7 @@ start:
 		goto out_unlock_internal;
 
 	/* We can write back this queue in page reclaim */
-	current->backing_dev_info = mapping->backing_dev_info;
+	current->backing_dev_info = mapping->a_bdi;
 
 	if ((ioflags & IO_ISDIRECT)) {
 		if (mapping->nrpages) {


