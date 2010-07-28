Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0G1Ouv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:50:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42925 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab0G1Oua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:50:30 -0400
From: Ernesto Ramos <ernesto@ti.com>
To: gregkh@suse.de
Cc: omar.ramirez@ti.com, ohad@wizery.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, fernando.lugo@ti.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, nm@ti.com,
        linux-omap@vger.kernel.org, Ernesto Ramos <ernesto@ti.com>
Subject: [PATCH 1/4] staging:ti dspbridge: fix bridge_brd_stop so IVA2 is set OFF
Date: Wed, 28 Jul 2010 09:54:52 -0500
Message-Id: <1280328895-31375-2-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1280328895-31375-1-git-send-email-ernesto@ti.com>
References: <1280328895-31375-1-git-send-email-ernesto@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

right now, bridge_brd_stop is not changing the IVA2 power state
to OFF since PM_PWSTST_IVA2 is not 0 after calling this function.

Signed-off-by: Ernesto Ramos <ernesto@ti.com>
---
 drivers/staging/tidspbridge/core/tiomap3430.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 9673acb..77527bd 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -639,11 +639,11 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
 	dsp_pwr_state = (*pdata->dsp_prm_read)(OMAP3430_IVA2_MOD, OMAP2_PM_PWSTST) &
 					OMAP_POWERSTATEST_MASK;
 	if (dsp_pwr_state != PWRDM_POWER_OFF) {
+		(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2_MASK, 0,
+					OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
 		sm_interrupt_dsp(dev_context, MBX_PM_DSPIDLE);
 		mdelay(10);
 
-		clk_status = dsp_clk_disable(DSP_CLK_IVA2);
-
 		/* IVA2 is not in OFF state */
 		/* Set PM_PWSTCTRL_IVA2  to OFF */
 		(*pdata->dsp_prm_rmw_bits)(OMAP_POWERSTATEST_MASK,
@@ -651,8 +651,6 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
 		/* Set the SW supervised state transition for Sleep */
 		(*pdata->dsp_cm_write)(OMAP34XX_CLKSTCTRL_FORCE_SLEEP,
 					OMAP3430_IVA2_MOD, OMAP2_CM_CLKSTCTRL);
-	} else {
-		clk_status = dsp_clk_disable(DSP_CLK_IVA2);
 	}
 	udelay(10);
 	/* Release the Ext Base virtual Address as the next DSP Program
@@ -682,6 +680,8 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
 	(*pdata->dsp_prm_write)(OMAP3430_RST1_IVA2_MASK | OMAP3430_RST2_IVA2_MASK |
 			OMAP3430_RST3_IVA2_MASK, OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
 
+	clk_status = dsp_clk_disable(DSP_CLK_IVA2);
+
 	return status;
 }
 
-- 
1.5.4.5

