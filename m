Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934902Ab1KAArz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:47:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55006 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934319Ab1KAArX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:47:23 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        David Woodhouse <dwmw2@infradead.org>
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 7/9] bq27x00: Fix reporting error messages
Date: Tue,  1 Nov 2011 01:43:09 +0100
Message-Id: <1320108191-6647-7-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320108191-6647-1-git-send-email-pali.rohar@gmail.com>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
 <1320108191-6647-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Do not be noise if battery is not calibrated (use dev_dbg)

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/power/bq27x00_battery.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index c4c403e..63cfb5a 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -155,7 +155,7 @@ static int bq27x00_battery_read_rsoc(struct bq27x00_device_info *di)
 		rsoc = bq27x00_read(di, BQ27000_REG_RSOC, true);
 
 	if (rsoc < 0)
-		dev_err(di->dev, "error reading relative State-of-Charge\n");
+		dev_dbg(di->dev, "error reading relative State-of-Charge\n");
 
 	return rsoc;
 }
@@ -170,7 +170,7 @@ static int bq27x00_battery_read_charge(struct bq27x00_device_info *di, u8 reg)
 
 	charge = bq27x00_read(di, reg, false);
 	if (charge < 0) {
-		dev_err(di->dev, "error reading nominal available capacity\n");
+		dev_dbg(di->dev, "error reading charge register %02x: %d\n", reg, charge);
 		return charge;
 	}
 
@@ -214,7 +214,7 @@ static int bq27x00_battery_read_ilmd(struct bq27x00_device_info *di)
 		ilmd = bq27x00_read(di, BQ27000_REG_ILMD, true);
 
 	if (ilmd < 0) {
-		dev_err(di->dev, "error reading initial last measured discharge\n");
+		dev_dbg(di->dev, "error reading initial last measured discharge\n");
 		return ilmd;
 	}
 
@@ -236,7 +236,7 @@ static int bq27x00_battery_read_energy(struct bq27x00_device_info *di)
 
 	ae = bq27x00_read(di, BQ27x00_REG_AE, false);
 	if (ae < 0) {
-		dev_err(di->dev, "error reading available energy\n");
+		dev_dbg(di->dev, "error reading available energy\n");
 		return ae;
 	}
 
@@ -295,7 +295,7 @@ static int bq27x00_battery_read_time(struct bq27x00_device_info *di, u8 reg)
 
 	tval = bq27x00_read(di, reg, false);
 	if (tval < 0) {
-		dev_err(di->dev, "error reading register %02x: %d\n", reg, tval);
+		dev_dbg(di->dev, "error reading time register %02x: %d\n", reg, tval);
 		return tval;
 	}
 
@@ -313,6 +313,7 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 	cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, is_bq27500);
 	if (cache.flags >= 0) {
 		if (!is_bq27500 && (cache.flags & BQ27000_FLAG_CI)) {
+			dev_info(di->dev, "battery is not calibrated! ignoring capacity values\n");
 			cache.capacity = -ENODATA;
 			cache.energy = -ENODATA;
 			cache.time_to_empty = -ENODATA;
@@ -369,8 +370,10 @@ static int bq27x00_battery_current(struct bq27x00_device_info *di,
 	int flags;
 
 	curr = bq27x00_read(di, BQ27x00_REG_AI, false);
-	if (curr < 0)
+	if (curr < 0) {
+		dev_err(di->dev, "error reading current\n");
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
1.7.5.4

