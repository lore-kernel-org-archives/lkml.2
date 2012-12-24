Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2LXQ2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 11:28:42 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:62751 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2LXQ2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 11:28:41 -0500
Message-ID: <1356366516.17063.5.camel@phoenix>
Subject: [PATCH 2/2] mfd: max77693: Init max77693->dev before using it
From: Axel Lin <axel.lin@ingics.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 25 Dec 2012 00:28:36 +0800
In-Reply-To: <1356365803.17063.0.camel@phoenix>
References: <1356365803.17063.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code uses max77693->dev in the dev_err call before setting it to
&i2c->dev. Fix it.

This patch also includes below cleanups:
 - Move checking pdata earlier and show dev_err if no platform data found.
 - Remove unnecessary err_regmap goto label.
 - Unregister i2c devices if regmap init for muic fails.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/mfd/max77693.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index cc5155e..9e60fed 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -114,35 +114,37 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 	u8 reg_data;
 	int ret = 0;
 
+	if (!pdata) {
+		dev_err(&i2c->dev, "No platform data found.\n");
+		return -EINVAL;
+	}
+
 	max77693 = devm_kzalloc(&i2c->dev,
 			sizeof(struct max77693_dev), GFP_KERNEL);
 	if (max77693 == NULL)
 		return -ENOMEM;
 
-	max77693->regmap = devm_regmap_init_i2c(i2c, &max77693_regmap_config);
-	if (IS_ERR(max77693->regmap)) {
-		ret = PTR_ERR(max77693->regmap);
-		dev_err(max77693->dev,"failed to allocate register map: %d\n",
-				ret);
-		goto err_regmap;
-	}
-
 	i2c_set_clientdata(i2c, max77693);
 	max77693->dev = &i2c->dev;
 	max77693->i2c = i2c;
 	max77693->irq = i2c->irq;
 	max77693->type = id->driver_data;
 
-	if (!pdata)
-		goto err_regmap;
+	max77693->regmap = devm_regmap_init_i2c(i2c, &max77693_regmap_config);
+	if (IS_ERR(max77693->regmap)) {
+		ret = PTR_ERR(max77693->regmap);
+		dev_err(max77693->dev, "failed to allocate register map: %d\n",
+				ret);
+		return ret;
+	}
 
 	max77693->wakeup = pdata->wakeup;
 
-	if (max77693_read_reg(max77693->regmap,
-				MAX77693_PMIC_REG_PMIC_ID2, &reg_data) < 0) {
+	ret = max77693_read_reg(max77693->regmap, MAX77693_PMIC_REG_PMIC_ID2,
+				&reg_data);
+	if (ret < 0) {
 		dev_err(max77693->dev, "device not found on this channel\n");
-		ret = -ENODEV;
-		goto err_regmap;
+		return ret;
 	} else
 		dev_info(max77693->dev, "device ID: 0x%x\n", reg_data);
 
@@ -163,7 +165,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 		ret = PTR_ERR(max77693->regmap_muic);
 		dev_err(max77693->dev,
 			"failed to allocate register map: %d\n", ret);
-		goto err_regmap;
+		goto err_regmap_muic;
 	}
 
 	ret = max77693_irq_init(max77693);
@@ -184,9 +186,9 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 err_mfd:
 	max77693_irq_exit(max77693);
 err_irq:
+err_regmap_muic:
 	i2c_unregister_device(max77693->muic);
 	i2c_unregister_device(max77693->haptic);
-err_regmap:
 	return ret;
 }
 
-- 
1.7.9.5



