Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab1HEQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 12:25:28 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:58059 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612Ab1HEQZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 12:25:25 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [RFC PATCH 2/2] AT91: dt: simple device tree support for at91sam9g45 family
Date: Fri,  5 Aug 2011 17:24:53 +0100
Message-Id: <bdd7c02a561bc0655e9dfd4586f42774f2347ca1.1312560476.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1312561493-7849-1-git-send-email-nicolas.ferre@atmel.com>
References: <1312561493-7849-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <56092075210001f40db485e0b126fe7c0c7b75ac.1312560476.git.nicolas.ferre@atmel.com>
References: <56092075210001f40db485e0b126fe7c0c7b75ac.1312560476.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic device tree support for at91sam9g45 SoC family and the
at91sam9m10g45ek board.
DT is been used to describe the at91sam9g45 SoC memory and AIC. It also
adds the dmaengine driver.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Kconfig               |    8 ++++++
 arch/arm/mach-at91/Makefile.boot         |    2 +
 arch/arm/mach-at91/at91sam9g45_devices.c |    3 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c  |   36 ++++++++++++++++++++++++++++++
 4 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 2248467..973c725 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -407,6 +407,14 @@ config MACH_AT91SAM9M10G45EK
 	  "ES" at the end of the name means that this board is an
 	  Engineering Sample.
 
+config MACH_AT91SAM9M10G45EK_DT
+	bool "Atmel AT91SAM9M10G45-EK Evaluation Kits with device-tree support"
+	select USE_OF
+	select MACH_AT91SAM9M10G45EK
+	help
+	  Select this if you want to experiment device-tree with
+	  Atmel's AT91SAM9M10G45-EK Evaluation Kit.
+
 endif
 
 # ----------------------------------------------------------
diff --git a/arch/arm/mach-at91/Makefile.boot b/arch/arm/mach-at91/Makefile.boot
index 3462b81..78d384f 100644
--- a/arch/arm/mach-at91/Makefile.boot
+++ b/arch/arm/mach-at91/Makefile.boot
@@ -16,3 +16,5 @@ else
 params_phys-y	:= 0x20000100
 initrd_phys-y	:= 0x20410000
 endif
+
+dtb-$(CONFIG_MACH_AT91SAM9M10G45EK_DT) += at91sam9m10g45ek.dtb
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 600bffb..ff3b7fc 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -35,7 +35,8 @@
  *  HDMAC - AHB DMA Controller
  * -------------------------------------------------------------------- */
 
-#if defined(CONFIG_AT_HDMAC) || defined(CONFIG_AT_HDMAC_MODULE)
+#if (defined(CONFIG_AT_HDMAC) || defined(CONFIG_AT_HDMAC_MODULE)) \
+	&& !defined(CONFIG_OF)
 static u64 hdmac_dmamask = DMA_BIT_MASK(32);
 
 static struct at_dma_platform_data atdma_pdata = {
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index ad234cc..99e8617 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -26,6 +26,10 @@
 #include <linux/clk.h>
 #include <linux/atmel-mci.h>
 
+#include <linux/irqdomain.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+
 #include <mach/hardware.h>
 #include <video/atmel_lcdc.h>
 
@@ -413,6 +417,38 @@ static void __init ek_board_init(void)
 	at91_pwm_leds(ek_pwm_led, ARRAY_SIZE(ek_pwm_led));
 }
 
+#if defined(CONFIG_OF)
+static const struct of_device_id aic_of_match[] __initconst = {
+	{ .compatible = "atmel,aic", },
+	{},
+};
+
+static void __init at91sam9g45_dt_device_init(void)
+{
+	irq_domain_generate_simple(aic_of_match, 0xfffff000, 0);
+
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+
+	/* remaining initialization */
+	ek_board_init(void)
+}
+
+static const char *at91_dt_board_compat[] __initdata = {
+	"atmel,at91sam9m10g45ek",
+	NULL
+};
+
+DT_MACHINE_START(at91sam9m10g45ek_dt, "Atmel AT91SAM9M10G45-EK (Device Tree)")
+	/* Maintainer: Atmel */
+	.timer		= &at91sam926x_timer,
+	.map_io		= at91_map_io,
+	.init_early	= ek_init_early,
+	.init_irq	= at91_init_irq_default,
+	.init_machine	= at91sam9g45_dt_device_init,
+	.dt_compat	= at91_dt_board_compat,
+MACHINE_END
+#endif
+
 MACHINE_START(AT91SAM9M10G45EK, "Atmel AT91SAM9M10G45-EK")
 	/* Maintainer: Atmel */
 	.timer		= &at91sam926x_timer,
-- 
1.7.4.1

