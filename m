Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab2BTGug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:50:36 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19396 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab2BTGrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:47:00 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 19 Feb 2012 22:46:13 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 09/20] pinctrl: Disallow map table entries with NULL dev_name field
Date: Sun, 19 Feb 2012 23:45:49 -0700
Message-Id: <1329720360-23227-10-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hog entries are mapping table entries with .ctrl_dev_name == .dev_name.
All other mapping table entries need .dev_name set so that they will
match some pinctrl_get() call. All extant PIN_MAP*() macros set
.dev_name.

So, there is no reason to allow mapping table entries without .dev_name
set. Update the code and documentation to disallow this.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 Documentation/pinctrl.txt       |   15 +++-----
 drivers/pinctrl/core.c          |   75 ++++++++++++--------------------------
 include/linux/pinctrl/machine.h |    7 ----
 3 files changed, 29 insertions(+), 68 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index bfe83b1..12b35db 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -494,14 +494,10 @@ Definitions:
     {"map-i2c0", i2c0, pinctrl0, fi2c0, gi2c0}
   }
 
-  Every map must be assigned a symbolic name, pin controller and function.
-  The group is not compulsory - if it is omitted the first group presented by
-  the driver as applicable for the function will be selected, which is
-  useful for simple cases.
-
-  The device name is present in map entries tied to specific devices. Maps
-  without device names are referred to as SYSTEM pinmuxes, such as can be taken
-  by the machine implementation on boot and not tied to any specific device.
+  Every map must be assigned a state name, pin controller, device and
+  function. The group is not compulsory - if it is omitted the first group
+  presented by the driver as applicable for the function will be selected,
+  which is useful for simple cases.
 
   It is possible to map several groups to the same combination of device,
   pin controller and function. This is for cases where a certain function on
@@ -979,8 +975,7 @@ after this you should be able to see this in the debugfs listing of all pins.
 System pin control hogging
 ==========================
 
-A system pin control map entry, i.e. a pin control setting that does not have
-a device associated with it, can be hogged by the core when the pin controller
+Pin control map entries can be hogged by the core when the pin controller
 is registered. This means that the core will attempt to call pinctrl_get() and
 pinctrl_enable() on it immediately after the pin control device has been
 registered.
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 5e30d91..331ffb6 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -479,24 +479,21 @@ EXPORT_SYMBOL_GPL(pinctrl_gpio_direction_output);
 static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 {
 	struct pinctrl_dev *pctldev = NULL;
-	const char *devname = NULL;
+	const char *devname;
 	struct pinctrl *p;
-	bool found_map;
 	unsigned num_maps = 0;
 	int ret = -ENODEV;
 	struct pinctrl_maps *maps_node;
 	int i;
 	struct pinctrl_map const *map;
 
-	/* We must have a state name */
-	if (WARN_ON(!name))
+	/* We must have both dev and state name */
+	if (WARN_ON(!dev || !name))
 		return ERR_PTR(-EINVAL);
 
-	if (dev)
-		devname = dev_name(dev);
+	devname = dev_name(dev);
 
-	pr_debug("get pin control handle %s for device %s\n", name,
-		 devname ? devname : "(none)");
+	pr_debug("get pin control handle device %s state %s\n", devname, name);
 
 	/*
 	 * create the state cookie holder struct pinctrl for each
@@ -511,8 +508,6 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 
 	/* Iterate over the pin control maps to locate the right ones */
 	for_each_maps(maps_node, i, map) {
-		found_map = false;
-
 		/*
 		 * First, try to find the pctldev given in the map
 		 */
@@ -530,47 +525,33 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 		pr_debug("in map, found pctldev %s to handle function %s",
 			 dev_name(pctldev->dev), map->function);
 
+		/* Map must be for this device */
+		if (strcmp(map->dev_name, devname))
+			continue;
+
 		/* State name must be the one we're looking for */
 		if (strcmp(map->name, name))
 			continue;
 
-		/*
-		 * This is for the case where no device name is given, we
-		 * already know that the function name matches from above
-		 * code.
-		 */
-		if (!map->dev_name)
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
-			ret = pinmux_apply_muxmap(pctldev, p, dev,
-						   devname, map);
-			if (ret) {
-				kfree(p);
-				return ERR_PTR(ret);
-			}
-			num_maps++;
+		ret = pinmux_apply_muxmap(pctldev, p, dev,
+					    devname, map);
+		if (ret) {
+			kfree(p);
+			return ERR_PTR(ret);
 		}
+		num_maps++;
 	}
 
 	/* We should have atleast one map, right */
 	if (!num_maps) {
 		pr_err("could not find any mux maps for device %s, ID %s\n",
-		       devname ? devname : "(anonymous)", name);
+		       devname, name);
 		kfree(p);
 		return ERR_PTR(-EINVAL);
 	}
 
 	pr_debug("found %u mux maps for device %s, UD %s\n",
-		 num_maps,
-		 devname ? devname : "(anonymous)", name);
+		 num_maps, devname, name);
 
 	/* Add the pinmux to the global list */
 	mutex_lock(&pinctrl_list_mutex);
@@ -697,14 +678,11 @@ int pinctrl_register_mappings(struct pinctrl_map const *maps,
 			return -EINVAL;
 		}
 
-		if (!maps[i].dev_name)
-			pr_debug("add system map %s function %s with no device\n",
-				 maps[i].name,
-				 maps[i].function);
-		else
-			pr_debug("register map %s, function %s\n",
-				 maps[i].name,
-				 maps[i].function);
+		if (!maps[i].dev_name) {
+			pr_err("failed to register map %s (%d): no device given\n",
+					maps[i].name, i);
+			return -EINVAL;
+		}
 	}
 
 	maps_node = kzalloc(sizeof(*maps_node), GFP_KERNEL);
@@ -929,13 +907,8 @@ static int pinctrl_maps_show(struct seq_file *s, void *what)
 	mutex_lock(&pinctrl_maps_mutex);
 	for_each_maps(maps_node, i, map) {
 		seq_printf(s, "%s:\n", map->name);
-		if (map->dev_name)
-			seq_printf(s, "  device: %s\n",
-				   map->dev_name);
-		else
-			seq_printf(s, "  SYSTEM MUX\n");
-		seq_printf(s, "  controlling device %s\n",
-			   map->ctrl_dev_name);
+		seq_printf(s, "  device: %s\n", map->dev_name);
+		seq_printf(s, "  controlling device %s\n", map->ctrl_dev_name);
 		seq_printf(s, "  function: %s\n", map->function);
 		seq_printf(s, "  group: %s\n", map->group ? map->group :
 			   "(default)");
diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index af145d5..400f192 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -46,13 +46,6 @@ struct pinctrl_map {
 	{ .name = a, .ctrl_dev_name = b, .function = c, .dev_name = d }
 
 /*
- * Convenience macro to map a system function onto a certain pinctrl device.
- * System functions are not assigned to a particular device.
- */
-#define PIN_MAP_SYS(a, b, c) \
-	{ .name = a, .ctrl_dev_name = b, .function = c }
-
-/*
  * Convenience macro to map a system function onto a certain pinctrl device,
  * to be hogged by the pin control core until the system shuts down.
  */
-- 
1.7.5.4

