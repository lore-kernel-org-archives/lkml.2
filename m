Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302Ab2DKPIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:08:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52515 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab2DKPId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:08:33 -0400
Message-ID: <1334156907.4819.3.camel@phoenix>
Subject: [PATCH 3/3] regulator: max8660: Use devm_kzalloc()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 11 Apr 2012 23:08:27 +0800
In-Reply-To: <1334156749.4819.0.camel@phoenix>
References: <1334156749.4819.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8660.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index 88f678e..9997cfb 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -367,16 +367,14 @@ static int __devinit max8660_probe(struct i2c_client *client,
 
 	if (pdata->num_subdevs > MAX8660_V_END) {
 		dev_err(&client->dev, "Too many regulators found!\n");
-		goto out;
+		return -EINVAL;
 	}
 
 	max8660 = kzalloc(sizeof(struct max8660) +
 			sizeof(struct regulator_dev *) * MAX8660_V_END,
 			GFP_KERNEL);
-	if (!max8660) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!max8660)
+		return -ENOMEM;
 
 	max8660->client = client;
 	rdev = max8660->rdev;
@@ -405,7 +403,7 @@ static int __devinit max8660_probe(struct i2c_client *client,
 	for (i = 0; i < pdata->num_subdevs; i++) {
 
 		if (!pdata->subdevs[i].platform_data)
-			goto err_free;
+			goto err_out;
 
 		boot_on = pdata->subdevs[i].platform_data->constraints.boot_on;
 
@@ -431,7 +429,7 @@ static int __devinit max8660_probe(struct i2c_client *client,
 		case MAX8660_V7:
 			if (!strcmp(i2c_id->name, "max8661")) {
 				dev_err(&client->dev, "Regulator not on this chip!\n");
-				goto err_free;
+				goto err_out;
 			}
 
 			if (boot_on)
@@ -441,7 +439,7 @@ static int __devinit max8660_probe(struct i2c_client *client,
 		default:
 			dev_err(&client->dev, "invalid regulator %s\n",
 				 pdata->subdevs[i].name);
-			goto err_free;
+			goto err_out;
 		}
 	}
 
@@ -469,9 +467,7 @@ static int __devinit max8660_probe(struct i2c_client *client,
 err_unregister:
 	while (--i >= 0)
 		regulator_unregister(rdev[i]);
-err_free:
-	kfree(max8660);
-out:
+err_out:
 	return ret;
 }
 
@@ -483,8 +479,6 @@ static int __devexit max8660_remove(struct i2c_client *client)
 	for (i = 0; i < MAX8660_V_END; i++)
 		if (max8660->rdev[i])
 			regulator_unregister(max8660->rdev[i]);
-	kfree(max8660);
-
 	return 0;
 }
 
-- 
1.7.5.4



