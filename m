Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab1G1XzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:55:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:11646 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125Ab1G1XoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="32808883"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: James.Bottomley@HansenPartnership.com, JBottomley@Parallels.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [7/50] fix crash in scsi_dispatch_cmd()
Message-Id: <20110728234411.6CC9F2403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: James Bottomley <James.Bottomley@HansenPartnership.com>

[ upstream commit bfe159a51203c15d23cb3158fffdc25ec4b4dda1 ]

USB surprise removal of sr is triggering an oops in
scsi_dispatch_command().  What seems to be happening is that USB is
hanging on to a queue reference until the last close of the upper
device, so the crash is caused by surprise remove of a mounted CD
followed by attempted unmount.

The problem is that USB doesn't issue its final commands as part of
the SCSI teardown path, but on last close when the block queue is long
gone.  The long term fix is probably to make sr do the teardown in the
same way as sd (so remove all the lower bits on ejection, but keep the
upper disk alive until last close of user space).  However, the
current oops can be simply fixed by not allowing any commands to be
sent to a dead queue.

Cc: stable@kernel.org
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/block/blk-core.c
===================================================================
--- linux-2.6.35.y.orig/block/blk-core.c
+++ linux-2.6.35.y/block/blk-core.c
@@ -893,6 +893,9 @@ struct request *blk_get_request(struct r
 {
 	struct request *rq;
 
+	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
+		return NULL;
+
 	BUG_ON(rw != READ && rw != WRITE);
 
 	spin_lock_irq(q->queue_lock);
Index: linux-2.6.35.y/block/blk-exec.c
===================================================================
--- linux-2.6.35.y.orig/block/blk-exec.c
+++ linux-2.6.35.y/block/blk-exec.c
@@ -50,6 +50,13 @@ void blk_execute_rq_nowait(struct reques
 {
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
 
+	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))) {
+		rq->errors = -ENXIO;
+		if (rq->end_io)
+			rq->end_io(rq, rq->errors);
+		return;
+	}
+
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
 	WARN_ON(irqs_disabled());
Index: linux-2.6.35.y/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.35.y.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6.35.y/drivers/scsi/scsi_lib.c
@@ -215,6 +215,8 @@ int scsi_execute(struct scsi_device *sde
 	int ret = DRIVER_ERROR << 24;
 
 	req = blk_get_request(sdev->request_queue, write, __GFP_WAIT);
+	if (!req)
+		return ret;
 
 	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
 					buffer, bufflen, __GFP_WAIT))
