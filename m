Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab1G1Gbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 02:31:36 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8573 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1G1Gbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 02:31:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 27 Jul 2011 23:31:31 -0700
From: wni@nvidia.com
To: sameo@linux.intel.com, mike@compulab.co.il, gking@nvidia.com,
        nkumbhar@nvidia.com
Cc: linux-kernel@vger.kernel.org, Wei Ni <wni@nvidia.com>
Subject: [PATCH] mfd: tps6586x: add api to power off tps6586x
Date: Thu, 28 Jul 2011 14:30:36 +0800
Message-Id: <1311834636-15940-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Ni <wni@nvidia.com>

Add an api to put tps6586x in sleep mode by resetting EXITSLREQ and
setting SLEEP_MODE in SUPPLYENE register. It will power off ldos.

Signed-off-by: Wei Ni <wni@nvidia.com>
Signed-off-by: Nitin Kumbhar <nkumbhar@nvidia.com>
---
 drivers/mfd/tps6586x.c       |   29 +++++++++++++++++++++++++++++
 include/linux/mfd/tps6586x.h |    1 +
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index bba26d9..d0eaa0a 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -27,6 +27,10 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps6586x.h>
 
+#define TPS6586X_SUPPLYENE	0x14
+#define EXITSLREQ_BIT		BIT(1) /* Exit sleep mode request */
+#define SLEEP_MODE_BIT		BIT(3) /* Sleep mode */
+
 /* GPIO control registers */
 #define TPS6586X_GPIOSET1	0x5d
 #define TPS6586X_GPIOSET2	0x5e
@@ -251,6 +255,29 @@ out:
 }
 EXPORT_SYMBOL_GPL(tps6586x_update);
 
+static struct i2c_client *tps6586x_i2c_client;
+int tps6586x_power_off(void)
+{
+	struct device *dev = NULL;
+	int ret = -EINVAL;
+
+	if (!tps6586x_i2c_client)
+		return ret;
+
+	dev = &tps6586x_i2c_client->dev;
+
+	ret = tps6586x_clr_bits(dev, TPS6586X_SUPPLYENE, EXITSLREQ_BIT);
+	if (ret)
+		return ret;
+
+	ret = tps6586x_set_bits(dev, TPS6586X_SUPPLYENE, SLEEP_MODE_BIT);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tps6586x_power_off);
+
 static int tps6586x_gpio_get(struct gpio_chip *gc, unsigned offset)
 {
 	struct tps6586x *tps6586x = container_of(gc, struct tps6586x, gpio);
@@ -525,6 +552,8 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
 		goto err_add_devs;
 	}
 
+	tps6586x_i2c_client = client;
+
 	return 0;
 
 err_add_devs:
diff --git a/include/linux/mfd/tps6586x.h b/include/linux/mfd/tps6586x.h
index b6bab1b..cfbf387 100644
--- a/include/linux/mfd/tps6586x.h
+++ b/include/linux/mfd/tps6586x.h
@@ -74,5 +74,6 @@ extern int tps6586x_set_bits(struct device *dev, int reg, uint8_t bit_mask);
 extern int tps6586x_clr_bits(struct device *dev, int reg, uint8_t bit_mask);
 extern int tps6586x_update(struct device *dev, int reg, uint8_t val,
 			   uint8_t mask);
+extern int tps6586x_power_off(void);
 
 #endif /*__LINUX_MFD_TPS6586X_H */
-- 
1.7.0

