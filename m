Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab2LLOBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:01:22 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47802 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203Ab2LLOBS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:01:18 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/33] leds-lp55xx: use common lp55xx data structure in
 _probe()
Thread-Topic: [PATCH 09/33] leds-lp55xx: use common lp55xx data structure in
 _probe()
Thread-Index: Ac3YcSWpmyxrtYTYSHelVEAhoXv4dg==
Date: Wed, 12 Dec 2012 14:01:14 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AAF0@DQHE02.ent.ti.com>
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

 LP5521 and LP5523 data structures have common features.
 Use common lp55xx data structures rather than chip specific data.

 lp55xx_chip          : Common data between lp5521_chip and lp5523_chip
 lp55xx_led           : Common LED structure bettwen lp5521_led and lp5523_led
 lp55xx_platform_data : Common platform data between lp5521_platform_data and
                        lp5523_platform_data

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   34 +++++++++++++++++++++-------------
 drivers/leds/leds-lp5523.c |   34 +++++++++++++++++++++-------------
 2 files changed, 42 insertions(+), 26 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 2e646e1..ef713ab 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -34,6 +34,9 @@
 #include <linux/leds-lp5521.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
+#include <linux/platform_data/leds-lp55xx.h>
+
+#include "leds-lp55xx-common.h"
 
 #define LP5521_PROGRAM_LENGTH		32	/* in bytes */
 
@@ -873,26 +876,31 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct lp5521_chip		*old_chip;
-	struct lp5521_platform_data	*old_pdata;
 	int ret;
+	struct lp55xx_chip *chip;
+	struct lp55xx_led *led;
+	struct lp55xx_platform_data *pdata = client->dev.platform_data;
 
-	old_chip = devm_kzalloc(&client->dev, sizeof(*old_chip), GFP_KERNEL);
-	if (!old_chip)
-		return -ENOMEM;
-
-	i2c_set_clientdata(client, old_chip);
-	old_chip->client = client;
-
-	old_pdata = client->dev.platform_data;
-
-	if (!old_pdata) {
+	if (!pdata) {
 		dev_err(&client->dev, "no platform data\n");
 		return -EINVAL;
 	}
 
-	mutex_init(&old_chip->lock);
+	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	led = devm_kzalloc(&client->dev,
+			sizeof(*led) * pdata->num_channels, GFP_KERNEL);
+	if (!led)
+		return -ENOMEM;
+
+	chip->cl = client;
+	chip->pdata = pdata;
+
+	mutex_init(&chip->lock);
 
-	old_chip->pdata   = old_pdata;
+	i2c_set_clientdata(client, led);
 
 	ret = lp5521_init_device(old_chip);
 	if (ret)
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 270dfbe..aa66a3b 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -34,6 +34,9 @@
 #include <linux/leds-lp5523.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
+#include <linux/platform_data/leds-lp55xx.h>
+
+#include "leds-lp55xx-common.h"
 
 #define LP5523_REG_ENABLE		0x00
 #define LP5523_REG_OP_MODE		0x01
@@ -1011,26 +1014,31 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct lp5523_chip		*old_chip;
-	struct lp5523_platform_data	*old_pdata;
 	int ret, i;
+	struct lp55xx_chip *chip;
+	struct lp55xx_led *led;
+	struct lp55xx_platform_data *pdata = client->dev.platform_data;
 
-	old_chip = devm_kzalloc(&client->dev, sizeof(*old_chip), GFP_KERNEL);
-	if (!old_chip)
-		return -ENOMEM;
-
-	i2c_set_clientdata(client, old_chip);
-	old_chip->client = client;
-
-	old_pdata = client->dev.platform_data;
-
-	if (!old_pdata) {
+	if (!pdata) {
 		dev_err(&client->dev, "no platform data\n");
 		return -EINVAL;
 	}
 
-	mutex_init(&old_chip->lock);
+	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	led = devm_kzalloc(&client->dev,
+			sizeof(*led) * pdata->num_channels, GFP_KERNEL);
+	if (!led)
+		return -ENOMEM;
+
+	chip->cl = client;
+	chip->pdata = pdata;
+
+	mutex_init(&chip->lock);
 
-	old_chip->pdata   = old_pdata;
+	i2c_set_clientdata(client, led);
 
 	ret = lp5523_init_device(old_chip);
 	if (ret)
-- 
1.7.9.5


Best Regards,
Milo


