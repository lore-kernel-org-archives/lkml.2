Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab0E3LKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 07:10:18 -0400
Received: from legolas.restena.lu ([158.64.1.34]:48427 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab0E3LKQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 07:10:16 -0400
Date: Sun, 30 May 2010 13:09:45 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jaya Kumar <jayakumar.lkml@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Patch] HID: Fix PicoLCD to allow it to run fbcon and handle unplug
 while FB in use
Message-ID: <20100530130945.5c03797f@neptune.home>
In-Reply-To: <20100526215829.28a4aa47@neptune.home>
References: <20100509184911.3f136b77@neptune.home>
	<AANLkTik0EkPYKdnhrpF7yK6eXIrHMsNYrzSC6tyeBR0P@mail.gmail.com>
	<20100510080047.5adade6f@pluto.restena.lu>
	<20100526215829.28a4aa47@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes multiple issues related to FB use:
- NULL-pointer dereference if fbcon wants to use our FB on
  8-bpp framebuffer.
- Getting new vmalloc()ed framebuffer on each depth change
  causes pain if the FB was mmap()ed by userspace, so allocate
  biggest FB needed and just convert its content on depth change
  to avoid the issue
- When FB is in use and our device gets unplugged, wait until
  last user stops using FB before we free fb_info and framebuffer
  (via deferred work)

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---

This should fix all issues I've seen running fbcon and userspace fb
applications on top of picolcd, even when it gets unplugged.

I would appreciate if a second pair of eyes could could review the
locking and releasing of FB resources (I've tested it on UP, currently
no SMP system available for testing)

Thanks,
Bruno



 drivers/hid/hid-picolcd.c |  201 +++++++++++++++++++++++++++++++++++++--------
 1 files changed, 167 insertions(+), 34 deletions(-)

diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index 95253b3..1a0dacc 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -127,6 +127,26 @@ static const struct fb_var_screeninfo picolcdfb_var = {
 	.height         = 26,
 	.bits_per_pixel = 1,
 	.grayscale      = 1,
+	.red            = {
+		.offset = 0,
+		.length = 1,
+		.msb_right = 0,
+	},
+	.green          = {
+		.offset = 0,
+		.length = 1,
+		.msb_right = 0,
+	},
+	.blue           = {
+		.offset = 0,
+		.length = 1,
+		.msb_right = 0,
+	},
+	.transp         = {
+		.offset = 0,
+		.length = 0,
+		.msb_right = 0,
+	},
 };
 #endif /* CONFIG_HID_PICOLCD_FB */
 
@@ -188,6 +208,7 @@ struct picolcd_data {
 	/* Framebuffer stuff */
 	u8 fb_update_rate;
 	u8 fb_bpp;
+	u8 fb_force;
 	u8 *fb_vbitmap;		/* local copy of what was sent to PicoLCD */
 	u8 *fb_bitmap;		/* framebuffer */
 	struct fb_info *fb_info;
@@ -346,7 +367,7 @@ static int picolcd_fb_update_tile(u8 *vbitmap, const u8 *bitmap, int bpp,
 			const u8 *bdata = bitmap + tile * 256 + chip * 8 + b * 32;
 			for (i = 0; i < 64; i++) {
 				tdata[i] <<= 1;
-				tdata[i] |= (bdata[i/8] >> (7 - i % 8)) & 0x01;
+				tdata[i] |= (bdata[i/8] >> (i % 8)) & 0x01;
 			}
 		}
 	} else if (bpp == 8) {
@@ -399,13 +420,10 @@ static int picolcd_fb_reset(struct picolcd_data *data, int clear)
 
 	if (data->fb_bitmap) {
 		if (clear) {
-			memset(data->fb_vbitmap, 0xff, PICOLCDFB_SIZE);
+			memset(data->fb_vbitmap, 0, PICOLCDFB_SIZE);
 			memset(data->fb_bitmap, 0, PICOLCDFB_SIZE*data->fb_bpp);
-		} else {
-			/* invert 1 byte in each tile to force resend */
-			for (i = 0; i < PICOLCDFB_SIZE; i += 64)
-				data->fb_vbitmap[i] = ~data->fb_vbitmap[i];
 		}
+		data->fb_force = 1;
 	}
 
 	/* schedule first output of framebuffer */
@@ -421,6 +439,9 @@ static void picolcd_fb_update(struct picolcd_data *data)
 	int chip, tile, n;
 	unsigned long flags;
 
+	if (!data)
+		return;
+
 	spin_lock_irqsave(&data->lock, flags);
 	if (!(data->status & PICOLCD_READY_FB)) {
 		spin_unlock_irqrestore(&data->lock, flags);
@@ -440,14 +461,18 @@ static void picolcd_fb_update(struct picolcd_data *data)
 	for (chip = 0; chip < 4; chip++)
 		for (tile = 0; tile < 8; tile++)
 			if (picolcd_fb_update_tile(data->fb_vbitmap,
-					data->fb_bitmap, data->fb_bpp, chip, tile)) {
+					data->fb_bitmap, data->fb_bpp, chip, tile) ||
+				data->fb_force) {
 				n += 2;
+				if (!data->fb_info->par)
+					return; /* device lost! */
 				if (n >= HID_OUTPUT_FIFO_SIZE / 2) {
 					usbhid_wait_io(data->hdev);
 					n = 0;
 				}
 				picolcd_fb_send_tile(data->hdev, chip, tile);
 			}
+	data->fb_force = false;
 	if (n)
 		usbhid_wait_io(data->hdev);
 }
@@ -511,11 +536,23 @@ static int picolcd_fb_blank(int blank, struct fb_info *info)
 static void picolcd_fb_destroy(struct fb_info *info)
 {
 	struct picolcd_data *data = info->par;
+	u32 *ref_cnt = info->pseudo_palette;
+	int may_release;
+
 	info->par = NULL;
 	if (data)
 		data->fb_info = NULL;
 	fb_deferred_io_cleanup(info);
-	framebuffer_release(info);
+
+	ref_cnt--;
+	mutex_lock(&info->lock);
+	(*ref_cnt)--;
+	may_release = !ref_cnt;
+	mutex_unlock(&info->lock);
+	if (may_release) {
+		framebuffer_release(info);
+		vfree((u8 *)info->fix.smem_start);
+	}
 }
 
 static int picolcd_fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
@@ -526,29 +563,37 @@ static int picolcd_fb_check_var(struct fb_var_screeninfo *var, struct fb_info *i
 	/* only allow 1/8 bit depth (8-bit is grayscale) */
 	*var = picolcdfb_var;
 	var->activate = activate;
-	if (bpp >= 8)
+	if (bpp >= 8) {
 		var->bits_per_pixel = 8;
-	else
+		var->red.length     = 8;
+		var->green.length   = 8;
+		var->blue.length    = 8;
+	} else {
 		var->bits_per_pixel = 1;
+		var->red.length     = 1;
+		var->green.length   = 1;
+		var->blue.length    = 1;
+	}
 	return 0;
 }
 
 static int picolcd_set_par(struct fb_info *info)
 {
 	struct picolcd_data *data = info->par;
-	u8 *o_fb, *n_fb;
+	u8 *tmp_fb, *o_fb;
+	if (!data)
+		return -ENODEV;
 	if (info->var.bits_per_pixel == data->fb_bpp)
 		return 0;
 	/* switch between 1/8 bit depths */
 	if (info->var.bits_per_pixel != 1 && info->var.bits_per_pixel != 8)
 		return -EINVAL;
 
-	o_fb = data->fb_bitmap;
-	n_fb = vmalloc(PICOLCDFB_SIZE*info->var.bits_per_pixel);
-	if (!n_fb)
+	o_fb   = data->fb_bitmap;
+	tmp_fb = kmalloc(PICOLCDFB_SIZE*info->var.bits_per_pixel, GFP_KERNEL);
+	if (!tmp_fb)
 		return -ENOMEM;
 
-	fb_deferred_io_cleanup(info);
 	/* translate FB content to new bits-per-pixel */
 	if (info->var.bits_per_pixel == 1) {
 		int i, b;
@@ -558,24 +603,87 @@ static int picolcd_set_par(struct fb_info *info)
 				p <<= 1;
 				p |= o_fb[i*8+b] ? 0x01 : 0x00;
 			}
+			tmp_fb[i] = p;
 		}
+		memcpy(o_fb, tmp_fb, PICOLCDFB_SIZE);
 		info->fix.visual = FB_VISUAL_MONO01;
 		info->fix.line_length = PICOLCDFB_WIDTH / 8;
 	} else {
 		int i;
+		memcpy(tmp_fb, o_fb, PICOLCDFB_SIZE);
 		for (i = 0; i < PICOLCDFB_SIZE * 8; i++)
-			n_fb[i] = o_fb[i/8] & (0x01 << (7 - i % 8)) ? 0xff : 0x00;
-		info->fix.visual = FB_VISUAL_TRUECOLOR;
+			o_fb[i] = tmp_fb[i/8] & (0x01 << (7 - i % 8)) ? 0xff : 0x00;
+		info->fix.visual = FB_VISUAL_DIRECTCOLOR;
 		info->fix.line_length = PICOLCDFB_WIDTH;
 	}
 
-	data->fb_bitmap   = n_fb;
+	kfree(tmp_fb);
 	data->fb_bpp      = info->var.bits_per_pixel;
-	info->screen_base = (char __force __iomem *)n_fb;
-	info->fix.smem_start = (unsigned long)n_fb;
-	info->fix.smem_len   = PICOLCDFB_SIZE*data->fb_bpp;
-	fb_deferred_io_init(info);
-	vfree(o_fb);
+	return 0;
+}
+
+/* Do refcounting on our FB and cleanup per worker if FB is
+ * closed after unplug of our device
+ * (fb_release holds info->lock and still touches info after
+ *  we return so we can't release it immediately.
+ */
+struct picolcd_fb_cleanup_item {
+	struct fb_info *info;
+	struct picolcd_fb_cleanup_item *next;
+};
+static struct picolcd_fb_cleanup_item *fb_pending;
+DEFINE_SPINLOCK(fb_pending_lock);
+
+static void picolcd_fb_do_cleanup(struct work_struct *data)
+{
+	struct picolcd_fb_cleanup_item *item;
+	unsigned long flags;
+
+	do {
+		spin_lock_irqsave(&fb_pending_lock, flags);
+		item = fb_pending;
+		fb_pending = item ? item->next : NULL;
+		spin_unlock_irqrestore(&fb_pending_lock, flags);
+
+		if (item) {
+			u8 *fb = (u8 *)item->info->fix.smem_start;
+			/* make sure we do not race against fb core when
+			 * releasing */
+			mutex_lock(&item->info->lock);
+			mutex_unlock(&item->info->lock);
+			framebuffer_release(item->info);
+			vfree(fb);
+		}
+	} while (item);
+}
+
+DECLARE_WORK(picolcd_fb_cleanup, picolcd_fb_do_cleanup);
+
+static int picolcd_fb_open(struct fb_info *info, int u)
+{
+	u32 *ref_cnt = info->pseudo_palette;
+	ref_cnt--;
+
+	(*ref_cnt)++;
+	return 0;
+}
+
+static int picolcd_fb_release(struct fb_info *info, int u)
+{
+	u32 *ref_cnt = info->pseudo_palette;
+	ref_cnt--;
+
+	(*ref_cnt)++;
+	if (!*ref_cnt) {
+		unsigned long flags;
+		struct picolcd_fb_cleanup_item *item = (struct picolcd_fb_cleanup_item *)ref_cnt;
+		item--;
+		spin_lock_irqsave(&fb_pending_lock, flags);
+		item->next = fb_pending;
+		fb_pending = item;
+		spin_unlock_irqrestore(&fb_pending_lock, flags);
+		schedule_work(&picolcd_fb_cleanup);
+	}
 	return 0;
 }
 
@@ -583,6 +691,8 @@ static int picolcd_set_par(struct fb_info *info)
 static struct fb_ops picolcdfb_ops = {
 	.owner        = THIS_MODULE,
 	.fb_destroy   = picolcd_fb_destroy,
+	.fb_open      = picolcd_fb_open,
+	.fb_release   = picolcd_fb_release,
 	.fb_read      = fb_sys_read,
 	.fb_write     = picolcd_fb_write,
 	.fb_blank     = picolcd_fb_blank,
@@ -660,11 +770,12 @@ static int picolcd_init_framebuffer(struct picolcd_data *data)
 {
 	struct device *dev = &data->hdev->dev;
 	struct fb_info *info = NULL;
-	int error = -ENOMEM;
+	int i, error = -ENOMEM;
 	u8 *fb_vbitmap = NULL;
 	u8 *fb_bitmap  = NULL;
+	u32 *palette;
 
-	fb_bitmap = vmalloc(PICOLCDFB_SIZE*picolcdfb_var.bits_per_pixel);
+	fb_bitmap = vmalloc(PICOLCDFB_SIZE*8);
 	if (fb_bitmap == NULL) {
 		dev_err(dev, "can't get a free page for framebuffer\n");
 		goto err_nomem;
@@ -678,18 +789,29 @@ static int picolcd_init_framebuffer(struct picolcd_data *data)
 
 	data->fb_update_rate = PICOLCDFB_UPDATE_RATE_DEFAULT;
 	data->fb_defio = picolcd_fb_defio;
-	info = framebuffer_alloc(0, dev);
+	/* The extra memory is:
+	 * - struct picolcd_fb_cleanup_item
+	 * - u32 for ref_count
+	 * - 256*u32 for pseudo_palette
+	 */
+	info = framebuffer_alloc(257 * sizeof(u32) + sizeof(struct picolcd_fb_cleanup_item), dev);
 	if (info == NULL) {
 		dev_err(dev, "failed to allocate a framebuffer\n");
 		goto err_nomem;
 	}
 
+	palette  = info->par + sizeof(struct picolcd_fb_cleanup_item);
+	*palette = 1;
+	palette++;
+	for (i = 0; i < 256; i++)
+		palette[i] = i > 0 && i < 16 ? 0xff : 0;
+	info->pseudo_palette = palette;
 	info->fbdefio = &data->fb_defio;
 	info->screen_base = (char __force __iomem *)fb_bitmap;
 	info->fbops = &picolcdfb_ops;
 	info->var = picolcdfb_var;
 	info->fix = picolcdfb_fix;
-	info->fix.smem_len   = PICOLCDFB_SIZE;
+	info->fix.smem_len   = PICOLCDFB_SIZE*8;
 	info->fix.smem_start = (unsigned long)fb_bitmap;
 	info->par = data;
 	info->flags = FBINFO_FLAG_DEFAULT;
@@ -707,18 +829,20 @@ static int picolcd_init_framebuffer(struct picolcd_data *data)
 		dev_err(dev, "failed to create sysfs attributes\n");
 		goto err_cleanup;
 	}
+	fb_deferred_io_init(info);
 	data->fb_info    = info;
 	error = register_framebuffer(info);
 	if (error) {
 		dev_err(dev, "failed to register framebuffer\n");
 		goto err_sysfs;
 	}
-	fb_deferred_io_init(info);
 	/* schedule first output of framebuffer */
+	data->fb_force = 1;
 	schedule_delayed_work(&info->deferred_work, 0);
 	return 0;
 
 err_sysfs:
+	fb_deferred_io_cleanup(info);
 	device_remove_file(dev, &dev_attr_fb_update_rate);
 err_cleanup:
 	data->fb_vbitmap = NULL;
@@ -728,8 +852,8 @@ err_cleanup:
 
 err_nomem:
 	framebuffer_release(info);
-	vfree(fb_bitmap);
 	kfree(fb_vbitmap);
+	vfree(fb_bitmap);
 	return error;
 }
 
@@ -737,19 +861,17 @@ static void picolcd_exit_framebuffer(struct picolcd_data *data)
 {
 	struct fb_info *info = data->fb_info;
 	u8 *fb_vbitmap = data->fb_vbitmap;
-	u8 *fb_bitmap  = data->fb_bitmap;
 
 	if (!info)
 		return;
 
+	info->par = NULL;
+	device_remove_file(&data->hdev->dev, &dev_attr_fb_update_rate);
+	unregister_framebuffer(info);
 	data->fb_vbitmap = NULL;
 	data->fb_bitmap  = NULL;
 	data->fb_bpp     = 0;
 	data->fb_info    = NULL;
-	device_remove_file(&data->hdev->dev, &dev_attr_fb_update_rate);
-	fb_deferred_io_cleanup(info);
-	unregister_framebuffer(info);
-	vfree(fb_bitmap);
 	kfree(fb_vbitmap);
 }
 
@@ -2566,6 +2688,13 @@ static void picolcd_remove(struct hid_device *hdev)
 	spin_lock_irqsave(&data->lock, flags);
 	data->status |= PICOLCD_FAILED;
 	spin_unlock_irqrestore(&data->lock, flags);
+#ifdef CONFIG_HID_PICOLCD_FB
+	/* short-circuit FB as early as possible in order to
+	 * avoid long delays if we host console.
+	 */
+	if (data->fb_info)
+		data->fb_info->par = NULL;
+#endif
 
 	picolcd_exit_devfs(data);
 	device_remove_file(&hdev->dev, &dev_attr_operation_mode);
@@ -2623,6 +2752,10 @@ static int __init picolcd_init(void)
 static void __exit picolcd_exit(void)
 {
 	hid_unregister_driver(&picolcd_driver);
+#ifdef CONFIG_HID_PICOLCD_FB
+	flush_scheduled_work();
+	WARN_ON(fb_pending);
+#endif
 }
 
 module_init(picolcd_init);
-- 
1.6.4.4

