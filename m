Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030421Ab2CNCUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:20:08 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58161 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965208Ab2CNCUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:20:06 -0400
Message-ID: <1331691601.3782.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: Simplify implementation of
 tps65912_get_voltage_dcdc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 14 Mar 2012 10:20:01 +0800
In-Reply-To: <1331691525.3782.2.camel@phoenix>
References: <1331691525.3782.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call tps65912_get_sel_register instead of duplicating the same code.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65912-regulator.c |   31 +++++--------------------------
 1 files changed, 5 insertions(+), 26 deletions(-)

diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index 988d0ec..b36799b 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -409,34 +409,13 @@ static int tps65912_get_voltage_dcdc(struct regulator_dev *dev)
 	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
 	struct tps65912 *mfd = pmic->mfd;
 	int id = rdev_get_id(dev);
-	int opvsel = 0, avsel = 0, sr, vsel;
+	int reg, vsel;
 
-	switch (id) {
-	case TPS65912_REG_DCDC1:
-		opvsel = tps65912_reg_read(mfd, TPS65912_DCDC1_OP);
-		avsel = tps65912_reg_read(mfd, TPS65912_DCDC1_AVS);
-		break;
-	case TPS65912_REG_DCDC2:
-		opvsel = tps65912_reg_read(mfd, TPS65912_DCDC2_OP);
-		avsel = tps65912_reg_read(mfd, TPS65912_DCDC2_AVS);
-		break;
-	case TPS65912_REG_DCDC3:
-		opvsel = tps65912_reg_read(mfd, TPS65912_DCDC3_OP);
-		avsel = tps65912_reg_read(mfd, TPS65912_DCDC3_AVS);
-		break;
-	case TPS65912_REG_DCDC4:
-		opvsel = tps65912_reg_read(mfd, TPS65912_DCDC4_OP);
-		avsel = tps65912_reg_read(mfd, TPS65912_DCDC4_AVS);
-		break;
-	default:
-		return -EINVAL;
-	}
+	reg = tps65912_get_sel_register(pmic, id);
+	if (reg < 0)
+		return reg;
 
-	sr = (opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT;
-	if (sr)
-		vsel = avsel;
-	else
-		vsel = opvsel;
+	vsel = tps65912_reg_read(mfd, reg);
 	vsel &= 0x3F;
 
 	return tps65912_list_voltage_dcdc(dev, vsel);
-- 
1.7.5.4



