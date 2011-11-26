Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab1KZKBZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 05:01:25 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:43643 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab1KZKBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 05:01:17 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: platform-driver-x86@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Matthew Garrett <mjg@redhat.com>,
        Corentin Chary <corentincj@iksaif.net>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/16] samsung-laptop: add keyboard backlight support
Date: Sat, 26 Nov 2011 11:00:08 +0100
Message-Id: <1322301613-8801-12-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322301613-8801-1-git-send-email-corentincj@iksaif.net>
References: <1322301613-8801-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/Kconfig          |    2 +
 drivers/platform/x86/samsung-laptop.c |  136 +++++++++++++++++++++++++++++++++
 2 files changed, 138 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index ec13bc5..1d89c3a 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -747,6 +747,8 @@ config SAMSUNG_LAPTOP
 	depends on X86
 	depends on RFKILL || RFKILL = n
 	depends BACKLIGHT_CLASS_DEVICE
+	select LEDS_CLASS
+	select NEW_LEDS
 	---help---
 	  This module implements a driver for a wide range of different
 	  Samsung laptops.  It offers control over the different
diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index d7cbee9..4a46a7b 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -17,6 +17,7 @@
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/backlight.h>
+#include <linux/leds.h>
 #include <linux/fb.h>
 #include <linux/dmi.h>
 #include <linux/platform_device.h>
@@ -112,6 +113,9 @@ struct sabi_commands {
 	u16 get_usb_charge;
 	u16 set_usb_charge;
 
+	/* 0x81 to read, (0x82 | level << 8) to set, 0xaabb to enable */
+	u16 kbd_backlight;
+
 	/*
 	 * Tell the BIOS that Linux is running on this machine.
 	 * 81 is on, 80 is off
@@ -171,6 +175,8 @@ static const struct sabi_config sabi_configs[] = {
 			.get_usb_charge = 0xFFFF,
 			.set_usb_charge = 0xFFFF,
 
+			.kbd_backlight = 0xFFFF,
+
 			.set_linux = 0x0a,
 		},
 
@@ -224,6 +230,8 @@ static const struct sabi_config sabi_configs[] = {
 			.get_usb_charge = 0x67,
 			.set_usb_charge = 0x68,
 
+			.kbd_backlight = 0x78,
+
 			.set_linux = 0xff,
 		},
 
@@ -290,6 +298,11 @@ struct samsung_laptop {
 	struct backlight_device *backlight_device;
 	struct rfkill *rfk;
 
+	struct led_classdev kbd_led;
+	int kbd_led_wk;
+	struct workqueue_struct *led_workqueue;
+	struct work_struct kbd_led_work;
+
 	struct samsung_laptop_debug debug;
 
 	bool handle_backlight;
@@ -757,6 +770,122 @@ static int __init samsung_rfkill_init(struct samsung_laptop *samsung)
 	return 0;
 }
 
+static int kbd_backlight_enable(struct samsung_laptop *samsung)
+{
+	const struct sabi_commands *commands = &samsung->config->commands;
+	struct sabi_data data;
+	int retval;
+
+	if (commands->kbd_backlight == 0xFFFF)
+		return -ENODEV;
+
+	memset(&data, 0, sizeof(data));
+	data.d0 = 0xaabb;
+	retval = sabi_command(samsung, commands->kbd_backlight,
+			      &data, &data);
+
+	if (retval)
+		return retval;
+
+	if (data.d0 != 0xccdd)
+		return -ENODEV;
+	return 0;
+}
+
+static int kbd_backlight_read(struct samsung_laptop *samsung)
+{
+	const struct sabi_commands *commands = &samsung->config->commands;
+	struct sabi_data data;
+	int retval;
+
+	memset(&data, 0, sizeof(data));
+	data.data[0] = 0x81;
+	retval = sabi_command(samsung, commands->kbd_backlight,
+			      &data, &data);
+
+	if (retval)
+		return retval;
+
+	return data.data[0];
+}
+
+static int kbd_backlight_write(struct samsung_laptop *samsung, int brightness)
+{
+	const struct sabi_commands *commands = &samsung->config->commands;
+	struct sabi_data data;
+
+	memset(&data, 0, sizeof(data));
+	data.d0 = 0x82 | ((brightness & 0xFF) << 8);
+	return sabi_command(samsung, commands->kbd_backlight,
+			    &data, NULL);
+}
+
+static void kbd_led_update(struct work_struct *work)
+{
+	struct samsung_laptop *samsung;
+
+	samsung = container_of(work, struct samsung_laptop, kbd_led_work);
+	kbd_backlight_write(samsung, samsung->kbd_led_wk);
+}
+
+static void kbd_led_set(struct led_classdev *led_cdev,
+			enum led_brightness value)
+{
+	struct samsung_laptop *samsung;
+
+	samsung = container_of(led_cdev, struct samsung_laptop, kbd_led);
+
+	if (value > samsung->kbd_led.max_brightness)
+		value = samsung->kbd_led.max_brightness;
+	else if (value < 0)
+		value = 0;
+
+	samsung->kbd_led_wk = value;
+	queue_work(samsung->led_workqueue, &samsung->kbd_led_work);
+}
+
+static enum led_brightness kbd_led_get(struct led_classdev *led_cdev)
+{
+	struct samsung_laptop *samsung;
+
+	samsung = container_of(led_cdev, struct samsung_laptop, kbd_led);
+	return kbd_backlight_read(samsung);
+}
+
+static void samsung_leds_exit(struct samsung_laptop *samsung)
+{
+	if (!IS_ERR_OR_NULL(samsung->kbd_led.dev))
+		led_classdev_unregister(&samsung->kbd_led);
+	if (samsung->led_workqueue)
+		destroy_workqueue(samsung->led_workqueue);
+}
+
+static int __init samsung_leds_init(struct samsung_laptop *samsung)
+{
+	int ret = 0;
+
+	samsung->led_workqueue = create_singlethread_workqueue("led_workqueue");
+	if (!samsung->led_workqueue)
+		return -ENOMEM;
+
+	if (kbd_backlight_enable(samsung) >= 0) {
+		INIT_WORK(&samsung->kbd_led_work, kbd_led_update);
+
+		samsung->kbd_led.name = "samsung::kbd_backlight";
+		samsung->kbd_led.brightness_set = kbd_led_set;
+		samsung->kbd_led.brightness_get = kbd_led_get;
+		samsung->kbd_led.max_brightness = 8;
+
+		ret = led_classdev_register(&samsung->platform_device->dev,
+					   &samsung->kbd_led);
+	}
+
+	if (ret)
+		samsung_leds_exit(samsung);
+
+	return ret;
+}
+
 static void samsung_backlight_exit(struct samsung_laptop *samsung)
 {
 	if (samsung->backlight_device) {
@@ -1366,6 +1495,10 @@ static int __init samsung_init(void)
 	if (ret)
 		goto error_rfkill;
 
+	ret = samsung_leds_init(samsung);
+	if (ret)
+		goto error_leds;
+
 	ret = samsung_debugfs_init(samsung);
 	if (ret)
 		goto error_debugfs;
@@ -1374,6 +1507,8 @@ static int __init samsung_init(void)
 	return ret;
 
 error_debugfs:
+	samsung_leds_exit(samsung);
+error_leds:
 	samsung_rfkill_exit(samsung);
 error_rfkill:
 	samsung_backlight_exit(samsung);
@@ -1395,6 +1530,7 @@ static void __exit samsung_exit(void)
 	samsung = platform_get_drvdata(samsung_platform_device);
 
 	samsung_debugfs_exit(samsung);
+	samsung_leds_exit(samsung);
 	samsung_rfkill_exit(samsung);
 	samsung_backlight_exit(samsung);
 	samsung_sysfs_exit(samsung);
-- 
1.7.5.4

