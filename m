Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab0EQTkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:40:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36172 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab0EQTkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:40:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iq5oxdjqDElbpLyuMMbmrVxpW3YYr+2rtDqe27pScY4/hUsiJG2GroZ2aN/THiIDNB
         0U3kK9HxUZVWE3AVTxSb1TMiAmSqGw2Wg687KTw/W858aMeC+SR+6+0CQXIBpClbAIZG
         2vPOdp2xw+93NWZnsOOzG4QyefoT6+CtyfTSY=
Date: Mon, 17 May 2010 23:40:16 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Matt Reimer <mreimer@vpop.net>, Evgeniy Polyakov <zbr@ioremap.net>,
       Tejun Heo <tj@kernel.org>
Subject: [PATCH] power_supply: Use attribute groups
Message-ID: <20100517194016.GA12147@oksana.dev.rtsoft.ru>
References: <20100511174708.GA26777@oksana.dev.rtsoft.ru>
 <20100511175812.GH30801@buzzloop.caiaq.de>
 <20100511182347.GA31831@oksana.dev.rtsoft.ru>
 <20100511222825.GJ30801@buzzloop.caiaq.de>
 <20100512181546.GA4804@oksana.dev.rtsoft.ru>
 <20100512183806.GA28658@suse.de>
 <20100512190814.GA9674@oksana.dev.rtsoft.ru>
 <AANLkTimQq30DklQUDBokPXsLiXKsuiaCUFg_5ddkJbXa@mail.gmail.com>
 <20100512193050.GA14221@oksana.dev.rtsoft.ru>
 <20100513093304.GE30801@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100513093304.GE30801@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a race between power supply device and initial
attributes creation, plus makes it possible to implement
writable properties.

Suggested-by: Greg KH <gregkh@suse.de>
Suggested-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---

On Thu, May 13, 2010 at 11:33:04AM +0200, Daniel Mack wrote:
[...]
> > > > In short: we can't use attr groups since the attributes creation
> > > > is conditional. And we especially don't want to use the attr groups
> > > > for attrs with different modes. But it's not a problem, because...
> > > 
> > > Groups have a filter callback for every member, to decide if the
> > > attribute should be created or not.
> > 
> > Thanks Kay. It seems the callback was added just a few months
> > after the discussion above. ;-)
[...]
> > Daniel, I think that today we can just use the attribute group
> > mechanism, it has all needed. Do you want me to prepare a patch
> > to convert existing attributes, or do you to try it yourself?
> 
> Would be good if you did that, just to see how this is interface meant
> to be used exactly. I'll adopt my patches accordingly then.

OK. It took me quite some time as my hx4700 refused to boot.
I still don't know why it doesn't boot, but I implemented
test_power driver and was able to test the draft.

Daniel, it works for me, and implementing writable properties
should be straightforward now (see is_visible callback).

Thanks,

 drivers/power/power_supply.h       |    7 +--
 drivers/power/power_supply_core.c  |   48 +++++++++++-----
 drivers/power/power_supply_sysfs.c |  114 ++++++++++++------------------------
 include/linux/power_supply.h       |    1 +
 4 files changed, 75 insertions(+), 95 deletions(-)

diff --git a/drivers/power/power_supply.h b/drivers/power/power_supply.h
index f38ba48..018de2b 100644
--- a/drivers/power/power_supply.h
+++ b/drivers/power/power_supply.h
@@ -12,15 +12,12 @@
 
 #ifdef CONFIG_SYSFS
 
-extern int power_supply_create_attrs(struct power_supply *psy);
-extern void power_supply_remove_attrs(struct power_supply *psy);
+extern void power_supply_init_attrs(struct device_type *dev_type);
 extern int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env);
 
 #else
 
-static inline int power_supply_create_attrs(struct power_supply *psy)
-{ return 0; }
-static inline void power_supply_remove_attrs(struct power_supply *psy) {}
+static inline void power_supply_init_attrs(struct device_type *dev_type) {}
 #define power_supply_uevent NULL
 
 #endif /* CONFIG_SYSFS */
diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index cce75b4..91606bb 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/power_supply.h>
@@ -22,6 +23,8 @@
 struct class *power_supply_class;
 EXPORT_SYMBOL_GPL(power_supply_class);
 
+static struct device_type power_supply_dev_type;
+
 static int __power_supply_changed_work(struct device *dev, void *data)
 {
 	struct power_supply *psy = (struct power_supply *)data;
@@ -144,22 +147,39 @@ struct power_supply *power_supply_get_by_name(char *name)
 }
 EXPORT_SYMBOL_GPL(power_supply_get_by_name);
 
+static void power_supply_dev_release(struct device *dev)
+{
+	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
+	kfree(dev);
+}
+
 int power_supply_register(struct device *parent, struct power_supply *psy)
 {
-	int rc = 0;
+	struct device *dev;
+	int rc;
 
-	psy->dev = device_create(power_supply_class, parent, 0, psy,
-				 "%s", psy->name);
-	if (IS_ERR(psy->dev)) {
-		rc = PTR_ERR(psy->dev);
-		goto dev_create_failed;
-	}
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
 
-	INIT_WORK(&psy->changed_work, power_supply_changed_work);
+	device_initialize(dev);
 
-	rc = power_supply_create_attrs(psy);
+	dev->class = power_supply_class;
+	dev->type = &power_supply_dev_type;
+	dev->parent = parent;
+	dev->release = power_supply_dev_release;
+	dev_set_drvdata(dev, psy);
+	psy->dev = dev;
+
+	rc = kobject_set_name(&dev->kobj, "%s", psy->name);
+	if (rc)
+		goto kobject_set_name_failed;
+
+	rc = device_add(dev);
 	if (rc)
-		goto create_attrs_failed;
+		goto device_add_failed;
+
+	INIT_WORK(&psy->changed_work, power_supply_changed_work);
 
 	rc = power_supply_create_triggers(psy);
 	if (rc)
@@ -170,10 +190,10 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 	goto success;
 
 create_triggers_failed:
-	power_supply_remove_attrs(psy);
-create_attrs_failed:
 	device_unregister(psy->dev);
-dev_create_failed:
+kobject_set_name_failed:
+device_add_failed:
+	kfree(dev);
 success:
 	return rc;
 }
@@ -183,7 +203,6 @@ void power_supply_unregister(struct power_supply *psy)
 {
 	flush_scheduled_work();
 	power_supply_remove_triggers(psy);
-	power_supply_remove_attrs(psy);
 	device_unregister(psy->dev);
 }
 EXPORT_SYMBOL_GPL(power_supply_unregister);
@@ -196,6 +215,7 @@ static int __init power_supply_class_init(void)
 		return PTR_ERR(power_supply_class);
 
 	power_supply_class->dev_uevent = power_supply_uevent;
+	power_supply_init_attrs(&power_supply_dev_type);
 
 	return 0;
 }
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 5b6e352..f95d934 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -41,6 +41,9 @@ static struct device_attribute power_supply_attrs[];
 static ssize_t power_supply_show_property(struct device *dev,
 					  struct device_attribute *attr,
 					  char *buf) {
+	static char *type_text[] = {
+		"Battery", "UPS", "Mains", "USB"
+	};
 	static char *status_text[] = {
 		"Unknown", "Charging", "Discharging", "Not charging", "Full"
 	};
@@ -58,12 +61,15 @@ static ssize_t power_supply_show_property(struct device *dev,
 	static char *capacity_level_text[] = {
 		"Unknown", "Critical", "Low", "Normal", "High", "Full"
 	};
-	ssize_t ret;
+	ssize_t ret = 0;
 	struct power_supply *psy = dev_get_drvdata(dev);
 	const ptrdiff_t off = attr - power_supply_attrs;
 	union power_supply_propval value;
 
-	ret = psy->get_property(psy, off, &value);
+	if (off == POWER_SUPPLY_PROP_TYPE)
+		value.intval = psy->type;
+	else
+		ret = psy->get_property(psy, off, &value);
 
 	if (ret < 0) {
 		if (ret == -ENODATA)
@@ -85,10 +91,13 @@ static ssize_t power_supply_show_property(struct device *dev,
 		return sprintf(buf, "%s\n", technology_text[value.intval]);
 	else if (off == POWER_SUPPLY_PROP_CAPACITY_LEVEL)
 		return sprintf(buf, "%s\n", capacity_level_text[value.intval]);
+	else if (off == POWER_SUPPLY_PROP_TYPE)
+		return sprintf(buf, "%s\n", type_text[value.intval]);
 	else if (off >= POWER_SUPPLY_PROP_MODEL_NAME)
 		return sprintf(buf, "%s\n", value.strval);
 
 	return sprintf(buf, "%d\n", value.intval);
+return 0;
 }
 
 /* Must be in the same order as POWER_SUPPLY_PROP_* */
@@ -132,67 +141,50 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(time_to_empty_avg),
 	POWER_SUPPLY_ATTR(time_to_full_now),
 	POWER_SUPPLY_ATTR(time_to_full_avg),
+	POWER_SUPPLY_ATTR(type),
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_ATTR(model_name),
 	POWER_SUPPLY_ATTR(manufacturer),
 	POWER_SUPPLY_ATTR(serial_number),
 };
 
-static ssize_t power_supply_show_static_attrs(struct device *dev,
-					      struct device_attribute *attr,
-					      char *buf) {
-	static char *type_text[] = { "Battery", "UPS", "Mains", "USB" };
-	struct power_supply *psy = dev_get_drvdata(dev);
-
-	return sprintf(buf, "%s\n", type_text[psy->type]);
-}
-
-static struct device_attribute power_supply_static_attrs[] = {
-	__ATTR(type, 0444, power_supply_show_static_attrs, NULL),
-};
+static struct attribute *
+__power_supply_attrs[ARRAY_SIZE(power_supply_attrs) + 1];
 
-int power_supply_create_attrs(struct power_supply *psy)
+static mode_t power_supply_attr_is_visible(struct kobject *kobj,
+					   struct attribute *attr,
+					   int attrno)
 {
-	int rc = 0;
-	int i, j;
-
-	for (i = 0; i < ARRAY_SIZE(power_supply_static_attrs); i++) {
-		rc = device_create_file(psy->dev,
-			    &power_supply_static_attrs[i]);
-		if (rc)
-			goto statics_failed;
-	}
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct power_supply *psy = dev_get_drvdata(dev);
+	int i;
 
-	for (j = 0; j < psy->num_properties; j++) {
-		rc = device_create_file(psy->dev,
-			    &power_supply_attrs[psy->properties[j]]);
-		if (rc)
-			goto dynamics_failed;
+	for (i = 0; i < psy->num_properties; i++) {
+		if (psy->properties[i] == attrno)
+			return 0444;
 	}
 
-	goto succeed;
-
-dynamics_failed:
-	while (j--)
-		device_remove_file(psy->dev,
-			   &power_supply_attrs[psy->properties[j]]);
-statics_failed:
-	while (i--)
-		device_remove_file(psy->dev, &power_supply_static_attrs[i]);
-succeed:
-	return rc;
+	return 0;
 }
 
-void power_supply_remove_attrs(struct power_supply *psy)
+static struct attribute_group power_supply_attr_group = {
+	.attrs = __power_supply_attrs,
+	.is_visible = power_supply_attr_is_visible,
+};
+
+const struct attribute_group *power_supply_attr_groups[] = {
+	&power_supply_attr_group,
+	NULL,
+};
+
+void power_supply_init_attrs(struct device_type *dev_type)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(power_supply_static_attrs); i++)
-		device_remove_file(psy->dev, &power_supply_static_attrs[i]);
+	dev_type->groups = power_supply_attr_groups;
 
-	for (i = 0; i < psy->num_properties; i++)
-		device_remove_file(psy->dev,
-			    &power_supply_attrs[psy->properties[i]]);
+	for (i = 0; i < ARRAY_SIZE(power_supply_attrs); i++)
+		__power_supply_attrs[i] = &power_supply_attrs[i].attr;
 }
 
 static char *kstruprdup(const char *str, gfp_t gfp)
@@ -236,36 +228,6 @@ int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
 	if (!prop_buf)
 		return -ENOMEM;
 
-	for (j = 0; j < ARRAY_SIZE(power_supply_static_attrs); j++) {
-		struct device_attribute *attr;
-		char *line;
-
-		attr = &power_supply_static_attrs[j];
-
-		ret = power_supply_show_static_attrs(dev, attr, prop_buf);
-		if (ret < 0)
-			goto out;
-
-		line = strchr(prop_buf, '\n');
-		if (line)
-			*line = 0;
-
-		attrname = kstruprdup(attr->attr.name, GFP_KERNEL);
-		if (!attrname) {
-			ret = -ENOMEM;
-			goto out;
-		}
-
-		dev_dbg(dev, "Static prop %s=%s\n", attrname, prop_buf);
-
-		ret = add_uevent_var(env, "POWER_SUPPLY_%s=%s", attrname, prop_buf);
-		kfree(attrname);
-		if (ret)
-			goto out;
-	}
-
-	dev_dbg(dev, "%zd dynamic props\n", psy->num_properties);
-
 	for (j = 0; j < psy->num_properties; j++) {
 		struct device_attribute *attr;
 		char *line;
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index ebd2b8f..c5f73a3 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -114,6 +114,7 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
 	POWER_SUPPLY_PROP_TIME_TO_FULL_NOW,
 	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
+	POWER_SUPPLY_PROP_TYPE, /* use power_supply.type instead */
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,
-- 
1.7.0.1

