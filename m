Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab2BTUm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 15:42:56 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:49628 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753654Ab2BTUm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 15:42:28 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Maxime Coquelin <maxime.coquelin@stericsson.com>,
        Alex Macro <alex.macro@stericsson.com>,
        Michel Jaouen <michel.jaouen@stericsson.com>
Subject: [PATCH 3/4 v2] mfd/ab8500: parametrize IRQ masks and registers
Date: Mon, 20 Feb 2012 21:42:17 +0100
Message-ID: <1329770537-9565-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This makes the AB8500 state struct contain the IRQ mask and
register offsets previously hard-coded so as to make room for
more AB8500 variants.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Maxime Coquelin <maxime.coquelin@stericsson.com>
Signed-off-by: Alex Macro <alex.macro@stericsson.com>
Signed-off-by: Michel Jaouen <michel.jaouen@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-core.c         |   50 +++++++++++++++++++++++++++---------
 include/linux/mfd/abx500/ab8500.h |    9 +++++-
 2 files changed, 44 insertions(+), 15 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 3547eee..73907ad 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -97,11 +97,13 @@
 
 /*
  * Map interrupt numbers to the LATCH and MASK register offsets, Interrupt
- * numbers are indexed into this array with (num / 8).
+ * numbers are indexed into this array with (num / 8). The interupts are
+ * defined in linux/mfd/ab8500.h
  *
  * This is one off from the register names, i.e. AB8500_IT_MASK1_REG is at
  * offset 0.
  */
+/* AB8500 support */
 static const int ab8500_irq_regoffset[AB8500_NUM_IRQ_REGS] = {
 	0, 1, 2, 3, 4, 6, 7, 8, 9, 11, 18, 19, 20, 21,
 };
@@ -256,7 +258,7 @@ static void ab8500_irq_sync_unlock(struct irq_data *data)
 	struct ab8500 *ab8500 = irq_data_get_irq_chip_data(data);
 	int i;
 
-	for (i = 0; i < AB8500_NUM_IRQ_REGS; i++) {
+	for (i = 0; i < ab8500->mask_size; i++) {
 		u8 old = ab8500->oldmask[i];
 		u8 new = ab8500->mask[i];
 		int reg;
@@ -274,7 +276,7 @@ static void ab8500_irq_sync_unlock(struct irq_data *data)
 
 		ab8500->oldmask[i] = new;
 
-		reg = AB8500_IT_MASK1_REG + ab8500_irq_regoffset[i];
+		reg = AB8500_IT_MASK1_REG + ab8500->irq_reg_offset[i];
 		set_register_interruptible(ab8500, AB8500_INTERRUPT, reg, new);
 	}
 
@@ -317,8 +319,8 @@ static irqreturn_t ab8500_irq(int irq, void *dev)
 
 	dev_vdbg(ab8500->dev, "interrupt\n");
 
-	for (i = 0; i < AB8500_NUM_IRQ_REGS; i++) {
-		int regoffset = ab8500_irq_regoffset[i];
+	for (i = 0; i < ab8500->mask_size; i++) {
+		int regoffset = ab8500->irq_reg_offset[i];
 		int status;
 		u8 value;
 
@@ -350,8 +352,11 @@ static int ab8500_irq_init(struct ab8500 *ab8500)
 {
 	int base = ab8500->irq_base;
 	int irq;
+	int num_irqs;
 
-	for (irq = base; irq < base + AB8500_NR_IRQS; irq++) {
+	num_irqs = AB8500_NR_IRQS;
+
+	for (irq = base; irq < base + num_irqs; irq++) {
 		irq_set_chip_data(irq, ab8500);
 		irq_set_chip_and_handler(irq, &ab8500_irq_chip,
 					 handle_simple_irq);
@@ -370,8 +375,11 @@ static void ab8500_irq_remove(struct ab8500 *ab8500)
 {
 	int base = ab8500->irq_base;
 	int irq;
+	int num_irqs;
+
+	num_irqs = AB8500_NR_IRQS;
 
-	for (irq = base; irq < base + AB8500_NR_IRQS; irq++) {
+	for (irq = base; irq < base + num_irqs; irq++) {
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, 0);
 #endif
@@ -907,6 +915,16 @@ int __devinit ab8500_init(struct ab8500 *ab8500, enum ab8500_version version)
 			ab8500->chip_id >> 4,
 			ab8500->chip_id & 0x0F);
 
+	ab8500->mask_size = AB8500_NUM_IRQ_REGS;
+	ab8500->irq_reg_offset = ab8500_irq_regoffset;
+	ab8500->mask = kzalloc(ab8500->mask_size, GFP_KERNEL);
+	if (!ab8500->mask)
+		return -ENOMEM;
+	ab8500->oldmask = kzalloc(ab8500->mask_size, GFP_KERNEL);
+	if (!ab8500->oldmask) {
+		ret = -ENOMEM;
+		goto out_freemask;
+	}
 	/*
 	 * ab8500 has switched off due to (SWITCH_OFF_STATUS):
 	 * 0x01 Swoff bit programming
@@ -929,7 +947,7 @@ int __devinit ab8500_init(struct ab8500 *ab8500, enum ab8500_version version)
 		plat->init(ab8500);
 
 	/* Clear and mask all interrupts */
-	for (i = 0; i < AB8500_NUM_IRQ_REGS; i++) {
+	for (i = 0; i < ab8500->mask_size; i++) {
 		/*
 		 * Interrupt register 12 doesn't exist prior to AB8500 version
 		 * 2.0
@@ -939,23 +957,23 @@ int __devinit ab8500_init(struct ab8500 *ab8500, enum ab8500_version version)
 			continue;
 
 		get_register_interruptible(ab8500, AB8500_INTERRUPT,
-			AB8500_IT_LATCH1_REG + ab8500_irq_regoffset[i],
+			AB8500_IT_LATCH1_REG + ab8500->irq_reg_offset[i],
 			&value);
 		set_register_interruptible(ab8500, AB8500_INTERRUPT,
-			AB8500_IT_MASK1_REG + ab8500_irq_regoffset[i], 0xff);
+			AB8500_IT_MASK1_REG + ab8500->irq_reg_offset[i], 0xff);
 	}
 
 	ret = abx500_register_ops(ab8500->dev, &ab8500_ops);
 	if (ret)
-		return ret;
+		goto out_freeoldmask;
 
-	for (i = 0; i < AB8500_NUM_IRQ_REGS; i++)
+	for (i = 0; i < ab8500->mask_size; i++)
 		ab8500->mask[i] = ab8500->oldmask[i] = 0xff;
 
 	if (ab8500->irq_base) {
 		ret = ab8500_irq_init(ab8500);
 		if (ret)
-			return ret;
+			goto out_freeoldmask;
 
 		ret = request_threaded_irq(ab8500->irq, NULL, ab8500_irq,
 					   IRQF_ONESHOT | IRQF_NO_SUSPEND,
@@ -982,6 +1000,10 @@ out_freeirq:
 out_removeirq:
 	if (ab8500->irq_base)
 		ab8500_irq_remove(ab8500);
+out_freeoldmask:
+	kfree(ab8500->oldmask);
+out_freemask:
+	kfree(ab8500->mask);
 
 	return ret;
 }
@@ -994,6 +1016,8 @@ int __devexit ab8500_exit(struct ab8500 *ab8500)
 		free_irq(ab8500->irq, ab8500);
 		ab8500_irq_remove(ab8500);
 	}
+	kfree(ab8500->oldmask);
+	kfree(ab8500->mask);
 
 	return 0;
 }
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 7989258..55eabe8 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -175,6 +175,9 @@ enum ab8500_version {
  * @tx_buf: tx buf for SPI
  * @mask: cache of IRQ regs for bus lock
  * @oldmask: cache of previous IRQ regs for bus lock
+ * @mask_size: Actual number of valid entries in mask[], oldmask[] and
+ * irq_reg_offset
+ * @irq_reg_offset: Array of offsets into IRQ registers
  */
 struct ab8500 {
 	struct device	*dev;
@@ -192,8 +195,10 @@ struct ab8500 {
 	unsigned long	tx_buf[4];
 	unsigned long	rx_buf[4];
 
-	u8 mask[AB8500_NUM_IRQ_REGS];
-	u8 oldmask[AB8500_NUM_IRQ_REGS];
+	u8 *mask;
+	u8 *oldmask;
+	int mask_size;
+	const int *irq_reg_offset;
 };
 
 struct regulator_reg_init;
-- 
1.7.8

