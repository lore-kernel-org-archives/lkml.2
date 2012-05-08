Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab2EHPn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:43:58 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5651 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab2EHPnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:43:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 08 May 2012 08:43:40 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 3/6 v3] mfd: tps65910: Add device-tree support
Date: Tue, 8 May 2012 11:42:40 -0700
Message-ID: <1336502563-31789-4-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336502563-31789-1-git-send-email-rklein@nvidia.com>
References: <1336502563-31789-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree based initialization support for TI's tps65910 pmic.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 v3: no change since v2.
 v2: split mfd portion into single change to add dt support
     added of_node to config before calling regulator_register
     removed passing pdata to mfd_cell child devices
     removed use_dt_for_init_data flag

 drivers/mfd/tps65910.c |   80 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 79 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index f221153..4b52e95 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -23,6 +23,7 @@
 #include <linux/mfd/core.h>
 #include <linux/regmap.h>
 #include <linux/mfd/tps65910.h>
+#include <linux/of_device.h>
 
 static struct mfd_cell tps65910s[] = {
 	{
@@ -129,6 +130,77 @@ err_sleep_init:
 	return ret;
 }
 
+#ifdef CONFIG_OF
+static struct of_device_id tps65910_of_match[] = {
+	{ .compatible = "ti,tps65910", .data = (void *)TPS65910},
+	{ .compatible = "ti,tps65911", .data = (void *)TPS65911},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, tps65910_of_match);
+
+static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
+						int *chip_id)
+{
+	struct device_node *np = client->dev.of_node;
+	struct tps65910_board *board_info;
+	unsigned int prop;
+	const struct of_device_id *match;
+	unsigned int prop_array[TPS6591X_MAX_NUM_GPIO];
+	int ret = 0;
+	int idx;
+
+	match = of_match_device(tps65910_of_match, &client->dev);
+	if (!match) {
+		dev_err(&client->dev, "Failed to find matching dt id\n");
+		return NULL;
+	}
+
+	*chip_id  = (int)match->data;
+
+	board_info = devm_kzalloc(&client->dev, sizeof(*board_info),
+			GFP_KERNEL);
+	if (!board_info) {
+		dev_err(&client->dev, "Failed to allocate pdata\n");
+		return NULL;
+	}
+
+	ret = of_property_read_u32(np, "ti,vmbch-threshold", &prop);
+	if (!ret)
+		board_info->vmbch_threshold = prop;
+	else if (*chip_id == TPS65911)
+		dev_warn(&client->dev, "VMBCH-Threshold not specified");
+
+	ret = of_property_read_u32(np, "ti,vmbch2-threshold", &prop);
+	if (!ret)
+		board_info->vmbch2_threshold = prop;
+	else if (*chip_id == TPS65911)
+		dev_warn(&client->dev, "VMBCH2-Threshold not specified");
+
+	ret = of_property_read_u32_array(np, "ti,en-gpio-sleep",
+				   prop_array, TPS6591X_MAX_NUM_GPIO);
+	if (!ret)
+		for (idx = 0; idx < ARRAY_SIZE(prop_array); idx++)
+			board_info->en_gpio_sleep[idx] = (prop_array[idx] != 0);
+	else if (ret != -EINVAL) {
+		dev_err(&client->dev,
+			"error reading property ti,en-gpio-sleep: %d\n.", ret);
+		return NULL;
+	}
+
+
+	board_info->irq = client->irq;
+	board_info->irq_base = -1;
+	board_info->gpio_base = -1;
+
+	return board_info;
+}
+#else
+static inline struct tps65910_board *tps65910_parse_dt(
+					struct i2c_client *client)
+{
+	return NULL;
+}
+#endif
 
 static int tps65910_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
@@ -137,8 +209,13 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	struct tps65910_board *pmic_plat_data;
 	struct tps65910_platform_data *init_data;
 	int ret = 0;
+	int chip_id = id->driver_data;
 
 	pmic_plat_data = dev_get_platdata(&i2c->dev);
+
+	if (!pmic_plat_data && i2c->dev.of_node)
+		pmic_plat_data = tps65910_parse_dt(i2c, &chip_id);
+
 	if (!pmic_plat_data)
 		return -EINVAL;
 
@@ -155,7 +232,7 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	i2c_set_clientdata(i2c, tps65910);
 	tps65910->dev = &i2c->dev;
 	tps65910->i2c_client = i2c;
-	tps65910->id = id->driver_data;
+	tps65910->id = chip_id;
 	mutex_init(&tps65910->io_mutex);
 
 	tps65910->regmap = regmap_init_i2c(i2c, &tps65910_regmap_config);
@@ -215,6 +292,7 @@ static struct i2c_driver tps65910_i2c_driver = {
 	.driver = {
 		   .name = "tps65910",
 		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(tps65910_of_match),
 	},
 	.probe = tps65910_i2c_probe,
 	.remove = tps65910_i2c_remove,
-- 
1.7.0.4

