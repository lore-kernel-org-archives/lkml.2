Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab1IGQNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:13:24 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:48725 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab1IGQLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:11:45 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 4/6] regmap-spi-adi + staging:iio:imu:adis16400 halve register addresses
Date: Wed,  7 Sep 2011 17:19:45 +0100
Message-Id: <1315412387-5765-5-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <4E679770.4090008@cam.ac.uk>
References: <4E679770.4090008@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The register addresses were even numbers only.  That makes for very bad
caching, so lets halve them all.

Nasty trick needed with the write_flag_mask being halved to make this work.
---
 drivers/base/regmap/regmap-spi-adi.c     |    8 ++-
 drivers/staging/iio/imu/adis16400.h      |   88 +++++++++++++++---------------
 drivers/staging/iio/imu/adis16400_core.c |    2 +-
 drivers/staging/iio/imu/adis16400_ring.c |   22 ++++----
 4 files changed, 61 insertions(+), 59 deletions(-)

diff --git a/drivers/base/regmap/regmap-spi-adi.c b/drivers/base/regmap/regmap-spi-adi.c
index a98c000..d4301cc 100644
--- a/drivers/base/regmap/regmap-spi-adi.c
+++ b/drivers/base/regmap/regmap-spi-adi.c
@@ -25,14 +25,13 @@ static int regmap_spi_write(struct device *dev, const void *data, size_t count)
 
 	BUG_ON(count != 3);
 	/* Fiddling needed as the value is bigendian */
-	rawdata[0] += 1;
+	rawdata[0] = (rawdata[0] << 1) + 1;
 	ret = spi_write(spi, data, 2);
 	if (ret < 0)
 		return ret;
 
 	rawdata[1] = rawdata[0] - 1;
-	ret = spi_write(spi, data + 1, 2);
-	return ret;
+	return spi_write(spi, data + 1, 2);
 }
 
 static int regmap_spi_read(struct device *dev,
@@ -40,6 +39,9 @@ static int regmap_spi_read(struct device *dev,
 			   void *val, size_t val_size)
 {
 	struct spi_device *spi = to_spi_device(dev);
+	u8 *regraw = (u8 *)reg;
+
+	regraw[0] <<= 1;
 
 	BUG_ON(reg_size != 1 || val_size != 2);
 
diff --git a/drivers/staging/iio/imu/adis16400.h b/drivers/staging/iio/imu/adis16400.h
index 0bf1fd9..919d6fa 100644
--- a/drivers/staging/iio/imu/adis16400.h
+++ b/drivers/staging/iio/imu/adis16400.h
@@ -23,58 +23,58 @@
 #define ADIS16400_READ_REG(a)    a
 #define ADIS16400_WRITE_REG(a) ((a) | 0x80)
 
-#define ADIS16400_FLASH_CNT  0x00 /* Flash memory write count */
-#define ADIS16400_SUPPLY_OUT 0x02 /* Power supply measurement */
-#define ADIS16400_XGYRO_OUT 0x04 /* X-axis gyroscope output */
-#define ADIS16400_YGYRO_OUT 0x06 /* Y-axis gyroscope output */
-#define ADIS16400_ZGYRO_OUT 0x08 /* Z-axis gyroscope output */
-#define ADIS16400_XACCL_OUT 0x0A /* X-axis accelerometer output */
-#define ADIS16400_YACCL_OUT 0x0C /* Y-axis accelerometer output */
-#define ADIS16400_ZACCL_OUT 0x0E /* Z-axis accelerometer output */
-#define ADIS16400_XMAGN_OUT 0x10 /* X-axis magnetometer measurement */
-#define ADIS16400_YMAGN_OUT 0x12 /* Y-axis magnetometer measurement */
-#define ADIS16400_ZMAGN_OUT 0x14 /* Z-axis magnetometer measurement */
-#define ADIS16400_TEMP_OUT  0x16 /* Temperature output */
-#define ADIS16400_AUX_ADC   0x18 /* Auxiliary ADC measurement */
-
-#define ADIS16350_XTEMP_OUT 0x10 /* X-axis gyroscope temperature measurement */
-#define ADIS16350_YTEMP_OUT 0x12 /* Y-axis gyroscope temperature measurement */
-#define ADIS16350_ZTEMP_OUT 0x14 /* Z-axis gyroscope temperature measurement */
-
-#define ADIS16300_PITCH_OUT 0x12 /* X axis inclinometer output measurement */
-#define ADIS16300_ROLL_OUT  0x12 /* Y axis inclinometer output measurement */
+#define ADIS16400_FLASH_CNT  (0x00 >> 1) /* Flash memory write count */
+#define ADIS16400_SUPPLY_OUT (0x02 >> 1) /* Power supply measurement */
+#define ADIS16400_XGYRO_OUT (0x04 >> 1) /* X-axis gyroscope output */
+#define ADIS16400_YGYRO_OUT (0x06 >> 1) /* Y-axis gyroscope output */
+#define ADIS16400_ZGYRO_OUT (0x08 >> 1) /* Z-axis gyroscope output */
+#define ADIS16400_XACCL_OUT (0x0A >> 1) /* X-axis accelerometer output */
+#define ADIS16400_YACCL_OUT (0x0C >> 1) /* Y-axis accelerometer output */
+#define ADIS16400_ZACCL_OUT (0x0E >> 1) /* Z-axis accelerometer output */
+#define ADIS16400_XMAGN_OUT (0x10 >> 1) /* X-axis magnetometer measurement */
+#define ADIS16400_YMAGN_OUT (0x12 >> 1) /* Y-axis magnetometer measurement */
+#define ADIS16400_ZMAGN_OUT (0x14 >> 1) /* Z-axis magnetometer measurement */
+#define ADIS16400_TEMP_OUT  (0x16 >> 1) /* Temperature output */
+#define ADIS16400_AUX_ADC   (0x18 >> 1) /* Auxiliary ADC measurement */
+
+#define ADIS16350_XTEMP_OUT (0x10 >> 1) /* X-axis gyroscope temperature measurement */
+#define ADIS16350_YTEMP_OUT (0x12 >> 1) /* Y-axis gyroscope temperature measurement */
+#define ADIS16350_ZTEMP_OUT (0x14 >> 1) /* Z-axis gyroscope temperature measurement */
+
+#define ADIS16300_PITCH_OUT (0x12 >> 1) /* X axis inclinometer output measurement */
+#define ADIS16300_ROLL_OUT  (0x12 >> 1) /* Y axis inclinometer output measurement */
 
 /* Calibration parameters */
-#define ADIS16400_XGYRO_OFF 0x1A /* X-axis gyroscope bias offset factor */
-#define ADIS16400_YGYRO_OFF 0x1C /* Y-axis gyroscope bias offset factor */
-#define ADIS16400_ZGYRO_OFF 0x1E /* Z-axis gyroscope bias offset factor */
-#define ADIS16400_XACCL_OFF 0x20 /* X-axis acceleration bias offset factor */
-#define ADIS16400_YACCL_OFF 0x22 /* Y-axis acceleration bias offset factor */
-#define ADIS16400_ZACCL_OFF 0x24 /* Z-axis acceleration bias offset factor */
-#define ADIS16400_XMAGN_HIF 0x26 /* X-axis magnetometer, hard-iron factor */
-#define ADIS16400_YMAGN_HIF 0x28 /* Y-axis magnetometer, hard-iron factor */
-#define ADIS16400_ZMAGN_HIF 0x2A /* Z-axis magnetometer, hard-iron factor */
-#define ADIS16400_XMAGN_SIF 0x2C /* X-axis magnetometer, soft-iron factor */
-#define ADIS16400_YMAGN_SIF 0x2E /* Y-axis magnetometer, soft-iron factor */
-#define ADIS16400_ZMAGN_SIF 0x30 /* Z-axis magnetometer, soft-iron factor */
-
-#define ADIS16400_GPIO_CTRL 0x32 /* Auxiliary digital input/output control */
-#define ADIS16400_MSC_CTRL  0x34 /* Miscellaneous control */
-#define ADIS16400_SMPL_PRD  0x36 /* Internal sample period (rate) control */
-#define ADIS16400_SENS_AVG  0x38 /* Dynamic range and digital filter control */
-#define ADIS16400_SLP_CNT   0x3A /* Sleep mode control */
-#define ADIS16400_DIAG_STAT 0x3C /* System status */
+#define ADIS16400_XGYRO_OFF (0x1A >> 1) /* X-axis gyroscope bias offset factor */
+#define ADIS16400_YGYRO_OFF (0x1C >> 1) /* Y-axis gyroscope bias offset factor */
+#define ADIS16400_ZGYRO_OFF (0x1E >> 1) /* Z-axis gyroscope bias offset factor */
+#define ADIS16400_XACCL_OFF (0x20 >> 1) /* X-axis acceleration bias offset factor */
+#define ADIS16400_YACCL_OFF (0x22 >> 1) /* Y-axis acceleration bias offset factor */
+#define ADIS16400_ZACCL_OFF (0x24 >> 1) /* Z-axis acceleration bias offset factor */
+#define ADIS16400_XMAGN_HIF (0x26 >> 1) /* X-axis magnetometer, hard-iron factor */
+#define ADIS16400_YMAGN_HIF (0x28 >> 1) /* Y-axis magnetometer, hard-iron factor */
+#define ADIS16400_ZMAGN_HIF (0x2A >> 1) /* Z-axis magnetometer, hard-iron factor */
+#define ADIS16400_XMAGN_SIF (0x2C >> 1) /* X-axis magnetometer, soft-iron factor */
+#define ADIS16400_YMAGN_SIF (0x2E >> 1) /* Y-axis magnetometer, soft-iron factor */
+#define ADIS16400_ZMAGN_SIF (0x30 >> 1) /* Z-axis magnetometer, soft-iron factor */
+
+#define ADIS16400_GPIO_CTRL (0x32 >> 1) /* Auxiliary digital input/output control */
+#define ADIS16400_MSC_CTRL  (0x34 >> 1) /* Miscellaneous control */
+#define ADIS16400_SMPL_PRD  (0x36 >> 1) /* Internal sample period (rate) control */
+#define ADIS16400_SENS_AVG  (0x38 >> 1) /* Dynamic range and digital filter control */
+#define ADIS16400_SLP_CNT   (0x3A >> 1) /* Sleep mode control */
+#define ADIS16400_DIAG_STAT (0x3C >> 1) /* System status */
 
 /* Alarm functions */
-#define ADIS16400_GLOB_CMD  0x3E /* System command */
-#define ADIS16400_ALM_MAG1  0x40 /* Alarm 1 amplitude threshold */
-#define ADIS16400_ALM_MAG2  0x42 /* Alarm 2 amplitude threshold */
-#define ADIS16400_ALM_SMPL1 0x44 /* Alarm 1 sample size */
-#define ADIS16400_ALM_SMPL2 0x46 /* Alarm 2 sample size */
-#define ADIS16400_ALM_CTRL  0x48 /* Alarm control */
-#define ADIS16400_AUX_DAC   0x4A /* Auxiliary DAC data */
-
-#define ADIS16400_PRODUCT_ID 0x56 /* Product identifier */
+#define ADIS16400_GLOB_CMD  (0x3E >> 1) /* System command */
+#define ADIS16400_ALM_MAG1  (0x40 >> 1) /* Alarm 1 amplitude threshold */
+#define ADIS16400_ALM_MAG2  (0x42 >> 1) /* Alarm 2 amplitude threshold */
+#define ADIS16400_ALM_SMPL1 (0x44 >> 1) /* Alarm 1 sample size */
+#define ADIS16400_ALM_SMPL2 (0x46 >> 1) /* Alarm 2 sample size */
+#define ADIS16400_ALM_CTRL  (0x48 >> 1) /* Alarm control */
+#define ADIS16400_AUX_DAC   (0x4A >> 1) /* Auxiliary DAC data */
+
+#define ADIS16400_PRODUCT_ID (0x56 >> 1) /* Product identifier */
 
 #define ADIS16400_ERROR_ACTIVE			(1<<14)
 #define ADIS16400_NEW_DATA			(1<<14)
diff --git a/drivers/staging/iio/imu/adis16400_core.c b/drivers/staging/iio/imu/adis16400_core.c
index b4be380..a75a7d1 100644
--- a/drivers/staging/iio/imu/adis16400_core.c
+++ b/drivers/staging/iio/imu/adis16400_core.c
@@ -1074,7 +1074,7 @@ static struct regmap_config adis16400_regmap_config = {
 	.precious_reg = &adis16400_reg_precious,
 	.volatile_reg = &adis16400_reg_volatile,
 	.max_register = 0x56,
-	.write_flag_mask = 0x80,
+	.write_flag_mask = 0x40, /* doubling of this occurs */
 	.read_flag_mask = 0,
 };
 
diff --git a/drivers/staging/iio/imu/adis16400_ring.c b/drivers/staging/iio/imu/adis16400_ring.c
index 8345d4e..e1cd1bf 100644
--- a/drivers/staging/iio/imu/adis16400_ring.c
+++ b/drivers/staging/iio/imu/adis16400_ring.c
@@ -57,17 +57,17 @@ static int adis16400_spi_read_burst(struct device *dev, u8 *rx)
 }
 
 static const u16 read_all_tx_array[] = {
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_SUPPLY_OUT)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_XGYRO_OUT)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_YGYRO_OUT)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_ZGYRO_OUT)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_XACCL_OUT)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_YACCL_OUT)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_ZACCL_OUT)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16350_XTEMP_OUT)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16350_YTEMP_OUT)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16350_ZTEMP_OUT)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_AUX_ADC)),
+	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_SUPPLY_OUT << 1)),
+	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_XGYRO_OUT << 1)),
+	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_YGYRO_OUT << 1)),
+	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_ZGYRO_OUT << 1)),
+	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_XACCL_OUT << 1)),
+	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_YACCL_OUT << 1)),
+	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_ZACCL_OUT << 1)),
+	cpu_to_be16(ADIS16400_READ_REG(ADIS16350_XTEMP_OUT << 1)),
+	cpu_to_be16(ADIS16400_READ_REG(ADIS16350_YTEMP_OUT << 1)),
+	cpu_to_be16(ADIS16400_READ_REG(ADIS16350_ZTEMP_OUT << 1)),
+	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_AUX_ADC << 1)),
 };
 
 static int adis16350_spi_read_all(struct device *dev, u8 *rx)
-- 
1.7.3.4

