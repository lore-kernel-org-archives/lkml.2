Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab2CLIAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 04:00:06 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61973 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab2CLH77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 03:59:59 -0400
Message-ID: <1331539194.13086.4.camel@phoenix>
Subject: [PATCH RFC/RFT 2/2] regulator: Convert tps6507x to set_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 12 Mar 2012 15:59:54 +0800
In-Reply-To: <1331539070.13086.2.camel@phoenix>
References: <1331539070.13086.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6507x-regulator.c |   31 +++++--------------------------
 1 files changed, 5 insertions(+), 26 deletions(-)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index e140a15..832833f 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -328,12 +328,11 @@ static int tps6507x_pmic_get_voltage(struct regulator_dev *dev)
 	return tps->info[rid]->table[data] * 1000;
 }
 
-static int tps6507x_pmic_set_voltage(struct regulator_dev *dev,
-					  int min_uV, int max_uV,
-					  unsigned *selector)
+static int tps6507x_pmic_set_voltage_sel(struct regulator_dev *dev,
+					  unsigned selector)
 {
 	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
-	int data, vsel, rid = rdev_get_id(dev);
+	int data, rid = rdev_get_id(dev);
 	u8 reg, mask;
 
 	switch (rid) {
@@ -367,32 +366,12 @@ static int tps6507x_pmic_set_voltage(struct regulator_dev *dev,
 		return -EINVAL;
 	}
 
-	if (min_uV < tps->info[rid]->min_uV || min_uV > tps->info[rid]->max_uV)
-		return -EINVAL;
-	if (max_uV < tps->info[rid]->min_uV || max_uV > tps->info[rid]->max_uV)
-		return -EINVAL;
-
-	for (vsel = 0; vsel < tps->info[rid]->table_len; vsel++) {
-		int mV = tps->info[rid]->table[vsel];
-		int uV = mV * 1000;
-
-		/* Break at the first in-range value */
-		if (min_uV <= uV && uV <= max_uV)
-			break;
-	}
-
-	/* write to the register in case we found a match */
-	if (vsel == tps->info[rid]->table_len)
-		return -EINVAL;
-
-	*selector = vsel;
-
 	data = tps6507x_pmic_reg_read(tps, reg);
 	if (data < 0)
 		return data;
 
 	data &= ~mask;
-	data |= vsel;
+	data |= selector;
 
 	return tps6507x_pmic_reg_write(tps, reg, data);
 }
@@ -417,7 +396,7 @@ static struct regulator_ops tps6507x_pmic_ops = {
 	.enable = tps6507x_pmic_enable,
 	.disable = tps6507x_pmic_disable,
 	.get_voltage = tps6507x_pmic_get_voltage,
-	.set_voltage = tps6507x_pmic_set_voltage,
+	.set_voltage_sel = tps6507x_pmic_set_voltage_sel,
 	.list_voltage = tps6507x_pmic_list_voltage,
 };
 
-- 
1.7.5.4



