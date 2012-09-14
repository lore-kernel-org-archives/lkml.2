Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab2INHx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 03:53:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50271 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab2INHxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 03:53:25 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-leds@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        fabio.baltieri@gmail.com, shuahkhan@gmail.com, raph@8d.com,
        tpiepho@freescale.com
Subject: [PATCH 2/2] leds-gpio: remove workqueue in .brightness_set()
Date: Fri, 14 Sep 2012 15:53:03 +0800
Message-Id: <1347609183-26730-3-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347609183-26730-1-git-send-email-bryan.wu@canonical.com>
References: <1347609183-26730-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LED core use workqueue internally now, need to use it in the class driver.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-gpio.c | 43 ++++++-------------------------------------
 1 file changed, 6 insertions(+), 37 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 087d1e6..c89dd15 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -18,36 +18,18 @@
 #include <linux/of_platform.h>
 #include <linux/of_gpio.h>
 #include <linux/slab.h>
-#include <linux/workqueue.h>
 #include <linux/module.h>
 #include <linux/pinctrl/consumer.h>
 
 struct gpio_led_data {
 	struct led_classdev cdev;
 	unsigned gpio;
-	struct work_struct work;
-	u8 new_level;
-	u8 can_sleep;
 	u8 active_low;
 	u8 blinking;
 	int (*platform_gpio_blink_set)(unsigned gpio, int state,
 			unsigned long *delay_on, unsigned long *delay_off);
 };
 
-static void gpio_led_work(struct work_struct *work)
-{
-	struct gpio_led_data	*led_dat =
-		container_of(work, struct gpio_led_data, work);
-
-	if (led_dat->blinking) {
-		led_dat->platform_gpio_blink_set(led_dat->gpio,
-						 led_dat->new_level,
-						 NULL, NULL);
-		led_dat->blinking = 0;
-	} else
-		gpio_set_value_cansleep(led_dat->gpio, led_dat->new_level);
-}
-
 static void gpio_led_set(struct led_classdev *led_cdev,
 	enum led_brightness value)
 {
@@ -63,21 +45,12 @@ static void gpio_led_set(struct led_classdev *led_cdev,
 	if (led_dat->active_low)
 		level = !level;
 
-	/* Setting GPIOs with I2C/etc requires a task context, and we don't
-	 * seem to have a reliable way to know if we're already in one; so
-	 * let's just assume the worst.
-	 */
-	if (led_dat->can_sleep) {
-		led_dat->new_level = level;
-		schedule_work(&led_dat->work);
-	} else {
-		if (led_dat->blinking) {
-			led_dat->platform_gpio_blink_set(led_dat->gpio, level,
-							 NULL, NULL);
-			led_dat->blinking = 0;
-		} else
-			gpio_set_value(led_dat->gpio, level);
-	}
+	if (led_dat->blinking) {
+		led_dat->platform_gpio_blink_set(led_dat->gpio, level,
+				NULL, NULL);
+		led_dat->blinking = 0;
+	} else
+		gpio_set_value(led_dat->gpio, level);
 }
 
 static int gpio_blink_set(struct led_classdev *led_cdev,
@@ -113,7 +86,6 @@ static int __devinit create_gpio_led(const struct gpio_led *template,
 	led_dat->cdev.name = template->name;
 	led_dat->cdev.default_trigger = template->default_trigger;
 	led_dat->gpio = template->gpio;
-	led_dat->can_sleep = gpio_cansleep(template->gpio);
 	led_dat->active_low = template->active_low;
 	led_dat->blinking = 0;
 	if (blink_set) {
@@ -133,8 +105,6 @@ static int __devinit create_gpio_led(const struct gpio_led *template,
 	if (ret < 0)
 		goto err;
 		
-	INIT_WORK(&led_dat->work, gpio_led_work);
-
 	ret = led_classdev_register(parent, &led_dat->cdev);
 	if (ret < 0)
 		goto err;
@@ -150,7 +120,6 @@ static void delete_gpio_led(struct gpio_led_data *led)
 	if (!gpio_is_valid(led->gpio))
 		return;
 	led_classdev_unregister(&led->cdev);
-	cancel_work_sync(&led->work);
 	gpio_free(led->gpio);
 }
 
-- 
1.7.11.4

