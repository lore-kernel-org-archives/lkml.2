Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1ANFqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 00:46:11 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:32965 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab1ANFqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 00:46:05 -0500
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Rene Sapiens <rene.sapiens@ti.com>, devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] staging: tidspbridge: replace mbox callback with notifier_call
Date: Thu, 13 Jan 2011 23:34:53 -0600
Message-Id: <1294983293-10177-3-git-send-email-omar.ramirez@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294983293-10177-1-git-send-email-omar.ramirez@ti.com>
References: <1294983293-10177-1-git-send-email-omar.ramirez@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lately, mailbox callbacks have been replaced by notifier block
call chains, this needs to be changed in the users of mailbox,
otherwise compilation will break due to missing parameters.

Reported-by: Hari Kanigeri <h-kanigeri2@ti.com>
Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 drivers/staging/tidspbridge/core/tiomap3430.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index d6f333e..7652c06 100644
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
@@ -553,7 +557,7 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 		 * Enable Mailbox events and also drain any pending
 		 * stale messages.
 		 */
-		dev_context->mbox = omap_mbox_get("dsp");
+		dev_context->mbox = omap_mbox_get("dsp", &dsp_mbox_notifier);
 		if (IS_ERR(dev_context->mbox)) {
 			dev_context->mbox = NULL;
 			pr_err("%s: Failed to get dsp mailbox handle\n",
@@ -563,8 +567,6 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 
 	}
 	if (!status) {
-		dev_context->mbox->rxq->callback = (int (*)(void *))io_mbox_msg;
-
 /*PM_IVA2GRPSEL_PER = 0xC0;*/
 		temp = readl(resources->dw_per_pm_base + 0xA8);
 		temp = (temp & 0xFFFFFF30) | 0xC0;
@@ -685,7 +687,7 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
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

