Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab0EGRqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:46:11 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:42672 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab0EGRqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:46:09 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>,
       Andres Salomon <dilinger@collabora.co.uk>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Matt Reimer <mreimer@vpop.net>, Evgeniy Polyakov <zbr@ioremap.net>,
       Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] pda_power: add support for writeable properties
Date: Tue, 23 Mar 2010 10:06:17 +0100
Message-Id: <1269335179-30177-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for writeable power supply properties and
exposes them as writeable to sysfs.

A power supply implementation must implement two new function calls in
order to use that feature:

  int set_property(struct power_supply *psy,
                   enum power_supply_property psp,
                   const union power_supply_propval *val);

  int property_is_writeable(struct power_supply *psy,
                            enum power_supply_property psp);

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Andres Salomon <dilinger@collabora.co.uk>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Len Brown <len.brown@intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Matt Reimer <mreimer@vpop.net>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/power/power_supply_sysfs.c |   31 +++++++++++++++++++++++++++++--
 include/linux/power_supply.h       |    5 +++++
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 5b6e352..5cfb410 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -31,9 +31,9 @@
 
 #define POWER_SUPPLY_ATTR(_name)					\
 {									\
-	.attr = { .name = #_name, .mode = 0444 },	\
+	.attr = { .name = #_name },					\
 	.show = power_supply_show_property,				\
-	.store = NULL,							\
+	.store = power_supply_store_property,				\
 }
 
 static struct device_attribute power_supply_attrs[];
@@ -91,6 +91,25 @@ static ssize_t power_supply_show_property(struct device *dev,
 	return sprintf(buf, "%d\n", value.intval);
 }
 
+static ssize_t power_supply_store_property(struct device *dev,
+					   struct device_attribute *attr,
+					   const char *buf, size_t count) {
+	ssize_t ret;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	const ptrdiff_t off = attr - power_supply_attrs;
+	union power_supply_propval value;
+	long long_val;
+
+	/* TODO: support other types than int */
+	ret = strict_strtol(buf, 10, &long_val);
+	if (ret < 0)
+		return ret;
+
+	value.intval = long_val;
+
+	return psy->set_property(psy, off, &value);
+}
+
 /* Must be in the same order as POWER_SUPPLY_PROP_* */
 static struct device_attribute power_supply_attrs[] = {
 	/* Properties of type `int' */
@@ -164,6 +183,14 @@ int power_supply_create_attrs(struct power_supply *psy)
 	}
 
 	for (j = 0; j < psy->num_properties; j++) {
+		mode_t mode = S_IRUSR | S_IRGRP | S_IROTH;
+
+		if (psy->property_is_writeable &&
+		    psy->property_is_writeable(psy, psy->properties[j]) > 0)
+			mode |= S_IWUSR;
+
+		power_supply_attrs[psy->properties[j]].attr.mode = mode;
+
 		rc = device_create_file(psy->dev,
 			    &power_supply_attrs[psy->properties[j]]);
 		if (rc)
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index ebd2b8f..f02f7fd 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -144,6 +144,11 @@ struct power_supply {
 	int (*get_property)(struct power_supply *psy,
 			    enum power_supply_property psp,
 			    union power_supply_propval *val);
+	int (*set_property)(struct power_supply *psy,
+			    enum power_supply_property psp,
+			    const union power_supply_propval *val);
+	int (*property_is_writeable)(struct power_supply *psy,
+				     enum power_supply_property psp);
 	void (*external_power_changed)(struct power_supply *psy);
 	void (*set_charged)(struct power_supply *psy);
 
-- 
1.6.3.3

