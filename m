Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab2LRBaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:30:21 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:35620 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab2LRBaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:30:20 -0500
Message-ID: <1355794210.5681.1.camel@phoenix>
Subject: [PATCH 1/4] regulator: core: Allow specify apply_[reg|bit] for
 regmap based voltage_sel operations
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Mike Rapoport <mike@compulab.co.il>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 18 Dec 2012 09:30:10 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some DVM regulators needs to update apply_bit after setting vsel_reg to
initiate voltage change on the output.  This patch adds apply_reg and
apply_bit to struct regulator_desc and update
regulator_set_voltage_sel_regmap() to set apply_bit of apply_reg when
apply_bit is set.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/core.c         |   12 +++++++++++-
 include/linux/regulator/driver.h |    6 ++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a35858e..9afcdda3 100644
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
+	if (rdev->desc->apply_bit)
+		ret = regmap_update_bits(rdev->regmap, rdev->desc->apply_reg,
+					 rdev->desc->apply_bit,
+					 rdev->desc->apply_bit);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_set_voltage_sel_regmap);
 
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index d10bb0f..23070fd 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -193,6 +193,10 @@ enum regulator_type {
  *
  * @vsel_reg: Register for selector when using regulator_regmap_X_voltage_
  * @vsel_mask: Mask for register bitfield used for selector
+ * @apply_reg: Register for initiate voltage change on the output when
+ *                using regulator_set_voltage_sel_regmap
+ * @apply_bit: Register bitfield used for initiate voltage change on the
+ *                output when using regulator_set_voltage_sel_regmap
  * @enable_reg: Register for control when using regmap enable/disable ops
  * @enable_mask: Mask for control when using regmap enable/disable ops
  *
@@ -218,6 +222,8 @@ struct regulator_desc {
 
 	unsigned int vsel_reg;
 	unsigned int vsel_mask;
+	unsigned int apply_reg;
+	unsigned int apply_bit;
 	unsigned int enable_reg;
 	unsigned int enable_mask;
 	unsigned int bypass_reg;
-- 
1.7.9.5



