Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab2IYPad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:30:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39458 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931Ab2IYPa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:30:29 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org
Subject: [PATCH v2 2/3] scsi: create an all-zero filter for scanners
Date: Tue, 25 Sep 2012 17:30:08 +0200
Message-Id: <1348587009-22400-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1348587009-22400-1-git-send-email-pbonzini@redhat.com>
References: <1348587009-22400-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using /dev/sg for scanners is blocked from unprivileged users.  Reimplement
this using customizable command filters, so that the sysfs knobs will work
in this case too.

Cc: linux-scsi@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v1->v2: OOM check [Alan Cox]
		use GFP_ATOMIC, not GFP_KERNEL

 drivers/scsi/scsi_scan.c |    8 +++++++-
 drivers/scsi/sg.c        |    3 ---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 56a9379..81b1579 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -773,13 +773,19 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	}
 
 	switch (sdev->type) {
+	case TYPE_SCANNER:
+		sdev->request_queue->cmd_filter =
+			kzalloc(sizeof(struct blk_cmd_filter), GFP_ATOMIC);
+		if (sdev->request_queue->cmd_filter == NULL)
+			return SCSI_SCAN_NO_RESPONSE;
+		/* fallthrough */
+
 	case TYPE_RBC:
 	case TYPE_TAPE:
 	case TYPE_DISK:
 	case TYPE_PRINTER:
 	case TYPE_MOD:
 	case TYPE_PROCESSOR:
-	case TYPE_SCANNER:
 	case TYPE_MEDIUM_CHANGER:
 	case TYPE_ENCLOSURE:
 	case TYPE_COMM:
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 2ba7c82..c7474f5 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -219,9 +219,6 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 	struct sg_fd *sfp = filp->private_data;
 	struct request_queue *q = sfp->parentdp->device->request_queue;
 
-	if (sfp->parentdp->device->type == TYPE_SCANNER)
-		return 0;
-
 	return blk_verify_command(q->cmd_filter,
 				  cmd, filp->f_mode & FMODE_WRITE);
 }
-- 
1.7.1



