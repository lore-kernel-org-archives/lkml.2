Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab2JEIWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:22:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56141 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab2JEIWr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:22:47 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/28] leds-lp55xx: support device specific attibutes
Thread-Topic: [PATCH 20/28] leds-lp55xx: support device specific attibutes
Thread-Index: Ac2i0pO2eznTGTh7QNmjImCVvZtAcQ==
Date: Fri, 5 Oct 2012 08:22:37 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F64176815@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 LP55xx family chips have a selftest device attribute.
 To maintain this sysfs, chip specific attribute is configurable.
 Eventually those are created on registering the sysfs with common dev attrs.
 Furthermore, this patch makes adding device attributes simple in each driver.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c        |    2 +-
 drivers/leds/leds-lp5523.c        |    2 +-
 drivers/leds/leds-lp55xx-common.c |   15 ++++++++++++++-
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 67d492c..84023e2 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -440,7 +440,6 @@ static ssize_t lp5521_selftest(struct device *dev,
 	return sprintf(buf, "%s\n", ret ? "FAIL" : "OK");
 }
 
-/* device attributes */
 static DEVICE_ATTR(selftest, S_IRUGO, lp5521_selftest, NULL);
 
 static struct attribute *lp5521_attributes[] = {
@@ -468,6 +467,7 @@ static struct lp55xx_device_config lp5521_cfg = {
 	.set_led_current    = lp5521_set_led_current,
 	.run_engine         = lp5521_run_engine,
 	.firmware_cb        = lp5521_firmware_loaded,
+	.dev_attr_group     = &lp5521_group,
 };
 
 static int __devinit lp5521_probe(struct i2c_client *client,
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 5c4f6df..cf629fb 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -491,7 +491,6 @@ static void lp5523_firmware_loaded(struct lp55xx_chip *chip)
 	lp5523_update_program_memory(chip, fw->data, fw->size);
 }
 
-/* device attributes */
 static DEVICE_ATTR(selftest, S_IRUGO, lp5523_selftest, NULL);
 
 static struct attribute *lp5523_attributes[] = {
@@ -523,6 +522,7 @@ static struct lp55xx_device_config lp5523_cfg = {
 	.set_led_current    = lp5523_set_led_current,
 	.run_engine         = lp5523_run_engine,
 	.firmware_cb        = lp5523_firmware_loaded,
+	.dev_attr_group     = &lp5523_group,
 };
 
 static int __devinit lp5523_probe(struct i2c_client *client,
diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index af3fb49..98d66af 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -489,14 +489,27 @@ EXPORT_SYMBOL_GPL(lp55xx_unregister_leds);
 int lp55xx_register_sysfs(struct lp55xx_chip *chip)
 {
 	struct device *dev = &chip->cl->dev;
+	struct lp55xx_device_config *cfg = chip->cfg;
+	int ret;
+
+	/* add common attributes and device specific attribute(s) */
+
+	ret = sysfs_create_group(&dev->kobj, &lp55xx_dev_attr_group);
+	if (ret)
+		return ret;
 
-	return sysfs_create_group(&dev->kobj, &lp55xx_dev_attr_group);
+	return cfg->dev_attr_group ?
+		sysfs_create_group(&dev->kobj, cfg->dev_attr_group) : 0;
 }
 EXPORT_SYMBOL_GPL(lp55xx_register_sysfs);
 
 void lp55xx_unregister_sysfs(struct lp55xx_chip *chip)
 {
 	struct device *dev = &chip->cl->dev;
+	struct lp55xx_device_config *cfg = chip->cfg;
+
+	if (cfg->dev_attr_group)
+		sysfs_remove_group(&dev->kobj, cfg->dev_attr_group);
 
 	sysfs_remove_group(&dev->kobj, &lp55xx_dev_attr_group);
 }
-- 
1.7.9.5


Best Regards,
Milo


