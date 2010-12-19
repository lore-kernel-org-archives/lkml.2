Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab0LSVXE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 16:23:04 -0500
Received: from nm28-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.246]:46432 "HELO
	nm28-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757293Ab0LSVXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 16:23:02 -0500
X-Yahoo-Newman-Id: 808980.62681.bm@omp1055.mail.ac4.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: tmOvf_QVM1kTvmSLfSCLKDGJZgmDgUWcwRLt2Zw1UYT2ija
 5vKIoQFj6VexUbSrXPlrQkW0F1SFzZZ21t8ONWEYFyfYbagQ1fkLLAl8UtXM
 Ls0RoEUtadNceM6MfeRT.ZXPO8sITWs5J2OPKuaPdI3ODKYKJckyj33I4Z0b
 W0.3f1IwOETmakBgjj1gRBB4HSm7E8d1ZeGbGTLvw_n7TlbanfFPFh6iwf6z
 zNeQsVdne3.UqP3XzdQODoFBt7E1lfufwhfNVbh6NlL50lloVqIqnu.8jDzW
 DG7z2.rCfLHtzsncRi43KsOff9fyBD6wp89RhxOBDco6.y5LWollfVNzDKpP
 W_RbBlv2SXByPoBg55JIZtOQDcg0UP7Y5H16qRNgRd7LRbgNvs1x5jGdeWxw
 m2412e6qSMQ3V7fv9ogV.JSH.px0_7NtM7W44RCIgOO.6w2KzF297
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
Subject: [PATCH 10/12] megaraid_sas: Add smp_mb__after_atomic_*() for instance->fw_outstanding
Date: Sun, 19 Dec 2010 13:22:05 -0800
Message-Id: <1292793727-31957-11-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds four missing smp_mb__after_atomic_[inc,dec] barriers
for atomic_inc() and atomic_dec() usage with instance->fw_outstanding
within the main I/O dispatcher megasas_queue_command_lck(), completion
callback megasas_complete_cmd() and struct megasas_instance HW reset
queue drain in megasas_issue_pending_cmds_again().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/megaraid/megaraid_sas.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 7451bc0..31c5419 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -1398,6 +1398,7 @@ megasas_queue_command_lck(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd
 	 * Issue the command to the FW
 	 */
 	atomic_inc(&instance->fw_outstanding);
+	smp_mb__after_atomic_inc();
 
 	instance->instancet->fire_cmd(instance, cmd->frame_phys_addr,
 				cmd->frame_count-1, instance->reg_set);
@@ -2068,6 +2069,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		if (exception) {
 
 			atomic_dec(&instance->fw_outstanding);
+			smp_mb__after_atomic_dec();
 
 			scsi_dma_unmap(cmd->scmd);
 			cmd->scmd->scsi_done(cmd->scmd);
@@ -2116,6 +2118,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		}
 
 		atomic_dec(&instance->fw_outstanding);
+		smp_mb__after_atomic_dec();
 
 		scsi_dma_unmap(cmd->scmd);
 		cmd->scmd->scsi_done(cmd->scmd);
@@ -2219,6 +2222,7 @@ megasas_issue_pending_cmds_again(struct megasas_instance *instance)
 			cmd, cmd->scmd->cmnd[0], cmd->scmd->serial_number);
 
 			atomic_inc(&instance->fw_outstanding);
+			smp_mb__after_atomic_inc();
 			instance->instancet->fire_cmd(instance,
 					cmd->frame_phys_addr,
 					cmd->frame_count-1, instance->reg_set);
-- 
1.7.3.4

