Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab1FGKtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:49:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38874 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750906Ab1FGKtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:49:46 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Fix WM8994 IRQ register cache restore on resume
Date: Tue,  7 Jun 2011 11:49:42 +0100
Message-Id: <1307443782-14809-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the byte swap was factored out into the per-register I/O functions
the register restore for the IRQ mask cache (which we use and store in
CPU native format for the interrupt handler) was not updated to do a byte
swap when it uses the bulk I/O. Fix this by writing the cache out one
register at a time.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 77babcf..09e6c3e 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -316,7 +316,7 @@ static int wm8994_suspend(struct device *dev)
 static int wm8994_resume(struct device *dev)
 {
 	struct wm8994 *wm8994 = dev_get_drvdata(dev);
-	int ret;
+	int ret, i;
 
 	/* We may have lied to the PM core about suspending */
 	if (!wm8994->suspended)
@@ -329,10 +329,16 @@ static int wm8994_resume(struct device *dev)
 		return ret;
 	}
 
-	ret = wm8994_write(wm8994, WM8994_INTERRUPT_STATUS_1_MASK,
-			   WM8994_NUM_IRQ_REGS * 2, &wm8994->irq_masks_cur);
-	if (ret < 0)
-		dev_err(dev, "Failed to restore interrupt masks: %d\n", ret);
+	/* Write register at a time as we use the cache on the CPU so store
+	 * it in native endian.
+	 */
+	for (i = 0; i < ARRAY_SIZE(wm8994->irq_masks_cur); i++) {
+		ret = wm8994_reg_write(wm8994, WM8994_INTERRUPT_STATUS_1_MASK
+				       + i, wm8994->irq_masks_cur[i]);
+		if (ret < 0)
+			dev_err(dev, "Failed to restore interrupt masks: %d\n",
+				ret);
+	}
 
 	ret = wm8994_write(wm8994, WM8994_LDO_1, WM8994_NUM_LDO_REGS * 2,
 			   &wm8994->ldo_regs);
-- 
1.7.5.3

