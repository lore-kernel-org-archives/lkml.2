Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751035Ab0HIERK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 00:17:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55496 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab0HIERH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 00:17:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sca1z4TFxSyyB+03vswhu7sHWA0NaiHUN+FHjJ+J74vyo2NVbdXBioSqmTu9WsW4r/
         sdpYnvPNMOtla+IJfWHhOhwbdM3k1nquBxgQKLcKmmEeuZqUIiHAI98xyi0GMC7t67di
         xYTCD1d5lB7R/D7R6johiyuezvf0Cl18oW3rE=
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, sameo@linux.intel.com, dtor@mail.ru,
        adobriyan@gmail.com, tj@kernel.org,
        Marek Vasut <marek.vasut@gmail.com>
Subject: [PATCH] UCB1400: Pass ucb1400-gpio data through ac97 bus
Date: Mon,  9 Aug 2010 06:16:34 +0200
Message-Id: <1281327394-6716-1-git-send-email-marek.vasut@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
---
 drivers/gpio/ucb1400_gpio.c |   19 ++++++-------------
 drivers/mfd/ucb1400_core.c  |    5 +++++
 include/linux/ucb1400.h     |   19 ++++++-------------
 3 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/gpio/ucb1400_gpio.c b/drivers/gpio/ucb1400_gpio.c
index 50e6bd1..fba45a5 100644
--- a/drivers/gpio/ucb1400_gpio.c
+++ b/drivers/gpio/ucb1400_gpio.c
@@ -12,8 +12,6 @@
 #include <linux/module.h>
 #include <linux/ucb1400.h>
 
-struct ucb1400_gpio_data *ucbdata;
-
 static int ucb1400_gpio_dir_in(struct gpio_chip *gc, unsigned off)
 {
 	struct ucb1400_gpio *gpio;
@@ -50,7 +48,7 @@ static int ucb1400_gpio_probe(struct platform_device *dev)
 	struct ucb1400_gpio *ucb = dev->dev.platform_data;
 	int err = 0;
 
-	if (!(ucbdata && ucbdata->gpio_offset)) {
+	if (!(ucb && ucb->gpio_offset)) {
 		err = -EINVAL;
 		goto err;
 	}
@@ -58,7 +56,7 @@ static int ucb1400_gpio_probe(struct platform_device *dev)
 	platform_set_drvdata(dev, ucb);
 
 	ucb->gc.label = "ucb1400_gpio";
-	ucb->gc.base = ucbdata->gpio_offset;
+	ucb->gc.base = ucb->gpio_offset;
 	ucb->gc.ngpio = 10;
 	ucb->gc.owner = THIS_MODULE;
 
@@ -72,8 +70,8 @@ static int ucb1400_gpio_probe(struct platform_device *dev)
 	if (err)
 		goto err;
 
-	if (ucbdata && ucbdata->gpio_setup)
-		err = ucbdata->gpio_setup(&dev->dev, ucb->gc.ngpio);
+	if (ucb && ucb->gpio_setup)
+		err = ucb->gpio_setup(&dev->dev, ucb->gc.ngpio);
 
 err:
 	return err;
@@ -85,8 +83,8 @@ static int ucb1400_gpio_remove(struct platform_device *dev)
 	int err = 0;
 	struct ucb1400_gpio *ucb = platform_get_drvdata(dev);
 
-	if (ucbdata && ucbdata->gpio_teardown) {
-		err = ucbdata->gpio_teardown(&dev->dev, ucb->gc.ngpio);
+	if (ucb && ucb->gpio_teardown) {
+		err = ucb->gpio_teardown(&dev->dev, ucb->gc.ngpio);
 		if (err)
 			return err;
 	}
@@ -113,11 +111,6 @@ static void __exit ucb1400_gpio_exit(void)
 	platform_driver_unregister(&ucb1400_gpio_driver);
 }
 
-void __init ucb1400_gpio_set_data(struct ucb1400_gpio_data *data)
-{
-	ucbdata = data;
-}
-
 module_init(ucb1400_gpio_init);
 module_exit(ucb1400_gpio_exit);
 
diff --git a/drivers/mfd/ucb1400_core.c b/drivers/mfd/ucb1400_core.c
index dbe2801..3e24632 100644
--- a/drivers/mfd/ucb1400_core.c
+++ b/drivers/mfd/ucb1400_core.c
@@ -75,6 +75,11 @@ static int ucb1400_core_probe(struct device *dev)
 
 	/* GPIO */
 	ucb_gpio.ac97 = ac97;
+	if (pdata) {
+		ucb_gpio.gpio_setup = pdata->gpio_setup;
+		ucb_gpio.gpio_teardown = pdata->gpio_teardown;
+		ucb_gpio.gpio_offset = pdata->gpio_offset;
+	}
 	ucb->ucb1400_gpio = platform_device_alloc("ucb1400_gpio", -1);
 	if (!ucb->ucb1400_gpio) {
 		err = -ENOMEM;
diff --git a/include/linux/ucb1400.h b/include/linux/ucb1400.h
index 1b47909..1a6bfdd 100644
--- a/include/linux/ucb1400.h
+++ b/include/linux/ucb1400.h
@@ -83,15 +83,12 @@
 #define UCB_ID			0x7e
 #define UCB_ID_1400             0x4304
 
-struct ucb1400_gpio_data {
-	int gpio_offset;
-	int (*gpio_setup)(struct device *dev, int ngpio);
-	int (*gpio_teardown)(struct device *dev, int ngpio);
-};
-
 struct ucb1400_gpio {
 	struct gpio_chip	gc;
 	struct snd_ac97		*ac97;
+	int			gpio_offset;
+	int (*gpio_setup)(struct device *dev, int ngpio);
+	int (*gpio_teardown)(struct device *dev, int ngpio);
 };
 
 struct ucb1400_ts {
@@ -112,6 +109,9 @@ struct ucb1400 {
 
 struct ucb1400_pdata {
 	int	irq;
+	int	gpio_offset;
+	int (*gpio_setup)(struct device *dev, int ngpio);
+	int (*gpio_teardown)(struct device *dev, int ngpio);
 };
 
 static inline u16 ucb1400_reg_read(struct snd_ac97 *ac97, u16 reg)
@@ -163,11 +163,4 @@ static inline void ucb1400_adc_disable(struct snd_ac97 *ac97)
 
 unsigned int ucb1400_adc_read(struct snd_ac97 *ac97, u16 adc_channel,
 			      int adcsync);
-
-#ifdef CONFIG_GPIO_UCB1400
-void __init ucb1400_gpio_set_data(struct ucb1400_gpio_data *data);
-#else
-static inline void ucb1400_gpio_set_data(struct ucb1400_gpio_data *data) {}
-#endif
-
 #endif
-- 
1.7.1

