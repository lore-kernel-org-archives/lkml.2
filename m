Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab2HTPjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:39:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41562 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2HTPjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:39:31 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, Axel Lin <axel.lin@gmail.com>,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] regulator: max8907: fix compile error when !CONFIG_OF
Date: Mon, 20 Aug 2012 09:39:10 -0600
Message-Id: <1345477150-25933-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Fix the following:

  CC [M]  drivers/regulator/max8907-regulator.o
drivers/regulator/max8907-regulator.c: In function 'max8907_regulator_probe':
drivers/regulator/max8907-regulator.c:297:12: error: 'max8907_matches' undeclared (first use in this function)

by removing direct references to max8907_matches[], which only exists when
CONFIG_OF is defined.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Note: It's possible that the MAX8907 PMIC is only used with Tegra; there
certainly is a reference to AP15 (an old Tegra version) in the MAX8907
documentation. If so, Tegra implies CONFIG_OF, so we could just make
MAX8907 depend on CONFIG_OF and remove all the ifdefs from the driver.
That said, I'm not at all sure whether the MAX8907 is Tegra-specific.
---
 drivers/regulator/max8907-regulator.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max8907-regulator.c b/drivers/regulator/max8907-regulator.c
index 831488f..0d03e71 100644
--- a/drivers/regulator/max8907-regulator.c
+++ b/drivers/regulator/max8907-regulator.c
@@ -248,11 +248,31 @@ static int max8907_regulator_parse_dt(struct platform_device *pdev)
 
 	return 0;
 }
+
+static inline struct regulator_init_data *match_init_data(int index)
+{
+	return max8907_matches[index].init_data;
+}
+
+static inline struct device_node *match_of_node(int index)
+{
+	return max8907_matches[index].of_node;
+}
 #else
 static int max8907_regulator_parse_dt(struct platform_device *pdev)
 {
 	return 0;
 }
+
+static inline struct regulator_init_data *match_init_data(int index)
+{
+	return NULL;
+}
+
+static inline struct device_node *match_of_node(int index)
+{
+	return NULL;
+}
 #endif
 
 static __devinit int max8907_regulator_probe(struct platform_device *pdev)
@@ -294,11 +314,11 @@ static __devinit int max8907_regulator_probe(struct platform_device *pdev)
 		if (pdata)
 			idata = pdata->init_data[i];
 		else
-			idata = max8907_matches[i].init_data;
+			idata = match_init_data(i);
 		config.init_data = idata;
 		config.driver_data = pmic;
 		config.regmap = max8907->regmap_gen;
-		config.of_node = max8907_matches[i].of_node;
+		config.of_node = match_of_node(i);
 
 		switch (pmic->desc[i].id) {
 		case MAX8907_MBATT:
-- 
1.7.0.4

