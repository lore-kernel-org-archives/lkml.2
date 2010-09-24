Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab0IXNrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:47:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45597 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab0IXNq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:46:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:date:x-google-sender-auth:message-id
         :subject:from:to:content-type;
        b=iuEYOu1Wk6pPOQCgEesSNqR/J6AyJYNaBILqbCkt5rI0/PTBjKbQ0ksEEg6rCqha8j
         bKuMS2TQdw9L7/K7IkzxeuMOYjV5ZRD8Q12AGfNP1Rv0AeCdwO0zrJx3KskuJc80vn+I
         oj9OUxl5N0loVjIunRKFApImgr6cPOu5S790A=
MIME-Version: 1.0
Reply-To: pghatwork@gmail.com
Date: Fri, 24 Sep 2010 15:46:44 +0200
X-Google-Sender-Auth: cdpiAPNQSKP1A6tRXk3Aprghz-A
Message-ID: <AANLkTin9Qji_bdyd3yqrP_-ti5xRT9jJ4je2fPM=uHFX@mail.gmail.com>
Subject: [PATCH 1/6] This patch adds support for the ST-Ericsson CG2900
From: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
To: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Pavan Savoy <pavan_savoy@sify.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the ST-Ericsson CG2900
 connectivity controller.
 This patch contains the framework for registering users, chip
 handlers, and transports as well as the needed files towards
 the mach-ux500 board.

Signed-off-by: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
---
 arch/arm/mach-ux500/Makefile                      |    5 +
 arch/arm/mach-ux500/cg2900_devices.c              |  353 ++++
 arch/arm/mach-ux500/include/mach/cg2900_devices.h |  120 ++
 drivers/mfd/Kconfig                               |    8 +
 drivers/mfd/Makefile                              |    1 +
 drivers/mfd/cg2900/Makefile                       |    7 +
 drivers/mfd/cg2900/cg2900_char_devices.c          |  709 +++++++
 drivers/mfd/cg2900/cg2900_char_devices.h          |   36 +
 drivers/mfd/cg2900/cg2900_core.c                  | 2287 +++++++++++++++++++++
 drivers/mfd/cg2900/cg2900_core.h                  |  303 +++
 drivers/mfd/cg2900/cg2900_debug.h                 |   77 +
 drivers/mfd/cg2900/hci_defines.h                  |  102 +
 include/linux/mfd/cg2900.h                        |  205 ++
 13 files changed, 4213 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-ux500/cg2900_devices.c
 create mode 100644 arch/arm/mach-ux500/include/mach/cg2900_devices.h
 create mode 100644 drivers/mfd/cg2900/Makefile
 create mode 100644 drivers/mfd/cg2900/cg2900_char_devices.c
 create mode 100644 drivers/mfd/cg2900/cg2900_char_devices.h
 create mode 100644 drivers/mfd/cg2900/cg2900_core.c
 create mode 100644 drivers/mfd/cg2900/cg2900_core.h
 create mode 100644 drivers/mfd/cg2900/cg2900_debug.h
 create mode 100644 drivers/mfd/cg2900/hci_defines.h
 create mode 100644 include/linux/mfd/cg2900.h

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index 46dbaf6..afafdd6 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -11,3 +11,8 @@ obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
 obj-$(CONFIG_LOCAL_TIMERS)	+= localtimer.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= board-mop500-regulators.o
+ifeq ($(CONFIG_MFD_CG2900), m)
+obj-y					+= cg2900_devices.o
+else
+obj-$(CONFIG_MFD_CG2900)		+= cg2900_devices.o
+endif
diff --git a/arch/arm/mach-ux500/cg2900_devices.c
b/arch/arm/mach-ux500/cg2900_devices.c
new file mode 100644
index 0000000..0aa6a07
--- /dev/null
+++ b/arch/arm/mach-ux500/cg2900_devices.c
@@ -0,0 +1,353 @@
+/*
+ * arch/arm/mach-ux500/cg2900_devices.c
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for
ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Board specific device support for the Linux Bluetooth HCI H:4 Driver
+ * for ST-Ericsson connectivity controller.
+ */
+
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/skbuff.h>
+#include <asm-generic/errno-base.h>
+#include <asm/byteorder.h>
+#include <mach/cg2900_devices.h>
+#include <linux/module.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <plat/pincfg.h>
+#include "pins-db8500.h"
+
+#ifndef PIN_INPUT_PULLUP
+#define PIN_INPUT_PULLUP		(PIN_DIR_INPUT | PIN_PULL_UP)
+#endif
+
+#ifndef GPIO_LOW
+#define GPIO_LOW			0
+#endif
+
+#ifndef GPIO_HIGH
+#define GPIO_HIGH			1
+#endif
+
+#ifndef GPIO_TO_IRQ
+#define GPIO_TO_IRQ			NOMADIK_GPIO_TO_IRQ
+#endif
+
+/** BT_ENABLE_GPIO - GPIO to enable/disable the BT module.
+ */
+#define BT_ENABLE_GPIO			170
+
+/** GBF_ENA_RESET_GPIO - GPIO to enable/disable the controller.
+ */
+#define GBF_ENA_RESET_GPIO		171
+
+/** BT_CTS_GPIO - CTS GPIO.
+*/
+#define BT_CTS_GPIO			0
+
+/** GBF_ENA_RESET_NAME - Name of GPIO for enabling/disabling.
+ */
+#define GBF_ENA_RESET_NAME		"gbf_ena_reset"
+
+/** GBF_ENA_RESET_NAME - Name of GPIO for enabling/disabling.
+ */
+#define BT_ENABLE_NAME			"bt_enable"
+/** CG2900_DEVICE_NAME - Name for this module.
+*/
+#define CG2900_DEVICE_NAME		"cg2900_driver"
+
+/** UART_LINES_NUM - Number of uart lines we want to configure.
+*/
+#define UART_LINES_NUM			4
+
+/* Bluetooth Opcode Group Field */
+#define BT_OGF_VS			0x3F
+
+/* Bluetooth Opcode Command Field */
+#define BT_OCF_VS_POWER_SWITCH_OFF	0x0140
+#define BT_OCF_VS_BT_ENABLE		0x0310
+
+#define MAKE_CMD(__ogf, __ocf)		((u16)(((u16)__ogf << 10) | __ocf))
+
+#define BT_VS_POWER_SWITCH_OFF		MAKE_CMD(BT_OGF_VS, \
+						 BT_OCF_VS_POWER_SWITCH_OFF)
+#define BT_VS_BT_ENABLE			MAKE_CMD(BT_OGF_VS, BT_OCF_VS_BT_ENABLE)
+
+#define VS_BT_DISABLE			0x00
+#define VS_BT_ENABLE			0x01
+
+#define H4_HEADER_LENGTH		0x01
+#define BT_HEADER_LENGTH		0x03
+
+#define STLC2690_HCI_REV		0x0600
+#define CG2900_HCI_REV			0x0101
+#define CG2900_SPECIAL_HCI_REV		0x0700
+
+struct vs_power_sw_off_cmd {
+	__le16	op_code;
+	u8	len;
+	u8	gpio_0_7_pull_up;
+	u8	gpio_8_15_pull_up;
+	u8	gpio_16_20_pull_up;
+	u8	gpio_0_7_pull_down;
+	u8	gpio_8_15_pull_down;
+	u8	gpio_16_20_pull_down;
+} __attribute__((packed));
+
+struct vs_bt_enable_cmd {
+	__le16	op_code;
+	u8	len;
+	u8	enable;
+} __attribute__((packed));
+
+static u8	cg2900_hci_version;
+static u8	cg2900_lmp_version;
+static u8	cg2900_lmp_subversion;
+static u16	cg2900_hci_revision;
+static u16	cg2900_manufacturer;
+
+/* IRQ callback. */
+static struct cg2900_devices_cb *cg2900_dev_callback;
+
+/* Pin configuration for UART functions. */
+static pin_cfg_t uart0_enabled[] = {
+	GPIO0_U0_CTSn   | PIN_INPUT_PULLUP,
+	GPIO1_U0_RTSn   | PIN_OUTPUT_HIGH,
+	GPIO2_U0_RXD    | PIN_INPUT_PULLUP,
+	GPIO3_U0_TXD    | PIN_OUTPUT_HIGH,
+};
+
+/* Pin configuration for sleep mode. */
+static pin_cfg_t uart0_disabled[] = {
+	GPIO0_GPIO   | PIN_INPUT_PULLUP, /* CTS pull up. */
+	GPIO1_GPIO   | PIN_OUTPUT_HIGH,  /* RTS high - flow off. */
+	GPIO2_GPIO   | PIN_INPUT_PULLUP, /* RX pull down. */
+	GPIO3_GPIO   | PIN_OUTPUT_LOW,   /* TX low - break on. */
+};
+
+void cg2900_devices_enable_chip(void)
+{
+	gpio_set_value(GBF_ENA_RESET_GPIO, GPIO_HIGH);
+}
+EXPORT_SYMBOL(cg2900_devices_enable_chip);
+
+void cg2900_devices_disable_chip(void)
+{
+	gpio_set_value(GBF_ENA_RESET_GPIO, GPIO_LOW);
+	cg2900_dev_callback = NULL;
+}
+EXPORT_SYMBOL(cg2900_devices_disable_chip);
+
+void cg2900_devices_set_hci_revision(u8 hci_version,
+				     u16 hci_revision,
+				     u8 lmp_version,
+				     u8 lmp_subversion,
+				     u16 manufacturer)
+{
+	cg2900_hci_version	= hci_version;
+	cg2900_hci_revision	= hci_revision;
+	cg2900_lmp_version	= lmp_version;
+	cg2900_lmp_subversion	= lmp_subversion;
+	cg2900_manufacturer	= manufacturer;
+}
+EXPORT_SYMBOL(cg2900_devices_set_hci_revision);
+
+struct sk_buff *cg2900_devices_get_power_switch_off_cmd(u16 *op_code)
+{
+	struct sk_buff *skb;
+	struct vs_power_sw_off_cmd *cmd;
+
+	/* If connected chip does not support the command return NULL */
+	if (CG2900_HCI_REV != cg2900_hci_revision &&
+	    CG2900_SPECIAL_HCI_REV != cg2900_hci_revision)
+		return NULL;
+
+	skb = alloc_skb(sizeof(*cmd) + H4_HEADER_LENGTH, GFP_KERNEL);
+	if (!skb) {
+		pr_err("Could not allocate skb");
+		return NULL;
+	}
+
+	skb_reserve(skb, H4_HEADER_LENGTH);
+	cmd = (struct vs_power_sw_off_cmd *)skb_put(skb, sizeof(*cmd));
+	cmd->op_code = cpu_to_le16(BT_VS_POWER_SWITCH_OFF);
+	cmd->len = sizeof(*cmd) - BT_HEADER_LENGTH;
+	/*
+	 * Enter system specific GPIO settings here:
+	 * Section data[3-5] is GPIO pull-up selection
+	 * Section data[6-8] is GPIO pull-down selection
+	 * Each section is a bitfield where
+	 * - byte 0 bit 0 is GPIO 0
+	 * - byte 0 bit 1 is GPIO 1
+	 * - up to
+	 * - byte 2 bit 4 which is GPIO 20
+	 * where each bit means:
+	 * - 0: No pull-up / no pull-down
+	 * - 1: Pull-up / pull-down
+	 * All GPIOs are set as input.
+	 */
+	cmd->gpio_0_7_pull_up = 0x00;
+	cmd->gpio_8_15_pull_up = 0x00;
+	cmd->gpio_16_20_pull_up = 0x00;
+	cmd->gpio_0_7_pull_down = 0x00;
+	cmd->gpio_8_15_pull_down = 0x00;
+	cmd->gpio_16_20_pull_down = 0x00;
+
+	if (op_code)
+		*op_code = BT_VS_POWER_SWITCH_OFF;
+
+	return skb;
+}
+EXPORT_SYMBOL(cg2900_devices_get_power_switch_off_cmd);
+
+struct sk_buff *cg2900_devices_get_bt_enable_cmd(u16 *op_code, bool bt_enable)
+{
+	struct sk_buff *skb;
+	struct vs_bt_enable_cmd *cmd;
+
+	/* If connected chip does not support the command return NULL */
+	if (CG2900_HCI_REV != cg2900_hci_revision &&
+	    CG2900_SPECIAL_HCI_REV != cg2900_hci_revision)
+		return NULL;
+
+	/* CG2900 used */
+	skb = alloc_skb(sizeof(*cmd) + H4_HEADER_LENGTH, GFP_KERNEL);
+	if (!skb) {
+		pr_err("Could not allocate skb");
+		return NULL;
+	}
+
+	skb_reserve(skb, H4_HEADER_LENGTH);
+	cmd = (struct vs_bt_enable_cmd *)skb_put(skb, sizeof(*cmd));
+	cmd->op_code = cpu_to_le16(BT_VS_BT_ENABLE);
+	cmd->len = sizeof(*cmd) - BT_HEADER_LENGTH;
+	if (bt_enable)
+		cmd->enable = VS_BT_ENABLE;
+	else
+		cmd->enable = VS_BT_DISABLE;
+
+	if (op_code)
+		*op_code = BT_VS_BT_ENABLE;
+
+	return skb;
+}
+EXPORT_SYMBOL(cg2900_devices_get_bt_enable_cmd);
+
+static irqreturn_t cg2900_devices_interrupt(int irq, void *dev_id)
+{
+	disable_irq_nosync(irq);
+	if (cg2900_dev_callback && cg2900_dev_callback->interrupt_cb)
+		cg2900_dev_callback->interrupt_cb();
+
+	return IRQ_HANDLED;
+}
+
+int cg2900_devices_set_cts_irq(void)
+{
+	int err;
+
+	/*
+	 * Without this delay we get interrupt on CTS immediately
+	 * due to some turbulences on this line.
+	 */
+	mdelay(4);
+
+	/* Disable UART functions. */
+	err = nmk_config_pins(uart0_disabled, UART_LINES_NUM);
+
+	if (err)
+		goto error;
+
+	/* Set IRQ on CTS. */
+	err = request_irq(GPIO_TO_IRQ(BT_CTS_GPIO),
+					cg2900_devices_interrupt,
+					IRQF_TRIGGER_FALLING,
+					CG2900_DEVICE_NAME,
+					NULL);
+	if (err)
+		goto error;
+
+	return 0;
+
+error:
+	(void)nmk_config_pins(uart0_enabled, UART_LINES_NUM);
+	pr_err("Can not set intterupt.");
+	return err;
+}
+EXPORT_SYMBOL(cg2900_devices_set_cts_irq);
+
+void cg2900_devices_unset_cts_irq(void)
+{
+	int err;
+
+	/* Restore UART settings. */
+	free_irq(GPIO_TO_IRQ(BT_CTS_GPIO), NULL);
+	err = nmk_config_pins(uart0_enabled, UART_LINES_NUM);
+	if (err)
+		pr_err("Unable to enable UART");
+}
+EXPORT_SYMBOL(cg2900_devices_unset_cts_irq);
+
+void cg2900_devices_reg_cb(struct cg2900_devices_cb *cb)
+{
+	if (!cg2900_dev_callback)
+		cg2900_dev_callback = cb;
+	else
+		pr_err("Callback already registered");
+}
+EXPORT_SYMBOL(cg2900_devices_reg_cb);
+int cg2900_devices_init(void)
+{
+	int err = 0;
+
+	err = gpio_request(GBF_ENA_RESET_GPIO, GBF_ENA_RESET_NAME);
+	if (err < 0) {
+		pr_err("gpio_request failed with err: %d", err);
+		goto finished;
+	}
+
+	err = gpio_direction_output(GBF_ENA_RESET_GPIO, GPIO_HIGH);
+	if (err < 0) {
+		pr_err("gpio_direction_output failed with err: %d", err);
+		goto error_handling;
+	}
+
+	err = gpio_request(BT_ENABLE_GPIO, BT_ENABLE_NAME);
+	if (err < 0) {
+		pr_err("gpio_request failed with err: %d", err);
+		goto finished;
+	}
+
+	err = gpio_direction_output(BT_ENABLE_GPIO, GPIO_HIGH);
+	if (err < 0) {
+		pr_err("gpio_direction_output failed with err: %d", err);
+		goto error_handling;
+	}
+
+	goto finished;
+
+error_handling:
+	gpio_free(GBF_ENA_RESET_GPIO);
+
+finished:
+	cg2900_devices_disable_chip();
+	return err;
+}
+EXPORT_SYMBOL(cg2900_devices_init);
+
+void cg2900_devices_exit(void)
+{
+	cg2900_devices_disable_chip();
+	gpio_free(GBF_ENA_RESET_GPIO);
+}
+EXPORT_SYMBOL(cg2900_devices_exit);
diff --git a/arch/arm/mach-ux500/include/mach/cg2900_devices.h
b/arch/arm/mach-ux500/include/mach/cg2900_devices.h
new file mode 100644
index 0000000..2db25b3
--- /dev/null
+++ b/arch/arm/mach-ux500/include/mach/cg2900_devices.h
@@ -0,0 +1,120 @@
+/*
+ * arch/arm/mach-ux500/include/mach/cg2900_devices.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for
ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Board specific device support for the Linux Bluetooth HCI H4 Driver
+ * for ST-Ericsson connectivity controller.
+ */
+
+#ifndef _CG2900_DEVICES_H_
+#define _CG2900_DEVICES_H_
+
+#include <linux/types.h>
+#include <linux/skbuff.h>
+
+/**
+ * struct cg2900_devices_cb - Callback structure for cg2900_devices user.
+ * @interrupt_cb:  Callback function called when interrupt on CTS occurred.
+ *
+ * Defines the callback functions provided from the caller.
+ */
+struct cg2900_devices_cb {
+	void (*interrupt_cb)(void);
+};
+
+/**
+ * cg2900_devices_enable_chip() - Enable the controller.
+ */
+extern void cg2900_devices_enable_chip(void);
+
+/**
+ * cg2900_devices_disable_chip() - Disable the controller.
+ */
+extern void cg2900_devices_disable_chip(void);
+
+/**
+ * cg2900_devices_set_hci_revision() - Stores HCI revision info for
the connected connectivity controller.
+ * @hci_version:	HCI version from the controller.
+ * @hci_revision:	HCI revision from the controller.
+ * @lmp_version:	LMP version from the controller.
+ * @lmp_subversion:	LMP subversion from the controller.
+ * @manufacturer:	Manufacturer ID from the controller.
+ *
+ * See Bluetooth specification and white paper for used controller for details
+ * about parameters.
+ */
+extern void cg2900_devices_set_hci_revision(u8 hci_version,
+					    u16 hci_revision,
+					    u8 lmp_version,
+					    u8 lmp_subversion,
+					    u16 manufacturer);
+
+/**
+ * cg2900_devices_get_power_switch_off_cmd() - Get HCI power switch
off command to use based on connected connectivity controller.
+ * @op_code:	HCI opcode in generated packet. NULL if not needed.
+ *
+ * This command does not add the H4 channel header in front of the message.
+ *
+ * Returns:
+ *   NULL if no command shall be sent,
+ *   sk_buffer with command otherwise.
+ */
+extern struct sk_buff *cg2900_devices_get_power_switch_off_cmd(u16 *op_code);
+
+/**
+ * cg2900_devices_get_bt_enable_cmd() - Get HCI BT enable command to
use based on connected connectivity controller.
+ * @op_code:	HCI opcode in generated packet. NULL if not needed.
+ * @bt_enable:	true if Bluetooth IP shall be enabled, false otherwise.
+ *
+ * This command does not add the H4 channel header in front of the message.
+ *
+ * Returns:
+ *   NULL if no command shall be sent,
+ *   sk_buffer with command otherwise.
+ */
+extern struct sk_buff *cg2900_devices_get_bt_enable_cmd(u16 *op_code,
+							bool bt_enable);
+
+/**
+ * cg2900_devices_init() - Initialize the board config.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   Error codes from gpio_request and gpio_direction_output.
+ */
+extern int cg2900_devices_init(void);
+
+/**
+ * cg2900_devices_exit() - Exit function for the board config.
+ */
+extern void cg2900_devices_exit(void);
+
+/**
+ * cg2900_devices_unset_cts_irq() - Disable interrupt on CTS.
+ */
+extern void cg2900_devices_unset_cts_irq(void);
+
+/**
+ * cg2900_devices_set_cts_irq() - Enable interrupt on CTS.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   Error codes from request_irq and nmk_config_pins.
+ */
+extern int cg2900_devices_set_cts_irq(void);
+
+/**
+ * cg2900_devices_reg_cb() - Register callbacks from upper layer.
+ *@cb:	Callback structure from upper layer.
+ *
+ */
+extern void cg2900_devices_reg_cb(struct cg2900_devices_cb *cb);
+#endif /* _CG2900_DEVICES_H_ */
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index fbfe14a..c0a6652 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -576,6 +576,14 @@ config MFD_TPS6586X
 	  This driver can also be built as a module.  If so, the module
 	  will be called tps6586x.

+config MFD_CG2900
+	tristate "Support ST-Ericsson CG2900 main structure"
+	depends on NET
+	help
+	  Support for ST-Ericsson CG2900 Connectivity Combo controller main structure.
+	  Supports multiple functionalities muxed over a Bluetooth HCI H:4 interface.
+	  CG2900 support Bluetooth, FM radio, and GPS.
+
 endif # MFD_SUPPORT

 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index d5968cd..e3d8206 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -78,3 +78,4 @@ obj-$(CONFIG_MFD_RDC321X)	+= rdc321x-southbridge.o
 obj-$(CONFIG_MFD_JANZ_CMODIO)	+= janz-cmodio.o
 obj-$(CONFIG_MFD_JZ4740_ADC)	+= jz4740-adc.o
 obj-$(CONFIG_MFD_TPS6586X)	+= tps6586x.o
+obj-y				+= cg2900/
diff --git a/drivers/mfd/cg2900/Makefile b/drivers/mfd/cg2900/Makefile
new file mode 100644
index 0000000..76af761
--- /dev/null
+++ b/drivers/mfd/cg2900/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for ST-Ericsson CG2900 connectivity combo controller
+#
+
+obj-$(CONFIG_MFD_CG2900)            += cg2900.o
+cg2900-objs                         := cg2900_core.o cg2900_char_devices.o
+export-objs                         := cg2900_core.o
diff --git a/drivers/mfd/cg2900/cg2900_char_devices.c
b/drivers/mfd/cg2900/cg2900_char_devices.c
new file mode 100644
index 0000000..709689b
--- /dev/null
+++ b/drivers/mfd/cg2900/cg2900_char_devices.c
@@ -0,0 +1,709 @@
+/*
+ * drivers/mfd/cg2900/cg2900_char_devices.c
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for
ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson connectivity controller.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/device.h>
+#include <linux/poll.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/miscdevice.h>
+#include <linux/list.h>
+
+#include <linux/mfd/cg2900.h>
+#include <mach/cg2900_devices.h>
+#include "cg2900_core.h"
+#include "cg2900_debug.h"
+
+/* Ioctls */
+#define CG2900_CHAR_DEV_IOCTL_RESET		_IOW('U', 210, int)
+#define CG2900_CHAR_DEV_IOCTL_CHECK4RESET	_IOR('U', 212, int)
+#define CG2900_CHAR_DEV_IOCTL_GET_REVISION	_IOR('U', 213, int)
+#define CG2900_CHAR_DEV_IOCTL_GET_SUB_VER	_IOR('U', 214, int)
+
+#define CG2900_CHAR_DEV_IOCTL_EVENT_RESET	1
+#define CG2900_CHAR_DEV_IOCTL_EVENT_CLOSED	2
+
+/* Internal type definitions */
+
+/**
+ * enum char_reset_state - Reset state.
+ * @CG2900_CHAR_IDLE:	Idle state.
+ * @CG2900_CHAR_RESET:	Reset state.
+ */
+enum char_reset_state {
+	CG2900_CHAR_IDLE,
+	CG2900_CHAR_RESET
+};
+
+/**
+ * struct char_dev_user - Stores device information.
+ * @dev:		Registered CG2900 Core device.
+ * @miscdev:	Registered device struct.
+ * @name:		Name of device.
+ * @rx_queue:		Data queue.
+ * @rx_wait_queue:	Wait queue.
+ * @reset_wait_queue:	Reset Wait queue.
+ * @reset_state:	Reset state.
+ * @read_mutex:		Read mutex.
+ * @write_mutex:	Write mutex.
+ * @list:		List header for inserting into device list.
+ */
+struct char_dev_user {
+	struct cg2900_device	*dev;
+	struct miscdevice	*miscdev;
+	char			*name;
+	struct sk_buff_head	rx_queue;
+	wait_queue_head_t	rx_wait_queue;
+	wait_queue_head_t	reset_wait_queue;
+	enum char_reset_state	reset_state;
+	struct mutex		read_mutex;
+	struct mutex		write_mutex;
+	struct list_head	list;
+};
+
+/**
+ * struct char_info - Stores all current users.
+ * @open_mutex:	Open mutex (used for both open and release).
+ * @dev_users:	List of char dev users.
+ */
+struct char_info {
+	struct mutex		open_mutex;
+	struct list_head	dev_users;
+};
+
+/* Internal variable declarations */
+
+/*
+ * char_info - Main information object for char devices.
+ */
+static struct char_info *char_info;
+
+/* ST-Ericsson CG2900 driver callbacks */
+
+/**
+ * char_dev_read_cb() - Handle data received from controller.
+ * @dev:	Device receiving data.
+ * @skb:	Buffer with data coming from controller.
+ *
+ * The char_dev_read_cb() function handles data received from
STE-CG2900 driver.
+ */
+static void char_dev_read_cb(struct cg2900_device *dev, struct sk_buff *skb)
+{
+	struct char_dev_user *char_dev = (struct char_dev_user *)dev->user_data;
+
+	CG2900_INFO("CharDev: char_dev_read_cb");
+
+	if (!char_dev) {
+		CG2900_ERR("No char dev! Exiting");
+		kfree_skb(skb);
+		return;
+	}
+
+	skb_queue_tail(&char_dev->rx_queue, skb);
+
+	wake_up_interruptible(&char_dev->rx_wait_queue);
+}
+
+/**
+ * char_dev_reset_cb() - Handle reset from controller.
+ * @dev:	Device resetting.
+ *
+ * The char_dev_reset_cb() function handles reset from the CG2900 driver.
+ */
+static void char_dev_reset_cb(struct cg2900_device *dev)
+{
+	struct char_dev_user *char_dev = (struct char_dev_user *)dev->user_data;
+
+	CG2900_INFO("CharDev: char_dev_reset_cb");
+
+	if (!char_dev) {
+		CG2900_ERR("char_dev == NULL");
+		return;
+	}
+
+	char_dev->reset_state = CG2900_CHAR_RESET;
+	/*
+	 * The device will be freed by CG2900 Core when this function is
+	 * finished.
+	 */
+	char_dev->dev = NULL;
+
+	wake_up_interruptible(&char_dev->rx_wait_queue);
+	wake_up_interruptible(&char_dev->reset_wait_queue);
+}
+
+/*
+ * struct char_cb - Callback structure for CG2900 user.
+ * @read_cb:	Callback function called when data is received from the
+ *		CG2900 driver.
+ * @reset_cb:	Callback function called when the controller has been reset.
+ */
+static struct cg2900_callbacks char_cb = {
+	.read_cb = char_dev_read_cb,
+	.reset_cb = char_dev_reset_cb
+};
+
+/* File operation functions */
+
+/**
+ * char_dev_open() - Open char device.
+ * @inode:	Device driver information.
+ * @filp:	Pointer to the file struct.
+ *
+ * The char_dev_open() function opens the char device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EACCES if device was already registered to driver or if registration
+ *   failed.
+ */
+static int char_dev_open(struct inode *inode, struct file *filp)
+{
+	int err = 0;
+	int minor;
+	struct char_dev_user *dev = NULL;
+	struct char_dev_user *tmp;
+	struct list_head *cursor;
+
+	mutex_lock(&char_info->open_mutex);
+
+	minor = iminor(inode);
+
+	/* Find the device for this file */
+	list_for_each(cursor, &char_info->dev_users) {
+		tmp = list_entry(cursor, struct char_dev_user, list);
+		if (tmp->miscdev->minor == minor) {
+			dev = tmp;
+			break;
+		}
+	}
+	if (!dev) {
+		CG2900_ERR("Could not identify device in inode");
+		err = -EINVAL;
+		goto error_handling;
+	}
+
+	filp->private_data = dev;
+
+	CG2900_INFO("CharDev: char_dev_open %s", dev->name);
+
+	if (dev->dev) {
+		CG2900_ERR("Device already registered to CG2900 Driver");
+		err = -EACCES;
+		goto error_handling;
+	}
+	/* First initiate wait queues for this device. */
+	init_waitqueue_head(&dev->rx_wait_queue);
+	init_waitqueue_head(&dev->reset_wait_queue);
+
+	dev->reset_state = CG2900_CHAR_IDLE;
+
+	/* Register to CG2900 Driver */
+	dev->dev = cg2900_register_user(dev->name, &char_cb);
+	if (dev->dev)
+		dev->dev->user_data = dev;
+	else {
+		CG2900_ERR("Couldn't register to CG2900 for H:4 channel %s",
+			   dev->name);
+		err = -EACCES;
+	}
+
+error_handling:
+	mutex_unlock(&char_info->open_mutex);
+	return err;
+}
+
+/**
+ * char_dev_release() - Release char device.
+ * @inode:	Device driver information.
+ * @filp:	Pointer to the file struct.
+ *
+ * The char_dev_release() function release the char device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EBADF if NULL pointer was supplied in private data.
+ */
+static int char_dev_release(struct inode *inode, struct file *filp)
+{
+	int err = 0;
+	struct char_dev_user *dev = (struct char_dev_user *)filp->private_data;
+
+	CG2900_INFO("CharDev: char_dev_release");
+
+	if (!dev) {
+		CG2900_ERR("Calling with NULL pointer");
+		return -EBADF;
+	}
+
+	mutex_lock(&char_info->open_mutex);
+	mutex_lock(&dev->read_mutex);
+	mutex_lock(&dev->write_mutex);
+
+	if (dev->reset_state == CG2900_CHAR_IDLE)
+		cg2900_deregister_user(dev->dev);
+
+	dev->dev = NULL;
+	filp->private_data = NULL;
+	wake_up_interruptible(&dev->rx_wait_queue);
+	wake_up_interruptible(&dev->reset_wait_queue);
+
+	mutex_unlock(&dev->write_mutex);
+	mutex_unlock(&dev->read_mutex);
+	mutex_unlock(&char_info->open_mutex);
+
+	return err;
+}
+
+/**
+ * char_dev_read() - Queue and copy buffer to user.
+ * @filp:	Pointer to the file struct.
+ * @buf:	Received buffer.
+ * @count:	Size of buffer.
+ * @f_pos:	Position in buffer.
+ *
+ * The char_dev_read() function queues and copy the received buffer to
+ * the user space char device. If no data is available this function
will block.
+ *
+ * Returns:
+ *   Bytes successfully read (could be 0).
+ *   -EBADF if NULL pointer was supplied in private data.
+ *   -EFAULT if copy_to_user fails.
+ *   Error codes from wait_event_interruptible.
+ */
+static ssize_t char_dev_read(struct file *filp, char __user *buf, size_t count,
+			     loff_t *f_pos)
+{
+	struct char_dev_user *dev = (struct char_dev_user *)filp->private_data;
+	struct sk_buff *skb;
+	int bytes_to_copy;
+	int err = 0;
+
+	CG2900_INFO("CharDev: char_dev_read");
+
+	if (!dev) {
+		CG2900_ERR("Calling with NULL pointer");
+		return -EBADF;
+	}
+	mutex_lock(&dev->read_mutex);
+
+	if (skb_queue_empty(&dev->rx_queue)) {
+		err = wait_event_interruptible(dev->rx_wait_queue,
+				(!(skb_queue_empty(&dev->rx_queue))) ||
+				(CG2900_CHAR_RESET == dev->reset_state) ||
+				(dev->dev == NULL));
+		if (err) {
+			CG2900_ERR("Failed to wait for event");
+			goto error_handling;
+		}
+	}
+
+	if (!dev->dev) {
+		CG2900_DBG("dev is empty - return with negative bytes");
+		err = -EBADF;
+		goto error_handling;
+	}
+
+	skb = skb_dequeue(&dev->rx_queue);
+	if (!skb) {
+		CG2900_DBG("skb queue is empty - return with zero bytes");
+		bytes_to_copy = 0;
+		goto finished;
+	}
+
+	bytes_to_copy = min(count, skb->len);
+
+	err = copy_to_user(buf, skb->data, bytes_to_copy);
+	if (err) {
+		skb_queue_head(&dev->rx_queue, skb);
+		err = -EFAULT;
+		goto error_handling;
+	}
+
+	skb_pull(skb, bytes_to_copy);
+
+	if (skb->len > 0)
+		skb_queue_head(&dev->rx_queue, skb);
+	else
+		kfree_skb(skb);
+
+	goto finished;
+
+error_handling:
+	mutex_unlock(&dev->read_mutex);
+	return (ssize_t)err;
+finished:
+	mutex_unlock(&dev->read_mutex);
+	return bytes_to_copy;
+}
+
+/**
+ * char_dev_write() - Copy buffer from user and write to CG2900 driver.
+ * @filp:	Pointer to the file struct.
+ * @buf:	Write buffer.
+ * @count:	Size of the buffer write.
+ * @f_pos:	Position of buffer.
+ *
+ * Returns:
+ *   Bytes successfully written (could be 0).
+ *   -EBADF if NULL pointer was supplied in private data.
+ *   -EFAULT if copy_from_user fails.
+ */
+static ssize_t char_dev_write(struct file *filp, const char __user *buf,
+			      size_t count, loff_t *f_pos)
+{
+	struct sk_buff *skb;
+	struct char_dev_user *dev = (struct char_dev_user *)filp->private_data;
+	int err = 0;
+
+	CG2900_INFO("CharDev: char_dev_write");
+
+	if (!dev) {
+		CG2900_ERR("Calling with NULL pointer");
+		return -EBADF;
+	}
+	mutex_lock(&dev->write_mutex);
+
+	skb = cg2900_alloc_skb(count, GFP_ATOMIC);
+	if (!skb) {
+		CG2900_ERR("Couldn't allocate sk_buff with length %d", count);
+		goto error_handling;
+	}
+
+	if (copy_from_user(skb_put(skb, count), buf, count)) {
+		kfree_skb(skb);
+		err = -EFAULT;
+		goto error_handling;
+	}
+
+	err = cg2900_write(dev->dev, skb);
+	if (err) {
+		CG2900_ERR("cg2900_write failed (%d)", err);
+		kfree_skb(skb);
+		goto error_handling;
+	}
+
+	mutex_unlock(&dev->write_mutex);
+	return count;
+
+error_handling:
+	mutex_unlock(&dev->write_mutex);
+	return err;
+}
+
+/**
+ * char_dev_unlocked_ioctl() - Handle IOCTL call to the interface.
+ * @filp:	Pointer to the file struct.
+ * @cmd:	IOCTL command.
+ * @arg:	IOCTL argument.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EBADF if NULL pointer was supplied in private data.
+ *   -EINVAL if supplied cmd is not supported.
+ *   For cmd CG2900_CHAR_DEV_IOCTL_CHECK4RESET 0x01 is returned if device is
+ *   reset and 0x02 is returned if device is closed.
+ */
+static long char_dev_unlocked_ioctl(struct file *filp, unsigned int cmd,
+				    unsigned long arg)
+{
+	struct char_dev_user *dev = (struct char_dev_user *)filp->private_data;
+	struct cg2900_rev_data rev_data;
+	int err = 0;
+
+	CG2900_INFO("CharDev: char_dev_unlocked_ioctl cmd %d for %s", cmd,
+		    dev->name);
+	CG2900_DBG("DIR: %d, TYPE: %d, NR: %d, SIZE: %d",
+		     _IOC_DIR(cmd), _IOC_TYPE(cmd), _IOC_NR(cmd),
+		     _IOC_SIZE(cmd));
+
+	switch (cmd) {
+	case CG2900_CHAR_DEV_IOCTL_RESET:
+		if (!dev) {
+			err = -EBADF;
+			goto error_handling;
+		}
+		CG2900_INFO("ioctl reset command for device %s", dev->name);
+		err = cg2900_reset(dev->dev);
+		break;
+
+	case CG2900_CHAR_DEV_IOCTL_CHECK4RESET:
+		if (!dev) {
+			CG2900_INFO("ioctl check for reset command for device");
+			/* Return positive value if closed */
+			err = CG2900_CHAR_DEV_IOCTL_EVENT_CLOSED;
+		} else if (dev->reset_state == CG2900_CHAR_RESET) {
+			CG2900_INFO("ioctl check for reset command for device "
+				    "%s", dev->name);
+			/* Return positive value if reset */
+			err = CG2900_CHAR_DEV_IOCTL_EVENT_RESET;
+		}
+		break;
+
+	case CG2900_CHAR_DEV_IOCTL_GET_REVISION:
+		CG2900_INFO("ioctl check for local revision info");
+		if (cg2900_get_local_revision(&rev_data)) {
+			CG2900_DBG("Read revision data revision %d "
+				   "sub_version %d",
+				   rev_data.revision, rev_data.sub_version);
+			err = rev_data.revision;
+		} else {
+			CG2900_DBG("No revision data available");
+			err = -EIO;
+		}
+		break;
+
+	case CG2900_CHAR_DEV_IOCTL_GET_SUB_VER:
+		CG2900_INFO("ioctl check for local sub-version info");
+		if (cg2900_get_local_revision(&rev_data)) {
+			CG2900_DBG("Read revision data revision %d "
+				   "sub_version %d",
+				   rev_data.revision, rev_data.sub_version);
+			err = rev_data.sub_version;
+		} else {
+			CG2900_DBG("No revision data available");
+			err = -EIO;
+		}
+		break;
+
+	default:
+		CG2900_ERR("Unknown ioctl command %08X", cmd);
+		err = -EINVAL;
+		break;
+	};
+
+error_handling:
+	return err;
+}
+
+/**
+ * char_dev_poll() - Handle POLL call to the interface.
+ * @filp:	Pointer to the file struct.
+ * @wait:	Poll table supplied to caller.
+ *
+ * Returns:
+ *   Mask of current set POLL values
+ */
+static unsigned int char_dev_poll(struct file *filp, poll_table *wait)
+{
+	struct char_dev_user *dev = (struct char_dev_user *)filp->private_data;
+	unsigned int mask = 0;
+
+	if (!dev) {
+		CG2900_DBG("Device not open");
+		return POLLERR | POLLRDHUP;
+	}
+
+	poll_wait(filp, &dev->reset_wait_queue, wait);
+	poll_wait(filp, &dev->rx_wait_queue, wait);
+
+	if (!dev->dev)
+		mask |= POLLERR | POLLRDHUP;
+	else
+		mask |= POLLOUT; /* We can TX unless there is an error */
+
+	if (!(skb_queue_empty(&dev->rx_queue)))
+		mask |= POLLIN | POLLRDNORM;
+
+	if (CG2900_CHAR_RESET == dev->reset_state)
+		mask |= POLLPRI;
+
+	return mask;
+}
+
+/*
+ * struct char_dev_fops - Char devices file operations.
+ * @read:		Function that reads from the char device.
+ * @write:		Function that writes to the char device.
+ * @unlocked_ioctl:	Function that performs IO operations with
+ *			the char device.
+ * @poll:		Function that checks if there are possible operations
+ *			with the char device.
+ * @open:		Function that opens the char device.
+ * @release:		Function that release the char device.
+ */
+static const struct file_operations char_dev_fops = {
+	.read		= char_dev_read,
+	.write		= char_dev_write,
+	.unlocked_ioctl	= char_dev_unlocked_ioctl,
+	.poll		= char_dev_poll,
+	.open		= char_dev_open,
+	.release	= char_dev_release
+};
+
+/**
+ * setup_dev() - Set up the char device structure for device.
+ * @parent:	Parent device pointer.
+ * @name:	Name of registered device.
+ *
+ * The setup_dev() function sets up the char_dev structure for this device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL if NULL pointer has been supplied.
+ *   Error codes from cdev_add and device_create.
+ */
+static int setup_dev(struct device *parent, char *name)
+{
+	int err = 0;
+	struct char_dev_user *dev_usr;
+
+	CG2900_INFO("CharDev: setup_dev");
+
+	dev_usr = kzalloc(sizeof(*dev_usr), GFP_KERNEL);
+	if (!dev_usr) {
+		CG2900_ERR("Couldn't allocate dev_usr");
+		return -ENOMEM;
+	}
+
+	/* Store device name */
+	dev_usr->name = name;
+
+	dev_usr->miscdev = kzalloc(sizeof(*(dev_usr->miscdev)),
+				       GFP_KERNEL);
+	if (!dev_usr->miscdev) {
+		CG2900_ERR("Couldn't allocate char_dev");
+		err = -ENOMEM;
+		goto err_free_usr;
+	}
+
+	/* Prepare miscdevice struct before registering the device */
+	dev_usr->miscdev->minor = MISC_DYNAMIC_MINOR;
+	dev_usr->miscdev->name = name;
+	dev_usr->miscdev->fops = &char_dev_fops;
+	dev_usr->miscdev->parent = parent;
+
+	err = misc_register(dev_usr->miscdev);
+	if (err) {
+		CG2900_ERR("Error %d registering misc dev!", err);
+		goto err_free_dev;
+	}
+
+	CG2900_INFO("Added char device %s with major 0x%X and minor 0x%X",
+		    name, MAJOR(dev_usr->miscdev->this_device->devt),
+		    MINOR(dev_usr->miscdev->this_device->devt));
+
+	mutex_init(&dev_usr->read_mutex);
+	mutex_init(&dev_usr->write_mutex);
+
+	skb_queue_head_init(&dev_usr->rx_queue);
+
+	list_add_tail(&dev_usr->list, &char_info->dev_users);
+	return 0;
+
+err_free_dev:
+	kfree(dev_usr->miscdev);
+	dev_usr->miscdev = NULL;
+err_free_usr:
+	kfree(dev_usr);
+	return err;
+}
+
+/**
+ * remove_dev() - Remove char device structure for device.
+ * @dev_usr:	Char device user.
+ *
+ * The remove_dev() function releases the char_dev structure for this device.
+ */
+static void remove_dev(struct char_dev_user *dev_usr)
+{
+	CG2900_INFO("CharDev: remove_dev");
+
+	if (!dev_usr)
+		return;
+
+	skb_queue_purge(&dev_usr->rx_queue);
+
+	mutex_destroy(&dev_usr->read_mutex);
+	mutex_destroy(&dev_usr->write_mutex);
+
+	/* Remove device node in file system. */
+	misc_deregister(dev_usr->miscdev);
+	kfree(dev_usr->miscdev);
+	dev_usr->miscdev = NULL;
+
+	kfree(dev_usr);
+}
+
+/* External functions */
+
+void cg2900_char_devices_init(struct miscdevice *dev)
+{
+	CG2900_INFO("cg2900_char_devices_init");
+
+	if (!dev) {
+		CG2900_ERR("NULL supplied for dev");
+		return;
+	}
+
+	if (char_info) {
+		CG2900_ERR("Char devices already initiated");
+		return;
+	}
+
+	/* Initialize private data. */
+	char_info = kzalloc(sizeof(*char_info), GFP_ATOMIC);
+	if (!char_info) {
+		CG2900_ERR("Could not alloc char_info struct.");
+		return;
+	}
+
+	mutex_init(&char_info->open_mutex);
+	INIT_LIST_HEAD(&char_info->dev_users);
+
+	setup_dev(dev->this_device, CG2900_BT_CMD);
+	setup_dev(dev->this_device, CG2900_BT_ACL);
+	setup_dev(dev->this_device, CG2900_BT_EVT);
+	setup_dev(dev->this_device, CG2900_FM_RADIO);
+	setup_dev(dev->this_device, CG2900_GNSS);
+	setup_dev(dev->this_device, CG2900_DEBUG);
+	setup_dev(dev->this_device, CG2900_STE_TOOLS);
+	setup_dev(dev->this_device, CG2900_HCI_LOGGER);
+	setup_dev(dev->this_device, CG2900_US_CTRL);
+	setup_dev(dev->this_device, CG2900_BT_AUDIO);
+	setup_dev(dev->this_device, CG2900_FM_RADIO_AUDIO);
+	setup_dev(dev->this_device, CG2900_CORE);
+}
+
+void cg2900_char_devices_exit(void)
+{
+	struct list_head *cursor, *next;
+	struct char_dev_user *tmp;
+
+	CG2900_INFO("cg2900_char_devices_exit");
+
+	if (!char_info)
+		return;
+
+	list_for_each_safe(cursor, next, &char_info->dev_users) {
+		tmp = list_entry(cursor, struct char_dev_user, list);
+		list_del(cursor);
+		remove_dev(tmp);
+	}
+
+	mutex_destroy(&char_info->open_mutex);
+
+	kfree(char_info);
+	char_info = NULL;
+}
+
+MODULE_AUTHOR("Henrik Possung ST-Ericsson");
+MODULE_AUTHOR("Par-Gunnar Hjalmdahl ST-Ericsson");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("ST-Ericsson CG2900 Char Devices Driver");
diff --git a/drivers/mfd/cg2900/cg2900_char_devices.h
b/drivers/mfd/cg2900/cg2900_char_devices.h
new file mode 100644
index 0000000..65d2b7f
--- /dev/null
+++ b/drivers/mfd/cg2900/cg2900_char_devices.h
@@ -0,0 +1,36 @@
+/*
+ * drivers/mfd/cg2900/cg2900_char_devices.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for
ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson connectivity controller.
+ */
+
+#ifndef _CG2900_CHAR_DEVICES_H_
+#define _CG2900_CHAR_DEVICES_H_
+
+#include <linux/miscdevice.h>
+
+/**
+ * cg2900_char_devices_init() - Initialize char device module.
+ * @parent:	Parent device for the driver.
+ *
+ * Returns:
+ *   0 if success.
+ *   Negative value upon error.
+ */
+extern int cg2900_char_devices_init(struct miscdevice *parent);
+
+/**
+ * cg2900_char_devices_exit() - Release the char device module.
+ */
+extern void cg2900_char_devices_exit(void);
+
+#endif /* _CG2900_CHAR_DEVICES_H_ */
diff --git a/drivers/mfd/cg2900/cg2900_core.c b/drivers/mfd/cg2900/cg2900_core.c
new file mode 100644
index 0000000..8c26202
--- /dev/null
+++ b/drivers/mfd/cg2900/cg2900_core.c
@@ -0,0 +1,2287 @@
+/*
+ * drivers/mfd/cg2900/cg2900_core.c
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for
ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson CG2900 GPS/BT/FM controller.
+ */
+
+#include <linux/module.h>
+#include <linux/workqueue.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/timer.h>
+#include <linux/skbuff.h>
+#include <linux/gfp.h>
+#include <linux/stat.h>
+#include <linux/types.h>
+#include <linux/time.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/firmware.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <asm/byteorder.h>
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci.h>
+
+#include <linux/mfd/cg2900.h>
+#include <mach/cg2900_devices.h>
+#include "cg2900_core.h"
+#include "cg2900_char_devices.h"
+#include "cg2900_debug.h"
+#include "hci_defines.h"
+
+/* Device names */
+#define CG2900_CDEV_NAME		"cg2900_core_test"
+#define CG2900_CLASS_NAME		"cg2900_class"
+#define CG2900_DEVICE_NAME		"cg2900_driver"
+#define CORE_WQ_NAME			"cg2900_core_wq"
+
+#define SET_MAIN_STATE(__core_new_state) \
+	CG2900_SET_STATE("main_state", core_info->main_state, \
+			 __core_new_state)
+#define SET_BOOT_STATE(__core_new_state) \
+	CG2900_SET_STATE("boot_state", core_info->boot_state, __core_new_state)
+#define SET_TRANSPORT_STATE(__core_new_state) \
+	CG2900_SET_STATE("transport_state", core_info->transport_state, \
+			 __core_new_state)
+
+#define LOGGER_DIRECTION_TX		0
+#define LOGGER_DIRECTION_RX		1
+
+/* Number of bytes to reserve at start of sk_buffer when receiving packet */
+#define RX_SKB_RESERVE			8
+
+/*
+ * Timeout values
+ */
+#define CHIP_STARTUP_TIMEOUT		(15000)	/* ms */
+#define CHIP_SHUTDOWN_TIMEOUT		(15000)	/* ms */
+#define LINE_TOGGLE_DETECT_TIMEOUT	(50)	/* ms */
+#define CHIP_READY_TIMEOUT		(100)	/* ms */
+#define REVISION_READOUT_TIMEOUT	(500)	/* ms */
+
+/*
+ * We can have up to 32 char devs with current bit mask and we also have
+ * the parent device here in the transport so that is 33 devices in total.
+ */
+#define MAX_NBR_OF_DEVS			33
+
+/* Default H4 channels which may change depending on connected controller */
+#define HCI_FM_RADIO_H4_CHANNEL		0x08
+#define HCI_GNSS_H4_CHANNEL		0x09
+
+/*
+ *	Internal type definitions
+ */
+
+/**
+ * enum main_state - Main-state for CG2900 Core.
+ * @CORE_INITIALIZING:	CG2900 Core initializing.
+ * @CORE_IDLE:		No user registered to CG2900 Core.
+ * @CORE_BOOTING:	CG2900 Core booting after first user is registered.
+ * @CORE_CLOSING:	CG2900 Core closing after last user has deregistered.
+ * @CORE_RESETING:	CG2900 Core reset requested.
+ * @CORE_ACTIVE:	CG2900 Core up and running with at least one user.
+ */
+enum main_state {
+	CORE_INITIALIZING,
+	CORE_IDLE,
+	CORE_BOOTING,
+	CORE_CLOSING,
+	CORE_RESETING,
+	CORE_ACTIVE
+};
+
+/**
+ * enum boot_state - BOOT-state for CG2900 Core.
+ * @BOOT_NOT_STARTED:				Boot has not yet started.
+ * @BOOT_READ_LOCAL_VERSION_INFORMATION:	ReadLocalVersionInformation
+ *						command has been sent.
+ * @BOOT_READY:					CG2900 Core boot is ready.
+ * @BOOT_FAILED:				CG2900 Core boot failed.
+ */
+enum boot_state {
+	BOOT_NOT_STARTED,
+	BOOT_READ_LOCAL_VERSION_INFORMATION,
+	BOOT_READY,
+	BOOT_FAILED
+};
+
+/**
+ * enum transport_state - State for the CG2900 transport.
+ * @TRANS_INITIALIZING:	Transport initializing.
+ * @TRANS_OPENED:	Transport is opened (data can be sent).
+ * @TRANS_CLOSED:	Transport is closed (data cannot be sent).
+ */
+enum transport_state {
+	TRANS_INITIALIZING,
+	TRANS_OPENED,
+	TRANS_CLOSED
+};
+
+/**
+ * struct cg2900_users - Stores all current users of CG2900 Core.
+ * @bt_cmd:		BT command channel user.
+ * @bt_acl:		BT ACL channel user.
+ * @bt_evt:		BT event channel user.
+ * @fm_radio:		FM radio channel user.
+ * @gnss GNSS:		GNSS channel user.
+ * @debug Debug:	Internal debug channel user.
+ * @ste_tools:		ST-E tools channel user.
+ * @hci_logger:		HCI logger channel user.
+ * @us_ctrl:		User space control channel user.
+ * @bt_audio:		BT audio command channel user.
+ * @fm_radio_audio:	FM audio command channel user.
+ * @core:		Core command channel user.
+ * @nbr_of_users:	Number of users currently registered (not including
+ *			the HCI logger).
+ */
+struct cg2900_users {
+	struct cg2900_device	*bt_cmd;
+	struct cg2900_device	*bt_acl;
+	struct cg2900_device	*bt_evt;
+	struct cg2900_device	*fm_radio;
+	struct cg2900_device	*gnss;
+	struct cg2900_device	*debug;
+	struct cg2900_device	*ste_tools;
+	struct cg2900_device	*hci_logger;
+	struct cg2900_device	*us_ctrl;
+	struct cg2900_device	*bt_audio;
+	struct cg2900_device	*fm_radio_audio;
+	struct cg2900_device	*core;
+	unsigned int		nbr_of_users;
+};
+
+/**
+  * struct local_chip_info - Stores local controller info.
+  * @version_set:		true if version data is valid.
+  * @hci_version:		HCI version of local controller.
+  * @hci_revision:		HCI revision of local controller.
+  * @lmp_pal_version:		LMP/PAL version of local controller.
+  * @manufacturer:		Manufacturer of local controller.
+  * @lmp_pal_subversion:	LMP/PAL sub-version of local controller.
+  *
+  * According to Bluetooth HCI Read Local Version Information command.
+  */
+struct local_chip_info {
+	bool	version_set;
+	u8	hci_version;
+	u16	hci_revision;
+	u8	lmp_pal_version;
+	u16	manufacturer;
+	u16	lmp_pal_subversion;
+};
+
+/**
+ * struct chip_handler_item - Structure to store chip handler cb.
+ * @list:	list_head struct.
+ * @cb:		Chip handler callback struct.
+ */
+struct chip_handler_item {
+	struct list_head		list;
+	struct cg2900_id_callbacks	cb;
+};
+
+/**
+ * struct cg2900_work_struct - Work structure for CG2900 Core module.
+ * @work:	Work structure.
+ * @data:	Pointer to private data.
+ *
+ * This structure is used to pack work for work queue.
+ */
+struct cg2900_work_struct{
+	struct work_struct	work;
+	void			*data;
+};
+
+/**
+ * struct test_char_dev_info - Stores device information.
+ * @test_miscdev:	Registered Misc Device.
+ * @rx_queue:		RX data queue.
+ */
+struct test_char_dev_info {
+	struct miscdevice	test_miscdev;
+	struct sk_buff_head	rx_queue;
+};
+
+/**
+ * struct trans_info - Stores transport information.
+ * @dev:	Transport device.
+ * @cb:		Transport cb.
+ */
+struct trans_info {
+	struct cg2900_trans_dev		dev;
+	struct cg2900_trans_callbacks	cb;
+};
+
+/**
+ * struct core_info - Main info structure for CG2900 Core.
+ * @users:		Stores all users of CG2900 Core.
+ * @local_chip_info:	Stores information of local controller.
+ * @main_state:		Current Main-state of CG2900 Core.
+ * @boot_state:		Current BOOT-state of CG2900 Core.
+ * @transport_state:	Current TRANSPORT-state of CG2900 Core.
+ * @wq:			CG2900 Core workqueue.
+ * @hci_logger_config:	Stores HCI logger configuration.
+ * @dev:		Device structure for STE Connectivity driver.
+ * @chip_dev:		Device structure for chip driver.
+ * @h4_channels:	HCI H:4 channel used by this device.
+ * @test_char_dev:	Stores information of test char dev.
+ * @trans_info:		Stores information about current transport.
+ */
+struct core_info {
+	struct cg2900_users		users;
+	struct local_chip_info		local_chip_info;
+	enum main_state			main_state;
+	enum boot_state			boot_state;
+	enum transport_state		transport_state;
+	struct workqueue_struct		*wq;
+	struct cg2900_hci_logger_config	hci_logger_config;
+	struct miscdevice		*dev;
+	struct cg2900_chip_dev		chip_dev;
+	struct cg2900_h4_channels	h4_channels;
+	struct test_char_dev_info	*test_char_dev;
+	struct trans_info		*trans_info;
+};
+
+/*
+ *	Internal variable declarations
+ */
+
+/*
+ * core_info - Main information object for CG2900 Core.
+ */
+static struct core_info *core_info;
+
+/* Module parameters */
+int cg2900_debug_level = CG2900_DEFAULT_DEBUG_LEVEL;
+EXPORT_SYMBOL(cg2900_debug_level);
+
+u8 bd_address[] = {0x00, 0xBE, 0xAD, 0xDE, 0x80, 0x00};
+EXPORT_SYMBOL(bd_address);
+int bd_addr_count = BT_BDADDR_SIZE;
+
+/* Setting default values to ST-E CG2900 */
+int default_manufacturer = 0x30;
+EXPORT_SYMBOL(default_manufacturer);
+int default_hci_revision = 0x0700;
+EXPORT_SYMBOL(default_hci_revision);
+int default_sub_version = 0x0011;
+EXPORT_SYMBOL(default_sub_version);
+
+static int sleep_timeout_ms;
+
+/*
+ * chip_handlers - List of the register handlers for different chips.
+ */
+LIST_HEAD(chip_handlers);
+
+/*
+ * main_wait_queue - Main Wait Queue in CG2900 Core.
+ */
+static DECLARE_WAIT_QUEUE_HEAD(main_wait_queue);
+
+/*
+ * main_wait_queue - Char device Wait Queue in CG2900 Core.
+ */
+static DECLARE_WAIT_QUEUE_HEAD(char_wait_queue);
+
+/*
+ *	Internal functions
+ */
+
+/**
+ * free_user_dev - Frees user device and also sets it to NULL to inform caller.
+ * @dev:	Pointer to user device.
+ */
+static void free_user_dev(struct cg2900_device **dev)
+{
+	if (*dev) {
+		kfree((*dev)->cb);
+		kfree(*dev);
+		*dev = NULL;
+	}
+}
+
+/**
+ * handle_reset_of_user - Calls the reset callback and frees the device.
+ * @dev:	Pointer to CG2900 device.
+ */
+static void handle_reset_of_user(struct cg2900_device **dev)
+{
+	if (*dev) {
+		if ((*dev)->cb->reset_cb)
+			(*dev)->cb->reset_cb((*dev));
+		free_user_dev(dev);
+	}
+}
+
+/**
+ * transmit_skb_to_chip() - Transmit buffer to the transport.
+ * @skb:	Data packet.
+ * @use_logger:	True if HCI logger shall be used, false otherwise.
+ *
+ * The transmit_skb_to_chip() function transmit buffer to the transport.
+ * If enabled, copy the transmitted data to the HCI logger as well.
+ */
+static void transmit_skb_to_chip(struct sk_buff *skb, bool use_logger)
+{
+	int err;
+	struct sk_buff *skb_log;
+	struct trans_info *trans_info = core_info->trans_info;
+	struct cg2900_device *logger;
+
+	CG2900_DBG_DATA("transmit_skb_to_chip %d bytes. First byte 0x%02X",
+			skb->len, *(skb->data));
+
+	if (TRANS_CLOSED == core_info->transport_state) {
+		CG2900_ERR("Trying to write on a closed channel");
+		kfree_skb(skb);
+		return;
+	}
+
+	/*
+	 * If HCI logging is enabled for this channel, copy the data to
+	 * the HCI logging output.
+	 */
+	logger = core_info->users.hci_logger;
+	if (!use_logger || !logger)
+		goto transmit;
+
+	/*
+	 * Alloc a new sk_buff and copy the data into it. Then send it to
+	 * the HCI logger.
+	 */
+	skb_log = alloc_skb(skb->len + 1, GFP_ATOMIC);
+	if (!skb_log) {
+		CG2900_ERR("Couldn't allocate skb_log");
+		goto transmit;
+	}
+
+	memcpy(skb_put(skb_log, skb->len), skb->data, skb->len);
+	skb_log->data[0] = (u8) LOGGER_DIRECTION_TX;
+
+	if (logger->cb->read_cb)
+		logger->cb->read_cb(logger, skb_log);
+
+transmit:
+	CG2900_DBG_DATA_CONTENT("Length: %d Data: %02X %02X %02X %02X %02X "
+				"%02X %02X %02X %02X %02X %02X %02X",
+				skb->len,
+				skb->data[0], skb->data[1], skb->data[2],
+				skb->data[3], skb->data[4], skb->data[5],
+				skb->data[6], skb->data[7], skb->data[8],
+				skb->data[9], skb->data[10], skb->data[11]);
+
+	if (trans_info && trans_info->cb.write) {
+		err = trans_info->cb.write(&trans_info->dev, skb);
+		if (err)
+			CG2900_ERR("Transport write failed (%d)", err);
+	} else {
+		CG2900_ERR("No way to write to chip");
+		err = -EPERM;
+	}
+
+	if (err)
+		kfree_skb(skb);
+}
+
+/**
+ * create_and_send_bt_cmd() - Copy and send sk_buffer.
+ * @data:	Data to send.
+ * @length:	Length in bytes of data.
+ *
+ * The create_and_send_bt_cmd() function allocates sk_buffer, copy supplied
+ * data to it, and send the sk_buffer to the transport.
+ */
+static void create_and_send_bt_cmd(void *data, int length)
+{
+	struct sk_buff *skb;
+
+	skb = cg2900_alloc_skb(length, GFP_ATOMIC);
+	if (!skb) {
+		CG2900_ERR("Couldn't allocate sk_buff with length %d",
+			     length);
+		return;
+	}
+
+	memcpy(skb_put(skb, length), data, length);
+	skb_push(skb, CG2900_SKB_RESERVE);
+	skb->data[0] = HCI_BT_CMD_H4_CHANNEL;
+
+	transmit_skb_to_chip(skb, core_info->hci_logger_config.bt_cmd_enable);
+}
+
+/**
+ * chip_not_detected() - Called when it is not possible to detect the chip.
+ *
+ * This function sets chip information to default values if it is not possible
+ * to read out information from the chip. This is common when running module
+ * tests.
+ */
+static void chip_not_detected(void)
+{
+	struct list_head *cursor;
+	struct chip_handler_item *tmp;
+
+	CG2900_ERR("Could not read out revision from the chip. This is "
+		   "typical when running stubbed CG2900.\n"
+		   "Switching to default value:\n"
+		   "\tman 0x%04X\n"
+		   "\trev 0x%04X\n"
+		   "\tsub 0x%04X",
+		   default_manufacturer,
+		   default_hci_revision,
+		   default_sub_version);
+
+	core_info->chip_dev.chip.manufacturer = default_manufacturer;
+	core_info->chip_dev.chip.hci_revision = default_hci_revision;
+	core_info->chip_dev.chip.hci_sub_version = default_sub_version;
+
+	memset(&(core_info->chip_dev.cb), 0, sizeof(core_info->chip_dev.cb));
+
+	/* Find the handler for our default chip */
+	list_for_each(cursor, &chip_handlers) {
+		tmp = list_entry(cursor, struct chip_handler_item, list);
+		if (tmp->cb.check_chip_support(&(core_info->chip_dev))) {
+			CG2900_INFO("Chip handler found");
+			SET_BOOT_STATE(BOOT_READY);
+			break;
+		}
+	}
+}
+
+/**
+ * enable_hci_logger() - Enable HCI logger for each device.
+ * @skb:	Received sk buffer.
+ *
+ * The enable_hci_logger() change HCI logger configuration for all registered
+ * devices.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EACCES if bad structure was supplied.
+ */
+static int enable_hci_logger(struct sk_buff *skb)
+{
+	struct cg2900_users *users;
+	struct cg2900_hci_logger_config	*config;
+
+	if (skb->len != sizeof(*config)) {
+		CG2900_ERR("Trying to configure HCI logger with bad structure");
+		return -EACCES;
+	}
+
+	users = &(core_info->users);
+	config = &(core_info->hci_logger_config);
+
+	/* First store the logger config */
+	memcpy(config, skb->data, sizeof(*config));
+
+	/* Then go through all devices and set the right settings */
+	if (users->bt_cmd)
+		users->bt_cmd->logger_enabled = config->bt_cmd_enable;
+	if (users->bt_audio)
+		users->bt_audio->logger_enabled = config->bt_audio_enable;
+	if (users->bt_acl)
+		users->bt_acl->logger_enabled = config->bt_acl_enable;
+	if (users->bt_evt)
+		users->bt_evt->logger_enabled = config->bt_evt_enable;
+	if (users->fm_radio)
+		users->fm_radio->logger_enabled = config->fm_radio_enable;
+	if (users->fm_radio_audio)
+		users->fm_radio_audio->logger_enabled =
+				config->fm_radio_audio_enable;
+	if (users->gnss)
+		users->gnss->logger_enabled = config->gnss_enable;
+
+	kfree_skb(skb);
+	return 0;
+}
+
+/**
+ * find_bt_audio_user() - Check if data packet is an audio related packet.
+ * @h4_channel:	H4 channel.
+ * @dev:	Stored CG2900 device.
+ * @skb:	skb with received packet.
+ * Returns:
+ *   0 - if no error occurred.
+ *   -ENXIO - if cg2900_device not found.
+ */
+static int find_bt_audio_user(int h4_channel, struct cg2900_device **dev,
+				  const struct sk_buff * const skb)
+{
+	if (core_info->chip_dev.cb.is_bt_audio_user &&
+	    core_info->chip_dev.cb.is_bt_audio_user(h4_channel, skb)) {
+		*dev = core_info->users.bt_audio;
+		if (!(*dev)) {
+			CG2900_ERR("H:4 channel not registered in core_info: "
+				     "0x%X", h4_channel);
+			return -ENXIO;
+		}
+	}
+	return 0;
+}
+
+/**
+ * find_fm_audio_user() - Check if data packet is an audio related packet.
+ * @h4_channel:	H4 channel.
+ * @dev:	Stored CG2900 device.
+ * @skb:	skb with received packet.
+ * Returns:
+ *   0 if no error occurred.
+ *   -ENXIO if cg2900_device not found.
+ */
+static int find_fm_audio_user(int h4_channel, struct cg2900_device **dev,
+				  const struct sk_buff * const skb)
+{
+	if (core_info->chip_dev.cb.is_fm_audio_user &&
+	    core_info->chip_dev.cb.is_fm_audio_user(h4_channel, skb)) {
+		*dev = core_info->users.fm_radio_audio;
+		if (!(*dev)) {
+			CG2900_ERR("H:4 channel not registered in core_info: "
+				     "0x%X", h4_channel);
+			return -ENXIO;
+		}
+	}
+	return 0;
+}
+
+/**
+ * find_h4_user() - Get H4 user based on supplied H4 channel.
+ * @h4_channel:	H4 channel.
+ * @dev:	Stored CG2900 device.
+ * @skb:	(optional) skb with received packet. Set to NULL if NA.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL if bad channel is supplied or no user was found.
+ *   -ENXIO if channel is audio channel but not registered with CG2900.
+ */
+static int find_h4_user(int h4_channel, struct cg2900_device **dev,
+			const struct sk_buff * const skb)
+{
+	int err = 0;
+	struct cg2900_users *users = &(core_info->users);
+	struct cg2900_h4_channels *chan = &(core_info->h4_channels);
+
+	if (h4_channel == chan->bt_cmd_channel) {
+		*dev = users->bt_cmd;
+	} else if (h4_channel == chan->bt_acl_channel) {
+		*dev = users->bt_acl;
+	} else if (h4_channel == chan->bt_evt_channel) {
+		*dev = users->bt_evt;
+		/* Check if it's event generated by previously sent audio user
+		 * command. If so then that event should be dispatched to audio
+		 * user*/
+		err = find_bt_audio_user(h4_channel, dev, skb);
+	} else if (h4_channel == chan->gnss_channel) {
+		*dev = users->gnss;
+	} else if (h4_channel == chan->fm_radio_channel) {
+		*dev = users->fm_radio;
+		/* Check if it's an event generated by previously sent audio
+		 * user command. If so then that event should be dispatched to
+		 * audio user */
+		err = find_fm_audio_user(h4_channel, dev, skb);
+	} else if (h4_channel == chan->debug_channel) {
+		*dev = users->debug;
+	} else if (h4_channel == chan->ste_tools_channel) {
+		*dev = users->ste_tools;
+	} else if (h4_channel == chan->hci_logger_channel) {
+		*dev = users->hci_logger;
+	} else if (h4_channel == chan->us_ctrl_channel) {
+		*dev = users->us_ctrl;
+	} else if (h4_channel == chan->core_channel) {
+		*dev = users->core;
+	} else {
+		*dev = NULL;
+		CG2900_ERR("Bad H:4 channel supplied: 0x%X", h4_channel);
+		return -EINVAL;
+	}
+
+	return err;
+}
+
+/**
+ * add_h4_user() - Add H4 user to user storage based on supplied H4 channel.
+ * @dev:	Stored CG2900 device.
+ * @name:	Device name to identify different devices that are using
+ *		the same H4 channel.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL if NULL pointer or bad channel is supplied.
+ *   -EBUSY if there already is a user for supplied channel.
+ */
+static int add_h4_user(struct cg2900_device *dev, const char * const name)
+{
+	int err = 0;
+	struct cg2900_users *users = &(core_info->users);
+	struct cg2900_hci_logger_config	*config =
+			&(core_info->hci_logger_config);
+	struct cg2900_h4_channels *chan = &(core_info->h4_channels);
+
+	if (!dev) {
+		CG2900_ERR("NULL device supplied");
+		return -EINVAL;
+	}
+
+	if (dev->h4_channel == chan->bt_cmd_channel) {
+		if (!users->bt_cmd &&
+		    0 == strncmp(name, CG2900_BT_CMD, CG2900_MAX_NAME_SIZE)) {
+			users->bt_cmd = dev;
+			users->bt_cmd->logger_enabled = config->bt_cmd_enable;
+			(users->nbr_of_users)++;
+		} else if (!users->bt_audio &&
+			   0 == strncmp(name, CG2900_BT_AUDIO,
+					CG2900_MAX_NAME_SIZE)) {
+			users->bt_audio = dev;
+			users->bt_audio->logger_enabled =
+					config->bt_audio_enable;
+			(users->nbr_of_users)++;
+		} else {
+			err = -EBUSY;
+			CG2900_ERR("name %s bt_cmd 0x%X  bt_audio 0x%X",
+				     name, (int)users->bt_cmd,
+				     (int)users->bt_audio);
+		}
+	} else if (dev->h4_channel == chan->bt_acl_channel) {
+		if (!users->bt_acl) {
+			users->bt_acl = dev;
+			users->bt_acl->logger_enabled = config->bt_acl_enable;
+			(users->nbr_of_users)++;
+		} else {
+			err = -EBUSY;
+		}
+	} else if (dev->h4_channel == chan->bt_evt_channel) {
+		if (!users->bt_evt) {
+			users->bt_evt = dev;
+			users->bt_evt->logger_enabled = config->bt_evt_enable;
+			(users->nbr_of_users)++;
+		} else {
+			err = -EBUSY;
+		}
+	} else if (dev->h4_channel == chan->gnss_channel) {
+		if (!users->gnss) {
+			users->gnss = dev;
+			users->gnss->logger_enabled = config->gnss_enable;
+			(users->nbr_of_users)++;
+		} else {
+			err = -EBUSY;
+		}
+	} else if (dev->h4_channel == chan->fm_radio_channel) {
+		if (!users->fm_radio &&
+		    0 == strncmp(name, CG2900_FM_RADIO,
+				 CG2900_MAX_NAME_SIZE)) {
+			users->fm_radio = dev;
+			users->fm_radio->logger_enabled =
+					config->fm_radio_enable;
+			(users->nbr_of_users)++;
+		} else if (!users->fm_radio_audio &&
+			   0 == strncmp(name, CG2900_FM_RADIO_AUDIO,
+					CG2900_MAX_NAME_SIZE)) {
+			users->fm_radio_audio = dev;
+			users->fm_radio_audio->logger_enabled =
+					config->fm_radio_audio_enable;
+			(users->nbr_of_users)++;
+		} else {
+			err = -EBUSY;
+		}
+	} else if (dev->h4_channel == chan->debug_channel) {
+		if (!users->debug)
+			users->debug = dev;
+		else
+			err = -EBUSY;
+	} else if (dev->h4_channel == chan->ste_tools_channel) {
+		if (!users->ste_tools)
+			users->ste_tools = dev;
+		else
+			err = -EBUSY;
+	} else if (dev->h4_channel == chan->hci_logger_channel) {
+		if (!users->hci_logger)
+			users->hci_logger = dev;
+		else
+			err = -EBUSY;
+	} else if (dev->h4_channel == chan->us_ctrl_channel) {
+		if (!users->us_ctrl)
+			users->us_ctrl = dev;
+		else
+			err = -EBUSY;
+	} else if (dev->h4_channel == chan->core_channel) {
+		if (!users->core) {
+			(users->nbr_of_users)++;
+			users->core = dev;
+		} else {
+			err = -EBUSY;
+		}
+	} else {
+		err = -EINVAL;
+		CG2900_ERR("Bad H:4 channel supplied: 0x%X", dev->h4_channel);
+	}
+
+	if (err)
+		CG2900_ERR("H:4 channel 0x%X, not registered (%d)",
+			   dev->h4_channel, err);
+
+	return err;
+}
+
+/**
+ * remove_h4_user() - Remove H4 user from user storage.
+ * @dev:	Stored CG2900 device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL if NULL pointer is supplied, bad channel is supplied, or if there
+ *   is no user for supplied channel.
+ */
+static int remove_h4_user(struct cg2900_device **dev)
+{
+	int err = 0;
+	struct cg2900_users *users = &(core_info->users);
+	struct cg2900_h4_channels *chan = &(core_info->h4_channels);
+	struct cg2900_chip_callbacks *cb = &(core_info->chip_dev.cb);
+
+	if (!dev || !(*dev)) {
+		CG2900_ERR("NULL device supplied");
+		return -EINVAL;
+	}
+
+	if ((*dev)->h4_channel == chan->bt_cmd_channel) {
+		CG2900_DBG("bt_cmd 0x%X bt_audio 0x%X dev 0x%X",
+			     (int)users->bt_cmd,
+			     (int)users->bt_audio, (int)*dev);
+
+		if (*dev == users->bt_cmd) {
+			users->bt_cmd = NULL;
+			(users->nbr_of_users)--;
+		} else if (*dev == users->bt_audio) {
+			users->bt_audio = NULL;
+			(users->nbr_of_users)--;
+		} else
+			err = -EINVAL;
+
+		CG2900_DBG("bt_cmd 0x%X bt_audio 0x%X dev 0x%X",
+			     (int)users->bt_cmd,
+			     (int)users->bt_audio, (int)*dev);
+
+		/*
+		 * If both BT Command channel users are de-registered we
+		 * inform the chip handler.
+		 */
+		if (!users->bt_cmd && !users->bt_audio &&
+		    cb->last_bt_user_removed)
+			cb->last_bt_user_removed(&(core_info->chip_dev));
+	} else if ((*dev)->h4_channel == chan->bt_acl_channel) {
+		if (*dev == users->bt_acl) {
+			users->bt_acl = NULL;
+			(users->nbr_of_users)--;
+		} else
+			err = -EINVAL;
+	} else if ((*dev)->h4_channel == chan->bt_evt_channel) {
+		if (*dev == users->bt_evt) {
+			users->bt_evt = NULL;
+			(users->nbr_of_users)--;
+		} else
+			err = -EINVAL;
+	} else if ((*dev)->h4_channel == chan->gnss_channel) {
+		if (*dev == users->gnss) {
+			users->gnss = NULL;
+			(users->nbr_of_users)--;
+		} else
+			err = -EINVAL;
+
+		/*
+		 * If the GNSS channel user is de-registered we inform
+		 * the chip handler.
+		 */
+		if (users->gnss == NULL && cb->last_gnss_user_removed)
+			cb->last_gnss_user_removed(&(core_info->chip_dev));
+	} else if ((*dev)->h4_channel == chan->fm_radio_channel) {
+		if (*dev == users->fm_radio) {
+			users->fm_radio = NULL;
+			(users->nbr_of_users)--;
+		} else if (*dev == users->fm_radio_audio) {
+			users->fm_radio_audio = NULL;
+			(users->nbr_of_users)--;
+		} else
+			err = -EINVAL;
+
+		/*
+		 * If both FM Radio channel users are de-registered we inform
+		 * the chip handler.
+		 */
+		if (!users->fm_radio && !users->fm_radio_audio &&
+		    cb->last_fm_user_removed)
+			cb->last_fm_user_removed(&(core_info->chip_dev));
+	} else if ((*dev)->h4_channel == chan->debug_channel) {
+		if (*dev == users->debug)
+			users->debug = NULL;
+		else
+			err = -EINVAL;
+	} else if ((*dev)->h4_channel == chan->ste_tools_channel) {
+		if (*dev == users->ste_tools)
+			users->ste_tools = NULL;
+		else
+			err = -EINVAL;
+	} else if ((*dev)->h4_channel == chan->hci_logger_channel) {
+		if (*dev == users->hci_logger)
+			users->hci_logger = NULL;
+		else
+			err = -EINVAL;
+	} else if ((*dev)->h4_channel == chan->us_ctrl_channel) {
+		if (*dev == users->us_ctrl)
+			users->us_ctrl = NULL;
+		else
+			err = -EINVAL;
+	} else if ((*dev)->h4_channel == chan->core_channel) {
+		if (*dev == users->core) {
+			users->core = NULL;
+			(users->nbr_of_users)--;
+		} else
+			err = -EINVAL;
+	} else {
+		CG2900_ERR("Bad H:4 channel supplied: 0x%X",
+			     (*dev)->h4_channel);
+		return -EINVAL;
+	}
+
+	if (err)
+		CG2900_ERR("Trying to remove device that was not registered");
+
+	/*
+	 * Free the device even if there is an error with the device.
+	 * Also set to NULL to inform caller about the free.
+	 */
+	free_user_dev(dev);
+
+	return err;
+}
+
+/**
+ * chip_startup() - Start the connectivity controller and download
patches and settings.
+ */
+static void chip_startup(void)
+{
+	struct hci_command_hdr cmd;
+
+	CG2900_INFO("chip_startup");
+
+	SET_MAIN_STATE(CORE_BOOTING);
+	SET_BOOT_STATE(BOOT_NOT_STARTED);
+
+	/*
+	 * Transmit HCI reset command to ensure the chip is using
+	 * the correct transport
+	 */
+	cmd.opcode = cpu_to_le16(HCI_OP_RESET);
+	cmd.plen = 0; /* No parameters for HCI reset */
+	create_and_send_bt_cmd(&cmd, sizeof(cmd));
+}
+
+/**
+ * chip_shutdown() - Reset and power the chip off.
+ */
+static void chip_shutdown(void)
+{
+	int err = 0;
+	struct trans_info *trans_info = core_info->trans_info;
+	struct cg2900_chip_callbacks *cb = &(core_info->chip_dev.cb);
+
+	CG2900_INFO("chip_shutdown");
+
+	/* First do a quick power switch of the chip to assure a good state */
+	if (trans_info && trans_info->cb.set_chip_power)
+		trans_info->cb.set_chip_power(false);
+
+	/*
+	 * Wait 50ms before continuing to be sure that the chip detects
+	 * chip power off.
+	 */
+	schedule_timeout_interruptible(
+			msecs_to_jiffies(LINE_TOGGLE_DETECT_TIMEOUT));
+
+	if (trans_info && trans_info->cb.set_chip_power)
+		trans_info->cb.set_chip_power(true);
+
+	/* Wait 100ms before continuing to be sure that the chip is ready */
+	schedule_timeout_interruptible(msecs_to_jiffies(CHIP_READY_TIMEOUT));
+
+	/*
+	 * Let the chip handler finish the reset if any callback is registered.
+	 * Otherwise we are finished.
+	 */
+	if (!cb->chip_shutdown) {
+		CG2900_DBG("No registered handler. Finishing shutdown.");
+		cg2900_chip_shutdown_finished(err);
+		return;
+	}
+
+	err = cb->chip_shutdown(&(core_info->chip_dev));
+	if (err) {
+		CG2900_ERR("chip_shutdown failed (%d). Finishing shutdown.",
+			   err);
+		cg2900_chip_shutdown_finished(err);
+	}
+}
+
+/**
+ * handle_reset_cmd_complete_evt() - Handle a received HCI Command
Complete event for a Reset command.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   True,  if packet was handled internally,
+ *   False, otherwise.
+ */
+static bool handle_reset_cmd_complete_evt(u8 *data)
+{
+	bool pkt_handled = false;
+	u8 status = data[0];
+	struct hci_command_hdr cmd;
+
+	CG2900_INFO("Received Reset complete event with status 0x%X", status);
+
+	if ((core_info->main_state == CORE_BOOTING ||
+	     core_info->main_state == CORE_INITIALIZING) &&
+	    core_info->boot_state == BOOT_NOT_STARTED) {
+		/* Transmit HCI Read Local Version Information command */
+		SET_BOOT_STATE(BOOT_READ_LOCAL_VERSION_INFORMATION);
+		cmd.opcode = cpu_to_le16(HCI_OP_READ_LOCAL_VERSION);
+		cmd.plen = 0; /* No parameters for HCI reset */
+		create_and_send_bt_cmd(&cmd, sizeof(cmd));
+
+		pkt_handled = true;
+	}
+
+	return pkt_handled;
+}
+
+/**
+ * handle_read_local_version_info_cmd_complete_evt() - Handle a
received HCI Command Complete event for a ReadLocalVersionInformation
command.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   True,  if packet was handled internally,
+ *   False, otherwise.
+ */
+static bool handle_read_local_version_info_cmd_complete_evt(u8 *data)
+{
+	bool chip_handled = false;
+	struct list_head *cursor;
+	struct chip_handler_item *tmp;
+	struct local_chip_info *chip;
+	struct cg2900_chip_info *chip_info;
+	struct cg2900_chip_callbacks *cb;
+	int err;
+	struct hci_rp_read_local_version *evt;
+
+	/* Check we're in the right state */
+	if ((core_info->main_state != CORE_BOOTING &&
+	     core_info->main_state != CORE_INITIALIZING) ||
+	     core_info->boot_state != BOOT_READ_LOCAL_VERSION_INFORMATION)
+		return false;
+
+	/* We got an answer for our HCI command. Extract data */
+	evt = (struct hci_rp_read_local_version *)data;
+
+	/* We will handle the packet */
+	if (HCI_BT_ERROR_NO_ERROR != evt->status) {
+		CG2900_ERR("Received Read Local Version Information with "
+			     "status 0x%X", evt->status);
+		SET_BOOT_STATE(BOOT_FAILED);
+		cg2900_reset(NULL);
+		return true;
+	}
+
+	/* The command worked. Store the data */
+	chip = &(core_info->local_chip_info);
+	chip->version_set = true;
+	chip->hci_version = evt->hci_ver;
+	chip->hci_revision = le16_to_cpu(evt->hci_rev);
+	chip->lmp_pal_version = evt->lmp_ver;
+	chip->manufacturer = le16_to_cpu(evt->manufacturer);
+	chip->lmp_pal_subversion = le16_to_cpu(evt->lmp_subver);
+	CG2900_DBG("Received Read Local Version Information with:\n"
+		   "\thci_version:  0x%X\n"
+		   "\thci_revision: 0x%X\n"
+		   "\tlmp_pal_version: 0x%X\n"
+		   "\tmanufacturer: 0x%X\n"
+		   "\tlmp_pal_subversion: 0x%X",
+		   chip->hci_version, chip->hci_revision,
+		   chip->lmp_pal_version, chip->manufacturer,
+		   chip->lmp_pal_subversion);
+
+	cg2900_devices_set_hci_revision(chip->hci_version,
+					chip->hci_revision,
+					chip->lmp_pal_version,
+					chip->lmp_pal_subversion,
+					chip->manufacturer);
+
+	/* Received good confirmation. Find handler for the chip. */
+	chip_info = &(core_info->chip_dev.chip);
+	chip_info->hci_revision = chip->hci_revision;
+	chip_info->hci_sub_version = chip->lmp_pal_subversion;
+	chip_info->manufacturer = chip->manufacturer;
+
+	memset(&(core_info->chip_dev.cb), 0, sizeof(core_info->chip_dev.cb));
+
+	list_for_each(cursor, &chip_handlers) {
+		tmp = list_entry(cursor, struct chip_handler_item, list);
+		chip_handled = tmp->cb.check_chip_support(
+				&(core_info->chip_dev));
+		if (chip_handled) {
+			CG2900_INFO("Chip handler found");
+			break;
+		}
+	}
+
+	if (core_info->main_state == CORE_INITIALIZING) {
+		/*
+		 * We are now finished with the start-up during HwRegistered
+		 * operation.
+		 */
+		SET_BOOT_STATE(BOOT_READY);
+		wake_up_interruptible(&main_wait_queue);
+	} else if (!chip_handled) {
+		CG2900_INFO("No chip handler found. Start-up complete");
+		SET_BOOT_STATE(BOOT_READY);
+		cg2900_chip_startup_finished(0);
+	} else {
+		cb = &(core_info->chip_dev.cb);
+		if (!cb->chip_startup)
+			cg2900_chip_startup_finished(0);
+		else {
+			err = cb->chip_startup(&(core_info->chip_dev));
+			if (err)
+				cg2900_chip_startup_finished(err);
+		}
+	}
+
+	return true;
+}
+
+/**
+ * handle_rx_data_bt_evt() - Check if data should be handled in CG2900 Core.
+ * @skb:	Data packet
+ *
+ * The handle_rx_data_bt_evt() function checks if received data should be
+ * handled in CG2900 Core. If so handle it correctly.
+ * Received data is always HCI BT Event.
+ *
+ * Returns:
+ *   True,  if packet was handled internally,
+ *   False, otherwise.
+ */
+static bool handle_rx_data_bt_evt(struct sk_buff *skb)
+{
+	bool pkt_handled = false;
+	u8 *data = &(skb->data[CG2900_SKB_RESERVE]);
+	struct hci_event_hdr *evt;
+	struct hci_ev_cmd_complete *cmd_complete;
+	u16 op_code;
+
+	evt = (struct hci_event_hdr *)data;
+
+	/* First check the event code */
+	if (HCI_EV_CMD_COMPLETE != evt->evt)
+		return false;
+
+	data += sizeof(*evt);
+	cmd_complete = (struct hci_ev_cmd_complete *)data;
+
+	op_code = le16_to_cpu(cmd_complete->opcode);
+
+	CG2900_DBG_DATA("Received Command Complete: op_code = 0x%04X", op_code);
+	data += sizeof(*cmd_complete); /* Move to first byte after OCF */
+
+	if (op_code == HCI_OP_RESET)
+		pkt_handled = handle_reset_cmd_complete_evt(data);
+	else if (op_code == HCI_OP_READ_LOCAL_VERSION)
+		pkt_handled =
+			handle_read_local_version_info_cmd_complete_evt(data);
+
+	if (pkt_handled)
+		kfree_skb(skb);
+
+	return pkt_handled;
+}
+
+/**
+ * test_char_dev_tx_received() - Handle data received from CG2900 Core.
+ * @dev:	Current transport device information.
+ * @skb:	Buffer with data coming form device.
+ */
+static int test_char_dev_tx_received(struct cg2900_trans_dev *dev,
+				     struct sk_buff *skb)
+{
+	skb_queue_tail(&core_info->test_char_dev->rx_queue, skb);
+	wake_up_interruptible(&char_wait_queue);
+	return 0;
+}
+
+/**
+ * test_char_dev_open() - User space char device has been opened.
+ * @inode:	Device driver information.
+ * @filp:	Pointer to the file struct.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EACCES if transport already exists.
+ *   -ENOMEM if allocation fails.
+ *   Errors from create_work_item.
+ */
+static int test_char_dev_open(struct inode *inode, struct file *filp)
+{
+	struct cg2900_trans_callbacks cb = {
+		.write = test_char_dev_tx_received,
+		.open = NULL,
+		.close = NULL,
+		.set_chip_power = NULL
+	};
+
+	CG2900_INFO("test_char_dev_open");
+	return cg2900_register_trans_driver(&cb, NULL);
+}
+
+/**
+ * test_char_dev_release() - User space char device has been closed.
+ * @inode:	Device driver information.
+ * @filp:	Pointer to the file struct.
+ *
+ * Returns:
+ *   0 if there is no error.
+ */
+static int test_char_dev_release(struct inode *inode, struct file *filp)
+{
+	/* Clean the message queue */
+	skb_queue_purge(&core_info->test_char_dev->rx_queue);
+	return cg2900_deregister_trans_driver();
+}
+
+/**
+ * test_char_dev_read() - Queue and copy buffer to user space char device.
+ * @filp:	Pointer to the file struct.
+ * @buf:	Received buffer.
+ * @count:	Count of received data in bytes.
+ * @f_pos:	Position in buffer.
+ *
+ * Returns:
+ *   >= 0 is number of bytes read.
+ *   -EFAULT if copy_to_user fails.
+ */
+static ssize_t test_char_dev_read(struct file *filp, char __user *buf,
+				  size_t count, loff_t *f_pos)
+{
+	struct sk_buff *skb;
+	int bytes_to_copy;
+	int err;
+	struct sk_buff_head *rx_queue = &core_info->test_char_dev->rx_queue;
+
+	CG2900_INFO("test_char_dev_read");
+
+	if (skb_queue_empty(rx_queue))
+		wait_event_interruptible(char_wait_queue,
+					 !(skb_queue_empty(rx_queue)));
+
+	skb = skb_dequeue(rx_queue);
+	if (!skb) {
+		CG2900_INFO("skb queue is empty - return with zero bytes");
+		bytes_to_copy = 0;
+		goto finished;
+	}
+
+	bytes_to_copy = min(count, skb->len);
+	err = copy_to_user(buf, skb->data, bytes_to_copy);
+	if (err) {
+		skb_queue_head(rx_queue, skb);
+		return -EFAULT;
+	}
+
+	skb_pull(skb, bytes_to_copy);
+
+	if (skb->len > 0)
+		skb_queue_head(rx_queue, skb);
+	else
+		kfree_skb(skb);
+
+finished:
+	return bytes_to_copy;
+}
+
+/**
+ * test_char_dev_write() - Copy buffer from user and write to CG2900 Core.
+ * @filp:	Pointer to the file struct.
+ * @buf:	Read buffer.
+ * @count:	Size of the buffer write.
+ * @f_pos:	Position in buffer.
+ *
+ * Returns:
+ *   >= 0 is number of bytes written.
+ *   -EFAULT if copy_from_user fails.
+ */
+static ssize_t test_char_dev_write(struct file *filp, const char __user *buf,
+				   size_t count, loff_t *f_pos)
+{
+	struct sk_buff *skb;
+
+	CG2900_INFO("test_char_dev_write count %d", count);
+
+	/* Allocate the SKB and reserve space for the header */
+	skb = alloc_skb(count + RX_SKB_RESERVE, GFP_ATOMIC);
+	if (!skb) {
+		CG2900_ERR("Failed to alloc skb");
+		return -ENOMEM;
+	}
+	skb_reserve(skb, RX_SKB_RESERVE);
+
+	if (copy_from_user(skb_put(skb, count), buf, count)) {
+		kfree_skb(skb);
+		return -EFAULT;
+	}
+	cg2900_data_from_chip(skb);
+
+	return count;
+}
+
+/**
+ * test_char_dev_poll() - Handle POLL call to the interface.
+ * @filp:	Pointer to the file struct.
+ * @wait:	Poll table supplied to caller.
+ *
+ * Returns:
+ *   Mask of current set POLL values (0 or (POLLIN | POLLRDNORM))
+ */
+static unsigned int test_char_dev_poll(struct file *filp, poll_table *wait)
+{
+	unsigned int mask = 0;
+
+	poll_wait(filp, &char_wait_queue, wait);
+
+	if (!(skb_queue_empty(&core_info->test_char_dev->rx_queue)))
+		mask |= POLLIN | POLLRDNORM;
+
+	return mask;
+}
+
+/*
+ * struct test_char_dev_fops - Test char devices file operations.
+ * @read:	Function that reads from the char device.
+ * @write:	Function that writes to the char device.
+ * @poll:	Function that handles poll call to the fd.
+ */
+static const struct file_operations test_char_dev_fops = {
+	.open = test_char_dev_open,
+	.release = test_char_dev_release,
+	.read = test_char_dev_read,
+	.write = test_char_dev_write,
+	.poll = test_char_dev_poll
+};
+
+/**
+ * test_char_dev_create() - Create a char device for testing.
+ *
+ * Creates a separate char device that will interact directly with userspace
+ * test application.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ENOMEM if allocation fails.
+ *   -EBUSY if device has already been allocated.
+ *   Error codes from misc_register.
+ */
+static int test_char_dev_create(void)
+{
+	int err;
+
+	if (core_info->test_char_dev) {
+		CG2900_ERR("Trying to allocate test_char_dev twice");
+		return -EBUSY;
+	}
+
+	core_info->test_char_dev = kzalloc(sizeof(*(core_info->test_char_dev)),
+					   GFP_KERNEL);
+	if (!core_info->test_char_dev) {
+		CG2900_ERR("Couldn't allocate test_char_dev");
+		return -ENOMEM;
+	}
+
+	/* Initialize the RX queue */
+	skb_queue_head_init(&core_info->test_char_dev->rx_queue);
+
+	/* Prepare miscdevice struct before registering the device */
+	core_info->test_char_dev->test_miscdev.minor = MISC_DYNAMIC_MINOR;
+	core_info->test_char_dev->test_miscdev.name = CG2900_CDEV_NAME;
+	core_info->test_char_dev->test_miscdev.fops = &test_char_dev_fops;
+	core_info->test_char_dev->test_miscdev.parent =
+			core_info->dev->this_device;
+
+	err = misc_register(&core_info->test_char_dev->test_miscdev);
+	if (err) {
+		CG2900_ERR("Error %d registering misc dev!", err);
+		kfree(core_info->test_char_dev);
+		core_info->test_char_dev = NULL;
+		return err;
+	}
+
+	return 0;
+}
+
+/**
+ * test_char_dev_destroy() - Clean up after test_char_dev_create().
+ */
+static void test_char_dev_destroy(void)
+{
+	int err;
+
+	if (!core_info->test_char_dev)
+		return;
+
+	err = misc_deregister(&core_info->test_char_dev->test_miscdev);
+	if (err)
+		CG2900_ERR("Error %d deregistering misc dev!", err);
+
+	/* Clean the message queue */
+	skb_queue_purge(&core_info->test_char_dev->rx_queue);
+
+	kfree(core_info->test_char_dev);
+	core_info->test_char_dev = NULL;
+}
+
+/**
+ * open_transport() - Open the CG2900 transport for data transfers.
+ *
+ * Returns:
+ *   0 if there is no error,
+ *   -EACCES if write to transport failed,
+ *   -EIO if transport has not been selected or chip did not answer
to commands.
+ */
+static int open_transport(void)
+{
+	int err = 0;
+	struct trans_info *trans_info = core_info->trans_info;
+
+	CG2900_INFO("open_transport");
+
+	if (trans_info && trans_info->cb.open) {
+		err = trans_info->cb.open(&trans_info->dev);
+		if (err)
+			CG2900_ERR("Transport open failed (%d)", err);
+	}
+
+	if (!err)
+		SET_TRANSPORT_STATE(TRANS_OPENED);
+
+	return err;
+}
+
+/**
+ * close_transport() - Close the CG2900 transport for data transfers.
+ */
+static void close_transport(void)
+{
+	struct trans_info *trans_info = core_info->trans_info;
+
+	CG2900_INFO("close_transport");
+
+	/* Check so transport has not already been removed */
+	if (TRANS_OPENED == core_info->transport_state)
+		SET_TRANSPORT_STATE(TRANS_CLOSED);
+
+	if (trans_info && trans_info->cb.close) {
+		int err = trans_info->cb.close(&trans_info->dev);
+		if (err)
+			CG2900_ERR("Transport close failed (%d)", err);
+	}
+}
+
+/**
+ * create_work_item() - Create work item and add it to the work queue.
+ * @wq:		work queue struct where the work will be added.
+ * @work_func:	Work function.
+ * @data:	Private data for the work.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EBUSY if not possible to queue work.
+ *   -ENOMEM if allocation fails.
+ */
+static int create_work_item(struct workqueue_struct *wq, work_func_t work_func,
+			    void *data)
+{
+	struct cg2900_work_struct *new_work;
+	int err;
+
+	new_work = kmalloc(sizeof(*new_work), GFP_ATOMIC);
+	if (!new_work) {
+		CG2900_ERR("Failed to alloc memory for cg2900_work_struct!");
+		return -ENOMEM;
+	}
+
+	new_work->data = data;
+	INIT_WORK(&new_work->work, work_func);
+
+	err = queue_work(wq, &new_work->work);
+	if (!err) {
+		CG2900_ERR("Failed to queue work_struct because it's already "
+			   "in the queue!");
+		kfree(new_work);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+/**
+ * work_hw_registered() - Called when the interface to HW has been established.
+ * @work:	Reference to work data.
+ *
+ * Since there now is a transport identify the connected chip and decide which
+ * chip handler to use.
+ */
+static void work_hw_registered(struct work_struct *work)
+{
+	struct cg2900_work_struct *current_work = NULL;
+	bool run_shutdown = true;
+	struct cg2900_chip_callbacks *cb;
+	struct cg2900_h4_channels *chan;
+	struct trans_info *trans_info = core_info->trans_info;
+	struct hci_command_hdr cmd;
+
+	CG2900_INFO("work_hw_registered");
+
+	if (!work) {
+		CG2900_ERR("work == NULL");
+		return;
+	}
+
+	current_work = container_of(work, struct cg2900_work_struct, work);
+
+	SET_MAIN_STATE(CORE_INITIALIZING);
+	SET_BOOT_STATE(BOOT_NOT_STARTED);
+
+	/*
+	 * This might look strange, but we need to read out
+	 * the revision info in order to be able to shutdown the chip properly.
+	 */
+	if (trans_info && trans_info->cb.set_chip_power)
+		trans_info->cb.set_chip_power(true);
+
+	/* Wait 100ms before continuing to be sure that the chip is ready */
+	schedule_timeout_interruptible(msecs_to_jiffies(CHIP_READY_TIMEOUT));
+
+	/*
+	 * Transmit HCI reset command to ensure the chip is using
+	 * the correct transport
+	 */
+	cmd.opcode = cpu_to_le16(HCI_OP_RESET);
+	cmd.plen = 0; /* No parameters for HCI reset */
+	create_and_send_bt_cmd(&cmd, sizeof(cmd));
+
+	/* Wait up to 500 milliseconds for revision to be read out */
+	CG2900_DBG("Wait up to 500 milliseconds for revision to be read.");
+	wait_event_interruptible_timeout(main_wait_queue,
+		(BOOT_READY == core_info->boot_state),
+		msecs_to_jiffies(REVISION_READOUT_TIMEOUT));
+
+	/*
+	 * If we are in BOOT_READY we have a good revision.
+	 * Otherwise handle this as an error and switch to default handler.
+	 */
+	if (BOOT_READY != core_info->boot_state) {
+		chip_not_detected();
+		run_shutdown = false;
+	}
+
+	/* Read out the channels for connected chip */
+	cb = &(core_info->chip_dev.cb);
+	chan = &(core_info->h4_channels);
+	if (cb->get_h4_channel) {
+		/* Get the H4 channel ID for all channels */
+		cb->get_h4_channel(CG2900_BT_CMD, &(chan->bt_cmd_channel));
+		cb->get_h4_channel(CG2900_BT_ACL, &(chan->bt_acl_channel));
+		cb->get_h4_channel(CG2900_BT_EVT, &(chan->bt_evt_channel));
+		cb->get_h4_channel(CG2900_GNSS, &(chan->gnss_channel));
+		cb->get_h4_channel(CG2900_FM_RADIO, &(chan->fm_radio_channel));
+		cb->get_h4_channel(CG2900_DEBUG, &(chan->debug_channel));
+		cb->get_h4_channel(CG2900_STE_TOOLS,
+				   &(chan->ste_tools_channel));
+		cb->get_h4_channel(CG2900_HCI_LOGGER,
+				   &(chan->hci_logger_channel));
+		cb->get_h4_channel(CG2900_US_CTRL, &(chan->us_ctrl_channel));
+		cb->get_h4_channel(CG2900_CORE, &(chan->core_channel));
+	}
+
+	/*
+	 * Now it is time to shutdown the controller to reduce
+	 * power consumption until any users register
+	 */
+	if (run_shutdown)
+		chip_shutdown();
+	else
+		cg2900_chip_shutdown_finished(0);
+
+	kfree(current_work);
+}
+
+/*
+ *	CG2900 API functions
+ */
+
+struct cg2900_device *cg2900_register_user(char  *name,
+					   struct cg2900_callbacks *cb)
+{
+	struct cg2900_device *current_dev;
+	int err;
+	struct trans_info *trans_info = core_info->trans_info;
+
+	CG2900_INFO("cg2900_register_user %s", name);
+
+	BUG_ON(!core_info);
+
+	/* Wait for state CORE_IDLE or CORE_ACTIVE. */
+	err = wait_event_interruptible_timeout(main_wait_queue,
+			(CORE_IDLE == core_info->main_state ||
+			 CORE_ACTIVE == core_info->main_state),
+			msecs_to_jiffies(LINE_TOGGLE_DETECT_TIMEOUT));
+
+	if (err <= 0) {
+		if (CORE_INITIALIZING == core_info->main_state)
+			CG2900_ERR("Transport not opened");
+		else
+			CG2900_ERR("cg2900_register_user currently busy (0x%X)."
+				   " Try again.", core_info->main_state);
+		return NULL;
+	}
+
+	/* Allocate device */
+	current_dev = kzalloc(sizeof(*current_dev), GFP_ATOMIC);
+	if (!current_dev) {
+		CG2900_ERR("Couldn't allocate current dev");
+		goto error_handling;
+	}
+
+	if (!core_info->chip_dev.cb.get_h4_channel) {
+		CG2900_ERR("No channel handler registered");
+		goto error_handling;
+	}
+	err = core_info->chip_dev.cb.get_h4_channel(name,
+						    &(current_dev->h4_channel));
+	if (err) {
+		CG2900_ERR("Couldn't find H4 channel for %s", name);
+		goto error_handling;
+	}
+	current_dev->dev = core_info->dev->this_device;
+	current_dev->cb = kmalloc(sizeof(*(current_dev->cb)),
+					 GFP_ATOMIC);
+	if (!current_dev->cb) {
+		CG2900_ERR("Couldn't allocate cb ");
+		goto error_handling;
+	}
+	memcpy((char *)current_dev->cb, (char *)cb,
+	       sizeof(*(current_dev->cb)));
+
+	/* Retrieve pointer to the correct CG2900 Core user structure */
+	err = add_h4_user(current_dev, name);
+
+	if (!err) {
+		CG2900_DBG("H:4 channel 0x%X registered",
+			   current_dev->h4_channel);
+	} else {
+		CG2900_ERR("H:4 channel 0x%X already registered "
+			   "or other error (%d)",
+			   current_dev->h4_channel, err);
+		goto error_handling;
+	}
+
+	if (CORE_ACTIVE != core_info->main_state &&
+	    core_info->users.nbr_of_users == 1) {
+		/* Open transport and start-up the chip */
+		if (trans_info && trans_info->cb.set_chip_power)
+			trans_info->cb.set_chip_power(true);
+
+		/* Wait 100ms to be sure that the chip is ready */
+		schedule_timeout_interruptible(
+				msecs_to_jiffies(CHIP_READY_TIMEOUT));
+
+		err = open_transport();
+		if (err) {
+			/*
+			 * Remove the user. If there is no error it will be
+			 * freed as well.
+			 */
+			remove_h4_user(&current_dev);
+			goto finished;
+		}
+
+		chip_startup();
+
+		/* Wait up to 15 seconds for chip to start */
+		CG2900_DBG("Wait up to 15 seconds for chip to start..");
+		wait_event_interruptible_timeout(main_wait_queue,
+			(CORE_ACTIVE == core_info->main_state ||
+			 CORE_IDLE   == core_info->main_state),
+			msecs_to_jiffies(CHIP_STARTUP_TIMEOUT));
+		if (CORE_ACTIVE != core_info->main_state) {
+			CG2900_ERR("ST-Ericsson CG2900 driver failed to "
+				     "start");
+
+			/* Close the transport and power off the chip */
+			close_transport();
+
+			/*
+			 * Remove the user. If there is no error it will be
+			 * freed as well.
+			 */
+			remove_h4_user(&current_dev);
+
+			/* Chip shut-down finished, set correct state. */
+			SET_MAIN_STATE(CORE_IDLE);
+		}
+	}
+	goto finished;
+
+error_handling:
+	free_user_dev(&current_dev);
+finished:
+	return current_dev;
+}
+EXPORT_SYMBOL(cg2900_register_user);
+
+void cg2900_deregister_user(struct cg2900_device *dev)
+{
+	int h4_channel;
+	int err = 0;
+
+	CG2900_INFO("cg2900_deregister_user");
+
+	BUG_ON(!core_info);
+
+	if (!dev) {
+		CG2900_ERR("Calling with NULL pointer");
+		return;
+	}
+
+	h4_channel = dev->h4_channel;
+
+	/* Remove the user. If there is no error it will be freed as well */
+	err = remove_h4_user(&dev);
+	if (err) {
+		CG2900_ERR("Trying to deregister non-registered "
+			   "H:4 channel 0x%X or other error %d",
+			   h4_channel, err);
+		return;
+	}
+
+	CG2900_DBG("H:4 channel 0x%X deregistered", h4_channel);
+
+	if (0 != core_info->users.nbr_of_users)
+		/* This was not the last user, we're done. */
+		return;
+
+	if (CORE_IDLE == core_info->main_state)
+		/* Chip has already been shut down. */
+		return;
+
+	SET_MAIN_STATE(CORE_CLOSING);
+	chip_shutdown();
+
+	/* Wait up to 15 seconds for chip to shut-down */
+	CG2900_DBG("Wait up to 15 seconds for chip to shut-down..");
+	wait_event_interruptible_timeout(main_wait_queue,
+				(CORE_IDLE == core_info->main_state),
+				msecs_to_jiffies(CHIP_SHUTDOWN_TIMEOUT));
+
+	/* Force shutdown if we timed out */
+	if (CORE_IDLE != core_info->main_state) {
+		CG2900_ERR("ST-Ericsson CG2900 Core Driver was shut-down with "
+			   "problems.");
+
+		/* Close the transport and power off the chip */
+		close_transport();
+
+		/* Chip shut-down finished, set correct state. */
+		SET_MAIN_STATE(CORE_IDLE);
+	}
+}
+EXPORT_SYMBOL(cg2900_deregister_user);
+
+int cg2900_reset(struct cg2900_device *dev)
+{
+	CG2900_INFO("cg2900_reset");
+
+	BUG_ON(!core_info);
+
+	SET_MAIN_STATE(CORE_RESETING);
+
+	/* Shutdown the chip */
+	chip_shutdown();
+
+	/*
+	 * Inform all registered users about the reset and free the user devices
+	 * Don't send reset for debug and logging channels
+	 */
+	handle_reset_of_user(&(core_info->users.bt_cmd));
+	handle_reset_of_user(&(core_info->users.bt_audio));
+	handle_reset_of_user(&(core_info->users.bt_acl));
+	handle_reset_of_user(&(core_info->users.bt_evt));
+	handle_reset_of_user(&(core_info->users.fm_radio));
+	handle_reset_of_user(&(core_info->users.fm_radio_audio));
+	handle_reset_of_user(&(core_info->users.gnss));
+	handle_reset_of_user(&(core_info->users.core));
+
+	core_info->users.nbr_of_users = 0;
+
+	/* Reset finished. We are now idle until first user is registered */
+	SET_MAIN_STATE(CORE_IDLE);
+
+	/*
+	 * Send wake-up since this might have been called from a failed boot.
+	 * No harm done if it is a CG2900 Core user who called.
+	 */
+	wake_up_interruptible(&main_wait_queue);
+
+	return 0;
+}
+EXPORT_SYMBOL(cg2900_reset);
+
+struct sk_buff *cg2900_alloc_skb(unsigned int size, gfp_t priority)
+{
+	struct sk_buff *skb;
+
+	CG2900_INFO("cg2900_alloc_skb");
+	CG2900_DBG("size %d bytes", size);
+
+	/* Allocate the SKB and reserve space for the header */
+	skb = alloc_skb(size + CG2900_SKB_RESERVE, priority);
+	if (skb)
+		skb_reserve(skb, CG2900_SKB_RESERVE);
+
+	return skb;
+}
+EXPORT_SYMBOL(cg2900_alloc_skb);
+
+int cg2900_write(struct cg2900_device *dev, struct sk_buff *skb)
+{
+	int err = 0;
+	u8 *h4_header;
+	struct cg2900_chip_callbacks *cb;
+
+	CG2900_DBG_DATA("cg2900_write");
+
+	BUG_ON(!core_info);
+
+	if (!dev) {
+		CG2900_ERR("cg2900_write with no device");
+		return -EINVAL;
+	}
+
+	if (!skb) {
+		CG2900_ERR("cg2900_write with no sk_buffer");
+		return -EINVAL;
+	}
+
+	CG2900_DBG_DATA("Length %d bytes", skb->len);
+
+	if (core_info->h4_channels.hci_logger_channel == dev->h4_channel) {
+		/*
+		 * Treat the HCI logger write differently.
+		 * A write can only mean a change of configuration.
+		 */
+		err = enable_hci_logger(skb);
+	} else if (core_info->h4_channels.core_channel == dev->h4_channel) {
+		CG2900_ERR("Not possible to write data on core channel, "
+			   "it only supports enable / disable chip");
+		err = -EPERM;
+	} else if (CORE_ACTIVE == core_info->main_state) {
+		/*
+		 * Move the data pointer to the H:4 header position and
+		 * store the H4 header.
+		 */
+		h4_header = skb_push(skb, CG2900_SKB_RESERVE);
+		*h4_header = (u8)dev->h4_channel;
+
+		/*
+		 * Check if the chip handler wants to handle this packet.
+		 * If not, send it to the transport.
+		 */
+		cb = &(core_info->chip_dev.cb);
+		if (!cb->data_to_chip ||
+		    !(cb->data_to_chip(&(core_info->chip_dev), dev, skb)))
+			transmit_skb_to_chip(skb, dev->logger_enabled);
+	} else {
+		CG2900_ERR("Trying to transmit data when CG2900 Core is not "
+			     "active");
+		err = -EACCES;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(cg2900_write);
+
+bool cg2900_get_local_revision(struct cg2900_rev_data *rev_data)
+{
+	BUG_ON(!core_info);
+
+	if (!rev_data) {
+		CG2900_ERR("Calling with rev_data NULL");
+		return false;
+	}
+
+	if (!core_info->local_chip_info.version_set)
+		return false;
+
+	rev_data->revision = core_info->local_chip_info.hci_revision;
+	rev_data->sub_version = core_info->local_chip_info.lmp_pal_subversion;
+
+	return true;
+}
+EXPORT_SYMBOL(cg2900_get_local_revision);
+
+int cg2900_register_chip_driver(struct cg2900_id_callbacks *cb)
+{
+	struct chip_handler_item *item;
+
+	CG2900_INFO("cg2900_register_chip_driver");
+
+	if (!cb) {
+		CG2900_ERR("NULL supplied as cb");
+		return -EINVAL;
+	}
+
+	item = kzalloc(sizeof(*item), GFP_ATOMIC);
+	if (!item) {
+		CG2900_ERR("Failed to alloc memory!");
+		return -ENOMEM;
+	}
+
+	memcpy(&(item->cb), cb, sizeof(cb));
+	list_add_tail(&item->list, &chip_handlers);
+	return 0;
+}
+EXPORT_SYMBOL(cg2900_register_chip_driver);
+
+int cg2900_register_trans_driver(struct cg2900_trans_callbacks *cb, void *data)
+{
+	int err;
+
+	BUG_ON(!core_info);
+
+	CG2900_INFO("cg2900_register_trans_driver");
+
+	if (core_info->trans_info) {
+		CG2900_ERR("trans_info already exists");
+		return -EACCES;
+	}
+
+	core_info->trans_info = kzalloc(sizeof(*(core_info->trans_info)),
+					GFP_KERNEL);
+	if (!core_info->trans_info) {
+		CG2900_ERR("Could not allocate trans_info");
+		return -ENOMEM;
+	}
+
+	memcpy(&(core_info->trans_info->cb), cb, sizeof(*cb));
+	core_info->trans_info->dev.dev = core_info->dev->this_device;
+	core_info->trans_info->dev.user_data = data;
+
+	err = create_work_item(core_info->wq, work_hw_registered, NULL);
+	if (err) {
+		CG2900_ERR("Could not create work item (%d) "
+			     "work_hw_registered", err);
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(cg2900_register_trans_driver);
+
+int cg2900_deregister_trans_driver(void)
+{
+	BUG_ON(!core_info);
+
+	CG2900_INFO("cg2900_deregister_trans_driver");
+
+	SET_MAIN_STATE(CORE_INITIALIZING);
+	SET_TRANSPORT_STATE(TRANS_INITIALIZING);
+
+	if (!core_info->trans_info)
+		return -EACCES;
+
+	kfree(core_info->trans_info);
+	core_info->trans_info = NULL;
+
+	return 0;
+}
+EXPORT_SYMBOL(cg2900_deregister_trans_driver);
+
+int cg2900_chip_startup_finished(int err)
+{
+	CG2900_INFO("cg2900_chip_startup_finished (%d)", err);
+
+	if (err)
+		/* Shutdown the chip */
+		chip_shutdown();
+	else
+		SET_MAIN_STATE(CORE_ACTIVE);
+
+	wake_up_interruptible(&main_wait_queue);
+
+	return 0;
+}
+EXPORT_SYMBOL(cg2900_chip_startup_finished);
+
+int cg2900_chip_shutdown_finished(int err)
+{
+	CG2900_INFO("cg2900_chip_shutdown_finished (%d)", err);
+
+	/* Close the transport, which will power off the chip */
+	close_transport();
+
+	/* Chip shut-down finished, set correct state and wake up the chip. */
+	SET_MAIN_STATE(CORE_IDLE);
+	wake_up_interruptible(&main_wait_queue);
+
+	return 0;
+}
+EXPORT_SYMBOL(cg2900_chip_shutdown_finished);
+
+int cg2900_send_to_chip(struct sk_buff *skb, bool use_logger)
+{
+	transmit_skb_to_chip(skb, use_logger);
+	return 0;
+}
+EXPORT_SYMBOL(cg2900_send_to_chip);
+
+struct cg2900_device *cg2900_get_bt_cmd_dev(void)
+{
+	if (core_info)
+		return core_info->users.bt_cmd;
+	else
+		return NULL;
+}
+EXPORT_SYMBOL(cg2900_get_bt_cmd_dev);
+
+struct cg2900_device *cg2900_get_fm_radio_dev(void)
+{
+	if (core_info)
+		return core_info->users.fm_radio;
+	else
+		return NULL;
+}
+EXPORT_SYMBOL(cg2900_get_fm_radio_dev);
+
+struct cg2900_device *cg2900_get_bt_audio_dev(void)
+{
+	if (core_info)
+		return core_info->users.bt_audio;
+	else
+		return NULL;
+}
+EXPORT_SYMBOL(cg2900_get_bt_audio_dev);
+
+struct cg2900_device *cg2900_get_fm_audio_dev(void)
+{
+	if (core_info)
+		return core_info->users.fm_radio_audio;
+	else
+		return NULL;
+}
+EXPORT_SYMBOL(cg2900_get_fm_audio_dev);
+
+struct cg2900_hci_logger_config *cg2900_get_hci_logger_config(void)
+{
+	if (core_info)
+		return &(core_info->hci_logger_config);
+	else
+		return NULL;
+}
+EXPORT_SYMBOL(cg2900_get_hci_logger_config);
+
+unsigned long cg2900_get_sleep_timeout(void)
+{
+	if (CORE_ACTIVE != core_info->main_state || !sleep_timeout_ms)
+		return 0;
+
+	return msecs_to_jiffies(sleep_timeout_ms);
+}
+EXPORT_SYMBOL(cg2900_get_sleep_timeout);
+
+void cg2900_data_from_chip(struct sk_buff *skb)
+{
+	struct cg2900_device *dev = NULL;
+	u8 h4_channel;
+	int err = 0;
+	struct cg2900_chip_callbacks *cb;
+	struct sk_buff *skb_log;
+	struct cg2900_device *logger;
+
+	CG2900_INFO("cg2900_data_from_chip");
+
+	if (!skb) {
+		CG2900_ERR("No data supplied");
+		return;
+	}
+
+	h4_channel = *(skb->data);
+
+	/*
+	 * First check if this is the response for something
+	 * we have sent internally.
+	 */
+	if ((core_info->main_state == CORE_BOOTING ||
+	     core_info->main_state == CORE_INITIALIZING) &&
+	    (HCI_BT_EVT_H4_CHANNEL == h4_channel) &&
+	    handle_rx_data_bt_evt(skb)) {
+		CG2900_DBG("Received packet handled internally");
+		return;
+	}
+
+	/* Find out where to route the data */
+	err = find_h4_user(h4_channel, &dev, skb);
+
+	/* Check if the chip handler wants to deal with the packet. */
+	cb = &(core_info->chip_dev.cb);
+	if (!err && cb->data_from_chip &&
+	    cb->data_from_chip(&(core_info->chip_dev), dev, skb))
+		return;
+
+	if (err || !dev) {
+		CG2900_ERR("H:4 channel: 0x%X,  does not match device",
+			     h4_channel);
+		kfree_skb(skb);
+		return;
+	}
+
+	/*
+	 * If HCI logging is enabled for this channel, copy the data to
+	 * the HCI logging output.
+	 */
+	logger = core_info->users.hci_logger;
+	if (!logger || !dev->logger_enabled)
+		goto transmit;
+
+	/*
+	 * Alloc a new sk_buffer and copy the data into it.
+	 * Then send it to the HCI logger.
+	 */
+	skb_log = alloc_skb(skb->len + 1, GFP_ATOMIC);
+	if (!skb_log) {
+		CG2900_ERR("Couldn't allocate skb_log");
+		goto transmit;
+	}
+
+	memcpy(skb_put(skb_log, skb->len), skb->data, skb->len);
+	skb_log->data[0] = (u8) LOGGER_DIRECTION_RX;
+
+	if (logger->cb->read_cb)
+		logger->cb->read_cb(logger, skb_log);
+
+transmit:
+	/* Remove the H4 header */
+	(void)skb_pull(skb, CG2900_SKB_RESERVE);
+
+	/* Call the Read callback */
+	if (dev->cb->read_cb)
+		dev->cb->read_cb(dev, skb);
+}
+EXPORT_SYMBOL(cg2900_data_from_chip);
+
+/*
+ * Module INIT and EXIT functions
+ */
+
+/**
+ * cg2900_init() - Initialize module.
+ *
+ * The cg2900_init() function initialize the transport and CG2900 Core, then
+ * register to the transport framework.
+ *
+ * Returns:
+ *   0 if success.
+ *   -ENOMEM for failed alloc or structure creation.
+ *   Error codes generated by cg2900_devices_init, alloc_chrdev_region,
+ *   class_create, device_create, core_init, tty_register_ldisc,
+ *   create_work_item, cg2900_char_devices_init.
+ */
+static int __init cg2900_init(void)
+{
+	int err;
+
+	CG2900_INFO("cg2900_init");
+
+	err = cg2900_devices_init();
+	if (err) {
+		CG2900_ERR("Couldn't initialize cg2900_devices");
+		return err;
+	}
+
+	core_info = kzalloc(sizeof(*core_info), GFP_KERNEL);
+	if (!core_info) {
+		CG2900_ERR("Couldn't allocate core_info");
+		return -ENOMEM;
+	}
+
+	/* Set the internal states */
+	core_info->main_state = CORE_INITIALIZING;
+	core_info->boot_state = BOOT_NOT_STARTED;
+	core_info->transport_state = TRANS_INITIALIZING;
+
+	/* Get the H4 channel ID for all channels */
+	core_info->h4_channels.bt_cmd_channel = HCI_BT_CMD_H4_CHANNEL;
+	core_info->h4_channels.bt_acl_channel = HCI_BT_ACL_H4_CHANNEL;
+	core_info->h4_channels.bt_evt_channel = HCI_BT_EVT_H4_CHANNEL;
+	core_info->h4_channels.gnss_channel = HCI_FM_RADIO_H4_CHANNEL;
+	core_info->h4_channels.fm_radio_channel = HCI_GNSS_H4_CHANNEL;
+
+	core_info->wq = create_singlethread_workqueue(CORE_WQ_NAME);
+	if (!core_info->wq) {
+		CG2900_ERR("Could not create workqueue");
+		err = -ENOMEM;
+		goto error_handling;
+	}
+
+	core_info->dev = kzalloc(sizeof(*(core_info->dev)), GFP_KERNEL);
+	if (!core_info->dev) {
+		CG2900_ERR("Couldn't allocate main device");
+		err = -ENOMEM;
+		goto error_handling_destroy_wq;
+	}
+
+	/* Prepare miscdevice struct before registering the device */
+	core_info->dev->minor = MISC_DYNAMIC_MINOR;
+	core_info->dev->name = CG2900_DEVICE_NAME;
+
+	err = misc_register(core_info->dev);
+	if (err) {
+		CG2900_ERR("Error %d registering main device!", err);
+		goto error_handling_dev_register;
+	}
+
+	core_info->chip_dev.dev = core_info->dev->this_device;
+
+	/* Create and add test char device. */
+	err = test_char_dev_create();
+	if (err)
+		goto error_handling_deregister;
+
+	/* Initialize the character devices */
+	err = cg2900_char_devices_init(core_info->dev);
+	if (err) {
+		CG2900_ERR("cg2900_char_devices_init failed %d", err);
+		goto error_handling_test_destroy;
+	}
+
+	return 0;
+
+error_handling_test_destroy:
+	test_char_dev_destroy();
+error_handling_deregister:
+	misc_deregister(core_info->dev);
+error_handling_dev_register:
+	kfree(core_info->dev);
+	core_info->dev = NULL;
+error_handling_destroy_wq:
+	destroy_workqueue(core_info->wq);
+error_handling:
+	kfree(core_info);
+	core_info = NULL;
+	return err;
+}
+
+/**
+ * cg2900_exit() - Remove module.
+ */
+static void __exit cg2900_exit(void)
+{
+	CG2900_INFO("cg2900_exit");
+
+	if (!core_info) {
+		CG2900_ERR("CG2900 Core not initiated");
+		return;
+	}
+
+	/* Remove initialized character devices */
+	cg2900_char_devices_exit();
+
+	test_char_dev_destroy();
+
+	/* Free the user devices */
+	free_user_dev(&(core_info->users.bt_cmd));
+	free_user_dev(&(core_info->users.bt_acl));
+	free_user_dev(&(core_info->users.bt_evt));
+	free_user_dev(&(core_info->users.fm_radio));
+	free_user_dev(&(core_info->users.gnss));
+	free_user_dev(&(core_info->users.debug));
+	free_user_dev(&(core_info->users.ste_tools));
+	free_user_dev(&(core_info->users.hci_logger));
+	free_user_dev(&(core_info->users.us_ctrl));
+	free_user_dev(&(core_info->users.core));
+
+	misc_deregister(core_info->dev);
+	kfree(core_info->dev);
+	core_info->dev = NULL;
+
+	destroy_workqueue(core_info->wq);
+
+	kfree(core_info);
+	core_info = NULL;
+
+	cg2900_devices_exit();
+}
+
+module_init(cg2900_init);
+module_exit(cg2900_exit);
+
+module_param(sleep_timeout_ms, int, S_IRUGO | S_IWUSR | S_IWGRP);
+MODULE_PARM_DESC(sleep_timeout_ms,
+		 "Sleep timeout for data transmissions:\n"
+		 "\t0 = disable <default>\n"
+		 "\t>0 = sleep timeout in milliseconds");
+
+module_param(cg2900_debug_level, int, S_IRUGO | S_IWUSR | S_IWGRP);
+MODULE_PARM_DESC(cg2900_debug_level,
+		 "Debug level. Default 1. Possible values:\n"
+		 "\t0  = No debug\n"
+		 "\t1  = Error prints\n"
+		 "\t10 = General info, e.g. function entries\n"
+		 "\t20 = Debug info, e.g. steps in a functionality\n"
+		 "\t25 = Data info, i.e. prints when data is transferred\n"
+		 "\t30 = Data content, i.e. contents of the transferred data");
+
+module_param_array(bd_address, byte, &bd_addr_count,
+		   S_IRUGO | S_IWUSR | S_IWGRP);
+MODULE_PARM_DESC(bd_address,
+		 "Bluetooth Device address. "
+		 "Default 0x00 0x80 0xDE 0xAD 0xBE 0xEF. "
+		 "Enter as comma separated value.");
+
+module_param(default_hci_revision, int, S_IRUGO | S_IWUSR | S_IWGRP);
+MODULE_PARM_DESC(default_hci_revision,
+		 "Default HCI revision according to Bluetooth Assigned "
+		 "Numbers.");
+
+module_param(default_manufacturer, int, S_IRUGO | S_IWUSR | S_IWGRP);
+MODULE_PARM_DESC(default_manufacturer,
+		 "Default Manufacturer according to Bluetooth Assigned "
+		 "Numbers.");
+
+module_param(default_sub_version, int, S_IRUGO | S_IWUSR | S_IWGRP);
+MODULE_PARM_DESC(default_sub_version,
+		 "Default HCI sub-version according to Bluetooth Assigned "
+		 "Numbers.");
+
+MODULE_AUTHOR("Par-Gunnar Hjalmdahl ST-Ericsson");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Linux Bluetooth HCI H:4 CG2900 Connectivity
Device Driver");
diff --git a/drivers/mfd/cg2900/cg2900_core.h b/drivers/mfd/cg2900/cg2900_core.h
new file mode 100644
index 0000000..dd07305
--- /dev/null
+++ b/drivers/mfd/cg2900/cg2900_core.h
@@ -0,0 +1,303 @@
+/*
+ * drivers/mfd/cg2900/cg2900_core.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for
ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson CG2900 GPS/BT/FM controller.
+ */
+
+#ifndef _CG2900_CORE_H_
+#define _CG2900_CORE_H_
+
+#include <linux/skbuff.h>
+#include <linux/device.h>
+
+/* Reserve 1 byte for the HCI H:4 header */
+#define CG2900_SKB_RESERVE			1
+
+#define BT_BDADDR_SIZE				6
+
+struct cg2900_h4_channels {
+	int	bt_cmd_channel;
+	int	bt_acl_channel;
+	int	bt_evt_channel;
+	int	gnss_channel;
+	int	fm_radio_channel;
+	int	debug_channel;
+	int	ste_tools_channel;
+	int	hci_logger_channel;
+	int	us_ctrl_channel;
+	int	core_channel;
+};
+
+/**
+  * struct cg2900_hci_logger_config - Configures the HCI logger.
+  * @bt_cmd_enable: Enable BT command logging.
+  * @bt_acl_enable: Enable BT ACL logging.
+  * @bt_evt_enable: Enable BT event logging.
+  * @gnss_enable: Enable GNSS logging.
+  * @fm_radio_enable: Enable FM radio logging.
+  * @bt_audio_enable: Enable BT audio command logging.
+  * @fm_radio_audio_enable: Enable FM radio audio command logging.
+  *
+  * Set using cg2900_write on CHANNEL_HCI_LOGGER H4 channel.
+  */
+struct cg2900_hci_logger_config {
+	bool bt_cmd_enable;
+	bool bt_acl_enable;
+	bool bt_evt_enable;
+	bool gnss_enable;
+	bool fm_radio_enable;
+	bool bt_audio_enable;
+	bool fm_radio_audio_enable;
+};
+
+/**
+ * struct cg2900_chip_info - Chip info structure.
+ * @manufacturer:	Chip manufacturer.
+ * @hci_revision:	Chip revision, i.e. which chip is this.
+ * @hci_sub_version:	Chip sub-version, i.e. which tape-out is this.
+ *
+ * Note that these values match the Bluetooth Assigned Numbers,
+ * see http://www.bluetooth.org/
+ */
+struct cg2900_chip_info {
+	int manufacturer;
+	int hci_revision;
+	int hci_sub_version;
+};
+
+struct cg2900_chip_dev;
+
+/**
+ * struct cg2900_chip_callbacks - Callback functions registered by
chip handler.
+ * @chip_startup:		Called when chip is started up.
+ * @chip_shutdown:		Called when chip is shut down.
+ * @data_to_chip:		Called when data shall be transmitted to chip.
+ *				Return true when CG2900 Core shall not send it
+ *				to chip.
+ * @data_from_chip:		Called when data shall be transmitted to user.
+ *				Return true when packet is taken care of by
+ *				Return chip return handler.
+ * @get_h4_channel:		Connects channel name with H:4 channel number.
+ * @is_bt_audio_user:		Return true if current packet is for
+ *				the BT audio user.
+ * @is_fm_audio_user:		Return true if current packet is for
+ *				the FM audio user.
+ * @last_bt_user_removed:	Last BT channel user has been removed.
+ * @last_fm_user_removed:	Last FM channel user has been removed.
+ * @last_gnss_user_removed:	Last GNSS channel user has been removed.
+ *
+ * Note that some callbacks may be NULL. They must always be NULL
checked before
+ * calling.
+ */
+struct cg2900_chip_callbacks {
+	int (*chip_startup)(struct cg2900_chip_dev *dev);
+	int (*chip_shutdown)(struct cg2900_chip_dev *dev);
+	bool (*data_to_chip)(struct cg2900_chip_dev *dev,
+			     struct cg2900_device *cg2900_dev,
+			     struct sk_buff *skb);
+	bool (*data_from_chip)(struct cg2900_chip_dev *dev,
+			       struct cg2900_device *cg2900_dev,
+			       struct sk_buff *skb);
+	int (*get_h4_channel)(char *name, int *h4_channel);
+	bool (*is_bt_audio_user)(int h4_channel,
+				 const struct sk_buff * const skb);
+	bool (*is_fm_audio_user)(int h4_channel,
+				 const struct sk_buff * const skb);
+	void (*last_bt_user_removed)(struct cg2900_chip_dev *dev);
+	void (*last_fm_user_removed)(struct cg2900_chip_dev *dev);
+	void (*last_gnss_user_removed)(struct cg2900_chip_dev *dev);
+};
+
+/**
+ * struct cg2900_chip_dev - Chip handler info structure.
+ * @dev:	Parent device from CG2900 Core.
+ * @chip:	Chip info such as manufacturer.
+ * @cb:		Callback structure for the chip handler.
+ * @user_data:	Arbitrary data set by chip handler.
+ */
+struct cg2900_chip_dev {
+	struct device			*dev;
+	struct cg2900_chip_info		chip;
+	struct cg2900_chip_callbacks	cb;
+	void				*user_data;
+};
+
+/**
+ * struct cg2900_id_callbacks - Chip handler identification callbacks.
+ * @check_chip_support:	Called when chip is connected. If chip is supported by
+ *			driver, return true and fill in @callbacks in @dev.
+ *
+ * Note that the callback may be NULL. It must always be NULL checked before
+ * calling.
+ */
+struct cg2900_id_callbacks {
+	bool (*check_chip_support)(struct cg2900_chip_dev *dev);
+};
+
+/**
+ * struct cg2900_trans_dev - CG2900 transport info structure.
+ * @dev:	Parent device from CG2900 Core.
+ * @user_data:	Arbitrary data set by chip handler.
+ */
+struct cg2900_trans_dev {
+	struct device	*dev;
+	void		*user_data;
+};
+
+/**
+ * struct cg2900_trans_callbacks - Callback functions registered by transport.
+ * @open:		CG2900 Core needs a transport.
+ * @close:		CG2900 Core does not need a transport.
+ * @write:		CG2900 Core transmits to the chip.
+ * @set_chip_power:	CG2900 Core enables or disables the chip.
+ *
+ * Note that some callbacks may be NULL. They must always be NULL
checked before
+ * calling.
+ */
+struct cg2900_trans_callbacks {
+	int (*open)(struct cg2900_trans_dev *dev);
+	int (*close)(struct cg2900_trans_dev *dev);
+	int (*write)(struct cg2900_trans_dev *dev, struct sk_buff *skb);
+	void (*set_chip_power)(bool chip_on);
+};
+
+/**
+ * cg2900_register_chip_driver() - Register a chip handler.
+ * @cb:	Callbacks to call when chip is connected.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL if NULL is supplied as @cb.
+ *   -ENOMEM if allocation fails or work queue can't be created.
+ */
+extern int cg2900_register_chip_driver(struct cg2900_id_callbacks *cb);
+
+/**
+ * cg2900_register_trans_driver() - Register a transport driver.
+ * @cb:		Callbacks to call when chip is connected.
+ * @data:	Arbitrary data used by the transport driver.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL if NULL is supplied as @cb.
+ *   -ENOMEM if allocation fails or work queue can't be created.
+ */
+extern int cg2900_register_trans_driver(struct cg2900_trans_callbacks *cb,
+					void *data);
+
+/**
+ * cg2900_deregister_trans_driver() - Deregister a transport driver.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL if NULL is supplied as @cb.
+ *   -ENOMEM if allocation fails or work queue can't be created.
+ */
+extern int cg2900_deregister_trans_driver(void);
+
+/**
+ * cg2900_chip_startup_finished() - Called from chip handler when
start-up is finished.
+ * @err:	Result of the start-up.
+ *
+ * Returns:
+ *   0 if there is no error.
+ */
+extern int cg2900_chip_startup_finished(int err);
+
+/**
+ * cg2900_chip_shutdown_finished() - Called from chip handler when
shutdown is finished.
+ * @err:	Result of the shutdown.
+ *
+ * Returns:
+ *   0 if there is no error.
+ */
+extern int cg2900_chip_shutdown_finished(int err);
+
+/**
+ * cg2900_send_to_chip() - Send data to chip.
+ * @skb:	Packet to transmit.
+ * @use_logger:	true if hci_logger should copy data content.
+ *
+ * Returns:
+ *   0 if there is no error.
+ */
+extern int cg2900_send_to_chip(struct sk_buff *skb, bool use_logger);
+
+/**
+ * cg2900_get_bt_cmd_dev() - Return user of the BT command H:4 channel.
+ *
+ * Returns:
+ *   User of the BT command H:4 channel.
+ *   NULL if no user is registered.
+ */
+extern struct cg2900_device *cg2900_get_bt_cmd_dev(void);
+
+/**
+ * cg2900_get_fm_radio_dev() - Return user of the FM radio H:4 channel.
+ *
+ * Returns:
+ *   User of the FM radio H:4 channel.
+ *   NULL if no user is registered.
+ */
+extern struct cg2900_device *cg2900_get_fm_radio_dev(void);
+
+/**
+ * cg2900_get_bt_audio_dev() - Return user of the BT audio H:4 channel.
+ *
+ * Returns:
+ *   User of the BT audio H:4 channel.
+ *   NULL if no user is registered.
+ */
+extern struct cg2900_device *cg2900_get_bt_audio_dev(void);
+
+/**
+ * cg2900_get_fm_audio_dev() - Return user of the FM audio H:4 channel.
+ *
+ * Returns:
+ *   User of the FM audio H:4 channel.
+ *   NULL if no user is registered.
+ */
+extern struct cg2900_device *cg2900_get_fm_audio_dev(void);
+
+/**
+ * cg2900_get_hci_logger_config() - Return HCI Logger configuration.
+ *
+ * Returns:
+ *   HCI logger configuration.
+ *   NULL if CG2900 Core has not yet been started.
+ */
+extern struct cg2900_hci_logger_config *cg2900_get_hci_logger_config(void);
+
+/**
+ * cg2900_get_sleep_timeout() - Return sleep timeout in jiffies.
+ *
+ * Returns:
+ *   Sleep timeout in jiffies. 0 means that sleep timeout shall not be used.
+ */
+extern unsigned long cg2900_get_sleep_timeout(void);
+
+/**
+ * cg2900_data_from_chip() - Data received from connectivity controller.
+ * @skb: Data packet
+ *
+ * The cg2900_data_from_chip() function checks which channel
+ * the data was received on and send to the right user.
+ */
+extern void cg2900_data_from_chip(struct sk_buff *skb);
+
+/* module_param declared in cg2900_core.c */
+extern u8 bd_address[BT_BDADDR_SIZE];
+extern int default_manufacturer;
+extern int default_hci_revision;
+extern int default_sub_version;
+
+#endif /* _CG2900_CORE_H_ */
diff --git a/drivers/mfd/cg2900/cg2900_debug.h
b/drivers/mfd/cg2900/cg2900_debug.h
new file mode 100644
index 0000000..a3aeeaf
--- /dev/null
+++ b/drivers/mfd/cg2900/cg2900_debug.h
@@ -0,0 +1,77 @@
+/*
+ * drivers/mfd/cg2900/cg2900_debug.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for
ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Debug functionality for the Linux Bluetooth HCI H:4 Driver for ST-Ericsson
+ * CG2900 connectivity controller.
+ */
+
+#ifndef _CG2900_DEBUG_H_
+#define _CG2900_DEBUG_H_
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+
+#define CG2900_DEFAULT_DEBUG_LEVEL 1
+
+/* module_param declared in cg2900_core.c */
+extern int cg2900_debug_level;
+
+#if defined(NDEBUG) || CG2900_DEFAULT_DEBUG_LEVEL == 0
+	#define CG2900_DBG_DATA_CONTENT(fmt, arg...)
+	#define CG2900_DBG_DATA(fmt, arg...)
+	#define CG2900_DBG(fmt, arg...)
+	#define CG2900_INFO(fmt, arg...)
+	#define CG2900_ERR(fmt, arg...)
+#else
+	#define CG2900_DBG_DATA_CONTENT(fmt, arg...)			\
+	do {								\
+		if (cg2900_debug_level >= 30)				\
+			printk(KERN_DEBUG "CG2900 %s: " fmt "\n" , __func__ , \
+			       ## arg); \
+	} while (0)
+
+	#define CG2900_DBG_DATA(fmt, arg...)				\
+	do {								\
+		if (cg2900_debug_level >= 25)				\
+			printk(KERN_DEBUG "CG2900 %s: " fmt "\n" , __func__ , \
+			       ## arg); \
+	} while (0)
+
+	#define CG2900_DBG(fmt, arg...)				\
+	do {								\
+		if (cg2900_debug_level >= 20)				\
+			printk(KERN_DEBUG "CG2900 %s: " fmt "\n" , __func__ , \
+			       ## arg); \
+	} while (0)
+
+	#define CG2900_INFO(fmt, arg...)				\
+	do {								\
+		if (cg2900_debug_level >= 10)				\
+			printk(KERN_INFO "CG2900: " fmt "\n" , ## arg); \
+	} while (0)
+
+	#define CG2900_ERR(fmt, arg...)				\
+	do {								\
+		if (cg2900_debug_level >= 1)				\
+			printk(KERN_ERR  "CG2900 %s: " fmt "\n" , __func__ , \
+			       ## arg); \
+	} while (0)
+
+#endif /* NDEBUG */
+
+#define CG2900_SET_STATE(__name, __var, __new_state)	\
+do {									\
+	CG2900_DBG("New %s: 0x%X", __name, (uint32_t)__new_state);	\
+	__var = __new_state;				\
+} while (0)
+
+#endif /* _CG2900_DEBUG_H_ */
diff --git a/drivers/mfd/cg2900/hci_defines.h b/drivers/mfd/cg2900/hci_defines.h
new file mode 100644
index 0000000..e7f7c30
--- /dev/null
+++ b/drivers/mfd/cg2900/hci_defines.h
@@ -0,0 +1,102 @@
+/*
+ * drivers/mfd/cg2900/hci_defines.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for
ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI defines for ST-Ericsson CG2900 connectivity controller.
+ */
+
+#ifndef _BLUETOOTH_DEFINES_H_
+#define _BLUETOOTH_DEFINES_H_
+
+#include <linux/types.h>
+
+/* H:4 offset in an HCI packet */
+#define HCI_H4_POS				0
+#define HCI_H4_SIZE				1
+
+/* Standardized Bluetooth H:4 channels */
+#define HCI_BT_CMD_H4_CHANNEL			0x01
+#define HCI_BT_ACL_H4_CHANNEL			0x02
+#define HCI_BT_SCO_H4_CHANNEL			0x03
+#define HCI_BT_EVT_H4_CHANNEL			0x04
+
+/* Bluetooth Opcode Group Field (OGF) */
+#define HCI_BT_OGF_LINK_CTRL			0x01
+#define HCI_BT_OGF_LINK_POLICY			0x02
+#define HCI_BT_OGF_CTRL_BB			0x03
+#define HCI_BT_OGF_LINK_INFO			0x04
+#define HCI_BT_OGF_LINK_STATUS			0x05
+#define HCI_BT_OGF_LINK_TESTING			0x06
+#define HCI_BT_OGF_VS				0x3F
+
+/* Bluetooth Opcode Command Field (OCF) */
+#define HCI_BT_OCF_READ_LOCAL_VERSION_INFO	0x0001
+#define HCI_BT_OCF_RESET			0x0003
+
+/* Bluetooth HCI command OpCodes in LSB/MSB fashion */
+#define HCI_BT_RESET_CMD_LSB			0x03
+#define HCI_BT_RESET_CMD_MSB			0x0C
+#define HCI_BT_READ_LOCAL_VERSION_CMD_LSB	0x01
+#define HCI_BT_READ_LOCAL_VERSION_CMD_MSB	0x10
+
+/* Bluetooth Event OpCodes */
+#define HCI_BT_EVT_CMD_COMPLETE			0x0E
+#define HCI_BT_EVT_CMD_STATUS			0x0F
+
+/* Bluetooth Command offsets */
+#define HCI_BT_CMD_ID_POS			1
+#define HCI_BT_CMD_PARAM_LEN_POS		3
+#define HCI_BT_CMD_PARAM_POS			4
+#define HCI_BT_CMD_HDR_SIZE			4
+
+/* Bluetooth Event offsets for CG2900 users, i.e. not including H:4 channel */
+#define HCI_BT_EVT_ID_POS			0
+#define HCI_BT_EVT_LEN_POS			1
+#define HCI_BT_EVT_CMD_COMPL_ID_POS		3
+#define HCI_BT_EVT_CMD_STATUS_ID_POS		4
+#define HCI_BT_EVT_CMD_COMPL_STATUS_POS		5
+#define HCI_BT_EVT_CMD_STATUS_STATUS_POS	2
+#define HCI_BT_EVT_CMD_COMPL_NR_OF_PKTS_POS	2
+#define HCI_BT_EVT_CMD_STATUS_NR_OF_PKTS_POS	3
+
+#define HCI_BT_EVT_CMD_COMPL_ID_POS_LSB		HCI_BT_EVT_CMD_COMPL_ID_POS
+#define HCI_BT_EVT_CMD_COMPL_ID_POS_MSB
(HCI_BT_EVT_CMD_COMPL_ID_POS + 1)
+#define HCI_BT_EVT_CMD_STATUS_ID_POS_LSB	HCI_BT_EVT_CMD_STATUS_ID_POS
+#define HCI_BT_EVT_CMD_STATUS_ID_POS_MSB
(HCI_BT_EVT_CMD_STATUS_ID_POS + 1)
+
+/* Bluetooth error codes */
+#define HCI_BT_ERROR_NO_ERROR			0x00
+#define HCI_BT_ERROR_CMD_DISALLOWED		0x0C
+
+/* Bluetooth lengths */
+#define HCI_BT_SEND_FILE_MAX_CHUNK_SIZE		254
+
+#define HCI_BT_RESET_LEN			3
+#define HCI_BT_RESET_PARAM_LEN			0
+#define HCI_BT_CMD_COMPLETE_NO_PARAM_LEN	4
+
+/* Utility macros */
+#define GET_U16_FROM_L_ENDIAN(__u8_lsb, __u8_msb)	((u16)(__u8_lsb | \
+							 (__u8_msb << 8)))
+#define HCI_BT_MAKE_FIRST_BYTE_IN_CMD(__ocf)		((u8)(__ocf & 0x00FF))
+#define HCI_BT_MAKE_SECOND_BYTE_IN_CMD(__ogf, __ocf)	((u8)(__ogf << 2) | \
+		((__ocf >> 8) & 0x0003))
+#define HCI_BT_ID_TO_OCF(__1st_byte, __2nd_byte)	((u16)(__1st_byte | \
+		((__2nd_byte & 0x03) << 8)))
+#define HCI_BT_ID_TO_OGF(__1st_byte)		((u8)(__1st_byte >> 2))
+#define HCI_BT_GET_ID				GET_U16_FROM_L_ENDIAN
+#define HCI_BT_EVENT_GET_ID			GET_U16_FROM_L_ENDIAN
+
+/* Macros to set multibyte words to correct HCI endian (always Little
Endian) */
+#define HCI_SET_U16_DATA_LSB(__u16_data)	((u8)(__u16_data & 0x00FF))
+#define HCI_SET_U16_DATA_MSB(__u16_data)	((u8)(__u16_data >> 8))
+
+#endif /* _BLUETOOTH_DEFINES_H_ */
diff --git a/include/linux/mfd/cg2900.h b/include/linux/mfd/cg2900.h
new file mode 100644
index 0000000..9c2afc5
--- /dev/null
+++ b/include/linux/mfd/cg2900.h
@@ -0,0 +1,205 @@
+/*
+ * include/linux/mfd/cg2900.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for
ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson CG2900 connectivity
+ * controller.
+ */
+
+#ifndef _CG2900_H_
+#define _CG2900_H_
+
+#include <linux/skbuff.h>
+
+#define CG2900_MAX_NAME_SIZE 30
+
+/*
+ * Channel names to use when registering to CG2900 driver
+ */
+
+/** CG2900_BT_CMD - Bluetooth HCI H4 channel for Bluetooth commands.
+ */
+#define CG2900_BT_CMD		"cg2900_bt_cmd"
+
+/** CG2900_BT_ACL - Bluetooth HCI H4 channel for Bluetooth ACL data.
+ */
+#define CG2900_BT_ACL		"cg2900_bt_acl"
+
+/** CG2900_BT_EVT - Bluetooth HCI H4 channel for Bluetooth events.
+ */
+#define CG2900_BT_EVT		"cg2900_bt_evt"
+
+/** CG2900_FM_RADIO - Bluetooth HCI H4 channel for FM radio.
+ */
+#define CG2900_FM_RADIO		"cg2900_fm_radio"
+
+/** CG2900_GNSS - Bluetooth HCI H4 channel for GNSS.
+ */
+#define CG2900_GNSS		"cg2900_gnss"
+
+/** CG2900_DEBUG - Bluetooth HCI H4 channel for internal debug data.
+ */
+#define CG2900_DEBUG		"cg2900_debug"
+
+/** CG2900_STE_TOOLS - Bluetooth HCI H4 channel for development tools data.
+ */
+#define CG2900_STE_TOOLS	"cg2900_ste_tools"
+
+/** CG2900_HCI_LOGGER - BT channel for logging all transmitted H4 packets.
+ * Data read is copy of all data transferred on the other channels.
+ * Only write allowed is configuration of the HCI Logger.
+ */
+#define CG2900_HCI_LOGGER	"cg2900_hci_logger"
+
+/** CG2900_US_CTRL - Channel for user space init and control of CG2900.
+ */
+#define CG2900_US_CTRL		"cg2900_us_ctrl"
+
+/** CG2900_BT_AUDIO - HCI Channel for BT audio configuration commands.
+ * Maps to Bluetooth command and event channels.
+ */
+#define CG2900_BT_AUDIO		"cg2900_bt_audio"
+
+/** CG2900_FM_RADIO_AUDIO - HCI channel for FM audio configuration commands.
+ * Maps to FM Radio channel.
+ */
+#define CG2900_FM_RADIO_AUDIO	"cg2900_fm_audio"
+
+/** CG2900_CORE- Channel for keeping ST-Ericsson CG2900 enabled.
+ * Opening this channel forces the chip to stay powered.
+ * No data can be written to or read from this channel.
+ */
+#define CG2900_CORE		"cg2900_core"
+
+struct cg2900_callbacks;
+
+/**
+ * struct cg2900_device - Device structure for CG2900 user.
+ * @h4_channel:		HCI H:4 channel used by this device.
+ * @cb:			Callback functions registered by this device.
+ * @logger_enabled:	true if HCI logger is enabled for this channel,
+ *			false otherwise.
+ * @user_data:		Arbitrary data used by caller.
+ * @dev:		Parent device this driver is connected to.
+ *
+ * Defines data needed to access an HCI channel.
+ */
+struct cg2900_device {
+	int				h4_channel;
+	struct cg2900_callbacks		*cb;
+	bool				logger_enabled;
+	void				*user_data;
+	struct device			*dev;
+};
+
+/**
+ * struct cg2900_callbacks - Callback structure for CG2900 user.
+ * @read_cb:	Callback function called when data is received from
+ *		the connectivity controller.
+ * @reset_cb:	Callback function called when the connectivity controller has
+ *		been reset.
+ *
+ * Defines the callback functions provided from the caller.
+ */
+struct cg2900_callbacks {
+	void (*read_cb) (struct cg2900_device *dev, struct sk_buff *skb);
+	void (*reset_cb) (struct cg2900_device *dev);
+};
+
+/**
+ * struct cg2900_rev_data - Contains revision data for the local controller.
+ * @revision:		Revision of the controller, e.g. to indicate that it is
+ *			a CG2900 controller.
+ * @sub_version:	Subversion of the controller, e.g. to indicate a certain
+ *			tape-out of the controller.
+ *
+ * The values to match retrieved values to each controller may be
retrieved from
+ * the manufacturer.
+ */
+struct cg2900_rev_data {
+	int revision;
+	int sub_version;
+};
+
+/**
+ * cg2900_register_user() - Register CG2900 user.
+ * @name:	Name of HCI H:4 channel to register to.
+ * @cb:		Callback structure to use for the H:4 channel.
+ *
+ * Returns:
+ *   Pointer to CG2900 device structure if successful.
+ *   NULL upon failure.
+ */
+extern struct cg2900_device *cg2900_register_user(char *name,
+						  struct cg2900_callbacks *cb);
+
+/**
+ * cg2900_deregister_user() - Remove registration of CG2900 user.
+ * @dev:	CG2900 device.
+ */
+extern void cg2900_deregister_user(struct cg2900_device *dev);
+
+/**
+ * cg2900_reset() - Reset the CG2900 controller.
+ * @dev:	CG2900 device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EACCES if driver has not been initialized.
+ */
+extern int cg2900_reset(struct cg2900_device *dev);
+
+/**
+ * cg2900_alloc_skb() - Alloc an sk_buff structure for CG2900 handling.
+ * @size:	Size in number of octets.
+ * @priority:	Allocation priority, e.g. GFP_KERNEL.
+ *
+ * Returns:
+ *   Pointer to sk_buff buffer structure if successful.
+ *   NULL upon allocation failure.
+ */
+extern struct sk_buff *cg2900_alloc_skb(unsigned int size, gfp_t priority);
+
+/**
+ * cg2900_write() - Send data to the connectivity controller.
+ * @dev: CG2900 device.
+ * @skb: Data packet.
+ *
+ * The cg2900_write() function sends data to the connectivity controller.
+ * If the return value is 0 the skb will be freed by the driver,
+ * otherwise it won't be freed.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EACCES if driver has not been initialized or trying to write while driver
+ *   is not active.
+ *   -EINVAL if NULL pointer was supplied.
+ *   -EPERM if operation is not permitted, e.g. trying to write to a channel
+ *   that doesn't handle write operations.
+ *   Error codes returned from core_enable_hci_logger.
+ */
+extern int cg2900_write(struct cg2900_device *dev, struct sk_buff *skb);
+
+/**
+ * cg2900_get_local_revision() - Read revision of the connected controller.
+ * @rev_data:	Revision data structure to fill. Must be allocated by caller.
+ *
+ * The cg2900_get_local_revision() function returns the revision data of the
+ * local controller if available. If data is not available, e.g. because the
+ * controller has not yet been started this function will return false.
+ *
+ * Returns:
+ *   true if revision data is available.
+ *   false if no revision data is available.
+ */
+extern bool cg2900_get_local_revision(struct cg2900_rev_data *rev_data);
+
+#endif /* _CG2900_H_ */
-- 
1.6.3.3
