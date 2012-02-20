Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab2BTGs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:48:26 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19478 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab2BTGrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:47:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 19 Feb 2012 22:46:19 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 16/20] pinctrl: Refactor struct pinctrl handling in core.c vs pinmux.c
Date: Sun, 19 Feb 2012 23:45:56 -0700
Message-Id: <1329720360-23227-17-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change separates two aspects of struct pinctrl:

a) The data representation of the parsed mapping table, into:

   1) The top-level struct pinctrl object, a single entity returned
      by pinctrl_get().

   2) The parsed version of each mapping table entry, struct
      pinctrl_setting, of which there is one per mapping table entry.

b) The code that handles this; the code for (1) above is in core.c, and
   the code to parse/execute each entry in (2) above is in pinmux.c, while
   the iteration over multiple settings is lifted to core.c.

This will allow the following future changes:

1) pinctrl_get() API rework, so that struct pinctrl represents all states
   for the device, and the device can select between them without calling
   put()/get() again.

2) To support that, a struct pinctrl_state object will be inserted into
   the data model between the struct pinctrl and struct pinctrl_setting.

3) The mapping table will be extended to allow specification of pin config
   settings too. To support this, struct pinctrl_setting will be enhanced
   to store either mux settings or config settings, and functions will be
   added to pinconf.c to parse/execute pin configuration settings.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/core.c   |  103 +++++++-----
 drivers/pinctrl/core.h   |   26 ++-
 drivers/pinctrl/pinmux.c |  409 +++++++++++-----------------------------------
 drivers/pinctrl/pinmux.h |   42 ++---
 4 files changed, 193 insertions(+), 387 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 7cb64e6..2066aee 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -472,14 +472,15 @@ EXPORT_SYMBOL_GPL(pinctrl_gpio_direction_output);
 
 static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 {
-	struct pinctrl_dev *pctldev = NULL;
+	struct pinctrl_dev *pctldev;
 	const char *devname;
 	struct pinctrl *p;
 	unsigned num_maps = 0;
-	int ret = -ENODEV;
+	int ret;
 	struct pinctrl_maps *maps_node;
 	int i;
 	struct pinctrl_map const *map;
+	struct pinctrl_setting *setting;
 
 	/* We must have both dev and state name */
 	if (WARN_ON(!dev || !name))
@@ -499,10 +500,20 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 		dev_err(dev, "failed to alloc struct pinctrl\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	pinmux_init_pinctrl_handle(p);
+	p->dev = dev;
+	p->state = name;
+	INIT_LIST_HEAD(&p->settings);
 
 	/* Iterate over the pin control maps to locate the right ones */
 	for_each_maps(maps_node, i, map) {
+		/* Map must be for this device */
+		if (strcmp(map->dev_name, devname))
+			continue;
+
+		/* State name must be the one we're looking for */
+		if (strcmp(map->name, name))
+			continue;
+
 		/*
 		 * First, try to find the pctldev given in the map
 		 */
@@ -510,29 +521,28 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 		if (!pctldev) {
 			dev_err(dev, "unknown pinctrl device %s in map entry",
 				map->ctrl_dev_name);
-			pinmux_put(p);
-			kfree(p);
 			/* Eventually, this should trigger deferred probe */
-			return ERR_PTR(-ENODEV);
+			ret = -ENODEV;
+			goto error;
 		}
 
 		dev_dbg(dev, "in map, found pctldev %s to handle function %s",
 			dev_name(pctldev->dev), map->function);
 
-		/* Map must be for this device */
-		if (strcmp(map->dev_name, devname))
-			continue;
+		setting = kzalloc(sizeof(*setting), GFP_KERNEL);
+		if (setting == NULL) {
+			dev_err(dev,
+				"failed to alloc struct pinctrl_setting\n");
+			ret = -ENOMEM;
+			goto error;
+		}
 
-		/* State name must be the one we're looking for */
-		if (strcmp(map->name, name))
-			continue;
+		setting->pctldev = pctldev;
+		ret = pinmux_map_to_setting(map, setting);
+		if (ret < 0)
+			goto error;
 
-		ret = pinmux_apply_muxmap(pctldev, p, dev,
-					    devname, map);
-		if (ret) {
-			kfree(p);
-			return ERR_PTR(ret);
-		}
+		list_add_tail(&setting->node, &p->settings);
 		num_maps++;
 	}
 
@@ -553,6 +563,14 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 	list_add_tail(&p->node, &pinctrl_list);
 
 	return p;
+
+error:
+	list_for_each_entry(setting, &p->settings, node)
+		pinmux_free_setting(setting);
+
+	kfree(p);
+
+	return ERR_PTR(ret);
 }
 
 /**
@@ -576,13 +594,18 @@ EXPORT_SYMBOL_GPL(pinctrl_get);
 
 static void pinctrl_put_locked(struct pinctrl *p)
 {
+	struct pinctrl_setting *setting, *n;
+
 	if (p == NULL)
 		return;
 
 	if (p->usecount)
 		pr_warn("releasing pin control handle with active users!\n");
-	/* Free the groups and all acquired pins */
-	pinmux_put(p);
+	list_for_each_entry_safe(setting, n, &p->settings, node) {
+		pinmux_free_setting(setting);
+		list_del(&setting->node);
+		kfree(setting);
+	}
 
 	/* Remove from list */
 	list_del(&p->node);
@@ -604,18 +627,24 @@ EXPORT_SYMBOL_GPL(pinctrl_put);
 
 static int pinctrl_enable_locked(struct pinctrl *p)
 {
-	int ret = 0;
+	struct pinctrl_setting *setting;
+	int ret;
 
 	if (p == NULL)
 		return -EINVAL;
 
 	if (p->usecount++ == 0) {
-		ret = pinmux_enable(p);
-		if (ret)
-			p->usecount--;
+		list_for_each_entry(setting, &p->settings, node) {
+			ret = pinmux_enable_setting(setting);
+			if (ret < 0) {
+				/* FIXME: Difficult to return to prev state */
+				p->usecount--;
+				return ret;
+			}
+		}
 	}
 
-	return ret;
+	return 0;
 }
 
 /**
@@ -634,11 +663,14 @@ EXPORT_SYMBOL_GPL(pinctrl_enable);
 
 static void pinctrl_disable_locked(struct pinctrl *p)
 {
+	struct pinctrl_setting *setting;
+
 	if (p == NULL)
 		return;
 
 	if (--p->usecount == 0) {
-		pinmux_disable(p);
+		list_for_each_entry(setting, &p->settings, node)
+			pinmux_disable_setting(setting);
 	}
 }
 
@@ -979,27 +1011,20 @@ static int pinctrl_devices_show(struct seq_file *s, void *what)
 static int pinctrl_show(struct seq_file *s, void *what)
 {
 	struct pinctrl *p;
+	struct pinctrl_setting *setting;
 
 	seq_puts(s, "Requested pin control handlers their pinmux maps:\n");
 
 	mutex_lock(&pinctrl_mutex);
 
 	list_for_each_entry(p, &pinctrl_list, node) {
-		struct pinctrl_dev *pctldev = p->pctldev;
+		seq_printf(s, "device: %s state: %s users: %u\n",
+			   dev_name(p->dev), p->state, p->usecount);
 
-		if (!pctldev) {
-			seq_puts(s, "NO PIN CONTROLLER DEVICE\n");
-			continue;
+		list_for_each_entry(setting, &p->settings, node) {
+			seq_printf(s, "  ");
+			pinmux_dbg_show(s, setting);
 		}
-
-		seq_printf(s, "device: %s",
-			   pinctrl_dev_get_name(p->pctldev));
-
-		pinmux_dbg_show(s, p);
-
-		seq_printf(s, " users: %u map-> %s\n",
-			   p->usecount,
-			   p->dev ? dev_name(p->dev) : "(system)");
 	}
 
 	mutex_unlock(&pinctrl_mutex);
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 4cdc38d..1290995 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -49,25 +49,31 @@ struct pinctrl_dev {
  * struct pinctrl - per-device pin control state holder
  * @node: global list node
  * @dev: the device using this pin control handle
+ * @state: the state name passed to pinctrl_get()
  * @usecount: the number of active users of this pin controller setting, used
  *	to keep track of nested use cases
- * @pctldev: pin control device handling this pin control handle
- * @func_selector: the function selector for the pinmux device handling
- *	this pinmux
- * @groups: the group selectors for the pinmux device and
- *	selector combination handling this pinmux, this is a list that
- *	will be traversed on all pinmux operations such as
- *	get/put/enable/disable
+ * @settings: a list of settings for this device/state
  */
 struct pinctrl {
 	struct list_head node;
 	struct device *dev;
+	const char *state;
 	unsigned usecount;
+	struct list_head settings;
+};
+
+/**
+ * struct pinctrl_setting - an individual mux setting
+ * @node: list node for struct pinctrl's @settings field
+ * @pctldev: pin control device handling to be programmed
+ * @group_selector: the group selector to program
+ * @func_selector: the function selector to program
+ */
+struct pinctrl_setting {
+	struct list_head node;
 	struct pinctrl_dev *pctldev;
-#ifdef CONFIG_PINMUX
+	unsigned group_selector;
 	unsigned func_selector;
-	struct list_head groups;
-#endif
 };
 
 /**
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index c574751..8d32380 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -7,6 +7,8 @@
  *
  * Author: Linus Walleij <linus.walleij@linaro.org>
  *
+ * Copyright (C) 2012 NVIDIA CORPORATION. All rights reserved.
+ *
  * License terms: GNU General Public License (GPL) version 2
  */
 #define pr_fmt(fmt) "pinmux core: " fmt
@@ -28,16 +30,6 @@
 #include "core.h"
 #include "pinmux.h"
 
-/**
- * struct pinmux_group - group list item for pinmux groups
- * @node: pinmux group list node
- * @group_selector: the group selector for this group
- */
-struct pinmux_group {
-	struct list_head node;
-	unsigned group_selector;
-};
-
 int pinmux_check_ops(struct pinctrl_dev *pctldev)
 {
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
@@ -241,164 +233,8 @@ int pinmux_gpio_direction(struct pinctrl_dev *pctldev,
 	return ret;
 }
 
-/**
- * acquire_pins() - acquire all the pins for a certain function on a pinmux
- * @pctldev: the device to take the pins on
- * @owner: a representation of the owner of this pin; typically the device
- *	name that controls its mux function
- * @group_selector: the group selector containing the pins to acquire
- */
-static int acquire_pins(struct pinctrl_dev *pctldev,
-			const char *owner,
-			unsigned group_selector)
-{
-	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
-	const unsigned *pins;
-	unsigned num_pins;
-	int ret;
-	int i;
-
-	ret = pctlops->get_group_pins(pctldev, group_selector,
-				      &pins, &num_pins);
-	if (ret)
-		return ret;
-
-	dev_dbg(pctldev->dev, "requesting the %u pins from group %u\n",
-		num_pins, group_selector);
-
-	/* Try to allocate all pins in this group, one by one */
-	for (i = 0; i < num_pins; i++) {
-		ret = pin_request(pctldev, pins[i], owner, NULL);
-		if (ret) {
-			dev_err(pctldev->dev,
-				"could not get request pin %d on device %s - conflicting mux mappings?\n",
-				pins[i],
-				pinctrl_dev_get_name(pctldev));
-			/* On error release all taken pins */
-			i--; /* this pin just failed */
-			for (; i >= 0; i--)
-				pin_free(pctldev, pins[i], NULL);
-			return -ENODEV;
-		}
-	}
-	return 0;
-}
-
-/**
- * release_pins() - release pins taken by earlier acquirement
- * @pctldev: the device to free the pins on
- * @group_selector: the group selector containing the pins to free
- */
-static void release_pins(struct pinctrl_dev *pctldev,
-			 unsigned group_selector)
-{
-	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
-	const unsigned *pins;
-	unsigned num_pins;
-	int ret;
-	int i;
-
-	ret = pctlops->get_group_pins(pctldev, group_selector,
-				      &pins, &num_pins);
-	if (ret) {
-		dev_err(pctldev->dev, "could not get pins to release for group selector %d\n",
-			group_selector);
-		return;
-	}
-	for (i = 0; i < num_pins; i++)
-		pin_free(pctldev, pins[i], NULL);
-}
-
-/**
- * pinmux_check_pin_group() - check function and pin group combo
- * @pctldev: device to check the pin group vs function for
- * @func_selector: the function selector to check the pin group for, we have
- *	already looked this up in the calling function
- * @pin_group: the pin group to match to the function
- *
- * This function will check that the pinmux driver can supply the
- * selected pin group for a certain function, returns the group selector if
- * the group and function selector will work fine together, else returns
- * negative
- */
-static int pinmux_check_pin_group(struct pinctrl_dev *pctldev,
-				  unsigned func_selector,
-				  const char *pin_group)
-{
-	const struct pinmux_ops *pmxops = pctldev->desc->pmxops;
-	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
-	int ret;
-
-	/*
-	 * If the driver does not support different pin groups for the
-	 * functions, we only support group 0, and assume this exists.
-	 */
-	if (!pctlops || !pctlops->list_groups)
-		return 0;
-
-	/*
-	 * Passing NULL (no specific group) will select the first and
-	 * hopefully only group of pins available for this function.
-	 */
-	if (!pin_group) {
-		char const * const *groups;
-		unsigned num_groups;
-
-		ret = pmxops->get_function_groups(pctldev, func_selector,
-						  &groups, &num_groups);
-		if (ret)
-			return ret;
-		if (num_groups < 1)
-			return -EINVAL;
-		ret = pinctrl_get_group_selector(pctldev, groups[0]);
-		if (ret < 0) {
-			dev_err(pctldev->dev,
-				"function %s wants group %s but the pin controller does not seem to have that group\n",
-				pmxops->get_function_name(pctldev, func_selector),
-				groups[0]);
-			return ret;
-		}
-
-		if (num_groups > 1)
-			dev_dbg(pctldev->dev,
-				"function %s support more than one group, default-selecting first group %s (%d)\n",
-				pmxops->get_function_name(pctldev, func_selector),
-				groups[0],
-				ret);
-
-		return ret;
-	}
-
-	dev_dbg(pctldev->dev,
-		"check if we have pin group %s on controller %s\n",
-		pin_group, pinctrl_dev_get_name(pctldev));
-
-	ret = pinctrl_get_group_selector(pctldev, pin_group);
-	if (ret < 0) {
-		dev_dbg(pctldev->dev,
-			"%s does not support pin group %s with function %s\n",
-			pinctrl_dev_get_name(pctldev),
-			pin_group,
-			pmxops->get_function_name(pctldev, func_selector));
-	}
-	return ret;
-}
-
-/**
- * pinmux_search_function() - check pin control driver for a certain function
- * @pctldev: device to check for function and position
- * @map: function map containing the function and position to look for
- * @func_selector: returns the applicable function selector if found
- * @group_selector: returns the applicable group selector if found
- *
- * This will search the pinmux driver for an applicable
- * function with a specific pin group, returns 0 if these can be mapped
- * negative otherwise
- */
-static int pinmux_search_function(struct pinctrl_dev *pctldev,
-				  struct pinctrl_map const *map,
-				  unsigned *func_selector,
-				  unsigned *group_selector)
+int pinmux_func_name_to_selector(struct pinctrl_dev *pctldev,
+				 const char *function)
 {
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
 	unsigned selector = 0;
@@ -407,168 +243,128 @@ static int pinmux_search_function(struct pinctrl_dev *pctldev,
 	while (ops->list_functions(pctldev, selector) >= 0) {
 		const char *fname = ops->get_function_name(pctldev,
 							   selector);
-		int ret;
-
-		if (!strcmp(map->function, fname)) {
-			/* Found the function, check pin group */
-			ret = pinmux_check_pin_group(pctldev, selector,
-						     map->group);
-			if (ret < 0)
-				return ret;
 
-			/* This function and group selector can be used */
-			*func_selector = selector;
-			*group_selector = ret;
-			return 0;
+		if (!strcmp(function, fname))
+			return selector;
 
-		}
 		selector++;
 	}
 
 	pr_err("%s does not support function %s\n",
-	       pinctrl_dev_get_name(pctldev), map->function);
+	       pinctrl_dev_get_name(pctldev), function);
 	return -EINVAL;
 }
 
-/**
- * pinmux_enable_muxmap() - enable a map entry for a certain pinmux
- */
-static int pinmux_enable_muxmap(struct pinctrl_dev *pctldev,
-				struct pinctrl *p,
-				struct device *dev,
-				const char *devname,
-				struct pinctrl_map const *map)
+int pinmux_map_to_setting(struct pinctrl_map const *map,
+			  struct pinctrl_setting *setting)
 {
-	unsigned func_selector;
-	unsigned group_selector;
-	struct pinmux_group *grp;
+	struct pinctrl_dev *pctldev = setting->pctldev;
+	const struct pinmux_ops *pmxops = pctldev->desc->pmxops;
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+	char const * const *groups;
+	unsigned num_groups;
 	int ret;
+	const char *group;
+	int i;
+	const unsigned *pins;
+	unsigned num_pins;
 
-	/*
-	 * Note that we're not locking the pinmux mutex here, because
-	 * this is only called at pinmux initialization time when it
-	 * has not been added to any list and thus is not reachable
-	 * by anyone else.
-	 */
+	setting->func_selector =
+		pinmux_func_name_to_selector(pctldev, map->function);
+	if (setting->func_selector < 0)
+		return setting->func_selector;
 
-	if (p->pctldev && p->pctldev != pctldev) {
-		dev_err(pctldev->dev,
-			"different pin control devices given for device %s, function %s\n",
-			devname, map->function);
+	ret = pmxops->get_function_groups(pctldev, setting->func_selector,
+					  &groups, &num_groups);
+	if (ret < 0)
+		return ret;
+	if (!num_groups)
 		return -EINVAL;
+
+	if (map->group) {
+		bool found = false;
+		group = map->group;
+		for (i = 0; i < num_groups; i++) {
+			if (!strcmp(group, groups[i])) {
+				found = true;
+				break;
+			}
+		}
+		if (!found)
+			return -EINVAL;
+	} else {
+		group = groups[0];
 	}
-	p->dev = dev;
-	p->pctldev = pctldev;
 
-	/* Now go into the driver and try to match a function and group */
-	ret = pinmux_search_function(pctldev, map, &func_selector,
-				     &group_selector);
-	if (ret < 0)
-		return ret;
+	setting->group_selector =
+		pinctrl_get_group_selector(pctldev, group);
+	if (setting->group_selector < 0)
+		return setting->group_selector;
 
-	/*
-	 * If the function selector is already set, it needs to be identical,
-	 * we support several groups with one function but not several
-	 * functions with one or several groups in the same pinmux.
-	 */
-	if (p->func_selector != UINT_MAX &&
-	    p->func_selector != func_selector) {
+	ret = pctlops->get_group_pins(pctldev, setting->group_selector,
+				      &pins, &num_pins);
+	if (ret) {
 		dev_err(pctldev->dev,
-			"dual function defines in the map for device %s\n",
-		       devname);
-		return -EINVAL;
+			"could not get pins for device %s group selector %d\n",
+			pinctrl_dev_get_name(pctldev), setting->group_selector);
+			return -ENODEV;
 	}
-	p->func_selector = func_selector;
-
-	/* Now add this group selector, we may have many of them */
-	grp = kmalloc(sizeof(*grp), GFP_KERNEL);
-	if (!grp)
-		return -ENOMEM;
-	grp->group_selector = group_selector;
-	ret = acquire_pins(pctldev, devname, group_selector);
-	if (ret) {
-		kfree(grp);
-		return ret;
+
+	/* Try to allocate all pins in this group, one by one */
+	for (i = 0; i < num_pins; i++) {
+		ret = pin_request(pctldev, pins[i], map->dev_name, NULL);
+		if (ret) {
+			dev_err(pctldev->dev,
+				"could not get request pin %d on device %s\n",
+				pins[i], pinctrl_dev_get_name(pctldev));
+			/* On error release all taken pins */
+			i--; /* this pin just failed */
+			for (; i >= 0; i--)
+				pin_free(pctldev, pins[i], NULL);
+			return -ENODEV;
+		}
 	}
-	list_add_tail(&grp->node, &p->groups);
 
 	return 0;
 }
 
-/**
- * pinmux_apply_muxmap() - apply a certain mux mapping entry
- */
-int pinmux_apply_muxmap(struct pinctrl_dev *pctldev,
-			struct pinctrl *p,
-			struct device *dev,
-			const char *devname,
-			struct pinctrl_map const *map)
+void pinmux_free_setting(struct pinctrl_setting const *setting)
 {
+	struct pinctrl_dev *pctldev = setting->pctldev;
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+	const unsigned *pins;
+	unsigned num_pins;
 	int ret;
+	int i;
 
-	ret = pinmux_enable_muxmap(pctldev, p, dev,
-				   devname, map);
+	ret = pctlops->get_group_pins(pctldev, setting->group_selector,
+				      &pins, &num_pins);
 	if (ret) {
-		pinmux_put(p);
-		return ret;
+		dev_err(pctldev->dev,
+			"could not get pins for device %s group selector %d\n",
+			pinctrl_dev_get_name(pctldev), setting->group_selector);
+		return;
 	}
 
-	return 0;
-}
-
-/**
- * pinmux_put() - free up the pinmux portions of a pin controller handle
- */
-void pinmux_put(struct pinctrl *p)
-{
-	struct list_head *node, *tmp;
-
-	list_for_each_safe(node, tmp, &p->groups) {
-		struct pinmux_group *grp =
-			list_entry(node, struct pinmux_group, node);
-		/* Release all pins taken by this group */
-		release_pins(p->pctldev, grp->group_selector);
-		list_del(node);
-		kfree(grp);
-	}
+	for (i = 0; i < num_pins; i++)
+		pin_free(pctldev, pins[i], NULL);
 }
 
-/**
- * pinmux_enable() - enable the pinmux portion of a pin control handle
- */
-int pinmux_enable(struct pinctrl *p)
+int pinmux_enable_setting(struct pinctrl_setting const *setting)
 {
-	struct pinctrl_dev *pctldev = p->pctldev;
+	struct pinctrl_dev *pctldev = setting->pctldev;
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
-	struct pinmux_group *grp;
-	int ret;
 
-	list_for_each_entry(grp, &p->groups, node) {
-		ret = ops->enable(pctldev, p->func_selector,
-				  grp->group_selector);
-		if (ret)
-			/*
-			 * TODO: call disable() on all groups we called
-			 * enable() on to this point?
-			 */
-			return ret;
-	}
-	return 0;
+	return ops->enable(pctldev, setting->func_selector,
+			   setting->group_selector);
 }
 
-/**
- * pinmux_disable() - disable the pinmux portions of a pin control handle
- */
-void pinmux_disable(struct pinctrl *p)
+void pinmux_disable_setting(struct pinctrl_setting const *setting)
 {
-	struct pinctrl_dev *pctldev = p->pctldev;
+	struct pinctrl_dev *pctldev = setting->pctldev;
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
-	struct pinmux_group *grp;
 
-	list_for_each_entry(grp, &p->groups, node) {
-		ops->disable(pctldev, p->func_selector,
-			     grp->group_selector);
-	}
+	ops->disable(pctldev, setting->func_selector, setting->group_selector);
 }
 
 #ifdef CONFIG_DEBUG_FS
@@ -639,29 +435,18 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 	return 0;
 }
 
-void pinmux_dbg_show(struct seq_file *s, struct pinctrl *p)
+void pinmux_dbg_show(struct seq_file *s, struct pinctrl_setting const *setting)
 {
-	struct pinctrl_dev *pctldev = p->pctldev;
-	const struct pinmux_ops *pmxops;
-	const struct pinctrl_ops *pctlops;
-	struct pinmux_group *grp;
-
-	pmxops = pctldev->desc->pmxops;
-	pctlops = pctldev->desc->pctlops;
-
-	seq_printf(s, " function: %s (%u),",
-		   pmxops->get_function_name(pctldev,
-					     p->func_selector),
-		   p->func_selector);
-
-	seq_printf(s, " groups: [");
-	list_for_each_entry(grp, &p->groups, node) {
-		seq_printf(s, " %s (%u)",
-			   pctlops->get_group_name(pctldev,
-						   grp->group_selector),
-			   grp->group_selector);
-	}
-	seq_printf(s, " ]");
+	struct pinctrl_dev *pctldev = setting->pctldev;
+	const struct pinmux_ops *pmxops = pctldev->desc->pmxops;
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+
+	seq_printf(s, "controller: %s group: %s (%u) function: %s (%u)\n",
+		   pinctrl_dev_get_name(pctldev),
+		   pctlops->get_group_name(pctldev, setting->group_selector),
+		   setting->group_selector,
+		   pmxops->get_function_name(pctldev, setting->func_selector),
+		   setting->func_selector);
 }
 
 static int pinmux_functions_open(struct inode *inode, struct file *file)
diff --git a/drivers/pinctrl/pinmux.h b/drivers/pinctrl/pinmux.h
index 84b8fe9..1500ae8 100644
--- a/drivers/pinctrl/pinmux.h
+++ b/drivers/pinctrl/pinmux.h
@@ -13,6 +13,7 @@
 #ifdef CONFIG_PINMUX
 
 int pinmux_check_ops(struct pinctrl_dev *pctldev);
+
 int pinmux_request_gpio(struct pinctrl_dev *pctldev,
 			struct pinctrl_gpio_range *range,
 			unsigned pin, unsigned gpio);
@@ -21,22 +22,16 @@ void pinmux_free_gpio(struct pinctrl_dev *pctldev, unsigned pin,
 int pinmux_gpio_direction(struct pinctrl_dev *pctldev,
 			  struct pinctrl_gpio_range *range,
 			  unsigned pin, bool input);
-static inline void pinmux_init_pinctrl_handle(struct pinctrl *p)
-{
-	p->func_selector = UINT_MAX;
-	INIT_LIST_HEAD(&p->groups);
-}
-int pinmux_apply_muxmap(struct pinctrl_dev *pctldev,
-			struct pinctrl *p,
-			struct device *dev,
-			const char *devname,
-			struct pinctrl_map const *map);
-void pinmux_put(struct pinctrl *p);
-int pinmux_enable(struct pinctrl *p);
-void pinmux_disable(struct pinctrl *p);
+
+int pinmux_map_to_setting(struct pinctrl_map const *map,
+			  struct pinctrl_setting *setting);
+void pinmux_free_setting(struct pinctrl_setting const *setting);
+int pinmux_enable_setting(struct pinctrl_setting const *setting);
+void pinmux_disable_setting(struct pinctrl_setting const *setting);
+
+void pinmux_dbg_show(struct seq_file *s, struct pinctrl_setting const *setting);
 void pinmux_init_device_debugfs(struct dentry *devroot,
 				struct pinctrl_dev *pctldev);
-void pinmux_dbg_show(struct seq_file *s, struct pinctrl *p);
 
 #else
 
@@ -65,28 +60,23 @@ static inline int pinmux_gpio_direction(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
-static inline void pinmux_init_pinctrl_handle(struct pinctrl *p)
-{
-}
-
-static inline int pinmux_apply_muxmap(struct pinctrl_dev *pctldev,
-				      struct pinctrl *p,
-				      struct device *dev,
-				      const char *devname,
-				      struct pinctrl_map const *map)
+static inline int pinmux_map_to_setting(struct pinctrl_map const *map,
+			  struct pinctrl_setting *setting)
 {
 	return 0;
 }
 
-static inline void pinmux_put(struct pinctrl *p)
+static inline void pinmux_free_setting(struct pinctrl_setting const *setting)
 {
 }
 
-static inline int pinmux_enable(struct pinctrl *p)
+static inline int pinmux_enable_setting(struct pinctrl_setting const *setting)
 {
+	return 0;
 }
 
-static inline void pinmux_disable(struct pinctrl *p)
+static inline void pinmux_disable_setting(
+			struct pinctrl_setting const *setting)
 {
 }
 
-- 
1.7.5.4

