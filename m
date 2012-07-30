Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab2G3TjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:39:24 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:53125 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab2G3TjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:39:21 -0400
Date: Mon, 30 Jul 2012 21:38:46 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Cc: Jaya Kumar <jayalk@intworks.biz>, linux-fbdev@vger.kernel.org
Subject: [PATCH 2/7] HID: picoLCD: Replace own refcounting with fbdev's
Message-ID: <20120730213846.2ebab405@neptune.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
References: <20120730213656.0a9f6d30@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/hid-picolcd.h      |    6 --
 drivers/hid/hid-picolcd_core.c |    1 -
 drivers/hid/hid-picolcd_fb.c   |  114 ++++++---------------------------------
 3 files changed, 18 insertions(+), 103 deletions(-)

diff --git a/drivers/hid/hid-picolcd.h b/drivers/hid/hid-picolcd.h
index 4ddb318..9200be1 100644
--- a/drivers/hid/hid-picolcd.h
+++ b/drivers/hid/hid-picolcd.h
@@ -96,7 +96,6 @@ struct picolcd_data {
 	u8 *fb_vbitmap;		/* local copy of what was sent to PicoLCD */
 	u8 *fb_bitmap;		/* framebuffer */
 	struct fb_info *fb_info;
-	struct fb_deferred_io fb_defio;
 #endif /* CONFIG_HID_PICOLCD_FB */
 #ifdef CONFIG_HID_PICOLCD_LCD
 	struct lcd_device *lcd;
@@ -179,8 +178,6 @@ int picolcd_init_framebuffer(struct picolcd_data *data);
 
 void picolcd_exit_framebuffer(struct picolcd_data *data);
 
-void picolcd_fb_unload(void);
-
 void picolcd_fb_refresh(struct picolcd_data *data);
 #define picolcd_fbinfo(d) ((d)->fb_info)
 #else
@@ -195,9 +192,6 @@ static inline int picolcd_init_framebuffer(struct picolcd_data *data)
 static inline void picolcd_exit_framebuffer(struct picolcd_data *data)
 {
 }
-static inline void picolcd_fb_unload(void)
-{
-}
 static inline void picolcd_fb_refresh(struct picolcd_data *data)
 {
 }
diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
index 36e7548..8d5d341 100644
--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -695,7 +695,6 @@ static int __init picolcd_init(void)
 static void __exit picolcd_exit(void)
 {
 	hid_unregister_driver(&picolcd_driver);
-	picolcd_fb_unload();
 }
 
 module_init(picolcd_init);
diff --git a/drivers/hid/hid-picolcd_fb.c b/drivers/hid/hid-picolcd_fb.c
index b2124f5..602786c 100644
--- a/drivers/hid/hid-picolcd_fb.c
+++ b/drivers/hid/hid-picolcd_fb.c
@@ -256,7 +256,7 @@ static void picolcd_fb_update(struct picolcd_data *data)
 					data->fb_bitmap, data->fb_bpp, chip, tile) ||
 				data->fb_force) {
 				n += 2;
-				if (!data->fb_info->par)
+				if (data->status & PICOLCD_FAILED)
 					return; /* device lost! */
 				if (n >= HID_OUTPUT_FIFO_SIZE / 2) {
 					usbhid_wait_io(data->hdev);
@@ -327,24 +327,17 @@ static int picolcd_fb_blank(int blank, struct fb_info *info)
 
 static void picolcd_fb_destroy(struct fb_info *info)
 {
-	struct picolcd_data *data = info->par;
-	u32 *ref_cnt = info->pseudo_palette;
-	int may_release;
+	struct picolcd_data *data;
 
+	/* make sure no work is deferred */
+	cancel_delayed_work_sync(&info->deferred_work);
+	data = info->par;
 	info->par = NULL;
 	if (data)
 		data->fb_info = NULL;
-	fb_deferred_io_cleanup(info);
 
-	ref_cnt--;
-	mutex_lock(&info->lock);
-	(*ref_cnt)--;
-	may_release = !*ref_cnt;
-	mutex_unlock(&info->lock);
-	if (may_release) {
-		vfree((u8 *)info->fix.smem_start);
-		framebuffer_release(info);
-	}
+	vfree((u8 *)info->fix.smem_start);
+	framebuffer_release(info);
 }
 
 static int picolcd_fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
@@ -414,77 +407,10 @@ static int picolcd_set_par(struct fb_info *info)
 	return 0;
 }
 
-/* Do refcounting on our FB and cleanup per worker if FB is
- * closed after unplug of our device
- * (fb_release holds info->lock and still touches info after
- *  we return so we can't release it immediately.
- */
-struct picolcd_fb_cleanup_item {
-	struct fb_info *info;
-	struct picolcd_fb_cleanup_item *next;
-};
-static struct picolcd_fb_cleanup_item *fb_pending;
-static DEFINE_SPINLOCK(fb_pending_lock);
-
-static void picolcd_fb_do_cleanup(struct work_struct *data)
-{
-	struct picolcd_fb_cleanup_item *item;
-	unsigned long flags;
-
-	do {
-		spin_lock_irqsave(&fb_pending_lock, flags);
-		item = fb_pending;
-		fb_pending = item ? item->next : NULL;
-		spin_unlock_irqrestore(&fb_pending_lock, flags);
-
-		if (item) {
-			u8 *fb = (u8 *)item->info->fix.smem_start;
-			/* make sure we do not race against fb core when
-			 * releasing */
-			mutex_lock(&item->info->lock);
-			mutex_unlock(&item->info->lock);
-			framebuffer_release(item->info);
-			vfree(fb);
-		}
-	} while (item);
-}
-
-static DECLARE_WORK(picolcd_fb_cleanup, picolcd_fb_do_cleanup);
-
-static int picolcd_fb_open(struct fb_info *info, int u)
-{
-	u32 *ref_cnt = info->pseudo_palette;
-	ref_cnt--;
-
-	(*ref_cnt)++;
-	return 0;
-}
-
-static int picolcd_fb_release(struct fb_info *info, int u)
-{
-	u32 *ref_cnt = info->pseudo_palette;
-	ref_cnt--;
-
-	(*ref_cnt)++;
-	if (!*ref_cnt) {
-		unsigned long flags;
-		struct picolcd_fb_cleanup_item *item = (struct picolcd_fb_cleanup_item *)ref_cnt;
-		item--;
-		spin_lock_irqsave(&fb_pending_lock, flags);
-		item->next = fb_pending;
-		fb_pending = item;
-		spin_unlock_irqrestore(&fb_pending_lock, flags);
-		schedule_work(&picolcd_fb_cleanup);
-	}
-	return 0;
-}
-
 /* Note this can't be const because of struct fb_info definition */
 static struct fb_ops picolcdfb_ops = {
 	.owner        = THIS_MODULE,
 	.fb_destroy   = picolcd_fb_destroy,
-	.fb_open      = picolcd_fb_open,
-	.fb_release   = picolcd_fb_release,
 	.fb_read      = fb_sys_read,
 	.fb_write     = picolcd_fb_write,
 	.fb_blank     = picolcd_fb_blank,
@@ -550,7 +476,7 @@ static ssize_t picolcd_fb_update_rate_store(struct device *dev,
 		u = PICOLCDFB_UPDATE_RATE_DEFAULT;
 
 	data->fb_update_rate = u;
-	data->fb_defio.delay = HZ / data->fb_update_rate;
+	data->fb_info->fbdefio->delay = HZ / data->fb_update_rate;
 	return count;
 }
 
@@ -580,25 +506,23 @@ int picolcd_init_framebuffer(struct picolcd_data *data)
 	}
 
 	data->fb_update_rate = PICOLCDFB_UPDATE_RATE_DEFAULT;
-	data->fb_defio = picolcd_fb_defio;
 	/* The extra memory is:
-	 * - struct picolcd_fb_cleanup_item
-	 * - u32 for ref_count
 	 * - 256*u32 for pseudo_palette
+	 * - struct fb_deferred_io
 	 */
-	info = framebuffer_alloc(257 * sizeof(u32) + sizeof(struct picolcd_fb_cleanup_item), dev);
+	info = framebuffer_alloc(256 * sizeof(u32) +
+			sizeof(struct fb_deferred_io), dev);
 	if (info == NULL) {
 		dev_err(dev, "failed to allocate a framebuffer\n");
 		goto err_nomem;
 	}
 
-	palette  = info->par + sizeof(struct picolcd_fb_cleanup_item);
-	*palette = 1;
-	palette++;
+	info->fbdefio = info->par;
+	*info->fbdefio = picolcd_fb_defio;
+	palette  = info->par + sizeof(struct fb_deferred_io);
 	for (i = 0; i < 256; i++)
 		palette[i] = i > 0 && i < 16 ? 0xff : 0;
 	info->pseudo_palette = palette;
-	info->fbdefio = &data->fb_defio;
 	info->screen_base = (char __force __iomem *)fb_bitmap;
 	info->fbops = &picolcdfb_ops;
 	info->var = picolcdfb_var;
@@ -658,6 +582,10 @@ void picolcd_exit_framebuffer(struct picolcd_data *data)
 		return;
 
 	device_remove_file(&data->hdev->dev, &dev_attr_fb_update_rate);
+	mutex_lock(&info->lock);
+	fb_deferred_io_cleanup(info);
+	info->par = NULL;
+	mutex_unlock(&info->lock);
 	unregister_framebuffer(info);
 	data->fb_vbitmap = NULL;
 	data->fb_bitmap  = NULL;
@@ -665,9 +593,3 @@ void picolcd_exit_framebuffer(struct picolcd_data *data)
 	data->fb_info    = NULL;
 	kfree(fb_vbitmap);
 }
-
-void picolcd_fb_unload()
-{
-	flush_work_sync(&picolcd_fb_cleanup);
-	WARN_ON(fb_pending);
-}
-- 
1.7.8.6

