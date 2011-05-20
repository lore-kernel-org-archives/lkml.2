Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab1ETDTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:19:33 -0400
Received: from nm9.access.bullet.mail.mud.yahoo.com ([66.94.237.210]:27803
	"HELO nm9.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757300Ab1ETDTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:19:30 -0400
X-Yahoo-Newman-Id: 304232.38124.bm@omp1011.access.mail.mud.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: etasDLQVM1mhPSy9B.Q2MxOMLmcopkPwkuQw.mJEcDUj8uD
 bEFL0HF96XbSI2vAMU_NDxGCSXE2t07m3FiWMOBGazFiAEJz67zBUS3IG7hW
 QUpMnjnHie7784sWuiGERlEUBLz2CGJYdj.KTAxWby0ruJOpgzZtexzSEFHR
 wYBHuvpPAbELI0WF7B2cKZjag3KJlOZb7T8oNPJnK2xt0MThx45DKJ80WxNf
 A_B4FeCwZwWXPCkpkCe4mRCkQsF8J2Bbi2BoJejIzAR8m0FiRdv6WPZuGuVC
 pNVEnhfvzLuTLDory3g7_2uZHdYdMhkvIFjRmkz94IVbxJBLyz9XTyt96mdP
 kd7O_KOdgJRD5EFnEux09xchi
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Svec <martin.svec@zoner.cz>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 2/6] target: Fix interrupt context bug with stats_lock and core_tmr_alloc_req
Date: Thu, 19 May 2011 20:19:10 -0700
Message-Id: <1305861554-29960-3-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1305861554-29960-1-git-send-email-nab@linux-iscsi.org>
References: <1305861554-29960-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes two bugs wrt to the interrupt context usage of target
core with HW target mode drivers.  It first converts the usage of struct
se_device->stats_lock in transport_get_lun_for_cmd() and core_tmr_lun_reset()
to properly use spin_lock_irq() to address an BUG with CONFIG_LOCKDEP_SUPPORT=y
enabled.

This patch also adds a 'in_interrupt()' check to allow GFP_ATOMIC usage from
core_tmr_alloc_req() to fix a 'sleeping in interrupt context' BUG with HW
target fabrics that require this logic to function.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |    4 ++--
 drivers/target/target_core_tmr.c    |    7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index d25e208..fc10ed4 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -150,13 +150,13 @@ out:
 
 	{
 	struct se_device *dev = se_lun->lun_se_dev;
-	spin_lock(&dev->stats_lock);
+	spin_lock_irq(&dev->stats_lock);
 	dev->num_cmds++;
 	if (se_cmd->data_direction == DMA_TO_DEVICE)
 		dev->write_bytes += se_cmd->data_length;
 	else if (se_cmd->data_direction == DMA_FROM_DEVICE)
 		dev->read_bytes += se_cmd->data_length;
-	spin_unlock(&dev->stats_lock);
+	spin_unlock_irq(&dev->stats_lock);
 	}
 
 	/*
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 4a10983..59b8b9c 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -55,7 +55,8 @@ struct se_tmr_req *core_tmr_alloc_req(
 {
 	struct se_tmr_req *tmr;
 
-	tmr = kmem_cache_zalloc(se_tmr_req_cache, GFP_KERNEL);
+	tmr = kmem_cache_zalloc(se_tmr_req_cache, (in_interrupt()) ?
+					GFP_ATOMIC : GFP_KERNEL);
 	if (!(tmr)) {
 		printk(KERN_ERR "Unable to allocate struct se_tmr_req\n");
 		return ERR_PTR(-ENOMEM);
@@ -398,9 +399,9 @@ int core_tmr_lun_reset(
 		printk(KERN_INFO "LUN_RESET: SCSI-2 Released reservation\n");
 	}
 
-	spin_lock(&dev->stats_lock);
+	spin_lock_irq(&dev->stats_lock);
 	dev->num_resets++;
-	spin_unlock(&dev->stats_lock);
+	spin_unlock_irq(&dev->stats_lock);
 
 	DEBUG_LR("LUN_RESET: %s for [%s] Complete\n",
 			(preempt_and_abort_list) ? "Preempt" : "TMR",
-- 
1.7.5.1

