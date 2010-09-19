Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab0ISHPp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 03:15:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57570 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751972Ab0ISHPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 03:15:24 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/Gb1ZrcfnG2+QhT823DtUuzeYRTo7SjiYwJqCGxJ
	38eLrZ7FGFnGHO
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: [PATCH 02/12] viafb: limit LCD code impact
Date: Sun, 19 Sep 2010 07:26:07 +0000
Message-Id: <a439cc4ee1516f18038607b6ec28fe8a49f97bbf.1284879532.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1284879532.git.FlorianSchandinat@gmx.de>
References: <cover.1284879532.git.FlorianSchandinat@gmx.de>
In-Reply-To: <cover.1284879532.git.FlorianSchandinat@gmx.de>
References: <cover.1284879532.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: limit LCD code impact

This patch cleans the LCD code up. It forbids overwritting global
decissions like what IGA should be used as the source and whether to
enable the second display channel. Additionally it removes a bit code
duplication.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
---
 drivers/video/via/lcd.c |   31 -------------------------------
 1 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index e99f933..b7d5535 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -818,19 +818,12 @@ void viafb_lcd_disable(void)
 		viafb_write_reg_mask(SR3D, VIASR, 0x00, 0x20);
 		/* 24 bit DI data paht off */
 		viafb_write_reg_mask(CR91, VIACR, 0x80, 0x80);
-		/* Simultaneout disabled   */
-		viafb_write_reg_mask(CR6B, VIACR, 0x00, 0x08);
 	}
 
 	/* Disable expansion bit   */
 	viafb_write_reg_mask(CR79, VIACR, 0x00, 0x01);
-	/* CRT path set to IGA1    */
-	viafb_write_reg_mask(SR16, VIASR, 0x00, 0x40);
 	/* Simultaneout disabled   */
 	viafb_write_reg_mask(CR6B, VIACR, 0x00, 0x08);
-	/* IGA2 path disabled      */
-	viafb_write_reg_mask(CR6A, VIACR, 0x00, 0x80);
-
 }
 
 static void set_lcd_output_path(int set_iga, int output_interface)
@@ -892,33 +885,9 @@ void viafb_lcd_enable(void)
 		viafb_write_reg_mask(SR3D, VIASR, 0x20, 0x20);
 		/* 24 bit DI data paht on  */
 		viafb_write_reg_mask(CR91, VIACR, 0x00, 0x80);
-
-		/* Set data source selection bit by iga path */
-		if (viaparinfo->lvds_setting_info->iga_path == IGA1) {
-			/* DFP-H set to IGA1       */
-			viafb_write_reg_mask(CR97, VIACR, 0x00, 0x10);
-			/* DFP-L set to IGA1       */
-			viafb_write_reg_mask(CR99, VIACR, 0x00, 0x10);
-		} else {
-			/* DFP-H set to IGA2       */
-			viafb_write_reg_mask(CR97, VIACR, 0x10, 0x10);
-			/* DFP-L set to IGA2       */
-			viafb_write_reg_mask(CR99, VIACR, 0x10, 0x10);
-		}
 		/* LCD enabled             */
 		viafb_write_reg_mask(CR6A, VIACR, 0x48, 0x48);
 	}
-
-	if (viaparinfo->lvds_setting_info->iga_path == IGA1) {
-		/* CRT path set to IGA2    */
-		viafb_write_reg_mask(SR16, VIASR, 0x40, 0x40);
-		/* IGA2 path disabled      */
-		viafb_write_reg_mask(CR6A, VIACR, 0x00, 0x80);
-		/* IGA2 path enabled       */
-	} else {		/* IGA2 */
-		viafb_write_reg_mask(CR6A, VIACR, 0x80, 0x80);
-	}
-
 }
 
 static void lcd_powersequence_off(void)
-- 
1.6.3.2

