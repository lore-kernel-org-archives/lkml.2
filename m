Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab1BATr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 14:47:58 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60169 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab1BATr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 14:47:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=uANwOURqTOto65DXSVUzxC6w/wtKWWU/Vm6feRD1t76FFlnLQYw0StNXb0B6JVjUoh
         hrtZslLWaaVrtARy4jrLVa3kfvLYXIvD/DvTEYrwSETgES4OWXem5dcmrzmwxx/L8YuN
         6dAhlVQCY5H4dcJpbJuTRG0vRConQq3KUJyzc=
MIME-Version: 1.0
Date: Tue, 1 Feb 2011 20:40:58 +0100
Message-ID: <AANLkTikqeq_fLSEvVc34Wum1nrf6BojyUp=JAe7m8Lby@mail.gmail.com>
Subject: [PATCH] leds-pca9532: Add gpio capability v3
From: Joachim Eastwood <manabian@gmail.com>
To: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, riku.voipio@iki.fi
Cc: joachim.eastwood@jotron.com, w.sang@pengutronix.de,
        hartleys@visionengravers.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The patch below allows unused leds on pca9532 to be used as gpio. The
board I am working on now has no less than 6 pca9532 chips. One chips
is used for only leds, one has 14 leds and 2 gpio and the rest of the
chips are gpio only.

There is also one board in mainline which could use this capabilty;
arch/arm/mach-iop32x/n2100.c
 232         {       .type = PCA9532_TYPE_NONE }, /* power OFF gpio */
 233         {       .type = PCA9532_TYPE_NONE }, /* reset gpio */

This patch defines a new pin type, PCA9532_TYPE_GPIO, and registers a
gpiochip if any pin has this type set. The gpio will registers all
chip pins but will filter on gpio_request.

Changes in v3:
* Fixed direction_output funtion, thanks to H Hartley Sweeten
* direction_input now calles set_value as direction_output
* Instructions in Kconfig

Tested on custom ARM board.

-------------------------------------------------------------------
    [leds-pca9532] Add gpio capability

    Pins not used for leds can now be used as gpio by setting pin type as
    PCA9532_TYPE_GPIO and defining a gpio_base in platform data.

    Signed-off-by: Joachim Eastwood <joachim.eastwood@jotron.com>
    Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/leds/Kconfig         |   10 ++++
 drivers/leds/leds-pca9532.c  |  111 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/leds-pca9532.h |    3 +-
 3 files changed, 120 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 6f190f4..525c517 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -152,6 +152,16 @@ config LEDS_PCA9532
 	  LED controller. It is generally only useful
 	  as a platform driver

+config LEDS_PCA9532_GPIO
+	bool "Enable GPIO support for PCA9532"
+	depends on LEDS_PCA9532
+	depends on GPIOLIB
+	help
+	  Allow unused pins on PCA9532 to be used as gpio.
+
+	  To use a pin as gpio pca9532_type in pca9532_platform data needs to
+	  set to PCA9532_TYPE_GPIO.
+
 config LEDS_GPIO
 	tristate "LED Support for GPIO connected LEDs"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index afac338..ad008bb 100644
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
@@ -200,16 +203,68 @@ static void pca9532_led_work(struct work_struct *work)
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
+
+static int pca9532_gpio_direction_input(struct gpio_chip *gc, unsigned offset)
+{
+	/* To use as input ensure pin is not driven */
+	pca9532_gpio_set_value(gc, offset, 0);
+
+	return 0;
+}
+
+static int pca9532_gpio_direction_output(struct gpio_chip *gc,
unsigned offset, int val)
+{
+	pca9532_gpio_set_value(gc, offset, val);
+
+	return 0;
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
@@ -224,12 +279,26 @@ static void pca9532_destroy_devices(struct
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
@@ -249,6 +318,9 @@ static int pca9532_configure(struct i2c_client *client,
 		switch (led->type) {
 		case PCA9532_TYPE_NONE:
 			break;
+		case PCA9532_TYPE_GPIO:
+			gpios++;
+			break;
 		case PCA9532_TYPE_LED:
 			led->state = pled->state;
 			led->name = pled->name;
@@ -297,6 +369,34 @@ static int pca9532_configure(struct i2c_client *client,
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
@@ -337,7 +437,12 @@ static int pca9532_probe(struct i2c_client *client,
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
