Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab2H2PWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 11:22:52 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6444 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab2H2PWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 11:22:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 29 Aug 2012 08:22:40 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2] regulator: tps6586x: register regulator even if no init data
Date: Wed, 29 Aug 2012 20:31:13 +0530
Message-ID: <1346252473-30068-1-git-send-email-ldewangan@nvidia.com>
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
Changes from V1:
Stephen pointed out that the pointer in if should be same what it
is used inside the if statements.
Making the change to address this.

 drivers/mfd/tps6586x.c                 |   16 ++++++++--------
 drivers/regulator/tps6586x-regulator.c |    3 +++
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 380a3c8..4a91a62 100644
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
+		if (reg_idata) {
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

