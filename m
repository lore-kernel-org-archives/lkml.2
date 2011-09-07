Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1IGQMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:12:00 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:48747 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab1IGQLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:11:46 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 6/6] staging:iio:imu:adis16400 make use of regmap bulk read capabilities
Date: Wed,  7 Sep 2011 17:19:47 +0100
Message-Id: <1315412387-5765-7-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <4E679770.4090008@cam.ac.uk>
References: <4E679770.4090008@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note this only works because of the spi cs change default fun.
---
 drivers/staging/iio/imu/adis16400.h      |    4 +-
 drivers/staging/iio/imu/adis16400_ring.c |   67 +++++-------------------------
 2 files changed, 13 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/iio/imu/adis16400.h b/drivers/staging/iio/imu/adis16400.h
index 919d6fa..d1b7b3e 100644
--- a/drivers/staging/iio/imu/adis16400.h
+++ b/drivers/staging/iio/imu/adis16400.h
@@ -122,7 +122,7 @@
 /* SLP_CNT */
 #define ADIS16400_SLP_CNT_POWER_OFF	(1<<8)
 
-#define ADIS16400_MAX_TX 24
+#define ADIS16400_MAX_TX 2
 #define ADIS16400_MAX_RX 24
 
 #define ADIS16400_SPI_SLOW	(u32)(300 * 1000)
@@ -158,7 +158,7 @@ struct adis16400_state {
 	struct adis16400_chip_info	*variant;
 
 	u8	tx[ADIS16400_MAX_TX] ____cacheline_aligned;
-	u8	rx[ADIS16400_MAX_RX] ____cacheline_aligned;
+	u16	rx[ADIS16400_MAX_RX >> 1] ____cacheline_aligned;
 };
 
 int adis16400_set_irq(struct iio_dev *indio_dev, bool enable);
diff --git a/drivers/staging/iio/imu/adis16400_ring.c b/drivers/staging/iio/imu/adis16400_ring.c
index e1cd1bf..84c539b 100644
--- a/drivers/staging/iio/imu/adis16400_ring.c
+++ b/drivers/staging/iio/imu/adis16400_ring.c
@@ -4,6 +4,7 @@
 #include <linux/spi/spi.h>
 #include <linux/slab.h>
 #include <linux/bitops.h>
+#include <linux/regmap.h>
 
 #include "../iio.h"
 #include "../ring_sw.h"
@@ -15,7 +16,7 @@
  * @dev: device associated with child of actual device (iio_dev or iio_trig)
  * @rx: somewhere to pass back the value read (min size is 24 bytes)
  **/
-static int adis16400_spi_read_burst(struct device *dev, u8 *rx)
+static int adis16400_spi_read_burst(struct device *dev, u16 *rx)
 {
 	struct spi_message msg;
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
@@ -56,55 +57,6 @@ static int adis16400_spi_read_burst(struct device *dev, u8 *rx)
 	return ret;
 }
 
-static const u16 read_all_tx_array[] = {
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_SUPPLY_OUT << 1)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_XGYRO_OUT << 1)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_YGYRO_OUT << 1)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_ZGYRO_OUT << 1)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_XACCL_OUT << 1)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_YACCL_OUT << 1)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_ZACCL_OUT << 1)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16350_XTEMP_OUT << 1)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16350_YTEMP_OUT << 1)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16350_ZTEMP_OUT << 1)),
-	cpu_to_be16(ADIS16400_READ_REG(ADIS16400_AUX_ADC << 1)),
-};
-
-static int adis16350_spi_read_all(struct device *dev, u8 *rx)
-{
-	struct iio_dev *indio_dev = dev_get_drvdata(dev);
-	struct adis16400_state *st = iio_priv(indio_dev);
-
-	struct spi_message msg;
-	int i, j = 0, ret;
-	struct spi_transfer *xfers;
-
-	xfers = kzalloc(sizeof(*xfers)*indio_dev->ring->scan_count + 1,
-			GFP_KERNEL);
-	if (xfers == NULL)
-		return -ENOMEM;
-
-	for (i = 0; i < ARRAY_SIZE(read_all_tx_array); i++)
-		if (test_bit(i, indio_dev->ring->scan_mask)) {
-			xfers[j].tx_buf = &read_all_tx_array[i];
-			xfers[j].bits_per_word = 16;
-			xfers[j].len = 2;
-			xfers[j + 1].rx_buf = rx + j*2;
-			j++;
-		}
-	xfers[j].bits_per_word = 16;
-	xfers[j].len = 2;
-
-	spi_message_init(&msg);
-	for (j = 0; j < indio_dev->ring->scan_count + 1; j++)
-		spi_message_add_tail(&xfers[j], &msg);
-
-	ret = spi_sync(st->us, &msg);
-	kfree(xfers);
-
-	return ret;
-}
-
 /* Whilst this makes a lot of calls to iio_sw_ring functions - it is to device
  * specific to be rolled into the core.
  */
@@ -120,7 +72,7 @@ static irqreturn_t adis16400_trigger_handler(int irq, void *p)
 	/* Asumption that long is enough for maximum channels */
 	unsigned long mask = *ring->scan_mask;
 
-	data = kmalloc(datasize , GFP_KERNEL);
+	data = kmalloc(datasize, GFP_KERNEL);
 	if (data == NULL) {
 		dev_err(&st->us->dev, "memory alloc failed in ring bh");
 		return -ENOMEM;
@@ -128,11 +80,14 @@ static irqreturn_t adis16400_trigger_handler(int irq, void *p)
 
 	if (ring->scan_count) {
 		if (st->variant->flags & ADIS16400_NO_BURST) {
-			ret = adis16350_spi_read_all(&indio_dev->dev, st->rx);
+			ret = regmap_bulk_read(st->regmap, ADIS16400_SUPPLY_OUT, st->rx, 12);
 			if (ret < 0)
 				goto err;
-			for (; i < ring->scan_count; i++)
-				data[i]	= *(s16 *)(st->rx + i*2);
+			for (; i < indio_dev->ring->scan_count; i++) {
+				j = __ffs(mask);
+				mask &= ~(1 << j);
+				data[i] = st->rx[j];
+			}
 		} else {
 			ret = adis16400_spi_read_burst(&indio_dev->dev, st->rx);
 			if (ret < 0)
@@ -141,9 +96,10 @@ static irqreturn_t adis16400_trigger_handler(int irq, void *p)
 				j = __ffs(mask);
 				mask &= ~(1 << j);
 				data[i] = be16_to_cpup(
-					(__be16 *)&(st->rx[j*2]));
+					(__be16 *)&(st->rx[j]));
 			}
 		}
+
 	}
 	/* Guaranteed to be aligned with 8 byte boundary */
 	if (ring->scan_timestamp)
@@ -175,7 +131,6 @@ static const struct iio_ring_setup_ops adis16400_ring_setup_ops = {
 int adis16400_configure_ring(struct iio_dev *indio_dev)
 {
 	int ret = 0;
-	struct adis16400_state *st = iio_priv(indio_dev);
 	struct iio_ring_buffer *ring;
 
 	ring = iio_sw_rb_allocate(indio_dev);
-- 
1.7.3.4

