Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab0DRSVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 14:21:37 -0400
Received: from tex.lwn.net ([70.33.254.29]:35350 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757371Ab0DRSVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 14:21:32 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 05/11] viafb: Unify duplicated set_bpp() code
Date: Sun, 18 Apr 2010 12:21:07 -0600
Message-Id: <1271614873-5952-6-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1271614873-5952-1-git-send-email-corbet@lwn.net>
References: <1271614873-5952-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Florian: make both mode-setting paths use the same code.

Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: ScottFang@viatech.com.cn
Cc: JosephChan@via.com.tw
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/accel.c |   78 +++++++++++++++++++--------------------------
 1 files changed, 33 insertions(+), 45 deletions(-)

diff --git a/drivers/video/via/accel.c b/drivers/video/via/accel.c
index a52147c..7c1d9c4 100644
--- a/drivers/video/via/accel.c
+++ b/drivers/video/via/accel.c
@@ -20,12 +20,42 @@
  */
 #include "global.h"
 
+/*
+ * Figure out an appropriate bytes-per-pixel setting.
+ */
+static int viafb_set_bpp(void __iomem *engine, u8 bpp)
+{
+	u32 gemode;
+
+	/* Preserve the reserved bits */
+	/* Lowest 2 bits to zero gives us no rotation */
+	gemode = readl(engine + VIA_REG_GEMODE) & 0xfffffcfc;
+	switch (bpp) {
+	case 8:
+		gemode |= VIA_GEM_8bpp;
+		break;
+	case 16:
+		gemode |= VIA_GEM_16bpp;
+		break;
+	case 32:
+		gemode |= VIA_GEM_32bpp;
+		break;
+	default:
+		printk(KERN_WARNING "viafb_set_bpp: Unsupported bpp %d\n", bpp);
+		return -EINVAL;
+	}
+	writel(gemode, engine + VIA_REG_GEMODE);
+	return 0;
+}
+
+
 static int hw_bitblt_1(void __iomem *engine, u8 op, u32 width, u32 height,
 	u8 dst_bpp, u32 dst_addr, u32 dst_pitch, u32 dst_x, u32 dst_y,
 	u32 *src_mem, u32 src_addr, u32 src_pitch, u32 src_x, u32 src_y,
 	u32 fg_color, u32 bg_color, u8 fill_rop)
 {
 	u32 ge_cmd = 0, tmp, i;
+	int ret;
 
 	if (!op || op > 3) {
 		printk(KERN_WARNING "hw_bitblt_1: Invalid operation: %d\n", op);
@@ -59,22 +89,9 @@ static int hw_bitblt_1(void __iomem *engine, u8 op, u32 width, u32 height,
 		}
 	}
 
-	switch (dst_bpp) {
-	case 8:
-		tmp = 0x00000000;
-		break;
-	case 16:
-		tmp = 0x00000100;
-		break;
-	case 32:
-		tmp = 0x00000300;
-		break;
-	default:
-		printk(KERN_WARNING "hw_bitblt_1: Unsupported bpp %d\n",
-			dst_bpp);
-		return -EINVAL;
-	}
-	writel(tmp, engine + 0x04);
+	ret = viafb_set_bpp(engine, dst_bpp);
+	if (ret)
+		return ret;
 
 	if (op != VIA_BITBLT_FILL) {
 		if (src_x & (op == VIA_BITBLT_MONO ? 0xFFFF8000 : 0xFFFFF000)
@@ -165,35 +182,6 @@ static int hw_bitblt_1(void __iomem *engine, u8 op, u32 width, u32 height,
 	return 0;
 }
 
-/*
- * Figure out an appropriate bytes-per-pixel setting.
- */
-static int viafb_set_bpp(void __iomem *engine, u8 bpp)
-{
-	u32 gemode;
-
-	/* Preserve the reserved bits */
-	/* Lowest 2 bits to zero gives us no rotation */
-	gemode = readl(engine + VIA_REG_GEMODE) & 0xfffffcfc;
-	switch (bpp) {
-	case 8:
-		gemode |= VIA_GEM_8bpp;
-		break;
-	case 16:
-		gemode |= VIA_GEM_16bpp;
-		break;
-	case 32:
-		gemode |= VIA_GEM_32bpp;
-		break;
-	default:
-		printk(KERN_WARNING "hw_bitblt_2: Unsupported bpp %d\n", bpp);
-		return -EINVAL;
-	}
-	writel(gemode, engine + VIA_REG_GEMODE);
-	return 0;
-}
-
-
 static int hw_bitblt_2(void __iomem *engine, u8 op, u32 width, u32 height,
 	u8 dst_bpp, u32 dst_addr, u32 dst_pitch, u32 dst_x, u32 dst_y,
 	u32 *src_mem, u32 src_addr, u32 src_pitch, u32 src_x, u32 src_y,
-- 
1.7.0.1

