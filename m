Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab0IXEuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 00:50:21 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60447 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752234Ab0IXEuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 00:50:19 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18iwick8Qwi/pENmjuzTjwQqjGJcHJdR8j4Y/t1mV
	n5u+Rc1qRBrhwm
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 4/4] viafb: fix hardware acceleration for suspend & resume
Date: Fri, 24 Sep 2010 05:01:26 +0000
Message-Id: <50111c5c3b3154da765ec850e9ab6672eb820694.1285303223.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1285303222.git.FlorianSchandinat@gmx.de>
References: <cover.1285303222.git.FlorianSchandinat@gmx.de>
In-Reply-To: <cover.1285303222.git.FlorianSchandinat@gmx.de>
References: <cover.1285303222.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits the acceleration initialization in two parts:
The first is only called during probe and is used to allocate
resources. The second part is also called on resume to reinitalize
the 2D engine. This should fix all acceleration issues after resume
most notable an "invisible" cursor and as we do nothing special it is
reasonable to assume that it works on all supported IGPs.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/accel.c    |   43 +++++++++++++++++++++++++----------------
 drivers/video/via/accel.h    |    3 +-
 drivers/video/via/viafbdev.c |    4 ++-
 3 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/video/via/accel.c b/drivers/video/via/accel.c
index e44893e..ae0bdf6 100644
--- a/drivers/video/via/accel.c
+++ b/drivers/video/via/accel.c
@@ -314,13 +314,11 @@ static int hw_bitblt_2(void __iomem *engine, u8 op, u32 width, u32 height,
 	return 0;
 }
 
-int viafb_init_engine(struct fb_info *info)
+int viafb_setup_engine(struct fb_info *info)
 {
 	struct viafb_par *viapar = info->par;
 	void __iomem *engine;
-	int highest_reg, i;
-	u32 vq_start_addr, vq_end_addr, vq_start_low, vq_end_low, vq_high,
-		vq_len, chip_name = viapar->shared->chip_info.gfx_chip_name;
+	u32 chip_name = viapar->shared->chip_info.gfx_chip_name;
 
 	engine = viapar->shared->vdev->engine_mmio;
 	if (!engine) {
@@ -329,18 +327,6 @@ int viafb_init_engine(struct fb_info *info)
 		return -ENOMEM;
 	}
 
-	/* Initialize registers to reset the 2D engine */
-	switch (viapar->shared->chip_info.twod_engine) {
-	case VIA_2D_ENG_M1:
-		highest_reg = 0x5c;
-		break;
-	default:
-		highest_reg = 0x40;
-		break;
-	}
-	for (i = 0; i <= highest_reg; i += 4)
-		writel(0x0, engine + i);
-
 	switch (chip_name) {
 	case UNICHROME_CLE266:
 	case UNICHROME_K400:
@@ -386,6 +372,29 @@ int viafb_init_engine(struct fb_info *info)
 	viapar->shared->vdev->camera_fbmem_offset = viapar->fbmem_free;
 #endif
 
+	viafb_reset_engine(viapar);
+	return 0;
+}
+
+void viafb_reset_engine(struct viafb_par *viapar)
+{
+	void __iomem *engine = viapar->shared->vdev->engine_mmio;
+	int highest_reg, i;
+	u32 vq_start_addr, vq_end_addr, vq_start_low, vq_end_low, vq_high,
+		vq_len, chip_name = viapar->shared->chip_info.gfx_chip_name;
+
+	/* Initialize registers to reset the 2D engine */
+	switch (viapar->shared->chip_info.twod_engine) {
+	case VIA_2D_ENG_M1:
+		highest_reg = 0x5c;
+		break;
+	default:
+		highest_reg = 0x40;
+		break;
+	}
+	for (i = 0; i <= highest_reg; i += 4)
+		writel(0x0, engine + i);
+
 	/* Init AGP and VQ regs */
 	switch (chip_name) {
 	case UNICHROME_K8M890:
@@ -473,7 +482,7 @@ int viafb_init_engine(struct fb_info *info)
 	writel(0x0, engine + VIA_REG_CURSOR_ORG);
 	writel(0x0, engine + VIA_REG_CURSOR_BG);
 	writel(0x0, engine + VIA_REG_CURSOR_FG);
-	return 0;
+	return;
 }
 
 void viafb_show_hw_cursor(struct fb_info *info, int Status)
diff --git a/drivers/video/via/accel.h b/drivers/video/via/accel.h
index 2c122d2..79d5e10 100644
--- a/drivers/video/via/accel.h
+++ b/drivers/video/via/accel.h
@@ -203,7 +203,8 @@
 #define VIA_BITBLT_MONO		2
 #define VIA_BITBLT_FILL		3
 
-int viafb_init_engine(struct fb_info *info);
+int viafb_setup_engine(struct fb_info *info);
+void viafb_reset_engine(struct viafb_par *viapar);
 void viafb_show_hw_cursor(struct fb_info *info, int Status);
 void viafb_wait_engine_idle(struct fb_info *info);
 
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index c4218ce..fdb1e84 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1512,6 +1512,8 @@ int viafb_resume(struct pci_dev *pdev)
 	if (pci_enable_device(pdev))
 		goto fail;
 	pci_set_master(pdev);
+	if (viaparinfo->shared->vdev->engine_mmio)
+		viafb_reset_engine(viaparinfo);
 	viafb_set_par(viafbinfo);
 	if (viafb_dual_fb)
 		viafb_set_par(viafbinfo1);
@@ -1583,7 +1585,7 @@ int __devinit via_fb_pci_probe(struct viafb_dev *vdev)
 	viafbinfo->flags = FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN;
 
 	viafbinfo->pseudo_palette = pseudo_pal;
-	if (viafb_accel && !viafb_init_engine(viafbinfo)) {
+	if (viafb_accel && !viafb_setup_engine(viafbinfo)) {
 		viafbinfo->flags |= FBINFO_HWACCEL_COPYAREA |
 			FBINFO_HWACCEL_FILLRECT |  FBINFO_HWACCEL_IMAGEBLIT;
 		default_var.accel_flags = FB_ACCELF_TEXT;
-- 
1.6.3.2

