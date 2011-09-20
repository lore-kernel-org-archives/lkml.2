Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab1ITPUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:20:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37359 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab1ITPUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:20:07 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 6/7] bq27x00: Fix reporting status value for bq27500 battery
Date: Tue, 20 Sep 2011 17:18:52 +0200
Message-Id: <1316531933-7159-6-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/power/bq27x00_battery.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index a22124a..c4c403e 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -62,10 +62,11 @@
 
 #define BQ27500_REG_SOC			0x2C
 #define BQ27500_REG_DCAP		0x3C /* Design capacity */
-#define BQ27500_FLAG_DSC		BIT(0)
+#define BQ27500_FLAG_DSG		BIT(0) /* Discharging */
 #define BQ27500_FLAG_SOCF		BIT(1) /* State-of-Charge threshold final */
 #define BQ27500_FLAG_SOC1		BIT(2) /* State-of-Charge threshold 1 */
-#define BQ27500_FLAG_FC			BIT(9)
+#define BQ27500_FLAG_CHG		BIT(8) /* Charging */
+#define BQ27500_FLAG_FC			BIT(9) /* Fully charged */
 
 #define BQ27000_RS			20 /* Resistor sense */
 
@@ -395,10 +396,14 @@ static int bq27x00_battery_status(struct bq27x00_device_info *di,
 	if (di->chip == BQ27500) {
 		if (di->cache.flags & BQ27500_FLAG_FC)
 			status = POWER_SUPPLY_STATUS_FULL;
-		else if (di->cache.flags & BQ27500_FLAG_DSC)
+		else if (di->cache.flags & BQ27500_FLAG_DSG)
 			status = POWER_SUPPLY_STATUS_DISCHARGING;
-		else
+		else if (di->cache.flags & BQ27500_FLAG_CHG)
 			status = POWER_SUPPLY_STATUS_CHARGING;
+		else if (power_supply_am_i_supplied(&di->bat))
+			status = POWER_SUPPLY_STATUS_NOT_CHARGING;
+		else
+			status = POWER_SUPPLY_STATUS_UNKNOWN;
 	} else {
 		if (di->cache.flags & BQ27000_FLAG_FC)
 			status = POWER_SUPPLY_STATUS_FULL;
-- 
1.7.4.1

