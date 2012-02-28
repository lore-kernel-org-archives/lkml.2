Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030455Ab2B1U27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 15:28:59 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17349 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965025Ab2B1U1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 15:27:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 28 Feb 2012 12:27:36 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
CC: Linus Walleij <linus.walleij@linaro.org>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 1/6] pinctrl: Fix and simplify locking
Date: Tue, 28 Feb 2012 13:27:27 -0700
Message-ID: <1330460852-23486-2-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330460852-23486-1-git-send-email-swarren@nvidia.com>
References: <1330460852-23486-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many problems with the current pinctrl locking:

struct pinctrl_dev's gpio_ranges_lock isn't effective;
pinctrl_match_gpio_range() only holds this lock while searching for a gpio
range, but the found range is return and manipulated after releading the
lock. This could allow pinctrl_remove_gpio_range() for that range while it
is in use, and the caller may very well delete the range after removing it,
causing pinctrl code to touch the now-free range object.

Solving this requires the introduction of a higher-level lock, at least
a lock per pin controller, which both gpio range registration and
pinctrl_get()/put() will acquire.

There is missing locking on HW programming; pin controllers may pack the
configuration for different pins/groups/config options/... into one
register, and hence have to read-modify-write the register. This needs to
be protected, but currently isn't. Related, a future change will add a
"complete" op to the pin controller drivers, the idea being that each
state's programming will be programmed into the pinctrl driver followed
by the "complete" call, which may e.g. flush a register cache to HW. For
this to work, it must not be possible to interleave the pinctrl driver
calls for different devices.

As above, solving this requires the introduction of a higher-level lock,
at least a lock per pin controller, which will be held for the duration
of any pinctrl_enable()/disable() call.

However, each pinctrl mapping table entry may affect a different pin
controller if necessary. Hence, with a per-pin-controller lock, almost
any pinctrl API may need to acquire multiple locks, one per controller.
To avoid deadlock, these would need to be acquired in the same order in
all cases. This is extremely difficult to implement in the case of
pinctrl_get(), which doesn't know which pin controllers to lock until it
has parsed the entire mapping table, since it contains somewhat arbitrary
data.

The simplest solution here is to introduce a single lock that covers all
pin controllers at once. This will be acquired by all pinctrl APIs.

This then makes struct pinctrl's mutex irrelevant, since that single lock
will always be held whenever this mutex is currently held.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Rebased. No logical changes.

 drivers/pinctrl/core.c          |  198 ++++++++++++++++++++++++---------------
 drivers/pinctrl/core.h          |   10 +-
 drivers/pinctrl/pinconf.c       |  107 ++++++++++++++++------
 drivers/pinctrl/pinmux.c        |   21 ++---
 include/linux/pinctrl/pinctrl.h |    1 -
 5 files changed, 215 insertions(+), 122 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 6af6d8d..aefc339 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -18,11 +18,8 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/slab.h>
-#include <linux/radix-tree.h>
 #include <linux/err.h>
 #include <linux/list.h>
-#include <linux/mutex.h>
-#include <linux/spinlock.h>
 #include <linux/sysfs.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
@@ -44,16 +41,16 @@ struct pinctrl_maps {
 	unsigned num_maps;
 };
 
-/* Global list of pin control devices */
-static DEFINE_MUTEX(pinctrldev_list_mutex);
+/* Mutex taken by all entry points */
+DEFINE_MUTEX(pinctrl_mutex);
+
+/* Global list of pin control devices (struct pinctrl_dev) */
 static LIST_HEAD(pinctrldev_list);
 
-/* List of pin controller handles */
-static DEFINE_MUTEX(pinctrl_list_mutex);
+/* List of pin controller handles (struct pinctrl) */
 static LIST_HEAD(pinctrl_list);
 
-/* Global pinctrl maps */
-static DEFINE_MUTEX(pinctrl_maps_mutex);
+/* List of pinctrl maps (struct pinctrl_maps) */
 static LIST_HEAD(pinctrl_maps);
 
 #define for_each_maps(_maps_node_, _i_, _map_) \
@@ -90,7 +87,6 @@ struct pinctrl_dev *get_pinctrl_dev_from_devname(const char *devname)
 	if (!devname)
 		return NULL;
 
-	mutex_lock(&pinctrldev_list_mutex);
 	list_for_each_entry(pctldev, &pinctrldev_list, node) {
 		if (!strcmp(dev_name(pctldev->dev), devname)) {
 			/* Matched on device name */
@@ -98,7 +94,6 @@ struct pinctrl_dev *get_pinctrl_dev_from_devname(const char *devname)
 			break;
 		}
 	}
-	mutex_unlock(&pinctrldev_list_mutex);
 
 	return found ? pctldev : NULL;
 }
@@ -143,11 +138,11 @@ bool pin_is_valid(struct pinctrl_dev *pctldev, int pin)
 	if (pin < 0)
 		return false;
 
+	mutex_lock(&pinctrl_mutex);
 	pindesc = pin_desc_get(pctldev, pin);
-	if (pindesc == NULL)
-		return false;
+	mutex_unlock(&pinctrl_mutex);
 
-	return true;
+	return pindesc != NULL;
 }
 EXPORT_SYMBOL_GPL(pin_is_valid);
 
@@ -191,8 +186,6 @@ static int pinctrl_register_one_pin(struct pinctrl_dev *pctldev,
 		return -ENOMEM;
 	}
 
-	spin_lock_init(&pindesc->lock);
-
 	/* Set owner */
 	pindesc->pctldev = pctldev;
 
@@ -243,16 +236,13 @@ pinctrl_match_gpio_range(struct pinctrl_dev *pctldev, unsigned gpio)
 	struct pinctrl_gpio_range *range = NULL;
 
 	/* Loop over the ranges */
-	mutex_lock(&pctldev->gpio_ranges_lock);
 	list_for_each_entry(range, &pctldev->gpio_ranges, node) {
 		/* Check if we're in the valid range */
 		if (gpio >= range->base &&
 		    gpio < range->base + range->npins) {
-			mutex_unlock(&pctldev->gpio_ranges_lock);
 			return range;
 		}
 	}
-	mutex_unlock(&pctldev->gpio_ranges_lock);
 
 	return NULL;
 }
@@ -274,7 +264,6 @@ static int pinctrl_get_device_gpio_range(unsigned gpio,
 	struct pinctrl_dev *pctldev = NULL;
 
 	/* Loop over the pin controllers */
-	mutex_lock(&pinctrldev_list_mutex);
 	list_for_each_entry(pctldev, &pinctrldev_list, node) {
 		struct pinctrl_gpio_range *range;
 
@@ -282,11 +271,9 @@ static int pinctrl_get_device_gpio_range(unsigned gpio,
 		if (range != NULL) {
 			*outdev = pctldev;
 			*outrange = range;
-			mutex_unlock(&pinctrldev_list_mutex);
 			return 0;
 		}
 	}
-	mutex_unlock(&pinctrldev_list_mutex);
 
 	return -EINVAL;
 }
@@ -302,9 +289,9 @@ static int pinctrl_get_device_gpio_range(unsigned gpio,
 void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
 			    struct pinctrl_gpio_range *range)
 {
-	mutex_lock(&pctldev->gpio_ranges_lock);
+	mutex_lock(&pinctrl_mutex);
 	list_add_tail(&range->node, &pctldev->gpio_ranges);
-	mutex_unlock(&pctldev->gpio_ranges_lock);
+	mutex_unlock(&pinctrl_mutex);
 }
 EXPORT_SYMBOL_GPL(pinctrl_add_gpio_range);
 
@@ -316,9 +303,9 @@ EXPORT_SYMBOL_GPL(pinctrl_add_gpio_range);
 void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
 			       struct pinctrl_gpio_range *range)
 {
-	mutex_lock(&pctldev->gpio_ranges_lock);
+	mutex_lock(&pinctrl_mutex);
 	list_del(&range->node);
-	mutex_unlock(&pctldev->gpio_ranges_lock);
+	mutex_unlock(&pinctrl_mutex);
 }
 EXPORT_SYMBOL_GPL(pinctrl_remove_gpio_range);
 
@@ -368,14 +355,21 @@ int pinctrl_request_gpio(unsigned gpio)
 	int ret;
 	int pin;
 
+	mutex_lock(&pinctrl_mutex);
+
 	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&pinctrl_mutex);
 		return -EINVAL;
+	}
 
 	/* Convert to the pin controllers number space */
 	pin = gpio - range->base + range->pin_base;
 
-	return pinmux_request_gpio(pctldev, range, pin, gpio);
+	ret = pinmux_request_gpio(pctldev, range, pin, gpio);
+
+	mutex_unlock(&pinctrl_mutex);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(pinctrl_request_gpio);
 
@@ -394,14 +388,20 @@ void pinctrl_free_gpio(unsigned gpio)
 	int ret;
 	int pin;
 
+	mutex_lock(&pinctrl_mutex);
+
 	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&pinctrl_mutex);
 		return;
+	}
 
 	/* Convert to the pin controllers number space */
 	pin = gpio - range->base + range->pin_base;
 
-	return pinmux_free_gpio(pctldev, pin, range);
+	pinmux_free_gpio(pctldev, pin, range);
+
+	mutex_unlock(&pinctrl_mutex);
 }
 EXPORT_SYMBOL_GPL(pinctrl_free_gpio);
 
@@ -432,7 +432,11 @@ static int pinctrl_gpio_direction(unsigned gpio, bool input)
  */
 int pinctrl_gpio_direction_input(unsigned gpio)
 {
-	return pinctrl_gpio_direction(gpio, true);
+	int ret;
+	mutex_lock(&pinctrl_mutex);
+	ret = pinctrl_gpio_direction(gpio, true);
+	mutex_unlock(&pinctrl_mutex);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(pinctrl_gpio_direction_input);
 
@@ -446,7 +450,11 @@ EXPORT_SYMBOL_GPL(pinctrl_gpio_direction_input);
  */
 int pinctrl_gpio_direction_output(unsigned gpio)
 {
-	return pinctrl_gpio_direction(gpio, false);
+	int ret;
+	mutex_lock(&pinctrl_mutex);
+	ret = pinctrl_gpio_direction(gpio, false);
+	mutex_unlock(&pinctrl_mutex);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(pinctrl_gpio_direction_output);
 
@@ -479,7 +487,6 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 		dev_err(dev, "failed to alloc struct pinctrl\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	mutex_init(&p->mutex);
 	pinmux_init_pinctrl_handle(p);
 
 	/* Iterate over the pin control maps to locate the right ones */
@@ -531,9 +538,7 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 		num_maps, devname, name ? name : "(undefined)");
 
 	/* Add the pinmux to the global list */
-	mutex_lock(&pinctrl_list_mutex);
 	list_add_tail(&p->node, &pinctrl_list);
-	mutex_unlock(&pinctrl_list_mutex);
 
 	return p;
 }
@@ -549,74 +554,91 @@ struct pinctrl *pinctrl_get(struct device *dev, const char *name)
 {
 	struct pinctrl *p;
 
-	mutex_lock(&pinctrl_maps_mutex);
+	mutex_lock(&pinctrl_mutex);
 	p = pinctrl_get_locked(dev, name);
-	mutex_unlock(&pinctrl_maps_mutex);
+	mutex_unlock(&pinctrl_mutex);
 
 	return p;
 }
 EXPORT_SYMBOL_GPL(pinctrl_get);
 
-/**
- * pinctrl_put() - release a previously claimed pin control handle
- * @p: a pin control handle previously claimed by pinctrl_get()
- */
-void pinctrl_put(struct pinctrl *p)
+static void pinctrl_put_locked(struct pinctrl *p)
 {
 	if (p == NULL)
 		return;
 
-	mutex_lock(&p->mutex);
 	if (p->usecount)
 		pr_warn("releasing pin control handle with active users!\n");
 	/* Free the groups and all acquired pins */
 	pinmux_put(p);
-	mutex_unlock(&p->mutex);
 
 	/* Remove from list */
-	mutex_lock(&pinctrl_list_mutex);
 	list_del(&p->node);
-	mutex_unlock(&pinctrl_list_mutex);
 
 	kfree(p);
 }
-EXPORT_SYMBOL_GPL(pinctrl_put);
 
 /**
- * pinctrl_enable() - enable a certain pin controller setting
- * @p: the pin control handle to enable, previously claimed by pinctrl_get()
+ * pinctrl_put() - release a previously claimed pin control handle
+ * @p: a pin control handle previously claimed by pinctrl_get()
  */
-int pinctrl_enable(struct pinctrl *p)
+void pinctrl_put(struct pinctrl *p)
+{
+	mutex_lock(&pinctrl_mutex);
+	pinctrl_put(p);
+	mutex_unlock(&pinctrl_mutex);
+}
+EXPORT_SYMBOL_GPL(pinctrl_put);
+
+static int pinctrl_enable_locked(struct pinctrl *p)
 {
 	int ret = 0;
 
 	if (p == NULL)
 		return -EINVAL;
-	mutex_lock(&p->mutex);
+
 	if (p->usecount++ == 0) {
 		ret = pinmux_enable(p);
 		if (ret)
 			p->usecount--;
 	}
-	mutex_unlock(&p->mutex);
+
 	return ret;
 }
-EXPORT_SYMBOL_GPL(pinctrl_enable);
 
 /**
- * pinctrl_disable() - disable a certain pin control setting
- * @p: the pin control handle to disable, previously claimed by pinctrl_get()
+ * pinctrl_enable() - enable a certain pin controller setting
+ * @p: the pin control handle to enable, previously claimed by pinctrl_get()
  */
-void pinctrl_disable(struct pinctrl *p)
+int pinctrl_enable(struct pinctrl *p)
+{
+	int ret;
+	mutex_lock(&pinctrl_mutex);
+	ret = pinctrl_enable_locked(p);
+	mutex_unlock(&pinctrl_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pinctrl_enable);
+
+static void pinctrl_disable_locked(struct pinctrl *p)
 {
 	if (p == NULL)
 		return;
 
-	mutex_lock(&p->mutex);
 	if (--p->usecount == 0) {
 		pinmux_disable(p);
 	}
-	mutex_unlock(&p->mutex);
+}
+
+/**
+ * pinctrl_disable() - disable a certain pin control setting
+ * @p: the pin control handle to disable, previously claimed by pinctrl_get()
+ */
+void pinctrl_disable(struct pinctrl *p)
+{
+	mutex_lock(&pinctrl_mutex);
+	pinctrl_disable_locked(p);
+	mutex_unlock(&pinctrl_mutex);
 }
 EXPORT_SYMBOL_GPL(pinctrl_disable);
 
@@ -676,9 +698,9 @@ int pinctrl_register_mappings(struct pinctrl_map const *maps,
 		return -ENOMEM;
 	}
 
-	mutex_lock(&pinctrl_maps_mutex);
+	mutex_lock(&pinctrl_mutex);
 	list_add_tail(&maps_node->node, &pinctrl_maps);
-	mutex_unlock(&pinctrl_maps_mutex);
+	mutex_unlock(&pinctrl_mutex);
 
 	return 0;
 }
@@ -693,6 +715,8 @@ static int pinctrl_pins_show(struct seq_file *s, void *what)
 
 	seq_printf(s, "registered pins: %d\n", pctldev->desc->npins);
 
+	mutex_lock(&pinctrl_mutex);
+
 	/* The pin number can be retrived from the pin controller descriptor */
 	for (i = 0; i < pctldev->desc->npins; i++) {
 		struct pin_desc *desc;
@@ -713,6 +737,8 @@ static int pinctrl_pins_show(struct seq_file *s, void *what)
 		seq_puts(s, "\n");
 	}
 
+	mutex_unlock(&pinctrl_mutex);
+
 	return 0;
 }
 
@@ -726,6 +752,8 @@ static int pinctrl_groups_show(struct seq_file *s, void *what)
 	if (!ops)
 		return 0;
 
+	mutex_lock(&pinctrl_mutex);
+
 	seq_puts(s, "registered pin groups:\n");
 	while (ops->list_groups(pctldev, selector) >= 0) {
 		const unsigned *pins;
@@ -748,6 +776,7 @@ static int pinctrl_groups_show(struct seq_file *s, void *what)
 		selector++;
 	}
 
+	mutex_unlock(&pinctrl_mutex);
 
 	return 0;
 }
@@ -759,8 +788,9 @@ static int pinctrl_gpioranges_show(struct seq_file *s, void *what)
 
 	seq_puts(s, "GPIO ranges handled:\n");
 
+	mutex_lock(&pinctrl_mutex);
+
 	/* Loop over the ranges */
-	mutex_lock(&pctldev->gpio_ranges_lock);
 	list_for_each_entry(range, &pctldev->gpio_ranges, node) {
 		seq_printf(s, "%u: %s GPIOS [%u - %u] PINS [%u - %u]\n",
 			   range->id, range->name,
@@ -768,7 +798,8 @@ static int pinctrl_gpioranges_show(struct seq_file *s, void *what)
 			   range->pin_base,
 			   (range->pin_base + range->npins - 1));
 	}
-	mutex_unlock(&pctldev->gpio_ranges_lock);
+
+	mutex_unlock(&pinctrl_mutex);
 
 	return 0;
 }
@@ -778,7 +809,9 @@ static int pinctrl_devices_show(struct seq_file *s, void *what)
 	struct pinctrl_dev *pctldev;
 
 	seq_puts(s, "name [pinmux] [pinconf]\n");
-	mutex_lock(&pinctrldev_list_mutex);
+
+	mutex_lock(&pinctrl_mutex);
+
 	list_for_each_entry(pctldev, &pinctrldev_list, node) {
 		seq_printf(s, "%s ", pctldev->desc->name);
 		if (pctldev->desc->pmxops)
@@ -791,7 +824,8 @@ static int pinctrl_devices_show(struct seq_file *s, void *what)
 			seq_puts(s, "no");
 		seq_puts(s, "\n");
 	}
-	mutex_unlock(&pinctrldev_list_mutex);
+
+	mutex_unlock(&pinctrl_mutex);
 
 	return 0;
 }
@@ -804,7 +838,8 @@ static int pinctrl_maps_show(struct seq_file *s, void *what)
 
 	seq_puts(s, "Pinctrl maps:\n");
 
-	mutex_lock(&pinctrl_maps_mutex);
+	mutex_lock(&pinctrl_mutex);
+
 	for_each_maps(maps_node, i, map) {
 		seq_printf(s, "%s:\n", map->name);
 		seq_printf(s, "  device: %s\n", map->dev_name);
@@ -813,7 +848,8 @@ static int pinctrl_maps_show(struct seq_file *s, void *what)
 		seq_printf(s, "  group: %s\n", map->group ? map->group :
 			   "(default)");
 	}
-	mutex_unlock(&pinctrl_maps_mutex);
+
+	mutex_unlock(&pinctrl_mutex);
 
 	return 0;
 }
@@ -823,6 +859,9 @@ static int pinctrl_show(struct seq_file *s, void *what)
 	struct pinctrl *p;
 
 	seq_puts(s, "Requested pin control handlers their pinmux maps:\n");
+
+	mutex_lock(&pinctrl_mutex);
+
 	list_for_each_entry(p, &pinctrl_list, node) {
 		struct pinctrl_dev *pctldev = p->pctldev;
 
@@ -841,6 +880,8 @@ static int pinctrl_show(struct seq_file *s, void *what)
 			   p->dev ? dev_name(p->dev) : "(system)");
 	}
 
+	mutex_unlock(&pinctrl_mutex);
+
 	return 0;
 }
 
@@ -1008,7 +1049,6 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 	pctldev->driver_data = driver_data;
 	INIT_RADIX_TREE(&pctldev->pin_desc_tree, GFP_KERNEL);
 	INIT_LIST_HEAD(&pctldev->gpio_ranges);
-	mutex_init(&pctldev->gpio_ranges_lock);
 	pctldev->dev = dev;
 
 	/* If we're implementing pinmuxing, check the ops for sanity */
@@ -1042,12 +1082,16 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 		goto out_err;
 	}
 
-	mutex_lock(&pinctrldev_list_mutex);
+	mutex_lock(&pinctrl_mutex);
+
 	list_add_tail(&pctldev->node, &pinctrldev_list);
-	mutex_unlock(&pinctrldev_list_mutex);
-	pctldev->p = pinctrl_get(pctldev->dev, PINCTRL_STATE_DEFAULT);
+
+	pctldev->p = pinctrl_get_locked(pctldev->dev, PINCTRL_STATE_DEFAULT);
 	if (!IS_ERR(pctldev->p))
-		pinctrl_enable(pctldev->p);
+		pinctrl_enable_locked(pctldev->p);
+
+	mutex_unlock(&pinctrl_mutex);
+
 	pinctrl_init_device_debugfs(pctldev);
 
 	return pctldev;
@@ -1070,18 +1114,22 @@ void pinctrl_unregister(struct pinctrl_dev *pctldev)
 		return;
 
 	pinctrl_remove_device_debugfs(pctldev);
+
+	mutex_lock(&pinctrl_mutex);
+
 	if (!IS_ERR(pctldev->p)) {
-		pinctrl_disable(pctldev->p);
-		pinctrl_put(pctldev->p);
+		pinctrl_disable_locked(pctldev->p);
+		pinctrl_put_locked(pctldev->p);
 	}
+
 	/* TODO: check that no pinmuxes are still active? */
-	mutex_lock(&pinctrldev_list_mutex);
 	list_del(&pctldev->node);
-	mutex_unlock(&pinctrldev_list_mutex);
 	/* Destroy descriptor tree */
 	pinctrl_free_pindescs(pctldev, pctldev->desc->pins,
 			      pctldev->desc->npins);
 	kfree(pctldev);
+
+	mutex_unlock(&pinctrl_mutex);
 }
 EXPORT_SYMBOL_GPL(pinctrl_unregister);
 
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 2981b73..d55cb67 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -9,6 +9,8 @@
  * License terms: GNU General Public License (GPL) version 2
  */
 
+#include <linux/mutex.h>
+#include <linux/radix-tree.h>
 #include <linux/pinctrl/pinconf.h>
 
 struct pinctrl_gpio_range;
@@ -22,7 +24,6 @@ struct pinctrl_gpio_range;
  *	this radix tree
  * @gpio_ranges: a list of GPIO ranges that is handled by this pin controller,
  *	ranges are added to this list at runtime
- * @gpio_ranges_lock: lock for the GPIO ranges list
  * @dev: the device entry for this pin controller
  * @owner: module providing the pin controller, used for refcounting
  * @driver_data: driver data for drivers registering to the pin controller
@@ -35,7 +36,6 @@ struct pinctrl_dev {
 	struct pinctrl_desc *desc;
 	struct radix_tree_root pin_desc_tree;
 	struct list_head gpio_ranges;
-	struct mutex gpio_ranges_lock;
 	struct device *dev;
 	struct module *owner;
 	void *driver_data;
@@ -52,7 +52,6 @@ struct pinctrl_dev {
  * @usecount: the number of active users of this pin controller setting, used
  *	to keep track of nested use cases
  * @pctldev: pin control device handling this pin control handle
- * @mutex: a lock for the pin control state holder
  * @func_selector: the function selector for the pinmux device handling
  *	this pinmux
  * @groups: the group selectors for the pinmux device and
@@ -65,7 +64,6 @@ struct pinctrl {
 	struct device *dev;
 	unsigned usecount;
 	struct pinctrl_dev *pctldev;
-	struct mutex mutex;
 #ifdef CONFIG_PINMUX
 	unsigned func_selector;
 	struct list_head groups;
@@ -78,7 +76,6 @@ struct pinctrl {
  * @name: a name for the pin, e.g. the name of the pin/pad/finger on a
  *	datasheet or such
  * @dynamic_name: if the name of this pin was dynamically allocated
- * @lock: a lock to protect the descriptor structure
  * @mux_requested: whether the pin is already requested by pinmux or not
  * @mux_function: a named muxing function for the pin that will be passed to
  *	subdrivers and shown in debugfs etc
@@ -87,7 +84,6 @@ struct pin_desc {
 	struct pinctrl_dev *pctldev;
 	const char *name;
 	bool dynamic_name;
-	spinlock_t lock;
 	/* These fields only added when supporting pinmux drivers */
 #ifdef CONFIG_PINMUX
 	const char *owner;
@@ -104,3 +100,5 @@ static inline struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev,
 {
 	return radix_tree_lookup(&pctldev->pin_desc_tree, pin);
 }
+
+extern struct mutex pinctrl_mutex;
diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 3f018a1..e0a4537 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -64,15 +64,23 @@ int pin_config_get(const char *dev_name, const char *name,
 	struct pinctrl_dev *pctldev;
 	int pin;
 
+	mutex_lock(&pinctrl_mutex);
+
 	pctldev = get_pinctrl_dev_from_devname(dev_name);
-	if (!pctldev)
-		return -EINVAL;
+	if (!pctldev) {
+		pin = -EINVAL;
+		goto unlock;
+	}
 
 	pin = pin_get_from_name(pctldev, name);
 	if (pin < 0)
-		return pin;
+		goto unlock;
 
-	return pin_config_get_for_pin(pctldev, pin, config);
+	pin = pin_config_get_for_pin(pctldev, pin, config);
+
+unlock:
+	mutex_unlock(&pinctrl_mutex);
+	return pin;
 }
 EXPORT_SYMBOL(pin_config_get);
 
@@ -110,17 +118,27 @@ int pin_config_set(const char *dev_name, const char *name,
 		   unsigned long config)
 {
 	struct pinctrl_dev *pctldev;
-	int pin;
+	int pin, ret;
+
+	mutex_lock(&pinctrl_mutex);
 
 	pctldev = get_pinctrl_dev_from_devname(dev_name);
-	if (!pctldev)
-		return -EINVAL;
+	if (!pctldev) {
+		ret = -EINVAL;
+		goto unlock;
+	}
 
 	pin = pin_get_from_name(pctldev, name);
-	if (pin < 0)
-		return pin;
+	if (pin < 0) {
+		ret = pin;
+		goto unlock;
+	}
+
+	ret = pin_config_set_for_pin(pctldev, pin, config);
 
-	return pin_config_set_for_pin(pctldev, pin, config);
+unlock:
+	mutex_unlock(&pinctrl_mutex);
+	return ret;
 }
 EXPORT_SYMBOL(pin_config_set);
 
@@ -129,25 +147,36 @@ int pin_config_group_get(const char *dev_name, const char *pin_group,
 {
 	struct pinctrl_dev *pctldev;
 	const struct pinconf_ops *ops;
-	int selector;
+	int selector, ret;
+
+	mutex_lock(&pinctrl_mutex);
 
 	pctldev = get_pinctrl_dev_from_devname(dev_name);
-	if (!pctldev)
-		return -EINVAL;
+	if (!pctldev) {
+		ret = -EINVAL;
+		goto unlock;
+	}
 	ops = pctldev->desc->confops;
 
 	if (!ops || !ops->pin_config_group_get) {
 		dev_err(pctldev->dev, "cannot get configuration for pin "
 			"group, missing group config get function in "
 			"driver\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto unlock;
 	}
 
 	selector = pinctrl_get_group_selector(pctldev, pin_group);
-	if (selector < 0)
-		return selector;
+	if (selector < 0) {
+		ret = selector;
+		goto unlock;
+	}
 
-	return ops->pin_config_group_get(pctldev, selector, config);
+	ret = ops->pin_config_group_get(pctldev, selector, config);
+
+unlock:
+	mutex_unlock(&pinctrl_mutex);
+	return ret;
 }
 EXPORT_SYMBOL(pin_config_group_get);
 
@@ -163,27 +192,34 @@ int pin_config_group_set(const char *dev_name, const char *pin_group,
 	int ret;
 	int i;
 
+	mutex_lock(&pinctrl_mutex);
+
 	pctldev = get_pinctrl_dev_from_devname(dev_name);
-	if (!pctldev)
-		return -EINVAL;
+	if (!pctldev) {
+		ret = -EINVAL;
+		goto unlock;
+	}
 	ops = pctldev->desc->confops;
 	pctlops = pctldev->desc->pctlops;
 
 	if (!ops || (!ops->pin_config_group_set && !ops->pin_config_set)) {
 		dev_err(pctldev->dev, "cannot configure pin group, missing "
 			"config function in driver\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto unlock;
 	}
 
 	selector = pinctrl_get_group_selector(pctldev, pin_group);
-	if (selector < 0)
-		return selector;
+	if (selector < 0) {
+		ret = selector;
+		goto unlock;
+	}
 
 	ret = pctlops->get_group_pins(pctldev, selector, &pins, &num_pins);
 	if (ret) {
 		dev_err(pctldev->dev, "cannot configure pin group, error "
 			"getting pins\n");
-		return ret;
+		goto unlock;
 	}
 
 	/*
@@ -197,23 +233,30 @@ int pin_config_group_set(const char *dev_name, const char *pin_group,
 		 * pin-by-pin as well, it returns -EAGAIN.
 		 */
 		if (ret != -EAGAIN)
-			return ret;
+			goto unlock;
 	}
 
 	/*
 	 * If the controller cannot handle entire groups, we configure each pin
 	 * individually.
 	 */
-	if (!ops->pin_config_set)
-		return 0;
+	if (!ops->pin_config_set) {
+		ret = 0;
+		goto unlock;
+	}
 
 	for (i = 0; i < num_pins; i++) {
 		ret = ops->pin_config_set(pctldev, pins[i], config);
 		if (ret < 0)
-			return ret;
+			goto unlock;
 	}
 
-	return 0;
+	ret = 0;
+
+unlock:
+	mutex_unlock(&pinctrl_mutex);
+
+	return ret;
 }
 EXPORT_SYMBOL(pin_config_group_set);
 
@@ -236,6 +279,8 @@ static int pinconf_pins_show(struct seq_file *s, void *what)
 	seq_puts(s, "Pin config settings per pin\n");
 	seq_puts(s, "Format: pin (name): pinmux setting array\n");
 
+	mutex_lock(&pinctrl_mutex);
+
 	/* The pin number can be retrived from the pin controller descriptor */
 	for (i = 0; i < pctldev->desc->npins; i++) {
 		struct pin_desc *desc;
@@ -254,6 +299,8 @@ static int pinconf_pins_show(struct seq_file *s, void *what)
 		seq_printf(s, "\n");
 	}
 
+	mutex_unlock(&pinctrl_mutex);
+
 	return 0;
 }
 
@@ -280,6 +327,8 @@ static int pinconf_groups_show(struct seq_file *s, void *what)
 	seq_puts(s, "Pin config settings per pin group\n");
 	seq_puts(s, "Format: group (name): pinmux setting array\n");
 
+	mutex_lock(&pinctrl_mutex);
+
 	while (pctlops->list_groups(pctldev, selector) >= 0) {
 		const char *gname = pctlops->get_group_name(pctldev, selector);
 
@@ -290,6 +339,8 @@ static int pinconf_groups_show(struct seq_file *s, void *what)
 		selector++;
 	}
 
+	mutex_unlock(&pinctrl_mutex);
+
 	return 0;
 }
 
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index db5ed86..77ece74 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -19,8 +19,6 @@
 #include <linux/radix-tree.h>
 #include <linux/err.h>
 #include <linux/list.h>
-#include <linux/mutex.h>
-#include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/sysfs.h>
 #include <linux/debugfs.h>
@@ -93,15 +91,12 @@ static int pin_request(struct pinctrl_dev *pctldev,
 		goto out;
 	}
 
-	spin_lock(&desc->lock);
 	if (desc->owner && strcmp(desc->owner, owner)) {
-		spin_unlock(&desc->lock);
 		dev_err(pctldev->dev,
 			"pin already requested\n");
 		goto out;
 	}
 	desc->owner = owner;
-	spin_unlock(&desc->lock);
 
 	/* Let each pin increase references to this module */
 	if (!try_module_get(pctldev->owner)) {
@@ -128,11 +123,8 @@ static int pin_request(struct pinctrl_dev *pctldev,
 		dev_err(pctldev->dev, "->request on device %s failed for pin %d\n",
 		       pctldev->desc->name, pin);
 out_free_pin:
-	if (status) {
-		spin_lock(&desc->lock);
+	if (status)
 		desc->owner = NULL;
-		spin_unlock(&desc->lock);
-	}
 out:
 	if (status)
 		dev_err(pctldev->dev, "pin-%d (%s) status %d\n",
@@ -175,10 +167,8 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 	else if (ops->free)
 		ops->free(pctldev, pin);
 
-	spin_lock(&desc->lock);
 	owner = desc->owner;
 	desc->owner = NULL;
-	spin_unlock(&desc->lock);
 	module_put(pctldev->owner);
 
 	return owner;
@@ -590,6 +580,8 @@ static int pinmux_functions_show(struct seq_file *s, void *what)
 	const struct pinmux_ops *pmxops = pctldev->desc->pmxops;
 	unsigned func_selector = 0;
 
+	mutex_lock(&pinctrl_mutex);
+
 	while (pmxops->list_functions(pctldev, func_selector) >= 0) {
 		const char *func = pmxops->get_function_name(pctldev,
 							  func_selector);
@@ -610,9 +602,10 @@ static int pinmux_functions_show(struct seq_file *s, void *what)
 		seq_puts(s, "]\n");
 
 		func_selector++;
-
 	}
 
+	mutex_unlock(&pinctrl_mutex);
+
 	return 0;
 }
 
@@ -624,6 +617,8 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 	seq_puts(s, "Pinmux settings per pin\n");
 	seq_puts(s, "Format: pin (name): owner\n");
 
+	mutex_lock(&pinctrl_mutex);
+
 	/* The pin number can be retrived from the pin controller descriptor */
 	for (i = 0; i < pctldev->desc->npins; i++) {
 		struct pin_desc *desc;
@@ -647,6 +642,8 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 			   owner);
 	}
 
+	mutex_unlock(&pinctrl_mutex);
+
 	return 0;
 }
 
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 411fe23..bbdd7e1 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -15,7 +15,6 @@
 #ifdef CONFIG_PINCTRL
 
 #include <linux/radix-tree.h>
-#include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/seq_file.h>
 
-- 
1.7.0.4

