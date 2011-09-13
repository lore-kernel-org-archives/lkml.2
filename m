Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab1IMVWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 17:22:32 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10378 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801Ab1IMVWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 17:22:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 13 Sep 2011 14:22:20 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 1/2 v3] power: bq20z75: devicetree init support
Date: Tue, 13 Sep 2011 14:20:59 -0700
Message-Id: <1315948860-21482-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to generate platform data when kernel is configured
through device tree.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
	v3: Changed to use "ti," properties
	    Changed to use gpio property with flag for polarity
	    Removed unnecessary call to of_match_device

 drivers/power/bq20z75.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
index 9c5e5be..bb4afb2 100644
--- a/drivers/power/bq20z75.c
+++ b/drivers/power/bq20z75.c
@@ -613,6 +613,78 @@ static void bq20z75_delayed_work(struct work_struct *work)
 	}
 }
 
+#if defined(CONFIG_OF)
+#include <linux/of_device.h>
+static const struct of_device_id bq20z75_dt_ids[] = {
+	{ .compatible = "ti,bq20z75" },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, bq20z75_dt_ids);
+
+static struct bq20z75_platform_data *bq20z75_of_populate_pdata(
+	struct i2c_client *client)
+{
+	const struct of_device_id *dtid;
+	struct device_node *of_node = client->dev.of_node;
+	struct bq20z75_platform_data *pdata = client->dev.platform_data;
+	enum of_gpio_flags gpio_flags;
+	int rc;
+	u32 prop;
+
+	/* verify this driver matches this device */
+	if (!of_node)
+		return NULL;
+
+	/* if platform data is set, honor it */
+	if (pdata)
+		return pdata;
+
+	/* first make sure at least one property is set, otherwise
+	 * it won't change behavior from running without pdata.
+	 */
+	if (!of_get_property(of_node, "ti,i2c-retry-count", NULL) &&
+		!of_get_property(of_node, "ti,poll-retry-count", NULL) &&
+		!of_get_property(of_node, "ti,battery-detect-gpios", NULL))
+		goto of_out;
+
+	pdata = devm_kzalloc(&client->dev, sizeof(struct bq20z75_platform_data),
+				GFP_KERNEL);
+	if (!pdata)
+		goto of_out;
+
+	rc = of_property_read_u32(of_node, "ti,i2c-retry-count", &prop);
+	if (!rc)
+		pdata->i2c_retry_count = prop;
+
+	rc = of_property_read_u32(of_node, "ti,poll-retry-count", &prop);
+	if (!rc)
+		pdata->poll_retry_count = prop;
+
+	if (!of_get_property(of_node, "ti,battery-detect-gpios", NULL)) {
+		pdata->battery_detect = -1;
+		goto of_out;
+	}
+
+	pdata->battery_detect = of_get_named_gpio_flags(of_node,
+			"ti,battery-detect-gpios", 0, &gpio_flags);
+
+	if (gpio_flags & OF_GPIO_ACTIVE_LOW)
+		pdata->battery_detect_present = 0;
+	else
+		pdata->battery_detect_present = 1;
+
+of_out:
+	return pdata;
+}
+#else
+#define bq20z75_dt_ids NULL
+static struct bq20z75_platform_data *bq20z75_of_populate_pdata(
+	struct i2c_client *client)
+{
+	return NULL;
+}
+#endif
+
 static int __devinit bq20z75_probe(struct i2c_client *client,
 	const struct i2c_device_id *id)
 {
@@ -642,6 +714,8 @@ static int __devinit bq20z75_probe(struct i2c_client *client,
 	bq20z75_device->power_supply.external_power_changed =
 		bq20z75_external_power_changed;
 
+	pdata = bq20z75_of_populate_pdata(client);
+
 	if (pdata) {
 		bq20z75_device->gpio_detect =
 			gpio_is_valid(pdata->battery_detect);
@@ -775,6 +849,7 @@ static struct i2c_driver bq20z75_battery_driver = {
 	.id_table	= bq20z75_id,
 	.driver = {
 		.name	= "bq20z75-battery",
+		.of_match_table = bq20z75_dt_ids,
 	},
 };
 
-- 
1.7.6

