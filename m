Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab0K2Tyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:54:53 -0500
Received: from mail.perches.com ([173.55.12.10]:1989 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab0K2Tyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:54:52 -0500
From: Joe Perches <joe@perches.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: Add and use rdev_<level> macros
Date: Mon, 29 Nov 2010 11:54:50 -0800
Message-Id: <9c7b69e9a5274587e5ba9f2b460f79f0159e9b75.1291060462.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use rdev_<level> convenience macros to emit rdev_get_name(rdev)
along with whatever format/arg... is supplied.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/regulator/core.c |  146 ++++++++++++++++++++-------------------------
 1 files changed, 65 insertions(+), 81 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 64a56a7..ad1999b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -32,6 +32,15 @@
 
 #include "dummy.h"
 
+#define rdev_err(rdev, fmt, ...)					\
+	pr_err("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__)
+#define rdev_warn(rdev, fmt, ...)					\
+	pr_warn("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__)
+#define rdev_info(rdev, fmt, ...)					\
+	pr_info("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__)
+#define rdev_debug(rdev, fmt, ...)					\
+	pr_debug("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__)
+
 static DEFINE_MUTEX(regulator_list_mutex);
 static LIST_HEAD(regulator_list);
 static LIST_HEAD(regulator_map_list);
@@ -114,11 +123,11 @@ static int regulator_check_voltage(struct regulator_dev *rdev,
 	BUG_ON(*min_uV > *max_uV);
 
 	if (!rdev->constraints) {
-		pr_err("no constraints for %s\n", rdev_get_name(rdev));
+		rdev_err(rdev, "no constraints\n");
 		return -ENODEV;
 	}
 	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE)) {
-		pr_err("operation not allowed for %s\n", rdev_get_name(rdev));
+		rdev_err(rdev, "operation not allowed\n");
 		return -EPERM;
 	}
 
@@ -140,11 +149,11 @@ static int regulator_check_current_limit(struct regulator_dev *rdev,
 	BUG_ON(*min_uA > *max_uA);
 
 	if (!rdev->constraints) {
-		pr_err("no constraints for %s\n", rdev_get_name(rdev));
+		rdev_err(rdev, "no constraints\n");
 		return -ENODEV;
 	}
 	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_CURRENT)) {
-		pr_err("operation not allowed for %s\n", rdev_get_name(rdev));
+		rdev_err(rdev, "operation not allowed\n");
 		return -EPERM;
 	}
 
@@ -173,15 +182,15 @@ static int regulator_check_mode(struct regulator_dev *rdev, int mode)
 	}
 
 	if (!rdev->constraints) {
-		pr_err("no constraints for %s\n", rdev_get_name(rdev));
+		rdev_err(rdev, "no constraints\n");
 		return -ENODEV;
 	}
 	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_MODE)) {
-		pr_err("operation not allowed for %s\n", rdev_get_name(rdev));
+		rdev_err(rdev, "operation not allowed\n");
 		return -EPERM;
 	}
 	if (!(rdev->constraints->valid_modes_mask & mode)) {
-		pr_err("invalid mode %x for %s\n", mode, rdev_get_name(rdev));
+		rdev_err(rdev, "invalid mode %x\n", mode);
 		return -EINVAL;
 	}
 	return 0;
@@ -191,11 +200,11 @@ static int regulator_check_mode(struct regulator_dev *rdev, int mode)
 static int regulator_check_drms(struct regulator_dev *rdev)
 {
 	if (!rdev->constraints) {
-		pr_err("no constraints for %s\n", rdev_get_name(rdev));
+		rdev_err(rdev, "no constraints\n");
 		return -ENODEV;
 	}
 	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_DRMS)) {
-		pr_err("operation not allowed for %s\n", rdev_get_name(rdev));
+		rdev_err(rdev, "operation not allowed\n");
 		return -EPERM;
 	}
 	return 0;
@@ -592,18 +601,17 @@ static int suspend_set_state(struct regulator_dev *rdev,
 	 */
 	if (!rstate->enabled && !rstate->disabled) {
 		if (can_set_state)
-			pr_warning("No configuration for %s\n",
-				   rdev_get_name(rdev));
+			rdev_warn(rdev, "No configuration\n");
 		return 0;
 	}
 
 	if (rstate->enabled && rstate->disabled) {
-		pr_err("invalid configuration for %s\n", rdev_get_name(rdev));
+		rdev_err(rdev, "invalid configuration\n");
 		return -EINVAL;
 	}
 
 	if (!can_set_state) {
-		pr_err("no way to set suspend state\n");
+		rdev_err(rdev, "no way to set suspend state\n");
 		return -EINVAL;
 	}
 
@@ -612,14 +620,14 @@ static int suspend_set_state(struct regulator_dev *rdev,
 	else
 		ret = rdev->desc->ops->set_suspend_disable(rdev);
 	if (ret < 0) {
-		pr_err("failed to enabled/disable\n");
+		rdev_err(rdev, "failed to enabled/disable\n");
 		return ret;
 	}
 
 	if (rdev->desc->ops->set_suspend_voltage && rstate->uV > 0) {
 		ret = rdev->desc->ops->set_suspend_voltage(rdev, rstate->uV);
 		if (ret < 0) {
-			pr_err("failed to set voltage\n");
+			rdev_err(rdev, "failed to set voltage\n");
 			return ret;
 		}
 	}
@@ -627,7 +635,7 @@ static int suspend_set_state(struct regulator_dev *rdev,
 	if (rdev->desc->ops->set_suspend_mode && rstate->mode > 0) {
 		ret = rdev->desc->ops->set_suspend_mode(rdev, rstate->mode);
 		if (ret < 0) {
-			pr_err("failed to set mode\n");
+			rdev_err(rdev, "failed to set mode\n");
 			return ret;
 		}
 	}
@@ -705,14 +713,13 @@ static void print_constraints(struct regulator_dev *rdev)
 	if (constraints->valid_modes_mask & REGULATOR_MODE_STANDBY)
 		count += sprintf(buf + count, "standby");
 
-	printk(KERN_INFO "regulator: %s: %s\n", rdev_get_name(rdev), buf);
+	rdev_info(rdev, "regulator: %s\n", buf);
 }
 
 static int machine_constraints_voltage(struct regulator_dev *rdev,
 	struct regulation_constraints *constraints)
 {
 	struct regulator_ops *ops = rdev->desc->ops;
-	const char *name = rdev_get_name(rdev);
 	int ret;
 	unsigned selector;
 
@@ -725,8 +732,8 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 				       rdev->constraints->max_uV,
 				       &selector);
 			if (ret < 0) {
-				pr_err("failed to apply %duV constraint to %s\n",
-					rdev->constraints->min_uV, name);
+				rdev_err(rdev, "failed to apply %duV constraint\n",
+					 rdev->constraints->min_uV);
 				rdev->constraints = NULL;
 				return ret;
 			}
@@ -758,8 +765,7 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 
 		/* else require explicit machine-level constraints */
 		if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
-			pr_err("invalid '%s' voltage constraints\n",
-				name);
+			rdev_err(rdev, "invalid voltage constraints\n");
 			return -EINVAL;
 		}
 
@@ -780,20 +786,19 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 
 		/* final: [min_uV..max_uV] valid iff constraints valid */
 		if (max_uV < min_uV) {
-			pr_err("unsupportable '%s' voltage constraints\n",
-				name);
+			rdev_err(rdev, "unsupportable voltage constraints\n");
 			return -EINVAL;
 		}
 
 		/* use regulator's subset of machine constraints */
 		if (constraints->min_uV < min_uV) {
-			pr_debug("override '%s' min_uV, %d -> %d\n",
-				 name, constraints->min_uV, min_uV);
+			rdev_debug(rdev, "override min_uV, %d -> %d\n",
+				   constraints->min_uV, min_uV);
 			constraints->min_uV = min_uV;
 		}
 		if (constraints->max_uV > max_uV) {
-			pr_debug("override '%s' max_uV, %d -> %d\n",
-				 name, constraints->max_uV, max_uV);
+			rdev_debug(rdev, "override max_uV, %d -> %d\n",
+				   constraints->max_uV, max_uV);
 			constraints->max_uV = max_uV;
 		}
 	}
@@ -816,13 +821,10 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 	struct regulation_constraints *constraints)
 {
 	int ret = 0;
-	const char *name;
 	struct regulator_ops *ops = rdev->desc->ops;
 
 	rdev->constraints = constraints;
 
-	name = rdev_get_name(rdev);
-
 	ret = machine_constraints_voltage(rdev, constraints);
 	if (ret != 0)
 		goto out;
@@ -831,8 +833,7 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 	if (constraints->initial_state) {
 		ret = suspend_prepare(rdev, constraints->initial_state);
 		if (ret < 0) {
-			pr_err("failed to set suspend state for %s\n",
-				name);
+			rdev_err(rdev, "failed to set suspend state\n");
 			rdev->constraints = NULL;
 			goto out;
 		}
@@ -840,16 +841,14 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 
 	if (constraints->initial_mode) {
 		if (!ops->set_mode) {
-			pr_err("no set_mode operation for %s\n",
-				name);
+			rdev_err(rdev, "no set_mode operation\n");
 			ret = -EINVAL;
 			goto out;
 		}
 
 		ret = ops->set_mode(rdev, constraints->initial_mode);
 		if (ret < 0) {
-			pr_err("failed to set initial mode for %s: %d\n",
-				name, ret);
+			rdev_err(rdev, "failed to set initial mode: %d\n", ret);
 			goto out;
 		}
 	}
@@ -860,7 +859,7 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 	if ((constraints->always_on || constraints->boot_on) && ops->enable) {
 		ret = ops->enable(rdev);
 		if (ret < 0) {
-			pr_err("failed to enable %s\n", name);
+			rdev_err(rdev, "failed to enable\n");
 			rdev->constraints = NULL;
 			goto out;
 		}
@@ -888,8 +887,8 @@ static int set_supply(struct regulator_dev *rdev,
 	err = sysfs_create_link(&rdev->dev.kobj, &supply_rdev->dev.kobj,
 				"supply");
 	if (err) {
-		pr_err("could not add device link %s err %d\n",
-			supply_rdev->dev.kobj.name, err);
+		rdev_err(rdev, "could not add device link %s err %d\n",
+			 supply_rdev->dev.kobj.name, err);
 		       goto out;
 	}
 	rdev->supply = supply_rdev;
@@ -945,10 +944,10 @@ static int set_consumer_device_supply(struct regulator_dev *rdev,
 			continue;
 
 		dev_dbg(consumer_dev, "%s/%s is '%s' supply; fail %s/%s\n",
-				dev_name(&node->regulator->dev),
-				node->regulator->desc->name,
-				supply,
-				dev_name(&rdev->dev), rdev_get_name(rdev));
+			dev_name(&node->regulator->dev),
+			node->regulator->desc->name,
+			supply,
+			dev_name(&rdev->dev), rdev_get_name(rdev));
 		return -EBUSY;
 	}
 
@@ -1019,8 +1018,7 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 		regulator->dev_attr.show = device_requested_uA_show;
 		err = device_create_file(dev, &regulator->dev_attr);
 		if (err < 0) {
-			pr_warning("could not add regulator_dev"
-				" requested microamps sysfs entry\n");
+			rdev_warn(rdev, "could not add regulator_dev requested microamps sysfs entry\n");
 			goto attr_name_err;
 		}
 
@@ -1037,8 +1035,8 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 		err = sysfs_create_link(&rdev->dev.kobj, &dev->kobj,
 					buf);
 		if (err) {
-			pr_warning("could not add device link %s err %d\n",
-			       dev->kobj.name, err);
+			rdev_warn(rdev, "could not add device link %s err %d\n",
+				  dev->kobj.name, err);
 			goto link_name_err;
 		}
 	}
@@ -1075,7 +1073,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 	int ret;
 
 	if (id == NULL) {
-		pr_err("regulator: get() with no identifier\n");
+		pr_err("get() with no identifier\n");
 		return regulator;
 	}
 
@@ -1109,8 +1107,8 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 	 * substitute in a dummy regulator so consumers can continue.
 	 */
 	if (!has_full_constraints) {
-		pr_warning("%s supply %s not found, using dummy regulator\n",
-			   devname, id);
+		pr_warn("%s supply %s not found, using dummy regulator\n",
+			devname, id);
 		rdev = dummy_regulator_rdev;
 		goto found;
 	}
@@ -1261,8 +1259,7 @@ static int _regulator_enable(struct regulator_dev *rdev)
 			ret = _regulator_enable(rdev->supply);
 			mutex_unlock(&rdev->supply->mutex);
 			if (ret < 0) {
-				pr_err("failed to enable %s: %d\n",
-				       rdev_get_name(rdev), ret);
+				rdev_err(rdev, "failed to enable: %d\n", ret);
 				return ret;
 			}
 		}
@@ -1289,8 +1286,7 @@ static int _regulator_enable(struct regulator_dev *rdev)
 			if (ret >= 0) {
 				delay = ret;
 			} else {
-				pr_warning("enable_time() failed for %s: %d\n",
-					   rdev_get_name(rdev),
+				rdev_warn(rdev, "enable_time() failed: %d\n",
 					   ret);
 				delay = 0;
 			}
@@ -1316,8 +1312,7 @@ static int _regulator_enable(struct regulator_dev *rdev)
 			trace_regulator_enable_complete(rdev_get_name(rdev));
 
 		} else if (ret < 0) {
-			pr_err("is_enabled() failed for %s: %d\n",
-				rdev_get_name(rdev), ret);
+			rdev_err(rdev, "is_enabled() failed: %d\n", ret);
 			return ret;
 		}
 		/* Fallthrough on positive return values - already enabled */
@@ -1374,8 +1369,7 @@ static int _regulator_disable(struct regulator_dev *rdev,
 
 			ret = rdev->desc->ops->disable(rdev);
 			if (ret < 0) {
-				pr_err("failed to disable %s\n",
-					rdev_get_name(rdev));
+				rdev_err(rdev, "failed to disable\n");
 				return ret;
 			}
 
@@ -1447,8 +1441,7 @@ static int _regulator_force_disable(struct regulator_dev *rdev,
 		/* ah well, who wants to live forever... */
 		ret = rdev->desc->ops->disable(rdev);
 		if (ret < 0) {
-			pr_err("failed to force disable %s\n",
-				rdev_get_name(rdev));
+			rdev_err(rdev, "failed to force disable\n");
 			return ret;
 		}
 		/* notify other consumers that power has been forced off */
@@ -1889,8 +1882,7 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 	/* get output voltage */
 	output_uV = rdev->desc->ops->get_voltage(rdev);
 	if (output_uV <= 0) {
-		pr_err("invalid output voltage found for %s\n",
-			rdev_get_name(rdev));
+		rdev_err(rdev, "invalid output voltage found\n");
 		goto out;
 	}
 
@@ -1900,8 +1892,7 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 	else
 		input_uV = rdev->constraints->input_uV;
 	if (input_uV <= 0) {
-		pr_err("invalid input voltage found for %s\n",
-			rdev_get_name(rdev));
+		rdev_err(rdev, "invalid input voltage found\n");
 		goto out;
 	}
 
@@ -1914,16 +1905,14 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 						 total_uA_load);
 	ret = regulator_check_mode(rdev, mode);
 	if (ret < 0) {
-		pr_err("failed to get optimum mode for %s @"
-			" %d uA %d -> %d uV\n",  rdev_get_name(rdev),
-			total_uA_load, input_uV, output_uV);
+		rdev_err(rdev, "failed to get optimum mode @ %d uA %d -> %d uV\n",
+			 total_uA_load, input_uV, output_uV);
 		goto out;
 	}
 
 	ret = rdev->desc->ops->set_mode(rdev, mode);
 	if (ret < 0) {
-		pr_err("failed to set optimum mode %x for %s\n",
-			 mode, rdev_get_name(rdev));
+		rdev_err(rdev, "failed to set optimum mode %x\n", mode);
 		goto out;
 	}
 	ret = mode;
@@ -2054,7 +2043,7 @@ int regulator_bulk_enable(int num_consumers,
 	return 0;
 
 err:
-	printk(KERN_ERR "Failed to enable %s: %d\n", consumers[i].supply, ret);
+	pr_err("Failed to enable %s: %d\n", consumers[i].supply, ret);
 	for (--i; i >= 0; --i)
 		regulator_disable(consumers[i].consumer);
 
@@ -2089,8 +2078,7 @@ int regulator_bulk_disable(int num_consumers,
 	return 0;
 
 err:
-	printk(KERN_ERR "Failed to disable %s: %d\n", consumers[i].supply,
-	       ret);
+	pr_err("Failed to disable %s: %d\n", consumers[i].supply, ret);
 	for (--i; i >= 0; --i)
 		regulator_enable(consumers[i].consumer);
 
@@ -2472,7 +2460,7 @@ int regulator_suspend_prepare(suspend_state_t state)
 		mutex_unlock(&rdev->mutex);
 
 		if (ret < 0) {
-			pr_err("failed to prepare %s\n", rdev_get_name(rdev));
+			rdev_err(rdev, "failed to prepare\n");
 			goto out;
 		}
 	}
@@ -2594,7 +2582,6 @@ static int __init regulator_init_complete(void)
 	struct regulator_ops *ops;
 	struct regulation_constraints *c;
 	int enabled, ret;
-	const char *name;
 
 	mutex_lock(&regulator_list_mutex);
 
@@ -2606,8 +2593,6 @@ static int __init regulator_init_complete(void)
 		ops = rdev->desc->ops;
 		c = rdev->constraints;
 
-		name = rdev_get_name(rdev);
-
 		if (!ops->disable || (c && c->always_on))
 			continue;
 
@@ -2628,10 +2613,10 @@ static int __init regulator_init_complete(void)
 		if (has_full_constraints) {
 			/* We log since this may kill the system if it
 			 * goes wrong. */
-			pr_info("disabling %s\n", name);
+			rdev_info(rdev, "disabling\n");
 			ret = ops->disable(rdev);
 			if (ret != 0) {
-				pr_err("couldn't disable %s: %d\n", name, ret);
+				rdev_err(rdev, "couldn't disable: %d\n", ret);
 			}
 		} else {
 			/* The intention is that in future we will
@@ -2639,8 +2624,7 @@ static int __init regulator_init_complete(void)
 			 * so warn even if we aren't going to do
 			 * anything here.
 			 */
-			pr_warning("incomplete constraints, leaving %s on\n",
-				   name);
+			rdev_warn(rdev, "incomplete constraints, leaving on\n");
 		}
 
 unlock:
-- 
1.7.3.2.245.g03276.dirty

