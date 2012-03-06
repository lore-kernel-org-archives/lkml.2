Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030616Ab2CFMfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:35:41 -0500
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:54264 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030583Ab2CFMfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:35:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of peter.ujfalusi@ti.com designates 10.152.130.102 as permitted sender) smtp.mail=peter.ujfalusi@ti.com
MIME-Version: 1.0
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Tony Lindgren <tony@atomide.com>, Liam Girdwood <lrg@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-next@vger.kernel.org, paul.gortmaker@windriver.com
Subject: [PATCH 2/5] Revert "mfd: Add regulator support for twl6040 VIO, V2V1 supplies"
Date: Tue,  6 Mar 2012 14:35:13 +0200
Message-Id: <1331037316-7375-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1331037316-7375-1-git-send-email-peter.ujfalusi@ti.com>
References: <1331037316-7375-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit c04eaf3db0589e7c9f13c992a871ae2b2eb73f4f.

Reverting changes regarding to twl6040 in MFD tree since the patches will go
via the audio tree.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c  |   41 ++++-------------------------------------
 include/linux/mfd/twl6040.h |    2 --
 2 files changed, 4 insertions(+), 39 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 58c95b4..2d6beda 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -27,7 +27,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
-#include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
@@ -36,10 +35,8 @@
 #include <linux/err.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/twl6040.h>
-#include <linux/regulator/consumer.h>
 
 #define VIBRACTRL_MEMBER(reg) ((reg == TWL6040_REG_VIBCTLL) ? 0 : 1)
-#define TWL6040_NUM_SUPPLIES	(2)
 
 int twl6040_reg_read(struct twl6040 *twl6040, unsigned int reg)
 {
@@ -527,14 +524,6 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 		goto err;
 	}
 
-	twl6040->supplies = devm_kzalloc(&client->dev,
-					 sizeof(struct regulator_bulk_data) *
-					 TWL6040_NUM_SUPPLIES, GFP_KERNEL);
-	if (!twl6040->supplies) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
 	twl6040->regmap = regmap_init_i2c(client, &twl6040_regmap_config);
 	if (IS_ERR(twl6040->regmap)) {
 		ret = PTR_ERR(twl6040->regmap);
@@ -543,21 +532,6 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, twl6040);
 
-	twl6040->supplies[0].supply = "vio";
-	twl6040->supplies[1].supply = "v2v1";
-	ret = regulator_bulk_get(&client->dev, TWL6040_NUM_SUPPLIES,
-				 twl6040->supplies);
-	if (ret != 0) {
-		dev_err(&client->dev, "Failed to get supplies: %d\n", ret);
-		goto regulator_get_err;
-	}
-
-	ret = regulator_bulk_enable(TWL6040_NUM_SUPPLIES, twl6040->supplies);
-	if (ret != 0) {
-		dev_err(&client->dev, "Failed to enable supplies: %d\n", ret);
-		goto power_err;
-	}
-
 	twl6040->dev = &client->dev;
 	twl6040->irq = client->irq;
 	twl6040->irq_base = pdata->irq_base;
@@ -578,13 +552,13 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 		ret = gpio_request_one(twl6040->audpwron, GPIOF_OUT_INIT_LOW,
 				       "audpwron");
 		if (ret)
-			goto gpio_err;
+			goto gpio1_err;
 	}
 
 	/* codec interrupt */
 	ret = twl6040_irq_init(twl6040);
 	if (ret)
-		goto irq_init_err;
+		goto gpio2_err;
 
 	ret = request_threaded_irq(twl6040->irq_base + TWL6040_IRQ_READY,
 				   NULL, twl6040_naudint_handler, 0,
@@ -644,14 +618,10 @@ mfd_err:
 	free_irq(twl6040->irq_base + TWL6040_IRQ_READY, twl6040);
 irq_err:
 	twl6040_irq_exit(twl6040);
-irq_init_err:
+gpio2_err:
 	if (gpio_is_valid(twl6040->audpwron))
 		gpio_free(twl6040->audpwron);
-gpio_err:
-	regulator_bulk_disable(TWL6040_NUM_SUPPLIES, twl6040->supplies);
-power_err:
-	regulator_bulk_free(TWL6040_NUM_SUPPLIES, twl6040->supplies);
-regulator_get_err:
+gpio1_err:
 	i2c_set_clientdata(client, NULL);
 	regmap_exit(twl6040->regmap);
 err:
@@ -675,9 +645,6 @@ static int __devexit twl6040_remove(struct i2c_client *client)
 	i2c_set_clientdata(client, NULL);
 	regmap_exit(twl6040->regmap);
 
-	regulator_bulk_disable(TWL6040_NUM_SUPPLIES, twl6040->supplies);
-	regulator_bulk_free(TWL6040_NUM_SUPPLIES, twl6040->supplies);
-
 	return 0;
 }
 
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index bf3931e..b15b5f0 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -199,12 +199,10 @@ struct twl6040_platform_data {
 };
 
 struct regmap;
-struct regulator_bulk_data;
 
 struct twl6040 {
 	struct device *dev;
 	struct regmap *regmap;
-	struct regulator_bulk_data *supplies; /* supplies for vio, v2v1 */
 	struct mutex mutex;
 	struct mutex io_mutex;
 	struct mutex irq_mutex;
-- 
1.7.8.5

