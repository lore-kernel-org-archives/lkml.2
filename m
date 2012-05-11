Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946178Ab2EKTll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:41:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57381 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946166Ab2EKTlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:41:35 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: horms@verge.net.au, linux@arm.linux.org.uk, arnd@arndb.de,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        lethal@linux-sh.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Date: Sat, 12 May 2012 04:42:31 +0900
Message-Id: <20120511194231.6567.67186.sendpatchset@w520>
In-Reply-To: <20120511194151.6567.53888.sendpatchset@w520>
References: <20120511194151.6567.53888.sendpatchset@w520>
Subject: [PATCH 04/06] mach-shmobile: Emma Mobile EV2 GPIO support V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Tie in the Emma Mobile GPIO driver "em-gio" to
support the GPIOs on Emma Mobile EV2.

A static IRQ range is used to allow boards to
hook up their platform devices to the GPIOs.

DT support is still on the TODO for the GPIO driver,
so only platform device support is included here.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Changes since V1:
 - none, this is the first public release

 arch/arm/mach-shmobile/Kconfig              |    1 
 arch/arm/mach-shmobile/include/mach/emev2.h |    3 
 arch/arm/mach-shmobile/setup-emev2.c        |  203 +++++++++++++++++++++++++++
 3 files changed, 207 insertions(+)

--- 0008/arch/arm/mach-shmobile/Kconfig
+++ work/arch/arm/mach-shmobile/Kconfig	2012-05-12 03:41:45.000000000 +0900
@@ -45,6 +45,7 @@ config ARCH_EMEV2
 	bool "Emma Mobile EV2"
 	select CPU_V7
 	select ARM_GIC
+	select ARCH_WANT_OPTIONAL_GPIOLIB
 
 comment "SH-Mobile Board Type"
 
--- 0009/arch/arm/mach-shmobile/include/mach/emev2.h
+++ work/arch/arm/mach-shmobile/include/mach/emev2.h	2012-05-12 03:44:29.000000000 +0900
@@ -13,4 +13,7 @@ extern void emev2_secondary_init(unsigne
 extern int emev2_boot_secondary(unsigned int cpu);
 extern void emev2_smp_prepare_cpus(void);
 
+#define EMEV2_GPIO_BASE 200
+#define EMEV2_GPIO_IRQ(n) (EMEV2_GPIO_BASE + (n))
+
 #endif /* __ASM_EMEV2_H__ */
--- 0009/arch/arm/mach-shmobile/setup-emev2.c
+++ work/arch/arm/mach-shmobile/setup-emev2.c	2012-05-12 03:45:30.000000000 +0900
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/platform_device.h>
+#include <linux/platform_data/gpio-em.h>
 #include <linux/delay.h>
 #include <linux/input.h>
 #include <linux/io.h>
@@ -156,6 +157,203 @@ static struct platform_device sti_device
 	.num_resources	= ARRAY_SIZE(sti_resources),
 };
 
+
+/* GIO */
+static struct gpio_em_config gio0_config = {
+	.gpio_base = 0,
+	.irq_base = EMEV2_GPIO_IRQ(0),
+	.number_of_pins = 32,
+};
+
+static struct resource gio0_resources[] = {
+	[0] = {
+		.name	= "GIO_000",
+		.start	= 0xe0050000,
+		.end	= 0xe005002b,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.name	= "GIO_000",
+		.start	= 0xe0050040,
+		.end	= 0xe005005f,
+		.flags	= IORESOURCE_MEM,
+	},
+	[2] = {
+		.start	= 99,
+		.flags	= IORESOURCE_IRQ,
+	},
+	[3] = {
+		.start	= 100,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device gio0_device = {
+	.name		= "em_gio",
+	.id		= 0,
+	.resource	= gio0_resources,
+	.num_resources	= ARRAY_SIZE(gio0_resources),
+	.dev		= {
+		.platform_data	= &gio0_config,
+	},
+};
+
+static struct gpio_em_config gio1_config = {
+	.gpio_base = 32,
+	.irq_base = EMEV2_GPIO_IRQ(32),
+	.number_of_pins = 32,
+};
+
+static struct resource gio1_resources[] = {
+	[0] = {
+		.name	= "GIO_032",
+		.start	= 0xe0050080,
+		.end	= 0xe00500ab,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.name	= "GIO_032",
+		.start	= 0xe00500c0,
+		.end	= 0xe00500df,
+		.flags	= IORESOURCE_MEM,
+	},
+	[2] = {
+		.start	= 101,
+		.flags	= IORESOURCE_IRQ,
+	},
+	[3] = {
+		.start	= 102,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device gio1_device = {
+	.name		= "em_gio",
+	.id		= 1,
+	.resource	= gio1_resources,
+	.num_resources	= ARRAY_SIZE(gio1_resources),
+	.dev		= {
+		.platform_data	= &gio1_config,
+	},
+};
+
+static struct gpio_em_config gio2_config = {
+	.gpio_base = 64,
+	.irq_base = EMEV2_GPIO_IRQ(64),
+	.number_of_pins = 32,
+};
+
+static struct resource gio2_resources[] = {
+	[0] = {
+		.name	= "GIO_064",
+		.start	= 0xe0050100,
+		.end	= 0xe005012b,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.name	= "GIO_064",
+		.start	= 0xe0050140,
+		.end	= 0xe005015f,
+		.flags	= IORESOURCE_MEM,
+	},
+	[2] = {
+		.start	= 103,
+		.flags	= IORESOURCE_IRQ,
+	},
+	[3] = {
+		.start	= 104,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device gio2_device = {
+	.name		= "em_gio",
+	.id		= 2,
+	.resource	= gio2_resources,
+	.num_resources	= ARRAY_SIZE(gio2_resources),
+	.dev		= {
+		.platform_data	= &gio2_config,
+	},
+};
+
+static struct gpio_em_config gio3_config = {
+	.gpio_base = 96,
+	.irq_base = EMEV2_GPIO_IRQ(96),
+	.number_of_pins = 32,
+};
+
+static struct resource gio3_resources[] = {
+	[0] = {
+		.name	= "GIO_096",
+		.start	= 0xe0050100,
+		.end	= 0xe005012b,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.name	= "GIO_096",
+		.start	= 0xe0050140,
+		.end	= 0xe005015f,
+		.flags	= IORESOURCE_MEM,
+	},
+	[2] = {
+		.start	= 105,
+		.flags	= IORESOURCE_IRQ,
+	},
+	[3] = {
+		.start	= 106,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device gio3_device = {
+	.name		= "em_gio",
+	.id		= 3,
+	.resource	= gio3_resources,
+	.num_resources	= ARRAY_SIZE(gio3_resources),
+	.dev		= {
+		.platform_data	= &gio3_config,
+	},
+};
+
+static struct gpio_em_config gio4_config = {
+	.gpio_base = 128,
+	.irq_base = EMEV2_GPIO_IRQ(128),
+	.number_of_pins = 31,
+};
+
+static struct resource gio4_resources[] = {
+	[0] = {
+		.name	= "GIO_128",
+		.start	= 0xe0050200,
+		.end	= 0xe005022b,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.name	= "GIO_128",
+		.start	= 0xe0050240,
+		.end	= 0xe005025f,
+		.flags	= IORESOURCE_MEM,
+	},
+	[2] = {
+		.start	= 107,
+		.flags	= IORESOURCE_IRQ,
+	},
+	[3] = {
+		.start	= 108,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device gio4_device = {
+	.name		= "em_gio",
+	.id		= 4,
+	.resource	= gio4_resources,
+	.num_resources	= ARRAY_SIZE(gio4_resources),
+	.dev		= {
+		.platform_data	= &gio4_config,
+	},
+};
+
 static struct platform_device *emev2_early_devices[] __initdata = {
 	&uart0_device,
 	&uart1_device,
@@ -165,6 +363,11 @@ static struct platform_device *emev2_ear
 
 static struct platform_device *emev2_late_devices[] __initdata = {
 	&sti_device,
+	&gio0_device,
+	&gio1_device,
+	&gio2_device,
+	&gio3_device,
+	&gio4_device,
 };
 
 void __init emev2_add_standard_devices(void)
