Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab2LMIoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 03:44:20 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64330 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab2LMIoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 03:44:19 -0500
Message-ID: <1355388248.31434.3.camel@phoenix>
Subject: [RFC/RFT][PATCH 1/4] regulator: core: Allow specify
 activate_[reg|bit] for regmap based voltage_sel operations
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Mike Rapoport <mike@compulab.co.il>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Dec 2012 16:44:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some DVM regulators needs to update activate_bit after setting vsel_reg to
initiate voltage change on the output.  This patch adds activate_reg and
activate_bit to struct regulator_desc and update
regulator_set_voltage_sel_regmap() to set activate_bit of activate_reg when
activate_bit is set.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/core.c         |   12 +++++++++++-
 include/linux/regulator/driver.h |    6 ++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 0f65b24..2021086 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2074,10 +2074,20 @@ EXPORT_SYMBOL_GPL(regulator_get_voltage_sel_regmap);
  */
 int regulator_set_voltage_sel_regmap(struct regulator_dev *rdev, unsigned sel)
 {
+	int ret;
+
 	sel <<= ffs(rdev->desc->vsel_mask) - 1;
 
-	return regmap_update_bits(rdev->regmap, rdev->desc->vsel_reg,
+	ret = regmap_update_bits(rdev->regmap, rdev->desc->vsel_reg,
 				  rdev->desc->vsel_mask, sel);
+	if (ret)
+		return ret;
+
+	if (rdev->desc->activate_bit)
+		ret = regmap_update_bits(rdev->regmap, rdev->desc->activate_reg,
+					 rdev->desc->activate_bit,
+					 rdev->desc->activate_bit);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_set_voltage_sel_regmap);
 
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index d10bb0f..ba5a535 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -193,6 +193,10 @@ enum regulator_type {
  *
  * @vsel_reg: Register for selector when using regulator_regmap_X_voltage_
  * @vsel_mask: Mask for register bitfield used for selector
+ * @activate_reg: Register for initiate voltage change on the output when
+ *                using regulator_set_voltage_sel_regmap
+ * @activate_bit: Register bitfield used for initiate voltage change on the
+ *                output when using regulator_set_voltage_sel_regmap
  * @enable_reg: Register for control when using regmap enable/disable ops
  * @enable_mask: Mask for control when using regmap enable/disable ops
  *
@@ -218,6 +222,8 @@ struct regulator_desc {
 
 	unsigned int vsel_reg;
 	unsigned int vsel_mask;
+	unsigned int activate_reg;
+	unsigned int activate_bit;
 	unsigned int enable_reg;
 	unsigned int enable_mask;
 	unsigned int bypass_reg;
-- 
1.7.9.5



