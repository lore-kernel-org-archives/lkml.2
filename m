Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab0I2Tfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:35:36 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40058 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab0I2Tff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:35:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=en8XNhc1Y+RcAIfMIW0gC5QMa9rLQqyACV2HSm7XSB8L1ybQlpHkzJATBhTPofnYQt
         lb36zviM9NsCzV4G8lQ9+PDlDRXmEQM642ymSTI1//sd2LL2RnyS33NHNTUDGbG6+uJm
         eyVLjJIU4MZTqOtnLg9YND09e7YUBfP0T/Cs0=
Subject: [PATCH 5/9 v2] ARM: S3C64XX: add support for mach-mini6410
To: linux-arm-kernel@lists.infradead.org
From: Darius Augulis <augulis.darius@gmail.com>
Cc: kgene.kim@samsung.com, paulius.zaleckas@gmail.com,
        linux-kernel@vger.kernel.org, ben-linux@fluff.org
Date: Wed, 29 Sep 2010 22:35:32 +0300
Message-ID: <20100929193406.25307.33007.stgit@darius-desktop>
In-Reply-To: <20100929192354.25307.40197.stgit@darius-desktop>
References: <20100929192354.25307.40197.stgit@darius-desktop>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for mini6410 board from FriendlyARM

Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
---

Changelog since v1:
 - Ben's comments about coding style fixed

 arch/arm/mach-s3c64xx/Kconfig         |   10 ++
 arch/arm/mach-s3c64xx/Makefile        |    1 
 arch/arm/mach-s3c64xx/mach-mini6410.c |  157 +++++++++++++++++++++++++++++++++
 3 files changed, 168 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-s3c64xx/mach-mini6410.c

diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
index c05ae12..bbeb4ca 100644
--- a/arch/arm/mach-s3c64xx/Kconfig
+++ b/arch/arm/mach-s3c64xx/Kconfig
@@ -98,6 +98,16 @@ config MACH_ANW6410
 	help
 	  Machine support for the A&W6410
 
+config MACH_MINI6410
+	bool "MINI6410"
+	select CPU_S3C6410
+	select S3C_DEV_HSMMC
+	select S3C_DEV_HSMMC1
+	select S3C64XX_SETUP_SDHCI
+	select S3C_DEV_USB_HOST
+	help
+	  Machine support for the FriendlyARM MINI6410
+
 config MACH_REAL6410
 	bool "REAL6410"
 	select CPU_S3C6410
diff --git a/arch/arm/mach-s3c64xx/Makefile b/arch/arm/mach-s3c64xx/Makefile
index 90221a2..4657363 100644
--- a/arch/arm/mach-s3c64xx/Makefile
+++ b/arch/arm/mach-s3c64xx/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_MACH_ANW6410)	+= mach-anw6410.o
 obj-$(CONFIG_MACH_SMDK6400)	+= mach-smdk6400.o
 obj-$(CONFIG_MACH_SMDK6410)	+= mach-smdk6410.o
 obj-$(CONFIG_MACH_REAL6410)     += mach-real6410.o
+obj-$(CONFIG_MACH_MINI6410)     += mach-mini6410.o
 obj-$(CONFIG_MACH_NCP)		+= mach-ncp.o
 obj-$(CONFIG_MACH_HMT)		+= mach-hmt.o
 obj-$(CONFIG_MACH_SMARTQ)	+= mach-smartq.o
diff --git a/arch/arm/mach-s3c64xx/mach-mini6410.c b/arch/arm/mach-s3c64xx/mach-mini6410.c
new file mode 100644
index 0000000..425e65d
--- /dev/null
+++ b/arch/arm/mach-s3c64xx/mach-mini6410.c
@@ -0,0 +1,157 @@
+/* linux/arch/arm/mach-s3c64xx/mach-mini6410.c
+ *
+ * Copyright 2010 Darius Augulis <augulis.darius@gmail.com>
+ * Copyright 2008 Openmoko, Inc.
+ * Copyright 2008 Simtec Electronics
+ *	Ben Dooks <ben@simtec.co.uk>
+ *	http://armlinux.simtec.co.uk/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+*/
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/dm9000.h>
+#include <linux/serial_core.h>
+#include <linux/types.h>
+
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+
+#include <mach/map.h>
+#include <mach/regs-gpio.h>
+#include <mach/regs-srom.h>
+#include <mach/s3c6410.h>
+
+#include <plat/cpu.h>
+#include <plat/devs.h>
+#include <plat/regs-serial.h>
+
+#define UCON (S3C2410_UCON_DEFAULT | S3C2410_UCON_UCLK)
+#define ULCON (S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB)
+#define UFCON (S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE)
+
+static struct s3c2410_uartcfg mini6410_uartcfgs[] __initdata = {
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
+	},
+	[3] = {
+		.hwport	= 3,
+		.flags	= 0,
+		.ucon	= UCON,
+		.ulcon	= ULCON,
+		.ufcon	= UFCON,
+	},
+};
+
+/* DM9000AEP 10/100 ethernet controller */
+
+static struct resource mini6410_dm9k_resource[] = {
+	[0] = {
+		.start	= S3C64XX_PA_XM0CSN1,
+		.end	= S3C64XX_PA_XM0CSN1 + 1,
+		.flags	= IORESOURCE_MEM
+	},
+	[1] = {
+		.start	= S3C64XX_PA_XM0CSN1 + 4,
+		.end	= S3C64XX_PA_XM0CSN1 + 5,
+		.flags	= IORESOURCE_MEM
+	},
+	[2] = {
+		.start	= S3C_EINT(7),
+		.end	= S3C_EINT(7),
+		.flags	= IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL
+	}
+};
+
+static struct dm9000_plat_data mini6410_dm9k_pdata = {
+	.flags		= (DM9000_PLATF_16BITONLY | DM9000_PLATF_NO_EEPROM),
+};
+
+static struct platform_device mini6410_device_eth = {
+	.name		= "dm9000",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(mini6410_dm9k_resource),
+	.resource	= mini6410_dm9k_resource,
+	.dev		= {
+		.platform_data	= &mini6410_dm9k_pdata,
+	},
+};
+
+static struct platform_device *mini6410_devices[] __initdata = {
+	&mini6410_device_eth,
+	&s3c_device_hsmmc0,
+	&s3c_device_hsmmc1,
+	&s3c_device_ohci,
+};
+
+static void __init mini6410_map_io(void)
+{
+	s3c64xx_init_io(NULL, 0);
+	s3c24xx_init_clocks(12000000);
+	s3c24xx_init_uarts(mini6410_uartcfgs, ARRAY_SIZE(mini6410_uartcfgs));
+}
+
+static void __init mini6410_machine_init(void)
+{
+	u32 cs1;
+
+	/* configure nCS1 width to 16 bits */
+
+	cs1 = __raw_readl(S3C64XX_SROM_BW) &
+		~(S3C64XX_SROM_BW__CS_MASK << S3C64XX_SROM_BW__NCS1__SHIFT);
+	cs1 |= ((1 << S3C64XX_SROM_BW__DATAWIDTH__SHIFT) |
+		(1 << S3C64XX_SROM_BW__WAITENABLE__SHIFT) |
+		(1 << S3C64XX_SROM_BW__BYTEENABLE__SHIFT)) <<
+			S3C64XX_SROM_BW__NCS1__SHIFT;
+	__raw_writel(cs1, S3C64XX_SROM_BW);
+
+	/* set timing for nCS1 suitable for ethernet chip */
+
+	__raw_writel((0 << S3C64XX_SROM_BCX__PMC__SHIFT) |
+		(6 << S3C64XX_SROM_BCX__TACP__SHIFT) |
+		(4 << S3C64XX_SROM_BCX__TCAH__SHIFT) |
+		(1 << S3C64XX_SROM_BCX__TCOH__SHIFT) |
+		(13 << S3C64XX_SROM_BCX__TACC__SHIFT) |
+		(4 << S3C64XX_SROM_BCX__TCOS__SHIFT) |
+		(0 << S3C64XX_SROM_BCX__TACS__SHIFT), S3C64XX_SROM_BC1);
+
+	platform_add_devices(mini6410_devices, ARRAY_SIZE(mini6410_devices));
+}
+
+MACHINE_START(MINI6410, "MINI6410")
+	/* Maintainer: Darius Augulis <augulis.darius@gmail.com> */
+	.phys_io	= S3C_PA_UART & 0xfff00000,
+	.io_pg_offst	= (((u32)S3C_VA_UART) >> 18) & 0xfffc,
+	.boot_params	= S3C64XX_PA_SDRAM + 0x100,
+
+	.init_irq	= s3c6410_init_irq,
+	.map_io		= mini6410_map_io,
+	.init_machine	= mini6410_machine_init,
+	.timer		= &s3c24xx_timer,
+MACHINE_END

