Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1AZHVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:21:34 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:45000 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1AZHVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:21:32 -0500
X-Auth-Info: ycrSbpLomRgkbLq5PI3JFqP1uy4jX4BKsqsV2yYzHgQ=
From: Heiko Schocher <hs@denx.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: Heiko Schocher <hs@denx.de>, linux-fbdev@vger.kernel.org,
        devicetree-discuss@ozlabs.org, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 3/4 v5] video, sm501: add OF binding to support SM501
Date: Wed, 26 Jan 2011 08:21:30 +0100
Message-Id: <1296026490-14665-1-git-send-email-hs@denx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1291451028-22532-1-git-send-email-hs@denx.de>
References: <1291451028-22532-1-git-send-email-hs@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- add binding to OF, compatible name "smi,sm501"

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
      - get rid of "#if defined(CONFIG_PPC_MPC52xx)" usage
        hide this in DTS, as Paul suggested.
    - i/o routine patch
    - edid support patch
- changes since v4
  replace remaining CONFIG_PPC_MPC52xx with CONFIG_OF, as
  it is no longer MPC52xx only.
- changes since v5
  free edid_data after its usage, as it is no longer needed,
  suggested from Paul Mundt. Also fall back to default if
  kmemdup(edid_data) fails.

./scripts/checkpatch.pl 0003-video-sm501-add-OF-binding-to-support-SM501.patch
total: 0 errors, 0 warnings, 132 lines checked

0003-video-sm501-add-OF-binding-to-support-SM501.patch has no obvious style problems and is ready for submission.

 Documentation/powerpc/dts-bindings/sm501.txt |   34 +++++++++++++++++++++
 drivers/mfd/sm501.c                          |    9 +++++-
 drivers/video/sm501fb.c                      |   42 ++++++++++++++++++++++++--
 3 files changed, 81 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/sm501.txt

diff --git a/Documentation/powerpc/dts-bindings/sm501.txt b/Documentation/powerpc/dts-bindings/sm501.txt
new file mode 100644
index 0000000..7d319fb
--- /dev/null
+++ b/Documentation/powerpc/dts-bindings/sm501.txt
@@ -0,0 +1,34 @@
+* SM SM501
+
+The SM SM501 is a LCD controller, with proper hardware, it can also
+drive DVI monitors.
+
+Required properties:
+- compatible : should be "smi,sm501".
+- reg : contain two entries:
+    - First entry: System Configuration register
+    - Second entry: IO space (Display Controller register)
+- interrupts : SMI interrupt to the cpu should be described here.
+- interrupt-parent : the phandle for the interrupt controller that
+  services interrupts for this device.
+
+Optional properties:
+- mode : select a video mode:
+    <xres>x<yres>[-<bpp>][@<refresh>]
+- edid : verbatim EDID data block describing attached display.
+  Data from the detailed timing descriptor will be used to
+  program the display controller.
+- little-endian: availiable on big endian systems, to
+  set different foreign endian.
+- big-endian: availiable on little endian systems, to
+  set different foreign endian.
+
+Example for MPC5200:
+	display@1,0 {
+		compatible = "smi,sm501";
+		reg = <1 0x00000000 0x00800000
+		       1 0x03e00000 0x00200000>;
+		interrupts = <1 1 3>;
+		mode = "640x480-32@60";
+		edid = [edid-data];
+	};
diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 558d5f3..df3702c 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1377,7 +1377,7 @@ static int __devinit sm501_init_dev(struct sm501_devdata *sm)
 			sm501_register_gpio(sm);
 	}
 
-	if (pdata->gpio_i2c != NULL && pdata->gpio_i2c_nr > 0) {
+	if (pdata && pdata->gpio_i2c != NULL && pdata->gpio_i2c_nr > 0) {
 		if (!sm501_gpio_isregistered(sm))
 			dev_err(sm->dev, "no gpio available for i2c gpio.\n");
 		else
@@ -1422,6 +1422,7 @@ static int __devinit sm501_plat_probe(struct platform_device *dev)
 
 	sm->io_res = platform_get_resource(dev, IORESOURCE_MEM, 1);
 	sm->mem_res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+
 	if (sm->io_res == NULL || sm->mem_res == NULL) {
 		dev_err(&dev->dev, "failed to get IO resource\n");
 		ret = -ENOENT;
@@ -1735,10 +1736,16 @@ static struct pci_driver sm501_pci_driver = {
 
 MODULE_ALIAS("platform:sm501");
 
+static struct of_device_id __devinitdata of_sm501_match_tbl[] = {
+	{ .compatible = "smi,sm501", },
+	{ /* end */ }
+};
+
 static struct platform_driver sm501_plat_driver = {
 	.driver		= {
 		.name	= "sm501",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_sm501_match_tbl,
 	},
 	.probe		= sm501_plat_probe,
 	.remove		= sm501_plat_remove,
diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
index d60b2a2..92b001d 100644
--- a/drivers/video/sm501fb.c
+++ b/drivers/video/sm501fb.c
@@ -1729,6 +1729,15 @@ static int sm501fb_init_fb(struct fb_info *fb,
 		FBINFO_HWACCEL_COPYAREA | FBINFO_HWACCEL_FILLRECT |
 		FBINFO_HWACCEL_XPAN | FBINFO_HWACCEL_YPAN;
 
+#if defined(CONFIG_OF)
+#ifdef __BIG_ENDIAN
+	if (of_get_property(info->dev->parent->of_node, "little-endian", NULL))
+		fb->flags |= FBINFO_FOREIGN_ENDIAN;
+#else
+	if (of_get_property(info->dev->parent->of_node, "big-endian", NULL))
+		fb->flags |= FBINFO_FOREIGN_ENDIAN;
+#endif
+#endif
 	/* fixed data */
 
 	fb->fix.type		= FB_TYPE_PACKED_PIXELS;
@@ -1765,14 +1774,17 @@ static int sm501fb_init_fb(struct fb_info *fb,
 			fb->var.xres_virtual = fb->var.xres;
 			fb->var.yres_virtual = fb->var.yres;
 		} else {
-			if (info->edid_data)
+			if (info->edid_data) {
 				ret = fb_find_mode(&fb->var, fb, fb_mode,
 					fb->monspecs.modedb,
 					fb->monspecs.modedb_len,
 					&sm501_default_mode, default_bpp);
-			else
+				/* edid_data is no longer needed, free it */
+				kfree(info->edid_data);
+			} else {
 				ret = fb_find_mode(&fb->var, fb,
 					   NULL, NULL, 0, NULL, 8);
+			}
 
 			switch (ret) {
 			case 1:
@@ -1933,8 +1945,32 @@ static int __devinit sm501fb_probe(struct platform_device *pdev)
 	}
 
 	if (info->pdata == NULL) {
-		dev_info(dev, "using default configuration data\n");
+		int found = 0;
+#if defined(CONFIG_OF)
+		struct device_node *np = pdev->dev.parent->of_node;
+		const u8 *prop;
+		const char *cp;
+		int len;
+
 		info->pdata = &sm501fb_def_pdata;
+		if (np) {
+			/* Get EDID */
+			cp = of_get_property(np, "mode", &len);
+			if (cp)
+				strcpy(fb_mode, cp);
+			prop = of_get_property(np, "edid", &len);
+			if (prop && len == EDID_LENGTH) {
+				info->edid_data = kmemdup(prop, EDID_LENGTH,
+							  GFP_KERNEL);
+				if (info->edid_data)
+					found = 1;
+			}
+		}
+#endif
+		if (!found) {
+			dev_info(dev, "using default configuration data\n");
+			info->pdata = &sm501fb_def_pdata;
+		}
 	}
 
 	/* probe for the presence of each panel */
-- 
1.7.3.4

