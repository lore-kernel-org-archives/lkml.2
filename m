Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab0EJX0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:26:36 -0400
Received: from kroah.org ([198.145.64.141]:33445 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932505Ab0EJWxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:53:05 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:27 2010
Message-Id: <20100510223327.488909085@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:33:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@suse.de>
Subject: [112/117] SCSI: fix locking around blk_abort_request()
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 70b25f890ce9f0520c64075ce9225a5b020a513e upstream.

blk_abort_request() expects queue lock to be held by the caller.
Grab it before calling the function.

Lack of this synchronization led to infinite loop on corrupt
q->timeout_list.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libsas/sas_ata.c       |    4 ++++
 drivers/scsi/libsas/sas_scsi_host.c |    4 ++++
 2 files changed, 8 insertions(+)

--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -394,11 +394,15 @@ int sas_ata_init_host_and_port(struct do
 void sas_ata_task_abort(struct sas_task *task)
 {
 	struct ata_queued_cmd *qc = task->uldd_task;
+	struct request_queue *q = qc->scsicmd->device->request_queue;
 	struct completion *waiting;
+	unsigned long flags;
 
 	/* Bounce SCSI-initiated commands to the SCSI EH */
 	if (qc->scsicmd) {
+		spin_lock_irqsave(q->queue_lock, flags);
 		blk_abort_request(qc->scsicmd->request);
+		spin_unlock_irqrestore(q->queue_lock, flags);
 		scsi_schedule_eh(qc->scsicmd->device->host);
 		return;
 	}
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1029,6 +1029,8 @@ int __sas_task_abort(struct sas_task *ta
 void sas_task_abort(struct sas_task *task)
 {
 	struct scsi_cmnd *sc = task->uldd_task;
+	struct request_queue *q = sc->device->request_queue;
+	unsigned long flags;
 
 	/* Escape for libsas internal commands */
 	if (!sc) {
@@ -1043,7 +1045,9 @@ void sas_task_abort(struct sas_task *tas
 		return;
 	}
 
+	spin_lock_irqsave(q->queue_lock, flags);
 	blk_abort_request(sc->request);
+	spin_unlock_irqrestore(q->queue_lock, flags);
 	scsi_schedule_eh(sc->device->host);
 }
 


