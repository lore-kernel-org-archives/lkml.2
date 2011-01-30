Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab1A3UUP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 15:20:15 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42930 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab1A3UUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 15:20:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=g4uvQ49ziLTD6r2l8q8r80bsjYCMs9YBB29kQsxxI/4C26vddp8zLI6H1iHFFsbOVX
         mBcn2pdlMKg5X94L+y2SCS22bmNEBllekXRyjHvBSutpAkimQCvL7mxgBJbAJJhH/Xwz
         +fBVVonbcWWsc/YmtgwG7m8pj5fV/PaiEa0UE=
MIME-Version: 1.0
Date: Sun, 30 Jan 2011 21:20:13 +0100
Message-ID: <AANLkTinuphNyLoFz1TLxFJ6=g+GMph6njGhs2FBB6Evj@mail.gmail.com>
Subject: [leds-pca9532] Add gpio capability v2
From: Joachim Eastwood <manabian@gmail.com>
To: rpurdie@rpsys.net, riku.voipio@iki.fi, linux-kernel@vger.kernel.org
Cc: joachim.eastwood@jotron.com, Wolfram Sang <w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is v2 of the patch to add gpio capability to the leds-pca9532
driver. Please read the first mail in this thread for more
information.

Changes in v2:
* Add Kconfig magic. gpio capability is now optional
* Addressed review from Wolfram Sang

Wolfram: If this looks okey can I add your Reviewed-by tag?

--------------------------------------------------------------------------
    [leds-pca9532] Add gpio capability

    Pins not used for leds can now be used as gpio by setting pin type as
    PCA9532_TYPE_GPIO and defining a gpio_base in platform data.

    Signed-off-by: Joachim Eastwood <joachim.eastwood@jotron.com>

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 6f190f4..7212f57 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -152,6 +152,13 @@ config LEDS_PCA9532
 	  LED controller. It is generally only useful
 	  as a platform driver

+config LEDS_PCA9532_GPIO
+	bool "Enable GPIO support for PCA9532"
+	depends on LEDS_PCA9532
+	depends on GPIOLIB
+	help
+	  Allow unused pins on PCA9532 to be used as gpio.
+
 config LEDS_GPIO
 	tristate "LED Support for GPIO connected LEDs"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index afac338..0eaa774 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -19,7 +19,9 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 #include <linux/leds-pca9532.h>
+#include <linux/gpio.h>

+#define PCA9532_REG_INPUT(i) ((i)/8)
 #define PCA9532_REG_PSC(i) (0x2+(i)*2)
 #define PCA9532_REG_PWM(i) (0x3+(i)*2)
 #define PCA9532_REG_LS0  0x6
@@ -34,6 +36,7 @@ struct pca9532_data {
 	struct mutex update_lock;
 	struct input_dev *idev;
 	struct work_struct work;
+	struct gpio_chip gpio;
 	u8 pwm[2];
 	u8 psc[2];
 };
@@ -200,16 +203,71 @@ static void pca9532_led_work(struct work_struct *work)
 	pca9532_setled(led);
 }

-static void pca9532_destroy_devices(struct pca9532_data *data, int n_devs)
+#ifdef CONFIG_LEDS_PCA9532_GPIO
+static int pca9532_gpio_request_pin(struct gpio_chip *gc, unsigned offset)
+{
+	struct pca9532_data *data = container_of(gc, struct pca9532_data, gpio);
+	struct pca9532_led *led = &data->leds[offset];
+
+	if (led->type == PCA9532_TYPE_GPIO)
+		return 0;
+
+	return -EBUSY;
+}
+
+static int pca9532_gpio_direction_input(struct gpio_chip *gc, unsigned offset)
+{
+	struct pca9532_data *data = container_of(gc, struct pca9532_data, gpio);
+	struct pca9532_led *led = &data->leds[offset];
+
+	/* To use as input ensure pin is not driven */
+	led->state = PCA9532_OFF;
+	pca9532_setled(led);
+
+	return 0;
+}
+
+static int pca9532_gpio_direction_output(struct gpio_chip *gc,
unsigned offset, int val)
+{
+	return 0;
+}
+
+
+static void pca9532_gpio_set_value(struct gpio_chip *gc, unsigned
offset, int val)
+{
+	struct pca9532_data *data = container_of(gc, struct pca9532_data, gpio);
+	struct pca9532_led *led = &data->leds[offset];
+
+	if (val)
+		led->state = PCA9532_ON;
+	else
+		led->state = PCA9532_OFF;
+
+	pca9532_setled(led);
+}
+
+static int pca9532_gpio_get_value(struct gpio_chip *gc, unsigned offset)
+{
+	struct pca9532_data *data = container_of(gc, struct pca9532_data, gpio);
+	unsigned char reg;
+
+	reg = i2c_smbus_read_byte_data(data->client, PCA9532_REG_INPUT(offset));
+
+	return !!(reg & (1 << (offset % 8)));
+}
+#endif /* CONFIG_LEDS_PCA9532_GPIO */
+
+static int pca9532_destroy_devices(struct pca9532_data *data, int n_devs)
 {
 	int i = n_devs;

 	if (!data)
-		return;
+		return -EINVAL;

 	while (--i >= 0) {
 		switch (data->leds[i].type) {
 		case PCA9532_TYPE_NONE:
+		case PCA9532_TYPE_GPIO:
 			break;
 		case PCA9532_TYPE_LED:
 			led_classdev_unregister(&data->leds[i].ldev);
@@ -224,12 +282,26 @@ static void pca9532_destroy_devices(struct
pca9532_data *data, int n_devs)
 			break;
 		}
 	}
+
+#ifdef CONFIG_LEDS_PCA9532_GPIO
+	if (data->gpio.dev) {
+		int err = gpiochip_remove(&data->gpio);
+		if (err) {
+			dev_err(&data->client->dev, "%s failed, %d\n",
+						"gpiochip_remove()", err);
+			return err;
+		}
+	}
+#endif
+
+	return 0;
 }

 static int pca9532_configure(struct i2c_client *client,
 	struct pca9532_data *data, struct pca9532_platform_data *pdata)
 {
 	int i, err = 0;
+	int gpios = 0;

 	for (i = 0; i < 2; i++)	{
 		data->pwm[i] = pdata->pwm[i];
@@ -249,6 +321,9 @@ static int pca9532_configure(struct i2c_client *client,
 		switch (led->type) {
 		case PCA9532_TYPE_NONE:
 			break;
+		case PCA9532_TYPE_GPIO:
+			gpios++;
+			break;
 		case PCA9532_TYPE_LED:
 			led->state = pled->state;
 			led->name = pled->name;
@@ -297,6 +372,34 @@ static int pca9532_configure(struct i2c_client *client,
 			break;
 		}
 	}
+
+#ifdef CONFIG_LEDS_PCA9532_GPIO
+	if (gpios) {
+		data->gpio.label = "gpio-pca9532";
+		data->gpio.direction_input = pca9532_gpio_direction_input;
+		data->gpio.direction_output = pca9532_gpio_direction_output;
+		data->gpio.set = pca9532_gpio_set_value;
+		data->gpio.get = pca9532_gpio_get_value;
+		data->gpio.request = pca9532_gpio_request_pin;
+		data->gpio.can_sleep = 1;
+		data->gpio.base = pdata->gpio_base;
+		data->gpio.ngpio = 16;
+		data->gpio.dev = &client->dev;
+		data->gpio.owner = THIS_MODULE;
+
+		err = gpiochip_add(&data->gpio);
+		if (err) {
+			/* Use data->gpio.dev as a flag for freeing gpiochip */
+			data->gpio.dev = NULL;
+			dev_warn(&client->dev, "could not add gpiochip\n");
+		} else {
+			dev_info(&client->dev, "gpios %i...%i\n",
+				data->gpio.base, data->gpio.base +
+				data->gpio.ngpio - 1);
+		}
+	}
+#endif
+
 	return 0;

 exit:
@@ -337,7 +440,12 @@ static int pca9532_probe(struct i2c_client *client,
 static int pca9532_remove(struct i2c_client *client)
 {
 	struct pca9532_data *data = i2c_get_clientdata(client);
-	pca9532_destroy_devices(data, 16);
+	int err;
+
+	err = pca9532_destroy_devices(data, 16);
+	if (err)
+		return err;
+
 	kfree(data);
 	return 0;
 }
diff --git a/include/linux/leds-pca9532.h b/include/linux/leds-pca9532.h
index f158eb1..b8d6fff 100644
--- a/include/linux/leds-pca9532.h
+++ b/include/linux/leds-pca9532.h
@@ -25,7 +25,7 @@ enum pca9532_state {
 };

 enum pca9532_type { PCA9532_TYPE_NONE, PCA9532_TYPE_LED,
-	PCA9532_TYPE_N2100_BEEP };
+	PCA9532_TYPE_N2100_BEEP, PCA9532_TYPE_GPIO };

 struct pca9532_led {
 	u8 id;
@@ -41,6 +41,7 @@ struct pca9532_platform_data {
 	struct pca9532_led leds[16];
 	u8 pwm[2];
 	u8 psc[2];
+	int gpio_base;
 };

 #endif /* __LINUX_PCA9532_H */
