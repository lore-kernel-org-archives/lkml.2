Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab1JZBCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:02:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51402 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab1JZBCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:02:20 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com, jgarzik@pobox.com, davem@davemloft.net,
        hch@infradead.org
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] block, ide: unexport elv_add_request()
Date: Tue, 25 Oct 2011 18:02:04 -0700
Message-Id: <1319590927-15791-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319590927-15791-1-git-send-email-tj@kernel.org>
References: <1319590927-15791-1-git-send-email-tj@kernel.org>
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
index a36738b..1efb943 100644
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
index b686f2b..951eda7 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -63,7 +63,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	rq->end_io = done;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	__elv_add_request(q, rq, where);
+	elv_add_request(q, rq, where);
 
 	/*
 	 * Some drivers beat this path pretty hard.  As an optimization, if
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 720ad60..a21d43e 100644
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

