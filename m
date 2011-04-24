Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab1DXBo6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 21:44:58 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:36707 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757396Ab1DXBoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 21:44:34 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19JrLU1FL9JqCpfj9wa3GLSafP8zU1utKCHtb2Eyd
	ua9LLYMSfBD5CB
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/3] viafb: gather common good, old VGA initialization in one place
Date: Sun, 24 Apr 2011 02:00:41 +0000
Message-Id: <1303610443-8681-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1303610443-8681-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1303610443-8681-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves all unprotected VGA initialization in one table and
provides some documentation for those values.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c      |   49 ++++++++++++++++++++++++++++++++----------
 drivers/video/via/viamode.c |   19 ----------------
 2 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 0098270..5b9c096 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -308,6 +308,42 @@ static struct io_reg scaling_parameters[] = {
 	{VIACR, CR87, 0xFF, 0x1F},	/* LCD Scaling Parameter 14 */
 };
 
+static struct io_reg common_vga[] = {
+	{VIACR, CR07, 0x10, 0x10}, /* [0] vertical total (bit 8)
+					[1] vertical display end (bit 8)
+					[2] vertical retrace start (bit 8)
+					[3] start vertical blanking (bit 8)
+					[4] line compare (bit 8)
+					[5] vertical total (bit 9)
+					[6] vertical display end (bit 9)
+					[7] vertical retrace start (bit 9) */
+	{VIACR, CR08, 0xFF, 0x00}, /* [0-4] preset row scan
+					[5-6] byte panning */
+	{VIACR, CR09, 0xDF, 0x40}, /* [0-4] max scan line
+					[5] start vertical blanking (bit 9)
+					[6] line compare (bit 9)
+					[7] scan doubling */
+	{VIACR, CR0A, 0xFF, 0x1E}, /* [0-4] cursor start
+					[5] cursor disable */
+	{VIACR, CR0B, 0xFF, 0x00}, /* [0-4] cursor end
+					[5-6] cursor skew */
+	{VIACR, CR0E, 0xFF, 0x00}, /* [0-7] cursor location (high) */
+	{VIACR, CR0F, 0xFF, 0x00}, /* [0-7] cursor location (low) */
+	{VIACR, CR11, 0xF0, 0x80}, /* [0-3] vertical retrace end
+					[6] memory refresh bandwidth
+					[7] CRTC register protect enable */
+	{VIACR, CR14, 0xFF, 0x00}, /* [0-4] underline location
+					[5] divide memory address clock by 4
+					[6] double word addressing */
+	{VIACR, CR17, 0xFF, 0x63}, /* [0-1] mapping of display address 13-14
+					[2] divide scan line clock by 2
+					[3] divide memory address clock by 2
+					[5] address wrap
+					[6] byte mode select
+					[7] sync enable */
+	{VIACR, CR18, 0xFF, 0xFF}, /* [0-7] line compare */
+};
+
 static struct fifo_depth_select display_fifo_depth_reg = {
 	/* IGA1 FIFO Depth_Select */
 	{IGA1_FIFO_DEPTH_SELECT_REG_NUM, {{SR17, 0, 7} } },
@@ -1167,22 +1203,10 @@ static void load_fix_bit_crtc_reg(void)
 	/* always set to 1 */
 	viafb_write_reg_mask(CR03, VIACR, 0x80, BIT7);
 	/* line compare should set all bits = 1 (extend modes) */
-	viafb_write_reg(CR18, VIACR, 0xff);
-	/* line compare should set all bits = 1 (extend modes) */
-	viafb_write_reg_mask(CR07, VIACR, 0x10, BIT4);
-	/* line compare should set all bits = 1 (extend modes) */
 	viafb_write_reg_mask(CR35, VIACR, 0x10, BIT4);
 	/* line compare should set all bits = 1 (extend modes) */
 	viafb_write_reg_mask(CR33, VIACR, 0x06, BIT0 + BIT1 + BIT2);
 	/*viafb_write_reg_mask(CR32, VIACR, 0x01, BIT0); */
-	/* extend mode always set to e3h */
-	viafb_write_reg(CR17, VIACR, 0xe3);
-	/* extend mode always set to 0h */
-	viafb_write_reg(CR08, VIACR, 0x00);
-	/* extend mode always set to 0h */
-	viafb_write_reg(CR14, VIACR, 0x00);
-	viafb_write_reg_mask(CR09, VIACR, 0x40, 0xDF);
-	viafb_write_reg_mask(CR11, VIACR, 0x00, BIT4 + BIT5 + BIT6);
 
 	viafb_lock_crt();
 
@@ -2353,6 +2377,7 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 	outb(0x00, VIAAR);
 
 	/* Write Common Setting for Video Mode */
+	viafb_write_regx(common_vga, ARRAY_SIZE(common_vga));
 	switch (viaparinfo->chip_info->gfx_chip_name) {
 	case UNICHROME_CLE266:
 		viafb_write_regx(CLE266_ModeXregs, NUM_TOTAL_CLE266_ModeXregs);
diff --git a/drivers/video/via/viamode.c b/drivers/video/via/viamode.c
index 8c5bc41..036ad3a 100644
--- a/drivers/video/via/viamode.c
+++ b/drivers/video/via/viamode.c
@@ -30,10 +30,6 @@ struct io_reg CN400_ModeXregs[] = { {VIASR, SR10, 0xFF, 0x01},
 {VIASR, SR1A, 0xFB, 0x08},
 {VIASR, SR1E, 0x0F, 0x01},
 {VIASR, SR2A, 0xFF, 0x00},
-{VIACR, CR0A, 0xFF, 0x1E},	/* Cursor Start                        */
-{VIACR, CR0B, 0xFF, 0x00},	/* Cursor End                          */
-{VIACR, CR0E, 0xFF, 0x00},	/* Cursor Location High                */
-{VIACR, CR0F, 0xFF, 0x00},	/* Cursor Localtion Low                */
 {VIACR, CR32, 0xFF, 0x00},
 {VIACR, CR33, 0xFF, 0x00},
 {VIACR, CR35, 0xFF, 0x00},
@@ -125,10 +121,6 @@ struct io_reg KM400_ModeXregs[] = {
 	{VIASR, SR2A, 0xFF, 0x00},	/* Power Management Control 5      */
 	{VIASR, SR2D, 0xFF, 0xFF},	/* Power Management Control 1      */
 	{VIASR, SR2E, 0xFF, 0xFF},	/* Power Management Control 2      */
-	{VIACR, CR0A, 0xFF, 0x1E},	/* Cursor Start                    */
-	{VIACR, CR0B, 0xFF, 0x00},	/* Cursor End                      */
-	{VIACR, CR0E, 0xFF, 0x00},	/* Cursor Location High            */
-	{VIACR, CR0F, 0xFF, 0x00},	/* Cursor Localtion Low            */
 	{VIACR, CR33, 0xFF, 0x00},
 	{VIACR, CR55, 0x80, 0x00},
 	{VIACR, CR5D, 0x80, 0x00},
@@ -162,10 +154,6 @@ struct io_reg CX700_ModeXregs[] = { {VIASR, SR10, 0xFF, 0x01},
 {VIASR, SR1E, 0xFF, 0x01},
 {VIASR, SR2A, 0xFF, 0x00},
 {VIASR, SR2D, 0xFF, 0xFF},	/* VCK and LCK PLL power on.           */
-{VIACR, CR0A, 0xFF, 0x1E},	/* Cursor Start                        */
-{VIACR, CR0B, 0xFF, 0x00},	/* Cursor End                          */
-{VIACR, CR0E, 0xFF, 0x00},	/* Cursor Location High                */
-{VIACR, CR0F, 0xFF, 0x00},	/* Cursor Localtion Low                */
 {VIACR, CR32, 0xFF, 0x00},
 {VIACR, CR33, 0xFF, 0x00},
 {VIACR, CR35, 0xFF, 0x00},
@@ -205,13 +193,6 @@ struct io_reg VX855_ModeXregs[] = {
 {VIASR, SR58, 0xFF, 0x00},
 {VIASR, SR59, 0xFF, 0x00},
 {VIASR, SR2D, 0xFF, 0xFF},	/* VCK and LCK PLL power on.           */
-{VIACR, CR09, 0xFF, 0x00},	/* Initial CR09=0*/
-{VIACR, CR11, 0x8F, 0x00},	/* IGA1 initial  Vertical end       */
-{VIACR, CR17, 0x7F, 0x00}, 	/* IGA1 CRT Mode control init   */
-{VIACR, CR0A, 0xFF, 0x1E},	/* Cursor Start                        */
-{VIACR, CR0B, 0xFF, 0x00},	/* Cursor End                          */
-{VIACR, CR0E, 0xFF, 0x00},	/* Cursor Location High                */
-{VIACR, CR0F, 0xFF, 0x00},	/* Cursor Localtion Low                */
 {VIACR, CR32, 0xFF, 0x00},
 {VIACR, CR33, 0x7F, 0x00},
 {VIACR, CR35, 0xFF, 0x00},
-- 
1.6.3.2

