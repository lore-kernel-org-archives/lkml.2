Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab2LNQWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:22:03 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62542 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274Ab2LNQUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:20:14 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Yang QU <yang.qu@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 17/21] gpio: ab8500: Add the action range for the internal pull up function on GPIO
Date: Fri, 14 Dec 2012 16:19:35 +0000
Message-Id: <1355501979-1157-18-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang QU <yang.qu@stericsson.com>

Only 4 GPIOs named GPIOx_VBAT have both internal pull up and pull
down capability on ab8540. Limit the action range for this function.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Yang QU <yang.qu@stericsson.com>
Reviewed-by: Per FORLIN <per.forlin@stericsson.com>
---
 drivers/gpio/gpio-ab8500.c             |   54 +++++++++++++++++---------------
 include/linux/mfd/abx500/ab8500-gpio.h |    6 ++--
 2 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index ff8df1f..b4f631a 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -23,10 +23,12 @@
 
 
 /*
- * The AB9540 GPIO support is an extended version of the
- * AB8500 GPIO support. The AB9540 supports an additional
- * (7th) register so that more GPIO may be configured and
- * used.
+ * The AB9540 and AB8540 GPIO support are extended versions
+ * of the AB8500 GPIO support.
+ * The AB9540 supports an additional (7th) register so that
+ * more GPIO may be configured and used.
+ * The AB8540 supports 4 new gpios (GPIOx_VBAT) that have
+ * internal pull-up and pull-down capabilities.
  */
 
 /*
@@ -636,46 +638,46 @@ int ab8500_config_pulldown(struct device *dev,
 }
 EXPORT_SYMBOL(ab8500_config_pulldown);
 
-/*
- * ab8540_config_pull_updown() only available for following GPIOs:
- * GPIO51(GPIO1_VBAT)
- * GPIO52(GPIO2_VBAT)
- * GPIO53(GPIO3_VBAT)
- * GPIO54(GPIO4_VBAT)
- */
 int ab8540_config_pull_updown(struct device *dev,
-				int gpio, enum ab8540_gpio_pull_updown reg)
+				int gpio, enum ab8540_gpio_pull_updown val)
 {
-	u8 offset =  gpio - AB8500_PIN_GPIO(51);
-	u8 pos = 2 * offset;
+	u8 pos;
 	int ret;
 
+	if ((gpio < AB8500_PIN_GPIO(51)) || (gpio > AB8500_PIN_GPIO(54))) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	pos = (gpio - AB8500_PIN_GPIO(51)) << 1;
+
 	ret = abx500_mask_and_set_register_interruptible(dev,
 			AB8500_MISC, AB8540_GPIO_PULL_UPDOWN_REG,
-			AB8540_GPIO_PULL_UPDOWN_MASK << pos, reg << pos);
+			AB8540_GPIO_PULL_UPDOWN_MASK << pos, val << pos);
+
+out:
 	if (ret < 0)
 		dev_err(dev, "%s failed (%d)\n", __func__, ret);
 	return ret;
 }
 EXPORT_SYMBOL(ab8540_config_pull_updown);
 
-/*
- * ab8540_gpio_config_vinsel() only available for following GPIOs:
- * GPIO51(GPIO1_VBAT)
- * GPIO52(GPIO2_VBAT)
- * GPIO53(GPIO3_VBAT)
- * GPIO54(GPIO4_VBAT)
- */
 int ab8540_gpio_config_vinsel(struct device *dev,
-				int gpio, enum ab8540_gpio_vinsel reg)
+				int gpio, enum ab8540_gpio_vinsel val)
 {
-	u8 offset =  gpio - AB8500_PIN_GPIO(51);
-	u8 pos = 2 * offset;
+	u8 pos;
 	int ret;
 
+	if ((gpio < AB8500_PIN_GPIO(51)) || (gpio > AB8500_PIN_GPIO(54))) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	ret = abx500_mask_and_set_register_interruptible(dev,
 			AB8500_MISC, AB8540_GPIO_VINSEL_REG,
-			AB8540_GPIO_VINSEL_MASK << pos, reg << pos);
+			AB8540_GPIO_VINSEL_MASK << pos, val << pos);
+
+out:
 	if (ret < 0)
 		dev_err(dev, "%s failed (%d)\n", __func__, ret);
 	return ret;
diff --git a/include/linux/mfd/abx500/ab8500-gpio.h b/include/linux/mfd/abx500/ab8500-gpio.h
index 20df07d..86ccb33 100644
--- a/include/linux/mfd/abx500/ab8500-gpio.h
+++ b/include/linux/mfd/abx500/ab8500-gpio.h
@@ -39,11 +39,13 @@ enum ab8540_gpio_vinsel {
 int ab8500_config_pulldown(struct device *dev,
 				int gpio, bool enable);
 
+/* Selects pull up/pull down for GPIOx_VBAT, x=1 to 4 */
 int ab8540_config_pull_updown(struct device *dev,
-				int gpio, enum ab8540_gpio_pull_updown reg);
+				int gpio, enum ab8540_gpio_pull_updown val);
 
+/* Selects voltage for GPIOx_VBAT, x=1 to 4 */
 int ab8540_gpio_config_vinsel(struct device *dev,
-				int gpio, enum ab8540_gpio_vinsel reg);
+				int gpio, enum ab8540_gpio_vinsel val);
 
 int ab8500_gpio_config_select(struct device *dev,
 				int gpio, bool gpio_select);
-- 
1.7.9.5

