Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab2KVSqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:46:42 -0500
Received: from userp1050.oracle.com ([156.151.31.82]:24052 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab2KVSqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:46:38 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH v4 10/31] dio: Convert direct_IO to use iov_iter
Date: Wed, 21 Nov 2012 16:40:50 -0600
Message-Id: <1353537671-26284-11-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: userp1040.oracle.com [156.151.31.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the direct_IO aop to take an iov_iter argument rather than an iovec.
This will get passed down through most filesystems so that only the
__blockdev_direct_IO helper need be aware of whether user or kernel memory
is being passed to the function.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 Documentation/filesystems/Locking |  4 +--
 Documentation/filesystems/vfs.txt |  4 +--
 fs/9p/vfs_addr.c                  |  8 ++---
 fs/block_dev.c                    |  8 ++---
 fs/btrfs/inode.c                  | 61 ++++++++++++++++++++++++---------------
 fs/ceph/addr.c                    |  3 +-
 fs/direct-io.c                    | 19 ++++++------
 fs/ext2/inode.c                   |  8 ++---
 fs/ext3/inode.c                   | 15 ++++------
 fs/ext4/ext4.h                    |  3 +-
 fs/ext4/indirect.c                | 16 +++++-----
 fs/ext4/inode.c                   | 27 ++++++++---------
 fs/fat/inode.c                    | 10 +++----
 fs/fuse/file.c                    | 11 +++++--
 fs/gfs2/aops.c                    |  7 ++---
 fs/hfs/inode.c                    |  7 ++---
 fs/hfsplus/inode.c                |  6 ++--
 fs/jfs/inode.c                    |  7 ++---
 fs/nfs/direct.c                   | 13 +++++----
 fs/nilfs2/inode.c                 |  8 ++---
 fs/ocfs2/aops.c                   |  8 ++---
 fs/reiserfs/inode.c               |  7 ++---
 fs/udf/file.c                     |  3 +-
 fs/udf/inode.c                    | 10 +++----
 fs/xfs/xfs_aops.c                 | 13 ++++-----
 include/linux/fs.h                | 18 ++++++------
 include/linux/nfs_fs.h            |  3 +-
 mm/filemap.c                      | 13 +++++++--
 mm/page_io.c                      |  8 +++--
 29 files changed, 165 insertions(+), 163 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index e540a24..573673e 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -196,8 +196,8 @@ prototypes:
 	int (*invalidatepage) (struct page *, unsigned long);
 	int (*releasepage) (struct page *, int);
 	void (*freepage)(struct page *);
-	int (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs);
+	int (*direct_IO)(int, struct kiocb *, struct iov_iter *iter,
+			loff_t offset);
 	int (*get_xip_mem)(struct address_space *, pgoff_t, int, void **,
 				unsigned long *);
 	int (*migratepage)(struct address_space *, struct page *, struct page *);
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 2ee133e..0a6a8d4 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -580,8 +580,8 @@ struct address_space_operations {
 	int (*invalidatepage) (struct page *, unsigned long);
 	int (*releasepage) (struct page *, int);
 	void (*freepage)(struct page *);
-	ssize_t (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs);
+	ssize_t (*direct_IO)(int, struct kiocb *, struct iov_iter *iter,
+			loff_t offset);
 	struct page* (*get_xip_page)(struct address_space *, sector_t,
 			int);
 	/* migrate the contents of a page to the specified target */
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 0ad61c6..e70f239 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -239,9 +239,8 @@ static int v9fs_launder_page(struct page *page)
  * v9fs_direct_IO - 9P address space operation for direct I/O
  * @rw: direction (read or write)
  * @iocb: target I/O control block
- * @iov: array of vectors that define I/O buffer
+ * @iter: array of vectors that define I/O buffer
  * @pos: offset in file to begin the operation
- * @nr_segs: size of iovec array
  *
  * The presence of v9fs_direct_IO() in the address space ops vector
  * allowes open() O_DIRECT flags which would have failed otherwise.
@@ -255,8 +254,7 @@ static int v9fs_launder_page(struct page *page)
  *
  */
 static ssize_t
-v9fs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-	       loff_t pos, unsigned long nr_segs)
+v9fs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
 {
 	/*
 	 * FIXME
@@ -265,7 +263,7 @@ v9fs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	 */
 	p9_debug(P9_DEBUG_VFS, "v9fs_direct_IO: v9fs_direct_IO (%s) off/no(%lld/%lu) EINVAL\n",
 		 iocb->ki_filp->f_path.dentry->d_name.name,
-		 (long long)pos, nr_segs);
+		 (long long)pos, iter->nr_segs);
 
 	return -EINVAL;
 }
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1a1e5e3..36bff7c 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -228,14 +228,14 @@ blkdev_get_blocks(struct inode *inode, sector_t iblock,
 }
 
 static ssize_t
-blkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs)
+blkdev_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
+			loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 
-	return __blockdev_direct_IO(rw, iocb, inode, I_BDEV(inode), iov, offset,
-				    nr_segs, blkdev_get_blocks, NULL, NULL, 0);
+	return __blockdev_direct_IO(rw, iocb, inode, I_BDEV(inode), iter,
+				    offset, blkdev_get_blocks, NULL, NULL, 0);
 }
 
 int __sync_blockdev(struct block_device *bdev, int wait)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 95542a1..9ca0eb3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6524,8 +6524,7 @@ free_ordered:
 }
 
 static ssize_t check_direct_IO(struct btrfs_root *root, int rw, struct kiocb *iocb,
-			const struct iovec *iov, loff_t offset,
-			unsigned long nr_segs)
+			struct iov_iter *iter, loff_t offset)
 {
 	int seg;
 	int i;
@@ -6539,46 +6538,60 @@ static ssize_t check_direct_IO(struct btrfs_root *root, int rw, struct kiocb *io
 		goto out;
 
 	/* Check the memory alignment.  Blocks cannot straddle pages */
-	for (seg = 0; seg < nr_segs; seg++) {
-		addr = (unsigned long)iov[seg].iov_base;
-		size = iov[seg].iov_len;
-		end += size;
-		if ((addr & blocksize_mask) || (size & blocksize_mask))
-			goto out;
+	if (iov_iter_has_iovec(iter)) {
+		const struct iovec *iov = iov_iter_iovec(iter);
+
+		for (seg = 0; seg < iter->nr_segs; seg++) {
+			addr = (unsigned long)iov[seg].iov_base;
+				size = iov[seg].iov_len;
+			end += size;
+			if ((addr & blocksize_mask) || (size & blocksize_mask))
+				goto out;
 
-		/* If this is a write we don't need to check anymore */
-		if (rw & WRITE)
-			continue;
+			/* If this is a write we don't need to check anymore */
+			if (rw & WRITE)
+				continue;
 
-		/*
-		 * Check to make sure we don't have duplicate iov_base's in this
-		 * iovec, if so return EINVAL, otherwise we'll get csum errors
-		 * when reading back.
-		 */
-		for (i = seg + 1; i < nr_segs; i++) {
-			if (iov[seg].iov_base == iov[i].iov_base)
+			/*
+			 * Check to make sure we don't have duplicate iov_base's
+			 * in this iovec, if so return EINVAL, otherwise we'll
+			 * get csum errors when reading back.
+			 */
+			for (i = seg + 1; i < iter->nr_segs; i++) {
+				if (iov[seg].iov_base == iov[i].iov_base)
+					goto out;
+			}
+		}
+	} else if (iov_iter_has_bvec(iter)) {
+		struct bio_vec *bvec = iov_iter_bvec(iter);
+
+		for (seg = 0; seg < iter->nr_segs; seg++) {
+			addr = (unsigned long)bvec[seg].bv_offset;
+			size = bvec[seg].bv_len;
+			end += size;
+			if ((addr & blocksize_mask) || (size & blocksize_mask))
 				goto out;
 		}
-	}
+	} else
+		BUG();
+
 	retval = 0;
 out:
 	return retval;
 }
 
 static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
-			const struct iovec *iov, loff_t offset,
-			unsigned long nr_segs)
+			       struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 
-	if (check_direct_IO(BTRFS_I(inode)->root, rw, iocb, iov,
-			    offset, nr_segs))
+	if (check_direct_IO(BTRFS_I(inode)->root, rw, iocb, iter, offset))
 		return 0;
 
 	return __blockdev_direct_IO(rw, iocb, inode,
 		   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
-		   iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
+		   iter, offset, btrfs_get_blocks_direct, NULL,
 		   btrfs_submit_direct, 0);
 }
 
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6690269..a47c4ef 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1146,8 +1146,7 @@ static int ceph_write_end(struct file *file, struct address_space *mapping,
  * never get called.
  */
 static ssize_t ceph_direct_io(int rw, struct kiocb *iocb,
-			      const struct iovec *iov,
-			      loff_t pos, unsigned long nr_segs)
+			      struct iov_iter *iter, loff_t pos)
 {
 	WARN_ON(1);
 	return -EINVAL;
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 035c0a3..e2733e4 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1079,9 +1079,9 @@ static int dio_aligned(unsigned long offset, unsigned *blkbits,
  */
 static inline ssize_t
 do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, const struct iovec *iov, loff_t offset, 
-	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
-	dio_submit_t submit_io,	int flags)
+	struct block_device *bdev, struct iov_iter *iter, loff_t offset,
+	get_block_t get_block, dio_iodone_t end_io, dio_submit_t submit_io,
+	int flags)
 {
 	int seg;
 	size_t size;
@@ -1095,6 +1095,8 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	size_t bytes;
 	struct buffer_head map_bh = { 0, };
 	struct blk_plug plug;
+	const struct iovec *iov = iov_iter_iovec(iter);
+	unsigned long nr_segs = iter->nr_segs;
 
 	if (rw & WRITE)
 		rw = WRITE_ODIRECT;
@@ -1296,9 +1298,9 @@ out:
 
 ssize_t
 __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, const struct iovec *iov, loff_t offset,
-	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
-	dio_submit_t submit_io,	int flags)
+	struct block_device *bdev, struct iov_iter *iter, loff_t offset,
+	get_block_t get_block, dio_iodone_t end_io, dio_submit_t submit_io,
+	int flags)
 {
 	/*
 	 * The block device state is needed in the end to finally
@@ -1312,9 +1314,8 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	prefetch(bdev->bd_queue);
 	prefetch((char *)bdev->bd_queue + SMP_CACHE_BYTES);
 
-	return do_blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
-				     nr_segs, get_block, end_io,
-				     submit_io, flags);
+	return do_blockdev_direct_IO(rw, iocb, inode, bdev, iter, offset,
+				     get_block, end_io, submit_io, flags);
 }
 
 EXPORT_SYMBOL(__blockdev_direct_IO);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 6363ac6..f1d65f5 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -833,18 +833,16 @@ static sector_t ext2_bmap(struct address_space *mapping, sector_t block)
 }
 
 static ssize_t
-ext2_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs)
+ext2_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
-				 ext2_get_block);
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, ext2_get_block);
 	if (ret < 0 && (rw & WRITE))
-		ext2_write_failed(mapping, offset + iov_length(iov, nr_segs));
+		ext2_write_failed(mapping, offset + iov_iter_count(iter));
 	return ret;
 }
 
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 7e87e37..a31d871 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1856,8 +1856,7 @@ static int ext3_releasepage(struct page *page, gfp_t wait)
  * VFS code falls back into buffered path in that case so we are safe.
  */
 static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
-			const struct iovec *iov, loff_t offset,
-			unsigned long nr_segs)
+			struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -1865,10 +1864,10 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 	handle_t *handle;
 	ssize_t ret;
 	int orphan = 0;
-	size_t count = iov_length(iov, nr_segs);
+	size_t count = iov_iter_count(iter);
 	int retries = 0;
 
-	trace_ext3_direct_IO_enter(inode, offset, iov_length(iov, nr_segs), rw);
+	trace_ext3_direct_IO_enter(inode, offset, count, rw);
 
 	if (rw == WRITE) {
 		loff_t final_size = offset + count;
@@ -1892,15 +1891,14 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 	}
 
 retry:
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
-				 ext3_get_block);
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, ext3_get_block);
 	/*
 	 * In case of error extending write may have instantiated a few
 	 * blocks outside i_size. Trim these off again.
 	 */
 	if (unlikely((rw & WRITE) && ret < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + iov_length(iov, nr_segs);
+		loff_t end = offset + count;
 
 		if (end > isize)
 			ext3_truncate_failed_direct_write(inode);
@@ -1943,8 +1941,7 @@ retry:
 			ret = err;
 	}
 out:
-	trace_ext3_direct_IO_exit(inode, offset,
-				iov_length(iov, nr_segs), rw, ret);
+	trace_ext3_direct_IO_exit(inode, offset, count, rw, ret);
 	return ret;
 }
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3c20de1..e5f60f0 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2030,8 +2030,7 @@ extern void ext4_da_update_reserve_space(struct inode *inode,
 extern int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 				struct ext4_map_blocks *map, int flags);
 extern ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
-				const struct iovec *iov, loff_t offset,
-				unsigned long nr_segs);
+				struct iov_iter *iter, loff_t offset);
 extern int ext4_ind_calc_metadata_amount(struct inode *inode, sector_t lblock);
 extern int ext4_ind_trans_blocks(struct inode *inode, int nrblocks, int chunk);
 extern void ext4_ind_truncate(struct inode *inode);
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 792e388..40dcec2 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -772,8 +772,7 @@ out:
  * VFS code falls back into buffered path in that case so we are safe.
  */
 ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
-			   const struct iovec *iov, loff_t offset,
-			   unsigned long nr_segs)
+			   struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -781,7 +780,7 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 	handle_t *handle;
 	ssize_t ret;
 	int orphan = 0;
-	size_t count = iov_length(iov, nr_segs);
+	size_t count = iov_iter_count(iter);
 	int retries = 0;
 
 	if (rw == WRITE) {
@@ -825,18 +824,17 @@ retry:
 			goto locked;
 		}
 		ret = __blockdev_direct_IO(rw, iocb, inode,
-				 inode->i_sb->s_bdev, iov,
-				 offset, nr_segs,
-				 ext4_get_block, NULL, NULL, 0);
+				 inode->i_sb->s_bdev, iter,
+				 offset, ext4_get_block, NULL, NULL, 0);
 		inode_dio_done(inode);
 	} else {
 locked:
-		ret = blockdev_direct_IO(rw, iocb, inode, iov,
-				 offset, nr_segs, ext4_get_block);
+		ret = blockdev_direct_IO(rw, iocb, inode, iter,
+				 offset, ext4_get_block);
 
 		if (unlikely((rw & WRITE) && ret < 0)) {
 			loff_t isize = i_size_read(inode);
-			loff_t end = offset + iov_length(iov, nr_segs);
+			loff_t end = offset + iov_iter_count(iter);
 
 			if (end > isize)
 				ext4_truncate_failed_write(inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b3c243b..8a85501 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2992,13 +2992,12 @@ retry:
  *
  */
 static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
-			      const struct iovec *iov, loff_t offset,
-			      unsigned long nr_segs)
+			      struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
-	size_t count = iov_length(iov, nr_segs);
+	size_t count = iov_iter_count(iter);
 
 	loff_t final_size = offset + count;
 	if (rw == WRITE && final_size <= inode->i_size) {
@@ -3058,16 +3057,16 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 
 		if (overwrite)
 			ret = __blockdev_direct_IO(rw, iocb, inode,
-						 inode->i_sb->s_bdev, iov,
-						 offset, nr_segs,
+						 inode->i_sb->s_bdev, iter,
+						 offset,
 						 ext4_get_block_write_nolock,
 						 ext4_end_io_dio,
 						 NULL,
 						 0);
 		else
 			ret = __blockdev_direct_IO(rw, iocb, inode,
-						 inode->i_sb->s_bdev, iov,
-						 offset, nr_segs,
+						 inode->i_sb->s_bdev, iter,
+						 offset,
 						 ext4_get_block_write,
 						 ext4_end_io_dio,
 						 NULL,
@@ -3117,12 +3116,11 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 	}
 
 	/* for write the the end of file case, we fall back to old way */
-	return ext4_ind_direct_IO(rw, iocb, iov, offset, nr_segs);
+	return ext4_ind_direct_IO(rw, iocb, iter, offset);
 }
 
 static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
-			      const struct iovec *iov, loff_t offset,
-			      unsigned long nr_segs)
+			      struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -3134,13 +3132,12 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 	if (ext4_should_journal_data(inode))
 		return 0;
 
-	trace_ext4_direct_IO_enter(inode, offset, iov_length(iov, nr_segs), rw);
+	trace_ext4_direct_IO_enter(inode, offset, iov_iter_count(iter), rw);
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-		ret = ext4_ext_direct_IO(rw, iocb, iov, offset, nr_segs);
+		ret = ext4_ext_direct_IO(rw, iocb, iter, offset);
 	else
-		ret = ext4_ind_direct_IO(rw, iocb, iov, offset, nr_segs);
-	trace_ext4_direct_IO_exit(inode, offset,
-				iov_length(iov, nr_segs), rw, ret);
+		ret = ext4_ind_direct_IO(rw, iocb, iter, offset);
+	trace_ext4_direct_IO_exit(inode, offset, iov_iter_count(iter), rw, ret);
 	return ret;
 }
 
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 5bafaad..4fd356a 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -184,8 +184,7 @@ static int fat_write_end(struct file *file, struct address_space *mapping,
 }
 
 static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
-			     const struct iovec *iov,
-			     loff_t offset, unsigned long nr_segs)
+			     struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
@@ -202,7 +201,7 @@ static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
 		 *
 		 * Return 0, and fallback to normal buffered write.
 		 */
-		loff_t size = offset + iov_length(iov, nr_segs);
+		loff_t size = offset + iov_iter_count(iter);
 		if (MSDOS_I(inode)->mmu_private < size)
 			return 0;
 	}
@@ -211,10 +210,9 @@ static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
 	 * FAT need to use the DIO_LOCKING for avoiding the race
 	 * condition of fat_get_block() and ->truncate().
 	 */
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
-				 fat_get_block);
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, fat_get_block);
 	if (ret < 0 && (rw & WRITE))
-		fat_write_failed(mapping, offset + iov_length(iov, nr_segs));
+		fat_write_failed(mapping, offset + iov_iter_count(iter));
 
 	return ret;
 }
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 4e42e95..2dd941c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2149,17 +2149,22 @@ static ssize_t fuse_loop_dio(struct file *filp, const struct iovec *iov,
 
 
 static ssize_t
-fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs)
+fuse_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
 {
 	ssize_t ret = 0;
 	struct file *file = NULL;
 	loff_t pos = 0;
 
+	/*
+	 * We'll eventually want to work with both iovec and bvec
+	 */
+	BUG_ON(!iov_iter_has_iovec(iter));
+
 	file = iocb->ki_filp;
 	pos = offset;
 
-	ret = fuse_loop_dio(file, iov, nr_segs, &pos, rw);
+	ret = fuse_loop_dio(file, iov_iter_iovec(iter), iter->nr_segs, &pos,
+			    rw);
 
 	return ret;
 }
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 01c4975..872d05c 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -995,8 +995,7 @@ static int gfs2_ok_for_dio(struct gfs2_inode *ip, int rw, loff_t offset)
 
 
 static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
-			      const struct iovec *iov, loff_t offset,
-			      unsigned long nr_segs)
+			      struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -1020,8 +1019,8 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 	if (rv != 1)
 		goto out; /* dio not valid, fall back to buffered i/o */
 
-	rv = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				  offset, nr_segs, gfs2_get_block_direct,
+	rv = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iter,
+				  offset, gfs2_get_block_direct,
 				  NULL, NULL, 0);
 out:
 	gfs2_glock_dq(&gh);
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 0b35903..986cb91 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -117,14 +117,13 @@ static int hfs_releasepage(struct page *page, gfp_t mask)
 }
 
 static ssize_t hfs_direct_IO(int rw, struct kiocb *iocb,
-		const struct iovec *iov, loff_t offset, unsigned long nr_segs)
+		struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
-				 hfs_get_block);
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, hfs_get_block);
 
 	/*
 	 * In case of error extending write may have instantiated a few
@@ -132,7 +131,7 @@ static ssize_t hfs_direct_IO(int rw, struct kiocb *iocb,
 	 */
 	if (unlikely((rw & WRITE) && ret < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + iov_length(iov, nr_segs);
+		loff_t end = offset + iov_iter_count(iter);
 
 		if (end > isize)
 			vmtruncate(inode, isize);
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 2172aa5..94fc092 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -113,13 +113,13 @@ static int hfsplus_releasepage(struct page *page, gfp_t mask)
 }
 
 static ssize_t hfsplus_direct_IO(int rw, struct kiocb *iocb,
-		const struct iovec *iov, loff_t offset, unsigned long nr_segs)
+		struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset,
 				 hfsplus_get_block);
 
 	/*
@@ -128,7 +128,7 @@ static ssize_t hfsplus_direct_IO(int rw, struct kiocb *iocb,
 	 */
 	if (unlikely((rw & WRITE) && ret < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + iov_length(iov, nr_segs);
+		loff_t end = offset + iov_iter_count(iter);
 
 		if (end > isize)
 			vmtruncate(inode, isize);
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 4692bf3..7c192e1 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -323,14 +323,13 @@ static sector_t jfs_bmap(struct address_space *mapping, sector_t block)
 }
 
 static ssize_t jfs_direct_IO(int rw, struct kiocb *iocb,
-	const struct iovec *iov, loff_t offset, unsigned long nr_segs)
+			     struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
-				 jfs_get_block);
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, jfs_get_block);
 
 	/*
 	 * In case of error extending write may have instantiated a few
@@ -338,7 +337,7 @@ static ssize_t jfs_direct_IO(int rw, struct kiocb *iocb,
 	 */
 	if (unlikely((rw & WRITE) && ret < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + iov_length(iov, nr_segs);
+		loff_t end = offset + iov_iter_count(iter);
 
 		if (end > isize)
 			vmtruncate(inode, isize);
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index cae26cb..4532781 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -112,7 +112,7 @@ static inline int put_dreq(struct nfs_direct_req *dreq)
  * nfs_direct_IO - NFS address space operation for direct I/O
  * @rw: direction (read or write)
  * @iocb: target I/O control block
- * @iov: array of vectors that define I/O buffer
+ * @iter: array of vectors that define I/O buffer
  * @pos: offset in file to begin the operation
  * @nr_segs: size of iovec array
  *
@@ -121,22 +121,25 @@ static inline int put_dreq(struct nfs_direct_req *dreq)
  * shunt off direct read and write requests before the VFS gets them,
  * so this method is only ever called for swap.
  */
-ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov, loff_t pos, unsigned long nr_segs)
+ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
+		      loff_t pos)
 {
 #ifndef CONFIG_NFS_SWAP
 	dprintk("NFS: nfs_direct_IO (%s) off/no(%Ld/%lu) EINVAL\n",
 			iocb->ki_filp->f_path.dentry->d_name.name,
-			(long long) pos, nr_segs);
+			(long long) pos, iter->nr_segs);
 
 	return -EINVAL;
 #else
+	const struct iovec *iov = iov_iter_iovec(iter);
+
 	VM_BUG_ON(iocb->ki_left != PAGE_SIZE);
 	VM_BUG_ON(iocb->ki_nbytes != PAGE_SIZE);
 
 	if (rw == READ || rw == KERNEL_READ)
-		return nfs_file_direct_read(iocb, iov, nr_segs, pos,
+		return nfs_file_direct_read(iocb, iov, iter->nr_segs, pos,
 				rw == READ ? true : false);
-	return nfs_file_direct_write(iocb, iov, nr_segs, pos,
+	return nfs_file_direct_write(iocb, iov, iter->nr_segs, pos,
 				rw == WRITE ? true : false);
 #endif /* CONFIG_NFS_SWAP */
 }
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 4d31d2c..0577750 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -255,8 +255,8 @@ static int nilfs_write_end(struct file *file, struct address_space *mapping,
 }
 
 static ssize_t
-nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-		loff_t offset, unsigned long nr_segs)
+nilfs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
+		loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -266,7 +266,7 @@ nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 		return 0;
 
 	/* Needs synchronization with the cleaner */
-	size = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
+	size = blockdev_direct_IO(rw, iocb, inode, iter, offset,
 				  nilfs_get_block);
 
 	/*
@@ -275,7 +275,7 @@ nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	 */
 	if (unlikely((rw & WRITE) && size < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + iov_length(iov, nr_segs);
+		loff_t end = offset + iov_iter_count(iter);
 
 		if (end > isize)
 			vmtruncate(inode, isize);
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 6577432..ed100d5 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -621,9 +621,8 @@ static int ocfs2_releasepage(struct page *page, gfp_t wait)
 
 static ssize_t ocfs2_direct_IO(int rw,
 			       struct kiocb *iocb,
-			       const struct iovec *iov,
-			       loff_t offset,
-			       unsigned long nr_segs)
+			       struct iov_iter *iter,
+			       loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
@@ -640,8 +639,7 @@ static ssize_t ocfs2_direct_IO(int rw,
 		return 0;
 
 	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
-				    iov, offset, nr_segs,
-				    ocfs2_direct_IO_get_blocks,
+				    iter, offset, ocfs2_direct_IO_get_blocks,
 				    ocfs2_dio_end_io, NULL, 0);
 }
 
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index f27f01a..2c7bb7f 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3064,14 +3064,13 @@ static int reiserfs_releasepage(struct page *page, gfp_t unused_gfp_flags)
 /* We thank Mingming Cao for helping us understand in great detail what
    to do in this section of the code. */
 static ssize_t reiserfs_direct_IO(int rw, struct kiocb *iocb,
-				  const struct iovec *iov, loff_t offset,
-				  unsigned long nr_segs)
+				  struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset,
 				  reiserfs_get_blocks_direct_io);
 
 	/*
@@ -3080,7 +3079,7 @@ static ssize_t reiserfs_direct_IO(int rw, struct kiocb *iocb,
 	 */
 	if (unlikely((rw & WRITE) && ret < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + iov_length(iov, nr_segs);
+		loff_t end = offset + iov_iter_count(iter);
 
 		if (end > isize)
 			vmtruncate(inode, isize);
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 77b5953..c4164dc 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -119,8 +119,7 @@ static int udf_adinicb_write_end(struct file *file,
 }
 
 static ssize_t udf_adinicb_direct_IO(int rw, struct kiocb *iocb,
-				     const struct iovec *iov,
-				     loff_t offset, unsigned long nr_segs)
+				     struct iov_iter *iter, loff_t offset)
 {
 	/* Fallback to buffered I/O. */
 	return 0;
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index df88b95..260e4f8 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -145,19 +145,17 @@ static int udf_write_begin(struct file *file, struct address_space *mapping,
 	return ret;
 }
 
-static ssize_t udf_direct_IO(int rw, struct kiocb *iocb,
-			     const struct iovec *iov,
-			     loff_t offset, unsigned long nr_segs)
+static ssize_t udf_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
+			     loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
-				  udf_get_block);
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, udf_get_block);
 	if (unlikely(ret < 0 && (rw & WRITE)))
-		udf_write_failed(mapping, offset + iov_length(iov, nr_segs));
+		udf_write_failed(mapping, offset + iov_iter_count(iter));
 	return ret;
 }
 
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e562dd4..718921b 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1395,9 +1395,8 @@ STATIC ssize_t
 xfs_vm_direct_IO(
 	int			rw,
 	struct kiocb		*iocb,
-	const struct iovec	*iov,
-	loff_t			offset,
-	unsigned long		nr_segs)
+	struct iov_iter		*iter,
+	loff_t			offset)
 {
 	struct inode		*inode = iocb->ki_filp->f_mapping->host;
 	struct block_device	*bdev = xfs_find_bdev_for_inode(inode);
@@ -1405,7 +1404,7 @@ xfs_vm_direct_IO(
 	ssize_t			ret;
 
 	if (rw & WRITE) {
-		size_t size = iov_length(iov, nr_segs);
+		size_t size = iov_iter_count(iter);
 
 		/*
 		 * We need to preallocate a transaction for a size update
@@ -1421,15 +1420,13 @@ xfs_vm_direct_IO(
 			ioend->io_isdirect = 1;
 		}
 
-		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
-					    offset, nr_segs,
+		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iter, offset,
 					    xfs_get_blocks_direct,
 					    xfs_end_io_direct_write, NULL, 0);
 		if (ret != -EIOCBQUEUED && iocb->private)
 			goto out_trans_cancel;
 	} else {
-		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
-					    offset, nr_segs,
+		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iter, offset,
 					    xfs_get_blocks_direct,
 					    NULL, NULL, 0);
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6f26f11..aa8b038 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -453,8 +453,8 @@ struct address_space_operations {
 	void (*invalidatepage) (struct page *, unsigned long);
 	int (*releasepage) (struct page *, gfp_t);
 	void (*freepage)(struct page *);
-	ssize_t (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs);
+	ssize_t (*direct_IO)(int, struct kiocb *, struct iov_iter *iter,
+			loff_t offset);
 	int (*get_xip_mem)(struct address_space *, pgoff_t, int,
 						void **, unsigned long *);
 	/*
@@ -2525,16 +2525,16 @@ enum {
 void dio_end_io(struct bio *bio, int error);
 
 ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, const struct iovec *iov, loff_t offset,
-	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
-	dio_submit_t submit_io,	int flags);
+	struct block_device *bdev, struct iov_iter *iter, loff_t offset,
+	get_block_t get_block, dio_iodone_t end_io, dio_submit_t submit_io,
+	int flags);
 
 static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
-		struct inode *inode, const struct iovec *iov, loff_t offset,
-		unsigned long nr_segs, get_block_t get_block)
+		struct inode *inode, struct iov_iter *iter, loff_t offset,
+		get_block_t get_block)
 {
-	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				    offset, nr_segs, get_block, NULL, NULL,
+	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iter,
+				    offset, get_block, NULL, NULL,
 				    DIO_LOCKING | DIO_SKIP_HOLES);
 }
 #endif
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 1cc2568..4913e3c 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -444,8 +444,7 @@ extern int nfs3_removexattr (struct dentry *, const char *name);
 /*
  * linux/fs/nfs/direct.c
  */
-extern ssize_t nfs_direct_IO(int, struct kiocb *, const struct iovec *, loff_t,
-			unsigned long);
+extern ssize_t nfs_direct_IO(int, struct kiocb *, struct iov_iter *, loff_t);
 extern ssize_t nfs_file_direct_read(struct kiocb *iocb,
 			const struct iovec *iov, unsigned long nr_segs,
 			loff_t pos, bool uio);
diff --git a/mm/filemap.c b/mm/filemap.c
index 753ec48..d428020 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1409,11 +1409,15 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 			goto out; /* skip atime */
 		size = i_size_read(inode);
 		if (pos < size) {
+			size_t bytes = iov_length(iov, nr_segs);
 			retval = filemap_write_and_wait_range(mapping, pos,
-					pos + iov_length(iov, nr_segs) - 1);
+					pos + bytes - 1);
 			if (!retval) {
+				struct iov_iter iter;
+
+				iov_iter_init(&iter, iov, nr_segs, bytes, 0);
 				retval = mapping->a_ops->direct_IO(READ, iocb,
-							iov, pos, nr_segs);
+							&iter, pos);
 			}
 			if (retval > 0) {
 				*ppos = pos + retval;
@@ -2037,6 +2041,7 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 	ssize_t		written;
 	size_t		write_len;
 	pgoff_t		end;
+	struct iov_iter iter;
 
 	if (count != ocount)
 		*nr_segs = iov_shorten((struct iovec *)iov, *nr_segs, count);
@@ -2068,7 +2073,9 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 		}
 	}
 
-	written = mapping->a_ops->direct_IO(WRITE, iocb, iov, pos, *nr_segs);
+	iov_iter_init(&iter, iov, *nr_segs, write_len, 0);
+
+	written = mapping->a_ops->direct_IO(WRITE, iocb, &iter, pos);
 
 	/*
 	 * Finally, try again to invalidate clean pages which might have been
diff --git a/mm/page_io.c b/mm/page_io.c
index 78eee32..33da274 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -208,6 +208,9 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 			.iov_base = kmap(page),
 			.iov_len  = PAGE_SIZE,
 		};
+		struct iov_iter iter;
+
+		iov_iter_init(&iter, &iov, 1, PAGE_SIZE, 0);
 
 		init_sync_kiocb(&kiocb, swap_file);
 		kiocb.ki_pos = page_file_offset(page);
@@ -215,9 +218,8 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 		kiocb.ki_nbytes = PAGE_SIZE;
 
 		unlock_page(page);
-		ret = mapping->a_ops->direct_IO(KERNEL_WRITE,
-						&kiocb, &iov,
-						kiocb.ki_pos, 1);
+		ret = mapping->a_ops->direct_IO(KERNEL_WRITE, &kiocb, &iter,
+						kiocb.ki_pos);
 		kunmap(page);
 		if (ret == PAGE_SIZE) {
 			count_vm_event(PSWPOUT);
-- 
1.8.0

