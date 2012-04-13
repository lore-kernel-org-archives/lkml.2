Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab2DMNiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 09:38:11 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:46179 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696Ab2DMNiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 09:38:07 -0400
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>
Subject: [PATCH v2 2/2] regulator: da9052: add device tree support
Date: Fri, 13 Apr 2012 21:37:41 +0800
Message-Id: <1334324261-5476-2-git-send-email-paul.liu@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334324261-5476-1-git-send-email-paul.liu@linaro.org>
References: <1334324261-5476-1-git-send-email-paul.liu@linaro.org>
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
 drivers/regulator/da9052-regulator.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index b6c8c4b..2678cbe 100644
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
@@ -425,8 +428,32 @@ static int __devinit da9052_regulator_probe(struct platform_device *pdev)
 	}
 
 	config.dev = &pdev->dev;
-	config.init_data = pdata->regulators[pdev->id];
 	config.driver_data = regulator;
+	if (pdata && pdata->regulators) {
+		config.init_data = pdata->regulators[pdev->id];
+	} else {
+#ifdef CONFIG_OF
+		struct device_node *nproot = da9052->dev->of_node;
+		struct device_node *np;
+
+		if (!nproot)
+			return -ENODEV;
+
+		nproot = of_find_node_by_name(nproot, "regulators");
+		if (!nproot)
+			return -ENODEV;
+
+		for (np = of_get_next_child(nproot, NULL); !np;
+		     np = of_get_next_child(nproot, np)) {
+			if (!of_node_cmp(np->name,
+					 regulator->info->reg_desc.name)) {
+				config.init_data = of_get_regulator_init_data(
+					&pdev->dev, np);
+				break;
+			}
+		}
+#endif
+	}
 
 	regulator->rdev = regulator_register(&regulator->info->reg_desc,
 					     &config);
-- 
1.7.9.5

