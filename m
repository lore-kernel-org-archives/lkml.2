Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab2LNQUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:20:15 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:51870 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab2LNQUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:20:12 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org,
        Alexandre Torgue <alexandre.torgue@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, Yang QU <yang.qu@stericsson.com>
Subject: [PATCH 16/21] gpio: ab8500: Add internal pull up on GPIO of ab8540
Date: Fri, 14 Dec 2012 16:19:34 +0000
Message-Id: <1355501979-1157-17-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@stericsson.com>

Add 4 GPIOs named GPIOx_VBAT which have both internal pull up
and pull down capability on ab8540. We can also select different
voltage domains for GPIOx_VBAT.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Yang QU <yang.qu@stericsson.com>
Reviewed-by: Alexandre TORGUE <alexandre.torgue@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
Tested-by: Alexandre TORGUE <alexandre.torgue@stericsson.com>
Tested-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/gpio/gpio-ab8500.c             |   64 ++++++++++++++++++++++++++++
 include/linux/mfd/abx500/ab8500-gpio.h |   71 +++++++++++---------------------
 2 files changed, 87 insertions(+), 48 deletions(-)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index 757ae34..ff8df1f 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -72,6 +72,8 @@
 #define AB8500_GPIO_IN5_REG	0x44
 #define AB8500_GPIO_IN6_REG	0x45
 #define AB9540_GPIO_IN7_REG	0x46
+#define AB8540_GPIO_VINSEL_REG	0x47
+#define AB8540_GPIO_PULL_UPDOWN_REG	0x48
 #define AB8500_GPIO_ALTFUN_REG	0x50
 #define AB8500_ALTFUN_REG_INDEX	6
 #define AB9540_ALTFUN_REG_INDEX	7
@@ -80,6 +82,8 @@
 #define AB8505_NUM_GPIO		53
 #define AB8540_NUM_GPIO		56
 #define AB8500_NUM_VIR_GPIO_IRQ	16
+#define AB8540_GPIO_PULL_UPDOWN_MASK	0x03
+#define AB8540_GPIO_VINSEL_MASK	0x03
 
 enum ab8500_gpio_action {
 	NONE,
@@ -552,6 +556,20 @@ static int __devinit ab8500_gpio_probe(struct platform_device *pdev)
 		if (ret < 0)
 			goto out_free;
 	}
+
+	if (is_ab8540(parent)) {
+		ret = abx500_set_register_interruptible(ab8500_gpio->dev,
+				AB8500_MISC, AB8540_GPIO_VINSEL_REG,
+				pdata->config_vinsel);
+		if (ret < 0)
+			goto out_free;
+		ret = abx500_set_register_interruptible(ab8500_gpio->dev,
+				AB8500_MISC, AB8540_GPIO_PULL_UPDOWN_REG,
+				pdata->config_pullupdown);
+		if (ret < 0)
+			goto out_free;
+	}
+
 	ret = abx500_set_register_interruptible(ab8500_gpio->dev, AB8500_MISC,
 				AB8500_GPIO_ALTFUN_REG,
 				pdata->config_reg[altfun_reg_index]);
@@ -619,6 +637,52 @@ int ab8500_config_pulldown(struct device *dev,
 EXPORT_SYMBOL(ab8500_config_pulldown);
 
 /*
+ * ab8540_config_pull_updown() only available for following GPIOs:
+ * GPIO51(GPIO1_VBAT)
+ * GPIO52(GPIO2_VBAT)
+ * GPIO53(GPIO3_VBAT)
+ * GPIO54(GPIO4_VBAT)
+ */
+int ab8540_config_pull_updown(struct device *dev,
+				int gpio, enum ab8540_gpio_pull_updown reg)
+{
+	u8 offset =  gpio - AB8500_PIN_GPIO(51);
+	u8 pos = 2 * offset;
+	int ret;
+
+	ret = abx500_mask_and_set_register_interruptible(dev,
+			AB8500_MISC, AB8540_GPIO_PULL_UPDOWN_REG,
+			AB8540_GPIO_PULL_UPDOWN_MASK << pos, reg << pos);
+	if (ret < 0)
+		dev_err(dev, "%s failed (%d)\n", __func__, ret);
+	return ret;
+}
+EXPORT_SYMBOL(ab8540_config_pull_updown);
+
+/*
+ * ab8540_gpio_config_vinsel() only available for following GPIOs:
+ * GPIO51(GPIO1_VBAT)
+ * GPIO52(GPIO2_VBAT)
+ * GPIO53(GPIO3_VBAT)
+ * GPIO54(GPIO4_VBAT)
+ */
+int ab8540_gpio_config_vinsel(struct device *dev,
+				int gpio, enum ab8540_gpio_vinsel reg)
+{
+	u8 offset =  gpio - AB8500_PIN_GPIO(51);
+	u8 pos = 2 * offset;
+	int ret;
+
+	ret = abx500_mask_and_set_register_interruptible(dev,
+			AB8500_MISC, AB8540_GPIO_VINSEL_REG,
+			AB8540_GPIO_VINSEL_MASK << pos, reg << pos);
+	if (ret < 0)
+		dev_err(dev, "%s failed (%d)\n", __func__, ret);
+	return ret;
+}
+EXPORT_SYMBOL(ab8540_gpio_config_vinsel);
+
+/*
  * ab8500_gpio_config_select()
  *
  * Configure functionality of pin, either specific use or GPIO.
diff --git a/include/linux/mfd/abx500/ab8500-gpio.h b/include/linux/mfd/abx500/ab8500-gpio.h
index 48325db..20df07d 100644
--- a/include/linux/mfd/abx500/ab8500-gpio.h
+++ b/include/linux/mfd/abx500/ab8500-gpio.h
@@ -18,62 +18,37 @@ struct ab8500_gpio_platform_data {
 	int gpio_base;
 	u32 irq_base;
 	u8  config_reg[8];
-	u8  config_direction[6];
-	u8  config_pullups[6];
+	u8  config_direction[7];
+	u8  config_pullups[7];
+	u8  config_vinsel;
+	u8  config_pullupdown;
 };
 
-enum ab8500_pin {
-	AB8500_PIN_GPIO1 = 0,
-	AB8500_PIN_GPIO2,
-	AB8500_PIN_GPIO3,
-	AB8500_PIN_GPIO4,
-	AB8500_PIN_GPIO5,
-	AB8500_PIN_GPIO6,
-	AB8500_PIN_GPIO7,
-	AB8500_PIN_GPIO8,
-	AB8500_PIN_GPIO9,
-	AB8500_PIN_GPIO10,
-	AB8500_PIN_GPIO11,
-	AB8500_PIN_GPIO12,
-	AB8500_PIN_GPIO13,
-	AB8500_PIN_GPIO14,
-	AB8500_PIN_GPIO15,
-	AB8500_PIN_GPIO16,
-	AB8500_PIN_GPIO17,
-	AB8500_PIN_GPIO18,
-	AB8500_PIN_GPIO19,
-	AB8500_PIN_GPIO20,
-	AB8500_PIN_GPIO21,
-	AB8500_PIN_GPIO22,
-	AB8500_PIN_GPIO23,
-	AB8500_PIN_GPIO24,
-	AB8500_PIN_GPIO25,
-	AB8500_PIN_GPIO26,
-	AB8500_PIN_GPIO27,
-	AB8500_PIN_GPIO28,
-	AB8500_PIN_GPIO29,
-	AB8500_PIN_GPIO30,
-	AB8500_PIN_GPIO31,
-	AB8500_PIN_GPIO32,
-	AB8500_PIN_GPIO33,
-	AB8500_PIN_GPIO34,
-	AB8500_PIN_GPIO35,
-	AB8500_PIN_GPIO36,
-	AB8500_PIN_GPIO37,
-	AB8500_PIN_GPIO38,
-	AB8500_PIN_GPIO39,
-	AB8500_PIN_GPIO40,
-	AB8500_PIN_GPIO41,
-	AB8500_PIN_GPIO42,
+enum ab8540_gpio_pull_updown {
+	AB8540_GPIO_PULL_DOWN = 0x0,
+	AB8540_GPIO_PULL_NONE = 0x1,
+	AB8540_GPIO_PULL_UP = 0x3,
+};
+
+enum ab8540_gpio_vinsel {
+	AB8540_GPIO_VINSEL_VBAT = 0x0,
+	AB8540_GPIO_VINSEL_VIN_1V8 = 0x1,
+	AB8540_GPIO_VINSEL_VDD_BIF = 0x2,
 };
 
 int ab8500_config_pulldown(struct device *dev,
-				enum ab8500_pin gpio, bool enable);
+				int gpio, bool enable);
+
+int ab8540_config_pull_updown(struct device *dev,
+				int gpio, enum ab8540_gpio_pull_updown reg);
+
+int ab8540_gpio_config_vinsel(struct device *dev,
+				int gpio, enum ab8540_gpio_vinsel reg);
 
 int ab8500_gpio_config_select(struct device *dev,
-				enum ab8500_pin gpio, bool gpio_select);
+				int gpio, bool gpio_select);
 
 int ab8500_gpio_config_get_select(struct device *dev,
-				enum ab8500_pin	gpio, bool *gpio_select);
+				int gpio, bool *gpio_select);
 
 #endif /* _AB8500_GPIO_H */
-- 
1.7.9.5

