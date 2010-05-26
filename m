Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab0EZT65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:58:57 -0400
Received: from legolas.restena.lu ([158.64.1.34]:50264 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab0EZT6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:58:55 -0400
Date: Wed, 26 May 2010 21:58:29 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: vfree() and mmap()ed framebuffer with defio (Was: Deadlock
 between fbcon and fb_defio?)
Message-ID: <20100526215829.28a4aa47@neptune.home>
In-Reply-To: <20100510080047.5adade6f@pluto.restena.lu>
References: <20100509184911.3f136b77@neptune.home>
	<AANLkTik0EkPYKdnhrpF7yK6eXIrHMsNYrzSC6tyeBR0P@mail.gmail.com>
	<20100510080047.5adade6f@pluto.restena.lu>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaya,

On Mon, 10 May 2010 Bruno Prémont <bonbons@linux-vserver.org> wrote:
> I want to make sure that I won't be accessing the old framebuffer after
> freeing it and also that defio monitors the new framebuffer.
> 
> For that reason I defio_cleanup(), replace framebuffer, defio_init().
> All of this happens while do_fb_ioctl() holds lock on fb_info and
> console_sem.

I've slightly changed the code path when releasing old valloc()ed
framebuffer. Now I don't call defio_init/cleanup while framebuffer is
registered so the deadlock cannot happen. But just calling vfree()
to dispose old framebuffer is not sufficient when it was mmap()ed.

Do you know how I could "get rid" of that old framebuffer in a proper
way?


Currently I'm getting the complaints from kernel when the process that
mmap()ed frambuffer exits after depth changed via set_par() or even a
"BUG: unable to handle kernel paging request" (depending on what exactly
I do (pertinent hunk of patch, full patch at the end):

@@ -574,7 +611,10 @@ static int picolcd_set_par(struct fb_info *info)
 	info->screen_base = (char __force __iomem *)n_fb;
 	info->fix.smem_start = (unsigned long)n_fb;
 	info->fix.smem_len   = PICOLCDFB_SIZE*data->fb_bpp;
-	fb_deferred_io_init(info);
+	for (i = 0; i < o_len; i += PAGE_SIZE) {
+		struct page *page = vmalloc_to_page(o_fb + i);
+		page->mapping = NULL;
+	}
 	vfree(o_fb);
 	return 0;
 }


If I run the for loop I end up with the "unable to handle paging request" BUG:
[ 4364.740056] BUG: unable to handle kernel paging request at 84db1980
[ 4364.741115] IP: [<c103816f>] __wake_up_bit+0xf/0x30
[ 4364.741806] *pde = 00000000 
[ 4364.742165] Oops: 0000 [#1] 
[ 4364.742526] last sysfs file: /sys/devices/platform/via_cputemp.0/temp1_input
[ 4364.743559] Modules linked in: hid_picolcd e_powersaver via_cputemp snd_hda_codec_via snd_hda_intel snd_hda_codec backlight snd_pcm lcd led_class snd_timer fb_sys_fops sysimgblt sysfillrect syscopyarea snd soundcore snd_page_alloc sg [last unloaded: hid_picolcd]
[ 4364.747026] 
[ 4364.747393] Pid: 5, comm: events/0 Tainted: G    B      2.6.34-venus #46 CX700+W697HG/CX700+W697HG
[ 4364.748855] EIP: 0060:[<c103816f>] EFLAGS: 00010296 CPU: 0
[ 4364.749603] EIP is at __wake_up_bit+0xf/0x30
[ 4364.750012] EAX: 84db1980 EBX: 84db1980 ECX: 00000000 EDX: c14b6330
[ 4364.750012] ESI: f69b4874 EDI: f69b4864 EBP: f704af54 ESP: f704af44
[ 4364.750012]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[ 4364.750012] Process events/0 (pid: 5, ti=f704a000 task=f704edc0 task.ti=f704a000)
[ 4364.750012] Stack:
[ 4364.750012]  00000000 c14b6330 00000000 c14b65cc f704af60 c105b39d c14b6330 f704af7c
[ 4364.750012] <0> c11a2e96 f69b4868 f69b2800 f69b2a1c f7003300 c11a2e50 f704afc0 c1035056
[ 4364.750012] <0> c10228ef f704e000 f704edc0 f704e000 f704efa0 f704edc0 f7003308 00000000
[ 4364.750012] Call Trace:
[ 4364.750012]  [<c105b39d>] ? unlock_page+0x3d/0x40
[ 4364.750012]  [<c11a2e96>] ? fb_deferred_io_work+0x46/0xc0
[ 4364.750012]  [<c11a2e50>] ? fb_deferred_io_work+0x0/0xc0
[ 4364.750012]  [<c1035056>] ? worker_thread+0xd6/0x180
[ 4364.750012]  [<c10228ef>] ? finish_task_switch+0x2f/0x80
[ 4364.750012]  [<c1038210>] ? autoremove_wake_function+0x0/0x50
[ 4364.750012]  [<c1034f80>] ? worker_thread+0x0/0x180
[ 4364.750012]  [<c1037e4c>] ? kthread+0x6c/0x80
[ 4364.750012]  [<c1037de0>] ? kthread+0x0/0x80
[ 4364.750012]  [<c1003036>] ? kernel_thread_helper+0x6/0x10
[ 4364.750012] Code: 20 5d 4b c1 2b 8b cc 02 00 00 d3 e8 c1 e0 03 03 83 c4 02 00 00 5b 5d c3 8d 74 26 00 55 89 e5 53 89 c3 83 ec 0c 89 55 f4 89 4d f8 <3b> 00 74 17 8d 45 f4 b9 01 00 00 00 89 04 24 ba 03 00 00 00 89 
[ 4364.750012] EIP: [<c103816f>] __wake_up_bit+0xf/0x30 SS:ESP 0068:f704af44
[ 4364.750012] CR2: 0000000084db1980
[ 4364.772281] ---[ end trace a9d32c215502d31b ]---

If I don't do the for loop I get on of these for each page of the old
framebuffer still mmap()ed by userspace:
[ 1301.041395] BUG: Bad page state in process links  pfn:3b8fa
[ 1301.041867] page:c1d02f40 count:0 mapcount:0 mapping:f6a23be8 index:0x0
[ 1301.042641] page flags: 0x80000014(referenced|dirty)
[ 1301.043420] Pid: 1688, comm: links Not tainted 2.6.34-venus #46
[ 1301.044552] Call Trace:
[ 1301.044972]  [<c105eea2>] bad_page+0x82/0xd0
[ 1301.045727]  [<c1060341>] free_hot_cold_page+0x191/0x310
[ 1301.046497]  [<c1062c1e>] put_page+0x3e/0x100
[ 1301.047256]  [<c1078d9d>] free_page_and_swap_cache+0x1d/0x40
[ 1301.048056]  [<c106ddc8>] unmap_vmas+0x2a8/0x580
[ 1301.048846]  [<c1021ce7>] ? dequeue_task_fair+0x27/0x1d0
[ 1301.049640]  [<c1071837>] exit_mmap+0x97/0x110
[ 1301.050477]  [<c1023e56>] mmput+0x26/0x90
[ 1301.051259]  [<c10274f1>] exit_mm+0xb1/0xc0
[ 1301.052045]  [<c10288ba>] do_exit+0xba/0x6b0
[ 1301.052848]  [<c102f721>] ? recalc_sigpending+0x11/0x30
[ 1301.053660]  [<c1030b9c>] ? dequeue_signal+0x2c/0x130
[ 1301.054480]  [<c1028edd>] do_group_exit+0x2d/0x70
[ 1301.055293]  [<c10321bc>] get_signal_to_deliver+0x17c/0x370
[ 1301.056103]  [<c10299f6>] ? current_fs_time+0x16/0x20
[ 1301.056892]  [<c10022f8>] do_notify_resume+0x98/0x820
[ 1301.057690]  [<c11d4b6e>] ? tty_unthrottle+0x3e/0x50
[ 1301.058490]  [<c10299f6>] ? current_fs_time+0x16/0x20
[ 1301.059303]  [<c11d2db0>] ? n_tty_read+0x0/0x680
[ 1301.060134]  [<c109153d>] ? sys_select+0x3d/0xb0
[ 1301.060935]  [<c1029c2b>] ? sys_gettimeofday+0x2b/0x70
[ 1301.061756]  [<c13394d2>] work_notifysig+0x13/0x19

What do I have to do to prevent both errors?
I would guess unmapping the old framebuffer from userspace (or maybe
fail set_par() with -EBUSY? - if so how do I determine if the
framebuffer was mmap()ed?)

Any suggestion is welcome!
Thanks,
Bruno





---

Below patch fixes multiple issues running fbcon on top of hid-picolcd's
framebuffer but still has issues on depth change (c.f. above).
Fixed issues:
 - NULL pointer deref in 8-bpp mode when fbcon wants to parse
   access color map
 - bit-order for 1-bpp is the opposite from the one I expected
 - too quick update of framebuffer after registration can cause
   parts to the framebuffer to not be pushed to device

diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index 95253b3..599bf4b 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -26,6 +26,7 @@
 
 #include <linux/fb.h>
 #include <linux/vmalloc.h>
+#include <linux/mm.h>
 #include <linux/backlight.h>
 #include <linux/lcd.h>
 
@@ -127,6 +128,26 @@ static const struct fb_var_screeninfo picolcdfb_var = {
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
 
@@ -188,6 +209,7 @@ struct picolcd_data {
 	/* Framebuffer stuff */
 	u8 fb_update_rate;
 	u8 fb_bpp;
+	u8 fb_force;
 	u8 *fb_vbitmap;		/* local copy of what was sent to PicoLCD */
 	u8 *fb_bitmap;		/* framebuffer */
 	struct fb_info *fb_info;
@@ -346,7 +368,7 @@ static int picolcd_fb_update_tile(u8 *vbitmap, const u8 *bitmap, int bpp,
 			const u8 *bdata = bitmap + tile * 256 + chip * 8 + b * 32;
 			for (i = 0; i < 64; i++) {
 				tdata[i] <<= 1;
-				tdata[i] |= (bdata[i/8] >> (7 - i % 8)) & 0x01;
+				tdata[i] |= (bdata[i/8] >> (i % 8)) & 0x01;
 			}
 		}
 	} else if (bpp == 8) {
@@ -399,13 +421,10 @@ static int picolcd_fb_reset(struct picolcd_data *data, int clear)
 
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
@@ -421,6 +440,9 @@ static void picolcd_fb_update(struct picolcd_data *data)
 	int chip, tile, n;
 	unsigned long flags;
 
+	if (!data)
+		return;
+
 	spin_lock_irqsave(&data->lock, flags);
 	if (!(data->status & PICOLCD_READY_FB)) {
 		spin_unlock_irqrestore(&data->lock, flags);
@@ -440,14 +462,18 @@ static void picolcd_fb_update(struct picolcd_data *data)
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
 
@@ -537,18 +570,22 @@ static int picolcd_set_par(struct fb_info *info)
 {
 	struct picolcd_data *data = info->par;
 	u8 *o_fb, *n_fb;
+	int i;
+	unsigned long o_len;
+	if (!data)
+		return -ENODEV;
 	if (info->var.bits_per_pixel == data->fb_bpp)
 		return 0;
 	/* switch between 1/8 bit depths */
 	if (info->var.bits_per_pixel != 1 && info->var.bits_per_pixel != 8)
 		return -EINVAL;
 
-	o_fb = data->fb_bitmap;
-	n_fb = vmalloc(PICOLCDFB_SIZE*info->var.bits_per_pixel);
+	o_len = info->fix.smem_len;
+	o_fb  = data->fb_bitmap;
+	n_fb  = vmalloc(PICOLCDFB_SIZE*info->var.bits_per_pixel);
 	if (!n_fb)
 		return -ENOMEM;
 
-	fb_deferred_io_cleanup(info);
 	/* translate FB content to new bits-per-pixel */
 	if (info->var.bits_per_pixel == 1) {
 		int i, b;
@@ -565,7 +602,7 @@ static int picolcd_set_par(struct fb_info *info)
 		int i;
 		for (i = 0; i < PICOLCDFB_SIZE * 8; i++)
 			n_fb[i] = o_fb[i/8] & (0x01 << (7 - i % 8)) ? 0xff : 0x00;
-		info->fix.visual = FB_VISUAL_TRUECOLOR;
+		info->fix.visual = FB_VISUAL_DIRECTCOLOR;
 		info->fix.line_length = PICOLCDFB_WIDTH;
 	}
 
@@ -574,7 +611,10 @@ static int picolcd_set_par(struct fb_info *info)
 	info->screen_base = (char __force __iomem *)n_fb;
 	info->fix.smem_start = (unsigned long)n_fb;
 	info->fix.smem_len   = PICOLCDFB_SIZE*data->fb_bpp;
-	fb_deferred_io_init(info);
+	for (i = 0; i < o_len; i += PAGE_SIZE) {
+		struct page *page = vmalloc_to_page(o_fb + i);
+		page->mapping = NULL;
+	}
 	vfree(o_fb);
 	return 0;
 }
@@ -660,9 +700,10 @@ static int picolcd_init_framebuffer(struct picolcd_data *data)
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
@@ -678,12 +719,16 @@ static int picolcd_init_framebuffer(struct picolcd_data *data)
 
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
@@ -707,18 +752,20 @@ static int picolcd_init_framebuffer(struct picolcd_data *data)
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
@@ -742,13 +789,13 @@ static void picolcd_exit_framebuffer(struct picolcd_data *data)
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
@@ -2566,6 +2613,11 @@ static void picolcd_remove(struct hid_device *hdev)
 	spin_lock_irqsave(&data->lock, flags);
 	data->status |= PICOLCD_FAILED;
 	spin_unlock_irqrestore(&data->lock, flags);
+	/* short-circuit FB as early as possible in order to
+	 * avoid long delays if we host console.
+	 */
+	if (data->fb_info)
+		data->fb_info->par = NULL;
 
 	picolcd_exit_devfs(data);
 	device_remove_file(&hdev->dev, &dev_attr_operation_mode);
