Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab1IVGWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 02:22:54 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:48632 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969Ab1IVGWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 02:22:49 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH 3/4] mfd/ab5500: break out debugfs code
Date: Thu, 22 Sep 2011 08:22:33 +0200
Message-ID: <1316672553-7733-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This breaks the debugfs portions of the AB5500 driver into its own
file. Split off a _raw function to access registers since we don't
want to expose a generically named function globally. Move all
required data structures to a shared ab5500-core.h file.

Cc: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/Kconfig          |    8 +
 drivers/mfd/Makefile         |    1 +
 drivers/mfd/ab5500-core.c    |  907 +-----------------------------------------
 drivers/mfd/ab5500-core.h    |   87 ++++
 drivers/mfd/ab5500-debugfs.c |  806 +++++++++++++++++++++++++++++++++++++
 drivers/mfd/ab5500-debugfs.h |   22 +
 6 files changed, 941 insertions(+), 890 deletions(-)
 create mode 100644 drivers/mfd/ab5500-core.h
 create mode 100644 drivers/mfd/ab5500-debugfs.c
 create mode 100644 drivers/mfd/ab5500-debugfs.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index b161c49..be808cb 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -585,6 +585,14 @@ config AB5500_CORE
 	  chip. This connects to the db5500 chip via the I2C bus via PRCMU.
 	  This chip embeds various other multimedia funtionalities as well.
 
+config AB5500_DEBUG
+	bool "Enable debug info via debugfs"
+	depends on AB5500_CORE && DEBUG_FS
+	default y if DEBUG_FS
+	help
+	  Select this option if you want debug information from the AB5500
+	  using the debug filesystem, debugfs.
+
 config AB8500_CORE
 	bool "ST-Ericsson AB8500 Mixed Signal Power Management chip"
 	depends on GENERIC_HARDIRQS && ABX500_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 5ed47a7..3d91fe2 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -81,6 +81,7 @@ obj-$(CONFIG_AB3100_CORE)	+= ab3100-core.o
 obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
 obj-$(CONFIG_AB3550_CORE)	+= ab3550-core.o
 obj-$(CONFIG_AB5500_CORE)	+= ab5500-core.o
+obj-$(CONFIG_AB5500_DEBUG)	+= ab5500-debugfs.o
 obj-$(CONFIG_AB8500_CORE)	+= ab8500-core.o ab8500-sysctrl.o
 obj-$(CONFIG_AB8500_DEBUG)	+= ab8500-debugfs.o
 obj-$(CONFIG_AB8500_GPADC)	+= ab8500-gpadc.o
diff --git a/drivers/mfd/ab5500-core.c b/drivers/mfd/ab5500-core.c
index afec0f2..4175544 100644
--- a/drivers/mfd/ab5500-core.c
+++ b/drivers/mfd/ab5500-core.c
@@ -21,9 +21,6 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/random.h>
-#include <linux/debugfs.h>
-#include <linux/seq_file.h>
-#include <linux/uaccess.h>
 #include <linux/mfd/ab5500/ab5500.h>
 #include <linux/mfd/abx500.h>
 #include <linux/list.h>
@@ -33,87 +30,13 @@
 #include <linux/version.h>
 #include <linux/mfd/db5500-prcmu.h>
 
+#include "ab5500-core.h"
+#include "ab5500-debugfs.h"
+
 #define AB5500_NUM_EVENT_REG 23
 #define AB5500_IT_LATCH0_REG 0x40
 #define AB5500_IT_MASK0_REG 0x60
 
-/* Read/write operation values. */
-#define AB5500_PERM_RD (0x01)
-#define AB5500_PERM_WR (0x02)
-
-/* Read/write permissions. */
-#define AB5500_PERM_RO (AB5500_PERM_RD)
-#define AB5500_PERM_RW (AB5500_PERM_RD | AB5500_PERM_WR)
-
-#define AB5500_MASK_BASE (0x60)
-#define AB5500_MASK_END (0x79)
-#define AB5500_CHIP_ID (0x20)
-
-/**
- * struct ab5500_bank
- * @slave_addr: I2C slave_addr found in AB5500 specification
- * @name: Documentation name of the bank. For reference
- */
-struct ab5500_bank {
-	u8 slave_addr;
-	const char *name;
-};
-
-static const struct ab5500_bank bankinfo[AB5500_NUM_BANKS] = {
-	[AB5500_BANK_VIT_IO_I2C_CLK_TST_OTP] = {
-		AB5500_ADDR_VIT_IO_I2C_CLK_TST_OTP, "VIT_IO_I2C_CLK_TST_OTP"},
-	[AB5500_BANK_VDDDIG_IO_I2C_CLK_TST] = {
-		AB5500_ADDR_VDDDIG_IO_I2C_CLK_TST, "VDDDIG_IO_I2C_CLK_TST"},
-	[AB5500_BANK_VDENC] = {AB5500_ADDR_VDENC, "VDENC"},
-	[AB5500_BANK_SIM_USBSIM] = {AB5500_ADDR_SIM_USBSIM, "SIM_USBSIM"},
-	[AB5500_BANK_LED] = {AB5500_ADDR_LED, "LED"},
-	[AB5500_BANK_ADC] = {AB5500_ADDR_ADC, "ADC"},
-	[AB5500_BANK_RTC] = {AB5500_ADDR_RTC, "RTC"},
-	[AB5500_BANK_STARTUP] = {AB5500_ADDR_STARTUP, "STARTUP"},
-	[AB5500_BANK_DBI_ECI] = {AB5500_ADDR_DBI_ECI, "DBI-ECI"},
-	[AB5500_BANK_CHG] = {AB5500_ADDR_CHG, "CHG"},
-	[AB5500_BANK_FG_BATTCOM_ACC] = {
-		AB5500_ADDR_FG_BATTCOM_ACC, "FG_BATCOM_ACC"},
-	[AB5500_BANK_USB] = {AB5500_ADDR_USB, "USB"},
-	[AB5500_BANK_IT] = {AB5500_ADDR_IT, "IT"},
-	[AB5500_BANK_VIBRA] = {AB5500_ADDR_VIBRA, "VIBRA"},
-	[AB5500_BANK_AUDIO_HEADSETUSB] = {
-		AB5500_ADDR_AUDIO_HEADSETUSB, "AUDIO_HEADSETUSB"},
-};
-
-/**
- * struct ab5500_reg_range
- * @first: the first address of the range
- * @last: the last address of the range
- * @perm: access permissions for the range
- */
-struct ab5500_reg_range {
-	u8 first;
-	u8 last;
-	u8 perm;
-};
-
-/**
- * struct ab5500_i2c_ranges
- * @count: the number of ranges in the list
- * @range: the list of register ranges
- */
-struct ab5500_i2c_ranges {
-	u8 nranges;
-	u8 bankid;
-	const struct ab5500_reg_range *range;
-};
-
-/**
- * struct ab5500_i2c_banks
- * @count: the number of ranges in the list
- * @range: the list of register ranges
- */
-struct ab5500_i2c_banks {
-	u8 nbanks;
-	const struct ab5500_i2c_ranges *bank;
-};
-
 /*
  * Permissible register ranges for reading and writing per device and bank.
  *
@@ -1073,8 +996,9 @@ static struct mfd_cell ab5500_devs[AB5500_NUM_DEVICES] = {
 /*
  * Functionality for getting/setting register values.
  */
-static int get_register_interruptible(struct ab5500 *ab, u8 bank, u8 reg,
-	u8 *value)
+int ab5500_get_register_interruptible_raw(struct ab5500 *ab,
+					  u8 bank, u8 reg,
+					  u8 *value)
 {
 	int err;
 
@@ -1121,7 +1045,7 @@ out:
 	return err;
 }
 
-static int mask_and_set_register_interruptible(struct ab5500 *ab, u8 bank,
+int ab5500_mask_and_set_register_interruptible_raw(struct ab5500 *ab, u8 bank,
 	u8 reg, u8 bitmask, u8 bitvalues)
 {
 	int err = 0;
@@ -1158,7 +1082,8 @@ static int mask_and_set_register_interruptible(struct ab5500 *ab, u8 bank,
 static int
 set_register_interruptible(struct ab5500 *ab, u8 bank, u8 reg, u8 value)
 {
-	return mask_and_set_register_interruptible(ab, bank, reg, 0xff, value);
+	return ab5500_mask_and_set_register_interruptible_raw(ab, bank, reg,
+							      0xff, value);
 }
 
 /*
@@ -1261,7 +1186,7 @@ static int ab5500_mask_and_set_register_interruptible(struct device *dev,
 		return -EINVAL;
 
 	ab = dev_get_drvdata(dev->parent);
-	return mask_and_set_register_interruptible(ab, bank, reg,
+	return ab5500_mask_and_set_register_interruptible_raw(ab, bank, reg,
 		bitmask, bitvalues);
 }
 
@@ -1283,7 +1208,7 @@ static int ab5500_get_register_interruptible(struct device *dev, u8 bank,
 		return -EINVAL;
 
 	ab = dev_get_drvdata(dev->parent);
-	return get_register_interruptible(ab, bank, reg, value);
+	return ab5500_get_register_interruptible_raw(ab, bank, reg, value);
 }
 
 static int ab5500_get_register_page_interruptible(struct device *dev, u8 bank,
@@ -1327,806 +1252,6 @@ static struct abx500_ops ab5500_ops = {
 	.startup_irq_enabled = NULL,
 };
 
-#ifdef CONFIG_DEBUG_FS
-static struct ab5500_i2c_ranges ab5500_reg_ranges[AB5500_NUM_BANKS] = {
-	[AB5500_BANK_LED] = {
-		.bankid = AB5500_BANK_LED,
-		.nranges = 1,
-		.range = (struct ab5500_reg_range[]) {
-			{
-				.first = 0x00,
-				.last = 0x0C,
-				.perm = AB5500_PERM_RW,
-			},
-		},
-	},
-	[AB5500_BANK_ADC] = {
-		.bankid = AB5500_BANK_ADC,
-		.nranges = 6,
-		.range = (struct ab5500_reg_range[]) {
-			{
-				.first = 0x1F,
-				.last = 0x22,
-				.perm = AB5500_PERM_RO,
-			},
-			{
-				.first = 0x23,
-				.last = 0x24,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x26,
-				.last = 0x2D,
-				.perm = AB5500_PERM_RO,
-			},
-			{
-				.first = 0x2F,
-				.last = 0x34,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x37,
-				.last = 0x57,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x58,
-				.last = 0x58,
-				.perm = AB5500_PERM_RO,
-			},
-		},
-	},
-	[AB5500_BANK_RTC] = {
-		.bankid = AB5500_BANK_RTC,
-		.nranges = 2,
-		.range = (struct ab5500_reg_range[]) {
-			{
-				.first = 0x00,
-				.last = 0x04,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x06,
-				.last = 0x0C,
-				.perm = AB5500_PERM_RW,
-			},
-		},
-	},
-	[AB5500_BANK_STARTUP] = {
-		.bankid = AB5500_BANK_STARTUP,
-		.nranges = 12,
-		.range = (struct ab5500_reg_range[]) {
-			{
-				.first = 0x00,
-				.last = 0x01,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x1F,
-				.last = 0x1F,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x2E,
-				.last = 0x2E,
-				.perm = AB5500_PERM_RO,
-			},
-			{
-				.first = 0x2F,
-				.last = 0x30,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x50,
-				.last = 0x51,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x60,
-				.last = 0x61,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x66,
-				.last = 0x8A,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x8C,
-				.last = 0x96,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0xAA,
-				.last = 0xB4,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0xB7,
-				.last = 0xBF,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0xC1,
-				.last = 0xCA,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0xD3,
-				.last = 0xE0,
-				.perm = AB5500_PERM_RW,
-			},
-		},
-	},
-	[AB5500_BANK_DBI_ECI] = {
-		.bankid = AB5500_BANK_DBI_ECI,
-		.nranges = 3,
-		.range = (struct ab5500_reg_range[]) {
-			{
-				.first = 0x00,
-				.last = 0x07,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x10,
-				.last = 0x10,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x13,
-				.last = 0x13,
-				.perm = AB5500_PERM_RW,
-			},
-		},
-	},
-	[AB5500_BANK_CHG] = {
-		.bankid = AB5500_BANK_CHG,
-		.nranges = 2,
-		.range = (struct ab5500_reg_range[]) {
-			{
-				.first = 0x11,
-				.last = 0x11,
-				.perm = AB5500_PERM_RO,
-			},
-			{
-				.first = 0x12,
-				.last = 0x1B,
-				.perm = AB5500_PERM_RW,
-			},
-		},
-	},
-	[AB5500_BANK_FG_BATTCOM_ACC] = {
-		.bankid = AB5500_BANK_FG_BATTCOM_ACC,
-		.nranges = 2,
-		.range = (struct ab5500_reg_range[]) {
-			{
-				.first = 0x00,
-				.last = 0x0B,
-				.perm = AB5500_PERM_RO,
-			},
-			{
-				.first = 0x0C,
-				.last = 0x10,
-				.perm = AB5500_PERM_RW,
-			},
-		},
-	},
-	[AB5500_BANK_USB] = {
-		.bankid = AB5500_BANK_USB,
-		.nranges = 12,
-		.range = (struct ab5500_reg_range[]) {
-			{
-				.first = 0x01,
-				.last = 0x01,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x80,
-				.last = 0x83,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x87,
-				.last = 0x8A,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x8B,
-				.last = 0x8B,
-				.perm = AB5500_PERM_RO,
-			},
-			{
-				.first = 0x91,
-				.last = 0x92,
-				.perm = AB5500_PERM_RO,
-			},
-			{
-				.first = 0x93,
-				.last = 0x93,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x94,
-				.last = 0x94,
-				.perm = AB5500_PERM_RO,
-			},
-			{
-				.first = 0xA8,
-				.last = 0xB0,
-				.perm = AB5500_PERM_RO,
-			},
-			{
-				.first = 0xB2,
-				.last = 0xB2,
-				.perm = AB5500_PERM_RO,
-			},
-			{
-				.first = 0xB4,
-				.last = 0xBC,
-				.perm = AB5500_PERM_RO,
-			},
-			{
-				.first = 0xBF,
-				.last = 0xBF,
-				.perm = AB5500_PERM_RO,
-			},
-			{
-				.first = 0xC1,
-				.last = 0xC5,
-				.perm = AB5500_PERM_RO,
-			},
-		},
-	},
-	[AB5500_BANK_IT] = {
-		.bankid = AB5500_BANK_IT,
-		.nranges = 4,
-		.range = (struct ab5500_reg_range[]) {
-			{
-				.first = 0x00,
-				.last = 0x02,
-				.perm = AB5500_PERM_RO,
-			},
-			{
-				.first = 0x20,
-				.last = 0x36,
-				.perm = AB5500_PERM_RO,
-			},
-			{
-				.first = 0x40,
-				.last = 0x56,
-				.perm = AB5500_PERM_RO,
-			},
-			{
-				.first = 0x60,
-				.last = 0x76,
-				.perm = AB5500_PERM_RO,
-			},
-		},
-	},
-	[AB5500_BANK_VDDDIG_IO_I2C_CLK_TST] = {
-		.bankid = AB5500_BANK_VDDDIG_IO_I2C_CLK_TST,
-		.nranges = 7,
-		.range = (struct ab5500_reg_range[]) {
-			{
-				.first = 0x02,
-				.last = 0x02,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x12,
-				.last = 0x12,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x30,
-				.last = 0x34,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x40,
-				.last = 0x44,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x50,
-				.last = 0x54,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x60,
-				.last = 0x64,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x70,
-				.last = 0x74,
-				.perm = AB5500_PERM_RW,
-			},
-		},
-	},
-	[AB5500_BANK_VIT_IO_I2C_CLK_TST_OTP] = {
-		.bankid = AB5500_BANK_VIT_IO_I2C_CLK_TST_OTP,
-		.nranges = 13,
-		.range = (struct ab5500_reg_range[]) {
-			{
-				.first = 0x01,
-				.last = 0x01,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x02,
-				.last = 0x02,
-				.perm = AB5500_PERM_RO,
-			},
-			{
-				.first = 0x0D,
-				.last = 0x0F,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x1C,
-				.last = 0x1C,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x1E,
-				.last = 0x1E,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x20,
-				.last = 0x21,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x25,
-				.last = 0x25,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x28,
-				.last = 0x2A,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x30,
-				.last = 0x33,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x40,
-				.last = 0x43,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x50,
-				.last = 0x53,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x60,
-				.last = 0x63,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x70,
-				.last = 0x73,
-				.perm = AB5500_PERM_RW,
-			},
-		},
-	},
-	[AB5500_BANK_VIBRA] = {
-		.bankid = AB5500_BANK_VIBRA,
-		.nranges = 2,
-		.range = (struct ab5500_reg_range[]) {
-			{
-				.first = 0x10,
-				.last = 0x13,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0xFE,
-				.last = 0xFE,
-				.perm = AB5500_PERM_RW,
-			},
-		},
-	},
-	[AB5500_BANK_AUDIO_HEADSETUSB] = {
-		.bankid = AB5500_BANK_AUDIO_HEADSETUSB,
-		.nranges = 2,
-		.range = (struct ab5500_reg_range[]) {
-			{
-				.first = 0x00,
-				.last = 0x48,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0xEB,
-				.last = 0xFB,
-				.perm = AB5500_PERM_RW,
-			},
-		},
-	},
-	[AB5500_BANK_SIM_USBSIM] = {
-		.bankid = AB5500_BANK_SIM_USBSIM,
-		.nranges = 1,
-		.range = (struct ab5500_reg_range[]) {
-			{
-				.first = 0x13,
-				.last = 0x19,
-				.perm = AB5500_PERM_RW,
-			},
-		},
-	},
-	[AB5500_BANK_VDENC] = {
-		.bankid = AB5500_BANK_VDENC,
-		.nranges = 12,
-		.range = (struct ab5500_reg_range[]) {
-			{
-				.first = 0x00,
-				.last = 0x08,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x09,
-				.last = 0x09,
-				.perm = AB5500_PERM_RO,
-			},
-			{
-				.first = 0x0A,
-				.last = 0x12,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x15,
-				.last = 0x19,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x1B,
-				.last = 0x21,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x27,
-				.last = 0x2C,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x41,
-				.last = 0x41,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x45,
-				.last = 0x5B,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x5D,
-				.last = 0x5D,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x69,
-				.last = 0x69,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x6C,
-				.last = 0x6D,
-				.perm = AB5500_PERM_RW,
-			},
-			{
-				.first = 0x80,
-				.last = 0x81,
-				.perm = AB5500_PERM_RW,
-			},
-		},
-	},
-};
-static int ab5500_registers_print(struct seq_file *s, void *p)
-{
-	struct ab5500 *ab = s->private;
-	unsigned int i;
-	u8 bank = (u8)ab->debug_bank;
-
-	seq_printf(s, "ab5500 register values:\n");
-	for (bank = 0; bank < AB5500_NUM_BANKS; bank++) {
-		seq_printf(s, " bank %u, %s (0x%x):\n", bank,
-				bankinfo[bank].name,
-				bankinfo[bank].slave_addr);
-		for (i = 0; i < ab5500_reg_ranges[bank].nranges; i++) {
-			u8 reg;
-			int err;
-
-			for (reg = ab5500_reg_ranges[bank].range[i].first;
-				reg <= ab5500_reg_ranges[bank].range[i].last;
-				reg++) {
-				u8 value;
-
-				err = get_register_interruptible(ab, bank, reg,
-						&value);
-				if (err < 0) {
-					dev_err(ab->dev, "get_reg failed %d"
-						"bank 0x%x reg 0x%x\n",
-						err, bank, reg);
-					return err;
-				}
-
-				err = seq_printf(s, "[%d/0x%02X]: 0x%02X\n",
-						bank, reg, value);
-				if (err < 0) {
-					dev_err(ab->dev,
-						"seq_printf overflow\n");
-					/*
-					 * Error is not returned here since
-					 * the output is wanted in any case
-					 */
-					return 0;
-				}
-			}
-		}
-	}
-	return 0;
-}
-
-static int ab5500_registers_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ab5500_registers_print, inode->i_private);
-}
-
-static const struct file_operations ab5500_registers_fops = {
-	.open = ab5500_registers_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
-
-static int ab5500_bank_print(struct seq_file *s, void *p)
-{
-	struct ab5500 *ab = s->private;
-
-	seq_printf(s, "%d\n", ab->debug_bank);
-	return 0;
-}
-
-static int ab5500_bank_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ab5500_bank_print, inode->i_private);
-}
-
-static ssize_t ab5500_bank_write(struct file *file,
-	const char __user *user_buf,
-	size_t count, loff_t *ppos)
-{
-	struct ab5500 *ab = ((struct seq_file *)(file->private_data))->private;
-	char buf[32];
-	int buf_size;
-	unsigned long user_bank;
-	int err;
-
-	/* Get userspace string and assure termination */
-	buf_size = min(count, (sizeof(buf) - 1));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	buf[buf_size] = 0;
-
-	err = strict_strtoul(buf, 0, &user_bank);
-	if (err)
-		return -EINVAL;
-
-	if (user_bank >= AB5500_NUM_BANKS) {
-		dev_err(ab->dev,
-			"debugfs error input > number of banks\n");
-		return -EINVAL;
-	}
-
-	ab->debug_bank = user_bank;
-
-	return buf_size;
-}
-
-static int ab5500_address_print(struct seq_file *s, void *p)
-{
-	struct ab5500 *ab = s->private;
-
-	seq_printf(s, "0x%02X\n", ab->debug_address);
-	return 0;
-}
-
-static int ab5500_address_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ab5500_address_print, inode->i_private);
-}
-
-static ssize_t ab5500_address_write(struct file *file,
-	const char __user *user_buf,
-	size_t count, loff_t *ppos)
-{
-	struct ab5500 *ab = ((struct seq_file *)(file->private_data))->private;
-	char buf[32];
-	int buf_size;
-	unsigned long user_address;
-	int err;
-
-	/* Get userspace string and assure termination */
-	buf_size = min(count, (sizeof(buf) - 1));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	buf[buf_size] = 0;
-
-	err = strict_strtoul(buf, 0, &user_address);
-	if (err)
-		return -EINVAL;
-	if (user_address > 0xff) {
-		dev_err(ab->dev,
-			"debugfs error input > 0xff\n");
-		return -EINVAL;
-	}
-	ab->debug_address = user_address;
-	return buf_size;
-}
-
-static int ab5500_val_print(struct seq_file *s, void *p)
-{
-	struct ab5500 *ab = s->private;
-	int err;
-	u8 regvalue;
-
-	err = get_register_interruptible(ab, (u8)ab->debug_bank,
-		(u8)ab->debug_address, &regvalue);
-	if (err) {
-		dev_err(ab->dev, "get_reg failed %d, bank 0x%x"
-			", reg 0x%x\n", err, ab->debug_bank,
-			ab->debug_address);
-		return -EINVAL;
-	}
-	seq_printf(s, "0x%02X\n", regvalue);
-
-	return 0;
-}
-
-static int ab5500_val_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ab5500_val_print, inode->i_private);
-}
-
-static ssize_t ab5500_val_write(struct file *file,
-	const char __user *user_buf,
-	size_t count, loff_t *ppos)
-{
-	struct ab5500 *ab = ((struct seq_file *)(file->private_data))->private;
-	char buf[32];
-	int buf_size;
-	unsigned long user_val;
-	int err;
-	u8 regvalue;
-
-	/* Get userspace string and assure termination */
-	buf_size = min(count, (sizeof(buf)-1));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	buf[buf_size] = 0;
-
-	err = strict_strtoul(buf, 0, &user_val);
-	if (err)
-		return -EINVAL;
-	if (user_val > 0xff) {
-		dev_err(ab->dev,
-			"debugfs error input > 0xff\n");
-		return -EINVAL;
-	}
-	err = mask_and_set_register_interruptible(
-		ab, (u8)ab->debug_bank,
-		(u8)ab->debug_address, 0xFF, (u8)user_val);
-	if (err)
-		return -EINVAL;
-
-	get_register_interruptible(ab, (u8)ab->debug_bank,
-		(u8)ab->debug_address, &regvalue);
-	if (err)
-		return -EINVAL;
-
-	return buf_size;
-}
-
-static const struct file_operations ab5500_bank_fops = {
-	.open = ab5500_bank_open,
-	.write = ab5500_bank_write,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
-
-static const struct file_operations ab5500_address_fops = {
-	.open = ab5500_address_open,
-	.write = ab5500_address_write,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
-
-static const struct file_operations ab5500_val_fops = {
-	.open = ab5500_val_open,
-	.write = ab5500_val_write,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
-
-static struct dentry *ab5500_dir;
-static struct dentry *ab5500_reg_file;
-static struct dentry *ab5500_bank_file;
-static struct dentry *ab5500_address_file;
-static struct dentry *ab5500_val_file;
-
-static inline void ab5500_setup_debugfs(struct ab5500 *ab)
-{
-	ab->debug_bank = AB5500_BANK_VIT_IO_I2C_CLK_TST_OTP;
-	ab->debug_address = AB5500_CHIP_ID;
-
-	ab5500_dir = debugfs_create_dir("ab5500", NULL);
-	if (!ab5500_dir)
-		goto exit_no_debugfs;
-
-	ab5500_reg_file = debugfs_create_file("all-bank-registers",
-		S_IRUGO, ab5500_dir, ab, &ab5500_registers_fops);
-	if (!ab5500_reg_file)
-		goto exit_destroy_dir;
-
-	ab5500_bank_file = debugfs_create_file("register-bank",
-		(S_IRUGO | S_IWUGO), ab5500_dir, ab, &ab5500_bank_fops);
-	if (!ab5500_bank_file)
-		goto exit_destroy_reg;
-
-	ab5500_address_file = debugfs_create_file("register-address",
-		(S_IRUGO | S_IWUGO), ab5500_dir, ab, &ab5500_address_fops);
-	if (!ab5500_address_file)
-		goto exit_destroy_bank;
-
-	ab5500_val_file = debugfs_create_file("register-value",
-		(S_IRUGO | S_IWUGO), ab5500_dir, ab, &ab5500_val_fops);
-	if (!ab5500_val_file)
-		goto exit_destroy_address;
-
-	return;
-
-exit_destroy_address:
-	debugfs_remove(ab5500_address_file);
-exit_destroy_bank:
-	debugfs_remove(ab5500_bank_file);
-exit_destroy_reg:
-	debugfs_remove(ab5500_reg_file);
-exit_destroy_dir:
-	debugfs_remove(ab5500_dir);
-exit_no_debugfs:
-	dev_err(ab->dev, "failed to create debugfs entries.\n");
-	return;
-}
-
-static inline void ab5500_remove_debugfs(void)
-{
-	debugfs_remove(ab5500_val_file);
-	debugfs_remove(ab5500_address_file);
-	debugfs_remove(ab5500_bank_file);
-	debugfs_remove(ab5500_reg_file);
-	debugfs_remove(ab5500_dir);
-}
-
-#else /* !CONFIG_DEBUG_FS */
-static inline void ab5500_setup_debugfs(struct ab5500 *ab)
-{
-}
-static inline void ab5500_remove_debugfs(void)
-{
-}
-#endif
-
 /*
  * ab5500_setup : Basic set-up, datastructure creation/destruction
  *		  and I2C interface.This sets up a default config
@@ -2142,7 +1267,7 @@ static int __init ab5500_setup(struct ab5500 *ab,
 	int i;
 
 	for (i = 0; i < size; i++) {
-		err = mask_and_set_register_interruptible(ab,
+		err = ab5500_mask_and_set_register_interruptible_raw(ab,
 			settings[i].bank,
 			settings[i].reg,
 			0xFF, settings[i].setting);
@@ -2205,8 +1330,9 @@ static int __init ab5500_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, ab);
 
 	/* Read chip ID register */
-	err = get_register_interruptible(ab, AB5500_BANK_VIT_IO_I2C_CLK_TST_OTP,
-		AB5500_CHIP_ID, &ab->chip_id);
+	err = ab5500_get_register_interruptible_raw(ab,
+					AB5500_BANK_VIT_IO_I2C_CLK_TST_OTP,
+					AB5500_CHIP_ID, &ab->chip_id);
 	if (err) {
 		dev_err(&pdev->dev, "could not communicate with the analog "
 			"baseband chip\n");
@@ -2233,7 +1359,8 @@ static int __init ab5500_probe(struct platform_device *pdev)
 		u8 maskreg = AB5500_IT_MASK0_REG + i;
 		u8 val;
 
-		get_register_interruptible(ab, AB5500_BANK_IT, latchreg, &val);
+		ab5500_get_register_interruptible_raw(ab, AB5500_BANK_IT,
+						      latchreg, &val);
 		set_register_interruptible(ab, AB5500_BANK_IT, maskreg, 0xff);
 		ab->mask[i] = ab->oldmask[i] = 0xff;
 	}
diff --git a/drivers/mfd/ab5500-core.h b/drivers/mfd/ab5500-core.h
new file mode 100644
index 0000000..63b30b1
--- /dev/null
+++ b/drivers/mfd/ab5500-core.h
@@ -0,0 +1,87 @@
+/*
+ * Copyright (C) 2011 ST-Ericsson
+ * License terms: GNU General Public License (GPL) version 2
+ * Shared definitions and data structures for the AB5500 MFD driver
+ */
+
+/* Read/write operation values. */
+#define AB5500_PERM_RD (0x01)
+#define AB5500_PERM_WR (0x02)
+
+/* Read/write permissions. */
+#define AB5500_PERM_RO (AB5500_PERM_RD)
+#define AB5500_PERM_RW (AB5500_PERM_RD | AB5500_PERM_WR)
+
+#define AB5500_MASK_BASE (0x60)
+#define AB5500_MASK_END (0x79)
+#define AB5500_CHIP_ID (0x20)
+
+/**
+ * struct ab5500_reg_range
+ * @first: the first address of the range
+ * @last: the last address of the range
+ * @perm: access permissions for the range
+ */
+struct ab5500_reg_range {
+	u8 first;
+	u8 last;
+	u8 perm;
+};
+
+/**
+ * struct ab5500_i2c_ranges
+ * @count: the number of ranges in the list
+ * @range: the list of register ranges
+ */
+struct ab5500_i2c_ranges {
+	u8 nranges;
+	u8 bankid;
+	const struct ab5500_reg_range *range;
+};
+
+/**
+ * struct ab5500_i2c_banks
+ * @count: the number of ranges in the list
+ * @range: the list of register ranges
+ */
+struct ab5500_i2c_banks {
+	u8 nbanks;
+	const struct ab5500_i2c_ranges *bank;
+};
+
+/**
+ * struct ab5500_bank
+ * @slave_addr: I2C slave_addr found in AB5500 specification
+ * @name: Documentation name of the bank. For reference
+ */
+struct ab5500_bank {
+	u8 slave_addr;
+	const char *name;
+};
+
+static const struct ab5500_bank bankinfo[AB5500_NUM_BANKS] = {
+	[AB5500_BANK_VIT_IO_I2C_CLK_TST_OTP] = {
+		AB5500_ADDR_VIT_IO_I2C_CLK_TST_OTP, "VIT_IO_I2C_CLK_TST_OTP"},
+	[AB5500_BANK_VDDDIG_IO_I2C_CLK_TST] = {
+		AB5500_ADDR_VDDDIG_IO_I2C_CLK_TST, "VDDDIG_IO_I2C_CLK_TST"},
+	[AB5500_BANK_VDENC] = {AB5500_ADDR_VDENC, "VDENC"},
+	[AB5500_BANK_SIM_USBSIM] = {AB5500_ADDR_SIM_USBSIM, "SIM_USBSIM"},
+	[AB5500_BANK_LED] = {AB5500_ADDR_LED, "LED"},
+	[AB5500_BANK_ADC] = {AB5500_ADDR_ADC, "ADC"},
+	[AB5500_BANK_RTC] = {AB5500_ADDR_RTC, "RTC"},
+	[AB5500_BANK_STARTUP] = {AB5500_ADDR_STARTUP, "STARTUP"},
+	[AB5500_BANK_DBI_ECI] = {AB5500_ADDR_DBI_ECI, "DBI-ECI"},
+	[AB5500_BANK_CHG] = {AB5500_ADDR_CHG, "CHG"},
+	[AB5500_BANK_FG_BATTCOM_ACC] = {
+		AB5500_ADDR_FG_BATTCOM_ACC, "FG_BATCOM_ACC"},
+	[AB5500_BANK_USB] = {AB5500_ADDR_USB, "USB"},
+	[AB5500_BANK_IT] = {AB5500_ADDR_IT, "IT"},
+	[AB5500_BANK_VIBRA] = {AB5500_ADDR_VIBRA, "VIBRA"},
+	[AB5500_BANK_AUDIO_HEADSETUSB] = {
+		AB5500_ADDR_AUDIO_HEADSETUSB, "AUDIO_HEADSETUSB"},
+};
+
+int ab5500_get_register_interruptible_raw(struct ab5500 *ab, u8 bank, u8 reg,
+	u8 *value);
+int ab5500_mask_and_set_register_interruptible_raw(struct ab5500 *ab, u8 bank,
+	u8 reg, u8 bitmask, u8 bitvalues);
diff --git a/drivers/mfd/ab5500-debugfs.c b/drivers/mfd/ab5500-debugfs.c
new file mode 100644
index 0000000..6be1fe6
--- /dev/null
+++ b/drivers/mfd/ab5500-debugfs.c
@@ -0,0 +1,806 @@
+/*
+ * Copyright (C) 2011 ST-Ericsson
+ * License terms: GNU General Public License (GPL) version 2
+ * Debugfs support for the AB5500 MFD driver
+ */
+
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/mfd/ab5500/ab5500.h>
+#include <linux/mfd/abx500.h>
+#include <linux/uaccess.h>
+
+#include "ab5500-core.h"
+#include "ab5500-debugfs.h"
+
+static struct ab5500_i2c_ranges ab5500_reg_ranges[AB5500_NUM_BANKS] = {
+	[AB5500_BANK_LED] = {
+		.bankid = AB5500_BANK_LED,
+		.nranges = 1,
+		.range = (struct ab5500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x0C,
+				.perm = AB5500_PERM_RW,
+			},
+		},
+	},
+	[AB5500_BANK_ADC] = {
+		.bankid = AB5500_BANK_ADC,
+		.nranges = 6,
+		.range = (struct ab5500_reg_range[]) {
+			{
+				.first = 0x1F,
+				.last = 0x22,
+				.perm = AB5500_PERM_RO,
+			},
+			{
+				.first = 0x23,
+				.last = 0x24,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x26,
+				.last = 0x2D,
+				.perm = AB5500_PERM_RO,
+			},
+			{
+				.first = 0x2F,
+				.last = 0x34,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x37,
+				.last = 0x57,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x58,
+				.last = 0x58,
+				.perm = AB5500_PERM_RO,
+			},
+		},
+	},
+	[AB5500_BANK_RTC] = {
+		.bankid = AB5500_BANK_RTC,
+		.nranges = 2,
+		.range = (struct ab5500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x04,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x06,
+				.last = 0x0C,
+				.perm = AB5500_PERM_RW,
+			},
+		},
+	},
+	[AB5500_BANK_STARTUP] = {
+		.bankid = AB5500_BANK_STARTUP,
+		.nranges = 12,
+		.range = (struct ab5500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x01,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x1F,
+				.last = 0x1F,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x2E,
+				.last = 0x2E,
+				.perm = AB5500_PERM_RO,
+			},
+			{
+				.first = 0x2F,
+				.last = 0x30,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x50,
+				.last = 0x51,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x60,
+				.last = 0x61,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x66,
+				.last = 0x8A,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x8C,
+				.last = 0x96,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0xAA,
+				.last = 0xB4,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0xB7,
+				.last = 0xBF,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0xC1,
+				.last = 0xCA,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0xD3,
+				.last = 0xE0,
+				.perm = AB5500_PERM_RW,
+			},
+		},
+	},
+	[AB5500_BANK_DBI_ECI] = {
+		.bankid = AB5500_BANK_DBI_ECI,
+		.nranges = 3,
+		.range = (struct ab5500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x07,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x10,
+				.last = 0x10,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x13,
+				.last = 0x13,
+				.perm = AB5500_PERM_RW,
+			},
+		},
+	},
+	[AB5500_BANK_CHG] = {
+		.bankid = AB5500_BANK_CHG,
+		.nranges = 2,
+		.range = (struct ab5500_reg_range[]) {
+			{
+				.first = 0x11,
+				.last = 0x11,
+				.perm = AB5500_PERM_RO,
+			},
+			{
+				.first = 0x12,
+				.last = 0x1B,
+				.perm = AB5500_PERM_RW,
+			},
+		},
+	},
+	[AB5500_BANK_FG_BATTCOM_ACC] = {
+		.bankid = AB5500_BANK_FG_BATTCOM_ACC,
+		.nranges = 2,
+		.range = (struct ab5500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x0B,
+				.perm = AB5500_PERM_RO,
+			},
+			{
+				.first = 0x0C,
+				.last = 0x10,
+				.perm = AB5500_PERM_RW,
+			},
+		},
+	},
+	[AB5500_BANK_USB] = {
+		.bankid = AB5500_BANK_USB,
+		.nranges = 12,
+		.range = (struct ab5500_reg_range[]) {
+			{
+				.first = 0x01,
+				.last = 0x01,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x80,
+				.last = 0x83,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x87,
+				.last = 0x8A,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x8B,
+				.last = 0x8B,
+				.perm = AB5500_PERM_RO,
+			},
+			{
+				.first = 0x91,
+				.last = 0x92,
+				.perm = AB5500_PERM_RO,
+			},
+			{
+				.first = 0x93,
+				.last = 0x93,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x94,
+				.last = 0x94,
+				.perm = AB5500_PERM_RO,
+			},
+			{
+				.first = 0xA8,
+				.last = 0xB0,
+				.perm = AB5500_PERM_RO,
+			},
+			{
+				.first = 0xB2,
+				.last = 0xB2,
+				.perm = AB5500_PERM_RO,
+			},
+			{
+				.first = 0xB4,
+				.last = 0xBC,
+				.perm = AB5500_PERM_RO,
+			},
+			{
+				.first = 0xBF,
+				.last = 0xBF,
+				.perm = AB5500_PERM_RO,
+			},
+			{
+				.first = 0xC1,
+				.last = 0xC5,
+				.perm = AB5500_PERM_RO,
+			},
+		},
+	},
+	[AB5500_BANK_IT] = {
+		.bankid = AB5500_BANK_IT,
+		.nranges = 4,
+		.range = (struct ab5500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x02,
+				.perm = AB5500_PERM_RO,
+			},
+			{
+				.first = 0x20,
+				.last = 0x36,
+				.perm = AB5500_PERM_RO,
+			},
+			{
+				.first = 0x40,
+				.last = 0x56,
+				.perm = AB5500_PERM_RO,
+			},
+			{
+				.first = 0x60,
+				.last = 0x76,
+				.perm = AB5500_PERM_RO,
+			},
+		},
+	},
+	[AB5500_BANK_VDDDIG_IO_I2C_CLK_TST] = {
+		.bankid = AB5500_BANK_VDDDIG_IO_I2C_CLK_TST,
+		.nranges = 7,
+		.range = (struct ab5500_reg_range[]) {
+			{
+				.first = 0x02,
+				.last = 0x02,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x12,
+				.last = 0x12,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x30,
+				.last = 0x34,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x40,
+				.last = 0x44,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x50,
+				.last = 0x54,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x60,
+				.last = 0x64,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x70,
+				.last = 0x74,
+				.perm = AB5500_PERM_RW,
+			},
+		},
+	},
+	[AB5500_BANK_VIT_IO_I2C_CLK_TST_OTP] = {
+		.bankid = AB5500_BANK_VIT_IO_I2C_CLK_TST_OTP,
+		.nranges = 13,
+		.range = (struct ab5500_reg_range[]) {
+			{
+				.first = 0x01,
+				.last = 0x01,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x02,
+				.last = 0x02,
+				.perm = AB5500_PERM_RO,
+			},
+			{
+				.first = 0x0D,
+				.last = 0x0F,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x1C,
+				.last = 0x1C,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x1E,
+				.last = 0x1E,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x20,
+				.last = 0x21,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x25,
+				.last = 0x25,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x28,
+				.last = 0x2A,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x30,
+				.last = 0x33,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x40,
+				.last = 0x43,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x50,
+				.last = 0x53,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x60,
+				.last = 0x63,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x70,
+				.last = 0x73,
+				.perm = AB5500_PERM_RW,
+			},
+		},
+	},
+	[AB5500_BANK_VIBRA] = {
+		.bankid = AB5500_BANK_VIBRA,
+		.nranges = 2,
+		.range = (struct ab5500_reg_range[]) {
+			{
+				.first = 0x10,
+				.last = 0x13,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0xFE,
+				.last = 0xFE,
+				.perm = AB5500_PERM_RW,
+			},
+		},
+	},
+	[AB5500_BANK_AUDIO_HEADSETUSB] = {
+		.bankid = AB5500_BANK_AUDIO_HEADSETUSB,
+		.nranges = 2,
+		.range = (struct ab5500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x48,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0xEB,
+				.last = 0xFB,
+				.perm = AB5500_PERM_RW,
+			},
+		},
+	},
+	[AB5500_BANK_SIM_USBSIM] = {
+		.bankid = AB5500_BANK_SIM_USBSIM,
+		.nranges = 1,
+		.range = (struct ab5500_reg_range[]) {
+			{
+				.first = 0x13,
+				.last = 0x19,
+				.perm = AB5500_PERM_RW,
+			},
+		},
+	},
+	[AB5500_BANK_VDENC] = {
+		.bankid = AB5500_BANK_VDENC,
+		.nranges = 12,
+		.range = (struct ab5500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x08,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x09,
+				.last = 0x09,
+				.perm = AB5500_PERM_RO,
+			},
+			{
+				.first = 0x0A,
+				.last = 0x12,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x15,
+				.last = 0x19,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x1B,
+				.last = 0x21,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x27,
+				.last = 0x2C,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x41,
+				.last = 0x41,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x45,
+				.last = 0x5B,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x5D,
+				.last = 0x5D,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x69,
+				.last = 0x69,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x6C,
+				.last = 0x6D,
+				.perm = AB5500_PERM_RW,
+			},
+			{
+				.first = 0x80,
+				.last = 0x81,
+				.perm = AB5500_PERM_RW,
+			},
+		},
+	},
+};
+
+static int ab5500_registers_print(struct seq_file *s, void *p)
+{
+	struct ab5500 *ab = s->private;
+	unsigned int i;
+	u8 bank = (u8)ab->debug_bank;
+
+	seq_printf(s, "ab5500 register values:\n");
+	for (bank = 0; bank < AB5500_NUM_BANKS; bank++) {
+		seq_printf(s, " bank %u, %s (0x%x):\n", bank,
+				bankinfo[bank].name,
+				bankinfo[bank].slave_addr);
+		for (i = 0; i < ab5500_reg_ranges[bank].nranges; i++) {
+			u8 reg;
+			int err;
+
+			for (reg = ab5500_reg_ranges[bank].range[i].first;
+				reg <= ab5500_reg_ranges[bank].range[i].last;
+				reg++) {
+				u8 value;
+
+				err = ab5500_get_register_interruptible_raw(ab,
+								bank, reg,
+								&value);
+				if (err < 0) {
+					dev_err(ab->dev, "get_reg failed %d"
+						"bank 0x%x reg 0x%x\n",
+						err, bank, reg);
+					return err;
+				}
+
+				err = seq_printf(s, "[%d/0x%02X]: 0x%02X\n",
+						bank, reg, value);
+				if (err < 0) {
+					dev_err(ab->dev,
+						"seq_printf overflow\n");
+					/*
+					 * Error is not returned here since
+					 * the output is wanted in any case
+					 */
+					return 0;
+				}
+			}
+		}
+	}
+	return 0;
+}
+
+static int ab5500_registers_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab5500_registers_print, inode->i_private);
+}
+
+static const struct file_operations ab5500_registers_fops = {
+	.open = ab5500_registers_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab5500_bank_print(struct seq_file *s, void *p)
+{
+	struct ab5500 *ab = s->private;
+
+	seq_printf(s, "%d\n", ab->debug_bank);
+	return 0;
+}
+
+static int ab5500_bank_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab5500_bank_print, inode->i_private);
+}
+
+static ssize_t ab5500_bank_write(struct file *file,
+	const char __user *user_buf,
+	size_t count, loff_t *ppos)
+{
+	struct ab5500 *ab = ((struct seq_file *)(file->private_data))->private;
+	char buf[32];
+	int buf_size;
+	unsigned long user_bank;
+	int err;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf) - 1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	err = strict_strtoul(buf, 0, &user_bank);
+	if (err)
+		return -EINVAL;
+
+	if (user_bank >= AB5500_NUM_BANKS) {
+		dev_err(ab->dev,
+			"debugfs error input > number of banks\n");
+		return -EINVAL;
+	}
+
+	ab->debug_bank = user_bank;
+
+	return buf_size;
+}
+
+static int ab5500_address_print(struct seq_file *s, void *p)
+{
+	struct ab5500 *ab = s->private;
+
+	seq_printf(s, "0x%02X\n", ab->debug_address);
+	return 0;
+}
+
+static int ab5500_address_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab5500_address_print, inode->i_private);
+}
+
+static ssize_t ab5500_address_write(struct file *file,
+	const char __user *user_buf,
+	size_t count, loff_t *ppos)
+{
+	struct ab5500 *ab = ((struct seq_file *)(file->private_data))->private;
+	char buf[32];
+	int buf_size;
+	unsigned long user_address;
+	int err;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf) - 1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	err = strict_strtoul(buf, 0, &user_address);
+	if (err)
+		return -EINVAL;
+	if (user_address > 0xff) {
+		dev_err(ab->dev,
+			"debugfs error input > 0xff\n");
+		return -EINVAL;
+	}
+	ab->debug_address = user_address;
+	return buf_size;
+}
+
+static int ab5500_val_print(struct seq_file *s, void *p)
+{
+	struct ab5500 *ab = s->private;
+	int err;
+	u8 regvalue;
+
+	err = ab5500_get_register_interruptible_raw(ab, (u8)ab->debug_bank,
+		(u8)ab->debug_address, &regvalue);
+	if (err) {
+		dev_err(ab->dev, "get_reg failed %d, bank 0x%x"
+			", reg 0x%x\n", err, ab->debug_bank,
+			ab->debug_address);
+		return -EINVAL;
+	}
+	seq_printf(s, "0x%02X\n", regvalue);
+
+	return 0;
+}
+
+static int ab5500_val_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab5500_val_print, inode->i_private);
+}
+
+static ssize_t ab5500_val_write(struct file *file,
+	const char __user *user_buf,
+	size_t count, loff_t *ppos)
+{
+	struct ab5500 *ab = ((struct seq_file *)(file->private_data))->private;
+	char buf[32];
+	int buf_size;
+	unsigned long user_val;
+	int err;
+	u8 regvalue;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	err = strict_strtoul(buf, 0, &user_val);
+	if (err)
+		return -EINVAL;
+	if (user_val > 0xff) {
+		dev_err(ab->dev,
+			"debugfs error input > 0xff\n");
+		return -EINVAL;
+	}
+	err = ab5500_mask_and_set_register_interruptible_raw(
+		ab, (u8)ab->debug_bank,
+		(u8)ab->debug_address, 0xFF, (u8)user_val);
+	if (err)
+		return -EINVAL;
+
+	ab5500_get_register_interruptible_raw(ab, (u8)ab->debug_bank,
+		(u8)ab->debug_address, &regvalue);
+	if (err)
+		return -EINVAL;
+
+	return buf_size;
+}
+
+static const struct file_operations ab5500_bank_fops = {
+	.open = ab5500_bank_open,
+	.write = ab5500_bank_write,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static const struct file_operations ab5500_address_fops = {
+	.open = ab5500_address_open,
+	.write = ab5500_address_write,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static const struct file_operations ab5500_val_fops = {
+	.open = ab5500_val_open,
+	.write = ab5500_val_write,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static struct dentry *ab5500_dir;
+static struct dentry *ab5500_reg_file;
+static struct dentry *ab5500_bank_file;
+static struct dentry *ab5500_address_file;
+static struct dentry *ab5500_val_file;
+
+void __init ab5500_setup_debugfs(struct ab5500 *ab)
+{
+	ab->debug_bank = AB5500_BANK_VIT_IO_I2C_CLK_TST_OTP;
+	ab->debug_address = AB5500_CHIP_ID;
+
+	ab5500_dir = debugfs_create_dir("ab5500", NULL);
+	if (!ab5500_dir)
+		goto exit_no_debugfs;
+
+	ab5500_reg_file = debugfs_create_file("all-bank-registers",
+		S_IRUGO, ab5500_dir, ab, &ab5500_registers_fops);
+	if (!ab5500_reg_file)
+		goto exit_destroy_dir;
+
+	ab5500_bank_file = debugfs_create_file("register-bank",
+		(S_IRUGO | S_IWUGO), ab5500_dir, ab, &ab5500_bank_fops);
+	if (!ab5500_bank_file)
+		goto exit_destroy_reg;
+
+	ab5500_address_file = debugfs_create_file("register-address",
+		(S_IRUGO | S_IWUGO), ab5500_dir, ab, &ab5500_address_fops);
+	if (!ab5500_address_file)
+		goto exit_destroy_bank;
+
+	ab5500_val_file = debugfs_create_file("register-value",
+		(S_IRUGO | S_IWUGO), ab5500_dir, ab, &ab5500_val_fops);
+	if (!ab5500_val_file)
+		goto exit_destroy_address;
+
+	return;
+
+exit_destroy_address:
+	debugfs_remove(ab5500_address_file);
+exit_destroy_bank:
+	debugfs_remove(ab5500_bank_file);
+exit_destroy_reg:
+	debugfs_remove(ab5500_reg_file);
+exit_destroy_dir:
+	debugfs_remove(ab5500_dir);
+exit_no_debugfs:
+	dev_err(ab->dev, "failed to create debugfs entries.\n");
+	return;
+}
+
+void __exit ab5500_remove_debugfs(void)
+{
+	debugfs_remove(ab5500_val_file);
+	debugfs_remove(ab5500_address_file);
+	debugfs_remove(ab5500_bank_file);
+	debugfs_remove(ab5500_reg_file);
+	debugfs_remove(ab5500_dir);
+}
diff --git a/drivers/mfd/ab5500-debugfs.h b/drivers/mfd/ab5500-debugfs.h
new file mode 100644
index 0000000..7330a9b
--- /dev/null
+++ b/drivers/mfd/ab5500-debugfs.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2011 ST-Ericsson
+ * License terms: GNU General Public License (GPL) version 2
+ * Debugfs interface to the AB5500 core driver
+ */
+
+#ifdef CONFIG_DEBUG_FS
+
+void ab5500_setup_debugfs(struct ab5500 *ab);
+void ab5500_remove_debugfs(void);
+
+#else /* !CONFIG_DEBUG_FS */
+
+static inline void ab5500_setup_debugfs(struct ab5500 *ab)
+{
+}
+
+static inline void ab5500_remove_debugfs(void)
+{
+}
+
+#endif
-- 
1.7.3.2

