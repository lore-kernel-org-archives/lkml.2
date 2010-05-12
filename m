Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454Ab0ELWyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 18:54:16 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:38974 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab0ELWyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 18:54:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=JUNGUwspNnJ1+7CoO4qjbq+1aS/G8+kXM17SLM3moZxW36NuxblGxVTB/3Ae0tsXsT
         Nf84SfALKynFf0Un9LlJCmtGAkdbWy1By1wAgOuGaJVqAdV8tMs/QO4FNQ+nnwFHs2wg
         6uJpP/P4U6xsfVSn2iWGXIpRnau0jnXUADBao=
Date: Thu, 13 May 2010 00:53:41 +0200
From: Dan Carpenter <error27@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Tejun Heo <tj@kernel.org>, Vasu Dev <vasu.dev@intel.com>,
       Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch] libsas: potential null dereference
Message-ID: <20100512225341.GA5695@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	Tejun Heo <tj@kernel.org>, Vasu Dev <vasu.dev@intel.com>,
	Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "sc" variable can potentially be null here, so we have to initialize
"q" later.  This was introduced in: 70b25f890 "[SCSI] fix locking around
blk_abort_request()"

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
I appologize if I sent this already.  I was having trouble with my email 
earlier today and I don't see this in my gmail outbox.

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 8228350..96dc7d0 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1030,7 +1030,7 @@ int __sas_task_abort(struct sas_task *task)
 void sas_task_abort(struct sas_task *task)
 {
 	struct scsi_cmnd *sc = task->uldd_task;
-	struct request_queue *q = sc->device->request_queue;
+	struct request_queue *q;
 	unsigned long flags;
 
 	/* Escape for libsas internal commands */
@@ -1046,6 +1046,7 @@ void sas_task_abort(struct sas_task *task)
 		return;
 	}
 
+	q = sc->device->request_queue;
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_abort_request(sc->request);
 	spin_unlock_irqrestore(q->queue_lock, flags);

