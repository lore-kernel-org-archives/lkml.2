Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab1EGCzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 22:55:43 -0400
Received: from nm25.access.bullet.mail.mud.yahoo.com ([66.94.237.90]:36575
	"HELO nm25.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755247Ab1EGCzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 22:55:18 -0400
X-Yahoo-Newman-Id: 402218.68873.bm@omp1011.access.mail.mud.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: XrfOrt8VM1mq.CYkOtAjChVh2dLWoe4e2YRV9fmwBgE1NyQ
 dBGXw3RQCSt4Vz9dLM0yWGxjX9fn9d2j36r4XN2Rl0dwnE4wKB4m3HYvbvAN
 hdSG0ppUtUpGkUEmRiMFDDMOko5NIOn4Pl6j4grGjgkUdTYHIsrKagSxZaOM
 _NKbk7JIiyrwyOYd9L_3isFOQnptZkFqSKdjoSaiJj6klbvrxlDdresp7AfZ
 pDtMcEklhWHzkP8EXstGclEV42O5zZWyDFAyXDHvl_YS_y5_PVHDTdffAK9Y
 DwZVly5fYjYmatbpx8Q6corjlt8QEum.delnXk1uV0VRW8cSRHUjQkdkyGzJ
 ti3F_t0yaq7.k.1UMerGoPTpNyTo2dYVmiJ3o6sCBlSPbJBBbwcN6gnr_dGi
 pnU0avJ6Y6Xs8vtwJ3P2hHEkvesYJLF9gR41bDYy28YcecxPWHKOrVCo-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Kiran Patil <kiran.patil@intel.com>,
        "Robert W. Love" <robert.w.love@intel.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>, Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 2/3] target: Fix interrupt context bug with stats_lock and core_tmr_alloc_req
Date: Fri,  6 May 2011 19:54:57 -0700
Message-Id: <1304736898-10830-3-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1304736898-10830-1-git-send-email-nab@linux-iscsi.org>
References: <1304736898-10830-1-git-send-email-nab@linux-iscsi.org>
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

