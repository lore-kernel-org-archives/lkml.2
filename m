Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab2DXEwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 00:52:21 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:36478 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab2DXEwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 00:52:20 -0400
X-RZG-AUTH: :KXokZlStbvrPCC8w2n2KADUjx90tFpDbrwvi3rISAmCHBWiKTAoKIqY5gZEywA==
X-RZG-CLASS-ID: mo05
Message-Id: <201204240451.q3O4pWCG003918@gatekeeper.vosshq.de>
From: Nikolaus Voss <n.voss@weinmann.de>
Date: Mon, 23 Apr 2012 12:51:23 +0200
Subject: [PATCH v2] drivers/rtc/rtc-m41t93.c: don't let get_time() reset
 M41T93_FLAG_OF
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, grant.likely@secretlab.ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the rtc reports the time might be invalid due to oscillator
failure, M41T93_FLAG_OF flag must not be reset by get_time() as
the read operation doesn't make the time valid.

Without this patch, only the first get_time() reported an invalid
time, the second get_time() reported a valid time althought the
reported time is probably wrong due to oscillator failure.

Instead of resetting in get_time(), with this patch M41T93_FLAG_OF
is reset in set_time() when a valid time is to be written.

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
---
v2: better commit description

 drivers/i2c/busses/i2c-at91.c |    5 +--
 drivers/rtc/rtc-m41t93.c      |   46 ++++++++++++++++++++++++-----------------
 2 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index ca142c5..a6f9e73 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -115,14 +115,13 @@ static void __devinit at91_calc_twi_clock(struct at91_twi_dev *dev, int twi_clk)
 	const int div = max(0, (int)DIV_ROUND_UP(clk_get_rate(dev->clk),
 						 2 * twi_clk) - offset);
 	int ckdiv = fls(div >> 8);
-	int cdiv = div >> ckdiv;;
+	int cdiv = div >> ckdiv;
 
 	if (dev->is_rm9200 && (ckdiv > 5)) {
 		dev_warn(dev->dev, "AT91RM9200 erratum 22: using ckdiv = 5.\n");
 		ckdiv = 5;
 		cdiv = 255;
-	}
-	else if (ckdiv > 7) {
+	} else if (ckdiv > 7) {
 		dev_warn(dev->dev, "%d exceeds 3 bits for ckdiv, limiting.\n",
 			 ckdiv);
 		ckdiv = 7;
diff --git a/drivers/rtc/rtc-m41t93.c b/drivers/rtc/rtc-m41t93.c
index ef71132..f19f45c 100644
--- a/drivers/rtc/rtc-m41t93.c
+++ b/drivers/rtc/rtc-m41t93.c
@@ -48,6 +48,7 @@ static inline int m41t93_set_reg(struct spi_device *spi, u8 addr, u8 data)
 static int m41t93_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct spi_device *spi = to_spi_device(dev);
+	int tmp;
 	u8 buf[9] = {0x80};        /* write cmd + 8 data bytes */
 	u8 * const data = &buf[1]; /* ptr to first data byte */
 
@@ -62,6 +63,30 @@ static int m41t93_set_time(struct device *dev, struct rtc_time *tm)
 		return -EINVAL;
 	}
 
+	tmp = spi_w8r8(spi, M41T93_REG_FLAGS);
+	if (tmp < 0)
+		return tmp;
+
+	if (tmp & M41T93_FLAG_OF) {
+		dev_warn(&spi->dev, "OF bit is set, resetting.\n");
+		m41t93_set_reg(spi, M41T93_REG_FLAGS, tmp & ~M41T93_FLAG_OF);
+
+		tmp = spi_w8r8(spi, M41T93_REG_FLAGS);
+		if (tmp < 0) {
+			return tmp;
+		} else if (tmp & M41T93_FLAG_OF) {
+			/* OF cannot be immediately reset: oscillator has to be
+			 * restarted. */
+			u8 reset_osc = buf[M41T93_REG_ST_SEC] | M41T93_FLAG_ST;
+
+			dev_warn(&spi->dev,
+				 "OF bit is still set, kickstarting clock.\n");
+			m41t93_set_reg(spi, M41T93_REG_ST_SEC, reset_osc);
+			reset_osc &= ~M41T93_FLAG_ST;
+			m41t93_set_reg(spi, M41T93_REG_ST_SEC, reset_osc);
+		}
+	}
+
 	data[M41T93_REG_SSEC]		= 0;
 	data[M41T93_REG_ST_SEC]		= bin2bcd(tm->tm_sec);
 	data[M41T93_REG_MIN]		= bin2bcd(tm->tm_min);
@@ -89,10 +114,7 @@ static int m41t93_get_time(struct device *dev, struct rtc_time *tm)
 	   1. halt bit (HT) is set: the clock is running but update of readout
 	      registers has been disabled due to power failure. This is normal
 	      case after poweron. Time is valid after resetting HT bit.
-	   2. oscillator fail bit (OF) is set. Oscillator has be stopped and
-	      time is invalid:
-	      a) OF can be immeditely reset.
-	      b) OF cannot be immediately reset: oscillator has to be restarted.
+	   2. oscillator fail bit (OF) is set: time is invalid.
 	*/
 	tmp = spi_w8r8(spi, M41T93_REG_ALM_HOUR_HT);
 	if (tmp < 0)
@@ -110,21 +132,7 @@ static int m41t93_get_time(struct device *dev, struct rtc_time *tm)
 
 	if (tmp & M41T93_FLAG_OF) {
 		ret = -EINVAL;
-		dev_warn(&spi->dev, "OF bit is set, resetting.\n");
-		m41t93_set_reg(spi, M41T93_REG_FLAGS, tmp & ~M41T93_FLAG_OF);
-
-		tmp = spi_w8r8(spi, M41T93_REG_FLAGS);
-		if (tmp < 0)
-			return tmp;
-		else if (tmp & M41T93_FLAG_OF) {
-			u8 reset_osc = buf[M41T93_REG_ST_SEC] | M41T93_FLAG_ST;
-
-			dev_warn(&spi->dev,
-				 "OF bit is still set, kickstarting clock.\n");
-			m41t93_set_reg(spi, M41T93_REG_ST_SEC, reset_osc);
-			reset_osc &= ~M41T93_FLAG_ST;
-			m41t93_set_reg(spi, M41T93_REG_ST_SEC, reset_osc);
-		}
+		dev_warn(&spi->dev, "OF bit is set, write time to restart.\n");
 	}
 
 	if (tmp & M41T93_FLAG_BL)
-- 
1.7.5.4

