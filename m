Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab0D1WTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:19:37 -0400
Received: from tex.lwn.net ([70.33.254.29]:48915 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932284Ab0D1WS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:18:28 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 27/30] viafb: replace inb/outb
Date: Wed, 28 Apr 2010 16:17:28 -0600
Message-Id: <1272493051-25380-28-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272493051-25380-1-git-send-email-corbet@lwn.net>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

viafb: replace inb/outb

This patch replaces occurences of inb/outb with via_write_reg and
via_write_reg_mask where this is possible to improve code
readability.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index d474fbe..b2bb24e 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1008,16 +1008,12 @@ void viafb_load_reg(int timing_value, int viafb_load_reg_num,
 void viafb_write_regx(struct io_reg RegTable[], int ItemNum)
 {
 	int i;
-	unsigned char RegTemp;
 
 	/*DEBUG_MSG(KERN_INFO "Table Size : %x!!\n",ItemNum ); */
 
-	for (i = 0; i < ItemNum; i++) {
-		outb(RegTable[i].index, RegTable[i].port);
-		RegTemp = inb(RegTable[i].port + 1);
-		RegTemp = (RegTemp & (~RegTable[i].mask)) | RegTable[i].value;
-		outb(RegTemp, RegTable[i].port + 1);
-	}
+	for (i = 0; i < ItemNum; i++)
+		via_write_reg_mask(RegTable[i].port, RegTable[i].index,
+			RegTable[i].value, RegTable[i].mask);
 }
 
 void viafb_load_fetch_count_reg(int h_addr, int bpp_byte, int set_iga)
@@ -2130,10 +2126,8 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 	outb(VPIT.Misc, VIAWMisc);
 
 	/* Write Sequencer */
-	for (i = 1; i <= StdSR; i++) {
-		outb(i, VIASR);
-		outb(VPIT.SR[i - 1], VIASR + 1);
-	}
+	for (i = 1; i <= StdSR; i++)
+		via_write_reg(VIASR, i, VPIT.SR[i - 1]);
 
 	viafb_write_reg_mask(0x15, VIASR, 0xA2, 0xA2);
 	viafb_set_iga_path();
@@ -2142,10 +2136,8 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 	viafb_fill_crtc_timing(crt_timing, vmode_tbl, video_bpp / 8, IGA1);
 
 	/* Write Graphic Controller */
-	for (i = 0; i < StdGR; i++) {
-		outb(i, VIAGR);
-		outb(VPIT.GR[i], VIAGR + 1);
-	}
+	for (i = 0; i < StdGR; i++)
+		via_write_reg(VIAGR, i, VPIT.GR[i]);
 
 	/* Write Attribute Controller */
 	for (i = 0; i < StdAR; i++) {
-- 
1.7.0.1

