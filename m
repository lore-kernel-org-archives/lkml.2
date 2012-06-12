Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab2FLMIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:08:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59700 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab2FLMIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:08:38 -0400
Message-ID: <1339502910.2881.1.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: wm8350: Use wm8350_ldo_list_voltage
 instead of open code to verify selected voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 12 Jun 2012 20:08:30 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call wm8350_ldo_list_voltage() instead of open code to verify selected voltage
falls within specified range.
Use wm8350_ldo_list_voltage() here is less error prone.

wm8350_ldo_val_to_mvolts() is only used in wm8350_ldo_list_voltage now, so
remove it and move the implementation to wm8350_ldo_list_voltage().

This patch also include below small changes in wm8350_ldo_map_voltage:
1. wm8350_ldo_map_voltage() returns selector, thus rename variable mV to sel.
2. Use DIV_ROUND_UP macro to calculate selector.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8350-regulator.c |   52 ++++++++++++++--------------------
 1 file changed, 21 insertions(+), 31 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 53bf3df..c4913be 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -108,15 +108,6 @@ static int get_isink_val(int min_uA, int max_uA, u16 *setting)
 	return -EINVAL;
 }
 
-static inline int wm8350_ldo_val_to_mvolts(unsigned int val)
-{
-	if (val < 16)
-		return (val * 50) + 900;
-	else
-		return ((val - 16) * 100) + 1800;
-
-}
-
 static inline unsigned int wm8350_ldo_mvolts_to_val(int mV)
 {
 	if (mV < 1800)
@@ -671,10 +662,22 @@ static int wm8350_ldo_set_suspend_disable(struct regulator_dev *rdev)
 	return 0;
 }
 
+static int wm8350_ldo_list_voltage(struct regulator_dev *rdev,
+				    unsigned selector)
+{
+	if (selector > WM8350_LDO1_VSEL_MASK)
+		return -EINVAL;
+
+	if (selector < 16)
+		return (selector * 50000) + 900000;
+	else
+		return ((selector - 16) * 100000) + 1800000;
+}
+
 static int wm8350_ldo_map_voltage(struct regulator_dev *rdev, int min_uV,
 				  int max_uV)
 {
-	int mV;
+	int volt, sel;
 	int min_mV = min_uV / 1000;
 	int max_mV = max_uV / 1000;
 
@@ -683,29 +686,16 @@ static int wm8350_ldo_map_voltage(struct regulator_dev *rdev, int min_uV,
 	if (max_mV < 900 || max_mV > 3300)
 		return -EINVAL;
 
-	if (min_mV < 1800) {
-		/* step size is 50mV < 1800mV */
-		mV = (min_mV - 851) / 50;
-		if (wm8350_ldo_val_to_mvolts(mV) > max_mV)
-			return -EINVAL;
-		BUG_ON(wm8350_ldo_val_to_mvolts(mV) < min_mV);
-	} else {
-		/* step size is 100mV > 1800mV */
-		mV = ((min_mV - 1701) / 100) + 16;
-		if (wm8350_ldo_val_to_mvolts(mV) > max_mV)
-			return -EINVAL;
-		BUG_ON(wm8350_ldo_val_to_mvolts(mV) < min_mV);
-	}
-
-	return mV;
-}
+	if (min_mV < 1800) /* step size is 50mV < 1800mV */
+		sel = DIV_ROUND_UP(min_uV - 900, 50);
+	else /* step size is 100mV > 1800mV */
+		sel = DIV_ROUND_UP(min_uV - 1800, 100) + 16;
 
-static int wm8350_ldo_list_voltage(struct regulator_dev *rdev,
-				    unsigned selector)
-{
-	if (selector > WM8350_LDO1_VSEL_MASK)
+	volt = wm8350_ldo_list_voltage(rdev, sel);
+	if (volt < min_uV || volt > max_uV)
 		return -EINVAL;
-	return wm8350_ldo_val_to_mvolts(selector) * 1000;
+
+	return sel;
 }
 
 int wm8350_dcdc_set_slot(struct wm8350 *wm8350, int dcdc, u16 start,
-- 
1.7.9.5



