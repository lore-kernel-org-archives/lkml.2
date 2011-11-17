Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab1KQODY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 09:03:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45372 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022Ab1KQODW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 09:03:22 -0500
From: Rene Bolldorf <xsecute@googlemail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Rene Bolldorf <xsecute@googlemail.com>
Subject: =?UTF-8?q?=5BPATCH=202/2=5D=20Initial=20support=20for=20the=20Ubiquiti=20Networks=20XM=20board=20=28rev=201=2E0=29=2E=20=28patch=20v2=29?=
Date: Thu, 17 Nov 2011 15:02:57 +0100
Message-Id: <1321538577-548-3-git-send-email-xsecute@googlemail.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321538577-548-1-git-send-email-xsecute@googlemail.com>
References: <CAEWqx59k97AMU6hH0NCC2TMEY2mu8d5ytxO68oEsa=7uvLBA4A@mail.gmail.com>
 <1321538577-548-1-git-send-email-xsecute@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rene Bolldorf <xsecute@googlemail.com>
---
 arch/mips/ath79/Kconfig        |   11 ++++
 arch/mips/ath79/Makefile       |    1 +
 arch/mips/ath79/mach-ubnt-xm.c |  119 ++++++++++++++++++++++++++++++++++++++++
 arch/mips/ath79/machtypes.h    |    1 +
 4 files changed, 132 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/ath79/mach-ubnt-xm.c

diff --git a/arch/mips/ath79/Kconfig b/arch/mips/ath79/Kconfig
index 4770741..1a35258 100644
--- a/arch/mips/ath79/Kconfig
+++ b/arch/mips/ath79/Kconfig
@@ -23,6 +23,16 @@ config ATH79_MACH_PB44
 	  Say 'Y' here if you want your kernel to support the
 	  Atheros PB44 reference board.
 
+config ATH79_MACH_UBNT_XM
+	bool "Ubiquiti Networks XM (rev 1.0) board"
+	select SOC_AR724X
+	select ATH79_DEV_GPIO_BUTTONS
+	select ATH79_DEV_LEDS_GPIO
+	select ATH79_DEV_SPI
+	help
+	  Say 'Y' here if you want your kernel to support the
+	  Ubiquiti Networks XM (rev 1.0) board.
+
 endmenu
 
 config SOC_AR71XX
@@ -33,6 +43,7 @@ config SOC_AR71XX
 config SOC_AR724X
 	select USB_ARCH_HAS_EHCI
 	select USB_ARCH_HAS_OHCI
+	select HW_HAS_PCI
 	def_bool n
 
 config SOC_AR913X
diff --git a/arch/mips/ath79/Makefile b/arch/mips/ath79/Makefile
index c33d465..ac9f375 100644
--- a/arch/mips/ath79/Makefile
+++ b/arch/mips/ath79/Makefile
@@ -26,3 +26,4 @@ obj-$(CONFIG_ATH79_DEV_SPI)		+= dev-spi.o
 #
 obj-$(CONFIG_ATH79_MACH_AP81)		+= mach-ap81.o
 obj-$(CONFIG_ATH79_MACH_PB44)		+= mach-pb44.o
+obj-$(CONFIG_ATH79_MACH_UBNT_XM)	+= mach-ubnt-xm.o
diff --git a/arch/mips/ath79/mach-ubnt-xm.c b/arch/mips/ath79/mach-ubnt-xm.c
new file mode 100644
index 0000000..3c311a5
--- /dev/null
+++ b/arch/mips/ath79/mach-ubnt-xm.c
@@ -0,0 +1,119 @@
+/*
+ *  Ubiquiti Networks XM (rev 1.0) board support
+ *
+ *  Copyright (C) 2011 René Bolldorf <xsecute@googlemail.com>
+ *
+ *  Derived from: mach-pb44.c
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms of the GNU General Public License version 2 as published
+ *  by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/pci.h>
+
+#ifdef CONFIG_PCI
+#include <linux/ath9k_platform.h>
+#include <asm/mach-ath79/pci-ath724x.h>
+#endif /* CONFIG_PCI */
+
+#include "machtypes.h"
+#include "dev-gpio-buttons.h"
+#include "dev-leds-gpio.h"
+#include "dev-spi.h"
+
+#define UBNT_XM_GPIO_LED_L1		0
+#define UBNT_XM_GPIO_LED_L2		1
+#define UBNT_XM_GPIO_LED_L3		11
+#define UBNT_XM_GPIO_LED_L4		7
+
+#define UBNT_XM_GPIO_BTN_RESET		12
+
+#define UBNT_XM_KEYS_POLL_INTERVAL	20
+#define UBNT_XM_KEYS_DEBOUNCE_INTERVAL	(3 * UBNT_XM_KEYS_POLL_INTERVAL)
+
+#define UBNT_XM_PCI_IRQ			48
+#define UBNT_XM_EEPROM_ADDR		(u8 *) KSEG1ADDR(0x1fff1000)
+
+static struct gpio_led ubnt_xm_leds_gpio[] __initdata = {
+	{
+		.name		= "ubnt-xm:red:link1",
+		.gpio		= UBNT_XM_GPIO_LED_L1,
+		.active_low	= 0,
+	}, {
+		.name		= "ubnt-xm:orange:link2",
+		.gpio		= UBNT_XM_GPIO_LED_L2,
+		.active_low	= 0,
+	}, {
+		.name		= "ubnt-xm:green:link3",
+		.gpio		= UBNT_XM_GPIO_LED_L3,
+		.active_low	= 0,
+	}, {
+		.name		= "ubnt-xm:green:link4",
+		.gpio		= UBNT_XM_GPIO_LED_L4,
+		.active_low	= 0,
+	},
+};
+
+static struct gpio_keys_button ubnt_xm_gpio_keys[] __initdata = {
+	{
+		.desc			= "reset",
+		.type			= EV_KEY,
+		.code			= KEY_RESTART,
+		.debounce_interval	= UBNT_XM_KEYS_DEBOUNCE_INTERVAL,
+		.gpio			= UBNT_XM_GPIO_BTN_RESET,
+		.active_low		= 1,
+	}
+};
+
+static struct spi_board_info ubnt_xm_spi_info[] = {
+	{
+		.bus_num	= 0,
+		.chip_select	= 0,
+		.max_speed_hz	= 25000000,
+		.modalias	= "mx25l6405d",
+	}
+};
+
+static struct ath79_spi_platform_data ubnt_xm_spi_data = {
+	.bus_num		= 0,
+	.num_chipselect		= 1,
+};
+
+#ifdef CONFIG_PCI
+static struct ath9k_platform_data ubnt_xm_eeprom_data;
+
+static struct ath724x_pci_data ubnt_xm_pci_data[] = {
+	{
+		.irq	= UBNT_XM_PCI_IRQ,
+		.pdata	= &ubnt_xm_eeprom_data,
+	},
+};
+#endif /* CONFIG_PCI */
+
+static void __init ubnt_xm_init(void)
+{
+	ath79_register_leds_gpio(-1, ARRAY_SIZE(ubnt_xm_leds_gpio),
+				 ubnt_xm_leds_gpio);
+
+	ath79_register_gpio_keys_polled(-1, UBNT_XM_KEYS_POLL_INTERVAL,
+					ARRAY_SIZE(ubnt_xm_gpio_keys),
+					ubnt_xm_gpio_keys);
+
+	ath79_register_spi(&ubnt_xm_spi_data, ubnt_xm_spi_info,
+			   ARRAY_SIZE(ubnt_xm_spi_info));
+
+#ifdef CONFIG_PCI
+	memcpy(ubnt_xm_eeprom_data.eeprom_data, UBNT_XM_EEPROM_ADDR,
+	       sizeof(ubnt_xm_eeprom_data.eeprom_data));
+
+	ath724x_pci_add_data(ubnt_xm_pci_data, ARRAY_SIZE(ubnt_xm_pci_data));
+#endif /* CONFIG_PCI */
+
+}
+
+MIPS_MACHINE(ATH79_MACH_UBNT_XM,
+	     "UBNT-XM",
+	     "Ubiquiti Networks XM (rev 1.0) board",
+	     ubnt_xm_init);
diff --git a/arch/mips/ath79/machtypes.h b/arch/mips/ath79/machtypes.h
index 3940fe4..35d5d5c 100644
--- a/arch/mips/ath79/machtypes.h
+++ b/arch/mips/ath79/machtypes.h
@@ -18,6 +18,7 @@ enum ath79_mach_type {
 	ATH79_MACH_GENERIC = 0,
 	ATH79_MACH_AP81,		/* Atheros AP81 reference board */
 	ATH79_MACH_PB44,		/* Atheros PB44 reference board */
+	ATH79_MACH_UBNT_XM,		/* Ubiquiti Networks XM board rev 1.0 */
 };
 
 #endif /* _ATH79_MACHTYPE_H */
-- 
1.7.7.1

