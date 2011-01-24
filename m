Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab1AXJ5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 04:57:33 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:49678 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1AXJ5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 04:57:30 -0500
X-Auth-Info: HNQOm8q4g2W0snavqeH4+W0vPotR9jN19f61/oAThg0=
From: Heiko Schocher <hs@denx.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: Heiko Schocher <hs@denx.de>, linux-fbdev@vger.kernel.org,
        devicetree-discuss@ozlabs.org, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 2/4 v4] video, sm501: add edid and commandline support
Date: Mon, 24 Jan 2011 10:57:27 +0100
Message-Id: <1295863047-11131-1-git-send-email-hs@denx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1291451028-22532-1-git-send-email-hs@denx.de>
References: <1291451028-22532-1-git-send-email-hs@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- add commandline options:
  sm501fb.mode:
    Specify resolution as "<xres>x<yres>[-<bpp>][@<refresh>]"
  sm501fb.bpp:
    Specify bit-per-pixel if not specified mode

- Add support for encoding display mode information
  in the device tree using verbatim EDID block.

  If the "edid" entry in the "smi,sm501" node is present,
  the driver will build mode database using EDID data
  and allow setting the display modes from this database.

Signed-off-by: Heiko Schocher <hs@denx.de>
cc: linux-fbdev@vger.kernel.org
cc: devicetree-discuss@ozlabs.org
cc: Ben Dooks <ben@simtec.co.uk>
cc: Vincent Sanders <vince@simtec.co.uk>
cc: Samuel Ortiz <sameo@linux.intel.com>
cc: linux-kernel@vger.kernel.org
cc: Randy Dunlap <rdunlap@xenotime.net>
cc: Paul Mundt <lethal@linux-sh.org>

---
- changes since v1:
  add Ben Dooks, Vincent Sanders and Samuel Ortiz to cc, as suggested from
  Paul Mundt.
- changes since v2:
  add comments from Randy Dunlap:
  - move parameter documentation to Documentation/fb/sm501.txt
- changes since v3:
  - rebased against v2.6.38-rc2
  - split in 3 patches
    - of support patch
    - i/o routine patch
    - edid support patch

./scripts/checkpatch.pl 0002-video-sm501-add-edid-and-commandline-support.patch
total: 0 errors, 0 warnings, 123 lines checked

0002-video-sm501-add-edid-and-commandline-support.patch has no obvious style problems and is ready for submission.

 Documentation/fb/sm501.txt |   10 ++++++
 drivers/video/sm501fb.c    |   67 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 71 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/fb/sm501.txt

diff --git a/Documentation/fb/sm501.txt b/Documentation/fb/sm501.txt
new file mode 100644
index 0000000..8d17aeb
--- /dev/null
+++ b/Documentation/fb/sm501.txt
@@ -0,0 +1,10 @@
+Configuration:
+
+You can pass the following kernel command line options to sm501 videoframebuffer:
+
+	sm501fb.bpp=	SM501 Display driver:
+			Specifiy bits-per-pixel if not specified by 'mode'
+
+	sm501fb.mode=	SM501 Display driver:
+			Specify resolution as
+			"<xres>x<yres>[-<bpp>][@<refresh>]"
diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
index c5b4b95..30b53ae 100644
--- a/drivers/video/sm501fb.c
+++ b/drivers/video/sm501fb.c
@@ -41,6 +41,26 @@
 #include <linux/sm501.h>
 #include <linux/sm501-regs.h>
 
+#include "edid.h"
+
+static char *fb_mode = "640x480-16@60";
+static unsigned long default_bpp = 16;
+
+static struct fb_videomode __devinitdata sm501_default_mode = {
+	.refresh	= 60,
+	.xres		= 640,
+	.yres		= 480,
+	.pixclock	= 20833,
+	.left_margin	= 142,
+	.right_margin	= 13,
+	.upper_margin	= 21,
+	.lower_margin	= 1,
+	.hsync_len	= 69,
+	.vsync_len	= 3,
+	.sync		= FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	.vmode		= FB_VMODE_NONINTERLACED
+};
+
 #define NR_PALETTE	256
 
 enum sm501_controller {
@@ -77,6 +97,7 @@ struct sm501fb_info {
 	void __iomem		*regs2d;	/* 2d remapped registers */
 	void __iomem		*fbmem;		/* remapped framebuffer */
 	size_t			 fbmem_len;	/* length of remapped region */
+	u8 *edid_data;
 };
 
 /* per-framebuffer private data */
@@ -1725,9 +1746,16 @@ static int sm501fb_init_fb(struct fb_info *fb,
 	fb->var.vmode		= FB_VMODE_NONINTERLACED;
 	fb->var.bits_per_pixel  = 16;
 
+	if (info->edid_data) {
+			/* Now build modedb from EDID */
+			fb_edid_to_monspecs(info->edid_data, &fb->monspecs);
+			fb_videomode_to_modelist(fb->monspecs.modedb,
+						 fb->monspecs.modedb_len,
+						 &fb->modelist);
+	}
+
 	if (enable && (pd->flags & SM501FB_FLAG_USE_INIT_MODE) && 0) {
 		/* TODO read the mode from the current display */
-
 	} else {
 		if (pd->def_mode) {
 			dev_info(info->dev, "using supplied mode\n");
@@ -1737,12 +1765,34 @@ static int sm501fb_init_fb(struct fb_info *fb,
 			fb->var.xres_virtual = fb->var.xres;
 			fb->var.yres_virtual = fb->var.yres;
 		} else {
-			ret = fb_find_mode(&fb->var, fb,
+			if (info->edid_data)
+				ret = fb_find_mode(&fb->var, fb, fb_mode,
+					fb->monspecs.modedb,
+					fb->monspecs.modedb_len,
+					&sm501_default_mode, default_bpp);
+			else
+				ret = fb_find_mode(&fb->var, fb,
 					   NULL, NULL, 0, NULL, 8);
 
-			if (ret == 0 || ret == 4) {
-				dev_err(info->dev,
-					"failed to get initial mode\n");
+			switch (ret) {
+			case 1:
+				dev_info(info->dev, "using mode specified in "
+						"@mode\n");
+				break;
+			case 2:
+				dev_info(info->dev, "using mode specified in "
+					"@mode with ignored refresh rate\n");
+				break;
+			case 3:
+				dev_info(info->dev, "using mode default "
+					"mode\n");
+				break;
+			case 4:
+				dev_info(info->dev, "using mode from list\n");
+				break;
+			default:
+				dev_info(info->dev, "ret = %d\n", ret);
+				dev_info(info->dev, "failed to find mode\n");
 				return -EINVAL;
 			}
 		}
@@ -1827,6 +1877,7 @@ static void sm501_free_init_fb(struct sm501fb_info *info,
 {
 	struct fb_info *fbi = info->fb[head];
 
+	kfree(info->edid_data);
 	fb_dealloc_cmap(&fbi->cmap);
 }
 
@@ -1884,7 +1935,6 @@ static int __devinit sm501fb_probe(struct platform_device *pdev)
 
 	if (info->pdata == NULL) {
 		dev_info(dev, "using default configuration data\n");
-		info->pdata = &sm501fb_def_pdata;
 	}
 
 	/* probe for the presence of each panel */
@@ -2157,6 +2207,11 @@ static void __exit sm501fb_cleanup(void)
 module_init(sm501fb_init);
 module_exit(sm501fb_cleanup);
 
+module_param_named(mode, fb_mode, charp, 0);
+MODULE_PARM_DESC(mode,
+	"Specify resolution as \"<xres>x<yres>[-<bpp>][@<refresh>]\" ");
+module_param_named(bpp, default_bpp, ulong, 0);
+MODULE_PARM_DESC(bpp, "Specify bit-per-pixel if not specified mode");
 MODULE_AUTHOR("Ben Dooks, Vincent Sanders");
 MODULE_DESCRIPTION("SM501 Framebuffer driver");
 MODULE_LICENSE("GPL v2");
-- 
1.7.3.4

