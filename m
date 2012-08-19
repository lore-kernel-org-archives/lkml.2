Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab2HSRcw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 13:32:52 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:59761 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab2HSRct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 13:32:49 -0400
Date: Sun, 19 Aug 2012 19:32:04 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: [PATCH 2/6] HID: picoLCD: rework hid-fbdev interaction
Message-ID: <20120819193204.75a35508@neptune.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
References: <20120819192859.74136bb0@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out all FB related data out of struct picolcd_data into a struct
picolcd_fb_data that is allocated with fb_info. This way fb_info may
cleanly outlive struct picolcd_data for as long as needed for its last
user to drop his reference.

Access to struct picolcd_data is now protected with struct
picolcd_fb_data's lock and tile  update reports are only generated
while picolcd_fbdata->picolcd is not NULL and is not marked as failed
(which indicates unplug in progress).

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/hid-picolcd.h    |   19 +++-
 drivers/hid/hid-picolcd_fb.c |  216 ++++++++++++++++++++++--------------------
 2 files changed, 126 insertions(+), 109 deletions(-)

diff --git a/drivers/hid/hid-picolcd.h b/drivers/hid/hid-picolcd.h
index 9200be1..dc4c795 100644
--- a/drivers/hid/hid-picolcd.h
+++ b/drivers/hid/hid-picolcd.h
@@ -90,11 +90,6 @@ struct picolcd_data {
 
 #ifdef CONFIG_HID_PICOLCD_FB
 	/* Framebuffer stuff */
-	u8 fb_update_rate;
-	u8 fb_bpp;
-	u8 fb_force;
-	u8 *fb_vbitmap;		/* local copy of what was sent to PicoLCD */
-	u8 *fb_bitmap;		/* framebuffer */
 	struct fb_info *fb_info;
 #endif /* CONFIG_HID_PICOLCD_FB */
 #ifdef CONFIG_HID_PICOLCD_LCD
@@ -119,9 +114,21 @@ struct picolcd_data {
 	int status;
 #define PICOLCD_BOOTLOADER 1
 #define PICOLCD_FAILED 2
-#define PICOLCD_READY_FB 4
 };
 
+#ifdef CONFIG_HID_PICOLCD_FB
+struct picolcd_fb_data {
+	/* Framebuffer stuff */
+	spinlock_t lock;
+	struct picolcd_data *picolcd;
+	u8 update_rate;
+	u8 bpp;
+	u8 force;
+	u8 ready;
+	u8 *vbitmap;		/* local copy of what was sent to PicoLCD */
+	u8 *bitmap;		/* framebuffer */
+};
+#endif /* CONFIG_HID_PICOLCD_FB */
 
 /* Find a given report */
 #define picolcd_in_report(id, dev) picolcd_report(id, dev, HID_INPUT_REPORT)
diff --git a/drivers/hid/hid-picolcd_fb.c b/drivers/hid/hid-picolcd_fb.c
index 4d8e22c..5905bbd 100644
--- a/drivers/hid/hid-picolcd_fb.c
+++ b/drivers/hid/hid-picolcd_fb.c
@@ -98,19 +98,26 @@ static const struct fb_var_screeninfo picolcdfb_var = {
 };
 
 /* Send a given tile to PicoLCD */
-static int picolcd_fb_send_tile(struct hid_device *hdev, int chip, int tile)
+static int picolcd_fb_send_tile(struct picolcd_data *data, u8 *vbitmap,
+		int chip, int tile)
 {
-	struct picolcd_data *data = hid_get_drvdata(hdev);
-	struct hid_report *report1 = picolcd_out_report(REPORT_LCD_CMD_DATA, hdev);
-	struct hid_report *report2 = picolcd_out_report(REPORT_LCD_DATA, hdev);
+	struct hid_report *report1, *report2;
 	unsigned long flags;
 	u8 *tdata;
 	int i;
 
-	if (!report1 || report1->maxfield != 1 || !report2 || report2->maxfield != 1)
+	report1 = picolcd_out_report(REPORT_LCD_CMD_DATA, data->hdev);
+	if (!report1 || report1->maxfield != 1)
+		return -ENODEV;
+	report2 = picolcd_out_report(REPORT_LCD_DATA, data->hdev);
+	if (!report2 || report2->maxfield != 1)
 		return -ENODEV;
 
 	spin_lock_irqsave(&data->lock, flags);
+	if ((data->status & PICOLCD_FAILED)) {
+		spin_unlock_irqrestore(&data->lock, flags);
+		return -ENODEV;
+	}
 	hid_set_field(report1->field[0],  0, chip << 2);
 	hid_set_field(report1->field[0],  1, 0x02);
 	hid_set_field(report1->field[0],  2, 0x00);
@@ -128,7 +135,7 @@ static int picolcd_fb_send_tile(struct hid_device *hdev, int chip, int tile)
 	hid_set_field(report2->field[0],  2, 0x00);
 	hid_set_field(report2->field[0],  3,   32);
 
-	tdata = data->fb_vbitmap + (tile * 4 + chip) * 64;
+	tdata = vbitmap + (tile * 4 + chip) * 64;
 	for (i = 0; i < 64; i++)
 		if (i < 32)
 			hid_set_field(report1->field[0], 11 + i, tdata[i]);
@@ -189,6 +196,7 @@ void picolcd_fb_refresh(struct picolcd_data *data)
 int picolcd_fb_reset(struct picolcd_data *data, int clear)
 {
 	struct hid_report *report = picolcd_out_report(REPORT_LCD_CMD, data->hdev);
+	struct picolcd_fb_data *fbdata = data->fb_info->par;
 	int i, j;
 	unsigned long flags;
 	static const u8 mapcmd[8] = { 0x00, 0x02, 0x00, 0x64, 0x3f, 0x00, 0x64, 0xc0 };
@@ -207,20 +215,19 @@ int picolcd_fb_reset(struct picolcd_data *data, int clear)
 				hid_set_field(report->field[0], j, 0);
 		usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
 	}
-
-	data->status |= PICOLCD_READY_FB;
 	spin_unlock_irqrestore(&data->lock, flags);
 
-	if (data->fb_bitmap) {
-		if (clear) {
-			memset(data->fb_vbitmap, 0, PICOLCDFB_SIZE);
-			memset(data->fb_bitmap, 0, PICOLCDFB_SIZE*data->fb_bpp);
-		}
-		data->fb_force = 1;
+	if (clear) {
+		memset(fbdata->vbitmap, 0, PICOLCDFB_SIZE);
+		memset(fbdata->bitmap, 0, PICOLCDFB_SIZE*fbdata->bpp);
 	}
+	fbdata->force = 1;
 
 	/* schedule first output of framebuffer */
-	picolcd_fb_refresh(data);
+	if (fbdata->ready)
+		schedule_delayed_work(&data->fb_info->deferred_work, 0);
+	else
+		fbdata->ready = 1;
 
 	return 0;
 }
@@ -230,20 +237,15 @@ static void picolcd_fb_update(struct fb_info *info)
 {
 	int chip, tile, n;
 	unsigned long flags;
+	struct picolcd_fb_data *fbdata = info->par;
 	struct picolcd_data *data;
 
 	mutex_lock(&info->lock);
-	data = info->par;
-	if (!data)
-		goto out;
 
-	spin_lock_irqsave(&data->lock, flags);
-	if (!(data->status & PICOLCD_READY_FB)) {
-		spin_unlock_irqrestore(&data->lock, flags);
-		picolcd_fb_reset(data, 0);
-	} else {
-		spin_unlock_irqrestore(&data->lock, flags);
-	}
+	spin_lock_irqsave(&fbdata->lock, flags);
+	if (!fbdata->ready && fbdata->picolcd)
+		picolcd_fb_reset(fbdata->picolcd, 0);
+	spin_unlock_irqrestore(&fbdata->lock, flags);
 
 	/*
 	 * Translate the framebuffer into the format needed by the PicoLCD.
@@ -254,32 +256,38 @@ static void picolcd_fb_update(struct fb_info *info)
 	 */
 	n = 0;
 	for (chip = 0; chip < 4; chip++)
-		for (tile = 0; tile < 8; tile++)
-			if (picolcd_fb_update_tile(data->fb_vbitmap,
-					data->fb_bitmap, data->fb_bpp, chip, tile) ||
-				data->fb_force) {
-				n += 2;
-				if (n >= HID_OUTPUT_FIFO_SIZE / 2) {
-					mutex_unlock(&info->lock);
-					usbhid_wait_io(data->hdev);
-					mutex_lock(&info->lock);
-					data = info->par;
-					if (!data)
-						goto out;
-					spin_lock_irqsave(&data->lock, flags);
-					if (data->status & PICOLCD_FAILED) {
-						spin_unlock_irqrestore(&data->lock, flags);
-						goto out;
-					}
-					spin_unlock_irqrestore(&data->lock, flags);
-					n = 0;
-				}
-				picolcd_fb_send_tile(data->hdev, chip, tile);
+		for (tile = 0; tile < 8; tile++) {
+			if (!fbdata->force && !picolcd_fb_update_tile(
+					fbdata->vbitmap, fbdata->bitmap,
+					fbdata->bpp, chip, tile))
+				continue;
+			n += 2;
+			if (n >= HID_OUTPUT_FIFO_SIZE / 2) {
+				spin_lock_irqsave(&fbdata->lock, flags);
+				data = fbdata->picolcd;
+				spin_unlock_irqrestore(&fbdata->lock, flags);
+				mutex_unlock(&info->lock);
+				if (!data)
+					return;
+				usbhid_wait_io(data->hdev);
+				mutex_lock(&info->lock);
+				n = 0;
 			}
-	data->fb_force = false;
+			spin_lock_irqsave(&fbdata->lock, flags);
+			data = fbdata->picolcd;
+			spin_unlock_irqrestore(&fbdata->lock, flags);
+			if (!data || picolcd_fb_send_tile(data,
+					fbdata->vbitmap, chip, tile))
+				goto out;
+		}
+	fbdata->force = false;
 	if (n) {
+		spin_lock_irqsave(&fbdata->lock, flags);
+		data = fbdata->picolcd;
+		spin_unlock_irqrestore(&fbdata->lock, flags);
 		mutex_unlock(&info->lock);
-		usbhid_wait_io(data->hdev);
+		if (data)
+			usbhid_wait_io(data->hdev);
 		return;
 	}
 out:
@@ -336,20 +344,22 @@ static ssize_t picolcd_fb_write(struct fb_info *info, const char __user *buf,
 
 static int picolcd_fb_blank(int blank, struct fb_info *info)
 {
-	if (!info->par)
-		return -ENODEV;
 	/* We let fb notification do this for us via lcd/backlight device */
 	return 0;
 }
 
 static void picolcd_fb_destroy(struct fb_info *info)
 {
+	struct picolcd_fb_data *fbdata = info->par;
+
 	/* make sure no work is deferred */
 	fb_deferred_io_cleanup(info);
 
+	/* No thridparty should ever unregister our framebuffer! */
+	WARN_ON(fbdata->picolcd != NULL);
+
 	vfree((u8 *)info->fix.smem_start);
 	framebuffer_release(info);
-	printk(KERN_DEBUG "picolcd_fb_destroy(%p)\n", info);
 }
 
 static int picolcd_fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
@@ -376,17 +386,15 @@ static int picolcd_fb_check_var(struct fb_var_screeninfo *var, struct fb_info *i
 
 static int picolcd_set_par(struct fb_info *info)
 {
-	struct picolcd_data *data = info->par;
+	struct picolcd_fb_data *fbdata = info->par;
 	u8 *tmp_fb, *o_fb;
-	if (!data)
-		return -ENODEV;
-	if (info->var.bits_per_pixel == data->fb_bpp)
+	if (info->var.bits_per_pixel == fbdata->bpp)
 		return 0;
 	/* switch between 1/8 bit depths */
 	if (info->var.bits_per_pixel != 1 && info->var.bits_per_pixel != 8)
 		return -EINVAL;
 
-	o_fb   = data->fb_bitmap;
+	o_fb   = fbdata->bitmap;
 	tmp_fb = kmalloc(PICOLCDFB_SIZE*info->var.bits_per_pixel, GFP_KERNEL);
 	if (!tmp_fb)
 		return -ENOMEM;
@@ -415,7 +423,7 @@ static int picolcd_set_par(struct fb_info *info)
 	}
 
 	kfree(tmp_fb);
-	data->fb_bpp      = info->var.bits_per_pixel;
+	fbdata->bpp = info->var.bits_per_pixel;
 	return 0;
 }
 
@@ -453,7 +461,8 @@ static ssize_t picolcd_fb_update_rate_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct picolcd_data *data = dev_get_drvdata(dev);
-	unsigned i, fb_update_rate = data->fb_update_rate;
+	struct picolcd_fb_data *fbdata = data->fb_info->par;
+	unsigned i, fb_update_rate = fbdata->update_rate;
 	size_t ret = 0;
 
 	for (i = 1; i <= PICOLCDFB_UPDATE_RATE_LIMIT; i++)
@@ -472,6 +481,7 @@ static ssize_t picolcd_fb_update_rate_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct picolcd_data *data = dev_get_drvdata(dev);
+	struct picolcd_fb_data *fbdata = data->fb_info->par;
 	int i;
 	unsigned u;
 
@@ -487,8 +497,8 @@ static ssize_t picolcd_fb_update_rate_store(struct device *dev,
 	else if (u == 0)
 		u = PICOLCDFB_UPDATE_RATE_DEFAULT;
 
-	data->fb_update_rate = u;
-	data->fb_info->fbdefio->delay = HZ / data->fb_update_rate;
+	fbdata->update_rate = u;
+	data->fb_info->fbdefio->delay = HZ / fbdata->update_rate;
 	return count;
 }
 
@@ -500,30 +510,18 @@ int picolcd_init_framebuffer(struct picolcd_data *data)
 {
 	struct device *dev = &data->hdev->dev;
 	struct fb_info *info = NULL;
+	struct picolcd_fb_data *fbdata = NULL;
 	int i, error = -ENOMEM;
-	u8 *fb_vbitmap = NULL;
-	u8 *fb_bitmap  = NULL;
 	u32 *palette;
 
-	fb_bitmap = vmalloc(PICOLCDFB_SIZE*8);
-	if (fb_bitmap == NULL) {
-		dev_err(dev, "can't get a free page for framebuffer\n");
-		goto err_nomem;
-	}
-
-	fb_vbitmap = kmalloc(PICOLCDFB_SIZE, GFP_KERNEL);
-	if (fb_vbitmap == NULL) {
-		dev_err(dev, "can't alloc vbitmap image buffer\n");
-		goto err_nomem;
-	}
-
-	data->fb_update_rate = PICOLCDFB_UPDATE_RATE_DEFAULT;
 	/* The extra memory is:
 	 * - 256*u32 for pseudo_palette
 	 * - struct fb_deferred_io
 	 */
 	info = framebuffer_alloc(256 * sizeof(u32) +
-			sizeof(struct fb_deferred_io), dev);
+			sizeof(struct fb_deferred_io) +
+			sizeof(struct picolcd_fb_data) +
+			PICOLCDFB_SIZE, dev);
 	if (info == NULL) {
 		dev_err(dev, "failed to allocate a framebuffer\n");
 		goto err_nomem;
@@ -531,74 +529,86 @@ int picolcd_init_framebuffer(struct picolcd_data *data)
 
 	info->fbdefio = info->par;
 	*info->fbdefio = picolcd_fb_defio;
-	palette  = info->par + sizeof(struct fb_deferred_io);
+	info->par += sizeof(struct fb_deferred_io);
+	palette = info->par;
+	info->par += 256 * sizeof(u32);
 	for (i = 0; i < 256; i++)
 		palette[i] = i > 0 && i < 16 ? 0xff : 0;
 	info->pseudo_palette = palette;
-	info->screen_base = (char __force __iomem *)fb_bitmap;
 	info->fbops = &picolcdfb_ops;
 	info->var = picolcdfb_var;
 	info->fix = picolcdfb_fix;
 	info->fix.smem_len   = PICOLCDFB_SIZE*8;
-	info->fix.smem_start = (unsigned long)fb_bitmap;
-	info->par = data;
 	info->flags = FBINFO_FLAG_DEFAULT;
 
-	data->fb_vbitmap = fb_vbitmap;
-	data->fb_bitmap  = fb_bitmap;
-	data->fb_bpp     = picolcdfb_var.bits_per_pixel;
+	fbdata = info->par;
+	spin_lock_init(&fbdata->lock);
+	fbdata->picolcd = data;
+	fbdata->update_rate = PICOLCDFB_UPDATE_RATE_DEFAULT;
+	fbdata->bpp     = picolcdfb_var.bits_per_pixel;
+	fbdata->force   = 1;
+	fbdata->vbitmap = info->par + sizeof(struct picolcd_fb_data);
+	fbdata->bitmap  = vmalloc(PICOLCDFB_SIZE*8);
+	if (fbdata->bitmap == NULL) {
+		dev_err(dev, "can't get a free page for framebuffer\n");
+		goto err_nomem;
+	}
+	info->screen_base = (char __force __iomem *)fbdata->bitmap;
+	info->fix.smem_start = (unsigned long)fbdata->bitmap;
+	memset(fbdata->vbitmap, 0xff, PICOLCDFB_SIZE);
+	data->fb_info = info;
+
 	error = picolcd_fb_reset(data, 1);
 	if (error) {
 		dev_err(dev, "failed to configure display\n");
 		goto err_cleanup;
 	}
+
 	error = device_create_file(dev, &dev_attr_fb_update_rate);
 	if (error) {
 		dev_err(dev, "failed to create sysfs attributes\n");
 		goto err_cleanup;
 	}
+
 	fb_deferred_io_init(info);
-	data->fb_info    = info;
 	error = register_framebuffer(info);
 	if (error) {
 		dev_err(dev, "failed to register framebuffer\n");
 		goto err_sysfs;
 	}
-	/* schedule first output of framebuffer */
-	data->fb_force = 1;
-	schedule_delayed_work(&info->deferred_work, 0);
 	return 0;
 
 err_sysfs:
-	fb_deferred_io_cleanup(info);
 	device_remove_file(dev, &dev_attr_fb_update_rate);
+	fb_deferred_io_cleanup(info);
 err_cleanup:
-	data->fb_vbitmap = NULL;
-	data->fb_bitmap  = NULL;
-	data->fb_bpp     = 0;
 	data->fb_info    = NULL;
 
 err_nomem:
+	if (fbdata)
+		vfree(fbdata->bitmap);
 	framebuffer_release(info);
-	vfree(fb_bitmap);
-	kfree(fb_vbitmap);
 	return error;
 }
 
 void picolcd_exit_framebuffer(struct picolcd_data *data)
 {
 	struct fb_info *info = data->fb_info;
-	u8 *fb_vbitmap = data->fb_vbitmap;
-
-	if (!info)
-		return;
+	struct picolcd_fb_data *fbdata = info->par;
+	unsigned long flags;
 
 	device_remove_file(&data->hdev->dev, &dev_attr_fb_update_rate);
-	info->par = NULL;
+
+	/* disconnect framebuffer from HID dev */
+	spin_lock_irqsave(&fbdata->lock, flags);
+	fbdata->picolcd = NULL;
+	spin_unlock_irqrestore(&fbdata->lock, flags);
+
+	/* make sure there is no running update - thus that fbdata->picolcd
+	 * once obtained under lock is guaranteed not to get free() under
+	 * the feet of the deferred work */
+	flush_delayed_work_sync(&info->deferred_work);
+
+	data->fb_info = NULL;
 	unregister_framebuffer(info);
-	data->fb_vbitmap = NULL;
-	data->fb_bitmap  = NULL;
-	data->fb_bpp     = 0;
-	data->fb_info    = NULL;
-	kfree(fb_vbitmap);
 }
-- 
1.7.8.6

