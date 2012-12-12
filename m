Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2LLOFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:05:47 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42305 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab2LLOC1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:02:27 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 21/33] leds-lp55xx: support device specific attibutes
Thread-Topic: [PATCH 21/33] leds-lp55xx: support device specific attibutes
Thread-Index: Ac3YcU7Po5uCGB1WTROSug5+ah2Mzw==
Date: Wed, 12 Dec 2012 14:02:23 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0ABBF@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
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

 To support device specific attributes, new common driver function is added.
 Eventually those are created on registering the sysfs with common dev attrs.
 Furthermore, this patch makes adding device attributes simple in each driver.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp55xx-common.c |   13 ++++++++++++-
 drivers/leds/leds-lp55xx-common.h |    4 ++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index f3a2866..731f826 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -493,7 +493,18 @@ EXPORT_SYMBOL_GPL(lp55xx_unregister_leds);
 int lp55xx_register_sysfs(struct lp55xx_chip *chip)
 {
 	struct device *dev = &chip->cl->dev;
+	struct lp55xx_device_config *cfg = chip->cfg;
+	int ret;
+
+	if (!cfg->run_engine || !cfg->firmware_cb)
+		goto dev_specific_attrs;
+
+	ret = sysfs_create_group(&dev->kobj, &lp55xx_engine_attr_group);
+	if (ret)
+		return ret;
 
-	return sysfs_create_group(&dev->kobj, &lp55xx_engine_attr_group);
+dev_specific_attrs:
+	return cfg->dev_attr_group ?
+		sysfs_create_group(&dev->kobj, cfg->dev_attr_group) : 0;
 }
 EXPORT_SYMBOL_GPL(lp55xx_register_sysfs);
diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
index affdb43..39f54d2 100644
--- a/drivers/leds/leds-lp55xx-common.h
+++ b/drivers/leds/leds-lp55xx-common.h
@@ -44,6 +44,7 @@ struct lp55xx_reg {
  * @brightness_work_fn : Brightness work function
  * @firmware_cb        : Call function when the firmware is loaded
  * @run_engine         : Run internal engine for pattern
+ * @dev_attr_group     : Device specific attributes
  */
 struct lp55xx_device_config {
 	const struct lp55xx_reg reset;
@@ -64,6 +65,9 @@ struct lp55xx_device_config {
 
 	/* used for running firmware LED patterns */
 	void (*run_engine) (struct lp55xx_chip *chip, bool start);
+
+	/* additional device specific attributes */
+	const struct attribute_group *dev_attr_group;
 };
 
 /*
-- 
1.7.9.5


Best Regards,
Milo


