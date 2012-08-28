Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab2H1Kum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 06:50:42 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18836 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab2H1Kul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 06:50:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 28 Aug 2012 03:50:35 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <sameo@linux.intel.com>,
        <lrg@ti.com>
CC: <swarren@wwwdotorg.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: tps6586x: register regulator even if no init data
Date: Tue, 28 Aug 2012 15:59:26 +0530
Message-ID: <1346149767-31602-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register all TPS6586x regulators even if there is no regulator
init data for platform i.e. without any user-supplied constraints.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This patch make sure that all chip regulators get registered
even there is no user-supplied.
This is based on discussion on following patch about registering
rails without init data.
	max8907: fix use of possibly NULL idata

 drivers/mfd/tps6586x.c                 |   16 ++++++++--------
 drivers/regulator/tps6586x-regulator.c |    3 +++
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 380a3c8..f5dac8a 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -396,19 +396,19 @@ static struct tps6586x_platform_data *tps6586x_parse_dt(struct i2c_client *clien
 	for (i = 0, j = 0; i < num && j < count; i++) {
 		struct regulator_init_data *reg_idata;
 
-		if (!tps6586x_matches[i].init_data)
-			continue;
-
 		reg_idata  = tps6586x_matches[i].init_data;
 		devs[j].name = "tps6586x-regulator";
 		devs[j].platform_data = tps6586x_matches[i].init_data;
 		devs[j].id = (int)tps6586x_matches[i].driver_data;
-		if (devs[j].id == TPS6586X_ID_SYS)
-			sys_rail_name = reg_idata->constraints.name;
 
-		if ((devs[j].id == TPS6586X_ID_LDO_5) ||
-			(devs[j].id == TPS6586X_ID_LDO_RTC))
-			reg_idata->supply_regulator = sys_rail_name;
+		if (tps6586x_matches[i].init_data) {
+			if (devs[j].id == TPS6586X_ID_SYS)
+				sys_rail_name = reg_idata->constraints.name;
+
+			if ((devs[j].id == TPS6586X_ID_LDO_5) ||
+				(devs[j].id == TPS6586X_ID_LDO_RTC))
+				reg_idata->supply_regulator = sys_rail_name;
+		}
 
 		devs[j].of_node = tps6586x_matches[i].of_node;
 		j++;
diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index ce1e7cb..4508222 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -332,6 +332,9 @@ static int __devinit tps6586x_regulator_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, rdev);
 
+	if (!pdev->dev.platform_data)
+		return 0;
+
 	return tps6586x_regulator_set_slew_rate(pdev);
 }
 
-- 
1.7.1.1

