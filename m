Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162239Ab2GLW4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:56:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162126Ab2GLWoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:44:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Praveen Murali <pmurali@logicube.com>,
        Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 147/187] SCSI: libsas: fix taskfile corruption in sas_ata_qc_fill_rtf
Date: Thu, 12 Jul 2012 15:35:03 -0700
Message-Id: <20120712191536.033985218@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 6ef1b512f4e6f936d89aa20be3d97a7ec7c290ac upstream.

fill_result_tf() grabs the taskfile flags from the originating qc which
sas_ata_qc_fill_rtf() promptly overwrites.  The presence of an
ata_taskfile in the sata_device makes it tempting to just copy the full
contents in sas_ata_qc_fill_rtf().  However, libata really only wants
the fis contents and expects the other portions of the taskfile to not
be touched by ->qc_fill_rtf.  To that end store a fis buffer in the
sata_device and use ata_tf_from_fis() like every other ->qc_fill_rtf()
implementation.

Reported-by: Praveen Murali <pmurali@logicube.com>
Tested-by: Praveen Murali <pmurali@logicube.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/aic94xx/aic94xx_task.c |    2 +-
 drivers/scsi/libsas/sas_ata.c       |   12 ++++++------
 include/scsi/libsas.h               |    6 ++++--
 3 files changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -201,7 +201,7 @@ static void asd_get_response_tasklet(str
 
 		if (SAS_STATUS_BUF_SIZE >= sizeof(*resp)) {
 			resp->frame_len = le16_to_cpu(*(__le16 *)(r+6));
-			memcpy(&resp->ending_fis[0], r+16, 24);
+			memcpy(&resp->ending_fis[0], r+16, ATA_RESP_FIS_SIZE);
 			ts->buf_valid_size = sizeof(*resp);
 		}
 	}
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -139,12 +139,12 @@ static void sas_ata_task_done(struct sas
 	if (stat->stat == SAS_PROTO_RESPONSE || stat->stat == SAM_STAT_GOOD ||
 	    ((stat->stat == SAM_STAT_CHECK_CONDITION &&
 	      dev->sata_dev.command_set == ATAPI_COMMAND_SET))) {
-		ata_tf_from_fis(resp->ending_fis, &dev->sata_dev.tf);
+		memcpy(dev->sata_dev.fis, resp->ending_fis, ATA_RESP_FIS_SIZE);
 
 		if (!link->sactive) {
-			qc->err_mask |= ac_err_mask(dev->sata_dev.tf.command);
+			qc->err_mask |= ac_err_mask(dev->sata_dev.fis[2]);
 		} else {
-			link->eh_info.err_mask |= ac_err_mask(dev->sata_dev.tf.command);
+			link->eh_info.err_mask |= ac_err_mask(dev->sata_dev.fis[2]);
 			if (unlikely(link->eh_info.err_mask))
 				qc->flags |= ATA_QCFLAG_FAILED;
 		}
@@ -161,8 +161,8 @@ static void sas_ata_task_done(struct sas
 				qc->flags |= ATA_QCFLAG_FAILED;
 			}
 
-			dev->sata_dev.tf.feature = 0x04; /* status err */
-			dev->sata_dev.tf.command = ATA_ERR;
+			dev->sata_dev.fis[3] = 0x04; /* status err */
+			dev->sata_dev.fis[2] = ATA_ERR;
 		}
 	}
 
@@ -269,7 +269,7 @@ static bool sas_ata_qc_fill_rtf(struct a
 {
 	struct domain_device *dev = qc->ap->private_data;
 
-	memcpy(&qc->result_tf, &dev->sata_dev.tf, sizeof(qc->result_tf));
+	ata_tf_from_fis(dev->sata_dev.fis, &qc->result_tf);
 	return true;
 }
 
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -163,6 +163,8 @@ enum ata_command_set {
         ATAPI_COMMAND_SET = 1,
 };
 
+#define ATA_RESP_FIS_SIZE 24
+
 struct sata_device {
         enum   ata_command_set command_set;
         struct smp_resp        rps_resp; /* report_phy_sata_resp */
@@ -171,7 +173,7 @@ struct sata_device {
 
 	struct ata_port *ap;
 	struct ata_host ata_host;
-	struct ata_taskfile tf;
+	u8     fis[ATA_RESP_FIS_SIZE];
 };
 
 enum {
@@ -537,7 +539,7 @@ enum exec_status {
  */
 struct ata_task_resp {
 	u16  frame_len;
-	u8   ending_fis[24];	  /* dev to host or data-in */
+	u8   ending_fis[ATA_RESP_FIS_SIZE];	  /* dev to host or data-in */
 };
 
 #define SAS_STATUS_BUF_SIZE 96


