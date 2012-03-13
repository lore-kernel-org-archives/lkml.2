Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665Ab2CMGKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:10:34 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9132 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758426Ab2CMGKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:10:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 12 Mar 2012 23:10:28 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com, axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1 1/2] regulator: tps65910: Provide settling time for enabling rails.
Date: Tue, 13 Mar 2012 11:35:20 +0530
Message-Id: <1331618721-26326-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1331618721-26326-1-git-send-email-ldewangan@nvidia.com>
References: <1331618721-26326-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is settling time for each rails when it is switched to
ON. Implementing enable time for returning proper settling time
of regulator rails when it is enabled.
Filling the on-time for each rail as per tps65910/tps65911
datasheets.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps65910-regulator.c |   37 ++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 8074d51..9084664 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -89,11 +89,13 @@ struct tps_info {
 	unsigned max_uV;
 	u8 n_voltages;
 	const u16 *voltage_table;
+	int enable_time_us;
 };
 
 static struct tps_info tps65910_regs[] = {
 	{
 		.name = "VRTC",
+		.enable_time_us = 2200,
 	},
 	{
 		.name = "VIO",
@@ -101,16 +103,19 @@ static struct tps_info tps65910_regs[] = {
 		.max_uV = 3300000,
 		.n_voltages = ARRAY_SIZE(VIO_VSEL_table),
 		.voltage_table = VIO_VSEL_table,
+		.enable_time_us = 350,
 	},
 	{
 		.name = "VDD1",
 		.min_uV = 600000,
 		.max_uV = 4500000,
+		.enable_time_us = 350,
 	},
 	{
 		.name = "VDD2",
 		.min_uV = 600000,
 		.max_uV = 4500000,
+		.enable_time_us = 350,
 	},
 	{
 		.name = "VDD3",
@@ -118,6 +123,7 @@ static struct tps_info tps65910_regs[] = {
 		.max_uV = 5000000,
 		.n_voltages = ARRAY_SIZE(VDD3_VSEL_table),
 		.voltage_table = VDD3_VSEL_table,
+		.enable_time_us = 200,
 	},
 	{
 		.name = "VDIG1",
@@ -125,6 +131,7 @@ static struct tps_info tps65910_regs[] = {
 		.max_uV = 2700000,
 		.n_voltages = ARRAY_SIZE(VDIG1_VSEL_table),
 		.voltage_table = VDIG1_VSEL_table,
+		.enable_time_us = 100,
 	},
 	{
 		.name = "VDIG2",
@@ -132,6 +139,7 @@ static struct tps_info tps65910_regs[] = {
 		.max_uV = 1800000,
 		.n_voltages = ARRAY_SIZE(VDIG2_VSEL_table),
 		.voltage_table = VDIG2_VSEL_table,
+		.enable_time_us = 100,
 	},
 	{
 		.name = "VPLL",
@@ -139,6 +147,7 @@ static struct tps_info tps65910_regs[] = {
 		.max_uV = 2500000,
 		.n_voltages = ARRAY_SIZE(VPLL_VSEL_table),
 		.voltage_table = VPLL_VSEL_table,
+		.enable_time_us = 100,
 	},
 	{
 		.name = "VDAC",
@@ -146,6 +155,7 @@ static struct tps_info tps65910_regs[] = {
 		.max_uV = 2850000,
 		.n_voltages = ARRAY_SIZE(VDAC_VSEL_table),
 		.voltage_table = VDAC_VSEL_table,
+		.enable_time_us = 100,
 	},
 	{
 		.name = "VAUX1",
@@ -153,6 +163,7 @@ static struct tps_info tps65910_regs[] = {
 		.max_uV = 2850000,
 		.n_voltages = ARRAY_SIZE(VAUX1_VSEL_table),
 		.voltage_table = VAUX1_VSEL_table,
+		.enable_time_us = 100,
 	},
 	{
 		.name = "VAUX2",
@@ -160,6 +171,7 @@ static struct tps_info tps65910_regs[] = {
 		.max_uV = 3300000,
 		.n_voltages = ARRAY_SIZE(VAUX2_VSEL_table),
 		.voltage_table = VAUX2_VSEL_table,
+		.enable_time_us = 100,
 	},
 	{
 		.name = "VAUX33",
@@ -167,6 +179,7 @@ static struct tps_info tps65910_regs[] = {
 		.max_uV = 3300000,
 		.n_voltages = ARRAY_SIZE(VAUX33_VSEL_table),
 		.voltage_table = VAUX33_VSEL_table,
+		.enable_time_us = 100,
 	},
 	{
 		.name = "VMMC",
@@ -174,12 +187,14 @@ static struct tps_info tps65910_regs[] = {
 		.max_uV = 3300000,
 		.n_voltages = ARRAY_SIZE(VMMC_VSEL_table),
 		.voltage_table = VMMC_VSEL_table,
+		.enable_time_us = 100,
 	},
 };
 
 static struct tps_info tps65911_regs[] = {
 	{
 		.name = "VRTC",
+		.enable_time_us = 2200,
 	},
 	{
 		.name = "VIO",
@@ -187,72 +202,84 @@ static struct tps_info tps65911_regs[] = {
 		.max_uV = 3300000,
 		.n_voltages = ARRAY_SIZE(VIO_VSEL_table),
 		.voltage_table = VIO_VSEL_table,
+		.enable_time_us = 350,
 	},
 	{
 		.name = "VDD1",
 		.min_uV = 600000,
 		.max_uV = 4500000,
 		.n_voltages = 73,
+		.enable_time_us = 350,
 	},
 	{
 		.name = "VDD2",
 		.min_uV = 600000,
 		.max_uV = 4500000,
 		.n_voltages = 73,
+		.enable_time_us = 350,
 	},
 	{
 		.name = "VDDCTRL",
 		.min_uV = 600000,
 		.max_uV = 1400000,
 		.n_voltages = 65,
+		.enable_time_us = 900,
 	},
 	{
 		.name = "LDO1",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
 		.n_voltages = 47,
+		.enable_time_us = 420,
 	},
 	{
 		.name = "LDO2",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
 		.n_voltages = 47,
+		.enable_time_us = 420,
 	},
 	{
 		.name = "LDO3",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
 		.n_voltages = 24,
+		.enable_time_us = 230,
 	},
 	{
 		.name = "LDO4",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
 		.n_voltages = 47,
+		.enable_time_us = 230,
 	},
 	{
 		.name = "LDO5",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
 		.n_voltages = 24,
+		.enable_time_us = 230,
 	},
 	{
 		.name = "LDO6",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
 		.n_voltages = 24,
+		.enable_time_us = 230,
 	},
 	{
 		.name = "LDO7",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
 		.n_voltages = 24,
+		.enable_time_us = 230,
 	},
 	{
 		.name = "LDO8",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
 		.n_voltages = 24,
+		.enable_time_us = 230,
 	},
 };
 
@@ -482,6 +509,12 @@ static int tps65910_disable(struct regulator_dev *dev)
 	return tps65910_clear_bits(mfd, reg, TPS65910_SUPPLY_STATE_ENABLED);
 }
 
+static int tps65910_enable_time(struct regulator_dev *dev)
+{
+	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	return pmic->info[id]->enable_time_us;
+}
 
 static int tps65910_set_mode(struct regulator_dev *dev, unsigned int mode)
 {
@@ -864,6 +897,7 @@ static struct regulator_ops tps65910_ops_dcdc = {
 	.is_enabled		= tps65910_is_enabled,
 	.enable			= tps65910_enable,
 	.disable		= tps65910_disable,
+	.enable_time		= tps65910_enable_time,
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
 	.get_voltage		= tps65910_get_voltage_dcdc,
@@ -875,6 +909,7 @@ static struct regulator_ops tps65910_ops_vdd3 = {
 	.is_enabled		= tps65910_is_enabled,
 	.enable			= tps65910_enable,
 	.disable		= tps65910_disable,
+	.enable_time		= tps65910_enable_time,
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
 	.get_voltage		= tps65910_get_voltage_vdd3,
@@ -885,6 +920,7 @@ static struct regulator_ops tps65910_ops = {
 	.is_enabled		= tps65910_is_enabled,
 	.enable			= tps65910_enable,
 	.disable		= tps65910_disable,
+	.enable_time		= tps65910_enable_time,
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
 	.get_voltage		= tps65910_get_voltage,
@@ -896,6 +932,7 @@ static struct regulator_ops tps65911_ops = {
 	.is_enabled		= tps65910_is_enabled,
 	.enable			= tps65910_enable,
 	.disable		= tps65910_disable,
+	.enable_time		= tps65910_enable_time,
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
 	.get_voltage		= tps65911_get_voltage,
-- 
1.7.1.1

