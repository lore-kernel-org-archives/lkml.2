Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab1LTFqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 00:46:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab1LTFqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 00:46:14 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 20 Dec 2011 16:44:41 +1100
Subject: [PATCH 1/2] leds-tca6507: allow driver to compile when GPIOLIB is not
 available.
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>
Message-ID: <20111220054441.7043.48656.stgit@notabene.brown>
In-Reply-To: <20111220054233.7043.3561.stgit@notabene.brown>
References: <20111220054233.7043.3561.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver can configure the outputs as GPIO line instead of LEDs.  But
that only works if GPIOLIB is available.  So make that code conditional
on the library's availability.

Also remove the 'teardown' callback as it is never called and should
never be needed.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/leds/leds-tca6507.c  |   92 +++++++++++++++++++++++++++++-------------
 include/linux/leds-tca6507.h |    3 +
 2 files changed, 65 insertions(+), 30 deletions(-)

diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
index a7ea4cf..3565a61 100644
--- a/drivers/leds/leds-tca6507.c
+++ b/drivers/leds/leds-tca6507.c
@@ -149,9 +149,11 @@ struct tca6507_chip {
 		int			bank;	/* Bank used, or -1 */
 		int			blink;	/* 1 if we are hardware-blinking */
 	} leds[NUM_LEDS];
+#ifdef CONFIG_GPIOLIB
 	struct gpio_chip		gpio;
 	const char			*gpio_name[NUM_LEDS];
 	int				gpio_map[NUM_LEDS];
+#endif
 };
 
 static const struct i2c_device_id tca6507_id[] = {
@@ -520,6 +522,7 @@ static int tca6507_blink_set(struct led_classdev *led_cdev,
 	return 0;
 }
 
+#ifdef CONFIG_GPIOLIB
 static void tca6507_gpio_set_value(struct gpio_chip *gc,
 				   unsigned offset, int val)
 {
@@ -542,6 +545,62 @@ static int tca6507_gpio_direction_output(struct gpio_chip *gc,
 	tca6507_gpio_set_value(gc, offset, val);
 	return 0;
 }
+static int tca6507_probe_gpios(struct i2c_client *client,
+			       struct tca6507_chip *tca,
+			       struct tca6507_platform_data *pdata)
+{
+	int err;
+	int i = 0;
+	int gpios = 0;
+
+	for (i = 0; i < NUM_LEDS; i++)
+		if (pdata->leds.leds[i].name && pdata->leds.leds[i].flags) {
+			/* Configure as a gpio */
+			tca->gpio_name[gpios] = pdata->leds.leds[i].name;
+			tca->gpio_map[gpios] = i;
+			gpios++;
+		}
+
+	if (!gpios)
+		return 0;
+
+	tca->gpio.label = "gpio-tca6507";
+	tca->gpio.names = tca->gpio_name;
+	tca->gpio.ngpio = gpios;
+	tca->gpio.base = pdata->gpio_base;
+	tca->gpio.owner = THIS_MODULE;
+	tca->gpio.direction_output = tca6507_gpio_direction_output;
+	tca->gpio.set = tca6507_gpio_set_value;
+	tca->gpio.dev = &client->dev;
+	err = gpiochip_add(&tca->gpio);
+	if (err) {
+		tca->gpio.ngpio = 0;
+		return err;
+	}
+	if (pdata->setup)
+		pdata->setup(tca->gpio.base, tca->gpio.ngpio);
+	return 0;
+}
+
+static void tca6507_remove_gpio(struct tca6507_chip *tca)
+{
+	if (tca->gpio.ngpio) {
+		int err = gpiochip_remove(&tca->gpio);
+		dev_err(&tca->client->dev, "%s failed, %d\n",
+			"gpiochip_remove()", err);
+	}
+}
+#else /* CONFIG_GPIOLIB */
+static int tca6507_probe_gpios(struct i2c_client *client,
+			       struct tca6507_chip *tca,
+			       struct tca6507_platform_data *pdata)
+{
+	return 0;
+}
+static void tca6507_remove_gpio(struct tca6507_chip *tca)
+{
+}
+#endif /* CONFIG_GPIOLIB */
 
 static int __devinit tca6507_probe(struct i2c_client *client,
 				   const struct i2c_device_id *id)
@@ -551,7 +610,6 @@ static int __devinit tca6507_probe(struct i2c_client *client,
 	struct tca6507_platform_data *pdata;
 	int err;
 	int i = 0;
-	int gpios = 0;
 
 	adapter = to_i2c_adapter(client->dev.parent);
 	pdata = client->dev.platform_data;
@@ -590,30 +648,10 @@ static int __devinit tca6507_probe(struct i2c_client *client,
 			if (err < 0)
 				goto exit;
 		}
-		if (pdata->leds.leds[i].name && pdata->leds.leds[i].flags) {
-			/* Configure as a gpio */
-			tca->gpio_name[gpios] = pdata->leds.leds[i].name;
-			tca->gpio_map[gpios] = i;
-			gpios++;
-		}
-	}
-	if (gpios) {
-		tca->gpio.label = "gpio-tca6507";
-		tca->gpio.names = tca->gpio_name;
-		tca->gpio.ngpio = gpios;
-		tca->gpio.base = pdata->gpio_base;
-		tca->gpio.owner = THIS_MODULE;
-		tca->gpio.direction_output = tca6507_gpio_direction_output;
-		tca->gpio.set = tca6507_gpio_set_value;
-		tca->gpio.dev = &client->dev;
-		err = gpiochip_add(&tca->gpio);
-		if (err) {
-			tca->gpio.ngpio = 0;
-			goto exit;
-		}
-		if (pdata->setup)
-			pdata->setup(tca->gpio.base, tca->gpio.ngpio);
 	}
+	err = tca6507_probe_gpios(client, tca, pdata);
+	if (err)
+		goto exit;
 	i2c_set_clientdata(client, tca);
 	/* set all registers to known state - zero */
 	tca->reg_set = 0x7f;
@@ -638,11 +676,7 @@ static int __devexit tca6507_remove(struct i2c_client *client)
 		if (tca_leds[i].led_cdev.name)
 			led_classdev_unregister(&tca_leds[i].led_cdev);
 	}
-	if (tca->gpio.ngpio) {
-		int err = gpiochip_remove(&tca->gpio);
-		dev_err(&tca->client->dev, "%s failed, %d\n",
-			"gpiochip_remove()", err);
-	}
+	tca6507_remove_gpio(tca);
 	cancel_work_sync(&tca->work);
 	kfree(tca);
 	i2c_set_clientdata(client, NULL);
diff --git a/include/linux/leds-tca6507.h b/include/linux/leds-tca6507.h
index 3b8ac62..dcabf4f 100644
--- a/include/linux/leds-tca6507.h
+++ b/include/linux/leds-tca6507.h
@@ -24,9 +24,10 @@
 
 struct tca6507_platform_data {
 	struct led_platform_data leds;
+#ifdef CONFIG_GPIOLIB
 	int gpio_base;
 	void (*setup)(unsigned gpio_base, unsigned ngpio);
-	void (*teardown)(unsigned gpio_base, unsigned ngpio);
+#endif
 };
 
 #define	TCA6507_MAKE_GPIO 1


