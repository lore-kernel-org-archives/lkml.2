Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab0F1V7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 17:59:06 -0400
Received: from imr1.ericy.com ([198.24.6.9]:60418 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630Ab0F1V7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 17:59:01 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Hans de Goede <hdegoede@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>, Crane Cai <crane.cai@amd.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Ralf Baechle <ralf@linux-mips.org>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       linux-i2c@vger.kernel.org, Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH/RFC 1/4] hwmon: i2c PMBus device emulator
Date: Mon, 28 Jun 2010 14:56:51 -0700
Message-ID: <1277762214-15155-2-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <1277762214-15155-1-git-send-email-guenter.roeck@ericsson.com>
References: <1277762214-15155-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 Documentation/i2c/i2c-pmbus    |   41 ++
 drivers/i2c/busses/Kconfig     |   13 +
 drivers/i2c/busses/Makefile    |    1 +
 drivers/i2c/busses/i2c-pmbus.c |  874 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 929 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/i2c/i2c-pmbus
 create mode 100644 drivers/i2c/busses/i2c-pmbus.c

diff --git a/Documentation/i2c/i2c-pmbus b/Documentation/i2c/i2c-pmbus
new file mode 100644
index 0000000..4ba01fc
--- /dev/null
+++ b/Documentation/i2c/i2c-pmbus
@@ -0,0 +1,41 @@
+MODULE: i2c-pmbus
+
+DESCRIPTION:
+
+This module is a fake I2C/SMBus driver to emulate various PMBus devices.
+It implements five types of SMBus commands: write quick, (r/w) byte,
+(r/w) byte data, (r/w) word data, and (r/w) I2C block data.
+
+The driver supports various PMBus devices at fixed addresses. The following
+PMBus devices are supported.
+
+Device	        Address
+BMR453	        0x10
+LTC2978	        0x20
+MAX16064	0x30
+MAX8688	        0x40
+UCD9240         0x50
+
+No hardware is needed nor associated with this module.  It will accept write
+quick commands to the specified addresses; it will respond to the other
+commands (also to the specified addresses) by reading from or writing to
+arrays in memory.
+
+Once loaded, the driver randomly changes sensor readings, up to lower and upper
+fault limits. This may cause alarms or faults to be raised. This is expected
+behavior.
+
+The typical use-case is like this:
+	1. load this module
+	3. load the target chip driver module
+	4. observe its behavior using the sensors command
+
+
+CAVEATS:
+
+Support for multiple pages (PMBus PAGE command) is limited. Pages can be
+selected, but there is only one set of data, causing all paged registers to
+return the same values.
+
+The emulator does not support self-modification of sensor readings for devices
+which have to be programmed in direct mode.
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index bceafbf..5ab4abc 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -731,6 +731,19 @@ config I2C_PCA_ISA
 	  delays when I2C/SMBus chip drivers are loaded (e.g. at boot
 	  time).  If unsure, say N.
 
+config I2C_PMBUS
+	tristate "I2C/PMBus Chip Emulator"
+	depends on EXPERIMENTAL
+	default 'n'
+	help
+	  This module emulates various PMBus devices. It may be useful to
+	  developers of PMBus client drivers.
+
+	  If you do build this module, be sure to read the notes and warnings
+	  in <file:Documentation/i2c/i2c-pmbus>.
+
+	  If you don't know what to do here, definitely say N.
+
 config I2C_SIBYTE
 	tristate "SiByte SMBus interface"
 	depends on SIBYTE_SB1xxx_SOC
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 936880b..c11884e 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_I2C_TINY_USB)	+= i2c-tiny-usb.o
 obj-$(CONFIG_I2C_ACORN)		+= i2c-acorn.o
 obj-$(CONFIG_I2C_ELEKTOR)	+= i2c-elektor.o
 obj-$(CONFIG_I2C_PCA_ISA)	+= i2c-pca-isa.o
+obj-$(CONFIG_I2C_PMBUS)		+= i2c-pmbus.o
 obj-$(CONFIG_I2C_SIBYTE)	+= i2c-sibyte.o
 obj-$(CONFIG_I2C_STUB)		+= i2c-stub.o
 obj-$(CONFIG_SCx200_ACB)	+= scx200_acb.o
diff --git a/drivers/i2c/busses/i2c-pmbus.c b/drivers/i2c/busses/i2c-pmbus.c
new file mode 100644
index 0000000..7e231cd
--- /dev/null
+++ b/drivers/i2c/busses/i2c-pmbus.c
@@ -0,0 +1,874 @@
+/*
+ * i2c-pmbus.c - I2C/SMBus chip emulator
+ *
+ * Copyright (C) 2010 Ericsson AB.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/i2c.h>
+#include <linux/random.h>
+#include "../../hwmon/pmbus.h"
+
+#define NUM_CHIPS   5
+
+enum chips { bmr453, ltc2978, max16064, max8688, ucd9240 };
+
+/*
+ * Register sizes per PMBus specification.
+ */
+static s8 pmbus_regsize[256] = {
+	1, 1, 1, 0, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
+	1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 16, -1, -1, -1, -1, -1,
+	1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, -1, -1, -1, -1, -1,
+	16, 2, 2, 2, -1, 2, 2, 2, 2, 2, 1, 2, 2, 1, 2, 2,
+	2, 1, 2, 2, 2, 1, 2, 1, 2, 1, 2, 2, 1, -1, -1, 2,
+	1, 2, 2, 2, 1, 2, 1, 2, 2, 2, 1, 2, 1, 2, 2, 2,
+	2, 2, 2, 1, 2, 2, 2, -1, 2, 1, 2, 2, -1, -1, -1, -1,
+	-1, -1, -1, -1, -1, -1, -1, -1, 1, 2, 1, 1, 1, 1, 1, 1,
+	1, 1, 1, -1, -1, -1, -1, -1, 2, 2, 2, 2, 2, 2, 2, 2,
+	2, 2, 2, 2, 2, 2, 2, 2, 1, 16, 16, 16, 16, 16, 16, -1,
+	2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 14, 14, -1, -1, -1, -1,
+	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
+	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
+	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
+	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
+	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
+};
+
+/*
+ * PMBus register types. 1=rw, 0=ro or undefined
+ */
+static s8 pmbus_rw[256] = {
+	1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0,
+	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
+	1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
+	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1,
+	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
+	1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+};
+
+/*
+ * exp 0xf8 -> 2^-1; mantissa 0x01 = 0.5V
+ * exp 0xf0 -> 2^-2; mantissa 0x01 = 0.25V
+ * exp 0xd0 -> 2^-6; mantissa 0x01 = 0.025V, 0x10 = 0.25V
+ */
+#define V1P5_LINEAR	0xd060
+#define V2P5_LINEAR	0xd0a0
+#define V2P75_LINEAR	0xd0b0
+#define V3P25_LINEAR	0xd0d0
+#define V3P5_LINEAR	0xd0e0
+#define V3P75_LINEAR	0xd0f0
+#define V11P5_LINEAR	0xf817
+#define V11P25_LINEAR	0xf02d
+#define V12_LINEAR	0xf818
+#define V12P5_LINEAR	0xf032
+#define V12P75_LINEAR	0xf033
+
+static u16 pmbus_linear_data[256] = {
+	[PMBUS_PAGE] = 0,
+
+	[PMBUS_CAPABILITY] = PB_CAPABILITY_SMBALERT,
+	[PMBUS_VOUT_MODE] = (PB_VOUT_MODE_LINEAR | 0x13),
+				/* linear, -13 */
+
+	[PMBUS_VIN_OV_FAULT_LIMIT] = V12P75_LINEAR,
+	[PMBUS_VIN_OV_WARN_LIMIT] = V12P5_LINEAR,
+	[PMBUS_VIN_UV_WARN_LIMIT] = V11P5_LINEAR,
+	[PMBUS_VIN_UV_FAULT_LIMIT] = V11P25_LINEAR,
+
+	[PMBUS_VOUT_OV_FAULT_LIMIT] = V3P5_LINEAR,
+	[PMBUS_VOUT_OV_WARN_LIMIT] = V3P25_LINEAR,
+	[PMBUS_VOUT_UV_WARN_LIMIT] = V2P75_LINEAR,
+	[PMBUS_VOUT_UV_FAULT_LIMIT] = V2P5_LINEAR,
+
+	[PMBUS_IOUT_OC_FAULT_LIMIT] = 22,
+	[PMBUS_IOUT_OC_LV_FAULT_LIMIT] = 30,
+	[PMBUS_IOUT_OC_WARN_LIMIT] = 20,
+	[PMBUS_IOUT_UC_FAULT_LIMIT] = 0,
+
+	[PMBUS_IIN_OC_FAULT_LIMIT] = 20,
+	[PMBUS_IIN_OC_WARN_LIMIT] = 19,
+
+	[PMBUS_POUT_OP_FAULT_LIMIT] = 0x1000 | 600, /* 2400 */
+	[PMBUS_POUT_OP_WARN_LIMIT] = 0x1000 | 500,  /* 2000 */
+	[PMBUS_PIN_OP_WARN_LIMIT] = 0x1000 | 400,   /* 1600 */
+
+	[PMBUS_OT_FAULT_LIMIT] = 100,
+	[PMBUS_OT_WARN_LIMIT] = 90,
+	[PMBUS_UT_WARN_LIMIT] = 10,
+	[PMBUS_UT_FAULT_LIMIT] = 0,
+
+	[PMBUS_READ_VIN] = V12_LINEAR,
+	[PMBUS_READ_IIN] = 2,
+	[PMBUS_READ_VCAP] = V11P5_LINEAR,
+	[PMBUS_READ_VOUT] = 3,
+	[PMBUS_READ_IOUT] = 8,
+	[PMBUS_READ_TEMPERATURE_1] = 44,
+	[PMBUS_READ_TEMPERATURE_2] = 45,
+	[PMBUS_READ_TEMPERATURE_3] = 46,
+	[PMBUS_READ_FAN_SPEED_1] = 99,
+	[PMBUS_READ_FAN_SPEED_2] = 98,
+	[PMBUS_READ_FAN_SPEED_3] = 97,
+	[PMBUS_READ_FAN_SPEED_4] = 96,
+	[PMBUS_READ_DUTY_CYCLE] = 77,
+	[PMBUS_READ_FREQUENCY] = 1234,
+	[PMBUS_READ_POUT] = 377,
+	[PMBUS_READ_PIN] = 194,
+};
+
+/*
+ * Values calculated from max16064 manual
+ */
+#define V3UF_MAXIM	0x1200
+#define V3UW_MAXIM	0x1500
+#define V3_MAXIM	0x176e
+#define V3OW_MAXIM	0x1a00
+#define V3OF_MAXIM	0x2000
+
+#define I10_MAXIM	0x0906
+#define I20_MAXIM	0x120d
+#define I25_MAXIM	0x1691
+
+#define T0_MAXIM	0
+#define T20_MAXIM	0xff68
+#define T40_MAXIM	0xfecf
+#define T80_MAXIM	0xfd9f
+#define T90_MAXIM	0xfd58
+
+static u16 pmbus_maxim_data[256] = {
+	[PMBUS_VOUT_OV_FAULT_LIMIT] = V3OF_MAXIM,
+	[PMBUS_VOUT_OV_WARN_LIMIT] = V3OW_MAXIM,
+	[PMBUS_VOUT_UV_WARN_LIMIT] = V3UW_MAXIM,
+	[PMBUS_VOUT_UV_FAULT_LIMIT] = V3UF_MAXIM,
+
+	[PMBUS_IOUT_OC_FAULT_LIMIT] = I25_MAXIM,
+	[PMBUS_IOUT_OC_WARN_LIMIT] = I20_MAXIM,
+
+	[PMBUS_OT_FAULT_LIMIT] = T90_MAXIM,
+	[PMBUS_OT_WARN_LIMIT] = T80_MAXIM,
+	[PMBUS_UT_WARN_LIMIT] = T20_MAXIM,
+	[PMBUS_UT_FAULT_LIMIT] = T0_MAXIM,
+
+	[PMBUS_READ_VOUT] = V3_MAXIM,
+	[PMBUS_READ_IOUT] = I10_MAXIM,
+	[PMBUS_READ_TEMPERATURE_1] = T40_MAXIM,
+};
+
+struct pmbus_chip {
+	char name[16];
+	u8 addr;
+	bool linear;
+	u8 pages;		/* Number of pages (for PAGE register) */
+	u8 pointer;
+	s8 regsize[256];
+	u16 *initdata;
+	u8 data[256][I2C_SMBUS_BLOCK_MAX];
+};
+
+static struct pmbus_chip pmbus_chips[NUM_CHIPS] = {
+	[bmr453] = {
+		.name = "bmr453",
+		.addr = 0x10,
+		.linear = 1,
+		.regsize[PMBUS_PAGE] = -1,
+		.regsize[PMBUS_PHASE] = -1,
+		.regsize[PMBUS_CAPABILITY] = -1,
+		.regsize[PMBUS_QUERY] = -1,
+		.regsize[PMBUS_VOUT_MODE] = -1,
+		.regsize[PMBUS_COEFFICIENTS] = -1,
+		.regsize[PMBUS_POUT_MAX] = -1,
+		.regsize[PMBUS_READ_IIN] = -1,
+		.regsize[PMBUS_READ_VCAP] = -1,
+		.regsize[PMBUS_READ_TEMPERATURE_3] = -1,
+		.regsize[PMBUS_READ_FAN_SPEED_1] = -1,
+		.regsize[PMBUS_READ_FAN_SPEED_2] = -1,
+		.regsize[PMBUS_READ_FAN_SPEED_3] = -1,
+		.regsize[PMBUS_READ_FAN_SPEED_4] = -1,
+		.regsize[PMBUS_READ_POUT] = -1,
+		.regsize[PMBUS_READ_PIN] = -1,
+		.regsize[PMBUS_MFR_ID] = 11,
+		.regsize[PMBUS_MFR_MODEL] = 13,
+		.initdata = pmbus_linear_data,
+		.data[PMBUS_MFR_ID] = "Ericsson AB",
+		.data[PMBUS_MFR_MODEL] = "BMR453xxxx001",
+		},
+	[ltc2978] = {
+		.name = "ltc2978",
+		.addr = 0x20,
+		.linear = 1,
+		.pages = 8,
+		.regsize[PMBUS_PHASE] = -1,
+		.regsize[PMBUS_CAPABILITY] = -1,
+		.regsize[PMBUS_QUERY] = -1,
+		.regsize[PMBUS_COEFFICIENTS] = -1,
+		.regsize[PMBUS_POUT_MAX] = -1,
+		.regsize[PMBUS_STATUS_IOUT] = -1,
+		.regsize[PMBUS_STATUS_OTHER] = -1,
+		.regsize[PMBUS_READ_IIN] = -1,
+		.regsize[PMBUS_READ_IOUT] = -1,
+		.regsize[PMBUS_READ_VCAP] = -1,
+		.regsize[PMBUS_READ_TEMPERATURE_2] = -1,
+		.regsize[PMBUS_READ_TEMPERATURE_3] = -1,
+		.regsize[PMBUS_READ_FAN_SPEED_1] = -1,
+		.regsize[PMBUS_READ_FAN_SPEED_2] = -1,
+		.regsize[PMBUS_READ_FAN_SPEED_3] = -1,
+		.regsize[PMBUS_READ_FAN_SPEED_4] = -1,
+		.regsize[PMBUS_READ_POUT] = -1,
+		.regsize[PMBUS_READ_PIN] = -1,
+		.regsize[PMBUS_MFR_ID] = -1,
+		.regsize[LTC2978_MFR_SPECIAL_ID] = 2,
+		.initdata = pmbus_linear_data,
+		.data[LTC2978_MFR_SPECIAL_ID] = { 0x01, 0x21 },
+		},
+	[max16064] = {
+		.name = "max16064",
+		.addr = 0x30,
+		.pages = 4,
+		.regsize[PMBUS_PHASE] = -1,
+		.regsize[PMBUS_QUERY] = -1,
+		.regsize[PMBUS_VOUT_MODE] = -1,
+		.regsize[PMBUS_COEFFICIENTS] = -1,
+		.regsize[PMBUS_POUT_MAX] = -1,
+		.regsize[PMBUS_STATUS_IOUT] = -1,
+		.regsize[PMBUS_STATUS_INPUT] = -1,
+		.regsize[PMBUS_STATUS_OTHER] = -1,
+		.regsize[PMBUS_READ_VIN] = -1,
+		.regsize[PMBUS_READ_IIN] = -1,
+		.regsize[PMBUS_READ_IOUT] = -1,
+		.regsize[PMBUS_READ_VCAP] = -1,
+		.regsize[PMBUS_READ_TEMPERATURE_2] = -1,
+		.regsize[PMBUS_READ_TEMPERATURE_3] = -1,
+		.regsize[PMBUS_READ_FAN_SPEED_1] = -1,
+		.regsize[PMBUS_READ_FAN_SPEED_2] = -1,
+		.regsize[PMBUS_READ_FAN_SPEED_3] = -1,
+		.regsize[PMBUS_READ_FAN_SPEED_4] = -1,
+		.regsize[PMBUS_READ_POUT] = -1,
+		.regsize[PMBUS_READ_PIN] = -1,
+		.regsize[PMBUS_MFR_ID] = 1,
+		.regsize[PMBUS_MFR_MODEL] = 1,
+		.initdata = pmbus_maxim_data,
+		.data[PMBUS_MFR_ID] = { 0x4d },
+		.data[PMBUS_MFR_MODEL] = { 0x43 },
+		},
+	[max8688] = {
+		.name = "max8688",
+		.addr = 0x40,
+		.regsize[PMBUS_PAGE] = -1,
+		.regsize[PMBUS_PHASE] = -1,
+		.regsize[PMBUS_QUERY] = -1,
+		.regsize[PMBUS_CAPABILITY] = -1,
+		.regsize[PMBUS_VOUT_MODE] = -1,
+		.regsize[PMBUS_COEFFICIENTS] = -1,
+		.regsize[PMBUS_POUT_MAX] = -1,
+		.regsize[PMBUS_STATUS_IOUT] = -1,
+		.regsize[PMBUS_STATUS_VOUT] = -1,
+		.regsize[PMBUS_STATUS_TEMPERATURE] = -1,
+		.regsize[PMBUS_STATUS_CML] = -1,
+		.regsize[PMBUS_STATUS_INPUT] = -1,
+		.regsize[PMBUS_STATUS_OTHER] = -1,
+		.regsize[PMBUS_READ_VIN] = -1,
+		.regsize[PMBUS_READ_IIN] = -1,
+		.regsize[PMBUS_READ_VCAP] = -1,
+		.regsize[PMBUS_READ_TEMPERATURE_2] = -1,
+		.regsize[PMBUS_READ_TEMPERATURE_3] = -1,
+		.regsize[PMBUS_READ_FAN_SPEED_1] = -1,
+		.regsize[PMBUS_READ_FAN_SPEED_2] = -1,
+		.regsize[PMBUS_READ_FAN_SPEED_3] = -1,
+		.regsize[PMBUS_READ_FAN_SPEED_4] = -1,
+		.regsize[PMBUS_READ_POUT] = -1,
+		.regsize[PMBUS_READ_PIN] = -1,
+		.regsize[PMBUS_MFR_ID] = 2,
+		.regsize[PMBUS_MFR_MODEL] = 2,
+		.initdata = pmbus_maxim_data,
+		.data[PMBUS_MFR_ID] = { 0x4d, 0x01 },
+		.data[PMBUS_MFR_MODEL] = { 0x41, 0x01 },
+		},
+	[ucd9240] = {
+		.name = "ucd9240",
+		.addr = 0x50,
+		.linear = 1,
+		.pages = 4,
+		.regsize[PMBUS_QUERY] = -1,
+		.regsize[PMBUS_COEFFICIENTS] = -1,
+		.regsize[PMBUS_POUT_MAX] = -1,
+		.regsize[PMBUS_UT_WARN_LIMIT] = -1,
+		.regsize[PMBUS_UT_FAULT_LIMIT] = -1,
+		.regsize[PMBUS_UT_FAULT_RESPONSE] = -1,
+		.regsize[PMBUS_IIN_OC_FAULT_LIMIT] = -1,
+		.regsize[PMBUS_IIN_OC_WARN_LIMIT] = -1,
+		.regsize[PMBUS_READ_VCAP] = -1,
+		.regsize[PMBUS_READ_TEMPERATURE_3] = -1,
+		.regsize[PMBUS_READ_FAN_SPEED_2] = -1,
+		.regsize[PMBUS_READ_FAN_SPEED_3] = -1,
+		.regsize[PMBUS_READ_FAN_SPEED_4] = -1,
+		.initdata = pmbus_linear_data,
+		},
+};
+
+static void pmbus_set_error(struct pmbus_chip *chip, u8 sreg, u16 s1, u8 s2)
+{
+	if (pmbus_regsize[PMBUS_STATUS_BYTE] > 0
+	    && (!chip->regsize[PMBUS_STATUS_BYTE]
+		|| chip->regsize[PMBUS_STATUS_BYTE] > 0))
+		chip->data[PMBUS_STATUS_BYTE][0] |= s1 & 0xff;
+	if (pmbus_regsize[PMBUS_STATUS_WORD] > 0
+	    && (!chip->regsize[PMBUS_STATUS_WORD]
+		|| chip->regsize[PMBUS_STATUS_WORD] > 0)) {
+		chip->data[PMBUS_STATUS_WORD][0] |= s1 & 0xff;
+		chip->data[PMBUS_STATUS_WORD][1] |= (s1 >> 8) & 0xff;
+	}
+	if (pmbus_regsize[sreg] > 0
+	    && (!chip->regsize[sreg] || chip->regsize[sreg] > 0))
+		chip->data[sreg][0] |= s2;
+}
+
+/* Return negative errno on error. */
+static s32 pmbus_xfer(struct i2c_adapter *adap, u16 addr, unsigned short flags,
+		      char read_write, u8 command, int size,
+		      union i2c_smbus_data *data)
+{
+	s32 ret;
+	int i, len, regsize;
+	struct pmbus_chip *chip = NULL;
+
+	/* Search for the right chip */
+	for (i = 0; i < NUM_CHIPS && pmbus_chips[i].addr; i++) {
+		if (addr == pmbus_chips[i].addr) {
+			chip = pmbus_chips + i;
+			break;
+		}
+	}
+	if (!chip) {
+		dev_dbg(&adap->dev, "No chip at address 0x%02x\n", addr);
+		return -ENODEV;
+	}
+
+	if (size != I2C_SMBUS_QUICK && (pmbus_regsize[command] == -1
+					|| chip->regsize[command] == -1)) {
+		dev_dbg(&adap->dev, "Unsupported command 0x%02x\n", command);
+		return -EINVAL;
+	}
+
+	if (size != I2C_SMBUS_QUICK && read_write == I2C_SMBUS_WRITE
+	    && !pmbus_rw[command]) {
+		dev_dbg(&adap->dev, "Command 0x%02x is r/o ", command);
+		return -EACCES;
+	}
+
+	switch (size) {
+
+	case I2C_SMBUS_QUICK:
+		dev_dbg(&adap->dev, "smbus quick - addr 0x%02x\n", addr);
+		ret = 0;
+		break;
+
+	case I2C_SMBUS_BYTE:
+		if (read_write == I2C_SMBUS_WRITE) {
+			if (command == PMBUS_CLEAR_FAULTS) {
+				chip->data[PMBUS_STATUS_BYTE][0] = 0;
+				chip->data[PMBUS_STATUS_WORD][0] = 0;
+				chip->data[PMBUS_STATUS_WORD][1] = 0;
+				chip->data[PMBUS_STATUS_CML][0] = 0;
+				chip->data[PMBUS_STATUS_VOUT][0] = 0;
+				chip->data[PMBUS_STATUS_INPUT][0] = 0;
+				chip->data[PMBUS_STATUS_TEMPERATURE][0] = 0;
+				chip->data[PMBUS_STATUS_OTHER][0] = 0;
+			}
+			chip->pointer = command;
+			dev_dbg(&adap->dev, "smbus byte - addr 0x%02x, "
+				"wrote 0x%02x.\n", addr, command);
+		} else {
+			data->byte = chip->data[chip->pointer][0];
+			dev_dbg(&adap->dev, "smbus byte - addr 0x%02x, "
+				"read  0x%02x.\n", addr, data->byte);
+		}
+
+		ret = 0;
+		break;
+
+	case I2C_SMBUS_BYTE_DATA:
+		if (pmbus_regsize[command] < 1) {
+			pmbus_set_error(chip, PMBUS_STATUS_CML, PB_STATUS_CML,
+					PB_CML_FAULT_OTHER_COMM);
+			ret = -EINVAL;
+			break;
+		}
+		if (read_write == I2C_SMBUS_WRITE) {
+			if (command == PMBUS_PAGE
+			    && data->byte > chip->pages) {
+				pmbus_set_error(chip, PMBUS_STATUS_CML,
+						PB_STATUS_CML,
+						PB_CML_FAULT_OTHER_COMM);
+				ret = -EINVAL;
+				break;
+			}
+			chip->data[command][0] = data->byte;
+			chip->data[command][1] = 0;
+			dev_dbg(&adap->dev, "smbus byte data - addr 0x%02x, "
+				"wrote 0x%02x at 0x%02x.\n",
+				addr, data->byte, command);
+		} else {
+			data->byte = chip->data[command][0];
+			dev_dbg(&adap->dev, "smbus byte data - addr 0x%02x, "
+				"read  0x%02x at 0x%02x.\n",
+				addr, data->byte, command);
+		}
+
+		ret = 0;
+		break;
+
+	case I2C_SMBUS_WORD_DATA:
+		if (pmbus_regsize[command] < 2) {
+			pmbus_set_error(chip, PMBUS_STATUS_CML, PB_STATUS_CML,
+					PB_CML_FAULT_OTHER_COMM);
+			ret = -EINVAL;
+			break;
+		}
+		if (read_write == I2C_SMBUS_WRITE) {
+			chip->data[command][0] = data->word & 0xff;
+			chip->data[command][1] = (data->word >> 8) & 0xff;
+			dev_dbg(&adap->dev, "smbus word data - addr 0x%02x, "
+				"wrote 0x%04x at 0x%02x.\n",
+				addr, data->word, command);
+		} else {
+			data->word = (chip->data[command][0]
+				      | (chip->data[command][1] << 8));
+			dev_dbg(&adap->dev, "smbus word data - addr 0x%02x, "
+				"read  0x%04x at 0x%02x.\n",
+				addr, data->word, command);
+		}
+
+		ret = 0;
+		break;
+
+	case I2C_SMBUS_BLOCK_DATA:
+		len = data->block[0];
+		regsize = pmbus_regsize[command];
+		if (chip->regsize[command])
+			regsize = chip->regsize[command];
+		if (len <= 0 || len > regsize) {
+			pmbus_set_error(chip, PMBUS_STATUS_CML, PB_STATUS_CML,
+					PB_CML_FAULT_OTHER_COMM);
+			ret = -EINVAL;
+			break;
+		}
+		if (read_write == I2C_SMBUS_WRITE) {
+			for (i = 1; i <= len; i++)
+				chip->data[command][i-1] = data->block[i];
+		} else {
+			data->block[0] = regsize;
+			for (i = 0; i < regsize; i++)
+				data->block[i+1] = chip->data[command][i];
+		}
+
+		ret = 0;
+		break;
+
+	default:
+		dev_dbg(&adap->dev, "Unsupported I2C/SMBus command\n");
+		ret = -EOPNOTSUPP;
+		break;
+	}			/* switch (size) */
+
+	return ret;
+}
+
+static u32 pmbus_func(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE |
+	  I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA |
+	  I2C_SMBUS_BLOCK_DATA;
+}
+
+static const struct i2c_algorithm smbus_algorithm = {
+	.functionality = pmbus_func,
+	.smbus_xfer = pmbus_xfer,
+};
+
+static struct i2c_adapter pmbus_adapter = {
+	.owner = THIS_MODULE,
+	.class = I2C_CLASS_HWMON | I2C_CLASS_SPD,
+	.algo = &smbus_algorithm,
+	.nr = 2,
+	.name = "SMBus pmbus driver",
+};
+
+struct boundaries {
+	u8 reg;
+	u8 warn_low;
+	u8 warn_high;
+	u8 fault_low;
+	u8 fault_high;
+	u8 status_reg;
+	u8 warn_status_low;
+	u8 warn_status_high;
+	u8 fault_status_low;
+	u8 fault_status_high;
+	u8 g_status_bit_low;
+	u8 g_status_bit_high;
+	int min, max;
+};
+
+static struct boundaries boundaries[] = {
+	{
+	    .reg = PMBUS_READ_VIN,
+	    .warn_low = PMBUS_VIN_UV_WARN_LIMIT,
+	    .warn_high = PMBUS_VIN_OV_WARN_LIMIT,
+	    .fault_low = PMBUS_VIN_UV_FAULT_LIMIT,
+	    .fault_high = PMBUS_VIN_OV_FAULT_LIMIT,
+	    .status_reg = PMBUS_STATUS_INPUT,
+	    .warn_status_low = PB_VOLTAGE_UV_WARNING,
+	    .warn_status_high = PB_VOLTAGE_OV_WARNING,
+	    .fault_status_low = PB_VOLTAGE_UV_FAULT,
+	    .fault_status_high = PB_VOLTAGE_OV_FAULT,
+	    .g_status_bit_low = PB_STATUS_VIN_UV,
+	    .min = 0,
+	    .max = 50000,
+	},
+	{
+	    .reg = PMBUS_READ_VOUT,
+	    .warn_low = PMBUS_VOUT_UV_WARN_LIMIT,
+	    .warn_high = PMBUS_VOUT_OV_WARN_LIMIT,
+	    .fault_low = PMBUS_VOUT_UV_FAULT_LIMIT,
+	    .fault_high = PMBUS_VOUT_OV_FAULT_LIMIT,
+	    .status_reg = PMBUS_STATUS_VOUT,
+	    .warn_status_low = PB_VOLTAGE_UV_WARNING,
+	    .warn_status_high = PB_VOLTAGE_OV_WARNING,
+	    .fault_status_low = PB_VOLTAGE_UV_FAULT,
+	    .fault_status_high = PB_VOLTAGE_OV_FAULT,
+	    .g_status_bit_high = PB_STATUS_VOUT_OV,
+	    .min = 0,
+	    .max = 50000,
+	},
+	{
+	    .reg = PMBUS_READ_PIN,
+	    .warn_high = PMBUS_PIN_OP_WARN_LIMIT,
+	    .status_reg = PMBUS_STATUS_INPUT,
+	    .warn_status_high = PB_PIN_OP_WARNING,
+	    .min = 0,
+	    .max = 1000000,
+	},
+	{
+	    .reg = PMBUS_READ_POUT,
+	    .warn_high = PMBUS_POUT_OP_WARN_LIMIT,
+	    .fault_high = PMBUS_POUT_OP_FAULT_LIMIT,
+	    .status_reg = PMBUS_STATUS_IOUT,
+	    .warn_status_high = PB_POUT_OP_WARNING,
+	    .fault_status_high = PB_POUT_OP_FAULT,
+	    .min = 0,
+	    .max = 1000000,
+	},
+	{
+	    .reg = PMBUS_READ_IIN,
+	    .warn_high = PMBUS_IIN_OC_WARN_LIMIT,
+	    .fault_high = PMBUS_IIN_OC_FAULT_LIMIT,
+	    .status_reg = PMBUS_STATUS_INPUT,
+	    .warn_status_high = PB_IIN_OC_WARNING,
+	    .fault_status_high = PB_IIN_OC_FAULT,
+	    .min = 0,
+	    .max = 10000,
+	},
+	{
+	    .reg = PMBUS_READ_IOUT,
+	    .warn_high = PMBUS_IOUT_OC_WARN_LIMIT,
+	    .fault_low = PMBUS_IOUT_UC_FAULT_LIMIT,
+	    .fault_high = PMBUS_IOUT_OC_FAULT_LIMIT,
+	    .status_reg = PMBUS_STATUS_IOUT,
+	    .warn_status_high = PB_IOUT_OC_WARNING,
+	    .fault_status_low = PB_IOUT_UC_FAULT,
+	    .fault_status_high = PB_IOUT_OC_FAULT,
+	    .g_status_bit_high = PB_STATUS_IOUT_OC,
+	    .min = 0,
+	    .max = 10000,
+	},
+	{
+	    .reg = PMBUS_READ_TEMPERATURE_1,
+	    .warn_low = PMBUS_UT_WARN_LIMIT,
+	    .warn_high = PMBUS_OT_WARN_LIMIT,
+	    .fault_low = PMBUS_UT_FAULT_LIMIT,
+	    .fault_high = PMBUS_OT_FAULT_LIMIT,
+	    .status_reg = PMBUS_STATUS_TEMPERATURE,
+	    .warn_status_low = PB_TEMP_UT_WARNING,
+	    .warn_status_high = PB_TEMP_OT_WARNING,
+	    .fault_status_low = PB_TEMP_UT_FAULT,
+	    .fault_status_high = PB_TEMP_OT_FAULT,
+	    .g_status_bit_low = PB_STATUS_TEMPERATURE,
+	    .g_status_bit_high = PB_STATUS_TEMPERATURE,
+	    .min = 0,
+	    .max = 100,
+	},
+	{
+	    .reg = PMBUS_READ_TEMPERATURE_2,
+	    .warn_low = PMBUS_UT_WARN_LIMIT,
+	    .warn_high = PMBUS_OT_WARN_LIMIT,
+	    .fault_low = PMBUS_UT_FAULT_LIMIT,
+	    .fault_high = PMBUS_OT_FAULT_LIMIT,
+	    .status_reg = PMBUS_STATUS_TEMPERATURE,
+	    .warn_status_low = PB_TEMP_UT_WARNING,
+	    .warn_status_high = PB_TEMP_OT_WARNING,
+	    .fault_status_low = PB_TEMP_UT_FAULT,
+	    .fault_status_high = PB_TEMP_OT_FAULT,
+	    .g_status_bit_low = PB_STATUS_TEMPERATURE,
+	    .g_status_bit_high = PB_STATUS_TEMPERATURE,
+	    .min = 0,
+	    .max = 100,
+	},
+	{
+	    .reg = PMBUS_READ_TEMPERATURE_3,
+	    .warn_low = PMBUS_UT_WARN_LIMIT,
+	    .warn_high = PMBUS_OT_WARN_LIMIT,
+	    .fault_low = PMBUS_UT_FAULT_LIMIT,
+	    .fault_high = PMBUS_OT_FAULT_LIMIT,
+	    .status_reg = PMBUS_STATUS_TEMPERATURE,
+	    .warn_status_low = PB_TEMP_UT_WARNING,
+	    .warn_status_high = PB_TEMP_OT_WARNING,
+	    .fault_status_low = PB_TEMP_UT_FAULT,
+	    .fault_status_high = PB_TEMP_OT_FAULT,
+	    .g_status_bit_low = PB_STATUS_TEMPERATURE,
+	    .g_status_bit_high = PB_STATUS_TEMPERATURE,
+	    .min = 0,
+	    .max = 100,
+	},
+};
+
+static int lintoval(u16 adc)
+{
+	s16 exponent, mantissa;
+	int val;
+
+	exponent = adc >> 11;
+	mantissa = adc & 0x07ff;
+
+	if (exponent > 0x0f)
+		exponent |= 0xffe0;	/* sign extend exponent */
+	if (mantissa > 0x03ff)
+		mantissa |= 0xf800;	/* sign extend mantissa */
+
+	/* scale result to milli-units */
+	val = mantissa * 1000;
+
+	if (exponent > 0)
+		val <<= exponent;
+	else if (exponent < 0)
+		val >>= -exponent;
+
+	return val;
+}
+
+static u16 valtolin(int val)
+{
+	s16 exponent = 0, mantissa = 0;
+
+	if (val < 0) {
+		while (val < -1024 * 512) {
+			exponent++;
+			val /= 2;
+		}
+		while (val > -1024 * 256) {
+			exponent--;
+			val *= 2;
+		}
+	} else if (val > 0) {
+		while (val > 1024 * 512) {
+			exponent++;
+			val /= 2;
+		}
+		while (val < 1024 * 256) {
+			exponent--;
+			val *= 2;
+		}
+	}
+	mantissa = (val + 500) / 1000;
+
+	return (mantissa & 0x7ff) | ((exponent << 11) & 0xf800);
+}
+
+static void i2c_pmbus_update_chip(struct pmbus_chip *chip)
+{
+	int i, reg;
+
+	for (reg = PMBUS_READ_VIN; reg <= PMBUS_READ_PIN; reg++) {
+		u16 regval;
+		s8 offset;
+		int val, lf = 0, lw = 0, uf = 0, uw = 0, factor;
+		struct boundaries *b;
+
+		if (pmbus_regsize[reg] == -1 || chip->regsize[reg] == -1)
+			continue;
+		for (i = 0; i < ARRAY_SIZE(boundaries); i++) {
+			if (boundaries[i].reg == reg)
+				break;
+		}
+		if (i >= ARRAY_SIZE(boundaries))
+			continue;
+		b = &boundaries[i];
+
+		/* Randomly increase or decrease value up to
+		 * critical limit. If a limit is exceeded, set
+		 * warning/fault flag as appropriate
+		 */
+		regval = (chip->data[reg][0] | (chip->data[reg][1] << 8));
+		val = lintoval(regval);
+		get_random_bytes(&offset, 1);
+		/* Change value up to approximately 1% */
+		factor = val >> 14;
+		if (factor < 0)
+			factor = -factor;
+		if (factor == 0)
+			factor = 1;
+		val += offset * factor;
+		if (b->fault_low) {
+			lf = lintoval(chip->data[b->fault_low][0]
+				      | (chip->data[b->fault_low][1] << 8));
+			if (val < lf)
+				val = lf - 1;
+		}
+		if (b->warn_low) {
+			lw = lintoval(chip->data[b->warn_low][0]
+				      | (chip->data[b->warn_low][1] << 8));
+			if (!b->fault_low && val < lw)
+				val = lw - 1;
+		}
+		if (!b->fault_low && !b->warn_low && val < b->min)
+			val = b->min;
+		if (b->fault_high) {
+			uf = lintoval(chip->data[b->fault_high][0]
+				      | (chip->data[b->fault_low][1] << 8));
+			if (val > uf)
+				val = uf + 1;
+		}
+		if (b->warn_high) {
+			uw = lintoval(chip->data[b->warn_high][0]
+				      | (chip->data[b->warn_high][1] << 8));
+			if (!b->fault_high && val > uw)
+				val = uw + 1;
+		}
+		if (!b->fault_high && !b->warn_high && val > b->max)
+			val = b->max;
+		if (b->status_reg && b->fault_status_low && b->fault_low) {
+			if (val < lf) {
+				chip->data[b->status_reg][0]
+				  |= b->fault_status_low;
+				chip->data[PMBUS_STATUS_BYTE][0] |=
+				  b->g_status_bit_low;
+			}
+		}
+		if (b->status_reg && b->fault_status_high && b->fault_high) {
+			if (val > uf) {
+				chip->data[b->status_reg][0] |=
+				  b->fault_status_high;
+				chip->data[PMBUS_STATUS_BYTE][0] |=
+				  b->g_status_bit_high;
+			}
+		}
+		if (b->status_reg && b->warn_status_low && b->warn_low) {
+			if (val < lw) {
+				chip->data[b->status_reg][0] |=
+				  b->warn_status_low;
+				chip->data[PMBUS_STATUS_BYTE][0] |=
+				  b->g_status_bit_low;
+			}
+		}
+		if (b->status_reg && b->warn_status_high && b->warn_high) {
+			if (val > uw) {
+				chip->data[b->status_reg][0] |=
+				  b->warn_status_high;
+				chip->data[PMBUS_STATUS_BYTE][0] |=
+				  b->g_status_bit_high;
+			}
+		}
+		regval = valtolin(val);
+		chip->data[reg][0] = regval & 0xff;
+		chip->data[reg][1] = (regval >> 8) & 0xff;
+	}
+}
+
+static int i2c_pmbus_update_thread(void *p)
+{
+	while (!kthread_should_stop()) {
+		int i;
+
+		for (i = 0; i < NUM_CHIPS; i++) {
+			struct pmbus_chip *chip = &pmbus_chips[i];
+
+			if (chip->addr && chip->linear)
+				i2c_pmbus_update_chip(chip);
+		}
+		if (kthread_should_stop())
+			break;
+		msleep_interruptible(1000);
+	}
+	return 0;
+}
+
+static struct task_struct *i2c_pmbus_kthread;
+
+static int __init i2c_pmbus_init(void)
+{
+	int i, j, ret;
+
+	for (i = 0; i < NUM_CHIPS; i++) {
+		if (pmbus_chips[i].addr) {
+			u16 *initdata = pmbus_chips[i].initdata;
+			if (initdata)
+				for (j = 0; j < 256; j++)
+					if (initdata[j]) {
+						pmbus_chips[i].data[j][0]
+						 = initdata[j] & 0xff;
+						pmbus_chips[i].data[j][1]
+						  = (initdata[j] >> 8) & 0xff;
+					}
+			printk(KERN_INFO "i2c-pmbus: Virtual %s at 0x%02x\n",
+			       pmbus_chips[i].name, pmbus_chips[i].addr);
+		}
+	}
+
+	i2c_pmbus_kthread = kthread_run(i2c_pmbus_update_thread, NULL,
+					"pmbus_update");
+
+	ret = i2c_add_numbered_adapter(&pmbus_adapter);
+	return ret;
+}
+
+static void __exit i2c_pmbus_exit(void)
+{
+	if (i2c_pmbus_kthread)
+		kthread_stop(i2c_pmbus_kthread);
+	i2c_del_adapter(&pmbus_adapter);
+}
+
+MODULE_AUTHOR("Guenter Roeck <guenter.roeck@ericsson.com>");
+MODULE_DESCRIPTION("I2C PMBus chip emulator");
+MODULE_LICENSE("GPL");
+
+module_init(i2c_pmbus_init);
+module_exit(i2c_pmbus_exit);
-- 
1.7.0.87.g0901d

