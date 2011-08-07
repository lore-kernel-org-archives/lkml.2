Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab1HGXpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 19:45:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48702 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab1HGXpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 19:45:21 -0400
From: stufever@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, FlorianSchandinat@gmx.de, lethal@linux-sh.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: [PATCH V2] viafb: replace strict_strtoul to kstrto* and check return value
Date: Mon,  8 Aug 2011 07:42:33 +0800
Message-Id: <1312760553-2143-1-git-send-email-wangshaoyan.pt@taobao.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

This commit replace the function strict_strtoul(becasue commit 33ee3b2e), and check the return value to avoid such warning:

  drivers/video/via/viafbdev.c:1992: warning: ignoring return value of 'kstrtoul', declared with attribute warn_unused_result

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 drivers/video/via/viafbdev.c |  126 ++++++++++++++++++++++-------------------
 1 files changed, 68 insertions(+), 58 deletions(-)

Change since V1:
  1.use kstrto*, not kstrtoul
  2.replace &buf[0] to buf

diff --git drivers/video/via/viafbdev.c drivers/video/via/viafbdev.c
index 53aa443..0186cd7 100644
--- drivers/video/via/viafbdev.c
+++ drivers/video/via/viafbdev.c
@@ -1158,7 +1158,8 @@ static ssize_t viafb_dvp0_proc_write(struct file *file,
 	for (i = 0; i < 3; i++) {
 		value = strsep(&pbuf, " ");
 		if (value != NULL) {
-			strict_strtoul(value, 0, (unsigned long *)&reg_val);
+			if (kstrtou8(value, 0, &reg_val) < 0)
+				return -EINVAL;
 			DEBUG_MSG(KERN_INFO "DVP0:reg_val[%l]=:%x\n", i,
 				  reg_val);
 			switch (i) {
@@ -1228,7 +1229,8 @@ static ssize_t viafb_dvp1_proc_write(struct file *file,
 	for (i = 0; i < 3; i++) {
 		value = strsep(&pbuf, " ");
 		if (value != NULL) {
-			strict_strtoul(value, 0, (unsigned long *)&reg_val);
+			if (kstrtou8(value, 0, &reg_val) < 0)
+				return -EINVAL;
 			switch (i) {
 			case 0:
 				viafb_write_reg_mask(CR9B, VIACR,
@@ -1286,7 +1288,8 @@ static ssize_t viafb_dfph_proc_write(struct file *file,
 	if (copy_from_user(&buf[0], buffer, length))
 		return -EFAULT;
 	buf[length - 1] = '\0';	/*Ensure end string */
-	strict_strtoul(&buf[0], 0, (unsigned long *)&reg_val);
+	if (kstrtou8(buf, 0, &reg_val) < 0)
+		return -EINVAL;
 	viafb_write_reg_mask(CR97, VIACR, reg_val, 0x0f);
 	return count;
 }
@@ -1325,7 +1328,8 @@ static ssize_t viafb_dfpl_proc_write(struct file *file,
 	if (copy_from_user(&buf[0], buffer, length))
 		return -EFAULT;
 	buf[length - 1] = '\0';	/*Ensure end string */
-	strict_strtoul(&buf[0], 0, (unsigned long *)&reg_val);
+	if (kstrtou8(buf, -1, &reg_val) < 0)
+		return -EINVAL;
 	viafb_write_reg_mask(CR99, VIACR, reg_val, 0x0f);
 	return count;
 }
@@ -1394,8 +1398,8 @@ static ssize_t viafb_vt1636_proc_write(struct file *file,
 		for (i = 0; i < 2; i++) {
 			value = strsep(&pbuf, " ");
 			if (value != NULL) {
-				strict_strtoul(value, 0,
-					(unsigned long *)&reg_val.Data);
+				if (kstrtou8(value, 0, &reg_val.Data) < 0)
+					return -EINVAL;
 				switch (i) {
 				case 0:
 					reg_val.Index = 0x08;
@@ -1431,8 +1435,8 @@ static ssize_t viafb_vt1636_proc_write(struct file *file,
 		for (i = 0; i < 2; i++) {
 			value = strsep(&pbuf, " ");
 			if (value != NULL) {
-				strict_strtoul(value, 0,
-					(unsigned long *)&reg_val.Data);
+				if (kstrtou8(value, 0, &reg_val.Data) < 0)
+					return -EINVAL;
 				switch (i) {
 				case 0:
 					reg_val.Index = 0x08;
@@ -1950,61 +1954,67 @@ static int __init viafb_setup(void)
 		if (!*this_opt)
 			continue;
 
-		if (!strncmp(this_opt, "viafb_mode1=", 12))
+		if (!strncmp(this_opt, "viafb_mode1=", 12)) {
 			viafb_mode1 = kstrdup(this_opt + 12, GFP_KERNEL);
-		else if (!strncmp(this_opt, "viafb_mode=", 11))
+		} else if (!strncmp(this_opt, "viafb_mode=", 11)) {
 			viafb_mode = kstrdup(this_opt + 11, GFP_KERNEL);
-		else if (!strncmp(this_opt, "viafb_bpp1=", 11))
-			strict_strtoul(this_opt + 11, 0,
-				(unsigned long *)&viafb_bpp1);
-		else if (!strncmp(this_opt, "viafb_bpp=", 10))
-			strict_strtoul(this_opt + 10, 0,
-				(unsigned long *)&viafb_bpp);
-		else if (!strncmp(this_opt, "viafb_refresh1=", 15))
-			strict_strtoul(this_opt + 15, 0,
-				(unsigned long *)&viafb_refresh1);
-		else if (!strncmp(this_opt, "viafb_refresh=", 14))
-			strict_strtoul(this_opt + 14, 0,
-				(unsigned long *)&viafb_refresh);
-		else if (!strncmp(this_opt, "viafb_lcd_dsp_method=", 21))
-			strict_strtoul(this_opt + 21, 0,
-				(unsigned long *)&viafb_lcd_dsp_method);
-		else if (!strncmp(this_opt, "viafb_lcd_panel_id=", 19))
-			strict_strtoul(this_opt + 19, 0,
-				(unsigned long *)&viafb_lcd_panel_id);
-		else if (!strncmp(this_opt, "viafb_accel=", 12))
-			strict_strtoul(this_opt + 12, 0,
-				(unsigned long *)&viafb_accel);
-		else if (!strncmp(this_opt, "viafb_SAMM_ON=", 14))
-			strict_strtoul(this_opt + 14, 0,
-				(unsigned long *)&viafb_SAMM_ON);
-		else if (!strncmp(this_opt, "viafb_active_dev=", 17))
+		} else if (!strncmp(this_opt, "viafb_bpp1=", 11)) {
+			if (kstrtouint(this_opt + 11, 0, &viafb_bpp1) < 0)
+				return -EINVAL;
+		} else if (!strncmp(this_opt, "viafb_bpp=", 10)) {
+			if (kstrtouint(this_opt + 10, 0, &viafb_bpp) < 0)
+				return -EINVAL;
+		} else if (!strncmp(this_opt, "viafb_refresh1=", 15)) {
+			if (kstrtoint(this_opt + 15, 0, &viafb_refresh1) < 0)
+				return -EINVAL;
+		} else if (!strncmp(this_opt, "viafb_refresh=", 14)) {
+			if (kstrtoint(this_opt + 14, 0, &viafb_refresh) < 0)
+				return -EINVAL;
+		} else if (!strncmp(this_opt, "viafb_lcd_dsp_method=", 21)) {
+			if (kstrtoint(this_opt + 21, 0,
+				      &viafb_lcd_dsp_method) < 0)
+				return -EINVAL;
+		} else if (!strncmp(this_opt, "viafb_lcd_panel_id=", 19)) {
+			if (kstrtoint(this_opt + 19, 0,
+				      &viafb_lcd_panel_id) < 0)
+				return -EINVAL;
+		} else if (!strncmp(this_opt, "viafb_accel=", 12)) {
+			if (kstrtoint(this_opt + 12, 0, &viafb_accel) < 0)
+				return -EINVAL;
+		} else if (!strncmp(this_opt, "viafb_SAMM_ON=", 14)) {
+			if (kstrtoint(this_opt + 14, 0, &viafb_SAMM_ON) < 0)
+				return -EINVAL;
+		} else if (!strncmp(this_opt, "viafb_active_dev=", 17)) {
 			viafb_active_dev = kstrdup(this_opt + 17, GFP_KERNEL);
-		else if (!strncmp(this_opt,
-			"viafb_display_hardware_layout=", 30))
-			strict_strtoul(this_opt + 30, 0,
-			(unsigned long *)&viafb_display_hardware_layout);
-		else if (!strncmp(this_opt, "viafb_second_size=", 18))
-			strict_strtoul(this_opt + 18, 0,
-				(unsigned long *)&viafb_second_size);
-		else if (!strncmp(this_opt,
-			"viafb_platform_epia_dvi=", 24))
-			strict_strtoul(this_opt + 24, 0,
-				(unsigned long *)&viafb_platform_epia_dvi);
-		else if (!strncmp(this_opt,
-			"viafb_device_lcd_dualedge=", 26))
-			strict_strtoul(this_opt + 26, 0,
-				(unsigned long *)&viafb_device_lcd_dualedge);
-		else if (!strncmp(this_opt, "viafb_bus_width=", 16))
-			strict_strtoul(this_opt + 16, 0,
-				(unsigned long *)&viafb_bus_width);
-		else if (!strncmp(this_opt, "viafb_lcd_mode=", 15))
-			strict_strtoul(this_opt + 15, 0,
-				(unsigned long *)&viafb_lcd_mode);
-		else if (!strncmp(this_opt, "viafb_lcd_port=", 15))
+		} else if (!strncmp(this_opt,
+			"viafb_display_hardware_layout=", 30)) {
+			if (kstrtoint(this_opt + 30, 0,
+				      &viafb_display_hardware_layout) < 0)
+				return -EINVAL;
+		} else if (!strncmp(this_opt, "viafb_second_size=", 18)) {
+			if (kstrtoint(this_opt + 18, 0, &viafb_second_size) < 0)
+				return -EINVAL;
+		} else if (!strncmp(this_opt,
+			"viafb_platform_epia_dvi=", 24)) {
+			if (kstrtoint(this_opt + 24, 0,
+				      &viafb_platform_epia_dvi) < 0)
+				return -EINVAL;
+		} else if (!strncmp(this_opt,
+			"viafb_device_lcd_dualedge=", 26)) {
+			if (kstrtoint(this_opt + 26, 0,
+				      &viafb_device_lcd_dualedge) < 0)
+				return -EINVAL;
+		} else if (!strncmp(this_opt, "viafb_bus_width=", 16)) {
+			if (kstrtoint(this_opt + 16, 0, &viafb_bus_width) < 0)
+				return -EINVAL;
+		} else if (!strncmp(this_opt, "viafb_lcd_mode=", 15)) {
+			if (kstrtoint(this_opt + 15, 0, &viafb_lcd_mode) < 0)
+				return -EINVAL;
+		} else if (!strncmp(this_opt, "viafb_lcd_port=", 15)) {
 			viafb_lcd_port = kstrdup(this_opt + 15, GFP_KERNEL);
-		else if (!strncmp(this_opt, "viafb_dvi_port=", 15))
+		} else if (!strncmp(this_opt, "viafb_dvi_port=", 15)) {
 			viafb_dvi_port = kstrdup(this_opt + 15, GFP_KERNEL);
+		}
 	}
 	return 0;
 }
-- 
1.7.0.4

