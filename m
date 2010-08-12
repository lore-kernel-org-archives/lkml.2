Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470Ab0HLAAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:00:08 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56034 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759409Ab0HKX7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:48 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+DjCc7LjqDFIvmsGQk+9RhNSCfzuL/BJoT7ZJtPS
	80kdNguuWo2s37
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: [[PATCH 09/11]] viafb: add new output device management
Date: Thu, 12 Aug 2010 00:10:06 +0000
Message-Id: <1281571806-9013-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: add new output device management

This patch adds a new output device management that stores for each
IGA which output devices are routed to it and a compatiblity layer
that converts the old per-output device values in the new format.
Bounding the output devices to each IGA is a central idea of the
cleanup. Doing it this way should be easier and make much more sense
than the old format which happily mixed different output devices
together and did not even take into account that some devices are no
longer available on newer chipsets.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
---
 drivers/video/via/hw.c       |  102 ++++++++++++++++++++++++++++++++++++++++++
 drivers/video/via/hw.h       |    9 ++++
 drivers/video/via/viafbdev.h |    3 +
 3 files changed, 114 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 638cf96..30cc2f0 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -753,6 +753,66 @@ void write_dac_reg(u8 index, u8 r, u8 g, u8 b)
 	outb(b, LUT_DATA);
 }
 
+static u32 get_dvi_devices(int output_interface)
+{
+	switch (output_interface) {
+	case INTERFACE_DVP0:
+		return VIA_96 | VIA_6C;
+
+	case INTERFACE_DVP1:
+		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
+			return VIA_93;
+		else
+			return VIA_DVP1;
+
+	case INTERFACE_DFP_HIGH:
+		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
+			return 0;
+		else
+			return VIA_LVDS2 | VIA_96;
+
+	case INTERFACE_DFP_LOW:
+		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
+			return 0;
+		else
+			return VIA_DVP1 | VIA_LVDS1;
+
+	case INTERFACE_TMDS:
+		return VIA_LVDS1;
+	}
+
+	return 0;
+}
+
+static u32 get_lcd_devices(int output_interface)
+{
+	switch (output_interface) {
+	case INTERFACE_DVP0:
+		return VIA_96;
+
+	case INTERFACE_DVP1:
+		return VIA_DVP1;
+
+	case INTERFACE_DFP_HIGH:
+		return VIA_LVDS2 | VIA_96;
+
+	case INTERFACE_DFP_LOW:
+		return VIA_LVDS1 | VIA_DVP1;
+
+	case INTERFACE_DFP:
+		return VIA_LVDS1 | VIA_LVDS2;
+
+	case INTERFACE_LVDS0:
+	case INTERFACE_LVDS0LVDS1:
+		return VIA_LVDS1;
+
+	case INTERFACE_LVDS1:
+		return VIA_LVDS2;
+	}
+
+	return 0;
+}
+
 /*Set IGA path for each device*/
 void viafb_set_iga_path(void)
 {
@@ -819,6 +879,48 @@ void viafb_set_iga_path(void)
 			viaparinfo->tmds_setting_info->iga_path = IGA1;
 		}
 	}
+
+	viaparinfo->shared->iga1_devices = 0;
+	viaparinfo->shared->iga2_devices = 0;
+	if (viafb_CRT_ON) {
+		if (viaparinfo->crt_setting_info->iga_path == IGA1)
+			viaparinfo->shared->iga1_devices |= VIA_CRT;
+		else
+			viaparinfo->shared->iga2_devices |= VIA_CRT;
+	}
+
+	if (viafb_DVI_ON) {
+		if (viaparinfo->tmds_setting_info->iga_path == IGA1)
+			viaparinfo->shared->iga1_devices |= get_dvi_devices(
+				viaparinfo->chip_info->
+				tmds_chip_info.output_interface);
+		else
+			viaparinfo->shared->iga2_devices |= get_dvi_devices(
+				viaparinfo->chip_info->
+				tmds_chip_info.output_interface);
+	}
+
+	if (viafb_LCD_ON) {
+		if (viaparinfo->lvds_setting_info->iga_path == IGA1)
+			viaparinfo->shared->iga1_devices |= get_lcd_devices(
+				viaparinfo->chip_info->
+				lvds_chip_info.output_interface);
+		else
+			viaparinfo->shared->iga2_devices |= get_lcd_devices(
+				viaparinfo->chip_info->
+				lvds_chip_info.output_interface);
+	}
+
+	if (viafb_LCD2_ON) {
+		if (viaparinfo->lvds_setting_info2->iga_path == IGA1)
+			viaparinfo->shared->iga1_devices |= get_lcd_devices(
+				viaparinfo->chip_info->
+				lvds_chip_info2.output_interface);
+		else
+			viaparinfo->shared->iga2_devices |= get_lcd_devices(
+				viaparinfo->chip_info->
+				lvds_chip_info2.output_interface);
+	}
 }
 
 static void set_color_register(u8 index, u8 red, u8 green, u8 blue)
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index 39f3a69..c52a1d5 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -30,6 +30,15 @@
 #define viafb_write_reg(i, p, d)		via_write_reg(p, i, d)
 #define viafb_write_reg_mask(i, p, d, m)	via_write_reg_mask(p, i, d, m)
 
+/* VIA output devices */
+#define VIA_6C		0x00000001
+#define VIA_93		0x00000002
+#define VIA_96		0x00000004
+#define VIA_CRT		0x00000010
+#define VIA_DVP1	0x00000020
+#define VIA_LVDS1	0x00000040
+#define VIA_LVDS2	0x00000080
+
 /***************************************************
 * Definition IGA1 Design Method of CRTC Registers *
 ****************************************************/
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
index 52a35fa..945a47a 100644
--- a/drivers/video/via/viafbdev.h
+++ b/drivers/video/via/viafbdev.h
@@ -40,6 +40,9 @@
 #define VIAFB_NUM_I2C		5
 
 struct viafb_shared {
+	u32 iga1_devices;
+	u32 iga2_devices;
+
 	struct proc_dir_entry *proc_entry;	/*viafb proc entry */
 	struct viafb_dev *vdev;			/* Global dev info */
 
-- 
1.6.3.2

