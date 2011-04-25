Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab1DYUUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:20:48 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34498 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab1DYUUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:20:46 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Akihiro MAEDA <sola.1980.a@gmail.com>,
        Masashi YOKOTA <yokota@pylone.jp>
Subject: [PATCH 3/3][RFC] power: Fixup stack usage in vritual battery driver
Date: Mon, 25 Apr 2011 13:20:29 -0700
Message-Id: <1303762829-18000-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1303762829-18000-1-git-send-email-john.stultz@linaro.org>
References: <1303762829-18000-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason the virtual battery driver code allocates
4k on the stack. This is clearly broken, so keep the length
smaller (256) and cleanup the string management code to use
the bounds checking versions.

Also cleans up some 80+ char line formatting issues.

CC: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Akihiro MAEDA <sola.1980.a@gmail.com>
CC: Masashi YOKOTA <yokota@pylone.jp>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/power/virtual_battery.c |   62 +++++++++++++++++++++++++-------------
 1 files changed, 41 insertions(+), 21 deletions(-)

diff --git a/drivers/power/virtual_battery.c b/drivers/power/virtual_battery.c
index ed686ef..e865230 100644
--- a/drivers/power/virtual_battery.c
+++ b/drivers/power/virtual_battery.c
@@ -115,6 +115,7 @@ static struct power_supply power_supply_bat = {
 };
 
 
+#define MAX_KEYLENGTH 256
 struct battery_property_map {
 	int value;
 	char const * key;
@@ -160,18 +161,21 @@ static struct battery_property_map map_technology[] = {
 };
 
 
-static int map_get_value(struct battery_property_map * map, const char * key, int def_val)
+static int map_get_value(struct battery_property_map * map, const char * key,
+				int def_val)
 {
-	char buf[4096];
+	char buf[MAX_KEYLENGTH];
 	int cr;
 
-	strcpy(buf, key);
-	cr = strlen(buf) - 1;
+	strncpy(buf, key, MAX_KEYLENGTH);
+	buf[MAX_KEYLENGTH-1] = '\0';
+
+	cr = strnlen(buf, MAX_KEYLENGTH) - 1;
 	if (buf[cr] == '\n')
 		buf[cr] = '\0';
 
 	while (map->key) {
-		if (strcasecmp(map->key, buf) == 0)
+		if (strncasecmp(map->key, buf, MAX_KEYLENGTH) == 0)
 			return map->value;
 		map++;
 	}
@@ -180,7 +184,8 @@ static int map_get_value(struct battery_property_map * map, const char * key, in
 }
 
 
-static const char * map_get_key(struct battery_property_map * map, int value, const char * def_key)
+static const char * map_get_key(struct battery_property_map * map, int value,
+				const char * def_key)
 {
 	while (map->key) {
 		if (map->value == value)
@@ -193,7 +198,8 @@ static const char * map_get_key(struct battery_property_map * map, int value, co
 
 static int param_set_ac_status(const char *key, const struct kernel_param *kp)
 {
-	dev_dbg(&bat_pdev->dev, "%s: name=%s, key=%s\n", __func__, kp->name, key);
+	dev_dbg(&bat_pdev->dev, "%s: name=%s, key=%s\n",
+			__func__, kp->name, key);
 	ac_status = map_get_value( map_ac_online, key, ac_status);
 	power_supply_changed(&power_supply_ac);
 	return 0;
@@ -206,9 +212,11 @@ static int param_get_ac_status(char *buffer, const struct kernel_param *kp)
 	return strlen(buffer);
 }
 
-static int param_set_battery_status(const char *key, const struct kernel_param *kp)
+static int param_set_battery_status(const char *key,
+					const struct kernel_param *kp)
 {
-	dev_dbg(&bat_pdev->dev, "%s: name=%s, key=%s.\n", __func__, kp->name, key);
+	dev_dbg(&bat_pdev->dev, "%s: name=%s, key=%s.\n",
+			__func__, kp->name, key);
 	battery_status = map_get_value( map_status, key, battery_status);
 	power_supply_changed(&power_supply_bat);
 	return 0;
@@ -221,9 +229,11 @@ static int param_get_battery_status(char *buffer, const struct kernel_param *kp)
 	return strlen(buffer);
 }
 
-static int param_set_battery_health(const char *key, const struct kernel_param *kp)
+static int param_set_battery_health(const char *key,
+					const struct kernel_param *kp)
 {
-	dev_dbg(&bat_pdev->dev, "%s: name=%s, key=%s\n", __func__, kp->name, key);
+	dev_dbg(&bat_pdev->dev, "%s: name=%s, key=%s\n",
+			__func__, kp->name, key);
 	battery_health = map_get_value( map_health, key, battery_health);
 	power_supply_changed(&power_supply_bat);
 	return 0;
@@ -236,41 +246,51 @@ static int param_get_battery_health(char *buffer, const struct kernel_param *kp)
 	return strlen(buffer);
 }
 
-static int param_set_battery_present(const char *key, const struct kernel_param *kp)
+static int param_set_battery_present(const char *key,
+					const struct kernel_param *kp)
 {
-	dev_dbg(&bat_pdev->dev, "%s: name=%s, key=%s\n", __func__, kp->name, key);
+	dev_dbg(&bat_pdev->dev, "%s: name=%s, key=%s\n",
+			__func__, kp->name, key);
 	battery_present = map_get_value( map_present, key, battery_present);
 	power_supply_changed(&power_supply_ac);
 	return 0;
 }
 
-static int param_get_battery_present(char *buffer, const struct kernel_param *kp)
+static int param_get_battery_present(char *buffer,
+					const struct kernel_param *kp)
 {
 	dev_dbg(&bat_pdev->dev, "%s: name=%s\n", __func__, kp->name);
 	strcpy(buffer, map_get_key( map_present, battery_present, "unknown"));
 	return strlen(buffer);
 }
 
-static int param_set_battery_technology(const char *key, const struct kernel_param *kp)
+static int param_set_battery_technology(const char *key,
+					const struct kernel_param *kp)
 {
-	dev_dbg(&bat_pdev->dev, "%s: name=%s, key=%s\n", __func__, kp->name, key);
-	battery_technology = map_get_value( map_technology, key, battery_technology);
+	dev_dbg(&bat_pdev->dev, "%s: name=%s, key=%s\n",
+			__func__, kp->name, key);
+	battery_technology = map_get_value(map_technology, key,
+						battery_technology);
 	power_supply_changed(&power_supply_bat);
 	return 0;
 }
 
-static int param_get_battery_technology(char *buffer, const struct kernel_param *kp)
+static int param_get_battery_technology(char *buffer,
+					const struct kernel_param *kp)
 {
 	dev_dbg(&bat_pdev->dev, "%s: name=%s\n", __func__, kp->name);
-	strcpy(buffer, map_get_key( map_technology, battery_technology, "unknown"));
+	strcpy(buffer,
+		map_get_key( map_technology, battery_technology, "unknown"));
 	return strlen(buffer);
 }
 
-static int param_set_battery_capacity(const char *key, const struct kernel_param *kp)
+static int param_set_battery_capacity(const char *key,
+					const struct kernel_param *kp)
 {
 	int tmp;
 
-	dev_dbg(&bat_pdev->dev, "%s: name=%s, key=%s\n", __func__, kp->name, key);
+	dev_dbg(&bat_pdev->dev, "%s: name=%s, key=%s\n",
+			__func__, kp->name, key);
 
 	if (1 != sscanf(key, "%d", &tmp))
 		return -EINVAL;
-- 
1.7.3.2.146.gca209

