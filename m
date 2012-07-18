Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab2GRGaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 02:30:08 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18674 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2GRG3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 02:29:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 17 Jul 2012 23:25:43 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>,
        <sameo@linux.intel.com>, <swarren@nvidia.com>,
        <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 1/6] mfd: tps6586x:use devm managed resources
Date: Wed, 18 Jul 2012 11:50:45 +0530
Message-ID: <1342592450-12488-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1342592450-12488-1-git-send-email-ldewangan@nvidia.com>
References: <1342592450-12488-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate memory for device state using devm_kzalloc()
to simplify accounting and letting the kernel do the
garbage-collection.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes V1 -> V2:
No change, generated new patch for V2 series.

Changes V2->V3:
Revert the request registration through devm_* and use the normal api.

 drivers/mfd/tps6586x.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index c84b550..c103ea9 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
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
@@ -594,7 +596,7 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
 					pdata->irq_base);
 		if (ret) {
 			dev_err(&client->dev, "IRQ init failed: %d\n", ret);
-			goto err_irq_init;
+			return ret;
 		}
 	}
 
@@ -622,8 +624,7 @@ err_add_devs:
 err_gpio_init:
 	if (client->irq)
 		free_irq(client->irq, tps6586x);
-err_irq_init:
-	kfree(tps6586x);
+
 	return ret;
 }
 
@@ -644,7 +645,6 @@ static int __devexit tps6586x_i2c_remove(struct i2c_client *client)
 	}
 
 	tps6586x_remove_subdevs(tps6586x);
-	kfree(tps6586x);
 	return 0;
 }
 
-- 
1.7.1.1

