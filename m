Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab2EBNy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 09:54:59 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:48739 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698Ab2EBNy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 09:54:58 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH] MFD: twl6040: Add regulator support for VIO, V2V1 supplies
Date: Wed,  2 May 2012 16:54:42 +0300
Message-Id: <1335966882-19897-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
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

Hi Samuel,

The runtime dependencies for this patch has been sent to linux-omap list:
http://marc.info/?l=linux-omap&m=133596645010228&w=2
http://marc.info/?l=linux-omap&m=133596645610232&w=2
http://marc.info/?l=linux-omap&m=133596644310224&w=2
http://marc.info/?l=linux-omap&m=133596643310220&w=2

Alone this patch does not cause compile time regression but in runtime it needs
the arch/arm/mach-omap2 patches.
I try to avoid cross tree issues as much as I can and I'm happy if these will
come together in linux-next (and finally in 3.5).

Regards,
Peter

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 493f4a6..7a92d95 100644
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
@@ -532,6 +535,21 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 
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
@@ -552,13 +570,13 @@ static int __devinit twl6040_probe(struct i2c_client *client,
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
@@ -618,10 +636,14 @@ mfd_err:
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
 err:
 	return ret;
@@ -643,6 +665,9 @@ static int __devexit twl6040_remove(struct i2c_client *client)
 	mfd_remove_devices(&client->dev);
 	i2c_set_clientdata(client, NULL);
 
+	regulator_bulk_disable(TWL6040_NUM_SUPPLIES, twl6040->supplies);
+	regulator_bulk_free(TWL6040_NUM_SUPPLIES, twl6040->supplies);
+
 	return 0;
 }
 
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index b15b5f0..6659487 100644
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
1.7.8.6

