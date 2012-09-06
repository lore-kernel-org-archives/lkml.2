Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212Ab2IFE11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 00:27:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65359 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2IFE1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 00:27:25 -0400
Message-ID: <1346905640.2573.14.camel@taehun-desktop>
Subject: [PATCH v3] ARM: S3C24XX: Add WIZnet W5300E01-ARM board support
From: Taehun Kim <kth3321@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 06 Sep 2012 13:27:20 +0900
In-Reply-To: <1346653236-19728-1-git-send-email-kth3321@gmail.com>
References: <1346653236-19728-1-git-send-email-kth3321@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- The gpio routines are changed to use the gpio_request() functions from
  comments of Vasily and Sylwester.
- The mistake of adding a character by my email client automatically is fixed.

Please review this patch and apply it if do not have any problems.

Signed-off-by: Taehun Kim <kth3321@gmail.com>
---
 arch/arm/mach-s3c24xx/Kconfig         |    5 +
 arch/arm/mach-s3c24xx/Makefile        |    1 +
 arch/arm/mach-s3c24xx/mach-w5300e01.c |  193 +++++++++++++++++++++++++++++++++
 3 files changed, 199 insertions(+)
 create mode 100644 arch/arm/mach-s3c24xx/mach-w5300e01.c

diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
index d56b0f7..94b60ca 100644
--- a/arch/arm/mach-s3c24xx/Kconfig
+++ b/arch/arm/mach-s3c24xx/Kconfig
@@ -248,6 +248,11 @@ config MACH_VR1000
 	help
 	  Say Y here if you are using the Thorcom VR1000 board.
 
+config MACH_W5300E01
+	bool "WIZnet W5300E01-ARM Board"
+	help
+	  Say Y here if you are using the Wiznet W5300E01-ARM board.
+
 endif	# CPU_S3C2410
 
 config S3C2412_PM_SLEEP
diff --git a/arch/arm/mach-s3c24xx/Makefile b/arch/arm/mach-s3c24xx/Makefile
index 0ab6ab1..fc1a89e 100644
--- a/arch/arm/mach-s3c24xx/Makefile
+++ b/arch/arm/mach-s3c24xx/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_MACH_QT2410)		+= mach-qt2410.o
 obj-$(CONFIG_ARCH_SMDK2410)		+= mach-smdk2410.o
 obj-$(CONFIG_MACH_TCT_HAMMER)		+= mach-tct_hammer.o
 obj-$(CONFIG_MACH_VR1000)		+= mach-vr1000.o
+obj-$(CONFIG_MACH_W5300E01)		+= mach-w5300e01.o
 
 obj-$(CONFIG_MACH_JIVE)			+= mach-jive.o
 obj-$(CONFIG_MACH_SMDK2413)		+= mach-smdk2413.o
diff --git a/arch/arm/mach-s3c24xx/mach-w5300e01.c b/arch/arm/mach-s3c24xx/mach-w5300e01.c
new file mode 100644
index 0000000..ab648e5
--- /dev/null
+++ b/arch/arm/mach-s3c24xx/mach-w5300e01.c
@@ -0,0 +1,193 @@
+/* linux/arch/arm/mach-s3c24xx/mach-w5300e01.c
+ *
+ * Copyright (c) 2012 Taehun Kim <kth3321@gmail.com>
+ *
+ * For product information, visit http://www.wiznet.co.kr/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * @History:
+ * derived from linux/arch/arm/mach-s3c24xx/mach-bast.c, written by
+ * Ben Dooks <ben@simtec.co.uk>
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/timer.h>
+#include <linux/init.h>
+#include <linux/serial_core.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/io.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/nand.h>
+#include <linux/mtd/map.h>
+#include <linux/mtd/partitions.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+#include <asm/mach-types.h>
+
+#include <mach/regs-gpio.h>
+#include <plat/gpio-cfg.h>
+#include <plat/cpu.h>
+#include <plat/devs.h>
+#include <plat/regs-serial.h>
+#include <plat/nand.h>
+#include <plat/pm.h>
+
+static struct map_desc w5300e01_iodesc[] __initdata = {
+	/* Character LCD register map. */
+	{ 0xf8000000, __phys_to_pfn(S3C2410_CS3), SZ_1M, MT_DEVICE }
+};
+
+#define UCON S3C2410_UCON_DEFAULT
+#define ULCON (S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB)
+#define UFCON (S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE)
+
+static struct s3c2410_uartcfg w5300e01_uartcfgs[] __initdata = {
+	[0] = {
+		.hwport	= 0,
+		.flags	= 0,
+		.ucon	= UCON,
+		.ulcon	= ULCON,
+		.ufcon	= UFCON,
+	},
+	[1] = {
+		.hwport	= 1,
+		.flags	= 0,
+		.ucon	= UCON,
+		.ulcon	= ULCON,
+		.ufcon	= UFCON,
+	},
+	[2] = {
+		.hwport	= 2,
+		.flags	= 0,
+		.ucon	= UCON,
+		.ulcon	= ULCON,
+		.ufcon	= UFCON,
+	}
+};
+
+static struct mtd_partition w5300e01_mtd_partitions[] = {
+	[0] = {
+		.name		= "Bootloader",
+		.size		= 0x20000,
+		.offset		= 0,
+		.mask_flags	= MTD_WRITEABLE,
+	},
+	[1] = {
+		.name		= "Boot Param",
+		.size		= 0x20000,
+		.offset		= MTDPART_OFS_APPEND,
+	},
+	[2] = {
+		.name		= "Kernel",
+		.size		= 0x3C0000,
+		.offset		= MTDPART_OFS_APPEND,
+	},
+	[3] = {
+		.name		= "Ramdisk",
+		.size		= 0x1000000,
+		.offset		= MTDPART_OFS_APPEND,
+	},
+	[4] = {
+		.name		= "JFFS2 FileSystem",
+		.size		= MTDPART_SIZ_FULL,
+		.offset		= MTDPART_OFS_APPEND,
+	},
+};
+
+static struct resource w5300_resources[] = {
+	[0] = {
+		.start	= S3C2410_CS2,
+		.end	= S3C2410_CS2 + SZ_1M,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= IRQ_EINT0,
+		.end	= IRQ_EINT0,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device w5300_device = {
+	.name		= "w5300",
+	.num_resources	= ARRAY_SIZE(w5300_resources),
+	.resource	= w5300_resources,
+};
+
+static struct s3c2410_nand_set w5300e01_nand_sets[] = {
+	[0] = {
+		.name		= "W5300E01",
+		.nr_chips	= 1,
+		.nr_partitions	= ARRAY_SIZE(w5300e01_mtd_partitions),
+		.partitions	= w5300e01_mtd_partitions,
+	},
+};
+
+static struct s3c2410_platform_nand w5300e01_nand_info = {
+	.tacls		= 20,
+	.twrph0		= 60,
+	.twrph1		= 30,
+	.nr_sets	= ARRAY_SIZE(w5300e01_nand_sets),
+	.sets		= w5300e01_nand_sets,
+};
+
+static struct platform_device *w5300e01_devices[] __initdata = {
+	&s3c_device_nand,
+	&s3c_device_usbgadget,
+	&s3c_device_wdt,
+	&s3c_device_i2c0,
+	&s3c_device_iis,
+	&w5300_device,
+};
+
+static const struct gpio w5300e01_gpios[] = {
+	{ S3C2410_GPF(4), GPIOF_OUT_INIT_HIGH, NULL },
+	{ S3C2410_GPF(5), GPIOF_OUT_INIT_HIGH, NULL },
+	{ S3C2410_GPF(6), GPIOF_OUT_INIT_HIGH, NULL },
+	{ S3C2410_GPF(7), GPIOF_OUT_INIT_HIGH, NULL },
+};
+
+static void __init w5300e01_map_io(void)
+{
+	s3c24xx_init_io(w5300e01_iodesc, ARRAY_SIZE(w5300e01_iodesc));
+	s3c24xx_init_clocks(0);
+	s3c24xx_init_uarts(w5300e01_uartcfgs, ARRAY_SIZE(w5300e01_uartcfgs));
+}
+
+static void __init w5300_init(void)
+{
+	/* W5300 interrupt pin. */
+	if (gpio_request(S3C2410_GPF(0), "W5300 irq")) {
+		pr_err("%s: GPIO request failed.\n", __func__);
+		return;
+	}
+	s3c_gpio_cfgpin(S3C2410_GPF(0), S3C_GPIO_SFN(2)); /* EINT0 */
+}
+
+static void __init w5300e01_init(void)
+{
+	s3c_nand_set_platdata(&w5300e01_nand_info);
+	platform_add_devices(w5300e01_devices, ARRAY_SIZE(w5300e01_devices));
+
+	if (gpio_request_array(w5300e01_gpios, ARRAY_SIZE(w5300e01_gpios)))
+		pr_err("%s: GPIO request failed\n", __func__);
+
+	w5300_init();
+	s3c_pm_init();
+}
+
+MACHINE_START(W5300E01, "WIZnet W5300E01-ARM")
+	.atag_offset	= S3C2410_SDRAM_PA + 0x100,
+	.map_io		= w5300e01_map_io,
+	.init_irq	= s3c24xx_init_irq,
+	.init_machine	= w5300e01_init,
+	.timer		= &s3c24xx_timer,
+MACHINE_END
-- 
1.7.9.5



