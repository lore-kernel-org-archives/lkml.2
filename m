Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab0LSV3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 16:29:12 -0500
Received: from nm11-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.196]:31197 "HELO
	nm11-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932479Ab0LSV3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 16:29:08 -0500
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Dec 2010 16:29:08 EST
X-Yahoo-Newman-Id: 353952.9554.bm@omp1040.mail.ac4.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: cddUdfYVM1lsUT3MCL4SQXneSzXKpKZKPrAXlJ1cn.2_xQ3
 0zdcKAdWgYKJMBOErhViD7xU75Jif4J2QiBgDfFAxnayRfU2M6HDU5dbqoGb
 1bIigubxIFAi1DyvlebG.p3VG7uGemwgXvZ8Wf79cyep5G44ogq1tz7mNeYK
 xsVsPEky19Q3grLFwNZkgvZHhRiCLLQTK1BMmoD4xJa62esXRnkJZoWQageo
 uzvetul0IYdx39n0cA22ua11DDb1yyjYZdkID08M8ybwv5nSOZ5PTV.n3TA5
 MZu26FJJWZUn7QMmOSD8IMr_YhOiL6Xd6Wa1E.cJow22btwKOIY8O6pH63hU
 98r4EmN5cGu2GpGi2M0SJMawylCpD
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
Subject: [PATCH 08/12] qla4xxx: Convert to host_lock less w/ interrupts disabled externally
Date: Sun, 19 Dec 2010 13:22:03 -0800
Message-Id: <1292793727-31957-9-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts qla4xxx to run in host_lock less mode with the new
IRQ_DISABLE_SCSI_QCMD() that disables interrupts while calling ->queuecommand()
dispatch.  It also drops the legacy host_lock unlock optimization.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla4xxx/ql4_os.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 0d48fb4..d21eba7 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -450,7 +450,7 @@ void qla4xxx_srb_compl(struct kref *ref)
 }
 
 /**
- * qla4xxx_queuecommand - scsi layer issues scsi command to driver.
+ * qla4xxx_queuecommand_irq_disable - scsi layer issues scsi command to driver.
  * @cmd: Pointer to Linux's SCSI command structure
  * @done_fn: Function that the driver calls to notify the SCSI mid-layer
  *	that the command has been processed.
@@ -463,7 +463,7 @@ void qla4xxx_srb_compl(struct kref *ref)
  * completion handling).   Unfortunely, it sometimes calls the scheduler
  * in interrupt context which is a big NO! NO!.
  **/
-static int qla4xxx_queuecommand_lck(struct scsi_cmnd *cmd,
+static int qla4xxx_queuecommand_irq_disable(struct scsi_cmnd *cmd,
 				void (*done)(struct scsi_cmnd *))
 {
 	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
@@ -508,8 +508,6 @@ static int qla4xxx_queuecommand_lck(struct scsi_cmnd *cmd,
 	    test_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags))
 		goto qc_host_busy;
 
-	spin_unlock_irq(ha->host->host_lock);
-
 	srb = qla4xxx_get_new_srb(ha, ddb_entry, cmd, done);
 	if (!srb)
 		goto qc_host_busy_lock;
@@ -518,7 +516,6 @@ static int qla4xxx_queuecommand_lck(struct scsi_cmnd *cmd,
 	if (rval != QLA_SUCCESS)
 		goto qc_host_busy_free_sp;
 
-	spin_lock_irq(ha->host->host_lock);
 	return 0;
 
 qc_host_busy_free_sp:
@@ -526,7 +523,6 @@ qc_host_busy_free_sp:
 	mempool_free(srb, ha->srb_mempool);
 
 qc_host_busy_lock:
-	spin_lock_irq(ha->host->host_lock);
 
 qc_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
@@ -537,7 +533,7 @@ qc_fail_command:
 	return 0;
 }
 
-static DEF_SCSI_QCMD(qla4xxx_queuecommand)
+static IRQ_DISABLE_SCSI_QCMD(qla4xxx_queuecommand)
 
 /**
  * qla4xxx_mem_free - frees memory allocated to adapter
-- 
1.7.3.4

