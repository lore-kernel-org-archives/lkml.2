Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338Ab2EPGpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:45:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58985 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759224Ab2EPGpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:45:03 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: horms@verge.net.au, linux@arm.linux.org.uk, arnd@arndb.de,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        lethal@linux-sh.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 16 May 2012 15:46:03 +0900
Message-Id: <20120516064603.32286.93274.sendpatchset@w520>
In-Reply-To: <20120516064449.32286.77941.sendpatchset@w520>
References: <20120516064449.32286.77941.sendpatchset@w520>
Subject: [PATCH 08/08] mach-shmobile: Use DT_MACHINE for KZM9D V3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Use DT_MACHINE_START() on the emev2 based KZM9D board.

Also include a tiny DTS file to describe the board and
update the Kconfig dependencies to select CONFIG_USE_OF.

Update the SMP glue code to use OF for matching.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Changes from V1:
 - none - this is the first public release

 arch/arm/boot/dts/emev2-kzm9d.dts    |   26 ++++++++++++++++++++++++++
 arch/arm/mach-shmobile/Kconfig       |    1 +
 arch/arm/mach-shmobile/board-kzm9d.c |    8 +++++++-
 arch/arm/mach-shmobile/platsmp.c     |    3 ++-
 4 files changed, 36 insertions(+), 2 deletions(-)

--- /dev/null
+++ work/arch/arm/boot/dts/emev2-kzm9d.dts	2012-05-16 15:22:30.000000000 +0900
@@ -0,0 +1,26 @@
+/*
+ * Device Tree Source for the KZM9D board
+ *
+ * Copyright (C) 2012 Renesas Solutions Corp.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+/dts-v1/;
+
+/include/ "emev2.dtsi"
+
+/ {
+	model = "EMEV2 KZM9D Board";
+	compatible = "renesas,kzm9d", "renesas,emev2";
+
+	memory {
+		device_type = "memory";
+		reg = <0x40000000 0x8000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS1,115200n81";
+	};
+};
--- 0010/arch/arm/mach-shmobile/Kconfig
+++ work/arch/arm/mach-shmobile/Kconfig	2012-05-16 15:03:53.000000000 +0900
@@ -119,6 +119,7 @@ config MACH_KZM9G
 config MACH_KZM9D
 	bool "KZM9D board"
 	depends on ARCH_EMEV2
+	select USE_OF
 
 comment "SH-Mobile System Configuration"
 
--- 0011/arch/arm/mach-shmobile/board-kzm9d.c
+++ work/arch/arm/mach-shmobile/board-kzm9d.c	2012-05-16 15:17:35.000000000 +0900
@@ -68,7 +68,12 @@ void __init kzm9d_add_standard_devices(v
 	platform_add_devices(kzm9d_devices, ARRAY_SIZE(kzm9d_devices));
 }
 
-MACHINE_START(KZM9D, "kzm9d")
+static const char *kzm9d_boards_compat_dt[] __initdata = {
+	"renesas,kzm9d",
+	NULL,
+};
+
+DT_MACHINE_START(KZM9D_DT, "kzm9d")
 	.map_io		= emev2_map_io,
 	.init_early	= emev2_add_early_devices,
 	.nr_irqs	= NR_IRQS_LEGACY,
@@ -76,4 +81,5 @@ MACHINE_START(KZM9D, "kzm9d")
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= kzm9d_add_standard_devices,
 	.timer		= &shmobile_timer,
+	.dt_compat	= kzm9d_boards_compat_dt,
 MACHINE_END
--- 0009/arch/arm/mach-shmobile/platsmp.c
+++ work/arch/arm/mach-shmobile/platsmp.c	2012-05-16 15:17:41.000000000 +0900
@@ -16,6 +16,7 @@
 #include <linux/device.h>
 #include <linux/smp.h>
 #include <linux/io.h>
+#include <linux/of.h>
 #include <asm/hardware/gic.h>
 #include <asm/mach-types.h>
 #include <mach/common.h>
@@ -23,7 +24,7 @@
 
 #define is_sh73a0() (machine_is_ag5evm() || machine_is_kota2() || machine_is_kzm9g())
 #define is_r8a7779() machine_is_marzen()
-#define is_emev2() machine_is_kzm9d()
+#define is_emev2() of_machine_is_compatible("renesas,emev2")
 
 static unsigned int __init shmobile_smp_get_core_count(void)
 {
