Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1AJE4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 23:56:47 -0500
Received: from d1.icnet.pl ([212.160.220.21]:48309 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab1AJE4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 23:56:44 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3] LEDS: Add output invertion option to backlight trigger
Date: Mon, 10 Jan 2011 05:54:32 +0100
User-Agent: KMail/1.9.10
Cc: Richard Purdie <rpurdie@rpsys.net>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Richard Purdie <rpurdie@linux.intel.com>
References: <201012091441.51846.jkrzyszt@tis.icnet.pl> <20110106130440.cfd77c8e.akpm@linux-foundation.org>
In-Reply-To: <20110106130440.cfd77c8e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101100554.34677.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the LED backlight tirgger driver with an option that 
allows for inverting the trigger output polarity.

With the invertion option provided, I (ab)use the backlight trigger for 
driving a LED that indicates LCD display blank condtition on my Amstrad 
Delta videophone. Since the machine has no dedicated power LED, it was 
not possible to distinguish if the display was blanked, or the machine 
was turned off, without touching it.

The invert sysfs control is patterned after a similiar function of the 
GPIO trigger driver.

Created and tested against linux-2.6.37 on Amstrad Delta.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Richard Purdie <rpurdie@rpsys.net>
---

v2 -> v3 changes, all provided, requested or inspired by Andrew Morton 
  (thanks!):
- sysfs file should show "0" or "1" to match the thing which the user
  wrote there,
- use strict_strtoul() so the kernel correctly rejects non-numerical 
  input,
- disallow any input other than 0 or 1,
- new sysfs file should be documented,
- the new sysfs file name could be consistent with the one already used 
  by the gpio trigger for a similiar function.

v1 -> v2 changes:
- improve some conditional expressions to be more readable; thanks to 
  Ralph Corderoy (from e3-hacking) and Lars-Peter Clausen for their 
  suggestions,
- refresh against linux-2.6.36-rc5.

 Documentation/ABI/testing/sysfs-class-led |   10 ++++
 drivers/leds/ledtrig-backlight.c          |   61 ++++++++++++++++++++++++++++--
 2 files changed, 67 insertions(+), 4 deletions(-)

--- linux-2.6.37/drivers/leds/ledtrig-backlight.c.orig	2011-01-10 02:55:26.000000000 +0100
+++ linux-2.6.37/drivers/leds/ledtrig-backlight.c	2011-01-10 03:12:46.000000000 +0100
@@ -26,6 +26,7 @@ struct bl_trig_notifier {
 	int brightness;
 	int old_status;
 	struct notifier_block notifier;
+	unsigned invert;
 };
 
 static int fb_notifier_callback(struct notifier_block *p,
@@ -36,23 +37,64 @@ static int fb_notifier_callback(struct n
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
+	return sprintf(buf, "%u\n", n->invert);
+}
+
+static ssize_t bl_trig_invert_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t num)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	struct bl_trig_notifier *n = led->trigger_data;
+	unsigned long invert;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &invert);
+	if (ret < 0)
+		return ret;
+
+	if (invert > 1)
+		return -EINVAL;
+
+	n->invert = invert;
+
+	/* After inverting, we need to update the LED. */
+	if ((n->old_status == BLANK) ^ n->invert)
+		led_set_brightness(led, LED_OFF);
+	else
+		led_set_brightness(led, n->brightness);
+
+	return num;
+}
+static DEVICE_ATTR(inverted, 0644, bl_trig_invert_show, bl_trig_invert_store);
+
 static void bl_trig_activate(struct led_classdev *led)
 {
 	int ret;
@@ -66,6 +108,10 @@ static void bl_trig_activate(struct led_
 		return;
 	}
 
+	ret = device_create_file(led->dev, &dev_attr_inverted);
+	if (ret)
+		goto err_invert;
+
 	n->led = led;
 	n->brightness = led->brightness;
 	n->old_status = UNBLANK;
@@ -74,6 +120,12 @@ static void bl_trig_activate(struct led_
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
@@ -82,6 +134,7 @@ static void bl_trig_deactivate(struct le
 		(struct bl_trig_notifier *) led->trigger_data;
 
 	if (n) {
+		device_remove_file(led->dev, &dev_attr_inverted);
 		fb_unregister_client(&n->notifier);
 		kfree(n);
 	}
--- linux-2.6.37/Documentation/ABI/testing/sysfs-class-led.orig	2011-01-10 02:42:16.000000000 +0100
+++ linux-2.6.37/Documentation/ABI/testing/sysfs-class-led	2011-01-10 03:38:28.000000000 +0100
@@ -26,3 +26,13 @@ Description:
 		scheduler is chosen. Trigger specific parameters can appear in
 		/sys/class/leds/<led> once a given trigger is selected.
 
+What:		/sys/class/leds/<led>/inverted
+Date:		January 2011
+KernelVersion:	2.6.38
+Contact:	Richard Purdie <rpurdie@rpsys.net>
+Description:
+		Invert the LED on/off state. This parameter is specific to
+		gpio and backlight triggers. In case of the backlight trigger,
+		it is usefull when driving a LED which is intended to indicate
+		a device in a standby like state.
+
