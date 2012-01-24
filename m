Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab2AXKSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 05:18:49 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:60491 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755002Ab2AXKSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 05:18:47 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Viresh Kumar <viresh.kumar@st.com>,
        Michel Jaouen <michel.jaouen@stericsson.com>,
        Chris Blair <chris.blair@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] mfd/stmpe: Add support for no-interrupt config
Date: Tue, 24 Jan 2012 11:18:34 +0100
Message-ID: <1327400314-18030-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Blair <chris.blair@stericsson.com>

Adds support for boards which have an STMPE device without the
interrupt pin connected.

Cc: Viresh Kumar <viresh.kumar@st.com>
Signed-off-by: Chris Blair <chris.blair@stericsson.com>
Tested-by: Michel Jaouen <michel.jaouen@stericsson.com>
Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/stmpe.c       |   72 +++++++++++++++++++++++++--------------------
 include/linux/mfd/stmpe.h |    2 +
 2 files changed, 42 insertions(+), 32 deletions(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index e07947e..7c98e61 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -864,7 +864,7 @@ static int __devinit stmpe_chip_init(struct stmpe *stmpe)
 	unsigned int irq_trigger = stmpe->pdata->irq_trigger;
 	int autosleep_timeout = stmpe->pdata->autosleep_timeout;
 	struct stmpe_variant_info *variant = stmpe->variant;
-	u8 icr;
+	u8 icr = 0;
 	unsigned int id;
 	u8 data[2];
 	int ret;
@@ -887,31 +887,33 @@ static int __devinit stmpe_chip_init(struct stmpe *stmpe)
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
+	if (!stmpe->pdata->no_irq) {
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
@@ -988,7 +990,7 @@ int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
 	if (ci->init)
 		ci->init(stmpe);
 
-	if (pdata->irq_over_gpio) {
+	if (!pdata->no_irq && pdata->irq_over_gpio) {
 		ret = gpio_request_one(pdata->irq_gpio, GPIOF_DIR_IN, "stmpe");
 		if (ret) {
 			dev_err(stmpe->dev, "failed to request IRQ GPIO: %d\n",
@@ -1005,15 +1007,21 @@ int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
 	if (ret)
 		goto free_gpio;
 
-	ret = stmpe_irq_init(stmpe);
-	if (ret)
-		goto free_gpio;
+	if (pdata->no_irq) {
+		dev_info(stmpe->dev,
+			"board config says IRQs are not supported\n");
+	} else {
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
+			dev_err(stmpe->dev, "failed to request IRQ: %d\n", ret);
+			goto out_removeirq;
+		}
 	}
 
 	ret = stmpe_devices_init(stmpe);
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index ca1d7a3..c4b45fd 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -188,6 +188,7 @@ struct stmpe_ts_platform_data {
  * @irq_invert_polarity: IRQ line is connected with reversed polarity
  * @autosleep: bool to enable/disable stmpe autosleep
  * @autosleep_timeout: inactivity timeout in milliseconds for autosleep
+ * @no_irq: IRQs are not supported on this board
  * @irq_base: base IRQ number.  %STMPE_NR_IRQS irqs will be used, or
  *	      %STMPE_NR_INTERNAL_IRQS if the GPIO driver is not used.
  * @irq_over_gpio: true if gpio is used to get irq
@@ -200,6 +201,7 @@ struct stmpe_ts_platform_data {
 struct stmpe_platform_data {
 	int id;
 	unsigned int blocks;
+	bool no_irq;
 	int irq_base;
 	unsigned int irq_trigger;
 	bool irq_invert_polarity;
-- 
1.7.8

