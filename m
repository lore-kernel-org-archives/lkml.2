Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab2KGUzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 15:55:46 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38044 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab2KGUzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 15:55:45 -0500
From: Marek Belisko <marek.belisko@open-nandra.com>
To: cooloney@gmail.com, rpurdie@rpsys.net
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 1/2] leds/tca6507: Add support for devicetree.
Date: Wed,  7 Nov 2012 21:55:25 +0100
Message-Id: <1352321726-21284-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support added only for leds (not for gpio's).

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---

Changes from v1:
- return proper error value not NULL from tca6507_led_dt_init()
- remove empty lines
- remove kfree()

 drivers/leds/leds-tca6507.c |   70 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
index dabcf7a..e2c01f7 100644
--- a/drivers/leds/leds-tca6507.c
+++ b/drivers/leds/leds-tca6507.c
@@ -667,6 +667,66 @@ static void tca6507_remove_gpio(struct tca6507_chip *tca)
 }
 #endif /* CONFIG_GPIOLIB */
 
+#ifdef CONFIG_OF
+static struct tca6507_platform_data * __devinit tca6507_led_dt_init(struct i2c_client *client)
+{
+	struct device_node *np = client->dev.of_node, *child;
+	struct tca6507_platform_data *pdata;
+	struct led_info *tca_leds;
+	int count = 0;
+
+	for_each_child_of_node(np, child)
+		count++;
+	if (!count)
+		return ERR_PTR(-ENODEV);
+
+	if (count > NUM_LEDS)
+		return ERR_PTR(-ENODEV);
+
+	tca_leds = devm_kzalloc(&client->dev, sizeof(struct led_info) * NUM_LEDS, GFP_KERNEL);
+	if (!tca_leds)
+		return ERR_PTR(-ENOMEM);
+
+	for_each_child_of_node(np, child) {
+		struct led_info led;
+		u32 reg;
+		int ret;
+
+		led.name = of_get_property(child, "label", NULL) ? : child->name;
+		led.default_trigger =
+			of_get_property(child, "linux,default-trigger", NULL);
+
+		ret = of_property_read_u32(child, "reg", &reg);
+
+		if (ret != 0)
+			continue;
+		tca_leds[reg] = led;
+	}
+	pdata = devm_kzalloc(&client->dev, sizeof(struct tca6507_platform_data), GFP_KERNEL);
+	if (!pdata) {
+		return ERR_PTR(-ENOMEM);
+	}
+
+	pdata->leds.leds = tca_leds;
+	pdata->leds.num_leds = NUM_LEDS;
+
+	return pdata;
+}
+
+static const struct of_device_id of_tca6507_leds_match[] = {
+	{ .compatible = "leds-tca6507", },
+	{},
+};
+
+#else
+static int __devinit tca6507_led_dt_init(struct i2c_client *client, struct tca6507_platform_data *data)
+{
+	return -1;
+}
+
+#define of_tca6507_leds_match NULL
+#endif
+
 static int __devinit tca6507_probe(struct i2c_client *client,
 				   const struct i2c_device_id *id)
 {
@@ -683,9 +743,12 @@ static int __devinit tca6507_probe(struct i2c_client *client,
 		return -EIO;
 
 	if (!pdata || pdata->leds.num_leds != NUM_LEDS) {
-		dev_err(&client->dev, "Need %d entries in platform-data list\n",
-			NUM_LEDS);
-		return -ENODEV;
+		pdata = tca6507_led_dt_init(client);
+		if (IS_ERR(pdata)) {
+			dev_err(&client->dev, "Need %d entries in platform-data list\n",
+				NUM_LEDS);
+			return PTR_ERR(pdata);
+		}
 	}
 	tca = devm_kzalloc(&client->dev, sizeof(*tca), GFP_KERNEL);
 	if (!tca)
@@ -750,6 +813,7 @@ static struct i2c_driver tca6507_driver = {
 	.driver   = {
 		.name    = "leds-tca6507",
 		.owner   = THIS_MODULE,
+		.of_match_table = of_tca6507_leds_match,
 	},
 	.probe    = tca6507_probe,
 	.remove   = __devexit_p(tca6507_remove),
-- 
1.7.9.5

