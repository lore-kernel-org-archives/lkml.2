Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab2FYOB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 10:01:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:44423 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873Ab2FYOB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 10:01:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="157912084"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH] power_supply: Added support for power supply attribute sources
Date: Mon, 25 Jun 2012 18:07:22 +0530
Message-Id: <1340627842-31908-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some platforms one driver(or HW chip) may not be able to provide all
the necessary attributes of the power supply connected to the platform or
may provide very limited info which can be used by core/primary drivers.

For example a temperature sensor chip placed near the battery can be used
to report battery ambient temperature but it does not makes sense to register
sensor driver with power supply class. Or even a ADC driver or platform
driver may report power supply properties like voltage/current or charging
status but registering all those driver with power supply class is not a
practical or ideal approach.

This patch adds the generic support to register the drivers as power
supply attribute(properties) sources and adds an interface to read
these attributes from power supply class drivers.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 Documentation/power/power_supply_class.txt |   30 +++++++++++
 drivers/power/power_supply_core.c          |   78 ++++++++++++++++++++++++++++
 include/linux/power_supply.h               |   28 ++++++++++
 3 files changed, 136 insertions(+), 0 deletions(-)

diff --git a/Documentation/power/power_supply_class.txt b/Documentation/power/power_supply_class.txt
index c0f62ae..f8ceb45 100644
--- a/Documentation/power/power_supply_class.txt
+++ b/Documentation/power/power_supply_class.txt
@@ -130,6 +130,36 @@ while battery powers a load)
 TIME_TO_FULL - seconds left for battery to be considered full (i.e.
 while battery is charging)
 
+Power supply attribute sources
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+On some platforms one driver(or HW chip) may not be able to provide all
+the necessary attributes of the power supply connected to the platform.
+
+For example a temperature sensor chip placed near the battery can be used
+to report battery ambient temperature but it does not makes sense to register
+sensor driver with power supply class. Or even a ADC driver or platform
+driver may report power supply properties like voltage/current or charging
+status but registering all those driver with power supply class is not a
+practical or ideal approach.
+
+Power supply subsystem provides an interface to register and report about
+these power supply attributes to the primary driver which is registered
+with power supply class.
+
+Power supply attribute source driver can use the following functions to
+register/unregister as attributes source.
+
+int power_supply_attributes_register(struct device *parent,
+				struct power_supply_attr_source *psy_attr);
+
+void power_supply_attributes_unregister(
+			struct power_supply_attr_source *psy_attr);
+
+Power supply class driver(consumer driver) which needs to get
+power supply attributes can call the following function.
+
+int power_supply_get_external_attr(
+				struct power_supply_attr_query *query);
 
 Battery <-> external power supply interaction
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index ff990d2..25c47a3 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/list.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/power_supply.h>
@@ -26,6 +27,8 @@ EXPORT_SYMBOL_GPL(power_supply_class);
 
 static struct device_type power_supply_dev_type;
 
+static LIST_HEAD(list_head_source_attr);
+
 static int __power_supply_changed_work(struct device *dev, void *data)
 {
 	struct power_supply *psy = (struct power_supply *)data;
@@ -164,6 +167,34 @@ int power_supply_powers(struct power_supply *psy, struct device *dev)
 }
 EXPORT_SYMBOL_GPL(power_supply_powers);
 
+int power_supply_get_external_attr(struct power_supply_attr_query *query)
+{
+	struct list_head *list;
+	struct power_supply_attr_source *psy_attr;
+	int ret = -ENODEV;
+
+	if (!query || list_empty(&list_head_source_attr))
+		return -EINVAL;
+
+	list_for_each(list, &list_head_source_attr) {
+		psy_attr = list_entry(list,
+			struct power_supply_attr_source, attr_pool);
+
+		if (psy_attr->type != query->type)
+			continue;
+
+		ret = psy_attr->get_property(psy_attr,
+				query->property, &query->res);
+		if (ret < 0)
+			continue;
+		else
+			break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(power_supply_get_external_attr);
+
 static void power_supply_dev_release(struct device *dev)
 {
 	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
@@ -289,6 +320,53 @@ void power_supply_unregister(struct power_supply *psy)
 }
 EXPORT_SYMBOL_GPL(power_supply_unregister);
 
+int power_supply_attributes_register(struct device *parent,
+				struct power_supply_attr_source *psy_attr)
+{
+	struct device *dev;
+	int rc;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	device_initialize(dev);
+
+	dev->parent = parent;
+	dev->release = power_supply_dev_release;
+	dev_set_drvdata(dev, psy_attr);
+	psy_attr->dev = dev;
+
+	rc = kobject_set_name(&dev->kobj, "%s", psy_attr->name);
+	if (rc)
+		goto kobject_set_name_failed;
+
+	rc = device_add(dev);
+	if (rc)
+		goto device_add_failed;
+
+	INIT_LIST_HEAD(&psy_attr->attr_pool);
+	/* add to the list head */
+	list_add(&psy_attr->attr_pool, &list_head_source_attr);
+
+	goto success;
+
+kobject_set_name_failed:
+device_add_failed:
+	put_device(dev);
+success:
+	return rc;
+}
+EXPORT_SYMBOL_GPL(power_supply_attributes_register);
+
+void power_supply_attributes_unregister(struct power_supply_attr_source
+								*psy_attr)
+{
+	list_del(&psy_attr->attr_pool);
+	device_unregister(psy_attr->dev);
+}
+EXPORT_SYMBOL_GPL(power_supply_attributes_unregister);
+
 static int __init power_supply_class_init(void)
 {
 	power_supply_class = class_create(THIS_MODULE, "power_supply");
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 53f177d..af296c3 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -193,6 +193,25 @@ struct power_supply {
 #endif
 };
 
+struct power_supply_attr_query {
+	enum power_supply_property property;
+	enum power_supply_type type;
+	/* variable to store result */
+	union power_supply_propval res;
+};
+
+struct power_supply_attr_source {
+	const char *name;
+	enum power_supply_type type;
+	int (*get_property)(struct power_supply_attr_source *psy_attr,
+			    enum power_supply_property psp,
+			    union power_supply_propval *val);
+
+	/* private */
+	struct device *dev;
+	struct list_head attr_pool;
+};
+
 /*
  * This is recommended structure to specify static power supply parameters.
  * Generic one, parametrizable for different power supplies. Power supply
@@ -216,6 +235,8 @@ extern struct power_supply *power_supply_get_by_name(char *name);
 extern void power_supply_changed(struct power_supply *psy);
 extern int power_supply_am_i_supplied(struct power_supply *psy);
 extern int power_supply_set_battery_charged(struct power_supply *psy);
+extern int power_supply_get_external_attr(
+				struct power_supply_attr_query *query);
 
 #ifdef CONFIG_POWER_SUPPLY
 extern int power_supply_is_system_supplied(void);
@@ -226,6 +247,13 @@ static inline int power_supply_is_system_supplied(void) { return -ENOSYS; }
 extern int power_supply_register(struct device *parent,
 				 struct power_supply *psy);
 extern void power_supply_unregister(struct power_supply *psy);
+
+extern int power_supply_attributes_register(struct device *parent,
+				struct power_supply_attr_source *psy_attr);
+
+extern void power_supply_attributes_unregister(
+			struct power_supply_attr_source *psy_attr);
+
 extern int power_supply_powers(struct power_supply *psy, struct device *dev);
 
 /* For APM emulation, think legacy userspace. */
-- 
1.7.0.4

