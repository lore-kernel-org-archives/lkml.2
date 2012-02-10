Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab2BJKF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 05:05:59 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:52179 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759071Ab2BJKF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 05:05:56 -0500
MIME-Version: 1.0
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 7/7] MFD: TWL6040: Add regulator support for VIO, V2V1 supplies
Date: Fri, 10 Feb 2012 12:05:16 +0200
Message-Id: <1328868316-24749-8-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1328868316-24749-1-git-send-email-peter.ujfalusi@ti.com>
References: <1328868316-24749-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

twl6040 has three power supply source:
VBAT needs to be connected to VBAT, VIO, and V2V1.
Add regulator support for the VIO, V2V1 supplies.
Initially handle the two supply together with bulk commands.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/twl6040-core.c  |   33 +++++++++++++++++++++++++++++----
 include/linux/mfd/twl6040.h |    2 ++
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index ea00c69..566f6e0 100644
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
@@ -506,6 +509,21 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 
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
@@ -526,13 +544,13 @@ static int __devinit twl6040_probe(struct i2c_client *client,
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
@@ -592,10 +610,14 @@ mfd_err:
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
@@ -619,6 +641,9 @@ static int __devexit twl6040_remove(struct i2c_client *client)
 	i2c_set_clientdata(client, NULL);
 	regmap_exit(twl6040->regmap);
 
+	regulator_bulk_disable(TWL6040_NUM_SUPPLIES, twl6040->supplies);
+	regulator_bulk_free(TWL6040_NUM_SUPPLIES, twl6040->supplies);
+
 	return 0;
 }
 
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index e3ff28d..2acdd7d 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -27,6 +27,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/mfd/core.h>
+#include <linux/regulator/consumer.h>
 
 #define TWL6040_REG_ASICID		0x01
 #define TWL6040_REG_ASICREV		0x02
@@ -203,6 +204,7 @@ struct regmap;
 struct twl6040 {
 	struct device *dev;
 	struct regmap *regmap;
+	struct regulator_bulk_data supplies[2]; /* supplies for vio, v2v1 */
 	struct mutex mutex;
 	struct mutex io_mutex;
 	struct mutex irq_mutex;
-- 
1.7.8.4

