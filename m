Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0EIKMt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 06:12:49 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52897 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab0EIKMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 06:12:44 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 5/6] ad525x_dpot: add support for ADN2860 and AD528x pots
Date: Sun,  9 May 2010 06:15:28 -0400
Message-Id: <1273400129-26101-5-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273400129-26101-1-git-send-email-vapier@gentoo.org>
References: <1273400129-26101-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

New parts supported:
	AD5280, AD5282, ADN2860

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/misc/Kconfig           |    3 ++-
 drivers/misc/ad525x_dpot-i2c.c |    3 +++
 drivers/misc/ad525x_dpot.c     |   28 +++++++++++++++++-----------
 drivers/misc/ad525x_dpot.h     |    6 ++++--
 4 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 90c3415..233886d 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -23,7 +23,8 @@ config AD525X_DPOT
 	  AD5204, AD5206, AD5207, AD5231, AD5232, AD5233, AD5235,
 	  AD5260, AD5262, AD5263, AD5290, AD5291, AD5292, AD5293,
 	  AD7376, AD8400, AD8402, AD8403, ADN2850, AD5241, AD5242,
-	  AD5243, AD5245, AD5246, AD5247, AD5248
+	  AD5243, AD5245, AD5246, AD5247, AD5248, AD5280, AD5282,
+	  ADN2860
 	  digital potentiometer chips.
 
 	  See Documentation/misc-devices/ad525x_dpot.txt for the
diff --git a/drivers/misc/ad525x_dpot-i2c.c b/drivers/misc/ad525x_dpot-i2c.c
index 0dfad4e..abba18e 100644
--- a/drivers/misc/ad525x_dpot-i2c.c
+++ b/drivers/misc/ad525x_dpot-i2c.c
@@ -94,6 +94,9 @@ static const struct i2c_device_id ad_dpot_id[] = {
 	{"ad5246", AD5246_ID},
 	{"ad5247", AD5247_ID},
 	{"ad5248", AD5248_ID},
+	{"ad5280", AD5280_ID},
+	{"ad5282", AD5282_ID},
+	{"adn2860", ADN2860_ID},
 	{}
 };
 MODULE_DEVICE_TABLE(i2c, ad_dpot_id);
diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
index c3595ed..3aa34c9 100644
--- a/drivers/misc/ad525x_dpot.c
+++ b/drivers/misc/ad525x_dpot.c
@@ -44,6 +44,9 @@
  * AD5243		2		256		2.5, 10, 50, 100
  * AD5248		2		256		2.5, 10, 50, 100
  * AD5242		2		256		20, 50, 200
+ * AD5280		1		256		20, 50, 200
+ * AD5282		2		256		20, 50, 200
+ * ADN2860		3		512		25, 250
  *
  * See Documentation/misc-devices/ad525x_dpot.txt for more info.
  *
@@ -153,6 +156,8 @@ static s32 dpot_read_i2c(struct dpot_data *dpot, u8 reg)
 	case DPOT_UID(AD5242_ID):
 	case DPOT_UID(AD5243_ID):
 	case DPOT_UID(AD5248_ID):
+	case DPOT_UID(AD5280_ID):
+	case DPOT_UID(AD5282_ID):
 		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ?
 			0 : DPOT_AD5291_RDAC_AB;
 		return dpot_read_r8d8(dpot, ctrl);
@@ -249,21 +254,22 @@ static s32 dpot_write_i2c(struct dpot_data *dpot, u8 reg, u16 value)
 	case DPOT_UID(AD5242_ID):
 	case DPOT_UID(AD5243_ID):
 	case DPOT_UID(AD5248_ID):
-		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ? 0 : DPOT_AD5291_RDAC_AB;
+	case DPOT_UID(AD5280_ID):
+	case DPOT_UID(AD5282_ID):
+		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ?
+			0 : DPOT_AD5291_RDAC_AB;
 		return dpot_write_r8d8(dpot, ctrl, value);
 		break;
-
-
 	default:
-	if (reg & DPOT_ADDR_CMD)
-		return dpot_write_d8(dpot, reg);
+		if (reg & DPOT_ADDR_CMD)
+			return dpot_write_d8(dpot, reg);
 
-	if (dpot->max_pos > 256)
-		return dpot_write_r8d16(dpot, (reg & 0xF8) |
-					((reg & 0x7) << 1), value);
-	else
-		/* All other registers require instruction + data bytes */
-		return dpot_write_r8d8(dpot, reg, value);
+		if (dpot->max_pos > 256)
+			return dpot_write_r8d16(dpot, (reg & 0xF8) |
+						((reg & 0x7) << 1), value);
+		else
+			/* All other registers require instruction + data bytes */
+			return dpot_write_r8d8(dpot, reg, value);
 	}
 }
 
diff --git a/drivers/misc/ad525x_dpot.h b/drivers/misc/ad525x_dpot.h
index 849c5d0..d789a95 100644
--- a/drivers/misc/ad525x_dpot.h
+++ b/drivers/misc/ad525x_dpot.h
@@ -112,8 +112,10 @@ enum dpot_devid {
 	AD5246_ID = DPOT_CONF(F_RDACS_RW, BRDAC0, 7, 37),
 	AD5247_ID = DPOT_CONF(F_RDACS_RW, BRDAC0, 7, 38),
 	AD5248_ID = DPOT_CONF(F_RDACS_RW, BRDAC0 | BRDAC1, 8, 39),
-
-
+	AD5280_ID = DPOT_CONF(F_RDACS_RW, BRDAC0, 8, 40),
+	AD5282_ID = DPOT_CONF(F_RDACS_RW, BRDAC0 | BRDAC1, 8, 41),
+	ADN2860_ID = DPOT_CONF(F_RDACS_RW_TOL | F_CMD_INC,
+			BRDAC0 | BRDAC1 | BRDAC2, 9, 42),
 };
 
 #define DPOT_RDAC0		0
-- 
1.7.1

