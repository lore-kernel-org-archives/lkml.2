Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab3AIRaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 12:30:39 -0500
Received: from smtp-out-052.synserver.de ([212.40.185.52]:1067 "EHLO
	smtp-out-052.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab3AIRag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 12:30:36 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 5469
From: Lars-Peter Clausen <lars@metafoo.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/3] staging:iio: Use spi_sync_transfer()
Date: Wed,  9 Jan 2013 18:31:11 +0100
Message-Id: <1357752671-30222-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1357752671-30222-1-git-send-email-lars@metafoo.de>
References: <1357752671-30222-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new spi_sync_transfer() helper function instead of open-coding it.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/staging/iio/accel/kxsd9.c          |  6 +---
 drivers/staging/iio/accel/lis3l02dq_core.c | 18 ++----------
 drivers/staging/iio/accel/sca3000_core.c   | 13 ++-------
 drivers/staging/iio/accel/sca3000_ring.c   |  6 +---
 drivers/staging/iio/adc/ad7280a.c          |  6 +---
 drivers/staging/iio/frequency/ad5930.c     |  5 +---
 drivers/staging/iio/frequency/ad9850.c     |  5 +---
 drivers/staging/iio/frequency/ad9852.c     |  5 +---
 drivers/staging/iio/gyro/adxrs450_core.c   |  5 +---
 drivers/staging/iio/meter/ade7753.c        |  6 +---
 drivers/staging/iio/meter/ade7754.c        |  5 +---
 drivers/staging/iio/meter/ade7758_core.c   | 28 ++++---------------
 drivers/staging/iio/meter/ade7759.c        |  5 +---
 drivers/staging/iio/meter/ade7854-spi.c    | 44 ++++++------------------------
 drivers/staging/iio/resolver/ad2s1210.c    |  5 +---
 15 files changed, 29 insertions(+), 133 deletions(-)

diff --git a/drivers/staging/iio/accel/kxsd9.c b/drivers/staging/iio/accel/kxsd9.c
index fdd5fbd..afdfcaf 100644
--- a/drivers/staging/iio/accel/kxsd9.c
+++ b/drivers/staging/iio/accel/kxsd9.c
@@ -94,7 +94,6 @@ error_ret:
 
 static int kxsd9_read(struct iio_dev *indio_dev, u8 address)
 {
-	struct spi_message msg;
 	int ret;
 	struct kxsd9_state *st = iio_priv(indio_dev);
 	struct spi_transfer xfers[] = {
@@ -112,10 +111,7 @@ static int kxsd9_read(struct iio_dev *indio_dev, u8 address)
 
 	mutex_lock(&st->buf_lock);
 	st->tx[0] = KXSD9_READ(address);
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfers[0], &msg);
-	spi_message_add_tail(&xfers[1], &msg);
-	ret = spi_sync(st->us, &msg);
+	ret = spi_sync_transfer(st->us, xfers, ARRAY_SIZE(xfers));
 	if (ret)
 		return ret;
 	return (((u16)(st->rx[0])) << 8) | (st->rx[1] & 0xF0);
diff --git a/drivers/staging/iio/accel/lis3l02dq_core.c b/drivers/staging/iio/accel/lis3l02dq_core.c
index 21b0469..899da76 100644
--- a/drivers/staging/iio/accel/lis3l02dq_core.c
+++ b/drivers/staging/iio/accel/lis3l02dq_core.c
@@ -52,7 +52,6 @@ int lis3l02dq_spi_read_reg_8(struct iio_dev *indio_dev,
 			     u8 reg_address, u8 *val)
 {
 	struct lis3l02dq_state *st = iio_priv(indio_dev);
-	struct spi_message msg;
 	int ret;
 	struct spi_transfer xfer = {
 		.tx_buf = st->tx,
@@ -65,9 +64,7 @@ int lis3l02dq_spi_read_reg_8(struct iio_dev *indio_dev,
 	st->tx[0] = LIS3L02DQ_READ_REG(reg_address);
 	st->tx[1] = 0;
 
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfer, &msg);
-	ret = spi_sync(st->us, &msg);
+	ret = spi_sync_transfer(st->us, &xfer, 1);
 	*val = st->rx[1];
 	mutex_unlock(&st->buf_lock);
 
@@ -108,7 +105,6 @@ static int lis3l02dq_spi_write_reg_s16(struct iio_dev *indio_dev,
 				       s16 value)
 {
 	int ret;
-	struct spi_message msg;
 	struct lis3l02dq_state *st = iio_priv(indio_dev);
 	struct spi_transfer xfers[] = { {
 			.tx_buf = st->tx,
@@ -128,10 +124,7 @@ static int lis3l02dq_spi_write_reg_s16(struct iio_dev *indio_dev,
 	st->tx[2] = LIS3L02DQ_WRITE_REG(lower_reg_address + 1);
 	st->tx[3] = (value >> 8) & 0xFF;
 
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfers[0], &msg);
-	spi_message_add_tail(&xfers[1], &msg);
-	ret = spi_sync(st->us, &msg);
+	ret = spi_sync_transfer(st->us, xfers, ARRAY_SIZE(xfers));
 	mutex_unlock(&st->buf_lock);
 
 	return ret;
@@ -142,8 +135,6 @@ static int lis3l02dq_read_reg_s16(struct iio_dev *indio_dev,
 				  int *val)
 {
 	struct lis3l02dq_state *st = iio_priv(indio_dev);
-
-	struct spi_message msg;
 	int ret;
 	s16 tempval;
 	struct spi_transfer xfers[] = { {
@@ -166,10 +157,7 @@ static int lis3l02dq_read_reg_s16(struct iio_dev *indio_dev,
 	st->tx[2] = LIS3L02DQ_READ_REG(lower_reg_address + 1);
 	st->tx[3] = 0;
 
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfers[0], &msg);
-	spi_message_add_tail(&xfers[1], &msg);
-	ret = spi_sync(st->us, &msg);
+	ret = spi_sync_transfer(st->us, xfers, ARRAY_SIZE(xfers));
 	if (ret) {
 		dev_err(&st->us->dev, "problem when reading 16 bit register");
 		goto error_ret;
diff --git a/drivers/staging/iio/accel/sca3000_core.c b/drivers/staging/iio/accel/sca3000_core.c
index ffd1697..3a5abcb 100644
--- a/drivers/staging/iio/accel/sca3000_core.c
+++ b/drivers/staging/iio/accel/sca3000_core.c
@@ -90,7 +90,6 @@ int sca3000_read_data_short(struct sca3000_state *st,
 			    uint8_t reg_address_high,
 			    int len)
 {
-	struct spi_message msg;
 	struct spi_transfer xfer[2] = {
 		{
 			.len = 1,
@@ -101,11 +100,8 @@ int sca3000_read_data_short(struct sca3000_state *st,
 		}
 	};
 	st->tx[0] = SCA3000_READ_REG(reg_address_high);
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfer[0], &msg);
-	spi_message_add_tail(&xfer[1], &msg);
 
-	return spi_sync(st->us, &msg);
+	return spi_sync_transfer(st->us, xfer, ARRAY_SIZE(xfer));
 }
 
 /**
@@ -133,7 +129,6 @@ static int sca3000_reg_lock_on(struct sca3000_state *st)
  **/
 static int __sca3000_unlock_reg_lock(struct sca3000_state *st)
 {
-	struct spi_message msg;
 	struct spi_transfer xfer[3] = {
 		{
 			.len = 2,
@@ -154,12 +149,8 @@ static int __sca3000_unlock_reg_lock(struct sca3000_state *st)
 	st->tx[3] = 0x50;
 	st->tx[4] = SCA3000_WRITE_REG(SCA3000_REG_ADDR_UNLOCK);
 	st->tx[5] = 0xA0;
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfer[0], &msg);
-	spi_message_add_tail(&xfer[1], &msg);
-	spi_message_add_tail(&xfer[2], &msg);
 
-	return spi_sync(st->us, &msg);
+	return spi_sync_transfer(st->us, xfer, ARRAY_SIZE(xfer));
 }
 
 /**
diff --git a/drivers/staging/iio/accel/sca3000_ring.c b/drivers/staging/iio/accel/sca3000_ring.c
index cbec2f1..3e5e860 100644
--- a/drivers/staging/iio/accel/sca3000_ring.c
+++ b/drivers/staging/iio/accel/sca3000_ring.c
@@ -39,7 +39,6 @@ static int sca3000_read_data(struct sca3000_state *st,
 			    int len)
 {
 	int ret;
-	struct spi_message msg;
 	struct spi_transfer xfer[2] = {
 		{
 			.len = 1,
@@ -55,10 +54,7 @@ static int sca3000_read_data(struct sca3000_state *st,
 	}
 	xfer[1].rx_buf = *rx_p;
 	st->tx[0] = SCA3000_READ_REG(reg_address_high);
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfer[0], &msg);
-	spi_message_add_tail(&xfer[1], &msg);
-	ret = spi_sync(st->us, &msg);
+	ret = spi_sync_transfer(st->us, xfer, ARRAY_SIZE(xfer));
 	if (ret) {
 		dev_err(get_device(&st->us->dev), "problem reading register");
 		goto error_free_rx;
diff --git a/drivers/staging/iio/adc/ad7280a.c b/drivers/staging/iio/adc/ad7280a.c
index cfc39a7..26bafbe 100644
--- a/drivers/staging/iio/adc/ad7280a.c
+++ b/drivers/staging/iio/adc/ad7280a.c
@@ -199,12 +199,8 @@ static int __ad7280_read32(struct spi_device *spi, unsigned *val)
 		.rx_buf = &rx_buf,
 		.len = 4,
 	};
-	struct spi_message m;
 
-	spi_message_init(&m);
-	spi_message_add_tail(&t, &m);
-
-	ret = spi_sync(spi, &m);
+	ret = spi_sync_transfer(spi, &t, 1);
 	if (ret)
 		return ret;
 
diff --git a/drivers/staging/iio/frequency/ad5930.c b/drivers/staging/iio/frequency/ad5930.c
index 2d541d0..3ca9530 100644
--- a/drivers/staging/iio/frequency/ad5930.c
+++ b/drivers/staging/iio/frequency/ad5930.c
@@ -44,7 +44,6 @@ static ssize_t ad5930_set_parameter(struct device *dev,
 					const char *buf,
 					size_t len)
 {
-	struct spi_message msg;
 	struct spi_transfer xfer;
 	int ret;
 	struct ad5903_config *config = (struct ad5903_config *)buf;
@@ -64,9 +63,7 @@ static ssize_t ad5930_set_parameter(struct device *dev,
 	xfer.tx_buf = config;
 	mutex_lock(&st->lock);
 
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfer, &msg);
-	ret = spi_sync(st->sdev, &msg);
+	ret = spi_sync_transfer(st->sdev, &xfer, 1);
 	if (ret)
 		goto error_ret;
 error_ret:
diff --git a/drivers/staging/iio/frequency/ad9850.c b/drivers/staging/iio/frequency/ad9850.c
index 74abee0..663ab4a 100644
--- a/drivers/staging/iio/frequency/ad9850.c
+++ b/drivers/staging/iio/frequency/ad9850.c
@@ -39,7 +39,6 @@ static ssize_t ad9850_set_parameter(struct device *dev,
 					const char *buf,
 					size_t len)
 {
-	struct spi_message msg;
 	struct spi_transfer xfer;
 	int ret;
 	struct ad9850_config *config = (struct ad9850_config *)buf;
@@ -50,9 +49,7 @@ static ssize_t ad9850_set_parameter(struct device *dev,
 	xfer.tx_buf = config;
 	mutex_lock(&st->lock);
 
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfer, &msg);
-	ret = spi_sync(st->sdev, &msg);
+	ret = spi_sync_transfer(st->sdev, &xfer, 1);
 	if (ret)
 		goto error_ret;
 error_ret:
diff --git a/drivers/staging/iio/frequency/ad9852.c b/drivers/staging/iio/frequency/ad9852.c
index fd9d14a..cdb96c6 100644
--- a/drivers/staging/iio/frequency/ad9852.c
+++ b/drivers/staging/iio/frequency/ad9852.c
@@ -183,7 +183,6 @@ static IIO_DEVICE_ATTR(dds, S_IWUSR, NULL, ad9852_set_parameter, 0);
 
 static void ad9852_init(struct ad9852_state *st)
 {
-	struct spi_message msg;
 	struct spi_transfer xfer;
 	int ret;
 	u8 config[5];
@@ -199,9 +198,7 @@ static void ad9852_init(struct ad9852_state *st)
 	xfer.len = 5;
 	xfer.tx_buf = &config;
 
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfer, &msg);
-	ret = spi_sync(st->sdev, &msg);
+	ret = spi_sync_transfer(st->sdev, &xfer, 1);
 	if (ret)
 		goto error_ret;
 
diff --git a/drivers/staging/iio/gyro/adxrs450_core.c b/drivers/staging/iio/gyro/adxrs450_core.c
index d93527d..9cf755f 100644
--- a/drivers/staging/iio/gyro/adxrs450_core.c
+++ b/drivers/staging/iio/gyro/adxrs450_core.c
@@ -141,7 +141,6 @@ error_ret:
 static int adxrs450_spi_initial(struct adxrs450_state *st,
 		u32 *val, char chk)
 {
-	struct spi_message msg;
 	int ret;
 	struct spi_transfer xfers = {
 		.tx_buf = st->tx,
@@ -157,9 +156,7 @@ static int adxrs450_spi_initial(struct adxrs450_state *st,
 	st->tx[3] = 0;
 	if (chk)
 		st->tx[3] |= (ADXRS450_CHK | ADXRS450_P);
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfers, &msg);
-	ret = spi_sync(st->us, &msg);
+	ret = spi_sync_transfer(st->us, &xfers, 1);
 	if (ret) {
 		dev_err(&st->us->dev, "Problem while reading initializing data\n");
 		goto error_ret;
diff --git a/drivers/staging/iio/meter/ade7753.c b/drivers/staging/iio/meter/ade7753.c
index 8b9eceb..7169d27 100644
--- a/drivers/staging/iio/meter/ade7753.c
+++ b/drivers/staging/iio/meter/ade7753.c
@@ -103,7 +103,6 @@ static int ade7753_spi_read_reg_24(struct device *dev,
 		u8 reg_address,
 		u32 *val)
 {
-	struct spi_message msg;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ade7753_state *st = iio_priv(indio_dev);
 	int ret;
@@ -122,10 +121,7 @@ static int ade7753_spi_read_reg_24(struct device *dev,
 	mutex_lock(&st->buf_lock);
 	st->tx[0] = ADE7753_READ_REG(reg_address);
 
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfers[0], &msg);
-	spi_message_add_tail(&xfers[1], &msg);
-	ret = spi_sync(st->us, &msg);
+	ret = spi_sync_transfer(st->us, xfers, ARRAY_SIZE(xfers));
 	if (ret) {
 		dev_err(&st->us->dev, "problem when reading 24 bit register 0x%02X",
 				reg_address);
diff --git a/drivers/staging/iio/meter/ade7754.c b/drivers/staging/iio/meter/ade7754.c
index 76e0ade..6ffe311 100644
--- a/drivers/staging/iio/meter/ade7754.c
+++ b/drivers/staging/iio/meter/ade7754.c
@@ -103,7 +103,6 @@ static int ade7754_spi_read_reg_24(struct device *dev,
 		u8 reg_address,
 		u32 *val)
 {
-	struct spi_message msg;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ade7754_state *st = iio_priv(indio_dev);
 	int ret;
@@ -122,9 +121,7 @@ static int ade7754_spi_read_reg_24(struct device *dev,
 	st->tx[2] = 0;
 	st->tx[3] = 0;
 
-	spi_message_init(&msg);
-	spi_message_add_tail(xfers, &msg);
-	ret = spi_sync(st->us, &msg);
+	ret = spi_sync_transfer(st->us, xfers, ARRAY_SIZE(xfers));
 	if (ret) {
 		dev_err(&st->us->dev, "problem when reading 24 bit register 0x%02X",
 				reg_address);
diff --git a/drivers/staging/iio/meter/ade7758_core.c b/drivers/staging/iio/meter/ade7758_core.c
index a0fef77..609e679 100644
--- a/drivers/staging/iio/meter/ade7758_core.c
+++ b/drivers/staging/iio/meter/ade7758_core.c
@@ -47,7 +47,6 @@ static int ade7758_spi_write_reg_16(struct device *dev,
 		u16 value)
 {
 	int ret;
-	struct spi_message msg;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ade7758_state *st = iio_priv(indio_dev);
 	struct spi_transfer xfers[] = {
@@ -63,9 +62,7 @@ static int ade7758_spi_write_reg_16(struct device *dev,
 	st->tx[1] = (value >> 8) & 0xFF;
 	st->tx[2] = value & 0xFF;
 
-	spi_message_init(&msg);
-	spi_message_add_tail(xfers, &msg);
-	ret = spi_sync(st->us, &msg);
+	ret = spi_sync_transfer(st->us, xfers, ARRAY_SIZE(xfers));
 	mutex_unlock(&st->buf_lock);
 
 	return ret;
@@ -76,7 +73,6 @@ static int ade7758_spi_write_reg_24(struct device *dev,
 		u32 value)
 {
 	int ret;
-	struct spi_message msg;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ade7758_state *st = iio_priv(indio_dev);
 	struct spi_transfer xfers[] = {
@@ -93,9 +89,7 @@ static int ade7758_spi_write_reg_24(struct device *dev,
 	st->tx[2] = (value >> 8) & 0xFF;
 	st->tx[3] = value & 0xFF;
 
-	spi_message_init(&msg);
-	spi_message_add_tail(xfers, &msg);
-	ret = spi_sync(st->us, &msg);
+	ret = spi_sync_transfer(st->us, xfers, ARRAY_SIZE(xfers));
 	mutex_unlock(&st->buf_lock);
 
 	return ret;
@@ -105,7 +99,6 @@ int ade7758_spi_read_reg_8(struct device *dev,
 		u8 reg_address,
 		u8 *val)
 {
-	struct spi_message msg;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ade7758_state *st = iio_priv(indio_dev);
 	int ret;
@@ -128,10 +121,7 @@ int ade7758_spi_read_reg_8(struct device *dev,
 	st->tx[0] = ADE7758_READ_REG(reg_address);
 	st->tx[1] = 0;
 
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfers[0], &msg);
-	spi_message_add_tail(&xfers[1], &msg);
-	ret = spi_sync(st->us, &msg);
+	ret = spi_sync_transfer(st->us, xfers, ARRAY_SIZE(xfers));
 	if (ret) {
 		dev_err(&st->us->dev, "problem when reading 8 bit register 0x%02X",
 				reg_address);
@@ -148,7 +138,6 @@ static int ade7758_spi_read_reg_16(struct device *dev,
 		u8 reg_address,
 		u16 *val)
 {
-	struct spi_message msg;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ade7758_state *st = iio_priv(indio_dev);
 	int ret;
@@ -173,10 +162,7 @@ static int ade7758_spi_read_reg_16(struct device *dev,
 	st->tx[1] = 0;
 	st->tx[2] = 0;
 
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfers[0], &msg);
-	spi_message_add_tail(&xfers[1], &msg);
-	ret = spi_sync(st->us, &msg);
+	ret = spi_sync_transfer(st->us, xfers, ARRAY_SIZE(xfers));
 	if (ret) {
 		dev_err(&st->us->dev, "problem when reading 16 bit register 0x%02X",
 				reg_address);
@@ -194,7 +180,6 @@ static int ade7758_spi_read_reg_24(struct device *dev,
 		u8 reg_address,
 		u32 *val)
 {
-	struct spi_message msg;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ade7758_state *st = iio_priv(indio_dev);
 	int ret;
@@ -219,10 +204,7 @@ static int ade7758_spi_read_reg_24(struct device *dev,
 	st->tx[2] = 0;
 	st->tx[3] = 0;
 
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfers[0], &msg);
-	spi_message_add_tail(&xfers[1], &msg);
-	ret = spi_sync(st->us, &msg);
+	ret = spi_sync_transfer(st->us, xfers, ARRAY_SIZE(xfers));
 	if (ret) {
 		dev_err(&st->us->dev, "problem when reading 24 bit register 0x%02X",
 				reg_address);
diff --git a/drivers/staging/iio/meter/ade7759.c b/drivers/staging/iio/meter/ade7759.c
index cb0707c..7d1e76b 100644
--- a/drivers/staging/iio/meter/ade7759.c
+++ b/drivers/staging/iio/meter/ade7759.c
@@ -103,7 +103,6 @@ static int ade7759_spi_read_reg_40(struct device *dev,
 		u8 reg_address,
 		u64 *val)
 {
-	struct spi_message msg;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ade7759_state *st = iio_priv(indio_dev);
 	int ret;
@@ -120,9 +119,7 @@ static int ade7759_spi_read_reg_40(struct device *dev,
 	st->tx[0] = ADE7759_READ_REG(reg_address);
 	memset(&st->tx[1], 0 , 5);
 
-	spi_message_init(&msg);
-	spi_message_add_tail(xfers, &msg);
-	ret = spi_sync(st->us, &msg);
+	ret = spi_sync_transfer(st->us, xfers, ARRAY_SIZE(xfers));
 	if (ret) {
 		dev_err(&st->us->dev, "problem when reading 40 bit register 0x%02X",
 				reg_address);
diff --git a/drivers/staging/iio/meter/ade7854-spi.c b/drivers/staging/iio/meter/ade7854-spi.c
index 7dae035..be83f98 100644
--- a/drivers/staging/iio/meter/ade7854-spi.c
+++ b/drivers/staging/iio/meter/ade7854-spi.c
@@ -20,7 +20,6 @@ static int ade7854_spi_write_reg_8(struct device *dev,
 		u8 value)
 {
 	int ret;
-	struct spi_message msg;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ade7854_state *st = iio_priv(indio_dev);
 	struct spi_transfer xfer = {
@@ -35,9 +34,7 @@ static int ade7854_spi_write_reg_8(struct device *dev,
 	st->tx[2] = reg_address & 0xFF;
 	st->tx[3] = value & 0xFF;
 
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfer, &msg);
-	ret = spi_sync(st->spi, &msg);
+	ret = spi_sync_transfer(st->spi, &xfer, 1);
 	mutex_unlock(&st->buf_lock);
 
 	return ret;
@@ -48,7 +45,6 @@ static int ade7854_spi_write_reg_16(struct device *dev,
 		u16 value)
 {
 	int ret;
-	struct spi_message msg;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ade7854_state *st = iio_priv(indio_dev);
 	struct spi_transfer xfer = {
@@ -64,9 +60,7 @@ static int ade7854_spi_write_reg_16(struct device *dev,
 	st->tx[3] = (value >> 8) & 0xFF;
 	st->tx[4] = value & 0xFF;
 
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfer, &msg);
-	ret = spi_sync(st->spi, &msg);
+	ret = spi_sync_transfer(st->spi, &xfer, 1);
 	mutex_unlock(&st->buf_lock);
 
 	return ret;
@@ -77,7 +71,6 @@ static int ade7854_spi_write_reg_24(struct device *dev,
 		u32 value)
 {
 	int ret;
-	struct spi_message msg;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ade7854_state *st = iio_priv(indio_dev);
 	struct spi_transfer xfer = {
@@ -94,9 +87,7 @@ static int ade7854_spi_write_reg_24(struct device *dev,
 	st->tx[4] = (value >> 8) & 0xFF;
 	st->tx[5] = value & 0xFF;
 
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfer, &msg);
-	ret = spi_sync(st->spi, &msg);
+	ret = spi_sync_transfer(st->spi, &xfer, 1);
 	mutex_unlock(&st->buf_lock);
 
 	return ret;
@@ -107,7 +98,6 @@ static int ade7854_spi_write_reg_32(struct device *dev,
 		u32 value)
 {
 	int ret;
-	struct spi_message msg;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ade7854_state *st = iio_priv(indio_dev);
 	struct spi_transfer xfer = {
@@ -125,9 +115,7 @@ static int ade7854_spi_write_reg_32(struct device *dev,
 	st->tx[5] = (value >> 8) & 0xFF;
 	st->tx[6] = value & 0xFF;
 
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfer, &msg);
-	ret = spi_sync(st->spi, &msg);
+	ret = spi_sync_transfer(st->spi, &xfer, 1);
 	mutex_unlock(&st->buf_lock);
 
 	return ret;
@@ -137,7 +125,6 @@ static int ade7854_spi_read_reg_8(struct device *dev,
 		u16 reg_address,
 		u8 *val)
 {
-	struct spi_message msg;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ade7854_state *st = iio_priv(indio_dev);
 	int ret;
@@ -159,10 +146,7 @@ static int ade7854_spi_read_reg_8(struct device *dev,
 	st->tx[1] = (reg_address >> 8) & 0xFF;
 	st->tx[2] = reg_address & 0xFF;
 
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfers[0], &msg);
-	spi_message_add_tail(&xfers[1], &msg);
-	ret = spi_sync(st->spi, &msg);
+	ret = spi_sync_transfer(st->spi, xfers, ARRAY_SIZE(xfers));
 	if (ret) {
 		dev_err(&st->spi->dev, "problem when reading 8 bit register 0x%02X",
 				reg_address);
@@ -179,7 +163,6 @@ static int ade7854_spi_read_reg_16(struct device *dev,
 		u16 reg_address,
 		u16 *val)
 {
-	struct spi_message msg;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ade7854_state *st = iio_priv(indio_dev);
 	int ret;
@@ -200,10 +183,7 @@ static int ade7854_spi_read_reg_16(struct device *dev,
 	st->tx[1] = (reg_address >> 8) & 0xFF;
 	st->tx[2] = reg_address & 0xFF;
 
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfers[0], &msg);
-	spi_message_add_tail(&xfers[1], &msg);
-	ret = spi_sync(st->spi, &msg);
+	ret = spi_sync_transfer(st->spi, xfers, ARRAY_SIZE(xfers));
 	if (ret) {
 		dev_err(&st->spi->dev, "problem when reading 16 bit register 0x%02X",
 				reg_address);
@@ -220,7 +200,6 @@ static int ade7854_spi_read_reg_24(struct device *dev,
 		u16 reg_address,
 		u32 *val)
 {
-	struct spi_message msg;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ade7854_state *st = iio_priv(indio_dev);
 	int ret;
@@ -242,10 +221,7 @@ static int ade7854_spi_read_reg_24(struct device *dev,
 	st->tx[1] = (reg_address >> 8) & 0xFF;
 	st->tx[2] = reg_address & 0xFF;
 
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfers[0], &msg);
-	spi_message_add_tail(&xfers[1], &msg);
-	ret = spi_sync(st->spi, &msg);
+	ret = spi_sync_transfer(st->spi, xfers, ARRAY_SIZE(xfers));
 	if (ret) {
 		dev_err(&st->spi->dev, "problem when reading 24 bit register 0x%02X",
 				reg_address);
@@ -262,7 +238,6 @@ static int ade7854_spi_read_reg_32(struct device *dev,
 		u16 reg_address,
 		u32 *val)
 {
-	struct spi_message msg;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ade7854_state *st = iio_priv(indio_dev);
 	int ret;
@@ -284,10 +259,7 @@ static int ade7854_spi_read_reg_32(struct device *dev,
 	st->tx[1] = (reg_address >> 8) & 0xFF;
 	st->tx[2] = reg_address & 0xFF;
 
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfers[0], &msg);
-	spi_message_add_tail(&xfers[1], &msg);
-	ret = spi_sync(st->spi, &msg);
+	ret = spi_sync_transfer(st->spi, xfers, ARRAY_SIZE(xfers));
 	if (ret) {
 		dev_err(&st->spi->dev, "problem when reading 32 bit register 0x%02X",
 				reg_address);
diff --git a/drivers/staging/iio/resolver/ad2s1210.c b/drivers/staging/iio/resolver/ad2s1210.c
index 4ba4d05..a1f36ea 100644
--- a/drivers/staging/iio/resolver/ad2s1210.c
+++ b/drivers/staging/iio/resolver/ad2s1210.c
@@ -130,15 +130,12 @@ static int ad2s1210_config_read(struct ad2s1210_state *st,
 		.rx_buf = st->rx,
 		.tx_buf = st->tx,
 	};
-	struct spi_message msg;
 	int ret = 0;
 
 	ad2s1210_set_mode(MOD_CONFIG, st);
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfer, &msg);
 	st->tx[0] = address | AD2S1210_MSB_IS_HIGH;
 	st->tx[1] = AD2S1210_REG_FAULT;
-	ret = spi_sync(st->sdev, &msg);
+	ret = spi_sync_transfer(st->sdev, &xfer, 1);
 	if (ret < 0)
 		return ret;
 	st->old_data = true;
-- 
1.8.0

