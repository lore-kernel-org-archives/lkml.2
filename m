Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab0F1Uet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 16:34:49 -0400
Received: from legolas.restena.lu ([158.64.1.34]:39010 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab0F1Ueo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 16:34:44 -0400
Date: Mon, 28 Jun 2010 22:30:29 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] HID: picolcd: Add minimal palette required by fbcon on
 8bpp
Message-ID: <20100628223029.4f4e5b8e@neptune.home>
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

Add a minimal palette so fbcon does not try to dereference
a NULL point when fb is set to 8bpp.

fbcon stores pixels the other way around in bytes for 1bpp
than intially implemented, correct this.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/hid-picolcd.c |   62 +++++++++++++++++++++++++++++++++++++--------
 1 files changed, 51 insertions(+), 11 deletions(-)

diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index 883d720..ac7aece 100644
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
@@ -440,7 +458,8 @@ static void picolcd_fb_update(struct picolcd_data *data)
 	for (chip = 0; chip < 4; chip++)
 		for (tile = 0; tile < 8; tile++)
 			if (picolcd_fb_update_tile(data->fb_vbitmap,
-					data->fb_bitmap, data->fb_bpp, chip, tile)) {
+					data->fb_bitmap, data->fb_bpp, chip, tile) ||
+				data->fb_force) {
 				n += 2;
 				if (n >= HID_OUTPUT_FIFO_SIZE / 2) {
 					usbhid_wait_io(data->hdev);
@@ -448,6 +467,7 @@ static void picolcd_fb_update(struct picolcd_data *data)
 				}
 				picolcd_fb_send_tile(data->hdev, chip, tile);
 			}
+	data->fb_force = false;
 	if (n)
 		usbhid_wait_io(data->hdev);
 }
@@ -526,10 +546,17 @@ static int picolcd_fb_check_var(struct fb_var_screeninfo *var, struct fb_info *i
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
 
@@ -660,9 +687,10 @@ static int picolcd_init_framebuffer(struct picolcd_data *data)
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
@@ -678,12 +706,23 @@ static int picolcd_init_framebuffer(struct picolcd_data *data)
 
 	data->fb_update_rate = PICOLCDFB_UPDATE_RATE_DEFAULT;
 	data->fb_defio = picolcd_fb_defio;
-	info = framebuffer_alloc(0, dev);
+	/* The extra memory is:
+	 * - struct picolcd_fb_cleanup_item
+	 * - u32 for ref_count
+	 * - 256*u32 for pseudo_palette
+	 */
+	info = framebuffer_alloc(257 * sizeof(u32), dev);
 	if (info == NULL) {
 		dev_err(dev, "failed to allocate a framebuffer\n");
 		goto err_nomem;
 	}
 
+	palette  = info->par;
+	*palette = 1;
+	palette++;
+	for (i = 0; i < 256; i++)
+		palette[i] = i > 0 && i < 16 ? 0xff : 0;
+	info->pseudo_palette = palette;
 	info->fbdefio = &data->fb_defio;
 	info->screen_base = (char __force __iomem *)fb_bitmap;
 	info->fbops = &picolcdfb_ops;
@@ -715,6 +754,7 @@ static int picolcd_init_framebuffer(struct picolcd_data *data)
 		goto err_sysfs;
 	}
 	/* schedule first output of framebuffer */
+	data->fb_force = 1;
 	schedule_delayed_work(&info->deferred_work, 0);
 	return 0;
 
-- 
1.7.1

