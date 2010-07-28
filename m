Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab0G1Oue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:50:34 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35830 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab0G1Ou3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:50:29 -0400
From: Ernesto Ramos <ernesto@ti.com>
To: gregkh@suse.de
Cc: omar.ramirez@ti.com, ohad@wizery.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, fernando.lugo@ti.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, nm@ti.com,
        linux-omap@vger.kernel.org,
        Ernesto Ramos <ernesto@ernesto-desktop (none)>
Subject: [PATCH 4/4] staging:ti dspbridge: remove bridge_brd_delete function
Date: Wed, 28 Jul 2010 09:54:55 -0500
Message-Id: <1280328895-31375-5-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1280328895-31375-4-git-send-email-ernesto@ti.com>
References: <1280328895-31375-1-git-send-email-ernesto@ti.com>
 <1280328895-31375-2-git-send-email-ernesto@ti.com>
 <1280328895-31375-3-git-send-email-ernesto@ti.com>
 <1280328895-31375-4-git-send-email-ernesto@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ernesto Ramos <ernesto@ernesto-desktop.(none)>

Remove bridge_brd_delete() function since it is
doing the same that bridge_brd_stop().

Signed-off-by: Ernesto Ramos <ernesto@ernesto-desktop.(none)>
---
 drivers/staging/tidspbridge/core/tiomap3430.c |   57 +------------------------
 1 files changed, 1 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index e7584de..f914829 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -686,61 +686,6 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
 }
 
 /*
- *  ======== bridge_brd_delete ========
- *  purpose:
- *      Puts DSP in Low power mode
- *
- *  Preconditions :
- *  a) None
- */
-static int bridge_brd_delete(struct bridge_dev_context *dev_ctxt)
-{
-	int status = 0;
-	struct bridge_dev_context *dev_context = dev_ctxt;
-	struct pg_table_attrs *pt_attrs;
-	int clk_status;
-	struct dspbridge_platform_data *pdata =
-				omap_dspbridge_dev->dev.platform_data;
-
-	if (dev_context->dw_brd_state == BRD_STOPPED)
-		return status;
-
-	/* as per TRM, it is advised to first drive
-	 * the IVA2 to 'Standby' mode, before turning off the clocks.. This is
-	 * to ensure that there are no pending L3 or other transactons from
-	 * IVA2 */
-	status = sleep_dsp(dev_context, PWR_EMERGENCYDEEPSLEEP, NULL);
-	clk_status = dsp_clk_disable(DSP_CLK_IVA2);
-
-	/* Release the Ext Base virtual Address as the next DSP Program
-	 * may have a different load address */
-	if (dev_context->dw_dsp_ext_base_addr)
-		dev_context->dw_dsp_ext_base_addr = 0;
-
-	dev_context->dw_brd_state = BRD_STOPPED;	/* update board state */
-
-	/* This is a good place to clear the MMU page tables as well */
-	if (dev_context->pt_attrs) {
-		pt_attrs = dev_context->pt_attrs;
-		memset((u8 *) pt_attrs->l1_base_va, 0x00, pt_attrs->l1_size);
-		memset((u8 *) pt_attrs->l2_base_va, 0x00, pt_attrs->l2_size);
-		memset((u8 *) pt_attrs->pg_info, 0x00,
-		       (pt_attrs->l2_num_pages * sizeof(struct page_info)));
-	}
-	/* Disable the mail box interrupts */
-	if (dev_context->mbox) {
-		omap_mbox_disable_irq(dev_context->mbox, IRQ_RX);
-		omap_mbox_put(dev_context->mbox);
-		dev_context->mbox = NULL;
-	}
-	/* Reset IVA2 clocks*/
-	(*pdata->dsp_prm_write)(OMAP3430_RST1_IVA2_MASK | OMAP3430_RST2_IVA2_MASK |
-			OMAP3430_RST3_IVA2_MASK, OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
-
-	return status;
-}
-
-/*
  *  ======== bridge_brd_status ========
  *      Returns the board status.
  */
@@ -1023,7 +968,7 @@ static int bridge_dev_destroy(struct bridge_dev_context *dev_ctxt)
 		return -EFAULT;
 
 	/* first put the device to stop state */
-	bridge_brd_delete(dev_context);
+	bridge_brd_stop(dev_context);
 	if (dev_context->pt_attrs) {
 		pt_attrs = dev_context->pt_attrs;
 		kfree(pt_attrs->pg_info);
-- 
1.5.4.5

