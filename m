Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab0DWVbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 17:31:17 -0400
Received: from tex.lwn.net ([70.33.254.29]:50577 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab0DWV2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 17:28:41 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 09/13] via: Rationalize vt1636 detection
Date: Fri, 23 Apr 2010 15:28:09 -0600
Message-Id: <1272058093-20914-10-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272058093-20914-1-git-send-email-corbet@lwn.net>
References: <1272058093-20914-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code was ugly and didn't check whether i2c operations were succeeding;
make it a little better.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/vt1636.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/video/via/vt1636.c b/drivers/video/via/vt1636.c
index e9f3661..e5f8024 100644
--- a/drivers/video/via/vt1636.c
+++ b/drivers/video/via/vt1636.c
@@ -167,26 +167,20 @@ bool viafb_lvds_identify_vt1636(u8 i2c_adapter)
 
 	/* Sense VT1636 LVDS Transmiter */
 	viaparinfo->chip_info->lvds_chip_info.lvds_chip_slave_addr =
-	VT1636_LVDS_I2C_ADDR;
+		VT1636_LVDS_I2C_ADDR;
 
 	/* Check vendor ID first: */
-	viafb_i2c_readbyte(i2c_adapter,
-			   (u8) viaparinfo->chip_info->lvds_chip_info.lvds_chip_slave_addr,
-			   0x00, &Buffer[0]);
-	viafb_i2c_readbyte(i2c_adapter,
-			   (u8) viaparinfo->chip_info->lvds_chip_info.lvds_chip_slave_addr,
-			   0x01, &Buffer[1]);
+	if (viafb_i2c_readbyte(i2c_adapter, VT1636_LVDS_I2C_ADDR,
+					0x00, &Buffer[0]))
+		return false;
+	viafb_i2c_readbyte(i2c_adapter, VT1636_LVDS_I2C_ADDR, 0x01, &Buffer[1]);
 
 	if (!((Buffer[0] == 0x06) && (Buffer[1] == 0x11)))
 		return false;
 
 	/* Check Chip ID: */
-	viafb_i2c_readbyte(i2c_adapter,
-			   (u8) viaparinfo->chip_info->lvds_chip_info.lvds_chip_slave_addr,
-			   0x02, &Buffer[0]);
-	viafb_i2c_readbyte(i2c_adapter,
-			   (u8) viaparinfo->chip_info->lvds_chip_info.lvds_chip_slave_addr,
-			   0x03, &Buffer[1]);
+	viafb_i2c_readbyte(i2c_adapter, VT1636_LVDS_I2C_ADDR, 0x02, &Buffer[0]);
+	viafb_i2c_readbyte(i2c_adapter, VT1636_LVDS_I2C_ADDR, 0x03, &Buffer[1]);
 	if ((Buffer[0] == 0x45) && (Buffer[1] == 0x33)) {
 		viaparinfo->chip_info->lvds_chip_info.lvds_chip_name =
 			VT1636_LVDS;
-- 
1.7.0.1

