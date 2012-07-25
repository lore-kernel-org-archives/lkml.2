Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab2GYLNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:13:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:9146 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506Ab2GYLNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:13:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="172975079"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH] power_supply: API to return the power supply object from supplied to list
Date: Wed, 25 Jul 2012 15:20:18 +0530
Message-Id: <1343209818-14232-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an API in the power supply core to get the
power supply object from supplied_to list based on power
supply attribute(present/online).

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 drivers/power/power_supply_core.c |   19 +++++++++++++++++++
 include/linux/power_supply.h      |    3 +++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index ff990d2..8ef1d8b 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -158,6 +158,25 @@ struct power_supply *power_supply_get_by_name(char *name)
 }
 EXPORT_SYMBOL_GPL(power_supply_get_by_name);
 
+struct power_supply *power_supply_get_by_suppliedto(struct power_supply *psy,
+						enum power_supply_property psp)
+{
+	union power_supply_propval ret = {0,};
+	struct power_supply *pst;
+	int i;
+
+	for (i = 0; i < psy->num_supplicants; i++) {
+		pst = power_supply_get_by_name(psy->supplied_to[i]);
+		if (!pst || pst->get_property(pst, psp, &ret))
+			continue;
+		if (ret.intval)
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
index 0bafbb1..2fdcf77 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -219,6 +219,9 @@ struct power_supply_info {
 };
 
 extern struct power_supply *power_supply_get_by_name(char *name);
+extern struct power_supply *power_supply_get_by_suppliedto(
+					struct power_supply *psy,
+					enum power_supply_property psp);
 extern void power_supply_changed(struct power_supply *psy);
 extern int power_supply_am_i_supplied(struct power_supply *psy);
 extern int power_supply_set_battery_charged(struct power_supply *psy);
-- 
1.7.0.4

