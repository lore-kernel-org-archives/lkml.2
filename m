Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab2GYMXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 08:23:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:32737 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555Ab2GYMXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 08:23:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="185852906"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH v2] power_supply: Added helper function to get the ps object from supplied_to list
Date: Wed, 25 Jul 2012 16:30:37 +0530
Message-Id: <1343214037-15238-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a helper function in the power supply core to get the
power supply object from supplied_to list based on power supply attribute.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 drivers/power/power_supply_core.c |   19 +++++++++++++++++++
 include/linux/power_supply.h      |    3 +++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index ff990d2..5845a76 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -158,6 +158,25 @@ struct power_supply *power_supply_get_by_name(char *name)
 }
 EXPORT_SYMBOL_GPL(power_supply_get_by_name);
 
+struct power_supply *power_supply_get_by_suppliedto(struct power_supply *psy,
+				enum power_supply_property psp, int intval)
+{
+	union power_supply_propval ret = {0,};
+	struct power_supply *pst;
+	int i;
+
+	for (i = 0; i < psy->num_supplicants; i++) {
+		pst = power_supply_get_by_name(psy->supplied_to[i]);
+		if (!pst || pst->get_property(pst, psp, &ret))
+			continue;
+		if (ret.intval == intval)
+			return pst;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(power_supply_get_by_suppliedto);
+
 int power_supply_powers(struct power_supply *psy, struct device *dev)
 {
 	return sysfs_create_link(&psy->dev->kobj, &dev->kobj, "powers");
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 0bafbb1..3cfee0c 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -219,6 +219,9 @@ struct power_supply_info {
 };
 
 extern struct power_supply *power_supply_get_by_name(char *name);
+extern struct power_supply *power_supply_get_by_suppliedto(
+				struct power_supply *psy,
+				enum power_supply_property psp, int intval);
 extern void power_supply_changed(struct power_supply *psy);
 extern int power_supply_am_i_supplied(struct power_supply *psy);
 extern int power_supply_set_battery_charged(struct power_supply *psy);
-- 
1.7.0.4

