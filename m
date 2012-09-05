Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327Ab2IET4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:56:15 -0400
Received: from mail-yx0-f202.google.com ([209.85.213.202]:34757 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab2IET4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:56:11 -0400
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-iio@vger.kernel.org, grundler@chromium.org, ldewangan@nvidia.com,
        lars@metafoo.de, gregkh@linuxfoundation.org, jic23@cam.ac.uk,
        Bryan Freed <bfreed@chromium.org>
Subject: [PATCH] iio: isl29018: Support fractional ALS scaling.
Date: Wed,  5 Sep 2012 12:55:53 -0700
Message-Id: <1346874953-22353-1-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Industrial IO framework supports scaling ADC values by fractions,
but most drivers default to using whole numbers.
This change turns on fractional scaling in the isl29018 driver.

Signed-off-by: Bryan Freed <bfreed@chromium.org>
---
 drivers/staging/iio/light/isl29018.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
index 31d22f5..6ee5567 100644
--- a/drivers/staging/iio/light/isl29018.c
+++ b/drivers/staging/iio/light/isl29018.c
@@ -63,6 +63,7 @@ struct isl29018_chip {
 	struct regmap		*regmap;
 	struct mutex		lock;
 	unsigned int		lux_scale;
+	unsigned int		lux_uscale;
 	unsigned int		range;
 	unsigned int		adc_bit;
 	int			prox_scheme;
@@ -145,13 +146,22 @@ static int isl29018_read_sensor_input(struct isl29018_chip *chip, int mode)
 static int isl29018_read_lux(struct isl29018_chip *chip, int *lux)
 {
 	int lux_data;
+	unsigned int data_x_range, lux_unshifted;
 
 	lux_data = isl29018_read_sensor_input(chip, COMMMAND1_OPMODE_ALS_ONCE);
 
 	if (lux_data < 0)
 		return lux_data;
 
-	*lux = (lux_data * chip->range * chip->lux_scale) >> chip->adc_bit;
+	/* To support fractional scaling, separate the unshifted lux
+	 * into two calculations: int scaling and micro-scaling.
+	 * lux_uscale ranges from 0-999999, so about 20 bits.  Split
+	 * the /1,000,000 in two to reduce the risk of over/underflow.
+	 */
+	data_x_range = lux_data * chip->range;
+	lux_unshifted = data_x_range * chip->lux_scale;
+	lux_unshifted += data_x_range / 1000 * chip->lux_uscale / 1000;
+	*lux = lux_unshifted >> chip->adc_bit;
 
 	return 0;
 }
@@ -339,6 +349,8 @@ static int isl29018_write_raw(struct iio_dev *indio_dev,
 	mutex_lock(&chip->lock);
 	if (mask == IIO_CHAN_INFO_CALIBSCALE && chan->type == IIO_LIGHT) {
 		chip->lux_scale = val;
+		/* With no write_raw_get_fmt(), val2 is a MICRO fraction. */
+		chip->lux_uscale = val2;
 		ret = 0;
 	}
 	mutex_unlock(&chip->lock);
@@ -379,7 +391,8 @@ static int isl29018_read_raw(struct iio_dev *indio_dev,
 	case IIO_CHAN_INFO_CALIBSCALE:
 		if (chan->type == IIO_LIGHT) {
 			*val = chip->lux_scale;
-			ret = IIO_VAL_INT;
+			*val2 = chip->lux_uscale;
+			ret = IIO_VAL_INT_PLUS_MICRO;
 		}
 		break;
 	default:
-- 
1.7.7.3

