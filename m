Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab0KWTlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 14:41:10 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:33005 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751527Ab0KWTlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 14:41:08 -0500
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Paul Mundt <lethal@linux-sh.org>, Sekhar Nori <nsekhar@ti.com>,
        "Govindarajan, Sriramakrishnan" <srk@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH v4 2/5] da850-evm: add UI Expander pushbuttons
Date: Tue, 23 Nov 2010 14:40:57 -0500
Message-Id: <9e73184bfb5c0a0d47377dd9b0627405dd87ce8a.1290540916.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1290540916.git.bengardiner@nanometrics.ca>
References: <cover.1290201713.git.bengardiner@nanometrics.ca> <cover.1290540916.git.bengardiner@nanometrics.ca>
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
Reviewed-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>

---

Changes since v3:
 * extracted Kconfig changes to patch 5/5
 * fixed leading whitespace problem

Changes since v2:
 * rebased to 083eae3e28643e0eefc5243719f8b1572cf98299 of
   git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git
 * remove the "TODO : populate at runtime using" in this patch instead of 4/4
   (Nori, Sekhar)
 * integrated the static array initialization patch of Sekhar Nori
 * use static array initialization ranges
 * rename DA850_PB_POLL_MS to DA850_GPIO_KEYS_POLL_MS
 * use shorter names prefixed with da850_evm

Changes since v1:
 * set INPUT_POLLDEV default for DA850_EVM machine, but don't select it
   unconditionally
 * adding note to description about why tca6416-keypad was not used
 * adding Govindarajan, Sriramakrishnan, the author of the tca6416-keypad
   driver

---
 arch/arm/mach-davinci/board-da850-evm.c |   98 ++++++++++++++++++++++++++++++-
 1 files changed, 97 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index f89b0b7..51f5ffa 100644
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
@@ -272,6 +274,88 @@ static inline void da850_evm_setup_emac_rmii(int rmii_sel)
 static inline void da850_evm_setup_emac_rmii(int rmii_sel) { }
 #endif
 
+
+#define DA850_KEYS_DEBOUNCE_MS	10
+/*
+ * At 200ms polling interval it is possible to miss an
+ * event by tapping very lightly on the push button but most
+ * pushes do result in an event; longer intervals require the
+ * user to hold the button whereas shorter intervals require
+ * more CPU time for polling.
+ */
+#define DA850_GPIO_KEYS_POLL_MS	200
+
+enum da850_evm_ui_exp_pins {
+	DA850_EVM_UI_EXP_SEL_C = 5,
+	DA850_EVM_UI_EXP_SEL_B,
+	DA850_EVM_UI_EXP_SEL_A,
+	DA850_EVM_UI_EXP_PB8,
+	DA850_EVM_UI_EXP_PB7,
+	DA850_EVM_UI_EXP_PB6,
+	DA850_EVM_UI_EXP_PB5,
+	DA850_EVM_UI_EXP_PB4,
+	DA850_EVM_UI_EXP_PB3,
+	DA850_EVM_UI_EXP_PB2,
+	DA850_EVM_UI_EXP_PB1,
+};
+
+static const char const *da850_evm_ui_exp[] = {
+	[DA850_EVM_UI_EXP_SEL_C]        = "sel_c",
+	[DA850_EVM_UI_EXP_SEL_B]        = "sel_b",
+	[DA850_EVM_UI_EXP_SEL_A]        = "sel_a",
+	[DA850_EVM_UI_EXP_PB8]          = "pb8",
+	[DA850_EVM_UI_EXP_PB7]          = "pb7",
+	[DA850_EVM_UI_EXP_PB6]          = "pb6",
+	[DA850_EVM_UI_EXP_PB5]          = "pb5",
+	[DA850_EVM_UI_EXP_PB4]          = "pb4",
+	[DA850_EVM_UI_EXP_PB3]          = "pb3",
+	[DA850_EVM_UI_EXP_PB2]          = "pb2",
+	[DA850_EVM_UI_EXP_PB1]          = "pb1",
+};
+
+#define DA850_N_UI_PB		8
+
+static struct gpio_keys_button da850_evm_ui_keys[] = {
+	[0 ... DA850_N_UI_PB - 1] = {
+		.type			= EV_KEY,
+		.active_low		= 1,
+		.wakeup			= 0,
+		.debounce_interval	= DA850_KEYS_DEBOUNCE_MS,
+		.code			= -1, /* assigned at runtime */
+		.gpio			= -1, /* assigned at runtime */
+		.desc			= NULL, /* assigned at runtime */
+	},
+};
+
+static struct gpio_keys_platform_data da850_evm_ui_keys_pdata = {
+	.buttons = da850_evm_ui_keys,
+	.nbuttons = ARRAY_SIZE(da850_evm_ui_keys),
+	.rep = 0, /* disable auto-repeat */
+	.poll_interval = DA850_GPIO_KEYS_POLL_MS,
+};
+
+static struct platform_device da850_evm_ui_keys_device = {
+	.name = "gpio-keys",
+	.id = 0,
+	.dev = {
+		.platform_data = &da850_evm_ui_keys_pdata
+	},
+};
+
+static void da850_evm_ui_keys_init(unsigned gpio)
+{
+	int i;
+	struct gpio_keys_button *button;
+
+	for (i = 0; i < DA850_N_UI_PB; i++) {
+		button = &da850_evm_ui_keys[i];
+		button->code = KEY_F8 - i;
+		button->desc = (char *)
+				da850_evm_ui_exp[DA850_EVM_UI_EXP_PB8 + i];
+		button->gpio = gpio + DA850_EVM_UI_EXP_PB8 + i;
+	}
+}
+
 static int da850_evm_ui_expander_setup(struct i2c_client *client, unsigned gpio,
 						unsigned ngpio, void *c)
 {
@@ -304,15 +388,24 @@ static int da850_evm_ui_expander_setup(struct i2c_client *client, unsigned gpio,
 	gpio_direction_output(sel_b, 1);
 	gpio_direction_output(sel_c, 1);
 
+	da850_evm_ui_keys_init(gpio);
+	ret = platform_device_register(&da850_evm_ui_keys_device);
+	if (ret) {
+		pr_warning("Could not register UI GPIO expander push-buttons"
+				" device\n");
+		goto exp_setup_keys_fail;
+	}
+
 	ui_card_detected = 1;
 	pr_info("DA850/OMAP-L138 EVM UI card detected\n");
 
 	da850_evm_setup_nor_nand();
-
 	da850_evm_setup_emac_rmii(sel_a);
 
 	return 0;
 
+exp_setup_keys_fail:
+	gpio_free(sel_c);
 exp_setup_selc_fail:
 	gpio_free(sel_b);
 exp_setup_selb_fail:
@@ -324,6 +417,8 @@ exp_setup_sela_fail:
 static int da850_evm_ui_expander_teardown(struct i2c_client *client,
 					unsigned gpio, unsigned ngpio, void *c)
 {
+	platform_device_unregister(&da850_evm_ui_keys_device);
+
 	/* deselect all functionalities */
 	gpio_set_value_cansleep(gpio + 5, 1);
 	gpio_set_value_cansleep(gpio + 6, 1);
@@ -340,6 +435,7 @@ static struct pca953x_platform_data da850_evm_ui_expander_info = {
 	.gpio_base	= DAVINCI_N_GPIO,
 	.setup		= da850_evm_ui_expander_setup,
 	.teardown	= da850_evm_ui_expander_teardown,
+	.names		= da850_evm_ui_exp,
 };
 
 static struct i2c_board_info __initdata da850_evm_i2c_devices[] = {
-- 
1.7.0.4

