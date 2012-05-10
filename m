Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab2EJHIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 03:08:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33861 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab2EJHIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 03:08:48 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: horms@verge.net.au, linux@arm.linux.org.uk, arnd@arndb.de,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        lethal@linux-sh.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Date: Thu, 10 May 2012 16:09:41 +0900
Message-Id: <20120510070941.17209.38029.sendpatchset@w520>
Subject: [PATCH] mach-shmobile: Emma Mobile EV2 DT prototype code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Here's a first attempt at DT support for EMEV2.

Basic devices like the serial ports UART0->UART3 and the
STI timer are now described in the .dts file.

It all is rather straightforward. The main exception is
a mismatch between the data sheet IRQ numbers and the ones
used in the .dts file. The EMEV2 data sheet includes all GIC
interrupts such as SGI, PPI and SPI, so the SPI interrupts
are starting from interrupt 32. The default GIC operation
seems to be top start SPI from 0 which is somewhat confusing
for the user. With platform devices we use gic_spi() for 
interrupts starting from 32. Not sure the best way to start
counting from 0 with DT.

At this point the DT support in this patch is UP only,
I'd be very interested in enabling SMP on a SoC level.

Future work include GPIO driver and DT bindings, followed
by on-board Ethernet controller support.

Not-yet-signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/boot/Makefile               |    1 
 arch/arm/boot/dts/emev2-kzm9d.dts    |   66 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-shmobile/Makefile.boot |    3 +
 arch/arm/mach-shmobile/clock-emev2.c |    5 ++
 arch/arm/mach-shmobile/setup-emev2.c |   49 ++++++++++++++++++++++++-
 5 files changed, 123 insertions(+), 1 deletion(-)

--- 0001/arch/arm/boot/Makefile
+++ work/arch/arm/boot/Makefile	2012-05-10 15:20:22.000000000 +0900
@@ -53,6 +53,7 @@ $(obj)/compressed/vmlinux: $(obj)/Image
 
 $(obj)/zImage:	$(obj)/compressed/vmlinux FORCE
 	$(call if_changed,objcopy)
+	cat $(obj)/emev2-kzm9d.dtb >> $@
 	@echo '  Kernel: $@ is ready'
 
 endif
--- /dev/null
+++ work/arch/arm/boot/dts/emev2-kzm9d.dts	2012-05-10 15:20:23.000000000 +0900
@@ -0,0 +1,66 @@
+/dts-v1/;
+
+/ {
+	model = "EMEV2 KZM9D Board";
+	compatible = "renesas,emev2";
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	interrupt-parent = <&gic>;
+
+	cpus {
+		cpu@0 {
+			compatible = "arm,cortex-a9";
+		};
+		cpu@1 {
+			compatible = "arm,cortex-a9";
+		};
+	};
+
+	gic: interrupt-controller@e0020000 {
+		compatible = "arm,cortex-a9-gic";
+		interrupt-controller;
+		#interrupt-cells = <3>;
+		reg = <0xe0028000 0x1000>,
+		      <0xe0020000 0x0100>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS1,115200n81 mem=128M@0x40000000 ignore_loglevel";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x40000000 0x8000000>; /* 128 MB */
+	};
+
+	sti@e0180000 {
+		compatible = "renesas,em-sti";
+		reg = <0xe0180000 0x54>;
+		interrupts = <0 125 0>;
+       };
+
+	uart@e1020000 {
+		compatible = "renesas,em-uart";
+		reg = <0xe1020000 0x38>;
+		interrupts = <0 8 0>;
+       };
+
+	uart@e1030000 {
+		compatible = "renesas,em-uart";
+		reg = <0xe1030000 0x38>;
+		interrupts = <0 9 0>;
+       };
+
+	uart@e1040000 {
+		compatible = "renesas,em-uart";
+		reg = <0xe1040000 0x38>;
+		interrupts = <0 10 0>;
+       };
+
+	uart@e1050000 {
+		compatible = "renesas,em-uart";
+		reg = <0xe1050000 0x38>;
+		interrupts = <0 11 0>;
+       };
+};
--- 0001/arch/arm/mach-shmobile/Makefile.boot
+++ work/arch/arm/mach-shmobile/Makefile.boot	2012-05-10 15:20:22.000000000 +0900
@@ -7,3 +7,6 @@ __ZRELADDR	:= $(shell /bin/bash -c 'prin
 #
 #params_phys-y (Instead: Pass atags pointer in r2)
 #initrd_phys-y (Instead: Use compiled-in initramfs)
+
+dtb-y	+= emev2-kzm9d.dtb
+
--- 0009/arch/arm/mach-shmobile/clock-emev2.c
+++ work/arch/arm/mach-shmobile/clock-emev2.c	2012-05-10 15:20:22.000000000 +0900
@@ -168,10 +168,15 @@ static int __init emev2_sclkdiv_register
 
 static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("serial8250-em.0", &gclk_clks[GCLK_USIAU0_SCLK]),
+	CLKDEV_DEV_ID("e1020000.uart", &gclk_clks[GCLK_USIAU0_SCLK]),
 	CLKDEV_DEV_ID("serial8250-em.1", &gclk_clks[GCLK_USIBU1_SCLK]),
+	CLKDEV_DEV_ID("e1030000.uart", &gclk_clks[GCLK_USIBU1_SCLK]),
 	CLKDEV_DEV_ID("serial8250-em.2", &gclk_clks[GCLK_USIBU2_SCLK]),
+	CLKDEV_DEV_ID("e1040000.uart", &gclk_clks[GCLK_USIBU2_SCLK]),
 	CLKDEV_DEV_ID("serial8250-em.3", &gclk_clks[GCLK_USIBU3_SCLK]),
+	CLKDEV_DEV_ID("e1050000.uart", &gclk_clks[GCLK_USIBU3_SCLK]),
 	CLKDEV_DEV_ID("em_sti.0", &gclk_clks[GCLK_STI_SCLK]),
+	CLKDEV_DEV_ID("e0180000.sti", &gclk_clks[GCLK_STI_SCLK]),
 };
 
 void __init emev2_clock_init(void)
--- 0011/arch/arm/mach-shmobile/setup-emev2.c
+++ work/arch/arm/mach-shmobile/setup-emev2.c	2012-05-10 15:57:48.000000000 +0900
@@ -21,9 +21,11 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/platform_device.h>
+#include <linux/of_platform.h>
 #include <linux/delay.h>
 #include <linux/input.h>
 #include <linux/io.h>
+#include <linux/of_irq.h>
 #include <mach/hardware.h>
 #include <mach/common.h>
 #include <mach/irqs.h>
@@ -31,6 +33,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/time.h>
+#include <asm/hardware/gic.h>
 
 static struct map_desc emev2_io_desc[] __initdata = {
 	/* 128K entity map for 0xe0020000 (GIC) */
@@ -181,9 +184,14 @@ void __init emev2_add_standard_devices(v
 			     ARRAY_SIZE(emev2_late_devices));
 }
 
-void __init emev2_add_early_devices(void)
+void __init emev2_init_delay(void)
 {
 	shmobile_setup_delay(533, 1, 3); /* Cortex-A9 @ 533MHz */
+}
+
+void __init emev2_add_early_devices(void)
+{
+	emev2_init_delay();
 
 	early_platform_add_devices(emev2_early_devices,
 				   ARRAY_SIZE(emev2_early_devices));
@@ -192,3 +200,42 @@ void __init emev2_add_early_devices(void
 	shmobile_setup_console();
 }
 
+#ifdef CONFIG_USE_OF
+static const struct of_dev_auxdata emev2_auxdata_lookup[] __initconst = {
+	{ }
+};
+
+void __init emev2_add_standard_devices_dt(void)
+{
+	emev2_clock_init();
+	of_platform_populate(NULL, of_default_bus_match_table,
+			     emev2_auxdata_lookup, NULL);
+}
+
+static const struct of_device_id emev2_dt_irq_match[] = {
+	{ .compatible = "arm,cortex-a9-gic", .data = gic_of_init, },
+	{},
+};
+
+static const char *emev2_boards_compat_dt[] __initdata = {
+	"renesas,emev2",
+	NULL,
+};
+
+void __init emev2_init_irq_dt(void)
+{
+	of_irq_init(emev2_dt_irq_match);
+}
+
+DT_MACHINE_START(EMEV2_DT, "Generic Emma Mobile EV2 (Flattened Device Tree)")
+	.map_io		= emev2_map_io,
+	.init_early	= emev2_init_delay,
+	.nr_irqs	= NR_IRQS_LEGACY,
+	.init_irq	= emev2_init_irq_dt,
+	.handle_irq	= gic_handle_irq,
+	.init_machine	= emev2_add_standard_devices_dt,
+	.timer		= &shmobile_timer,
+	.dt_compat	= emev2_boards_compat_dt,
+MACHINE_END
+
+#endif /* CONFIG_USE_OF */
