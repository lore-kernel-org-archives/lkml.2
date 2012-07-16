Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab2GPHOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 03:14:12 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7481 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab2GPHOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 03:14:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 16 Jul 2012 00:14:01 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <ccross@android.com>,
        <olof@lixom.net>, <swarren@wwwdotorg.org>
CC: <thierry.reding@avionic-design.de>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH RESEND] ARM: tegra: harmony: add regulator supply name and its input supply
Date: Mon, 16 Jul 2012 12:35:53 +0530
Message-ID: <1342422353-10973-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Name the regulator as per board schematics and adds its
supply name info in regulator data.
Add the always on fixed regulator to refer the battery supply.

Use this fixed regulator for input supply of some of PMIC
regulator

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This was 1/2 of the series
[PATCH 0/2] regulator: tps6586x: support for input supply

There is change in the regulator driver of tps6586x to support input
supply, this change is also require to avoid any functionality break.
The regulator change is in the Mark's regulator/for-next, this change
should also go from this tree.
Resending this as Mark suggested.

 arch/arm/mach-tegra/board-harmony-power.c |   33 +++++++++++++++++-----------
 1 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-tegra/board-harmony-power.c b/arch/arm/mach-tegra/board-harmony-power.c
index 44dcb2e..8fd387b 100644
--- a/arch/arm/mach-tegra/board-harmony-power.c
+++ b/arch/arm/mach-tegra/board-harmony-power.c
@@ -19,6 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/fixed.h>
 #include <linux/mfd/tps6586x.h>
 #include <linux/of.h>
 #include <linux/of_i2c.h>
@@ -34,7 +35,9 @@ static struct regulator_consumer_supply tps658621_ldo0_supply[] = {
 };
 
 static struct regulator_init_data ldo0_data = {
+	.supply_regulator = "vdd_sm2",
 	.constraints = {
+		.name = "vdd_ldo0",
 		.min_uV = 3300 * 1000,
 		.max_uV = 3300 * 1000,
 		.valid_modes_mask = (REGULATOR_MODE_NORMAL |
@@ -48,9 +51,11 @@ static struct regulator_init_data ldo0_data = {
 	.consumer_supplies = tps658621_ldo0_supply,
 };
 
-#define HARMONY_REGULATOR_INIT(_id, _minmv, _maxmv)			\
+#define HARMONY_REGULATOR_INIT(_id, _name, _supply, _minmv, _maxmv)	\
 	static struct regulator_init_data _id##_data = {		\
+		.supply_regulator = _supply,				\
 		.constraints = {					\
+			.name = _name,					\
 			.min_uV = (_minmv)*1000,			\
 			.max_uV = (_maxmv)*1000,			\
 			.valid_modes_mask = (REGULATOR_MODE_NORMAL |	\
@@ -61,18 +66,18 @@ static struct regulator_init_data ldo0_data = {
 		},							\
 	}
 
-HARMONY_REGULATOR_INIT(sm0, 725, 1500);
-HARMONY_REGULATOR_INIT(sm1, 725, 1500);
-HARMONY_REGULATOR_INIT(sm2, 3000, 4550);
-HARMONY_REGULATOR_INIT(ldo1, 725, 1500);
-HARMONY_REGULATOR_INIT(ldo2, 725, 1500);
-HARMONY_REGULATOR_INIT(ldo3, 1250, 3300);
-HARMONY_REGULATOR_INIT(ldo4, 1700, 2475);
-HARMONY_REGULATOR_INIT(ldo5, 1250, 3300);
-HARMONY_REGULATOR_INIT(ldo6, 1250, 3300);
-HARMONY_REGULATOR_INIT(ldo7, 1250, 3300);
-HARMONY_REGULATOR_INIT(ldo8, 1250, 3300);
-HARMONY_REGULATOR_INIT(ldo9, 1250, 3300);
+HARMONY_REGULATOR_INIT(sm0,  "vdd_sm0",  "vdd_sys", 725, 1500);
+HARMONY_REGULATOR_INIT(sm1,  "vdd_sm1",  "vdd_sys", 725, 1500);
+HARMONY_REGULATOR_INIT(sm2,  "vdd_sm2",  "vdd_sys", 3000, 4550);
+HARMONY_REGULATOR_INIT(ldo1, "vdd_ldo1", "vdd_sm2", 725, 1500);
+HARMONY_REGULATOR_INIT(ldo2, "vdd_ldo2", "vdd_sm2", 725, 1500);
+HARMONY_REGULATOR_INIT(ldo3, "vdd_ldo3", "vdd_sm2", 1250, 3300);
+HARMONY_REGULATOR_INIT(ldo4, "vdd_ldo4", "vdd_sm2", 1700, 2475);
+HARMONY_REGULATOR_INIT(ldo5, "vdd_ldo5", NULL,	    1250, 3300);
+HARMONY_REGULATOR_INIT(ldo6, "vdd_ldo6", "vdd_sm2", 1250, 3300);
+HARMONY_REGULATOR_INIT(ldo7, "vdd_ldo7", "vdd_sm2", 1250, 3300);
+HARMONY_REGULATOR_INIT(ldo8, "vdd_ldo8", "vdd_sm2", 1250, 3300);
+HARMONY_REGULATOR_INIT(ldo9, "vdd_ldo9", "vdd_sm2", 1250, 3300);
 
 #define TPS_REG(_id, _data)			\
 	{					\
@@ -115,6 +120,8 @@ static struct i2c_board_info __initdata harmony_regulators[] = {
 int __init harmony_regulator_init(void)
 {
 	if (machine_is_harmony()) {
+		regulator_register_always_on(0, "vdd_sys",
+			NULL, 0, 5000000);
 		i2c_register_board_info(3, harmony_regulators, 1);
 	} else { /* Harmony, booted using device tree */
 		struct device_node *np;
-- 
1.7.1.1

