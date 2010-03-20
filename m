Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0CTQQW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 12:16:22 -0400
Received: from legolas.restena.lu ([158.64.1.34]:41972 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab0CTQPN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 12:15:13 -0400
Date: Sat, 20 Mar 2010 17:04:15 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: [PATCH v2 2/6] hid: add framebuffer support to PicoLCD device
Message-ID: <20100320170415.6ee219c8@neptune.home>
In-Reply-To: <20100320170014.440959a8@neptune.home>
References: <20100320170014.440959a8@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add framebuffer support to PicoLCD device with use of deferred-io.

Only changed areas of framebuffer get sent to device in order to
save USB bandwidth and especially resources on PicoLCD device or
allow higher refresh rate for a small area.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/Kconfig       |    7 +-
 drivers/hid/hid-picolcd.c |  454 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 460 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 7097f0a..a474bcd 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -230,6 +230,11 @@ config HID_PETALYNX
 config HID_PICOLCD
 	tristate "PicoLCD (graphic version)"
 	depends on USB_HID
+	select FB_DEFERRED_IO if FB
+	select FB_SYS_FILLRECT if FB
+	select FB_SYS_COPYAREA if FB
+	select FB_SYS_IMAGEBLIT if FB
+	select FB_SYS_FOPS if FB
 	---help---
 	  This provides support for Minibox PicoLCD devices, currently
 	  only the graphical ones are supported.
@@ -237,8 +242,8 @@ config HID_PICOLCD
 	  This includes support for the following device features:
 	  - Keypad
 	  - Switching between Firmware and Flash mode
-	  Features that are not (yet) supported:
 	  - Framebuffer for monochrome 256x64 display
+	  Features that are not (yet) supported:
 	  - Backlight control
 	  - Contrast control
 	  - IR
diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index 30b8e08..0c1d293 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -24,6 +24,9 @@
 #include "usbhid/usbhid.h"
 #include <linux/usb.h>
 
+#include <linux/fb.h>
+#include <linux/vmalloc.h>
+
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 
@@ -69,6 +72,59 @@
 #define REPORT_HOOK_VERSION    0xf7 /* LCD: IN[2], OUT[1]   */
 #define REPORT_EXIT_FLASHER    0xff /*                      Bootloader: OUT[2]         */
 
+#if defined(CONFIG_FB) || defined(CONFIG_FB_MODULE)
+/* Framebuffer
+ *
+ * The PicoLCD use a Topway LCD module of 256x64 pixel
+ * This display area is tiled over 4 controllers with 8 tiles
+ * each. Each tile has 8x64 pixel, each data byte representing
+ * a 1-bit wide vertical line of the tile.
+ *
+ * The display can be updated at a tile granularity.
+ *
+ *       Chip 1           Chip 2           Chip 3           Chip 4
+ * +----------------+----------------+----------------+----------------+
+ * |     Tile 1     |     Tile 1     |     Tile 1     |     Tile 1     |
+ * +----------------+----------------+----------------+----------------+
+ * |     Tile 2     |     Tile 2     |     Tile 2     |     Tile 2     |
+ * +----------------+----------------+----------------+----------------+
+ *                                  ...
+ * +----------------+----------------+----------------+----------------+
+ * |     Tile 8     |     Tile 8     |     Tile 8     |     Tile 8     |
+ * +----------------+----------------+----------------+----------------+
+ */
+#define PICOLCDFB_NAME "picolcdfb"
+#define PICOLCDFB_WIDTH (256)
+#define PICOLCDFB_LINE_LENGTH (256/8)
+#define PICOLCDFB_HEIGHT (64)
+#define PICOLCDFB_SIZE (PICOLCDFB_LINE_LENGTH*PICOLCDFB_HEIGHT)
+
+#define PICOLCDFB_UPDATE_RATE_LIMIT   10
+#define PICOLCDFB_UPDATE_RATE_DEFAULT  2
+
+/* Framebuffer visual structures */
+static const struct fb_fix_screeninfo picolcdfb_fix = {
+	.id          = PICOLCDFB_NAME,
+	.type        = FB_TYPE_PACKED_PIXELS,
+	.visual      = FB_VISUAL_MONO01,
+	.xpanstep    = 0,
+	.ypanstep    = 0,
+	.ywrapstep   = 0,
+	.line_length = PICOLCDFB_LINE_LENGTH,
+	.accel       = FB_ACCEL_NONE,
+};
+
+static const struct fb_var_screeninfo picolcdfb_var = {
+	.xres           = PICOLCDFB_WIDTH,
+	.yres           = PICOLCDFB_HEIGHT,
+	.xres_virtual   = PICOLCDFB_WIDTH,
+	.yres_virtual   = PICOLCDFB_HEIGHT,
+	.width          = 103,
+	.height         = 26,
+	.bits_per_pixel = 1,
+};
+#endif /* CONFIG_FB */
+
 /* Input device
  *
  * The PicoLCD has an IR receiver header, a built-in keypad with 5 keys
@@ -118,12 +174,22 @@ struct picolcd_data {
 	struct input_dev *input_cir;
 	int keycode[PICOLCD_KEYS];
 
+#if defined(CONFIG_FB) || defined(CONFIG_FB_MODULE)
+	/* Framebuffer stuff */
+	u8 fb_update_rate;
+	u8 *fb_vbitmap;		/* local copy of what was sent to PicoLCD */
+	u8 *fb_bitmap;		/* framebuffer */
+	struct fb_info *fb_info;
+	struct fb_deferred_io fb_defio;
+#endif /* CONFIG_FB */
+
 	/* Housekeeping stuff */
 	spinlock_t lock;
 	struct picolcd_pending *pending;
 	struct completion ready;
 	int status;
 #define PICOLCD_BUSY 1
+#define PICOLCD_READY_FB 2
 #define PICOLCD_FAILED 4
 #define PICOLCD_BOOTLOADER 8
 };
@@ -218,6 +284,378 @@ retry:
 	}
 }
 
+#if defined(CONFIG_FB) || defined(CONFIG_FB_MODULE)
+/* Send a given tile to PicoLCD */
+static inline int picolcd_fb_send_tile(struct hid_device *hdev, int chip,
+		int tile)
+{
+	struct picolcd_data *data = hid_get_drvdata(hdev);
+	struct hid_report *report1 = picolcd_out_report(REPORT_LCD_CMD_DATA, hdev);
+	struct hid_report *report2 = picolcd_out_report(REPORT_LCD_DATA, hdev);
+	unsigned long flags;
+	u8 *tdata;
+	int i;
+
+	if (!report1 || report1->maxfield != 1 || !report2 || report2->maxfield != 1)
+		return -ENODEV;
+
+	spin_lock_irqsave(&data->lock, flags);
+	hid_set_field(report1->field[0],  0, chip << 2);
+	hid_set_field(report1->field[0],  1, 0x02);
+	hid_set_field(report1->field[0],  2, 0x00);
+	hid_set_field(report1->field[0],  3, 0x00);
+	hid_set_field(report1->field[0],  4, 0xb8 | tile);
+	hid_set_field(report1->field[0],  5, 0x00);
+	hid_set_field(report1->field[0],  6, 0x00);
+	hid_set_field(report1->field[0],  7, 0x40);
+	hid_set_field(report1->field[0],  8, 0x00);
+	hid_set_field(report1->field[0],  9, 0x00);
+	hid_set_field(report1->field[0], 10,   32);
+
+	hid_set_field(report2->field[0],  0, (chip << 2) | 0x01);
+	hid_set_field(report2->field[0],  1, 0x00);
+	hid_set_field(report2->field[0],  2, 0x00);
+	hid_set_field(report2->field[0],  3,   32);
+
+	tdata = data->fb_vbitmap + (tile * 4 + chip) * 64;
+	for (i = 0; i < 64; i++)
+		if (i < 32)
+			hid_set_field(report1->field[0], 11 + i, tdata[i]);
+		else
+			hid_set_field(report2->field[0], 4 + i - 32, tdata[i]);
+
+	usbhid_submit_report(data->hdev, report1, USB_DIR_OUT);
+	usbhid_submit_report(data->hdev, report2, USB_DIR_OUT);
+	spin_unlock_irqrestore(&data->lock, flags);
+	return 0;
+}
+
+/* Translate a single tile*/
+static inline int picolcd_fb_update_tile(u8 *vbitmap, const u8 *bitmap,
+		int chip, int tile)
+{
+	int i, b, changed = 0;
+	u8 tdata[64];
+	u8 *vdata = vbitmap + (tile * 4 + chip) * 64;
+
+	for (b = 7; b >= 0; b--) {
+		const u8 *bdata = bitmap + tile * 256 + chip * 8 + b * 32;
+		for (i = 0; i < 64; i++) {
+			tdata[i] <<= 1;
+			tdata[i] |= (bdata[i/8] >> (7 - i % 8)) & 0x01;
+		}
+	}
+	for (i = 0; i < 64; i++)
+		if (tdata[i] != vdata[i]) {
+			changed = 1;
+			vdata[i] = tdata[i];
+		}
+	return changed;
+}
+
+/* Reconfigure LCD display */
+static int picolcd_fb_reset(struct picolcd_data *data, int clear)
+{
+	struct hid_report *report = picolcd_out_report(REPORT_LCD_CMD, data->hdev);
+	int i, j;
+	unsigned long flags;
+	static const u8 mapcmd[8] = { 0x00, 0x02, 0x00, 0x64, 0x3f, 0x00, 0x64, 0xc0 };
+
+	if (!report || report->maxfield != 1)
+		return -ENODEV;
+
+	spin_lock_irqsave(&data->lock, flags);
+	for (i = 0; i < 4; i++) {
+		for (j = 0; j < report->field[0]->maxusage; j++)
+			if (j == 0)
+				hid_set_field(report->field[0], j, i << 2);
+			else if (j < sizeof(mapcmd))
+				hid_set_field(report->field[0], j, mapcmd[j]);
+			else
+				hid_set_field(report->field[0], j, 0);
+		usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
+	}
+
+	data->status |= PICOLCD_READY_FB;
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	if (clear && data->fb_bitmap) {
+		memset(data->fb_bitmap, 0, PICOLCDFB_SIZE);
+	}
+
+	/* schedule first output of framebuffer */
+	if (data->fb_info)
+		schedule_delayed_work(&data->fb_info->deferred_work, 0);
+
+	return 0;
+}
+
+/* Update fb_vbitmap from the screen_base and send changed tiles to device */
+static void picolcd_fb_update(struct picolcd_data *data)
+{
+	int chip, tile;
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->lock, flags);
+	if (!(data->status & PICOLCD_READY_FB)) {
+		spin_unlock_irqrestore(&data->lock, flags);
+		picolcd_fb_reset(data, 0);
+	} else {
+		spin_unlock_irqrestore(&data->lock, flags);
+	}
+
+	/*
+	 * Translate the XBM format screen_base into the format needed by the
+	 * PicoLCD. See display layout above.
+	 * Do this one tile after the other and push those tiles that changed.
+	 */
+	for (chip = 0; chip < 4; chip++)
+		for (tile = 0; tile < 8; tile++)
+			if (picolcd_fb_update_tile(data->fb_vbitmap,
+					data->fb_bitmap, chip, tile))
+				picolcd_fb_send_tile(data->hdev, chip, tile);
+}
+
+/* Stub to call the system default and update the image on the picoLCD */
+static void picolcd_fb_fillrect(struct fb_info *info,
+		const struct fb_fillrect *rect)
+{
+	if (!info->par)
+		return;
+	sys_fillrect(info, rect);
+
+	schedule_delayed_work(&info->deferred_work, 0);
+}
+
+/* Stub to call the system default and update the image on the picoLCD */
+static void picolcd_fb_copyarea(struct fb_info *info,
+		const struct fb_copyarea *area)
+{
+	if (!info->par)
+		return;
+	sys_copyarea(info, area);
+
+	schedule_delayed_work(&info->deferred_work, 0);
+}
+
+/* Stub to call the system default and update the image on the picoLCD */
+static void picolcd_fb_imageblit(struct fb_info *info, const struct fb_image *image)
+{
+	if (!info->par)
+		return;
+	sys_imageblit(info, image);
+
+	schedule_delayed_work(&info->deferred_work, 0);
+}
+
+/*
+ * this is the slow path from userspace. they can seek and write to
+ * the fb. it's inefficient to do anything less than a full screen draw
+ */
+static ssize_t picolcd_fb_write(struct fb_info *info, const char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	ssize_t ret;
+	if (!info->par)
+		return -ENODEV;
+	ret = fb_sys_write(info, buf, count, ppos);
+	if (ret >= 0)
+		schedule_delayed_work(&info->deferred_work, 0);
+	return ret;
+}
+
+static int picolcd_fb_blank(int blank, struct fb_info *info)
+{
+	if (!info->par)
+		return -ENODEV;
+	/* We let fb notification do this for us via lcd/backlight device */
+	return 0;
+}
+
+static void picolcd_fb_destroy(struct fb_info *info)
+{
+	struct picolcd_data *data = info->par;
+	info->par = NULL;
+	if (data)
+		data->fb_info = NULL;
+	fb_deferred_io_cleanup(info);
+	framebuffer_release(info);
+}
+
+/* Note this can't be const because of struct fb_info definition */
+static struct fb_ops picolcdfb_ops = {
+	.owner        = THIS_MODULE,
+	.fb_destroy   = picolcd_fb_destroy,
+	.fb_read      = fb_sys_read,
+	.fb_write     = picolcd_fb_write,
+	.fb_blank     = picolcd_fb_blank,
+	.fb_fillrect  = picolcd_fb_fillrect,
+	.fb_copyarea  = picolcd_fb_copyarea,
+	.fb_imageblit = picolcd_fb_imageblit,
+};
+
+
+/* Callback from deferred IO workqueue */
+static void picolcd_fb_deferred_io(struct fb_info *info, struct list_head *pagelist)
+{
+	picolcd_fb_update(info->par);
+}
+
+static const struct fb_deferred_io picolcd_fb_defio = {
+	.delay = HZ / PICOLCDFB_UPDATE_RATE_DEFAULT,
+	.deferred_io = picolcd_fb_deferred_io,
+};
+
+
+/*
+ * The "fb_update_rate" sysfs attribute
+ */
+static ssize_t picolcd_fb_update_rate_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct picolcd_data *data = dev_get_drvdata(dev);
+	unsigned fb_update_rate = data->fb_update_rate;
+
+	return snprintf(buf, PAGE_SIZE, "%u (1..%u)\n", fb_update_rate,
+			PICOLCDFB_UPDATE_RATE_LIMIT);
+}
+
+static ssize_t picolcd_fb_update_rate_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct picolcd_data *data = dev_get_drvdata(dev);
+	int i;
+	unsigned u;
+
+	if (count < 1 || count > 10)
+		return -EINVAL;
+
+	i = sscanf(buf, "%u", &u);
+	if (i != 1)
+		return -EINVAL;
+
+	if (u > PICOLCDFB_UPDATE_RATE_LIMIT)
+		return -ERANGE;
+	else if (u == 0)
+		u = PICOLCDFB_UPDATE_RATE_DEFAULT;
+
+	data->fb_update_rate = u;
+	data->fb_defio.delay = HZ / data->fb_update_rate;
+	return count;
+}
+
+static DEVICE_ATTR(fb_update_rate, 0666, picolcd_fb_update_rate_show,
+		picolcd_fb_update_rate_store);
+
+/* initialize Framebuffer device */
+static inline int picolcd_init_framebuffer(struct picolcd_data *data)
+{
+	struct device *dev = &data->hdev->dev;
+	struct fb_info *info = NULL;
+	int error = -ENOMEM;
+	u8 *fb_vbitmap = NULL;
+	u8 *fb_bitmap  = NULL;
+
+	fb_bitmap = vmalloc(PICOLCDFB_SIZE);
+	if (fb_bitmap == NULL) {
+		dev_err(dev, "can't get a free page for framebuffer\n");
+		goto err_nomem;
+	}
+
+	fb_vbitmap = kmalloc(PICOLCDFB_SIZE, GFP_KERNEL);
+	if (fb_vbitmap == NULL) {
+		dev_err(dev, "can't alloc vbitmap image buffer\n");
+		goto err_nomem;
+	}
+
+	data->fb_update_rate = PICOLCDFB_UPDATE_RATE_DEFAULT;
+	data->fb_defio = picolcd_fb_defio;
+	info = framebuffer_alloc(0, dev);
+	if (info == NULL) {
+		dev_err(dev, "failed to allocate a framebuffer\n");
+		goto err_nomem;
+	}
+
+	info->fbdefio = &data->fb_defio;
+	info->screen_base = (char __force __iomem *)fb_bitmap;
+	info->fbops = &picolcdfb_ops;
+	info->var = picolcdfb_var;
+	info->fix = picolcdfb_fix;
+	info->fix.smem_len = PICOLCDFB_SIZE;
+	info->par = data;
+	info->flags = FBINFO_FLAG_DEFAULT;
+
+	data->fb_vbitmap = fb_vbitmap;
+	data->fb_bitmap  = fb_bitmap;
+	error = picolcd_fb_reset(data, 1);
+	if (error) {
+		dev_err(dev, "failed to configure display\n");
+		goto err_cleanup;
+	}
+	error = sysfs_create_file(&dev->kobj, &dev_attr_fb_update_rate.attr);
+	if (error) {
+		dev_err(dev, "failed to create sysfs attributes\n");
+		goto err_cleanup;
+	}
+	data->fb_info    = info;
+	error = register_framebuffer(info);
+	if (error) {
+		dev_err(dev, "failed to register framebuffer\n");
+		goto err_sysfs;
+	}
+	fb_deferred_io_init(info);
+	/* schedule first output of framebuffer */
+	schedule_delayed_work(&info->deferred_work, 0);
+	return 0;
+
+err_sysfs:
+	sysfs_remove_file(&dev->kobj, &dev_attr_fb_update_rate.attr);
+err_cleanup:
+	data->fb_vbitmap = NULL;
+	data->fb_bitmap  = NULL;
+	data->fb_info    = NULL;
+
+err_nomem:
+	framebuffer_release(info);
+	vfree(fb_bitmap);
+	kfree(fb_vbitmap);
+	return error;
+}
+
+static void picolcd_exit_framebuffer(struct picolcd_data *data)
+{
+	struct fb_info *info = data->fb_info;
+	u8 *fb_vbitmap = data->fb_vbitmap;
+	u8 *fb_bitmap  = data->fb_bitmap;
+
+	if (!info)
+		return;
+
+	data->fb_vbitmap = NULL;
+	data->fb_bitmap  = NULL;
+	data->fb_info    = NULL;
+	sysfs_remove_file(&(data->hdev->dev.kobj), &dev_attr_fb_update_rate.attr);
+	fb_deferred_io_cleanup(info);
+	unregister_framebuffer(info);
+	vfree(fb_bitmap);
+	kfree(fb_vbitmap);
+}
+
+
+#else
+static inline int picolcd_fb_reset(struct picolcd_data *data, int clear)
+{
+	return 0;
+}
+static inline int picolcd_init_framebuffer(struct picolcd_data *data)
+{
+	return 0;
+}
+static void picolcd_exit_framebuffer(struct picolcd_data *data)
+{
+}
+#endif /* CONFIG_FB */
+
 /*
  * input class device
  */
@@ -337,6 +775,11 @@ static int picolcd_reset(struct hid_device *hdev)
 		return -EBUSY;
 	}
 
+#if defined(CONFIG_FB) || defined(CONFIG_FB_MODULE)
+	if (data->fb_info)
+		schedule_delayed_work(&data->fb_info->deferred_work, 0);
+#endif /* CONFIG_FB */
+
 	return 0;
 }
 
@@ -937,6 +1380,9 @@ static int picolcd_reset_resume(struct hid_device *hdev)
 	ret = picolcd_reset(hdev);
 	if (ret)
 		dbg_hid(PICOLCD_NAME " resetting our device failed: %d\n", ret);
+	ret = picolcd_fb_reset(hid_get_drvdata(hdev), 0);
+	if (ret)
+		dbg_hid(PICOLCD_NAME " restoring framebuffer content failed: %d\n", ret);
 	return 0;
 }
 #endif
@@ -1053,6 +1499,11 @@ static inline int picolcd_probe_lcd(struct hid_device *hdev, struct picolcd_data
 	if (error)
 		goto err;
 
+	/* Set up the framebuffer device */
+	error = picolcd_init_framebuffer(data);
+	if (error)
+		goto err;
+
 #ifdef CONFIG_DEBUG_FS
 	report = picolcd_out_report(REPORT_READ_MEMORY, hdev);
 	if (report && report->maxfield == 1 && report->field[0]->report_size == 8)
@@ -1062,6 +1513,7 @@ static inline int picolcd_probe_lcd(struct hid_device *hdev, struct picolcd_data
 #endif
 	return 0;
 err:
+	picolcd_exit_framebuffer(data);
 	picolcd_exit_cir(data);
 	picolcd_exit_keys(data);
 	return error;
@@ -1200,6 +1652,8 @@ static void picolcd_remove(struct hid_device *hdev)
 	hdev->ll_driver->close(hdev);
 	hid_hw_stop(hdev);
 
+	/* Clean up the framebuffer */
+	picolcd_exit_framebuffer(data);
 	/* Cleanup input */
 	picolcd_exit_cir(data);
 	picolcd_exit_keys(data);
-- 
1.6.4.4

