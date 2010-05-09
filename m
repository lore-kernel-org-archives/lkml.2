Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab0EIQtf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 12:49:35 -0400
Received: from legolas.restena.lu ([158.64.1.34]:39810 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab0EIQtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 12:49:33 -0400
Date: Sun, 9 May 2010 18:49:11 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Subject: Deadlock between fbcon and fb_defio?
Message-ID: <20100509184911.3f136b77@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaya,

While working on hid-picolcd to get fbcon working on top of it (fixing
up color handling and other issues) I've hit what looks like a dead-lock
apparently between fbcon and fb_defio.

In set_par() I'm calling fb_deferred_io_cleanup() before switching
to new framebuffer (on bits-per-pixel change) after which I resume
deferred_io by calling fb_deferred_io_init().

See code at (fixes I'm working on are at the end):
http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=blob;f=drivers/hid/hid-picolcd.c;hb=picolcd


Any idea why things deadlock here and how to avoid it? (it seems
to be more of a race condition as I already called fbset successfully
but that was from a ssh session instead of from console itself).

One option seems to be to release console_sem for the time I stop
fb_defio and re-acquiring it afterwards. But this rather looks like
a work-around as the events kernel thread seems to have both fbcon
fb_defio work interleaved (which I think a better fix would prevent)...

Trace below.

Thanks,
Bruno


[ 3480.400053] INFO: task events/0:5 blocked for more than 120 seconds.
[ 3480.400072] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3480.400094] events/0      D c1038220  2600     5      2 0x00000000
[ 3480.400133]  f704aed0 00000046 f704edc0 c1038220 f704aeb4 f704ef40 f6157f00 f5cd31c0
[ 3480.400172]  f704edc0 7fffffff c119c4e0 f704af20 c1337e05 000007c0 ffffffff f5af27c0
[ 3480.400208]  00000014 00000008 00000004 f6157f00 f5af27c0 00000246 f6325c00 0000000d
[ 3480.400245] Call Trace:
[ 3480.400290]  [<c1038220>] ? autoremove_wake_function+0x0/0x50
[ 3480.400329]  [<c119c4e0>] ? fb_flashcursor+0x0/0x100
[ 3480.400364]  [<c1337e05>] schedule_timeout+0xf5/0x170
[ 3480.400398]  [<c119c4e0>] ? fb_flashcursor+0x0/0x100
[ 3480.400427]  [<c13387a8>] __down+0x48/0x70
[ 3480.400457]  [<c103c770>] down+0x20/0x30
[ 3480.400490]  [<c10263fd>] acquire_console_sem+0x1d/0x50
[ 3480.400520]  [<c119c500>] fb_flashcursor+0x20/0x100
[ 3480.400547]  [<c11a300f>] ? fb_deferred_io_work+0xaf/0xc0
[ 3480.400577]  [<c119c4e0>] ? fb_flashcursor+0x0/0x100
[ 3480.400605]  [<c1035066>] worker_thread+0xd6/0x180
[ 3480.400633]  [<c10228ef>] ? finish_task_switch+0x2f/0x80
[ 3480.400666]  [<c1038220>] ? autoremove_wake_function+0x0/0x50
[ 3480.400694]  [<c1034f90>] ? worker_thread+0x0/0x180
[ 3480.400723]  [<c1037e5c>] kthread+0x6c/0x80
[ 3480.400750]  [<c1037df0>] ? kthread+0x0/0x80
[ 3480.400777]  [<c1003036>] kernel_thread_helper+0x6/0x10
[ 3480.400832] INFO: task fbset:18512 blocked for more than 120 seconds.
[ 3480.400848] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3480.400867] fbset         D 00000002  1828 18512   1504 0x00000000
[ 3480.400902]  f33b7b34 00000086 f712f810 00000002 00000000 f712f990 00000001 f5cd31c0
[ 3480.400937]  f712f810 7fffffff f33b7bd8 f33b7b84 c1337e05 c14b58b0 00000002 00000041
[ 3480.400974]  c14b52e8 00000000 f5cc600c f33b7b64 c10760c3 c14b58b0 00000000 000200d2
[ 3480.401009] Call Trace:
[ 3480.401037]  [<c1337e05>] schedule_timeout+0xf5/0x170
[ 3480.401068]  [<c10760c3>] ? __insert_vmap_area+0x53/0xb0
[ 3480.401099]  [<c13377b8>] wait_for_common+0x98/0xf0
[ 3480.401128]  [<c1022f80>] ? default_wake_function+0x0/0x10
[ 3480.401158]  [<c13378a2>] wait_for_completion+0x12/0x20
[ 3480.401186]  [<c1034bcb>] flush_cpu_workqueue+0x3b/0x70
[ 3480.401214]  [<c1034e70>] ? wq_barrier_func+0x0/0x10
[ 3480.401241]  [<c1034c7a>] flush_workqueue+0xa/0x10
[ 3480.401268]  [<c1034c8d>] flush_scheduled_work+0xd/0x10
[ 3480.401294]  [<c11a3192>] fb_deferred_io_cleanup+0x32/0x80
[ 3480.401335]  [<f8127eb4>] picolcd_set_par+0x74/0x120 [hid_picolcd]
[ 3480.401387]  [<c1194491>] fb_set_var+0x191/0x340
[ 3480.401431]  [<c1107477>] ? xfs_bmap_search_extents+0x47/0xf0
[ 3480.401461]  [<c110f726>] ? xfs_bmapi+0x2e6/0x1330
[ 3480.401490]  [<c100483e>] ? handle_irq+0x1e/0xd0
[ 3480.401518]  [<c1194a5a>] do_fb_ioctl+0x41a/0x550
[ 3480.401553]  [<c1081907>] ? nameidata_to_filp+0x47/0x60
[ 3480.401583]  [<c105b3bd>] ? unlock_page+0x3d/0x40
[ 3480.401614]  [<c106e8e0>] ? __do_fault+0x330/0x400
[ 3480.401640]  [<c108aa00>] ? path_put+0x20/0x30
[ 3480.401668]  [<c1194b90>] ? fb_ioctl+0x0/0x20
[ 3480.401694]  [<c1194bad>] fb_ioctl+0x1d/0x20
[ 3480.401719]  [<c108ede0>] vfs_ioctl+0x20/0x80
[ 3480.401745]  [<c108f7d2>] do_vfs_ioctl+0x362/0x560
[ 3480.401780]  [<c101a417>] ? do_page_fault+0x1c7/0x360
[ 3480.401811]  [<c1003a10>] ? do_device_not_available+0x0/0x50
[ 3480.401843]  [<c1009a76>] ? init_fpu+0x66/0x170
[ 3480.401868]  [<c108fa09>] sys_ioctl+0x39/0x70
[ 3480.401893]  [<c1002b10>] sysenter_do_call+0x12/0x26

---

Fix crash if we are the first framebuffer loaded as in that case fbcon
wants to flush framebuffer at the end of fb registration, before we
have setup fb_defio.

Add a flag for forcing full re-transmit of framebuffer as otherwise
we have a long race period after initialization during which fb can
change and match startup inverted shadow copy, thus cause initial transmit
of tiles to be skipped (visible with fbcon).

Adjust visual handling so fbcon gets properly displayed in 8bpp grayscale
mode.

Reorder tear-down so we avoid spamming kernel log with messages regarding
full USB queue and also avoid long delay from fb_defio cleanup when
fb was active during unplug.

diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index 95253b3..ffaa39c 100644
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
+				tdata[i] |= (bdata[i/8] >> (/* 7 - */ i % 8)) & 0x01;
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
@@ -511,10 +536,11 @@ static int picolcd_fb_blank(int blank, struct fb_info *info)
 static void picolcd_fb_destroy(struct fb_info *info)
 {
 	struct picolcd_data *data = info->par;
+	fb_deferred_io_cleanup(info);
+
 	info->par = NULL;
 	if (data)
 		data->fb_info = NULL;
-	fb_deferred_io_cleanup(info);
 	framebuffer_release(info);
 }
 
@@ -526,10 +552,17 @@ static int picolcd_fb_check_var(struct fb_var_screeninfo *var, struct fb_info *i
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
 
@@ -537,6 +570,8 @@ static int picolcd_set_par(struct fb_info *info)
 {
 	struct picolcd_data *data = info->par;
 	u8 *o_fb, *n_fb;
+	if (!data)
+		return -ENODEV;
 	if (info->var.bits_per_pixel == data->fb_bpp)
 		return 0;
 	/* switch between 1/8 bit depths */
@@ -565,7 +600,7 @@ static int picolcd_set_par(struct fb_info *info)
 		int i;
 		for (i = 0; i < PICOLCDFB_SIZE * 8; i++)
 			n_fb[i] = o_fb[i/8] & (0x01 << (7 - i % 8)) ? 0xff : 0x00;
-		info->fix.visual = FB_VISUAL_TRUECOLOR;
+		info->fix.visual = FB_VISUAL_DIRECTCOLOR;
 		info->fix.line_length = PICOLCDFB_WIDTH;
 	}
 
@@ -660,9 +695,10 @@ static int picolcd_init_framebuffer(struct picolcd_data *data)
 {
 	struct device *dev = &data->hdev->dev;
 	struct fb_info *info = NULL;
-	int error = -ENOMEM;
+	int i, error = -ENOMEM;
 	u8 *fb_vbitmap = NULL;
 	u8 *fb_bitmap  = NULL;
+	u32 *palette;
 
 	fb_bitmap = vmalloc(PICOLCDFB_SIZE*picolcdfb_var.bits_per_pixel);
 	if (fb_bitmap == NULL) {
@@ -678,12 +714,16 @@ static int picolcd_init_framebuffer(struct picolcd_data *data)
 
 	data->fb_update_rate = PICOLCDFB_UPDATE_RATE_DEFAULT;
 	data->fb_defio = picolcd_fb_defio;
-	info = framebuffer_alloc(0, dev);
+	info = framebuffer_alloc(256 * sizeof(u32), dev);
 	if (info == NULL) {
 		dev_err(dev, "failed to allocate a framebuffer\n");
 		goto err_nomem;
 	}
 
+	palette = info->par;
+	for (i = 0; i < 256; i++)
+		palette[i] = i > 0 && i < 16 ? 0xff : 0;
+	info->pseudo_palette = info->par;
 	info->fbdefio = &data->fb_defio;
 	info->screen_base = (char __force __iomem *)fb_bitmap;
 	info->fbops = &picolcdfb_ops;
@@ -707,18 +747,20 @@ static int picolcd_init_framebuffer(struct picolcd_data *data)
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
@@ -742,13 +784,13 @@ static void picolcd_exit_framebuffer(struct picolcd_data *data)
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
 	vfree(fb_bitmap);
 	kfree(fb_vbitmap);
 }
@@ -2566,6 +2608,11 @@ static void picolcd_remove(struct hid_device *hdev)
 	spin_lock_irqsave(&data->lock, flags);
 	data->status |= PICOLCD_FAILED;
 	spin_unlock_irqrestore(&data->lock, flags);
+	/* short-circuit FB as early as possible in order to
+	 * avoid long details if we hosted console.
+	 */
+	if (data->fb_info)
+		data->fb_info->par = NULL;
 
 	picolcd_exit_devfs(data);
 	device_remove_file(&hdev->dev, &dev_attr_operation_mode);
