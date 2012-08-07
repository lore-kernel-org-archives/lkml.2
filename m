Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab2HGWhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:37:23 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:50315 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866Ab2HGWhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:37:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Junichi Nomura <j-nomura@ce.jp.nec.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 013/109] SCSI: Fix device removal NULL pointer dereference
Date: Tue,  7 Aug 2012 15:34:32 -0700
Message-Id: <20120807222044.245484147@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 67bd94130015c507011af37858989b199c52e1de upstream.

Use blk_queue_dead() to test whether the queue is dead instead
of !sdev. Since scsi_prep_fn() may be invoked concurrently with
__scsi_remove_device(), keep the queuedata (sdev) pointer in
__scsi_remove_device(). This patch fixes a kernel oops that
can be triggered by USB device removal. See also
http://www.spinics.net/lists/linux-scsi/msg56254.html.

Other changes included in this patch:
- Swap the blk_cleanup_queue() and kfree() calls in
  scsi_host_dev_release() to make that code easier to grasp.
- Remove the queue dead check from scsi_run_queue() since the
  queue state can change anyway at any point in that function
  where the queue lock is not held.
- Remove the queue dead check from the start of scsi_request_fn()
  since it is redundant with the scsi_device_online() check.

Reported-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/hosts.c      |    7 ++++---
 drivers/scsi/scsi_lib.c   |   32 ++++----------------------------
 drivers/scsi/scsi_priv.h  |    1 -
 drivers/scsi/scsi_sysfs.c |    5 +----
 4 files changed, 9 insertions(+), 36 deletions(-)

--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -290,6 +290,7 @@ static void scsi_host_dev_release(struct
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
 	struct request_queue *q;
+	void *queuedata;
 
 	scsi_proc_hostdir_rm(shost->hostt);
 
@@ -299,9 +300,9 @@ static void scsi_host_dev_release(struct
 		destroy_workqueue(shost->work_q);
 	q = shost->uspace_req_q;
 	if (q) {
-		kfree(q->queuedata);
-		q->queuedata = NULL;
-		scsi_free_queue(q);
+		queuedata = q->queuedata;
+		blk_cleanup_queue(q);
+		kfree(queuedata);
 	}
 
 	scsi_destroy_command_freelist(shost);
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -406,10 +406,6 @@ static void scsi_run_queue(struct reques
 	LIST_HEAD(starved_list);
 	unsigned long flags;
 
-	/* if the device is dead, sdev will be NULL, so no queue to run */
-	if (!sdev)
-		return;
-
 	shost = sdev->host;
 	if (scsi_target(sdev)->single_lun)
 		scsi_single_lun_run(sdev);
@@ -1370,16 +1366,16 @@ static inline int scsi_host_queue_ready(
  * may be changed after request stacking drivers call the function,
  * regardless of taking lock or not.
  *
- * When scsi can't dispatch I/Os anymore and needs to kill I/Os
- * (e.g. !sdev), scsi needs to return 'not busy'.
- * Otherwise, request stacking drivers may hold requests forever.
+ * When scsi can't dispatch I/Os anymore and needs to kill I/Os scsi
+ * needs to return 'not busy'. Otherwise, request stacking drivers
+ * may hold requests forever.
  */
 static int scsi_lld_busy(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost;
 
-	if (!sdev)
+	if (blk_queue_dead(q))
 		return 0;
 
 	shost = sdev->host;
@@ -1490,12 +1486,6 @@ static void scsi_request_fn(struct reque
 	struct scsi_cmnd *cmd;
 	struct request *req;
 
-	if (!sdev) {
-		while ((req = blk_peek_request(q)) != NULL)
-			scsi_kill_request(req, q);
-		return;
-	}
-
 	if(!get_device(&sdev->sdev_gendev))
 		/* We must be tearing the block queue down already */
 		return;
@@ -1697,20 +1687,6 @@ struct request_queue *scsi_alloc_queue(s
 	return q;
 }
 
-void scsi_free_queue(struct request_queue *q)
-{
-	unsigned long flags;
-
-	WARN_ON(q->queuedata);
-
-	/* cause scsi_request_fn() to kill all non-finished requests */
-	spin_lock_irqsave(q->queue_lock, flags);
-	q->request_fn(q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
-	blk_cleanup_queue(q);
-}
-
 /*
  * Function:    scsi_block_requests()
  *
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -84,7 +84,6 @@ extern void scsi_next_command(struct scs
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
-extern void scsi_free_queue(struct request_queue *q);
 extern int scsi_init_queue(void);
 extern void scsi_exit_queue(void);
 struct request_queue;
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -971,11 +971,8 @@ void __scsi_remove_device(struct scsi_de
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
 
-	/* cause the request function to reject all I/O requests */
-	sdev->request_queue->queuedata = NULL;
-
 	/* Freeing the queue signals to block that we're done */
-	scsi_free_queue(sdev->request_queue);
+	blk_cleanup_queue(sdev->request_queue);
 	put_device(dev);
 }
 


