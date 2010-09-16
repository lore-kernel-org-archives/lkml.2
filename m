Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0IPQPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 12:15:19 -0400
Received: from verein.lst.de ([213.95.11.210]:56722 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab0IPQPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 12:15:17 -0400
Date: Thu, 16 Sep 2010 18:14:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: jaxboe@fusionio.com
Cc: tj@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] block: remove BLKDEV_IFL_WAIT
Message-ID: <20100916161450.GA5587@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the blkdev_issue_* helpers can only sanely be used for synchronous
caller.  To issue cache flushes or barriers asynchronously the caller needs
to set up a bio by itself with a completion callback to move the asynchronous
state machine ahead.  So drop the BLKDEV_IFL_WAIT flag that is always
specified when calling blkdev_issue_* and also remove the now unused flags
argument to blkdev_issue_flush and blkdev_issue_zeroout.  For
blkdev_issue_discard we need to keep it for the secure discard flag, which
gains a more descriptive name and loses the bitops vs flag confusion.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/block/blk-flush.c
===================================================================
--- linux-2.6.orig/block/blk-flush.c	2010-09-15 20:12:43.464935029 -0300
+++ linux-2.6/block/blk-flush.c	2010-09-15 20:17:59.761935029 -0300
@@ -205,7 +205,6 @@ static void bio_end_flush(struct bio *bi
  * @bdev:	blockdev to issue flush for
  * @gfp_mask:	memory allocation flags (for bio_alloc)
  * @error_sector:	error sector
- * @flags:	BLKDEV_IFL_* flags to control behaviour
  *
  * Description:
  *    Issue a flush for the block device in question. Caller can supply
@@ -214,7 +213,7 @@ static void bio_end_flush(struct bio *bi
  *    request was pushed in some internal queue for later handling.
  */
 int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
-		sector_t *error_sector, unsigned long flags)
+		sector_t *error_sector)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q;
@@ -240,21 +239,19 @@ int blkdev_issue_flush(struct block_devi
 	bio = bio_alloc(gfp_mask, 0);
 	bio->bi_end_io = bio_end_flush;
 	bio->bi_bdev = bdev;
-	if (test_bit(BLKDEV_WAIT, &flags))
-		bio->bi_private = &wait;
+	bio->bi_private = &wait;
 
 	bio_get(bio);
 	submit_bio(WRITE_FLUSH, bio);
-	if (test_bit(BLKDEV_WAIT, &flags)) {
-		wait_for_completion(&wait);
-		/*
-		 * The driver must store the error location in ->bi_sector, if
-		 * it supports it. For non-stacked drivers, this should be
-		 * copied from blk_rq_pos(rq).
-		 */
-		if (error_sector)
-			*error_sector = bio->bi_sector;
-	}
+	wait_for_completion(&wait);
+
+	/*
+	 * The driver must store the error location in ->bi_sector, if
+	 * it supports it. For non-stacked drivers, this should be
+	 * copied from blk_rq_pos(rq).
+	 */
+	if (error_sector)
+		*error_sector = bio->bi_sector;
 
 	if (!bio_flagged(bio, BIO_UPTODATE))
 		ret = -EIO;
Index: linux-2.6/block/blk-lib.c
===================================================================
--- linux-2.6.orig/block/blk-lib.c	2010-09-15 20:12:43.465935029 -0300
+++ linux-2.6/block/blk-lib.c	2010-09-15 20:17:59.761935029 -0300
@@ -61,7 +61,7 @@ int blkdev_issue_discard(struct block_de
 		max_discard_sectors &= ~(disc_sects - 1);
 	}
 
-	if (flags & BLKDEV_IFL_SECURE) {
+	if (flags & BLKDEV_DISCARD_SECURE) {
 		if (!blk_queue_secdiscard(q))
 			return -EOPNOTSUPP;
 		type |= REQ_SECURE;
@@ -77,8 +77,7 @@ int blkdev_issue_discard(struct block_de
 		bio->bi_sector = sector;
 		bio->bi_end_io = blkdev_discard_end_io;
 		bio->bi_bdev = bdev;
-		if (flags & BLKDEV_IFL_WAIT)
-			bio->bi_private = &wait;
+		bio->bi_private = &wait;
 
 		if (nr_sects > max_discard_sectors) {
 			bio->bi_size = max_discard_sectors << 9;
@@ -92,8 +91,7 @@ int blkdev_issue_discard(struct block_de
 		bio_get(bio);
 		submit_bio(type, bio);
 
-		if (flags & BLKDEV_IFL_WAIT)
-			wait_for_completion(&wait);
+		wait_for_completion(&wait);
 
 		if (bio_flagged(bio, BIO_EOPNOTSUPP))
 			ret = -EOPNOTSUPP;
@@ -139,7 +137,6 @@ static void bio_batch_end_io(struct bio
  * @sector:	start sector
  * @nr_sects:	number of sectors to write
  * @gfp_mask:	memory allocation flags (for bio_alloc)
- * @flags:	BLKDEV_IFL_* flags to control behaviour
  *
  * Description:
  *  Generate and issue number of bios with zerofiled pages.
@@ -148,7 +145,7 @@ static void bio_batch_end_io(struct bio
  */
 
 int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
-			sector_t nr_sects, gfp_t gfp_mask, unsigned long flags)
+			sector_t nr_sects, gfp_t gfp_mask)
 {
 	int ret;
 	struct bio *bio;
@@ -174,8 +171,7 @@ submit:
 		bio->bi_sector = sector;
 		bio->bi_bdev   = bdev;
 		bio->bi_end_io = bio_batch_end_io;
-		if (flags & BLKDEV_IFL_WAIT)
-			bio->bi_private = &bb;
+		bio->bi_private = &bb;
 
 		while (nr_sects != 0) {
 			sz = min((sector_t) PAGE_SIZE >> 9 , nr_sects);
@@ -193,10 +189,9 @@ submit:
 		submit_bio(WRITE, bio);
 	}
 
-	if (flags & BLKDEV_IFL_WAIT)
-		/* Wait for bios in-flight */
-		while ( issued != atomic_read(&bb.done))
-			wait_for_completion(&wait);
+	/* Wait for bios in-flight */
+	while (issued != atomic_read(&bb.done))
+		wait_for_completion(&wait);
 
 	if (!test_bit(BIO_UPTODATE, &bb.flags))
 		/* One of bios in the batch was completed with error.*/
Index: linux-2.6/block/ioctl.c
===================================================================
--- linux-2.6.orig/block/ioctl.c	2010-09-15 20:12:43.468935029 -0300
+++ linux-2.6/block/ioctl.c	2010-09-15 20:17:59.763935029 -0300
@@ -116,7 +116,7 @@ static int blkdev_reread_part(struct blo
 static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 			     uint64_t len, int secure)
 {
-	unsigned long flags = BLKDEV_IFL_WAIT;
+	unsigned long flags = 0;
 
 	if (start & 511)
 		return -EINVAL;
@@ -128,7 +128,7 @@ static int blk_ioctl_discard(struct bloc
 	if (start + len > (bdev->bd_inode->i_size >> 9))
 		return -EINVAL;
 	if (secure)
-		flags |= BLKDEV_IFL_SECURE;
+		flags |= BLKDEV_DISCARD_SECURE;
 	return blkdev_issue_discard(bdev, start, len, GFP_KERNEL, flags);
 }
 
Index: linux-2.6/drivers/block/drbd/drbd_int.h
===================================================================
--- linux-2.6.orig/drivers/block/drbd/drbd_int.h	2010-09-08 18:05:39.435256146 -0300
+++ linux-2.6/drivers/block/drbd/drbd_int.h	2010-09-15 20:17:59.768935029 -0300
@@ -2321,8 +2321,7 @@ static inline void drbd_md_flush(struct
 	if (test_bit(MD_NO_BARRIER, &mdev->flags))
 		return;
 
-	r = blkdev_issue_flush(mdev->ldev->md_bdev, GFP_KERNEL, NULL,
-			BLKDEV_IFL_WAIT);
+	r = blkdev_issue_flush(mdev->ldev->md_bdev, GFP_KERNEL, NULL);
 	if (r) {
 		set_bit(MD_NO_BARRIER, &mdev->flags);
 		dev_err(DEV, "meta data flush failed with status %d, disabling md-flushes\n", r);
Index: linux-2.6/drivers/block/drbd/drbd_receiver.c
===================================================================
--- linux-2.6.orig/drivers/block/drbd/drbd_receiver.c	2010-09-15 20:12:43.492935029 -0300
+++ linux-2.6/drivers/block/drbd/drbd_receiver.c	2010-09-15 20:17:59.775935029 -0300
@@ -975,7 +975,7 @@ static enum finish_epoch drbd_flush_afte
 
 	if (mdev->write_ordering >= WO_bdev_flush && get_ldev(mdev)) {
 		rv = blkdev_issue_flush(mdev->ldev->backing_bdev, GFP_KERNEL,
-					NULL, BLKDEV_IFL_WAIT);
+					NULL);
 		if (rv) {
 			dev_err(DEV, "local disk flush failed with status %d\n", rv);
 			/* would rather check on EOPNOTSUPP, but that is not reliable.
Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c	2010-09-08 18:05:39.472255936 -0300
+++ linux-2.6/fs/block_dev.c	2010-09-15 20:17:59.780935029 -0300
@@ -370,7 +370,7 @@ int blkdev_fsync(struct file *filp, int
 	 */
 	mutex_unlock(&bd_inode->i_mutex);
 
-	error = blkdev_issue_flush(bdev, GFP_KERNEL, NULL, BLKDEV_IFL_WAIT);
+	error = blkdev_issue_flush(bdev, GFP_KERNEL, NULL);
 	if (error == -EOPNOTSUPP)
 		error = 0;
 
Index: linux-2.6/fs/btrfs/extent-tree.c
===================================================================
--- linux-2.6.orig/fs/btrfs/extent-tree.c	2010-09-15 20:12:43.723935029 -0300
+++ linux-2.6/fs/btrfs/extent-tree.c	2010-09-15 20:45:58.588935030 -0300
@@ -1695,8 +1695,7 @@ static int remove_extent_backref(struct
 static void btrfs_issue_discard(struct block_device *bdev,
 				u64 start, u64 len)
 {
-	blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL,
-			BLKDEV_IFL_WAIT);
+	blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL, 0);
 }
 
 static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
Index: linux-2.6/fs/ext3/fsync.c
===================================================================
--- linux-2.6.orig/fs/ext3/fsync.c	2010-09-08 18:05:39.506256215 -0300
+++ linux-2.6/fs/ext3/fsync.c	2010-09-15 20:17:59.795935029 -0300
@@ -90,7 +90,6 @@ int ext3_sync_file(struct file *file, in
 	 * storage
 	 */
 	if (needs_barrier)
-		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL,
-				BLKDEV_IFL_WAIT);
+		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
 	return ret;
 }
Index: linux-2.6/fs/ext4/fsync.c
===================================================================
--- linux-2.6.orig/fs/ext4/fsync.c	2010-09-08 18:05:39.522255657 -0300
+++ linux-2.6/fs/ext4/fsync.c	2010-09-15 20:17:59.799935029 -0300
@@ -128,10 +128,9 @@ int ext4_sync_file(struct file *file, in
 		    (journal->j_fs_dev != journal->j_dev) &&
 		    (journal->j_flags & JBD2_BARRIER))
 			blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL,
-					NULL, BLKDEV_IFL_WAIT);
+					NULL);
 		ret = jbd2_log_wait_commit(journal, commit_tid);
 	} else if (journal->j_flags & JBD2_BARRIER)
-		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL,
-			BLKDEV_IFL_WAIT);
+		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
 	return ret;
 }
Index: linux-2.6/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.orig/fs/ext4/mballoc.c	2010-09-15 20:12:43.742935029 -0300
+++ linux-2.6/fs/ext4/mballoc.c	2010-09-15 20:17:59.806935029 -0300
@@ -2566,8 +2566,7 @@ static inline void ext4_issue_discard(st
 	discard_block = block + ext4_group_first_block_no(sb, block_group);
 	trace_ext4_discard_blocks(sb,
 			(unsigned long long) discard_block, count);
-	ret = sb_issue_discard(sb, discard_block, count, GFP_NOFS,
-			       BLKDEV_IFL_WAIT);
+	ret = sb_issue_discard(sb, discard_block, count, GFP_NOFS, 0);
 	if (ret == EOPNOTSUPP) {
 		ext4_warning(sb, "discard not supported, disabling");
 		clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
Index: linux-2.6/fs/fat/fatent.c
===================================================================
--- linux-2.6.orig/fs/fat/fatent.c	2010-09-15 20:12:43.747935029 -0300
+++ linux-2.6/fs/fat/fatent.c	2010-09-15 20:17:59.821935029 -0300
@@ -578,8 +578,7 @@ int fat_free_clusters(struct inode *inod
 				sb_issue_discard(sb,
 					fat_clus_to_blknr(sbi, first_cl),
 					nr_clus * sbi->sec_per_clus,
-					GFP_NOFS,
-					BLKDEV_IFL_WAIT);
+					GFP_NOFS, 0);
 
 				first_cl = cluster;
 			}
Index: linux-2.6/fs/gfs2/rgrp.c
===================================================================
--- linux-2.6.orig/fs/gfs2/rgrp.c	2010-09-15 20:12:43.754935029 -0300
+++ linux-2.6/fs/gfs2/rgrp.c	2010-09-15 20:17:59.825935029 -0300
@@ -854,7 +854,7 @@ static void gfs2_rgrp_send_discards(stru
 				if ((start + nr_sects) != blk) {
 					rv = blkdev_issue_discard(bdev, start,
 							    nr_sects, GFP_NOFS,
-							    BLKDEV_IFL_WAIT);
+							    0);
 					if (rv)
 						goto fail;
 					nr_sects = 0;
@@ -868,8 +868,7 @@ start_new_extent:
 		}
 	}
 	if (nr_sects) {
-		rv = blkdev_issue_discard(bdev, start, nr_sects, GFP_NOFS,
-					 BLKDEV_IFL_WAIT);
+		rv = blkdev_issue_discard(bdev, start, nr_sects, GFP_NOFS, 0);
 		if (rv)
 			goto fail;
 	}
Index: linux-2.6/fs/jbd2/checkpoint.c
===================================================================
--- linux-2.6.orig/fs/jbd2/checkpoint.c	2010-09-08 18:05:39.596003247 -0300
+++ linux-2.6/fs/jbd2/checkpoint.c	2010-09-15 20:17:59.833935029 -0300
@@ -532,8 +532,7 @@ int jbd2_cleanup_journal_tail(journal_t
 	 */
 	if ((journal->j_fs_dev != journal->j_dev) &&
 	    (journal->j_flags & JBD2_BARRIER))
-		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL,
-			BLKDEV_IFL_WAIT);
+		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
 	if (!(journal->j_flags & JBD2_ABORT))
 		jbd2_journal_update_superblock(journal, 1);
 	return 0;
Index: linux-2.6/fs/jbd2/commit.c
===================================================================
--- linux-2.6.orig/fs/jbd2/commit.c	2010-09-15 20:12:43.756935029 -0300
+++ linux-2.6/fs/jbd2/commit.c	2010-09-15 20:17:59.839935029 -0300
@@ -684,8 +684,7 @@ start_journal_io:
 	if (commit_transaction->t_flushed_data_blocks &&
 	    (journal->j_fs_dev != journal->j_dev) &&
 	    (journal->j_flags & JBD2_BARRIER))
-		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL,
-			BLKDEV_IFL_WAIT);
+		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
 
 	/* Done it all: now write the commit record asynchronously. */
 	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
@@ -810,8 +809,7 @@ wait_for_iobuf:
 	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
 				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT) &&
 	    journal->j_flags & JBD2_BARRIER) {
-		blkdev_issue_flush(journal->j_dev, GFP_KERNEL, NULL,
-				   BLKDEV_IFL_WAIT);
+		blkdev_issue_flush(journal->j_dev, GFP_KERNEL, NULL);
 	}
 
 	if (err)
Index: linux-2.6/fs/nilfs2/the_nilfs.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/the_nilfs.c	2010-09-15 20:12:43.761935029 -0300
+++ linux-2.6/fs/nilfs2/the_nilfs.c	2010-09-15 20:17:59.846935029 -0300
@@ -774,7 +774,7 @@ int nilfs_discard_segments(struct the_ni
 			ret = blkdev_issue_discard(nilfs->ns_bdev,
 						   start * sects_per_block,
 						   nblocks * sects_per_block,
-						   GFP_NOFS, BLKDEV_IFL_WAIT);
+						   GFP_NOFS, 0);
 			if (ret < 0)
 				return ret;
 			nblocks = 0;
@@ -784,7 +784,7 @@ int nilfs_discard_segments(struct the_ni
 		ret = blkdev_issue_discard(nilfs->ns_bdev,
 					   start * sects_per_block,
 					   nblocks * sects_per_block,
-					   GFP_NOFS, BLKDEV_IFL_WAIT);
+					   GFP_NOFS, 0);
 	return ret;
 }
 
Index: linux-2.6/fs/reiserfs/file.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/file.c	2010-09-08 18:05:39.613003457 -0300
+++ linux-2.6/fs/reiserfs/file.c	2010-09-15 20:17:59.853935029 -0300
@@ -152,8 +152,7 @@ static int reiserfs_sync_file(struct fil
 	barrier_done = reiserfs_commit_for_inode(inode);
 	reiserfs_write_unlock(inode->i_sb);
 	if (barrier_done != 1 && reiserfs_barrier_flush(inode->i_sb))
-		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL, 
-			BLKDEV_IFL_WAIT);
+		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
 	if (barrier_done < 0)
 		return barrier_done;
 	return (err < 0) ? -EIO : 0;
Index: linux-2.6/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_super.c	2010-09-15 20:12:43.774935029 -0300
+++ linux-2.6/fs/xfs/linux-2.6/xfs_super.c	2010-09-15 20:17:59.858935029 -0300
@@ -693,8 +693,7 @@ void
 xfs_blkdev_issue_flush(
 	xfs_buftarg_t		*buftarg)
 {
-	blkdev_issue_flush(buftarg->bt_bdev, GFP_KERNEL, NULL,
-			BLKDEV_IFL_WAIT);
+	blkdev_issue_flush(buftarg->bt_bdev, GFP_KERNEL, NULL);
 }
 
 STATIC void
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2010-09-15 20:12:43.788935029 -0300
+++ linux-2.6/include/linux/blkdev.h	2010-09-15 20:17:59.863935029 -0300
@@ -871,18 +871,14 @@ static inline struct request *blk_map_qu
 		return NULL;
 	return bqt->tag_index[tag];
 }
-enum{
-	BLKDEV_WAIT,	/* wait for completion */
-	BLKDEV_SECURE,	/* secure discard */
-};
-#define BLKDEV_IFL_WAIT		(1 << BLKDEV_WAIT)
-#define BLKDEV_IFL_SECURE	(1 << BLKDEV_SECURE)
-extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *,
-			unsigned long);
+
+#define BLKDEV_DISCARD_SECURE	0x01	/* secure discard */
+
+extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
 extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
-			sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
+			sector_t nr_sects, gfp_t gfp_mask);
 static inline int sb_issue_discard(struct super_block *sb, sector_t block,
 		sector_t nr_blocks, gfp_t gfp_mask, unsigned long flags)
 {
Index: linux-2.6/mm/swapfile.c
===================================================================
--- linux-2.6.orig/mm/swapfile.c	2010-09-15 20:12:43.845935029 -0300
+++ linux-2.6/mm/swapfile.c	2010-09-15 20:17:59.868935029 -0300
@@ -141,7 +141,7 @@ static int discard_swap(struct swap_info
 	nr_blocks = ((sector_t)se->nr_pages - 1) << (PAGE_SHIFT - 9);
 	if (nr_blocks) {
 		err = blkdev_issue_discard(si->bdev, start_block,
-				nr_blocks, GFP_KERNEL, BLKDEV_IFL_WAIT);
+				nr_blocks, GFP_KERNEL, 0);
 		if (err)
 			return err;
 		cond_resched();
@@ -152,7 +152,7 @@ static int discard_swap(struct swap_info
 		nr_blocks = (sector_t)se->nr_pages << (PAGE_SHIFT - 9);
 
 		err = blkdev_issue_discard(si->bdev, start_block,
-				nr_blocks, GFP_KERNEL, BLKDEV_IFL_WAIT);
+				nr_blocks, GFP_KERNEL, 0);
 		if (err)
 			break;
 
@@ -191,7 +191,7 @@ static void discard_swap_cluster(struct
 			start_block <<= PAGE_SHIFT - 9;
 			nr_blocks <<= PAGE_SHIFT - 9;
 			if (blkdev_issue_discard(si->bdev, start_block,
-				    nr_blocks, GFP_NOIO, BLKDEV_IFL_WAIT))
+				    nr_blocks, GFP_NOIO, 0))
 				break;
 		}
 
