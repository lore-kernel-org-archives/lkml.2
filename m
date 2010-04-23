Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab0DWIBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:01:21 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:40822 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab0DWIAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:00:44 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 04/14] m68k: amiga - Frame buffer platform device conversion
Date: Fri, 23 Apr 2010 10:00:25 +0200
Message-Id: <1272009635-6504-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1272009635-6504-4-git-send-email-geert@linux-m68k.org>
References: <1272009635-6504-1-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-2-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-3-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-4-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/platform.c |   15 +++++++++++++
 drivers/video/amifb.c      |   49 +++++++++++++++++++++++++++----------------
 2 files changed, 46 insertions(+), 18 deletions(-)

diff --git a/arch/m68k/amiga/platform.c b/arch/m68k/amiga/platform.c
index 33a7669..7fa929c 100644
--- a/arch/m68k/amiga/platform.c
+++ b/arch/m68k/amiga/platform.c
@@ -56,3 +56,18 @@ static int __init amiga_init_bus(void)
 subsys_initcall(amiga_init_bus);
 
 #endif /* CONFIG_ZORRO */
+
+
+static int __init amiga_init_devices(void)
+{
+	if (!MACH_IS_AMIGA)
+		return -ENODEV;
+
+	/* video hardware */
+	if (AMIGAHW_PRESENT(AMI_VIDEO))
+		platform_device_register_simple("amiga-video", -1, NULL, 0);
+
+	return 0;
+}
+
+device_initcall(amiga_init_devices);
diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
index dca48df..e5d6b56 100644
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -50,8 +50,9 @@
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
-
+#include <linux/platform_device.h>
 #include <linux/uaccess.h>
+
 #include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/amigahw.h>
@@ -1135,7 +1136,7 @@ static int amifb_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg
 	 * Interface to the low level console driver
 	 */
 
-static void amifb_deinit(void);
+static void amifb_deinit(struct platform_device *pdev);
 
 	/*
 	 * Internal routines
@@ -2246,7 +2247,7 @@ static inline void chipfree(void)
 	 * Initialisation
 	 */
 
-static int __init amifb_init(void)
+static int __init amifb_probe(struct platform_device *pdev)
 {
 	int tag, i, err = 0;
 	u_long chipptr;
@@ -2261,16 +2262,6 @@ static int __init amifb_init(void)
 	}
 	amifb_setup(option);
 #endif
-	if (!MACH_IS_AMIGA || !AMIGAHW_PRESENT(AMI_VIDEO))
-		return -ENODEV;
-
-	/*
-	 * We request all registers starting from bplpt[0]
-	 */
-	if (!request_mem_region(CUSTOM_PHYSADDR+0xe0, 0x120,
-				"amifb [Denise/Lisa]"))
-		return -EBUSY;
-
 	custom.dmacon = DMAF_ALL | DMAF_MASTER;
 
 	switch (amiga_chipset) {
@@ -2377,6 +2368,7 @@ default_chipset:
 	fb_info.fbops = &amifb_ops;
 	fb_info.par = &currentpar;
 	fb_info.flags = FBINFO_DEFAULT;
+	fb_info.device = &pdev->dev;
 
 	if (!fb_find_mode(&fb_info.var, &fb_info, mode_option, ami_modedb,
 			  NUM_TOTAL_MODES, &ami_modedb[defmode], 4)) {
@@ -2451,18 +2443,18 @@ default_chipset:
 	return 0;
 
 amifb_error:
-	amifb_deinit();
+	amifb_deinit(pdev);
 	return err;
 }
 
-static void amifb_deinit(void)
+static void amifb_deinit(struct platform_device *pdev)
 {
 	if (fb_info.cmap.len)
 		fb_dealloc_cmap(&fb_info.cmap);
+	fb_dealloc_cmap(&fb_info.cmap);
 	chipfree();
 	if (videomemory)
 		iounmap((void*)videomemory);
-	release_mem_region(CUSTOM_PHYSADDR+0xe0, 0x120);
 	custom.dmacon = DMAF_ALL | DMAF_MASTER;
 }
 
@@ -3794,14 +3786,35 @@ static void ami_rebuild_copper(void)
 	}
 }
 
-static void __exit amifb_exit(void)
+static int __exit amifb_remove(struct platform_device *pdev)
 {
 	unregister_framebuffer(&fb_info);
-	amifb_deinit();
+	amifb_deinit(pdev);
 	amifb_video_off();
+	return 0;
+}
+
+static struct platform_driver amifb_driver = {
+	.remove = __exit_p(amifb_remove),
+	.driver   = {
+		.name	= "amiga-video",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init amifb_init(void)
+{
+	return platform_driver_probe(&amifb_driver, amifb_probe);
 }
 
 module_init(amifb_init);
+
+static void __exit amifb_exit(void)
+{
+	platform_driver_unregister(&amifb_driver);
+}
+
 module_exit(amifb_exit);
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:amiga-video");
-- 
1.6.0.4

