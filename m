Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab1IHOBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:01:35 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:50803 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932902Ab1IHOBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:01:14 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 2/2] staging:iio:imu:adis16400 regmap introduction.
Date: Thu,  8 Sep 2011 15:09:24 +0100
Message-Id: <1315490964-25718-3-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1315490964-25718-1-git-send-email-jic23@cam.ac.uk>
References: <1315490964-25718-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apply regmap for the basic register reads and writes.
Note not currently used at all for the mass reads
that occur in the buffer code.

Not signed off by: Jonathan Cameorn <jic23@cam.ac.uk>
---
 drivers/staging/iio/imu/Kconfig          |    1 +
 drivers/staging/iio/imu/adis16400.h      |    2 +
 drivers/staging/iio/imu/adis16400_core.c |  301 +++++++++++++++++++-----------
 3 files changed, 191 insertions(+), 113 deletions(-)

diff --git a/drivers/staging/iio/imu/Kconfig b/drivers/staging/iio/imu/Kconfig
index e0e0144..9b4b912 100644
--- a/drivers/staging/iio/imu/Kconfig
+++ b/drivers/staging/iio/imu/Kconfig
@@ -8,6 +8,7 @@ config ADIS16400
 	depends on SPI
 	select IIO_SW_RING if IIO_RING_BUFFER
 	select IIO_TRIGGER if IIO_RING_BUFFER
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Analog Devices adis16300, adis16350,
 	  adis16354, adis16355, adis16360, adis16362, adis16364, adis16365,
diff --git a/drivers/staging/iio/imu/adis16400.h b/drivers/staging/iio/imu/adis16400.h
index 1f8f0c6..b36dcbb 100644
--- a/drivers/staging/iio/imu/adis16400.h
+++ b/drivers/staging/iio/imu/adis16400.h
@@ -143,6 +143,7 @@ struct adis16400_chip_info {
 
 /**
  * struct adis16400_state - device instance specific data
+ * @regmap:		register map
  * @us:			actual spi_device
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
@@ -150,6 +151,7 @@ struct adis16400_chip_info {
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16400_state {
+	struct regmap			*regmap;
 	struct spi_device		*us;
 	struct iio_trigger		*trig;
 	struct mutex			buf_lock;
diff --git a/drivers/staging/iio/imu/adis16400_core.c b/drivers/staging/iio/imu/adis16400_core.c
index b6d824f..66364f5 100644
--- a/drivers/staging/iio/imu/adis16400_core.c
+++ b/drivers/staging/iio/imu/adis16400_core.c
@@ -25,6 +25,8 @@
 #include <linux/sysfs.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/err.h>
+#include <linux/regmap.h>
 
 #include "../iio.h"
 #include "../sysfs.h"
@@ -43,71 +45,19 @@ enum adis16400_chip_variant {
 };
 
 /**
- * adis16400_spi_write_reg_8() - write single byte to a register
- * @dev: device associated with child of actual device (iio_dev or iio_trig)
- * @reg_address: the address of the register to be written
- * @val: the value to write
- */
-static int adis16400_spi_write_reg_8(struct iio_dev *indio_dev,
-				     u8 reg_address,
-				     u8 val)
-{
-	int ret;
-	struct adis16400_state *st = iio_priv(indio_dev);
-
-	mutex_lock(&st->buf_lock);
-	st->tx[0] = ADIS16400_WRITE_REG(reg_address);
-	st->tx[1] = val;
-
-	ret = spi_write(st->us, st->tx, 2);
-	mutex_unlock(&st->buf_lock);
-
-	return ret;
-}
-
-/**
  * adis16400_spi_write_reg_16() - write 2 bytes to a pair of registers
  * @dev: device associated with child of actual device (iio_dev or iio_trig)
  * @reg_address: the address of the lower of the two registers. Second register
  *               is assumed to have address one greater.
  * @val: value to be written
- *
- * At the moment the spi framework doesn't allow global setting of cs_change.
- * This means that use cannot be made of spi_write.
  */
 static int adis16400_spi_write_reg_16(struct iio_dev *indio_dev,
 		u8 lower_reg_address,
 		u16 value)
 {
-	int ret;
-	struct spi_message msg;
 	struct adis16400_state *st = iio_priv(indio_dev);
-	struct spi_transfer xfers[] = {
-		{
-			.tx_buf = st->tx,
-			.bits_per_word = 8,
-			.len = 2,
-			.cs_change = 1,
-		}, {
-			.tx_buf = st->tx + 2,
-			.bits_per_word = 8,
-			.len = 2,
-		},
-	};
-
-	mutex_lock(&st->buf_lock);
-	st->tx[0] = ADIS16400_WRITE_REG(lower_reg_address);
-	st->tx[1] = value & 0xFF;
-	st->tx[2] = ADIS16400_WRITE_REG(lower_reg_address + 1);
-	st->tx[3] = (value >> 8) & 0xFF;
-
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfers[0], &msg);
-	spi_message_add_tail(&xfers[1], &msg);
-	ret = spi_sync(st->us, &msg);
-	mutex_unlock(&st->buf_lock);
 
-	return ret;
+	return regmap_write(st->regmap, lower_reg_address, value);
 }
 
 /**
@@ -116,49 +66,21 @@ static int adis16400_spi_write_reg_16(struct iio_dev *indio_dev,
  * @reg_address: the address of the lower of the two registers. Second register
  *               is assumed to have address one greater.
  * @val: somewhere to pass back the value read
- *
- * At the moment the spi framework doesn't allow global setting of cs_change.
- * This means that use cannot be made of spi_read.
- **/
+ */
 static int adis16400_spi_read_reg_16(struct iio_dev *indio_dev,
 		u8 lower_reg_address,
 		u16 *val)
 {
-	struct spi_message msg;
 	struct adis16400_state *st = iio_priv(indio_dev);
 	int ret;
-	struct spi_transfer xfers[] = {
-		{
-			.tx_buf = st->tx,
-			.bits_per_word = 8,
-			.len = 2,
-			.cs_change = 1,
-		}, {
-			.rx_buf = st->rx,
-			.bits_per_word = 8,
-			.len = 2,
-		},
-	};
-
-	mutex_lock(&st->buf_lock);
-	st->tx[0] = ADIS16400_READ_REG(lower_reg_address);
-	st->tx[1] = 0;
-
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfers[0], &msg);
-	spi_message_add_tail(&xfers[1], &msg);
-	ret = spi_sync(st->us, &msg);
-	if (ret) {
-		dev_err(&st->us->dev,
-			"problem when reading 16 bit register 0x%02X",
-			lower_reg_address);
-		goto error_ret;
-	}
-	*val = (st->rx[0] << 8) | st->rx[1];
+	unsigned int value;
 
-error_ret:
-	mutex_unlock(&st->buf_lock);
-	return ret;
+	ret = regmap_read(st->regmap, lower_reg_address, &value);
+	if (ret < 0)
+		return ret;
+	*val = value;
+	
+	return 0;
 }
 
 static ssize_t adis16400_read_frequency(struct device *dev,
@@ -172,7 +94,7 @@ static ssize_t adis16400_read_frequency(struct device *dev,
 	ret = adis16400_spi_read_reg_16(indio_dev,
 			ADIS16400_SMPL_PRD,
 			&t);
-	if (ret)
+	if (ret < 0)
 		return ret;
 	sps =  (t & ADIS16400_SMPL_PRD_TIME_BASE) ? 53 : 1638;
 	sps /= (t & ADIS16400_SMPL_PRD_DIV_MASK) + 1;
@@ -192,7 +114,7 @@ static ssize_t adis16400_write_frequency(struct device *dev,
 	u8 t;
 
 	ret = strict_strtol(buf, 10, &val);
-	if (ret)
+	if (ret < 0)
 		return ret;
 
 	mutex_lock(&indio_dev->mlock);
@@ -206,7 +128,7 @@ static ssize_t adis16400_write_frequency(struct device *dev,
 	else
 		st->us->max_speed_hz = ADIS16400_SPI_FAST;
 
-	ret = adis16400_spi_write_reg_8(indio_dev,
+	ret = adis16400_spi_write_reg_16(indio_dev,
 			ADIS16400_SMPL_PRD,
 			t);
 
@@ -218,10 +140,10 @@ static ssize_t adis16400_write_frequency(struct device *dev,
 static int adis16400_reset(struct iio_dev *indio_dev)
 {
 	int ret;
-	ret = adis16400_spi_write_reg_8(indio_dev,
+	ret = adis16400_spi_write_reg_16(indio_dev,
 			ADIS16400_GLOB_CMD,
 			ADIS16400_GLOB_CMD_SW_RESET);
-	if (ret)
+	if (ret < 0)
 		dev_err(&indio_dev->dev, "problem resetting device");
 
 	return ret;
@@ -252,7 +174,7 @@ int adis16400_set_irq(struct iio_dev *indio_dev, bool enable)
 	u16 msc;
 
 	ret = adis16400_spi_read_reg_16(indio_dev, ADIS16400_MSC_CTRL, &msc);
-	if (ret)
+	if (ret < 0)
 		goto error_ret;
 
 	msc |= ADIS16400_MSC_CTRL_DATA_RDY_POL_HIGH;
@@ -262,7 +184,7 @@ int adis16400_set_irq(struct iio_dev *indio_dev, bool enable)
 		msc &= ~ADIS16400_MSC_CTRL_DATA_RDY_EN;
 
 	ret = adis16400_spi_write_reg_16(indio_dev, ADIS16400_MSC_CTRL, msc);
-	if (ret)
+	if (ret < 0)
 		goto error_ret;
 
 error_ret:
@@ -276,7 +198,7 @@ static int adis16400_stop_device(struct iio_dev *indio_dev)
 	u16 val = ADIS16400_SLP_CNT_POWER_OFF;
 
 	ret = adis16400_spi_write_reg_16(indio_dev, ADIS16400_SLP_CNT, val);
-	if (ret)
+	if (ret < 0)
 		dev_err(&indio_dev->dev,
 			"problem with turning device off: SLP_CNT");
 
@@ -338,7 +260,7 @@ static int adis16400_self_test(struct iio_dev *indio_dev)
 	ret = adis16400_spi_write_reg_16(indio_dev,
 			ADIS16400_MSC_CTRL,
 			ADIS16400_MSC_CTRL_MEM_TEST);
-	if (ret) {
+	if (ret < 0) {
 		dev_err(&indio_dev->dev, "problem starting self test");
 		goto err_ret;
 	}
@@ -362,24 +284,24 @@ static int adis16400_initial_setup(struct iio_dev *indio_dev)
 	spi_setup(st->us);
 
 	ret = adis16400_set_irq(indio_dev, false);
-	if (ret) {
+	if (ret < 0) {
 		dev_err(&indio_dev->dev, "disable irq failed");
 		goto err_ret;
 	}
 
 	ret = adis16400_self_test(indio_dev);
-	if (ret) {
+	if (ret < 0) {
 		dev_err(&indio_dev->dev, "self test failure");
 		goto err_ret;
 	}
 
 	ret = adis16400_check_status(indio_dev);
-	if (ret) {
+	if (ret < 0) {
 		adis16400_reset(indio_dev);
 		dev_err(&indio_dev->dev, "device not playing ball -> reset");
 		msleep(ADIS16400_STARTUP_DELAY);
 		ret = adis16400_check_status(indio_dev);
-		if (ret) {
+		if (ret < 0) {
 			dev_err(&indio_dev->dev, "giving up");
 			goto err_ret;
 		}
@@ -387,7 +309,7 @@ static int adis16400_initial_setup(struct iio_dev *indio_dev)
 	if (st->variant->flags & ADIS16400_HAS_PROD_ID) {
 		ret = adis16400_spi_read_reg_16(indio_dev,
 						ADIS16400_PRODUCT_ID, &prod_id);
-		if (ret)
+		if (ret < 0)
 			goto err_ret;
 
 		if ((prod_id & 0xF000) != st->variant->product_id)
@@ -492,7 +414,7 @@ static int adis16400_read_raw(struct iio_dev *indio_dev,
 		ret = adis16400_spi_read_reg_16(indio_dev,
 				adis16400_addresses[chan->address][0],
 				&val16);
-		if (ret) {
+		if (ret < 0) {
 			mutex_unlock(&indio_dev->mlock);
 			return ret;
 		}
@@ -539,7 +461,7 @@ static int adis16400_read_raw(struct iio_dev *indio_dev,
 				adis16400_addresses[chan->address][1],
 				&val16);
 		mutex_unlock(&indio_dev->mlock);
-		if (ret)
+		if (ret < 0)
 			return ret;
 		val16 = ((val16 & 0xFFF) << 4) >> 4;
 		*val = val16;
@@ -1016,6 +938,150 @@ static const struct iio_info adis16400_info = {
 	.attrs = &adis16400_attribute_group,
 };
 
+/* This may technically result in read attempts to undefined registers */
+static bool adis16400_reg_readable(struct device *dev,
+				   unsigned int reg)
+{
+	switch (reg) {
+	case ADIS16400_FLASH_CNT:
+	case ADIS16400_SUPPLY_OUT:
+	case ADIS16400_XGYRO_OUT:
+	case ADIS16400_YGYRO_OUT:
+	case ADIS16400_ZGYRO_OUT:
+	case ADIS16400_XACCL_OUT:
+	case ADIS16400_YACCL_OUT:
+	case ADIS16400_ZACCL_OUT:
+	case ADIS16400_XMAGN_OUT:
+	case ADIS16400_YMAGN_OUT:
+	case ADIS16400_ZMAGN_OUT:
+	case ADIS16400_TEMP_OUT:
+	case ADIS16400_AUX_ADC:
+	case ADIS16400_XGYRO_OFF:
+	case ADIS16400_YGYRO_OFF:
+	case ADIS16400_ZGYRO_OFF:
+	case ADIS16400_XACCL_OFF:
+	case ADIS16400_YACCL_OFF:
+	case ADIS16400_ZACCL_OFF:
+	case ADIS16400_XMAGN_HIF:
+	case ADIS16400_YMAGN_HIF:
+	case ADIS16400_ZMAGN_HIF:
+	case ADIS16400_XMAGN_SIF:
+	case ADIS16400_YMAGN_SIF:
+	case ADIS16400_ZMAGN_SIF:
+	case ADIS16400_GPIO_CTRL:
+	case ADIS16400_MSC_CTRL:
+	case ADIS16400_SMPL_PRD:
+	case ADIS16400_SENS_AVG:
+	case ADIS16400_DIAG_STAT:
+	case ADIS16400_ALM_MAG1:
+	case ADIS16400_ALM_MAG2:
+	case ADIS16400_ALM_SMPL1:
+	case ADIS16400_ALM_SMPL2:
+	case ADIS16400_ALM_CTRL:
+	case ADIS16400_AUX_DAC:
+	case ADIS16400_PRODUCT_ID:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool adis16400_reg_precious(struct device *dev,
+				   unsigned int reg)
+{
+	switch (reg) {
+	case ADIS16400_SUPPLY_OUT:
+	case ADIS16400_XGYRO_OUT:
+	case ADIS16400_YGYRO_OUT:
+	case ADIS16400_ZGYRO_OUT:
+	case ADIS16400_XACCL_OUT:
+	case ADIS16400_YACCL_OUT:
+	case ADIS16400_ZACCL_OUT:
+	case ADIS16400_XMAGN_OUT:
+	case ADIS16400_YMAGN_OUT:
+	case ADIS16400_ZMAGN_OUT:
+	case ADIS16400_TEMP_OUT:
+	case ADIS16400_AUX_ADC:
+	case ADIS16400_DIAG_STAT:
+		return true;
+	default:
+		return 0;
+	}
+}
+
+static bool adis16400_reg_volatile(struct device *dev,
+				   unsigned int reg)
+{
+	switch (reg) {
+	case ADIS16400_FLASH_CNT:
+	case ADIS16400_SUPPLY_OUT:
+	case ADIS16400_XGYRO_OUT:
+	case ADIS16400_YGYRO_OUT:
+	case ADIS16400_ZGYRO_OUT:
+	case ADIS16400_XACCL_OUT:
+	case ADIS16400_YACCL_OUT:
+	case ADIS16400_ZACCL_OUT:
+	case ADIS16400_XMAGN_OUT:
+	case ADIS16400_YMAGN_OUT:
+	case ADIS16400_ZMAGN_OUT:
+	case ADIS16400_TEMP_OUT:
+	case ADIS16400_AUX_ADC:
+	case ADIS16400_DIAG_STAT:
+
+		return true;
+	default:
+		return 0;
+	}
+}
+
+static bool adis16400_reg_writeable(struct device *dev,
+				    unsigned int reg)
+{
+	switch (reg) {
+	case ADIS16400_XGYRO_OFF:
+	case ADIS16400_YGYRO_OFF:
+	case ADIS16400_ZGYRO_OFF:
+	case ADIS16400_XACCL_OFF:
+	case ADIS16400_YACCL_OFF:
+	case ADIS16400_ZACCL_OFF:
+	case ADIS16400_XMAGN_HIF:
+	case ADIS16400_YMAGN_HIF:
+	case ADIS16400_ZMAGN_HIF:
+	case ADIS16400_XMAGN_SIF:
+	case ADIS16400_YMAGN_SIF:
+	case ADIS16400_ZMAGN_SIF:
+	case ADIS16400_GPIO_CTRL:
+	case ADIS16400_MSC_CTRL:
+	case ADIS16400_SMPL_PRD:
+	case ADIS16400_SENS_AVG:
+	case ADIS16400_SLP_CNT:
+	case ADIS16400_GLOB_CMD:
+	case ADIS16400_ALM_MAG1:
+	case ADIS16400_ALM_MAG2:
+	case ADIS16400_ALM_SMPL1:
+	case ADIS16400_ALM_SMPL2:
+	case ADIS16400_ALM_CTRL:
+	case ADIS16400_AUX_DAC:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static const struct regmap_config adis16400_regmap_config = {
+	.reg_bits = 8,
+	.reg_pad_bits = 8,
+	.val_bits = 16,
+	.half_write = true,
+	.writeable_reg = &adis16400_reg_writeable,
+	.readable_reg = &adis16400_reg_readable,
+	.precious_reg = &adis16400_reg_precious,
+	.volatile_reg = &adis16400_reg_volatile,
+	.max_register = 0x56,
+	.write_flag_mask = 0x80,
+	.read_flag_mask = 0,
+};
+
 static int __devinit adis16400_probe(struct spi_device *spi)
 {
 	int ret;
@@ -1026,9 +1092,14 @@ static int __devinit adis16400_probe(struct spi_device *spi)
 		goto error_ret;
 	}
 	st = iio_priv(indio_dev);
+	st->regmap = regmap_init_spi(spi, &adis16400_regmap_config);
+	if (IS_ERR(st->regmap)) {
+		ret = PTR_ERR(st->regmap);
+		goto error_free_dev;
+	}
 	/* this is only used for removal purposes */
 	spi_set_drvdata(spi, indio_dev);
-
+	spi->cs_between_transfers = 1;
 	st->us = spi;
 	mutex_init(&st->buf_lock);
 
@@ -1042,29 +1113,29 @@ static int __devinit adis16400_probe(struct spi_device *spi)
 	indio_dev->modes = INDIO_DIRECT_MODE;
 
 	ret = adis16400_configure_ring(indio_dev);
-	if (ret)
-		goto error_free_dev;
+	if (ret < 0)
+		goto error_free_regmap;
 
 	ret = iio_ring_buffer_register(indio_dev,
 				       st->variant->channels,
 				       st->variant->num_channels);
-	if (ret) {
+	if (ret < 0) {
 		dev_err(&spi->dev, "failed to initialize the ring\n");
 		goto error_unreg_ring_funcs;
 	}
 
 	if (spi->irq) {
 		ret = adis16400_probe_trigger(indio_dev);
-		if (ret)
+		if (ret < 0)
 			goto error_uninitialize_ring;
 	}
 
 	/* Get the device into a sane initial state */
 	ret = adis16400_initial_setup(indio_dev);
-	if (ret)
+	if (ret < 0)
 		goto error_remove_trigger;
 	ret = iio_device_register(indio_dev);
-	if (ret)
+	if (ret < 0)
 		goto error_remove_trigger;
 
 	return 0;
@@ -1076,6 +1147,8 @@ error_uninitialize_ring:
 	iio_ring_buffer_unregister(indio_dev);
 error_unreg_ring_funcs:
 	adis16400_unconfigure_ring(indio_dev);
+error_free_regmap:
+	regmap_exit(st->regmap);
 error_free_dev:
 	iio_free_device(indio_dev);
 error_ret:
@@ -1087,14 +1160,16 @@ static int adis16400_remove(struct spi_device *spi)
 {
 	int ret;
 	struct iio_dev *indio_dev =  spi_get_drvdata(spi);
+	struct adis16400_state *st = iio_priv(indio_dev);
 
 	ret = adis16400_stop_device(indio_dev);
-	if (ret)
+	if (ret < 0)
 		goto err_ret;
 
 	adis16400_remove_trigger(indio_dev);
 	iio_ring_buffer_unregister(indio_dev);
 	adis16400_unconfigure_ring(indio_dev);
+	regmap_exit(st->regmap);
 	iio_device_unregister(indio_dev);
 
 	return 0;
-- 
1.7.3.4

