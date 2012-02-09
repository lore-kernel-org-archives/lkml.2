Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358Ab2BITLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 14:11:50 -0500
Received: from mail.df.lth.se ([194.47.250.12]:38266 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758290Ab2BITLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 14:11:20 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Barry Song <21cnbao@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/3] pinctrl: factor pin control handles over to the core
Date: Thu,  9 Feb 2012 20:01:37 +0100
Message-Id: <1328814097-22818-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the per-devices struct pinctrl handles and device map
over from the pinmux part of the subsystem to the core pinctrl part.
This makes the device handles core infrastructure with the goal of
using these handles also for pin configuration, so that device
drivers (or boards etc) will need one and only one handle to the
pin control core.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/core.c           |  598 ++++++++++++++++++++++++++++++++-
 drivers/pinctrl/core.h           |   30 ++-
 drivers/pinctrl/pinmux.c         |  711 +++++---------------------------------
 drivers/pinctrl/pinmux.h         |   67 ++++-
 include/linux/pinctrl/consumer.h |    8 +-
 5 files changed, 779 insertions(+), 635 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 75c6a6b..ec32c54 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1,7 +1,7 @@
 /*
  * Core driver for the pin control subsystem
  *
- * Copyright (C) 2011 ST-Ericsson SA
+ * Copyright (C) 2011-2012 ST-Ericsson SA
  * Written on behalf of Linaro for ST-Ericsson
  * Based on bits of regulator core, gpio core and clk core
  *
@@ -30,10 +30,30 @@
 #include "pinmux.h"
 #include "pinconf.h"
 
+/**
+ * struct pinctrl_hog - a list item to stash control hogs
+ * @node: pin control hog list node
+ * @map: map entry responsible for this hogging
+ * @pmx: the pin control hogged by this item
+ */
+struct pinctrl_hog {
+	struct list_head node;
+	struct pinctrl_map const *map;
+	struct pinctrl *p;
+};
+
 /* Global list of pin control devices */
 static DEFINE_MUTEX(pinctrldev_list_mutex);
 static LIST_HEAD(pinctrldev_list);
 
+/* List of pin controller handles */
+static DEFINE_MUTEX(pinctrl_list_mutex);
+static LIST_HEAD(pinctrl_list);
+
+/* Global pinctrl maps */
+static struct pinctrl_map *pinctrl_maps;
+static unsigned pinctrl_maps_num;
+
 const char *pinctrl_dev_get_name(struct pinctrl_dev *pctldev)
 {
 	/* We're not allowed to register devices without name */
@@ -337,6 +357,476 @@ int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
 	return -EINVAL;
 }
 
+/**
+ * pinctrl_request_gpio() - request a single pin to be used in as GPIO
+ * @gpio: the GPIO pin number from the GPIO subsystem number space
+ *
+ * This function should *ONLY* be used from gpiolib-based GPIO drivers,
+ * as part of their gpio_request() semantics, platforms and individual drivers
+ * shall *NOT* request GPIO pins to be muxed in.
+ */
+int pinctrl_request_gpio(unsigned gpio)
+{
+	struct pinctrl_dev *pctldev;
+	struct pinctrl_gpio_range *range;
+	int ret;
+	int pin;
+
+	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
+	if (ret)
+		return -EINVAL;
+
+	/* Convert to the pin controllers number space */
+	pin = gpio - range->base + range->pin_base;
+
+	return pinmux_request_gpio(pctldev, range, pin, gpio);
+}
+EXPORT_SYMBOL_GPL(pinctrl_request_gpio);
+
+/**
+ * pinctrl_free_gpio() - free control on a single pin, currently used as GPIO
+ * @gpio: the GPIO pin number from the GPIO subsystem number space
+ *
+ * This function should *ONLY* be used from gpiolib-based GPIO drivers,
+ * as part of their gpio_free() semantics, platforms and individual drivers
+ * shall *NOT* request GPIO pins to be muxed out.
+ */
+void pinctrl_free_gpio(unsigned gpio)
+{
+	struct pinctrl_dev *pctldev;
+	struct pinctrl_gpio_range *range;
+	int ret;
+	int pin;
+
+	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
+	if (ret)
+		return;
+
+	/* Convert to the pin controllers number space */
+	pin = gpio - range->base + range->pin_base;
+
+	return pinmux_free_gpio(pctldev, pin, range);
+}
+EXPORT_SYMBOL_GPL(pinctrl_free_gpio);
+
+static int pinctrl_gpio_direction(unsigned gpio, bool input)
+{
+	struct pinctrl_dev *pctldev;
+	struct pinctrl_gpio_range *range;
+	int ret;
+	int pin;
+
+	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
+	if (ret)
+		return ret;
+
+	/* Convert to the pin controllers number space */
+	pin = gpio - range->base + range->pin_base;
+
+	return pinmux_gpio_direction(pctldev, range, pin, input);
+}
+
+/**
+ * pinctrl_gpio_direction_input() - request a GPIO pin to go into input mode
+ * @gpio: the GPIO pin number from the GPIO subsystem number space
+ *
+ * This function should *ONLY* be used from gpiolib-based GPIO drivers,
+ * as part of their gpio_direction_input() semantics, platforms and individual
+ * drivers shall *NOT* touch pin control GPIO calls.
+ */
+int pinctrl_gpio_direction_input(unsigned gpio)
+{
+	return pinctrl_gpio_direction(gpio, true);
+}
+EXPORT_SYMBOL_GPL(pinctrl_gpio_direction_input);
+
+/**
+ * pinctrl_gpio_direction_output() - request a GPIO pin to go into output mode
+ * @gpio: the GPIO pin number from the GPIO subsystem number space
+ *
+ * This function should *ONLY* be used from gpiolib-based GPIO drivers,
+ * as part of their gpio_direction_output() semantics, platforms and individual
+ * drivers shall *NOT* touch pin control GPIO calls.
+ */
+int pinctrl_gpio_direction_output(unsigned gpio)
+{
+	return pinctrl_gpio_direction(gpio, false);
+}
+EXPORT_SYMBOL_GPL(pinctrl_gpio_direction_output);
+
+/**
+ * pinctrl_get() - retrieves the pin controller handle for a certain device
+ * @dev: the device to get the pin controller handle for
+ * @name: an optional specific control mapping name or NULL, the name is only
+ *	needed if you want to have more than one mapping per device, or if you
+ *	need an anonymous pin control (not tied to any specific device)
+ */
+struct pinctrl *pinctrl_get(struct device *dev, const char *name)
+{
+	struct pinctrl_map const *map = NULL;
+	struct pinctrl_dev *pctldev = NULL;
+	const char *devname = NULL;
+	struct pinctrl *p;
+	bool found_map;
+	unsigned num_maps = 0;
+	int ret = -ENODEV;
+	int i;
+
+	/* We must have dev or ID or both */
+	if (!dev && !name)
+		return ERR_PTR(-EINVAL);
+
+	if (dev)
+		devname = dev_name(dev);
+
+	pr_debug("get pin control handle %s for device %s\n", name,
+		 devname ? devname : "(none)");
+
+	/*
+	 * create the state cookie holder struct pinctrl for each
+	 * mapping, this is what consumers will get when requesting
+	 * a pin control handle with pinctrl_get()
+	 */
+	p = kzalloc(sizeof(struct pinctrl), GFP_KERNEL);
+	if (p == NULL)
+		return ERR_PTR(-ENOMEM);
+	mutex_init(&p->mutex);
+	pinmux_init_pinctrl_handle(p);
+
+	/* Iterate over the pin control maps to locate the right ones */
+	for (i = 0; i < pinctrl_maps_num; i++) {
+		map = &pinctrl_maps[i];
+		found_map = false;
+
+		/*
+		 * First, try to find the pctldev given in the map
+		 */
+		pctldev = get_pinctrl_dev_from_devname(map->ctrl_dev_name);
+		if (!pctldev) {
+			pr_warning("could not find a pinctrl device for pinmux function %s, fishy, they shall all have one\n",
+				   map->function);
+			pr_warning("given pinctrl device name: %s",
+				   map->ctrl_dev_name);
+
+			/* Continue to check the other mappings anyway... */
+			continue;
+		}
+
+		pr_debug("in map, found pctldev %s to handle function %s",
+			 dev_name(pctldev->dev), map->function);
+
+
+		/*
+		 * If we're looking for a specific named map, this must match,
+		 * else we loop and look for the next.
+		 */
+		if (name != NULL) {
+			if (map->name == NULL)
+				continue;
+			if (strcmp(map->name, name))
+				continue;
+		}
+
+		/*
+		 * This is for the case where no device name is given, we
+		 * already know that the function name matches from above
+		 * code.
+		 */
+		if (!map->dev_name && (name != NULL))
+			found_map = true;
+
+		/* If the mapping has a device set up it must match */
+		if (map->dev_name &&
+		    (!devname || !strcmp(map->dev_name, devname)))
+			/* MATCH! */
+			found_map = true;
+
+		/* If this map is applicable, then apply it */
+		if (found_map) {
+			ret = pinmux_apply_muxmap(pctldev, p, dev,
+						   devname, map);
+			if (ret) {
+				kfree(p);
+				return ERR_PTR(ret);
+			}
+			num_maps++;
+		}
+	}
+
+	/* We should have atleast one map, right */
+	if (!num_maps) {
+		pr_err("could not find any mux maps for device %s, ID %s\n",
+		       devname ? devname : "(anonymous)",
+		       name ? name : "(undefined)");
+		kfree(p);
+		return ERR_PTR(-EINVAL);
+	}
+
+	pr_debug("found %u mux maps for device %s, UD %s\n",
+		 num_maps,
+		 devname ? devname : "(anonymous)",
+		 name ? name : "(undefined)");
+
+	/* Add the pinmux to the global list */
+	mutex_lock(&pinctrl_list_mutex);
+	list_add(&p->node, &pinctrl_list);
+	mutex_unlock(&pinctrl_list_mutex);
+
+	return p;
+}
+EXPORT_SYMBOL_GPL(pinctrl_get);
+
+/**
+ * pinctrl_put() - release a previously claimed pin control handle
+ * @p: a pin control handle previously claimed by pinctrl_get()
+ */
+void pinctrl_put(struct pinctrl *p)
+{
+	if (p == NULL)
+		return;
+
+	mutex_lock(&p->mutex);
+	if (p->usecount)
+		pr_warn("releasing pin control handle with active users!\n");
+	/* Free the groups and all acquired pins */
+	pinmux_put(p);
+	mutex_unlock(&p->mutex);
+
+	/* Remove from list */
+	mutex_lock(&pinctrl_list_mutex);
+	list_del(&p->node);
+	mutex_unlock(&pinctrl_list_mutex);
+
+	kfree(p);
+}
+EXPORT_SYMBOL_GPL(pinctrl_put);
+
+/**
+ * pinctrl_enable() - enable a certain pin controller setting
+ * @p: the pin control handle to enable, previously claimed by pinctrl_get()
+ */
+int pinctrl_enable(struct pinctrl *p)
+{
+	int ret = 0;
+
+	if (p == NULL)
+		return -EINVAL;
+	mutex_lock(&p->mutex);
+	if (p->usecount++ == 0) {
+		ret = pinmux_enable(p);
+		if (ret)
+			p->usecount--;
+	}
+	mutex_unlock(&p->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pinctrl_enable);
+
+/**
+ * pinctrl_disable() - disable a certain pin control setting
+ * @p: the pin control handle to disable, previously claimed by pinctrl_get()
+ */
+void pinctrl_disable(struct pinctrl *p)
+{
+	if (p == NULL)
+		return;
+
+	mutex_lock(&p->mutex);
+	if (--p->usecount == 0) {
+		pinmux_disable(p);
+	}
+	mutex_unlock(&p->mutex);
+}
+EXPORT_SYMBOL_GPL(pinctrl_disable);
+
+/**
+ * pinctrl_register_mappings() - register a set of pin controller mappings
+ * @maps: the pincontrol mappings table to register, this should be marked with
+ *	__initdata so it can be discarded after boot, this function will
+ *	perform a shallow copy for the mapping entries.
+ * @num_maps: the number of maps in the mapping table
+ *
+ * Only call this once during initialization of your machine, the function is
+ * tagged as __init and won't be callable after init has completed. The map
+ * passed into this function will be owned by the pinmux core and cannot be
+ * freed.
+ */
+int __init pinctrl_register_mappings(struct pinctrl_map const *maps,
+				     unsigned num_maps)
+{
+	void *tmp_maps;
+	int i;
+
+	pr_debug("add %d pinmux maps\n", num_maps);
+
+	/* First sanity check the new mapping */
+	for (i = 0; i < num_maps; i++) {
+		if (!maps[i].name) {
+			pr_err("failed to register map %d: no map name given\n",
+					i);
+			return -EINVAL;
+		}
+
+		if (!maps[i].ctrl_dev_name) {
+			pr_err("failed to register map %s (%d): no pin control device given\n",
+			       maps[i].name, i);
+			return -EINVAL;
+		}
+
+		if (!maps[i].function) {
+			pr_err("failed to register map %s (%d): no function ID given\n",
+					maps[i].name, i);
+			return -EINVAL;
+		}
+
+		if (!maps[i].dev_name)
+			pr_debug("add system map %s function %s with no device\n",
+				 maps[i].name,
+				 maps[i].function);
+		else
+			pr_debug("register map %s, function %s\n",
+				 maps[i].name,
+				 maps[i].function);
+	}
+
+	/*
+	 * Make a copy of the map array - string pointers will end up in the
+	 * kernel const section anyway so these do not need to be deep copied.
+	 */
+	if (!pinctrl_maps_num) {
+		/* On first call, just copy them */
+		tmp_maps = kmemdup(maps,
+				   sizeof(struct pinctrl_map) * num_maps,
+				   GFP_KERNEL);
+		if (!tmp_maps)
+			return -ENOMEM;
+	} else {
+		/* Subsequent calls, reallocate array to new size */
+		size_t oldsize = sizeof(struct pinctrl_map) * pinctrl_maps_num;
+		size_t newsize = sizeof(struct pinctrl_map) * num_maps;
+
+		tmp_maps = krealloc(pinctrl_maps,
+				    oldsize + newsize, GFP_KERNEL);
+		if (!tmp_maps)
+			return -ENOMEM;
+		memcpy((tmp_maps + oldsize), maps, newsize);
+	}
+
+	pinctrl_maps = tmp_maps;
+	pinctrl_maps_num += num_maps;
+	return 0;
+}
+
+/* Hog a single map entry and add to the hoglist */
+static int pinctrl_hog_map(struct pinctrl_dev *pctldev,
+			   struct pinctrl_map const *map)
+{
+	struct pinctrl_hog *hog;
+	struct pinctrl *p;
+	int ret;
+
+	if (map->dev_name) {
+		/*
+		 * TODO: the day we have device tree support, we can
+		 * traverse the device tree and hog to specific device nodes
+		 * without any problems, so then we can hog pinmuxes for
+		 * all devices that just want a static pin mux at this point.
+		 */
+		dev_err(pctldev->dev, "map %s wants to hog a non-system pinmux, this is not going to work\n",
+				map->name);
+		return -EINVAL;
+	}
+
+	hog = kzalloc(sizeof(struct pinctrl_hog), GFP_KERNEL);
+	if (!hog)
+		return -ENOMEM;
+
+	p = pinctrl_get(NULL, map->name);
+	if (IS_ERR(p)) {
+		kfree(hog);
+		dev_err(pctldev->dev,
+			"could not get the %s pin control mapping for hogging\n",
+			map->name);
+		return PTR_ERR(p);
+	}
+
+	ret = pinctrl_enable(p);
+	if (ret) {
+		pinctrl_put(p);
+		kfree(hog);
+		dev_err(pctldev->dev,
+			"could not enable the %s pin control mapping for hogging\n",
+			map->name);
+		return ret;
+	}
+
+	hog->map = map;
+	hog->p = p;
+
+	dev_info(pctldev->dev, "hogged map %s, function %s\n", map->name,
+		 map->function);
+	mutex_lock(&pctldev->pinctrl_hogs_lock);
+	list_add(&hog->node, &pctldev->pinctrl_hogs);
+	mutex_unlock(&pctldev->pinctrl_hogs_lock);
+
+	return 0;
+}
+
+/**
+ * pinctrl_hog_maps() - hog specific map entries on controller device
+ * @pctldev: the pin control device to hog entries on
+ *
+ * When the pin controllers are registered, there may be some specific pinmux
+ * map entries that need to be hogged, i.e. get+enabled until the system shuts
+ * down.
+ */
+int pinctrl_hog_maps(struct pinctrl_dev *pctldev)
+{
+	struct device *dev = pctldev->dev;
+	const char *devname = dev_name(dev);
+	int ret;
+	int i;
+
+	INIT_LIST_HEAD(&pctldev->pinctrl_hogs);
+	mutex_init(&pctldev->pinctrl_hogs_lock);
+
+	for (i = 0; i < pinctrl_maps_num; i++) {
+		struct pinctrl_map const *map = &pinctrl_maps[i];
+
+		if (!map->hog_on_boot)
+			continue;
+
+		if (map->ctrl_dev_name &&
+		    !strcmp(map->ctrl_dev_name, devname)) {
+			/* OK time to hog! */
+			ret = pinctrl_hog_map(pctldev, map);
+			if (ret)
+				return ret;
+		}
+	}
+	return 0;
+}
+
+/**
+ * pinctrl_unhog_maps() - unhog specific map entries on controller device
+ * @pctldev: the pin control device to unhog entries on
+ */
+void pinctrl_unhog_maps(struct pinctrl_dev *pctldev)
+{
+	struct list_head *node, *tmp;
+
+	mutex_lock(&pctldev->pinctrl_hogs_lock);
+	list_for_each_safe(node, tmp, &pctldev->pinctrl_hogs) {
+		struct pinctrl_hog *hog =
+			list_entry(node, struct pinctrl_hog, node);
+		pinctrl_disable(hog->p);
+		pinctrl_put(hog->p);
+		list_del(node);
+		kfree(hog);
+	}
+	mutex_unlock(&pctldev->pinctrl_hogs_lock);
+}
+
 #ifdef CONFIG_DEBUG_FS
 
 static int pinctrl_pins_show(struct seq_file *s, void *what)
@@ -427,6 +917,43 @@ static int pinctrl_gpioranges_show(struct seq_file *s, void *what)
 	return 0;
 }
 
+static int pinctrl_maps_show(struct seq_file *s, void *what)
+{
+	int i;
+
+	seq_puts(s, "Pinctrl maps:\n");
+
+	for (i = 0; i < pinctrl_maps_num; i++) {
+		struct pinctrl_map const *map = &pinctrl_maps[i];
+
+		seq_printf(s, "%s:\n", map->name);
+		if (map->dev_name)
+			seq_printf(s, "  device: %s\n",
+				   map->dev_name);
+		else
+			seq_printf(s, "  SYSTEM MUX\n");
+		seq_printf(s, "  controlling device %s\n",
+			   map->ctrl_dev_name);
+		seq_printf(s, "  function: %s\n", map->function);
+		seq_printf(s, "  group: %s\n", map->group ? map->group :
+			   "(default)");
+	}
+	return 0;
+}
+
+static int pinmux_hogs_show(struct seq_file *s, void *what)
+{
+	struct pinctrl_dev *pctldev = s->private;
+	struct pinctrl_hog *hog;
+
+	seq_puts(s, "Pin control map hogs held by device\n");
+
+	list_for_each_entry(hog, &pctldev->pinctrl_hogs, node)
+		seq_printf(s, "%s\n", hog->map->name);
+
+	return 0;
+}
+
 static int pinctrl_devices_show(struct seq_file *s, void *what)
 {
 	struct pinctrl_dev *pctldev;
@@ -450,6 +977,32 @@ static int pinctrl_devices_show(struct seq_file *s, void *what)
 	return 0;
 }
 
+static int pinctrl_show(struct seq_file *s, void *what)
+{
+	struct pinctrl *p;
+
+	seq_puts(s, "Requested pin control handlers their pinmux maps:\n");
+	list_for_each_entry(p, &pinctrl_list, node) {
+		struct pinctrl_dev *pctldev = p->pctldev;
+
+		if (!pctldev) {
+			seq_puts(s, "NO PIN CONTROLLER DEVICE\n");
+			continue;
+		}
+
+		seq_printf(s, "device: %s",
+			   pinctrl_dev_get_name(p->pctldev));
+
+		pinmux_dbg_show(s, p);
+
+		seq_printf(s, " users: %u map-> %s\n",
+			   p->usecount,
+			   p->dev ? dev_name(p->dev) : "(system)");
+	}
+
+	return 0;
+}
+
 static int pinctrl_pins_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, pinctrl_pins_show, inode->i_private);
@@ -465,11 +1018,26 @@ static int pinctrl_gpioranges_open(struct inode *inode, struct file *file)
 	return single_open(file, pinctrl_gpioranges_show, inode->i_private);
 }
 
+static int pinctrl_maps_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinctrl_maps_show, inode->i_private);
+}
+
+static int pinmux_hogs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinmux_hogs_show, inode->i_private);
+}
+
 static int pinctrl_devices_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, pinctrl_devices_show, NULL);
 }
 
+static int pinctrl_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinctrl_show, NULL);
+}
+
 static const struct file_operations pinctrl_pins_ops = {
 	.open		= pinctrl_pins_open,
 	.read		= seq_read,
@@ -491,6 +1059,20 @@ static const struct file_operations pinctrl_gpioranges_ops = {
 	.release	= single_release,
 };
 
+static const struct file_operations pinctrl_maps_ops = {
+	.open		= pinctrl_maps_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations pinmux_hogs_ops = {
+	.open		= pinmux_hogs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static const struct file_operations pinctrl_devices_ops = {
 	.open		= pinctrl_devices_open,
 	.read		= seq_read,
@@ -498,6 +1080,13 @@ static const struct file_operations pinctrl_devices_ops = {
 	.release	= single_release,
 };
 
+static const struct file_operations pinctrl_ops = {
+	.open		= pinctrl_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static struct dentry *debugfs_root;
 
 static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
@@ -519,6 +1108,10 @@ static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
 			    device_root, pctldev, &pinctrl_groups_ops);
 	debugfs_create_file("gpio-ranges", S_IFREG | S_IRUGO,
 			    device_root, pctldev, &pinctrl_gpioranges_ops);
+	debugfs_create_file("pinctrl-maps", S_IFREG | S_IRUGO,
+			    device_root, pctldev, &pinctrl_maps_ops);
+	debugfs_create_file("pinmux-hogs", S_IFREG | S_IRUGO,
+			    device_root, pctldev, &pinmux_hogs_ops);
 	pinmux_init_device_debugfs(device_root, pctldev);
 	pinconf_init_device_debugfs(device_root, pctldev);
 }
@@ -539,7 +1132,8 @@ static void pinctrl_init_debugfs(void)
 
 	debugfs_create_file("pinctrl-devices", S_IFREG | S_IRUGO,
 			    debugfs_root, NULL, &pinctrl_devices_ops);
-	pinmux_init_debugfs(debugfs_root);
+	debugfs_create_file("pinctrl-handles", S_IFREG | S_IRUGO,
+			    debugfs_root, NULL, &pinctrl_ops);
 }
 
 #else /* CONFIG_DEBUG_FS */
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 7a89888..a50cdb0 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -30,6 +30,7 @@ struct pinctrl_gpio_range;
  *	subsystem
  * @pinctrl_hogs_lock: lock for the pin control hog list
  * @pinctrl_hogs: list of pin control maps hogged by this device
+ * @device_root: debugfs root for this device
  */
 struct pinctrl_dev {
 	struct list_head node;
@@ -41,12 +42,37 @@ struct pinctrl_dev {
 	struct device *dev;
 	struct module *owner;
 	void *driver_data;
+	struct mutex pinctrl_hogs_lock;
+	struct list_head pinctrl_hogs;
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *device_root;
 #endif
+};
+
+/**
+ * struct pinctrl - per-device pin control state holder
+ * @node: global list node
+ * @dev: the device using this pin control handle
+ * @usecount: the number of active users of this pin controller setting, used
+ *	to keep track of nested use cases
+ * @pctldev: pin control device handling this pin control handle
+ * @mutex: a lock for the pin control state holder
+ * @func_selector: the function selector for the pinmux device handling
+ *	this pinmux
+ * @groups: the group selectors for the pinmux device and
+ *	selector combination handling this pinmux, this is a list that
+ *	will be traversed on all pinmux operations such as
+ *	get/put/enable/disable
+ */
+struct pinctrl {
+	struct list_head node;
+	struct device *dev;
+	unsigned usecount;
+	struct pinctrl_dev *pctldev;
+	struct mutex mutex;
 #ifdef CONFIG_PINMUX
-	struct mutex pinctrl_hogs_lock;
-	struct list_head pinctrl_hogs;
+	unsigned func_selector;
+	struct list_head groups;
 #endif
 };
 
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 773835d..fe4a007 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -28,14 +28,7 @@
 #include <linux/pinctrl/machine.h>
 #include <linux/pinctrl/pinmux.h>
 #include "core.h"
-
-/* List of pin controller handles */
-static DEFINE_MUTEX(pinctrl_list_mutex);
-static LIST_HEAD(pinctrl_list);
-
-/* Global pinctrl maps */
-static struct pinctrl_map *pinctrl_maps;
-static unsigned pinctrl_maps_num;
+#include "pinmux.h"
 
 /**
  * struct pinmux_group - group list item for pinmux groups
@@ -48,43 +41,6 @@ struct pinmux_group {
 };
 
 /**
- * struct pinctrl - per-device pin control state holder
- * @node: global list node
- * @dev: the device using this pin control handle
- * @usecount: the number of active users of this pin controller setting, used
- *	to keep track of nested use cases
- * @pctldev: pin control device handling this pin control handle
- * @func_selector: the function selector for the pinmux device handling
- *	this pinmux
- * @groups: the group selectors for the pinmux device and
- *	selector combination handling this pinmux, this is a list that
- *	will be traversed on all pinmux operations such as
- *	get/put/enable/disable
- * @mutex: a lock for the pinmux state holder
- */
-struct pinctrl {
-	struct list_head node;
-	struct device *dev;
-	unsigned usecount;
-	struct pinctrl_dev *pctldev;
-	unsigned func_selector;
-	struct list_head groups;
-	struct mutex mutex;
-};
-
-/**
- * struct pinctrl_hog - a list item to stash control hogs
- * @node: pin control hog list node
- * @map: map entry responsible for this hogging
- * @pmx: the pin control hogged by this item
- */
-struct pinctrl_hog {
-	struct list_head node;
-	struct pinctrl_map const *map;
-	struct pinctrl *p;
-};
-
-/**
  * pin_request() - request a single pin to be muxed in, typically for GPIO
  * @pin: the pin number in the global pin space
  * @function: a functional name to give to this pin, passed to the driver
@@ -207,28 +163,18 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 }
 
 /**
- * pinctrl_request_gpio() - request a single pin to be used in as GPIO
- * @gpio: the GPIO pin number from the GPIO subsystem number space
- *
- * This function should *ONLY* be used from gpiolib-based GPIO drivers,
- * as part of their gpio_request() semantics, platforms and individual drivers
- * shall *NOT* request GPIO pins to be muxed in.
+ * pinmux_request_gpio() - request pinmuxing for a GPIO pin
+ * @pctldev: pin controller device affected
+ * @pin: the pin to mux in for GPIO
+ * @range: the applicable GPIO range
  */
-int pinctrl_request_gpio(unsigned gpio)
+int pinmux_request_gpio(struct pinctrl_dev *pctldev,
+			struct pinctrl_gpio_range *range,
+			unsigned pin, unsigned gpio)
 {
 	char gpiostr[16];
 	const char *function;
-	struct pinctrl_dev *pctldev;
-	struct pinctrl_gpio_range *range;
 	int ret;
-	int pin;
-
-	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
-	if (ret)
-		return -EINVAL;
-
-	/* Convert to the pin controllers number space */
-	pin = gpio - range->base + range->pin_base;
 
 	/* Conjure some name stating what chip and pin this is taken by */
 	snprintf(gpiostr, 15, "%s:%d", range->name, gpio);
@@ -243,53 +189,38 @@ int pinctrl_request_gpio(unsigned gpio)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(pinctrl_request_gpio);
 
 /**
- * pinctrl_free_gpio() - free control on a single pin, currently used as GPIO
- * @gpio: the GPIO pin number from the GPIO subsystem number space
- *
- * This function should *ONLY* be used from gpiolib-based GPIO drivers,
- * as part of their gpio_free() semantics, platforms and individual drivers
- * shall *NOT* request GPIO pins to be muxed out.
+ * pinmux_free_gpio() - release a pin from GPIO muxing
+ * @pctldev: the pin controller device for the pin
+ * @pin: the affected currently GPIO-muxed in pin
+ * @range: applicable GPIO range
  */
-void pinctrl_free_gpio(unsigned gpio)
+void pinmux_free_gpio(struct pinctrl_dev *pctldev, unsigned pin,
+		      struct pinctrl_gpio_range *range)
 {
-	struct pinctrl_dev *pctldev;
-	struct pinctrl_gpio_range *range;
-	int ret;
-	int pin;
 	const char *func;
 
-	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
-	if (ret)
-		return;
-
-	/* Convert to the pin controllers number space */
-	pin = gpio - range->base + range->pin_base;
-
 	func = pin_free(pctldev, pin, range);
 	kfree(func);
 }
-EXPORT_SYMBOL_GPL(pinctrl_free_gpio);
 
-static int pinctrl_gpio_direction(unsigned gpio, bool input)
+/**
+ * pinmux_gpio_direction() - set the direction of a single muxed-in GPIO pin
+ * @pctldev: the pin controller handling this pin
+ * @range: applicable GPIO range
+ * @pin: the affected GPIO pin in this controller
+ * @input: true if we set the pin as input, false for output
+ */
+int pinmux_gpio_direction(struct pinctrl_dev *pctldev,
+			  struct pinctrl_gpio_range *range,
+			  unsigned pin, bool input)
 {
-	struct pinctrl_dev *pctldev;
-	struct pinctrl_gpio_range *range;
 	const struct pinmux_ops *ops;
 	int ret;
-	int pin;
-
-	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
-	if (ret)
-		return ret;
 
 	ops = pctldev->desc->pmxops;
 
-	/* Convert to the pin controllers number space */
-	pin = gpio - range->base + range->pin_base;
-
 	if (ops->gpio_set_direction)
 		ret = ops->gpio_set_direction(pctldev, range, pin, input);
 	else
@@ -299,112 +230,6 @@ static int pinctrl_gpio_direction(unsigned gpio, bool input)
 }
 
 /**
- * pinctrl_gpio_direction_input() - request a GPIO pin to go into input mode
- * @gpio: the GPIO pin number from the GPIO subsystem number space
- *
- * This function should *ONLY* be used from gpiolib-based GPIO drivers,
- * as part of their gpio_direction_input() semantics, platforms and individual
- * drivers shall *NOT* touch pin control GPIO calls.
- */
-int pinctrl_gpio_direction_input(unsigned gpio)
-{
-	return pinctrl_gpio_direction(gpio, true);
-}
-EXPORT_SYMBOL_GPL(pinctrl_gpio_direction_input);
-
-/**
- * pinctrl_gpio_direction_output() - request a GPIO pin to go into output mode
- * @gpio: the GPIO pin number from the GPIO subsystem number space
- *
- * This function should *ONLY* be used from gpiolib-based GPIO drivers,
- * as part of their gpio_direction_output() semantics, platforms and individual
- * drivers shall *NOT* touch pin control GPIO calls.
- */
-int pinctrl_gpio_direction_output(unsigned gpio)
-{
-	return pinctrl_gpio_direction(gpio, false);
-}
-EXPORT_SYMBOL_GPL(pinctrl_gpio_direction_output);
-
-/**
- * pinctrl_register_mappings() - register a set of pin controller mappings
- * @maps: the pincontrol mappings table to register, this should be marked with
- *	__initdata so it can be discarded after boot, this function will
- *	perform a shallow copy for the mapping entries.
- * @num_maps: the number of maps in the mapping table
- *
- * Only call this once during initialization of your machine, the function is
- * tagged as __init and won't be callable after init has completed. The map
- * passed into this function will be owned by the pinmux core and cannot be
- * freed.
- */
-int __init pinctrl_register_mappings(struct pinctrl_map const *maps,
-				     unsigned num_maps)
-{
-	void *tmp_maps;
-	int i;
-
-	pr_debug("add %d pinmux maps\n", num_maps);
-
-	/* First sanity check the new mapping */
-	for (i = 0; i < num_maps; i++) {
-		if (!maps[i].name) {
-			pr_err("failed to register map %d: no map name given\n",
-					i);
-			return -EINVAL;
-		}
-
-		if (!maps[i].ctrl_dev_name) {
-			pr_err("failed to register map %s (%d): no pin control device given\n",
-			       maps[i].name, i);
-			return -EINVAL;
-		}
-
-		if (!maps[i].function) {
-			pr_err("failed to register map %s (%d): no function ID given\n",
-					maps[i].name, i);
-			return -EINVAL;
-		}
-
-		if (!maps[i].dev_name)
-			pr_debug("add system map %s function %s with no device\n",
-				 maps[i].name,
-				 maps[i].function);
-		else
-			pr_debug("register map %s, function %s\n",
-				 maps[i].name,
-				 maps[i].function);
-	}
-
-	/*
-	 * Make a copy of the map array - string pointers will end up in the
-	 * kernel const section anyway so these do not need to be deep copied.
-	 */
-	if (!pinctrl_maps_num) {
-		/* On first call, just copy them */
-		tmp_maps = kmemdup(maps,
-				   sizeof(struct pinctrl_map) * num_maps,
-				   GFP_KERNEL);
-		if (!tmp_maps)
-			return -ENOMEM;
-	} else {
-		/* Subsequent calls, reallocate array to new size */
-		size_t oldsize = sizeof(struct pinctrl_map) * pinctrl_maps_num;
-		size_t newsize = sizeof(struct pinctrl_map) * num_maps;
-
-		tmp_maps = krealloc(pinctrl_maps,
-				    oldsize + newsize, GFP_KERNEL);
-		if (!tmp_maps)
-			return -ENOMEM;
-		memcpy((tmp_maps + oldsize), maps, newsize);
-	}
-
-	pinctrl_maps = tmp_maps;
-	pinctrl_maps_num += num_maps;
-	return 0;
-}
-
-/**
  * acquire_pins() - acquire all the pins for a certain function on a pinmux
  * @pctldev: the device to take the pins on
  * @func_selector: the function selector to acquire the pins for
@@ -660,227 +485,81 @@ static int pinmux_enable_muxmap(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
-static void pinmux_free_groups(struct pinctrl *p)
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
-}
-
 /**
- * pinctrl_get() - retrieves the pin controller handle for a certain device
- * @dev: the device to get the pin controller handle for
- * @name: an optional specific control mapping name or NULL, the name is only
- *	needed if you want to have more than one mapping per device, or if you
- *	need an anonymous pin control (not tied to any specific device)
+ * pinmux_apply_muxmap() - apply a certain mux mapping entry
  */
-struct pinctrl *pinctrl_get(struct device *dev, const char *name)
+int pinmux_apply_muxmap(struct pinctrl_dev *pctldev,
+			struct pinctrl *p,
+			struct device *dev,
+			const char *devname,
+			struct pinctrl_map const *map)
 {
-	struct pinctrl_map const *map = NULL;
-	struct pinctrl_dev *pctldev = NULL;
-	const char *devname = NULL;
-	struct pinctrl *p;
-	bool found_map;
-	unsigned num_maps = 0;
-	int ret = -ENODEV;
-	int i;
-
-	/* We must have dev or ID or both */
-	if (!dev && !name)
-		return ERR_PTR(-EINVAL);
-
-	if (dev)
-		devname = dev_name(dev);
-
-	pr_debug("get mux %s for device %s\n", name,
-		 devname ? devname : "(none)");
-
-	/*
-	 * create the state cookie holder struct pinmux for each
-	 * mapping, this is what consumers will get when requesting
-	 * a pinmux handle with pinmux_get()
-	 */
-	p = kzalloc(sizeof(struct pinctrl), GFP_KERNEL);
-	if (p == NULL)
-		return ERR_PTR(-ENOMEM);
-	mutex_init(&p->mutex);
-	p->func_selector = UINT_MAX;
-	INIT_LIST_HEAD(&p->groups);
-
-	/* Iterate over the pin control maps to locate the right ones */
-	for (i = 0; i < pinctrl_maps_num; i++) {
-		map = &pinctrl_maps[i];
-		found_map = false;
-
-		/*
-		 * First, try to find the pctldev given in the map
-		 */
-		pctldev = get_pinctrl_dev_from_devname(map->ctrl_dev_name);
-		if (!pctldev) {
-			pr_warning("could not find a pinctrl device for pinmux function %s, fishy, they shall all have one\n",
-				   map->function);
-			pr_warning("given pinctrl device name: %s",
-				   map->ctrl_dev_name);
-
-			/* Continue to check the other mappings anyway... */
-			continue;
-		}
-
-		pr_debug("in map, found pctldev %s to handle function %s",
-			 dev_name(pctldev->dev), map->function);
-
-
-		/*
-		 * If we're looking for a specific named map, this must match,
-		 * else we loop and look for the next.
-		 */
-		if (name != NULL) {
-			if (map->name == NULL)
-				continue;
-			if (strcmp(map->name, name))
-				continue;
-		}
-
-		/*
-		 * This is for the case where no device name is given, we
-		 * already know that the function name matches from above
-		 * code.
-		 */
-		if (!map->dev_name && (name != NULL))
-			found_map = true;
-
-		/* If the mapping has a device set up it must match */
-		if (map->dev_name &&
-		    (!devname || !strcmp(map->dev_name, devname)))
-			/* MATCH! */
-			found_map = true;
-
-		/* If this map is applicable, then apply it */
-		if (found_map) {
-			ret = pinmux_enable_muxmap(pctldev, p, dev,
-						   devname, map);
-			if (ret) {
-				pinmux_free_groups(p);
-				kfree(p);
-				return ERR_PTR(ret);
-			}
-			num_maps++;
-		}
-	}
-
+	int ret;
 
-	/* We should have atleast one map, right */
-	if (!num_maps) {
-		pr_err("could not find any mux maps for device %s, ID %s\n",
-		       devname ? devname : "(anonymous)",
-		       name ? name : "(undefined)");
-		kfree(p);
-		return ERR_PTR(-EINVAL);
+	ret = pinmux_enable_muxmap(pctldev, p, dev,
+				   devname, map);
+	if (ret) {
+		pinmux_put(p);
+		return ret;
 	}
 
-	pr_debug("found %u mux maps for device %s, UD %s\n",
-		 num_maps,
-		 devname ? devname : "(anonymous)",
-		 name ? name : "(undefined)");
-
-	/* Add the pinmux to the global list */
-	mutex_lock(&pinctrl_list_mutex);
-	list_add(&p->node, &pinctrl_list);
-	mutex_unlock(&pinctrl_list_mutex);
-
-	return p;
+	return 0;
 }
-EXPORT_SYMBOL_GPL(pinctrl_get);
 
 /**
- * pinctrl_put() - release a previously claimed pin control handle
- * @p: a pin control handle previously claimed by pinctrl_get()
+ * pinmux_put() - free up the pinmux portions of a pin controller handle
  */
-void pinctrl_put(struct pinctrl *p)
+void pinmux_put(struct pinctrl *p)
 {
-	if (p == NULL)
-		return;
-
-	mutex_lock(&p->mutex);
-	if (p->usecount)
-		pr_warn("releasing pin control handle with active users!\n");
-	/* Free the groups and all acquired pins */
-	pinmux_free_groups(p);
-	mutex_unlock(&p->mutex);
-
-	/* Remove from list */
-	mutex_lock(&pinctrl_list_mutex);
-	list_del(&p->node);
-	mutex_unlock(&pinctrl_list_mutex);
+	struct list_head *node, *tmp;
 
-	kfree(p);
+	list_for_each_safe(node, tmp, &p->groups) {
+		struct pinmux_group *grp =
+			list_entry(node, struct pinmux_group, node);
+		/* Release all pins taken by this group */
+		release_pins(p->pctldev, grp->group_selector);
+		list_del(node);
+		kfree(grp);
+	}
 }
-EXPORT_SYMBOL_GPL(pinctrl_put);
 
 /**
- * pinctrl_enable() - enable a certain pin controller setting
- * @p: the pin control handle to enable, previously claimed by pinctrl_get()
+ * pinmux_enable() - enable the pinmux portion of a pin control handle
  */
-int pinctrl_enable(struct pinctrl *p)
+int pinmux_enable(struct pinctrl *p)
 {
-	int ret = 0;
+	struct pinctrl_dev *pctldev = p->pctldev;
+	const struct pinmux_ops *ops = pctldev->desc->pmxops;
+	struct pinmux_group *grp;
+	int ret;
 
-	if (p == NULL)
-		return -EINVAL;
-	mutex_lock(&p->mutex);
-	if (p->usecount++ == 0) {
-		struct pinctrl_dev *pctldev = p->pctldev;
-		const struct pinmux_ops *ops = pctldev->desc->pmxops;
-		struct pinmux_group *grp;
-
-		list_for_each_entry(grp, &p->groups, node) {
-			ret = ops->enable(pctldev, p->func_selector,
-					  grp->group_selector);
-			if (ret) {
-				/*
-				 * TODO: call disable() on all groups we called
-				 * enable() on to this point?
-				 */
-				p->usecount--;
-				break;
-			}
-		}
+	list_for_each_entry(grp, &p->groups, node) {
+		ret = ops->enable(pctldev, p->func_selector,
+				  grp->group_selector);
+		if (ret)
+			/*
+			 * TODO: call disable() on all groups we called
+			 * enable() on to this point?
+			 */
+			return ret;
 	}
-	mutex_unlock(&p->mutex);
-	return ret;
+	return 0;
 }
-EXPORT_SYMBOL_GPL(pinctrl_enable);
 
 /**
- * pinctrl_disable() - disable a certain pin control setting
- * @p: the pin control handle to disable, previously claimed by pinctrl_get()
+ * pinmux_disable() - disable the pinmux portions of a pin control handle
  */
-void pinctrl_disable(struct pinctrl *p)
+void pinmux_disable(struct pinctrl *p)
 {
-	if (p == NULL)
-		return;
-
-	mutex_lock(&p->mutex);
-	if (--p->usecount == 0) {
-		struct pinctrl_dev *pctldev = p->pctldev;
-		const struct pinmux_ops *ops = pctldev->desc->pmxops;
-		struct pinmux_group *grp;
+	struct pinctrl_dev *pctldev = p->pctldev;
+	const struct pinmux_ops *ops = pctldev->desc->pmxops;
+	struct pinmux_group *grp;
 
-		list_for_each_entry(grp, &p->groups, node) {
-			ops->disable(pctldev, p->func_selector,
-				     grp->group_selector);
-		}
+	list_for_each_entry(grp, &p->groups, node) {
+		ops->disable(pctldev, p->func_selector,
+			     grp->group_selector);
 	}
-	mutex_unlock(&p->mutex);
 }
-EXPORT_SYMBOL_GPL(pinctrl_disable);
 
 int pinmux_check_ops(struct pinctrl_dev *pctldev)
 {
@@ -910,116 +589,6 @@ int pinmux_check_ops(struct pinctrl_dev *pctldev)
 	return 0;
 }
 
-/* Hog a single map entry and add to the hoglist */
-static int pinctrl_hog_map(struct pinctrl_dev *pctldev,
-			   struct pinctrl_map const *map)
-{
-	struct pinctrl_hog *hog;
-	struct pinctrl *p;
-	int ret;
-
-	if (map->dev_name) {
-		/*
-		 * TODO: the day we have device tree support, we can
-		 * traverse the device tree and hog to specific device nodes
-		 * without any problems, so then we can hog pinmuxes for
-		 * all devices that just want a static pin mux at this point.
-		 */
-		dev_err(pctldev->dev, "map %s wants to hog a non-system pinmux, this is not going to work\n",
-				map->name);
-		return -EINVAL;
-	}
-
-	hog = kzalloc(sizeof(struct pinctrl_hog), GFP_KERNEL);
-	if (!hog)
-		return -ENOMEM;
-
-	p = pinctrl_get(NULL, map->name);
-	if (IS_ERR(p)) {
-		kfree(hog);
-		dev_err(pctldev->dev,
-			"could not get the %s pin control mapping for hogging\n",
-			map->name);
-		return PTR_ERR(p);
-	}
-
-	ret = pinctrl_enable(p);
-	if (ret) {
-		pinctrl_put(p);
-		kfree(hog);
-		dev_err(pctldev->dev,
-			"could not enable the %s pin control mapping for hogging\n",
-			map->name);
-		return ret;
-	}
-
-	hog->map = map;
-	hog->p = p;
-
-	dev_info(pctldev->dev, "hogged map %s, function %s\n", map->name,
-		 map->function);
-	mutex_lock(&pctldev->pinctrl_hogs_lock);
-	list_add(&hog->node, &pctldev->pinctrl_hogs);
-	mutex_unlock(&pctldev->pinctrl_hogs_lock);
-
-	return 0;
-}
-
-/**
- * pinctrl_hog_maps() - hog specific map entries on controller device
- * @pctldev: the pin control device to hog entries on
- *
- * When the pin controllers are registered, there may be some specific pinmux
- * map entries that need to be hogged, i.e. get+enabled until the system shuts
- * down.
- */
-int pinctrl_hog_maps(struct pinctrl_dev *pctldev)
-{
-	struct device *dev = pctldev->dev;
-	const char *devname = dev_name(dev);
-	int ret;
-	int i;
-
-	INIT_LIST_HEAD(&pctldev->pinctrl_hogs);
-	mutex_init(&pctldev->pinctrl_hogs_lock);
-
-	for (i = 0; i < pinctrl_maps_num; i++) {
-		struct pinctrl_map const *map = &pinctrl_maps[i];
-
-		if (!map->hog_on_boot)
-			continue;
-
-		if (map->ctrl_dev_name &&
-		    !strcmp(map->ctrl_dev_name, devname)) {
-			/* OK time to hog! */
-			ret = pinctrl_hog_map(pctldev, map);
-			if (ret)
-				return ret;
-		}
-	}
-	return 0;
-}
-
-/**
- * pinctrl_unhog_maps() - unhog specific map entries on controller device
- * @pctldev: the pin control device to unhog entries on
- */
-void pinctrl_unhog_maps(struct pinctrl_dev *pctldev)
-{
-	struct list_head *node, *tmp;
-
-	mutex_lock(&pctldev->pinctrl_hogs_lock);
-	list_for_each_safe(node, tmp, &pctldev->pinctrl_hogs) {
-		struct pinctrl_hog *hog =
-			list_entry(node, struct pinctrl_hog, node);
-		pinctrl_disable(hog->p);
-		pinctrl_put(hog->p);
-		list_del(node);
-		kfree(hog);
-	}
-	mutex_unlock(&pctldev->pinctrl_hogs_lock);
-}
-
 #ifdef CONFIG_DEBUG_FS
 
 /* Called from pincontrol core */
@@ -1083,83 +652,29 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 	return 0;
 }
 
-static int pinmux_hogs_show(struct seq_file *s, void *what)
-{
-	struct pinctrl_dev *pctldev = s->private;
-	struct pinctrl_hog *hog;
-
-	seq_puts(s, "Pin control map hogs held by device\n");
-
-	list_for_each_entry(hog, &pctldev->pinctrl_hogs, node)
-		seq_printf(s, "%s\n", hog->map->name);
-
-	return 0;
-}
-
-static int pinmux_show(struct seq_file *s, void *what)
+void pinmux_dbg_show(struct seq_file *s, struct pinctrl *p)
 {
-	struct pinctrl *p;
-
-	seq_puts(s, "Requested pinmuxes and their maps:\n");
-	list_for_each_entry(p, &pinctrl_list, node) {
-		struct pinctrl_dev *pctldev = p->pctldev;
-		const struct pinmux_ops *pmxops;
-		const struct pinctrl_ops *pctlops;
-		struct pinmux_group *grp;
-
-		if (!pctldev) {
-			seq_puts(s, "NO PIN CONTROLLER DEVICE\n");
-			continue;
-		}
-
-		pmxops = pctldev->desc->pmxops;
-		pctlops = pctldev->desc->pctlops;
-
-		seq_printf(s, "device: %s function: %s (%u),",
-			   pinctrl_dev_get_name(p->pctldev),
-			   pmxops->get_function_name(pctldev,
-				   p->func_selector),
-			   p->func_selector);
-
-		seq_printf(s, " groups: [");
-		list_for_each_entry(grp, &p->groups, node) {
-			seq_printf(s, " %s (%u)",
-				   pctlops->get_group_name(pctldev,
-					   grp->group_selector),
-				   grp->group_selector);
-		}
-		seq_printf(s, " ]");
+	struct pinctrl_dev *pctldev = p->pctldev;
+	const struct pinmux_ops *pmxops;
+	const struct pinctrl_ops *pctlops;
+	struct pinmux_group *grp;
 
-		seq_printf(s, " users: %u map-> %s\n",
-			   p->usecount,
-			   p->dev ? dev_name(p->dev) : "(system)");
-	}
+	pmxops = pctldev->desc->pmxops;
+	pctlops = pctldev->desc->pctlops;
 
-	return 0;
-}
-
-static int pinctrl_maps_show(struct seq_file *s, void *what)
-{
-	int i;
+	seq_printf(s, " function: %s (%u),",
+		   pmxops->get_function_name(pctldev,
+					     p->func_selector),
+		   p->func_selector);
 
-	seq_puts(s, "Pinctrl maps:\n");
-
-	for (i = 0; i < pinctrl_maps_num; i++) {
-		struct pinctrl_map const *map = &pinctrl_maps[i];
-
-		seq_printf(s, "%s:\n", map->name);
-		if (map->dev_name)
-			seq_printf(s, "  device: %s\n",
-				   map->dev_name);
-		else
-			seq_printf(s, "  SYSTEM MUX\n");
-		seq_printf(s, "  controlling device %s\n",
-			   map->ctrl_dev_name);
-		seq_printf(s, "  function: %s\n", map->function);
-		seq_printf(s, "  group: %s\n", map->group ? map->group :
-			   "(default)");
+	seq_printf(s, " groups: [");
+	list_for_each_entry(grp, &p->groups, node) {
+		seq_printf(s, " %s (%u)",
+			   pctlops->get_group_name(pctldev,
+						   grp->group_selector),
+			   grp->group_selector);
 	}
-	return 0;
+	seq_printf(s, " ]");
 }
 
 static int pinmux_functions_open(struct inode *inode, struct file *file)
@@ -1172,21 +687,6 @@ static int pinmux_pins_open(struct inode *inode, struct file *file)
 	return single_open(file, pinmux_pins_show, inode->i_private);
 }
 
-static int pinmux_hogs_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pinmux_hogs_show, inode->i_private);
-}
-
-static int pinmux_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pinmux_show, NULL);
-}
-
-static int pinctrl_maps_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pinctrl_maps_show, NULL);
-}
-
 static const struct file_operations pinmux_functions_ops = {
 	.open		= pinmux_functions_open,
 	.read		= seq_read,
@@ -1201,27 +701,6 @@ static const struct file_operations pinmux_pins_ops = {
 	.release	= single_release,
 };
 
-static const struct file_operations pinmux_hogs_ops = {
-	.open		= pinmux_hogs_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static const struct file_operations pinmux_ops = {
-	.open		= pinmux_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static const struct file_operations pinctrl_maps_ops = {
-	.open		= pinctrl_maps_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 void pinmux_init_device_debugfs(struct dentry *devroot,
 			 struct pinctrl_dev *pctldev)
 {
@@ -1229,16 +708,6 @@ void pinmux_init_device_debugfs(struct dentry *devroot,
 			    devroot, pctldev, &pinmux_functions_ops);
 	debugfs_create_file("pinmux-pins", S_IFREG | S_IRUGO,
 			    devroot, pctldev, &pinmux_pins_ops);
-	debugfs_create_file("pinmux-hogs", S_IFREG | S_IRUGO,
-			    devroot, pctldev, &pinmux_hogs_ops);
-}
-
-void pinmux_init_debugfs(struct dentry *subsys_root)
-{
-	debugfs_create_file("pinmuxes", S_IFREG | S_IRUGO,
-			    subsys_root, NULL, &pinmux_ops);
-	debugfs_create_file("pinctrl-maps", S_IFREG | S_IRUGO,
-			    subsys_root, NULL, &pinctrl_maps_ops);
 }
 
 #endif /* CONFIG_DEBUG_FS */
diff --git a/drivers/pinctrl/pinmux.h b/drivers/pinctrl/pinmux.h
index dfe8172..7680a17 100644
--- a/drivers/pinctrl/pinmux.h
+++ b/drivers/pinctrl/pinmux.h
@@ -15,9 +15,28 @@
 int pinmux_check_ops(struct pinctrl_dev *pctldev);
 void pinmux_init_device_debugfs(struct dentry *devroot,
 				struct pinctrl_dev *pctldev);
-void pinmux_init_debugfs(struct dentry *subsys_root);
-int pinctrl_hog_maps(struct pinctrl_dev *pctldev);
-void pinctrl_unhog_maps(struct pinctrl_dev *pctldev);
+int pinmux_request_gpio(struct pinctrl_dev *pctldev,
+			struct pinctrl_gpio_range *range,
+			unsigned pin, unsigned gpio);
+void pinmux_free_gpio(struct pinctrl_dev *pctldev, unsigned pin,
+		      struct pinctrl_gpio_range *range);
+int pinmux_gpio_direction(struct pinctrl_dev *pctldev,
+			  struct pinctrl_gpio_range *range,
+			  unsigned pin, bool input);
+static inline void pinmux_init_pinctrl_handle(struct pinctrl *p)
+{
+	p->func_selector = UINT_MAX;
+	INIT_LIST_HEAD(&p->groups);
+}
+int pinmux_apply_muxmap(struct pinctrl_dev *pctldev,
+			struct pinctrl *p,
+			struct device *dev,
+			const char *devname,
+			struct pinctrl_map const *map);
+void pinmux_put(struct pinctrl *p);
+int pinmux_enable(struct pinctrl *p);
+void pinmux_disable(struct pinctrl *p);
+void pinmux_dbg_show(struct seq_file *s, struct pinctrl *p);
 
 #else
 
@@ -31,16 +50,52 @@ static inline void pinmux_init_device_debugfs(struct dentry *devroot,
 {
 }
 
-static inline void pinmux_init_debugfs(struct dentry *subsys_root)
+static inline int pinmux_request_gpio(struct pinctrl_dev *pctldev,
+			struct pinctrl_gpio_range *range,
+			unsigned pin, unsigned gpio)
+{
+	return 0;
+}
+
+static inline void pinmux_free_gpio(struct pinctrl_dev *pctldev,
+				    unsigned pin,
+				    struct pinctrl_gpio_range *range)
+{
+}
+
+static inline int pinmux_gpio_direction(struct pinctrl_dev *pctldev,
+					struct pinctrl_gpio_range *range,
+					unsigned pin, bool input)
+{
+	return 0;
+}
+
+static inline void pinmux_init_pinctrl_handle(struct pinctrl *p)
 {
 }
 
-static inline int pinctrl_hog_maps(struct pinctrl_dev *pctldev)
+static inline int pinmux_apply_muxmap(struct pinctrl_dev *pctldev,
+				      struct pinctrl *p,
+				      struct device *dev,
+				      const char *devname,
+				      struct pinctrl_map const *map)
 {
 	return 0;
 }
 
-static inline void pinctrl_unhog_maps(struct pinctrl_dev *pctldev)
+static inline void pinmux_put(struct pinctrl *p)
+{
+}
+
+static inline int pinmux_enable(struct pinctrl *p)
+{
+}
+
+static inline void pinmux_disable(struct pinctrl *p)
+{
+}
+
+void pinmux_dbg_show(struct seq_file *s, struct pinctrl *p)
 {
 }
 
diff --git a/include/linux/pinctrl/consumer.h b/include/linux/pinctrl/consumer.h
index c7d0617..3086594 100644
--- a/include/linux/pinctrl/consumer.h
+++ b/include/linux/pinctrl/consumer.h
@@ -19,9 +19,9 @@
 /* This struct is private to the core and should be regarded as a cookie */
 struct pinctrl;
 
-#ifdef CONFIG_PINMUX
+#ifdef CONFIG_PINCTRL
 
-/* External interface to pinmux */
+/* External interface to pin control */
 extern int pinctrl_request_gpio(unsigned gpio);
 extern void pinctrl_free_gpio(unsigned gpio);
 extern int pinctrl_gpio_direction_input(unsigned gpio);
@@ -31,7 +31,7 @@ extern void pinctrl_put(struct pinctrl *p);
 extern int pinctrl_enable(struct pinctrl *p);
 extern void pinctrl_disable(struct pinctrl *p);
 
-#else /* !CONFIG_PINMUX */
+#else /* !CONFIG_PINCTRL */
 
 static inline int pinctrl_request_gpio(unsigned gpio)
 {
@@ -70,7 +70,7 @@ static inline void pinctrl_disable(struct pinctrl *p)
 {
 }
 
-#endif /* CONFIG_PINMUX */
+#endif /* CONFIG_PINCTRL */
 
 #ifdef CONFIG_PINCONF
 
-- 
1.7.7.6

