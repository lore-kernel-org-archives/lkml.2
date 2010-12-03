Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab0LCPIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:08:25 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:60303 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751727Ab0LCPGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:06:45 -0500
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, <dmitry.torokhov@gmail.com>,
        <sameo@linux.intel.com>, <ben-linux@fluff.org>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sundar Iyer <sundar.iyer@stericsson.com>
Subject: [PATCH 03/20] mach-ux500: move keymaps to new file
Date: Fri, 3 Dec 2010 20:35:36 +0530
Message-ID: <1291388753-14662-4-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move keylayouts to a dedicated file and plug these keylayouts
for input platform data. This will make addition of new and custom
keylayouts localized.

Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
---
 arch/arm/mach-ux500/Makefile               |    1 +
 arch/arm/mach-ux500/board-mop500-keypads.c |  134 ++++++++++++++++++++++++++++
 arch/arm/mach-ux500/board-mop500.c         |  113 +-----------------------
 arch/arm/mach-ux500/board-mop500.h         |    1 +
 arch/arm/mach-ux500/devices-db8500.c       |    2 +-
 5 files changed, 139 insertions(+), 112 deletions(-)
 create mode 100644 arch/arm/mach-ux500/board-mop500-keypads.c

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index 0612013..e1d3822 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_LOCAL_TIMERS)	+= localtimer.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= board-mop500-regulators.o
 obj-$(CONFIG_U5500_MODEM_IRQ)	+= modem_irq.o
 obj-$(CONFIG_U5500_MBOX)	+= mbox.o
+obj-$(CONFIG_INPUT_KEYBOARD)	+= board-mop500-keypads.o
diff --git a/arch/arm/mach-ux500/board-mop500-keypads.c b/arch/arm/mach-ux500/board-mop500-keypads.c
new file mode 100644
index 0000000..c1218c5
--- /dev/null
+++ b/arch/arm/mach-ux500/board-mop500-keypads.c
@@ -0,0 +1,134 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * Keypad layouts for various boards
+ */
+
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/stmpe.h>
+#include <linux/input/matrix_keypad.h>
+
+#include <plat/pincfg.h>
+#include <plat/ske.h>
+
+#include <mach/devices.h>
+#include <mach/hardware.h>
+
+#include "devices-db8500.h"
+#include "board-mop500.h"
+
+/* STMPE/SKE keypad use this key layout */
+static const unsigned int mop500_keymap[] = {
+	KEY(2, 5, KEY_END),
+	KEY(4, 1, KEY_POWER),
+	KEY(3, 5, KEY_VOLUMEDOWN),
+	KEY(1, 3, KEY_3),
+	KEY(5, 2, KEY_RIGHT),
+	KEY(5, 0, KEY_9),
+
+	KEY(0, 5, KEY_MENU),
+	KEY(7, 6, KEY_ENTER),
+	KEY(4, 5, KEY_0),
+	KEY(6, 7, KEY_2),
+	KEY(3, 4, KEY_UP),
+	KEY(3, 3, KEY_DOWN),
+
+	KEY(6, 4, KEY_SEND),
+	KEY(6, 2, KEY_BACK),
+	KEY(4, 2, KEY_VOLUMEUP),
+	KEY(5, 5, KEY_1),
+	KEY(4, 3, KEY_LEFT),
+	KEY(3, 2, KEY_7),
+};
+
+static const struct matrix_keymap_data mop500_keymap_data = {
+	.keymap         = mop500_keymap,
+	.keymap_size    = ARRAY_SIZE(mop500_keymap),
+};
+
+/*
+ * Nomadik SKE keypad
+ */
+#define ROW_PIN_I0      164
+#define ROW_PIN_I1      163
+#define ROW_PIN_I2      162
+#define ROW_PIN_I3      161
+#define ROW_PIN_I4      156
+#define ROW_PIN_I5      155
+#define ROW_PIN_I6      154
+#define ROW_PIN_I7      153
+#define COL_PIN_O0      168
+#define COL_PIN_O1      167
+#define COL_PIN_O2      166
+#define COL_PIN_O3      165
+#define COL_PIN_O4      160
+#define COL_PIN_O5      159
+#define COL_PIN_O6      158
+#define COL_PIN_O7      157
+
+#define SKE_KPD_MAX_ROWS        8
+#define SKE_KPD_MAX_COLS        8
+
+static int ske_kp_rows[] = {
+	ROW_PIN_I0, ROW_PIN_I1, ROW_PIN_I2, ROW_PIN_I3,
+	ROW_PIN_I4, ROW_PIN_I5, ROW_PIN_I6, ROW_PIN_I7,
+};
+
+/*
+ * ske_set_gpio_row: request and set gpio rows
+ */
+static int ske_set_gpio_row(int gpio)
+{
+	int ret;
+
+	ret = gpio_request(gpio, "ske-kp");
+	if (ret < 0) {
+		pr_err("ske_set_gpio_row: gpio request failed\n");
+		return ret;
+	}
+
+	ret = gpio_direction_output(gpio, 1);
+	if (ret < 0) {
+		pr_err("ske_set_gpio_row: gpio direction failed\n");
+		gpio_free(gpio);
+	}
+
+	return ret;
+}
+
+/*
+ * ske_kp_init - enable the gpio configuration
+ */
+static int ske_kp_init(void)
+{
+	int ret, i;
+
+	for (i = 0; i < SKE_KPD_MAX_ROWS; i++) {
+		ret = ske_set_gpio_row(ske_kp_rows[i]);
+		if (ret < 0) {
+			pr_err("ske_kp_init: failed init\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static struct ske_keypad_platform_data ske_keypad_board = {
+	.init           = ske_kp_init,
+	.keymap_data    = &mop500_keymap_data,
+	.no_autorepeat  = true,
+	.krow           = SKE_KPD_MAX_ROWS,     /* 8x8 matrix */
+	.kcol           = SKE_KPD_MAX_COLS,
+	.debounce_ms    = 40,                   /* in millsecs */
+};
+
+void mop500_keypad_init(void)
+{
+	db8500_add_ske_keypad(&ske_keypad_board);
+}
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 28bc18b..9b5e66e 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -19,15 +19,12 @@
 #include <linux/amba/pl022.h>
 #include <linux/spi/spi.h>
 #include <linux/mfd/ab8500.h>
-#include <linux/mfd/tc35892.h>
-#include <linux/input/matrix_keypad.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
 #include <plat/pincfg.h>
 #include <plat/i2c.h>
-#include <plat/ske.h>
 
 #include <mach/hardware.h>
 #include <mach/setup.h>
@@ -172,116 +169,8 @@ static void __init mop500_i2c_init(void)
 	db8500_add_i2c3(&u8500_i2c3_data);
 }
 
-static const unsigned int ux500_keymap[] = {
-	KEY(2, 5, KEY_END),
-	KEY(4, 1, KEY_POWER),
-	KEY(3, 5, KEY_VOLUMEDOWN),
-	KEY(1, 3, KEY_3),
-	KEY(5, 2, KEY_RIGHT),
-	KEY(5, 0, KEY_9),
-
-	KEY(0, 5, KEY_MENU),
-	KEY(7, 6, KEY_ENTER),
-	KEY(4, 5, KEY_0),
-	KEY(6, 7, KEY_2),
-	KEY(3, 4, KEY_UP),
-	KEY(3, 3, KEY_DOWN),
-
-	KEY(6, 4, KEY_SEND),
-	KEY(6, 2, KEY_BACK),
-	KEY(4, 2, KEY_VOLUMEUP),
-	KEY(5, 5, KEY_1),
-	KEY(4, 3, KEY_LEFT),
-	KEY(3, 2, KEY_7),
-};
-
-static const struct matrix_keymap_data ux500_keymap_data = {
-	.keymap         = ux500_keymap,
-	.keymap_size    = ARRAY_SIZE(ux500_keymap),
-};
-
-/*
- * Nomadik SKE keypad
- */
-#define ROW_PIN_I0      164
-#define ROW_PIN_I1      163
-#define ROW_PIN_I2      162
-#define ROW_PIN_I3      161
-#define ROW_PIN_I4      156
-#define ROW_PIN_I5      155
-#define ROW_PIN_I6      154
-#define ROW_PIN_I7      153
-#define COL_PIN_O0      168
-#define COL_PIN_O1      167
-#define COL_PIN_O2      166
-#define COL_PIN_O3      165
-#define COL_PIN_O4      160
-#define COL_PIN_O5      159
-#define COL_PIN_O6      158
-#define COL_PIN_O7      157
-
-#define SKE_KPD_MAX_ROWS        8
-#define SKE_KPD_MAX_COLS        8
-
-static int ske_kp_rows[] = {
-	ROW_PIN_I0, ROW_PIN_I1, ROW_PIN_I2, ROW_PIN_I3,
-	ROW_PIN_I4, ROW_PIN_I5, ROW_PIN_I6, ROW_PIN_I7,
-};
-
-/*
- * ske_set_gpio_row: request and set gpio rows
- */
-static int ske_set_gpio_row(int gpio)
-{
-	int ret;
-
-	ret = gpio_request(gpio, "ske-kp");
-	if (ret < 0) {
-		pr_err("ske_set_gpio_row: gpio request failed\n");
-		return ret;
-	}
-
-	ret = gpio_direction_output(gpio, 1);
-	if (ret < 0) {
-		pr_err("ske_set_gpio_row: gpio direction failed\n");
-		gpio_free(gpio);
-	}
-
-	return ret;
-}
-
-/*
- * ske_kp_init - enable the gpio configuration
- */
-static int ske_kp_init(void)
-{
-	int ret, i;
-
-	for (i = 0; i < SKE_KPD_MAX_ROWS; i++) {
-		ret = ske_set_gpio_row(ske_kp_rows[i]);
-		if (ret < 0) {
-			pr_err("ske_kp_init: failed init\n");
-			return ret;
-		}
-	}
-
-	return 0;
-}
-
-static struct ske_keypad_platform_data ske_keypad_board = {
-	.init           = ske_kp_init,
-	.keymap_data    = &ux500_keymap_data,
-	.no_autorepeat  = true,
-	.krow           = SKE_KPD_MAX_ROWS,     /* 8x8 matrix */
-	.kcol           = SKE_KPD_MAX_COLS,
-	.debounce_ms    = 40,                   /* in millsecs */
-};
-
-
-
 /* add any platform devices here - TODO */
 static struct platform_device *platform_devs[] __initdata = {
-	&ux500_ske_keypad_device,
 };
 
 static void __init mop500_spi_init(void)
@@ -310,6 +199,8 @@ static void __init u8500_init_machine(void)
 	mop500_spi_init();
 	mop500_uart_init();
 
+	mop500_keypad_init();
+
 	platform_device_register(&ab8500_device);
 
 	i2c_register_board_info(0, mop500_i2c0_devices,
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index 3a338e6..3104ae2 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -16,5 +16,6 @@
 
 extern void mop500_sdi_init(void);
 extern void mop500_sdi_tc35892_init(void);
+extern void mop500_keypad_init(void);
 
 #endif
diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index 1edcf82..e78445c 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -164,7 +164,7 @@ struct resource keypad_resources[] = {
 	},
 };
 
-struct platform_device ux500_ske_keypad_device = {
+struct platform_device u8500_ske_keypad_device = {
 	.name = "nmk-ske-keypad",
 	.id = -1,
 	.num_resources = ARRAY_SIZE(keypad_resources),
-- 
1.7.2.dirty

