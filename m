Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab0KPTkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:40:09 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:42922 "HELO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756309Ab0KPTjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:39:43 -0500
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
Subject: [PATCH v2 2/4] da850-evm: add UI Expander pushbuttons
Date: Tue, 16 Nov 2010 14:39:35 -0500
Message-Id: <95f48a32a0256ecdb7148aa08d16f64928a7e5d8.1289935504.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1289935504.git.bengardiner@nanometrics.ca>
References: <cover.1289835508.git.bengardiner@nanometrics.ca> <cover.1289935504.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds EV_KEYs for each of the 8 pushbuttons on the UI board via a
gpio-key device.

The expander is a tca6416; it controls the SEL_{A,B,C} lines which enable and
disable the peripherals found on the UI board in addition to the 8 pushbuttons
mentioned above. The reason the existing tca6416-keypad driver is not employed
is because there was no aparent way to keep the gpio lines used as
SEL_{A,B,C} registered while simultaneously registering the pushbuttons as a
tca6416-keypad instance.

Some experimentation with the polling interval was performed; we were searching
for the largest polling interval that did not affect the feel of the
responsiveness of the buttons. It is very subjective but 200ms seems to be a
good value that accepts firm pushes but rejects very light ones. The key values
assigned to the buttons were arbitrarily chosen to be F1-F8.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
Reviewed-by: Chris Cordahi <christophercordahi@nanometrics.ca>
CC: Govindarajan, Sriramakrishnan <srk@ti.com>

---

Changes since v1:
 * set INPUT_POLLDEV default for DA850_EVM machine, but don't select it
   unconditionally
 * adding note to description about why tca6416-keypad was not used
 * adding Govindarajan, Sriramakrishnan, the author of the tca6416-keypad
   driver
---
 arch/arm/mach-davinci/Kconfig           |    3 +
 arch/arm/mach-davinci/board-da850-evm.c |   76 +++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index b77b860..5163a1c 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -178,6 +178,9 @@ config DA850_UI_RMII
 
 endchoice
 
+config INPUT_POLLDEV
+	default MACH_DAVINCI_DA850_EVM
+
 config MACH_TNETV107X
 	bool "TI TNETV107X Reference Platform"
 	default ARCH_DAVINCI_TNETV107X
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index c6e11c6..ff71ffd 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -17,8 +17,10 @@
 #include <linux/i2c.h>
 #include <linux/i2c/at24.h>
 #include <linux/i2c/pca953x.h>
+#include <linux/input.h>
 #include <linux/mfd/tps6507x.h>
 #include <linux/gpio.h>
+#include <linux/gpio_keys.h>
 #include <linux/platform_device.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
@@ -272,6 +274,63 @@ static inline void da850_evm_setup_emac_rmii(int rmii_sel)
 static inline void da850_evm_setup_emac_rmii(int rmii_sel) { }
 #endif
 
+
+#define DA850_PB_DEBOUNCE_MS	10
+/*
+ * At 200ms polling interval it is possible to miss an
+ * event by tapping very lightly on the push button but most
+ * pushes do result in an event; longer intervals require the
+ * user to hold the button whereas shorter intervals require
+ * more CPU time for polling.
+ */
+#define DA850_PB_POLL_MS	200
+/* No need to poll switches anywhere near as fast */
+#define DA850_SW_POLL_MS	700
+
+static const char const *ui_expander_names[] = {
+	"dgnd", "dgnd", "dgnd", "dgnd", "nc", "sel_c", "sel_b", "sel_a", "pb8",
+	"pb7", "pb6", "pb5", "pb4", "pb3", "pb2", "pb1"
+};
+
+#define DA850_UI_PB8_OFFSET	8
+#define DA850_N_UI_PB		8
+
+static struct gpio_keys_button user_ui_pbs_gpio_keys[DA850_N_UI_PB];
+
+static struct gpio_keys_platform_data user_ui_pbs_gpio_key_platform_data = {
+	.buttons = user_ui_pbs_gpio_keys,
+	.nbuttons = ARRAY_SIZE(user_ui_pbs_gpio_keys),
+	.rep = 0, /* disable auto-repeat */
+	.poll_interval = DA850_PB_POLL_MS,
+};
+
+static struct platform_device user_ui_pb_gpio_key_device = {
+	.name = "gpio-keys",
+	.id = 0,
+	.dev = {
+		.platform_data = &user_ui_pbs_gpio_key_platform_data
+	}
+};
+
+static void da850_ui_pushbuttons_init(unsigned gpio)
+{
+	int i;
+	struct gpio_keys_button *button;
+
+	for (i = 0; i < DA850_N_UI_PB; i++) {
+		button = &user_ui_pbs_gpio_keys[i];
+
+		button->code = KEY_F8 - i;
+		button->type = EV_KEY;
+		button->active_low = 1;
+		button->wakeup = 0;
+		button->debounce_interval = DA850_PB_DEBOUNCE_MS;
+		button->desc = (char *)
+				ui_expander_names[DA850_UI_PB8_OFFSET + i];
+		button->gpio = gpio + DA850_UI_PB8_OFFSET + i;
+	}
+}
+
 static int da850_evm_ui_expander_setup(struct i2c_client *client, unsigned gpio,
 						unsigned ngpio, void *c)
 {
@@ -304,6 +363,14 @@ static int da850_evm_ui_expander_setup(struct i2c_client *client, unsigned gpio,
 	gpio_direction_output(sel_b, 1);
 	gpio_direction_output(sel_c, 1);
 
+	da850_ui_pushbuttons_init(gpio);
+	ret = platform_device_register(&user_ui_pb_gpio_key_device);
+	if (ret) {
+		pr_warning("Could not register UI GPIO expander push-buttons"
+				" device\n");
+		goto exp_setup_keys_fail;
+	}
+
 	ui_card_detected = 1;
 	pr_info("DA850/OMAP-L138 EVM UI card detected\n");
 
@@ -313,6 +380,8 @@ static int da850_evm_ui_expander_setup(struct i2c_client *client, unsigned gpio,
 
 	return 0;
 
+exp_setup_keys_fail:
+	gpio_free(sel_c);
 exp_setup_selc_fail:
 	gpio_free(sel_b);
 exp_setup_selb_fail:
@@ -324,6 +393,8 @@ exp_setup_sela_fail:
 static int da850_evm_ui_expander_teardown(struct i2c_client *client,
 					unsigned gpio, unsigned ngpio, void *c)
 {
+	platform_device_unregister(&user_ui_pb_gpio_key_device);
+
 	/* deselect all functionalities */
 	gpio_set_value(gpio + 5, 1);
 	gpio_set_value(gpio + 6, 1);
@@ -340,6 +411,7 @@ static struct pca953x_platform_data da850_evm_ui_expander_info = {
 	.gpio_base	= DAVINCI_N_GPIO,
 	.setup		= da850_evm_ui_expander_setup,
 	.teardown	= da850_evm_ui_expander_teardown,
+	.names		= ui_expander_names,
 };
 
 static struct i2c_board_info __initdata da850_evm_i2c_devices[] = {
@@ -349,6 +421,10 @@ static struct i2c_board_info __initdata da850_evm_i2c_devices[] = {
 	{
 		I2C_BOARD_INFO("tca6416", 0x20),
 		.platform_data = &da850_evm_ui_expander_info,
+		/*
+		 * TODO : populate at runtime using
+		 * .irq = gpio_to_irq(GPIO_TO_PIN(2,7)),
+		 */
 	},
 };
 
-- 
1.7.0.4

