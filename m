Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab1AEXGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:06:49 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59230 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab1AEXGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:06:45 -0500
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Fernando Guzman Lugo <x0095840@ti.com>,
        Rene Sapiens <rene.sapiens@ti.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Hari Kanigeri <h-kanigeri2@ti.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Subject: [PATCH] staging: tidspbridge: replace mbox callback with notifier_call
Date: Wed,  5 Jan 2011 16:55:28 -0600
Message-Id: <1294268128-8220-1-git-send-email-omar.ramirez@ti.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lately, mailbox callbacks have been replaced by notifier block
call chains, this needs to be changed in the users of mailbox,
otherwise compilation will break due to missing parameters.

Reported-by: Hari Kanigeri <h-kanigeri2@ti.com>
Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
---

To be pushed after mailbox dependencies.

 drivers/staging/tidspbridge/core/tiomap3430.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index cacd30e..28bdce0 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -223,6 +223,10 @@ static struct bridge_drv_interface drv_interface_fxns = {
 	bridge_msg_set_queue_id,
 };
 
+static struct notifier_block dsp_mbox_notifier = {
+	.notifier_call = io_mbox_msg,
+};
+
 static inline void flush_all(struct bridge_dev_context *dev_context)
 {
 	if (dev_context->dw_brd_state == BRD_DSP_HIBERNATION ||
@@ -551,7 +555,7 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 		 * Enable Mailbox events and also drain any pending
 		 * stale messages.
 		 */
-		dev_context->mbox = omap_mbox_get("dsp");
+		dev_context->mbox = omap_mbox_get("dsp", &dsp_mbox_notifier);
 		if (IS_ERR(dev_context->mbox)) {
 			dev_context->mbox = NULL;
 			pr_err("%s: Failed to get dsp mailbox handle\n",
@@ -561,8 +565,6 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 
 	}
 	if (!status) {
-		dev_context->mbox->rxq->callback = (int (*)(void *))io_mbox_msg;
-
 /*PM_IVA2GRPSEL_PER = 0xC0;*/
 		temp = readl(resources->dw_per_pm_base + 0xA8);
 		temp = (temp & 0xFFFFFF30) | 0xC0;
@@ -683,7 +685,7 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
 	/* Disable the mailbox interrupts */
 	if (dev_context->mbox) {
 		omap_mbox_disable_irq(dev_context->mbox, IRQ_RX);
-		omap_mbox_put(dev_context->mbox);
+		omap_mbox_put(dev_context->mbox, &dsp_mbox_notifier);
 		dev_context->mbox = NULL;
 	}
 	/* Reset IVA2 clocks*/
-- 
1.7.1

