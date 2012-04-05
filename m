Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab2DEGHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 02:07:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38494 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2DEGHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 02:07:41 -0400
Message-ID: <1333606056.18055.3.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: Convert rc5t583 to set_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 05 Apr 2012 14:07:36 +0800
In-Reply-To: <1333605888.18055.1.camel@phoenix>
References: <1333605888.18055.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not every regulator driver should implement set_voltage_sel callback.
See commit e8eef82
"regulator: Provide a selector based set_voltage_sel() operation".

For rc5t583, the regulator voltage can be mapped onto selector values with a
simple calculation, thus implement set_voltage is better than set_voltage_sel.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch also needs below patch to properly work.
https://lkml.org/lkml/2012/4/3/430

 drivers/regulator/rc5t583-regulator.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/rc5t583-regulator.c b/drivers/regulator/rc5t583-regulator.c
index 578bd5d..43c8410 100644
--- a/drivers/regulator/rc5t583-regulator.c
+++ b/drivers/regulator/rc5t583-regulator.c
@@ -124,19 +124,26 @@ static int rc5t583_list_voltage(struct regulator_dev *rdev, unsigned selector)
 	return ri->min_uV + (ri->step_uV * selector);
 }
 
-static int rc5t583_set_voltage_sel(struct regulator_dev *rdev,
-		unsigned int selector)
+static int rc5t583_set_voltage(struct regulator_dev *rdev,
+			       int min_uV, int max_uV, unsigned *selector)
 {
 	struct rc5t583_regulator *reg = rdev_get_drvdata(rdev);
 	struct rc5t583_regulator_info *ri = reg->reg_info;
-	int ret;
-	if (selector >= rdev->desc->n_voltages) {
-		dev_err(&rdev->dev, "Invalid selector 0x%02x\n", selector);
+	int sel, ret;
+
+	if (min_uV < ri->min_uV)
+		min_uV = ri->min_uV;
+
+	sel = DIV_ROUND_UP(min_uV - ri->min_uV, ri->step_uV);
+
+	if (sel >= rdev->desc->n_voltages) {
+		dev_err(&rdev->dev, "Invalid selector 0x%02x\n", sel);
 		return -EINVAL;
 	}
 
-	ret = rc5t583_update(reg->mfd->dev, ri->vout_reg,
-				selector, ri->vout_mask);
+	*selector = sel;
+
+	ret = rc5t583_update(reg->mfd->dev, ri->vout_reg, sel, ri->vout_mask);
 	if (ret < 0)
 		dev_err(&rdev->dev,
 		    "Error in update voltage register 0x%02x\n", ri->vout_reg);
@@ -191,7 +198,7 @@ static struct regulator_ops rc5t583_ops = {
 	.disable		= rc5t583_reg_disable,
 	.enable_time		= rc5t583_regulator_enable_time,
 	.get_voltage_sel	= rc5t583_get_voltage_sel,
-	.set_voltage_sel	= rc5t583_set_voltage_sel,
+	.set_voltage		= rc5t583_set_voltage,
 	.list_voltage		= rc5t583_list_voltage,
 	.set_voltage_time_sel	= rc5t583_set_voltage_time_sel,
 };
-- 
1.7.5.4



