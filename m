Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab0KPTjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:39:46 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:56983 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756304Ab0KPTjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:39:45 -0500
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Paul Mundt <lethal@linux-sh.org>,
        Alexander Clouter <alex@digriz.org.uk>,
        "Govindarajan, Sriramakrishnan" <srk@ti.com>
Subject: [PATCH v2 4/4] da850-evm: add baseboard UI expander buttons, switches and LEDs
Date: Tue, 16 Nov 2010 14:39:37 -0500
Message-Id: <d6d59b4a3c34149008f3681e0d6106efa15f354d.1289935504.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1289935504.git.bengardiner@nanometrics.ca>
References: <cover.1289835508.git.bengardiner@nanometrics.ca> <cover.1289935504.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a pca953x platform device for the tca6416 found on the evm
baseboard. The tca6416 is a GPIO expander, also found on the UI board at a
separate I2C address. The pins of the baseboard IO expander are connected to
software reset, deep sleep enable, test points, a push button, DIP switches and
LEDs.

Add support for the push button, DIP switches and LEDs and test points (as
free GPIOs). The reset and deep sleep enable connections are reserved by the
setup routine so that userspace can't toggle those lines.

The existing tca6416-keypad driver was not employed because there was no
apararent way to register the LEDs connected to gpio's on the tca6416 while
simultaneously registering the tca6416-keypad instance.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
Reviewed-by: Chris Cordahi <christophercordahi@nanometrics.ca>
CC: Govindarajan, Sriramakrishnan <srk@ti.com>

---

Changes since v1:
 * adding note about why the tca6416-keypad driver was not used.
 * adding Govindarajan, Sriramakrishnan, the author of the tca6416-keypad
   driver
---
 arch/arm/mach-davinci/board-da850-evm.c |  217 ++++++++++++++++++++++++++++++-
 1 files changed, 213 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index dcf21e5..79f2c95 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -410,6 +410,208 @@ static int da850_evm_ui_expander_teardown(struct i2c_client *client,
 	return 0;
 }
 
+/* assign the baseboard expander's GPIOs after the UI board's */
+#define DA850_UI_EXPANDER_N_GPIOS ARRAY_SIZE(ui_expander_names)
+#define DA850_BB_EXPANDER_GPIO_BASE (DAVINCI_N_GPIO + DA850_UI_EXPANDER_N_GPIOS)
+
+static const char const *baseboard_expander_names[] = {
+	"deep_sleep_en", "sw_rst", "tp_23", "tp_22", "tp_21", "user_pb1",
+	"user_led2", "user_led1", "user_sw_1", "user_sw_2", "user_sw_3",
+	"user_sw_4", "user_sw_5", "user_sw_6", "user_sw_7", "user_sw_8"
+};
+
+#define DA850_DEEP_SLEEP_EN_OFFSET		0
+#define DA850_SW_RST_OFFSET			1
+#define DA850_PB1_OFFSET			5
+#define DA850_USER_LED2_OFFSET			6
+#define DA850_USER_SW_1_OFFSET			8
+
+#define DA850_N_USER_SW				8
+#define DA850_N_USER_LED			2
+
+static struct gpio_keys_button user_pb_gpio_key = {
+	.code = KEY_PROG1,
+	.type = EV_KEY,
+	.active_low = 1,
+	.wakeup = 0,
+	.debounce_interval = DA850_PB_DEBOUNCE_MS,
+	.gpio = -1, /* assigned at runtime */
+	.desc = NULL, /* assigned at runtime */
+};
+
+static struct gpio_keys_platform_data user_pb_gpio_key_platform_data = {
+	.buttons = &user_pb_gpio_key,
+	.nbuttons = 1,
+	.rep = 0, /* disable auto-repeat */
+	.poll_interval = DA850_PB_POLL_MS,
+};
+
+static struct platform_device user_pb_gpio_key_device = {
+	.name = "gpio-keys",
+	.id = 1,
+	.dev = {
+		.platform_data = &user_pb_gpio_key_platform_data
+	}
+};
+
+static struct gpio_keys_button user_sw_gpio_keys[DA850_N_USER_SW];
+
+static struct gpio_keys_platform_data user_sw_gpio_key_platform_data = {
+	.buttons = user_sw_gpio_keys,
+	.nbuttons = ARRAY_SIZE(user_sw_gpio_keys),
+	.rep = 0, /* disable auto-repeat */
+	.poll_interval = DA850_SW_POLL_MS,
+};
+
+static struct platform_device user_sw_gpio_key_device = {
+	.name = "gpio-keys",
+	.id = 2,
+	.dev = {
+		.platform_data = &user_sw_gpio_key_platform_data
+	}
+};
+
+static void da850_user_switches_init(unsigned gpio)
+{
+	int i;
+	struct gpio_keys_button *button;
+
+	for (i = 0; i < DA850_N_USER_SW; i++) {
+		button = &user_sw_gpio_keys[i];
+
+		button->code = SW_LID + i;
+		button->type = EV_SW;
+		button->active_low = 1;
+		button->wakeup = 0;
+		button->debounce_interval = DA850_PB_DEBOUNCE_MS;
+		button->desc = (char *)
+			baseboard_expander_names[DA850_USER_SW_1_OFFSET + i];
+
+		button->gpio = gpio + DA850_USER_SW_1_OFFSET + i;
+	}
+}
+
+static struct gpio_led user_leds[DA850_N_USER_LED];
+
+static struct gpio_led_platform_data user_led_gpio_data = {
+	.leds = user_leds,
+	.num_leds = ARRAY_SIZE(user_leds),
+};
+
+static struct platform_device user_leds_gpio_device = {
+	.name		= "leds-gpio",
+	.id		= -1,
+	.dev = {
+		.platform_data = &user_led_gpio_data
+	}
+};
+
+static void da850_user_leds_init(unsigned gpio)
+{
+	int i;
+	struct gpio_led *led;
+
+	for (i = 0; i < DA850_N_USER_LED; i++) {
+		led = &user_leds[i];
+
+		led->active_low = 1;
+		led->gpio = gpio + DA850_USER_LED2_OFFSET + i;
+		led->name =
+			baseboard_expander_names[DA850_USER_LED2_OFFSET + i];
+	}
+}
+
+static int da850_evm_baseboard_expander_setup(struct i2c_client *client,
+						unsigned gpio, unsigned ngpio,
+						void *c)
+{
+	int ret;
+	int deep_sleep_en, sw_rst;
+
+	deep_sleep_en	= gpio + DA850_DEEP_SLEEP_EN_OFFSET;
+	sw_rst		= gpio + DA850_SW_RST_OFFSET;
+
+	/* Do not allow sysfs control of deep_sleep_en */
+	ret = gpio_request(deep_sleep_en,
+			baseboard_expander_names[DA850_DEEP_SLEEP_EN_OFFSET]);
+	if (ret) {
+		pr_warning("Cannot open IO expander pin %d\n", deep_sleep_en);
+		goto io_exp_setup_deep_sleep_en_fail;
+	}
+	/* do not drive a value on deep_sleep_en */
+	gpio_direction_input(deep_sleep_en);
+
+	/* Do not allow sysfs control of sw_rst */
+	ret = gpio_request(sw_rst,
+			baseboard_expander_names[DA850_SW_RST_OFFSET]);
+	if (ret) {
+		pr_warning("Cannot open IO expander pin %d\n", sw_rst);
+		goto io_exp_setup_sw_rst_fail;
+	}
+	/* do not drive a value on sw_rst */
+	gpio_direction_input(sw_rst);
+
+	/* Register user_pb1 as a gpio-keys button */
+	user_pb_gpio_key.desc = (char *)
+			baseboard_expander_names[DA850_PB1_OFFSET];
+	user_pb_gpio_key.gpio = gpio + DA850_PB1_OFFSET;
+	ret = platform_device_register(&user_pb_gpio_key_device);
+	if (ret) {
+		pr_warning("Cannot register user pb: %d\n", ret);
+		goto io_exp_setup_pb_fail;
+	}
+
+	/*
+	 * Register the switches as a separate gpio-keys device so the fast
+	 * polling interval for the pushbuttons is not wasted on switches
+	 */
+	da850_user_switches_init(gpio);
+	ret = platform_device_register(&user_sw_gpio_key_device);
+	if (ret) {
+		pr_warning("Could not register baseboard GPIO expander switches"
+						" device\n");
+		goto io_exp_setup_sw_fail;
+	}
+
+	da850_user_leds_init(gpio);
+	ret = platform_device_register(&user_leds_gpio_device);
+	if (ret) {
+		pr_warning("Could not register baseboard GPIO expander LEDS "
+				"device\n");
+		goto io_exp_setup_leds_fail;
+	}
+
+	return 0;
+
+io_exp_setup_leds_fail:
+	platform_device_unregister(&user_sw_gpio_key_device);
+io_exp_setup_sw_fail:
+	platform_device_unregister(&user_pb_gpio_key_device);
+io_exp_setup_pb_fail:
+	gpio_free(sw_rst);
+io_exp_setup_sw_rst_fail:
+	gpio_free(deep_sleep_en);
+io_exp_setup_deep_sleep_en_fail:
+	return ret;
+}
+
+static int da850_evm_baseboard_expander_teardown(struct i2c_client *client,
+					unsigned gpio, unsigned ngpio, void *c)
+{
+	int deep_sleep_en, sw_rst;
+
+	deep_sleep_en	= gpio + DA850_DEEP_SLEEP_EN_OFFSET;
+	sw_rst		= gpio + DA850_SW_RST_OFFSET;
+
+	platform_device_unregister(&user_leds_gpio_device);
+	platform_device_unregister(&user_sw_gpio_key_device);
+	platform_device_unregister(&user_pb_gpio_key_device);
+	gpio_free(sw_rst);
+	gpio_free(deep_sleep_en);
+
+	return 0;
+}
+
 static struct pca953x_platform_data da850_evm_ui_expander_info = {
 	.gpio_base	= DAVINCI_N_GPIO,
 	.setup		= da850_evm_ui_expander_setup,
@@ -417,6 +619,13 @@ static struct pca953x_platform_data da850_evm_ui_expander_info = {
 	.names		= ui_expander_names,
 };
 
+static struct pca953x_platform_data da850_evm_baseboard_expander_info = {
+	.gpio_base	= DA850_BB_EXPANDER_GPIO_BASE,
+	.setup		= da850_evm_baseboard_expander_setup,
+	.teardown	= da850_evm_baseboard_expander_teardown,
+	.names		= baseboard_expander_names,
+};
+
 static struct i2c_board_info __initdata da850_evm_i2c_devices[] = {
 	{
 		I2C_BOARD_INFO("tlv320aic3x", 0x18),
@@ -424,10 +633,10 @@ static struct i2c_board_info __initdata da850_evm_i2c_devices[] = {
 	{
 		I2C_BOARD_INFO("tca6416", 0x20),
 		.platform_data = &da850_evm_ui_expander_info,
-		/*
-		 * TODO : populate at runtime using
-		 * .irq = gpio_to_irq(GPIO_TO_PIN(2,7)),
-		 */
+	},
+	{
+		I2C_BOARD_INFO("tca6416", 0x21),
+		.platform_data = &da850_evm_baseboard_expander_info,
 	},
 };
 
-- 
1.7.0.4

