Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab0EJUIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 16:08:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40225 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab0EJUIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 16:08:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iKL2pu3stOVkJlOtB5f2Tg2qJhAT0hrvIeGU34AYyyQXzli76HS77ikW/h2j6IrRYE
         7mujk4ms5BJgdpZJjLRycSu8UMxNANU9Gk03/HgtZK4U5MP/AwZAYXxLbW3mTxHVAzO9
         qIF2PDbUuWaFzmwHYZQhh9FWmbboPuTTQSVNM=
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
To: paulius.zaleckas@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux@arm.linux.org.uk, Imre Kaloz <kaloz@openwrt.org>,
       Hans Ulli Kroll <ulli.kroll@googlemail.com>
Subject: [PATCH 1/4] ARM: Gemini: add support for Wiligear WBD-111
Date: Mon, 10 May 2010 22:06:58 +0200
Message-Id: <1273522021-14436-2-git-send-email-ulli.kroll@googlemail.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1273522021-14436-1-git-send-email-ulli.kroll@googlemail.com>
References: <1273522021-14436-1-git-send-email-ulli.kroll@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Imre Kaloz <kaloz@openwrt.org>

Signed-off-by: Hans Ulli Kroll <ulli.kroll@googlemail.com>
---
 arch/arm/mach-gemini/Kconfig        |    7 ++
 arch/arm/mach-gemini/Makefile       |    1 +
 arch/arm/mach-gemini/board-wbd111.c |  143 +++++++++++++++++++++++++++++++++++
 3 files changed, 151 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-gemini/board-wbd111.c

diff --git a/arch/arm/mach-gemini/Kconfig b/arch/arm/mach-gemini/Kconfig
index 515b75c..4de67ce 100644
--- a/arch/arm/mach-gemini/Kconfig
+++ b/arch/arm/mach-gemini/Kconfig
@@ -9,6 +9,13 @@ config MACH_RUT100
 	  Say Y here if you intend to run this kernel on a
 	  Teltonika 3G Router RUT100.
 
+config MACH_WBD111
+	bool "Wiliboard WBD-111"
+	select GEMINI_MEM_SWAP
+	help
+	  Say Y here if you intend to run this kernel on a
+	  Wiliboard WBD-111.
+
 endmenu
 
 config GEMINI_MEM_SWAP
diff --git a/arch/arm/mach-gemini/Makefile b/arch/arm/mach-gemini/Makefile
index 719505b..3997487 100644
--- a/arch/arm/mach-gemini/Makefile
+++ b/arch/arm/mach-gemini/Makefile
@@ -8,3 +8,4 @@ obj-y			:= irq.o mm.o time.o devices.o gpio.o
 
 # Board-specific support
 obj-$(CONFIG_MACH_RUT100)	+= board-rut1xx.o
+obj-$(CONFIG_MACH_WBD111)	+= board-wbd111.o
diff --git a/arch/arm/mach-gemini/board-wbd111.c b/arch/arm/mach-gemini/board-wbd111.c
new file mode 100644
index 0000000..36538c1
--- /dev/null
+++ b/arch/arm/mach-gemini/board-wbd111.c
@@ -0,0 +1,143 @@
+/*
+ *  Support for Wiliboard WBD-111
+ *
+ *  Copyright (C) 2009 Imre Kaloz <kaloz@openwrt.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+#include <linux/input.h>
+#include <linux/skbuff.h>
+#include <linux/gpio_keys.h>
+#include <linux/mdio-gpio.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/time.h>
+
+
+#include "common.h"
+
+static struct gpio_keys_button wbd111_keys[] = {
+	{
+		.code		= KEY_SETUP,
+		.gpio		= 5,
+		.active_low	= 1,
+		.desc		= "reset",
+		.type		= EV_KEY,
+	},
+};
+
+static struct gpio_keys_platform_data wbd111_keys_data = {
+	.buttons	= wbd111_keys,
+	.nbuttons	= ARRAY_SIZE(wbd111_keys),
+};
+
+static struct platform_device wbd111_keys_device = {
+	.name	= "gpio-keys",
+	.id	= -1,
+	.dev	= {
+		.platform_data = &wbd111_keys_data,
+	},
+};
+
+static struct gpio_led wbd111_leds[] = {
+	{
+		.name			= "L3red",
+		.gpio			= 1,
+	},
+	{
+		.name			= "L4green",
+		.gpio			= 2,
+	},
+	{
+		.name			= "L4red",
+		.gpio			= 3,
+	},
+	{
+		.name			= "L3green",
+		.gpio			= 5,
+	},
+};
+
+static struct gpio_led_platform_data wbd111_leds_data = {
+	.num_leds	= ARRAY_SIZE(wbd111_leds),
+	.leds		= wbd111_leds,
+};
+
+static struct platform_device wbd111_leds_device = {
+	.name	= "leds-gpio",
+	.id	= -1,
+	.dev	= {
+		.platform_data = &wbd111_leds_data,
+	},
+};
+
+static struct sys_timer wbd111_timer = {
+	.init	= gemini_timer_init,
+};
+
+#ifdef CONFIG_MTD_PARTITIONS
+static struct mtd_partition wbd111_partitions[] = {
+	{
+		.name		= "RedBoot",
+		.offset		= 0,
+		.size		= 0x020000,
+		.mask_flags	= MTD_WRITEABLE,
+	} , {
+		.name		= "kernel",
+		.offset		= 0x020000,
+		.size		= 0x100000,
+	} , {
+		.name		= "rootfs",
+		.offset		= 0x120000,
+		.size		= 0x6a0000,
+	} , {
+		.name		= "VCTL",
+		.offset		= 0x7c0000,
+		.size		= 0x010000,
+		.mask_flags	= MTD_WRITEABLE,
+	} , {
+		.name		= "cfg",
+		.offset		= 0x7d0000,
+		.size		= 0x010000,
+		.mask_flags	= MTD_WRITEABLE,
+	} , {
+		.name		= "FIS",
+		.offset		= 0x7e0000,
+		.size		= 0x010000,
+		.mask_flags	= MTD_WRITEABLE,
+	}
+};
+#define wbd111_num_partitions	ARRAY_SIZE(wbd111_partitions)
+#else
+#define wbd111_partitions	NULL
+#define wbd111_num_partitions	0
+#endif /* CONFIG_MTD_PARTITIONS */
+
+static void __init wbd111_init(void)
+{
+	gemini_gpio_init();
+	platform_register_uart();
+	platform_register_pflash(SZ_8M, wbd111_partitions,
+				 wbd111_num_partitions);
+	platform_device_register(&wbd111_leds_device);
+	platform_device_register(&wbd111_keys_device);
+}
+
+MACHINE_START(WBD111, "Wiliboard WBD-111")
+	.phys_io	= 0x7fffc000,
+	.io_pg_offst	= ((0xffffc000) >> 18) & 0xfffc,
+	.boot_params	= 0x100,
+	.map_io		= gemini_map_io,
+	.init_irq	= gemini_init_irq,
+	.timer		= &wbd111_timer,
+	.init_machine	= wbd111_init,
+MACHINE_END
-- 
1.7.0.3

