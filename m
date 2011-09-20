Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab1ITPUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:20:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37359 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab1ITPUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:20:10 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 7/7] bq27x00: Fix reporting error messages
Date: Tue, 20 Sep 2011 17:18:53 +0200
Message-Id: <1316531933-7159-7-git-send-email-pali.rohar@gmail.com>
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
index c4c403e..46db966 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -170,7 +170,7 @@ static int bq27x00_battery_read_charge(struct bq27x00_device_info *di, u8 reg)
 
 	charge = bq27x00_read(di, reg, false);
 	if (charge < 0) {
-		dev_err(di->dev, "error reading nominal available capacity\n");
+		dev_err(di->dev, "error reading charge register %02x: %d\n", reg, charge);
 		return charge;
 	}
 
@@ -295,7 +295,7 @@ static int bq27x00_battery_read_time(struct bq27x00_device_info *di, u8 reg)
 
 	tval = bq27x00_read(di, reg, false);
 	if (tval < 0) {
-		dev_err(di->dev, "error reading register %02x: %d\n", reg, tval);
+		dev_err(di->dev, "error reading time register %02x: %d\n", reg, tval);
 		return tval;
 	}
 
@@ -313,6 +313,7 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 	cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, is_bq27500);
 	if (cache.flags >= 0) {
 		if (!is_bq27500 && (cache.flags & BQ27000_FLAG_CI)) {
+			dev_err(di->dev, "battery is not calibrated! ignoring capacity values\n");
 			cache.capacity = -ENODATA;
 			cache.energy = -ENODATA;
 			cache.time_to_empty = -ENODATA;
@@ -369,8 +370,10 @@ static int bq27x00_battery_current(struct bq27x00_device_info *di,
 	int flags;
 
 	curr = bq27x00_read(di, BQ27x00_REG_AI, false);
-	if (curr < 0)
+	if (curr < 0) {
+		dev_err(di->dev, "error reading current");
 		return curr;
+	}
 
 	if (di->chip == BQ27500) {
 		/* bq27500 returns signed value */
@@ -460,8 +463,10 @@ static int bq27x00_battery_voltage(struct bq27x00_device_info *di,
 	int volt;
 
 	volt = bq27x00_read(di, BQ27x00_REG_VOLT, false);
-	if (volt < 0)
+	if (volt < 0) {
+		dev_err(di->dev, "error reading voltage\n");
 		return volt;
+	}
 
 	val->intval = volt * 1000;
 
-- 
1.7.4.1

