Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab0EIKMr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 06:12:47 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52891 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab0EIKMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 06:12:43 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 4/6] ad525x_dpot: add support for AD524x pots
Date: Sun,  9 May 2010 06:15:27 -0400
Message-Id: <1273400129-26101-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273400129-26101-1-git-send-email-vapier@gentoo.org>
References: <1273400129-26101-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

New parts supported:
	AD5241, AD5242, AD5243, AD5245, AD5246, AD5247, AD5248

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/misc/Kconfig           |    3 +-
 drivers/misc/ad525x_dpot-i2c.c |    7 ++
 drivers/misc/ad525x_dpot.c     |  234 +++++++++++++++++++++++++---------------
 drivers/misc/ad525x_dpot.h     |   27 ++++--
 4 files changed, 175 insertions(+), 96 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 69e019e..90c3415 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -22,7 +22,8 @@ config AD525X_DPOT
 	  AD5160, AD5161, AD5162, AD5165, AD5200, AD5201, AD5203,
 	  AD5204, AD5206, AD5207, AD5231, AD5232, AD5233, AD5235,
 	  AD5260, AD5262, AD5263, AD5290, AD5291, AD5292, AD5293,
-	  AD7376, AD8400, AD8402, AD8403, ADN2850
+	  AD7376, AD8400, AD8402, AD8403, ADN2850, AD5241, AD5242,
+	  AD5243, AD5245, AD5246, AD5247, AD5248
 	  digital potentiometer chips.
 
 	  See Documentation/misc-devices/ad525x_dpot.txt for the
diff --git a/drivers/misc/ad525x_dpot-i2c.c b/drivers/misc/ad525x_dpot-i2c.c
index 971e61d..0dfad4e 100644
--- a/drivers/misc/ad525x_dpot-i2c.c
+++ b/drivers/misc/ad525x_dpot-i2c.c
@@ -87,6 +87,13 @@ static const struct i2c_device_id ad_dpot_id[] = {
 	{"ad5253", AD5253_ID},
 	{"ad5254", AD5254_ID},
 	{"ad5255", AD5255_ID},
+	{"ad5241", AD5241_ID},
+	{"ad5242", AD5242_ID},
+	{"ad5243", AD5243_ID},
+	{"ad5245", AD5245_ID},
+	{"ad5246", AD5246_ID},
+	{"ad5247", AD5247_ID},
+	{"ad5248", AD5248_ID},
 	{}
 };
 MODULE_DEVICE_TABLE(i2c, ad_dpot_id);
diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
index 4919204..c3595ed 100644
--- a/drivers/misc/ad525x_dpot.c
+++ b/drivers/misc/ad525x_dpot.c
@@ -37,6 +37,13 @@
  * AD8402		2		256		1, 10, 50, 100
  * AD8403		4		256		1, 10, 50, 100
  * ADN2850		3		512		25, 250
+ * AD5241		1		256		10, 100, 1M
+ * AD5246		1		128		5, 10, 50, 100
+ * AD5247		1		128		5, 10, 50, 100
+ * AD5245		1		256		5, 10, 50, 100
+ * AD5243		2		256		2.5, 10, 50, 100
+ * AD5248		2		256		2.5, 10, 50, 100
+ * AD5242		2		256		20, 50, 200
  *
  * See Documentation/misc-devices/ad525x_dpot.txt for more info.
  *
@@ -106,118 +113,169 @@ static inline int dpot_write_r8d16(struct dpot_data *dpot, u8 reg, u16 val)
 	return dpot->bdata.bops->write_r8d16(dpot->bdata.client, reg, val);
 }
 
-static s32 dpot_read(struct dpot_data *dpot, u8 reg)
+static s32 dpot_read_spi(struct dpot_data *dpot, u8 reg)
 {
-	unsigned val = 0;
+	unsigned ctrl = 0;
 
-	if (dpot->feat & F_SPI) {
-		if (!(reg & (DPOT_ADDR_EEPROM | DPOT_ADDR_CMD))) {
+	if (!(reg & (DPOT_ADDR_EEPROM | DPOT_ADDR_CMD))) {
 
-			if (dpot->feat & F_RDACS_WONLY)
-				return dpot->rdac_cache[reg & DPOT_RDAC_MASK];
+		if (dpot->feat & F_RDACS_WONLY)
+			return dpot->rdac_cache[reg & DPOT_RDAC_MASK];
 
-			if (dpot->uid == DPOT_UID(AD5291_ID) ||
-				dpot->uid == DPOT_UID(AD5292_ID) ||
-				dpot->uid == DPOT_UID(AD5293_ID))
-				return dpot_read_r8d8(dpot,
-					DPOT_AD5291_READ_RDAC << 2);
+		if (dpot->uid == DPOT_UID(AD5291_ID) ||
+			dpot->uid == DPOT_UID(AD5292_ID) ||
+			dpot->uid == DPOT_UID(AD5293_ID))
+			return dpot_read_r8d8(dpot,
+				DPOT_AD5291_READ_RDAC << 2);
 
-			val = DPOT_SPI_READ_RDAC;
-		} else if (reg & DPOT_ADDR_EEPROM) {
-			val = DPOT_SPI_READ_EEPROM;
-		}
+		ctrl = DPOT_SPI_READ_RDAC;
+	} else if (reg & DPOT_ADDR_EEPROM) {
+		ctrl = DPOT_SPI_READ_EEPROM;
+	}
 
-		if (dpot->feat & F_SPI_16BIT)
-			return dpot_read_r8d8(dpot, val);
-		else if (dpot->feat & F_SPI_24BIT)
-			return dpot_read_r8d16(dpot, val);
+	if (dpot->feat & F_SPI_16BIT)
+		return dpot_read_r8d8(dpot, ctrl);
+	else if (dpot->feat & F_SPI_24BIT)
+		return dpot_read_r8d16(dpot, ctrl);
 
-	} else { /* I2C */
+	return -EFAULT;
+}
 
+static s32 dpot_read_i2c(struct dpot_data *dpot, u8 reg)
+{
+	unsigned ctrl = 0;
+	switch (dpot->uid) {
+	case DPOT_UID(AD5246_ID):
+	case DPOT_UID(AD5247_ID):
+		return dpot_read_d8(dpot);
+	case DPOT_UID(AD5245_ID):
+	case DPOT_UID(AD5241_ID):
+	case DPOT_UID(AD5242_ID):
+	case DPOT_UID(AD5243_ID):
+	case DPOT_UID(AD5248_ID):
+		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ?
+			0 : DPOT_AD5291_RDAC_AB;
+		return dpot_read_r8d8(dpot, ctrl);
+	default:
 		if ((reg & DPOT_REG_TOL) || (dpot->max_pos > 256))
 			return dpot_read_r8d16(dpot, (reg & 0xF8) |
 					((reg & 0x7) << 1));
 		else
 			return dpot_read_r8d8(dpot, reg);
-
 	}
-	return -EFAULT;
 }
 
-static s32 dpot_write(struct dpot_data *dpot, u8 reg, u16 value)
+static s32 dpot_read(struct dpot_data *dpot, u8 reg)
+{
+	if (dpot->feat & F_SPI)
+		return dpot_read_spi(dpot, reg);
+	else
+		return dpot_read_i2c(dpot, reg);
+}
+
+static s32 dpot_write_spi(struct dpot_data *dpot, u8 reg, u16 value)
 {
 	unsigned val = 0;
 
-	if (dpot->feat & F_SPI) {
-		if (!(reg & (DPOT_ADDR_EEPROM | DPOT_ADDR_CMD))) {
-			if (dpot->feat & F_RDACS_WONLY)
-				dpot->rdac_cache[reg & DPOT_RDAC_MASK] = value;
-
-			if (dpot->feat & F_AD_APPDATA) {
-				if (dpot->feat & F_SPI_8BIT) {
-					val = ((reg & DPOT_RDAC_MASK) <<
-						DPOT_MAX_POS(dpot->devid)) |
-						value;
-					return dpot_write_d8(dpot, val);
-				} else if (dpot->feat & F_SPI_16BIT) {
-					val = ((reg & DPOT_RDAC_MASK) <<
-						DPOT_MAX_POS(dpot->devid)) |
-						value;
-					return dpot_write_r8d8(dpot, val >> 8,
-						val & 0xFF);
-				} else
-					BUG();
-			} else {
-				if (dpot->uid == DPOT_UID(AD5291_ID) ||
-					dpot->uid == DPOT_UID(AD5292_ID) ||
-					dpot->uid == DPOT_UID(AD5293_ID))
-					return dpot_write_r8d8(dpot,
-						(DPOT_AD5291_RDAC << 2) |
-						(value >> 8), value & 0xFF);
-
-				val = DPOT_SPI_RDAC | (reg & DPOT_RDAC_MASK);
-			}
-		} else if (reg & DPOT_ADDR_EEPROM) {
-			val = DPOT_SPI_EEPROM | (reg & DPOT_RDAC_MASK);
-		} else if (reg & DPOT_ADDR_CMD) {
-			switch (reg) {
-			case DPOT_DEC_ALL_6DB:
-				val = DPOT_SPI_DEC_ALL_6DB;
-				break;
-			case DPOT_INC_ALL_6DB:
-				val = DPOT_SPI_INC_ALL_6DB;
-				break;
-			case DPOT_DEC_ALL:
-				val = DPOT_SPI_DEC_ALL;
-				break;
-			case DPOT_INC_ALL:
-				val = DPOT_SPI_INC_ALL;
-				break;
-			}
-		} else
-			BUG();
-
-		if (dpot->feat & F_SPI_16BIT)
-			return dpot_write_r8d8(dpot, val, value);
-		else if (dpot->feat & F_SPI_24BIT)
-			return dpot_write_r8d16(dpot, val, value);
-	} else {
-		/* Only write the instruction byte for certain commands */
-		if (reg & DPOT_ADDR_CMD)
-			return dpot_write_d8(dpot, reg);
-
-		if (dpot->max_pos > 256)
-			return dpot_write_r8d16(dpot, (reg & 0xF8) |
-						((reg & 0x7) << 1), value);
-		else
-			/* All other registers require instruction + data bytes */
-			return dpot_write_r8d8(dpot, reg, value);
+	if (!(reg & (DPOT_ADDR_EEPROM | DPOT_ADDR_CMD))) {
+		if (dpot->feat & F_RDACS_WONLY)
+			dpot->rdac_cache[reg & DPOT_RDAC_MASK] = value;
+
+		if (dpot->feat & F_AD_APPDATA) {
+			if (dpot->feat & F_SPI_8BIT) {
+				val = ((reg & DPOT_RDAC_MASK) <<
+					DPOT_MAX_POS(dpot->devid)) |
+					value;
+				return dpot_write_d8(dpot, val);
+			} else if (dpot->feat & F_SPI_16BIT) {
+				val = ((reg & DPOT_RDAC_MASK) <<
+					DPOT_MAX_POS(dpot->devid)) |
+					value;
+				return dpot_write_r8d8(dpot, val >> 8,
+					val & 0xFF);
+			} else
+				BUG();
+		} else {
+			if (dpot->uid == DPOT_UID(AD5291_ID) ||
+				dpot->uid == DPOT_UID(AD5292_ID) ||
+				dpot->uid == DPOT_UID(AD5293_ID))
+				return dpot_write_r8d8(dpot,
+					(DPOT_AD5291_RDAC << 2) |
+					(value >> 8), value & 0xFF);
 
-	}
+			val = DPOT_SPI_RDAC | (reg & DPOT_RDAC_MASK);
+		}
+	} else if (reg & DPOT_ADDR_EEPROM) {
+		val = DPOT_SPI_EEPROM | (reg & DPOT_RDAC_MASK);
+	} else if (reg & DPOT_ADDR_CMD) {
+		switch (reg) {
+		case DPOT_DEC_ALL_6DB:
+			val = DPOT_SPI_DEC_ALL_6DB;
+			break;
+		case DPOT_INC_ALL_6DB:
+			val = DPOT_SPI_INC_ALL_6DB;
+			break;
+		case DPOT_DEC_ALL:
+			val = DPOT_SPI_DEC_ALL;
+			break;
+		case DPOT_INC_ALL:
+			val = DPOT_SPI_INC_ALL;
+			break;
+		}
+	} else
+		BUG();
+
+	if (dpot->feat & F_SPI_16BIT)
+		return dpot_write_r8d8(dpot, val, value);
+	else if (dpot->feat & F_SPI_24BIT)
+		return dpot_write_r8d16(dpot, val, value);
 
 	return -EFAULT;
 }
 
+static s32 dpot_write_i2c(struct dpot_data *dpot, u8 reg, u16 value)
+{
+	/* Only write the instruction byte for certain commands */
+	unsigned ctrl = 0;
+
+	switch (dpot->uid) {
+	case DPOT_UID(AD5246_ID):
+	case DPOT_UID(AD5247_ID):
+		return dpot_write_d8(dpot, value);
+		break;
+
+	case DPOT_UID(AD5245_ID):
+	case DPOT_UID(AD5241_ID):
+	case DPOT_UID(AD5242_ID):
+	case DPOT_UID(AD5243_ID):
+	case DPOT_UID(AD5248_ID):
+		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ? 0 : DPOT_AD5291_RDAC_AB;
+		return dpot_write_r8d8(dpot, ctrl, value);
+		break;
+
+
+	default:
+	if (reg & DPOT_ADDR_CMD)
+		return dpot_write_d8(dpot, reg);
+
+	if (dpot->max_pos > 256)
+		return dpot_write_r8d16(dpot, (reg & 0xF8) |
+					((reg & 0x7) << 1), value);
+	else
+		/* All other registers require instruction + data bytes */
+		return dpot_write_r8d8(dpot, reg, value);
+	}
+}
+
+
+static s32 dpot_write(struct dpot_data *dpot, u8 reg, u16 value)
+{
+	if (dpot->feat & F_SPI)
+		return dpot_write_spi(dpot, reg, value);
+	else
+		return dpot_write_i2c(dpot, reg, value);
+}
+
 /* sysfs functions */
 
 static ssize_t sysfs_show_reg(struct device *dev,
diff --git a/drivers/misc/ad525x_dpot.h b/drivers/misc/ad525x_dpot.h
index 99b388e..849c5d0 100644
--- a/drivers/misc/ad525x_dpot.h
+++ b/drivers/misc/ad525x_dpot.h
@@ -29,13 +29,14 @@
 
 #define F_CMD_INC		(1 << 0)	/* Features INC/DEC ALL, 6dB */
 #define F_CMD_EEP		(1 << 1)	/* Features EEPROM */
-#define F_CMD_TOL		(1 << 2)	/* RDACS are Read/Write + Tolerance REG */
-#define F_RDACS_RW		(1 << 3)	/* RDACS are Read/Write + Tolerance REG */
-#define F_RDACS_WONLY		(1 << 4)	/* RDACS are Write only */
-#define F_AD_APPDATA		(1 << 5)	/* RDAC Address append to data */
-#define F_SPI_8BIT		(1 << 6)	/* All SPI XFERS are 8-bit */
-#define F_SPI_16BIT		(1 << 7)	/* All SPI XFERS are 16-bit */
-#define F_SPI_24BIT		(1 << 8)	/* All SPI XFERS are 24-bit */
+#define F_CMD_OTP		(1 << 2)	/* Features OTP */
+#define F_CMD_TOL		(1 << 3)	/* RDACS feature Tolerance REG */
+#define F_RDACS_RW		(1 << 4)	/* RDACS are Read/Write  */
+#define F_RDACS_WONLY		(1 << 5)	/* RDACS are Write only */
+#define F_AD_APPDATA		(1 << 6)	/* RDAC Address append to data */
+#define F_SPI_8BIT		(1 << 7)	/* All SPI XFERS are 8-bit */
+#define F_SPI_16BIT		(1 << 8)	/* All SPI XFERS are 16-bit */
+#define F_SPI_24BIT		(1 << 9)	/* All SPI XFERS are 24-bit */
 
 #define F_RDACS_RW_TOL	(F_RDACS_RW | F_CMD_EEP | F_CMD_TOL)
 #define F_RDACS_RW_EEP	(F_RDACS_RW | F_CMD_EEP)
@@ -104,6 +105,15 @@ enum dpot_devid {
 			BRDAC0 | BRDAC1 | BRDAC2, 8, 31),
 	ADN2850_ID = DPOT_CONF(F_RDACS_RW_EEP | F_CMD_INC | F_SPI_24BIT,
 			BRDAC0 | BRDAC1, 10, 32),
+	AD5241_ID = DPOT_CONF(F_RDACS_RW, BRDAC0, 8, 33),
+	AD5242_ID = DPOT_CONF(F_RDACS_RW, BRDAC0 | BRDAC1, 8, 34),
+	AD5243_ID = DPOT_CONF(F_RDACS_RW, BRDAC0 | BRDAC1, 8, 35),
+	AD5245_ID = DPOT_CONF(F_RDACS_RW, BRDAC0, 8, 36),
+	AD5246_ID = DPOT_CONF(F_RDACS_RW, BRDAC0, 7, 37),
+	AD5247_ID = DPOT_CONF(F_RDACS_RW, BRDAC0, 7, 38),
+	AD5248_ID = DPOT_CONF(F_RDACS_RW, BRDAC0 | BRDAC1, 8, 39),
+
+
 };
 
 #define DPOT_RDAC0		0
@@ -146,6 +156,9 @@ enum dpot_devid {
 #define DPOT_AD5291_RDAC	0x01
 #define DPOT_AD5291_READ_RDAC	0x02
 
+/* AD524x use special commands */
+#define DPOT_AD5291_RDAC_AB	0x80
+
 struct dpot_data;
 
 struct ad_dpot_bus_ops {
-- 
1.7.1

