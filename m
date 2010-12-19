Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab0LSVWd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 16:22:33 -0500
Received: from nm7-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.228]:29094 "HELO
	nm7-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757251Ab0LSVWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 16:22:31 -0500
X-Yahoo-Newman-Id: 303273.80993.bm@omp1029.mail.ac4.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: UP8gN0gVM1kOG7V3UkgPFD6UiUOG6VfTkrjLz9U9KPkJJrW
 9FQuWoHQTsyvn515DAfAkPXRmJuolLVeq1.j7DwDkxSk5APbchfz.uBpWOqS
 zThd8xi_pSqKt96.MbCSb2DYsjhZitB9Dxfa7uBtEBRH799zzb2ktC_OOE1n
 hjzpBEgt5pUn9LdNMowY6krT1TTckud1vcSgwrlfJYjp_9w2zLu7.3Xpdy4Q
 syFXi.q3Pa.nVd8ukUUwfdSs85TwocrJFghAeuz4sWTXemdLlyG2kWUYM4DD
 .szp6q8rjkgt4jbZnK3Y.htAzf4P2AHJHOpYZdtTQPicMlCIWWo1KcaOSgyG
 ESntqkbar_a9xTZ.lYPzk38ekfkLMSlyrgqKwcXEcGn35jUOHRkg029VzryZ
 lh6Qts_iZeiu05LK.AgvHTKiXGE_cfU_BR6Sr4uT8sZPjJQk-
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
Subject: [PATCH 03/12] libsas: Convert to host_lock less w/ interrupts disabled externally
Date: Sun, 19 Dec 2010 13:21:58 -0800
Message-Id: <1292793727-31957-4-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the libsas queuecommand to run in host_lock less mode
w/ the new IRQ_DISABLE_SCSI_QCMD() that disables interrupts while calling
->queuecommand() dispatch.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/libsas/sas_scsi_host.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 29251fa..011580f 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -185,24 +185,17 @@ int sas_queue_up(struct sas_task *task)
 /**
  * sas_queuecommand -- Enqueue a command for processing
  * @parameters: See SCSI Core documentation
- *
- * Note: XXX: Remove the host unlock/lock pair when SCSI Core can
- * call us without holding an IRQ spinlock...
  */
-static int sas_queuecommand_lck(struct scsi_cmnd *cmd,
+static int sas_queuecommand_irq_disable(struct scsi_cmnd *cmd,
 		     void (*scsi_done)(struct scsi_cmnd *))
-	__releases(host->host_lock)
 	__acquires(dev->sata_dev.ap->lock)
 	__releases(dev->sata_dev.ap->lock)
-	__acquires(host->host_lock)
 {
 	int res = 0;
 	struct domain_device *dev = cmd_to_domain_dev(cmd);
 	struct Scsi_Host *host = cmd->device->host;
 	struct sas_internal *i = to_sas_internal(host->transportt);
 
-	spin_unlock_irq(host->host_lock);
-
 	{
 		struct sas_ha_struct *sas_ha = dev->port->ha;
 		struct sas_task *task;
@@ -250,11 +243,10 @@ static int sas_queuecommand_lck(struct scsi_cmnd *cmd,
 		}
 	}
 out:
-	spin_lock_irq(host->host_lock);
 	return res;
 }
 
-DEF_SCSI_QCMD(sas_queuecommand)
+IRQ_DISABLE_SCSI_QCMD(sas_queuecommand)
 
 static void sas_eh_finish_cmd(struct scsi_cmnd *cmd)
 {
-- 
1.7.3.4

