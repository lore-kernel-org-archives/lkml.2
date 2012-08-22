Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab2HVGb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 02:31:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50416 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028Ab2HVGbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 02:31:24 -0400
From: AnilKumar Ch <anilkumar@ti.com>
To: <arnd@arndb.de>
CC: <gregkh@linuxfoundation.org>, <eric.piel@tremplin-utc.net>,
        <jic23@cam.ac.uk>, <greg@kroah.com>, <akpm@linux-foundation.org>,
        <broonie@opensource.wolfsonmicro.com>, <dmitry.torokhov@gmail.com>,
        <linux-kernel@vger.kernel.org>, AnilKumar Ch <anilkumar@ti.com>
Subject: [PATCH v2] lis3lv02d: Add STMicroelectronics lis331dlh digital accelerometer
Date: Wed, 22 Aug 2012 12:00:39 +0530
Message-ID: <1345617039-27469-1-git-send-email-anilkumar@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for lis331dlh digital accelerometer to the
lis3lv02d driver family. Adds ID field for detecting the lis331dlh
module, based on this ID field lis3lv02d driver will export the
lis331dlh module functionality.

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
---
Changes from v1:
	- Removed G range sysfs entry from v1
	- Modified documentation to specify lis331dlh is supported

 Documentation/misc-devices/lis3lv02d   |    3 ++-
 drivers/misc/lis3lv02d/lis3lv02d.c     |   42 +++++++++++++++++++++++++++++-
 drivers/misc/lis3lv02d/lis3lv02d.h     |   44 +++++++++++++++++++++++++++-----
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c |    7 ++++-
 4 files changed, 87 insertions(+), 9 deletions(-)

diff --git a/Documentation/misc-devices/lis3lv02d b/Documentation/misc-devices/lis3lv02d
index f1a4ec8..af815b9 100644
--- a/Documentation/misc-devices/lis3lv02d
+++ b/Documentation/misc-devices/lis3lv02d
@@ -4,7 +4,8 @@ Kernel driver lis3lv02d
 Supported chips:
 
   * STMicroelectronics LIS3LV02DL, LIS3LV02DQ (12 bits precision)
-  * STMicroelectronics LIS302DL, LIS3L02DQ, LIS331DL (8 bits)
+  * STMicroelectronics LIS302DL, LIS3L02DQ, LIS331DL (8 bits) and
+    LIS331DLH (16 bits)
 
 Authors:
         Yan Burman <burman.yan@gmail.com>
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index 29d12a7..c0a9199 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -80,6 +80,14 @@
 #define LIS3_SENSITIVITY_12B		((LIS3_ACCURACY * 1000) / 1024)
 #define LIS3_SENSITIVITY_8B		(18 * LIS3_ACCURACY)
 
+/*
+ * LIS3331DLH spec says 1LSBs corresponds 4G/1024 -> 1LSB is 1000/1024 mG.
+ * Sensitivity values for +/-2G, outdata in 12 bits for +/-2G scale. so 4
+ * bits adjustment is required
+ */
+#define LIS3DLH_SENSITIVITY_2G		((LIS3_ACCURACY * 1000) / 1024)
+#define SHIFT_ADJ_2G			4
+
 #define LIS3_DEFAULT_FUZZ_12B		3
 #define LIS3_DEFAULT_FLAT_12B		3
 #define LIS3_DEFAULT_FUZZ_8B		1
@@ -133,6 +141,19 @@ static s16 lis3lv02d_read_12(struct lis3lv02d *lis3, int reg)
 	return (s16)((hi << 8) | lo);
 }
 
+/* 12bits for 2G range, 13 bits for 4G range and 14 bits for 8G range */
+static s16 lis3lv02d_read_16(struct lis3lv02d *lis3, int reg)
+{
+	u8 lo, hi;
+	int v;
+
+	lis3->read(lis3, reg - 1, &lo);
+	lis3->read(lis3, reg, &hi);
+	v = (int) ((hi << 8) | lo);
+
+	return (s16) v >> lis3->shift_adj;
+}
+
 /**
  * lis3lv02d_get_axis - For the given axis, give the value converted
  * @axis:      1,2,3 - can also be negative
@@ -193,6 +214,7 @@ static void lis3lv02d_get_xyz(struct lis3lv02d *lis3, int *x, int *y, int *z)
 static int lis3_12_rates[4] = {40, 160, 640, 2560};
 static int lis3_8_rates[2] = {100, 400};
 static int lis3_3dc_rates[16] = {0, 1, 10, 25, 50, 100, 200, 400, 1600, 5000};
+static int lis3_3dlh_rates[4] = {50, 100, 400, 1000};
 
 /* ODR is Output Data Rate */
 static int lis3lv02d_get_odr(struct lis3lv02d *lis3)
@@ -265,7 +287,7 @@ static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
 				(LIS3_IRQ1_DATA_READY | LIS3_IRQ2_DATA_READY));
 	}
 
-	if (lis3->whoami == WAI_3DC) {
+	if ((lis3->whoami == WAI_3DC) || (lis3->whoami == WAI_3DLH)) {
 		ctlreg = CTRL_REG4;
 		selftest = CTRL4_ST0;
 	} else {
@@ -396,9 +418,17 @@ int lis3lv02d_poweron(struct lis3lv02d *lis3)
 		lis3->read(lis3, CTRL_REG2, &reg);
 		if (lis3->whoami ==  WAI_12B)
 			reg |= CTRL2_BDU | CTRL2_BOOT;
+		else if (lis3->whoami ==  WAI_3DLH)
+			reg |= CTRL2_BOOT_3DLH;
 		else
 			reg |= CTRL2_BOOT_8B;
 		lis3->write(lis3, CTRL_REG2, reg);
+
+		if (lis3->whoami ==  WAI_3DLH) {
+			lis3->read(lis3, CTRL_REG4, &reg);
+			reg |= CTRL4_BDU;
+			lis3->write(lis3, CTRL_REG4, reg);
+		}
 	}
 
 	err = lis3lv02d_get_pwron_wait(lis3);
@@ -954,6 +984,16 @@ int lis3lv02d_init_device(struct lis3lv02d *lis3)
 		lis3->odr_mask = CTRL1_ODR0|CTRL1_ODR1|CTRL1_ODR2|CTRL1_ODR3;
 		lis3->scale = LIS3_SENSITIVITY_8B;
 		break;
+	case WAI_3DLH:
+		pr_info("16 bits 3DLH sensor found\n");
+		lis3->read_data = lis3lv02d_read_16;
+		lis3->mdps_max_val = 2048; /* 12 bits for 2G */
+		lis3->shift_adj = SHIFT_ADJ_2G;
+		lis3->pwron_delay = LIS3_PWRON_DELAY_WAI_8B;
+		lis3->odrs = lis3_3dlh_rates;
+		lis3->odr_mask = CTRL1_DR0 | CTRL1_DR1;
+		lis3->scale = LIS3DLH_SENSITIVITY_2G;
+		break;
 	default:
 		pr_err("unknown sensor type 0x%X\n", lis3->whoami);
 		return -EINVAL;
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.h b/drivers/misc/lis3lv02d/lis3lv02d.h
index 2b1482a..c1a545e 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.h
+++ b/drivers/misc/lis3lv02d/lis3lv02d.h
@@ -26,12 +26,12 @@
 /*
  * This driver tries to support the "digital" accelerometer chips from
  * STMicroelectronics such as LIS3LV02DL, LIS302DL, LIS3L02DQ, LIS331DL,
- * LIS35DE, or LIS202DL. They are very similar in terms of programming, with
- * almost the same registers. In addition to differing on physical properties,
- * they differ on the number of axes (2/3), precision (8/12 bits), and special
- * features (freefall detection, click...). Unfortunately, not all the
- * differences can be probed via a register.
- * They can be connected either via I²C or SPI.
+ * LIS331DLH, LIS35DE, or LIS202DL. They are very similar in terms of
+ * programming, with almost the same registers. In addition to differing
+ * on physical properties, they differ on the number of axes (2/3),
+ * precision (8/12 bits), and special features (freefall detection,
+ * click...). Unfortunately, not all the differences can be probed via
+ * a register. They can be connected either via I²C or SPI.
  */
 
 #include <linux/lis3lv02d.h>
@@ -96,12 +96,22 @@ enum lis3lv02d_reg {
 };
 
 enum lis3_who_am_i {
+	WAI_3DLH	= 0x32,	/* 16 bits: LIS331DLH */
 	WAI_3DC		= 0x33,	/* 8 bits: LIS3DC, HP3DC */
 	WAI_12B		= 0x3A, /* 12 bits: LIS3LV02D[LQ]... */
 	WAI_8B		= 0x3B, /* 8 bits: LIS[23]02D[LQ]... */
 	WAI_6B		= 0x52, /* 6 bits: LIS331DLF - not supported */
 };
 
+enum lis3_type {
+	LIS3DC,
+	HP3DC,
+	LIS3LV02D,
+	LIS2302D,
+	LIS331DLF,
+	LIS331DLH,
+};
+
 enum lis3lv02d_ctrl1_12b {
 	CTRL1_Xen	= 0x01,
 	CTRL1_Yen	= 0x02,
@@ -129,6 +139,27 @@ enum lis3lv02d_ctrl1_3dc {
 	CTRL1_ODR3	= 0x80,
 };
 
+enum lis331dlh_ctrl1 {
+	CTRL1_DR0	= 0x08,
+	CTRL1_DR1	= 0x10,
+	CTRL1_PM0	= 0x20,
+	CTRL1_PM1	= 0x40,
+	CTRL1_PM2	= 0x80,
+};
+
+enum lis331dlh_ctrl2 {
+	CTRL2_HPEN1	= 0x04,
+	CTRL2_HPEN2	= 0x08,
+	CTRL2_FDS_3DLH	= 0x10,
+	CTRL2_BOOT_3DLH	= 0x80,
+};
+
+enum lis331dlh_ctrl4 {
+	CTRL4_STSIGN	= 0x08,
+	CTRL4_BLE	= 0x40,
+	CTRL4_BDU	= 0x80,
+};
+
 enum lis3lv02d_ctrl2 {
 	CTRL2_DAS	= 0x01,
 	CTRL2_SIM	= 0x02,
@@ -279,6 +310,7 @@ struct lis3lv02d {
 	int                     data_ready_count[2];
 	atomic_t		wake_thread;
 	unsigned char           irq_cfg;
+	unsigned int		shift_adj;
 
 	struct lis3lv02d_platform_data *pdata;	/* for passing board config */
 	struct mutex		mutex;     /* Serialize poll and selftest */
diff --git a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
index c02fea0..98cf9ba 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
@@ -90,7 +90,11 @@ static int lis3_i2c_init(struct lis3lv02d *lis3)
 	if (ret < 0)
 		return ret;
 
-	reg |= CTRL1_PD0 | CTRL1_Xen | CTRL1_Yen | CTRL1_Zen;
+	if (lis3->whoami == WAI_3DLH)
+		reg |= CTRL1_PM0 | CTRL1_Xen | CTRL1_Yen | CTRL1_Zen;
+	else
+		reg |= CTRL1_PD0 | CTRL1_Xen | CTRL1_Yen | CTRL1_Zen;
+
 	return lis3->write(lis3, CTRL_REG1, reg);
 }
 
@@ -232,6 +236,7 @@ static int lis3_i2c_runtime_resume(struct device *dev)
 
 static const struct i2c_device_id lis3lv02d_id[] = {
 	{"lis3lv02d", 0 },
+	{"lis331dlh", LIS331DLH},
 	{}
 };
 
-- 
1.7.9.5

