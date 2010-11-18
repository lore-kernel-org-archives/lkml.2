Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab0KRBaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 20:30:12 -0500
Received: from mail.perches.com ([173.55.12.10]:1523 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab0KRBaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 20:30:11 -0500
Subject: Re: [PATCH 2/2] drivers: regulator: core: convert to using pr_
 macros
From: Joe Perches <joe@perches.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, bleong@codeaurora.org
In-Reply-To: <1290040611.28741.332.camel@Joe-Laptop>
References: <1290036628-9928-1-git-send-email-dwalker@codeaurora.org>
	 <1290036628-9928-2-git-send-email-dwalker@codeaurora.org>
	 <1290040611.28741.332.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 17:30:07 -0800
Message-ID: <1290043807.28741.334.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 16:36 -0800, Joe Perches wrote:
> On Wed, 2010-11-17 at 15:30 -0800, Daniel Walker wrote:
> > The regulator framework uses a lot of printks with a
> > specific formatting using __func__. This converts them
> > to use pr_ calls with a central format string.
> []
> >  drivers/regulator/core.c |  131 +++++++++++++++++++---------------------------
> >  1 files changed, 54 insertions(+), 77 deletions(-)
> > 
> > diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> > index a3ca3d6..67cae17 100644
> > --- a/drivers/regulator/core.c
> > +++ b/drivers/regulator/core.c
> []
> > @@ -113,13 +113,11 @@ static int regulator_check_voltage(struct regulator_dev *rdev,
> >  	BUG_ON(*min_uV > *max_uV);
> >  
> >  	if (!rdev->constraints) {
> > -		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
> > -		       rdev_get_name(rdev));
> > +		pr_err("no constraints for %s\n", rdev_get_name(rdev));
> >  		return -ENODEV;
> 
> Hi Daniel.
> 
> I think it'd be better to introduce and use:
> 
> #define rdev_err(rdev, fmt, ...)
> 	pr_err("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__);
> #define rdev_warn(rdev, fmt, ...)
> 	pr_warn("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__);
> #define rdev_info(rdev, fmt, ...)
> 	pr_info("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__);

Perhaps something like this:

Compiled/untested.
---
 drivers/regulator/core.c |  182 ++++++++++++++++++---------------------------
 1 files changed, 73 insertions(+), 109 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f1d10c9..5dcec73 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -13,6 +13,8 @@
  *
  */
 
+#define pr_fmt(fmt) "%s: " fmt, __func__
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/device.h>
@@ -29,6 +31,15 @@
 
 #define REGULATOR_VERSION "0.5"
 
+#define rdev_err(rdev, fmt, ...)					\
+        pr_err("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__)
+#define rdev_warn(rdev, fmt, ...)					\
+        pr_warn("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__)
+#define rdev_info(rdev, fmt, ...)					\
+	pr_info("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__)
+#define rdev_debug(rdev, fmt, ...)					\
+	pr_debug("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__)
+
 static DEFINE_MUTEX(regulator_list_mutex);
 static LIST_HEAD(regulator_list);
 static LIST_HEAD(regulator_map_list);
@@ -111,13 +122,11 @@ static int regulator_check_voltage(struct regulator_dev *rdev,
 	BUG_ON(*min_uV > *max_uV);
 
 	if (!rdev->constraints) {
-		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
-		       rdev_get_name(rdev));
+		rdev_err(rdev, "no constraints\n");
 		return -ENODEV;
 	}
 	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE)) {
-		printk(KERN_ERR "%s: operation not allowed for %s\n",
-		       __func__, rdev_get_name(rdev));
+		rdev_err(rdev, "operation not allowed\n");
 		return -EPERM;
 	}
 
@@ -139,13 +148,11 @@ static int regulator_check_current_limit(struct regulator_dev *rdev,
 	BUG_ON(*min_uA > *max_uA);
 
 	if (!rdev->constraints) {
-		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
-		       rdev_get_name(rdev));
+		rdev_err(rdev, "no constraints\n");
 		return -ENODEV;
 	}
 	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_CURRENT)) {
-		printk(KERN_ERR "%s: operation not allowed for %s\n",
-		       __func__, rdev_get_name(rdev));
+		rdev_err(rdev, "operation not allowed\n");
 		return -EPERM;
 	}
 
@@ -174,18 +181,15 @@ static int regulator_check_mode(struct regulator_dev *rdev, int mode)
 	}
 
 	if (!rdev->constraints) {
-		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
-		       rdev_get_name(rdev));
+		rdev_err(rdev, "no constraints\n");
 		return -ENODEV;
 	}
 	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_MODE)) {
-		printk(KERN_ERR "%s: operation not allowed for %s\n",
-		       __func__, rdev_get_name(rdev));
+		rdev_err(rdev, "operation not allowed\n");
 		return -EPERM;
 	}
 	if (!(rdev->constraints->valid_modes_mask & mode)) {
-		printk(KERN_ERR "%s: invalid mode %x for %s\n",
-		       __func__, mode, rdev_get_name(rdev));
+		rdev_err(rdev, "invalid mode %x\n", mode);
 		return -EINVAL;
 	}
 	return 0;
@@ -195,13 +199,11 @@ static int regulator_check_mode(struct regulator_dev *rdev, int mode)
 static int regulator_check_drms(struct regulator_dev *rdev)
 {
 	if (!rdev->constraints) {
-		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
-		       rdev_get_name(rdev));
+		rdev_err(rdev, "no constraints\n");
 		return -ENODEV;
 	}
 	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_DRMS)) {
-		printk(KERN_ERR "%s: operation not allowed for %s\n",
-		       __func__, rdev_get_name(rdev));
+		rdev_err(rdev, "operation not allowed\n");
 		return -EPERM;
 	}
 	return 0;
@@ -598,20 +600,17 @@ static int suspend_set_state(struct regulator_dev *rdev,
 	 */
 	if (!rstate->enabled && !rstate->disabled) {
 		if (can_set_state)
-			printk(KERN_WARNING "%s: No configuration for %s\n",
-			       __func__, rdev_get_name(rdev));
+			rdev_warn(rdev, "No configuration\n");
 		return 0;
 	}
 
 	if (rstate->enabled && rstate->disabled) {
-		printk(KERN_ERR "%s: invalid configuration for %s\n",
-		       __func__, rdev_get_name(rdev));
+		rdev_err(rdev, "invalid configuration\n");
 		return -EINVAL;
 	}
 
 	if (!can_set_state) {
-		printk(KERN_ERR "%s: no way to set suspend state\n",
-			__func__);
+		rdev_err(rdev, "no way to set suspend state\n");
 		return -EINVAL;
 	}
 
@@ -620,15 +619,14 @@ static int suspend_set_state(struct regulator_dev *rdev,
 	else
 		ret = rdev->desc->ops->set_suspend_disable(rdev);
 	if (ret < 0) {
-		printk(KERN_ERR "%s: failed to enabled/disable\n", __func__);
+		rdev_err(rdev, "failed to enabled/disable\n");
 		return ret;
 	}
 
 	if (rdev->desc->ops->set_suspend_voltage && rstate->uV > 0) {
 		ret = rdev->desc->ops->set_suspend_voltage(rdev, rstate->uV);
 		if (ret < 0) {
-			printk(KERN_ERR "%s: failed to set voltage\n",
-				__func__);
+			rdev_err(rdev, "failed to set voltage\n");
 			return ret;
 		}
 	}
@@ -636,7 +634,7 @@ static int suspend_set_state(struct regulator_dev *rdev,
 	if (rdev->desc->ops->set_suspend_mode && rstate->mode > 0) {
 		ret = rdev->desc->ops->set_suspend_mode(rdev, rstate->mode);
 		if (ret < 0) {
-			printk(KERN_ERR "%s: failed to set mode\n", __func__);
+			rdev_err(rdev, "failed to set mode\n");
 			return ret;
 		}
 	}
@@ -714,14 +712,13 @@ static void print_constraints(struct regulator_dev *rdev)
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
 
 	/* do we need to apply the constraint voltage */
@@ -731,9 +728,9 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 		ret = ops->set_voltage(rdev,
 			rdev->constraints->min_uV, rdev->constraints->max_uV);
 			if (ret < 0) {
-				printk(KERN_ERR "%s: failed to apply %duV constraint to %s\n",
-				       __func__,
-				       rdev->constraints->min_uV, name);
+				rdev_err(rdev,
+					 "failed to apply %duV constraint\n",
+					 rdev->constraints->min_uV);
 				rdev->constraints = NULL;
 				return ret;
 			}
@@ -765,8 +762,7 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 
 		/* else require explicit machine-level constraints */
 		if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
-			pr_err("%s: %s '%s' voltage constraints\n",
-				       __func__, "invalid", name);
+			rdev_err(rdev, "invalid voltage constraints\n");
 			return -EINVAL;
 		}
 
@@ -787,22 +783,19 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 
 		/* final: [min_uV..max_uV] valid iff constraints valid */
 		if (max_uV < min_uV) {
-			pr_err("%s: %s '%s' voltage constraints\n",
-				       __func__, "unsupportable", name);
+			rdev_err(rdev, "unsupportable voltage constraints\n");
 			return -EINVAL;
 		}
 
 		/* use regulator's subset of machine constraints */
 		if (constraints->min_uV < min_uV) {
-			pr_debug("%s: override '%s' %s, %d -> %d\n",
-				       __func__, name, "min_uV",
-					constraints->min_uV, min_uV);
+			rdev_debug(rdev, "override min_uV, %d -> %d\n",
+				   constraints->min_uV, min_uV);
 			constraints->min_uV = min_uV;
 		}
 		if (constraints->max_uV > max_uV) {
-			pr_debug("%s: override '%s' %s, %d -> %d\n",
-				       __func__, name, "max_uV",
-					constraints->max_uV, max_uV);
+			rdev_debug(rdev, "override max_uV, %d -> %d\n",
+				   constraints->max_uV, max_uV);
 			constraints->max_uV = max_uV;
 		}
 	}
@@ -825,13 +818,10 @@ static int set_machine_constraints(struct regulator_dev *rdev,
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
@@ -840,8 +830,7 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 	if (constraints->initial_state) {
 		ret = suspend_prepare(rdev, constraints->initial_state);
 		if (ret < 0) {
-			printk(KERN_ERR "%s: failed to set suspend state for %s\n",
-			       __func__, name);
+			rdev_err(rdev, "failed to set suspend state\n");
 			rdev->constraints = NULL;
 			goto out;
 		}
@@ -849,17 +838,14 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 
 	if (constraints->initial_mode) {
 		if (!ops->set_mode) {
-			printk(KERN_ERR "%s: no set_mode operation for %s\n",
-			       __func__, name);
+			rdev_err(rdev, "no set_mode operation\n");
 			ret = -EINVAL;
 			goto out;
 		}
 
 		ret = ops->set_mode(rdev, constraints->initial_mode);
 		if (ret < 0) {
-			printk(KERN_ERR
-			       "%s: failed to set initial mode for %s: %d\n",
-			       __func__, name, ret);
+			rdev_err(rdev, "failed to set initial mode: %d\n", ret);
 			goto out;
 		}
 	}
@@ -870,8 +856,7 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 	if ((constraints->always_on || constraints->boot_on) && ops->enable) {
 		ret = ops->enable(rdev);
 		if (ret < 0) {
-			printk(KERN_ERR "%s: failed to enable %s\n",
-			       __func__, name);
+			rdev_err(rdev, "failed to enable\n");
 			rdev->constraints = NULL;
 			goto out;
 		}
@@ -899,10 +884,9 @@ static int set_supply(struct regulator_dev *rdev,
 	err = sysfs_create_link(&rdev->dev.kobj, &supply_rdev->dev.kobj,
 				"supply");
 	if (err) {
-		printk(KERN_ERR
-		       "%s: could not add device link %s err %d\n",
-		       __func__, supply_rdev->dev.kobj.name, err);
-		       goto out;
+		pr_err("could not add device link %s err %d\n",
+		       supply_rdev->dev.kobj.name, err);
+		goto out;
 	}
 	rdev->supply = supply_rdev;
 	list_add(&rdev->slist, &supply_rdev->supply_list);
@@ -957,10 +941,10 @@ static int set_consumer_device_supply(struct regulator_dev *rdev,
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
 
@@ -1031,8 +1015,8 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 		regulator->dev_attr.show = device_requested_uA_show;
 		err = device_create_file(dev, &regulator->dev_attr);
 		if (err < 0) {
-			printk(KERN_WARNING "%s: could not add regulator_dev"
-				" load sysfs\n", __func__);
+			rdev_warn(rdev,
+				  "could not add regulator_dev load sysfs\n");
 			goto attr_name_err;
 		}
 
@@ -1049,9 +1033,8 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 		err = sysfs_create_link(&rdev->dev.kobj, &dev->kobj,
 					buf);
 		if (err) {
-			printk(KERN_WARNING
-			       "%s: could not add device link %s err %d\n",
-			       __func__, dev->kobj.name, err);
+			rdev_warn(rdev, "could not add device link %s err %d\n",
+				  dev->kobj.name, err);
 			device_remove_file(dev, &regulator->dev_attr);
 			goto link_name_err;
 		}
@@ -1089,7 +1072,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 	int ret;
 
 	if (id == NULL) {
-		printk(KERN_ERR "regulator: get() with no identifier\n");
+		pr_err("regulator: get() with no identifier\n");
 		return regulator;
 	}
 
@@ -1123,8 +1106,8 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
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
@@ -1272,8 +1255,7 @@ static int _regulator_enable(struct regulator_dev *rdev)
 	if (rdev->supply) {
 		ret = _regulator_enable(rdev->supply);
 		if (ret < 0) {
-			printk(KERN_ERR "%s: failed to enable %s: %d\n",
-			       __func__, rdev_get_name(rdev), ret);
+			rdev_err(rdev, "failed to enable: %d\n", ret);
 			return ret;
 		}
 	}
@@ -1299,10 +1281,8 @@ static int _regulator_enable(struct regulator_dev *rdev)
 			if (ret >= 0) {
 				delay = ret;
 			} else {
-				printk(KERN_WARNING
-					"%s: enable_time() failed for %s: %d\n",
-					__func__, rdev_get_name(rdev),
-					ret);
+				rdev_warn(rdev, "enable_time() failed: %d\n",
+					  ret);
 				delay = 0;
 			}
 
@@ -1319,8 +1299,7 @@ static int _regulator_enable(struct regulator_dev *rdev)
 				udelay(delay);
 
 		} else if (ret < 0) {
-			printk(KERN_ERR "%s: is_enabled() failed for %s: %d\n",
-			       __func__, rdev_get_name(rdev), ret);
+			rdev_err(rdev, "is_enabled() failed: %d\n", ret);
 			return ret;
 		}
 		/* Fallthrough on positive return values - already enabled */
@@ -1374,8 +1353,7 @@ static int _regulator_disable(struct regulator_dev *rdev,
 		    rdev->desc->ops->disable) {
 			ret = rdev->desc->ops->disable(rdev);
 			if (ret < 0) {
-				printk(KERN_ERR "%s: failed to disable %s\n",
-				       __func__, rdev_get_name(rdev));
+				rdev_err(rdev, "failed to disable\n");
 				return ret;
 			}
 
@@ -1445,8 +1423,7 @@ static int _regulator_force_disable(struct regulator_dev *rdev,
 		/* ah well, who wants to live forever... */
 		ret = rdev->desc->ops->disable(rdev);
 		if (ret < 0) {
-			printk(KERN_ERR "%s: failed to force disable %s\n",
-			       __func__, rdev_get_name(rdev));
+			rdev_err(rdev, "failed to force disable\n");
 			return ret;
 		}
 		/* notify other consumers that power has been forced off */
@@ -1876,8 +1853,7 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 	/* get output voltage */
 	output_uV = rdev->desc->ops->get_voltage(rdev);
 	if (output_uV <= 0) {
-		printk(KERN_ERR "%s: invalid output voltage found for %s\n",
-			__func__, rdev_get_name(rdev));
+		rdev_err(rdev, "invalid output voltage found\n");
 		goto out;
 	}
 
@@ -1887,8 +1863,7 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 	else
 		input_uV = rdev->constraints->input_uV;
 	if (input_uV <= 0) {
-		printk(KERN_ERR "%s: invalid input voltage found for %s\n",
-			__func__, rdev_get_name(rdev));
+		rdev_err(rdev, "invalid input voltage found\n");
 		goto out;
 	}
 
@@ -1901,16 +1876,15 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 						 total_uA_load);
 	ret = regulator_check_mode(rdev, mode);
 	if (ret < 0) {
-		printk(KERN_ERR "%s: failed to get optimum mode for %s @"
-			" %d uA %d -> %d uV\n", __func__, rdev_get_name(rdev),
-			total_uA_load, input_uV, output_uV);
+		rdev_err(rdev,
+			 "failed to get optimum mode @ %d uA %d -> %d uV\n",
+			 total_uA_load, input_uV, output_uV);
 		goto out;
 	}
 
 	ret = rdev->desc->ops->set_mode(rdev, mode);
 	if (ret < 0) {
-		printk(KERN_ERR "%s: failed to set optimum mode %x for %s\n",
-			__func__, mode, rdev_get_name(rdev));
+		rdev_err(rdev, "failed to set optimum mode %x\n", mode);
 		goto out;
 	}
 	ret = mode;
@@ -2041,7 +2015,7 @@ int regulator_bulk_enable(int num_consumers,
 	return 0;
 
 err:
-	printk(KERN_ERR "Failed to enable %s: %d\n", consumers[i].supply, ret);
+	pr_err("Failed to enable %s: %d\n", consumers[i].supply, ret);
 	for (--i; i >= 0; --i)
 		regulator_disable(consumers[i].consumer);
 
@@ -2076,8 +2050,7 @@ int regulator_bulk_disable(int num_consumers,
 	return 0;
 
 err:
-	printk(KERN_ERR "Failed to disable %s: %d\n", consumers[i].supply,
-	       ret);
+	pr_err("Failed to disable %s: %d\n", consumers[i].supply, ret);
 	for (--i; i >= 0; --i)
 		regulator_enable(consumers[i].consumer);
 
@@ -2457,8 +2430,7 @@ int regulator_suspend_prepare(suspend_state_t state)
 		mutex_unlock(&rdev->mutex);
 
 		if (ret < 0) {
-			printk(KERN_ERR "%s: failed to prepare %s\n",
-				__func__, rdev_get_name(rdev));
+			rdev_err(rdev, "failed to prepare\n");
 			goto out;
 		}
 	}
@@ -2564,7 +2536,7 @@ static int __init regulator_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "regulator: core version %s\n", REGULATOR_VERSION);
+	pr_info("regulator: core version %s\n", REGULATOR_VERSION);
 
 	ret = class_register(&regulator_class);
 
@@ -2582,7 +2554,6 @@ static int __init regulator_init_complete(void)
 	struct regulator_ops *ops;
 	struct regulation_constraints *c;
 	int enabled, ret;
-	const char *name;
 
 	mutex_lock(&regulator_list_mutex);
 
@@ -2594,8 +2565,6 @@ static int __init regulator_init_complete(void)
 		ops = rdev->desc->ops;
 		c = rdev->constraints;
 
-		name = rdev_get_name(rdev);
-
 		if (!ops->disable || (c && c->always_on))
 			continue;
 
@@ -2616,13 +2585,10 @@ static int __init regulator_init_complete(void)
 		if (has_full_constraints) {
 			/* We log since this may kill the system if it
 			 * goes wrong. */
-			printk(KERN_INFO "%s: disabling %s\n",
-			       __func__, name);
+			rdev_info(rdev, "disabling\n");
 			ret = ops->disable(rdev);
 			if (ret != 0) {
-				printk(KERN_ERR
-				       "%s: couldn't disable %s: %d\n",
-				       __func__, name, ret);
+				rdev_err(rdev, "couldn't disable: %d\n", ret);
 			}
 		} else {
 			/* The intention is that in future we will
@@ -2630,9 +2596,7 @@ static int __init regulator_init_complete(void)
 			 * so warn even if we aren't going to do
 			 * anything here.
 			 */
-			printk(KERN_WARNING
-			       "%s: incomplete constraints, leaving %s on\n",
-			       __func__, name);
+			rdev_warn(rdev, "incomplete constraints, leaving on\n");
 		}
 
 unlock:


