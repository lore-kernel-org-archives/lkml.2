Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab2HUIGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:06:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33826 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab2HUIGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:06:39 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-9a-5033418a97cb
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: cbouatmailru@gmail.com, jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 3/5] charger-manager: Add support sysfs entry for charger
Date: Tue, 21 Aug 2012 17:06:49 +0900
Message-id: <1345536409-25880-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jAd0uR+MAg/tHtC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG5qbogvaQigsnprM3MN516WLk5JAQMJH4uf8ZM4QtJnHh3nq2
	LkYuDiGBRYwS1w72M0M4S5kkXt+dyQpSxSagJbH/xQ02EFtEQE7i9dq/TCBFzAKnGCUeXTwB
	NkpYwFNi/pEDYDaLgKrE23d/2UFsXgFXiV0zOlgh1ilItC47xD6BkXsBI8MqRtHUguSC4qT0
	XEO94sTc4tK8dL3k/NxNjGAfPpPawbiyweIQowAHoxIP749FRgFCrIllxZW5hxglOJiVRHir
	9Y0DhHhTEiurUovy44tKc1KLDzFKc7AoifPy9xkGCAmkJ5akZqemFqQWwWSZODilGhgTPkqq
	Nsal39kVfVnN5GuOkadwkg1HLpuGcKaL3uUXdc1VFyOlIlKWWmfo3tCV2LIleoflSsd6g21d
	Gpu3yH1dU/PKsO+MUf+Plg+Sj8y5e5z/PC4qnzk3fYPZGTf/n0r8z2e/VPmb/nLFy7jYgDYv
	1R276396Giw1EH8310pNQfXBxiC340osxRmJhlrMRcWJAHgkOIndAQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support sysfs entry for each charger(regulator).
Charger-manager use one or more chargers for charging battery but
some charger isn't necessary on specific scenario. So, if some charger
isn't needed, can disable specific charger through 'externally_control'
entry while system is on state and confirm the information(name, state)
of charger.

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
 drivers/power/charger-manager.c       |  172 +++++++++++++++++++++++++++++++++
 include/linux/power/charger-manager.h |   19 ++++
 2 files changed, 191 insertions(+), 0 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index bee010e..33cc3f6 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -22,6 +22,7 @@
 #include <linux/platform_device.h>
 #include <linux/power/charger-manager.h>
 #include <linux/regulator/consumer.h>
+#include <linux/sysfs.h>
 
 static const char * const default_event_names[] = {
 	[CM_EVENT_UNKNOWN] = "Unknown",
@@ -272,6 +273,9 @@ static int try_charger_enable(struct charger_manager *cm, bool enable)
 		if (cm->emergency_stop)
 			return -EAGAIN;
 		for (i = 0 ; i < desc->num_charger_regulators ; i++) {
+			if (desc->charger_regulators[i].externally_control)
+				continue;
+
 			err = regulator_enable(
 				desc->charger_regulators[i].consumer);
 			if (err < 0) {
@@ -282,6 +286,9 @@ static int try_charger_enable(struct charger_manager *cm, bool enable)
 		}
 	} else {
 		for (i = 0 ; i < desc->num_charger_regulators ; i++) {
+			if (desc->charger_regulators[i].externally_control)
+				continue;
+
 			err = regulator_disable(
 				desc->charger_regulators[i].consumer);
 			if (err < 0) {
@@ -1088,12 +1095,101 @@ static int charger_extcon_init(struct charger_manager *cm,
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
@@ -1265,6 +1361,8 @@ static int charger_manager_probe(struct platform_device *pdev)
 	for (i = 0 ; i < desc->num_charger_regulators ; i++) {
 		struct charger_regulator *charger
 					= &desc->charger_regulators[i];
+		char buf[11];
+		char *str;
 
 		charger->consumer = regulator_get(&pdev->dev,
 					charger->regulator_name);
@@ -1274,6 +1372,7 @@ static int charger_manager_probe(struct platform_device *pdev)
 			ret = -EINVAL;
 			goto err_chg_get;
 		}
+		charger->cm = cm;
 
 		for (j = 0 ; j < charger->num_cables ; j++) {
 			struct charger_cable *cable = &charger->cables[j];
@@ -1287,6 +1386,71 @@ static int charger_manager_probe(struct platform_device *pdev)
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
+		sysfs_attr_init(&cable->attr_name.attr);
+		charger->attr_name.attr.name = "name";
+		charger->attr_name.attr.mode = 0444;
+		charger->attr_name.show = charger_name_show;
+
+		sysfs_attr_init(&cable->attr_state.attr);
+		charger->attr_state.attr.name = "state";
+		charger->attr_state.attr.mode = 0444;
+		charger->attr_state.show = charger_state_show;
+
+		sysfs_attr_init(&cable->attr_externally_control.attr);
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
@@ -1312,6 +1476,14 @@ static int charger_manager_probe(struct platform_device *pdev)
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
index 7d7b90f..afeff17 100644
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

