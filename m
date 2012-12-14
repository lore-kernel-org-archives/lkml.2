Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab2LNQZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:25:06 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:40958 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab2LNQTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:19:51 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 02/21] gpio: ab8500: Make pins configurable
Date: Fri, 14 Dec 2012 16:19:20 +0000
Message-Id: <1355501979-1157-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>

Make it possible to set the pin configuration either as gpio or specific
functionality through the driver interface.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/gpio/gpio-ab8500.c             |   63 ++++++++++++++++++++++++++++++++
 include/linux/mfd/abx500/ab8500-gpio.h |   51 ++++++++++++++++++++++++++
 2 files changed, 114 insertions(+)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index db40acb..c3c7c5a 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -495,6 +495,69 @@ static int __devexit ab8500_gpio_remove(struct platform_device *pdev)
 	return 0;
 }
 
+/*
+ * ab8500_gpio_config_select()
+ *
+ * Configure functionality of pin, either specific use or GPIO.
+ * @dev: device pointer
+ * @gpio: gpio number
+ * @gpio_select: true if the pin should be used as GPIO
+ */
+int ab8500_gpio_config_select(struct device *dev,
+				enum ab8500_pin gpio, bool gpio_select)
+{
+	u8 offset = gpio - AB8500_PIN_GPIO1;
+	u8 reg = AB8500_GPIO_SEL1_REG + (offset / 8);
+	u8 pos = offset % 8;
+	u8 val = gpio_select ? 1 : 0;
+	int ret;
+
+	ret = abx500_mask_and_set_register_interruptible(dev,
+		AB8500_MISC, reg, 1 << pos, val << pos);
+	if (ret < 0)
+		dev_err(dev, "%s write failed\n", __func__);
+
+	dev_vdbg(dev, "%s (bank, addr, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
+		__func__, AB8500_MISC, reg, 1 << pos, val << pos);
+
+	return ret;
+}
+
+/*
+ * ab8500_gpio_config_get_select()
+ *
+ * Read currently configured functionality, either specific use or GPIO.
+ * @dev: device pointer
+ * @gpio: gpio number
+ * @gpio_select: pointer to pin selection status
+ */
+int ab8500_gpio_config_get_select(struct device *dev,
+					enum ab8500_pin gpio, bool *gpio_select)
+{
+	u8 offset =  gpio - AB8500_PIN_GPIO1;
+	u8 reg = AB8500_GPIO_SEL1_REG + (offset / 8);
+	u8 pos = offset % 8;
+	u8 val;
+	int ret;
+
+	ret = abx500_get_register_interruptible(dev,
+				AB8500_MISC, reg, &val);
+	if (ret < 0) {
+		dev_err(dev, "%s read failed\n", __func__);
+		return ret;
+	}
+
+	if (val & (1 << pos))
+		*gpio_select = true;
+	else
+		*gpio_select = false;
+
+	dev_vdbg(dev, "%s (bank, addr, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
+		__func__, AB8500_MISC, reg, 1 << pos, val);
+
+	return 0;
+}
+
 static struct platform_driver ab8500_gpio_driver = {
 	.driver = {
 		.name = "ab8500-gpio",
diff --git a/include/linux/mfd/abx500/ab8500-gpio.h b/include/linux/mfd/abx500/ab8500-gpio.h
index 2387c20..5caa615 100644
--- a/include/linux/mfd/abx500/ab8500-gpio.h
+++ b/include/linux/mfd/abx500/ab8500-gpio.h
@@ -20,4 +20,55 @@ struct ab8500_gpio_platform_data {
 	u8  config_reg[8];
 };
 
+enum ab8500_pin {
+	AB8500_PIN_GPIO1 = 0,
+	AB8500_PIN_GPIO2,
+	AB8500_PIN_GPIO3,
+	AB8500_PIN_GPIO4,
+	AB8500_PIN_GPIO5,
+	AB8500_PIN_GPIO6,
+	AB8500_PIN_GPIO7,
+	AB8500_PIN_GPIO8,
+	AB8500_PIN_GPIO9,
+	AB8500_PIN_GPIO10,
+	AB8500_PIN_GPIO11,
+	AB8500_PIN_GPIO12,
+	AB8500_PIN_GPIO13,
+	AB8500_PIN_GPIO14,
+	AB8500_PIN_GPIO15,
+	AB8500_PIN_GPIO16,
+	AB8500_PIN_GPIO17,
+	AB8500_PIN_GPIO18,
+	AB8500_PIN_GPIO19,
+	AB8500_PIN_GPIO20,
+	AB8500_PIN_GPIO21,
+	AB8500_PIN_GPIO22,
+	AB8500_PIN_GPIO23,
+	AB8500_PIN_GPIO24,
+	AB8500_PIN_GPIO25,
+	AB8500_PIN_GPIO26,
+	AB8500_PIN_GPIO27,
+	AB8500_PIN_GPIO28,
+	AB8500_PIN_GPIO29,
+	AB8500_PIN_GPIO30,
+	AB8500_PIN_GPIO31,
+	AB8500_PIN_GPIO32,
+	AB8500_PIN_GPIO33,
+	AB8500_PIN_GPIO34,
+	AB8500_PIN_GPIO35,
+	AB8500_PIN_GPIO36,
+	AB8500_PIN_GPIO37,
+	AB8500_PIN_GPIO38,
+	AB8500_PIN_GPIO39,
+	AB8500_PIN_GPIO40,
+	AB8500_PIN_GPIO41,
+	AB8500_PIN_GPIO42,
+};
+
+int ab8500_gpio_config_select(struct device *dev,
+				enum ab8500_pin gpio, bool gpio_select);
+
+int ab8500_gpio_config_get_select(struct device *dev,
+				enum ab8500_pin	gpio, bool *gpio_select);
+
 #endif /* _AB8500_GPIO_H */
-- 
1.7.9.5

