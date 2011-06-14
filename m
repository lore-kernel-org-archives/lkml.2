Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab1FNJBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 05:01:32 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:13717 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab1FNJAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 05:00:50 -0400
From: David Jander <david@protonic.nl>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: [PATCH v5 3/5] GPIO: pca953x.c: Deprecate meaningless device-tree bindings
Date: Tue, 14 Jun 2011 11:00:56 +0200
Message-Id: <1308042058-20107-4-git-send-email-david@protonic.nl>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308042058-20107-1-git-send-email-david@protonic.nl>
References: <1308042058-20107-1-git-send-email-david@protonic.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The property 'polarity' is handled by the GPIO core, and the 'gpio-base'
should be assigned automatically. It is meaningless in the device-tree,
since GPIO's are identified by the "chip-name"/offset pair.
This way, the whole pca953x_get_alt_pdata() can hopefully soon go away.
We still need to check whether we really want GPIO-interrupt functionality
by simply looking if the I2C node has an interrupts property defined, since
this property is not used for anything else.

Signed-off-by: David Jander <david@protonic.nl>
---
 drivers/gpio/pca953x.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index db69d9e..c28fc98 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -21,7 +21,6 @@
 #include <linux/slab.h>
 #ifdef CONFIG_OF_GPIO
 #include <linux/of_platform.h>
-#include <linux/of_gpio.h>
 #endif
 
 #define PCA953X_INPUT		0
@@ -546,6 +545,7 @@ static void pca953x_irq_teardown(struct pca953x_chip *chip)
 #ifdef CONFIG_OF_GPIO
 /*
  * Translate OpenFirmware node properties into platform_data
+ * WARNING: This is DEPRECATED and will be removed eventually!
  */
 void
 pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, int *invert)
@@ -560,6 +560,7 @@ pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, int *invert)
 
 	*gpio_base = -1;
 	val = of_get_property(node, "linux,gpio-base", &size);
+	WARN(val, "%s: device-tree property 'linux,gpio-base' is deprecated!", __func__);
 	if (val) {
 		if (size != sizeof(*val))
 			dev_warn(&client->dev, "%s: wrong linux,gpio-base\n",
@@ -569,6 +570,7 @@ pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, int *invert)
 	}
 
 	val = of_get_property(node, "polarity", NULL);
+	WARN(val, "%s: device-tree property 'polarity' is deprecated!", __func__);
 	if (val)
 		*invert = *val;
 }
@@ -637,7 +639,7 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 {
 	struct pca953x_platform_data *pdata;
 	struct pca953x_chip *chip;
-	int irq_base=-1, invert=0;
+	int irq_base=0, invert=0;
 	int ret = 0;
 
 	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
@@ -652,6 +654,11 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 		chip->names = pdata->names;
 	} else {
 		pca953x_get_alt_pdata(client, &chip->gpio_start, &invert);
+#ifdef CONFIG_OF_GPIO
+		/* If I2C node has no interrupts property, disable GPIO interrupts */
+		if (of_find_property(client->dev.of_node, "interrupts", NULL) == NULL)
+			irq_base = -1;
+#endif
 	}
 
 	chip->client = client;
-- 
1.7.4.1

