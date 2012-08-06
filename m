Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab2HFMYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:24:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40028 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab2HFMYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:24:09 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rabeeh Khoury <rabeeh@solid-run.com>,
        Ian Molton <ian.molton@codethink.co.uk>, Arnd Bergmann <arnd@arndb.de>,
        Maen Suleiman <maen@marvell.com>, Olof Johansson <olof@lixom.net>
Subject: [PATCH 4/6] ARM: dove: add device tree based machine descriptor
Date: Mon,  6 Aug 2012 14:23:32 +0200
Message-Id: <1344255815-4457-5-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344255815-4457-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1344255815-4457-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a generic DT_MACHINE for mach-dove. As with other orion based
SoCs there still is some glue code required to make all internal devices
work, i.e. auxdata is provided to pass clocks to corresponding device
drivers. 

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: Rabeeh Khoury <rabeeh@solid-run.com>
Cc: Ian Molton <ian.molton@codethink.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Maen Suleiman <maen@marvell.com>
Cc: Olof Johansson <olof@lixom.net>
---
 arch/arm/mach-dove/Kconfig  |    7 +++++
 arch/arm/mach-dove/common.c |   67 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/arch/arm/mach-dove/Kconfig b/arch/arm/mach-dove/Kconfig
index dd937c5..00154e7 100644
--- a/arch/arm/mach-dove/Kconfig
+++ b/arch/arm/mach-dove/Kconfig
@@ -15,6 +15,13 @@ config MACH_CM_A510
 	  Say 'Y' here if you want your kernel to support the
 	  CompuLab CM-A510 Board.
 
+config MACH_DOVE_DT
+	bool "Marvell Dove Flattened Device Tree"
+	select USE_OF
+	help
+	  Say 'Y' here if you want your kernel to support the
+	  Marvell Dove using flattened device tree.
+
 endmenu
 
 endif
diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index 6f2fe65..6f594bd3 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -17,6 +17,8 @@
 #include <linux/ata_platform.h>
 #include <linux/gpio.h>
 #include <linux/mv643xx_i2c.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 #include <asm/page.h>
 #include <asm/setup.h>
 #include <asm/timex.h>
@@ -30,6 +32,7 @@
 #include <asm/mach/arch.h>
 #include <linux/irq.h>
 #include <plat/time.h>
+#include <plat/irq.h>
 #include <plat/ehci-orion.h>
 #include <plat/common.h>
 #include <plat/addr-map.h>
@@ -384,3 +387,67 @@ void dove_restart(char mode, const char *cmd)
 	while (1)
 		;
 }
+
+#if defined(CONFIG_MACH_DOVE_DT)
+/*
+ * Auxdata required until real OF clock provider
+ */
+struct of_dev_auxdata dove_auxdata_lookup[] __initdata = {
+	OF_DEV_AUXDATA("marvell,orion-spi", 0xf1010600, "orion_spi.0", NULL),
+	OF_DEV_AUXDATA("marvell,orion-spi", 0xf1014600, "orion_spi.1", NULL),
+	OF_DEV_AUXDATA("marvell,orion-wdt", 0xf1020300, "orion_wdt", NULL),
+	OF_DEV_AUXDATA("marvell,mv64xxx-i2c", 0xf1011000, "mv64xxx_i2c.0",
+		       NULL),
+	OF_DEV_AUXDATA("marvell,orion-sata", 0xf10a0000, "sata_mv.0", NULL),
+	OF_DEV_AUXDATA("marvell,dove-sdhci", 0xf1092000, "sdhci-dove.0", NULL),
+	OF_DEV_AUXDATA("marvell,dove-sdhci", 0xf1090000, "sdhci-dove.1", NULL),
+	{},
+};
+
+static struct mv643xx_eth_platform_data dove_dt_ge00_data = {
+	.phy_addr = MV643XX_ETH_PHY_ADDR_DEFAULT,
+};
+
+static void __init dove_dt_init(void)
+{
+	pr_info("Dove 88AP510 SoC, TCLK = %d MHz.\n",
+		(dove_tclk + 499999) / 1000000);
+
+#ifdef CONFIG_CACHE_TAUROS2
+	tauros2_init();
+#endif
+	dove_setup_cpu_mbus();
+
+	/* Setup root of clk tree */
+	dove_clk_init();
+
+	/* Internal devices not ported to DT yet */
+	dove_rtc_init();
+	dove_xor0_init();
+	dove_xor1_init();
+
+	dove_ge00_init(&dove_dt_ge00_data);
+	dove_ehci0_init();
+	dove_ehci1_init();
+	dove_pcie_init(1, 1);
+	dove_crypto_init();
+
+	of_platform_populate(NULL, of_default_bus_match_table,
+			     dove_auxdata_lookup, NULL);
+}
+
+static const char * const dove_dt_board_compat[] = {
+	"marvell,dove",
+	NULL
+};
+
+DT_MACHINE_START(DOVE_DT, "Marvell Dove (Flattened Device Tree)")
+	.map_io		= dove_map_io,
+	.init_early	= dove_init_early,
+	.init_irq	= orion_dt_init_irq,
+	.timer		= &dove_timer,
+	.init_machine	= dove_dt_init,
+	.restart	= dove_restart,
+	.dt_compat	= dove_dt_board_compat,
+MACHINE_END
+#endif
-- 
1.7.10.4

