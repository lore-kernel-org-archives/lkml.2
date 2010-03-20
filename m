Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab0CTQQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 12:16:18 -0400
Received: from legolas.restena.lu ([158.64.1.34]:49082 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab0CTQPO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 12:15:14 -0400
Date: Sat, 20 Mar 2010 17:06:19 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH v2 3/6] hid: add backlight support to PicoLCD device
Message-ID: <20100320170619.4ae99546@neptune.home>
In-Reply-To: <20100320170014.440959a8@neptune.home>
References: <20100320170014.440959a8@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add backlight support to PicoLCD device.

Backlight support depends on backlight class and is only being
compiled if backlight class has been selected.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/Kconfig       |    2 +-
 drivers/hid/hid-picolcd.c |  134 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 134 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index a474bcd..5ec3cb7 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -243,8 +243,8 @@ config HID_PICOLCD
 	  - Keypad
 	  - Switching between Firmware and Flash mode
 	  - Framebuffer for monochrome 256x64 display
+	  - Backlight control    (needs CONFIG_BACKLIGHT_CLASS_DEVICE)
 	  Features that are not (yet) supported:
-	  - Backlight control
 	  - Contrast control
 	  - IR
 	  - General purpose outputs
diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index 0c1d293..06cf099 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -26,6 +26,7 @@
 
 #include <linux/fb.h>
 #include <linux/vmalloc.h>
+#include <linux/backlight.h>
 
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
@@ -182,6 +183,11 @@ struct picolcd_data {
 	struct fb_info *fb_info;
 	struct fb_deferred_io fb_defio;
 #endif /* CONFIG_FB */
+#if defined(CONFIG_BACKLIGHT_CLASS_DEVICE) || defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE)
+	struct backlight_device *backlight;
+	u8 lcd_brightness;
+	u8 lcd_power;
+#endif /* CONFIG_BACKLIGHT_CLASS_DEVICE */
 
 	/* Housekeeping stuff */
 	spinlock_t lock;
@@ -641,7 +647,7 @@ static void picolcd_exit_framebuffer(struct picolcd_data *data)
 	kfree(fb_vbitmap);
 }
 
-
+#define picolcd_fbinfo(d) (d)->fb_info
 #else
 static inline int picolcd_fb_reset(struct picolcd_data *data, int clear)
 {
@@ -654,8 +660,118 @@ static inline int picolcd_init_framebuffer(struct picolcd_data *data)
 static void picolcd_exit_framebuffer(struct picolcd_data *data)
 {
 }
+#define picolcd_fbinfo(d) NULL
 #endif /* CONFIG_FB */
 
+#if defined(CONFIG_BACKLIGHT_CLASS_DEVICE) || defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE)
+/*
+ * backlight class device
+ */
+static int picolcd_get_brightness(struct backlight_device *bdev)
+{
+	struct picolcd_data *data = bl_get_data(bdev);
+	return data->lcd_brightness;
+}
+
+static int picolcd_set_brightness(struct backlight_device *bdev)
+{
+	struct picolcd_data *data = bl_get_data(bdev);
+	struct hid_report *report = picolcd_out_report(REPORT_BRIGHTNESS, data->hdev);
+	unsigned long flags;
+
+	if (!report || report->maxfield != 1 || report->field[0]->report_count != 1)
+		return -ENODEV;
+
+	data->lcd_brightness = bdev->props.brightness & 0x0ff;
+	data->lcd_power      = bdev->props.power;
+	spin_lock_irqsave(&data->lock, flags);
+	hid_set_field(report->field[0], 0, data->lcd_power == FB_BLANK_UNBLANK ? data->lcd_brightness : 0);
+	usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
+	spin_unlock_irqrestore(&data->lock, flags);
+	return 0;
+}
+
+static int picolcd_check_bl_fb(struct backlight_device *bdev, struct fb_info *fb)
+{
+	return fb && fb == picolcd_fbinfo((struct picolcd_data *)bl_get_data(bdev));
+}
+
+static const struct backlight_ops picolcd_blops = {
+	.update_status  = picolcd_set_brightness,
+	.get_brightness = picolcd_get_brightness,
+	.check_fb       = picolcd_check_bl_fb,
+};
+
+static inline int picolcd_init_backlight(struct picolcd_data *data, struct hid_report *report)
+{
+	struct device *dev = &data->hdev->dev;
+	struct backlight_device *bdev;
+	struct backlight_properties props;
+	if (!report)
+		return -ENODEV;
+	if (report->maxfield != 1 || report->field[0]->report_count != 1 ||
+			report->field[0]->report_size != 8) {
+		dev_err(dev, "unsupported BRIGHTNESS report");
+		return -EINVAL;
+	}
+
+	memset(&props, 0, sizeof(props));
+	props.max_brightness = 0xff;
+	bdev = backlight_device_register(dev_name(dev), dev, data, &picolcd_blops, &props);
+	if (IS_ERR(bdev)) {
+		dev_err(dev, "failed to register backlight\n");
+		return PTR_ERR(bdev);
+	}
+	bdev->props.brightness     = 0xff;
+	data->lcd_brightness       = 0xff;
+	data->backlight            = bdev;
+	picolcd_set_brightness(bdev);
+	return 0;
+}
+
+static void picolcd_exit_backlight(struct picolcd_data *data)
+{
+	struct backlight_device *bdev = data->backlight;
+
+	data->backlight = NULL;
+	if (bdev)
+		backlight_device_unregister(bdev);
+}
+
+static inline int picolcd_resume_backlight(struct picolcd_data *data)
+{
+	if (!data->backlight)
+		return 0;
+	return picolcd_set_brightness(data->backlight);
+}
+
+static void picolcd_suspend_backlight(struct picolcd_data *data)
+{
+	int bl_power = data->lcd_power;
+	if (!data->backlight)
+		return;
+
+	data->backlight->props.power = FB_BLANK_POWERDOWN;
+	picolcd_set_brightness(data->backlight);
+	data->lcd_power = data->backlight->props.power = bl_power;
+}
+#else
+static inline int picolcd_init_backlight(struct picolcd_data *data, struct hid_report *report)
+{
+	return 0;
+}
+static inline void picolcd_exit_backlight(struct picolcd_data *data)
+{
+}
+static inline int picolcd_resume_backlight(struct picolcd_data *data)
+{
+	return 0;
+}
+static void picolcd_suspend_backlight(struct picolcd_data *data)
+{
+}
+#endif /* CONFIG_BACKLIGHT_CLASS_DEVICE */
+
 /*
  * input class device
  */
@@ -775,6 +891,7 @@ static int picolcd_reset(struct hid_device *hdev)
 		return -EBUSY;
 	}
 
+	picolcd_resume_backlight(data);
 #if defined(CONFIG_FB) || defined(CONFIG_FB_MODULE)
 	if (data->fb_info)
 		schedule_delayed_work(&data->fb_info->deferred_work, 0);
@@ -1365,12 +1482,17 @@ static int picolcd_raw_event(struct hid_device *hdev,
 #ifdef CONFIG_PM
 static int picolcd_suspend(struct hid_device *hdev)
 {
+	picolcd_suspend_backlight(hid_get_drvdata(hdev));
 	dbg_hid(PICOLCD_NAME " device ready for suspend\n");
 	return 0;
 }
 
 static int picolcd_resume(struct hid_device *hdev)
 {
+	int ret;
+	ret = picolcd_resume_backlight(hid_get_drvdata(hdev));
+	if (ret)
+		dbg_hid(PICOLCD_NAME " restoring backlight failed: %d\n", ret);
 	return 0;
 }
 
@@ -1383,6 +1505,9 @@ static int picolcd_reset_resume(struct hid_device *hdev)
 	ret = picolcd_fb_reset(hid_get_drvdata(hdev), 0);
 	if (ret)
 		dbg_hid(PICOLCD_NAME " restoring framebuffer content failed: %d\n", ret);
+	ret = picolcd_resume_backlight(hid_get_drvdata(hdev));
+	if (ret)
+		dbg_hid(PICOLCD_NAME " restoring backlight failed: %d\n", ret);
 	return 0;
 }
 #endif
@@ -1504,6 +1629,11 @@ static inline int picolcd_probe_lcd(struct hid_device *hdev, struct picolcd_data
 	if (error)
 		goto err;
 
+	/* Setup backlight class device */
+	error = picolcd_init_backlight(data, picolcd_out_report(REPORT_BRIGHTNESS, hdev));
+	if (error)
+		goto err;
+
 #ifdef CONFIG_DEBUG_FS
 	report = picolcd_out_report(REPORT_READ_MEMORY, hdev);
 	if (report && report->maxfield == 1 && report->field[0]->report_size == 8)
@@ -1513,6 +1643,7 @@ static inline int picolcd_probe_lcd(struct hid_device *hdev, struct picolcd_data
 #endif
 	return 0;
 err:
+	picolcd_exit_backlight(data);
 	picolcd_exit_framebuffer(data);
 	picolcd_exit_cir(data);
 	picolcd_exit_keys(data);
@@ -1653,6 +1784,7 @@ static void picolcd_remove(struct hid_device *hdev)
 	hid_hw_stop(hdev);
 
 	/* Clean up the framebuffer */
+	picolcd_exit_backlight(data);
 	picolcd_exit_framebuffer(data);
 	/* Cleanup input */
 	picolcd_exit_cir(data);
-- 
1.6.4.4

