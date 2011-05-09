Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab1EIJQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 05:16:23 -0400
Received: from [77.233.226.4] ([77.233.226.4]:57653 "EHLO
	mail.doredevelopment.dk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751051Ab1EIJQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 05:16:22 -0400
X-Quarantine-ID: <mkIvOZX+37N4>
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "To"
From: Esben Haabendal <eha@doredevelopment.dk>
Cc: Esben Haabendal <eha@doredevelopment.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH] leds: fix build with CONFIG_LEDS_TRIGGERS disabled
Date: Mon,  9 May 2011 11:16:18 +0200
Message-Id: <1304932578-14501-1-git-send-email-eha@doredevelopment.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20110506182341.d2cd8a19.rdunlap@xenotime.net>
References: <20110506182341.d2cd8a19.rdunlap@xenotime.net>
To: Randy Dunlap <rdunlap@xenotime.net>, akpm@linux-foundation.org,
        Richard Purdie <rpurdie@rpsys.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add led_get_trigger_data() function for stubbing out access to trigger_data
when CONFIG_LEDS_TRIGGERS is disabled.  This fixes builds with
CONFIG_LEDS_CLASS enabled, which were broken by
leds-support-automatic-start-of-blinking-with-ledtrig-timer.patch

Signed-off-by: Esben Haabendal <eha@doredevelopment.dk>
---
 drivers/leds/led-class.c |    2 +-
 drivers/leds/leds.h      |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index d7bdef8..dc3d3d8 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -131,7 +131,7 @@ static void led_set_software_blink(struct led_classdev *led_cdev,
 	if (!led_cdev->blink_brightness)
 		led_cdev->blink_brightness = led_cdev->max_brightness;
 
-	if (led_cdev->trigger_data &&
+	if (led_get_trigger_data(led_cdev) &&
 	    delay_on == led_cdev->blink_delay_on &&
 	    delay_off == led_cdev->blink_delay_off)
 		return;
diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
index 2dd8ecb..e77c7f8 100644
--- a/drivers/leds/leds.h
+++ b/drivers/leds/leds.h
@@ -40,10 +40,17 @@ void led_trigger_set_default(struct led_classdev *led_cdev);
 void led_trigger_set(struct led_classdev *led_cdev,
 			struct led_trigger *trigger);
 void led_trigger_remove(struct led_classdev *led_cdev);
+
+static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
+{
+	return led_cdev->trigger_data;
+}
+
 #else
 #define led_trigger_set_default(x) do {} while (0)
 #define led_trigger_set(x, y) do {} while (0)
 #define led_trigger_remove(x) do {} while (0)
+#define led_get_trigger_data(x) (NULL)
 #endif
 
 ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
-- 
1.7.1

