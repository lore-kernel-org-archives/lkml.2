Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030874Ab2HHVTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:19:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59528 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab2HHVTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:19:05 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 1/3] regulator: add always set/clear masks to regulator_enable_regmap
Date: Wed,  8 Aug 2012 15:18:45 -0600
Message-Id: <1344460727-6243-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Some regulators need some register bits set or cleared in order to place
them under software control. Add .en_dis_set_mask and .en_dis_clr_mask
fields to struct regulator_desc. These can't be part of the existing
.enable_mask field, whose bits are set when enabled and cleared when
disabled, since the bits in this field need to be set/cleard irrespective
of regulator state.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: New patch

 drivers/regulator/core.c         |   22 +++++++++++++++-------
 include/linux/regulator/driver.h |    4 ++++
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index b28221a..457be22 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1762,14 +1762,18 @@ EXPORT_SYMBOL_GPL(regulator_is_enabled_regmap);
  * @rdev: regulator to operate on
  *
  * Regulators that use regmap for their register I/O can set the
- * enable_reg and enable_mask fields in their descriptor and then use
- * this as their enable() operation, saving some code.
+ * enable_reg, enable_mask, en_dis_set_mask, and en_dis_clr_mask fields in
+ * their descriptor and then use this as their enable() operation, saving
+ * some code.
  */
 int regulator_enable_regmap(struct regulator_dev *rdev)
 {
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
-				  rdev->desc->enable_mask,
-				  rdev->desc->enable_mask);
+				  rdev->desc->enable_mask |
+				  rdev->desc->en_dis_set_mask |
+				  rdev->desc->en_dis_clr_mask,
+				  rdev->desc->enable_mask |
+				  rdev->desc->en_dis_set_mask);
 }
 EXPORT_SYMBOL_GPL(regulator_enable_regmap);
 
@@ -1779,13 +1783,17 @@ EXPORT_SYMBOL_GPL(regulator_enable_regmap);
  * @rdev: regulator to operate on
  *
  * Regulators that use regmap for their register I/O can set the
- * enable_reg and enable_mask fields in their descriptor and then use
- * this as their disable() operation, saving some code.
+ * enable_reg, enable_mask, en_dis_set_mask, and en_dis_clr_mask fields in
+ * their descriptor and then use this as their disable() operation, saving
+ * some code.
  */
 int regulator_disable_regmap(struct regulator_dev *rdev)
 {
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
-				  rdev->desc->enable_mask, 0);
+				  rdev->desc->enable_mask |
+				  rdev->desc->en_dis_set_mask |
+				  rdev->desc->en_dis_clr_mask,
+				  rdev->desc->en_dis_set_mask);
 }
 EXPORT_SYMBOL_GPL(regulator_disable_regmap);
 
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index bac4c87..2c40c86 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -182,6 +182,8 @@ enum regulator_type {
  * @vsel_mask: Mask for register bitfield used for selector
  * @enable_reg: Register for control when using regmap enable/disable ops
  * @enable_mask: Mask for control when using regmap enable/disable ops
+ * @en_dis_set_mask: Mask to always set when using regmap enable/disable ops
+ * @en_dis_clr_mask: Mask to always clear when using regmap enable/disable ops
  *
  * @enable_time: Time taken for initial enable of regulator (in uS).
  */
@@ -205,6 +207,8 @@ struct regulator_desc {
 	unsigned int vsel_mask;
 	unsigned int enable_reg;
 	unsigned int enable_mask;
+	unsigned int en_dis_set_mask;
+	unsigned int en_dis_clr_mask;
 
 	unsigned int enable_time;
 };
-- 
1.7.0.4

