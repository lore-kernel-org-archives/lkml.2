Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab2LJMuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 07:50:11 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:36202 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2LJMuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 07:50:05 -0500
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        amit.kachhap@gmail.com, Thomas Abraham <thomas.abraham@linaro.org>,
        kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org
Subject: [PATCH 1/4] regulator: s5m8767: Fix to work when platform registers less regulators
Date: Mon, 10 Dec 2012 18:19:39 +0530
Message-Id: <1355143782-15133-2-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1355143782-15133-1-git-send-email-amit.daniel@samsung.com>
References: <1355143782-15133-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/regulator/s5m8767.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 2b822be..df0b094 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -168,7 +168,7 @@ static unsigned int s5m8767_opmode_reg[][4] = {
 static int s5m8767_get_register(struct regulator_dev *rdev, int *reg,
 				int *enable_ctrl)
 {
-	int reg_id = rdev_get_id(rdev);
+	int i, reg_id = rdev_get_id(rdev);
 	unsigned int mode;
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
 
@@ -195,8 +195,17 @@ static int s5m8767_get_register(struct regulator_dev *rdev, int *reg,
 		return -EINVAL;
 	}
 
-	mode = s5m8767->opmode[reg_id].mode;
-	*enable_ctrl = s5m8767_opmode_reg[reg_id][mode] << S5M8767_ENCTRL_SHIFT;
+	for (i = 0; i < s5m8767->num_regulators; i++) {
+		if (s5m8767->opmode[i].id == reg_id) {
+			mode = s5m8767->opmode[i].mode;
+			break;
+		}
+	}
+
+	if (i < s5m8767->num_regulators)
+		*enable_ctrl =
+		s5m8767_opmode_reg[reg_id][mode] << S5M8767_ENCTRL_SHIFT;
+
 	return 0;
 }
 
@@ -547,7 +556,7 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 	rdev = s5m8767->rdev;
 	s5m8767->dev = &pdev->dev;
 	s5m8767->iodev = iodev;
-	s5m8767->num_regulators = S5M8767_REG_MAX - 2;
+	s5m8767->num_regulators = pdata->num_regulators;
 	platform_set_drvdata(pdev, s5m8767);
 
 	s5m8767->buck_gpioindex = pdata->buck_default_idx;
-- 
1.7.1

