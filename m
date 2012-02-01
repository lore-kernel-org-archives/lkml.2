Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2BARYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:24:39 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:46987 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753450Ab2BARYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:24:37 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] pinctrl: delete raw device pointers in pinmux maps
Date: Wed, 1 Feb 2012 18:24:13 +0100
Message-ID: <1328117053-27807-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

After discussion with Mark Brown in an unrelated thread about
ADC lookups, it came to my knowledge that the ability to pass
a struct device * in the regulator consumers is just a
historical artifact, and not really recommended. Since there
are no in-kernel users of these pointers, we just kill them
right now, before someone starts to use them.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/core.c          |   22 +++++++---------------
 drivers/pinctrl/core.h          |    3 +--
 drivers/pinctrl/pinconf.c       |    8 ++++----
 drivers/pinctrl/pinmux.c        |   27 ++++++++-------------------
 include/linux/pinctrl/machine.h |   12 ++----------
 5 files changed, 22 insertions(+), 50 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 894cd5e..4f10476 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -48,31 +48,23 @@ void *pinctrl_dev_get_drvdata(struct pinctrl_dev *pctldev)
 EXPORT_SYMBOL_GPL(pinctrl_dev_get_drvdata);
 
 /**
- * get_pinctrl_dev_from_dev() - look up pin controller device
- * @dev: a device pointer, this may be NULL but then devname needs to be
- *	defined instead
- * @devname: the name of a device instance, as returned by dev_name(), this
- *	may be NULL but then dev needs to be defined instead
+ * get_pinctrl_dev_from_devname() - look up pin controller device
+ * @devname: the name of a device instance, as returned by dev_name()
  *
  * Looks up a pin control device matching a certain device name or pure device
  * pointer, the pure device pointer will take precedence.
  */
-struct pinctrl_dev *get_pinctrl_dev_from_dev(struct device *dev,
-					     const char *devname)
+struct pinctrl_dev *get_pinctrl_dev_from_devname(const char *devname)
 {
 	struct pinctrl_dev *pctldev = NULL;
 	bool found = false;
 
+	if (!devname)
+		return NULL;
+
 	mutex_lock(&pinctrldev_list_mutex);
 	list_for_each_entry(pctldev, &pinctrldev_list, node) {
-		if (dev && pctldev->dev == dev) {
-			/* Matched on device pointer */
-			found = true;
-			break;
-		}
-
-		if (devname &&
-		    !strcmp(dev_name(pctldev->dev), devname)) {
+		if (!strcmp(dev_name(pctldev->dev), devname)) {
 			/* Matched on device name */
 			found = true;
 			break;
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index cfa86da..8a8b02e 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -72,8 +72,7 @@ struct pin_desc {
 #endif
 };
 
-struct pinctrl_dev *get_pinctrl_dev_from_dev(struct device *dev,
-					     const char *dev_name);
+struct pinctrl_dev *get_pinctrl_dev_from_devname(const char *dev_name);
 struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, unsigned int pin);
 int pin_get_from_name(struct pinctrl_dev *pctldev, const char *name);
 int pinctrl_get_device_gpio_range(unsigned gpio,
diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index e7adde4..0309bce 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -51,7 +51,7 @@ int pin_config_get(const char *dev_name, const char *name,
 	struct pinctrl_dev *pctldev;
 	int pin;
 
-	pctldev = get_pinctrl_dev_from_dev(NULL, dev_name);
+	pctldev = get_pinctrl_dev_from_devname(dev_name);
 	if (!pctldev)
 		return -EINVAL;
 
@@ -99,7 +99,7 @@ int pin_config_set(const char *dev_name, const char *name,
 	struct pinctrl_dev *pctldev;
 	int pin;
 
-	pctldev = get_pinctrl_dev_from_dev(NULL, dev_name);
+	pctldev = get_pinctrl_dev_from_devname(dev_name);
 	if (!pctldev)
 		return -EINVAL;
 
@@ -118,7 +118,7 @@ int pin_config_group_get(const char *dev_name, const char *pin_group,
 	const struct pinconf_ops *ops;
 	int selector;
 
-	pctldev = get_pinctrl_dev_from_dev(NULL, dev_name);
+	pctldev = get_pinctrl_dev_from_devname(dev_name);
 	if (!pctldev)
 		return -EINVAL;
 	ops = pctldev->desc->confops;
@@ -151,7 +151,7 @@ int pin_config_group_set(const char *dev_name, const char *pin_group,
 	int ret;
 	int i;
 
-	pctldev = get_pinctrl_dev_from_dev(NULL, dev_name);
+	pctldev = get_pinctrl_dev_from_devname(dev_name);
 	if (!pctldev)
 		return -EINVAL;
 	ops = pctldev->desc->confops;
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 7c3193f..1311f1d 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -354,7 +354,7 @@ int __init pinmux_register_mappings(struct pinmux_map const *maps,
 			return -EINVAL;
 		}
 
-		if (!maps[i].ctrl_dev && !maps[i].ctrl_dev_name) {
+		if (!maps[i].ctrl_dev_name) {
 			pr_err("failed to register map %s (%d): no pin control device given\n",
 			       maps[i].name, i);
 			return -EINVAL;
@@ -366,7 +366,7 @@ int __init pinmux_register_mappings(struct pinmux_map const *maps,
 			return -EINVAL;
 		}
 
-		if (!maps[i].dev && !maps[i].dev_name)
+		if (!maps[i].dev_name)
 			pr_debug("add system map %s function %s with no device\n",
 				 maps[i].name,
 				 maps[i].function);
@@ -721,20 +721,12 @@ struct pinmux *pinmux_get(struct device *dev, const char *name)
 		/*
 		 * First, try to find the pctldev given in the map
 		 */
-		pctldev = get_pinctrl_dev_from_dev(map->ctrl_dev,
-						   map->ctrl_dev_name);
+		pctldev = get_pinctrl_dev_from_devname(map->ctrl_dev_name);
 		if (!pctldev) {
-			const char *devname = NULL;
-
-			if (map->ctrl_dev)
-				devname = dev_name(map->ctrl_dev);
-			else if (map->ctrl_dev_name)
-				devname = map->ctrl_dev_name;
-
 			pr_warning("could not find a pinctrl device for pinmux function %s, fishy, they shall all have one\n",
 				   map->function);
 			pr_warning("given pinctrl device name: %s",
-				   devname ? devname : "UNDEFINED");
+				   map->ctrl_dev_name);
 
 			/* Continue to check the other mappings anyway... */
 			continue;
@@ -925,7 +917,7 @@ static int pinmux_hog_map(struct pinctrl_dev *pctldev,
 	struct pinmux *pmx;
 	int ret;
 
-	if (map->dev || map->dev_name) {
+	if (map->dev_name) {
 		/*
 		 * TODO: the day we have device tree support, we can
 		 * traverse the device tree and hog to specific device nodes
@@ -996,9 +988,8 @@ int pinmux_hog_maps(struct pinctrl_dev *pctldev)
 		if (!map->hog_on_boot)
 			continue;
 
-		if ((map->ctrl_dev == dev) ||
-			(map->ctrl_dev_name &&
-				!strcmp(map->ctrl_dev_name, devname))) {
+		if (map->ctrl_dev_name &&
+		    !strcmp(map->ctrl_dev_name, devname)) {
 			/* OK time to hog! */
 			ret = pinmux_hog_map(pctldev, map);
 			if (ret)
@@ -1156,14 +1147,12 @@ static int pinmux_maps_show(struct seq_file *s, void *what)
 		struct pinmux_map const *map = &pinmux_maps[i];
 
 		seq_printf(s, "%s:\n", map->name);
-		if (map->dev || map->dev_name)
+		if (map->dev_name)
 			seq_printf(s, "  device: %s\n",
-				   map->dev ? dev_name(map->dev) :
 				   map->dev_name);
 		else
 			seq_printf(s, "  SYSTEM MUX\n");
 		seq_printf(s, "  controlling device %s\n",
-			   map->ctrl_dev ? dev_name(map->ctrl_dev) :
 			   map->ctrl_dev_name);
 		seq_printf(s, "  function: %s\n", map->function);
 		seq_printf(s, "  group: %s\n", map->group ? map->group :
diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index d0aecb7..f8593fd 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -17,22 +17,16 @@
  * @name: the name of this specific map entry for the particular machine.
  *	This is the second parameter passed to pinmux_get() when you want
  *	to have several mappings to the same device
- * @ctrl_dev: the pin control device to be used by this mapping, may be NULL
- *	if you provide .ctrl_dev_name instead (this is more common)
  * @ctrl_dev_name: the name of the device controlling this specific mapping,
- *	the name must be the same as in your struct device*, may be NULL if
- *	you provide .ctrl_dev instead
+ *	the name must be the same as in your struct device*
  * @function: a function in the driver to use for this mapping, the driver
  *	will lookup the function referenced by this ID on the specified
  *	pin control device
  * @group: sometimes a function can map to different pin groups, so this
  *	selects a certain specific pin group to activate for the function, if
  *	left as NULL, the first applicable group will be used
- * @dev: the device using this specific mapping, may be NULL if you provide
- *	.dev_name instead (this is more common)
  * @dev_name: the name of the device using this specific mapping, the name
- *	must be the same as in your struct device*, may be NULL if you
- *	provide .dev instead
+ *	must be the same as in your struct device*
  * @hog_on_boot: if this is set to true, the pin control subsystem will itself
  *	hog the mappings as the pinmux device drivers are attached, so this is
  *	typically used with system maps (mux mappings without an assigned
@@ -42,11 +36,9 @@
  */
 struct pinmux_map {
 	const char *name;
-	struct device *ctrl_dev;
 	const char *ctrl_dev_name;
 	const char *function;
 	const char *group;
-	struct device *dev;
 	const char *dev_name;
 	bool hog_on_boot;
 };
-- 
1.7.8

