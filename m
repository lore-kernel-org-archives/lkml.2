Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2B0XzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 18:55:18 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10292 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab2B0XzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 18:55:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 27 Feb 2012 15:55:14 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
CC: Linus Walleij <linus.walleij@linaro.org>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 1/2] pinctrl: Introduce PINCTRL_STATE_DEFAULT, define hogs as that state
Date: Mon, 27 Feb 2012 16:55:08 -0700
Message-ID: <1330386909-17723-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides a single centralized name for the default state.

Update PIN_MAP_* macros to use this state name, instead of requiring the
user to pass a state name in.

With this change, hog entries in the mapping table are defined as those
with state name PINCTRL_STATE_DEFAULT, i.e. all entries have the same
name. This interacts badly with the nested iteration over mapping table
entries in pinctrl_hog_maps() and pinctrl_hog_map() which would now
attempt to claim each hog mapping table entry multiple times. Replacing
the custom hog code with a simple pinctrl_get()/pinctrl_enable().

Update documentation and mapping tables to use this.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Added all the hogging rework now described above; hopefully will solve
U300 runtime issues.
---
 Documentation/pinctrl.txt       |    8 +-
 arch/arm/mach-u300/core.c       |    6 +-
 drivers/pinctrl/core.c          |  145 ++-------------------------------------
 drivers/pinctrl/core.h          |    4 +-
 include/linux/pinctrl/machine.h |   13 ++--
 include/linux/pinctrl/pinctrl.h |    2 +
 6 files changed, 26 insertions(+), 152 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 5e314ce..6fe3232 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -814,7 +814,7 @@ it even more compact which assumes you want to use pinctrl-foo and position
 0 for mapping, for example:
 
 static struct pinctrl_map __initdata mapping[] = {
-       PIN_MAP("I2CMAP", "pinctrl-foo", "i2c0", "foo-i2c.0"),
+	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0", "foo-i2c.0"),
 };
 
 
@@ -930,7 +930,7 @@ foo_probe()
 	/* Allocate a state holder named "state" etc */
 	struct pinctrl p;
 
-	p = pinctrl_get(&device, NULL);
+	p = pinctrl_get(&device, PINCTRL_STATE_DEFAULT);
 	if IS_ERR(p)
 		return PTR_ERR(p);
 	pinctrl_enable(p);
@@ -989,7 +989,7 @@ of the pin controller itself, like this:
 
 {
 	.dev_name = "pinctrl-foo",
-	.name = "POWERMAP"
+	.name = PINCTRL_STATE_DEFAULT,
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "power_func",
 },
@@ -998,7 +998,7 @@ Since it may be common to request the core to hog a few always-applicable
 mux settings on the primary pin controller, there is a convenience macro for
 this:
 
-PIN_MAP_PRIMARY_SYS_HOG("POWERMAP", "pinctrl-foo", "power_func")
+PIN_MAP_SYS_HOG("pinctrl-foo", "power_func")
 
 This gives the exact same result as the above construction.
 
diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index 336526a..c9050dd 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -1569,9 +1569,9 @@ static struct platform_device dma_device = {
 /* Pinmux settings */
 static struct pinctrl_map __initdata u300_pinmux_map[] = {
 	/* anonymous maps for chip power and EMIFs */
-	PIN_MAP_SYS_HOG("POWER", "pinctrl-u300", "power"),
-	PIN_MAP_SYS_HOG("EMIF0", "pinctrl-u300", "emif0"),
-	PIN_MAP_SYS_HOG("EMIF1", "pinctrl-u300", "emif1"),
+	PIN_MAP_SYS_HOG("pinctrl-u300", "power"),
+	PIN_MAP_SYS_HOG("pinctrl-u300", "emif0"),
+	PIN_MAP_SYS_HOG("pinctrl-u300", "emif1"),
 	/* per-device maps for MMC/SD, SPI and UART */
 	PIN_MAP("MMCSD", "pinctrl-u300", "mmc0", "mmci"),
 	PIN_MAP("SPI", "pinctrl-u300", "spi0", "pl022"),
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 376cede..f25307b 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -44,18 +44,6 @@ struct pinctrl_maps {
 	unsigned num_maps;
 };
 
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
 /* Global list of pin control devices */
 static DEFINE_MUTEX(pinctrldev_list_mutex);
 static LIST_HEAD(pinctrldev_list);
@@ -702,103 +690,6 @@ int pinctrl_register_mappings(struct pinctrl_map const *maps,
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
-	hog = kzalloc(sizeof(*hog), GFP_KERNEL);
-	if (!hog) {
-		dev_err(pctldev->dev, "failed to alloc struct pinctrl_hog\n");
-		return -ENOMEM;
-	}
-
-	p = pinctrl_get_locked(pctldev->dev, map->name);
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
-	list_add_tail(&hog->node, &pctldev->pinctrl_hogs);
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
-static int pinctrl_hog_maps(struct pinctrl_dev *pctldev)
-{
-	struct device *dev = pctldev->dev;
-	const char *devname = dev_name(dev);
-	int ret;
-	struct pinctrl_maps *maps_node;
-	int i;
-	struct pinctrl_map const *map;
-
-	INIT_LIST_HEAD(&pctldev->pinctrl_hogs);
-
-	mutex_lock(&pinctrl_maps_mutex);
-	for_each_maps(maps_node, i, map) {
-		if (!strcmp(map->ctrl_dev_name, devname) &&
-		    !strcmp(map->dev_name, devname)) {
-			/* OK time to hog! */
-			ret = pinctrl_hog_map(pctldev, map);
-			if (ret) {
-				mutex_unlock(&pinctrl_maps_mutex);
-				return ret;
-			}
-		}
-	}
-	mutex_unlock(&pinctrl_maps_mutex);
-
-	return 0;
-}
-
-/**
- * pinctrl_unhog_maps() - unhog specific map entries on controller device
- * @pctldev: the pin control device to unhog entries on
- */
-static void pinctrl_unhog_maps(struct pinctrl_dev *pctldev)
-{
-	struct list_head *node, *tmp;
-
-	list_for_each_safe(node, tmp, &pctldev->pinctrl_hogs) {
-		struct pinctrl_hog *hog =
-			list_entry(node, struct pinctrl_hog, node);
-		pinctrl_disable(hog->p);
-		pinctrl_put(hog->p);
-		list_del(node);
-		kfree(hog);
-	}
-}
-
 #ifdef CONFIG_DEBUG_FS
 
 static int pinctrl_pins_show(struct seq_file *s, void *what)
@@ -889,19 +780,6 @@ static int pinctrl_gpioranges_show(struct seq_file *s, void *what)
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
 static int pinctrl_devices_show(struct seq_file *s, void *what)
 {
 	struct pinctrl_dev *pctldev;
@@ -988,11 +866,6 @@ static int pinctrl_gpioranges_open(struct inode *inode, struct file *file)
 	return single_open(file, pinctrl_gpioranges_show, inode->i_private);
 }
 
-static int pinmux_hogs_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pinmux_hogs_show, inode->i_private);
-}
-
 static int pinctrl_devices_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, pinctrl_devices_show, NULL);
@@ -1029,13 +902,6 @@ static const struct file_operations pinctrl_gpioranges_ops = {
 	.release	= single_release,
 };
 
-static const struct file_operations pinmux_hogs_ops = {
-	.open		= pinmux_hogs_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static const struct file_operations pinctrl_devices_ops = {
 	.open		= pinctrl_devices_open,
 	.read		= seq_read,
@@ -1078,8 +944,6 @@ static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
 			    device_root, pctldev, &pinctrl_groups_ops);
 	debugfs_create_file("gpio-ranges", S_IFREG | S_IRUGO,
 			    device_root, pctldev, &pinctrl_gpioranges_ops);
-	debugfs_create_file("pinmux-hogs", S_IFREG | S_IRUGO,
-			    device_root, pctldev, &pinmux_hogs_ops);
 	pinmux_init_device_debugfs(device_root, pctldev);
 	pinconf_init_device_debugfs(device_root, pctldev);
 }
@@ -1188,7 +1052,9 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 	mutex_lock(&pinctrldev_list_mutex);
 	list_add_tail(&pctldev->node, &pinctrldev_list);
 	mutex_unlock(&pinctrldev_list_mutex);
-	pinctrl_hog_maps(pctldev);
+	pctldev->p = pinctrl_get(pctldev->dev, PINCTRL_STATE_DEFAULT);
+	if (!IS_ERR(pctldev->p))
+		pinctrl_enable(pctldev->p);
 	pinctrl_init_device_debugfs(pctldev);
 
 	return pctldev;
@@ -1211,7 +1077,10 @@ void pinctrl_unregister(struct pinctrl_dev *pctldev)
 		return;
 
 	pinctrl_remove_device_debugfs(pctldev);
-	pinctrl_unhog_maps(pctldev);
+	if (!IS_ERR(pctldev->p)) {
+		pinctrl_disable(pctldev->p);
+		pinctrl_put(pctldev->p);
+	}
 	/* TODO: check that no pinmuxes are still active? */
 	mutex_lock(&pinctrldev_list_mutex);
 	list_del(&pctldev->node);
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 7551611..2981b73 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -27,7 +27,7 @@ struct pinctrl_gpio_range;
  * @owner: module providing the pin controller, used for refcounting
  * @driver_data: driver data for drivers registering to the pin controller
  *	subsystem
- * @pinctrl_hogs: list of pin control maps hogged by this device
+ * @p: result of pinctrl_get() for this device
  * @device_root: debugfs root for this device
  */
 struct pinctrl_dev {
@@ -39,7 +39,7 @@ struct pinctrl_dev {
 	struct device *dev;
 	struct module *owner;
 	void *driver_data;
-	struct list_head pinctrl_hogs;
+	struct pinctrl *p;
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *device_root;
 #endif
diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index 73fbb27..20e9735 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -12,6 +12,8 @@
 #ifndef __LINUX_PINCTRL_MACHINE_H
 #define __LINUX_PINCTRL_MACHINE_H
 
+#include "pinctrl.h"
+
 /**
  * struct pinctrl_map - boards/machines shall provide this map for devices
  * @dev_name: the name of the device using this specific mapping, the name
@@ -49,17 +51,18 @@ struct pinctrl_map {
  * Convenience macro to map a system function onto a certain pinctrl device,
  * to be hogged by the pin control core until the system shuts down.
  */
-#define PIN_MAP_SYS_HOG(a, b, c) \
-	{ .name = a, .ctrl_dev_name = b, .dev_name = b, .function = c, }
+#define PIN_MAP_SYS_HOG(a, b) \
+	{ .name = PINCTRL_STATE_DEFAULT, .ctrl_dev_name = a, .dev_name = a, \
+	  .function = b, }
 
 /*
  * Convenience macro to map a system function onto a certain pinctrl device
  * using a specified group, to be hogged by the pin control core until the
  * system shuts down.
  */
-#define PIN_MAP_SYS_HOG_GROUP(a, b, c, d)		\
-	{ .name = a, .ctrl_dev_name = b, .dev_name = b, .function = c, \
-	  .group = d, }
+#define PIN_MAP_SYS_HOG_GROUP(a, b, c) \
+	{ .name = PINCTRL_STATE_DEFAULT, .ctrl_dev_name = a, .dev_name = a, \
+	  .function = b, .group = c, }
 
 #ifdef CONFIG_PINMUX
 
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 8bd22ee..411fe23 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -19,6 +19,8 @@
 #include <linux/list.h>
 #include <linux/seq_file.h>
 
+#define PINCTRL_STATE_DEFAULT "default"
+
 struct pinctrl_dev;
 struct pinmux_ops;
 struct pinconf_ops;
-- 
1.7.0.4

