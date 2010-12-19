Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab0LSVWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 16:22:54 -0500
Received: from nm5.bullet.mail.ac4.yahoo.com ([98.139.52.202]:26247 "HELO
	nm5.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757295Ab0LSVWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 16:22:49 -0500
X-Yahoo-Newman-Id: 74159.45774.bm@omp1054.mail.ac4.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: fHTa2vwVM1kGc1iJ8UBPszN_8Eal3kwKed5sXkt97T3uOaD
 2BIeFSF8mXsoyKo13HaImznxN5scJ2_4An6LRTeuRiURc92OU3hERTKNA769
 QChhnkYKpo_QjvhoMXz0jnOC4h_wo004RuZidowsCbnPuz1wzSsQmlMymcoB
 mPM_LkidVqgqImK9cnhGkT313mXMbrJ1EQvr7GhsB2t0LesLaziTcp2Zb812
 93oH6TF5Y8hSYAChJ0yaTQfVDIujcXp2UCL_1Tc4Bv6jT.7xAyU18htpNXLb
 FjshaWt7VCnt_vxH_W3KcedvvkOCHJB9ZTCq95H2sFTI2.MEkPjcCDoouDrW
 i.VLypbhU829WB_5Yu5Cqs2j5G6O4
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
Subject: [PATCH 07/12] qla2xxx: Convert to host_lock less w/ interrupts disabled externally
Date: Sun, 19 Dec 2010 13:22:02 -0800
Message-Id: <1292793727-31957-8-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts qla2xxx to run in host_lock less mode with the new
IRQ_DISABLE_SCSI_QCMD() that disables interrupts while calling ->queuecommand()
dispatch.  It also drops the legacy host_lock unlock optimization.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_os.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2c0876c..c6cdfeb 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -534,7 +534,8 @@ qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
 }
 
 static int
-qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+qla2xxx_queuecommand_irq_disable(struct scsi_cmnd *cmd,
+				void (*done)(struct scsi_cmnd *))
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
@@ -544,7 +545,6 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *)
 	srb_t *sp;
 	int rval;
 
-	spin_unlock_irq(vha->host->host_lock);
 	if (ha->flags.eeh_busy) {
 		if (ha->flags.pci_channel_io_perm_failure)
 			cmd->result = DID_NO_CONNECT << 16;
@@ -585,8 +585,6 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *)
 	if (rval != QLA_SUCCESS)
 		goto qc24_host_busy_free_sp;
 
-	spin_lock_irq(vha->host->host_lock);
-
 	return 0;
 
 qc24_host_busy_free_sp:
@@ -594,21 +592,18 @@ qc24_host_busy_free_sp:
 	mempool_free(sp, ha->srb_mempool);
 
 qc24_host_busy_lock:
-	spin_lock_irq(vha->host->host_lock);
 	return SCSI_MLQUEUE_HOST_BUSY;
 
 qc24_target_busy:
-	spin_lock_irq(vha->host->host_lock);
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 qc24_fail_command:
-	spin_lock_irq(vha->host->host_lock);
 	done(cmd);
 
 	return 0;
 }
 
-static DEF_SCSI_QCMD(qla2xxx_queuecommand)
+static IRQ_DISABLE_SCSI_QCMD(qla2xxx_queuecommand)
 
 
 /*
-- 
1.7.3.4

