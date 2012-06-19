Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab2FSBix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 21:38:53 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44421 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab2FSBiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 21:38:51 -0400
Message-ID: <1340069925.7937.4.camel@phoenix>
Subject: [PATCH RFC] regulator: Use list_voltage() to get voltage in
 regulator_set_voltage_time_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yadwinder Singh Brar <yadi.brar01@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 19 Jun 2012 09:38:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this change, regulator_set_voltage_time_sel() can be more generic and not
limited to linear and table based mapping now.
One side-effect of this change is that list_voltage() must be implemented.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 8008c865..e207b21 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2303,8 +2303,7 @@ EXPORT_SYMBOL_GPL(regulator_set_voltage_time);
  * Provided with the starting and target voltage selectors, this function
  * returns time in microseconds required to rise or fall to this new voltage
  *
- * Drivers providing uV_step or volt_table in their regulator_desc and
- * ramp_delay in regulation_constraints can use this as their
+ * Drivers providing ramp_delay in regulation_constraints can use this as their
  * set_voltage_time_sel() operation.
  */
 int regulator_set_voltage_time_sel(struct regulator_dev *rdev,
@@ -2312,6 +2311,7 @@ int regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 				   unsigned int new_selector)
 {
 	unsigned int ramp_delay = 0;
+	int old_volt, new_volt;
 
 	if (rdev->constraints->ramp_delay)
 		ramp_delay = rdev->constraints->ramp_delay;
@@ -2323,19 +2323,14 @@ int regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 		return 0;
 	}
 
-	if (rdev->desc->uV_step) {
-		return DIV_ROUND_UP(rdev->desc->uV_step *
-				    abs(new_selector - old_selector),
-				    ramp_delay);
-	} else if (rdev->desc->volt_table) {
-		return DIV_ROUND_UP(abs(rdev->desc->volt_table[new_selector] -
-					rdev->desc->volt_table[old_selector]),
-				    ramp_delay);
-	} else {
-		rdev_warn(rdev, "Unsupported voltage mapping settings\n");
-	}
+	/* sanity check */
+	if (!rdev->desc->ops->list_voltage)
+		return -EINVAL;
 
-	return 0;
+	old_volt = rdev->desc->ops->list_voltage(rdev, old_selector);
+	new_volt = rdev->desc->ops->list_voltage(rdev, new_selector);
+
+	return DIV_ROUND_UP(abs(new_volt - old_volt), ramp_delay);
 }
 
 /**
-- 
1.7.9.5



