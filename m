Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab2GNFhX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 01:37:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37143 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab2GNFhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 01:37:21 -0400
Message-ID: <1342244233.4207.1.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: twl: Fix checking voltage range in
 twl6030smps_set_voltage()
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rajendra Nayak <rnayak@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Sat, 14 Jul 2012 13:37:13 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The voltage selection logic is supposed to find the samllest voltage falls
within specified range. When using equation to calculate vsel, we need to
ensure the requested min_uV meet the range of using the equation.
Otherwise we may select a voltage that is out of specified range.

For example, in the case vsel = 62 means select voltage of 2100000uV.
What we want is to ensure the requested min_uV <= 2100000 rather than checking
max_uV >= 2100000. And this also means in the case min_uV > 2100000, vsel = 62
does not meet the request.

Also calling twl6030smps_list_voltage() for all cases to ensure the selected
voltage still in bounds.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/twl-regulator.c |   36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 8f0bd56..03d0bea 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -760,32 +760,28 @@ twl6030smps_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 			unsigned int *selector)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
-	int	vsel = 0;
+	int vsel = 0, calc_uV;
 
 	switch (info->flags) {
 	case 0:
 		if (min_uV == 0)
 			vsel = 0;
 		else if ((min_uV >= 600000) && (min_uV <= 1300000)) {
-			int calc_uV;
 			vsel = DIV_ROUND_UP(min_uV - 600000, 12500);
 			vsel++;
-			calc_uV = twl6030smps_list_voltage(rdev, vsel);
-			if (calc_uV > max_uV)
-				return -EINVAL;
 		}
 		/* Values 1..57 for vsel are linear and can be calculated
 		 * values 58..62 are non linear.
 		 */
-		else if ((min_uV > 1900000) && (max_uV >= 2100000))
+		else if ((min_uV > 1900000) && (min_uV <= 2100000))
 			vsel = 62;
-		else if ((min_uV > 1800000) && (max_uV >= 1900000))
+		else if ((min_uV > 1800000) && (min_uV <= 1900000))
 			vsel = 61;
-		else if ((min_uV > 1500000) && (max_uV >= 1800000))
+		else if ((min_uV > 1500000) && (min_uV <= 1800000))
 			vsel = 60;
-		else if ((min_uV > 1350000) && (max_uV >= 1500000))
+		else if ((min_uV > 1350000) && (min_uV <= 1500000))
 			vsel = 59;
-		else if ((min_uV > 1300000) && (max_uV >= 1350000))
+		else if ((min_uV > 1300000) && (min_uV <= 1350000))
 			vsel = 58;
 		else
 			return -EINVAL;
@@ -794,25 +790,21 @@ twl6030smps_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 		if (min_uV == 0)
 			vsel = 0;
 		else if ((min_uV >= 700000) && (min_uV <= 1420000)) {
-			int calc_uV;
 			vsel = DIV_ROUND_UP(min_uV - 700000, 12500);
 			vsel++;
-			calc_uV = twl6030smps_list_voltage(rdev, vsel);
-			if (calc_uV > max_uV)
-				return -EINVAL;
 		}
 		/* Values 1..57 for vsel are linear and can be calculated
 		 * values 58..62 are non linear.
 		 */
-		else if ((min_uV > 1900000) && (max_uV >= 2100000))
+		else if ((min_uV > 1900000) && (min_uV <= 2100000))
 			vsel = 62;
-		else if ((min_uV > 1800000) && (max_uV >= 1900000))
+		else if ((min_uV > 1800000) && (min_uV <= 1900000))
 			vsel = 61;
-		else if ((min_uV > 1350000) && (max_uV >= 1800000))
+		else if ((min_uV > 1350000) && (min_uV <= 1800000))
 			vsel = 60;
-		else if ((min_uV > 1350000) && (max_uV >= 1500000))
+		else if ((min_uV > 1350000) && (min_uV <= 1500000))
 			vsel = 59;
-		else if ((min_uV > 1300000) && (max_uV >= 1350000))
+		else if ((min_uV > 1300000) && (min_uV <= 1350000))
 			vsel = 58;
 		else
 			return -EINVAL;
@@ -828,13 +820,17 @@ twl6030smps_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 	case SMPS_OFFSET_EN|SMPS_EXTENDED_EN:
 		if (min_uV == 0) {
 			vsel = 0;
-		} else if ((min_uV >= 2161000) && (max_uV <= 4321000)) {
+		} else if ((min_uV >= 2161000) && (min_uV <= 4321000)) {
 			vsel = DIV_ROUND_UP(min_uV - 2161000, 38600);
 			vsel++;
 		}
 		break;
 	}
 
+	calc_uV = twl6030smps_list_voltage(rdev, vsel);
+	if (calc_uV > max_uV)
+		return -EINVAL;
+
 	*selector = vsel;
 
 	return twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_VOLTAGE_SMPS,
-- 
1.7.9.5



