Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab1JXRGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 13:06:38 -0400
Received: from mail.fuel7.com ([74.222.0.51]:42654 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933080Ab1JXRGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 13:06:34 -0400
From: Kyle Manna <kyle.manna@fuel7.com>
To: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Kyle Manna <kyle.manna@fuel7.com>
Subject: [PATCH v2 6/6] mfd: TPS65910: Create an array for reg init data
Date: Mon, 24 Oct 2011 12:06:04 -0500
Message-Id: <1319475964-10841-7-git-send-email-kyle.manna@fuel7.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319475964-10841-1-git-send-email-kyle.manna@fuel7.com>
References: <1319475964-10841-1-git-send-email-kyle.manna@fuel7.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create an array of fixed size for the platform to pass regulator
initalization data through.

Passing an array of pointers to init data also allows more flexible
definition of init data as well as prevents reading past the end of the
array should the platform define an incorrectly sized array.

Signed-off-by: Kyle Manna <kyle.manna@fuel7.com>
---
 drivers/regulator/tps65910-regulator.c |   13 ++++++++++---
 include/linux/mfd/tps65910.h           |    5 ++++-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 44b4f22..a620e25 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -861,8 +861,6 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 	if (!pmic_plat_data)
 		return -EINVAL;
 
-	reg_data = pmic_plat_data->tps65910_pmic_init_data;
-
 	pmic = kzalloc(sizeof(*pmic), GFP_KERNEL);
 	if (!pmic)
 		return -ENOMEM;
@@ -913,7 +911,16 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		goto err_free_info;
 	}
 
-	for (i = 0; i < pmic->num_regulators; i++, info++, reg_data++) {
+	for (i = 0; i < pmic->num_regulators && i < TPS65910_NUM_REGS;
+			i++, info++) {
+
+		reg_data = pmic_plat_data->tps65910_pmic_init_data[i];
+
+		/* Regulator API handles empty constraints but not NULL
+		 * constraints */
+		if (!reg_data)
+			continue;
+
 		/* Register the regulators */
 		pmic->info[i] = info;
 
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 84108bb..207b8b2 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -771,6 +771,9 @@
 #define TPS65911_REG_LDO7				11
 #define TPS65911_REG_LDO8				12
 
+/* Max number of TPS65910/11 regulators */
+#define TPS65910_NUM_REGS				13
+
 /**
  * struct tps65910_board
  * Board platform data may be used to initialize regulators.
@@ -782,7 +785,7 @@ struct tps65910_board {
 	int irq_base;
 	int vmbch_threshold;
 	int vmbch2_threshold;
-	struct regulator_init_data *tps65910_pmic_init_data;
+	struct regulator_init_data *tps65910_pmic_init_data[TPS65910_NUM_REGS];
 };
 
 /**
-- 
1.7.5.4

