Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab1EKQFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:05:34 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45084 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab1EKQFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:05:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nLFKV4OeVqIA+yBzDU4pZExsPL1YLYI6FjcjvgeckA6jloK/gN5AlZSuIsG2j2tMIP
         TtWrT1FcGkFXPVZafyEe5KtJQLot9PZTTjAihHodz+2hBmLg/GejZ0hO3CCnHlVhV1gl
         NeXwKfOUmikpuPUjb39/iqoia6QpfJbF1Xv2I=
From: yxlraid@gmail.com
To: James.Bottomley@suse.de
Cc: jgarzik@redhat.com, sshtylyov@ru.mvista.com, maciej.trela@intel.com,
        tj@kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>
Subject: [PATCH 1/1] [SCSI] libsas: fix SATA NCQ error
Date: Sun,  8 May 2011 19:27:01 +0800
Message-Id: <1304854021-3768-1-git-send-email-yxlraid@gmail.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <libsas-fix-ncq-error>
References: <libsas-fix-ncq-error>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiangliang Yu <yuxiangl@marvell.com>

Current version of libsas can not handle SATA NCQ error.
This patch handle SATA NCQ error as AHCI do.

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
---
 drivers/scsi/libsas/sas_ata.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 31fc21f..e993014 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -99,19 +99,29 @@ static void sas_ata_task_done(struct sas_task *task)
 	struct sas_ha_struct *sas_ha;
 	enum ata_completion_errors ac;
 	unsigned long flags;
+	struct ata_link *link;
 
 	if (!qc)
 		goto qc_already_gone;
 
 	dev = qc->ap->private_data;
 	sas_ha = dev->port->ha;
+	link = &dev->sata_dev.ap->link;
 
 	spin_lock_irqsave(dev->sata_dev.ap->lock, flags);
 	if (stat->stat == SAS_PROTO_RESPONSE || stat->stat == SAM_STAT_GOOD ||
 	    ((stat->stat == SAM_STAT_CHECK_CONDITION &&
 	      dev->sata_dev.command_set == ATAPI_COMMAND_SET))) {
 		ata_tf_from_fis(resp->ending_fis, &dev->sata_dev.tf);
-		qc->err_mask |= ac_err_mask(dev->sata_dev.tf.command);
+
+		if (!link->sactive) {
+			qc->err_mask |= ac_err_mask(dev->sata_dev.tf.command);
+		} else {
+			link->eh_info.err_mask |= ac_err_mask(dev->sata_dev.tf.command);
+			if (unlikely(link->eh_info.err_mask))
+				qc->flags |= ATA_QCFLAG_FAILED;
+		}
+
 		dev->sata_dev.sstatus = resp->sstatus;
 		dev->sata_dev.serror = resp->serror;
 		dev->sata_dev.scontrol = resp->scontrol;
@@ -121,7 +131,13 @@ static void sas_ata_task_done(struct sas_task *task)
 			SAS_DPRINTK("%s: SAS error %x\n", __func__,
 				    stat->stat);
 			/* We saw a SAS error. Send a vague error. */
-			qc->err_mask = ac;
+			if (!link->sactive) {
+				qc->err_mask = ac;
+			} else {
+				link->eh_info.err_mask |= AC_ERR_DEV;
+				qc->flags |= ATA_QCFLAG_FAILED;
+			}
+
 			dev->sata_dev.tf.feature = 0x04; /* status err */
 			dev->sata_dev.tf.command = ATA_ERR;
 		}
-- 
1.7.5.1

