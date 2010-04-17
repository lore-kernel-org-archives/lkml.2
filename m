Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab0DQThK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 15:37:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:46845 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754358Ab0DQThF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 15:37:05 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/yxMxrirry5MKtXv2qzum15wcEjeTWmDkvI4gnrQ
	kJ2gLcXDvDJlWG
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, corbet@lwn.net,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 3/7] viafb: move some modesetting functions to a seperate file
Date: Sat, 17 Apr 2010 19:44:53 +0000
Message-Id: <1271533498-3376-3-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1271533498-3376-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1271533498-3376-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.41999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: move some modesetting functions to a seperate file

This patch moves the modesetting functions which are already cleaned up
to a seperate file.
Just the beginning to bring some structure in this mess.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/Makefile          |    2 +-
 drivers/video/via/hw.c              |   96 --------------------------
 drivers/video/via/hw.h              |    5 +-
 drivers/video/via/via_modesetting.c |  126 +++++++++++++++++++++++++++++++++++
 drivers/video/via/via_modesetting.h |   38 +++++++++++
 5 files changed, 166 insertions(+), 101 deletions(-)
 create mode 100644 drivers/video/via/via_modesetting.c
 create mode 100644 drivers/video/via/via_modesetting.h

diff --git a/drivers/video/via/Makefile b/drivers/video/via/Makefile
index eeed238..6f5b010 100644
--- a/drivers/video/via/Makefile
+++ b/drivers/video/via/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_FB_VIA) += viafb.o
 
-viafb-y	:=viafbdev.o hw.o via_i2c.o dvi.o lcd.o ioctl.o accel.o via_utility.o vt1636.o global.o tblDPASetting.o viamode.o tbl1636.o
+viafb-y	:=viafbdev.o hw.o via_i2c.o dvi.o lcd.o ioctl.o accel.o via_utility.o vt1636.o global.o tblDPASetting.o viamode.o tbl1636.o via_modesetting.o
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 6c6c140..1c3a8f3 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -624,102 +624,6 @@ void viafb_set_iga_path(void)
 	}
 }
 
-void via_set_primary_address(u32 addr)
-{
-	DEBUG_MSG(KERN_DEBUG "via_set_primary_address(0x%08X)\n", addr);
-	via_write_reg(VIACR, 0x0D, addr & 0xFF);
-	via_write_reg(VIACR, 0x0C, (addr >> 8) & 0xFF);
-	via_write_reg(VIACR, 0x34, (addr >> 16) & 0xFF);
-	via_write_reg_mask(VIACR, 0x48, (addr >> 24) & 0x1F, 0x1F);
-}
-
-void via_set_secondary_address(u32 addr)
-{
-	DEBUG_MSG(KERN_DEBUG "via_set_secondary_address(0x%08X)\n", addr);
-	/* secondary display supports only quadword aligned memory */
-	via_write_reg_mask(VIACR, 0x62, (addr >> 2) & 0xFE, 0xFE);
-	via_write_reg(VIACR, 0x63, (addr >> 10) & 0xFF);
-	via_write_reg(VIACR, 0x64, (addr >> 18) & 0xFF);
-	via_write_reg_mask(VIACR, 0xA3, (addr >> 26) & 0x07, 0x07);
-}
-
-void via_set_primary_pitch(u32 pitch)
-{
-	DEBUG_MSG(KERN_DEBUG "via_set_primary_pitch(0x%08X)\n", pitch);
-	/* spec does not say that first adapter skips 3 bits but old
-	 * code did it and seems to be reasonable in analogy to 2nd adapter
-	 */
-	pitch = pitch >> 3;
-	via_write_reg(VIACR, 0x13, pitch & 0xFF);
-	via_write_reg_mask(VIACR, 0x35, (pitch >> (8 - 5)) & 0xE0, 0xE0);
-}
-
-void via_set_secondary_pitch(u32 pitch)
-{
-	DEBUG_MSG(KERN_DEBUG "via_set_secondary_pitch(0x%08X)\n", pitch);
-	pitch = pitch >> 3;
-	via_write_reg(VIACR, 0x66, pitch & 0xFF);
-	via_write_reg_mask(VIACR, 0x67, (pitch >> 8) & 0x03, 0x03);
-	via_write_reg_mask(VIACR, 0x71, (pitch >> (10 - 7)) & 0x80, 0x80);
-}
-
-void via_set_primary_color_depth(u8 depth)
-{
-	u8 value;
-
-	DEBUG_MSG(KERN_DEBUG "via_set_primary_color_depth(%d)\n", depth);
-	switch (depth) {
-	case 8:
-		value = 0x00;
-		break;
-	case 15:
-		value = 0x04;
-		break;
-	case 16:
-		value = 0x14;
-		break;
-	case 24:
-		value = 0x0C;
-		break;
-	case 30:
-		value = 0x08;
-		break;
-	default:
-		printk(KERN_WARNING "via_set_primary_color_depth: "
-			"Unsupported depth: %d\n", depth);
-		return;
-	}
-
-	via_write_reg_mask(VIASR, 0x15, value, 0x1C);
-}
-
-void via_set_secondary_color_depth(u8 depth)
-{
-	u8 value;
-
-	DEBUG_MSG(KERN_DEBUG "via_set_secondary_color_depth(%d)\n", depth);
-	switch (depth) {
-	case 8:
-		value = 0x00;
-		break;
-	case 16:
-		value = 0x40;
-		break;
-	case 24:
-		value = 0xC0;
-		break;
-	case 30:
-		value = 0x80;
-		break;
-	default:
-		printk(KERN_WARNING "via_set_secondary_color_depth: "
-			"Unsupported depth: %d\n", depth);
-		return;
-	}
-
-	via_write_reg_mask(VIACR, 0x67, value, 0xC0);
-}
-
 static void set_color_register(u8 index, u8 red, u8 green, u8 blue)
 {
 	outb(0xFF, 0x3C6); /* bit mask of palette */
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index cb63f22..ddd15df 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -25,6 +25,7 @@
 #include "viamode.h"
 #include "global.h"
 #include "via_io.h"
+#include "via_modesetting.h"
 
 #define viafb_read_reg(p, i)			via_read_reg(p, i)
 #define viafb_write_reg(i, p, d)		via_write_reg(p, i, d)
@@ -912,10 +913,6 @@ void viafb_update_device_setting(int hres, int vres, int bpp,
 
 int viafb_get_fb_size_from_pci(void);
 void viafb_set_iga_path(void);
-void via_set_primary_address(u32 addr);
-void via_set_secondary_address(u32 addr);
-void via_set_primary_pitch(u32 pitch);
-void via_set_secondary_pitch(u32 pitch);
 void viafb_set_primary_color_register(u8 index, u8 red, u8 green, u8 blue);
 void viafb_set_secondary_color_register(u8 index, u8 red, u8 green, u8 blue);
 void viafb_get_fb_info(unsigned int *fb_base, unsigned int *fb_len);
diff --git a/drivers/video/via/via_modesetting.c b/drivers/video/via/via_modesetting.c
new file mode 100644
index 0000000..69ff285
--- /dev/null
+++ b/drivers/video/via/via_modesetting.c
@@ -0,0 +1,126 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+ * Copyright 2010 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+/*
+ * basic modesetting functions
+ */
+
+#include <linux/kernel.h>
+#include "via_modesetting.h"
+#include "via_io.h"
+#include "share.h"
+#include "debug.h"
+
+void via_set_primary_address(u32 addr)
+{
+	DEBUG_MSG(KERN_DEBUG "via_set_primary_address(0x%08X)\n", addr);
+	via_write_reg(VIACR, 0x0D, addr & 0xFF);
+	via_write_reg(VIACR, 0x0C, (addr >> 8) & 0xFF);
+	via_write_reg(VIACR, 0x34, (addr >> 16) & 0xFF);
+	via_write_reg_mask(VIACR, 0x48, (addr >> 24) & 0x1F, 0x1F);
+}
+
+void via_set_secondary_address(u32 addr)
+{
+	DEBUG_MSG(KERN_DEBUG "via_set_secondary_address(0x%08X)\n", addr);
+	/* secondary display supports only quadword aligned memory */
+	via_write_reg_mask(VIACR, 0x62, (addr >> 2) & 0xFE, 0xFE);
+	via_write_reg(VIACR, 0x63, (addr >> 10) & 0xFF);
+	via_write_reg(VIACR, 0x64, (addr >> 18) & 0xFF);
+	via_write_reg_mask(VIACR, 0xA3, (addr >> 26) & 0x07, 0x07);
+}
+
+void via_set_primary_pitch(u32 pitch)
+{
+	DEBUG_MSG(KERN_DEBUG "via_set_primary_pitch(0x%08X)\n", pitch);
+	/* spec does not say that first adapter skips 3 bits but old
+	 * code did it and seems to be reasonable in analogy to 2nd adapter
+	 */
+	pitch = pitch >> 3;
+	via_write_reg(VIACR, 0x13, pitch & 0xFF);
+	via_write_reg_mask(VIACR, 0x35, (pitch >> (8 - 5)) & 0xE0, 0xE0);
+}
+
+void via_set_secondary_pitch(u32 pitch)
+{
+	DEBUG_MSG(KERN_DEBUG "via_set_secondary_pitch(0x%08X)\n", pitch);
+	pitch = pitch >> 3;
+	via_write_reg(VIACR, 0x66, pitch & 0xFF);
+	via_write_reg_mask(VIACR, 0x67, (pitch >> 8) & 0x03, 0x03);
+	via_write_reg_mask(VIACR, 0x71, (pitch >> (10 - 7)) & 0x80, 0x80);
+}
+
+void via_set_primary_color_depth(u8 depth)
+{
+	u8 value;
+
+	DEBUG_MSG(KERN_DEBUG "via_set_primary_color_depth(%d)\n", depth);
+	switch (depth) {
+	case 8:
+		value = 0x00;
+		break;
+	case 15:
+		value = 0x04;
+		break;
+	case 16:
+		value = 0x14;
+		break;
+	case 24:
+		value = 0x0C;
+		break;
+	case 30:
+		value = 0x08;
+		break;
+	default:
+		printk(KERN_WARNING "via_set_primary_color_depth: "
+			"Unsupported depth: %d\n", depth);
+		return;
+	}
+
+	via_write_reg_mask(VIASR, 0x15, value, 0x1C);
+}
+
+void via_set_secondary_color_depth(u8 depth)
+{
+	u8 value;
+
+	DEBUG_MSG(KERN_DEBUG "via_set_secondary_color_depth(%d)\n", depth);
+	switch (depth) {
+	case 8:
+		value = 0x00;
+		break;
+	case 16:
+		value = 0x40;
+		break;
+	case 24:
+		value = 0xC0;
+		break;
+	case 30:
+		value = 0x80;
+		break;
+	default:
+		printk(KERN_WARNING "via_set_secondary_color_depth: "
+			"Unsupported depth: %d\n", depth);
+		return;
+	}
+
+	via_write_reg_mask(VIACR, 0x67, value, 0xC0);
+}
diff --git a/drivers/video/via/via_modesetting.h b/drivers/video/via/via_modesetting.h
new file mode 100644
index 0000000..ae35cfd
--- /dev/null
+++ b/drivers/video/via/via_modesetting.h
@@ -0,0 +1,38 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+ * Copyright 2010 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+/*
+ * basic modesetting functions
+ */
+
+#ifndef __VIA_MODESETTING_H__
+#define __VIA_MODESETTING_H__
+
+#include <linux/types.h>
+
+void via_set_primary_address(u32 addr);
+void via_set_secondary_address(u32 addr);
+void via_set_primary_pitch(u32 pitch);
+void via_set_secondary_pitch(u32 pitch);
+void via_set_primary_color_depth(u8 depth);
+void via_set_secondary_color_depth(u8 depth);
+
+#endif /* __VIA_MODESETTING_H__ */
-- 
1.6.3.2

