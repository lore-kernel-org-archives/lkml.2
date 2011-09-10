Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab1IJAsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 20:48:47 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13140 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab1IJAsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 20:48:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 09 Sep 2011 17:48:34 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 1/2 v2] power: bq20z75: devicetree init support
Date: Fri,  9 Sep 2011 17:47:48 -0700
Message-Id: <1315615669-8701-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to generate platform data when kernel is configured
through device tree.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
	v2: Fixed typo in binding description

 drivers/power/bq20z75.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
index 9c5e5be..922f725 100644
--- a/drivers/power/bq20z75.c
+++ b/drivers/power/bq20z75.c
@@ -613,6 +613,76 @@ static void bq20z75_delayed_work(struct work_struct *work)
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
+	int rc;
+	u32 prop;
+
+	/* verify this driver matches this device */
+	dtid = of_match_device(bq20z75_dt_ids, &client->dev);
+	if (!dtid)
+		return NULL;
+
+	/* if platform data is set, honor it */
+	if (pdata)
+		return pdata;
+
+	/* first make sure at least one property is set, otherwise
+	 * it won't change behavior from running without pdata.
+	 */
+	if (!of_get_property(of_node, "i2c-retry-count", NULL) &&
+		!of_get_property(of_node, "poll-retry-count", NULL) &&
+		!of_get_property(of_node, "battery-detect", NULL) &&
+		!of_get_property(of_node, "battery-detect-present", NULL))
+		goto of_out;
+
+	pdata = devm_kzalloc(&client->dev, sizeof(struct bq20z75_platform_data),
+				GFP_KERNEL);
+	if (!pdata)
+		goto of_out;
+
+	rc = of_property_read_u32(of_node, "i2c-retry-count", &prop);
+	if (!rc)
+		pdata->i2c_retry_count = prop;
+
+	rc = of_property_read_u32(of_node, "battery-detect", &prop);
+	if (!rc)
+		pdata->battery_detect = prop;
+	else
+		pdata->battery_detect = -1; /*default is no gpio */
+
+	rc = of_property_read_u32(of_node, "battery-detect-present", &prop);
+	if (!rc)
+		pdata->battery_detect_present = prop;
+
+	rc = of_property_read_u32(of_node, "poll-retry-count", &prop);
+	if (!rc)
+		pdata->poll_retry_count = prop;
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
@@ -642,6 +712,8 @@ static int __devinit bq20z75_probe(struct i2c_client *client,
 	bq20z75_device->power_supply.external_power_changed =
 		bq20z75_external_power_changed;
 
+	pdata = bq20z75_of_populate_pdata(client);
+
 	if (pdata) {
 		bq20z75_device->gpio_detect =
 			gpio_is_valid(pdata->battery_detect);
@@ -775,6 +847,7 @@ static struct i2c_driver bq20z75_battery_driver = {
 	.id_table	= bq20z75_id,
 	.driver = {
 		.name	= "bq20z75-battery",
+		.of_match_table = bq20z75_dt_ids,
 	},
 };
 
-- 
1.7.6

