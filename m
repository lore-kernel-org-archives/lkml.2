Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab2K2B71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 20:59:27 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:61401 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2K2B70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 20:59:26 -0500
Message-ID: <1354154356.10511.2.camel@phoenix>
Subject: [RFT][PATCH 1/2] regulator: palmas: Return raw register values as
 the selectors in [get|set]_voltage_sel
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2012 09:59:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't adjust the selector in [get|set]_voltage_sel, fix it in list_voltage() instead.

For smps*(except smps10), the vsel reg-value and voltage mapping as below:

reg-value       volt (uV) ( Assume RANGE is x1 )
0               0
1               500000
2               500000
3               500000
4               500000
5               500000
6               500000 (0.49V + 1 * 0.01V) * RANGE
7               510000 (0.49V + 2 * 0.01V) * RANGE
8               520000 (0.49V + 3 * 0.01V) * RANGE
9               530000 (0.49V + 4 * 0.01V) * RANGE
....

The linear mapping is start from selector 6.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
hi Graeme,
I don't have this hardware, I'd appreciate if you can review and test this patch.
I think it should be no behavior change with these 2 patches.
Note I don't have the datasheet, the reg-value and voltage mapping is from
my understanding of the current code.

Regards,
Axel
 drivers/regulator/palmas-regulator.c |   38 +++++++++++++---------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index fd27a43..76eaafb 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -309,19 +309,22 @@ static int palmas_list_voltage_smps(struct regulator_dev *dev,
 	int id = rdev_get_id(dev);
 	int mult = 1;
 
-	if (!selector)
-		return 0;
-
 	/* Read the multiplier set in VSEL register to return
 	 * the correct voltage.
 	 */
 	if (pmic->range[id])
 		mult = 2;
 
-	/* Voltage is (0.49V + (selector * 0.01V)) * RANGE
-	 * as defined in data sheet. RANGE is either x1 or x2
-	 */
-	return  (490000 + (selector * 10000)) * mult;
+	if (selector == 0)
+		return 0;
+	else if (selector < 6)
+		return 500000 * mult;
+	else
+		/* Voltage is linear mapping starting from selector 6,
+		 * volt = (0.49V + ((selector - 5) * 0.01V)) * RANGE
+		 * RANGE is either x1 or x2
+		 */
+		return (490000 + ((selector - 5) * 10000)) * mult;
 }
 
 static int palmas_get_voltage_smps_sel(struct regulator_dev *dev)
@@ -338,15 +341,6 @@ static int palmas_get_voltage_smps_sel(struct regulator_dev *dev)
 
 	selector = reg & PALMAS_SMPS12_VOLTAGE_VSEL_MASK;
 
-	/* Adjust selector to match list_voltage ranges */
-	if ((selector > 0) && (selector < 6))
-		selector = 6;
-	if (!selector)
-		selector = 5;
-	if (selector > 121)
-		selector = 121;
-	selector -= 5;
-
 	return selector;
 }
 
@@ -355,19 +349,15 @@ static int palmas_set_voltage_smps_sel(struct regulator_dev *dev,
 {
 	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
 	int id = rdev_get_id(dev);
-	unsigned int reg = 0;
-	unsigned int addr;
+	unsigned int reg, addr;
 
 	addr = palmas_regs_info[id].vsel_addr;
+	reg = selector;
 
 	/* Make sure we don't change the value of RANGE */
 	if (pmic->range[id])
 		reg |= PALMAS_SMPS12_VOLTAGE_RANGE;
 
-	/* Adjust the linux selector into range used in VSEL register */
-	if (selector)
-		reg |= selector + 5;
-
 	palmas_smps_write(pmic->palmas, addr, reg);
 
 	return 0;
@@ -386,11 +376,11 @@ static int palmas_map_voltage_smps(struct regulator_dev *rdev,
 	if (pmic->range[id]) { /* RANGE is x2 */
 		if (min_uV < 1000000)
 			min_uV = 1000000;
-		ret = DIV_ROUND_UP(min_uV - 1000000, 20000) + 1;
+		ret = DIV_ROUND_UP(min_uV - 1000000, 20000) + 6;
 	} else {		/* RANGE is x1 */
 		if (min_uV < 500000)
 			min_uV = 500000;
-		ret = DIV_ROUND_UP(min_uV - 500000, 10000) + 1;
+		ret = DIV_ROUND_UP(min_uV - 500000, 10000) + 6;
 	}
 
 	/* Map back into a voltage to verify we're still in bounds */
-- 
1.7.9.5



