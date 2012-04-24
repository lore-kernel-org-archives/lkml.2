Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab2DXW6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:58:47 -0400
Received: from 90-46-11-204.rar.beartech.net ([204.11.46.90]:12763 "EHLO
	exchsrvr.taosinc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932525Ab2DXW6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:58:44 -0400
Subject: [PATCH V9a] TAOS tsl2x7x
From: Jon Brenner <jbrenner@taosinc.com>
To: gregkh <gregkh@linuxfoundation.org>, Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-iio <linux-iio@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 24 Apr 2012 17:59:10 -0500
Message-ID: <1335308350.18759.3.camel@jonz-ub2>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TAOS (version 9a) tsl2x7x driver change / bug fix.

Fixed - removed decimal multiplications.
        Added missing 'static' declarations
        Fixed _read_raw case logic to allow reading of _PROCESSED IIO_LIGHT
	Replaced udelay with mdelay to accomodate eabi.

Signed-off-by: Jon Brenner <jbrenner@taosinc.com>
---
 drivers/staging/iio/light/tsl2x7x_core.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/iio/light/tsl2x7x_core.c b/drivers/staging/iio/light/tsl2x7x_core.c
index ff44989..f3fc85a 100755
--- a/drivers/staging/iio/light/tsl2x7x_core.c
+++ b/drivers/staging/iio/light/tsl2x7x_core.c
@@ -130,6 +130,8 @@
 		(IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_RISING) | \
 		IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_FALLING)),

+#define TSL2X7X_MIN_ITIME 3
+
 /* TAOS txx2x7x Device family members */
 enum {
 	tsl2571,
@@ -277,7 +279,7 @@ enum {
 	ALSPRX2,
 };

-const u8 device_channel_config[] = {
+static const u8 device_channel_config[] = {
 	ALS,
 	PRX,
 	PRX,
@@ -778,7 +780,7 @@ static int tsl2x7x_chip_on(struct iio_dev *indio_dev)
 		}
 	}

-	udelay(3000);	/* Power-on settling time */
+	mdelay(3);	/* Power-on settling time */

 	/* NOW enable the ADC
 	 * initialize the desired mode of operation */
@@ -853,6 +855,7 @@ static int tsl2x7x_chip_off(struct iio_dev *indio_dev)
  * put device back into proper state, and unlock
  * resource.
  */
+static
 int tsl2x7x_invoke_change(struct iio_dev *indio_dev)
 {
 	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
@@ -1021,7 +1024,7 @@ static ssize_t tsl2x7x_als_time_show(struct device *dev,
 	int y, z;

 	y = (TSL2X7X_MAX_TIMER_CNT - (u8)chip->tsl2x7x_settings.als_time) + 1;
-	z = y * 2.72;
+	z = y * TSL2X7X_MIN_ITIME;
 	y /= 1000;
 	z %= 1000;

@@ -1092,7 +1095,7 @@ static ssize_t tsl2x7x_als_persistence_show(struct device *dev,

 	/* Determine integration time */
 	y = (TSL2X7X_MAX_TIMER_CNT - (u8)chip->tsl2x7x_settings.als_time) + 1;
-	z = y * 2.72;
+	z = y * TSL2X7X_MIN_ITIME;
 	filter_delay = z * (chip->tsl2x7x_settings.persistence & 0x0F);
 	y = (filter_delay / 1000);
 	z = (filter_delay % 1000);
@@ -1114,7 +1117,7 @@ static ssize_t tsl2x7x_als_persistence_store(struct device *dev,

 	result.fract /= 1000;
 	y = (TSL2X7X_MAX_TIMER_CNT - (u8)chip->tsl2x7x_settings.als_time) + 1;
-	z = y * 2.72;
+	z = y * TSL2X7X_MIN_ITIME;

 	filter_delay =
 		DIV_ROUND_UP(((result.integer * 1000) + result.fract), z);
@@ -1138,7 +1141,7 @@ static ssize_t tsl2x7x_prox_persistence_show(struct device *dev,

 	/* Determine integration time */
 	y = (TSL2X7X_MAX_TIMER_CNT - (u8)chip->tsl2x7x_settings.prx_time) + 1;
-	z = y * 2.72;
+	z = y * TSL2X7X_MIN_ITIME;
 	filter_delay = z * ((chip->tsl2x7x_settings.persistence & 0xF0) >> 4);
 	y = (filter_delay / 1000);
 	z = (filter_delay % 1000);
@@ -1160,7 +1163,7 @@ static ssize_t tsl2x7x_prox_persistence_store(struct device *dev,

 	result.fract /= 1000;
 	y = (TSL2X7X_MAX_TIMER_CNT - (u8)chip->tsl2x7x_settings.prx_time) + 1;
-	z = y * 2.72;
+	z = y * TSL2X7X_MIN_ITIME;

 	filter_delay =
 		DIV_ROUND_UP(((result.integer * 1000) + result.fract), z);
@@ -1389,13 +1392,20 @@ static int tsl2x7x_read_raw(struct iio_dev *indio_dev,
 	struct tsl2X7X_chip *chip = iio_priv(indio_dev);

 	switch (mask) {
-	case IIO_CHAN_INFO_RAW:
+	case IIO_CHAN_INFO_PROCESSED:
 		switch (chan->type) {
 		case IIO_LIGHT:
 			tsl2x7x_get_lux(indio_dev);
 			*val = chip->als_cur_info.lux;
 			ret = IIO_VAL_INT;
 			break;
+		default:
+			return -EINVAL;
+			break;
+		}
+		break;
+	case IIO_CHAN_INFO_RAW:
+		switch (chan->type) {
 		case IIO_INTENSITY:
 			tsl2x7x_get_lux(indio_dev);
 			if (chan->channel == 0)
--
1.7.4.1

