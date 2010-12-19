Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab0LSVW7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 16:22:59 -0500
Received: from nm9.bullet.mail.ac4.yahoo.com ([98.139.52.206]:24344 "HELO
	nm9.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757293Ab0LSVW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 16:22:57 -0500
X-Yahoo-Newman-Id: 614186.61616.bm@omp1025.mail.ac4.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: PMD2xgoVM1l_MIUTW84XCN_U2hD6rE6VJDTd_Hdbg7ViDgL
 AfGvlMYHXbo5MOaTbo_CWYR0NIEbU.afl8X2ZQGgSVVv4Dvr84s8T1WmNgmI
 nSq2TQ3fdyhQhptaYszM2kaJVvnAGppe0vGC13MNPcTWG7EK_EZ1YT.BEQ43
 XrVKIod426v3o5XYbCEegBmCHNbw3FInJWomZR44p_ARVWat.nHrAk0ODaRS
 EigcHAn26OtYKt_MxmOsARChp5.FG7Fo9lGN_X6X7vSHFQOGLBhRBSeRRQnn
 DqrB5anTQzic32uqfOhCqCc7hWzdcLFJcOUeiGjoVuH65ZO2s78zd74l28sZ
 lrssudRiCBDD5z8bqFuTT1Nin317_AEUGPY.APFctbOYefeqksQ0dvpExJwn
 PoWZmUzG4yTXzgpXUVIAAMpoAGQkhIHOrqkWGDuc7r2s.0.a3h1cZlzis4A-
 -
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Ravi Anand <ravi.anand@qlogic.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        adam radford <aradford@gmail.com>,
        Kashyap Desai <Kashyap.Desai@lsi.com>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 09/12] scsi_debug: Convert to host_lock less
Date: Sun, 19 Dec 2010 13:22:04 -0800
Message-Id: <1292793727-31957-10-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts scsi_debug to run in host_lock less mode with interrupts
enabled, as we don't have a underly HW reason to use IRQ_DISABLE_SCSI_QCMD().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/scsi_debug.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c499eb3..71cd1fa 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3538,7 +3538,7 @@ static void sdebug_remove_adapter(void)
 }
 
 static
-int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
+int scsi_debug_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *SCpnt)
 {
 	unsigned char *cmd = (unsigned char *) SCpnt->cmnd;
 	int len, k;
@@ -3566,17 +3566,17 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 	if (target == SCpnt->device->host->hostt->this_id) {
 		printk(KERN_INFO "scsi_debug: initiator's id used as "
 		       "target!\n");
-		return schedule_resp(SCpnt, NULL, done,
+		return schedule_resp(SCpnt, NULL, SCpnt->scsi_done,
 				     DID_NO_CONNECT << 16, 0);
 	}
 
 	if ((SCpnt->device->lun >= scsi_debug_max_luns) &&
 	    (SCpnt->device->lun != SAM2_WLUN_REPORT_LUNS))
-		return schedule_resp(SCpnt, NULL, done,
+		return schedule_resp(SCpnt, NULL, SCpnt->scsi_done,
 				     DID_NO_CONNECT << 16, 0);
 	devip = devInfoReg(SCpnt->device);
 	if (NULL == devip)
-		return schedule_resp(SCpnt, NULL, done,
+		return schedule_resp(SCpnt, NULL, SCpnt->scsi_done,
 				     DID_NO_CONNECT << 16, 0);
 
 	if ((scsi_debug_every_nth != 0) &&
@@ -3610,8 +3610,8 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 			mk_sense_buffer(devip, ILLEGAL_REQUEST,
 					INVALID_OPCODE, 0);
 			errsts = check_condition_result;
-			return schedule_resp(SCpnt, devip, done, errsts,
-					     0);
+			return schedule_resp(SCpnt, devip, SCpnt->scsi_done,
+						errsts, 0);
 		}
 	}
 
@@ -3885,12 +3885,10 @@ xdwrite_read:
 		errsts = check_condition_result;
 		break;
 	}
-	return schedule_resp(SCpnt, devip, done, errsts,
+	return schedule_resp(SCpnt, devip, SCpnt->scsi_done, errsts,
 			     (delay_override ? 0 : scsi_debug_delay));
 }
 
-static DEF_SCSI_QCMD(scsi_debug_queuecommand)
-
 static struct scsi_host_template sdebug_driver_template = {
 	.proc_info =		scsi_debug_proc_info,
 	.proc_name =		sdebug_proc_name,
-- 
1.7.3.4

