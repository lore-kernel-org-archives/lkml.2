Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965238Ab2KVTyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:54:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28359 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab2KVTyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:54:44 -0500
X-AuditID: cbfee61b-b7f616d00000319b-d2-50add7e8dad8
From: y@samsung.com
To: anton.vorontsov@linaro.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 3/3] charger-manager: Split _probe funtion for code clean
Date: Thu, 22 Nov 2012 16:44:32 +0900
Message-id: <1353570272-19024-1-git-send-email-y@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <y@samsung.com>
References: <y@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJMWRmVeSWpSXmKPExsVy+t9jAd0X19cGGMw4KWhxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyps2fwl7QHV1xer9LA2ObVxcjJ4eEgInEh+uL2SFsMYkL99az
	dTFycQgJLGKUmHnuI5SzlEnifMNSli5GDg42AWGJqQe0QBpEBOQkXq/9ywRiMwvUSuy71sQK
	YgsLeEq0zN3FCFLOIqAqMXWuAYjJK2Ar8eqQNsQqBYnWZYfA1nIKyEjMmb0KzBYSkJa4393D
	MoGRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2MYF8/k97BuKrB4hCjAAejEg9vhsHa
	ACHWxLLiytxDjBIczEoivIsKgEK8KYmVValF+fFFpTmpxYcYpTlYlMR5mz1SAoQE0hNLUrNT
	UwtSi2CyTBycUg2MEw/pbOI6O32azMQTcpYzHsR/5co6XFyr2/vhXbjMBv+jKyf9+81wUopb
	sHei3q6NX/kO/xdcp3uI69qzu7marho3NR8ylW/d+6q4vUOJ+1SUx5rmPO+W4k7j7xohQp2G
	7gpv6hYqHDug5G3H/OvBJa7Xv9ceU3yw0CW+3/LvzCitla02PlvvKbEUZyQaajEXFScCAKmx
	3t7xAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chanwoo Choi <cw00.choi@samsung.com>

This patch split _probe function for readability because
_probe function is longer than 400 line.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/charger-manager.c |  279 +++++++++++++++++++++++----------------
 1 files changed, 168 insertions(+), 111 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 17130c7..cc000c4 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1217,6 +1217,55 @@ static int charger_extcon_init(struct charger_manager *cm,
 	return ret;
 }
 
+/**
+ * charger_manager_register_extcon - Register extcon device to recevie state
+ *				     of charger cable.
+ * @cm: the Charger Manager representing the battery.
+ *
+ * This function support EXTCON(External Connector) subsystem to detect the
+ * state of charger cables for enabling or disabling charger(regulator) and
+ * select the charger cable for charging among a number of external cable
+ * according to policy of H/W board.
+ */
+static int charger_manager_register_extcon(struct charger_manager *cm)
+{
+	struct charger_desc *desc = cm->desc;
+	struct charger_regulator *charger;
+	int ret = 0;
+	int i;
+	int j;
+
+	for (i = 0; i < desc->num_charger_regulators; i++) {
+		charger = &desc->charger_regulators[i];
+
+		charger->consumer = regulator_get(cm->dev,
+					charger->regulator_name);
+		if (charger->consumer == NULL) {
+			dev_err(cm->dev, "Cannot find charger(%s)n",
+					charger->regulator_name);
+			ret = -EINVAL;
+			goto err;
+		}
+		charger->cm = cm;
+
+		for (j = 0; j < charger->num_cables; j++) {
+			struct charger_cable *cable = &charger->cables[j];
+
+			ret = charger_extcon_init(cm, cable);
+			if (ret < 0) {
+				dev_err(cm->dev, "Cannot initialize charger(%s)n",
+						charger->regulator_name);
+				goto err;
+			}
+			cable->charger = charger;
+			cable->cm = cm;
+		}
+	}
+
+err:
+	return ret;
+}
+
 /* help function of sysfs node to control charger(regulator) */
 static ssize_t charger_name_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -1276,7 +1325,7 @@ static ssize_t charger_externally_control_store(struct device *dev,
 
 	for (i = 0; i < desc->num_charger_regulators; i++) {
 		if (&desc->charger_regulators[i] != charger &&
-			      !desc->charger_regulators[i].externally_control) {
+			!desc->charger_regulators[i].externally_control) {
 			/*
 			 * At least, one charger is controlled by
 			 * charger-manager
@@ -1305,13 +1354,107 @@ static ssize_t charger_externally_control_store(struct device *dev,
 	return count;
 }
 
+/**
+ * charger_manager_register_sysfs - Register sysfs entry for each charger
+ * @cm: the Charger Manager representing the battery.
+ *
+ * This function add sysfs entry for charger(regulator) to control charger from
+ * user-space. If some development board use one more chargers for charging
+ * but only need one charger on specific case which is dependent on user
+ * scenario or hardware restrictions, the user enter 1 or 0(zero) to '/sys/
+ * class/power_supply/battery/charger.[index]/externally_control'. For example,
+ * if user enter 1 to 'sys/class/power_supply/battery/charger.[index]/
+ * externally_control, this charger isn't controlled from charger-manager and
+ * always stay off state of regulator.
+ */
+static int charger_manager_register_sysfs(struct charger_manager *cm)
+{
+	struct charger_desc *desc = cm->desc;
+	struct charger_regulator *charger;
+	int chargers_externally_control = 1;
+	char buf[11];
+	char *str;
+	int ret = 0;
+	int i;
+
+	/* Create sysfs entry to control charger(regulator) */
+	for (i = 0; i < desc->num_charger_regulators; i++) {
+		charger = &desc->charger_regulators[i];
+
+		snprintf(buf, 10, "charger.%d", i);
+		str = kzalloc(sizeof(char) * (strlen(buf) + 1), GFP_KERNEL);
+		if (!str) {
+			dev_err(cm->dev, "Cannot allocate memory: %s\n",
+					charger->regulator_name);
+			ret = -ENOMEM;
+			goto err;
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
+		if (!desc->charger_regulators[i].externally_control ||
+				!chargers_externally_control)
+			chargers_externally_control = 0;
+
+		dev_info(cm->dev, "'%s' regulator's externally_control"
+				"is %d\n", charger->regulator_name,
+				charger->externally_control);
+
+		ret = sysfs_create_group(&cm->charger_psy.dev->kobj,
+					&charger->attr_g);
+		if (ret < 0) {
+			dev_err(cm->dev, "Cannot create sysfs entry"
+					"of %s regulator\n",
+					charger->regulator_name);
+			ret = -EINVAL;
+			goto err;
+		}
+	}
+
+	if (chargers_externally_control) {
+		dev_err(cm->dev, "Cannot register regulator because "
+				"charger-manager must need at least "
+				"one charger for charging battery\n");
+
+		ret = -EINVAL;
+		goto err;
+	}
+
+err:
+	return ret;
+}
+
 static int charger_manager_probe(struct platform_device *pdev)
 {
 	struct charger_desc *desc = dev_get_platdata(&pdev->dev);
 	struct charger_manager *cm;
 	int ret = 0, i = 0;
 	int j = 0;
-	int chargers_externally_control = 1;
 	union power_supply_propval val;
 
 	if (g_desc && !rtc_dev && g_desc->rtc_name) {
@@ -1442,11 +1585,10 @@ static int charger_manager_probe(struct platform_device *pdev)
 
 	memcpy(&cm->charger_psy, &psy_default, sizeof(psy_default));
 
-	if (!desc->psy_name) {
+	if (!desc->psy_name)
 		strncpy(cm->psy_name_buf, psy_default.name, PSY_NAME_MAX);
-	} else {
+	else
 		strncpy(cm->psy_name_buf, desc->psy_name, PSY_NAME_MAX);
-	}
 	cm->charger_psy.name = cm->psy_name_buf;
 
 	/* Allocate for psy properties because they may vary */
@@ -1498,105 +1640,19 @@ static int charger_manager_probe(struct platform_device *pdev)
 		goto err_register;
 	}
 
-	for (i = 0 ; i < desc->num_charger_regulators ; i++) {
-		struct charger_regulator *charger
-					= &desc->charger_regulators[i];
-		char buf[11];
-		char *str;
-
-		charger->consumer = regulator_get(&pdev->dev,
-					charger->regulator_name);
-		if (charger->consumer == NULL) {
-			dev_err(&pdev->dev, "Cannot find charger(%s)n",
-						charger->regulator_name);
-			ret = -EINVAL;
-			goto err_chg_get;
-		}
-		charger->cm = cm;
-
-		for (j = 0 ; j < charger->num_cables ; j++) {
-			struct charger_cable *cable = &charger->cables[j];
-
-			ret = charger_extcon_init(cm, cable);
-			if (ret < 0) {
-				dev_err(&pdev->dev, "Cannot find charger(%s)n",
-						charger->regulator_name);
-				goto err_extcon;
-			}
-			cable->charger = charger;
-			cable->cm = cm;
-		}
-
-		/* Create sysfs entry to control charger(regulator) */
-		snprintf(buf, 10, "charger.%d", i);
-		str = kzalloc(sizeof(char) * (strlen(buf) + 1), GFP_KERNEL);
-		if (!str) {
-			for (i--; i >= 0; i--) {
-				charger = &desc->charger_regulators[i];
-				kfree(charger->attr_g.name);
-			}
-			ret = -ENOMEM;
-
-			goto err_extcon;
-		}
-		strcpy(str, buf);
-
-		charger->attrs[0] = &charger->attr_name.attr;
-		charger->attrs[1] = &charger->attr_state.attr;
-		charger->attrs[2] = &charger->attr_externally_control.attr;
-		charger->attrs[3] = NULL;
-		charger->attr_g.name = str;
-		charger->attr_g.attrs = charger->attrs;
-
-		sysfs_attr_init(&charger->attr_name.attr);
-		charger->attr_name.attr.name = "name";
-		charger->attr_name.attr.mode = 0444;
-		charger->attr_name.show = charger_name_show;
-
-		sysfs_attr_init(&charger->attr_state.attr);
-		charger->attr_state.attr.name = "state";
-		charger->attr_state.attr.mode = 0444;
-		charger->attr_state.show = charger_state_show;
-
-		sysfs_attr_init(&charger->attr_externally_control.attr);
-		charger->attr_externally_control.attr.name
-				= "externally_control";
-		charger->attr_externally_control.attr.mode = 0644;
-		charger->attr_externally_control.show
-				= charger_externally_control_show;
-		charger->attr_externally_control.store
-				= charger_externally_control_store;
-
-		if (!desc->charger_regulators[i].externally_control ||
-				!chargers_externally_control) {
-			chargers_externally_control = 0;
-		}
-		dev_info(&pdev->dev, "'%s' regulator's externally_control"
-				"is %d\n", charger->regulator_name,
-				charger->externally_control);
-
-		ret = sysfs_create_group(&cm->charger_psy.dev->kobj,
-				&charger->attr_g);
-		if (ret < 0) {
-			dev_info(&pdev->dev, "Cannot create sysfs entry"
-					"of %s regulator\n",
-					charger->regulator_name);
-		}
-	}
-
-	if (chargers_externally_control) {
-		dev_err(&pdev->dev, "Cannot register regulator because "
-				"charger-manager must need at least "
-				"one charger for charging battery\n");
-
-		ret = -EINVAL;
-		goto err_chg_enable;
+	/* Register extcon device for charger cable */
+	ret = charger_manager_register_extcon(cm);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Cannot initialize extcon device\n");
+		goto err_reg_extcon;
 	}
 
-	ret = try_charger_enable(cm, true);
-	if (ret) {
-		dev_err(&pdev->dev, "Cannot enable charger regulators\n");
-		goto err_chg_enable;
+	/* Register sysfs entry for charger(regulator) */
+	ret = charger_manager_register_sysfs(cm);
+	if (ret < 0) {
+		dev_err(&pdev->dev,
+			"Cannot initialize sysfs entry of regulator\n");
+		goto err_reg_sysfs;
 	}
 
 	/* Add to the list */
@@ -1615,27 +1671,28 @@ static int charger_manager_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_chg_enable:
+err_reg_sysfs:
 	for (i = 0; i < desc->num_charger_regulators; i++) {
 		struct charger_regulator *charger;
 
 		charger = &desc->charger_regulators[i];
 		sysfs_remove_group(&cm->charger_psy.dev->kobj,
 				&charger->attr_g);
+
 		kfree(charger->attr_g.name);
 	}
-err_extcon:
-	for (i = 0 ; i < desc->num_charger_regulators ; i++) {
-		struct charger_regulator *charger
-				= &desc->charger_regulators[i];
-		for (j = 0 ; j < charger->num_cables ; j++) {
+err_reg_extcon:
+	for (i = 0; i < desc->num_charger_regulators; i++) {
+		struct charger_regulator *charger;
+
+		charger = &desc->charger_regulators[i];
+		for (j = 0; j < charger->num_cables; j++) {
 			struct charger_cable *cable = &charger->cables[j];
 			extcon_unregister_interest(&cable->extcon_dev);
 		}
-	}
-err_chg_get:
-	for (i = 0 ; i < desc->num_charger_regulators ; i++)
+
 		regulator_put(desc->charger_regulators[i].consumer);
+	}
 
 	power_supply_unregister(&cm->charger_psy);
 err_register:
-- 
1.7.0.4

