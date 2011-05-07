Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab1EGVCr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 17:02:47 -0400
Received: from mail.df.lth.se ([194.47.250.12]:16231 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624Ab1EGVCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 17:02:45 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/3] mfd/ab8500-core: provide enumerators for chip cuts
Date: Sun,  8 May 2011 00:54:45 +0200
Message-Id: <1304808885-12690-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since functionality in MFD cells may need to be adjusted according to
chip revision, let's enumerate them and keep track of them.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-core.c  |   32 ++++++++++++++++----------------
 include/linux/mfd/abx500.h |    7 +++++++
 2 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 67d01c9..fc0c1af 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -254,8 +254,9 @@ static void ab8500_irq_sync_unlock(struct irq_data *data)
 		if (new == old)
 			continue;
 
-		/* Interrupt register 12 does'nt exist prior to version 0x20 */
-		if (ab8500_irq_regoffset[i] == 11 && ab8500->chip_id < 0x20)
+		/* Interrupt register 12 doesn't exist prior to version 2.0 */
+		if (ab8500_irq_regoffset[i] == 11 &&
+			ab8500->chip_id < AB8500_CUT2P0)
 			continue;
 
 		ab8500->oldmask[i] = new;
@@ -307,8 +308,8 @@ static irqreturn_t ab8500_irq(int irq, void *dev)
 		int status;
 		u8 value;
 
-		/* Interrupt register 12 does'nt exist prior to version 0x20 */
-		if (regoffset == 11 && ab8500->chip_id < 0x20)
+		/* Interrupt register 12 doesn't exist prior to version 2.0 */
+		if (regoffset == 11 && ab8500->chip_id < AB8500_CUT2P0)
 			continue;
 
 		status = get_register_interruptible(ab8500, AB8500_INTERRUPT,
@@ -724,17 +725,15 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 	if (ret < 0)
 		return ret;
 
-	/*
-	 * 0x0 - Early Drop
-	 * 0x10 - Cut 1.0
-	 * 0x11 - Cut 1.1
-	 * 0x20 - Cut 2.0
-	 * 0x30 - Cut 3.0
-	 */
-	if (value == 0x0 || value == 0x10 || value == 0x11 || value == 0x20 ||
-		value == 0x30) {
+	switch (value) {
+	case AB8500_CUTEARLY:
+	case AB8500_CUT1P0:
+	case AB8500_CUT1P1:
+	case AB8500_CUT2P0:
+	case AB8500_CUT3P0:
 		dev_info(ab8500->dev, "detected chip, revision: %#x\n", value);
-	} else {
+		break;
+	default:
 		dev_err(ab8500->dev, "unknown chip, revision: %#x\n", value);
 		return -EINVAL;
 	}
@@ -763,8 +762,9 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 
 	/* Clear and mask all interrupts */
 	for (i = 0; i < AB8500_NUM_IRQ_REGS; i++) {
-		/* Interrupt register 12 does'nt exist prior to version 0x20 */
-		if (ab8500_irq_regoffset[i] == 11 && ab8500->chip_id < 0x20)
+		/* Interrupt register 12 doesn't exist prior to version 2.0 */
+		if (ab8500_irq_regoffset[i] == 11 &&
+			ab8500->chip_id < AB8500_CUT2P0)
 			continue;
 
 		get_register_interruptible(ab8500, AB8500_INTERRUPT,
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 7d9b6ae..f45b55f 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -34,6 +34,13 @@
 #define AB5500_2_0	0x21
 #define AB5500_2_1	0x22
 
+/* AB8500 CIDs*/
+#define AB8500_CUTEARLY	0x00
+#define AB8500_CUT1P0	0x10
+#define AB8500_CUT1P1	0x11
+#define AB8500_CUT2P0	0x20
+#define AB8500_CUT3P0	0x30
+
 /*
  * AB3100, EVENTA1, A2 and A3 event register flags
  * these are catenated into a single 32-bit flag in the code
-- 
1.7.5

