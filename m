Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab2DIQLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 12:11:11 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:17849 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2DIQLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 12:11:10 -0400
Message-ID: <1333987866.2871.5.camel@lorien2>
Subject: Re: [PATCH v2] leds: simple_strtoul-cleanup
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: shuahkhan@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        rpurdie@linux.intel.com
Date: Mon, 09 Apr 2012 10:11:06 -0600
In-Reply-To: <1333981564.2871.1.camel@lorien2>
References: <1333916003.2845.6.camel@lorien2>
	 <1333916453.1801.2.camel@joe2Laptop> <1333981564.2871.1.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

led-class.c and ledtri-timer.c still use simple_strtoul(). 
Change leds to use kstrtoul() instead of obsolete simple_strtoul().

This patch version addresses Joe's review comment. Added returning -EINVAL 
in error paths back in. Also fixed existing int ret declaration to be ssize_t 
to match the return type for _store functions in ledtrig-timer.c

>From 411bd03d4327d210595264c39f71e6f446ac0f90 Mon Sep 17 00:00:00 2001
From: Shuah Khan <shuahkhan@gmail.com>
Date: Mon, 9 Apr 2012 09:05:07 -0600
Subject: [PATCH] leds: simple_strtoul-cleanup


Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
---
 drivers/leds/led-class.c     |   21 ++++++++-------------
 drivers/leds/ledtrig-timer.c |   40 ++++++++++++++++------------------------
 2 files changed, 24 insertions(+), 37 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 5bff843..8ee92c8 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -44,23 +44,18 @@ static ssize_t led_brightness_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t size)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned long state;
 	ssize_t ret = -EINVAL;
-	char *after;
-	unsigned long state = simple_strtoul(buf, &after, 10);
-	size_t count = after - buf;
 
-	if (isspace(*after))
-		count++;
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
 
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
+	return size;
 }
 
 static ssize_t led_max_brightness_show(struct device *dev,
diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
index 328c64c..b32d5ea 100644
--- a/drivers/leds/ledtrig-timer.c
+++ b/drivers/leds/ledtrig-timer.c
@@ -31,21 +31,17 @@ static ssize_t led_delay_on_store(struct device *dev,
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
+	ssize_t ret = -EINVAL;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	led_blink_set(led_cdev, &state, &led_cdev->blink_delay_off);
+	led_cdev->blink_delay_on = state;
 
-	return ret;
+	return size;
 }
 
 static ssize_t led_delay_off_show(struct device *dev,
@@ -60,21 +56,17 @@ static ssize_t led_delay_off_store(struct device *dev,
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
+	ssize_t ret = -EINVAL;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	led_blink_set(led_cdev, &led_cdev->blink_delay_on, &state);
+	led_cdev->blink_delay_off = state;
 
-	return ret;
+	return size;
 }
 
 static DEVICE_ATTR(delay_on, 0644, led_delay_on_show, led_delay_on_store);
-- 
1.7.5.4



