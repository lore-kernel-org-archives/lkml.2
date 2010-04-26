Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab0DZSB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 14:01:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:38281 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754395Ab0DZSBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 14:01:52 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18GvH4nptwG1IWYOTnqVbwAuwxC3m+ssv4dWa2ET3
	Ix2OZBvJm9ZJg9
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, corbet@lwn.net,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 4/4] viafb: fix hardware acceleration for suspend & resume
Date: Mon, 26 Apr 2010 18:09:47 +0000
Message-Id: <1272305387-4872-5-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1272305387-4872-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1272305387-4872-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: fix hardware acceleration for suspend & resume

This patch splits the acceleration initialization in two parts:
The first is only called during probe and is used to allocate
resources. The second part is also called on resume to reinitalize
the 2D engine. This should fix all acceleration issues after resume
most notable an "invisible" cursor and as we do nothing special it is
reasonable to assume that it works on all supported IGPs.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/accel.c    |   41 +++++++++++++++++++++++++----------------
 drivers/video/via/accel.h    |    1 +
 drivers/video/via/viafbdev.c |    1 +
 3 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/video/via/accel.c b/drivers/video/via/accel.c
index 0d90c85..726c153 100644
--- a/drivers/video/via/accel.c
+++ b/drivers/video/via/accel.c
@@ -317,9 +317,7 @@ int viafb_init_engine(struct fb_info *info)
 {
 	struct viafb_par *viapar = info->par;
 	void __iomem *engine;
-	int highest_reg, i;
-	u32 vq_start_addr, vq_end_addr, vq_start_low, vq_end_low, vq_high,
-		vq_len, chip_name = viapar->shared->chip_info.gfx_chip_name;
+	u32 chip_name = viapar->shared->chip_info.gfx_chip_name;
 
 	engine = ioremap_nocache(info->fix.mmio_start, info->fix.mmio_len);
 	viapar->shared->engine_mmio = engine;
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
@@ -370,6 +356,29 @@ int viafb_init_engine(struct fb_info *info)
 	viapar->shared->vq_vram_addr = viapar->fbmem_free;
 	viapar->fbmem_used += VQ_SIZE;
 
+	viafb_start_engine(viapar);
+	return 0;
+}
+
+void viafb_start_engine(struct viafb_par *viapar)
+{
+	void __iomem *engine = viapar->shared->engine_mmio;
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
@@ -457,7 +466,7 @@ int viafb_init_engine(struct fb_info *info)
 	writel(0x0, engine + VIA_REG_CURSOR_ORG);
 	writel(0x0, engine + VIA_REG_CURSOR_BG);
 	writel(0x0, engine + VIA_REG_CURSOR_FG);
-	return 0;
+	return;
 }
 
 void viafb_show_hw_cursor(struct fb_info *info, int Status)
diff --git a/drivers/video/via/accel.h b/drivers/video/via/accel.h
index 2c122d2..5352f87 100644
--- a/drivers/video/via/accel.h
+++ b/drivers/video/via/accel.h
@@ -204,6 +204,7 @@
 #define VIA_BITBLT_FILL		3
 
 int viafb_init_engine(struct fb_info *info);
+void viafb_start_engine(struct viafb_par *viapar);
 void viafb_show_hw_cursor(struct fb_info *info, int Status);
 void viafb_wait_engine_idle(struct fb_info *info);
 
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 86d3ded..bbf0f70 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1759,6 +1759,7 @@ static int viafb_resume(struct pci_dev *pdev)
 	if (pci_enable_device(pdev))
 		goto fail;
 	pci_set_master(pdev);
+	viafb_start_engine(viafbinfo->par);
 	viafb_set_par(viafbinfo);
 	if (viafb_dual_fb)
 		viafb_set_par(viafbinfo1);
-- 
1.6.3.2

