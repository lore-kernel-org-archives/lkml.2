Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab2HGWhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:37:00 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:58680 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360Ab2HGWgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:36:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Christie <michaelc@cs.wisc.edu>,
        Bart Van Assche <bvanassche@acm.org>, Tejun Heo <tj@kernel.org>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 014/109] SCSI: Avoid dangling pointer in scsi_requeue_command()
Date: Tue,  7 Aug 2012 15:34:33 -0700
Message-Id: <20120807222044.348659632@linuxfoundation.org>
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

---
 drivers/scsi/scsi_lib.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -479,15 +479,26 @@ void scsi_requeue_run_queue(struct work_
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


