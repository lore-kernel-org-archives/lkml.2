Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab2EKBbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 21:31:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39366 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab2EKBbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 21:31:35 -0400
Message-ID: <1336699889.8454.3.camel@phoenix>
Subject: [PATCH 2/2] mfd: pcf50633-core: Convert to use devm_* APIs
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Fri, 11 May 2012 09:31:29 +0800
In-Reply-To: <1336699791.8454.1.camel@phoenix>
References: <1336699791.8454.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/pcf50633-core.c |   36 ++++++++++--------------------------
 1 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 189c2f0..29c122b 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -204,7 +204,7 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 		return -ENOENT;
 	}
 
-	pcf = kzalloc(sizeof(*pcf), GFP_KERNEL);
+	pcf = devm_kzalloc(&client->dev, sizeof(*pcf), GFP_KERNEL);
 	if (!pcf)
 		return -ENOMEM;
 
@@ -212,12 +212,11 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 
 	mutex_init(&pcf->lock);
 
-	pcf->regmap = regmap_init_i2c(client, &pcf50633_regmap_config);
+	pcf->regmap = devm_regmap_init_i2c(client, &pcf50633_regmap_config);
 	if (IS_ERR(pcf->regmap)) {
 		ret = PTR_ERR(pcf->regmap);
-		dev_err(pcf->dev, "Failed to allocate register map: %d\n",
-			ret);
-		goto err_free;
+		dev_err(pcf->dev, "Failed to allocate register map: %d\n", ret);
+		return ret;
 	}
 
 	i2c_set_clientdata(client, pcf);
@@ -228,7 +227,7 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	if (version < 0 || variant < 0) {
 		dev_err(pcf->dev, "Unable to probe pcf50633\n");
 		ret = -ENODEV;
-		goto err_regmap;
+		return ret;
 	}
 
 	dev_info(pcf->dev, "Probed device version %d variant %d\n",
@@ -237,16 +236,11 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	pcf50633_irq_init(pcf, client->irq);
 
 	/* Create sub devices */
-	pcf50633_client_dev_register(pcf, "pcf50633-input",
-						&pcf->input_pdev);
-	pcf50633_client_dev_register(pcf, "pcf50633-rtc",
-						&pcf->rtc_pdev);
-	pcf50633_client_dev_register(pcf, "pcf50633-mbc",
-						&pcf->mbc_pdev);
-	pcf50633_client_dev_register(pcf, "pcf50633-adc",
-						&pcf->adc_pdev);
-	pcf50633_client_dev_register(pcf, "pcf50633-backlight",
-						&pcf->bl_pdev);
+	pcf50633_client_dev_register(pcf, "pcf50633-input", &pcf->input_pdev);
+	pcf50633_client_dev_register(pcf, "pcf50633-rtc", &pcf->rtc_pdev);
+	pcf50633_client_dev_register(pcf, "pcf50633-mbc", &pcf->mbc_pdev);
+	pcf50633_client_dev_register(pcf, "pcf50633-adc", &pcf->adc_pdev);
+	pcf50633_client_dev_register(pcf, "pcf50633-backlight", &pcf->bl_pdev);
 
 
 	for (i = 0; i < PCF50633_NUM_REGULATORS; i++) {
@@ -274,13 +268,6 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 		pdata->probe_done(pcf);
 
 	return 0;
-
-err_regmap:
-	regmap_exit(pcf->regmap);
-err_free:
-	kfree(pcf);
-
-	return ret;
 }
 
 static int __devexit pcf50633_remove(struct i2c_client *client)
@@ -300,9 +287,6 @@ static int __devexit pcf50633_remove(struct i2c_client *client)
 	for (i = 0; i < PCF50633_NUM_REGULATORS; i++)
 		platform_device_unregister(pcf->regulator_pdev[i]);
 
-	regmap_exit(pcf->regmap);
-	kfree(pcf);
-
 	return 0;
 }
 
-- 
1.7.5.4



