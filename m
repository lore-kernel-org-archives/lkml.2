Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946289Ab2JYQPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:15:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48048 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946257Ab2JYQM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:12:26 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-keystone@list.ti.com>, Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v3 09/11] ARM: davinci - dm644x: update SoC code to remove the clock data
Date: Thu, 25 Oct 2012 12:11:55 -0400
Message-ID: <1351181518-11882-10-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the migration, the clock data is now moved to the driver/clk/
davinci/dm644x-clock.c. Currently the clock data is placed under ifndef
CONFIG_COMMON_CLK directive and will be removed in a subsequent patch.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 arch/arm/mach-davinci/davinci.h |    3 +++
 arch/arm/mach-davinci/dm644x.c  |   28 ++++++++++++++++++++++------
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-davinci/davinci.h b/arch/arm/mach-davinci/davinci.h
index 8661b20..ae9b1af 100644
--- a/arch/arm/mach-davinci/davinci.h
+++ b/arch/arm/mach-davinci/davinci.h
@@ -100,4 +100,7 @@ int __init dm646x_init_edma(struct edma_rsv_info *rsv);
 void dm646x_video_init(void);
 void dm646x_setup_vpif(struct vpif_display_config *,
 		       struct vpif_capture_config *);
+
+extern void __init dm644x_clk_init(void);
+
 #endif /*__DAVINCI_H */
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 0755d46..bf64b75 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -9,7 +9,9 @@
  * or implied.
  */
 #include <linux/init.h>
+#ifndef CONFIG_COMMON_CLK
 #include <linux/clk.h>
+#endif
 #include <linux/serial_8250.h>
 #include <linux/platform_device.h>
 
@@ -18,7 +20,9 @@
 #include <mach/cputype.h>
 #include <mach/edma.h>
 #include <mach/irqs.h>
+#ifndef CONFIG_COMMON_CLK
 #include <mach/psc.h>
+#endif
 #include <mach/mux.h>
 #include <mach/time.h>
 #include <mach/serial.h>
@@ -26,14 +30,11 @@
 #include <mach/gpio-davinci.h>
 
 #include "davinci.h"
-#include "clock.h"
 #include "mux.h"
 #include "asp.h"
-
-/*
- * Device specific clocks
- */
-#define DM644X_REF_FREQ		27000000
+#ifndef CONFIG_COMMON_CLK
+#include "clock.h"
+#endif
 
 #define DM644X_EMAC_BASE		0x01c80000
 #define DM644X_EMAC_MDIO_BASE		(DM644X_EMAC_BASE + 0x4000)
@@ -42,6 +43,12 @@
 #define DM644X_EMAC_CNTRL_RAM_OFFSET	0x2000
 #define DM644X_EMAC_CNTRL_RAM_SIZE	0x2000
 
+#ifndef CONFIG_COMMON_CLK
+/*
+ * Device specific clocks
+ */
+#define DM644X_REF_FREQ		27000000
+
 static struct pll_data pll1_data = {
 	.num       = 1,
 	.phys_base = DAVINCI_PLL1_BASE,
@@ -324,6 +331,7 @@ static struct clk_lookup dm644x_clks[] = {
 	CLK("watchdog", NULL, &timer2_clk),
 	CLK(NULL, NULL, NULL),
 };
+#endif
 
 static struct emac_platform_data dm644x_emac_pdata = {
 	.ctrl_reg_offset	= DM644X_EMAC_CNTRL_OFFSET,
@@ -821,7 +829,9 @@ static struct davinci_id dm644x_ids[] = {
 	},
 };
 
+#ifndef CONFIG_COMMON_CLK
 static u32 dm644x_psc_bases[] = { DAVINCI_PWR_SLEEP_CNTRL_BASE };
+#endif
 
 /*
  * T0_BOT: Timer 0, bottom:  clockevent source for hrtimers
@@ -879,9 +889,13 @@ static struct davinci_soc_info davinci_soc_info_dm644x = {
 	.jtag_id_reg		= 0x01c40028,
 	.ids			= dm644x_ids,
 	.ids_num		= ARRAY_SIZE(dm644x_ids),
+#ifdef CONFIG_COMMON_CLK
+	.clk_init		= dm644x_clk_init,
+#else
 	.cpu_clks		= dm644x_clks,
 	.psc_bases		= dm644x_psc_bases,
 	.psc_bases_num		= ARRAY_SIZE(dm644x_psc_bases),
+#endif
 	.pinmux_base		= DAVINCI_SYSTEM_MODULE_BASE,
 	.pinmux_pins		= dm644x_pins,
 	.pinmux_pins_num	= ARRAY_SIZE(dm644x_pins),
@@ -923,11 +937,13 @@ int __init dm644x_init_video(struct vpfe_config *vpfe_cfg,
 		dm644x_vpfe_dev.dev.platform_data = vpfe_cfg;
 		platform_device_register(&dm644x_ccdc_dev);
 		platform_device_register(&dm644x_vpfe_dev);
+#ifndef CONFIG_COMMON_CLK
 		/* Add ccdc clock aliases */
 		clk_add_alias("master", dm644x_ccdc_dev.name,
 			      "vpss_master", NULL);
 		clk_add_alias("slave", dm644x_ccdc_dev.name,
 			      "vpss_slave", NULL);
+#endif
 	}
 
 	if (vpbe_cfg) {
-- 
1.7.9.5

