Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab2KSGvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 01:51:24 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:46224 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252Ab2KSGvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 01:51:23 -0500
From: Qing Xu <qingx@marvell.com>
To: qingx@marvell.com, anton.vorontsov@linaro.org, dwmw2@infradead.org,
        sameo@linux.intel.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, haojian.zhuang@gmail.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v2 4/7] mfd: max8925: support dt for power supply
Date: Mon, 19 Nov 2012 14:52:24 +0800
Message-Id: <1353307944-9805-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 19 Nov 2012 06:51:09.0534 (UTC) FILETIME=[4198E7E0:01CDC622]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

Signed-off-by: Qing Xu <qingx@marvell.com>
---
 drivers/power/max8925_power.c |   61 +++++++++++++++++++++++++++++++++++++---
 1 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
index daa333b..aca3f68 100644
--- a/drivers/power/max8925_power.c
+++ b/drivers/power/max8925_power.c
@@ -426,6 +426,57 @@ static __devexit int max8925_deinit_charger(struct max8925_power_info *info)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static struct max8925_power_pdata*
+max8925_power_dt_init(	struct platform_device *pdev)
+{
+	struct device_node *nproot = pdev->dev.parent->of_node, *np;
+	int batt_detect;
+	int topoff_threshold;
+	int fast_charge;
+	int no_temp_support;
+	int no_insert_detect;
+	struct max8925_power_pdata *pdata;
+
+	if (!nproot)
+		return pdev->dev.platform_data;
+
+	np = of_find_node_by_name(nproot, "charger");
+	if (!np) {
+		dev_err(&pdev->dev, "failed to find charger node\n");
+		return NULL;
+	}
+
+	pdata = devm_kzalloc(&pdev->dev,
+			sizeof(struct max8925_power_pdata),
+			GFP_KERNEL);
+
+	of_property_read_u32(np, "topoff-threshold", &topoff_threshold);
+	of_property_read_u32(np, "batt-detect", &batt_detect);
+	of_property_read_u32(np, "fast-charge", &fast_charge);
+	of_property_read_u32(np, "no-insert-detect", &no_insert_detect);
+	of_property_read_u32(np, "no-temp-support", &no_temp_support);
+
+	pdata->batt_detect = batt_detect;
+	pdata->fast_charge = fast_charge;
+	pdata->topoff_threshold = topoff_threshold;
+	pdata->no_insert_detect = no_insert_detect;
+	pdata->no_temp_support = no_temp_support;
+
+	return pdata;
+}
+#else
+static struct max8925_power_pdata*
+max8925_power_dt_init(	struct platform_device *pdev)
+{
+	return pdev->dev.platform_data;
+}
+#endif
+
+static char *power_supplicants[] = {
+	"max8925-battery",
+};
+
 static __devinit int max8925_power_probe(struct platform_device *pdev)
 {
 	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
@@ -433,7 +484,7 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
 	struct max8925_power_info *info;
 	int ret;
 
-	pdata = pdev->dev.platform_data;
+	pdata = max8925_power_dt_init(pdev);
 	if (!pdata) {
 		dev_err(&pdev->dev, "platform data isn't assigned to "
 			"power supply\n");
@@ -453,8 +504,8 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
 	info->ac.properties = max8925_ac_props;
 	info->ac.num_properties = ARRAY_SIZE(max8925_ac_props);
 	info->ac.get_property = max8925_ac_get_prop;
-	info->ac.supplied_to = pdata->supplied_to;
-	info->ac.num_supplicants = pdata->num_supplicants;
+	info->ac.supplied_to = power_supplicants;
+	info->ac.num_supplicants = ARRAY_SIZE(power_supplicants);
 	ret = power_supply_register(&pdev->dev, &info->ac);
 	if (ret)
 		goto out;
@@ -465,8 +516,8 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
 	info->usb.properties = max8925_usb_props;
 	info->usb.num_properties = ARRAY_SIZE(max8925_usb_props);
 	info->usb.get_property = max8925_usb_get_prop;
-	info->usb.supplied_to = pdata->supplied_to;
-	info->usb.num_supplicants = pdata->num_supplicants;
+	info->usb.supplied_to = power_supplicants;
+	info->usb.num_supplicants = ARRAY_SIZE(power_supplicants);
 
 	ret = power_supply_register(&pdev->dev, &info->usb);
 	if (ret)
-- 
1.7.0.4

