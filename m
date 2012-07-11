Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab2GKNvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:51:08 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:40949 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932561Ab2GKNuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:50:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAG6E/U9bdWOb/2dsb2JhbABFt16BB4IgAQEFJ1IQIDE8GwcSiBG9V5EuA5U6kAaCYQ
X-IronPort-AV: E=Sophos;i="4.77,568,1336341600"; 
   d="scan'208";a="541808136"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 7/9] staging: sm7xxfb: minor maintenance on timing path
Date: Wed, 11 Jul 2012 15:49:39 +0200
Message-Id: <1342014581-2979-8-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1342014581-2979-1-git-send-email-jmunhoz@igalia.com>
References: <1342014581-2979-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patch keeps smtc_set_timing and sm7xx_set_timing functions closed
to smtcfb_setmode. This change eases reviewing and maintaining this
logic path.

Tested with SM712.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |  238 ++++++++++++++++++-------------------
 1 file changed, 119 insertions(+), 119 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 119f6d1..9dd2ef7 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -135,125 +135,6 @@ static int __init sm7xx_vga_setup(char *options)
 }
 __setup("vga=", sm7xx_vga_setup);
 
-static void sm7xx_set_timing(struct smtcfb_info *sfb)
-{
-	int i = 0, j = 0;
-	u32 m_nScreenStride;
-
-	dev_dbg(&sfb->pdev->dev,
-		"sfb->width=%d sfb->height=%d "
-		"sfb->fb.var.bits_per_pixel=%d sfb->hz=%d\n",
-		sfb->width, sfb->height, sfb->fb.var.bits_per_pixel, sfb->hz);
-
-	for (j = 0; j < numVGAModes; j++) {
-		if (VGAMode[j].mmSizeX == sfb->width &&
-		    VGAMode[j].mmSizeY == sfb->height &&
-		    VGAMode[j].bpp == sfb->fb.var.bits_per_pixel &&
-		    VGAMode[j].hz == sfb->hz) {
-
-			dev_dbg(&sfb->pdev->dev,
-				"VGAMode[j].mmSizeX=%d VGAMode[j].mmSizeY=%d "
-				"VGAMode[j].bpp=%d VGAMode[j].hz=%d\n",
-				VGAMode[j].mmSizeX, VGAMode[j].mmSizeY,
-				VGAMode[j].bpp, VGAMode[j].hz);
-
-			dev_dbg(&sfb->pdev->dev, "VGAMode index=%d\n", j);
-
-			smtc_mmiowb(0x0, 0x3c6);
-
-			smtc_seqw(0, 0x1);
-
-			smtc_mmiowb(VGAMode[j].Init_MISC, 0x3c2);
-
-			/* init SEQ register SR00 - SR04 */
-			for (i = 0; i < SIZE_SR00_SR04; i++)
-				smtc_seqw(i, VGAMode[j].Init_SR00_SR04[i]);
-
-			/* init SEQ register SR10 - SR24 */
-			for (i = 0; i < SIZE_SR10_SR24; i++)
-				smtc_seqw(i + 0x10,
-					  VGAMode[j].Init_SR10_SR24[i]);
-
-			/* init SEQ register SR30 - SR75 */
-			for (i = 0; i < SIZE_SR30_SR75; i++)
-				if (((i + 0x30) != 0x62) \
-					&& ((i + 0x30) != 0x6a) \
-					&& ((i + 0x30) != 0x6b))
-					smtc_seqw(i + 0x30,
-						VGAMode[j].Init_SR30_SR75[i]);
-
-			/* init SEQ register SR80 - SR93 */
-			for (i = 0; i < SIZE_SR80_SR93; i++)
-				smtc_seqw(i + 0x80,
-					  VGAMode[j].Init_SR80_SR93[i]);
-
-			/* init SEQ register SRA0 - SRAF */
-			for (i = 0; i < SIZE_SRA0_SRAF; i++)
-				smtc_seqw(i + 0xa0,
-					  VGAMode[j].Init_SRA0_SRAF[i]);
-
-			/* init Graphic register GR00 - GR08 */
-			for (i = 0; i < SIZE_GR00_GR08; i++)
-				smtc_grphw(i, VGAMode[j].Init_GR00_GR08[i]);
-
-			/* init Attribute register AR00 - AR14 */
-			for (i = 0; i < SIZE_AR00_AR14; i++)
-				smtc_attrw(i, VGAMode[j].Init_AR00_AR14[i]);
-
-			/* init CRTC register CR00 - CR18 */
-			for (i = 0; i < SIZE_CR00_CR18; i++)
-				smtc_crtcw(i, VGAMode[j].Init_CR00_CR18[i]);
-
-			/* init CRTC register CR30 - CR4D */
-			for (i = 0; i < SIZE_CR30_CR4D; i++)
-				smtc_crtcw(i + 0x30,
-					   VGAMode[j].Init_CR30_CR4D[i]);
-
-			/* init CRTC register CR90 - CRA7 */
-			for (i = 0; i < SIZE_CR90_CRA7; i++)
-				smtc_crtcw(i + 0x90,
-					   VGAMode[j].Init_CR90_CRA7[i]);
-		}
-	}
-	smtc_mmiowb(0x67, 0x3c2);
-
-	/* set VPR registers */
-	writel(0x0, sfb->m_pVPR + 0x0C);
-	writel(0x0, sfb->m_pVPR + 0x40);
-
-	/* set data width */
-	m_nScreenStride =
-		(sfb->width * sfb->fb.var.bits_per_pixel) / 64;
-	switch (sfb->fb.var.bits_per_pixel) {
-	case 8:
-		writel(0x0, sfb->m_pVPR + 0x0);
-		break;
-	case 16:
-		writel(0x00020000, sfb->m_pVPR + 0x0);
-		break;
-	case 24:
-		writel(0x00040000, sfb->m_pVPR + 0x0);
-		break;
-	case 32:
-		writel(0x00030000, sfb->m_pVPR + 0x0);
-		break;
-	}
-	writel((u32) (((m_nScreenStride + 2) << 16) | m_nScreenStride),
-	       sfb->m_pVPR + 0x10);
-
-}
-
-static void smtc_set_timing(struct smtcfb_info *sfb)
-{
-	switch (sfb->chip_id) {
-	case 0x710:
-	case 0x712:
-	case 0x720:
-		sm7xx_set_timing(sfb);
-		break;
-	}
-}
-
 static void sm712_setpalette(int regno, unsigned red, unsigned green,
 			     unsigned blue, struct fb_info *info)
 {
@@ -581,6 +462,125 @@ smtcfb_write(struct fb_info *info, const char __user *buf, size_t count,
 }
 #endif	/* ! __BIG_ENDIAN */
 
+static void sm7xx_set_timing(struct smtcfb_info *sfb)
+{
+	int i = 0, j = 0;
+	u32 m_nScreenStride;
+
+	dev_dbg(&sfb->pdev->dev,
+		"sfb->width=%d sfb->height=%d "
+		"sfb->fb.var.bits_per_pixel=%d sfb->hz=%d\n",
+		sfb->width, sfb->height, sfb->fb.var.bits_per_pixel, sfb->hz);
+
+	for (j = 0; j < numVGAModes; j++) {
+		if (VGAMode[j].mmSizeX == sfb->width &&
+		    VGAMode[j].mmSizeY == sfb->height &&
+		    VGAMode[j].bpp == sfb->fb.var.bits_per_pixel &&
+		    VGAMode[j].hz == sfb->hz) {
+
+			dev_dbg(&sfb->pdev->dev,
+				"VGAMode[j].mmSizeX=%d VGAMode[j].mmSizeY=%d "
+				"VGAMode[j].bpp=%d VGAMode[j].hz=%d\n",
+				VGAMode[j].mmSizeX, VGAMode[j].mmSizeY,
+				VGAMode[j].bpp, VGAMode[j].hz);
+
+			dev_dbg(&sfb->pdev->dev, "VGAMode index=%d\n", j);
+
+			smtc_mmiowb(0x0, 0x3c6);
+
+			smtc_seqw(0, 0x1);
+
+			smtc_mmiowb(VGAMode[j].Init_MISC, 0x3c2);
+
+			/* init SEQ register SR00 - SR04 */
+			for (i = 0; i < SIZE_SR00_SR04; i++)
+				smtc_seqw(i, VGAMode[j].Init_SR00_SR04[i]);
+
+			/* init SEQ register SR10 - SR24 */
+			for (i = 0; i < SIZE_SR10_SR24; i++)
+				smtc_seqw(i + 0x10,
+					  VGAMode[j].Init_SR10_SR24[i]);
+
+			/* init SEQ register SR30 - SR75 */
+			for (i = 0; i < SIZE_SR30_SR75; i++)
+				if (((i + 0x30) != 0x62) \
+					&& ((i + 0x30) != 0x6a) \
+					&& ((i + 0x30) != 0x6b))
+					smtc_seqw(i + 0x30,
+						VGAMode[j].Init_SR30_SR75[i]);
+
+			/* init SEQ register SR80 - SR93 */
+			for (i = 0; i < SIZE_SR80_SR93; i++)
+				smtc_seqw(i + 0x80,
+					  VGAMode[j].Init_SR80_SR93[i]);
+
+			/* init SEQ register SRA0 - SRAF */
+			for (i = 0; i < SIZE_SRA0_SRAF; i++)
+				smtc_seqw(i + 0xa0,
+					  VGAMode[j].Init_SRA0_SRAF[i]);
+
+			/* init Graphic register GR00 - GR08 */
+			for (i = 0; i < SIZE_GR00_GR08; i++)
+				smtc_grphw(i, VGAMode[j].Init_GR00_GR08[i]);
+
+			/* init Attribute register AR00 - AR14 */
+			for (i = 0; i < SIZE_AR00_AR14; i++)
+				smtc_attrw(i, VGAMode[j].Init_AR00_AR14[i]);
+
+			/* init CRTC register CR00 - CR18 */
+			for (i = 0; i < SIZE_CR00_CR18; i++)
+				smtc_crtcw(i, VGAMode[j].Init_CR00_CR18[i]);
+
+			/* init CRTC register CR30 - CR4D */
+			for (i = 0; i < SIZE_CR30_CR4D; i++)
+				smtc_crtcw(i + 0x30,
+					   VGAMode[j].Init_CR30_CR4D[i]);
+
+			/* init CRTC register CR90 - CRA7 */
+			for (i = 0; i < SIZE_CR90_CRA7; i++)
+				smtc_crtcw(i + 0x90,
+					   VGAMode[j].Init_CR90_CRA7[i]);
+		}
+	}
+	smtc_mmiowb(0x67, 0x3c2);
+
+	/* set VPR registers */
+	writel(0x0, sfb->m_pVPR + 0x0C);
+	writel(0x0, sfb->m_pVPR + 0x40);
+
+	/* set data width */
+	m_nScreenStride =
+		(sfb->width * sfb->fb.var.bits_per_pixel) / 64;
+	switch (sfb->fb.var.bits_per_pixel) {
+	case 8:
+		writel(0x0, sfb->m_pVPR + 0x0);
+		break;
+	case 16:
+		writel(0x00020000, sfb->m_pVPR + 0x0);
+		break;
+	case 24:
+		writel(0x00040000, sfb->m_pVPR + 0x0);
+		break;
+	case 32:
+		writel(0x00030000, sfb->m_pVPR + 0x0);
+		break;
+	}
+	writel((u32) (((m_nScreenStride + 2) << 16) | m_nScreenStride),
+	       sfb->m_pVPR + 0x10);
+
+}
+
+static void smtc_set_timing(struct smtcfb_info *sfb)
+{
+	switch (sfb->chip_id) {
+	case 0x710:
+	case 0x712:
+	case 0x720:
+		sm7xx_set_timing(sfb);
+		break;
+	}
+}
+
 void smtcfb_setmode(struct smtcfb_info *sfb)
 {
 	switch (sfb->fb.var.bits_per_pixel) {
-- 
1.7.10

