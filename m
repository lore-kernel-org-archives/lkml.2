Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab1JUD4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 23:56:51 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37297 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab1JUD4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 23:56:49 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com, jgarzik@pobox.com, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] block, ide: unexport elv_add_request()
Date: Thu, 20 Oct 2011 20:56:37 -0700
Message-Id: <1319169400-15706-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319169400-15706-1-git-send-email-tj@kernel.org>
References: <1319169400-15706-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only elv_add_request() user outside of block layer proper is
ide-atapi and ide-park.  Now that blk_execute_rq_nowait() is allowed
from irq context, they can both be switched to
blk_execute_rq_nowait().  Switch IDE users, make [__]elv_add_request()
internal to block and drop the queue_lock grabbing version.

IDE changes lightly tested.  Block layer changes doesn't introduce any
behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c         |    6 +++---
 block/blk-exec.c         |    2 +-
 block/blk-flush.c        |    2 +-
 block/blk.h              |    1 +
 block/elevator.c         |   16 +++-------------
 drivers/ide/ide-atapi.c  |    7 ++++---
 drivers/ide/ide-park.c   |    2 +-
 include/linux/elevator.h |    2 --
 8 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 0f3baf4..024cf4a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1002,7 +1002,7 @@ static void add_acct_request(struct request_queue *q, struct request *rq,
 			     int where)
 {
 	drive_stat_acct(rq, 1);
-	__elv_add_request(q, rq, where);
+	elv_add_request(q, rq, where);
 }
 
 static void part_round_stats_single(int cpu, struct hd_struct *part,
@@ -2763,9 +2763,9 @@ void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 		 * rq is already accounted, so use raw insert
 		 */
 		if (rq->cmd_flags & (REQ_FLUSH | REQ_FUA))
-			__elv_add_request(q, rq, ELEVATOR_INSERT_FLUSH);
+			elv_add_request(q, rq, ELEVATOR_INSERT_FLUSH);
 		else
-			__elv_add_request(q, rq, ELEVATOR_INSERT_SORT_MERGE);
+			elv_add_request(q, rq, ELEVATOR_INSERT_SORT_MERGE);
 
 		depth++;
 	}
diff --git a/block/blk-exec.c b/block/blk-exec.c
index 056f097..5324501 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -61,7 +61,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
 	spin_lock_irqsave(q->queue_lock, flags);
-	__elv_add_request(q, rq, where);
+	elv_add_request(q, rq, where);
 	blk_run_queue_async(q);
 	/* the queue is stopped so it won't be run */
 	if (rq->cmd_type == REQ_TYPE_PM_RESUME)
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 491eb30..ab01265 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -288,7 +288,7 @@ static void flush_data_end_io(struct request *rq, int error)
  * blk_insert_flush - insert a new FLUSH/FUA request
  * @rq: request to insert
  *
- * To be called from __elv_add_request() for %ELEVATOR_INSERT_FLUSH insertions.
+ * To be called from elv_add_request() for %ELEVATOR_INSERT_FLUSH insertions.
  * @rq is being submitted.  Analyze what needs to be done and put it on the
  * right queue.
  *
diff --git a/block/blk.h b/block/blk.h
index 3f6551b..77ad885 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -52,6 +52,7 @@ static inline void blk_clear_rq_complete(struct request *rq)
  */
 #define ELV_ON_HASH(rq)		(!hlist_unhashed(&(rq)->hash))
 
+void elv_add_request(struct request_queue *q, struct request *rq, int where);
 void blk_insert_flush(struct request *rq);
 void blk_abort_flushes(struct request_queue *q);
 
diff --git a/block/elevator.c b/block/elevator.c
index 66343d6..51447dd 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -599,7 +599,7 @@ void elv_requeue_request(struct request_queue *q, struct request *rq)
 
 	rq->cmd_flags &= ~REQ_STARTED;
 
-	__elv_add_request(q, rq, ELEVATOR_INSERT_REQUEUE);
+	elv_add_request(q, rq, ELEVATOR_INSERT_REQUEUE);
 }
 
 void elv_drain_elevator(struct request_queue *q)
@@ -636,8 +636,9 @@ void elv_quiesce_end(struct request_queue *q)
 	spin_unlock_irq(q->queue_lock);
 }
 
-void __elv_add_request(struct request_queue *q, struct request *rq, int where)
+void elv_add_request(struct request_queue *q, struct request *rq, int where)
 {
+	lockdep_is_held(q->queue_lock);
 	trace_block_rq_insert(q, rq);
 
 	rq->q = q;
@@ -715,17 +716,6 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 		BUG();
 	}
 }
-EXPORT_SYMBOL(__elv_add_request);
-
-void elv_add_request(struct request_queue *q, struct request *rq, int where)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	__elv_add_request(q, rq, where);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-}
-EXPORT_SYMBOL(elv_add_request);
 
 struct request *elv_latter_request(struct request_queue *q, struct request *rq)
 {
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 6f218e01..2f1b474 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -221,6 +221,8 @@ EXPORT_SYMBOL_GPL(ide_prep_sense);
 
 int ide_queue_sense_rq(ide_drive_t *drive, void *special)
 {
+	struct request *rq = &drive->sense_rq;
+
 	/* deferred failure from ide_prep_sense() */
 	if (!drive->sense_rq_armed) {
 		printk(KERN_WARNING PFX "%s: error queuing a sense request\n",
@@ -228,12 +230,11 @@ int ide_queue_sense_rq(ide_drive_t *drive, void *special)
 		return -ENOMEM;
 	}
 
-	drive->sense_rq.special = special;
 	drive->sense_rq_armed = false;
-
 	drive->hwif->rq = NULL;
 
-	elv_add_request(drive->queue, &drive->sense_rq, ELEVATOR_INSERT_FRONT);
+	rq->special = special;
+	blk_execute_rq_nowait(drive->queue, rq->rq_disk, rq, true, NULL);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ide_queue_sense_rq);
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index 6ab9ab2..0c64957 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -52,7 +52,7 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 	rq->cmd[0] = REQ_UNPARK_HEADS;
 	rq->cmd_len = 1;
 	rq->cmd_type = REQ_TYPE_SPECIAL;
-	elv_add_request(q, rq, ELEVATOR_INSERT_FRONT);
+	blk_execute_rq_nowait(q, NULL, rq, true, NULL);
 
 out:
 	return;
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 1d0f7a2..34d71f5 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -105,8 +105,6 @@ struct elevator_queue
  */
 extern void elv_dispatch_sort(struct request_queue *, struct request *);
 extern void elv_dispatch_add_tail(struct request_queue *, struct request *);
-extern void elv_add_request(struct request_queue *, struct request *, int);
-extern void __elv_add_request(struct request_queue *, struct request *, int);
 extern int elv_merge(struct request_queue *, struct request **, struct bio *);
 extern int elv_try_merge(struct request *, struct bio *);
 extern void elv_merge_requests(struct request_queue *, struct request *,
-- 
1.7.3.1

