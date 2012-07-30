Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab2G3Tjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:39:39 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:53140 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab2G3Tjd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:39:33 -0400
Date: Mon, 30 Jul 2012 21:38:57 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Cc: Jaya Kumar <jayalk@intworks.biz>, linux-fbdev@vger.kernel.org
Subject: [PATCH 5/7] HID: picoLCD: Improve unplug handling
Message-ID: <20120730213857.75d34cf8@neptune.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
References: <20120730213656.0a9f6d30@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop earlier attempting to submit new reports/URBs (though locking and
usbhid still prevents to bail out early enough to not produce multiple
  hid-picolcd 0003:04D8:C002.0003: usb_submit_urb(out) failed: -19
messages in kernel log.

Strengthen framebuffer removal to be less racy, though quick
bind/unbind sequences triggered via sysfs still trigger weird behavior:
- either SLAB corruptions
  Seems related to fbdefio
- immediate system reboot
  Unexplained as there is no explaining output on any console, not even
  serial console.
(note: picoLCD is hosting fbcon in both cases, but manual plug/unplug
seems too slow to trigger madness)

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/hid-picolcd_backlight.c |    3 +-
 drivers/hid/hid-picolcd_core.c      |   21 ++++++++++++-----
 drivers/hid/hid-picolcd_fb.c        |   41 +++++++++++++++++++++-------------
 drivers/hid/hid-picolcd_lcd.c       |    3 +-
 drivers/hid/hid-picolcd_leds.c      |    3 +-
 5 files changed, 46 insertions(+), 25 deletions(-)

diff --git a/drivers/hid/hid-picolcd_backlight.c b/drivers/hid/hid-picolcd_backlight.c
index cd1ccd7..b91f309 100644
--- a/drivers/hid/hid-picolcd_backlight.c
+++ b/drivers/hid/hid-picolcd_backlight.c
@@ -45,7 +45,8 @@ static int picolcd_set_brightness(struct backlight_device *bdev)
 	data->lcd_power      = bdev->props.power;
 	spin_lock_irqsave(&data->lock, flags);
 	hid_set_field(report->field[0], 0, data->lcd_power == FB_BLANK_UNBLANK ? data->lcd_brightness : 0);
-	usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
+	if (!(data->status & PICOLCD_FAILED))
+		usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
 	spin_unlock_irqrestore(&data->lock, flags);
 	return 0;
 }
diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
index 8d5d341..2d7ef68 100644
--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -105,12 +105,17 @@ struct picolcd_pending *picolcd_send_and_wait(struct hid_device *hdev,
 			hid_set_field(report->field[i], j, k < size ? raw_data[k] : 0);
 			k++;
 		}
-	data->pending = work;
-	usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
-	spin_unlock_irqrestore(&data->lock, flags);
-	wait_for_completion_interruptible_timeout(&work->ready, HZ*2);
-	spin_lock_irqsave(&data->lock, flags);
-	data->pending = NULL;
+	if (data->status & PICOLCD_FAILED) {
+		kfree(work);
+		work = NULL;
+	} else {
+		data->pending = work;
+		usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
+		spin_unlock_irqrestore(&data->lock, flags);
+		wait_for_completion_interruptible_timeout(&work->ready, HZ*2);
+		spin_lock_irqsave(&data->lock, flags);
+		data->pending = NULL;
+	}
 	spin_unlock_irqrestore(&data->lock, flags);
 	mutex_unlock(&data->mutex);
 	return work;
@@ -235,6 +240,10 @@ int picolcd_reset(struct hid_device *hdev)
 
 	/* perform the reset */
 	hid_set_field(report->field[0], 0, 1);
+	if (data->status & PICOLCD_FAILED) {
+		spin_unlock_irqrestore(&data->lock, flags);
+		return -ENODEV;
+	}
 	usbhid_submit_report(hdev, report, USB_DIR_OUT);
 	spin_unlock_irqrestore(&data->lock, flags);
 
diff --git a/drivers/hid/hid-picolcd_fb.c b/drivers/hid/hid-picolcd_fb.c
index 602786c..4d8e22c 100644
--- a/drivers/hid/hid-picolcd_fb.c
+++ b/drivers/hid/hid-picolcd_fb.c
@@ -226,13 +226,16 @@ int picolcd_fb_reset(struct picolcd_data *data, int clear)
 }
 
 /* Update fb_vbitmap from the screen_base and send changed tiles to device */
-static void picolcd_fb_update(struct picolcd_data *data)
+static void picolcd_fb_update(struct fb_info *info)
 {
 	int chip, tile, n;
 	unsigned long flags;
+	struct picolcd_data *data;
 
+	mutex_lock(&info->lock);
+	data = info->par;
 	if (!data)
-		return;
+		goto out;
 
 	spin_lock_irqsave(&data->lock, flags);
 	if (!(data->status & PICOLCD_READY_FB)) {
@@ -256,17 +259,31 @@ static void picolcd_fb_update(struct picolcd_data *data)
 					data->fb_bitmap, data->fb_bpp, chip, tile) ||
 				data->fb_force) {
 				n += 2;
-				if (data->status & PICOLCD_FAILED)
-					return; /* device lost! */
 				if (n >= HID_OUTPUT_FIFO_SIZE / 2) {
+					mutex_unlock(&info->lock);
 					usbhid_wait_io(data->hdev);
+					mutex_lock(&info->lock);
+					data = info->par;
+					if (!data)
+						goto out;
+					spin_lock_irqsave(&data->lock, flags);
+					if (data->status & PICOLCD_FAILED) {
+						spin_unlock_irqrestore(&data->lock, flags);
+						goto out;
+					}
+					spin_unlock_irqrestore(&data->lock, flags);
 					n = 0;
 				}
 				picolcd_fb_send_tile(data->hdev, chip, tile);
 			}
 	data->fb_force = false;
-	if (n)
+	if (n) {
+		mutex_unlock(&info->lock);
 		usbhid_wait_io(data->hdev);
+		return;
+	}
+out:
+	mutex_unlock(&info->lock);
 }
 
 /* Stub to call the system default and update the image on the picoLCD */
@@ -327,17 +344,12 @@ static int picolcd_fb_blank(int blank, struct fb_info *info)
 
 static void picolcd_fb_destroy(struct fb_info *info)
 {
-	struct picolcd_data *data;
-
 	/* make sure no work is deferred */
-	cancel_delayed_work_sync(&info->deferred_work);
-	data = info->par;
-	info->par = NULL;
-	if (data)
-		data->fb_info = NULL;
+	fb_deferred_io_cleanup(info);
 
 	vfree((u8 *)info->fix.smem_start);
 	framebuffer_release(info);
+	printk(KERN_DEBUG "picolcd_fb_destroy(%p)\n", info);
 }
 
 static int picolcd_fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
@@ -425,7 +437,7 @@ static struct fb_ops picolcdfb_ops = {
 /* Callback from deferred IO workqueue */
 static void picolcd_fb_deferred_io(struct fb_info *info, struct list_head *pagelist)
 {
-	picolcd_fb_update(info->par);
+	picolcd_fb_update(info);
 }
 
 static const struct fb_deferred_io picolcd_fb_defio = {
@@ -582,10 +594,7 @@ void picolcd_exit_framebuffer(struct picolcd_data *data)
 		return;
 
 	device_remove_file(&data->hdev->dev, &dev_attr_fb_update_rate);
-	mutex_lock(&info->lock);
-	fb_deferred_io_cleanup(info);
 	info->par = NULL;
-	mutex_unlock(&info->lock);
 	unregister_framebuffer(info);
 	data->fb_vbitmap = NULL;
 	data->fb_bitmap  = NULL;
diff --git a/drivers/hid/hid-picolcd_lcd.c b/drivers/hid/hid-picolcd_lcd.c
index 64a067f..2d0ddc5 100644
--- a/drivers/hid/hid-picolcd_lcd.c
+++ b/drivers/hid/hid-picolcd_lcd.c
@@ -47,7 +47,8 @@ static int picolcd_set_contrast(struct lcd_device *ldev, int contrast)
 	data->lcd_contrast = contrast & 0x0ff;
 	spin_lock_irqsave(&data->lock, flags);
 	hid_set_field(report->field[0], 0, data->lcd_contrast);
-	usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
+	if (!(data->status & PICOLCD_FAILED))
+		usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
 	spin_unlock_irqrestore(&data->lock, flags);
 	return 0;
 }
diff --git a/drivers/hid/hid-picolcd_leds.c b/drivers/hid/hid-picolcd_leds.c
index 5573cd8..28cb6a4 100644
--- a/drivers/hid/hid-picolcd_leds.c
+++ b/drivers/hid/hid-picolcd_leds.c
@@ -54,7 +54,8 @@ void picolcd_leds_set(struct picolcd_data *data)
 
 	spin_lock_irqsave(&data->lock, flags);
 	hid_set_field(report->field[0], 0, data->led_state);
-	usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
+	if (!(data->status & PICOLCD_FAILED))
+		usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
 	spin_unlock_irqrestore(&data->lock, flags);
 }
 
-- 
1.7.8.6

