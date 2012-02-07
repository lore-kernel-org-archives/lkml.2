Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab2BGNBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:01:53 -0500
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:49708 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756710Ab2BGNBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:01:50 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dtor@mail.ru>
Cc: Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 7/7] MFD: TWL6040: Add regulator support for VIO, V2V1 supplies
Date: Tue,  7 Feb 2012 15:01:18 +0200
Message-Id: <1328619678-26080-8-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1328619678-26080-1-git-send-email-peter.ujfalusi@ti.com>
References: <1328619678-26080-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

twl6040 has three power supply source:
VBAT needs to be connected to VBAT, VIO, and V2V1.
Add regulator support for the VIO, V2V1 supplies.
Initially handle the two supply together with bulk commands.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c  |   41 +++++++++++++++++++++++++++++++++++++----
 include/linux/mfd/twl6040.h |    2 ++
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index ea00c69..15e4487 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -27,6 +27,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
+#include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
@@ -35,8 +36,10 @@
 #include <linux/err.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/twl6040.h>
+#include <linux/regulator/consumer.h>
 
 #define VIBRACTRL_MEMBER(reg) ((reg == TWL6040_REG_VIBCTLL) ? 0 : 1)
+#define TWL6040_NUM_SUPPLIES	(2)
 
 int twl6040_reg_read(struct twl6040 *twl6040, unsigned int reg)
 {
@@ -498,6 +501,14 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 		goto err;
 	}
 
+	twl6040->supplies = devm_kzalloc(&client->dev,
+					 sizeof(struct regulator_bulk_data) *
+					 TWL6040_NUM_SUPPLIES, GFP_KERNEL);
+	if (!twl6040->supplies) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
 	twl6040->regmap = regmap_init_i2c(client, &twl6040_regmap_config);
 	if (IS_ERR(twl6040->regmap)) {
 		ret = PTR_ERR(twl6040->regmap);
@@ -506,6 +517,21 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, twl6040);
 
+	twl6040->supplies[0].supply = "vio";
+	twl6040->supplies[1].supply = "v2v1";
+	ret = regulator_bulk_get(&client->dev, TWL6040_NUM_SUPPLIES,
+				 twl6040->supplies);
+	if (ret != 0) {
+		dev_err(&client->dev, "Failed to get supplies: %d\n", ret);
+		goto regulator_get_err;
+	}
+
+	ret = regulator_bulk_enable(TWL6040_NUM_SUPPLIES, twl6040->supplies);
+	if (ret != 0) {
+		dev_err(&client->dev, "Failed to enable supplies: %d\n", ret);
+		goto power_err;
+	}
+
 	twl6040->dev = &client->dev;
 	twl6040->irq = client->irq;
 	twl6040->irq_base = pdata->irq_base;
@@ -526,13 +552,13 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 		ret = gpio_request_one(twl6040->audpwron, GPIOF_OUT_INIT_LOW,
 				       "audpwron");
 		if (ret)
-			goto gpio1_err;
+			goto gpio_err;
 	}
 
 	/* codec interrupt */
 	ret = twl6040_irq_init(twl6040);
 	if (ret)
-		goto gpio2_err;
+		goto irq_init_err;
 
 	ret = request_threaded_irq(twl6040->irq_base + TWL6040_IRQ_READY,
 				   NULL, twl6040_naudint_handler, 0,
@@ -592,10 +618,14 @@ mfd_err:
 	free_irq(twl6040->irq_base + TWL6040_IRQ_READY, twl6040);
 irq_err:
 	twl6040_irq_exit(twl6040);
-gpio2_err:
+irq_init_err:
 	if (gpio_is_valid(twl6040->audpwron))
 		gpio_free(twl6040->audpwron);
-gpio1_err:
+gpio_err:
+	regulator_bulk_disable(TWL6040_NUM_SUPPLIES, twl6040->supplies);
+power_err:
+	regulator_bulk_free(TWL6040_NUM_SUPPLIES, twl6040->supplies);
+regulator_get_err:
 	i2c_set_clientdata(client, NULL);
 	regmap_exit(twl6040->regmap);
 err:
@@ -619,6 +649,9 @@ static int __devexit twl6040_remove(struct i2c_client *client)
 	i2c_set_clientdata(client, NULL);
 	regmap_exit(twl6040->regmap);
 
+	regulator_bulk_disable(TWL6040_NUM_SUPPLIES, twl6040->supplies);
+	regulator_bulk_free(TWL6040_NUM_SUPPLIES, twl6040->supplies);
+
 	return 0;
 }
 
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index e3ff28d..f75d900 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -199,10 +199,12 @@ struct twl6040_platform_data {
 };
 
 struct regmap;
+struct regulator_bulk_data;
 
 struct twl6040 {
 	struct device *dev;
 	struct regmap *regmap;
+	struct regulator_bulk_data *supplies; /* supplies for vio, v2v1 */
 	struct mutex mutex;
 	struct mutex io_mutex;
 	struct mutex irq_mutex;
-- 
1.7.8.4

