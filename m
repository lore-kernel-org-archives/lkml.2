Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab0JHFXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:23:42 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:35890 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752855Ab0JHFWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:22:20 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/18] fs: keep inode with backing-dev
Date: Fri,  8 Oct 2010 16:21:17 +1100
Message-Id: <1286515292-15882-4-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286515292-15882-1-git-send-email-david@fromorbit.com>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

Having inode on writeback lists of a different bdi than
inode->i_mapping->backing_dev_info makes it very difficult to do
per-bdi locking of the writeback lists. Add functions to move these
inodes over when the mapping backing dev is changed.

Also, rename i_mapping.backing_dev_info to i_mapping.a_bdi while we're
here. Succinct is nice, and it catches conversion errors.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 drivers/char/mem.c          |    2 +-
 drivers/char/raw.c          |    2 +-
 drivers/mtd/mtdchar.c       |    2 +-
 fs/afs/write.c              |    6 ++--
 fs/block_dev.c              |   13 +++++----
 fs/btrfs/disk-io.c          |    2 +-
 fs/btrfs/file.c             |    2 +-
 fs/btrfs/inode.c            |   10 +++---
 fs/buffer.c                 |    2 +-
 fs/ceph/addr.c              |    2 +-
 fs/ceph/inode.c             |    4 +-
 fs/cifs/file.c              |    2 +-
 fs/cifs/inode.c             |    2 +-
 fs/configfs/inode.c         |    3 +-
 fs/ext2/ialloc.c            |    2 +-
 fs/fs-writeback.c           |    2 +-
 fs/fuse/file.c              |    6 ++--
 fs/fuse/inode.c             |    2 +-
 fs/gfs2/glock.c             |    3 +-
 fs/hugetlbfs/inode.c        |    3 +-
 fs/inode.c                  |    6 ++--
 fs/nfs/inode.c              |    3 +-
 fs/nfs/write.c              |    7 ++---
 fs/nilfs2/btnode.c          |    2 +-
 fs/nilfs2/mdt.c             |    2 +-
 fs/nilfs2/the_nilfs.c       |    2 +-
 fs/ntfs/file.c              |    2 +-
 fs/ocfs2/dlmfs/dlmfs.c      |    4 +-
 fs/ocfs2/file.c             |    2 +-
 fs/ramfs/inode.c            |    2 +-
 fs/romfs/super.c            |    4 +-
 fs/sysfs/inode.c            |    2 +-
 fs/ubifs/dir.c              |    2 +-
 fs/ubifs/super.c            |    2 +-
 fs/xfs/linux-2.6/xfs_buf.c  |    4 +-
 fs/xfs/linux-2.6/xfs_file.c |    2 +-
 include/linux/backing-dev.h |   16 ++++++++---
 include/linux/fs.h          |    2 +-
 kernel/cgroup.c             |    2 +-
 mm/backing-dev.c            |   61 ++++++++++++++++++++++++++++++++++++++++--
 mm/fadvise.c                |    4 +-
 mm/filemap.c                |    4 +-
 mm/filemap_xip.c            |    2 +-
 mm/page-writeback.c         |   15 +++++-----
 mm/readahead.c              |    6 ++--
 mm/shmem.c                  |    2 +-
 mm/swap.c                   |    2 +-
 mm/swap_state.c             |    2 +-
 mm/swapfile.c               |    2 +-
 mm/truncate.c               |    3 +-
 mm/vmscan.c                 |    2 +-
 51 files changed, 155 insertions(+), 90 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 1f528fa..2285c1e 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -872,7 +872,7 @@ static int memory_open(struct inode *inode, struct file *filp)
 
 	filp->f_op = dev->fops;
 	if (dev->dev_info)
-		filp->f_mapping->backing_dev_info = dev->dev_info;
+		mapping_set_bdi(filp->f_mapping, dev->dev_info);
 
 	if (dev->fops->open)
 		return dev->fops->open(inode, filp);
diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index b38942f..5baa83f 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -109,7 +109,7 @@ static int raw_release(struct inode *inode, struct file *filp)
 	if (--raw_devices[minor].inuse == 0) {
 		/* Here  inode->i_mapping == bdev->bd_inode->i_mapping  */
 		inode->i_mapping = &inode->i_data;
-		inode->i_mapping->backing_dev_info = &default_backing_dev_info;
+		mapping_set_bdi(inode->i_mapping, &default_backing_dev_info);
 	}
 	mutex_unlock(&raw_mutex);
 
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index a825002..26af8b1 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -113,7 +113,7 @@ static int mtd_open(struct inode *inode, struct file *file)
 	if (mtd_ino->i_state & I_NEW) {
 		mtd_ino->i_private = mtd;
 		mtd_ino->i_mode = S_IFCHR;
-		mtd_ino->i_data.backing_dev_info = mtd->backing_dev_info;
+		mapping_new_set_bdi(&mtd_ino->i_data, mtd->backing_dev_info);
 		unlock_new_inode(mtd_ino);
 	}
 	file->f_mapping = mtd_ino->i_mapping;
diff --git a/fs/afs/write.c b/fs/afs/write.c
index 722743b..b321bfc 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -438,7 +438,7 @@ no_more:
  */
 int afs_writepage(struct page *page, struct writeback_control *wbc)
 {
-	struct backing_dev_info *bdi = page->mapping->backing_dev_info;
+	struct backing_dev_info *bdi = page->mapping->a_bdi;
 	struct afs_writeback *wb;
 	int ret;
 
@@ -469,7 +469,7 @@ static int afs_writepages_region(struct address_space *mapping,
 				 struct writeback_control *wbc,
 				 pgoff_t index, pgoff_t end, pgoff_t *_next)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	struct backing_dev_info *bdi = mapping->a_bdi;
 	struct afs_writeback *wb;
 	struct page *page;
 	int ret, n;
@@ -548,7 +548,7 @@ static int afs_writepages_region(struct address_space *mapping,
 int afs_writepages(struct address_space *mapping,
 		   struct writeback_control *wbc)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	struct backing_dev_info *bdi = mapping->a_bdi;
 	pgoff_t start, end, next;
 	int ret;
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 50e8c85..ac070d7 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -533,7 +533,7 @@ struct block_device *bdget(dev_t dev)
 		inode->i_bdev = bdev;
 		inode->i_data.a_ops = &def_blk_aops;
 		mapping_set_gfp_mask(&inode->i_data, GFP_USER);
-		inode->i_data.backing_dev_info = &default_backing_dev_info;
+		mapping_new_set_bdi(&inode->i_data, &default_backing_dev_info);
 		spin_lock(&bdev_lock);
 		list_add(&bdev->bd_list, &all_bdevs);
 		spin_unlock(&bdev_lock);
@@ -1390,7 +1390,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 				bdi = blk_get_backing_dev_info(bdev);
 				if (bdi == NULL)
 					bdi = &default_backing_dev_info;
-				bdev->bd_inode->i_data.backing_dev_info = bdi;
+				mapping_set_bdi(&bdev->bd_inode->i_data, bdi);
 			}
 			if (bdev->bd_invalidated)
 				rescan_partitions(disk, bdev);
@@ -1405,8 +1405,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
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
@@ -1439,7 +1439,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	disk_put_part(bdev->bd_part);
 	bdev->bd_disk = NULL;
 	bdev->bd_part = NULL;
-	bdev->bd_inode->i_data.backing_dev_info = &default_backing_dev_info;
+	mapping_set_bdi(&bdev->bd_inode->i_data, &default_backing_dev_info);
 	if (bdev != bdev->bd_contains)
 		__blkdev_put(bdev->bd_contains, mode, 1);
 	bdev->bd_contains = NULL;
@@ -1533,7 +1533,8 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 		disk_put_part(bdev->bd_part);
 		bdev->bd_part = NULL;
 		bdev->bd_disk = NULL;
-		bdev->bd_inode->i_data.backing_dev_info = &default_backing_dev_info;
+		mapping_set_bdi(&bdev->bd_inode->i_data,
+				&default_backing_dev_info);
 		if (bdev != bdev->bd_contains)
 			victim = bdev->bd_contains;
 		bdev->bd_contains = NULL;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 64f1008..05c3fc7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1636,7 +1636,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	 */
 	fs_info->btree_inode->i_size = OFFSET_MAX;
 	fs_info->btree_inode->i_mapping->a_ops = &btree_aops;
-	fs_info->btree_inode->i_mapping->backing_dev_info = &fs_info->bdi;
+	mapping_new_set_bdi(fs_info->btree_inode->i_mapping, &fs_info->bdi);
 
 	RB_CLEAR_NODE(&BTRFS_I(fs_info->btree_inode)->rb_node);
 	extent_io_tree_init(&BTRFS_I(fs_info->btree_inode)->io_tree,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e354c33..96e3883 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -872,7 +872,7 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 		goto out;
 	count = ocount;
 
-	current->backing_dev_info = inode->i_mapping->backing_dev_info;
+	current->backing_dev_info = inode->i_mapping->a_bdi;
 	err = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));
 	if (err)
 		goto out;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c038644..c646c0c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2475,7 +2475,7 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
 		inode->i_mapping->a_ops = &btrfs_aops;
-		inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
+		mapping_new_set_bdi(inode->i_mapping, &root->fs_info->bdi);
 		BTRFS_I(inode)->io_tree.ops = &btrfs_extent_io_ops;
 		inode->i_fop = &btrfs_file_operations;
 		inode->i_op = &btrfs_file_inode_operations;
@@ -2490,7 +2490,7 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	case S_IFLNK:
 		inode->i_op = &btrfs_symlink_inode_operations;
 		inode->i_mapping->a_ops = &btrfs_symlink_aops;
-		inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
+		mapping_new_set_bdi(inode->i_mapping, &root->fs_info->bdi);
 		break;
 	default:
 		inode->i_op = &btrfs_special_inode_operations;
@@ -4705,7 +4705,7 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 		drop_inode = 1;
 	else {
 		inode->i_mapping->a_ops = &btrfs_aops;
-		inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
+		mapping_new_set_bdi(inode->i_mapping, &root->fs_info->bdi);
 		inode->i_fop = &btrfs_file_operations;
 		inode->i_op = &btrfs_file_inode_operations;
 		BTRFS_I(inode)->io_tree.ops = &btrfs_extent_io_ops;
@@ -6699,7 +6699,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 		drop_inode = 1;
 	else {
 		inode->i_mapping->a_ops = &btrfs_aops;
-		inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
+		mapping_new_set_bdi(inode->i_mapping, &root->fs_info->bdi);
 		inode->i_fop = &btrfs_file_operations;
 		inode->i_op = &btrfs_file_inode_operations;
 		BTRFS_I(inode)->io_tree.ops = &btrfs_extent_io_ops;
@@ -6739,7 +6739,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 
 	inode->i_op = &btrfs_symlink_inode_operations;
 	inode->i_mapping->a_ops = &btrfs_symlink_aops;
-	inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
+	mapping_new_set_bdi(inode->i_mapping, &root->fs_info->bdi);
 	inode_set_bytes(inode, name_len);
 	btrfs_i_size_write(inode, name_len - 1);
 	err = btrfs_update_inode(trans, root, inode);
diff --git a/fs/buffer.c b/fs/buffer.c
index 3e7dca2..b5c4153 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3161,7 +3161,7 @@ void block_sync_page(struct page *page)
 	smp_mb();
 	mapping = page_mapping(page);
 	if (mapping)
-		blk_run_backing_dev(mapping->backing_dev_info, page);
+		blk_run_backing_dev(mapping->a_bdi, page);
 }
 EXPORT_SYMBOL(block_sync_page);
 
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index efbc604..448400a 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -588,7 +588,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 				 struct writeback_control *wbc)
 {
 	struct inode *inode = mapping->host;
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	struct backing_dev_info *bdi = mapping->a_bdi;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_client *client;
 	pgoff_t index, start, end;
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 62377ec..e427082 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -624,8 +624,8 @@ static int fill_inode(struct inode *inode,
 	}
 
 	inode->i_mapping->a_ops = &ceph_aops;
-	inode->i_mapping->backing_dev_info =
-		&ceph_sb_to_client(inode->i_sb)->backing_dev_info;
+	mapping_new_set_bdi(inode->i_mapping,
+			&ceph_sb_to_client(inode->i_sb)->backing_dev_info);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index de748c6..3673e66 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1337,7 +1337,7 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 static int cifs_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	struct backing_dev_info *bdi = mapping->a_bdi;
 	unsigned int bytes_to_write;
 	unsigned int bytes_written;
 	struct cifs_sb_info *cifs_sb;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 53cce8c..63a0bdb 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -802,7 +802,7 @@ retry_iget5_locked:
 		if (inode->i_state & I_NEW) {
 			inode->i_ino = hash;
 			if (S_ISREG(inode->i_mode))
-				inode->i_data.backing_dev_info = sb->s_bdi;
+				inode->i_data.a_bdi = sb->s_bdi;
 #ifdef CONFIG_CIFS_FSCACHE
 			/* initialize per-inode cache cookie pointer */
 			CIFS_I(inode)->fscache = NULL;
diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index cf78d44..40b2bec 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -136,7 +136,8 @@ struct inode * configfs_new_inode(mode_t mode, struct configfs_dirent * sd)
 	struct inode * inode = new_inode(configfs_sb);
 	if (inode) {
 		inode->i_mapping->a_ops = &configfs_aops;
-		inode->i_mapping->backing_dev_info = &configfs_backing_dev_info;
+		mapping_new_set_bdi(inode->i_mapping,
+				&configfs_backing_dev_info);
 		inode->i_op = &configfs_inode_operations;
 
 		if (sd->s_iattr) {
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index ad70479..29942f0 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -172,7 +172,7 @@ static void ext2_preread_inode(struct inode *inode)
 	struct ext2_group_desc * gdp;
 	struct backing_dev_info *bdi;
 
-	bdi = inode->i_mapping->backing_dev_info;
+	bdi = inode->i_mapping->a_bdi;
 	if (bdi_read_congested(bdi))
 		return;
 	if (bdi_write_congested(bdi))
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 58a95b7..3209aff 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -74,7 +74,7 @@ static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
 	struct super_block *sb = inode->i_sb;
 
 	if (strcmp(sb->s_type->name, "bdev") == 0)
-		return inode->i_mapping->backing_dev_info;
+		return inode->i_mapping->a_bdi;
 
 	return sb->s_bdi;
 }
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index c822458..193a0d1 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -945,7 +945,7 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
 
 	/* We can write back this queue in page reclaim */
-	current->backing_dev_info = mapping->backing_dev_info;
+	current->backing_dev_info = mapping->a_bdi;
 
 	err = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));
 	if (err)
@@ -1133,7 +1133,7 @@ static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
 {
 	struct inode *inode = req->inode;
 	struct fuse_inode *fi = get_fuse_inode(inode);
-	struct backing_dev_info *bdi = inode->i_mapping->backing_dev_info;
+	struct backing_dev_info *bdi = inode->i_mapping->a_bdi;
 
 	list_del(&req->writepages_entry);
 	dec_bdi_stat(bdi, BDI_WRITEBACK);
@@ -1247,7 +1247,7 @@ static int fuse_writepage_locked(struct page *page)
 	req->end = fuse_writepage_end;
 	req->inode = inode;
 
-	inc_bdi_stat(mapping->backing_dev_info, BDI_WRITEBACK);
+	inc_bdi_stat(mapping->a_bdi, BDI_WRITEBACK);
 	inc_zone_page_state(tmp_page, NR_WRITEBACK_TEMP);
 	end_page_writeback(page);
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index da9e6e1..5cf105c 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -256,7 +256,7 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 	if ((inode->i_state & I_NEW)) {
 		inode->i_flags |= S_NOATIME|S_NOCMTIME;
 		inode->i_generation = generation;
-		inode->i_data.backing_dev_info = &fc->bdi;
+		mapping_new_set_bdi(&inode->i_data, &fc->bdi);
 		fuse_init_inode(inode, attr);
 		unlock_new_inode(inode);
 	} else if ((inode->i_mode ^ attr->mode) & S_IFMT) {
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 9adf8f9..c8f4c50 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/sched.h>
+#include <linux/backing-dev.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/buffer_head.h>
@@ -797,7 +798,7 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 		mapping->flags = 0;
 		mapping_set_gfp_mask(mapping, GFP_NOFS);
 		mapping->assoc_mapping = NULL;
-		mapping->backing_dev_info = s->s_bdi;
+		mapping_new_set_bdi(mapping, s->s_bdi);
 		mapping->writeback_index = 0;
 	}
 
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 6e5bd42..a37920a 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -459,7 +459,8 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb, uid_t uid,
 		inode->i_uid = uid;
 		inode->i_gid = gid;
 		inode->i_mapping->a_ops = &hugetlbfs_aops;
-		inode->i_mapping->backing_dev_info =&hugetlbfs_backing_dev_info;
+		mapping_new_set_bdi(inode->i_mapping,
+				&hugetlbfs_backing_dev_info);
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		INIT_LIST_HEAD(&inode->i_mapping->private_list);
 		info = HUGETLBFS_I(inode);
diff --git a/fs/inode.c b/fs/inode.c
index f04d501..22ef3f1 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -201,7 +201,7 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	mapping->flags = 0;
 	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_MOVABLE);
 	mapping->assoc_mapping = NULL;
-	mapping->backing_dev_info = &default_backing_dev_info;
+	mapping_new_set_bdi(mapping, &default_backing_dev_info);
 	mapping->writeback_index = 0;
 
 	/*
@@ -212,8 +212,8 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	if (sb->s_bdev) {
 		struct backing_dev_info *bdi;
 
-		bdi = sb->s_bdev->bd_inode->i_mapping->backing_dev_info;
-		mapping->backing_dev_info = bdi;
+		bdi = sb->s_bdev->bd_inode->i_mapping->a_bdi;
+		mapping_new_set_bdi(mapping, bdi);
 	}
 	inode->i_private = NULL;
 	inode->i_mapping = mapping;
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 7d2d6c7..886be68 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -287,7 +287,8 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 		if (S_ISREG(inode->i_mode)) {
 			inode->i_fop = &nfs_file_operations;
 			inode->i_data.a_ops = &nfs_file_aops;
-			inode->i_data.backing_dev_info = &NFS_SB(sb)->backing_dev_info;
+			mapping_new_set_bdi(&inode->i_data,
+						&NFS_SB(sb)->backing_dev_info);
 		} else if (S_ISDIR(inode->i_mode)) {
 			inode->i_op = NFS_SB(sb)->nfs_client->rpc_ops->dir_inode_ops;
 			inode->i_fop = &nfs_dir_operations;
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 874972d..a8baf4b 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -455,7 +455,7 @@ nfs_mark_request_commit(struct nfs_page *req)
 	nfsi->ncommit++;
 	spin_unlock(&inode->i_lock);
 	inc_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
-	inc_bdi_stat(req->wb_page->mapping->backing_dev_info, BDI_RECLAIMABLE);
+	inc_bdi_stat(req->wb_page->mapping->a_bdi, BDI_RECLAIMABLE);
 	__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
 }
 
@@ -466,7 +466,7 @@ nfs_clear_request_commit(struct nfs_page *req)
 
 	if (test_and_clear_bit(PG_CLEAN, &(req)->wb_flags)) {
 		dec_zone_page_state(page, NR_UNSTABLE_NFS);
-		dec_bdi_stat(page->mapping->backing_dev_info, BDI_RECLAIMABLE);
+		dec_bdi_stat(page->mapping->a_bdi, BDI_RECLAIMABLE);
 		return 1;
 	}
 	return 0;
@@ -1321,8 +1321,7 @@ nfs_commit_list(struct inode *inode, struct list_head *head, int how)
 		nfs_list_remove_request(req);
 		nfs_mark_request_commit(req);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
-		dec_bdi_stat(req->wb_page->mapping->backing_dev_info,
-				BDI_RECLAIMABLE);
+		dec_bdi_stat(req->wb_page->mapping->a_bdi, BDI_RECLAIMABLE);
 		nfs_clear_page_tag_locked(req);
 	}
 	nfs_commit_clear_lock(NFS_I(inode));
diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index f78ab10..d74ed8f 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -59,7 +59,7 @@ void nilfs_btnode_cache_init(struct address_space *btnc,
 	btnc->flags = 0;
 	mapping_set_gfp_mask(btnc, GFP_NOFS);
 	btnc->assoc_mapping = NULL;
-	btnc->backing_dev_info = bdi;
+	mapping_new_set_bdi(btnc, bdi);
 	btnc->a_ops = &def_btnode_aops;
 }
 
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index d01aff4..7713861 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -517,7 +517,7 @@ nilfs_mdt_new_common(struct the_nilfs *nilfs, struct super_block *sb,
 		mapping->flags = 0;
 		mapping_set_gfp_mask(mapping, gfp_mask);
 		mapping->assoc_mapping = NULL;
-		mapping->backing_dev_info = nilfs->ns_bdi;
+		mapping_new_set_bdi(mapping, nilfs->ns_bdi);
 
 		inode->i_mapping = mapping;
 	}
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index ba7c10c..cb81695 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -729,7 +729,7 @@ int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
 
 	nilfs->ns_mount_state = le16_to_cpu(sbp->s_state);
 
-	bdi = nilfs->ns_bdev->bd_inode->i_mapping->backing_dev_info;
+	bdi = nilfs->ns_bdev->bd_inode->i_mapping->a_bdi;
 	nilfs->ns_bdi = bdi ? : &default_backing_dev_info;
 
 	err = nilfs_store_log_cursor(nilfs, sbp);
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 113ebd9..19f9447 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -2088,7 +2088,7 @@ static ssize_t ntfs_file_aio_write_nolock(struct kiocb *iocb,
 	pos = *ppos;
 	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
 	/* We can write back this queue in page reclaim. */
-	current->backing_dev_info = mapping->backing_dev_info;
+	current->backing_dev_info = mapping->a_bdi;
 	written = 0;
 	err = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));
 	if (err)
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index c2903b8..6b931db 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -403,7 +403,7 @@ static struct inode *dlmfs_get_root_inode(struct super_block *sb)
 		inode->i_mode = mode;
 		inode->i_uid = current_fsuid();
 		inode->i_gid = current_fsgid();
-		inode->i_mapping->backing_dev_info = &dlmfs_backing_dev_info;
+		mapping_new_set_bdi(inode->i_mapping, &dlmfs_backing_dev_info);
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		inc_nlink(inode);
 
@@ -428,7 +428,7 @@ static struct inode *dlmfs_get_inode(struct inode *parent,
 	inode->i_mode = mode;
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
-	inode->i_mapping->backing_dev_info = &dlmfs_backing_dev_info;
+	mapping_new_set_bdi(inode->i_mapping, &dlmfs_backing_dev_info);
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 
 	ip = DLMFS_I(inode);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 9a03c15..863e016 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2327,7 +2327,7 @@ relock:
 			goto out_dio;
 		}
 	} else {
-		current->backing_dev_info = file->f_mapping->backing_dev_info;
+		current->backing_dev_info = file->f_mapping->a_bdi;
 		written = generic_file_buffered_write(iocb, iov, nr_segs, *ppos,
 						      ppos, count, 0);
 		current->backing_dev_info = NULL;
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index a5ebae7..02d8ffb 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -60,7 +60,7 @@ struct inode *ramfs_get_inode(struct super_block *sb,
 	if (inode) {
 		inode_init_owner(inode, dir, mode);
 		inode->i_mapping->a_ops = &ramfs_aops;
-		inode->i_mapping->backing_dev_info = &ramfs_backing_dev_info;
+		mapping_new_set_bdi(inode->i_mapping, &ramfs_backing_dev_info);
 		mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
 		mapping_set_unevictable(inode->i_mapping);
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index 42d2135..bb4b195 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -356,8 +356,8 @@ static struct inode *romfs_iget(struct super_block *sb, unsigned long pos)
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
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index cffb1fd..3d049e5 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -251,7 +251,7 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 
 	inode->i_private = sysfs_get(sd);
 	inode->i_mapping->a_ops = &sysfs_aops;
-	inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
+	mapping_new_set_bdi(inode->i_mapping, &sysfs_backing_dev_info);
 	inode->i_op = &sysfs_inode_operations;
 
 	set_default_inode_attr(inode, sd->s_mode);
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 87ebcce..d669260 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -109,7 +109,7 @@ struct inode *ubifs_new_inode(struct ubifs_info *c, const struct inode *dir,
 			 ubifs_current_time(inode);
 	inode->i_mapping->nrpages = 0;
 	/* Disable readahead */
-	inode->i_mapping->backing_dev_info = &c->bdi;
+	mapping_new_set_bdi(inode->i_mapping, &c->bdi);
 
 	switch (mode & S_IFMT) {
 	case S_IFREG:
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index cd5900b..45888fb 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -157,7 +157,7 @@ struct inode *ubifs_iget(struct super_block *sb, unsigned long inum)
 		goto out_invalid;
 
 	/* Disable read-ahead */
-	inode->i_mapping->backing_dev_info = &c->bdi;
+	mapping_new_set_bdi(inode->i_mapping, &c->bdi);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 286e36e..7038d77 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -630,7 +630,7 @@ xfs_buf_readahead(
 {
 	struct backing_dev_info *bdi;
 
-	bdi = target->bt_mapping->backing_dev_info;
+	bdi = target->bt_mapping->a_bdi;
 	if (bdi_read_congested(bdi))
 		return;
 
@@ -1580,7 +1580,7 @@ xfs_mapping_buftarg(
 		bdi = &default_backing_dev_info;
 	mapping = &inode->i_data;
 	mapping->a_ops = &mapping_aops;
-	mapping->backing_dev_info = bdi;
+	mapping_new_set_bdi(mapping, bdi);
 	mapping_set_gfp_mask(mapping, GFP_NOFS);
 	btp->bt_mapping = mapping;
 	return 0;
diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index ba8ad42..94cf85b 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -679,7 +679,7 @@ start:
 		goto out_unlock_internal;
 
 	/* We can write back this queue in page reclaim */
-	current->backing_dev_info = mapping->backing_dev_info;
+	current->backing_dev_info = mapping->a_bdi;
 
 	if ((ioflags & IO_ISDIRECT)) {
 		if (mapping->nrpages) {
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 35b0074..31e1346 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -314,19 +314,27 @@ static inline bool bdi_cap_flush_forker(struct backing_dev_info *bdi)
 	return bdi == &default_backing_dev_info;
 }
 
+void mapping_set_bdi(struct address_space *mapping,
+					struct backing_dev_info *bdi);
+static inline void mapping_new_set_bdi(struct address_space *mapping,
+					struct backing_dev_info *bdi)
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
@@ -345,7 +353,7 @@ static inline void blk_run_backing_dev(struct backing_dev_info *bdi,
 static inline void blk_run_address_space(struct address_space *mapping)
 {
 	if (mapping)
-		blk_run_backing_dev(mapping->backing_dev_info, NULL);
+		blk_run_backing_dev(mapping->a_bdi, NULL);
 }
 
 #endif		/* _LINUX_BACKING_DEV_H */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1fb92f9..6f0b07f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -633,7 +633,7 @@ struct address_space {
 	pgoff_t			writeback_index;/* writeback starts here */
 	const struct address_space_operations *a_ops;	/* methods */
 	unsigned long		flags;		/* error bits/gfp mask */
-	struct backing_dev_info *backing_dev_info; /* device readahead, etc */
+	struct backing_dev_info *a_bdi;		/* device readahead, etc */
 	spinlock_t		private_lock;	/* for use by the address_space */
 	struct list_head	private_list;	/* ditto */
 	struct address_space	*assoc_mapping;	/* ditto */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c9483d8..8f1952b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -782,7 +782,7 @@ static struct inode *cgroup_new_inode(mode_t mode, struct super_block *sb)
 		inode->i_uid = current_fsuid();
 		inode->i_gid = current_fsgid();
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-		inode->i_mapping->backing_dev_info = &cgroup_backing_dev_info;
+		mapping_new_set_bdi(inode->i_mapping, &cgroup_backing_dev_info);
 	}
 	return inode;
 }
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 65d4204..0188d99 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -671,6 +671,48 @@ err:
 }
 EXPORT_SYMBOL(bdi_init);
 
+void mapping_set_bdi(struct address_space *mapping,
+				struct backing_dev_info *bdi)
+{
+	struct inode *inode = mapping->host;
+	struct backing_dev_info *old = mapping->a_bdi;
+
+	if (unlikely(old == bdi))
+		return;
+
+	spin_lock(&inode_lock);
+	if (!list_empty(&inode->i_list)) {
+		struct inode *i;
+
+		list_for_each_entry(i, &old->wb.b_dirty, i_list) {
+			if (inode == i) {
+				list_del(&inode->i_list);
+				list_add(&inode->i_list, &bdi->wb.b_dirty);
+				goto found;
+			}
+		}
+		list_for_each_entry(i, &old->wb.b_io, i_list) {
+			if (inode == i) {
+				list_del(&inode->i_list);
+				list_add(&inode->i_list, &bdi->wb.b_io);
+				goto found;
+			}
+		}
+		list_for_each_entry(i, &old->wb.b_more_io, i_list) {
+			if (inode == i) {
+				list_del(&inode->i_list);
+				list_add(&inode->i_list, &bdi->wb.b_more_io);
+				goto found;
+			}
+		}
+		BUG();
+	}
+found:
+	mapping->a_bdi = bdi;
+	spin_unlock(&inode_lock);
+}
+EXPORT_SYMBOL(mapping_set_bdi);
+
 void bdi_destroy(struct backing_dev_info *bdi)
 {
 	int i;
@@ -681,11 +723,24 @@ void bdi_destroy(struct backing_dev_info *bdi)
 	 */
 	if (bdi_has_dirty_io(bdi)) {
 		struct bdi_writeback *dst = &default_backing_dev_info.wb;
+		struct inode *i, *tmp;
 
 		spin_lock(&inode_lock);
-		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
-		list_splice(&bdi->wb.b_io, &dst->b_io);
-		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
+		list_for_each_entry_safe(i, tmp, &bdi->wb.b_dirty, i_list) {
+			list_del(&i->i_list);
+			list_add_tail(&i->i_list, &dst->b_dirty);
+			i->i_mapping->a_bdi = bdi;
+		}
+		list_for_each_entry_safe(i, tmp, &bdi->wb.b_io, i_list) {
+			list_del(&i->i_list);
+			list_add_tail(&i->i_list, &dst->b_io);
+			i->i_mapping->a_bdi = bdi;
+		}
+		list_for_each_entry_safe(i, tmp, &bdi->wb.b_more_io, i_list) {
+			list_del(&i->i_list);
+			list_add_tail(&i->i_list, &dst->b_more_io);
+			i->i_mapping->a_bdi = bdi;
+		}
 		spin_unlock(&inode_lock);
 	}
 
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 8d723c9..72e3ac5 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -72,7 +72,7 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
 	else
 		endbyte--;		/* inclusive */
 
-	bdi = mapping->backing_dev_info;
+	bdi = mapping->a_bdi;
 
 	switch (advice) {
 	case POSIX_FADV_NORMAL:
@@ -116,7 +116,7 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
 	case POSIX_FADV_NOREUSE:
 		break;
 	case POSIX_FADV_DONTNEED:
-		if (!bdi_write_congested(mapping->backing_dev_info))
+		if (!bdi_write_congested(mapping->a_bdi))
 			filemap_flush(mapping);
 
 		/* First and last FULL page! */
diff --git a/mm/filemap.c b/mm/filemap.c
index 3d4df44..454d5ec 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -136,7 +136,7 @@ void __remove_from_page_cache(struct page *page)
 	 */
 	if (PageDirty(page) && mapping_cap_account_dirty(mapping)) {
 		dec_zone_page_state(page, NR_FILE_DIRTY);
-		dec_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
+		dec_bdi_stat(mapping->a_bdi, BDI_RECLAIMABLE);
 	}
 }
 
@@ -2373,7 +2373,7 @@ ssize_t __generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
 
 	/* We can write back this queue in page reclaim */
-	current->backing_dev_info = mapping->backing_dev_info;
+	current->backing_dev_info = mapping->a_bdi;
 	written = 0;
 
 	err = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index 83364df..cdca914 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -409,7 +409,7 @@ xip_file_write(struct file *filp, const char __user *buf, size_t len,
 	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
 
 	/* We can write back this queue in page reclaim */
-	current->backing_dev_info = mapping->backing_dev_info;
+	current->backing_dev_info = mapping->a_bdi;
 
 	ret = generic_write_checks(filp, &pos, &count, S_ISBLK(inode->i_mode));
 	if (ret)
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index e3bccac..e2d50b1 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -489,7 +489,7 @@ static void balance_dirty_pages(struct address_space *mapping,
 	unsigned long pages_written = 0;
 	unsigned long pause = 1;
 	bool dirty_exceeded = false;
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	struct backing_dev_info *bdi = mapping->a_bdi;
 
 	for (;;) {
 		struct writeback_control wbc = {
@@ -633,7 +633,7 @@ void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
 	unsigned long *p;
 
 	ratelimit = ratelimit_pages;
-	if (mapping->backing_dev_info->dirty_exceeded)
+	if (mapping->a_bdi->dirty_exceeded)
 		ratelimit = 8;
 
 	/*
@@ -964,7 +964,7 @@ continue_unlock:
 			if (!clear_page_dirty_for_io(page))
 				goto continue_unlock;
 
-			trace_wbc_writepage(wbc, mapping->backing_dev_info);
+			trace_wbc_writepage(wbc, mapping->a_bdi);
 			ret = (*writepage)(page, wbc, data);
 			if (unlikely(ret)) {
 				if (ret == AOP_WRITEPAGE_ACTIVATE) {
@@ -1121,7 +1121,7 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
 {
 	if (mapping_cap_account_dirty(mapping)) {
 		__inc_zone_page_state(page, NR_FILE_DIRTY);
-		__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
+		__inc_bdi_stat(mapping->a_bdi, BDI_RECLAIMABLE);
 		task_dirty_inc(current);
 		task_io_account_write(PAGE_CACHE_SIZE);
 	}
@@ -1297,8 +1297,7 @@ int clear_page_dirty_for_io(struct page *page)
 		 */
 		if (TestClearPageDirty(page)) {
 			dec_zone_page_state(page, NR_FILE_DIRTY);
-			dec_bdi_stat(mapping->backing_dev_info,
-					BDI_RECLAIMABLE);
+			dec_bdi_stat(mapping->a_bdi, BDI_RECLAIMABLE);
 			return 1;
 		}
 		return 0;
@@ -1313,7 +1312,7 @@ int test_clear_page_writeback(struct page *page)
 	int ret;
 
 	if (mapping) {
-		struct backing_dev_info *bdi = mapping->backing_dev_info;
+		struct backing_dev_info *bdi = mapping->a_bdi;
 		unsigned long flags;
 
 		spin_lock_irqsave(&mapping->tree_lock, flags);
@@ -1342,7 +1341,7 @@ int test_set_page_writeback(struct page *page)
 	int ret;
 
 	if (mapping) {
-		struct backing_dev_info *bdi = mapping->backing_dev_info;
+		struct backing_dev_info *bdi = mapping->a_bdi;
 		unsigned long flags;
 
 		spin_lock_irqsave(&mapping->tree_lock, flags);
diff --git a/mm/readahead.c b/mm/readahead.c
index 77506a2..831b927 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -25,7 +25,7 @@
 void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping)
 {
-	ra->ra_pages = mapping->backing_dev_info->ra_pages;
+	ra->ra_pages = mapping->a_bdi->ra_pages;
 	ra->prev_pos = -1;
 }
 EXPORT_SYMBOL_GPL(file_ra_state_init);
@@ -549,7 +549,7 @@ page_cache_async_readahead(struct address_space *mapping,
 	/*
 	 * Defer asynchronous read-ahead on IO congestion.
 	 */
-	if (bdi_read_congested(mapping->backing_dev_info))
+	if (bdi_read_congested(mapping->a_bdi))
 		return;
 
 	/* do read-ahead */
@@ -564,7 +564,7 @@ page_cache_async_readahead(struct address_space *mapping,
 	 * explicitly kick off the IO.
 	 */
 	if (PageUptodate(page))
-		blk_run_backing_dev(mapping->backing_dev_info, NULL);
+		blk_run_backing_dev(mapping->a_bdi, NULL);
 #endif
 }
 EXPORT_SYMBOL_GPL(page_cache_async_readahead);
diff --git a/mm/shmem.c b/mm/shmem.c
index 080b09a..fbee46d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1588,7 +1588,7 @@ static struct inode *shmem_get_inode(struct super_block *sb, const struct inode
 	if (inode) {
 		inode_init_owner(inode, dir, mode);
 		inode->i_blocks = 0;
-		inode->i_mapping->backing_dev_info = &shmem_backing_dev_info;
+		mapping_new_set_bdi(inode->i_mapping, &shmem_backing_dev_info);
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		inode->i_generation = get_seconds();
 		info = SHMEM_I(inode);
diff --git a/mm/swap.c b/mm/swap.c
index 3ce7bc3..9352a37 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -501,7 +501,7 @@ void __init swap_setup(void)
 	unsigned long megs = totalram_pages >> (20 - PAGE_SHIFT);
 
 #ifdef CONFIG_SWAP
-	bdi_init(swapper_space.backing_dev_info);
+	bdi_init(swapper_space.a_bdi);
 #endif
 
 	/* Use a smaller cluster for small-memory machines */
diff --git a/mm/swap_state.c b/mm/swap_state.c
index e10f583..6496074 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -45,7 +45,7 @@ struct address_space swapper_space = {
 	.tree_lock	= __SPIN_LOCK_UNLOCKED(swapper_space.tree_lock),
 	.a_ops		= &swap_aops,
 	.i_mmap_nonlinear = LIST_HEAD_INIT(swapper_space.i_mmap_nonlinear),
-	.backing_dev_info = &swap_backing_dev_info,
+	.a_bdi		= &swap_backing_dev_info,
 };
 
 #define INC_CACHE_INFO(x)	do { swap_cache_info.x++; } while (0)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 7c703ff..c14b755 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -116,7 +116,7 @@ void swap_unplug_io_fn(struct backing_dev_info *unused_bdi, struct page *page)
 		 */
 		WARN_ON(page_count(page) <= 1);
 
-		bdi = bdev->bd_inode->i_mapping->backing_dev_info;
+		bdi = bdev->bd_inode->i_mapping->a_bdi;
 		blk_run_backing_dev(bdi, page);
 	}
 	up_read(&swap_unplug_sem);
diff --git a/mm/truncate.c b/mm/truncate.c
index ba887bf..bb79cef 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -75,8 +75,7 @@ void cancel_dirty_page(struct page *page, unsigned int account_size)
 		struct address_space *mapping = page->mapping;
 		if (mapping && mapping_cap_account_dirty(mapping)) {
 			dec_zone_page_state(page, NR_FILE_DIRTY);
-			dec_bdi_stat(mapping->backing_dev_info,
-					BDI_RECLAIMABLE);
+			dec_bdi_stat(mapping->a_bdi, BDI_RECLAIMABLE);
 			if (account_size)
 				task_io_account_cancelled_write(account_size);
 		}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c5dfabf..8f58773 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -366,7 +366,7 @@ static pageout_t pageout(struct page *page, struct address_space *mapping,
 	}
 	if (mapping->a_ops->writepage == NULL)
 		return PAGE_ACTIVATE;
-	if (!may_write_to_queue(mapping->backing_dev_info))
+	if (!may_write_to_queue(mapping->a_bdi))
 		return PAGE_KEEP;
 
 	if (clear_page_dirty_for_io(page)) {
-- 
1.7.1

