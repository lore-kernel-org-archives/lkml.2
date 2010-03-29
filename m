Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab0C2GJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 02:09:43 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44201 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab0C2GJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 02:09:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=MyW2B9kW2mg7OEX5kaPmxNZ2oc+BLI8c0AMa5bRSpx2uWnPpleg5EosTKJsGCh4wx8
         rzifb7a5wBuv3sNZqJ/1qQYXvA2wsrgmF0ps3LHEMGjL7tZ/J9Yukp2JAbWQLGXHYTL8
         rk120Jwqq+qTgwDFVyEClhll9qcrncZISsYrM=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/6] blkdev: add blkdev_issue helper functions
Date: Mon, 29 Mar 2010 10:09:22 +0400
Message-Id: <1269842965-4700-4-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1269842965-4700-3-git-send-email-dmonakhov@openvz.org>
References: <1269842965-4700-1-git-send-email-dmonakhov@openvz.org>
 <1269842965-4700-2-git-send-email-dmonakhov@openvz.org>
 <1269842965-4700-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move blkdev_issue_discard from blk-barrier.c because it is not barrier
related.

Add new helper functions:
__blkdev_issue_zeroout: Explicitly zero given range via zeroed write request.
This function is useful in many places.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/Makefile         |    2 +-
 block/blk-barrier.c    |  103 ---------------------
 block/blk-lib.c        |  232 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    3 +-
 4 files changed, 235 insertions(+), 105 deletions(-)
 create mode 100644 block/blk-lib.c

diff --git a/block/Makefile b/block/Makefile
index cb2d515..0bb499a 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -5,7 +5,7 @@
 obj-$(CONFIG_BLOCK) := elevator.o blk-core.o blk-tag.o blk-sysfs.o \
 			blk-barrier.o blk-settings.o blk-ioc.o blk-map.o \
 			blk-exec.o blk-merge.o blk-softirq.o blk-timeout.o \
-			blk-iopoll.o ioctl.o genhd.o scsi_ioctl.o
+			blk-iopoll.o blk-lib.o ioctl.o genhd.o scsi_ioctl.o
 
 obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
 obj-$(CONFIG_BLK_CGROUP)	+= blk-cgroup.o
diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 56254b1..1242bdd 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -347,106 +347,3 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 }
 EXPORT_SYMBOL(blkdev_issue_flush);
 
-static void blkdev_discard_end_io(struct bio *bio, int err)
-{
-	if (err) {
-		if (err == -EOPNOTSUPP)
-			set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
-	}
-
-	if (bio->bi_private)
-		complete(bio->bi_private);
-	__free_page(bio_page(bio));
-
-	bio_put(bio);
-}
-
-/**
- * blkdev_issue_discard - queue a discard
- * @bdev:	blockdev to issue discard for
- * @sector:	start sector
- * @nr_sects:	number of sectors to discard
- * @gfp_mask:	memory allocation flags (for bio_alloc)
- * @flags:	BLKDEV_IFL_* flags to control behaviour
- *
- * Description:
- *    Issue a discard request for the sectors in question.
- */
-int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
-		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags)
-{
-	DECLARE_COMPLETION_ONSTACK(wait);
-	struct request_queue *q = bdev_get_queue(bdev);
-	int type = flags & BLKDEV_IFL_BARRIER ?
-		DISCARD_BARRIER : DISCARD_NOBARRIER;
-	struct bio *bio;
-	struct page *page;
-	int ret = 0;
-
-	if (!q)
-		return -ENXIO;
-
-	if (!blk_queue_discard(q))
-		return -EOPNOTSUPP;
-
-	while (nr_sects && !ret) {
-		unsigned int sector_size = q->limits.logical_block_size;
-		unsigned int max_discard_sectors =
-			min(q->limits.max_discard_sectors, UINT_MAX >> 9);
-
-		bio = bio_alloc(gfp_mask, 1);
-		if (!bio)
-			goto out;
-		bio->bi_sector = sector;
-		bio->bi_end_io = blkdev_discard_end_io;
-		bio->bi_bdev = bdev;
-		if (flags & BLKDEV_IFL_BARRIER)
-			bio->bi_private = &wait;
-
-		/*
-		 * Add a zeroed one-sector payload as that's what
-		 * our current implementations need.  If we'll ever need
-		 * more the interface will need revisiting.
-		 */
-		page = alloc_page(gfp_mask | __GFP_ZERO);
-		if (!page)
-			goto out_free_bio;
-		if (bio_add_pc_page(q, bio, page, sector_size, 0) < sector_size)
-			goto out_free_page;
-
-		/*
-		 * And override the bio size - the way discard works we
-		 * touch many more blocks on disk than the actual payload
-		 * length.
-		 */
-		if (nr_sects > max_discard_sectors) {
-			bio->bi_size = max_discard_sectors << 9;
-			nr_sects -= max_discard_sectors;
-			sector += max_discard_sectors;
-		} else {
-			bio->bi_size = nr_sects << 9;
-			nr_sects = 0;
-		}
-
-		bio_get(bio);
-		submit_bio(type, bio);
-
-		if (flags & BLKDEV_IFL_BARRIER)
-			wait_for_completion(&wait);
-
-		if (bio_flagged(bio, BIO_EOPNOTSUPP))
-			ret = -EOPNOTSUPP;
-		else if (!bio_flagged(bio, BIO_UPTODATE))
-			ret = -EIO;
-		bio_put(bio);
-	}
-	return ret;
-out_free_page:
-	__free_page(page);
-out_free_bio:
-	bio_put(bio);
-out:
-	return -ENOMEM;
-}
-EXPORT_SYMBOL(blkdev_issue_discard);
diff --git a/block/blk-lib.c b/block/blk-lib.c
new file mode 100644
index 0000000..d0f84f6
--- /dev/null
+++ b/block/blk-lib.c
@@ -0,0 +1,232 @@
+/*
+ * Functions related to generic helpers functions
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/bio.h>
+#include <linux/blkdev.h>
+#include <linux/scatterlist.h>
+
+#include "blk.h"
+
+struct bio_batch
+{
+	atomic_t 		done;
+	unsigned long 		flags;
+	struct completion 	*wait;
+	bio_end_io_t		*end_io;
+};
+
+static void bio_batch_end_io(struct bio *bio, int err)
+{
+	struct bio_batch *bb = bio->bi_private;
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			set_bit(BIO_EOPNOTSUPP, &bb->flags);
+		else
+			clear_bit(BIO_UPTODATE, &bb->flags);
+	}
+	if (bb) {
+		if (bb->end_io)
+			bb->end_io(bio, err);
+		atomic_inc(&bb->done);
+		complete(bb->wait);
+	}
+	bio_put(bio);
+}
+
+/**
+ * __blkdev_issue_zeroout generate number of zero filed write bios
+ * @bdev:	blockdev to issue
+ * @sector:	start sector
+ * @nr_sects:	number of sectors to write
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ * @flags:	BLKDEV_IFL_* flags to control behaviour
+ *
+ * Description:
+ *  Generate and issue number of bios with zerofiled pages.
+ *  Send barrier at the beginning and at the end if requested. This guarantie
+ *  correct request ordering. Empty barrier allow us to avoid post queue flush.
+ */
+
+int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
+			sector_t nr_sects, gfp_t gfp_mask, unsigned long flags)
+{
+	int ret = 0;
+	struct bio *bio;
+	struct bio_batch bb;
+	unsigned int sz, issued = 0;
+	DECLARE_COMPLETION_ONSTACK(wait);
+
+	atomic_set(&bb.done, 0);
+	bb.flags = 1 << BIO_UPTODATE;
+	bb.wait = &wait;
+	bb.end_io = NULL;
+
+	if (flags & BLKDEV_IFL_BARRIER) {
+		/* issue async barrier before the data */
+		ret = blkdev_issue_flush(bdev, gfp_mask, NULL, 0);
+		if (ret)
+			return ret;
+	}
+submit:
+	while (nr_sects != 0) {
+		bio = bio_alloc(gfp_mask,
+				min(nr_sects, (sector_t)BIO_MAX_PAGES));
+		if (!bio)
+			break;
+
+		bio->bi_sector = sector;
+		bio->bi_bdev   = bdev;
+		bio->bi_end_io = bio_batch_end_io;
+		if (flags & BLKDEV_IFL_WAIT)
+			bio->bi_private = &bb;
+
+		while(nr_sects != 0) {
+			sz = min(PAGE_SIZE >> 9 , nr_sects);
+			if (sz == 0)
+				/* bio has maximum size possible */
+				break;
+			ret = bio_add_page(bio, ZERO_PAGE(0), sz << 9, 0);
+			nr_sects -= ret >> 9;
+			sector += ret >> 9;
+			if (ret < (sz << 9))
+				break;
+		}
+		issued++;
+		submit_bio(WRITE, bio);
+	}
+	/*
+	 * When all data bios are in flight. Send final barrier if requeted.
+	 */
+	if (nr_sects == 0 && flags & BLKDEV_IFL_BARRIER)
+		ret = blkdev_issue_flush(bdev, gfp_mask, NULL,
+					flags & BLKDEV_IFL_WAIT);
+
+
+	if (flags & BLKDEV_IFL_WAIT)
+		/* Wait for bios in-flight */
+		while ( issued != atomic_read(&bb.done))
+			wait_for_completion(&wait);
+
+	if (!test_bit(BIO_UPTODATE, &bb.flags))
+		/* One of bios in the batch was completed with error.*/
+		ret = -EIO;
+
+	if (ret)
+		goto out;
+
+	if (test_bit(BIO_EOPNOTSUPP, &bb.flags)) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+	if (nr_sects != 0)
+		goto submit;
+out:
+	return ret;
+}
+EXPORT_SYMBOL(__blkdev_issue_zeroout);
+
+static void blkdev_discard_end_io(struct bio *bio, int err)
+{
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
+		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+	}
+
+	if (bio->bi_private)
+		complete(bio->bi_private);
+	__free_page(bio_page(bio));
+
+	bio_put(bio);
+}
+
+/**
+ * blkdev_issue_discard - queue a discard
+ * @bdev:	blockdev to issue discard for
+ * @sector:	start sector
+ * @nr_sects:	number of sectors to discard
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ * @flags:	BLKDEV_IFL_* flags to control behaviour
+ *
+ * Description:
+ *    Issue a discard request for the sectors in question.
+ */
+int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
+		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags)
+{
+	DECLARE_COMPLETION_ONSTACK(wait);
+	struct request_queue *q = bdev_get_queue(bdev);
+	int type = flags & BLKDEV_IFL_BARRIER ?
+		DISCARD_BARRIER : DISCARD_NOBARRIER;
+	struct bio *bio;
+	struct page *page;
+	int ret = 0;
+
+	if (!q)
+		return -ENXIO;
+
+	if (!blk_queue_discard(q))
+		return -EOPNOTSUPP;
+
+	while (nr_sects && !ret) {
+		unsigned int sector_size = q->limits.logical_block_size;
+		unsigned int max_discard_sectors =
+			min(q->limits.max_discard_sectors, UINT_MAX >> 9);
+
+		bio = bio_alloc(gfp_mask, 1);
+		if (!bio)
+			goto out;
+		bio->bi_sector = sector;
+		bio->bi_end_io = blkdev_discard_end_io;
+		bio->bi_bdev = bdev;
+		if (flags & BLKDEV_IFL_BARRIER)
+			bio->bi_private = &wait;
+
+		/*
+		 * Add a zeroed one-sector payload as that's what
+		 * our current implementations need.  If we'll ever need
+		 * more the interface will need revisiting.
+		 */
+		page = alloc_page(gfp_mask | __GFP_ZERO);
+		if (!page)
+			goto out_free_bio;
+		if (bio_add_pc_page(q, bio, page, sector_size, 0) < sector_size)
+			goto out_free_page;
+
+		/*
+		 * And override the bio size - the way discard works we
+		 * touch many more blocks on disk than the actual payload
+		 * length.
+		 */
+		if (nr_sects > max_discard_sectors) {
+			bio->bi_size = max_discard_sectors << 9;
+			nr_sects -= max_discard_sectors;
+			sector += max_discard_sectors;
+		} else {
+			bio->bi_size = nr_sects << 9;
+			nr_sects = 0;
+		}
+
+		bio_get(bio);
+		submit_bio(type, bio);
+
+		if (flags & BLKDEV_IFL_BARRIER)
+			wait_for_completion(&wait);
+
+		if (bio_flagged(bio, BIO_EOPNOTSUPP))
+			ret = -EOPNOTSUPP;
+		else if (!bio_flagged(bio, BIO_UPTODATE))
+			ret = -EIO;
+		bio_put(bio);
+	}
+	return ret;
+out_free_page:
+	__free_page(page);
+out_free_bio:
+	bio_put(bio);
+out:
+	return -ENOMEM;
+}
+EXPORT_SYMBOL(blkdev_issue_discard);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 84ec105..8bc6966 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1022,7 +1022,8 @@ extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *,
 			unsigned long);
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
-
+extern int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
+			sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
 static inline int sb_issue_discard(struct super_block *sb,
 				   sector_t block, sector_t nr_blocks)
 {
-- 
1.6.6.1

