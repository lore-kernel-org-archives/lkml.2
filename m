Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab0C2GKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 02:10:47 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55998 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab0C2GJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 02:09:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=FISQp2p4nQVsF4sWpVL7uNWVpYaeJvISsJe6Nx9jT1deW0TkfTijSt9Dua/g9GHkpV
         QxfcaXyMtpV4xgChrcxDJcZVUFeZ7tSqQ6W9G2A7Szxnelo2prqHrtkl1Q3FJvYYycAU
         66oncbr4IVwNUlAiQ7Acj+6waeuOUNcFe7Iv4=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/6] blkdev: generalize flags for blkdev_issue_fn functions
Date: Mon, 29 Mar 2010 10:09:21 +0400
Message-Id: <1269842965-4700-3-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1269842965-4700-2-git-send-email-dmonakhov@openvz.org>
References: <1269842965-4700-1-git-send-email-dmonakhov@openvz.org>
 <1269842965-4700-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch just convert all blkdev_issue_xxx function to common
flags. Wait/allocation semantics not changed.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-barrier.c    |   10 +++++-----
 block/ioctl.c          |    2 +-
 fs/btrfs/extent-tree.c |    2 +-
 fs/gfs2/rgrp.c         |    5 +++--
 include/linux/blkdev.h |    8 +++-----
 mm/swapfile.c          |    8 +++++---
 6 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 7e6e810..56254b1 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -368,17 +368,17 @@ static void blkdev_discard_end_io(struct bio *bio, int err)
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
@@ -401,7 +401,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		bio->bi_sector = sector;
 		bio->bi_end_io = blkdev_discard_end_io;
 		bio->bi_bdev = bdev;
-		if (flags & DISCARD_FL_WAIT)
+		if (flags & BLKDEV_IFL_BARRIER)
 			bio->bi_private = &wait;
 
 		/*
@@ -432,7 +432,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		bio_get(bio);
 		submit_bio(type, bio);
 
-		if (flags & DISCARD_FL_WAIT)
+		if (flags & BLKDEV_IFL_BARRIER)
 			wait_for_completion(&wait);
 
 		if (bio_flagged(bio, BIO_EOPNOTSUPP))
diff --git a/block/ioctl.c b/block/ioctl.c
index be48ea5..d803cac 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -125,7 +125,7 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 	if (start + len > (bdev->bd_inode->i_size >> 9))
 		return -EINVAL;
 	return blkdev_issue_discard(bdev, start, len, GFP_KERNEL,
-				    DISCARD_FL_WAIT);
+				    BLKDEV_IFL_WAIT);
 }
 
 static int put_ushort(unsigned long arg, unsigned short val)
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 559f724..7453ac4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1588,7 +1588,7 @@ static void btrfs_issue_discard(struct block_device *bdev,
 				u64 start, u64 len)
 {
 	blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL,
-			     DISCARD_FL_BARRIER);
+			BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
 }
 
 static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
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
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c8ee5cf..84ec105 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1020,10 +1020,8 @@ enum{
 #define BLKDEV_IFL_BARRIER	(1 << __BLKDEV_IFL_BARRIER)
 extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *,
 			unsigned long);
-#define DISCARD_FL_WAIT		0x01	/* wait for completion */
-#define DISCARD_FL_BARRIER	0x02	/* issue DISCARD_BARRIER request */
-extern int blkdev_issue_discard(struct block_device *, sector_t sector,
-		sector_t nr_sects, gfp_t, int flags);
+extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
+		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
 
 static inline int sb_issue_discard(struct super_block *sb,
 				   sector_t block, sector_t nr_blocks)
@@ -1031,7 +1029,7 @@ static inline int sb_issue_discard(struct super_block *sb,
 	block <<= (sb->s_blocksize_bits - 9);
 	nr_blocks <<= (sb->s_blocksize_bits - 9);
 	return blkdev_issue_discard(sb->s_bdev, block, nr_blocks, GFP_KERNEL,
-				    DISCARD_FL_BARRIER);
+				   BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
 }
 
 extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6c0585b..6c48271 100644
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
 
@@ -189,7 +191,7 @@ static void discard_swap_cluster(struct swap_info_struct *si,
 			start_block <<= PAGE_SHIFT - 9;
 			nr_blocks <<= PAGE_SHIFT - 9;
 			if (blkdev_issue_discard(si->bdev, start_block,
-				    nr_blocks, GFP_NOIO, DISCARD_FL_BARRIER))
+				    nr_blocks, GFP_NOIO, BLKDEV_IFL_BARRIER))
 				break;
 		}
 
-- 
1.6.6.1

