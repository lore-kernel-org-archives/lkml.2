Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab1ITPTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:19:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63898 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1ITPTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:19:21 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 1/7] bq27x00: Do not cache current_now value for bq27000 batery
Date: Tue, 20 Sep 2011 17:18:47 +0200
Message-Id: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* This prevent reporting old current_now value for bq27000
* Also ask for current flags, to make sure that current_now will be reported with correct signature
---
 drivers/power/bq27x00_battery.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index bb16f5b..d238144 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -80,8 +80,6 @@ struct bq27x00_reg_cache {
 	int cycle_count;
 	int capacity;
 	int flags;
-
-	int current_now;
 };
 
 struct bq27x00_device_info {
@@ -270,17 +268,12 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 		cache.charge_full = bq27x00_battery_read_lmd(di);
 		cache.cycle_count = bq27x00_battery_read_cyct(di);
 
-		if (!is_bq27500)
-			cache.current_now = bq27x00_read(di, BQ27x00_REG_AI, false);
-
 		/* We only have to read charge design full once */
 		if (di->charge_design_full <= 0)
 			di->charge_design_full = bq27x00_battery_read_ilmd(di);
 	}
 
-	/* Ignore current_now which is a snapshot of the current battery state
-	 * and is likely to be different even between two consecutive reads */
-	if (memcmp(&di->cache, &cache, sizeof(cache) - sizeof(int)) != 0) {
+	if (memcmp(&di->cache, &cache, sizeof(cache)) != 0) {
 		di->cache = cache;
 		power_supply_changed(&di->bat);
 	}
@@ -330,12 +323,9 @@ static int bq27x00_battery_current(struct bq27x00_device_info *di,
 	union power_supply_propval *val)
 {
 	int curr;
+	int flags;
 
-	if (di->chip == BQ27500)
-	    curr = bq27x00_read(di, BQ27x00_REG_AI, false);
-	else
-	    curr = di->cache.current_now;
-
+	curr = bq27x00_read(di, BQ27x00_REG_AI, false);
 	if (curr < 0)
 		return curr;
 
@@ -343,7 +333,8 @@ static int bq27x00_battery_current(struct bq27x00_device_info *di,
 		/* bq27500 returns signed value */
 		val->intval = (int)((s16)curr) * 1000;
 	} else {
-		if (di->cache.flags & BQ27000_FLAG_CHGS) {
+		flags = bq27x00_read(di, BQ27x00_REG_FLAGS, false);
+		if (flags & BQ27000_FLAG_CHGS) {
 			dev_dbg(di->dev, "negative current!\n");
 			curr = -curr;
 		}
-- 
1.7.4.1

