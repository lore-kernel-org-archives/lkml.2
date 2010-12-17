Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab0LQLvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 06:51:06 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:58012 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751750Ab0LQLuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 06:50:39 -0500
From: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
To: Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
Subject: [PATCH 10/11] arch_mach-ux500: Add U8500 board support for CG2900
Date: Fri, 17 Dec 2010 12:25:49 +0100
Message-ID: <1292585149-28654-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device settings and necessary callbacks for
the ST-Ericsson CG2900 MFD driver into the UX500 board files.
CG2900 is Connectivity combo controller supporting GPS, Bluetooth,
and FM radio.

Signed-off-by: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
---
 arch/arm/mach-ux500/Makefile         |    1 +
 arch/arm/mach-ux500/board-mop500.c   |  152 ++++++++++++++++
 arch/arm/mach-ux500/devices-cg2900.c |  313 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-ux500/devices-cg2900.h |   19 ++
 4 files changed, 485 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-ux500/devices-cg2900.c
 create mode 100644 arch/arm/mach-ux500/devices-cg2900.h

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index 8411183..3497ec4 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_REGULATOR_AB8500)	+= board-mop500-regulators.o
 obj-$(CONFIG_U5500_MODEM_IRQ)	+= modem_irq.o
 obj-$(CONFIG_U5500_MBOX)	+= mbox.o
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq.o
+obj-$(CONFIG_MFD_CG2900)	+= devices-cg2900.o
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 3c3daf6..727d4a5 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -20,9 +20,13 @@
 #include <linux/amba/serial.h>
 #include <linux/spi/spi.h>
 #include <linux/mfd/ab8500.h>
+#include <linux/mfd/cg2900.h>
 #include <linux/mfd/tc35892.h>
 #include <linux/input/matrix_keypad.h>
 
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci.h>
+
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
@@ -37,6 +41,7 @@
 #include <mach/irqs.h>
 
 #include "ste-dma40-db8500.h"
+#include "devices-cg2900.h"
 #include "devices-db8500.h"
 #include "pins-db8500.h"
 #include "board-mop500.h"
@@ -133,6 +138,130 @@ static struct spi_board_info ab8500_spi_devices[] = {
 	},
 };
 
+#ifdef CONFIG_MFD_CG2900
+#define CG2900_BT_ENABLE_GPIO		170
+#define CG2900_GBF_ENA_RESET_GPIO	171
+#define CG2900_BT_CTS_GPIO		0
+
+enum cg2900_gpio_pull_sleep cg2900_sleep_gpio[21] = {
+	CG2900_NO_PULL,		/* GPIO 0:  PTA_CONFX */
+	CG2900_PULL_DN,		/* GPIO 1:  PTA_STATUS */
+	CG2900_NO_PULL,		/* GPIO 2:  UART_CTSN */
+	CG2900_PULL_UP,		/* GPIO 3:  UART_RTSN */
+	CG2900_PULL_UP,		/* GPIO 4:  UART_TXD */
+	CG2900_NO_PULL,		/* GPIO 5:  UART_RXD */
+	CG2900_PULL_DN,		/* GPIO 6:  IOM_DOUT */
+	CG2900_NO_PULL,		/* GPIO 7:  IOM_FSC */
+	CG2900_NO_PULL,		/* GPIO 8:  IOM_CLK */
+	CG2900_NO_PULL,		/* GPIO 9:  IOM_DIN */
+	CG2900_PULL_DN,		/* GPIO 10: PWR_REQ */
+	CG2900_PULL_DN,		/* GPIO 11: HOST_WAKEUP */
+	CG2900_PULL_DN,		/* GPIO 12: IIS_DOUT */
+	CG2900_NO_PULL,		/* GPIO 13: IIS_WS */
+	CG2900_NO_PULL,		/* GPIO 14: IIS_CLK */
+	CG2900_NO_PULL,		/* GPIO 15: IIS_DIN */
+	CG2900_PULL_DN,		/* GPIO 16: PTA_FREQ */
+	CG2900_PULL_DN,		/* GPIO 17: PTA_RF_ACTIVE */
+	CG2900_NO_PULL,		/* GPIO 18: NotConnected (J6428) */
+	CG2900_NO_PULL,		/* GPIO 19: EXT_DUTY_CYCLE */
+	CG2900_NO_PULL,		/* GPIO 20: EXT_FRM_SYNCH */
+};
+
+static struct platform_device ux500_cg2900_device = {
+	.name = "cg2900",
+};
+
+#ifdef CONFIG_MFD_CG2900_CHIP
+static struct platform_device ux500_cg2900_chip_device = {
+	.name = "cg2900-chip",
+	.dev = {
+		.parent = &ux500_cg2900_device.dev,
+	},
+};
+#endif /* CONFIG_MFD_CG2900_CHIP */
+
+#ifdef CONFIG_MFD_STLC2690_CHIP
+static struct platform_device ux500_stlc2690_chip_device = {
+	.name = "stlc2690-chip",
+	.dev = {
+		.parent = &ux500_cg2900_device.dev,
+	},
+};
+#endif /* CONFIG_MFD_STLC2690_CHIP */
+
+#ifdef CONFIG_MFD_CG2900_TEST
+static struct cg2900_platform_data cg2900_test_platform_data = {
+	.bus = HCI_VIRTUAL,
+	.gpio_sleep = cg2900_sleep_gpio,
+};
+
+static struct platform_device ux500_cg2900_test_device = {
+	.name = "cg2900-test",
+	.dev = {
+		.parent = &ux500_cg2900_device.dev,
+		.platform_data = &cg2900_test_platform_data,
+	},
+};
+#endif /* CONFIG_MFD_CG2900_TEST */
+
+#ifdef CONFIG_MFD_CG2900_UART
+static struct resource cg2900_uart_resources[] = {
+	{
+		.start = CG2900_GBF_ENA_RESET_GPIO,
+		.end = CG2900_GBF_ENA_RESET_GPIO,
+		.flags = IORESOURCE_IO,
+		.name = "gbf_ena_reset",
+	},
+	{
+		.start = CG2900_BT_ENABLE_GPIO,
+		.end = CG2900_BT_ENABLE_GPIO,
+		.flags = IORESOURCE_IO,
+		.name = "bt_enable",
+	},
+	{
+		.start = NOMADIK_GPIO_TO_IRQ(CG2900_BT_CTS_GPIO),
+		.end = NOMADIK_GPIO_TO_IRQ(CG2900_BT_CTS_GPIO),
+		.flags = IORESOURCE_IRQ,
+		.name = "cts_irq",
+	},
+};
+
+static pin_cfg_t cg2900_uart_enabled[] = {
+	GPIO0_U0_CTSn   | PIN_INPUT_PULLUP,
+	GPIO1_U0_RTSn   | PIN_OUTPUT_HIGH,
+	GPIO2_U0_RXD    | PIN_INPUT_PULLUP,
+	GPIO3_U0_TXD    | PIN_OUTPUT_HIGH
+};
+
+static pin_cfg_t cg2900_uart_disabled[] = {
+	GPIO0_GPIO   | PIN_INPUT_PULLUP,	/* CTS pull up. */
+	GPIO1_GPIO   | PIN_OUTPUT_HIGH,		/* RTS high-flow off. */
+	GPIO2_GPIO   | PIN_INPUT_PULLUP,	/* RX pull down. */
+	GPIO3_GPIO   | PIN_OUTPUT_LOW		/* TX low - break on. */
+};
+
+static struct cg2900_platform_data cg2900_uart_platform_data = {
+	.bus = HCI_UART,
+	.gpio_sleep = cg2900_sleep_gpio,
+	.uart = {
+		.n_uart_gpios = 4,
+		.uart_enabled = cg2900_uart_enabled,
+		.uart_disabled = cg2900_uart_disabled,
+	},
+};
+
+static struct platform_device ux500_cg2900_uart_device = {
+	.name = "cg2900-uart",
+	.dev = {
+		.platform_data = &cg2900_uart_platform_data,
+		.parent = &ux500_cg2900_device.dev,
+	},
+	.num_resources = ARRAY_SIZE(cg2900_uart_resources),
+	.resource = cg2900_uart_resources,
+};
+#endif /* CONFIG_MFD_CG2900_UART */
+#endif /* CONFIG_MFD_CG2900 */
+
 /*
  * TC35892
  */
@@ -446,6 +575,29 @@ static void __init u8500_init_machine(void)
 	ux500_ske_keypad_device.dev.platform_data = &ske_keypad_board;
 	platform_add_devices(platform_devs, ARRAY_SIZE(platform_devs));
 
+#ifdef CONFIG_MFD_CG2900
+#ifdef CONFIG_MFD_CG2900_TEST
+	dcg2900_init_platdata(&cg2900_test_platform_data);
+#endif /* CONFIG_MFD_CG2900_TEST */
+#ifdef CONFIG_MFD_CG2900_UART
+	dcg2900_init_platdata(&cg2900_uart_platform_data);
+#endif /* CONFIG_MFD_CG2900_UART */
+
+	platform_device_register(&ux500_cg2900_device);
+#ifdef CONFIG_MFD_CG2900_UART
+	platform_device_register(&ux500_cg2900_uart_device);
+#endif /* CONFIG_MFD_CG2900_UART */
+#ifdef CONFIG_MFD_CG2900_TEST
+	platform_device_register(&ux500_cg2900_test_device);
+#endif /* CONFIG_MFD_CG2900_TEST */
+#ifdef CONFIG_MFD_CG2900_CHIP
+	platform_device_register(&ux500_cg2900_chip_device);
+#endif /* CONFIG_MFD_CG2900_CHIP */
+#ifdef CONFIG_MFD_STLC2690_CHIP
+	platform_device_register(&ux500_stlc2690_chip_device);
+#endif /* CONFIG_MFD_STLC2690_CHIP */
+#endif /* CONFIG_MFD_CG2900 */
+
 	mop500_i2c_init();
 	mop500_sdi_init();
 	mop500_spi_init();
diff --git a/arch/arm/mach-ux500/devices-cg2900.c b/arch/arm/mach-ux500/devices-cg2900.c
new file mode 100644
index 0000000..4dcef97
--- /dev/null
+++ b/arch/arm/mach-ux500/devices-cg2900.c
@@ -0,0 +1,313 @@
+/*
+ * arch/arm/mach-ux500/devices-cg2900.c
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Board specific device support for the Linux Bluetooth HCI H:4 Driver
+ * for ST-Ericsson connectivity controller.
+ */
+#define NAME			"devices-cg2900"
+#define pr_fmt(fmt)		NAME ": " fmt "\n"
+
+#include <asm/byteorder.h>
+#include <asm-generic/errno-base.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/skbuff.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/mfd/cg2900.h>
+#include <plat/pincfg.h>
+
+#ifdef CONFIG_MFD_CG2900
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
+struct dcg2900_info {
+	int	gbf_gpio;
+	int	bt_gpio;
+	bool	sleep_gpio_set;
+	u8	gpio_0_7_pull_up;
+	u8	gpio_8_15_pull_up;
+	u8	gpio_16_20_pull_up;
+	u8	gpio_0_7_pull_down;
+	u8	gpio_8_15_pull_down;
+	u8	gpio_16_20_pull_down;
+};
+
+static void dcg2900_enable_chip(struct cg2900_chip_dev *dev)
+{
+	struct dcg2900_info *info = dev->b_data;
+
+	gpio_set_value(info->gbf_gpio, 1);
+}
+
+static void dcg2900_disable_chip(struct cg2900_chip_dev *dev)
+{
+	struct dcg2900_info *info = dev->b_data;
+
+	gpio_set_value(info->gbf_gpio, 0);
+}
+
+static struct sk_buff *dcg2900_get_power_switch_off_cmd
+				(struct cg2900_chip_dev *dev, u16 *op_code)
+{
+	struct sk_buff *skb;
+	struct vs_power_sw_off_cmd *cmd;
+	struct dcg2900_info *info;
+	int i;
+
+	/* If connected chip does not support the command return NULL */
+	if (CG2900_PG1_SPECIAL_HCI_REV != dev->chip.hci_revision &&
+	    CG2900_PG1_HCI_REV != dev->chip.hci_revision &&
+	    CG2900_PG2_HCI_REV != dev->chip.hci_revision)
+		return NULL;
+
+	dev_dbg(dev->dev, "Generating PowerSwitchOff command\n");
+
+	info = dev->b_data;
+
+	skb = alloc_skb(sizeof(*cmd) + H4_HEADER_LENGTH, GFP_KERNEL);
+	if (!skb) {
+		dev_err(dev->dev, "Could not allocate skb\n");
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
+	if (!info->sleep_gpio_set) {
+		struct cg2900_platform_data *pf_data;
+
+		pf_data = dev_get_platdata(dev->dev);
+		for (i = 0; i < 8; i++) {
+			if (pf_data->gpio_sleep[i] == CG2900_PULL_UP)
+				info->gpio_0_7_pull_up |= (1 << i);
+			else if (pf_data->gpio_sleep[i] == CG2900_PULL_DN)
+				info->gpio_0_7_pull_down |= (1 << i);
+		}
+		for (i = 8; i < 16; i++) {
+			if (pf_data->gpio_sleep[i] == CG2900_PULL_UP)
+				info->gpio_8_15_pull_up |= (1 << (i - 8));
+			else if (pf_data->gpio_sleep[i] == CG2900_PULL_DN)
+				info->gpio_8_15_pull_down |= (1 << (i - 8));
+		}
+		for (i = 16; i < 21; i++) {
+			if (pf_data->gpio_sleep[i] == CG2900_PULL_UP)
+				info->gpio_16_20_pull_up |= (1 << (i - 16));
+			else if (pf_data->gpio_sleep[i] == CG2900_PULL_DN)
+				info->gpio_16_20_pull_down |= (1 << (i - 16));
+		}
+		info->sleep_gpio_set = true;
+	}
+	cmd->gpio_0_7_pull_up = info->gpio_0_7_pull_up;
+	cmd->gpio_8_15_pull_up = info->gpio_8_15_pull_up;
+	cmd->gpio_16_20_pull_up = info->gpio_16_20_pull_up;
+	cmd->gpio_0_7_pull_down = info->gpio_0_7_pull_down;
+	cmd->gpio_8_15_pull_down = info->gpio_8_15_pull_down;
+	cmd->gpio_16_20_pull_down = info->gpio_16_20_pull_down;
+
+
+	if (op_code)
+		*op_code = BT_VS_POWER_SWITCH_OFF;
+
+	return skb;
+}
+
+static int dcg2900_init(struct cg2900_chip_dev *dev)
+{
+	int err = 0;
+	struct dcg2900_info *info;
+	struct resource *resource;
+	const char *gbf_name;
+	const char *bt_name = NULL;
+
+	/* First retrieve and save the resources */
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		dev_err(dev->dev, "Could not allocate dcg2900_info\n");
+		return -ENOMEM;
+	}
+
+	if (!dev->pdev->num_resources) {
+		dev_dbg(dev->dev, "No resources available\n");
+		info->gbf_gpio = -1;
+		info->bt_gpio = -1;
+		goto finished;
+	}
+
+	resource = platform_get_resource(dev->pdev, IORESOURCE_IO, 0);
+	if (!resource) {
+		dev_err(dev->dev, "GBF GPIO does not exist\n");
+		err = -EINVAL;
+		goto err_handling;
+	}
+	info->gbf_gpio = resource->start;
+	gbf_name = resource->name;
+
+	resource = platform_get_resource(dev->pdev, IORESOURCE_IO, 1);
+	/* BT Enable GPIO may not exist */
+	if (resource) {
+		info->bt_gpio = resource->start;
+		bt_name = resource->name;
+	}
+
+	/* Now setup the GPIOs */
+	err = gpio_request(info->gbf_gpio, gbf_name);
+	if (err < 0) {
+		dev_err(dev->dev, "gpio_request failed with err: %d\n", err);
+		goto err_handling;
+	}
+
+	err = gpio_direction_output(info->gbf_gpio, 0);
+	if (err < 0) {
+		dev_err(dev->dev, "gpio_direction_output failed with err: %d\n",
+			err);
+		goto err_handling_free_gpio_gbf;
+	}
+
+	if (!bt_name) {
+		info->bt_gpio = -1;
+		goto finished;
+	}
+
+	err = gpio_request(info->bt_gpio, bt_name);
+	if (err < 0) {
+		dev_err(dev->dev, "gpio_request failed with err: %d\n", err);
+		goto err_handling_free_gpio_gbf;
+	}
+
+	err = gpio_direction_output(info->bt_gpio, 1);
+	if (err < 0) {
+		dev_err(dev->dev, "gpio_direction_output failed with err: %d\n",
+			err);
+		goto err_handling_free_gpio_bt;
+	}
+
+finished:
+	dev->b_data = info;
+	return 0;
+
+err_handling_free_gpio_bt:
+	gpio_free(info->bt_gpio);
+err_handling_free_gpio_gbf:
+	gpio_free(info->gbf_gpio);
+err_handling:
+	kfree(info);
+	return err;
+}
+
+static void dcg2900_exit(struct cg2900_chip_dev *dev)
+{
+	struct dcg2900_info *info = dev->b_data;
+
+	dcg2900_disable_chip(dev);
+	if (info->bt_gpio != -1)
+		gpio_free(info->bt_gpio);
+	if (info->gbf_gpio != -1)
+		gpio_free(info->gbf_gpio);
+	kfree(info);
+	dev->b_data = NULL;
+}
+
+#ifdef CONFIG_MFD_CG2900_UART
+static int dcg2900_disable_uart(struct cg2900_chip_dev *dev)
+{
+	int err;
+	struct cg2900_platform_data *pdata = dev_get_platdata(dev->dev);
+
+	/*
+	 * Without this delay we get interrupt on CTS immediately
+	 * due to some turbulences on this line.
+	 */
+	mdelay(4);
+
+	/* Disable UART functions. */
+	err = nmk_config_pins(pdata->uart.uart_disabled,
+			      pdata->uart.n_uart_gpios);
+	if (err)
+		goto error;
+
+	return 0;
+
+error:
+	(void)nmk_config_pins(pdata->uart.uart_enabled,
+			      pdata->uart.n_uart_gpios);
+	dev_err(dev->dev, "Cannot set interrupt (%d)\n", err);
+	return err;
+}
+
+static int dcg2900_enable_uart(struct cg2900_chip_dev *dev)
+{
+	int err;
+	struct cg2900_platform_data *pdata = dev_get_platdata(dev->dev);
+
+	/* Restore UART settings. */
+	err = nmk_config_pins(pdata->uart.uart_enabled,
+			      pdata->uart.n_uart_gpios);
+	if (err)
+		dev_err(dev->dev, "Unable to enable UART (%d)\n", err);
+
+	return err;
+}
+#endif /* CONFIG_MFD_CG2900_UART */
+
+void dcg2900_init_platdata(struct cg2900_platform_data *data)
+{
+	data->init = dcg2900_init;
+	data->exit = dcg2900_exit;
+	data->enable_chip = dcg2900_enable_chip;
+	data->disable_chip = dcg2900_disable_chip;
+	data->get_power_switch_off_cmd = dcg2900_get_power_switch_off_cmd;
+#ifdef CONFIG_MFD_CG2900_UART
+	data->uart.enable_uart = dcg2900_enable_uart;
+	data->uart.disable_uart = dcg2900_disable_uart;
+#endif /* CONFIG_MFD_CG2900_UART */
+}
+#endif /* CONFIG_MFD_CG2900 */
diff --git a/arch/arm/mach-ux500/devices-cg2900.h b/arch/arm/mach-ux500/devices-cg2900.h
new file mode 100644
index 0000000..958b750
--- /dev/null
+++ b/arch/arm/mach-ux500/devices-cg2900.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * Author: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
+ * License terms: GNU General Public License (GPL), version 2.
+ */
+
+#ifndef __DEVICES_CG2900_H
+#define __DEVICES_CG2900_H
+
+#include <linux/mfd/cg2900.h>
+
+/**
+ * dcg2900_init_platdata() - Initializes platform data with callback functions.
+ * @data:	Platform data.
+ */
+extern void dcg2900_init_platdata(struct cg2900_platform_data *data);
+
+#endif /* __DEVICES_CG2900_H */
-- 
1.7.3.2

