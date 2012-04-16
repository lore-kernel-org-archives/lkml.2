Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174Ab2DPEIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 00:08:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:60756 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2DPEIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 00:08:37 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: ldewangan@nvidia.com
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] mfd: fix modular builds of rc5t583 regulator support
Date: Mon, 16 Apr 2012 00:08:21 -0400
Message-Id: <1334549301-32114-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The combination of commit 1b1247dd75aa5cf5fae54a3bec7280046e9c7957

    "mfd: Add support for RICOH PMIC RC5T583"

and commit 6ffc3270210efa2bea526953a142ffc908f5bd86

    "regulator: Add support for RICOH PMIC RC5T583 regulator"

are causing the i386 allmodconfig builds to fail with this:

  ERROR: "rc5t583_update" [drivers/regulator/rc5t583-regulator.ko] undefined!
  ERROR: "rc5t583_set_bits" [drivers/regulator/rc5t583-regulator.ko] undefined!
  ERROR: "rc5t583_clear_bits" [drivers/regulator/rc5t583-regulator.ko] undefined!
  ERROR: "rc5t583_read" [drivers/regulator/rc5t583-regulator.ko] undefined!

and this:

  ERROR: "rc5t583_ext_power_req_config" [drivers/regulator/rc5t583-regulator.ko] undefined!

For the 1st four, make the simple ops static inline, instead of
polluting the namespace with trivial exports.  For the last one,
add an EXPORT_SYMBOL.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[ alternately, make REGULATOR_RC5T583 bool instead of tristate? ]

diff --git a/drivers/mfd/rc5t583.c b/drivers/mfd/rc5t583.c
index 99ef944..44afae0 100644
--- a/drivers/mfd/rc5t583.c
+++ b/drivers/mfd/rc5t583.c
@@ -80,44 +80,6 @@ static struct mfd_cell rc5t583_subdevs[] = {
 	{.name = "rc5t583-key",      }
 };
 
-int rc5t583_write(struct device *dev, uint8_t reg, uint8_t val)
-{
-	struct rc5t583 *rc5t583 = dev_get_drvdata(dev);
-	return regmap_write(rc5t583->regmap, reg, val);
-}
-
-int rc5t583_read(struct device *dev, uint8_t reg, uint8_t *val)
-{
-	struct rc5t583 *rc5t583 = dev_get_drvdata(dev);
-	unsigned int ival;
-	int ret;
-	ret = regmap_read(rc5t583->regmap, reg, &ival);
-	if (!ret)
-		*val = (uint8_t)ival;
-	return ret;
-}
-
-int rc5t583_set_bits(struct device *dev, unsigned int reg,
-			unsigned int bit_mask)
-{
-	struct rc5t583 *rc5t583 = dev_get_drvdata(dev);
-	return regmap_update_bits(rc5t583->regmap, reg, bit_mask, bit_mask);
-}
-
-int rc5t583_clear_bits(struct device *dev, unsigned int reg,
-			unsigned int bit_mask)
-{
-	struct rc5t583 *rc5t583 = dev_get_drvdata(dev);
-	return regmap_update_bits(rc5t583->regmap, reg, bit_mask, 0);
-}
-
-int rc5t583_update(struct device *dev, unsigned int reg,
-		unsigned int val, unsigned int mask)
-{
-	struct rc5t583 *rc5t583 = dev_get_drvdata(dev);
-	return regmap_update_bits(rc5t583->regmap, reg, mask, val);
-}
-
 static int __rc5t583_set_ext_pwrreq1_control(struct device *dev,
 	int id, int ext_pwr, int slots)
 {
@@ -197,6 +159,7 @@ int rc5t583_ext_power_req_config(struct device *dev, int ds_id,
 			ds_id, ext_pwr_req);
 	return 0;
 }
+EXPORT_SYMBOL(rc5t583_ext_power_req_config);
 
 static int rc5t583_clear_ext_power_req(struct rc5t583 *rc5t583,
 	struct rc5t583_platform_data *pdata)
diff --git a/include/linux/mfd/rc5t583.h b/include/linux/mfd/rc5t583.h
index b2c1f44..c42fe92 100644
--- a/include/linux/mfd/rc5t583.h
+++ b/include/linux/mfd/rc5t583.h
@@ -26,6 +26,7 @@
 
 #include <linux/mutex.h>
 #include <linux/types.h>
+#include <linux/regmap.h>
 
 #define RC5T583_MAX_REGS		0xF8
 
@@ -308,14 +309,44 @@ struct rc5t583_platform_data {
 	struct regulator_init_data *reg_init_data[RC5T583_REGULATOR_MAX];
 };
 
-int rc5t583_write(struct device *dev, u8 reg, uint8_t val);
-int rc5t583_read(struct device *dev, uint8_t reg, uint8_t *val);
-int rc5t583_set_bits(struct device *dev, unsigned int reg,
-		unsigned int bit_mask);
-int rc5t583_clear_bits(struct device *dev, unsigned int reg,
-		unsigned int bit_mask);
-int rc5t583_update(struct device *dev, unsigned int reg,
-		unsigned int val, unsigned int mask);
+static inline int rc5t583_write(struct device *dev, uint8_t reg, uint8_t val)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(dev);
+	return regmap_write(rc5t583->regmap, reg, val);
+}
+
+static inline int rc5t583_read(struct device *dev, uint8_t reg, uint8_t *val)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(dev);
+	unsigned int ival;
+	int ret;
+	ret = regmap_read(rc5t583->regmap, reg, &ival);
+	if (!ret)
+		*val = (uint8_t)ival;
+	return ret;
+}
+
+static inline int rc5t583_set_bits(struct device *dev, unsigned int reg,
+			unsigned int bit_mask)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(dev);
+	return regmap_update_bits(rc5t583->regmap, reg, bit_mask, bit_mask);
+}
+
+static inline int rc5t583_clear_bits(struct device *dev, unsigned int reg,
+			unsigned int bit_mask)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(dev);
+	return regmap_update_bits(rc5t583->regmap, reg, bit_mask, 0);
+}
+
+static inline int rc5t583_update(struct device *dev, unsigned int reg,
+		unsigned int val, unsigned int mask)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(dev);
+	return regmap_update_bits(rc5t583->regmap, reg, mask, val);
+}
+
 int rc5t583_ext_power_req_config(struct device *dev, int deepsleep_id,
 	int ext_pwr_req, int deepsleep_slot_nr);
 int rc5t583_irq_init(struct rc5t583 *rc5t583, int irq, int irq_base);
-- 
1.7.9.1

