Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934483Ab2DLPke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 11:40:34 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65412 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367Ab2DLPkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 11:40:31 -0400
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, broonie@opensource.wolfsonmicro.com,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>
Subject: [PATCH 2/2] regulator: da9052: add device tree support
Date: Thu, 12 Apr 2012 23:39:42 +0800
Message-Id: <1334245182-31725-2-git-send-email-paul.liu@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334245182-31725-1-git-send-email-paul.liu@linaro.org>
References: <1334245182-31725-1-git-send-email-paul.liu@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>

This patch adds device tree support for dialog regulators

Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 drivers/regulator/da9052-regulator.c |   44 +++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 09915e8..892700c 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -19,6 +19,9 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#ifdef CONFIG_OF
+#include <linux/regulator/of_regulator.h>
+#endif
 
 #include <linux/mfd/da9052/da9052.h>
 #include <linux/mfd/da9052/reg.h>
@@ -536,6 +539,7 @@ static int __devinit da9052_regulator_probe(struct platform_device *pdev)
 	struct da9052_regulator *regulator;
 	struct da9052 *da9052;
 	struct da9052_pdata *pdata;
+	struct regulator_init_data *initdata = NULL;
 	int ret;
 
 	regulator = devm_kzalloc(&pdev->dev, sizeof(struct da9052_regulator),
@@ -554,9 +558,47 @@ static int __devinit da9052_regulator_probe(struct platform_device *pdev)
 		ret = -EINVAL;
 		goto err;
 	}
+	if (pdata && pdata->regulators) {
+		initdata = pdata->regulators[pdev->id];
+	} else {
+#ifdef CONFIG_OF
+		struct device_node *nproot = da9052->dev->of_node;
+		struct device_node *np;
+		int c;
+
+		if (!nproot) {
+			ret = -ENODEV;
+			goto err;
+		}
+
+		nproot = of_find_node_by_name(nproot, "regulators");
+		if (!nproot) {
+			ret = -ENODEV;
+			goto err;
+		}
+
+		c = 0;
+		for (np = of_get_next_child(nproot, NULL);
+		     np != NULL;
+		     np = of_get_next_child(nproot, np)) {
+			if (c == pdev->id) {
+				initdata = of_get_regulator_init_data(
+					&pdev->dev, np);
+				break;
+			}
+			c++;
+		}
+#endif
+	}
+
+	if (!initdata) {
+		dev_err(&pdev->dev, "no initdata\n");
+		ret = -ENODEV;
+		goto err;
+	}
 	regulator->rdev = regulator_register(&regulator->info->reg_desc,
 					     &pdev->dev,
-					     pdata->regulators[pdev->id],
+					     initdata,
 					     regulator, NULL);
 	if (IS_ERR(regulator->rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
-- 
1.7.9.5

