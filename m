Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab1KWAdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:33:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182Ab1KWAdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:33:42 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:22:07 2011
Message-Id: <20111123002207.178759855@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:20:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bart Van Assche <bvanassche@acm.org>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [02/25] [SCSI] Make scsi_free_queue() kill pending SCSI commands
In-Reply-To: <20111123002222.GA2376@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1913
Lines: 64

From: Bart Van Assche <bvanassche@acm.org>

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

--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -275,6 +275,7 @@ static void scsi_host_dev_release(struct
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
+	struct request_queue *q;
 
 	scsi_proc_hostdir_rm(shost->hostt);
 
@@ -282,9 +283,11 @@ static void scsi_host_dev_release(struct
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
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1672,6 +1672,15 @@ struct request_queue *scsi_alloc_queue(s
 
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
 


