Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab2DHUN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 16:13:28 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:7310 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab2DHUN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 16:13:27 -0400
Message-ID: <1333916003.2845.6.camel@lorien2>
Subject: [PATCH] leds: simple_strtoul-cleanup
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shuahkhan@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        rpurdie@linux.intel.com
Date: Sun, 08 Apr 2012 14:13:23 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

led-class.c and ledtri-timer.c still use simple_strtoul(). 
Change leds to use kstrtoul() instead of obsolete simple_strtoul().

>From 1bd3a727b022e35c5c4506b610798acd8b05b70d Mon Sep 17 00:00:00 2001
From: Shuah Khan <shuahkhan@gmail.com>
Date: Sun, 8 Apr 2012 13:39:30 -0600
Subject: [PATCH] leds: simple_strtoul-cleanup


Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
---
 drivers/leds/led-class.c     |   24 ++++++++++--------------
 drivers/leds/ledtrig-timer.c |   42 ++++++++++++++++++------------------------
 2 files changed, 28 insertions(+), 38 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 5bff843..c1896e6 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -44,23 +44,19 @@ static ssize_t led_brightness_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t size)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	ssize_t ret = -EINVAL;
-	char *after;
-	unsigned long state = simple_strtoul(buf, &after, 10);
-	size_t count = after - buf;
+	unsigned long state;
+	int ret;
 
-	if (isspace(*after))
-		count++;
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		goto out;
 
-	if (count == size) {
-		ret = count;
+	if (state == LED_OFF)
+		led_trigger_remove(led_cdev);
+	led_set_brightness(led_cdev, state);
 
-		if (state == LED_OFF)
-			led_trigger_remove(led_cdev);
-		led_set_brightness(led_cdev, state);
-	}
-
-	return ret;
+out:
+	return size;
 }
 
 static ssize_t led_max_brightness_show(struct device *dev,
diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
index 328c64c..dc95fa8 100644
--- a/drivers/leds/ledtrig-timer.c
+++ b/drivers/leds/ledtrig-timer.c
@@ -31,21 +31,18 @@ static ssize_t led_delay_on_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t size)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	int ret = -EINVAL;
-	char *after;
-	unsigned long state = simple_strtoul(buf, &after, 10);
-	size_t count = after - buf;
-
-	if (isspace(*after))
-		count++;
-
-	if (count == size) {
-		led_blink_set(led_cdev, &state, &led_cdev->blink_delay_off);
-		led_cdev->blink_delay_on = state;
-		ret = count;
-	}
+	unsigned long state;
+	int ret;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		goto out;
+
+	led_blink_set(led_cdev, &state, &led_cdev->blink_delay_off);
+	led_cdev->blink_delay_on = state;
 
-	return ret;
+out:
+	return size;
 }
 
 static ssize_t led_delay_off_show(struct device *dev,
@@ -60,21 +57,18 @@ static ssize_t led_delay_off_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t size)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	int ret = -EINVAL;
-	char *after;
-	unsigned long state = simple_strtoul(buf, &after, 10);
-	size_t count = after - buf;
-
-	if (isspace(*after))
-		count++;
-
-	if (count == size) {
-		led_blink_set(led_cdev, &led_cdev->blink_delay_on, &state);
-		led_cdev->blink_delay_off = state;
-		ret = count;
-	}
+	unsigned long state;
+	int ret;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		goto out;
+
+	led_blink_set(led_cdev, &led_cdev->blink_delay_on, &state);
+	led_cdev->blink_delay_off = state;
 
-	return ret;
+out:
+	return size;
 }
 
 static DEVICE_ATTR(delay_on, 0644, led_delay_on_show, led_delay_on_store);
-- 
1.7.5.4



