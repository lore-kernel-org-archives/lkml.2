Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab1H2EwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 00:52:00 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64634 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab1H2Evz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 00:51:55 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, grant.likely@secretlab.ca, lethal@linux-sh.org,
        rpurdie@rpsys.net, Magnus Damm <magnus.damm@gmail.com>,
        akpm@linux-foundation.org
Date: Mon, 29 Aug 2011 13:53:28 +0900
Message-Id: <20110829045328.23173.92976.sendpatchset@rxone.opensource.se>
Subject: [PATCH] leds: Update Renesas TPU LED driver to use workqueue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Use a workqueue in the Renesas TPU LED driver
to allow the Runtime PM code to sleep.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/leds/leds-renesas-tpu.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- 0017/drivers/leds/leds-renesas-tpu.c
+++ work/drivers/leds/leds-renesas-tpu.c	2011-08-29 13:40:12.000000000 +0900
@@ -31,6 +31,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/workqueue.h>
 
 enum r_tpu_pin { R_TPU_PIN_UNUSED, R_TPU_PIN_GPIO, R_TPU_PIN_GPIO_FN };
 enum r_tpu_timer { R_TPU_TIMER_UNUSED, R_TPU_TIMER_ON };
@@ -44,6 +45,8 @@ struct r_tpu_priv {
 	enum r_tpu_timer timer_state;
 	unsigned long min_rate;
 	unsigned int refresh_rate;
+	struct work_struct work;
+	enum led_brightness new_brightness;
 };
 
 static DEFINE_SPINLOCK(r_tpu_lock);
@@ -211,15 +214,15 @@ static void r_tpu_set_pin(struct r_tpu_p
 	p->pin_state = new_state;
 }
 
-static void r_tpu_set_brightness(struct led_classdev *ldev,
-				 enum led_brightness brightness)
+static void r_tpu_work(struct work_struct *work)
 {
-	struct r_tpu_priv *p = container_of(ldev, struct r_tpu_priv, ldev);
+	struct r_tpu_priv *p = container_of(work, struct r_tpu_priv, work);
+	enum led_brightness brightness = p->new_brightness;
 
 	r_tpu_disable(p);
 
 	/* off and maximum are handled as GPIO pins, in between PWM */
-	if ((brightness == 0) || (brightness == ldev->max_brightness))
+	if ((brightness == 0) || (brightness == p->ldev.max_brightness))
 		r_tpu_set_pin(p, R_TPU_PIN_GPIO, brightness);
 	else {
 		r_tpu_set_pin(p, R_TPU_PIN_GPIO_FN, 0);
@@ -227,6 +230,14 @@ static void r_tpu_set_brightness(struct 
 	}
 }
 
+static void r_tpu_set_brightness(struct led_classdev *ldev,
+				 enum led_brightness brightness)
+{
+	struct r_tpu_priv *p = container_of(ldev, struct r_tpu_priv, ldev);
+	p->new_brightness = brightness;
+	schedule_work(&p->work);
+}
+
 static int __devinit r_tpu_probe(struct platform_device *pdev)
 {
 	struct led_renesas_tpu_config *cfg = pdev->dev.platform_data;
@@ -274,6 +285,7 @@ static int __devinit r_tpu_probe(struct 
 	r_tpu_set_pin(p, R_TPU_PIN_GPIO, LED_OFF);
 	platform_set_drvdata(pdev, p);
 
+	INIT_WORK(&p->work, r_tpu_work);
 
 	p->ldev.name = cfg->name;
 	p->ldev.brightness = LED_OFF;
@@ -307,6 +319,7 @@ static int __devexit r_tpu_remove(struct
 
 	r_tpu_set_brightness(&p->ldev, LED_OFF);
 	led_classdev_unregister(&p->ldev);
+	cancel_work_sync(&p->work);
 	r_tpu_disable(p);
 	r_tpu_set_pin(p, R_TPU_PIN_UNUSED, LED_OFF);
 
