Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab2IEKCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:02:17 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:49600 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758407Ab2IEJ7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:59:54 -0400
From: Loic Pallardy <loic.pallardy-ext@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.com>
Cc: Lee Jones <lee.jones@linaro.org>, Loic Pallardy <loic.pallardy@gmail.com>,
        LT ST-Ericsson <st-ericsson@lists.linaro.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        Maxime Coquelin <maxime.coquelin@stericsson.com>
Subject: [PATCH 04/17] mfd: dbx500-prcmu: Introduce TCDM mapping struct
Date: Wed, 5 Sep 2012 11:59:00 +0200
Message-ID: <1346839153-6465-5-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TCDM size varies between DBs models.
This patch introduces a new structure aimed to handle the TCDM
dynamically.

Each SoC from ux500 family declares its mapping and pass it to
prcmu early init.

Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Signed-off-by: Maxime Coquelin <maxime.coquelin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c         |  3 ++-
 arch/arm/mach-ux500/cpu-db8500.c           | 11 +++++++++++
 arch/arm/mach-ux500/include/mach/devices.h |  3 +++
 include/linux/mfd/dbx500-prcmu.h           |  9 +++++++--
 4 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 057dfdb..a38493b 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -28,6 +28,7 @@
 #include <linux/mfd/tps6105x.h>
 #include <linux/mfd/abx500/ab8500-gpio.h>
 #include <linux/mfd/abx500/ab8500-codec.h>
+#include <linux/mfd/dbx500-prcmu.h>
 #include <linux/leds-lp5521.h>
 #include <linux/input.h>
 #include <linux/smsc911x.h>
@@ -718,7 +719,7 @@ static void __init u9540_init_machine(void)
 
 static void __init mop500_init_irq(void)
 {
-	prcmu_early_init();
+	prcmu_early_init(&db8500_tcdm_map);
 	ux500_init_irq();
 }
 
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index f3ed787..59dcf82 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/mfd/abx500/ab8500.h>
+#include <linux/mfd/dbx500-prcmu.h>
 
 #include <asm/mach/map.h>
 #include <asm/pmu.h>
@@ -133,6 +134,16 @@ static struct platform_device db8500_prcmu_device = {
 	.name			= "db8500-prcmu",
 };
 
+struct prcmu_tcdm_map db8500_tcdm_map = {
+	.tcdm_size = SZ_4K,
+	.legacy_offset = 0,
+};
+
+struct prcmu_tcdm_map db9540_tcdm_map = {
+	.tcdm_size = SZ_4K + SZ_8K,
+	.legacy_offset = SZ_8K,
+};
+
 static struct platform_device *platform_devs[] __initdata = {
 	&u8500_dma40_device,
 	&db8500_pmu_device,
diff --git a/arch/arm/mach-ux500/include/mach/devices.h b/arch/arm/mach-ux500/include/mach/devices.h
index cbc6f1e..1caa76e 100644
--- a/arch/arm/mach-ux500/include/mach/devices.h
+++ b/arch/arm/mach-ux500/include/mach/devices.h
@@ -20,4 +20,7 @@ extern struct platform_device ux500_cryp1_device;
 extern struct platform_device u8500_dma40_device;
 extern struct platform_device ux500_ske_keypad_device;
 
+extern struct prcmu_tcdm_map db8500_tcdm_map;
+extern struct prcmu_tcdm_map db9540_tcdm_map;
+
 #endif
diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index 5b90e94..55025ba 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -213,13 +213,18 @@ enum ddr_pwrst {
 	DDR_PWR_STATE_OFFHIGHLAT    = 0x03
 };
 
+struct prcmu_tcdm_map {
+	u32 tcdm_size;
+	u32 legacy_offset;
+};
+
 #include <linux/mfd/db8500-prcmu.h>
 
 #if defined(CONFIG_UX500_SOC_DB8500)
 
 #include <mach/id.h>
 
-static inline void __init prcmu_early_init(void)
+static inline void __init prcmu_early_init(struct prcmu_tcdm_map *map)
 {
 	return db8500_prcmu_early_init();
 }
@@ -438,7 +443,7 @@ static inline int prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
 }
 #else
 
-static inline void __init prcmu_early_init(void) {}
+static inline void __init prcmu_early_init(struct prcmu_tcdm_map *map) {}
 
 static inline int prcmu_set_power_state(u8 state, bool keep_ulp_clk,
 	bool keep_ap_pll)
-- 
1.7.11.1

