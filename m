Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab2IUJtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:49:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23896 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab2IUJts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:49:48 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-16-505c383b2be6
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: cbouatmailru@gmail.com, jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH v2] charger-manager: Add support sysfs entry for charger
Date: Fri, 21 Sep 2012 18:49:37 +0900
Message-id: <1348220977-17556-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJMWRmVeSWpSXmKPExsVy+t9jQV1ri5gAg6l3uCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGoZ3bWQs2RVe0/l7G1sA41buLkYNDQsBE4uVLlS5GTiBTTOLC
	vfVsXYxcHEIC0xklFq15zgThLGWSmLC8nxWkik1AS2L/ixtsILaIgJzE67V/wYqYBU4xSjy6
	eIIZJCEs4CHR9LGDDWQDi4CqxLlPGSBhXgFXiYsHtrJCbFOQaF12iH0CI/cCRoZVjKKpBckF
	xUnpuUZ6xYm5xaV56XrJ+bmbGMEefCa9g3FVg8UhRgEORiUe3hXfogOEWBPLiitzDzFKcDAr
	ifA+igEK8aYkVlalFuXHF5XmpBYfYpTmYFES5xX+FBggJJCeWJKanZpakFoEk2Xi4JRqYKxu
	KbrS/VEn8PLs3VFz3Y7JvrG3+n5lcSq3l1O9UM2ly6Ixi34v5qjau8bnQT/D7Kl2x9c22mVf
	54i2cWZifPDBa+n//84nphjKXGB0k83e2FPuY2Mre9nwyHHZ2Qy/W/VcXqy/cuyVX2Qz47Wd
	7l/mfT90XVT20/e2OfmvW2uPtGVYr3h03kqJpTgj0VCLuag4EQCDAz7h3AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support sysfs entry for each charger(regulator).
Charger-manager use one or more chargers for charging battery but
some charger isn't necessary on specific scenario. So, if some charger
isn't needed, can disable specific charger through 'externally_control'
entry while system is on state and confirm the information(name, state)
of charger.

patch-v2:
- Fix build break and fix codingstype which remove space in the for loop statement

  CHECK   drivers/power/charger-manager.c
drivers/power/charger-manager.c:1559:17: error: undefined identifier 'cable'
drivers/power/charger-manager.c:1564:17: error: undefined identifier 'cable'
drivers/power/charger-manager.c:1569:17: error: undefined identifier 'cable'
  CC      drivers/power/charger-manager.o
drivers/power/charger-manager.c: In function 'charger_manager_probe':
drivers/power/charger-manager.c:1559:3: error: 'cable' undeclared (first use in this function)
drivers/power/charger-manager.c:1559:3: note: each undeclared identifier is reported only once for each function it appears in
make[1]: *** [drivers/power/charger-manager.o] Error 1

patch-v1:
the list of added sysfs entry
- /sys/class/power_supply/battery/chargers/charger.[index]/name
: show name of charger(regulator)
- /sys/class/power_supply/battery/chargers/charger.[index]/state
: show either enabled or disabled state of charger
- /sys/class/power_supply/battery/chargers/charger.[index]/externally_control

If 'externally_control' of specific charger is 1, Charger-manager cannot enable
regulator for charging when charger cable is attached and charger must be
maintained with disabled state. If 'externally_control' is zero, Charger-manager
usually can control to enable/disable regulator.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/charger-manager.c       |  174 ++++++++++++++++++++++++++++++++-
 include/linux/power/charger-manager.h |   19 ++++
 2 files changed, 192 insertions(+), 1 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index e92ec55..a1ab825 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -22,6 +22,7 @@
 #include <linux/platform_device.h>
 #include <linux/power/charger-manager.h>
 #include <linux/regulator/consumer.h>
+#include <linux/sysfs.h>
 
 static const char * const default_event_names[] = {
 	[CM_EVENT_UNKNOWN] = "Unknown",
@@ -332,6 +333,9 @@ static int try_charger_enable(struct charger_manager *cm, bool enable)
 		cm->charging_end_time = 0;
 
 		for (i = 0 ; i < desc->num_charger_regulators ; i++) {
+			if (desc->charger_regulators[i].externally_control)
+				continue;
+
 			err = regulator_enable(desc->charger_regulators[i].consumer);
 			if (err < 0) {
 				dev_warn(cm->dev,
@@ -348,6 +352,9 @@ static int try_charger_enable(struct charger_manager *cm, bool enable)
 		cm->charging_end_time = ktime_to_ms(ktime_get());
 
 		for (i = 0 ; i < desc->num_charger_regulators ; i++) {
+			if (desc->charger_regulators[i].externally_control)
+				continue;
+
 			err = regulator_disable(desc->charger_regulators[i].consumer);
 			if (err < 0) {
 				dev_warn(cm->dev,
@@ -1217,12 +1224,101 @@ static int charger_extcon_init(struct charger_manager *cm,
 	return ret;
 }
 
+/* help function of sysfs node to control charger(regulator) */
+static ssize_t charger_name_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct charger_regulator *charger
+		= container_of(attr, struct charger_regulator, attr_name);
+	return sprintf(buf, "%s\n", charger->regulator_name);
+}
+
+static ssize_t charger_state_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct charger_regulator *charger
+		= container_of(attr, struct charger_regulator, attr_state);
+	int state = 1;
+
+	if (charger->externally_control)
+		state = 0;
+	else
+		state = regulator_is_enabled(charger->consumer);
+
+	return sprintf(buf, "%s\n", state ? "enabled" : "disabled");
+}
+
+static ssize_t charger_externally_control_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct charger_regulator *charger = container_of(attr,
+			struct charger_regulator, attr_externally_control);
+	return sprintf(buf, "%d\n", charger->externally_control);
+}
+
+static ssize_t charger_externally_control_store(struct device *dev,
+				struct device_attribute *attr, const char *buf,
+				size_t count)
+{
+	struct charger_regulator *charger
+		= container_of(attr, struct charger_regulator,
+					attr_externally_control);
+	struct charger_manager *cm = charger->cm;
+	struct charger_desc *desc = cm->desc;
+	int i, ret;
+	int externally_control;
+
+	ret = sscanf(buf, "%d", &externally_control);
+	if (ret == 0) {
+		ret = -EINVAL;
+		return ret;
+	}
+
+	if (externally_control) {
+		int chargers_externally_control = 1;
+
+		for (i = 0 ; i < desc->num_charger_regulators ; i++) {
+			if ((&desc->charger_regulators[i] != charger)
+			&& !desc->charger_regulators[i].externally_control) {
+				/*
+				 * At least, one charger is controlled by
+				 * charger-manager
+				 */
+				chargers_externally_control = 0;
+				break;
+			}
+		}
+
+		if (!chargers_externally_control) {
+			if (cm->charger_enabled) {
+				try_charger_enable(charger->cm, false);
+				charger->externally_control
+					= externally_control;
+				try_charger_enable(charger->cm, true);
+			} else
+				charger->externally_control
+					= externally_control;
+
+		} else {
+			dev_warn(cm->dev,
+				"\'%s\' regulator should be controlled "
+				"in charger-manager because charger-manager "
+				"must need at least one charger for charging\n",
+				charger->regulator_name);
+		}
+	} else
+		charger->externally_control = externally_control;
+
+	return count;
+}
+
 static int charger_manager_probe(struct platform_device *pdev)
 {
 	struct charger_desc *desc = dev_get_platdata(&pdev->dev);
 	struct charger_manager *cm;
 	int ret = 0, i = 0;
 	int j = 0;
+	int chargers_externally_control = 1;
 	union power_supply_propval val;
 
 	if (g_desc && !rtc_dev && g_desc->rtc_name) {
@@ -1412,6 +1508,8 @@ static int charger_manager_probe(struct platform_device *pdev)
 	for (i = 0 ; i < desc->num_charger_regulators ; i++) {
 		struct charger_regulator *charger
 					= &desc->charger_regulators[i];
+		char buf[11];
+		char *str;
 
 		charger->consumer = regulator_get(&pdev->dev,
 					charger->regulator_name);
@@ -1421,8 +1519,9 @@ static int charger_manager_probe(struct platform_device *pdev)
 			ret = -EINVAL;
 			goto err_chg_get;
 		}
+		charger->cm = cm;
 
-		for (j = 0 ; j < charger->num_cables ; j++) {
+		for (j = 0; j < charger->num_cables; j++) {
 			struct charger_cable *cable = &charger->cables[j];
 
 			ret = charger_extcon_init(cm, cable);
@@ -1434,6 +1533,71 @@ static int charger_manager_probe(struct platform_device *pdev)
 			cable->charger = charger;
 			cable->cm = cm;
 		}
+
+		/* Create sysfs entry to control charger(regulator) */
+		snprintf(buf, 10, "charger.%d", i);
+		str = kzalloc(sizeof(char) * (strlen(buf) + 1), GFP_KERNEL);
+		if (!str) {
+			for (i--; i >= 0; i--) {
+				charger = &desc->charger_regulators[i];
+				kfree(charger->attr_g.name);
+			}
+			ret = -ENOMEM;
+
+			goto err_extcon;
+		}
+		strcpy(str, buf);
+
+		charger->attrs[0] = &charger->attr_name.attr;
+		charger->attrs[1] = &charger->attr_state.attr;
+		charger->attrs[2] = &charger->attr_externally_control.attr;
+		charger->attrs[3] = NULL;
+		charger->attr_g.name = str;
+		charger->attr_g.attrs = charger->attrs;
+
+		sysfs_attr_init(&charger->attr_name.attr);
+		charger->attr_name.attr.name = "name";
+		charger->attr_name.attr.mode = 0444;
+		charger->attr_name.show = charger_name_show;
+
+		sysfs_attr_init(&charger->attr_state.attr);
+		charger->attr_state.attr.name = "state";
+		charger->attr_state.attr.mode = 0444;
+		charger->attr_state.show = charger_state_show;
+
+		sysfs_attr_init(&charger->attr_externally_control.attr);
+		charger->attr_externally_control.attr.name
+				= "externally_control";
+		charger->attr_externally_control.attr.mode = 0644;
+		charger->attr_externally_control.show
+				= charger_externally_control_show;
+		charger->attr_externally_control.store
+				= charger_externally_control_store;
+
+		if (!desc->charger_regulators[i].externally_control
+				|| !chargers_externally_control) {
+			chargers_externally_control = 0;
+		}
+		dev_info(&pdev->dev, "\'%s\' regulator's externally_control"
+				"is %d\n", charger->regulator_name,
+				charger->externally_control);
+
+		ret = sysfs_create_group(&cm->charger_psy.dev->kobj,
+				&charger->attr_g);
+		if (ret < 0) {
+			dev_info(&pdev->dev, "Cannot create sysfs entry"
+					"of %s regulator\n",
+					charger->regulator_name);
+		}
+	}
+
+	if (chargers_externally_control) {
+		dev_err(&pdev->dev, "Cannot register regulator because "
+				"charger-manager must need at least "
+				"one charger for charging battery\n");
+
+		ret = -EINVAL;
+		goto err_chg_enable;
 	}
 
 	ret = try_charger_enable(cm, true);
@@ -1459,6 +1623,14 @@ static int charger_manager_probe(struct platform_device *pdev)
 	return 0;
 
 err_chg_enable:
+	for (i = 0 ; i < desc->num_charger_regulators ; i++) {
+		struct charger_regulator *charger
+					= &desc->charger_regulators[i];
+		charger = &desc->charger_regulators[i];
+		sysfs_remove_group(&cm->charger_psy.dev->kobj,
+				&charger->attr_g);
+		kfree(charger->attr_g.name);
+	}
 err_extcon:
 	for (i = 0 ; i < desc->num_charger_regulators ; i++) {
 		struct charger_regulator *charger
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index a7b388e..0e86840 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -109,24 +109,43 @@ struct charger_cable {
  * struct charger_regulator
  * @regulator_name: the name of regulator for using charger.
  * @consumer: the regulator consumer for the charger.
+ * @externally_control:
+ *	Set if the charger-manager cannot control charger,
+ *	the charger will be maintained with disabled state.
  * @cables:
  *	the array of charger cables to enable/disable charger
  *	and set current limit according to constratint data of
  *	struct charger_cable if only charger cable included
  *	in the array of charger cables is attached/detached.
  * @num_cables: the number of charger cables.
+ * @attr_g: Attribute group for the charger(regulator)
+ * @attr_name: "name" sysfs entry
+ * @attr_state: "state" sysfs entry
+ * @attr_externally_control: "externally_control" sysfs entry
+ * @attrs: Arrays pointing to attr_name/state/externally_control for attr_g
  */
 struct charger_regulator {
 	/* The name of regulator for charging */
 	const char *regulator_name;
 	struct regulator *consumer;
 
+	/* charger never on when system is on */
+	int externally_control;
+
 	/*
 	 * Store constraint information related to current limit,
 	 * each cable have different condition for charging.
 	 */
 	struct charger_cable *cables;
 	int num_cables;
+
+	struct attribute_group attr_g;
+	struct device_attribute attr_name;
+	struct device_attribute attr_state;
+	struct device_attribute attr_externally_control;
+	struct attribute *attrs[4];
+
+	struct charger_manager *cm;
 };
 
 /**
-- 
1.7.0.4

