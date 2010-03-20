Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab0CTQP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 12:15:59 -0400
Received: from legolas.restena.lu ([158.64.1.34]:41864 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab0CTQPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 12:15:15 -0400
Date: Sat, 20 Mar 2010 17:08:10 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: [PATCH v2 4/6] hid: add lcd support to PicoLCD device
Message-ID: <20100320170810.60539df3@neptune.home>
In-Reply-To: <20100320170014.440959a8@neptune.home>
References: <20100320170014.440959a8@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add lcd support to PicoLCD device.

LCD support depends on lcd class and is only being
compiled if lcd class has been selected.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/Kconfig       |    2 +-
 drivers/hid/hid-picolcd.c |  108 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 109 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 5ec3cb7..b01de6d 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -244,8 +244,8 @@ config HID_PICOLCD
 	  - Switching between Firmware and Flash mode
 	  - Framebuffer for monochrome 256x64 display
 	  - Backlight control    (needs CONFIG_BACKLIGHT_CLASS_DEVICE)
+	  - Contrast control     (needs CONFIG_LCD_CLASS_DEVICE)
 	  Features that are not (yet) supported:
-	  - Contrast control
 	  - IR
 	  - General purpose outputs
 	  - EEProm / Flash access
diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index 06cf099..88284ca 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -27,6 +27,7 @@
 #include <linux/fb.h>
 #include <linux/vmalloc.h>
 #include <linux/backlight.h>
+#include <linux/lcd.h>
 
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
@@ -183,6 +184,10 @@ struct picolcd_data {
 	struct fb_info *fb_info;
 	struct fb_deferred_io fb_defio;
 #endif /* CONFIG_FB */
+#if defined(CONFIG_LCD_CLASS_DEVICE) || defined(CONFIG_LCD_CLASS_DEVICE_MODULE)
+	struct lcd_device *lcd;
+	u8 lcd_contrast;
+#endif
 #if defined(CONFIG_BACKLIGHT_CLASS_DEVICE) || defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE)
 	struct backlight_device *backlight;
 	u8 lcd_brightness;
@@ -772,6 +777,98 @@ static void picolcd_suspend_backlight(struct picolcd_data *data)
 }
 #endif /* CONFIG_BACKLIGHT_CLASS_DEVICE */
 
+#if defined(CONFIG_LCD_CLASS_DEVICE) || defined(CONFIG_LCD_CLASS_DEVICE_MODULE)
+/*
+ * lcd class device
+ */
+static int picolcd_get_contrast(struct lcd_device *ldev)
+{
+	struct picolcd_data *data = lcd_get_data(ldev);
+	return data->lcd_contrast;
+}
+
+static int picolcd_set_contrast(struct lcd_device *ldev, int contrast)
+{
+	struct picolcd_data *data = lcd_get_data(ldev);
+	struct hid_report *report = picolcd_out_report(REPORT_CONTRAST, data->hdev);
+	unsigned long flags;
+
+	if (!report || report->maxfield != 1 || report->field[0]->report_count != 1)
+		return -ENODEV;
+
+	data->lcd_contrast = contrast & 0x0ff;
+	spin_lock_irqsave(&data->lock, flags);
+	hid_set_field(report->field[0], 0, data->lcd_contrast);
+	usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
+	spin_unlock_irqrestore(&data->lock, flags);
+	return 0;
+}
+
+static int picolcd_check_lcd_fb(struct lcd_device *ldev, struct fb_info *fb)
+{
+	return fb && fb == picolcd_fbinfo((struct picolcd_data *)lcd_get_data(ldev));
+}
+
+static struct lcd_ops picolcd_lcdops = {
+	.get_contrast   = picolcd_get_contrast,
+	.set_contrast   = picolcd_set_contrast,
+	.check_fb       = picolcd_check_lcd_fb,
+};
+
+static inline int picolcd_init_lcd(struct picolcd_data *data, struct hid_report *report)
+{
+	struct device *dev = &data->hdev->dev;
+	struct lcd_device *ldev;
+
+	if (!report)
+		return -ENODEV;
+	if (report->maxfield != 1 || report->field[0]->report_count != 1 ||
+			report->field[0]->report_size != 8) {
+		dev_err(dev, "unsupported CONTRAST report");
+		return -EINVAL;
+	}
+
+	ldev = lcd_device_register(dev_name(dev), dev, data, &picolcd_lcdops);
+	if (IS_ERR(ldev)) {
+		dev_err(dev, "failed to register LCD\n");
+		return PTR_ERR(ldev);
+	}
+	ldev->props.max_contrast = 0x0ff;
+	data->lcd_contrast = 0xe5;
+	data->lcd = ldev;
+	picolcd_set_contrast(ldev, 0xe5);
+	return 0;
+}
+
+static void picolcd_exit_lcd(struct picolcd_data *data)
+{
+	struct lcd_device *ldev = data->lcd;
+
+	data->lcd = NULL;
+	if (ldev)
+		lcd_device_unregister(ldev);
+}
+
+static inline int picolcd_resume_lcd(struct picolcd_data *data)
+{
+	if (!data->lcd)
+		return 0;
+	return picolcd_set_contrast(data->lcd, data->lcd_contrast);
+}
+#else
+static inline int picolcd_init_lcd(struct picolcd_data *data, struct hid_report *report)
+{
+	return 0;
+}
+static inline void picolcd_exit_lcd(struct picolcd_data *data)
+{
+}
+static inline int picolcd_resume_lcd(struct picolcd_data *data)
+{
+	return 0;
+}
+#endif /* CONFIG_LCD_CLASS_DEVICE */
+
 /*
  * input class device
  */
@@ -891,6 +988,7 @@ static int picolcd_reset(struct hid_device *hdev)
 		return -EBUSY;
 	}
 
+	picolcd_resume_lcd(data);
 	picolcd_resume_backlight(data);
 #if defined(CONFIG_FB) || defined(CONFIG_FB_MODULE)
 	if (data->fb_info)
@@ -1505,6 +1603,9 @@ static int picolcd_reset_resume(struct hid_device *hdev)
 	ret = picolcd_fb_reset(hid_get_drvdata(hdev), 0);
 	if (ret)
 		dbg_hid(PICOLCD_NAME " restoring framebuffer content failed: %d\n", ret);
+	ret = picolcd_resume_lcd(hid_get_drvdata(hdev));
+	if (ret)
+		dbg_hid(PICOLCD_NAME " restoring lcd failed: %d\n", ret);
 	ret = picolcd_resume_backlight(hid_get_drvdata(hdev));
 	if (ret)
 		dbg_hid(PICOLCD_NAME " restoring backlight failed: %d\n", ret);
@@ -1629,6 +1730,11 @@ static inline int picolcd_probe_lcd(struct hid_device *hdev, struct picolcd_data
 	if (error)
 		goto err;
 
+	/* Setup lcd class device */
+	error = picolcd_init_lcd(data, picolcd_out_report(REPORT_CONTRAST, hdev));
+	if (error)
+		goto err;
+
 	/* Setup backlight class device */
 	error = picolcd_init_backlight(data, picolcd_out_report(REPORT_BRIGHTNESS, hdev));
 	if (error)
@@ -1644,6 +1750,7 @@ static inline int picolcd_probe_lcd(struct hid_device *hdev, struct picolcd_data
 	return 0;
 err:
 	picolcd_exit_backlight(data);
+	picolcd_exit_lcd(data);
 	picolcd_exit_framebuffer(data);
 	picolcd_exit_cir(data);
 	picolcd_exit_keys(data);
@@ -1785,6 +1892,7 @@ static void picolcd_remove(struct hid_device *hdev)
 
 	/* Clean up the framebuffer */
 	picolcd_exit_backlight(data);
+	picolcd_exit_lcd(data);
 	picolcd_exit_framebuffer(data);
 	/* Cleanup input */
 	picolcd_exit_cir(data);
-- 
1.6.4.4

