Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab1FITWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:22:39 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55587 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1FITWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:22:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rwvOdHhL8Iozfw8g3NYdhpXri17raKjGTIVby+RLfcOdNr9wUITo0dPn8ErwXEKjE6
         HC79x/Ll3i4EoLYCTe4WxTMOnYKUbyrlnA0DdcObBQC7nDcW1qBHfUaGpGBhwUzRBNjP
         mUfSjeP96itvhauTfTD0vWgpVyfEqLEQMfOiY=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 07/13] i2c-designware: move i2c functionality bit field to be adapter specific
Date: Thu,  9 Jun 2011 12:21:44 -0700
Message-Id: <1307647310-24332-8-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1307647310-24332-1-git-send-email-dirk.brandewie@gmail.com>
References: <1307647310-24332-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

The functionality of the adapter depends on the configuration of the
IP block at silicon compile time and is adapter specific.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
---
 drivers/i2c/busses/i2c-designware-core.c    |    8 ++------
 drivers/i2c/busses/i2c-designware-core.h    |    1 +
 drivers/i2c/busses/i2c-designware-platdrv.c |    8 ++++++++
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index d3b71f2..3c9f7cc 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -457,12 +457,8 @@ done:
 
 u32 i2c_dw_func(struct i2c_adapter *adap)
 {
-	return	I2C_FUNC_I2C |
-		I2C_FUNC_10BIT_ADDR |
-		I2C_FUNC_SMBUS_BYTE |
-		I2C_FUNC_SMBUS_BYTE_DATA |
-		I2C_FUNC_SMBUS_WORD_DATA |
-		I2C_FUNC_SMBUS_I2C_BLOCK;
+	struct dw_i2c_dev *dev = i2c_get_adapdata(adap);
+	return dev->functionality;
 }
 
 static u32 i2c_dw_read_clear_intrbits(struct dw_i2c_dev *dev)
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index 43de340..ab4e655 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -182,6 +182,7 @@ struct dw_i2c_dev {
 	int			irq;
 	int			swab;
 	struct i2c_adapter	adapter;
+	u32			functionality;
 	unsigned int		tx_fifo_depth;
 	unsigned int		rx_fifo_depth;
 };
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 08783a6..36db7a8 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -96,6 +96,14 @@ static int __devinit dw_i2c_probe(struct platform_device *pdev)
 	}
 	clk_enable(dev->clk);
 
+	dev->functionality =
+		I2C_FUNC_I2C |
+		I2C_FUNC_10BIT_ADDR |
+		I2C_FUNC_SMBUS_BYTE |
+		I2C_FUNC_SMBUS_BYTE_DATA |
+		I2C_FUNC_SMBUS_WORD_DATA |
+		I2C_FUNC_SMBUS_I2C_BLOCK;
+
 	dev->base = ioremap(mem->start, resource_size(mem));
 	if (dev->base == NULL) {
 		dev_err(&pdev->dev, "failure mapping io resources\n");
-- 
1.7.3.4

