Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab0GCIr7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 04:47:59 -0400
Received: from sh.osrg.net ([192.16.179.4]:47316 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab0GCIqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 04:46:44 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: axboe@kernel.dk
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 8/9] ide: stop using q->prepare_flush_fn
Date: Sat,  3 Jul 2010 17:45:39 +0900
Message-Id: <1278146740-8731-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 03 Jul 2010 17:46:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use REQ_FLUSH flag instead.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/ide/ide-disk.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index df3d91b..c22e622 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -427,10 +427,15 @@ static void ide_disk_unlock_native_capacity(ide_drive_t *drive)
 		drive->dev_flags |= IDE_DFLAG_NOHPA; /* disable HPA on resume */
 }
 
-static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
+static int idedisk_prep_fn(struct request_queue *q, struct request *rq)
 {
 	ide_drive_t *drive = q->queuedata;
-	struct ide_cmd *cmd = kmalloc(sizeof(*cmd), GFP_ATOMIC);
+	struct ide_cmd *cmd;
+
+	if (!(rq->cmd_flags & REQ_FLUSH))
+		return BLKPREP_OK;
+
+	cmd = kmalloc(sizeof(*cmd), GFP_ATOMIC);
 
 	/* FIXME: map struct ide_taskfile on rq->cmd[] */
 	BUG_ON(cmd == NULL);
@@ -448,6 +453,8 @@ static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
 	rq->special = cmd;
 	cmd->rq = rq;
+
+	return BLKPREP_OK;
 }
 
 ide_devset_get(multcount, mult_count);
@@ -513,7 +520,6 @@ static void update_ordered(ide_drive_t *drive)
 {
 	u16 *id = drive->id;
 	unsigned ordered = QUEUE_ORDERED_NONE;
-	prepare_flush_fn *prep_fn = NULL;
 
 	if (drive->dev_flags & IDE_DFLAG_WCACHE) {
 		unsigned long long capacity;
@@ -538,12 +544,12 @@ static void update_ordered(ide_drive_t *drive)
 
 		if (barrier) {
 			ordered = QUEUE_ORDERED_DRAIN_FLUSH;
-			prep_fn = idedisk_prepare_flush;
+			blk_queue_prep_rq(drive->queue, idedisk_prep_fn);
 		}
 	} else
 		ordered = QUEUE_ORDERED_DRAIN;
 
-	blk_queue_ordered(drive->queue, ordered, prep_fn);
+	blk_queue_ordered(drive->queue, ordered, NULL);
 }
 
 ide_devset_get_flag(wcache, IDE_DFLAG_WCACHE);
-- 
1.6.5

