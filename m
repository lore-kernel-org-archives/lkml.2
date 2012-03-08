Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824Ab2CHNCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 08:02:47 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:45456 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757732Ab2CHNCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 08:02:31 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/4] mfd/ab8500: make use of the firmware read-modify-write service
Date: Thu, 8 Mar 2012 14:02:20 +0100
Message-ID: <1331211740-9871-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Nilsson <mattias.i.nilsson@stericsson.com>

This patch updates the AB8500 driver to make use of the I2C
read-modify-write service in the PRCMU firmware.

Signed-off-by: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Reviewed-by: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-core.c         |   37 +++++++++++++++++++++++--------------
 drivers/mfd/ab8500-i2c.c          |   15 ++++++++++++++-
 include/linux/mfd/abx500/ab8500.h |    6 ++++--
 3 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index c637c8d..1f08704 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -201,29 +201,38 @@ static int mask_and_set_register_interruptible(struct ab8500 *ab8500, u8 bank,
 	u8 reg, u8 bitmask, u8 bitvalues)
 {
 	int ret;
-	u8 data;
 	/* put the u8 bank and u8 reg together into a an u16.
 	 * bank on higher 8 bits and reg in lower */
 	u16 addr = ((u16)bank) << 8 | reg;
 
 	mutex_lock(&ab8500->lock);
 
-	ret = ab8500->read(ab8500, addr);
-	if (ret < 0) {
-		dev_err(ab8500->dev, "failed to read reg %#x: %d\n",
-			addr, ret);
-		goto out;
-	}
+	if (ab8500->write_masked == NULL) {
+		u8 data;
 
-	data = (u8)ret;
-	data = (~bitmask & data) | (bitmask & bitvalues);
+		ret = ab8500->read(ab8500, addr);
+		if (ret < 0) {
+			dev_err(ab8500->dev, "failed to read reg %#x: %d\n",
+				addr, ret);
+			goto out;
+		}
 
-	ret = ab8500->write(ab8500, addr, data);
-	if (ret < 0)
-		dev_err(ab8500->dev, "failed to write reg %#x: %d\n",
-			addr, ret);
+		data = (u8)ret;
+		data = (~bitmask & data) | (bitmask & bitvalues);
+
+		ret = ab8500->write(ab8500, addr, data);
+		if (ret < 0)
+			dev_err(ab8500->dev, "failed to write reg %#x: %d\n",
+				addr, ret);
 
-	dev_vdbg(ab8500->dev, "mask: addr %#x => data %#x\n", addr, data);
+		dev_vdbg(ab8500->dev, "mask: addr %#x => data %#x\n", addr,
+			data);
+		goto out;
+	}
+	ret = ab8500->write_masked(ab8500, addr, bitmask, bitvalues);
+	if (ret < 0)
+		dev_err(ab8500->dev, "failed to modify reg %#x: %d\n", addr,
+			ret);
 out:
 	mutex_unlock(&ab8500->lock);
 	return ret;
diff --git a/drivers/mfd/ab8500-i2c.c b/drivers/mfd/ab8500-i2c.c
index 70a16ae..b83045f 100644
--- a/drivers/mfd/ab8500-i2c.c
+++ b/drivers/mfd/ab8500-i2c.c
@@ -11,7 +11,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/abx500/ab8500.h>
-#include <linux/mfd/db8500-prcmu.h>
+#include <linux/mfd/dbx500-prcmu.h>
 
 static int ab8500_i2c_write(struct ab8500 *ab8500, u16 addr, u8 data)
 {
@@ -23,6 +23,18 @@ static int ab8500_i2c_write(struct ab8500 *ab8500, u16 addr, u8 data)
 	return ret;
 }
 
+static int ab8500_i2c_write_masked(struct ab8500 *ab8500, u16 addr, u8 mask,
+	u8 data)
+{
+	int ret;
+
+	ret = prcmu_abb_write_masked((u8)(addr >> 8), (u8)(addr & 0xFF), &data,
+		&mask, 1);
+	if (ret < 0)
+		dev_err(ab8500->dev, "prcmu i2c error %d\n", ret);
+	return ret;
+}
+
 static int ab8500_i2c_read(struct ab8500 *ab8500, u16 addr)
 {
 	int ret;
@@ -59,6 +71,7 @@ static int __devinit ab8500_i2c_probe(struct platform_device *plf)
 
 	ab8500->read = ab8500_i2c_read;
 	ab8500->write = ab8500_i2c_write;
+	ab8500->write_masked = ab8500_i2c_write_masked;
 
 	platform_set_drvdata(plf, ab8500);
 
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 78ed95b..3b551a1 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -217,6 +217,7 @@ enum ab8500_version {
  * @version: chip version id (e.g. ab8500 or ab9540)
  * @chip_id: chip revision id
  * @write: register write
+ * @write_masked: masked register write
  * @read: register read
  * @rx_buf: rx buf for SPI
  * @tx_buf: tx buf for SPI
@@ -236,8 +237,9 @@ struct ab8500 {
 	enum ab8500_version version;
 	u8		chip_id;
 
-	int (*write) (struct ab8500 *a8500, u16 addr, u8 data);
-	int (*read) (struct ab8500 *a8500, u16 addr);
+	int (*write)(struct ab8500 *ab8500, u16 addr, u8 data);
+	int (*write_masked)(struct ab8500 *ab8500, u16 addr, u8 mask, u8 data);
+	int (*read)(struct ab8500 *ab8500, u16 addr);
 
 	unsigned long	tx_buf[4];
 	unsigned long	rx_buf[4];
-- 
1.7.8

