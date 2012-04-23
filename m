Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab2DWMbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:31:07 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:49872 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab2DWMbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:31:03 -0400
X-RZG-AUTH: :KXokZlStbvrPCC8w2n2KADUjx90tFpDbrwvi3rISAmCHBWiKTAoKIqY5gZEywA==
X-RZG-CLASS-ID: mo05
Message-Id: <201204231230.q3NCUbbP015327@gatekeeper.vosshq.de>
From: Nikolaus Voss <n.voss@weinmann.de>
Date: Mon, 23 Apr 2012 12:51:23 +0200
Subject: [PATCH] drivers/rtc/rtc-m41t93.c: don't let get_time() reset error state
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, grant.likely@secretlab.ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the rtc reports the time might be invalid due to oscillator
failure, this flags must not be reset by get_time() as the read
operation doesn't make the time valid.

Instead, the flag is reset in set_time() when a valid time is
to be written.

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
---
 drivers/rtc/rtc-m41t93.c |   46 +++++++++++++++++++++++++++-------------------
 1 files changed, 27 insertions(+), 19 deletions(-)

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

