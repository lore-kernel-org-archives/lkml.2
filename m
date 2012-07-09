Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab2GIDWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 23:22:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50736 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2GIDWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 23:22:42 -0400
Message-ID: <1341804151.14367.1.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: twl: Fix the formula to calculate vsel
 and voltage for twl6030ldo
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rajendra Nayak <rnayak@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 11:22:31 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In twl6030ldo_set_voltage, current code use below formula to calculate vsel:
        vsel = (min_uV/1000 - 1000)/100 + 1;
This is worng because when min_uV is 1000000 uV, vsel is 1.
It should be 0 in this case.
Fix it by change the equation to: (This equation is common for linear mapping)
        vsel = DIV_ROUND_UP(min_uV - rdev->desc->min_uV, rdev->desc->uV_step);

In twl6030ldo_get_voltage, current code use below formula to calculate voltage:
        mV = 1000mv + 100mv * (vsel - 1)
This is worng because when vsel is 0, mV is 900mV. Note the min_uV is 1000mV.
Fix it by change the equation to: (This equation is common for linear mapping)
        return rdev->desc->min_uV + vsel * rdev->desc->uV_step;

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/twl-regulator.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 8f0bd56..bb51dec 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -569,30 +569,21 @@ twl6030ldo_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 	if ((min_uV/1000 < info->min_mV) || (max_uV/1000 > info->max_mV))
 		return -EDOM;
 
-	/*
-	 * Use the below formula to calculate vsel
-	 * mV = 1000mv + 100mv * (vsel - 1)
-	 */
-	vsel = (min_uV/1000 - 1000)/100 + 1;
+	vsel = DIV_ROUND_UP(min_uV - rdev->desc->min_uV, rdev->desc->uV_step);
 	*selector = vsel;
-	return twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_VOLTAGE, vsel);
 
+	return twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_VOLTAGE, vsel);
 }
 
 static int twl6030ldo_get_voltage(struct regulator_dev *rdev)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
-	int		vsel = twlreg_read(info, TWL_MODULE_PM_RECEIVER,
-								VREG_VOLTAGE);
+	int vsel = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_VOLTAGE);
 
 	if (vsel < 0)
 		return vsel;
 
-	/*
-	 * Use the below formula to calculate vsel
-	 * mV = 1000mv + 100mv * (vsel - 1)
-	 */
-	return (1000 + (100 * (vsel - 1))) * 1000;
+	return rdev->desc->min_uV + vsel * rdev->desc->uV_step;
 }
 
 static struct regulator_ops twl6030ldo_ops = {
-- 
1.7.9.5



