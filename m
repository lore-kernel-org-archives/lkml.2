Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab2JAXZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:25:01 -0400
Received: from 1wt.eu ([62.212.114.60]:35310 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932782Ab2JAXBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:11 -0400
Message-Id: <20121001225202.011837973@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:41 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
        James Bottomley <JBottomley@Parallels.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 104/180] SCSI: Avoid dangling pointer in scsi_requeue_command()
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/scsi/scsi_lib.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8df12522..e28f9b0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -482,15 +482,26 @@ static void scsi_run_queue(struct request_queue *q)
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
-- 
1.7.2.1.45.g54fbc



