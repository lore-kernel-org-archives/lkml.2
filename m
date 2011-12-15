Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841Ab1LONcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 08:32:55 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:23024
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022Ab1LONcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 08:32:54 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-FB-SS: 0,13,
Subject: [Patch] Regulator: Replace kzalloc with devm_kzalloc and if-else
 with a switch-case for da9052-regulator
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linaro-dev@lists.linaro.org>, <lrg@slimlogic.co.uk>,
        <linux-kernel@vger.kernel.org>, Dajun <dajun.chen@diasemi.com>,
        <paul.liu@linaro.org>, <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 18:59:53 +0530
Message-ID: <1323955793.32031.88.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 drivers/regulator/da9052-regulator.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)
diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 9fff281..37a20c1 100755
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -505,18 +505,23 @@ static inline struct da9052_regulator_info *find_regulator_info(u8 chip_id,
 	struct da9052_regulator_info *info;
 	int i;
 
-	if (chip_id == DA9052) {
+	switch (chip_id) {
+	case DA9052:
 		for (i = 0; i < ARRAY_SIZE(da9052_regulator_info); i++) {
 			info = &da9052_regulator_info[i];
 			if (info->reg_desc.id == id)
 				return info;
 		}
-	} else {
+		break;
+	case DA9053_AA:
+	case DA9053_BA:
+	case DA9053_BB:
 		for (i = 0; i < ARRAY_SIZE(da9053_regulator_info); i++) {
 			info = &da9053_regulator_info[i];
 			if (info->reg_desc.id == id)
 				return info;
 		}
+		break;
 	}
 
 	return NULL;
@@ -529,7 +534,8 @@ static int __devinit da9052_regulator_probe(struct platform_device *pdev)
 	struct da9052_pdata *pdata;
 	int ret;
 
-	regulator = kzalloc(sizeof(struct da9052_regulator), GFP_KERNEL);
+	regulator = devm_kzalloc(&pdev->dev, sizeof(struct da9052_regulator),
+				 GFP_KERNEL);
 	if (!regulator)
 		return -ENOMEM;
 
@@ -559,7 +565,7 @@ static int __devinit da9052_regulator_probe(struct platform_device *pdev)
 
 	return 0;
 err:
-	kfree(regulator);
+	devm_kfree(&pdev->dev, regulator);
 	return ret;
 }
 
@@ -568,7 +574,7 @@ static int __devexit da9052_regulator_remove(struct platform_device *pdev)
 	struct da9052_regulator *regulator = platform_get_drvdata(pdev);
 
 	regulator_unregister(regulator->rdev);
-	kfree(regulator);
+	devm_kfree(&pdev->dev, regulator);
 
 	return 0;
 }


