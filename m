Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab0CXXB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 19:01:57 -0400
Received: from legolas.restena.lu ([158.64.1.34]:55119 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab0CXXBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 19:01:16 -0400
Date: Wed, 24 Mar 2010 23:55:56 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH v3 5/6] hid: add GPO (leds) support to PicoLCD device
Message-ID: <20100324235556.1608ee39@neptune.home>
In-Reply-To: <20100324233707.7243b04d@neptune.home>
References: <20100324233707.7243b04d@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add leds support to PicoLCD device to drive the GPO pins.

GPO support depends on leds class and is only being
compiled if leds class has been selected.

Changes since v2:
 - Drop inline keyword on non-stub functions

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/Kconfig       |    6 +-
 drivers/hid/hid-picolcd.c |  164 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 167 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 399edc5..34f6593 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -278,11 +278,11 @@ config HID_PICOLCD
 	  - Keypad
 	  - Switching between Firmware and Flash mode
 	  - Framebuffer for monochrome 256x64 display
-	  - Backlight control    (needs CONFIG_BACKLIGHT_CLASS_DEVICE)
-	  - Contrast control     (needs CONFIG_LCD_CLASS_DEVICE)
+	  - Backlight control         (needs CONFIG_BACKLIGHT_CLASS_DEVICE)
+	  - Contrast control          (needs CONFIG_LCD_CLASS_DEVICE)
+	  - General purpose outputs   (needs CONFIG_LEDS_CLASS)
 	  Features that are not (yet) supported:
 	  - IR
-	  - General purpose outputs
 	  - EEProm / Flash access
 
 config HID_QUANTA
diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index 0cc0d71..ff70aa2 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -29,6 +29,8 @@
 #include <linux/backlight.h>
 #include <linux/lcd.h>
 
+#include <linux/leds.h>
+
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 
@@ -194,6 +196,11 @@ struct picolcd_data {
 	u8 lcd_brightness;
 	u8 lcd_power;
 #endif /* CONFIG_BACKLIGHT_CLASS_DEVICE */
+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+	/* LED stuff */
+	u8 led_state;
+	struct led_classdev *led[8];
+#endif /* CONFIG_LEDS_CLASS */
 
 	/* Housekeeping stuff */
 	spinlock_t lock;
@@ -934,6 +941,153 @@ static inline int picolcd_resume_lcd(struct picolcd_data *data)
 }
 #endif /* CONFIG_LCD_CLASS_DEVICE */
 
+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+/**
+ * LED class device
+ */
+static void picolcd_leds_set(struct picolcd_data *data)
+{
+	struct hid_report *report;
+	unsigned long flags;
+
+	if (!data->led[0])
+		return;
+	report = picolcd_out_report(REPORT_LED_STATE, data->hdev);
+	if (!report || report->maxfield != 1 || report->field[0]->report_count != 1)
+		return;
+
+	spin_lock_irqsave(&data->lock, flags);
+	hid_set_field(report->field[0], 0, data->led_state);
+	usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
+	spin_unlock_irqrestore(&data->lock, flags);
+}
+
+static void picolcd_led_set_brightness(struct led_classdev *led_cdev,
+			enum led_brightness value)
+{
+	struct device *dev;
+	struct hid_device *hdev;
+	struct picolcd_data *data;
+	int i, state = 0;
+
+	dev  = led_cdev->dev->parent;
+	hdev = container_of(dev, struct hid_device, dev);
+	data = hid_get_drvdata(hdev);
+	for (i = 0; i < 8; i++) {
+		if (led_cdev != data->led[i])
+			continue;
+		state = (data->led_state >> i) & 1;
+		if (value == LED_OFF && state) {
+			data->led_state &= ~(1 << i);
+			picolcd_leds_set(data);
+		} else if (value != LED_OFF && !state) {
+			data->led_state |= 1 << i;
+			picolcd_leds_set(data);
+		}
+		break;
+	}
+}
+
+static enum led_brightness picolcd_led_get_brightness(struct led_classdev *led_cdev)
+{
+	struct device *dev;
+	struct hid_device *hdev;
+	struct picolcd_data *data;
+	int i, value = 0;
+
+	dev  = led_cdev->dev->parent;
+	hdev = container_of(dev, struct hid_device, dev);
+	data = hid_get_drvdata(hdev);
+	for (i = 0; i < 8; i++)
+		if (led_cdev == data->led[i]) {
+			value = (data->led_state >> i) & 1;
+			break;
+		}
+	return value ? LED_FULL : LED_OFF;
+}
+
+static int picolcd_init_leds(struct picolcd_data *data, struct hid_report *report)
+{
+	struct device *dev = &data->hdev->dev;
+	struct led_classdev *led;
+	size_t name_sz = strlen(dev_name(dev)) + 8;
+	char *name;
+	int i, ret = 0;
+
+	if (!report)
+		return -ENODEV;
+	if (report->maxfield != 1 || report->field[0]->report_count != 1 ||
+			report->field[0]->report_size != 8) {
+		dev_err(dev, "unsupported LED_STATE report");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < 8; i++) {
+		led = kzalloc(sizeof(struct led_classdev)+name_sz, GFP_KERNEL);
+		if (!led) {
+			dev_err(dev, "can't allocate memory for LED %d\n", i);
+			ret = -ENOMEM;
+			goto err;
+		}
+		name = (void *)(&led[1]);
+		snprintf(name, name_sz, "%s::GPO%d", dev_name(dev), i);
+		led->name = name;
+		led->brightness = 0;
+		led->max_brightness = 1;
+		led->brightness_get = picolcd_led_get_brightness;
+		led->brightness_set = picolcd_led_set_brightness;
+
+		data->led[i] = led;
+		ret = led_classdev_register(dev, data->led[i]);
+		if (ret) {
+			data->led[i] = NULL;
+			kfree(led);
+			dev_err(dev, "can't register LED %d\n", i);
+			goto err;
+		}
+	}
+	return 0;
+err:
+	for (i = 0; i < 8; i++)
+		if (data->led[i]) {
+			led = data->led[i];
+			data->led[i] = NULL;
+			led_classdev_unregister(led);
+			kfree(led);
+		}
+	return ret;
+}
+
+static void picolcd_exit_leds(struct picolcd_data *data)
+{
+	struct led_classdev *led;
+	int i;
+
+	for (i = 0; i < 8; i++) {
+		led = data->led[i];
+		data->led[i] = NULL;
+		if (!led)
+			continue;
+		led_classdev_unregister(led);
+		kfree(led);
+	}
+}
+
+#else
+static inline int picolcd_init_leds(struct picolcd_data *data,
+		struct hid_report *report)
+{
+	return 0;
+}
+static void picolcd_exit_leds(struct picolcd_data *data)
+{
+}
+static inline int picolcd_leds_set(struct picolcd_data *data)
+{
+	return 0;
+}
+#endif /* CONFIG_LEDS_CLASS */
+
 /*
  * input class device
  */
@@ -1076,6 +1230,7 @@ static int picolcd_reset(struct hid_device *hdev)
 		schedule_delayed_work(&data->fb_info->deferred_work, 0);
 #endif /* CONFIG_FB */
 
+	picolcd_leds_set(data);
 	return 0;
 }
 
@@ -1694,6 +1849,7 @@ static int picolcd_reset_resume(struct hid_device *hdev)
 	ret = picolcd_resume_backlight(hid_get_drvdata(hdev));
 	if (ret)
 		dbg_hid(PICOLCD_NAME " restoring backlight failed: %d\n", ret);
+	picolcd_leds_set(hid_get_drvdata(hdev));
 	return 0;
 }
 #endif
@@ -1808,6 +1964,11 @@ static int picolcd_probe_lcd(struct hid_device *hdev, struct picolcd_data *data)
 	if (error)
 		goto err;
 
+	/* Setup the LED class devices */
+	error = picolcd_init_leds(data, picolcd_out_report(REPORT_LED_STATE, hdev));
+	if (error)
+		goto err;
+
 #ifdef CONFIG_DEBUG_FS
 	report = picolcd_out_report(REPORT_READ_MEMORY, hdev);
 	if (report && report->maxfield == 1 && report->field[0]->report_size == 8)
@@ -1817,6 +1978,7 @@ static int picolcd_probe_lcd(struct hid_device *hdev, struct picolcd_data *data)
 #endif
 	return 0;
 err:
+	picolcd_exit_leds(data);
 	picolcd_exit_backlight(data);
 	picolcd_exit_lcd(data);
 	picolcd_exit_framebuffer(data);
@@ -1949,6 +2111,8 @@ static void picolcd_remove(struct hid_device *hdev)
 		complete(&data->pending->ready);
 	spin_unlock_irqrestore(&data->lock, flags);
 
+	/* Cleanup LED */
+	picolcd_exit_leds(data);
 	/* Clean up the framebuffer */
 	picolcd_exit_backlight(data);
 	picolcd_exit_lcd(data);
-- 
1.6.4.4

