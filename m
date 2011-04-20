Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab1DTMj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 08:39:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab1DTMj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 08:39:56 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, jmoyer@redhat.com,
        Lukas Czerner <lczerner@redhat.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/2] blkdev: Submit discard bio in batches in blkdev_issue_discard()
Date: Wed, 20 Apr 2011 14:39:31 +0200
Message-Id: <1303303172-22404-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we are waiting for every submitted REQ_DISCARD bio separately,
but it can have unwanted consequences of repeatedly flushing the queue,
so we rather submit bios in batches and wait for the entire batch, hence
narrowing the window of other ios going in.

Use bio_batch_end_io() and struct bio_batch for that purpose, the same
is used by blkdev_issue_zeroout(). Also change bio_batch_end_io() so we
always set !BIO_UPTODATE in the case of error and remove the check for
bb, since we are the only user of this function and we always set this.

Remove bio_get()/bio_put() from the blkdev_issue_discard() since
bio_alloc() and bio_batch_end_io() is doing the same thing, hence it is
not needed anymore.

I have done simple dd testing with surprising results. The script I have
used is:

for i in $(seq 10); do
        echo $i
        dd if=/dev/sdb1 of=/dev/sdc1 bs=4k &
        sleep 5
done
/usr/bin/time -f %e ./blkdiscard /dev/sdc1

Running time of BLKDISCARD on the whole device:
with patch              without patch
0.95                    15.58

So we can see that in this artificial test the kernel with the patch
applied is approx 16x faster in discarding the device.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
CC: Dmitry Monakhov <dmonakhov@openvz.org>
CC: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-lib.c |   69 +++++++++++++++++++++++-------------------------------
 1 files changed, 29 insertions(+), 40 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 25de73e..9260cb0 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -9,17 +9,23 @@
 
 #include "blk.h"
 
-static void blkdev_discard_end_io(struct bio *bio, int err)
+struct bio_batch {
+	atomic_t		done;
+	unsigned long		flags;
+	struct completion	*wait;
+};
+
+static void bio_batch_end_io(struct bio *bio, int err)
 {
+	struct bio_batch *bb = bio->bi_private;
+
 	if (err) {
 		if (err == -EOPNOTSUPP)
-			set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+			set_bit(BIO_EOPNOTSUPP, &bb->flags);
+		clear_bit(BIO_UPTODATE, &bb->flags);
 	}
-
-	if (bio->bi_private)
-		complete(bio->bi_private);
-
+	if (atomic_dec_and_test(&bb->done))
+		complete(bb->wait);
 	bio_put(bio);
 }
 
@@ -41,6 +47,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	struct request_queue *q = bdev_get_queue(bdev);
 	int type = REQ_WRITE | REQ_DISCARD;
 	unsigned int max_discard_sectors;
+	struct bio_batch bb;
 	struct bio *bio;
 	int ret = 0;
 
@@ -67,7 +74,11 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		type |= REQ_SECURE;
 	}
 
-	while (nr_sects && !ret) {
+	atomic_set(&bb.done, 1);
+	bb.flags = 1 << BIO_UPTODATE;
+	bb.wait = &wait;
+
+	while (nr_sects) {
 		bio = bio_alloc(gfp_mask, 1);
 		if (!bio) {
 			ret = -ENOMEM;
@@ -75,9 +86,9 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		}
 
 		bio->bi_sector = sector;
-		bio->bi_end_io = blkdev_discard_end_io;
+		bio->bi_end_io = bio_batch_end_io;
 		bio->bi_bdev = bdev;
-		bio->bi_private = &wait;
+		bio->bi_private = &bb;
 
 		if (nr_sects > max_discard_sectors) {
 			bio->bi_size = max_discard_sectors << 9;
@@ -88,45 +99,23 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 			nr_sects = 0;
 		}
 
-		bio_get(bio);
+		atomic_inc(&bb.done);
 		submit_bio(type, bio);
+	}
 
+	/* Wait for bios in-flight */
+	if (!atomic_dec_and_test(&bb.done))
 		wait_for_completion(&wait);
 
-		if (bio_flagged(bio, BIO_EOPNOTSUPP))
-			ret = -EOPNOTSUPP;
-		else if (!bio_flagged(bio, BIO_UPTODATE))
-			ret = -EIO;
-		bio_put(bio);
-	}
+	if (test_bit(BIO_EOPNOTSUPP, &bb.flags))
+		ret = -EOPNOTSUPP;
+	else if (!test_bit(BIO_UPTODATE, &bb.flags))
+		ret = -EIO;
 
 	return ret;
 }
 EXPORT_SYMBOL(blkdev_issue_discard);
 
-struct bio_batch
-{
-	atomic_t 		done;
-	unsigned long 		flags;
-	struct completion 	*wait;
-};
-
-static void bio_batch_end_io(struct bio *bio, int err)
-{
-	struct bio_batch *bb = bio->bi_private;
-
-	if (err) {
-		if (err == -EOPNOTSUPP)
-			set_bit(BIO_EOPNOTSUPP, &bb->flags);
-		else
-			clear_bit(BIO_UPTODATE, &bb->flags);
-	}
-	if (bb)
-		if (atomic_dec_and_test(&bb->done))
-			complete(bb->wait);
-	bio_put(bio);
-}
-
 /**
  * blkdev_issue_zeroout - generate number of zero filed write bios
  * @bdev:	blockdev to issue
-- 
1.7.4.4

