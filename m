Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab2FRCLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 22:11:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40120 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab2FRCLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 22:11:39 -0400
Message-ID: <1339985488.11918.3.camel@phoenix>
Subject: [PATCH RFC] regulator: core: Support table based mapping in
 regulator_set_voltage_time_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yadwinder Singh Brar <yadi.brar01@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 18 Jun 2012 10:11:28 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For table based mapping, we can calculate voltage difference by below equation:
abs(rdev->desc->volt_table[new_selector] - rdev->desc->volt_table[old_selector])

Thus we can make regulator_set_voltage_time_sel work for table based mapping.

regulator_set_voltage_time_sel() only supports linear or table based mapping.
In case it is misused, also warn if neither linear nor table based mapping
is used with regulator_set_voltage_time_sel().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c9a427b..bf0306f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2305,25 +2305,38 @@ EXPORT_SYMBOL_GPL(regulator_set_voltage_time);
  * Provided with the starting and target voltage selectors, this function
  * returns time in microseconds required to rise or fall to this new voltage
  *
- * Drivers providing uV_step in their regulator_desc and ramp_delay in
- * regulation_constraints can use this as their set_voltage_time_sel()
- * operation.
+ * Drivers providing uV_step or volt_table in their regulator_desc and
+ * ramp_delay in regulation_constraints can use this as their
+ * set_voltage_time_sel() operation.
  */
 int regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 				   unsigned int old_selector,
 				   unsigned int new_selector)
 {
-	if (rdev->desc->uV_step) {
-		if (rdev->constraints->ramp_delay)
-			return DIV_ROUND_UP(rdev->desc->uV_step *
-				abs(new_selector - old_selector),
-				rdev->constraints->ramp_delay * 1000);
-		if (rdev->desc->ramp_delay)
-			return DIV_ROUND_UP(rdev->desc->uV_step *
-				abs(new_selector - old_selector),
-				rdev->desc->ramp_delay * 1000);
+	unsigned int ramp_delay = 0;
+
+	if (rdev->constraints->ramp_delay)
+		ramp_delay = rdev->constraints->ramp_delay;
+	else if (rdev->desc->ramp_delay)
+		ramp_delay = rdev->desc->ramp_delay;
+
+	if (ramp_delay == 0) {
 		rdev_warn(rdev, "ramp_delay not set\n");
+		return 0;
 	}
+
+	if (rdev->desc->uV_step) {
+		return DIV_ROUND_UP(rdev->desc->uV_step *
+				    abs(new_selector - old_selector),
+				    ramp_delay * 1000);
+	} else if (rdev->desc->volt_table) {
+		return DIV_ROUND_UP(abs(rdev->desc->volt_table[new_selector] -
+					rdev->desc->volt_table[old_selector]),
+				    ramp_delay * 1000);
+	} else {
+		rdev_warn(rdev, "Unsupported voltage mapping settings\n");
+	}
+
 	return 0;
 }
 
-- 
1.7.9.5



