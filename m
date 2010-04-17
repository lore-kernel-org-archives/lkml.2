Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab0DQTic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 15:38:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:46969 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754499Ab0DQThF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 15:37:05 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19wUScIP3dwZVQHOB7gMij5UjOP4IVstykUIjafxN
	a3Y/r5Fa3Ag9nE
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, corbet@lwn.net,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 4/7] viafb: replace inb/outb
Date: Sat, 17 Apr 2010 19:44:54 +0000
Message-Id: <1271533498-3376-4-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1271533498-3376-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1271533498-3376-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: replace inb/outb

This patch replaces occurences of inb/outb with via_write_reg and
via_write_reg_mask where this is possible to improve code
readability.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 1c3a8f3..41628c8 100644
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
@@ -2117,10 +2113,8 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
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
@@ -2129,10 +2123,8 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
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
1.6.3.2

