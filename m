Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab2JWGRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:17:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53760 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab2JWGRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:17:22 -0400
From: Kelvin Cheung <keguang.zhang@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org
Cc: mturquette@linaro.org, Kelvin Cheung <keguang.zhang@gmail.com>
Subject: [PATCH 1/4] MIPS: Loongson1B: use common clock infrastructure instead of private APIs
Date: Tue, 23 Oct 2012 14:17:00 +0800
Message-Id: <1350973023-7667-2-git-send-email-keguang.zhang@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1350973023-7667-1-git-send-email-keguang.zhang@gmail.com>
References: <1350973023-7667-1-git-send-email-keguang.zhang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common clock infrastructure instead of private APIs.
1. Enable COMMON_CLK in the Kconfig.
2. Remove private clock APIs, which are replaced by the code in
   drivers/clk/clk-ls1x.c.
3. Modify header file for drivers/clk/clk-ls1x.c.

Signed-off-by: Kelvin Cheung <keguang.zhang@gmail.com>
---
 arch/mips/include/asm/mach-loongson1/platform.h |    1 +
 arch/mips/include/asm/mach-loongson1/regs-clk.h |    7 +-
 arch/mips/loongson1/Kconfig                     |    2 +-
 arch/mips/loongson1/common/clock.c              |  157 +----------------------
 4 files changed, 8 insertions(+), 159 deletions(-)

diff --git a/arch/mips/include/asm/mach-loongson1/platform.h b/arch/mips/include/asm/mach-loongson1/platform.h
index 2f17161..f584017 100644
--- a/arch/mips/include/asm/mach-loongson1/platform.h
+++ b/arch/mips/include/asm/mach-loongson1/platform.h
@@ -18,6 +18,7 @@ extern struct platform_device ls1x_eth0_device;
 extern struct platform_device ls1x_ehci_device;
 extern struct platform_device ls1x_rtc_device;
 
+extern void __init ls1x_clk_init(void);
 void ls1x_serial_setup(void);
 
 #endif /* __ASM_MACH_LOONGSON1_PLATFORM_H */
diff --git a/arch/mips/include/asm/mach-loongson1/regs-clk.h b/arch/mips/include/asm/mach-loongson1/regs-clk.h
index 8efa7fb..a81fa3d 100644
--- a/arch/mips/include/asm/mach-loongson1/regs-clk.h
+++ b/arch/mips/include/asm/mach-loongson1/regs-clk.h
@@ -20,14 +20,15 @@
 
 /* Clock PLL Divisor Register Bits */
 #define DIV_DC_EN			(0x1 << 31)
-#define DIV_DC				(0x1f << 26)
 #define DIV_CPU_EN			(0x1 << 25)
-#define DIV_CPU				(0x1f << 20)
 #define DIV_DDR_EN			(0x1 << 19)
-#define DIV_DDR				(0x1f << 14)
 
 #define DIV_DC_SHIFT			26
 #define DIV_CPU_SHIFT			20
 #define DIV_DDR_SHIFT			14
 
+#define DIV_DC_WIDTH			5
+#define DIV_CPU_WIDTH			5
+#define DIV_DDR_WIDTH			5
+
 #endif /* __ASM_MACH_LOONGSON1_REGS_CLK_H */
diff --git a/arch/mips/loongson1/Kconfig b/arch/mips/loongson1/Kconfig
index a9a14d6..fbf75f6 100644
--- a/arch/mips/loongson1/Kconfig
+++ b/arch/mips/loongson1/Kconfig
@@ -15,7 +15,7 @@ config LOONGSON1_LS1B
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_SUPPORTS_HIGHMEM
 	select SYS_HAS_EARLY_PRINTK
-	select HAVE_CLK
+	select COMMON_CLK
 
 endchoice
 
diff --git a/arch/mips/loongson1/common/clock.c b/arch/mips/loongson1/common/clock.c
index 1bbbbec..7db0a6a 100644
--- a/arch/mips/loongson1/common/clock.c
+++ b/arch/mips/loongson1/common/clock.c
@@ -7,170 +7,17 @@
  * option) any later version.
  */
 
-#include <linux/module.h>
-#include <linux/list.h>
-#include <linux/mutex.h>
 #include <linux/clk.h>
 #include <linux/err.h>
-#include <asm/clock.h>
 #include <asm/time.h>
-
-#include <loongson1.h>
-
-static LIST_HEAD(clocks);
-static DEFINE_MUTEX(clocks_mutex);
-
-struct clk *clk_get(struct device *dev, const char *name)
-{
-	struct clk *c;
-	struct clk *ret = NULL;
-
-	mutex_lock(&clocks_mutex);
-	list_for_each_entry(c, &clocks, node) {
-		if (!strcmp(c->name, name)) {
-			ret = c;
-			break;
-		}
-	}
-	mutex_unlock(&clocks_mutex);
-
-	return ret;
-}
-EXPORT_SYMBOL(clk_get);
-
-int clk_enable(struct clk *clk)
-{
-	return 0;
-}
-EXPORT_SYMBOL(clk_enable);
-
-void clk_disable(struct clk *clk)
-{
-}
-EXPORT_SYMBOL(clk_disable);
-
-unsigned long clk_get_rate(struct clk *clk)
-{
-	return clk->rate;
-}
-EXPORT_SYMBOL(clk_get_rate);
-
-void clk_put(struct clk *clk)
-{
-}
-EXPORT_SYMBOL(clk_put);
-
-static void pll_clk_init(struct clk *clk)
-{
-	u32 pll;
-
-	pll = __raw_readl(LS1X_CLK_PLL_FREQ);
-	clk->rate = (12 + (pll & 0x3f)) * 33 / 2
-			+ ((pll >> 8) & 0x3ff) * 33 / 1024 / 2;
-	clk->rate *= 1000000;
-}
-
-static void cpu_clk_init(struct clk *clk)
-{
-	u32 pll, ctrl;
-
-	pll = clk_get_rate(clk->parent);
-	ctrl = __raw_readl(LS1X_CLK_PLL_DIV) & DIV_CPU;
-	clk->rate = pll / (ctrl >> DIV_CPU_SHIFT);
-}
-
-static void ddr_clk_init(struct clk *clk)
-{
-	u32 pll, ctrl;
-
-	pll = clk_get_rate(clk->parent);
-	ctrl = __raw_readl(LS1X_CLK_PLL_DIV) & DIV_DDR;
-	clk->rate = pll / (ctrl >> DIV_DDR_SHIFT);
-}
-
-static void dc_clk_init(struct clk *clk)
-{
-	u32 pll, ctrl;
-
-	pll = clk_get_rate(clk->parent);
-	ctrl = __raw_readl(LS1X_CLK_PLL_DIV) & DIV_DC;
-	clk->rate = pll / (ctrl >> DIV_DC_SHIFT);
-}
-
-static struct clk_ops pll_clk_ops = {
-	.init	= pll_clk_init,
-};
-
-static struct clk_ops cpu_clk_ops = {
-	.init	= cpu_clk_init,
-};
-
-static struct clk_ops ddr_clk_ops = {
-	.init	= ddr_clk_init,
-};
-
-static struct clk_ops dc_clk_ops = {
-	.init	= dc_clk_init,
-};
-
-static struct clk pll_clk = {
-	.name	= "pll",
-	.ops	= &pll_clk_ops,
-};
-
-static struct clk cpu_clk = {
-	.name	= "cpu",
-	.parent = &pll_clk,
-	.ops	= &cpu_clk_ops,
-};
-
-static struct clk ddr_clk = {
-	.name	= "ddr",
-	.parent = &pll_clk,
-	.ops	= &ddr_clk_ops,
-};
-
-static struct clk dc_clk = {
-	.name	= "dc",
-	.parent = &pll_clk,
-	.ops	= &dc_clk_ops,
-};
-
-int clk_register(struct clk *clk)
-{
-	mutex_lock(&clocks_mutex);
-	list_add(&clk->node, &clocks);
-	if (clk->ops->init)
-		clk->ops->init(clk);
-	mutex_unlock(&clocks_mutex);
-
-	return 0;
-}
-EXPORT_SYMBOL(clk_register);
-
-static struct clk *ls1x_clks[] = {
-	&pll_clk,
-	&cpu_clk,
-	&ddr_clk,
-	&dc_clk,
-};
-
-int __init ls1x_clock_init(void)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(ls1x_clks); i++)
-		clk_register(ls1x_clks[i]);
-
-	return 0;
-}
+#include <platform.h>
 
 void __init plat_time_init(void)
 {
 	struct clk *clk;
 
 	/* Initialize LS1X clocks */
-	ls1x_clock_init();
+	ls1x_clk_init();
 
 	/* setup mips r4k timer */
 	clk = clk_get(NULL, "cpu");
-- 
1.7.1

