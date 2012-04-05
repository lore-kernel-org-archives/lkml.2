Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2DEGE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 02:04:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54756 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab2DEGE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 02:04:57 -0400
Message-ID: <1333605888.18055.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: rc5t583: Remove nsteps from struct
 rc5t583_regulator_info
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 05 Apr 2012 14:04:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nsteps can be calculated by (_max_mv - _min_mv) * 1000 / _step_uV + 1,
thus we can remove _nsteps from RC5T583_REG macro, and then remove
nsteps from struct rc5t583_regulator_info.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/rc5t583-regulator.c |   37 +++++++++++++++-----------------
 1 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/rc5t583-regulator.c b/drivers/regulator/rc5t583-regulator.c
index dc9ebb9..578bd5d 100644
--- a/drivers/regulator/rc5t583-regulator.c
+++ b/drivers/regulator/rc5t583-regulator.c
@@ -49,7 +49,6 @@ struct rc5t583_regulator_info {
 	int			min_uV;
 	int			max_uV;
 	int			step_uV;
-	int			nsteps;
 
 	/* Regulator specific turn-on delay  and voltage settling time*/
 	int			enable_uv_per_us;
@@ -131,7 +130,7 @@ static int rc5t583_set_voltage_sel(struct regulator_dev *rdev,
 	struct rc5t583_regulator *reg = rdev_get_drvdata(rdev);
 	struct rc5t583_regulator_info *ri = reg->reg_info;
 	int ret;
-	if (selector >= ri->nsteps) {
+	if (selector >= rdev->desc->n_voltages) {
 		dev_err(&rdev->dev, "Invalid selector 0x%02x\n", selector);
 		return -EINVAL;
 	}
@@ -198,8 +197,7 @@ static struct regulator_ops rc5t583_ops = {
 };
 
 #define RC5T583_REG(_id, _en_reg, _en_bit, _disc_reg, _disc_bit, _vout_reg,  \
-		_vout_mask, _ds_reg, _min_mv, _max_mv, _step_uV, _nsteps,    \
-		_enable_mv)					\
+		_vout_mask, _ds_reg, _min_mv, _max_mv, _step_uV, _enable_mv) \
 {								\
 	.reg_en_reg	= RC5T583_REG_##_en_reg,		\
 	.en_bit		= _en_bit,				\
@@ -211,14 +209,13 @@ static struct regulator_ops rc5t583_ops = {
 	.min_uV		= _min_mv * 1000,			\
 	.max_uV		= _max_mv * 1000,			\
 	.step_uV	= _step_uV,				\
-	.nsteps		= _nsteps,				\
 	.enable_uv_per_us = _enable_mv * 1000,			\
 	.change_uv_per_us = 40 * 1000,				\
 	.deepsleep_id	= RC5T583_DS_##_id,			\
 	.desc = {						\
 		.name = "rc5t583-regulator-"#_id,		\
 		.id = RC5T583_REGULATOR_##_id,			\
-		.n_voltages = _nsteps,				\
+		.n_voltages = (_max_mv - _min_mv) * 1000 / _step_uV + 1, \
 		.ops = &rc5t583_ops,				\
 		.type = REGULATOR_VOLTAGE,			\
 		.owner = THIS_MODULE,				\
@@ -227,33 +224,33 @@ static struct regulator_ops rc5t583_ops = {
 
 static struct rc5t583_regulator_info rc5t583_reg_info[RC5T583_REGULATOR_MAX] = {
 	RC5T583_REG(DC0, DC0CTL, 0, DC0CTL, 1, DC0DAC, 0x7F, DC0DAC_DS,
-			700, 1500, 12500, 0x41, 4),
+			700, 1500, 12500, 4),
 	RC5T583_REG(DC1, DC1CTL, 0, DC1CTL, 1, DC1DAC, 0x7F, DC1DAC_DS,
-			700, 1500, 12500, 0x41,  14),
+			700, 1500, 12500, 14),
 	RC5T583_REG(DC2, DC2CTL, 0, DC2CTL, 1, DC2DAC, 0x7F, DC2DAC_DS,
-			900, 2400, 12500, 0x79,  14),
+			900, 2400, 12500, 14),
 	RC5T583_REG(DC3, DC3CTL, 0, DC3CTL, 1, DC3DAC, 0x7F, DC3DAC_DS,
-			900, 2400, 12500, 0x79,  14),
+			900, 2400, 12500, 14),
 	RC5T583_REG(LDO0, LDOEN2, 0, LDODIS2, 0, LDO0DAC, 0x7F, LDO0DAC_DS,
-			900, 3400, 25000, 0x65,  160),
+			900, 3400, 25000, 160),
 	RC5T583_REG(LDO1, LDOEN2, 1, LDODIS2, 1, LDO1DAC, 0x7F, LDO1DAC_DS,
-			900, 3400, 25000, 0x65,  160),
+			900, 3400, 25000, 160),
 	RC5T583_REG(LDO2, LDOEN2, 2, LDODIS2, 2, LDO2DAC, 0x7F, LDO2DAC_DS,
-			900, 3400, 25000, 0x65,  160),
+			900, 3400, 25000, 160),
 	RC5T583_REG(LDO3, LDOEN2, 3, LDODIS2, 3, LDO3DAC, 0x7F, LDO3DAC_DS,
-			900, 3400, 25000, 0x65,  160),
+			900, 3400, 25000, 160),
 	RC5T583_REG(LDO4, LDOEN2, 4, LDODIS2, 4, LDO4DAC, 0x3F, LDO4DAC_DS,
-			750, 1500, 12500, 0x3D,  133),
+			750, 1500, 12500, 133),
 	RC5T583_REG(LDO5, LDOEN2, 5, LDODIS2, 5, LDO5DAC, 0x7F, LDO5DAC_DS,
-			900, 3400, 25000, 0x65,  267),
+			900, 3400, 25000, 267),
 	RC5T583_REG(LDO6, LDOEN2, 6, LDODIS2, 6, LDO6DAC, 0x7F, LDO6DAC_DS,
-			900, 3400, 25000, 0x65,  133),
+			900, 3400, 25000, 133),
 	RC5T583_REG(LDO7, LDOEN2, 7, LDODIS2, 7, LDO7DAC, 0x7F, LDO7DAC_DS,
-			900, 3400, 25000, 0x65,  233),
+			900, 3400, 25000, 233),
 	RC5T583_REG(LDO8, LDOEN1, 0, LDODIS1, 0, LDO8DAC, 0x7F, LDO8DAC_DS,
-			900, 3400, 25000, 0x65,  233),
+			900, 3400, 25000, 233),
 	RC5T583_REG(LDO9, LDOEN1, 1, LDODIS1, 1, LDO9DAC, 0x7F, LDO9DAC_DS,
-			900, 3400, 25000, 0x65,  133),
+			900, 3400, 25000, 133),
 };
 
 static int __devinit rc5t583_regulator_probe(struct platform_device *pdev)
-- 
1.7.5.4



