Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419Ab0ELW46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 18:56:58 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46991 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192Ab0ELW44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 18:56:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=a0GL/h1rhNufjj6ZmS/6KpHF/CoPQ/3uDLtG7d+L2ql2A8C2THiYUdtdVvigS44B25
         lWC7z6VfNHayhnGiIGHpjOsLca8CJ50iLFIN6S9jankt+DqcpCj1ssFGNjGLhC+O8ate
         DO6/U76+Qjq8K5v8+PWWu+/0WHEwUqeq9QvR8=
Date: Thu, 13 May 2010 00:56:29 +0200
From: Dan Carpenter <error27@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch] libsas: dereferencing variable before check
Message-ID: <20100512225629.GB5695@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "qc->scsicmd" could be null so I moved the dereference inside the
check.  This was introduced by 70b25f890: "[SCSI] fix locking around
blk_abort_request()" 

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 88f7446..98b1545 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -395,12 +395,13 @@ int sas_ata_init_host_and_port(struct domain_device *found_dev,
 void sas_ata_task_abort(struct sas_task *task)
 {
 	struct ata_queued_cmd *qc = task->uldd_task;
-	struct request_queue *q = qc->scsicmd->device->request_queue;
+	struct request_queue *q;
 	struct completion *waiting;
 	unsigned long flags;
 
 	/* Bounce SCSI-initiated commands to the SCSI EH */
 	if (qc->scsicmd) {
+		q = qc->scsicmd->device->request_queue;
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_abort_request(qc->scsicmd->request);
 		spin_unlock_irqrestore(q->queue_lock, flags);

