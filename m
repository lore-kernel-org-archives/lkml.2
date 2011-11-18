Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab1KRLSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:18:32 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51372 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab1KRLSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:18:30 -0500
From: Rajendra Nayak <rnayak@ti.com>
To: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <robherring2@gmail.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tony@atomide.com>,
        <lrg@ti.com>, <b-cousson@ti.com>, <patches@linaro.org>,
        <linux-kernel@vger.kernel.org>, <shawn.guo@freescale.com>,
        <linaro-dev@lists.linaro.org>, <olof@lixom.net>,
        Rajendra Nayak <rnayak@ti.com>
Subject: [PATCH v5 4/4] regulator: map consumer regulator based on device tree
Date: Fri, 18 Nov 2011 16:47:20 +0530
Message-ID: <1321615040-13257-5-git-send-email-rnayak@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1321615040-13257-1-git-send-email-rnayak@ti.com>
References: <1321615040-13257-1-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device nodes in DT can associate themselves with one or more
regulators/supply by providing a list of phandles (to regulator nodes)
and corresponding supply names.

For Example:
	devicenode: node@0x0 {
		...
		...
		vmmc-supply = <&regulator1>;
		vpll-supply = <&regulator2>;
	};

The driver would then do a regulator_get(dev, "vmmc"); to get
regulator1 and do a regulator_get(dev, "vpll"); to get
regulator2.

of_get_regulator() extracts the regulator node for a given
device, based on the supply name.

Use it to look up the regulator for a given consumer from device tree, during
a regulator_get(). If not found fallback and lookup through
the regulator_map_list instead.

Also, since the regulator dt nodes can use the same binding to
associate with a parent regulator/supply, allow the drivers to
specify a supply_name, which can then be used to lookup dt
to find the parent phandle.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c         |   79 ++++++++++++++++++++++++++++++++------
 include/linux/regulator/driver.h |    2 +
 2 files changed, 69 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 8b01eb0..9867ebc 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -25,6 +25,8 @@
 #include <linux/mutex.h>
 #include <linux/suspend.h>
 #include <linux/delay.h>
+#include <linux/of.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/regulator/consumer.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
@@ -132,6 +134,33 @@ static struct regulator *get_device_regulator(struct device *dev)
 	return NULL;
 }
 
+/**
+ * of_get_regulator - get a regulator device node based on supply name
+ * @dev: Device pointer for the consumer (of regulator) device
+ * @supply: regulator supply name
+ *
+ * Extract the regulator device node corresponding to the supply name.
+ * retruns the device node corresponding to the regulator if found, else
+ * returns NULL.
+ */
+static struct device_node *of_get_regulator(struct device *dev, const char *supply)
+{
+	struct device_node *regnode = NULL;
+	char prop_name[32]; /* 32 is max size of property name */
+
+	dev_dbg(dev, "Looking up %s-supply from device tree\n", supply);
+
+	snprintf(prop_name, 32, "%s-supply", supply);
+	regnode = of_parse_phandle(dev->of_node, prop_name, 0);
+
+	if (!regnode) {
+		dev_warn(dev, "%s property in node %s references invalid phandle",
+				prop_name, dev->of_node->full_name);
+		return NULL;
+	}
+	return regnode;
+}
+
 /* Platform voltage constraint check */
 static int regulator_check_voltage(struct regulator_dev *rdev,
 				   int *min_uV, int *max_uV)
@@ -1148,6 +1177,30 @@ static int _regulator_get_enable_time(struct regulator_dev *rdev)
 	return rdev->desc->ops->enable_time(rdev);
 }
 
+static struct regulator_dev *regulator_dev_lookup(struct device *dev,
+							 const char *supply)
+{
+	struct regulator_dev *r;
+	struct device_node *node;
+
+	/* first do a dt based lookup */
+	if (dev && dev->of_node) {
+		node = of_get_regulator(dev, supply);
+		if (node)
+			list_for_each_entry(r, &regulator_list, list)
+				if (r->dev.parent &&
+					node == r->dev.of_node)
+					return r;
+	}
+
+	/* if not found, try doing it non-dt way */
+	list_for_each_entry(r, &regulator_list, list)
+		if (strcmp(rdev_get_name(r), supply) == 0)
+			return r;
+
+	return NULL;
+}
+
 /* Internal regulator request function */
 static struct regulator *_regulator_get(struct device *dev, const char *id,
 					int exclusive)
@@ -1168,6 +1221,10 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 
 	mutex_lock(&regulator_list_mutex);
 
+	rdev = regulator_dev_lookup(dev, id);
+	if (rdev)
+		goto found;
+
 	list_for_each_entry(map, &regulator_map_list, list) {
 		/* If the mapping has a device set up it must match */
 		if (map->dev_name &&
@@ -2642,6 +2699,7 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	static atomic_t regulator_no = ATOMIC_INIT(0);
 	struct regulator_dev *rdev;
 	int ret, i;
+	const char *supply = NULL;
 
 	if (regulator_desc == NULL)
 		return ERR_PTR(-EINVAL);
@@ -2718,21 +2776,18 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	if (ret < 0)
 		goto scrub;
 
-	if (init_data->supply_regulator) {
+	if (init_data->supply_regulator)
+		supply = init_data->supply_regulator;
+	else if (regulator_desc->supply_name)
+		supply = regulator_desc->supply_name;
+
+	if (supply) {
 		struct regulator_dev *r;
-		int found = 0;
 
-		list_for_each_entry(r, &regulator_list, list) {
-			if (strcmp(rdev_get_name(r),
-				   init_data->supply_regulator) == 0) {
-				found = 1;
-				break;
-			}
-		}
+		r = regulator_dev_lookup(dev, supply);
 
-		if (!found) {
-			dev_err(dev, "Failed to find supply %s\n",
-				init_data->supply_regulator);
+		if (!r) {
+			dev_err(dev, "Failed to find supply %s\n", supply);
 			ret = -ENODEV;
 			goto scrub;
 		}
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 8fbb696..4214b9a 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -154,6 +154,7 @@ enum regulator_type {
  * this type.
  *
  * @name: Identifying name for the regulator.
+ * @supply_name: Identifying the regulator supply
  * @id: Numerical identifier for the regulator.
  * @n_voltages: Number of selectors available for ops.list_voltage().
  * @ops: Regulator operations table.
@@ -163,6 +164,7 @@ enum regulator_type {
  */
 struct regulator_desc {
 	const char *name;
+	const char *supply_name;
 	int id;
 	unsigned n_voltages;
 	struct regulator_ops *ops;
-- 
1.7.1

