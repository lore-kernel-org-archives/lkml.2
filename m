Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220Ab3AGFEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:04:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39531 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab3AGFEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:04:02 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, <nsekhar@ti.com>,
        <hvaibhav@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH v2 01/10] video: da8xx-fb: fb_check_var enhancement
Date: Mon, 7 Jan 2013 10:34:47 +0530
Message-ID: <55042f1892250bb83d66bc17f4ccfdee25a51ba0.1357303978.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1357303978.git.afzal@ti.com>
References: <cover.1357303978.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check whether "struct fb_var_screeninfo" fields are sane, if not
update it to be within allowed limits.

If user sends down buggy "var" values, this will bring those within
allowable limits. And fb_set_par is not supposed to change "var"
values, fb_check_var has to ensure that values are proper.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 46534e0..89446aa 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -888,6 +888,9 @@ static int fb_check_var(struct fb_var_screeninfo *var,
 			struct fb_info *info)
 {
 	int err = 0;
+	struct da8xx_fb_par *par = info->par;
+	int bpp = var->bits_per_pixel >> 3;
+	unsigned long line_size = var->xres_virtual * bpp;
 
 	if (var->bits_per_pixel > 16 && lcd_revision == LCD_VERSION_1)
 		return -EINVAL;
@@ -955,6 +958,21 @@ static int fb_check_var(struct fb_var_screeninfo *var,
 	var->green.msb_right = 0;
 	var->blue.msb_right = 0;
 	var->transp.msb_right = 0;
+
+	if (line_size * var->yres_virtual > par->vram_size)
+		var->yres_virtual = par->vram_size / line_size;
+
+	if (var->yres > var->yres_virtual)
+		var->yres = var->yres_virtual;
+
+	if (var->xres > var->xres_virtual)
+		var->xres = var->xres_virtual;
+
+	if (var->xres + var->xoffset > var->xres_virtual)
+		var->xoffset = var->xres_virtual - var->xres;
+	if (var->yres + var->yoffset > var->yres_virtual)
+		var->yoffset = var->yres_virtual - var->yres;
+
 	return err;
 }
 
-- 
1.7.9.5

