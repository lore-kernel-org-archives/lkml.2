Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161701Ab1FAIMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:12:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161626Ab1FAIMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:12:45 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:36 2011
Message-Id: <20110601080335.890268207@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:09 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        James Bottomley <jbottomley@parallels.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [073/146] [SCSI] target: Fix interrupt context bug with stats_lock and
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------
 core_tmr_alloc_req

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 53ab6709b4d35b1924240854d794482fd7d33d4a upstream.

This patch fixes two bugs wrt to the interrupt context usage of target
core with HW target mode drivers.  It first converts the usage of struct
se_device->stats_lock in transport_get_lun_for_cmd() and core_tmr_lun_reset()
to properly use spin_lock_irq() to address an BUG with CONFIG_LOCKDEP_SUPPORT=y
enabled.

This patch also adds a 'in_interrupt()' check to allow GFP_ATOMIC usage from
core_tmr_alloc_req() to fix a 'sleeping in interrupt context' BUG with HW
target fabrics that require this logic to function.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: James Bottomley <jbottomley@parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/target_core_device.c |    4 ++--
 drivers/target/target_core_tmr.c    |    7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -151,13 +151,13 @@ out:
 
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


