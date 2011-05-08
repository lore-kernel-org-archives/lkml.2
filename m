Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab1EHXbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 19:31:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34098 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755682Ab1EHXa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 19:30:56 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Support voltage offsets to compensate for drops in system
Date: Sun,  8 May 2011 22:13:37 +0100
Message-Id: <1304889217-12319-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some systems, particularly physically large systems used for early
prototyping, may experience substantial voltage drops between the regulator
and the consumers as a result of long traces in the system. With these
systems voltages may need to be set higher than requested in order to
ensure reliable system operation.

Allow systems to work around such hardware issues by allowing constraints
to supply an offset to be applied to any requested and reported voltages.
This is not ideal, especially since the voltage drop may be load dependant,
but is sufficient for most affected systems, it is not expected to be used
in production hardware. The offset is applied after all constraint
processing so constraints should be specified in terms of consumer values
not physically configured values.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c          |   15 ++++++++++++---
 include/linux/regulator/machine.h |    4 ++++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a2728a4..b483efa 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -724,6 +724,10 @@ static void print_constraints(struct regulator_dev *rdev)
 			count += sprintf(buf + count, "at %d mV ", ret / 1000);
 	}
 
+	if (constraints->uV_offset)
+		count += sprintf(buf, "%dmV offset ",
+				 constraints->uV_offset / 1000);
+
 	if (constraints->min_uA && constraints->max_uA) {
 		if (constraints->min_uA == constraints->max_uA)
 			count += sprintf(buf + count, "%d mA ",
@@ -1640,6 +1644,9 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 
 	trace_regulator_set_voltage(rdev_get_name(rdev), min_uV, max_uV);
 
+	min_uV += rdev->constraints->uV_offset;
+	max_uV += rdev->constraints->uV_offset;
+
 	if (rdev->desc->ops->set_voltage) {
 		ret = rdev->desc->ops->set_voltage(rdev, min_uV, max_uV,
 						   &selector);
@@ -1864,18 +1871,20 @@ EXPORT_SYMBOL_GPL(regulator_sync_voltage);
 
 static int _regulator_get_voltage(struct regulator_dev *rdev)
 {
-	int sel;
+	int sel, ret;
 
 	if (rdev->desc->ops->get_voltage_sel) {
 		sel = rdev->desc->ops->get_voltage_sel(rdev);
 		if (sel < 0)
 			return sel;
-		return rdev->desc->ops->list_voltage(rdev, sel);
+		ret = rdev->desc->ops->list_voltage(rdev, sel);
 	}
 	if (rdev->desc->ops->get_voltage)
-		return rdev->desc->ops->get_voltage(rdev);
+		ret = rdev->desc->ops->get_voltage(rdev);
 	else
 		return -EINVAL;
+
+	return ret - rdev->constraints->uV_offset;
 }
 
 /**
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index c4c4fc4..598e08b 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -68,6 +68,8 @@ struct regulator_state {
  *
  * @min_uV: Smallest voltage consumers may set.
  * @max_uV: Largest voltage consumers may set.
+ * @uV_offset: Offset applied to voltages from consumer to compensate for
+ *             voltage drops.
  *
  * @min_uA: Smallest consumers consumers may set.
  * @max_uA: Largest current consumers may set.
@@ -99,6 +101,8 @@ struct regulation_constraints {
 	int min_uV;
 	int max_uV;
 
+	int uV_offset;
+
 	/* current output range (inclusive) - for current control */
 	int min_uA;
 	int max_uA;
-- 
1.7.4.1

