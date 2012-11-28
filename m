Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab2K1RZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:25:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33054 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752399Ab2K1RZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:25:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/4] regulator: arizona-ldo1: Support DVFS in default constraints
Date: Wed, 28 Nov 2012 17:25:32 +0000
Message-Id: <1354123534-6927-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354123534-6927-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1354123534-6927-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Arizona devices such as the WM5102 can use DVFS on their digital core,
for these devices allow the voltage range to vary in the default setup.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-ldo1.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index 908996a..a1e0451 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -61,6 +61,16 @@ static const struct regulator_desc arizona_ldo1 = {
 	.owner = THIS_MODULE,
 };
 
+static const struct regulator_init_data arizona_ldo1_dvfs = {
+	.constraints = {
+		.min_uV = 1200000,
+		.max_uV = 1800000,
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS |
+				  REGULATOR_CHANGE_VOLTAGE,
+	},
+	.num_consumer_supplies = 1,
+};
+
 static const struct regulator_init_data arizona_ldo1_default = {
 	.constraints = {
 		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
@@ -88,7 +98,15 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 	 * default init_data for it.  This will be overridden with
 	 * platform data if provided.
 	 */
-	ldo1->init_data = arizona_ldo1_default;
+	switch (arizona->type) {
+	case WM5102:
+		ldo1->init_data = arizona_ldo1_dvfs;
+		break;
+	default:
+		ldo1->init_data = arizona_ldo1_default;
+		break;
+	}
+
 	ldo1->init_data.consumer_supplies = &ldo1->supply;
 	ldo1->supply.supply = "DCVDD";
 	ldo1->supply.dev_name = dev_name(arizona->dev);
-- 
1.7.10.4

