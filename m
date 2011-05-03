Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1ECKq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 06:46:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41278 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1ECKqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 06:46:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:date:in-reply-to:references:content-type
         :x-mailer:content-transfer-encoding:message-id:mime-version;
        b=TVJZH5AyZ9iYkqydN4boSUwCNvtdc8gEL3Fe46TBS7Rb2Z2/8BU9y3eDfft4IdN4qd
         d/PSxhdRC7yA9N4qc6e9973kVwHTxzYmfZiAetDgKn2E9qDCnAnn8gnxQXGcCcQOAt+J
         Jh18Suk8rX0F46oBGuhxBXUXxP3V1UPaErnPw=
Subject: Re: [PATCH 1/2] mfd: Add ASIC3 LED support
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Date: Tue, 03 May 2011 12:46:50 +0200
In-Reply-To: <1304419293.13769.13.camel@flow>
References: <E1QGERz-0007fX-2a@outmx08.plus.net>
	 <1304419293.13769.13.camel@flow>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.0- 
Content-Transfer-Encoding: 7bit
Message-ID: <1304419612.13769.17.camel@flow>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

This patch reverts your ASIC3_GPIOC?_LED? changes to keep the gpios as
outputs and informs the led driver via struct asic3_led of the gpio to
toggle in the brightness_set and blink_set callbacks.

Does this work for you?

regards
Philipp

---
 drivers/leds/leds-asic3.c |   19 +++++++++++++++++++
 drivers/mfd/asic3.c       |    3 +++
 include/linux/mfd/asic3.h |    8 +++++---
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-asic3.c b/drivers/leds/leds-asic3.c
index abda364..62b35dc 100644
--- a/drivers/leds/leds-asic3.c
+++ b/drivers/leds/leds-asic3.c
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/gpio.h>
 #include <linux/leds.h>
 #include <linux/slab.h>
 
@@ -41,10 +42,14 @@ static void brightness_set(struct led_classdev *cdev,
 {
 	struct platform_device *pdev = to_platform_device(cdev->dev->parent);
 	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	struct asic3_led *led = mfd_get_data(pdev);
 	struct asic3 *asic = dev_get_drvdata(pdev->dev.parent);
 	u32 timebase;
 	unsigned int base;
 
+	if (value != LED_OFF)
+		gpio_set_value(led->gpio, 1);
+
 	timebase = (value == LED_OFF) ? 0 : (LED_EN|0x4);
 
 	base = led_n_base[cell->id];
@@ -52,6 +57,9 @@ static void brightness_set(struct led_classdev *cdev,
 	asic3_write_register(asic, (base + ASIC3_LED_DutyTime), 32);
 	asic3_write_register(asic, (base + ASIC3_LED_AutoStopCount), 0);
 	asic3_write_register(asic, (base + ASIC3_LED_TimeBase), timebase);
+
+	if (value == LED_OFF)
+		gpio_set_value(led->gpio, 0);
 }
 
 static int blink_set(struct led_classdev *cdev,
@@ -60,6 +68,7 @@ static int blink_set(struct led_classdev *cdev,
 {
 	struct platform_device *pdev = to_platform_device(cdev->dev->parent);
 	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	struct asic3_led *led = mfd_get_data(pdev);
 	struct asic3 *asic = dev_get_drvdata(pdev->dev.parent);
 	u32 on;
 	u32 off;
@@ -79,6 +88,8 @@ static int blink_set(struct led_classdev *cdev,
 			return -EINVAL;
 	}
 
+	gpio_set_value(led->gpio, 1);
+
 	base = led_n_base[cell->id];
 	asic3_write_register(asic, (base + ASIC3_LED_PeriodTime), (on + off));
 	asic3_write_register(asic, (base + ASIC3_LED_DutyTime), on);
@@ -96,6 +107,10 @@ static int __devinit asic3_led_probe(struct platform_device *pdev)
 	struct asic3_led *led = mfd_get_data(pdev);
 	int ret;
 
+	ret = gpio_request(led->gpio, "leds-asic3");
+	if (ret < 0)
+		goto ret_gpio;
+
 	ret = mfd_cell_enable(pdev);
 	if (ret < 0)
 		goto ret0;
@@ -122,6 +137,8 @@ ret2:
 ret1:
 	(void) mfd_cell_disable(pdev);
 ret0:
+	gpio_free(led->gpio);
+ret_gpio:
 	return ret;
 }
 
@@ -135,6 +152,8 @@ static int __devexit asic3_led_remove(struct platform_device *pdev)
 
 	(void) mfd_cell_disable(pdev);
 
+	gpio_free(led->gpio);
+
 	return 0;
 }
 
diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 77c10b7..5e6758d 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -889,6 +889,9 @@ static int __init asic3_mfd_probe(struct platform_device *pdev,
 	}
 
 	if (pdata->leds) {
+		pdata->leds[0].gpio = asic->gpio.base + 32; /* ASIC3_GPIOC0_LED0 */
+		pdata->leds[1].gpio = asic->gpio.base + 33; /* ASIC3_GPIOC1_LED1 */
+		pdata->leds[2].gpio = asic->gpio.base + 34; /* ASIC3_GPIOC2_LED2 */
 		asic3_cell_leds[0].mfd_data = &pdata->leds[0];
 		asic3_cell_leds[1].mfd_data = &pdata->leds[1];
 		asic3_cell_leds[2].mfd_data = &pdata->leds[2];
diff --git a/include/linux/mfd/asic3.h b/include/linux/mfd/asic3.h
index d0dd3eb..f1944ef 100644
--- a/include/linux/mfd/asic3.h
+++ b/include/linux/mfd/asic3.h
@@ -21,6 +21,8 @@ struct asic3_led {
 	const char	*name;
 	const char	*default_trigger;
 	struct led_classdev *cdev;
+
+	int		gpio; /* set by the asic3 mfd driver itself */
 };
 
 struct asic3_platform_data {
@@ -120,9 +122,9 @@ struct asic3_platform_data {
 #define ASIC3_GPIOA11_PWM0		ASIC3_CONFIG_GPIO(11, 1, 1, 0)
 #define ASIC3_GPIOA12_PWM1		ASIC3_CONFIG_GPIO(12, 1, 1, 0)
 #define ASIC3_GPIOA15_CONTROL_CX	ASIC3_CONFIG_GPIO(15, 1, 1, 0)
-#define ASIC3_GPIOC0_LED0		ASIC3_CONFIG_GPIO(32, 1, 0, 0)
-#define ASIC3_GPIOC1_LED1		ASIC3_CONFIG_GPIO(33, 1, 0, 0)
-#define ASIC3_GPIOC2_LED2		ASIC3_CONFIG_GPIO(34, 1, 0, 0)
+#define ASIC3_GPIOC0_LED0		ASIC3_CONFIG_GPIO(32, 1, 1, 0)
+#define ASIC3_GPIOC1_LED1		ASIC3_CONFIG_GPIO(33, 1, 1, 0)
+#define ASIC3_GPIOC2_LED2		ASIC3_CONFIG_GPIO(34, 1, 1, 0)
 #define ASIC3_GPIOC3_SPI_RXD		ASIC3_CONFIG_GPIO(35, 1, 0, 0)
 #define ASIC3_GPIOC4_CF_nCD		ASIC3_CONFIG_GPIO(36, 1, 0, 0)
 #define ASIC3_GPIOC4_SPI_TXD		ASIC3_CONFIG_GPIO(36, 1, 1, 0)
-- 
1.7.4.4


