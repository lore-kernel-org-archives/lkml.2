Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0JTMMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 08:12:00 -0400
Received: from d1.icnet.pl ([212.160.220.21]:40971 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab0JTML6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 08:11:58 -0400
To: Richard Purdie <rpurdie@rpsys.net>
Subject: [RESEND] [PATCH v2] LEDS: Add output invertion option to backlight trigger
Cc: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, e3-hacking@earth.li
Content-Disposition: inline
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
Date: Wed, 20 Oct 2010 14:10:52 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010201410.54395.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the LED backlight tirgger driver with an option that allows 
for inverting the trigger output polarity.

Whith the invertion option provided, I (ab)use the backlight trigger for 
driving a led that indicates LCD display blank condtition on my Amstrad Delta 
videophone. Since the machine has no dedicated power LED, it was not possible 
to distinguish if its display was blanked or it was turned off, without 
touching it.

The invert sysfs control is modeled after a similiar function provided by the 
gpio trigger driver.

Created and tested against linux-2.6.36-rc5 on Amstrad Delta.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
Resent because of no response received in more than 2 weeks.

v1 -> v2 changes:
- improve some conditional expressions to be more readable; thanks to Ralph 
  Corderoy (from e3-hacking) and Lars-Peter Clausen for their suggestions,
- refresh against linux-2.6.36-rc5.

 drivers/leds/ledtrig-backlight.c |   60 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 56 insertions(+), 4 deletions(-)

diff -upr linux-2.6.36-rc5.orig/drivers/leds/ledtrig-backlight.c linux-2.6.36-rc5/drivers/leds/ledtrig-backlight.c
--- linux-2.6.36-rc5.orig/drivers/leds/ledtrig-backlight.c	2010-09-24 15:35:13.000000000 +0200
+++ linux-2.6.36-rc5/drivers/leds/ledtrig-backlight.c	2010-10-03 15:59:49.000000000 +0200
@@ -26,6 +26,7 @@ struct bl_trig_notifier {
 	int brightness;
 	int old_status;
 	struct notifier_block notifier;
+	unsigned invert;
 };
 
 static int fb_notifier_callback(struct notifier_block *p,
@@ -36,23 +37,63 @@ static int fb_notifier_callback(struct n
 	struct led_classdev *led = n->led;
 	struct fb_event *fb_event = data;
 	int *blank = fb_event->data;
+	int new_status = *blank ? BLANK : UNBLANK;
 
 	switch (event) {
 	case FB_EVENT_BLANK :
-		if (*blank && n->old_status == UNBLANK) {
+		if (new_status == n->old_status)
+			break;
+
+		if ((n->old_status == UNBLANK) ^ n->invert) {
 			n->brightness = led->brightness;
 			led_set_brightness(led, LED_OFF);
-			n->old_status = BLANK;
-		} else if (!*blank && n->old_status == BLANK) {
+		} else {
 			led_set_brightness(led, n->brightness);
-			n->old_status = UNBLANK;
 		}
+
+		n->old_status = new_status;
+
 		break;
 	}
 
 	return 0;
 }
 
+static ssize_t bl_trig_invert_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	struct bl_trig_notifier *n = led->trigger_data;
+
+	return sprintf(buf, "%s\n", n->invert ? "yes" : "no");
+}
+
+static ssize_t bl_trig_invert_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t num)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	struct bl_trig_notifier *n = led->trigger_data;
+	unsigned invert;
+	int ret;
+
+	ret = sscanf(buf, "%u", &invert);
+	if (ret < 1) {
+		dev_err(dev, "invalid value\n");
+		return -EINVAL;
+	}
+
+	n->invert = !!invert;
+
+	/* After inverting, we need to update the LED. */
+	if ((n->old_status == BLANK) ^ n->invert)
+		led_set_brightness(led, LED_OFF);
+	else
+		led_set_brightness(led, n->brightness);
+
+	return num;
+}
+static DEVICE_ATTR(invert, 0644, bl_trig_invert_show, bl_trig_invert_store);
+
 static void bl_trig_activate(struct led_classdev *led)
 {
 	int ret;
@@ -66,6 +107,10 @@ static void bl_trig_activate(struct led_
 		return;
 	}
 
+	ret = device_create_file(led->dev, &dev_attr_invert);
+	if (ret)
+		goto err_invert;
+
 	n->led = led;
 	n->brightness = led->brightness;
 	n->old_status = UNBLANK;
@@ -74,6 +119,12 @@ static void bl_trig_activate(struct led_
 	ret = fb_register_client(&n->notifier);
 	if (ret)
 		dev_err(led->dev, "unable to register backlight trigger\n");
+
+	return;
+
+err_invert:
+	led->trigger_data = NULL;
+	kfree(n);
 }
 
 static void bl_trig_deactivate(struct led_classdev *led)
@@ -82,6 +133,7 @@ static void bl_trig_deactivate(struct le
 		(struct bl_trig_notifier *) led->trigger_data;
 
 	if (n) {
+		device_remove_file(led->dev, &dev_attr_invert);
 		fb_unregister_client(&n->notifier);
 		kfree(n);
 	}
