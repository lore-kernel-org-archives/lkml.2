Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1AURdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:33:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48199 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751665Ab1AURdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:33:45 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] leds: Fix warnings when PM is disabled for BD2802
Date: Fri, 21 Jan 2011 17:33:37 +0000
Message-Id: <1295631217-19591-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The suspend and resume functions will only be referenced when PM is
enabled so they generate warnings due to being unreferenced and
unexported.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

This is the more usual idiom for fixing this than the patch you added.

 drivers/leds/leds-bd2802.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/leds/leds-bd2802.c b/drivers/leds/leds-bd2802.c
index 22152a2..ef0b868 100644
--- a/drivers/leds/leds-bd2802.c
+++ b/drivers/leds/leds-bd2802.c
@@ -319,20 +319,6 @@ static void bd2802_turn_off(struct bd2802_led *led, enum led_ids id,
 	bd2802_update_state(led, id, color, BD2802_OFF);
 }
 
-static void bd2802_restore_state(struct bd2802_led *led)
-{
-	int i;
-
-	for (i = 0; i < LED_NUM; i++) {
-		if (led->led[i].r)
-			bd2802_turn_on(led, i, RED, led->led[i].r);
-		if (led->led[i].g)
-			bd2802_turn_on(led, i, GREEN, led->led[i].g);
-		if (led->led[i].b)
-			bd2802_turn_on(led, i, BLUE, led->led[i].b);
-	}
-}
-
 #define BD2802_SET_REGISTER(reg_addr, reg_name)				\
 static ssize_t bd2802_store_reg##reg_addr(struct device *dev,		\
 	struct device_attribute *attr, const char *buf, size_t count)	\
@@ -761,6 +747,7 @@ static int __exit bd2802_remove(struct i2c_client *client)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int bd2802_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
@@ -771,6 +758,20 @@ static int bd2802_suspend(struct device *dev)
 	return 0;
 }
 
+static void bd2802_restore_state(struct bd2802_led *led)
+{
+	int i;
+
+	for (i = 0; i < LED_NUM; i++) {
+		if (led->led[i].r)
+			bd2802_turn_on(led, i, RED, led->led[i].r);
+		if (led->led[i].g)
+			bd2802_turn_on(led, i, GREEN, led->led[i].g);
+		if (led->led[i].b)
+			bd2802_turn_on(led, i, BLUE, led->led[i].b);
+	}
+}
+
 static int bd2802_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
@@ -783,6 +784,7 @@ static int bd2802_resume(struct device *dev)
 
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(bd2802_pm, bd2802_suspend, bd2802_resume);
 
-- 
1.7.2.3

