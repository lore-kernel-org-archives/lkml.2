Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2AZVRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:17:24 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:42546 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544Ab2AZVRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:17:23 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Viresh Kumar <viresh.kumar@st.com>,
        Chris Blair <chris.blair@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/2 v3] mfd/stmpe: Add support for no-interrupt config
Date: Thu, 26 Jan 2012 22:17:03 +0100
Message-ID: <1327612623-9135-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Blair <chris.blair@stericsson.com>

Adds support for boards which have an STMPE device without the
interrupt pin connected.

Acked-by: Viresh Kumar <viresh.kumar@st.com>
Signed-off-by: Chris Blair <chris.blair@stericsson.com>
Tested-by: Michel Jaouen <michel.jaouen@stericsson.com>
Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Corrects initialisation, error condition and driver removal cleanup
  for the no-irq configuration.
ChangeLog v2->v3:
- Removes the extra platform data member added to support no-irq
  mode and instead implements it using an invalid value for the
  existing irq member. This is propagated through to the sub-device
  drivers by having alternate versions of the cell data structures
  which do not have an irq resource defined.
---
 drivers/mfd/stmpe.c       |  134 ++++++++++++++++++++++++++++++++-------------
 include/linux/mfd/stmpe.h |    1 +
 2 files changed, 97 insertions(+), 38 deletions(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index e07947e..2dd8d49 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -298,6 +298,11 @@ static struct mfd_cell stmpe_gpio_cell = {
 	.num_resources	= ARRAY_SIZE(stmpe_gpio_resources),
 };
 
+static struct mfd_cell stmpe_gpio_cell_noirq = {
+	.name		= "stmpe-gpio",
+	/* gpio cell resources consist of an irq only so no resources here */
+};
+
 /*
  * Keypad (1601, 2401, 2403)
  */
@@ -346,6 +351,13 @@ static struct stmpe_variant_block stmpe801_blocks[] = {
 	},
 };
 
+static struct stmpe_variant_block stmpe801_blocks_noirq[] = {
+	{
+		.cell	= &stmpe_gpio_cell_noirq,
+		.block	= STMPE_BLOCK_GPIO,
+	},
+};
+
 static int stmpe801_enable(struct stmpe *stmpe, unsigned int blocks,
 			   bool enable)
 {
@@ -367,6 +379,17 @@ static struct stmpe_variant_info stmpe801 = {
 	.enable		= stmpe801_enable,
 };
 
+static struct stmpe_variant_info stmpe801_noirq = {
+	.name		= "stmpe801",
+	.id_val		= STMPE801_ID,
+	.id_mask	= 0xffff,
+	.num_gpios	= 8,
+	.regs		= stmpe801_regs,
+	.blocks		= stmpe801_blocks_noirq,
+	.num_blocks	= ARRAY_SIZE(stmpe801_blocks_noirq),
+	.enable		= stmpe801_enable,
+};
+
 /*
  * Touchscreen (STMPE811 or STMPE610)
  */
@@ -712,7 +735,7 @@ static struct stmpe_variant_info stmpe2403 = {
 	.enable_autosleep	= stmpe1601_autosleep, /* same as stmpe1601 */
 };
 
-static struct stmpe_variant_info *stmpe_variant_info[] = {
+static struct stmpe_variant_info *stmpe_variant_info[STMPE_NBR_PARTS] = {
 	[STMPE610]	= &stmpe610,
 	[STMPE801]	= &stmpe801,
 	[STMPE811]	= &stmpe811,
@@ -721,6 +744,16 @@ static struct stmpe_variant_info *stmpe_variant_info[] = {
 	[STMPE2403]	= &stmpe2403,
 };
 
+/*
+ * These devices can be connected in a 'no-irq' configuration - the irq pin
+ * is not used and the device cannot interrupt the CPU. Here we only list
+ * devices which support this configuration - the driver will fail probing
+ * for any devices not listed here which are configured in this way.
+ */
+static struct stmpe_variant_info *stmpe_noirq_variant_info[STMPE_NBR_PARTS] = {
+	[STMPE801]	= &stmpe801_noirq,
+};
+
 static irqreturn_t stmpe_irq(int irq, void *data)
 {
 	struct stmpe *stmpe = data;
@@ -864,7 +897,7 @@ static int __devinit stmpe_chip_init(struct stmpe *stmpe)
 	unsigned int irq_trigger = stmpe->pdata->irq_trigger;
 	int autosleep_timeout = stmpe->pdata->autosleep_timeout;
 	struct stmpe_variant_info *variant = stmpe->variant;
-	u8 icr;
+	u8 icr = 0;
 	unsigned int id;
 	u8 data[2];
 	int ret;
@@ -887,31 +920,33 @@ static int __devinit stmpe_chip_init(struct stmpe *stmpe)
 	if (ret)
 		return ret;
 
-	if (id == STMPE801_ID)
-		icr = STMPE801_REG_SYS_CTRL_INT_EN;
-	else
-		icr = STMPE_ICR_LSB_GIM;
-
-	/* STMPE801 doesn't support Edge interrupts */
-	if (id != STMPE801_ID) {
-		if (irq_trigger == IRQF_TRIGGER_FALLING ||
-				irq_trigger == IRQF_TRIGGER_RISING)
-			icr |= STMPE_ICR_LSB_EDGE;
-	}
-
-	if (irq_trigger == IRQF_TRIGGER_RISING ||
-			irq_trigger == IRQF_TRIGGER_HIGH) {
+	if (stmpe->irq >= 0) {
 		if (id == STMPE801_ID)
-			icr |= STMPE801_REG_SYS_CTRL_INT_HI;
+			icr = STMPE801_REG_SYS_CTRL_INT_EN;
 		else
-			icr |= STMPE_ICR_LSB_HIGH;
-	}
+			icr = STMPE_ICR_LSB_GIM;
 
-	if (stmpe->pdata->irq_invert_polarity) {
-		if (id == STMPE801_ID)
-			icr ^= STMPE801_REG_SYS_CTRL_INT_HI;
-		else
-			icr ^= STMPE_ICR_LSB_HIGH;
+		/* STMPE801 doesn't support Edge interrupts */
+		if (id != STMPE801_ID) {
+			if (irq_trigger == IRQF_TRIGGER_FALLING ||
+					irq_trigger == IRQF_TRIGGER_RISING)
+				icr |= STMPE_ICR_LSB_EDGE;
+		}
+
+		if (irq_trigger == IRQF_TRIGGER_RISING ||
+				irq_trigger == IRQF_TRIGGER_HIGH) {
+			if (id == STMPE801_ID)
+				icr |= STMPE801_REG_SYS_CTRL_INT_HI;
+			else
+				icr |= STMPE_ICR_LSB_HIGH;
+		}
+
+		if (stmpe->pdata->irq_invert_polarity) {
+			if (id == STMPE801_ID)
+				icr ^= STMPE801_REG_SYS_CTRL_INT_HI;
+			else
+				icr ^= STMPE_ICR_LSB_HIGH;
+		}
 	}
 
 	if (stmpe->pdata->autosleep) {
@@ -1001,19 +1036,38 @@ int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
 		stmpe->irq = ci->irq;
 	}
 
+	if (stmpe->irq < 0) {
+		/* use alternate variant info for no-irq mode, if supported */
+		dev_info(stmpe->dev,
+			"%s configured in no-irq mode by platform data\n",
+			stmpe->variant->name);
+		if (!stmpe_noirq_variant_info[stmpe->partnum]) {
+			dev_err(stmpe->dev,
+				"%s does not support no-irq mode!\n",
+				stmpe->variant->name);
+			ret = -ENODEV;
+			goto free_gpio;
+		}
+		stmpe->variant = stmpe_noirq_variant_info[stmpe->partnum];
+	}
+
 	ret = stmpe_chip_init(stmpe);
 	if (ret)
 		goto free_gpio;
 
-	ret = stmpe_irq_init(stmpe);
-	if (ret)
-		goto free_gpio;
+	if (stmpe->irq >= 0) {
+		ret = stmpe_irq_init(stmpe);
+		if (ret)
+			goto free_gpio;
 
-	ret = request_threaded_irq(stmpe->irq, NULL, stmpe_irq,
-			pdata->irq_trigger | IRQF_ONESHOT, "stmpe", stmpe);
-	if (ret) {
-		dev_err(stmpe->dev, "failed to request IRQ: %d\n", ret);
-		goto out_removeirq;
+		ret = request_threaded_irq(stmpe->irq, NULL, stmpe_irq,
+				pdata->irq_trigger | IRQF_ONESHOT,
+				"stmpe", stmpe);
+		if (ret) {
+			dev_err(stmpe->dev, "failed to request IRQ: %d\n",
+					ret);
+			goto out_removeirq;
+		}
 	}
 
 	ret = stmpe_devices_init(stmpe);
@@ -1026,9 +1080,11 @@ int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
 
 out_removedevs:
 	mfd_remove_devices(stmpe->dev);
-	free_irq(stmpe->irq, stmpe);
+	if (stmpe->irq >= 0)
+		free_irq(stmpe->irq, stmpe);
 out_removeirq:
-	stmpe_irq_remove(stmpe);
+	if (stmpe->irq >= 0)
+		stmpe_irq_remove(stmpe);
 free_gpio:
 	if (pdata->irq_over_gpio)
 		gpio_free(pdata->irq_gpio);
@@ -1041,8 +1097,10 @@ int stmpe_remove(struct stmpe *stmpe)
 {
 	mfd_remove_devices(stmpe->dev);
 
-	free_irq(stmpe->irq, stmpe);
-	stmpe_irq_remove(stmpe);
+	if (stmpe->irq >= 0) {
+		free_irq(stmpe->irq, stmpe);
+		stmpe_irq_remove(stmpe);
+	}
 
 	if (stmpe->pdata->irq_over_gpio)
 		gpio_free(stmpe->pdata->irq_gpio);
@@ -1057,7 +1115,7 @@ static int stmpe_suspend(struct device *dev)
 {
 	struct stmpe *stmpe = dev_get_drvdata(dev);
 
-	if (device_may_wakeup(dev))
+	if (stmpe->irq >= 0 && device_may_wakeup(dev))
 		enable_irq_wake(stmpe->irq);
 
 	return 0;
@@ -1067,7 +1125,7 @@ static int stmpe_resume(struct device *dev)
 {
 	struct stmpe *stmpe = dev_get_drvdata(dev);
 
-	if (device_may_wakeup(dev))
+	if (stmpe->irq >= 0 && device_may_wakeup(dev))
 		disable_irq_wake(stmpe->irq);
 
 	return 0;
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index ca1d7a3..a1c6aa7 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -26,6 +26,7 @@ enum stmpe_partnum {
 	STMPE1601,
 	STMPE2401,
 	STMPE2403,
+	STMPE_NBR_PARTS
 };
 
 /*
-- 
1.7.8

