Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab1G0Kdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 06:33:37 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:65102 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab1G0KdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 06:33:10 -0400
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>
Subject: [PATCH 3/3] regulator: tps65023: Added support for the similiar TPS65020 chip
Date: Wed, 27 Jul 2011 12:32:47 +0200
Message-Id: <1311762767-20263-4-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311762767-20263-1-git-send-email-marcus.folkesson@gmail.com>
References: <marcus.folkesson@gmail.com>
 <1311762767-20263-1-git-send-email-marcus.folkesson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defines a new voltage-table and allows registering of the tps65020 device.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---
 drivers/regulator/tps65023-regulator.c |   63 ++++++++++++++++++++++++++++++++
 1 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 5cc7344..a4c0583 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -103,8 +103,26 @@ static const u16 VCORE_VSEL_table[] = {
 	1500, 1525, 1550, 1600,
 };
 
+/* Supported voltage values for LDO regulators for tps65020 */
+static const u16 TPS65020_LDO1_VSEL_table[] = {
+	1000, 1050, 1100, 1300,
+	1800, 2500, 3000, 3300,
+};
+
+static const u16 TPS65020_LDO2_VSEL_table[] = {
+	1000, 1050, 1100, 1300,
+	1800, 2500, 3000, 3300,
+};
 
 
+static unsigned int tps65020_num_voltages[] = {
+				0,
+				0,
+				ARRAY_SIZE(VCORE_VSEL_table),
+				ARRAY_SIZE(TPS65020_LDO1_VSEL_table),
+				ARRAY_SIZE(TPS65020_LDO2_VSEL_table)
+};
+
 /* Supported voltage values for LDO regulators
  * for tps65021 and tps65023 */
 static const u16 TPS65023_LDO1_VSEL_table[] = {
@@ -553,6 +571,43 @@ static int __devexit tps_65023_remove(struct i2c_client *client)
 	return 0;
 }
 
+static const struct tps_info tps65020_regs[] = {
+	{
+		.name = "VDCDC1",
+		.min_uV = 3300000,
+		.max_uV = 3300000,
+		.fixed	= 1,
+	},
+	{
+		.name = "VDCDC2",
+		.min_uV =  1800000,
+		.max_uV = 1800000,
+		.fixed = 1,
+	},
+	{
+		.name = "VDCDC3",
+		.min_uV =  800000,
+		.max_uV = 1600000,
+		.table_len = ARRAY_SIZE(VCORE_VSEL_table),
+		.table = VCORE_VSEL_table,
+	},
+
+	{
+		.name = "LDO1",
+		.min_uV = 1000000,
+		.max_uV = 3150000,
+		.table_len = ARRAY_SIZE(TPS65020_LDO1_VSEL_table),
+		.table = TPS65020_LDO1_VSEL_table,
+	},
+	{
+		.name = "LDO2",
+		.min_uV = 1050000,
+		.max_uV = 3300000,
+		.table_len = ARRAY_SIZE(TPS65020_LDO2_VSEL_table),
+		.table = TPS65020_LDO2_VSEL_table,
+	},
+};
+
 static const struct tps_info tps65021_regs[] = {
 	{
 		.name = "VDCDC1",
@@ -625,6 +680,12 @@ static const struct tps_info tps65023_regs[] = {
 	},
 };
 
+static struct tps_driver_data tps65020_drv_data = {
+		.info = (struct tps_info *) tps65020_regs,
+		.core_regulator = TPS65023_DCDC_3,
+		.num_voltages = tps65020_num_voltages,
+};
+
 static struct tps_driver_data tps65021_drv_data = {
 		.info = (struct tps_info *) tps65021_regs,
 		.core_regulator = TPS65023_DCDC_3,
@@ -642,6 +703,8 @@ static const struct i2c_device_id tps_65023_id[] = {
 	.driver_data = (unsigned long) &tps65023_drv_data},
 	{.name = "tps65021",
 	.driver_data = (unsigned long) &tps65021_drv_data,},
+	{.name = "tps65020",
+	.driver_data = (unsigned long) &tps65020_drv_data},
 	{ },
 };
 
-- 
1.7.4.1

