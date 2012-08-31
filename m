Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab2HaBqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 21:46:42 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:46768 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab2HaBql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 21:46:41 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: lm-sensors@lm-sensors.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: (sht15) remove multiple driver registration
Date: Thu, 30 Aug 2012 21:46:19 -0400
Message-Id: <1346377579-24849-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declare an array of platform_device_id, instead of registering a driver
for each supported chip. This makes the code cleaner.
Also add a module description.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 drivers/hwmon/sht15.c | 94 +++++++++++++--------------------------------------
 1 file changed, 23 insertions(+), 71 deletions(-)

diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index 8b011d0..38e0233 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -1,7 +1,7 @@
 /*
  * sht15.c - support for the SHT15 Temperature and Humidity Sensor
  *
- * Portions Copyright (c) 2010-2011 Savoir-faire Linux Inc.
+ * Portions Copyright (c) 2010-2012 Savoir-faire Linux Inc.
  *          Jerome Oufella <jerome.oufella@savoirfairelinux.com>
  *          Vivien Didelot <vivien.didelot@savoirfairelinux.com>
  *
@@ -53,6 +53,9 @@
 #define SHT15_STATUS_HEATER		0x04
 #define SHT15_STATUS_LOW_BATTERY	0x40
 
+/* List of supported chips */
+enum sht15_chips { sht10, sht11, sht15, sht71, sht75 };
+
 /* Actions the driver may be doing */
 enum sht15_state {
 	SHT15_READING_NOTHING,
@@ -1042,77 +1045,26 @@ static int __devexit sht15_remove(struct platform_device *pdev)
 	return 0;
 }
 
-/*
- * sht_drivers simultaneously refers to __devinit and __devexit function
- * which causes spurious section mismatch warning. So use __refdata to
- * get rid from this.
- */
-static struct platform_driver __refdata sht_drivers[] = {
-	{
-		.driver = {
-			.name = "sht10",
-			.owner = THIS_MODULE,
-		},
-		.probe = sht15_probe,
-		.remove = __devexit_p(sht15_remove),
-	}, {
-		.driver = {
-			.name = "sht11",
-			.owner = THIS_MODULE,
-		},
-		.probe = sht15_probe,
-		.remove = __devexit_p(sht15_remove),
-	}, {
-		.driver = {
-			.name = "sht15",
-			.owner = THIS_MODULE,
-		},
-		.probe = sht15_probe,
-		.remove = __devexit_p(sht15_remove),
-	}, {
-		.driver = {
-			.name = "sht71",
-			.owner = THIS_MODULE,
-		},
-		.probe = sht15_probe,
-		.remove = __devexit_p(sht15_remove),
-	}, {
-		.driver = {
-			.name = "sht75",
-			.owner = THIS_MODULE,
-		},
-		.probe = sht15_probe,
-		.remove = __devexit_p(sht15_remove),
-	},
+static struct platform_device_id sht15_device_ids[] = {
+	{ "sht10", sht10 },
+	{ "sht11", sht11 },
+	{ "sht15", sht15 },
+	{ "sht71", sht71 },
+	{ "sht75", sht75 },
+	{ }
 };
+MODULE_DEVICE_TABLE(platform, sht15_device_ids);
 
-static int __init sht15_init(void)
-{
-	int ret;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(sht_drivers); i++) {
-		ret = platform_driver_register(&sht_drivers[i]);
-		if (ret)
-			goto error_unreg;
-	}
-
-	return 0;
-
-error_unreg:
-	while (--i >= 0)
-		platform_driver_unregister(&sht_drivers[i]);
-
-	return ret;
-}
-module_init(sht15_init);
-
-static void __exit sht15_exit(void)
-{
-	int i;
-	for (i = ARRAY_SIZE(sht_drivers) - 1; i >= 0; i--)
-		platform_driver_unregister(&sht_drivers[i]);
-}
-module_exit(sht15_exit);
+static struct platform_driver sht15_driver = {
+	.driver = {
+		.name = "sht15",
+		.owner = THIS_MODULE,
+	},
+	.probe = sht15_probe,
+	.remove = __devexit_p(sht15_remove),
+	.id_table = sht15_device_ids,
+};
+module_platform_driver(sht15_driver);
 
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Sensirion SHT15 temperature and humidity sensor driver");
-- 
1.7.11.4

