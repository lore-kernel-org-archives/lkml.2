Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab2L1JPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 04:15:12 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:54671 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2L1JPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 04:15:06 -0500
Message-ID: <1356686098.27172.6.camel@phoenix>
Subject: [PATCH 3/3] regulator: max8998: Return enough delay time for
 max8998_set_voltage_buck_time_sel
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Dec 2012 17:14:58 +0800
In-Reply-To: <1356685743.27172.2.camel@phoenix>
References: <1356685743.27172.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DIV_ROUND_UP to prevent truncation by integer division issue.
This ensures we return enough delay time.

Since the delay is required only if the voltage is increasing,
and we know both old_selector and new_selector.
We can check it earlier, for linear mapping, by simply compare
new_selector with old_selector.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max8998.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 06be8cc..26e5915 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -425,16 +425,17 @@ static int max8998_set_voltage_buck_time_sel(struct regulator_dev *rdev,
 {
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
 	struct i2c_client *i2c = max8998->iodev->i2c;
-	const struct voltage_map_desc *desc;
 	int buck = rdev_get_id(rdev);
 	u8 val = 0;
-	int difference, ret;
+	int ret;
+
+	/* Delay is required only if the voltage is increasing */
+	if (new_selector <= old_selector)
+		return 0;
 
 	if (buck < MAX8998_BUCK1 || buck > MAX8998_BUCK4)
 		return -EINVAL;
 
-	desc = ldo_voltage_map[buck];
-
 	/* Voltage stabilization */
 	ret = max8998_read_reg(i2c, MAX8998_REG_ONOFF4, &val);
 	if (ret)
@@ -445,11 +446,8 @@ static int max8998_set_voltage_buck_time_sel(struct regulator_dev *rdev,
 	if (max8998->iodev->type == TYPE_MAX8998 && !(val & MAX8998_ENRAMP))
 		return 0;
 
-	difference = (new_selector - old_selector) * desc->step / 1000;
-	if (difference > 0)
-		return difference / ((val & 0x0f) + 1);
-
-	return 0;
+	return DIV_ROUND_UP((new_selector - old_selector) * rdev->desc->uV_step,
+			    ((val & 0x0f) + 1) * 1000);
 }
 
 static struct regulator_ops max8998_ldo_ops = {
-- 
1.7.9.5



