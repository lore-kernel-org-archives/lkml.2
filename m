Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab0DLNEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 09:04:40 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40707 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab0DLNEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 09:04:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=GQE2+FfeUH3nfXnfFngS/3KPG6fgfvBCK4m/T3TjumpZNB11RmoPTyTs9sIHp3bxJS
         IhAGAFkueFrNEg6lnDm2WVgXUWoGTH7SBPJv0kEDHHl9CBqGuXcsfUk5hc92YneEylkA
         s59tlzfqPj5pDzp3jUjkgQdQT+wp/DoSU3nKM=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, hch@infradead.org,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/4] blkdev: add blkdev_issue helper functions
Date: Mon, 12 Apr 2010 17:03:56 +0400
Message-Id: <1271077437-7921-4-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1271077437-7921-3-git-send-email-dmonakhov@openvz.org>
References: <1271077437-7921-1-git-send-email-dmonakhov@openvz.org>
 <1271077437-7921-2-git-send-email-dmonakhov@openvz.org>
 <1271077437-7921-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move blkdev_issue_discard from blk-barrier.c because it is not barrier
related.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/Makefile      |    2 +-
 block/blk-barrier.c |  103 ----------------------------------------------
 block/blk-lib.c     |  114 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 115 insertions(+), 104 deletions(-)
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
index 0000000..d7827e5
--- /dev/null
+++ b/block/blk-lib.c
@@ -0,0 +1,114 @@
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
-- 
1.6.6.1

