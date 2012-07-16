Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab2GPHBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 03:01:25 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6368 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2GPHBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 03:01:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 16 Jul 2012 00:01:09 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>,
        <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 1/6] mfd: tps6586x:use devm managed resources
Date: Mon, 16 Jul 2012 12:21:45 +0530
Message-ID: <1342421510-10638-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1342421510-10638-1-git-send-email-ldewangan@nvidia.com>
References: <1342421510-10638-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate memory for device state using devm_kzalloc(), get the
IRQ using devm_request_irq().
All to simplify accounting and letting the kernel do the
garbage-collection.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes V1 -> V2:
No change, generated new patch for V2 series.

 drivers/mfd/tps6586x.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index c84b550..1256b7f 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -432,8 +432,8 @@ static int __devinit tps6586x_irq_init(struct tps6586x *tps6586x, int irq,
 #endif
 	}
 
-	ret = request_threaded_irq(irq, NULL, tps6586x_irq, IRQF_ONESHOT,
-				   "tps6586x", tps6586x);
+	ret = devm_request_threaded_irq(tps6586x->dev, irq, NULL, tps6586x_irq,
+			IRQF_ONESHOT, "tps6586x", tps6586x);
 
 	if (!ret) {
 		device_init_wakeup(tps6586x->dev, 1);
@@ -579,9 +579,11 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
 
 	dev_info(&client->dev, "VERSIONCRC is %02x\n", ret);
 
-	tps6586x = kzalloc(sizeof(struct tps6586x), GFP_KERNEL);
-	if (tps6586x == NULL)
+	tps6586x = devm_kzalloc(&client->dev, sizeof(*tps6586x), GFP_KERNEL);
+	if (tps6586x == NULL) {
+		dev_err(&client->dev, "memory for tps6586x alloc failed\n");
 		return -ENOMEM;
+	}
 
 	tps6586x->client = client;
 	tps6586x->dev = &client->dev;
@@ -594,14 +596,14 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
 					pdata->irq_base);
 		if (ret) {
 			dev_err(&client->dev, "IRQ init failed: %d\n", ret);
-			goto err_irq_init;
+			return ret;
 		}
 	}
 
 	ret = tps6586x_gpio_init(tps6586x, pdata->gpio_base);
 	if (ret) {
 		dev_err(&client->dev, "GPIO registration failed: %d\n", ret);
-		goto err_gpio_init;
+		return ret;
 	}
 
 	ret = tps6586x_add_subdevs(tps6586x, pdata);
@@ -619,11 +621,6 @@ err_add_devs:
 			dev_err(&client->dev, "Can't remove gpio chip: %d\n",
 				ret);
 	}
-err_gpio_init:
-	if (client->irq)
-		free_irq(client->irq, tps6586x);
-err_irq_init:
-	kfree(tps6586x);
 	return ret;
 }
 
@@ -633,9 +630,6 @@ static int __devexit tps6586x_i2c_remove(struct i2c_client *client)
 	struct tps6586x_platform_data *pdata = client->dev.platform_data;
 	int ret;
 
-	if (client->irq)
-		free_irq(client->irq, tps6586x);
-
 	if (pdata->gpio_base) {
 		ret = gpiochip_remove(&tps6586x->gpio);
 		if (ret)
@@ -644,7 +638,6 @@ static int __devexit tps6586x_i2c_remove(struct i2c_client *client)
 	}
 
 	tps6586x_remove_subdevs(tps6586x);
-	kfree(tps6586x);
 	return 0;
 }
 
-- 
1.7.1.1

