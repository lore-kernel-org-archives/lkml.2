Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0KVMm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 07:42:56 -0500
Received: from mail.bspu.unibel.by ([195.50.2.21]:58323 "EHLO mail.bspu.local"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754244Ab0KVMmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 07:42:55 -0500
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Nov 2010 07:42:55 EST
Message-ID: <4CEA62BB.9040403@bspu.unibel.by>
Date: Mon, 22 Nov 2010 14:31:55 +0200
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b7pre) Gecko/20101111 Firefox/4.0b7pre SeaMonkey/2.1b1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] viafb: I2C/DDC LCD detection for VIA framebuffer
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I2C/DDC LCD detection for VIA framebuffer

Adding legacy I2C/DDC support for VIA framebuffer, used to fix LCD
panel size and (if "via_active_dev" is empty default) force LCD
detection. This solving at least defaults on Chrome9 video
on HP mini 2133 notebook, but must be good in other cases,
include double-LCD. Also forcing viafb_active_dev to NULL as bugfix.

Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>
---
diff -pruN a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
--- a/drivers/video/via/via-core.c	2010-11-22 13:11:44.000000000 +0200
+++ b/drivers/video/via/via-core.c	2010-11-22 13:59:07.000000000 +0200
@@ -2,6 +2,7 @@
  * Copyright 1998-2009 VIA Technologies, Inc. All Rights Reserved.
  * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
  * Copyright 2009 Jonathan Corbet <corbet@lwn.net>
+ * Copyright 2010 Dzianis Kahanovich <mahatma@eu.by>
  */

 /*
@@ -16,6 +17,8 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>

+extern char *viafb_active_dev;
+
 /*
  * The default port config.
  */
@@ -576,6 +579,56 @@ static void via_teardown_subdevs(void)
 }

+static void via_i2c_detect(void)
+{
+	const u8 *edid;
+	struct fb_var_screeninfo var;
+	int i, n = 0;
+	struct i2c_adapter *adapter;
+
+	for (i = 0; i < VIAFB_NUM_PORTS; i++) {
+		adapter = viafb_find_i2c_adapter(i);
+		if (!adapter || !adapter->algo_data ||
+		    !(edid = fb_ddc_read(adapter)))
+			continue;
+		if (fb_parse_edid(edid, &var))
+			goto free_edid;
+		if (n) {
+			fb_edid_to_monspecs(edid, &viafbinfo1->monspecs);
+			viaparinfo->lvds_setting_info2->lcd_panel_hres =
+			    var.xres;
+			viaparinfo->lvds_setting_info2->lcd_panel_vres =
+			    var.yres;
+			if (!viafb_active_dev) {
+				viafb_SAMM_ON = STATE_ON;
+				if (viafbinfo1->monspecs.input & FB_DISP_DDI)
+					viafb_LCD2_ON = STATE_ON;
+			}
+		} else {
+			fb_edid_to_monspecs(edid, &viafbinfo->monspecs);
+			viaparinfo->lvds_setting_info->lcd_panel_hres =
+			    var.xres;
+			viaparinfo->lvds_setting_info->lcd_panel_vres =
+			    var.yres;
+			if (!viafb_active_dev) {
+				viafb_DVI_ON =
+				    viaparinfo->tmds_setting_info->
+				    max_hres ? STATE_ON : STATE_OFF;
+				if (viafbinfo->monspecs.input & FB_DISP_DDI) {
+					viafb_DeviceStatus = LCD_Device;
+					viafb_primary_dev = LCD_Device;
+					viafb_LCD_ON = STATE_ON;
+				}
+			}
+		}
+		n++;
+free_edid:
+		kfree(edid);
+		if (n > 1)
+			break;
+	}
+}
+

 static int __devinit via_pci_probe(struct pci_dev *pdev,
 		const struct pci_device_id *ent)
 {
@@ -607,6 +660,7 @@ static int __devinit via_pci_probe(struc
 	ret = via_fb_pci_probe(&global_dev);
 	if (ret)
 		goto out_subdevs;
+	via_i2c_detect();
 	return 0;

 out_subdevs:
diff -pruN a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c	2010-11-22 13:11:44.000000000 +0200
+++ b/drivers/video/via/viafbdev.c	2010-11-22 13:59:07.000000000 +0200
@@ -43,7 +43,7 @@ static int viafb_second_size;
 static int viafb_accel = 1;

 /* Added for specifying active devices.*/
-char *viafb_active_dev;
+char *viafb_active_dev = NULL;

 /*Added for specify lcd output port*/
 char *viafb_lcd_port = "";
--

-- 
WBR, Dzianis Kahanovich AKA Denis Kaganovich, http://mahatma.bspu.unibel.by/
