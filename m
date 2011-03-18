Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab1CRMuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 08:50:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43543 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755678Ab1CRMuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 08:50:17 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Push byte swaps out of wm8994 bulk read path
Date: Fri, 18 Mar 2011 12:50:10 +0000
Message-Id: <1300452610-636-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For consistency with the write path push byte swaps of the WM8994 register
data out of the bulk read data path into the per-register APIs. The only
user of the bulk register read is the interrupt code which is updated to
do the swaps itself part of this patch.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |   10 +++++-----
 drivers/mfd/wm8994-irq.c  |    6 ++++--
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 3f5b7cc..e198d40 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -40,10 +40,8 @@ static int wm8994_read(struct wm8994 *wm8994, unsigned short reg,
 		return ret;
 
 	for (i = 0; i < bytes / 2; i++) {
-		buf[i] = be16_to_cpu(buf[i]);
-
 		dev_vdbg(wm8994->dev, "Read %04x from R%d(0x%x)\n",
-			 buf[i], reg + i, reg + i);
+			 be16_to_cpu(buf[i]), reg + i, reg + i);
 	}
 
 	return 0;
@@ -69,7 +67,7 @@ int wm8994_reg_read(struct wm8994 *wm8994, unsigned short reg)
 	if (ret < 0)
 		return ret;
 	else
-		return val;
+		return be16_to_cpu(val);
 }
 EXPORT_SYMBOL_GPL(wm8994_reg_read);
 
@@ -79,7 +77,7 @@ EXPORT_SYMBOL_GPL(wm8994_reg_read);
  * @wm8994: Device to read from
  * @reg: First register
  * @count: Number of registers
- * @buf: Buffer to fill.
+ * @buf: Buffer to fill.  The data will be returned big endian.
  */
 int wm8994_bulk_read(struct wm8994 *wm8994, unsigned short reg,
 		     int count, u16 *buf)
@@ -180,6 +178,8 @@ int wm8994_set_bits(struct wm8994 *wm8994, unsigned short reg,
 	if (ret < 0)
 		goto out;
 
+	r = be16_to_cpu(r);
+
 	r &= ~mask;
 	r |= val;
 
diff --git a/drivers/mfd/wm8994-irq.c b/drivers/mfd/wm8994-irq.c
index f5e439a..1e3bf4a 100644
--- a/drivers/mfd/wm8994-irq.c
+++ b/drivers/mfd/wm8994-irq.c
@@ -225,9 +225,11 @@ static irqreturn_t wm8994_irq_thread(int irq, void *data)
 		return IRQ_NONE;
 	}
 
-	/* Apply masking */
-	for (i = 0; i < WM8994_NUM_IRQ_REGS; i++)
+	/* Bit swap and apply masking */
+	for (i = 0; i < WM8994_NUM_IRQ_REGS; i++) {
+		status[i] = be16_to_cpu(status[i]);
 		status[i] &= ~wm8994->irq_masks_cur[i];
+	}
 
 	/* Report */
 	for (i = 0; i < ARRAY_SIZE(wm8994_irqs); i++) {
-- 
1.7.4.1

