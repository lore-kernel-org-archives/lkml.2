Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1D1G7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 02:59:23 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:42266 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752575Ab1D1G7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 02:59:22 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] gpio: rename VIA local config struct
Date: Thu, 28 Apr 2011 08:59:00 +0200
Message-ID: <1303973940-13296-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The local VIA GPIO config struct "gpio_config" collides with my
extension to the gpio_chip struct, so rename it to via_gpio_config
so we don't get this clash.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/video/via/via-gpio.c |   49 +++++++++++++++++++++--------------------
 1 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/video/via/via-gpio.c b/drivers/video/via/via-gpio.c
index c2a0a1c..4b26f3f 100644
--- a/drivers/video/via/via-gpio.c
+++ b/drivers/video/via/via-gpio.c
@@ -145,7 +145,7 @@ static int via_gpio_get(struct gpio_chip *chip, unsigned int nr)
 }
 
 
-static struct viafb_gpio_cfg gpio_config = {
+static struct viafb_gpio_cfg via_gpio_config = {
 	.gpio_chip = {
 		.label = "VIAFB onboard GPIO",
 		.owner = THIS_MODULE,
@@ -183,8 +183,8 @@ static int viafb_gpio_resume(void *private)
 {
 	int i;
 
-	for (i = 0; i < gpio_config.gpio_chip.ngpio; i += 2)
-		viafb_gpio_enable(gpio_config.active_gpios[i]);
+	for (i = 0; i < via_gpio_config.gpio_chip.ngpio; i += 2)
+		viafb_gpio_enable(via_gpio_config.active_gpios[i]);
 	return 0;
 }
 
@@ -201,9 +201,9 @@ int viafb_gpio_lookup(const char *name)
 {
 	int i;
 
-	for (i = 0; i < gpio_config.gpio_chip.ngpio; i++)
-		if (!strcmp(name, gpio_config.active_gpios[i]->vg_name))
-			return gpio_config.gpio_chip.base + i;
+	for (i = 0; i < via_gpio_config.gpio_chip.ngpio; i++)
+		if (!strcmp(name, via_gpio_config.active_gpios[i]->vg_name))
+			return via_gpio_config.gpio_chip.base + i;
 	return -1;
 }
 EXPORT_SYMBOL_GPL(viafb_gpio_lookup);
@@ -229,14 +229,15 @@ static __devinit int viafb_gpio_probe(struct platform_device *platdev)
 		for (gpio = viafb_all_gpios;
 		     gpio < viafb_all_gpios + VIAFB_NUM_GPIOS; gpio++)
 			if (gpio->vg_port_index == port_cfg[i].ioport_index) {
-				gpio_config.active_gpios[ngpio] = gpio;
-				gpio_config.gpio_names[ngpio] = gpio->vg_name;
+				via_gpio_config.active_gpios[ngpio] = gpio;
+				via_gpio_config.gpio_names[ngpio] =
+					gpio->vg_name;
 				ngpio++;
 			}
 	}
-	gpio_config.gpio_chip.ngpio = ngpio;
-	gpio_config.gpio_chip.names = gpio_config.gpio_names;
-	gpio_config.vdev = vdev;
+	via_gpio_config.gpio_chip.ngpio = ngpio;
+	via_gpio_config.gpio_chip.names = via_gpio_config.gpio_names;
+	via_gpio_config.vdev = vdev;
 	if (ngpio == 0) {
 		printk(KERN_INFO "viafb: no GPIOs configured\n");
 		return 0;
@@ -245,18 +246,18 @@ static __devinit int viafb_gpio_probe(struct platform_device *platdev)
 	 * Enable the ports.  They come in pairs, with a single
 	 * enable bit for both.
 	 */
-	spin_lock_irqsave(&gpio_config.vdev->reg_lock, flags);
+	spin_lock_irqsave(&via_gpio_config.vdev->reg_lock, flags);
 	for (i = 0; i < ngpio; i += 2)
-		viafb_gpio_enable(gpio_config.active_gpios[i]);
-	spin_unlock_irqrestore(&gpio_config.vdev->reg_lock, flags);
+		viafb_gpio_enable(via_gpio_config.active_gpios[i]);
+	spin_unlock_irqrestore(&via_gpio_config.vdev->reg_lock, flags);
 	/*
 	 * Get registered.
 	 */
-	gpio_config.gpio_chip.base = -1;  /* Dynamic */
-	ret = gpiochip_add(&gpio_config.gpio_chip);
+	via_gpio_config.gpio_chip.base = -1;  /* Dynamic */
+	ret = gpiochip_add(&via_gpio_config.gpio_chip);
 	if (ret) {
 		printk(KERN_ERR "viafb: failed to add gpios (%d)\n", ret);
-		gpio_config.gpio_chip.ngpio = 0;
+		via_gpio_config.gpio_chip.ngpio = 0;
 	}
 #ifdef CONFIG_PM
 	viafb_pm_register(&viafb_gpio_pm_hooks);
@@ -277,8 +278,8 @@ static int viafb_gpio_remove(struct platform_device *platdev)
 	/*
 	 * Get unregistered.
 	 */
-	if (gpio_config.gpio_chip.ngpio > 0) {
-		ret = gpiochip_remove(&gpio_config.gpio_chip);
+	if (via_gpio_config.gpio_chip.ngpio > 0) {
+		ret = gpiochip_remove(&via_gpio_config.gpio_chip);
 		if (ret) { /* Somebody still using it? */
 			printk(KERN_ERR "Viafb: GPIO remove failed\n");
 			return ret;
@@ -287,11 +288,11 @@ static int viafb_gpio_remove(struct platform_device *platdev)
 	/*
 	 * Disable the ports.
 	 */
-	spin_lock_irqsave(&gpio_config.vdev->reg_lock, flags);
-	for (i = 0; i < gpio_config.gpio_chip.ngpio; i += 2)
-		viafb_gpio_disable(gpio_config.active_gpios[i]);
-	gpio_config.gpio_chip.ngpio = 0;
-	spin_unlock_irqrestore(&gpio_config.vdev->reg_lock, flags);
+	spin_lock_irqsave(&via_gpio_config.vdev->reg_lock, flags);
+	for (i = 0; i < via_gpio_config.gpio_chip.ngpio; i += 2)
+		viafb_gpio_disable(via_gpio_config.active_gpios[i]);
+	via_gpio_config.gpio_chip.ngpio = 0;
+	spin_unlock_irqrestore(&via_gpio_config.vdev->reg_lock, flags);
 	return ret;
 }
 
-- 
1.7.3.2

