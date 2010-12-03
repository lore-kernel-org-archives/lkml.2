Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab0LCPcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:32:54 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:54606 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782Ab0LCPcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:32:16 -0500
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, <dmitry.torokhov@gmail.com>,
        <sameo@linux.intel.com>, <ben-linux@fluff.org>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sundar Iyer <sundar.iyer@stericsson.com>
Subject: [PATCH 15/20] mach-ux500: add touchscreen interfaces platform data
Date: Fri, 3 Dec 2010 20:35:48 +0530
Message-ID: <1291388753-14662-16-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
---
 arch/arm/mach-ux500/Makefile                   |    1 +
 arch/arm/mach-ux500/board-mop500-touchscreen.c |  170 ++++++++++++++++++++++++
 arch/arm/mach-ux500/board-mop500.c             |    6 +-
 arch/arm/mach-ux500/board-mop500.h             |    2 +-
 4 files changed, 177 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/mach-ux500/board-mop500-touchscreen.c

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index e1d3822..e2af105 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_REGULATOR_AB8500)	+= board-mop500-regulators.o
 obj-$(CONFIG_U5500_MODEM_IRQ)	+= modem_irq.o
 obj-$(CONFIG_U5500_MBOX)	+= mbox.o
 obj-$(CONFIG_INPUT_KEYBOARD)	+= board-mop500-keypads.o
+obj-$(CONFIG_INPUT_TOUCHSCREEN)	+= board-mop500-touchscreen.o
diff --git a/arch/arm/mach-ux500/board-mop500-touchscreen.c b/arch/arm/mach-ux500/board-mop500-touchscreen.c
new file mode 100644
index 0000000..87cf2ac
--- /dev/null
+++ b/arch/arm/mach-ux500/board-mop500-touchscreen.c
@@ -0,0 +1,170 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * Author: Naveen Kumar G <naveen.gaddipati@stericsson.com>
+ *
+ * Touchscreen interfaces for various boards
+ */
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/input/bu21013.h>
+#include <../drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h>
+
+#include <mach/gpio.h>
+#include <mach/irqs.h>
+
+/*
+ * Synaptics RMI4 touchscreen interface on the NUIBs
+ */
+
+/*
+ * Descriptor structure.
+ * Describes the number of i2c devices on the bus that speak RMI.
+ */
+static struct synaptics_rmi4_platform_data rmi4_i2c_dev_platformdata = {
+	.name           = "synaptics_rmi4_i2c0",
+	.irq_number     = NOMADIK_GPIO_TO_IRQ(84),
+	.irq_type       = (IRQF_TRIGGER_FALLING | IRQF_SHARED),
+	.x_flip         = true,
+	.y_flip         = false,
+	.regulator_en   = true,
+};
+
+static struct i2c_board_info __initdata u8500_i2c3_devices_nuib[] = {
+	{
+		I2C_BOARD_INFO("synaptics_rmi4_i2c", 0x4B),
+		.platform_data = &rmi4_i2c_dev_platformdata,
+	},
+};
+
+/*
+ * BU21013 ROHM touchscreen interface on the STUIBs
+ */
+
+/* tracks number of bu21013 devices being enabled */
+static int bu21013_devices;
+
+#define TOUCH_GPIO_PIN  84
+
+#define TOUCH_XMAX	384
+#define TOUCH_YMAX	704
+
+#define PRCMU_CLOCK_OCR		0x1CC
+#define TSC_EXT_CLOCK_9_6MHZ	0x840000
+
+/**
+ * bu21013_gpio_board_init : configures the touch panel.
+ * @reset_pin: reset pin number
+ * This function can be used to configures
+ * the voltage and reset the touch panel controller.
+ */
+static int bu21013_gpio_board_init(int reset_pin)
+{
+	int retval = 0;
+
+	bu21013_devices++;
+	if (bu21013_devices == 1) {
+		retval = gpio_request(reset_pin, "touchp_reset");
+		if (retval) {
+			printk(KERN_ERR "Unable to request gpio reset_pin");
+			return retval;
+		}
+		retval = gpio_direction_output(reset_pin, 1);
+		if (retval < 0) {
+			printk(KERN_ERR "%s: gpio direction failed\n",
+					__func__);
+			return retval;
+		}
+		gpio_set_value(reset_pin, 1);
+	}
+
+	return retval;
+}
+
+/**
+ * bu21013_gpio_board_exit : deconfigures the touch panel controller
+ * @reset_pin: reset pin number
+ * This function can be used to deconfigures the chip selection
+ * for touch panel controller.
+ */
+static int bu21013_gpio_board_exit(int reset_pin)
+{
+	int retval = 0;
+
+	if (bu21013_devices == 1) {
+		retval = gpio_direction_output(reset_pin, 0);
+		if (retval < 0) {
+			printk(KERN_ERR "%s: gpio direction failed\n",
+					__func__);
+			return retval;
+		}
+		gpio_set_value(reset_pin, 0);
+	}
+	bu21013_devices--;
+
+	return retval;
+}
+
+/**
+ * bu21013_read_pin_val : get the interrupt pin value
+ * This function can be used to get the interrupt pin value for touch panel
+ * controller.
+ */
+static int bu21013_read_pin_val(void)
+{
+	return gpio_get_value(TOUCH_GPIO_PIN);
+}
+
+static struct bu21013_platform_device tsc_plat_device = {
+	.cs_en = bu21013_gpio_board_init,
+	.cs_dis = bu21013_gpio_board_exit,
+	.irq_read_val = bu21013_read_pin_val,
+	.irq = NOMADIK_GPIO_TO_IRQ(TOUCH_GPIO_PIN),
+	.cs_pin = EGPIO_PIN_13,
+	.x_max_res = 480,
+	.y_max_res = 864,
+	.touch_x_max = TOUCH_XMAX,
+	.touch_y_max = TOUCH_YMAX,
+	.ext_clk = true,
+	.x_flip         = true,
+	.y_flip         = false,
+};
+
+static struct bu21013_platform_device tsc_cntl2_plat_device = {
+	.cs_en = bu21013_gpio_board_init,
+	.cs_dis = bu21013_gpio_board_exit,
+	.irq_read_val = bu21013_read_pin_val,
+	.irq = NOMADIK_GPIO_TO_IRQ(TOUCH_GPIO_PIN),
+	.cs_pin = EGPIO_PIN_13,
+	.x_max_res = 480,
+	.y_max_res = 864,
+	.touch_x_max = TOUCH_XMAX,
+	.touch_y_max = TOUCH_YMAX,
+	.ext_clk = true,
+	.x_flip         = true,
+	.y_flip         = false,
+};
+
+static struct i2c_board_info __initdata u8500_i2c3_devices_stuib[] = {
+	{
+		I2C_BOARD_INFO("bu21013_ts", 0x5C),
+		.platform_data = &tsc_plat_device,
+	},
+	{
+		I2C_BOARD_INFO("bu21013_ts", 0x5D),
+		.platform_data = &tsc_cntl2_plat_device,
+	},
+};
+
+void mop500_touchpanel_init(void)
+{
+	i2c_register_board_info(3, u8500_i2c3_devices_nuib,
+			ARRAY_SIZE(u8500_i2c3_devices_nuib));
+
+	i2c_register_board_info(3, u8500_i2c3_devices_stuib,
+			ARRAY_SIZE(u8500_i2c3_devices_stuib));
+}
+
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 703840b..63313c4 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -202,8 +202,12 @@ static void __init u8500_init_machine(void)
 	mop500_spi_init();
 	mop500_uart_init();
 
+#ifdef CONFIG_INPUT_KEYBOARD
 	mop500_keypad_init();
-
+#endif
+#ifdef CONFIG_INPUT_TOUCHSCREEN
+	mop500_touchpanel_init();
+#endif
 	platform_device_register(&ab8500_device);
 
 	i2c_register_board_info(0, mop500_i2c0_devices,
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index 3104ae2..bac81c5 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -17,5 +17,5 @@
 extern void mop500_sdi_init(void);
 extern void mop500_sdi_tc35892_init(void);
 extern void mop500_keypad_init(void);
-
+extern void mop500_touchpanel_init(void);
 #endif
-- 
1.7.2.dirty

