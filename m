Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab1ELFr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 01:47:58 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58741 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab1ELFr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 01:47:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=nV5JaSkA39+Qm8NnDrtCL+rqH4JhfUHgVah/Q7ijhVP6jqAgw6kx+OgCsRirp/QsRO
         kQUmtqnh8hi8TbTRWYw3AUwaYIpBNZIcFBv4Z+VGIzZV9E3eXH7vxuBod8DXfVsIhuSf
         8gmHSJJaChdRpj6EOh/ZoXnTSl3PSbPC4ea78=
Subject: [PATCH] regulator: Fix desc_id for tps65023/6507x/65910
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 13:47:50 +0800
Message-ID: <1305179270.11113.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The desc_id variable should not be a static variable.

The rest of the code assumes the desc_id must less than TPSxxxxx_NUM_REGULATOR.
If we set desc_id to be a static variable, checking the return value of
rdev_get_id() may return error.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/regulator/tps65023-regulator.c |    3 +--
 drivers/regulator/tps6507x-regulator.c |    3 +--
 drivers/regulator/tps65910-regulator.c |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 60a7ca5..fbddc15 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -466,7 +466,6 @@ static struct regulator_ops tps65023_ldo_ops = {
 static int __devinit tps_65023_probe(struct i2c_client *client,
 				     const struct i2c_device_id *id)
 {
-	static int desc_id;
 	const struct tps_info *info = (void *)id->driver_data;
 	struct regulator_init_data *init_data;
 	struct regulator_dev *rdev;
@@ -499,7 +498,7 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 		tps->info[i] = info;
 
 		tps->desc[i].name = info->name;
-		tps->desc[i].id = desc_id++;
+		tps->desc[i].id = i;
 		tps->desc[i].n_voltages = num_voltages[i];
 		tps->desc[i].ops = (i > TPS65023_DCDC_3 ?
 					&tps65023_ldo_ops : &tps65023_dcdc_ops);
diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 0647552..bfffabc 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -553,7 +553,6 @@ static __devinit
 int tps6507x_pmic_probe(struct platform_device *pdev)
 {
 	struct tps6507x_dev *tps6507x_dev = dev_get_drvdata(pdev->dev.parent);
-	static int desc_id;
 	struct tps_info *info = &tps6507x_pmic_regs[0];
 	struct regulator_init_data *init_data;
 	struct regulator_dev *rdev;
@@ -598,7 +597,7 @@ int tps6507x_pmic_probe(struct platform_device *pdev)
 		}
 
 		tps->desc[i].name = info->name;
-		tps->desc[i].id = desc_id++;
+		tps->desc[i].id = i;
 		tps->desc[i].n_voltages = num_voltages[i];
 		tps->desc[i].ops = (i > TPS6507X_DCDC_3 ?
 		&tps6507x_pmic_ldo_ops : &tps6507x_pmic_dcdc_ops);
diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index d461fa7..048ba47 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -604,7 +604,6 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 	struct regulator_dev *rdev;
 	struct tps65910_reg *pmic;
 	struct tps65910_board *pmic_plat_data;
-	static int desc_id;
 	int i, err;
 
 	pmic_plat_data = dev_get_platdata(tps65910->dev);
@@ -630,7 +629,7 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		pmic->info[i] = info;
 
 		pmic->desc[i].name = info->name;
-		pmic->desc[i].id = desc_id++;
+		pmic->desc[i].id = i;
 		pmic->desc[i].n_voltages = info->table_len;
 
 		if ((i == TPS65910_REG_VDD1) || (i == TPS65910_REG_VDD2))
-- 
1.7.1



