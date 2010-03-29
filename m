Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0C2TaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 15:30:10 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47208 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab0C2TaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 15:30:06 -0400
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: Russell King <linux@arm.linux.org.uk>,
       Dmitry Artamonow <mad_soft@inbox.ru>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: [PATCH] ARM: mach-sa1100: Put nanoEngine support back in the kernel.
Date: Mon, 29 Mar 2010 16:29:32 -0300
Message-Id: <1269890972-13436-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds Bright Star Engineering's nanoEngine board support to the kernel.
Also:
- Adds the nanoEngine memory chip to arch/arm/mach-sa1100/cpu-sa1110.c
  (Micron MT48LC8M16A2TG-75).
- Increase in the sdram_params->name[] field length to accomodate the
  name of the memory chip.
- Clean up of header content and order of arch/arm/mach-sa1100/cpu-sa1110.c

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
---
 arch/arm/mach-sa1100/Kconfig      |    8 +++
 arch/arm/mach-sa1100/Makefile     |    2 +
 arch/arm/mach-sa1100/cpu-sa1110.c |   27 ++++++---
 arch/arm/mach-sa1100/nanoengine.c |  115 +++++++++++++++++++++++++++++++++++++
 4 files changed, 142 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm/mach-sa1100/nanoengine.c

diff --git a/arch/arm/mach-sa1100/Kconfig b/arch/arm/mach-sa1100/Kconfig
index b17d52f..403db50 100644
--- a/arch/arm/mach-sa1100/Kconfig
+++ b/arch/arm/mach-sa1100/Kconfig
@@ -118,6 +118,14 @@ config SA1100_LART
 	  (also known as the LART).  See <http://www.lartmaker.nl/> for
 	  information on the LART.
 
+config SA1100_NANOENGINE
+	bool "nanoEngine"
+	select CPU_FREQ_SA1110
+	help
+	  Say Y here if you are using the Bright Star Engineering nanoEngine.
+	  See <http://www.brightstareng.com/arm/nanoeng.htm> for information
+	  on the BSE nanoEngine.
+
 config SA1100_PLEB
 	bool "PLEB"
 	select CPU_FREQ_SA1100
diff --git a/arch/arm/mach-sa1100/Makefile b/arch/arm/mach-sa1100/Makefile
index 89349c1..8029fe2 100644
--- a/arch/arm/mach-sa1100/Makefile
+++ b/arch/arm/mach-sa1100/Makefile
@@ -37,6 +37,8 @@ obj-$(CONFIG_SA1100_JORNADA720_SSP)	+= jornada720_ssp.o
 obj-$(CONFIG_SA1100_LART)		+= lart.o
 led-$(CONFIG_SA1100_LART)		+= leds-lart.o
 
+obj-$(CONFIG_SA1100_NANOENGINE)		+= nanoengine.o
+
 obj-$(CONFIG_SA1100_PLEB)		+= pleb.o
 
 obj-$(CONFIG_SA1100_SHANNON)		+= shannon.o
diff --git a/arch/arm/mach-sa1100/cpu-sa1110.c b/arch/arm/mach-sa1100/cpu-sa1110.c
index 63b32b6..7236fcd 100644
--- a/arch/arm/mach-sa1100/cpu-sa1110.c
+++ b/arch/arm/mach-sa1100/cpu-sa1110.c
@@ -16,19 +16,17 @@
  *
  * The SDRAM type can be passed on the command line as cpu_sa1110.sdram=type
  */
-#include <linux/moduleparam.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/cpufreq.h>
 #include <linux/delay.h>
 #include <linux/init.h>
-#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
 
-#include <mach/hardware.h>
 #include <asm/cputype.h>
 #include <asm/mach-types.h>
-#include <asm/system.h>
+
+#include <mach/hardware.h>
 
 #include "generic.h"
 
@@ -37,7 +35,7 @@
 static struct cpufreq_driver sa1110_driver;
 
 struct sdram_params {
-	const char name[16];
+	const char name[20];
 	u_char  rows;		/* bits				 */
 	u_char  cas_latency;	/* cycles			 */
 	u_char  tck;		/* clock cycle time (ns)	 */
@@ -107,6 +105,15 @@ static struct sdram_params sdram_tbl[] __initdata = {
 		.twr		= 8,
 		.refresh	= 64000,
 		.cas_latency	= 3,
+	}, {	/* Micron MT48LC8M16A2TG-75 */
+		.name		= "MT48LC8M16A2TG-75",
+		.rows		= 12,
+		.tck		= 8,
+		.trcd		= 20,
+		.trp		= 20,
+		.twr		= 8,
+		.refresh	= 64000,
+		.cas_latency	= 3,
 	},
 };
 
@@ -366,14 +373,14 @@ static int __init sa1110_clk_init(void)
 	if (!name[0]) {
 		if (machine_is_assabet())
 			name = "TC59SM716-CL3";
-
 		if (machine_is_pt_system3())
 			name = "K4S641632D";
-
 		if (machine_is_h3100())
 			name = "KM416S4030CT";
 		if (machine_is_jornada720())
 		        name = "K4S281632B-1H";
+		if (machine_is_nanoengine())
+			name = "MT48LC8M16A2TG-75";
 	}
 
 	sdram = sa1110_find_sdram(name);
diff --git a/arch/arm/mach-sa1100/nanoengine.c b/arch/arm/mach-sa1100/nanoengine.c
new file mode 100644
index 0000000..73a7922
--- /dev/null
+++ b/arch/arm/mach-sa1100/nanoengine.c
@@ -0,0 +1,115 @@
+/*
+ * linux/arch/arm/mach-sa1100/nanoengine.c
+ *
+ * Bright Star Engineering's nanoEngine board init code.
+ *
+ * Copyright (C) 2009 Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/root_dev.h>
+
+#include <asm/mach-types.h>
+#include <asm/setup.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/flash.h>
+#include <asm/mach/map.h>
+#include <asm/mach/serial_sa1100.h>
+
+#include <mach/hardware.h>
+
+#include "generic.h"
+
+/* Flash bank 0 */
+static struct mtd_partition nanoengine_partitions[] = {
+	{
+		.name	= "nanoEngine boot firmware and parameter table",
+		.size		= 0x00010000,  /* 32K */
+		.offset		= 0,
+		.mask_flags	= MTD_WRITEABLE,
+	}, {
+		.name		= "kernel/initrd reserved",
+		.size		= 0x002f0000,
+		.offset		= 0x00010000,
+		.mask_flags	= MTD_WRITEABLE,
+	}, {
+		.name		= "experimental filesystem allocation",
+		.size		= 0x00100000,
+		.offset		= 0x00300000,
+		.mask_flags	= MTD_WRITEABLE,
+	}
+};
+
+static struct flash_platform_data nanoengine_flash_data = {
+	.map_name	= "jedec_probe",
+	.parts		= nanoengine_partitions,
+	.nr_parts	= ARRAY_SIZE(nanoengine_partitions),
+};
+
+static struct resource nanoengine_flash_resources[] = {
+	{
+		.start	= SA1100_CS0_PHYS,
+		.end	= SA1100_CS0_PHYS + SZ_32M - 1,
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.start	= SA1100_CS1_PHYS,
+		.end	= SA1100_CS1_PHYS + SZ_32M - 1,
+		.flags	= IORESOURCE_MEM,
+	}
+};
+
+static struct map_desc nanoengine_io_desc[] __initdata = {
+	{
+		/* System Registers */
+		.virtual	= 0xf0000000,
+		.pfn		= __phys_to_pfn(0x10000000),
+		.length		= 0x00100000,
+		.type		= MT_DEVICE
+	}, {
+		/* Internal PCI Config Space */
+		.virtual	= 0xf1000000,
+		.pfn		= __phys_to_pfn(0x18A00000),
+		.length		= 0x00100000,
+		.type		= MT_DEVICE
+	}
+};
+
+static void __init nanoengine_map_io(void)
+{
+	sa1100_map_io();
+	iotable_init(nanoengine_io_desc, ARRAY_SIZE(nanoengine_io_desc));
+
+	sa1100_register_uart(0, 1);
+	sa1100_register_uart(1, 2);
+	sa1100_register_uart(2, 3);
+	Ser1SDCR0 |= SDCR0_UART;
+	/* disable IRDA -- UART2 is used as a normal serial port */
+	Ser2UTCR4 = 0;
+	Ser2HSCR0 = 0;
+}
+
+static void __init nanoengine_init(void)
+{
+	sa11x0_register_mtd(&nanoengine_flash_data, nanoengine_flash_resources,
+		ARRAY_SIZE(nanoengine_flash_resources));
+}
+
+MACHINE_START(NANOENGINE, "BSE nanoEngine")
+	.phys_io	= 0x80000000,
+	.io_pg_offst	= ((0xf8000000) >> 18) & 0xfffc,
+	.boot_params	= 0xc0000000,
+	.map_io		= nanoengine_map_io,
+	.init_irq	= sa1100_init_irq,
+	.timer		= &sa1100_timer,
+	.init_machine	= nanoengine_init,
+MACHINE_END
+
-- 
1.7.0.3

