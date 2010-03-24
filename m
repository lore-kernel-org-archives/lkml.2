Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab0CXRau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:30:50 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46204 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507Ab0CXRaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:30:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=x1w3TFyzyjt1xIkZmSvz/Y8oGIMxD6UPjlE/lncy+YDr6NF/pOis+LdFcxkwVfegZE
         qnpYY+xJb/Ufh5QjkSVVdAnpnSeWCHHkI+r7xGg+bF+LfUxJhRg/Mzmcj0Ticta+BTb2
         3zG/IwzfPFQrn1PMQxGomrs/zbkMXZArD+JPA=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, hch@infradead.org, mkp@mkp.net,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/5] blkdev: pass gfp_mask and flags to blkdev_issue_flush
Date: Wed, 24 Mar 2010 20:29:47 +0300
Message-Id: <1269451792-5205-2-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1269451792-5205-1-git-send-email-dmonakhov@openvz.org>
References: <1269451792-5205-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some places caller don't want to wait a request to complete.
Flags make blkdev_issue_flush() more flexible. This patch just
convert existing callers to new interface without chaining
existing allocation/wait behavior.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-barrier.c                |   43 +++++++++++++++++++++---------------
 drivers/block/drbd/drbd_int.h      |    3 +-
 drivers/block/drbd/drbd_receiver.c |    3 +-
 fs/block_dev.c                     |    3 +-
 fs/ext3/fsync.c                    |    3 +-
 fs/ext4/fsync.c                    |    6 +++-
 fs/jbd2/checkpoint.c               |    3 +-
 fs/jbd2/commit.c                   |    6 +++-
 fs/reiserfs/file.c                 |    3 +-
 fs/xfs/linux-2.6/xfs_super.c       |    3 +-
 include/linux/blkdev.h             |   10 ++++++-
 11 files changed, 55 insertions(+), 31 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 8618d89..7e6e810 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -285,26 +285,31 @@ static void bio_end_empty_barrier(struct bio *bio, int err)
 			set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	}
-
-	complete(bio->bi_private);
+	if (bio->bi_private)
+		complete(bio->bi_private);
+	bio_put(bio);
 }
 
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
- *    wish to.
+ *    wish to. If WAIT flag is not passed then caller may check only what
+ *    request was pushed in some internal queue for later handling.
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
@@ -313,23 +318,25 @@ int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
 	if (!q)
 		return -ENXIO;
 
-	bio = bio_alloc(GFP_KERNEL, 0);
+	bio = bio_alloc(gfp_mask, 0);
 	bio->bi_end_io = bio_end_empty_barrier;
-	bio->bi_private = &wait;
 	bio->bi_bdev = bdev;
-	submit_bio(WRITE_BARRIER, bio);
+	if (test_bit(__BLKDEV_IFL_WAIT, &flags))
+		bio->bi_private = &wait;
 
-	wait_for_completion(&wait);
-
-	/*
-	 * The driver must store the error location in ->bi_sector, if
-	 * it supports it. For non-stacked drivers, this should be copied
-	 * from blk_rq_pos(rq).
-	 */
-	if (error_sector)
-		*error_sector = bio->bi_sector;
+	bio_get(bio);
+	submit_bio(WRITE_BARRIER, bio);
+	if (test_bit(__BLKDEV_IFL_WAIT, &flags)) {
+		wait_for_completion(&wait);
+		/*
+		 * The driver must store the error location in ->bi_sector, if
+		 * it supports it. For non-stacked drivers, this should be
+		 * copied from blk_rq_pos(rq).
+		 */
+		if (error_sector)
+			*error_sector = bio->bi_sector;
+	}
 
-	ret = 0;
 	if (bio_flagged(bio, BIO_EOPNOTSUPP))
 		ret = -EOPNOTSUPP;
 	else if (!bio_flagged(bio, BIO_UPTODATE))
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 2bf3a6e..1c00aa0 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -2241,7 +2241,8 @@ static inline void drbd_md_flush(struct drbd_conf *mdev)
 	if (test_bit(MD_NO_BARRIER, &mdev->flags))
 		return;
 
-	r = blkdev_issue_flush(mdev->ldev->md_bdev, NULL);
+	r = blkdev_issue_flush(mdev->ldev->md_bdev, GFP_KERNEL, NULL,
+			BLKDEV_IFL_WAIT);
 	if (r) {
 		set_bit(MD_NO_BARRIER, &mdev->flags);
 		dev_err(DEV, "meta data flush failed with status %d, disabling md-flushes\n", r);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index d065c64..ad395db 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -945,7 +945,8 @@ static enum finish_epoch drbd_flush_after_epoch(struct drbd_conf *mdev, struct d
 	int rv;
 
 	if (mdev->write_ordering >= WO_bdev_flush && get_ldev(mdev)) {
-		rv = blkdev_issue_flush(mdev->ldev->backing_bdev, NULL);
+		rv = blkdev_issue_flush(mdev->ldev->backing_bdev, GFP_KERNEL,
+					NULL, BLKDEV_IFL_WAIT);
 		if (rv) {
 			dev_err(DEV, "local disk flush failed with status %d\n", rv);
 			/* would rather check on EOPNOTSUPP, but that is not reliable.
diff --git a/fs/block_dev.c b/fs/block_dev.c
index d11d028..b1c8062 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -413,7 +413,8 @@ static int block_fsync(struct file *filp, struct dentry *dentry, int datasync)
 	if (error)
 		return error;
 	
-	error = blkdev_issue_flush(bdev, NULL);
+	error = blkdev_issue_flush(bdev, GFP_KERNEL, NULL,
+				(BLKDEV_IFL_WAIT));
 	if (error == -EOPNOTSUPP)
 		error = 0;
 	return error;
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
index 98bd140..99778d1 100644
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
diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 8868493..8f3ea7b 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -529,7 +529,8 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
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
index 1bc74b6..6f900d8 100644
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
index da2dba0..5e4f8c5 100644
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
index 25ea240..291b0ae 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -724,7 +724,8 @@ void
 xfs_blkdev_issue_flush(
 	xfs_buftarg_t		*buftarg)
 {
-	blkdev_issue_flush(buftarg->bt_bdev, NULL);
+	blkdev_issue_flush(buftarg->bt_bdev, GFP_KERNEL, NULL,
+			BLKDEV_IFL_WAIT);
 }
 
 STATIC void
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ebd22db..c8ee5cf 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1012,8 +1012,14 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 		return NULL;
 	return bqt->tag_index[tag];
 }
-
-extern int blkdev_issue_flush(struct block_device *, sector_t *);
+enum{
+	__BLKDEV_IFL_WAIT,	/* wait for completion */
+	__BLKDEV_IFL_BARRIER,	/*issue request with barrier */
+};
+#define BLKDEV_IFL_WAIT		(1 << __BLKDEV_IFL_WAIT)
+#define BLKDEV_IFL_BARRIER	(1 << __BLKDEV_IFL_BARRIER)
+extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *,
+			unsigned long);
 #define DISCARD_FL_WAIT		0x01	/* wait for completion */
 #define DISCARD_FL_BARRIER	0x02	/* issue DISCARD_BARRIER request */
 extern int blkdev_issue_discard(struct block_device *, sector_t sector,
-- 
1.6.6.1

