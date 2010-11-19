Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab0KSVhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:37:43 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:57474 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757091Ab0KSVhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:37:39 -0500
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Paul Mundt <lethal@linux-sh.org>, Sekhar Nori <nsekhar@ti.com>,
        "Govindarajan, Sriramakrishnan" <srk@ti.com>
Subject: [PATCH v3 4/4] da850-evm: add baseboard GPIO expander buttons, switches and LEDs
Date: Fri, 19 Nov 2010 16:37:23 -0500
Message-Id: <784b0a3281316ff90ecd3d52d224bbba1dd4ddb9.1290201713.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1290201713.git.bengardiner@nanometrics.ca>
References: <cover.1289935504.git.bengardiner@nanometrics.ca> <cover.1290201713.git.bengardiner@nanometrics.ca>
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
Reviewed-by: Sekhar Nori <nsekhar@ti.com>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

---

Changes since v2:
 * rebased to 083eae3e28643e0eefc5243719f8b1572cf98299 of
  git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git
 * remove the "TODO : populate at runtime using" in 1/4 instead of this patch
  (Nori, Sekhar)
 * ui_expander_names was renamed to da850_evm_ui_exp
 * DA850_SW_POLL_MS definition moved to this patch from 3/4
 * use indexed array initialization pattern introduced by Sekhar Nori in 3/4
 * shorter names prefixed with da850_evm
 * static array range intializers
 * using only a single gpio-keys instance for the pushbutton and switches on
   baseboard since there is no advantage to separate device instances with 
   different polling intervals (Dmitry Torokhov)

Changes since v1:
 * adding note about why the tca6416-keypad driver was not used.
 * adding Govindarajan, Sriramakrishnan, the author of the tca6416-keypad
   driver

---
 arch/arm/mach-davinci/board-da850-evm.c |  225 +++++++++++++++++++++++++++++++
 1 files changed, 225 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index c689e7e..32c7a02 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -431,6 +431,220 @@ static int da850_evm_ui_expander_teardown(struct i2c_client *client,
 	return 0;
 }
 
+/* assign the baseboard expander's GPIOs after the UI board's */
+#define DA850_UI_EXPANDER_N_GPIOS ARRAY_SIZE(da850_evm_ui_exp)
+#define DA850_BB_EXPANDER_GPIO_BASE (DAVINCI_N_GPIO + DA850_UI_EXPANDER_N_GPIOS)
+
+enum da850_evm_bb_exp_pins {
+	DA850_EVM_BB_EXP_DEEP_SLEEP_EN = 0,
+	DA850_EVM_BB_EXP_SW_RST,
+	DA850_EVM_BB_EXP_TP_23,
+	DA850_EVM_BB_EXP_TP_22,
+	DA850_EVM_BB_EXP_TP_21,
+	DA850_EVM_BB_EXP_USER_PB1,
+	DA850_EVM_BB_EXP_USER_LED2,
+	DA850_EVM_BB_EXP_USER_LED1,
+	DA850_EVM_BB_EXP_USER_SW1,
+	DA850_EVM_BB_EXP_USER_SW2,
+	DA850_EVM_BB_EXP_USER_SW3,
+	DA850_EVM_BB_EXP_USER_SW4,
+	DA850_EVM_BB_EXP_USER_SW5,
+	DA850_EVM_BB_EXP_USER_SW6,
+	DA850_EVM_BB_EXP_USER_SW7,
+	DA850_EVM_BB_EXP_USER_SW8
+};
+
+static const char const *da850_evm_bb_exp[] = {
+	[DA850_EVM_BB_EXP_DEEP_SLEEP_EN]	= "deep_sleep_en",
+	[DA850_EVM_BB_EXP_SW_RST]		= "sw_rst",
+	[DA850_EVM_BB_EXP_TP_23]		= "tp_23",
+	[DA850_EVM_BB_EXP_TP_22]		= "tp_22",
+	[DA850_EVM_BB_EXP_TP_21]		= "tp_21",
+	[DA850_EVM_BB_EXP_USER_PB1]		= "user_pb1",
+	[DA850_EVM_BB_EXP_USER_LED2]		= "user_led2",
+	[DA850_EVM_BB_EXP_USER_LED1]		= "user_led1",
+	[DA850_EVM_BB_EXP_USER_SW1]		= "user_sw1",
+	[DA850_EVM_BB_EXP_USER_SW2]		= "user_sw2",
+	[DA850_EVM_BB_EXP_USER_SW3]		= "user_sw3",
+	[DA850_EVM_BB_EXP_USER_SW4]		= "user_sw4",
+	[DA850_EVM_BB_EXP_USER_SW5]		= "user_sw5",
+	[DA850_EVM_BB_EXP_USER_SW6]		= "user_sw6",
+	[DA850_EVM_BB_EXP_USER_SW7]		= "user_sw7",
+	[DA850_EVM_BB_EXP_USER_SW8]		= "user_sw8",
+};
+
+#define DA850_N_BB_USER_SW	8
+
+static struct gpio_keys_button da850_evm_bb_keys[] = {
+	[0] = {
+		.type			= EV_KEY,
+		.active_low		= 1,
+		.wakeup			= 0,
+		.debounce_interval	= DA850_KEYS_DEBOUNCE_MS,
+		.code			= KEY_PROG1,
+		.desc			= NULL, /* assigned at runtime */
+		.gpio			= -1, /* assigned at runtime */
+	},
+	[1 ... DA850_N_BB_USER_SW] = {
+		.type			= EV_SW,
+		.active_low		= 1,
+		.wakeup			= 0,
+		.debounce_interval	= DA850_KEYS_DEBOUNCE_MS,
+		.code			= -1, /* assigned at runtime */
+		.desc			= NULL, /* assigned at runtime */
+		.gpio			= -1, /* assigned at runtime */
+	},
+};
+
+static struct gpio_keys_platform_data da850_evm_bb_keys_pdata = {
+	.buttons = da850_evm_bb_keys,
+	.nbuttons = ARRAY_SIZE(da850_evm_bb_keys),
+	.rep = 0, /* disable auto-repeat */
+	.poll_interval = DA850_GPIO_KEYS_POLL_MS,
+};
+
+static struct platform_device da850_evm_bb_keys_device = {
+	.name = "gpio-keys",
+	.id = 1,
+	.dev = {
+		.platform_data = &da850_evm_bb_keys_pdata
+	},
+};
+
+static void da850_evm_bb_keys_init(unsigned gpio)
+{
+	int i;
+	struct gpio_keys_button *button;
+
+	button = &da850_evm_bb_keys[0];
+	button->desc = (char *)
+		da850_evm_bb_exp[DA850_EVM_BB_EXP_USER_PB1];
+	button->gpio = gpio + DA850_EVM_BB_EXP_USER_PB1;
+
+	for (i = 0; i < DA850_N_BB_USER_SW; i++) {
+		button = &da850_evm_bb_keys[i + 1];
+		button->code = SW_LID + i;
+		button->desc = (char *)
+				da850_evm_bb_exp[DA850_EVM_BB_EXP_USER_SW1 + i];
+		button->gpio = gpio + DA850_EVM_BB_EXP_USER_SW1 + i;
+	}
+}
+
+#define DA850_N_BB_USER_LED	2
+
+static struct gpio_led da850_evm_bb_leds[] = {
+		[0 ... DA850_N_BB_USER_LED - 1] = {
+			.active_low = 1,
+			.gpio = -1, /* assigned at runtime */
+			.name = NULL, /* assigned at runtime */
+		},
+};
+
+static struct gpio_led_platform_data da850_evm_bb_leds_pdata = {
+	.leds = da850_evm_bb_leds,
+	.num_leds = ARRAY_SIZE(da850_evm_bb_leds),
+};
+
+static struct platform_device da850_evm_bb_leds_device = {
+	.name		= "leds-gpio",
+	.id		= -1,
+	.dev = {
+		.platform_data = &da850_evm_bb_leds_pdata
+	}
+};
+
+static void da850_evm_bb_leds_init(unsigned gpio)
+{
+	int i;
+	struct gpio_led *led;
+
+	for (i = 0; i < DA850_N_BB_USER_LED; i++) {
+		led = &da850_evm_bb_leds[i];
+
+		led->gpio = gpio + DA850_EVM_BB_EXP_USER_LED2 + i;
+		led->name =
+			da850_evm_bb_exp[DA850_EVM_BB_EXP_USER_LED2 + i];
+	}
+}
+
+static int da850_evm_bb_expander_setup(struct i2c_client *client,
+						unsigned gpio, unsigned ngpio,
+						void *c)
+{
+	int ret;
+	int deep_sleep_en, sw_rst;
+
+	deep_sleep_en	= gpio + DA850_EVM_BB_EXP_DEEP_SLEEP_EN;
+	sw_rst		= gpio + DA850_EVM_BB_EXP_SW_RST;
+
+	/* Do not allow sysfs control of deep_sleep_en */
+	ret = gpio_request(deep_sleep_en,
+			da850_evm_bb_exp[DA850_EVM_BB_EXP_DEEP_SLEEP_EN]);
+	if (ret) {
+		pr_warning("Cannot open IO expander pin %d\n", deep_sleep_en);
+		goto io_exp_setup_deep_sleep_en_fail;
+	}
+	/* do not drive a value on deep_sleep_en */
+	gpio_direction_input(deep_sleep_en);
+
+	/* Do not allow sysfs control of sw_rst */
+	ret = gpio_request(sw_rst,
+			da850_evm_bb_exp[DA850_EVM_BB_EXP_SW_RST]);
+	if (ret) {
+		pr_warning("Cannot open IO expander pin %d\n", sw_rst);
+		goto io_exp_setup_sw_rst_fail;
+	}
+	/* do not drive a value on sw_rst */
+	gpio_direction_input(sw_rst);
+
+	/*
+	 * Register the switches and pushbutton on the baseboard as a gpio-keys
+	 * device.
+	 */
+	da850_evm_bb_keys_init(gpio);
+	ret = platform_device_register(&da850_evm_bb_keys_device);
+	if (ret) {
+		pr_warning("Could not register baseboard GPIO expander switches"
+						" device\n");
+		goto io_exp_setup_sw_fail;
+	}
+
+	da850_evm_bb_leds_init(gpio);
+	ret = platform_device_register(&da850_evm_bb_leds_device);
+	if (ret) {
+		pr_warning("Could not register baseboard GPIO expander LEDS "
+				"device\n");
+		goto io_exp_setup_leds_fail;
+	}
+
+	return 0;
+
+io_exp_setup_leds_fail:
+	platform_device_unregister(&da850_evm_bb_keys_device);
+io_exp_setup_sw_fail:
+	gpio_free(sw_rst);
+io_exp_setup_sw_rst_fail:
+	gpio_free(deep_sleep_en);
+io_exp_setup_deep_sleep_en_fail:
+	return ret;
+}
+
+static int da850_evm_bb_expander_teardown(struct i2c_client *client,
+					unsigned gpio, unsigned ngpio, void *c)
+{
+	int deep_sleep_en, sw_rst;
+
+	deep_sleep_en	= gpio + DA850_EVM_BB_EXP_DEEP_SLEEP_EN;
+	sw_rst		= gpio + DA850_EVM_BB_EXP_SW_RST;
+
+	platform_device_unregister(&da850_evm_bb_leds_device);
+	platform_device_unregister(&da850_evm_bb_keys_device);
+	gpio_free(sw_rst);
+	gpio_free(deep_sleep_en);
+
+	return 0;
+}
+
 static struct pca953x_platform_data da850_evm_ui_expander_info = {
 	.gpio_base	= DAVINCI_N_GPIO,
 	.setup		= da850_evm_ui_expander_setup,
@@ -438,6 +652,13 @@ static struct pca953x_platform_data da850_evm_ui_expander_info = {
 	.names		= da850_evm_ui_exp,
 };
 
+static struct pca953x_platform_data da850_evm_bb_expander_info = {
+	.gpio_base	= DA850_BB_EXPANDER_GPIO_BASE,
+	.setup		= da850_evm_bb_expander_setup,
+	.teardown	= da850_evm_bb_expander_teardown,
+	.names		= da850_evm_bb_exp,
+};
+
 static struct i2c_board_info __initdata da850_evm_i2c_devices[] = {
 	{
 		I2C_BOARD_INFO("tlv320aic3x", 0x18),
@@ -446,6 +667,10 @@ static struct i2c_board_info __initdata da850_evm_i2c_devices[] = {
 		I2C_BOARD_INFO("tca6416", 0x20),
 		.platform_data = &da850_evm_ui_expander_info,
 	},
+	{
+		I2C_BOARD_INFO("tca6416", 0x21),
+		.platform_data = &da850_evm_bb_expander_info,
+	},
 };
 
 static struct davinci_i2c_platform_data da850_evm_i2c_0_pdata = {
-- 
1.7.0.4

