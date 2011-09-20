Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab1ITPUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:20:01 -0400
Received: from mail-ew0-f43.google.com ([209.85.215.43]:62596 "EHLO
	mail-ew0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab1ITPUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:20:00 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 3/7] bq27x00: Report -ENODATA if bq27000 battery was not calibrated
Date: Tue, 20 Sep 2011 17:18:49 +0200
Message-Id: <1316531933-7159-3-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* CI (Capacity Inaccurate) flag is set after full reset on bq27000 battery
* when is set, all capacity properties should be reported incorrectly, because there was no learning cycle and battery was not calibrated
* instead reporting incorrect values, report -ENODATA
---
 drivers/power/bq27x00_battery.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index a531122..6c8dfdb 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -56,6 +56,7 @@
 #define BQ27000_REG_ILMD		0x76 /* Initial last measured discharge */
 #define BQ27000_FLAG_EDVF		BIT(0) /* Final End-of-Discharge-Voltage flag */
 #define BQ27000_FLAG_EDV1		BIT(1) /* First End-of-Discharge-Voltage flag */
+#define BQ27000_FLAG_CI			BIT(4) /* Capacity Inaccurate flag */
 #define BQ27000_FLAG_FC			BIT(5)
 #define BQ27000_FLAG_CHGS		BIT(7) /* Charge state flag */
 
@@ -265,12 +266,20 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 
 	cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, is_bq27500);
 	if (cache.flags >= 0) {
-		cache.capacity = bq27x00_battery_read_rsoc(di);
+		if (!is_bq27500 && (cache.flags & BQ27000_FLAG_CI)) {
+			cache.capacity = -ENODATA;
+			cache.time_to_empty = -ENODATA;
+			cache.time_to_empty_avg = -ENODATA;
+			cache.time_to_full = -ENODATA;
+			cache.charge_full = -ENODATA;
+		} else {
+			cache.capacity = bq27x00_battery_read_rsoc(di);
+			cache.time_to_empty = bq27x00_battery_read_time(di, BQ27x00_REG_TTE);
+			cache.time_to_empty_avg = bq27x00_battery_read_time(di, BQ27x00_REG_TTECP);
+			cache.time_to_full = bq27x00_battery_read_time(di, BQ27x00_REG_TTF);
+			cache.charge_full = bq27x00_battery_read_lmd(di);
+		}
 		cache.temperature = bq27x00_read(di, BQ27x00_REG_TEMP, false);
-		cache.time_to_empty = bq27x00_battery_read_time(di, BQ27x00_REG_TTE);
-		cache.time_to_empty_avg = bq27x00_battery_read_time(di, BQ27x00_REG_TTECP);
-		cache.time_to_full = bq27x00_battery_read_time(di, BQ27x00_REG_TTF);
-		cache.charge_full = bq27x00_battery_read_lmd(di);
 		cache.cycle_count = bq27x00_battery_read_cyct(di);
 
 		/* We only have to read charge design full once */
-- 
1.7.4.1

