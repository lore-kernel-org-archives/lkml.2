Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab2HOUJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:09:58 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63049 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab2HOTwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Bart Van Assche <bvanassche@acm.org>,
        James Bottomley <JBottomley@parallels.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 121/165] [SCSI] Make scsi_free_queue() kill pending SCSI commands
Date: Wed, 15 Aug 2012 15:47:45 -0400
Message-ID: <1345060109-9187-122-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3308511c93e6ad0d3c58984ecd6e5e57f96b12c8 upstream.

Make sure that SCSI device removal via scsi_remove_host() does finish
all pending SCSI commands. Currently that's not the case and hence
removal of a SCSI host during I/O can cause a deadlock. See also
"blkdev_issue_discard() hangs forever if underlying storage device is
removed" (http://bugzilla.kernel.org/show_bug.cgi?id=40472). See also
http://lkml.org/lkml/2011/8/27/6.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/hosts.c    | 9 ++++++---
 drivers/scsi/scsi_lib.c | 9 +++++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 6660fa9..cdd904d 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -280,6 +280,7 @@ static void scsi_host_dev_release(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
+	struct request_queue *q;
 
 	scsi_proc_hostdir_rm(shost->hostt);
 
@@ -287,9 +288,11 @@ static void scsi_host_dev_release(struct device *dev)
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
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 725f3cd..9f240f4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1676,6 +1676,15 @@ struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 
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
 
-- 
1.7.12.rc2

