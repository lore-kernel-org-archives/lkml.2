Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab0ERTul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 15:50:41 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:35001 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab0ERTuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 15:50:39 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: kay.sievers@vrfy.org, gregkh@suse.de, dwmw2@infradead.org,
       broonie@opensource.wolfsonmicro.com, len.brown@intel.com,
       astarikovskiy@suse.de, mreimer@vpop.net, zbr@ioremap.net, tj@kernel.org,
       Daniel Mack <daniel@caiaq.de>, Anton Vorontsov <cbou@mail.ru>
Subject: [PATCH 2/3] pda_power: add support for writeable properties
Date: Tue, 18 May 2010 21:49:52 +0200
Message-Id: <1274212193-16669-2-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100517194016.GA12147@oksana.dev.rtsoft.ru>
References: <20100517194016.GA12147@oksana.dev.rtsoft.ru>
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
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Len Brown <len.brown@intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Matt Reimer <mreimer@vpop.net>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/power/power_supply_sysfs.c |   38 +++++++++++++++++++++++++++++++++--
 include/linux/power_supply.h       |    5 ++++
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 6eb49ef..6a779fe 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -33,7 +33,7 @@
 {									\
 	.attr = { .name = #_name },					\
 	.show = power_supply_show_property,				\
-	.store = NULL,							\
+	.store = power_supply_store_property,				\
 }
 
 static struct device_attribute power_supply_attrs[];
@@ -99,6 +99,29 @@ static ssize_t power_supply_show_property(struct device *dev,
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
+	ret = psy->set_property(psy, off, &value);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
 /* Must be in the same order as POWER_SUPPLY_PROP_* */
 static struct device_attribute power_supply_attrs[] = {
 	/* Properties of type `int' */
@@ -159,8 +182,17 @@ static mode_t power_supply_attr_is_visible(struct kobject *kobj,
 	int i;
 
 	for (i = 0; i < psy->num_properties; i++) {
-		if (psy->properties[i] == attrno)
-			return 0444;
+		int property = psy->properties[i];
+
+		if (property == attrno) {
+			mode_t mode = S_IRUSR | S_IRGRP | S_IROTH;
+
+			if (psy->property_is_writeable &&
+			    psy->property_is_writeable(psy, property) > 0)
+				mode |= S_IWUSR;
+
+			return mode;
+		}
 	}
 
 	return 0;
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index c5f73a3..30083a8 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -145,6 +145,11 @@ struct power_supply {
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
1.7.1

