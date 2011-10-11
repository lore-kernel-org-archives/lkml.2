Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab1JKHI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 03:08:56 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:38055 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750712Ab1JKHIz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 03:08:55 -0400
MIME-Version: 1.0
In-Reply-To: <20111010173506.GH3607@opensource.wolfsonmicro.com>
References: <1318263578-7407-1-git-send-email-rnayak@ti.com>
	<1318263578-7407-6-git-send-email-rnayak@ti.com>
	<20111010173506.GH3607@opensource.wolfsonmicro.com>
Date: Tue, 11 Oct 2011 12:38:53 +0530
Message-ID: <CACYZBRFmLEY_f1UwJa5U9uj8+NVA-WfUVkiuW1yKrpwnrA_00A@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] regulator: map consumer regulator based on device tree
From: "Nayak, Rajendra" <rnayak@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, lrg@ti.com, b-cousson@ti.com, patches@linaro.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>> +     if (supply) {
>> +             struct regulator_dev *r;
>> +             struct device_node *node;
>> +
>> +             /* first do a dt based lookup */
>> +             if (dev) {
>> +                     node = of_get_regulator(dev, supply);
>> +                     if (node)
>> +                             list_for_each_entry(r, &regulator_list, list)
>> +                                     if (node == r->dev.parent->of_node)
>> +                                             goto found;
>>               }
>>
>> -             if (!found) {
>> -                     dev_err(dev, "Failed to find supply %s\n",
>> -                             init_data->supply_regulator);
>> -                     ret = -ENODEV;
>> -                     goto scrub;
>> -             }
>> +             /* next try doing it non-dt way */
>> +             list_for_each_entry(r, &regulator_list, list)
>> +                     if (strcmp(rdev_get_name(r), supply) == 0)
>> +                             goto found;
>>
>> +             dev_err(dev, "Failed to find supply %s\n", supply);
>> +             ret = -ENODEV;
>> +             goto scrub;
>> +
>> +found:
>
> This is all getting *really* complicated and illegible.  I'm not sure
> what the best way to structure is but erroring out early looks useful.
>

How about this updated patch?

>From f4c7d2b283740382c272c7971665375067d26dbe Mon Sep 17 00:00:00 2001
From: Rajendra Nayak <rnayak@ti.com>
Date: Thu, 22 Sep 2011 17:51:10 +0530
Subject: [PATCH 5/5] regulator: map consumer regulator based on device tree

Device nodes in DT can associate themselves with one or more
regulators/supply by providing a list of phandles (to regulator nodes)
and corresponding supply names.

For Example:
	devicenode: node@0x0 {
		...
		...
		vmmc-supply = <&regulator1>;
		vpll-supply = <&regulator1>;
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
---
 drivers/regulator/core.c         |   91 +++++++++++++++++++++++++++++++------
 include/linux/regulator/driver.h |    2 +
 2 files changed, 78 insertions(+), 15 deletions(-)

Index: linux/drivers/regulator/core.c
===================================================================
--- linux.orig/drivers/regulator/core.c	2011-10-11 11:43:27.944140106 +0530
+++ linux/drivers/regulator/core.c	2011-10-11 12:25:53.540418748 +0530
@@ -25,9 +25,11 @@
 #include <linux/mutex.h>
 #include <linux/suspend.h>
 #include <linux/delay.h>
+#include <linux/of.h>
 #include <linux/regulator/consumer.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>

 #define CREATE_TRACE_POINTS
 #include <trace/events/regulator.h>
@@ -131,6 +133,33 @@
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
+static struct device_node *of_get_regulator(struct device *dev, const
char *supply)
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
+		pr_warn("%s: %s property in node %s references invalid phandle",
+			__func__, prop_name, dev->of_node->full_name);
+		return NULL;
+	}
+	return regnode;
+}
+
 /* Platform voltage constraint check */
 static int regulator_check_voltage(struct regulator_dev *rdev,
 				   int *min_uV, int *max_uV)
@@ -1147,6 +1176,28 @@
 	return rdev->desc->ops->enable_time(rdev);
 }

+static struct regulator_dev *regulator_dev_lookup(struct device *dev,
+							 const char *supply)
+{
+	struct regulator_dev *r;
+	struct device_node *node;
+
+	/* first do a dt based lookup */
+	if (dev && dev->of_node)
+		node = of_get_regulator(dev, supply);
+		if (node)
+			list_for_each_entry(r, &regulator_list, list)
+				if (node == r->dev.parent->of_node)
+					return r;
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
@@ -1155,6 +1206,7 @@
 	struct regulator_map *map;
 	struct regulator *regulator = ERR_PTR(-ENODEV);
 	const char *devname = NULL;
+	struct device_node *node;
 	int ret;

 	if (id == NULL) {
@@ -1167,6 +1219,10 @@

 	mutex_lock(&regulator_list_mutex);

+	rdev = regulator_dev_lookup(dev, id);
+	if (rdev)
+		goto found;
+
 	list_for_each_entry(map, &regulator_map_list, list) {
 		/* If the mapping has a device set up it must match */
 		if (map->dev_name &&
@@ -2579,6 +2635,7 @@
 	static atomic_t regulator_no = ATOMIC_INIT(0);
 	struct regulator_dev *rdev;
 	int ret, i;
+	const char *supply;

 	if (regulator_desc == NULL)
 		return ERR_PTR(-EINVAL);
@@ -2653,21 +2710,18 @@
 	if (ret < 0)
 		goto scrub;

-	if (init_data->supply_regulator) {
+	if (init_data->supply_regulator)
+		supply = init_data->supply_regulator;
+	else if (regulator_desc->supply_name);
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
Index: linux/include/linux/regulator/driver.h
===================================================================
--- linux.orig/include/linux/regulator/driver.h	2011-10-11
11:43:27.936139476 +0530
+++ linux/include/linux/regulator/driver.h	2011-10-11 11:43:43.485351850 +0530
@@ -153,6 +153,7 @@
  * this type.
  *
  * @name: Identifying name for the regulator.
+ * @supply_name: Identifying the regulator supply
  * @id: Numerical identifier for the regulator.
  * @n_voltages: Number of selectors available for ops.list_voltage().
  * @ops: Regulator operations table.
@@ -162,6 +163,7 @@
  */
 struct regulator_desc {
 	const char *name;
+	const char *supply_name;
 	int id;
 	unsigned n_voltages;
 	struct regulator_ops *ops;
