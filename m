Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2FKMLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 08:11:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37599 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab2FKMLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 08:11:32 -0400
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH] regulator: Add ramp_delay to regulator constraints to get used as a configurable parameter.
Date: Mon, 11 Jun 2012 17:41:08 +0530
Message-Id: <1339416668-17028-1-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some hardwares ramp_delay for BUCKs is a configurable parameter which can
be configured through DT or board file.This patch adds ramp_delay to regulator
constraints and allow user to configure it for regulators which supports this
feature, through DT or board file. It will provide two ways of setting the
ramp_delay for a regulator:
	First, by setting it as constraints in board file(for configurable
regulators) and set_machine_constraints() will take care of setting it on
hardware by calling(the provided) .set_ramp_delay() operation(callback).
	Second, by setting it as data in regulator_desc(as fixed/default
ramp_delay rate) for a regulator in driver.

regulator_set_voltage_time_sel() will give preference to
constraints->ramp_delay while reading ramp_delay rate for regulator. Similarly
users should also take care accordingly while refering ramp_delay rate(in case
of implementing their private .set_voltage_time_sel() callbacks for different
regulators).

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 .../devicetree/bindings/regulator/regulator.txt    |    1 +
 drivers/regulator/core.c                           |   23 ++++++++++++++++---
 drivers/regulator/of_regulator.c                   |    6 ++++-
 include/linux/regulator/driver.h                   |    3 ++
 include/linux/regulator/machine.h                  |    3 ++
 5 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index 5b7a408..d0a7b12 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -10,6 +10,7 @@ Optional properties:
 - regulator-always-on: boolean, regulator should never be disabled
 - regulator-boot-on: bootloader/firmware enabled regulator
 - <name>-supply: phandle to the parent supply/regulator node
+- regulator-ramp-delay: ramp delay for regulator(in mV/uS)
 
 Example:
 
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 63507a5..0ffd917 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -967,6 +967,14 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 		}
 	}
 
+	if (rdev->constraints->ramp_delay && ops->set_ramp_delay) {
+		ret = ops->set_ramp_delay(rdev, rdev->constraints->ramp_delay);
+		if (ret < 0) {
+			rdev_err(rdev, "failed to set ramp_delay\n");
+			goto out;
+		}
+	}
+
 	print_constraints(rdev);
 	return 0;
 out:
@@ -2305,10 +2313,17 @@ int regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 				   unsigned int old_selector,
 				   unsigned int new_selector)
 {
-	if (rdev->desc->ramp_delay && rdev->desc->uV_step)
-		return DIV_ROUND_UP(rdev->desc->uV_step *
-			abs(new_selector - old_selector),
-			rdev->desc->ramp_delay * 1000);
+	if (rdev->desc->uV_step) {
+		if (rdev->constraints->ramp_delay)
+			return DIV_ROUND_UP(rdev->desc->uV_step *
+				abs(new_selector - old_selector),
+				rdev->constraints->ramp_delay * 1000);
+		if (rdev->desc->ramp_delay)
+			return DIV_ROUND_UP(rdev->desc->uV_step *
+				abs(new_selector - old_selector),
+				rdev->desc->ramp_delay * 1000);
+		rdev_warn(rdev, "ramp_delay not set\n");
+	}
 	return 0;
 }
 
diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 56593b7..e2a7310 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -20,7 +20,7 @@ static void of_get_regulation_constraints(struct device_node *np,
 					struct regulator_init_data **init_data)
 {
 	const __be32 *min_uV, *max_uV, *uV_offset;
-	const __be32 *min_uA, *max_uA;
+	const __be32 *min_uA, *max_uA, *ramp_delay;
 	struct regulation_constraints *constraints = &(*init_data)->constraints;
 
 	constraints->name = of_get_property(np, "regulator-name", NULL);
@@ -60,6 +60,10 @@ static void of_get_regulation_constraints(struct device_node *np,
 		constraints->always_on = true;
 	else /* status change should be possible if not always on. */
 		constraints->valid_ops_mask |= REGULATOR_CHANGE_STATUS;
+
+	ramp_delay = of_get_property(np, "regulator-ramp-delay", NULL);
+	if (ramp_delay)
+		constraints->min_uV = be32_to_cpu(*ramp_delay);
 }
 
 /**
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index ae5c253..ddc155d 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -67,6 +67,8 @@ enum regulator_status {
  *
  * @enable_time: Time taken for the regulator voltage output voltage to
  *               stabilise after being enabled, in microseconds.
+ * @set_ramp_delay: Set the ramp delay for the regulator. The driver should
+ *		select ramp delay equal to or less than(closest) ramp_delay.
  * @set_voltage_time_sel: Time taken for the regulator voltage output voltage
  *               to stabilise after being set to a new value, in microseconds.
  *               The function provides the from and to voltage selector, the
@@ -113,6 +115,7 @@ struct regulator_ops {
 
 	/* Time taken to enable or set voltage on the regulator */
 	int (*enable_time) (struct regulator_dev *);
+	int (*set_ramp_delay) (struct regulator_dev *, int ramp_delay);
 	int (*set_voltage_time_sel) (struct regulator_dev *,
 				     unsigned int old_selector,
 				     unsigned int new_selector);
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index b021084..5f37ad3 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -92,6 +92,7 @@ struct regulator_state {
  *                 mode.
  * @initial_state: Suspend state to set by default.
  * @initial_mode: Mode to set at startup.
+ * @ramp_delay: Time to settle down after voltage change (unit: mV/us)
  */
 struct regulation_constraints {
 
@@ -125,6 +126,8 @@ struct regulation_constraints {
 	/* mode to set on startup */
 	unsigned int initial_mode;
 
+	unsigned int ramp_delay;
+
 	/* constraint flags */
 	unsigned always_on:1;	/* regulator never off when system is on */
 	unsigned boot_on:1;	/* bootloader/firmware enabled regulator */
-- 
1.7.0.4

