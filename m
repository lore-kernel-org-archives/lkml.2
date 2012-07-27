Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab2G0SSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 14:18:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:24925 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab2G0SSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 14:18:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="187866807"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH] max17042_battery: add support for battery STATUS and CHARGE_TYPE
Date: Fri, 27 Jul 2012 22:26:21 +0530
Message-Id: <1343408181-21988-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support to report the battery power supply attributes
STATUS and CHARGE_TYPE. This patch makes use of power_supply_get_external_attr()
API to get these attributes through power supply core.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 drivers/power/max17042_battery.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 74abc6c..56131f8 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -105,6 +105,8 @@ static void max17042_set_reg(struct i2c_client *client,
 
 static enum power_supply_property max17042_battery_props[] = {
 	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_CHARGE_TYPE,
 	POWER_SUPPLY_PROP_CYCLE_COUNT,
 	POWER_SUPPLY_PROP_VOLTAGE_MAX,
 	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
@@ -125,12 +127,29 @@ static int max17042_get_property(struct power_supply *psy,
 {
 	struct max17042_chip *chip = container_of(psy,
 				struct max17042_chip, battery);
+	struct power_supply_attr_query query;
 	int ret;
 
 	if (!chip->init_complete)
 		return -EAGAIN;
 
+	memset(&query, 0x0, sizeof(query));
+	query.property = psp;
+	query.type = POWER_SUPPLY_TYPE_BATTERY;
+
 	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		ret = power_supply_get_external_attr(&query);
+		if (ret < 0)
+			return ret;
+		val->intval = query.res.intval;
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_TYPE:
+		ret = power_supply_get_external_attr(&query);
+		if (ret < 0)
+			return ret;
+		val->intval = query.res.intval;
+		break;
 	case POWER_SUPPLY_PROP_PRESENT:
 		ret = max17042_read_reg(chip->client, MAX17042_STATUS);
 		if (ret < 0)
-- 
1.7.0.4

