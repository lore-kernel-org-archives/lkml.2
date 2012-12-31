Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab2LaLLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 06:11:45 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56417 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab2LaLJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 06:09:41 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 06/10] mfd: twl-core: Do not create dummy pdata when booted with DT
Date: Mon, 31 Dec 2012 12:09:27 +0100
Message-ID: <1356952171-6109-7-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356952171-6109-1-git-send-email-peter.ujfalusi@ti.com>
References: <1356952171-6109-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booted with DT we can manage without the dummy pdata.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl-core.c | 31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 86cca9e..547fed5 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -1165,6 +1165,11 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	int				status;
 	unsigned			i, num_slaves;
 
+	if (!node && !pdata) {
+		dev_err(&client->dev, "no platform data\n");
+		return -EINVAL;
+	}
+
 	pdev = platform_device_alloc(DRIVER_NAME, -1);
 	if (!pdev) {
 		dev_err(&client->dev, "can't alloc pdev\n");
@@ -1177,28 +1182,6 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		return status;
 	}
 
-	if (node && !pdata) {
-		/*
-		 * XXX: Temporary pdata until the information is correctly
-		 * retrieved by every TWL modules from DT.
-		 */
-		pdata = devm_kzalloc(&client->dev,
-				     sizeof(struct twl4030_platform_data),
-				     GFP_KERNEL);
-		if (!pdata) {
-			status = -ENOMEM;
-			goto free;
-		}
-	}
-
-	if (!pdata) {
-		dev_dbg(&client->dev, "no platform data?\n");
-		status = -EINVAL;
-		goto free;
-	}
-
-	platform_set_drvdata(pdev, pdata);
-
 	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C) == 0) {
 		dev_dbg(&client->dev, "can't talk I2C?\n");
 		status = -EIO;
@@ -1264,7 +1247,7 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	inuse = true;
 
 	/* setup clock framework */
-	clocks_init(&pdev->dev, pdata->clock);
+	clocks_init(&pdev->dev, pdata ? pdata->clock : NULL);
 
 	/* read TWL IDCODE Register */
 	if (twl_id == TWL4030_CLASS_ID) {
@@ -1273,7 +1256,7 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	/* load power event scripts */
-	if (IS_ENABLED(CONFIG_TWL4030_POWER) && pdata->power)
+	if (IS_ENABLED(CONFIG_TWL4030_POWER) && pdata && pdata->power)
 		twl4030_power_init(pdata->power);
 
 	/* Maybe init the T2 Interrupt subsystem */
-- 
1.8.0.2

