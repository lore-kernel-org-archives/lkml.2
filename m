Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab1IGQMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:12:53 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:48731 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab1IGQLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:11:45 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 5/6] regmap-spi-adi generalize regmap_spi_read.
Date: Wed,  7 Sep 2011 17:19:46 +0100
Message-Id: <1315412387-5765-6-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <4E679770.4090008@cam.ac.uk>
References: <4E679770.4090008@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Complexity here is that we have to break the transers after every word
so that the chip select can go high.

Note this is NOT a burst read, but rather a interleaved
register read - there may well be better ways of doing this.

The burst read supported by for example the adis16400 is too odd
to fit well into regmap.
---
 drivers/base/regmap/regmap-spi-adi.c |   31 ++++++++++++++++++++++++++-----
 1 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/base/regmap/regmap-spi-adi.c b/drivers/base/regmap/regmap-spi-adi.c
index d4301cc..6b581fa 100644
--- a/drivers/base/regmap/regmap-spi-adi.c
+++ b/drivers/base/regmap/regmap-spi-adi.c
@@ -23,7 +23,7 @@ static int regmap_spi_write(struct device *dev, const void *data, size_t count)
 	int ret;
 	u8 *rawdata = (u8 *)data;
 
-	BUG_ON(count != 3);
+//	BUG_ON(count != 3);
 	/* Fiddling needed as the value is bigendian */
 	rawdata[0] = (rawdata[0] << 1) + 1;
 	ret = spi_write(spi, data, 2);
@@ -39,13 +39,34 @@ static int regmap_spi_read(struct device *dev,
 			   void *val, size_t val_size)
 {
 	struct spi_device *spi = to_spi_device(dev);
-	u8 *regraw = (u8 *)reg;
+	struct spi_transfer *xfers;
+	struct spi_message msg;
+	int i, ret;
+	u8 startreg = ((u8 *)reg)[0] << 1;
 
-	regraw[0] <<= 1;
+	/* Could keep a single register read special version */
+	xfers = kzalloc(sizeof(*xfers)*((val_size >> 1) + 1), GFP_KERNEL);
+	if (xfers == NULL)
+		return -ENOMEM;
+	
+	for (i = 0; i < val_size >> 1; i++) {
+		xfers[i].tx_buf = (u16 *)val + i;
+		((u8 *)val)[i*2] = startreg + 2*i;
+		((u8 *)val)[i*2 + 1] = 0;
+		xfers[i + 1].rx_buf = (u16 *)val + i;
+		xfers[i].bits_per_word = 8;
+		xfers[i].len = 2;
+	}
+	xfers[i].bits_per_word = 8;
+	xfers[i].len = 2;
+	spi_message_init(&msg);
+	for (i = 0; i < (val_size >> 1) + 1; i++)
+		spi_message_add_tail(&xfers[i], &msg);
 
-	BUG_ON(reg_size != 1 || val_size != 2);
+	ret = spi_sync(spi, &msg);
+	kfree(xfers);
 
-	return spi_write_then_read(spi, reg, 2, val, val_size);
+	return ret;
 }
 
 static struct regmap_bus regmap_spi_adi = {
-- 
1.7.3.4

