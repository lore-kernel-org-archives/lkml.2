Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab0GAVwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:52:43 -0400
Received: from kroah.org ([198.145.64.141]:60863 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758950Ab0GAVNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:40 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:52 2010
Message-Id: <20100701174252.084362804@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@suse.de>
Subject: [067/200] [SCSI] libsas: fix deref before check in commit 70b25f890ce
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <James.Bottomley@suse.de>

commit 1b4d0d8ea7b3cbd107f345ab766416f9b38ce66a upstream.

commit 70b25f890ce9f0520c64075ce9225a5b020a513e
Author: Tejun Heo <tj@kernel.org>
Date:   Thu Apr 15 09:00:08 2010 +0900

    [SCSI] fix locking around blk_abort_request()

Introduced a reference before check problem, fix this by moving the
lock shorthand code to be right at the point of actual use.

Reported-by: Dan Carpenter <error27@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libsas/sas_ata.c       |    5 +++--
 drivers/scsi/libsas/sas_scsi_host.c |   16 ++++++++--------
 2 files changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -395,12 +395,13 @@ int sas_ata_init_host_and_port(struct do
 void sas_ata_task_abort(struct sas_task *task)
 {
 	struct ata_queued_cmd *qc = task->uldd_task;
-	struct request_queue *q = qc->scsicmd->device->request_queue;
 	struct completion *waiting;
-	unsigned long flags;
 
 	/* Bounce SCSI-initiated commands to the SCSI EH */
 	if (qc->scsicmd) {
+		struct request_queue *q = qc->scsicmd->device->request_queue;
+		unsigned long flags;
+
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_abort_request(qc->scsicmd->request);
 		spin_unlock_irqrestore(q->queue_lock, flags);
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1030,8 +1030,6 @@ int __sas_task_abort(struct sas_task *ta
 void sas_task_abort(struct sas_task *task)
 {
 	struct scsi_cmnd *sc = task->uldd_task;
-	struct request_queue *q = sc->device->request_queue;
-	unsigned long flags;
 
 	/* Escape for libsas internal commands */
 	if (!sc) {
@@ -1043,13 +1041,15 @@ void sas_task_abort(struct sas_task *tas
 
 	if (dev_is_sata(task->dev)) {
 		sas_ata_task_abort(task);
-		return;
-	}
+	} else {
+		struct request_queue *q = sc->device->request_queue;
+		unsigned long flags;
 
-	spin_lock_irqsave(q->queue_lock, flags);
-	blk_abort_request(sc->request);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-	scsi_schedule_eh(sc->device->host);
+		spin_lock_irqsave(q->queue_lock, flags);
+		blk_abort_request(sc->request);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+		scsi_schedule_eh(sc->device->host);
+	}
 }
 
 int sas_slave_alloc(struct scsi_device *scsi_dev)


