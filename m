Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab1AVBRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:17:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:45787 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029Ab1AVBRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:17:35 -0500
From: Jens Axboe <jaxboe@fusionio.com>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: [PATCH 03/10] scsi: convert to blk_delay_queue()
Date: Sat, 22 Jan 2011 01:17:22 +0000
Message-Id: <1295659049-2688-4-git-send-email-jaxboe@fusionio.com>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 22 Jan 2011 01:17:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
---
 drivers/scsi/scsi_lib.c |   44 +++++++++++++++++++-------------------------
 1 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9045c52..5a0ae7a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -67,6 +67,13 @@ static struct scsi_host_sg_pool scsi_sg_pools[] = {
 
 struct kmem_cache *scsi_sdb_cache;
 
+/*
+ * When to reinvoke queueing after a resource shortage. It's 3 msecs to
+ * not change behaviour from the previous unplug mechanism, experimentation
+ * may prove this needs changing.
+ */
+#define SCSI_QUEUE_DELAY	3
+
 static void scsi_run_queue(struct request_queue *q);
 
 /*
@@ -149,14 +156,7 @@ static int __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	/*
 	 * Requeue this command.  It will go before all other commands
 	 * that are already in the queue.
-	 *
-	 * NOTE: there is magic here about the way the queue is plugged if
-	 * we have no outstanding commands.
-	 * 
-	 * Although we *don't* plug the queue, we call the request
-	 * function.  The SCSI request function detects the blocked condition
-	 * and plugs the queue appropriately.
-         */
+	 */
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, cmd->request);
 	spin_unlock_irqrestore(q->queue_lock, flags);
@@ -1194,11 +1194,11 @@ int scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 	case BLKPREP_DEFER:
 		/*
 		 * If we defer, the blk_peek_request() returns NULL, but the
-		 * queue must be restarted, so we plug here if no returning
-		 * command will automatically do that.
+		 * queue must be restarted, so we schedule a callback to happen
+		 * shortly.
 		 */
 		if (sdev->device_busy == 0)
-			blk_plug_device(q);
+			blk_delay_queue(q, SCSI_QUEUE_DELAY);
 		break;
 	default:
 		req->cmd_flags |= REQ_DONTPREP;
@@ -1237,7 +1237,7 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
 				   sdev_printk(KERN_INFO, sdev,
 				   "unblocking device at zero depth\n"));
 		} else {
-			blk_plug_device(q);
+			blk_delay_queue(q, SCSI_QUEUE_DELAY);
 			return 0;
 		}
 	}
@@ -1467,7 +1467,7 @@ static void scsi_request_fn(struct request_queue *q)
 	 * the host is no longer able to accept any more requests.
 	 */
 	shost = sdev->host;
-	while (!blk_queue_plugged(q)) {
+	for (;;) {
 		int rtn;
 		/*
 		 * get next queueable request.  We do this early to make sure
@@ -1546,15 +1546,8 @@ static void scsi_request_fn(struct request_queue *q)
 		 */
 		rtn = scsi_dispatch_cmd(cmd);
 		spin_lock_irq(q->queue_lock);
-		if(rtn) {
-			/* we're refusing the command; because of
-			 * the way locks get dropped, we need to 
-			 * check here if plugging is required */
-			if(sdev->device_busy == 0)
-				blk_plug_device(q);
-
-			break;
-		}
+		if (rtn)
+			goto out_delay;
 	}
 
 	goto out;
@@ -1573,9 +1566,10 @@ static void scsi_request_fn(struct request_queue *q)
 	spin_lock_irq(q->queue_lock);
 	blk_requeue_request(q, req);
 	sdev->device_busy--;
-	if(sdev->device_busy == 0)
-		blk_plug_device(q);
- out:
+out_delay:
+	if (sdev->device_busy == 0)
+		blk_delay_queue(q, SCSI_QUEUE_DELAY);
+out:
 	/* must be careful here...if we trigger the ->remove() function
 	 * we cannot be holding the q lock */
 	spin_unlock_irq(q->queue_lock);
-- 
1.7.3.2.146.gca209

