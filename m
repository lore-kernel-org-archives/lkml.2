Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643Ab0G3T7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:59:36 -0400
Received: from compulab.co.il ([67.18.134.219]:60230 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab0G3T7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 15:59:34 -0400
From: Mike Rapoport <mike@compulab.co.il>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Gary King <gking@nvidia.com>
Subject: [PATCH] regulator: tps6586x: fix millivolt return values and SM2 table
Date: Fri, 30 Jul 2010 22:58:58 +0300
Message-Id: <1280519938-3089-1-git-send-email-mike@compulab.co.il>
X-Mailer: git-send-email 1.6.4.4
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gary King <gking@nvidia.com>

Hi Liam,
Below are bugfixes for the tps6586x spotted by Gary King.
Please add this patch to your regulator tree.
---

list_voltage and get_voltage are expected to return values in
microvolts, not millivolts

also, the SM2 regulator runs at a higher voltage (3-4.55V) than
the other regulators; add a new table for this regulator

Signed-off-by: Gary King <gking@nvidia.com>
Acked-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/regulator/tps6586x-regulator.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index 76cc41e..3c2eee8 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -80,7 +80,7 @@ static int tps6586x_ldo_list_voltage(struct regulator_dev *rdev,
 {
 	struct tps6586x_regulator *info = rdev_get_drvdata(rdev);
 
-	return info->voltages[selector];
+	return info->voltages[selector] * 1000;
 }
 
 
@@ -137,7 +137,7 @@ static int tps6586x_ldo_get_voltage(struct regulator_dev *rdev)
 	if (val > ri->desc.n_voltages)
 		BUG();
 
-	return ri->voltages[val];
+	return ri->voltages[val] * 1000;
 }
 
 static int tps6586x_dvm_set_voltage(struct regulator_dev *rdev,
@@ -217,6 +217,13 @@ static int tps6586x_ldo4_voltages[] = {
 	2300, 2325, 2350, 2375, 2400, 2425, 2450, 2475,
 };
 
+static int tps6586x_sm2_voltages[] = {
+	3000, 3050, 3100, 3150, 3200, 3250, 3300, 3350,
+	3400, 3450, 3500, 3550, 3600, 3650, 3700, 3750,
+	3800, 3850, 3900, 3950, 4000, 4050, 4100, 4150,
+	4200, 4250, 4300, 4350, 4400, 4450, 4500, 4550,
+};
+
 static int tps6586x_dvm_voltages[] = {
 	 725,  750,  775,  800,  825,  850,  875,  900,
 	 925,  950,  975, 1000, 1025, 1050, 1075, 1100,
@@ -265,7 +272,7 @@ static struct tps6586x_regulator tps6586x_regulator[] = {
 	TPS6586X_LDO(LDO_9, ldo, SUPPLYV6, 3, 3, ENE, 7, ENE, 7),
 	TPS6586X_LDO(LDO_RTC, ldo, SUPPLYV4, 3, 3, ENE, 7, ENE, 7),
 	TPS6586X_LDO(LDO_1, dvm, SUPPLYV1, 0, 5, ENC, 1, END, 1),
-	TPS6586X_LDO(SM_2, dvm, SUPPLYV2, 0, 5, ENC, 1, END, 1),
+	TPS6586X_LDO(SM_2, sm2, SUPPLYV2, 0, 5, ENC, 1, END, 1),
 
 	TPS6586X_DVM(LDO_2, dvm, LDO2BV1, 0, 5, ENA, 3, ENB, 3, VCC2, 6),
 	TPS6586X_DVM(LDO_4, ldo4, LDO4V1, 0, 5, ENC, 3, END, 3, VCC1, 6),
-- 
1.7.0.4

