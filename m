Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab0D1Nzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:55:49 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62230 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab0D1NzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:55:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=tDXpYi9l+AboVRQklNa8X6hXWK8iuQ6elDV33nS6F5N1vIPsS0KN8ko9hrgo/arv6o
         DhniysXJBxU1G7rtauEg9wMpSOg+VOvk8J7X+9pJAnDc8lL4TGzIHNjLa3/BXMwt2MMM
         P2hRyGwu1nwMfbIDwq0tODEZq7QCbksUGgMCQ=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, hch@infradead.org,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/4] blkdev: generalize flags for blkdev_issue_fn functions
Date: Wed, 28 Apr 2010 17:55:06 +0400
Message-Id: <1272462909-12942-2-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272462909-12942-1-git-send-email-dmonakhov@openvz.org>
References: <20100426172651.GT27497@kernel.dk>
 <1272462909-12942-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch just convert all blkdev_issue_xxx function to common
set of flags. Wait/allocation semantics preserved.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-barrier.c                |   20 +++++++++++---------
 block/ioctl.c                      |    2 +-
 drivers/block/drbd/drbd_int.h      |    3 ++-
 drivers/block/drbd/drbd_receiver.c |    3 ++-
 fs/block_dev.c                     |    3 ++-
 fs/btrfs/extent-tree.c             |    2 +-
 fs/ext3/fsync.c                    |    3 ++-
 fs/ext4/fsync.c                    |    6 ++++--
 fs/gfs2/rgrp.c                     |    5 +++--
 fs/jbd2/checkpoint.c               |    3 ++-
 fs/jbd2/commit.c                   |    6 ++++--
 fs/reiserfs/file.c                 |    3 ++-
 fs/xfs/linux-2.6/xfs_super.c       |    3 ++-
 include/linux/blkdev.h             |   18 +++++++++++-------
 mm/swapfile.c                      |    9 ++++++---
 15 files changed, 55 insertions(+), 34 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 6d88544..cf14311 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -293,19 +293,22 @@ static void bio_end_empty_barrier(struct bio *bio, int err)
 /**
  * blkdev_issue_flush - queue a flush
  * @bdev:	blockdev to issue flush for
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
  * @error_sector:	error sector
+ * @flags:	BLKDEV_IFL_* flags to control behaviour
  *
  * Description:
  *    Issue a flush for the block device in question. Caller can supply
  *    room for storing the error offset in case of a flush error, if they
  *    wish to.
  */
-int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
+int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
+		sector_t *error_sector, unsigned long flags)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q;
 	struct bio *bio;
-	int ret;
+	int ret = 0;
 
 	if (bdev->bd_disk == NULL)
 		return -ENXIO;
@@ -314,7 +317,7 @@ int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
 	if (!q)
 		return -ENXIO;
 
-	bio = bio_alloc(GFP_KERNEL, 0);
+	bio = bio_alloc(gfp_mask, 0);
 	bio->bi_end_io = bio_end_empty_barrier;
 	bio->bi_private = &wait;
 	bio->bi_bdev = bdev;
@@ -330,7 +333,6 @@ int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
 	if (error_sector)
 		*error_sector = bio->bi_sector;
 
-	ret = 0;
 	if (bio_flagged(bio, BIO_EOPNOTSUPP))
 		ret = -EOPNOTSUPP;
 	else if (!bio_flagged(bio, BIO_UPTODATE))
@@ -362,17 +364,17 @@ static void blkdev_discard_end_io(struct bio *bio, int err)
  * @sector:	start sector
  * @nr_sects:	number of sectors to discard
  * @gfp_mask:	memory allocation flags (for bio_alloc)
- * @flags:	DISCARD_FL_* flags to control behaviour
+ * @flags:	BLKDEV_IFL_* flags to control behaviour
  *
  * Description:
  *    Issue a discard request for the sectors in question.
  */
 int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
-		sector_t nr_sects, gfp_t gfp_mask, int flags)
+		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q = bdev_get_queue(bdev);
-	int type = flags & DISCARD_FL_BARRIER ?
+	int type = flags & BLKDEV_IFL_BARRIER ?
 		DISCARD_BARRIER : DISCARD_NOBARRIER;
 	struct bio *bio;
 	struct page *page;
@@ -395,7 +397,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		bio->bi_sector = sector;
 		bio->bi_end_io = blkdev_discard_end_io;
 		bio->bi_bdev = bdev;
-		if (flags & DISCARD_FL_WAIT)
+		if (flags & BLKDEV_IFL_WAIT)
 			bio->bi_private = &wait;
 
 		/*
@@ -426,7 +428,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		bio_get(bio);
 		submit_bio(type, bio);
 
-		if (flags & DISCARD_FL_WAIT)
+		if (flags & BLKDEV_IFL_WAIT)
 			wait_for_completion(&wait);
 
 		if (bio_flagged(bio, BIO_EOPNOTSUPP))
diff --git a/block/ioctl.c b/block/ioctl.c
index 8905d2a..e8eb679 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -126,7 +126,7 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 	if (start + len > (bdev->bd_inode->i_size >> 9))
 		return -EINVAL;
 	return blkdev_issue_discard(bdev, start, len, GFP_KERNEL,
-				    DISCARD_FL_WAIT);
+				    BLKDEV_IFL_WAIT);
 }
 
 static int put_ushort(unsigned long arg, unsigned short val)
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index e5e86a7..d6f1ae3 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -2251,7 +2251,8 @@ static inline void drbd_md_flush(struct drbd_conf *mdev)
 	if (test_bit(MD_NO_BARRIER, &mdev->flags))
 		return;
 
-	r = blkdev_issue_flush(mdev->ldev->md_bdev, NULL);
+	r = blkdev_issue_flush(mdev->ldev->md_bdev, GFP_KERNEL, NULL,
+			BLKDEV_IFL_WAIT);
 	if (r) {
 		set_bit(MD_NO_BARRIER, &mdev->flags);
 		dev_err(DEV, "meta data flush failed with status %d, disabling md-flushes\n", r);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 3f096e7..c786023 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -946,7 +946,8 @@ static enum finish_epoch drbd_flush_after_epoch(struct drbd_conf *mdev, struct d
 	int rv;
 
 	if (mdev->write_ordering >= WO_bdev_flush && get_ldev(mdev)) {
-		rv = blkdev_issue_flush(mdev->ldev->backing_bdev, NULL);
+		rv = blkdev_issue_flush(mdev->ldev->backing_bdev, GFP_KERNEL,
+					NULL, BLKDEV_IFL_WAIT);
 		if (rv) {
 			dev_err(DEV, "local disk flush failed with status %d\n", rv);
 			/* would rather check on EOPNOTSUPP, but that is not reliable.
diff --git a/fs/block_dev.c b/fs/block_dev.c
index ea8385e..dd76930 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -413,7 +413,8 @@ int blkdev_fsync(struct file *filp, struct dentry *dentry, int datasync)
 	if (error)
 		return error;
 	
-	error = blkdev_issue_flush(bdev, NULL);
+	error = blkdev_issue_flush(bdev, GFP_KERNEL, NULL,
+				(BLKDEV_IFL_WAIT));
 	if (error == -EOPNOTSUPP)
 		error = 0;
 	return error;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b34d32f..c6a4f45 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1589,7 +1589,7 @@ static void btrfs_issue_discard(struct block_device *bdev,
 				u64 start, u64 len)
 {
 	blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL,
-			     DISCARD_FL_BARRIER);
+			BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
 }
 
 static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
diff --git a/fs/ext3/fsync.c b/fs/ext3/fsync.c
index 8209f26..9492f60 100644
--- a/fs/ext3/fsync.c
+++ b/fs/ext3/fsync.c
@@ -91,7 +91,8 @@ int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
 	 * storage
 	 */
 	if (test_opt(inode->i_sb, BARRIER))
-		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL,
+				BLKDEV_IFL_WAIT);
 out:
 	return ret;
 }
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 0d0c323..ef3d980 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -100,9 +100,11 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 		if (ext4_should_writeback_data(inode) &&
 		    (journal->j_fs_dev != journal->j_dev) &&
 		    (journal->j_flags & JBD2_BARRIER))
-			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+			blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL,
+					NULL, BLKDEV_IFL_WAIT);
 		jbd2_log_wait_commit(journal, commit_tid);
 	} else if (journal->j_flags & JBD2_BARRIER)
-		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL,
+			BLKDEV_IFL_WAIT);
 	return ret;
 }
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 503b842..bf011dc 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -854,7 +854,8 @@ static void gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
 				if ((start + nr_sects) != blk) {
 					rv = blkdev_issue_discard(bdev, start,
 							    nr_sects, GFP_NOFS,
-							    DISCARD_FL_BARRIER);
+							    BLKDEV_IFL_WAIT |
+							    BLKDEV_IFL_BARRIER);
 					if (rv)
 						goto fail;
 					nr_sects = 0;
@@ -869,7 +870,7 @@ start_new_extent:
 	}
 	if (nr_sects) {
 		rv = blkdev_issue_discard(bdev, start, nr_sects, GFP_NOFS,
-					 DISCARD_FL_BARRIER);
+					 BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
 		if (rv)
 			goto fail;
 	}
diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 30beb11..076d1cc 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -530,7 +530,8 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
 	 */
 	if ((journal->j_fs_dev != journal->j_dev) &&
 	    (journal->j_flags & JBD2_BARRIER))
-		blkdev_issue_flush(journal->j_fs_dev, NULL);
+		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL,
+			BLKDEV_IFL_WAIT);
 	if (!(journal->j_flags & JBD2_ABORT))
 		jbd2_journal_update_superblock(journal, 1);
 	return 0;
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 671da7f..75716d3 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -717,7 +717,8 @@ start_journal_io:
 	if (commit_transaction->t_flushed_data_blocks &&
 	    (journal->j_fs_dev != journal->j_dev) &&
 	    (journal->j_flags & JBD2_BARRIER))
-		blkdev_issue_flush(journal->j_fs_dev, NULL);
+		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL,
+			BLKDEV_IFL_WAIT);
 
 	/* Done it all: now write the commit record asynchronously. */
 	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
@@ -727,7 +728,8 @@ start_journal_io:
 		if (err)
 			__jbd2_journal_abort_hard(journal);
 		if (journal->j_flags & JBD2_BARRIER)
-			blkdev_issue_flush(journal->j_dev, NULL);
+			blkdev_issue_flush(journal->j_dev, GFP_KERNEL, NULL,
+				BLKDEV_IFL_WAIT);
 	}
 
 	err = journal_finish_inode_data_buffers(journal, commit_transaction);
diff --git a/fs/reiserfs/file.c b/fs/reiserfs/file.c
index 1d9c127..9977df9 100644
--- a/fs/reiserfs/file.c
+++ b/fs/reiserfs/file.c
@@ -147,7 +147,8 @@ static int reiserfs_sync_file(struct file *filp,
 	barrier_done = reiserfs_commit_for_inode(inode);
 	reiserfs_write_unlock(inode->i_sb);
 	if (barrier_done != 1 && reiserfs_barrier_flush(inode->i_sb))
-		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL, 
+			BLKDEV_IFL_WAIT);
 	if (barrier_done < 0)
 		return barrier_done;
 	return (err < 0) ? -EIO : 0;
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 52e06b4..2b177c7 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -725,7 +725,8 @@ void
 xfs_blkdev_issue_flush(
 	xfs_buftarg_t		*buftarg)
 {
-	blkdev_issue_flush(buftarg->bt_bdev, NULL);
+	blkdev_issue_flush(buftarg->bt_bdev, GFP_KERNEL, NULL,
+			BLKDEV_IFL_WAIT);
 }
 
 STATIC void
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5cf17a4..59b9aed 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -998,12 +998,16 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 		return NULL;
 	return bqt->tag_index[tag];
 }
-
-extern int blkdev_issue_flush(struct block_device *, sector_t *);
-#define DISCARD_FL_WAIT		0x01	/* wait for completion */
-#define DISCARD_FL_BARRIER	0x02	/* issue DISCARD_BARRIER request */
-extern int blkdev_issue_discard(struct block_device *, sector_t sector,
-		sector_t nr_sects, gfp_t, int flags);
+enum{
+	BLKDEV_WAIT,	/* wait for completion */
+	BLKDEV_BARRIER,	/*issue request with barrier */
+};
+#define BLKDEV_IFL_WAIT		(1 << BLKDEV_WAIT)
+#define BLKDEV_IFL_BARRIER	(1 << BLKDEV_BARRIER)
+extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *,
+			unsigned long);
+extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
+		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
 
 static inline int sb_issue_discard(struct super_block *sb,
 				   sector_t block, sector_t nr_blocks)
@@ -1011,7 +1015,7 @@ static inline int sb_issue_discard(struct super_block *sb,
 	block <<= (sb->s_blocksize_bits - 9);
 	nr_blocks <<= (sb->s_blocksize_bits - 9);
 	return blkdev_issue_discard(sb->s_bdev, block, nr_blocks, GFP_KERNEL,
-				    DISCARD_FL_BARRIER);
+				   BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
 }
 
 extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6cd0a8f..eb086e0 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -139,7 +139,8 @@ static int discard_swap(struct swap_info_struct *si)
 	nr_blocks = ((sector_t)se->nr_pages - 1) << (PAGE_SHIFT - 9);
 	if (nr_blocks) {
 		err = blkdev_issue_discard(si->bdev, start_block,
-				nr_blocks, GFP_KERNEL, DISCARD_FL_BARRIER);
+				nr_blocks, GFP_KERNEL,
+				BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
 		if (err)
 			return err;
 		cond_resched();
@@ -150,7 +151,8 @@ static int discard_swap(struct swap_info_struct *si)
 		nr_blocks = (sector_t)se->nr_pages << (PAGE_SHIFT - 9);
 
 		err = blkdev_issue_discard(si->bdev, start_block,
-				nr_blocks, GFP_KERNEL, DISCARD_FL_BARRIER);
+				nr_blocks, GFP_KERNEL,
+				BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
 		if (err)
 			break;
 
@@ -189,7 +191,8 @@ static void discard_swap_cluster(struct swap_info_struct *si,
 			start_block <<= PAGE_SHIFT - 9;
 			nr_blocks <<= PAGE_SHIFT - 9;
 			if (blkdev_issue_discard(si->bdev, start_block,
-				    nr_blocks, GFP_NOIO, DISCARD_FL_BARRIER))
+				    nr_blocks, GFP_NOIO, BLKDEV_IFL_WAIT |
+							BLKDEV_IFL_BARRIER))
 				break;
 		}
 
-- 
1.6.6.1

