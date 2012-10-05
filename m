Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab2JEILm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:11:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57674 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab2JEILh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:11:37 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/28] leds-lp5521/5523: mem alloc for new lp55xx data
Thread-Topic: [PATCH 03/28] leds-lp5521/5523: mem alloc for new lp55xx data
Thread-Index: Ac2i0PPNe0AryaV+Rf25oOyevwhIvQ==
Date: Fri, 5 Oct 2012 08:10:59 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F64176711@DQHE02.ent.ti.com>
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

 The lp55xx_led and lp55xx_chip structures are used for supporting LP5521 and
 LP5523 device functionality.
 Core structures are allocated when each driver is probed.
 Unused old data code were removed.
 Additional headers are included.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   33 +++++++++++++++++++++------------
 drivers/leds/leds-lp5523.c |   33 +++++++++++++++++++++------------
 2 files changed, 42 insertions(+), 24 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 992984b..3735038 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -32,9 +32,12 @@
 #include <linux/wait.h>
 #include <linux/leds.h>
 #include <linux/leds-lp5521.h>
+#include <linux/platform_data/leds-lp55xx.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
 
+#include "leds-lp55xx-common.h"
+
 #define LP5521_PROGRAM_LENGTH		32	/* in bytes */
 
 #define LP5521_MAX_LEDS			3	/* Maximum number of LEDs */
@@ -743,24 +746,30 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	struct lp5521_platform_data	*old_pdata;
 	int ret, i, old_led;
 	u8 buf;
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
 
 	if (old_pdata->setup_resources) {
 		ret = old_pdata->setup_resources();
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 75fc7d5..91f42fc 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -32,9 +32,12 @@
 #include <linux/wait.h>
 #include <linux/leds.h>
 #include <linux/leds-lp5523.h>
+#include <linux/platform_data/leds-lp55xx.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
 
+#include "leds-lp55xx-common.h"
+
 #define LP5523_REG_ENABLE		0x00
 #define LP5523_REG_OP_MODE		0x01
 #define LP5523_REG_RATIOMETRIC_MSB	0x02
@@ -888,24 +891,30 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 	struct lp5523_chip		*old_chip;
 	struct lp5523_platform_data	*old_pdata;
 	int ret, i, old_led;
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
 
 	if (old_pdata->setup_resources) {
 		ret = old_pdata->setup_resources();
-- 
1.7.9.5


Best Regards,
Milo


