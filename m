Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab2BEW1W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:27:22 -0500
Received: from 1wt.eu ([62.212.114.60]:62152 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921Ab2BEW1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:27:19 -0500
Message-Id: <20120205220951.802368623@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:44 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
        James Bottomley <JBottomley@Parallels.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 55/91] Make scsi_free_queue() kill pending SCSI commands
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 3308511c93e6ad0d3c58984ecd6e5e57f96b12c8 upstream.

Make sure that SCSI device removal via scsi_remove_host() does finish
all pending SCSI commands. Currently that's not the case and hence
removal of a SCSI host during I/O can cause a deadlock. See also
"blkdev_issue_discard() hangs forever if underlying storage device is
removed" (http://bugzilla.kernel.org/show_bug.cgi?id=40472). See also
http://lkml.org/lkml/2011/8/27/6.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/hosts.c    |    9 ++++++---
 drivers/scsi/scsi_lib.c |    9 +++++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

Index: longterm-2.6.27/drivers/scsi/hosts.c
===================================================================
--- longterm-2.6.27.orig/drivers/scsi/hosts.c	2012-02-05 22:34:33.360914737 +0100
+++ longterm-2.6.27/drivers/scsi/hosts.c	2012-02-05 22:34:42.692915134 +0100
@@ -269,14 +269,17 @@
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
+	struct request_queue *q;
 
 	if (shost->ehandler)
 		kthread_stop(shost->ehandler);
 	if (shost->work_q)
 		destroy_workqueue(shost->work_q);
-	if (shost->uspace_req_q) {
-		kfree(shost->uspace_req_q->queuedata);
-		scsi_free_queue(shost->uspace_req_q);
+	q = shost->uspace_req_q;
+	if (q) {
+		kfree(q->queuedata);
+		q->queuedata = NULL;
+		scsi_free_queue(q);
 	}
 
 	scsi_destroy_command_freelist(shost);
Index: longterm-2.6.27/drivers/scsi/scsi_lib.c
===================================================================
--- longterm-2.6.27.orig/drivers/scsi/scsi_lib.c	2012-02-05 22:34:33.364914767 +0100
+++ longterm-2.6.27/drivers/scsi/scsi_lib.c	2012-02-05 22:34:42.697916475 +0100
@@ -1680,6 +1680,15 @@
 
 void scsi_free_queue(struct request_queue *q)
 {
+	unsigned long flags;
+
+	WARN_ON(q->queuedata);
+
+	/* cause scsi_request_fn() to kill all non-finished requests */
+	spin_lock_irqsave(q->queue_lock, flags);
+	q->request_fn(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
 	blk_cleanup_queue(q);
 }
 


