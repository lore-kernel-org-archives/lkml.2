Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab0D1WTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:19:11 -0400
Received: from tex.lwn.net ([70.33.254.29]:48918 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285Ab0D1WS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:18:29 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 28/30] viafb: improve misc register handling
Date: Wed, 28 Apr 2010 16:17:29 -0600
Message-Id: <1272493051-25380-29-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272493051-25380-1-git-send-email-corbet@lwn.net>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

viafb: improve misc register handling

This patch improves the misc register handling by adding a modify
function for this to via_io.h and moving expanded definitions of the
relevant ports there. The code was changed to use those to improve
readability.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c     |   27 ++++++++-------------------
 drivers/video/via/share.h  |    2 --
 drivers/video/via/via_io.h |    9 +++++++++
 3 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index b2bb24e..e356fe8 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1394,8 +1394,6 @@ u32 viafb_get_clk_value(int clk)
 /* Set VCLK*/
 void viafb_set_vclock(u32 CLK, int set_iga)
 {
-	unsigned char RegTemp;
-
 	/* H.W. Reset : ON */
 	viafb_write_reg_mask(CR17, VIACR, 0x00, BIT7);
 
@@ -1468,8 +1466,7 @@ void viafb_set_vclock(u32 CLK, int set_iga)
 	}
 
 	/* Fire! */
-	RegTemp = inb(VIARMisc);
-	outb(RegTemp | (BIT2 + BIT3), VIAWMisc);
+	via_write_misc_reg_mask(0x0C, 0x0C); /* select external clock */
 }
 
 void viafb_load_crtc_timing(struct display_timing device_timing,
@@ -1713,6 +1710,7 @@ void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
 	int index = 0;
 	int h_addr, v_addr;
 	u32 pll_D_N;
+	u8 polarity = 0;
 
 	for (i = 0; i < video_mode->mode_array; i++) {
 		index = i;
@@ -1741,20 +1739,11 @@ void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
 	v_addr = crt_reg.ver_addr;
 
 	/* update polarity for CRT timing */
-	if (crt_table[index].h_sync_polarity == NEGATIVE) {
-		if (crt_table[index].v_sync_polarity == NEGATIVE)
-			outb((inb(VIARMisc) & (~(BIT6 + BIT7))) |
-			     (BIT6 + BIT7), VIAWMisc);
-		else
-			outb((inb(VIARMisc) & (~(BIT6 + BIT7))) | (BIT6),
-			     VIAWMisc);
-	} else {
-		if (crt_table[index].v_sync_polarity == NEGATIVE)
-			outb((inb(VIARMisc) & (~(BIT6 + BIT7))) | (BIT7),
-			     VIAWMisc);
-		else
-			outb((inb(VIARMisc) & (~(BIT6 + BIT7))), VIAWMisc);
-	}
+	if (crt_table[index].h_sync_polarity == NEGATIVE)
+		polarity |= BIT6;
+	if (crt_table[index].v_sync_polarity == NEGATIVE)
+		polarity |= BIT7;
+	via_write_misc_reg_mask(polarity, BIT6 | BIT7);
 
 	if (set_iga == IGA1) {
 		viafb_unlock_crt();
@@ -2123,7 +2112,7 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 
 	/* Fill VPIT Parameters */
 	/* Write Misc Register */
-	outb(VPIT.Misc, VIAWMisc);
+	outb(VPIT.Misc, VIA_MISC_REG_WRITE);
 
 	/* Write Sequencer */
 	for (i = 1; i <= StdSR; i++)
diff --git a/drivers/video/via/share.h b/drivers/video/via/share.h
index f974c73..861b414 100644
--- a/drivers/video/via/share.h
+++ b/drivers/video/via/share.h
@@ -45,8 +45,6 @@
 
 /* standard VGA IO port
 */
-#define VIARMisc    0x3CC
-#define VIAWMisc    0x3C2
 #define VIAStatus   0x3DA
 #define VIACR       0x3D4
 #define VIASR       0x3C4
diff --git a/drivers/video/via/via_io.h b/drivers/video/via/via_io.h
index e1c1093..a3d2aca 100644
--- a/drivers/video/via/via_io.h
+++ b/drivers/video/via/via_io.h
@@ -29,6 +29,9 @@
 #include <linux/types.h>
 #include <linux/io.h>
 
+#define VIA_MISC_REG_READ	0x03CC
+#define VIA_MISC_REG_WRITE	0x03C2
+
 /*
  * Indexed port operations.  Note that these are all multi-op
  * functions; every invocation will be racy if you're not holding
@@ -55,4 +58,10 @@ static inline void via_write_reg_mask(u16 port, u8 index, u8 data, u8 mask)
 	outb((data & mask) | (old & ~mask), port + 1);
 }
 
+static inline void via_write_misc_reg_mask(u8 data, u8 mask)
+{
+	u8 old = inb(VIA_MISC_REG_READ);
+	outb((data & mask) | (old & ~mask), VIA_MISC_REG_WRITE);
+}
+
 #endif /* __VIA_IO_H__ */
-- 
1.7.0.1

