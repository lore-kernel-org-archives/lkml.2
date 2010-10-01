Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab0JAL6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:58:31 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:38970 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932148Ab0JAL62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:58:28 -0400
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Viresh Kumar <viresh.kumar@st.com>, shiraz.hashim@st.com,
        vipin.kumar@st.com, deepak.sikri@st.com, armando.visconti@st.com,
        vipulkumar.samar@st.com, rajeev-dlh.kumar@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com
Subject: [PATCH V2 56/69] ST SPEAr Clock Framework: Updating for single image solution
Date: Fri,  1 Oct 2010 17:26:16 +0530
Message-Id: <7a39285e2b281bae63cfebb7d3e76b2f91c9d0be.1285933332.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates different clk_lookup arrays for individual machines.
These lookup arrays will be registered only if that specific machine is
current machine.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/mach-spear13xx/clock.c          |   29 ++++++++++--
 arch/arm/mach-spear3xx/clock.c           |   75 +++++++++++++++++++-----------
 arch/arm/mach-spear6xx/clock.c           |    8 +++-
 arch/arm/plat-spear/clock.c              |    8 +---
 arch/arm/plat-spear/include/plat/clock.h |    2 +-
 5 files changed, 82 insertions(+), 40 deletions(-)

diff --git a/arch/arm/mach-spear13xx/clock.c b/arch/arm/mach-spear13xx/clock.c
index 75cd89c..0755e9f 100644
--- a/arch/arm/mach-spear13xx/clock.c
+++ b/arch/arm/mach-spear13xx/clock.c
@@ -1117,13 +1117,17 @@ static struct clk_lookup spear_clk_lookups[] = {
 	{.dev_id = "gpio1",		.clk = &gpio1_clk},
 	{.dev_id = "keyboard",		.clk = &kbd_clk},
 	{.dev_id = "wdt",		.clk = &wdt_clk},
+};
 
-	/* spear1300 machine specific clock structures */
+/* array of all spear 1300 clock lookups */
 #ifdef CONFIG_MACH_SPEAR1300
+static struct clk_lookup spear1300_clk_lookups[] = {
+};
 #endif
 
-	/* spear1310 machine specific clock structures */
+/* array of all spear 1310 clock lookups */
 #ifdef CONFIG_MACH_SPEAR1310
+static struct clk_lookup spear1310_clk_lookups[] = {
 	{.dev_id = "spear_can.0",	.clk = &can0_clk},
 	{.dev_id = "spear_can.1",	.clk = &can1_clk},
 	{.dev_id = "stmmaceth.1",	.clk = &gmac_ras1_clk},
@@ -1134,11 +1138,28 @@ static struct clk_lookup spear_clk_lookups[] = {
 	{.dev_id = "stmmacphy.2",	.clk = &gmac_phy2_clk},
 	{.dev_id = "stmmacphy.3",	.clk = &gmac_phy3_clk},
 	{.dev_id = "stmmacphy.4",	.clk = &gmac_phy4_clk},
-#endif
 };
+#endif
 
 /* machine clk init */
 void __init spear13xx_clk_init(void)
 {
-	clk_init(spear_clk_lookups, ARRAY_SIZE(spear_clk_lookups), &ddr_clk);
+	int i, cnt;
+	struct clk_lookup *lookups;
+
+	if (machine_is_spear1300()) {
+		cnt = ARRAY_SIZE(spear1300_clk_lookups);
+		lookups = spear1300_clk_lookups;
+	} else {
+		cnt = ARRAY_SIZE(spear1310_clk_lookups);
+		lookups = spear1310_clk_lookups;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(spear_clk_lookups); i++)
+		clk_register(&spear_clk_lookups[i]);
+
+	for (i = 0; i < cnt; i++)
+		clk_register(&lookups[i]);
+
+	clk_init(&ddr_clk);
 }
diff --git a/arch/arm/mach-spear3xx/clock.c b/arch/arm/mach-spear3xx/clock.c
index 814966a..ec34e50 100644
--- a/arch/arm/mach-spear3xx/clock.c
+++ b/arch/arm/mach-spear3xx/clock.c
@@ -13,6 +13,7 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <asm/mach-types.h>
 #include <mach/misc_regs.h>
 #include <plat/clock.h>
 
@@ -754,52 +755,72 @@ static struct clk_lookup spear_clk_lookups[] = {
 	{ .dev_id = "adc",		.clk = &adc_clk},
 	{ .dev_id = "ssp-pl022.0",	.clk = &ssp0_clk},
 	{ .dev_id = "gpio",		.clk = &gpio_clk},
-#if defined(CONFIG_MACH_SPEAR310) || defined(CONFIG_MACH_SPEAR320)
-	{ .dev_id = "emi",		.clk = &emi_clk},
-#endif
-#if defined(CONFIG_MACH_SPEAR300) || defined(CONFIG_MACH_SPEAR310) || \
-	defined(CONFIG_MACH_SPEAR320)
-	{ .con_id = "fsmc",		.clk = &fsmc_clk},
-#endif
-
-/* common clocks to spear310 and spear320 */
-#if defined(CONFIG_MACH_SPEAR310) || defined(CONFIG_MACH_SPEAR320)
-	{ .dev_id = "uart1",		.clk = &uart1_clk},
-	{ .dev_id = "uart2",		.clk = &uart2_clk},
-#endif
-
-	/* common clock to spear300 and spear320 */
-#if defined(CONFIG_MACH_SPEAR300) || defined(CONFIG_MACH_SPEAR320)
-	{ .dev_id = "clcd",		.clk = &clcd_clk},
-	{ .dev_id = "sdhci",		.clk = &sdhci_clk},
-#endif /* CONFIG_MACH_SPEAR300 || CONFIG_MACH_SPEAR320 */
+};
 
-	/* spear300 machine specific clock structures */
+/* array of all spear 300 clock lookups */
 #ifdef CONFIG_MACH_SPEAR300
+static struct clk_lookup spear300_clk_lookups[] = {
+	{ .dev_id = "clcd",		.clk = &clcd_clk},
+	{ .con_id = "fsmc",		.clk = &fsmc_clk},
 	{ .dev_id = "gpio1",		.clk = &gpio1_clk},
 	{ .dev_id = "keyboard",		.clk = &kbd_clk},
+	{ .dev_id = "sdhci",		.clk = &sdhci_clk},
+};
 #endif
 
-	/* spear310 machine specific clock structures */
+/* array of all spear 310 clock lookups */
 #ifdef CONFIG_MACH_SPEAR310
+static struct clk_lookup spear310_clk_lookups[] = {
+	{ .con_id = "fsmc",		.clk = &fsmc_clk},
+	{ .dev_id = "emi",		.clk = &emi_clk},
+	{ .dev_id = "uart1",		.clk = &uart1_clk},
+	{ .dev_id = "uart2",		.clk = &uart2_clk},
 	{ .dev_id = "uart3",		.clk = &uart3_clk},
 	{ .dev_id = "uart4",		.clk = &uart4_clk},
 	{ .dev_id = "uart5",		.clk = &uart5_clk},
-
+};
 #endif
-	/* spear320 machine specific clock structures */
+
+/* array of all spear 320 clock lookups */
 #ifdef CONFIG_MACH_SPEAR320
+static struct clk_lookup spear320_clk_lookups[] = {
+	{ .dev_id = "clcd",		.clk = &clcd_clk},
+	{ .con_id = "fsmc",		.clk = &fsmc_clk},
+	{ .dev_id = "i2c_designware.1",	.clk = &i2c1_clk},
+	{ .dev_id = "emi",		.clk = &emi_clk},
+	{ .dev_id = "pwm",		.clk = &pwm_clk},
+	{ .dev_id = "sdhci",		.clk = &sdhci_clk},
 	{ .dev_id = "spear_can.0",	.clk = &can0_clk},
 	{ .dev_id = "spear_can.1",	.clk = &can1_clk},
-	{ .dev_id = "i2c_designware.1",	.clk = &i2c1_clk},
 	{ .dev_id = "ssp-pl022.1",	.clk = &ssp1_clk},
 	{ .dev_id = "ssp-pl022.2",	.clk = &ssp2_clk},
-	{ .dev_id = "pwm",		.clk = &pwm_clk},
-#endif
+	{ .dev_id = "uart1",		.clk = &uart1_clk},
+	{ .dev_id = "uart2",		.clk = &uart2_clk},
 };
+#endif
 
 /* machine clk init */
 void __init spear3xx_clk_init(void)
 {
-	clk_init(spear_clk_lookups, ARRAY_SIZE(spear_clk_lookups), &ddr_clk);
+	int i, cnt;
+	struct clk_lookup *lookups;
+
+	if (machine_is_spear300()) {
+		cnt = ARRAY_SIZE(spear300_clk_lookups);
+		lookups = spear300_clk_lookups;
+	} else if (machine_is_spear310()) {
+		cnt = ARRAY_SIZE(spear310_clk_lookups);
+		lookups = spear310_clk_lookups;
+	} else {
+		cnt = ARRAY_SIZE(spear320_clk_lookups);
+		lookups = spear320_clk_lookups;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(spear_clk_lookups); i++)
+		clk_register(&spear_clk_lookups[i]);
+
+	for (i = 0; i < cnt; i++)
+		clk_register(&lookups[i]);
+
+	clk_init(&ddr_clk);
 }
diff --git a/arch/arm/mach-spear6xx/clock.c b/arch/arm/mach-spear6xx/clock.c
index 63aab69..fefbb1e 100644
--- a/arch/arm/mach-spear6xx/clock.c
+++ b/arch/arm/mach-spear6xx/clock.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <mach/misc_regs.h>
+#include <asm/mach-types.h>
 #include <plat/clock.h>
 
 /* root clks */
@@ -740,5 +741,10 @@ static struct clk_lookup spear_clk_lookups[] = {
 /* machine clk init */
 void __init spear6xx_clk_init(void)
 {
-	clk_init(spear_clk_lookups, ARRAY_SIZE(spear_clk_lookups), &ddr_clk);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(spear_clk_lookups); i++)
+		clk_register(&spear_clk_lookups[i]);
+
+	clk_init(&ddr_clk);
 }
diff --git a/arch/arm/plat-spear/clock.c b/arch/arm/plat-spear/clock.c
index ee8f82b..2043c34 100644
--- a/arch/arm/plat-spear/clock.c
+++ b/arch/arm/plat-spear/clock.c
@@ -949,14 +949,8 @@ void recalc_root_clocks(void)
 	spin_unlock_irqrestore(&clocks_lock, flags);
 }
 
-void __init
-clk_init(struct clk_lookup *clk_lookups, u32 count, struct clk *dclk)
+void __init clk_init(struct clk *dclk)
 {
-	int i;
-
-	for (i = 0; i < count; i++)
-		clk_register(&clk_lookups[i]);
-
 	recalc_root_clocks();
 
 	/* Mark all ancestors of DDR with special flag */
diff --git a/arch/arm/plat-spear/include/plat/clock.h b/arch/arm/plat-spear/include/plat/clock.h
index 00d6854..13ad461 100644
--- a/arch/arm/plat-spear/include/plat/clock.h
+++ b/arch/arm/plat-spear/include/plat/clock.h
@@ -241,7 +241,7 @@ struct ddr_rate_tbl {
  * Actually before changing rate of DDRs ancestor, we must put ddr in refresh
  * state and then change parent.
  */
-void clk_init(struct clk_lookup *clk_lookups, u32 count, struct clk *dclk);
+void clk_init(struct clk *dclk);
 void clk_register(struct clk_lookup *cl);
 void recalc_root_clocks(void);
 
-- 
1.7.2.2

