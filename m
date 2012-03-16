Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161922Ab2CPU4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:56:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60687 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161294Ab2CPUy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:54:59 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH 5/8] pinctrl: core device tree mapping table parsing support
Date: Fri, 16 Mar 2012 14:54:26 -0600
Message-Id: <1331931269-12262-5-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331931269-12262-1-git-send-email-swarren@wwwdotorg.org>
References: <1331931269-12262-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During pinctrl_get(), if the client device has a device tree node, look
for the common pinctrl properties there. If found, parse the referenced
device tree nodes, with the help of the pinctrl drivers, and generate
mapping table entries from them.

During pinctrl_put(), free any results of device tree parsing.

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
---
 drivers/pinctrl/core.c          |  313 ++++++++++++++++++++++++++++++++++++--
 drivers/pinctrl/core.h          |   16 ++
 include/linux/pinctrl/pinctrl.h |    7 +
 3 files changed, 319 insertions(+), 17 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index df6296c..aaefe16 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -23,6 +23,7 @@
 #include <linux/sysfs.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/of.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/machine.h>
 #include "core.h"
@@ -59,6 +60,10 @@ static LIST_HEAD(pinctrl_maps);
 			_i_ < _maps_node_->num_maps; \
 			i++, _map_ = &_maps_node_->maps[_i_])
 
+static int register_mappings(struct pinctrl_map const *maps, unsigned num_maps,
+			     bool dup, bool locked);
+static void pinctrl_put_locked(struct pinctrl *p, bool inlist);
+
 const char *pinctrl_dev_get_name(struct pinctrl_dev *pctldev)
 {
 	/* We're not allowed to register devices without name */
@@ -556,7 +561,255 @@ static struct pinctrl *find_pinctrl(struct device *dev)
 	return NULL;
 }
 
-static void pinctrl_put_locked(struct pinctrl *p, bool inlist);
+#ifdef CONFIG_OF
+static void unregister_mappings(struct pinctrl_map const *map)
+{
+	struct pinctrl_maps *maps_node;
+
+	list_for_each_entry(maps_node, &pinctrl_maps, node) {
+		if (maps_node->maps == map) {
+			list_del(&maps_node->node);
+			return;
+		}
+	}
+}
+
+static void dt_free_map(struct pinctrl_dev *pctldev,
+		     struct pinctrl_map *map, unsigned num_maps)
+{
+	if (pctldev) {
+		struct pinctrl_ops *ops = pctldev->desc->pctlops;
+		ops->dt_free_map(pctldev, map, num_maps);
+	} else {
+		kfree(map);
+	}
+}
+
+static void dt_free_maps(struct pinctrl *p)
+{
+	struct pinctrl_dt_map *dt_map, *n1;
+
+	list_for_each_entry_safe(dt_map, n1, &p->dt_maps, node) {
+		unregister_mappings(dt_map->map);
+		list_del(&dt_map->node);
+		dt_free_map(dt_map->pctldev, dt_map->map,
+			    dt_map->num_maps);
+		kfree(dt_map);
+	}
+
+	of_node_put(p->dev->of_node);
+}
+
+static int dt_remember_or_free_map(struct pinctrl *p, const char *statename,
+				   struct pinctrl_dev *pctldev,
+				   struct pinctrl_map *map, unsigned num_maps)
+{
+	int i;
+	struct pinctrl_dt_map *dt_map;
+
+	/* Initialize common mapping table entry fields */
+	for (i = 0; i < num_maps; i++) {
+		map[i].dev_name = dev_name(p->dev);
+		map[i].name = statename;
+		if (pctldev)
+			map[i].ctrl_dev_name = dev_name(pctldev->dev);
+	}
+
+	/* Remember the converted mapping table entries */
+	dt_map = kzalloc(sizeof(*dt_map), GFP_KERNEL);
+	if (!dt_map) {
+		dev_err(p->dev, "failed to alloc struct pinctrl_dt_map\n");
+		dt_free_map(pctldev, map, num_maps);
+		return -ENOMEM;
+	}
+
+	dt_map->pctldev = pctldev;
+	dt_map->map = map;
+	dt_map->num_maps = num_maps;
+	list_add_tail(&dt_map->node, &p->dt_maps);
+
+	return 0;
+}
+
+static struct pinctrl_dev *find_pctldev_by_of_node(struct device_node *np)
+{
+	struct pinctrl_dev *pctldev;
+
+	list_for_each_entry(pctldev, &pinctrldev_list, node)
+		if (pctldev->dev->of_node == np)
+			return pctldev;
+
+	return NULL;
+}
+
+static int dt_to_map_one_config(struct pinctrl *p, const char *statename,
+				struct device_node *np_config)
+{
+	struct device_node *np_pctldev;
+	struct pinctrl_dev *pctldev;
+	struct pinctrl_ops *ops;
+	int ret;
+	struct pinctrl_map *map;
+	unsigned num_maps;
+
+	/* Find the pin controller containing np_config */
+	np_pctldev = of_node_get(np_config);
+	for (;;) {
+		np_pctldev = of_get_next_parent(np_pctldev);
+		if (!np_pctldev || of_node_is_root(np_pctldev)) {
+			dev_err(p->dev, "could not find pctldev for node %s\n",
+				np_config->full_name);
+			of_node_put(np_pctldev);
+			/* FIXME: This should trigger deferrered probe */
+			return -ENODEV;
+		}
+		pctldev = find_pctldev_by_of_node(np_pctldev);
+		if (pctldev)
+			break;
+	}
+	of_node_put(np_pctldev);
+
+	/*
+	 * Call pinctrl driver to parse device tree node, and
+	 * generate mapping table entries
+	 */
+	ops = pctldev->desc->pctlops;
+	if (!ops->dt_node_to_map) {
+		dev_err(p->dev, "pctldev %s doesn't support DT\n",
+			dev_name(pctldev->dev));
+		return -ENODEV;
+	}
+	ret = ops->dt_node_to_map(pctldev, np_config, &map, &num_maps);
+	if (ret < 0)
+		return ret;
+
+	/* Stash the mapping table chunk away for later use */
+	ret = dt_remember_or_free_map(p, statename, pctldev,
+					map, num_maps);
+	if (ret < 0)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int dt_remember_dummy_state(struct pinctrl *p, const char *statename)
+{
+	struct pinctrl_map *map;
+	int ret;
+
+	map = kzalloc(sizeof(*map), GFP_KERNEL);
+	if (!map) {
+		dev_err(p->dev, "failed to alloc struct pinctrl_map\n");
+		return -ENOMEM;
+	}
+
+	map->type = PIN_MAP_TYPE_DUMMY_STATE;
+
+	ret = dt_remember_or_free_map(p, statename, NULL, map, 1);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int dt_to_map(struct pinctrl *p)
+{
+	struct device_node *np = p->dev->of_node;
+	int state, ret;
+	char *propname;
+	struct property *prop;
+	const char *statename;
+	const __be32 *list;
+	int size, config;
+	phandle phandle;
+	struct device_node *np_config;
+	struct pinctrl_dt_map *dt_map;
+
+	/* We may store pointers to property names within the node */
+	of_node_get(np);
+
+	/* For each defined state ID */
+	for (state = 0; ; state++) {
+		/* Retrieve the pinctrl-* property */
+		propname = kasprintf(GFP_KERNEL, "pinctrl-%d", state);
+		prop = of_find_property(np, propname, &size);
+		kfree(propname);
+		if (!prop)
+			break;
+		list = prop->value;
+		size /= sizeof(*list);
+
+		/* Determine whether pinctrl-names property names the state */
+		ret = of_property_read_string_index(np, "pinctrl-names",
+						    state, &statename);
+		/*
+		 * If not, statename is just the integer state ID. But rather
+		 * than dynamically allocate it and have to free it later,
+		 * just point part way into the property name for the string.
+		 */
+		if (ret < 0) {
+			/* strlen("pinctrl-") == 8 */
+			if (strlen(prop->name) < 8) {
+				dev_err(p->dev, "prop %s inconsistent length\n",
+					prop->name);
+				ret = -EINVAL;
+				goto err;
+			}
+			statename = prop->name + 8;
+		}
+
+		/* For every referenced pin configuration node in it */
+		for (config = 0; config < size; config++) {
+			phandle = be32_to_cpup(list++);
+
+			/* Look up the pin configuration node */
+			np_config = of_find_node_by_phandle(phandle);
+			if (!np_config) {
+				dev_err(p->dev,
+					"prop %s index %i invalid phandle\n",
+					prop->name, config);
+				ret = -EINVAL;
+				goto err;
+			}
+
+			/* Parse the node */
+			ret = dt_to_map_one_config(p, statename, np_config);
+			of_node_put(np_config);
+			if (ret < 0)
+				goto err;
+		}
+
+		/* No entries in DT? Generate a dummy state table entry */
+		if (!size) {
+			ret = dt_remember_dummy_state(p, statename);
+			if (ret < 0)
+				goto err;
+		}
+	}
+
+	list_for_each_entry(dt_map, &p->dt_maps, node) {
+		ret = register_mappings(dt_map->map, dt_map->num_maps, false,
+					true);
+		if (ret < 0)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	dt_free_maps(p);
+	return ret;
+}
+#else
+static int dt_to_map(struct pinctrl *p)
+{
+	return 0;
+}
+
+static void dt_free_maps(struct pinctrl *p)
+{
+}
+#endif
 
 static struct pinctrl *create_pinctrl(struct device *dev)
 {
@@ -579,6 +832,13 @@ static struct pinctrl *create_pinctrl(struct device *dev)
 	}
 	p->dev = dev;
 	INIT_LIST_HEAD(&p->states);
+	INIT_LIST_HEAD(&p->dt_maps);
+
+	ret = dt_to_map(p);
+	if (ret < 0) {
+		kfree(p);
+		return ERR_PTR(ret);
+	}
 
 	devname = dev_name(dev);
 
@@ -662,6 +922,8 @@ static void pinctrl_put_locked(struct pinctrl *p, bool inlist)
 		kfree(state);
 	}
 
+	dt_free_maps(p);
+
 	if (inlist)
 		list_del(&p->node);
 	kfree(p);
@@ -787,15 +1049,8 @@ int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
 }
 EXPORT_SYMBOL_GPL(pinctrl_select_state);
 
-/**
- * pinctrl_register_mappings() - register a set of pin controller mappings
- * @maps: the pincontrol mappings table to register. This should probably be
- *	marked with __initdata so it can be discarded after boot. This
- *	function will perform a shallow copy for the mapping entries.
- * @num_maps: the number of maps in the mapping table
- */
-int pinctrl_register_mappings(struct pinctrl_map const *maps,
-			      unsigned num_maps)
+static int register_mappings(struct pinctrl_map const *maps, unsigned num_maps,
+			     bool dup, bool locked)
 {
 	int i, ret;
 	struct pinctrl_maps *maps_node;
@@ -851,20 +1106,41 @@ int pinctrl_register_mappings(struct pinctrl_map const *maps,
 	}
 
 	maps_node->num_maps = num_maps;
-	maps_node->maps = kmemdup(maps, sizeof(*maps) * num_maps, GFP_KERNEL);
-	if (!maps_node->maps) {
-		pr_err("failed to duplicate mapping table\n");
-		kfree(maps_node);
-		return -ENOMEM;
+	if (dup) {
+		maps_node->maps = kmemdup(maps, sizeof(*maps) * num_maps,
+					  GFP_KERNEL);
+		if (!maps_node->maps) {
+			pr_err("failed to duplicate mapping table\n");
+			kfree(maps_node);
+			return -ENOMEM;
+		}
+	} else {
+		maps_node->maps = maps;
 	}
 
-	mutex_lock(&pinctrl_mutex);
+	if (!locked)
+		mutex_lock(&pinctrl_mutex);
 	list_add_tail(&maps_node->node, &pinctrl_maps);
-	mutex_unlock(&pinctrl_mutex);
+	if (!locked)
+		mutex_unlock(&pinctrl_mutex);
 
 	return 0;
 }
 
+/**
+ * pinctrl_register_mappings() - register a set of pin controller mappings
+ * @maps: the pincontrol mappings table to register. This should probably be
+ *	marked with __initdata so it can be discarded after boot. This
+ *	function will perform a shallow copy for the mapping entries.
+ * @num_maps: the number of maps in the mapping table
+ */
+int pinctrl_register_mappings(struct pinctrl_map const *maps,
+			      unsigned num_maps)
+{
+	return register_mappings(maps, num_maps, true, false);
+
+}
+
 #ifdef CONFIG_DEBUG_FS
 
 static int pinctrl_pins_show(struct seq_file *s, void *what)
@@ -1231,6 +1507,9 @@ static int pinctrl_check_ops(struct pinctrl_dev *pctldev)
 	    !ops->get_group_pins)
 		return -EINVAL;
 
+	if (ops->dt_node_to_map && !ops->dt_free_map)
+		return -EINVAL;
+
 	return 0;
 }
 
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 17ecf65..9d3a153 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -47,17 +47,33 @@ struct pinctrl_dev {
 };
 
 /**
+ * struct pinctrl_dt_map - mapping table chunk parsed from device tree
+ * @node: list node for struct pinctrl's @dt_maps field
+ * @pctldev: the pin controller that allocated this struct, and will free it
+ * @maps: the mapping table entries
+ */
+struct pinctrl_dt_map {
+	struct list_head node;
+	struct pinctrl_dev *pctldev;
+	struct pinctrl_map *map;
+	unsigned num_maps;
+};
+
+/**
  * struct pinctrl - per-device pin control state holder
  * @node: global list node
  * @dev: the device using this pin control handle
  * @states: a list of states for this device
  * @state: the current state
+ * @dt_maps: the mapping table chunks dynamically parsed from device tree for
+ *	this device, if any
  */
 struct pinctrl {
 	struct list_head node;
 	struct device *dev;
 	struct list_head states;
 	struct pinctrl_state *state;
+	struct list_head dt_maps;
 };
 
 /**
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 4e9f078..aa92cde 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -21,9 +21,11 @@
 
 struct device;
 struct pinctrl_dev;
+struct pinctrl_map;
 struct pinmux_ops;
 struct pinconf_ops;
 struct gpio_chip;
+struct device_node;
 
 /**
  * struct pinctrl_pin_desc - boards/machines provide information on their
@@ -83,6 +85,11 @@ struct pinctrl_ops {
 			       unsigned *num_pins);
 	void (*pin_dbg_show) (struct pinctrl_dev *pctldev, struct seq_file *s,
 			  unsigned offset);
+	int (*dt_node_to_map) (struct pinctrl_dev *pctldev,
+			       struct device_node *np_config,
+			       struct pinctrl_map **map, unsigned *num_maps);
+	void (*dt_free_map) (struct pinctrl_dev *pctldev,
+			     struct pinctrl_map *map, unsigned num_maps);
 };
 
 /**
-- 
1.7.0.4

