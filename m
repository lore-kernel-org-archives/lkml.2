Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab0F1Ufo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 16:35:44 -0400
Received: from legolas.restena.lu ([158.64.1.34]:57138 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab0F1Ueo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 16:34:44 -0400
Date: Mon, 28 Jun 2010 22:33:27 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] HID: picolcd: implement refcounting of framebuffer
Message-ID: <20100628223327.23c6006a@neptune.home>
In-Reply-To: <20100628222641.489c955a@neptune.home>
References: <20100509184911.3f136b77@neptune.home>
	<AANLkTik0EkPYKdnhrpF7yK6eXIrHMsNYrzSC6tyeBR0P@mail.gmail.com>
	<20100510080047.5adade6f@pluto.restena.lu>
	<20100526215829.28a4aa47@neptune.home>
	<20100530130945.5c03797f@neptune.home>
	<20100623123225.4c16e653@neptune.home>
	<alpine.LNX.2.00.1006241053360.13809@pobox.suse.cz>
	<20100628222641.489c955a@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As our device may be hot-unplugged and framebuffer cannot handle
this case by itself we need to keep track of usage count so as
to release fb_info and framebuffer memory only after the last user
has closed framebuffer.

We need to do the freeing in a scheduled work as fb_release()
is called with fb_info lock held.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/hid-picolcd.c |  110 ++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 103 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index 31a0abd..85a105e 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -439,6 +439,9 @@ static void picolcd_fb_update(struct picolcd_data *data)
 	int chip, tile, n;
 	unsigned long flags;
 
+	if (!data)
+		return;
+
 	spin_lock_irqsave(&data->lock, flags);
 	if (!(data->status & PICOLCD_READY_FB)) {
 		spin_unlock_irqrestore(&data->lock, flags);
@@ -461,6 +464,8 @@ static void picolcd_fb_update(struct picolcd_data *data)
 					data->fb_bitmap, data->fb_bpp, chip, tile) ||
 				data->fb_force) {
 				n += 2;
+				if (!data->fb_info->par)
+					return; /* device lost! */
 				if (n >= HID_OUTPUT_FIFO_SIZE / 2) {
 					usbhid_wait_io(data->hdev);
 					n = 0;
@@ -531,11 +536,23 @@ static int picolcd_fb_blank(int blank, struct fb_info *info)
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
@@ -564,6 +581,8 @@ static int picolcd_set_par(struct fb_info *info)
 {
 	struct picolcd_data *data = info->par;
 	u8 *tmp_fb, *o_fb;
+	if (!data)
+		return -ENODEV;
 	if (info->var.bits_per_pixel == data->fb_bpp)
 		return 0;
 	/* switch between 1/8 bit depths */
@@ -603,10 +622,77 @@ static int picolcd_set_par(struct fb_info *info)
 	return 0;
 }
 
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
+	return 0;
+}
+
 /* Note this can't be const because of struct fb_info definition */
 static struct fb_ops picolcdfb_ops = {
 	.owner        = THIS_MODULE,
 	.fb_destroy   = picolcd_fb_destroy,
+	.fb_open      = picolcd_fb_open,
+	.fb_release   = picolcd_fb_release,
 	.fb_read      = fb_sys_read,
 	.fb_write     = picolcd_fb_write,
 	.fb_blank     = picolcd_fb_blank,
@@ -708,13 +794,13 @@ static int picolcd_init_framebuffer(struct picolcd_data *data)
 	 * - u32 for ref_count
 	 * - 256*u32 for pseudo_palette
 	 */
-	info = framebuffer_alloc(257 * sizeof(u32), dev);
+	info = framebuffer_alloc(257 * sizeof(u32) + sizeof(struct picolcd_fb_cleanup_item), dev);
 	if (info == NULL) {
 		dev_err(dev, "failed to allocate a framebuffer\n");
 		goto err_nomem;
 	}
 
-	palette  = info->par;
+	palette  = info->par + sizeof(struct picolcd_fb_cleanup_item);
 	*palette = 1;
 	palette++;
 	for (i = 0; i < 256; i++)
@@ -775,18 +861,17 @@ static void picolcd_exit_framebuffer(struct picolcd_data *data)
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
-	unregister_framebuffer(info);
-	vfree(fb_bitmap);
 	kfree(fb_vbitmap);
 }
 
@@ -2603,6 +2688,13 @@ static void picolcd_remove(struct hid_device *hdev)
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
@@ -2660,6 +2752,10 @@ static int __init picolcd_init(void)
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
1.7.1

