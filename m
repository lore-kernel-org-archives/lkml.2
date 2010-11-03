Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab0KCVvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 17:51:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab0KCVvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 17:51:00 -0400
Date: Wed, 3 Nov 2010 17:50:47 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, jaxboe@fusionio.com
Cc: device-mapper development <dm-devel@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] block: rename trace_block_remap to trace_block_bio_remap
Message-ID: <20101103215047.GC26473@redhat.com>
References: <4AB3A393.5000709@ce.jp.nec.com>
 <4AB4F908.60307@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB4F908.60307@ce.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename "block_remap" tracepoint to "block_bio_remap" to clarify the
event.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c             |   10 +++++-----
 drivers/md/dm.c              |    4 ++--
 include/trace/events/block.h |    6 +++---
 kernel/trace/blktrace.c      |   12 ++++++------
 4 files changed, 16 insertions(+), 16 deletions(-)

v2: patch needed to be rebased and it should go through the Jens'
linux-2.6-block tree.  The original v1 patch is here:
https://patchwork.kernel.org/patch/48763/

diff --git a/block/blk-core.c b/block/blk-core.c
index f0834e2..9d5a61f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -33,7 +33,7 @@
 
 #include "blk.h"
 
-EXPORT_TRACEPOINT_SYMBOL_GPL(block_remap);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
 
@@ -1336,9 +1336,9 @@ static inline void blk_partition_remap(struct bio *bio)
 		bio->bi_sector += p->start_sect;
 		bio->bi_bdev = bdev->bd_contains;
 
-		trace_block_remap(bdev_get_queue(bio->bi_bdev), bio,
-				    bdev->bd_dev,
-				    bio->bi_sector - p->start_sect);
+		trace_block_bio_remap(bdev_get_queue(bio->bi_bdev), bio,
+				      bdev->bd_dev,
+				      bio->bi_sector - p->start_sect);
 	}
 }
 
@@ -1507,7 +1507,7 @@ static inline void __generic_make_request(struct bio *bio)
 			goto end_io;
 
 		if (old_sector != -1)
-			trace_block_remap(q, bio, old_dev, old_sector);
+			trace_block_bio_remap(q, bio, old_dev, old_sector);
 
 		old_sector = bio->bi_sector;
 		old_dev = bio->bi_bdev->bd_dev;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7cb1352..0a2b551 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -990,8 +990,8 @@ static void __map_bio(struct dm_target *ti, struct bio *clone,
 	if (r == DM_MAPIO_REMAPPED) {
 		/* the bio has been remapped so dispatch it */
 
-		trace_block_remap(bdev_get_queue(clone->bi_bdev), clone,
-				    tio->io->bio->bi_bdev->bd_dev, sector);
+		trace_block_bio_remap(bdev_get_queue(clone->bi_bdev), clone,
+				      tio->io->bio->bi_bdev->bd_dev, sector);
 
 		generic_make_request(clone);
 	} else if (r < 0 || r == DM_MAPIO_REQUEUE) {
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index d8ce278..b56c65d 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -486,16 +486,16 @@ TRACE_EVENT(block_split,
 );
 
 /**
- * block_remap - map request for a partition to the raw device
+ * block_bio_remap - map request for a logical device to the raw device
  * @q: queue holding the operation
  * @bio: revised operation
  * @dev: device for the operation
  * @from: original sector for the operation
  *
- * An operation for a partition on a block device has been mapped to the
+ * An operation for a logical device has been mapped to the
  * raw block device.
  */
-TRACE_EVENT(block_remap,
+TRACE_EVENT(block_bio_remap,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
 		 sector_t from),
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index bc251ed..9f42529 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -889,7 +889,7 @@ static void blk_add_trace_split(void *ignore,
 }
 
 /**
- * blk_add_trace_remap - Add a trace for a remap operation
+ * blk_add_trace_bio_remap - Add a trace for a bio-remap operation
  * @ignore:	trace callback data parameter (not used)
  * @q:		queue the io is for
  * @bio:	the source bio
@@ -901,9 +901,9 @@ static void blk_add_trace_split(void *ignore,
  *     it spans a stripe (or similar). Add a trace for that action.
  *
  **/
-static void blk_add_trace_remap(void *ignore,
-				struct request_queue *q, struct bio *bio,
-				dev_t dev, sector_t from)
+static void blk_add_trace_bio_remap(void *ignore,
+				    struct request_queue *q, struct bio *bio,
+				    dev_t dev, sector_t from)
 {
 	struct blk_trace *bt = q->blk_trace;
 	struct blk_io_trace_remap r;
@@ -1018,7 +1018,7 @@ static void blk_register_tracepoints(void)
 	WARN_ON(ret);
 	ret = register_trace_block_split(blk_add_trace_split, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_remap(blk_add_trace_remap, NULL);
+	ret = register_trace_block_bio_remap(blk_add_trace_bio_remap, NULL);
 	WARN_ON(ret);
 	ret = register_trace_block_rq_remap(blk_add_trace_rq_remap, NULL);
 	WARN_ON(ret);
@@ -1027,7 +1027,7 @@ static void blk_register_tracepoints(void)
 static void blk_unregister_tracepoints(void)
 {
 	unregister_trace_block_rq_remap(blk_add_trace_rq_remap, NULL);
-	unregister_trace_block_remap(blk_add_trace_remap, NULL);
+	unregister_trace_block_bio_remap(blk_add_trace_bio_remap, NULL);
 	unregister_trace_block_split(blk_add_trace_split, NULL);
 	unregister_trace_block_unplug_io(blk_add_trace_unplug_io, NULL);
 	unregister_trace_block_unplug_timer(blk_add_trace_unplug_timer, NULL);
