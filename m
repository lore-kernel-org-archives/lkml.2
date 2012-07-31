Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab2GaE74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:59:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48705 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755185Ab2GaEud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:33 -0400
Message-Id: <20120731044320.229453609@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:44:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 56/73] [SCSI] Avoid dangling pointer in scsi_requeue_command()
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 940f5d47e2f2e1fa00443921a0abf4822335b54d upstream.

When we call scsi_unprep_request() the command associated with the request
gets destroyed and therefore drops its reference on the device.  If this was
the only reference, the device may get released and we end up with a NULL
pointer deref when we call blk_requeue_request.

Reported-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Reviewed-by: Tejun Heo <tj@kernel.org>
[jejb: enhance commend and add commit log for stable]
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/scsi_lib.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4acf5c2..0e52ff0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -479,15 +479,26 @@ void scsi_requeue_run_queue(struct work_struct *work)
  */
 static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
 {
+	struct scsi_device *sdev = cmd->device;
 	struct request *req = cmd->request;
 	unsigned long flags;
 
+	/*
+	 * We need to hold a reference on the device to avoid the queue being
+	 * killed after the unlock and before scsi_run_queue is invoked which
+	 * may happen because scsi_unprep_request() puts the command which
+	 * releases its reference on the device.
+	 */
+	get_device(&sdev->sdev_gendev);
+
 	spin_lock_irqsave(q->queue_lock, flags);
 	scsi_unprep_request(req);
 	blk_requeue_request(q, req);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	scsi_run_queue(q);
+
+	put_device(&sdev->sdev_gendev);
 }
 
 void scsi_next_command(struct scsi_cmnd *cmd)


