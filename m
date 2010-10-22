Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab0JVKkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 06:40:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50282 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab0JVKkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 06:40:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:date:x-google-sender-auth:message-id
         :subject:from:to:content-type;
        b=lCboM8Yl7iW4GmO2wTO1xdcWFEGCWzPITx5P248nhByhzyIsQy76Sgg2Gbq9TzEs18
         RWWaKkslYiBPhhnCDNM00rdIN/xr9OBtfZgKkSvFylI5Vh9s0AcsJQKgCnZxNhiAO2eO
         6k+F2xSZfqsr1hGN2EFWvTmnyDS71I4bFa5HM=
MIME-Version: 1.0
Reply-To: pghatwork@gmail.com
Date: Fri, 22 Oct 2010 12:39:59 +0200
X-Google-Sender-Auth: kUP8UNGkgvzH0SOYwEVSG5JLp78
Message-ID: <AANLkTi=ir_iDdBTTrnyjJW5F11yXo3M-Y6B-MZpPoYag@mail.gmail.com>
Subject: [PATCH 7/9] mach-ux500: Add support for the ST-Ericsson CG2900.
From: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
To: linus.walleij@stericsson.com, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds board specific support for the ST-Ericsson CG2900
Connectivity Combo controller.
It contains device structures as well as necessary callback
functions.

Signed-off-by: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
---
 arch/arm/mach-ux500/Makefile               |    1 +
 arch/arm/mach-ux500/board-mop500.c         |    3 +
 arch/arm/mach-ux500/devices-cg2900.c       |  261 ++++++++++++++++++++++++++++
 arch/arm/mach-ux500/include/mach/devices.h |    4 +
 4 files changed, 269 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-ux500/devices-cg2900.c

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index 9e27a84..7754aff 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_LOCAL_TIMERS)	+= localtimer.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= board-mop500-regulators.o
 obj-$(CONFIG_U5500_MODEM_IRQ)	+= modem_irq.o
 obj-$(CONFIG_U5500_MBOX)	+= mbox.o
+obj-$(CONFIG_MFD_CG2900)	+= devices-cg2900.o
diff --git a/arch/arm/mach-ux500/board-mop500.c
b/arch/arm/mach-ux500/board-mop500.c
index 09fba17..589921b 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -303,6 +303,9 @@ static struct platform_device *platform_devs[]
__initdata = {
 	&ux500_i2c2_device,
 	&ux500_i2c3_device,
 	&ux500_ske_keypad_device,
+#ifdef CONFIG_MFD_CG2900
+	&ux500_cg2900_device,
+#endif
 };

 static void __init u8500_init_machine(void)
diff --git a/arch/arm/mach-ux500/devices-cg2900.c
b/arch/arm/mach-ux500/devices-cg2900.c
new file mode 100644
index 0000000..b5c60d5
--- /dev/null
+++ b/arch/arm/mach-ux500/devices-cg2900.c
@@ -0,0 +1,261 @@
+/*
+ * arch/arm/mach-ux500/devices-cg2900.c
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
+#include <asm/byteorder.h>
+#include <asm-generic/errno-base.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/skbuff.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/mfd/cg2900.h>
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci.h>
+#include <plat/pincfg.h>
+
+#include "pins-db8500.h"
+
+#ifdef CONFIG_MFD_CG2900
+
+#define BT_ENABLE_GPIO			170
+#define GBF_ENA_RESET_GPIO		171
+#define BT_CTS_GPIO			0
+
+#define GBF_ENA_RESET_NAME		"gbf_ena_reset"
+#define BT_ENABLE_NAME			"bt_enable"
+#define CG2900_NAME			"cg2900_devices"
+
+#define UART_LINES_NUM			4
+
+#define BT_VS_POWER_SWITCH_OFF		0xFD40
+
+#define H4_HEADER_LENGTH		0x01
+#define BT_HEADER_LENGTH		0x03
+
+#define STLC2690_HCI_REV		0x0600
+#define CG2900_PG1_HCI_REV		0x0101
+#define CG2900_PG2_HCI_REV		0x0200
+#define CG2900_PG1_SPECIAL_HCI_REV	0x0700
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
+static u16 cg2900_hci_revision;
+
+/* Pin configuration for UART functions. */
+static pin_cfg_t uart0_enabled[] = {
+	GPIO0_U0_CTSn   | (PIN_DIR_INPUT | PIN_PULL_UP),
+	GPIO1_U0_RTSn   | PIN_OUTPUT_HIGH,
+	GPIO2_U0_RXD    | (PIN_DIR_INPUT | PIN_PULL_UP),
+	GPIO3_U0_TXD    | PIN_OUTPUT_HIGH
+};
+
+/* Pin configuration for sleep mode. */
+static pin_cfg_t uart0_disabled[] = {
+	GPIO0_GPIO   | (PIN_DIR_INPUT | PIN_PULL_UP),	/* CTS pull up. */
+	GPIO1_GPIO   | PIN_OUTPUT_HIGH,		/* RTS high - flow off. */
+	GPIO2_GPIO   | (PIN_DIR_INPUT | PIN_PULL_UP),	/* RX pull down. */
+	GPIO3_GPIO   | PIN_OUTPUT_LOW		/* TX low - break on. */
+};
+
+static void cg2900_enable_chip(void)
+{
+	gpio_set_value(GBF_ENA_RESET_GPIO, 1);
+}
+
+static void cg2900_disable_chip(void)
+{
+	gpio_set_value(GBF_ENA_RESET_GPIO, 0);
+}
+
+static void cg2900_set_hci_revision(u8 hci_version, u16 hci_revision,
+				    u8 lmp_version, u8 lmp_subversion,
+				    u16 manufacturer)
+{
+	cg2900_hci_revision = hci_revision;
+	/* We don't care about the other values */
+}
+
+static struct sk_buff *cg2900_get_power_switch_off_cmd(u16 *op_code)
+{
+	struct sk_buff *skb;
+	struct vs_power_sw_off_cmd *cmd;
+
+	/* If connected chip does not support the command return NULL */
+	if (CG2900_PG1_SPECIAL_HCI_REV != cg2900_hci_revision &&
+	    CG2900_PG1_HCI_REV != cg2900_hci_revision &&
+	    CG2900_PG2_HCI_REV != cg2900_hci_revision)
+		return NULL;
+
+	skb = alloc_skb(sizeof(*cmd) + H4_HEADER_LENGTH, GFP_KERNEL);
+	if (!skb) {
+		pr_err(CG2900_NAME "Could not allocate skb");
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
+static int cg2900_init(void)
+{
+	int err = 0;
+
+	err = gpio_request(GBF_ENA_RESET_GPIO, GBF_ENA_RESET_NAME);
+	if (err < 0) {
+		pr_err(CG2900_NAME "gpio_request failed with err: %d", err);
+		goto finished;
+	}
+
+	err = gpio_direction_output(GBF_ENA_RESET_GPIO, 1);
+	if (err < 0) {
+		pr_err(CG2900_NAME "gpio_direction_output failed with err: %d",
+		       err);
+		goto error_handling;
+	}
+
+	err = gpio_request(BT_ENABLE_GPIO, BT_ENABLE_NAME);
+	if (err < 0) {
+		pr_err(CG2900_NAME "gpio_request failed with err: %d", err);
+		goto finished;
+	}
+
+	err = gpio_direction_output(BT_ENABLE_GPIO, 1);
+	if (err < 0) {
+		pr_err(CG2900_NAME "gpio_direction_output failed with err: %d",
+		       err);
+		goto error_handling;
+	}
+
+	goto finished;
+
+error_handling:
+	gpio_free(GBF_ENA_RESET_GPIO);
+
+finished:
+	cg2900_disable_chip();
+	return err;
+}
+
+void cg2900_exit(void)
+{
+	cg2900_disable_chip();
+	gpio_free(GBF_ENA_RESET_GPIO);
+}
+
+#ifdef CONFIG_MFD_CG2900_UART
+
+static int cg2900_disable_uart(void)
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
+	if (err)
+		goto error;
+
+	return 0;
+
+error:
+	(void)nmk_config_pins(uart0_enabled, UART_LINES_NUM);
+	pr_err(CG2900_NAME "Cannot set interrupt (%d)", err);
+	return err;
+}
+
+
+static int cg2900_enable_uart(void)
+{
+	int err;
+
+	/* Restore UART settings. */
+	err = nmk_config_pins(uart0_enabled, UART_LINES_NUM);
+	if (err)
+		pr_err(CG2900_NAME "Unable to enable UART (%d)", err);
+
+	return err;
+}
+
+#endif /* CONFIG_MFD_CG2900_UART */
+
+struct cg2900_platform_data cg2900_platform_data = {
+	.init = cg2900_init,
+	.exit = cg2900_exit,
+	.enable_chip = cg2900_enable_chip,
+	.disable_chip = cg2900_disable_chip,
+	.set_hci_revision = cg2900_set_hci_revision,
+	.get_power_switch_off_cmd = cg2900_get_power_switch_off_cmd,
+
+	.bus = HCI_UART,
+
+#ifdef CONFIG_MFD_CG2900_UART
+	.uart = {
+		.cts_irq = NOMADIK_GPIO_TO_IRQ(BT_CTS_GPIO),
+		.enable_uart = cg2900_enable_uart,
+		.disable_uart = cg2900_disable_uart
+	},
+#endif /* CONFIG_MFD_CG2900_UART */
+};
+
+struct platform_device ux500_cg2900_device = {
+	.name = "cg2900",
+	.dev = {
+		.platform_data = &cg2900_platform_data,
+	}
+};
+#endif /* CONFIG_MFD_CG2900 */
diff --git a/arch/arm/mach-ux500/include/mach/devices.h
b/arch/arm/mach-ux500/include/mach/devices.h
index b91a4d1..cbc7897 100644
--- a/arch/arm/mach-ux500/include/mach/devices.h
+++ b/arch/arm/mach-ux500/include/mach/devices.h
@@ -28,6 +28,10 @@ extern struct platform_device u8500_i2c4_device;
 extern struct platform_device u8500_dma40_device;
 extern struct platform_device ux500_ske_keypad_device;

+#ifdef CONFIG_MFD_CG2900
+extern struct platform_device ux500_cg2900_device;
+#endif
+
 extern struct amba_device u8500_sdi0_device;
 extern struct amba_device u8500_sdi1_device;
 extern struct amba_device u8500_sdi2_device;
-- 
1.6.3.3
