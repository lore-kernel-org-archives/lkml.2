Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab0LFSoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 13:44:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345Ab0LFSoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 13:44:23 -0500
Date: Mon, 6 Dec 2010 13:43:46 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>,
        device-mapper development <dm-devel@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>, stable@kernel.org
Subject: [PATCH for-2.6.37] block: max hardware sectors limit wrapper
Message-ID: <20101206184346.GA13582@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement blk_limits_max_hw_sectors() and make
blk_queue_max_hw_sectors() a wrapper around it.

DM needs this to avoid setting queue_limits' max_hw_sectors and
max_sectors directly.  dm_set_device_limits() now leverages
blk_limits_max_hw_sectors() logic to establish the appropriate
max_hw_sectors minimum (PAGE_SIZE).  Fixes issue where DM was
incorrectly setting max_sectors rather than max_hw_sectors (which
caused dm_merge_bvec()'s max_hw_sectors check to be ineffective).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@kernel.org
---
 block/blk-settings.c   |   26 ++++++++++++++++++++------
 drivers/md/dm-table.c  |    5 ++---
 include/linux/blkdev.h |    1 +
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 701859f..6a2ac23 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -229,8 +229,8 @@ void blk_queue_bounce_limit(struct request_queue *q, u64 dma_mask)
 EXPORT_SYMBOL(blk_queue_bounce_limit);
 
 /**
- * blk_queue_max_hw_sectors - set max sectors for a request for this queue
- * @q:  the request queue for the device
+ * blk_limits_max_hw_sectors - set hard and soft limit of max sectors for request
+ * @limits: the queue limits
  * @max_hw_sectors:  max hardware sectors in the usual 512b unit
  *
  * Description:
@@ -244,7 +244,7 @@ EXPORT_SYMBOL(blk_queue_bounce_limit);
  *    per-device basis in /sys/block/<device>/queue/max_sectors_kb.
  *    The soft limit can not exceed max_hw_sectors.
  **/
-void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_sectors)
+void blk_limits_max_hw_sectors(struct queue_limits *limits, unsigned int max_hw_sectors)
 {
 	if ((max_hw_sectors << 9) < PAGE_CACHE_SIZE) {
 		max_hw_sectors = 1 << (PAGE_CACHE_SHIFT - 9);
@@ -252,9 +252,23 @@ void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_secto
 		       __func__, max_hw_sectors);
 	}
 
-	q->limits.max_hw_sectors = max_hw_sectors;
-	q->limits.max_sectors = min_t(unsigned int, max_hw_sectors,
-				      BLK_DEF_MAX_SECTORS);
+	limits->max_hw_sectors = max_hw_sectors;
+	limits->max_sectors = min_t(unsigned int, max_hw_sectors,
+				    BLK_DEF_MAX_SECTORS);
+}
+EXPORT_SYMBOL(blk_limits_max_hw_sectors);
+
+/**
+ * blk_queue_max_hw_sectors - set max sectors for a request for this queue
+ * @q:  the request queue for the device
+ * @max_hw_sectors:  max hardware sectors in the usual 512b unit
+ *
+ * Description:
+ *    See description for blk_limits_max_hw_sectors().
+ **/
+void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_sectors)
+{
+	blk_limits_max_hw_sectors(&q->limits, max_hw_sectors);
 }
 EXPORT_SYMBOL(blk_queue_max_hw_sectors);
 
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 90267f8..3d098ce 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -517,9 +517,8 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 	 */
 
 	if (q->merge_bvec_fn && !ti->type->merge)
-		limits->max_sectors =
-			min_not_zero(limits->max_sectors,
-				     (unsigned int) (PAGE_SIZE >> 9));
+		blk_limits_max_hw_sectors(limits,
+					  (unsigned int) (PAGE_SIZE >> 9));
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dm_set_device_limits);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index aae86fd..f599dbc 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -805,6 +805,7 @@ extern struct request_queue *blk_init_allocated_queue(struct request_queue *,
 extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
+extern void blk_limits_max_hw_sectors(struct queue_limits *, unsigned int);
 extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_max_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
