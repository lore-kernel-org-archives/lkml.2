Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843Ab2BNOtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:49:19 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:35154 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760781Ab2BNOtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:49:18 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Danny Kukawka <dkukawka@suse.de>, Jeff Garzik <jgarzik@redhat.com>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] libsas: move SAM_STAT_CHECK_CONDITION out of switch
Date: Tue, 14 Feb 2012 15:49:07 +0100
Message-Id: <1329230947-27675-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329230958;3bfc84b7;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move SAM_STAT_CHECK_CONDITION out of switch to fix:

warning: case value ‘2’ not in enumerated type ‘enum exec_status’
  [-Wswitch]

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/scsi/libsas/sas_ata.c       |    3 +-
 drivers/scsi/libsas/sas_scsi_host.c |   91 ++++++++++++++++++-----------------
 2 files changed, 48 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index db9238f..4cbdb6e 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -43,6 +43,8 @@ static enum ata_completion_errors sas_to_ata_err(struct task_status_struct *ts)
 	/* transport error */
 	if (ts->resp == SAS_TASK_UNDELIVERED)
 		return AC_ERR_ATA_BUS;
+	if (ts->stat == SAM_STAT_CHECK_CONDITION)
+		return AC_ERR_DEV;
 
 	/* ts->resp == SAS_TASK_COMPLETE */
 	/* task delivered, what happened afterwards? */
@@ -77,7 +79,6 @@ static enum ata_completion_errors sas_to_ata_err(struct task_status_struct *ts)
 				    __func__, ts->stat);
 			return AC_ERR_OTHER;
 
-		case SAM_STAT_CHECK_CONDITION:
 		case SAS_ABORTED_TASK:
 			return AC_ERR_DEV;
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index b6e233d..559b37c 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -75,53 +75,54 @@ static void sas_scsi_task_done(struct sas_task *task)
 		hs = DID_NO_CONNECT;
 	} else { /* ts->resp == SAS_TASK_COMPLETE */
 		/* task delivered, what happened afterwards? */
-		switch (ts->stat) {
-		case SAS_DEV_NO_RESPONSE:
-		case SAS_INTERRUPTED:
-		case SAS_PHY_DOWN:
-		case SAS_NAK_R_ERR:
-		case SAS_OPEN_TO:
-			hs = DID_NO_CONNECT;
-			break;
-		case SAS_DATA_UNDERRUN:
-			scsi_set_resid(sc, ts->residual);
-			if (scsi_bufflen(sc) - scsi_get_resid(sc) < sc->underflow)
-				hs = DID_ERROR;
-			break;
-		case SAS_DATA_OVERRUN:
-			hs = DID_ERROR;
-			break;
-		case SAS_QUEUE_FULL:
-			hs = DID_SOFT_ERROR; /* retry */
-			break;
-		case SAS_DEVICE_UNKNOWN:
-			hs = DID_BAD_TARGET;
-			break;
-		case SAS_SG_ERR:
-			hs = DID_PARITY;
-			break;
-		case SAS_OPEN_REJECT:
-			if (ts->open_rej_reason == SAS_OREJ_RSVD_RETRY)
-				hs = DID_SOFT_ERROR; /* retry */
-			else
-				hs = DID_ERROR;
-			break;
-		case SAS_PROTO_RESPONSE:
-			SAS_DPRINTK("LLDD:%s sent SAS_PROTO_RESP for an SSP "
-				    "task; please report this\n",
-				    task->dev->port->ha->sas_ha_name);
-			break;
-		case SAS_ABORTED_TASK:
-			hs = DID_ABORT;
-			break;
-		case SAM_STAT_CHECK_CONDITION:
+		if (ts->stat == SAM_STAT_CHECK_CONDITION) {
 			memcpy(sc->sense_buffer, ts->buf,
-			       min(SCSI_SENSE_BUFFERSIZE, ts->buf_valid_size));
+				min(SCSI_SENSE_BUFFERSIZE, ts->buf_valid_size));
 			stat = SAM_STAT_CHECK_CONDITION;
-			break;
-		default:
-			stat = ts->stat;
-			break;
+		} else {
+			switch (ts->stat) {
+			case SAS_DEV_NO_RESPONSE:
+			case SAS_INTERRUPTED:
+			case SAS_PHY_DOWN:
+			case SAS_NAK_R_ERR:
+			case SAS_OPEN_TO:
+				hs = DID_NO_CONNECT;
+				break;
+			case SAS_DATA_UNDERRUN:
+				scsi_set_resid(sc, ts->residual);
+				if (scsi_bufflen(sc) - scsi_get_resid(sc) < sc->underflow)
+					hs = DID_ERROR;
+				break;
+			case SAS_DATA_OVERRUN:
+				hs = DID_ERROR;
+				break;
+			case SAS_QUEUE_FULL:
+				hs = DID_SOFT_ERROR; /* retry */
+				break;
+			case SAS_DEVICE_UNKNOWN:
+				hs = DID_BAD_TARGET;
+				break;
+			case SAS_SG_ERR:
+				hs = DID_PARITY;
+				break;
+			case SAS_OPEN_REJECT:
+				if (ts->open_rej_reason == SAS_OREJ_RSVD_RETRY)
+					hs = DID_SOFT_ERROR; /* retry */
+				else
+					hs = DID_ERROR;
+				break;
+			case SAS_PROTO_RESPONSE:
+				SAS_DPRINTK("LLDD:%s sent SAS_PROTO_RESP for "
+					    "an SSP task; please report this\n",
+					    task->dev->port->ha->sas_ha_name);
+				break;
+			case SAS_ABORTED_TASK:
+				hs = DID_ABORT;
+				break;
+			default:
+				stat = ts->stat;
+				break;
+			}
 		}
 	}
 	ASSIGN_SAS_TASK(sc, NULL);
-- 
1.7.7.3

