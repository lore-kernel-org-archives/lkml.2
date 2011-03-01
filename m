Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1CAA45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 19:56:57 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3867 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab1CAA4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 19:56:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 28 Feb 2011 16:56:41 -0800
From: rklein@nvidia.com
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: olof@lixom.net, linux-kernel@vger.kernel.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 3/4] power: bq20z75: add support for POWER_NOW
Date: Mon, 28 Feb 2011 16:55:30 -0800
Message-Id: <1298940931-17552-4-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1298940931-17552-1-git-send-email-rklein@nvidia.com>
References: <1298940931-17552-1-git-send-email-rklein@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rhyland Klein <rklein@nvidia.com>

Adding support for POWER_NOW property. Returns the product of current and
voltage in terms of uW.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/bq20z75.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
index e82d10e..7558d51 100644
--- a/drivers/power/bq20z75.c
+++ b/drivers/power/bq20z75.c
@@ -142,6 +142,7 @@ static enum power_supply_property bq20z75_properties[] = {
 	POWER_SUPPLY_PROP_CHARGE_NOW,
 	POWER_SUPPLY_PROP_CHARGE_FULL,
 	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
+	POWER_SUPPLY_PROP_POWER_NOW,
 };
 
 struct bq20z75_info {
@@ -411,6 +412,32 @@ static int bq20z75_get_battery_capacity(struct i2c_client *client,
 	return 0;
 }
 
+static int bq20z75_get_power_now(struct i2c_client *client,
+	union power_supply_propval *val)
+{
+	int voltage_now = 0;
+	int current_now = 0;
+
+	voltage_now = bq20z75_read_word_data(client,
+		bq20z75_data[REG_VOLTAGE].addr);
+	if (voltage_now < 0)
+		return voltage_now;
+
+	current_now = bq20z75_read_word_data(client,
+		bq20z75_data[REG_CURRENT].addr);
+	if (current_now < 0)
+		return current_now;
+
+	/* returned values are 16 bit */
+	current_now = (s16)current_now;
+	/* need to ensure it is positive */
+	current_now = abs(current_now);
+
+	val->intval = voltage_now * current_now;
+
+	return 0;
+}
+
 static char bq20z75_serial[5];
 static int bq20z75_get_battery_serial_number(struct i2c_client *client,
 	union power_supply_propval *val)
@@ -475,6 +502,10 @@ static int bq20z75_get_property(struct power_supply *psy,
 		ret = bq20z75_get_battery_capacity(client, ret, psp, val);
 		break;
 
+	case POWER_SUPPLY_PROP_POWER_NOW:
+		ret = bq20z75_get_power_now(client, val);
+		break;
+
 	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
 		ret = bq20z75_get_battery_serial_number(client, val);
 		break;
-- 
1.7.0.4

