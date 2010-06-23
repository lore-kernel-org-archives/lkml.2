Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232Ab0FWB7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 21:59:24 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:17231 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750938Ab0FWB7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 21:59:22 -0400
Message-ID: <4C216A79.7000305@bluewatersys.com>
Date: Wed, 23 Jun 2010 13:59:21 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux kernel <linux-kernel@vger.kernel.org>,
       ext-jani.1.nikula@nokia.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: [RFC PATCH] Rework gpio cansleep (was Re: gpiolib and sleeping gpios)
References: <4C1E88AE.5070808@bluewatersys.com> <887171.45295.qm@web180307.mail.gq1.yahoo.com> <20100621050957.GA23094@pengutronix.de>
In-Reply-To: <20100621050957.GA23094@pengutronix.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2010 05:09 PM, Uwe Kleine-König wrote:
> Hi,
>
> On Sun, Jun 20, 2010 at 07:40:46PM -0700, David Brownell wrote:
>   
>>>> And they will trigger runtime warnings, and
>>>> thus eventually get fixed.
>>>>         
>>> \
>>>   }
>>>
>>>   err = gpio_request(some_gpio, "some_gpio",
>>>           GPIOF_NO_SLEEP);
>>>       
>>
>> NAK ... keep it simple.  Such flags are
>> clearly not necessary...
>>
>> I understand that some folk are bothered
>> by concepts/frameworks that seem "too simple"
>> and thus want to complexify them.  In this
>> case I am in a position to help avoid that.
>> Complexity is not a virtue.
>>     
> I'm against such an additional flag, too.  But I still think merging
> gpio_get_value and gpio_get_value_cansleep is nice.
>
> Best regards
> Uwe
>
>   

Okay, here is a rough patch to demonstrate how I think the gpiolib
framework could be simplified for cansleep gpios.

'Can sleep' for a gpio has two different meanings depending on context:
1) When talking about a gpio chip, 'can sleep' refers to whether or not
the set/get functions for the gpio may sleep. For example, io expanders
on the i2c or spi bus may sleep.
2) When talking about a drivers use of a gpio, 'can sleep' refers to
whether or not the the driver ever calls gpio_(set/get)_value for a
particular gpio in a context where it is not possible to sleep. For
example, if a driver calls gpio_get_value(gpio) from an interupt handler
then the gpio must not be a sleeping gpio.

This patch introduces a new flag, FLAG_CANSLEEP, internal to gpiolib
which denotes that a requested gpio may be used in a sleeping context. A
new request function, gpio_request_cansleep, requests a gpio which may
only be used from sleep possible contexts (ie cannot be used from
interrupt handlers, inside spinlocks, etc). The existing gpio_request
function requests a gpio, but does not allow it to be used from a
context where sleep is not possible. If a sleeping gpio is passed to
gpio_request then -EINVAL is returned.

The gpio_(set/get)_value_cansleep functions are removed, and all callers
now use gpio_(set/get)_value. might_sleep_if is used to warn about
incorrect uses of sleeping gpios.

The benefits I see to this approach are:
 - Using gpio_request/gpio_request_cansleep means that passing a
sleeping gpio to a driver that calls gpio_(set/get)_value from non-sleep
safe context is caught at request time and handled as an error.
 - The API is simplified by combining gpio_(set/get)_value and
gpio_(set/get)_value_cansleep

~Ryan

---

 arch/arm/mach-davinci/board-dm355-evm.c     |   12 ++--
 arch/arm/mach-davinci/board-dm355-leopard.c |   12 ++--
 arch/arm/mach-davinci/board-dm644x-evm.c    |    4 +-
 drivers/gpio/gpiolib.c                      |   67 ++++++++++++++-------------
 drivers/input/keyboard/matrix_keypad.c      |   10 ++--
 drivers/leds/leds-gpio.c                    |    7 ++-
 drivers/leds/leds-lt3593.c                  |   14 +++---
 drivers/mmc/host/omap_hsmmc.c               |   11 ++--
 drivers/regulator/fixed.c                   |    6 +-
 drivers/usb/musb/davinci.c                  |    4 +-
 drivers/watchdog/wm831x_wdt.c               |    4 +-
 include/asm-generic/gpio.h                  |   16 ------
 include/linux/gpio.h                        |   18 ++-----
 sound/soc/s3c24xx/s3c24xx_simtec.c          |    8 ++--
 14 files changed, 88 insertions(+), 105 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index a319101..853fd12 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -118,10 +118,10 @@ static int dm355evm_mmc_gpios = -EINVAL;
 
 static void dm355evm_mmcsd_gpios(unsigned gpio)
 {
-	gpio_request(gpio + 0, "mmc0_ro");
-	gpio_request(gpio + 1, "mmc0_cd");
-	gpio_request(gpio + 2, "mmc1_ro");
-	gpio_request(gpio + 3, "mmc1_cd");
+	gpio_request_cansleep(gpio + 0, "mmc0_ro");
+	gpio_request_cansleep(gpio + 1, "mmc0_cd");
+	gpio_request_cansleep(gpio + 2, "mmc1_ro");
+	gpio_request_cansleep(gpio + 3, "mmc1_cd");
 
 	/* we "know" these are input-only so we don't
 	 * need to call gpio_direction_input()
@@ -262,7 +262,7 @@ static int dm355evm_mmc_get_cd(int module)
 	if (!gpio_is_valid(dm355evm_mmc_gpios))
 		return -ENXIO;
 	/* low == card present */
-	return !gpio_get_value_cansleep(dm355evm_mmc_gpios + 2 * module + 1);
+	return !gpio_get_value(dm355evm_mmc_gpios + 2 * module + 1);
 }
 
 static int dm355evm_mmc_get_ro(int module)
@@ -270,7 +270,7 @@ static int dm355evm_mmc_get_ro(int module)
 	if (!gpio_is_valid(dm355evm_mmc_gpios))
 		return -ENXIO;
 	/* high == card's write protect switch active */
-	return gpio_get_value_cansleep(dm355evm_mmc_gpios + 2 * module + 0);
+	return gpio_get_value(dm355evm_mmc_gpios + 2 * module + 0);
 }
 
 static struct davinci_mmc_config dm355evm_mmc_config = {
diff --git a/arch/arm/mach-davinci/board-dm355-leopard.c b/arch/arm/mach-davinci/board-dm355-leopard.c
index f1d8132..99a9a9c 100644
--- a/arch/arm/mach-davinci/board-dm355-leopard.c
+++ b/arch/arm/mach-davinci/board-dm355-leopard.c
@@ -110,10 +110,10 @@ static int leopard_mmc_gpio = -EINVAL;
 
 static void dm355leopard_mmcsd_gpios(unsigned gpio)
 {
-	gpio_request(gpio + 0, "mmc0_ro");
-	gpio_request(gpio + 1, "mmc0_cd");
-	gpio_request(gpio + 2, "mmc1_ro");
-	gpio_request(gpio + 3, "mmc1_cd");
+	gpio_request_cansleep(gpio + 0, "mmc0_ro");
+	gpio_request_cansleep(gpio + 1, "mmc0_cd");
+	gpio_request_cansleep(gpio + 2, "mmc1_ro");
+	gpio_request_cansleep(gpio + 3, "mmc1_cd");
 
 	/* we "know" these are input-only so we don't
 	 * need to call gpio_direction_input()
@@ -185,7 +185,7 @@ static int dm355leopard_mmc_get_cd(int module)
 	if (!gpio_is_valid(leopard_mmc_gpio))
 		return -ENXIO;
 	/* low == card present */
-	return !gpio_get_value_cansleep(leopard_mmc_gpio + 2 * module + 1);
+	return !gpio_get_value(leopard_mmc_gpio + 2 * module + 1);
 }
 
 static int dm355leopard_mmc_get_ro(int module)
@@ -193,7 +193,7 @@ static int dm355leopard_mmc_get_ro(int module)
 	if (!gpio_is_valid(leopard_mmc_gpio))
 		return -ENXIO;
 	/* high == card's write protect switch active */
-	return gpio_get_value_cansleep(leopard_mmc_gpio + 2 * module + 0);
+	return gpio_get_value(leopard_mmc_gpio + 2 * module + 0);
 }
 
 static struct davinci_mmc_config dm355leopard_mmc_config = {
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index 34c8b41..5cf037c 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -335,7 +335,7 @@ static int sw_gpio;
 static ssize_t
 sw_show(struct device *d, struct device_attribute *a, char *buf)
 {
-	char *s = gpio_get_value_cansleep(sw_gpio) ? "on\n" : "off\n";
+	char *s = gpio_get_value(sw_gpio) ? "on\n" : "off\n";
 
 	strcpy(buf, s);
 	return strlen(s);
@@ -350,7 +350,7 @@ evm_u18_setup(struct i2c_client *client, int gpio, unsigned ngpio, void *c)
 
 	/* export dip switch option */
 	sw_gpio = gpio + 7;
-	status = gpio_request(sw_gpio, "user_sw");
+	status = gpio_request_cansleep(sw_gpio, "user_sw");
 	if (status == 0)
 		status = gpio_direction_input(sw_gpio);
 	if (status == 0)
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 3ca3654..6090ddc 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -55,6 +55,7 @@ struct gpio_desc {
 #define FLAG_TRIG_FALL	5	/* trigger on falling edge */
 #define FLAG_TRIG_RISE	6	/* trigger on rising edge */
 #define FLAG_ACTIVE_LOW	7	/* sysfs value has active low */
+#define FLAG_CANSLEEP	8	/* gpio may sleep during get/set */	
 
 #define PDESC_ID_SHIFT	16	/* add new flags before this one */
 
@@ -279,7 +280,7 @@ static ssize_t gpio_value_show(struct device *dev,
 	} else {
 		int value;
 
-		value = !!gpio_get_value_cansleep(gpio);
+		value = !!__gpio_get_value(gpio);
 		if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
 			value = !value;
 
@@ -310,7 +311,7 @@ static ssize_t gpio_value_store(struct device *dev,
 		if (status == 0) {
 			if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
 				value = !value;
-			gpio_set_value_cansleep(gpio, value != 0);
+			__gpio_set_value(gpio, value != 0);
 			status = size;
 		}
 	}
@@ -773,8 +774,10 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 				device_unregister(dev);
 		} else
 			status = PTR_ERR(dev);
-		if (status == 0)
+		if (status == 0) {
 			set_bit(FLAG_EXPORT, &desc->flags);
+			set_bit(FLAG_CANSLEEP, &desc->flags);
+		}
 	}
 
 	mutex_unlock(&sysfs_lock);
@@ -1152,7 +1155,7 @@ EXPORT_SYMBOL_GPL(gpiochip_remove);
  * on each other, and help provide better diagnostics in debugfs.
  * They're called even less than the "set direction" calls.
  */
-int gpio_request(unsigned gpio, const char *label)
+static int __gpio_request(unsigned gpio, const char *label, int cansleep)
 {
 	struct gpio_desc	*desc;
 	struct gpio_chip	*chip;
@@ -1171,6 +1174,9 @@ int gpio_request(unsigned gpio, const char *label)
 	if (!try_module_get(chip->owner))
 		goto done;
 
+	if (!cansleep && chip->cansleep)
+		goto done;
+
 	/* NOTE:  gpio_request() can be called in early boot,
 	 * before IRQs are enabled, for non-sleeping (SOC) GPIOs.
 	 */
@@ -1184,6 +1190,9 @@ int gpio_request(unsigned gpio, const char *label)
 		goto done;
 	}
 
+	if (cansleep)
+		set_bit(FLAG_CANSLEEP, &desc->flags);
+
 	if (chip->request) {
 		/* chip->request may sleep */
 		spin_unlock_irqrestore(&gpio_lock, flags);
@@ -1204,8 +1213,19 @@ done:
 	spin_unlock_irqrestore(&gpio_lock, flags);
 	return status;
 }
+
+int gpio_request(unsigned gpio, const char *label)
+{
+	return __gpio_request(gpio, label, 0);
+}
 EXPORT_SYMBOL_GPL(gpio_request);
 
+int gpio_request_cansleep(unsigned gpio, const char *label)
+{
+	return __gpio_request(gpio, label, 1);
+}
+EXPORT_SYMBOL_GPL(gpio_request_cansleep);
+
 void gpio_free(unsigned gpio)
 {
 	unsigned long		flags;
@@ -1525,9 +1545,13 @@ EXPORT_SYMBOL_GPL(gpio_set_debounce);
 int __gpio_get_value(unsigned gpio)
 {
 	struct gpio_chip	*chip;
+	struct gpio_desc	*desc;
 
 	chip = gpio_to_chip(gpio);
-	WARN_ON(extra_checks && chip->can_sleep);
+	desc = &gpio_desc[gpio];
+
+	might_sleep_if(extra_checks && (chip->cansleep || 
+					test_bit(FLAG_CANSLEEP, &desc->flags));
 	return chip->get ? chip->get(chip, gpio - chip->base) : 0;
 }
 EXPORT_SYMBOL_GPL(__gpio_get_value);
@@ -1544,9 +1568,13 @@ EXPORT_SYMBOL_GPL(__gpio_get_value);
 void __gpio_set_value(unsigned gpio, int value)
 {
 	struct gpio_chip	*chip;
+	struct gpio_desc	*desc;
 
 	chip = gpio_to_chip(gpio);
-	WARN_ON(extra_checks && chip->can_sleep);
+	desc = &gpio_desc[gpio];
+
+	might_sleep_if(extra_checks && (chip->cansleep ||
+					test_bit(FLAG_CANSLEEP, &desc->flags));
 	chip->set(chip, gpio - chip->base, value);
 }
 EXPORT_SYMBOL_GPL(__gpio_set_value);
@@ -1588,33 +1616,6 @@ int __gpio_to_irq(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(__gpio_to_irq);
 
-
-
-/* There's no value in making it easy to inline GPIO calls that may sleep.
- * Common examples include ones connected to I2C or SPI chips.
- */
-
-int gpio_get_value_cansleep(unsigned gpio)
-{
-	struct gpio_chip	*chip;
-
-	might_sleep_if(extra_checks);
-	chip = gpio_to_chip(gpio);
-	return chip->get ? chip->get(chip, gpio - chip->base) : 0;
-}
-EXPORT_SYMBOL_GPL(gpio_get_value_cansleep);
-
-void gpio_set_value_cansleep(unsigned gpio, int value)
-{
-	struct gpio_chip	*chip;
-
-	might_sleep_if(extra_checks);
-	chip = gpio_to_chip(gpio);
-	chip->set(chip, gpio - chip->base, value);
-}
-EXPORT_SYMBOL_GPL(gpio_set_value_cansleep);
-
-
 #ifdef CONFIG_DEBUG_FS
 
 static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index b443e08..e0b3884 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -52,7 +52,7 @@ static void __activate_col(const struct matrix_keypad_platform_data *pdata,
 	if (on) {
 		gpio_direction_output(pdata->col_gpios[col], level_on);
 	} else {
-		gpio_set_value_cansleep(pdata->col_gpios[col], !level_on);
+		gpio_set_value(pdata->col_gpios[col], !level_on);
 		gpio_direction_input(pdata->col_gpios[col]);
 	}
 }
@@ -78,7 +78,7 @@ static void activate_all_cols(const struct matrix_keypad_platform_data *pdata,
 static bool row_asserted(const struct matrix_keypad_platform_data *pdata,
 			 int row)
 {
-	return gpio_get_value_cansleep(pdata->row_gpios[row]) ?
+	return gpio_get_value(pdata->row_gpios[row]) ?
 			!pdata->active_low : pdata->active_low;
 }
 
@@ -273,7 +273,8 @@ static int __devinit init_matrix_gpio(struct platform_device *pdev,
 
 	/* initialized strobe lines as outputs, activated */
 	for (i = 0; i < pdata->num_col_gpios; i++) {
-		err = gpio_request(pdata->col_gpios[i], "matrix_kbd_col");
+		err = gpio_request_cansleep(pdata->col_gpios[i],
+					    "matrix_kbd_col");
 		if (err) {
 			dev_err(&pdev->dev,
 				"failed to request GPIO%d for COL%d\n",
@@ -285,7 +286,8 @@ static int __devinit init_matrix_gpio(struct platform_device *pdev,
 	}
 
 	for (i = 0; i < pdata->num_row_gpios; i++) {
-		err = gpio_request(pdata->row_gpios[i], "matrix_kbd_row");
+		err = gpio_request_cansleep(pdata->row_gpios[i],
+					    "matrix_kbd_row");
 		if (err) {
 			dev_err(&pdev->dev,
 				"failed to request GPIO%d for ROW%d\n",
diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index cc22eee..89a8278 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -42,7 +42,7 @@ static void gpio_led_work(struct work_struct *work)
 						 NULL, NULL);
 		led_dat->blinking = 0;
 	} else
-		gpio_set_value_cansleep(led_dat->gpio, led_dat->new_level);
+		gpio_set_value(led_dat->gpio, led_dat->new_level);
 }
 
 static void gpio_led_set(struct led_classdev *led_cdev,
@@ -103,7 +103,10 @@ static int __devinit create_gpio_led(const struct gpio_led *template,
 		return 0;
 	}
 
-	ret = gpio_request(template->gpio, template->name);
+	if (gpio_cansleep(template->gpio))
+		ret = gpio_request_cansleep(template->gpio, template->name);
+	else
+		ret = gpio_request(template->gpio);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/leds/leds-lt3593.c b/drivers/leds/leds-lt3593.c
index 2579678..605c6ca 100644
--- a/drivers/leds/leds-lt3593.c
+++ b/drivers/leds/leds-lt3593.c
@@ -48,25 +48,25 @@ static void lt3593_led_work(struct work_struct *work)
 	 */
 
 	if (led_dat->new_level == 0) {
-		gpio_set_value_cansleep(led_dat->gpio, 0);
+		gpio_set_value(led_dat->gpio, 0);
 		return;
 	}
 
 	pulses = 32 - (led_dat->new_level * 32) / 255;
 
 	if (pulses == 0) {
-		gpio_set_value_cansleep(led_dat->gpio, 0);
+		gpio_set_value(led_dat->gpio, 0);
 		mdelay(1);
-		gpio_set_value_cansleep(led_dat->gpio, 1);
+		gpio_set_value(led_dat->gpio, 1);
 		return;
 	}
 
-	gpio_set_value_cansleep(led_dat->gpio, 1);
+	gpio_set_value(led_dat->gpio, 1);
 
 	while (pulses--) {
-		gpio_set_value_cansleep(led_dat->gpio, 0);
+		gpio_set_value(led_dat->gpio, 0);
 		udelay(1);
-		gpio_set_value_cansleep(led_dat->gpio, 1);
+		gpio_set_value(led_dat->gpio, 1);
 		udelay(1);
 	}
 }
@@ -93,7 +93,7 @@ static int __devinit create_lt3593_led(const struct gpio_led *template,
 		return 0;
 	}
 
-	ret = gpio_request(template->gpio, template->name);
+	ret = gpio_request_cansleep(template->gpio, template->name);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index b032828..0b362a6 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -191,7 +191,7 @@ static int omap_hsmmc_card_detect(struct device *dev, int slot)
 	struct omap_mmc_platform_data *mmc = dev->platform_data;
 
 	/* NOTE: assumes card detect signal is active-low */
-	return !gpio_get_value_cansleep(mmc->slots[0].switch_pin);
+	return !gpio_get_value(mmc->slots[0].switch_pin);
 }
 
 static int omap_hsmmc_get_wp(struct device *dev, int slot)
@@ -199,7 +199,7 @@ static int omap_hsmmc_get_wp(struct device *dev, int slot)
 	struct omap_mmc_platform_data *mmc = dev->platform_data;
 
 	/* NOTE: assumes write protect signal is active-high */
-	return gpio_get_value_cansleep(mmc->slots[0].gpio_wp);
+	return gpio_get_value(mmc->slots[0].gpio_wp);
 }
 
 static int omap_hsmmc_get_cover_state(struct device *dev, int slot)
@@ -207,7 +207,7 @@ static int omap_hsmmc_get_cover_state(struct device *dev, int slot)
 	struct omap_mmc_platform_data *mmc = dev->platform_data;
 
 	/* NOTE: assumes card detect signal is active-low */
-	return !gpio_get_value_cansleep(mmc->slots[0].switch_pin);
+	return !gpio_get_value(mmc->slots[0].switch_pin);
 }
 
 #ifdef CONFIG_PM
@@ -473,7 +473,8 @@ static int omap_hsmmc_gpio_init(struct omap_mmc_platform_data *pdata)
 			pdata->slots[0].card_detect = omap_hsmmc_card_detect;
 		pdata->slots[0].card_detect_irq =
 				gpio_to_irq(pdata->slots[0].switch_pin);
-		ret = gpio_request(pdata->slots[0].switch_pin, "mmc_cd");
+		ret = gpio_request_cansleep(pdata->slots[0].switch_pin,
+					    "mmc_cd");
 		if (ret)
 			return ret;
 		ret = gpio_direction_input(pdata->slots[0].switch_pin);
@@ -484,7 +485,7 @@ static int omap_hsmmc_gpio_init(struct omap_mmc_platform_data *pdata)
 
 	if (gpio_is_valid(pdata->slots[0].gpio_wp)) {
 		pdata->slots[0].get_ro = omap_hsmmc_get_wp;
-		ret = gpio_request(pdata->slots[0].gpio_wp, "mmc_wp");
+		ret = gpio_request_cansleep(pdata->slots[0].gpio_wp, "mmc_wp");
 		if (ret)
 			goto err_free_cd;
 		ret = gpio_direction_input(pdata->slots[0].gpio_wp);
diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 2fe9d99..1e9392d 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -49,7 +49,7 @@ static int fixed_voltage_enable(struct regulator_dev *dev)
 	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
 
 	if (gpio_is_valid(data->gpio)) {
-		gpio_set_value_cansleep(data->gpio, data->enable_high);
+		gpio_set_value(data->gpio, data->enable_high);
 		data->is_enabled = true;
 	}
 
@@ -61,7 +61,7 @@ static int fixed_voltage_disable(struct regulator_dev *dev)
 	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
 
 	if (gpio_is_valid(data->gpio)) {
-		gpio_set_value_cansleep(data->gpio, !data->enable_high);
+		gpio_set_value(data->gpio, !data->enable_high);
 		data->is_enabled = false;
 	}
 
@@ -148,7 +148,7 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 			dev_warn(&pdev->dev,
 				"using GPIO 0 for regulator enable control\n");
 
-		ret = gpio_request(config->gpio, config->supply_name);
+		ret = gpio_request_cansleep(config->gpio, config->supply_name);
 		if (ret) {
 			dev_err(&pdev->dev,
 			   "Could not obtain regulator enable GPIO %d: %d\n",
diff --git a/drivers/usb/musb/davinci.c b/drivers/usb/musb/davinci.c
index 5762436..48d72d4 100644
--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -161,7 +161,7 @@ static int vbus_state = -1;
  */
 static void evm_deferred_drvvbus(struct work_struct *ignored)
 {
-	gpio_set_value_cansleep(GPIO_nVBUS_DRV, vbus_state);
+	gpio_set_value(GPIO_nVBUS_DRV, vbus_state);
 	vbus_state = !vbus_state;
 }
 
@@ -181,7 +181,7 @@ static void davinci_source_power(struct musb *musb, int is_on, int immediate)
 		static DECLARE_WORK(evm_vbus_work, evm_deferred_drvvbus);
 
 		if (immediate)
-			gpio_set_value_cansleep(GPIO_nVBUS_DRV, vbus_state);
+			gpio_set_value(GPIO_nVBUS_DRV, vbus_state);
 		else
 			schedule_work(&evm_vbus_work);
 	}
diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index 8c4b2d5..1f37574 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -123,7 +123,7 @@ static int wm831x_wdt_kick(struct wm831x *wm831x)
 	mutex_lock(&wdt_mutex);
 
 	if (update_gpio) {
-		gpio_set_value_cansleep(update_gpio, update_state);
+		gpio_set_value(update_gpio, update_state);
 		update_state = !update_state;
 		ret = 0;
 		goto out;
@@ -350,7 +350,7 @@ static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 		reg |= pdata->software << WM831X_WDOG_RST_SRC_SHIFT;
 
 		if (pdata->update_gpio) {
-			ret = gpio_request(pdata->update_gpio,
+			ret = gpio_request_cansleep(pdata->update_gpio,
 					   "Watchdog update");
 			if (ret < 0) {
 				dev_err(wm831x->dev,
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 4f3d75e..8ae678b 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -128,10 +128,6 @@ extern int gpio_direction_output(unsigned gpio, int value);
 
 extern int gpio_set_debounce(unsigned gpio, unsigned debounce);
 
-extern int gpio_get_value_cansleep(unsigned gpio);
-extern void gpio_set_value_cansleep(unsigned gpio, int value);
-
-
 /* A platform's <asm/gpio.h> code may want to inline the I/O calls when
  * the GPIO is constant and refers to some always-present controller,
  * giving direct access to chip registers and tight bitbanging loops.
@@ -200,18 +196,6 @@ static inline int gpio_cansleep(unsigned gpio)
 	return 0;
 }
 
-static inline int gpio_get_value_cansleep(unsigned gpio)
-{
-	might_sleep();
-	return gpio_get_value(gpio);
-}
-
-static inline void gpio_set_value_cansleep(unsigned gpio, int value)
-{
-	might_sleep();
-	gpio_set_value(gpio, value);
-}
-
 #endif /* !CONFIG_HAVE_GPIO_LIB */
 
 #ifndef CONFIG_GPIO_SYSFS
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 03f616b..d02e4cd 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -33,6 +33,11 @@ static inline int gpio_request(unsigned gpio, const char *label)
 	return -ENOSYS;
 }
 
+static inline int gpio_request_cansleep(unsigned gpio, const char *label)
+{
+	return -ENOSYS;
+}
+
 static inline void gpio_free(unsigned gpio)
 {
 	might_sleep();
@@ -76,19 +81,6 @@ static inline int gpio_cansleep(unsigned gpio)
 	return 0;
 }
 
-static inline int gpio_get_value_cansleep(unsigned gpio)
-{
-	/* GPIO can never have been requested or set as {in,out}put */
-	WARN_ON(1);
-	return 0;
-}
-
-static inline void gpio_set_value_cansleep(unsigned gpio, int value)
-{
-	/* GPIO can never have been requested or set as output */
-	WARN_ON(1);
-}
-
 static inline int gpio_export(unsigned gpio, bool direction_may_change)
 {
 	/* GPIO can never have been requested or set as {in,out}put */
diff --git a/sound/soc/s3c24xx/s3c24xx_simtec.c b/sound/soc/s3c24xx/s3c24xx_simtec.c
index 4984754..b22b0d4 100644
--- a/sound/soc/s3c24xx/s3c24xx_simtec.c
+++ b/sound/soc/s3c24xx/s3c24xx_simtec.c
@@ -51,8 +51,8 @@ static int speaker_gain_get(struct snd_kcontrol *kcontrol,
  */
 static void speaker_gain_set(int value)
 {
-	gpio_set_value_cansleep(pdata->amp_gain[0], value & 1);
-	gpio_set_value_cansleep(pdata->amp_gain[1], value >> 1);
+	gpio_set_value(pdata->amp_gain[0], value & 1);
+	gpio_set_value(pdata->amp_gain[1], value >> 1);
 }
 
 /**
@@ -253,13 +253,13 @@ static int attach_gpio_amp(struct device *dev,
 
 	/* attach gpio amp gain (if any) */
 	if (pdata->amp_gain[0] > 0) {
-		ret = gpio_request(pd->amp_gain[0], "gpio-amp-gain0");
+		ret = gpio_request_cansleep(pd->amp_gain[0], "gpio-amp-gain0");
 		if (ret) {
 			dev_err(dev, "cannot get amp gpio gain0\n");
 			return ret;
 		}
 
-		ret = gpio_request(pd->amp_gain[1], "gpio-amp-gain1");
+		ret = gpio_request_cansleep(pd->amp_gain[1], "gpio-amp-gain1");
 		if (ret) {
 			dev_err(dev, "cannot get amp gpio gain1\n");
 			gpio_free(pdata->amp_gain[0]);

