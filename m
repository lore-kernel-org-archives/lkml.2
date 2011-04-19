Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab1DSXPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 19:15:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751945Ab1DSXPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 19:15:40 -0400
Date: Tue, 19 Apr 2011 16:14:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Weitzel <j.weitzel@phytec.de>
Cc: riku.voipio@iki.fi, rpurdie@rpsys.net, linux-kernel@vger.kernel.org,
        Joachim Eastwood <joachim.eastwood@jotron.com>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] leds: leds-pca9532 add support pca9530, pca9531 and
 pca9533
Message-Id: <20110419161452.4c1fd674.akpm@linux-foundation.org>
In-Reply-To: <1301992043-9552-1-git-send-email-j.weitzel@phytec.de>
References: <1301992043-9552-1-git-send-email-j.weitzel@phytec.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011 10:27:23 +0200
Jan Weitzel <j.weitzel@phytec.de> wrote:

> Adding chipinfo to use driver with pca953x family
> Rename driver to pca953x, but left files and platformflags named pca9532
> 
> Tested with pca9530 and pca9533

The patch generates rather a mess when merged on top of
drivers-leds-leds-pca9532c-add-gpio-capability.patch, below.

I suspect the changes in your patch also need to be made to the code
which drivers-leds-leds-pca9532c-add-gpio-capability.patch added.  So
could you please review the below change and redo and retest your patch
on top of it?

Thanks.


From: Joachim Eastwood <manabian@gmail.com>

Allow unused leds on pca9532 to be used as gpio.  The board I am working
on now has no less than 6 pca9532 chips.  One chips is used for only leds,
one has 14 leds and 2 gpio and the rest of the chips are gpio only.

There is also one board in mainline which could use this capabilty;
arch/arm/mach-iop32x/n2100.c
 232         {       .type = PCA9532_TYPE_NONE }, /* power OFF gpio */
 233         {       .type = PCA9532_TYPE_NONE }, /* reset gpio */

This patch defines a new pin type, PCA9532_TYPE_GPIO, and registers a
gpiochip if any pin has this type set.  The gpio will registers all chip
pins but will filter on gpio_request.

[randy.dunlap@oracle.com: fix build when GPIOLIB is not enabled]
Signed-off-by: Joachim Eastwood <joachim.eastwood@jotron.com>
Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jan Weitzel <j.weitzel@phytec.de>
Cc: Juergen Kilb <j.kilb@phytec.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig         |   10 ++
 drivers/leds/leds-pca9532.c  |  113 ++++++++++++++++++++++++++++++++-
 include/linux/leds-pca9532.h |    3 
 3 files changed, 122 insertions(+), 4 deletions(-)

diff -puN drivers/leds/Kconfig~drivers-leds-leds-pca9532c-add-gpio-capability drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~drivers-leds-leds-pca9532c-add-gpio-capability
+++ a/drivers/leds/Kconfig
@@ -154,6 +154,16 @@ config LEDS_PCA9532
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
diff -puN drivers/leds/leds-pca9532.c~drivers-leds-leds-pca9532c-add-gpio-capability drivers/leds/leds-pca9532.c
--- a/drivers/leds/leds-pca9532.c~drivers-leds-leds-pca9532c-add-gpio-capability
+++ a/drivers/leds/leds-pca9532.c
@@ -19,7 +19,9 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 #include <linux/leds-pca9532.h>
+#include <linux/gpio.h>
 
+#define PCA9532_REG_INPUT(i) ((i)/8)
 #define PCA9532_REG_PSC(i) (0x2+(i)*2)
 #define PCA9532_REG_PWM(i) (0x3+(i)*2)
 #define PCA9532_REG_LS0  0x6
@@ -34,6 +36,9 @@ struct pca9532_data {
 	struct mutex update_lock;
 	struct input_dev *idev;
 	struct work_struct work;
+#ifdef CONFIG_LEDS_PCA9532_GPIO
+	struct gpio_chip gpio;
+#endif
 	u8 pwm[2];
 	u8 psc[2];
 };
@@ -200,16 +205,68 @@ static void pca9532_led_work(struct work
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
+static void pca9532_gpio_set_value(struct gpio_chip *gc, unsigned offset, int val)
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
+static int pca9532_gpio_direction_output(struct gpio_chip *gc, unsigned offset, int val)
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
@@ -224,12 +281,26 @@ static void pca9532_destroy_devices(stru
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
@@ -249,6 +320,9 @@ static int pca9532_configure(struct i2c_
 		switch (led->type) {
 		case PCA9532_TYPE_NONE:
 			break;
+		case PCA9532_TYPE_GPIO:
+			gpios++;
+			break;
 		case PCA9532_TYPE_LED:
 			led->state = pled->state;
 			led->name = pled->name;
@@ -297,6 +371,34 @@ static int pca9532_configure(struct i2c_
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
@@ -337,7 +439,12 @@ static int pca9532_probe(struct i2c_clie
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
diff -puN include/linux/leds-pca9532.h~drivers-leds-leds-pca9532c-add-gpio-capability include/linux/leds-pca9532.h
--- a/include/linux/leds-pca9532.h~drivers-leds-leds-pca9532c-add-gpio-capability
+++ a/include/linux/leds-pca9532.h
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
_

