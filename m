Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab2KZRAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:00:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47061 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab2KZRAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:00:47 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gabor Juhos <juhosg@openwrt.org>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 017/270] MIPS: ath79: Fix CPU/DDR frequency calculation for SRIF PLLs
Date: Mon, 26 Nov 2012 14:55:07 -0200
Message-Id: <1353949160-26803-18-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <juhosg@openwrt.org>

commit 97541ccfb9db2bb9cd1dde6344d5834438d14bda upstream.

Besides the CPU and DDR PLLs, the CPU and DDR frequencies
can be derived from other PLLs in the SRIF block on the
AR934x SoCs. The current code does not checks if the SRIF
PLLs are used and this can lead to incorrectly calculated
CPU/DDR frequencies.

Fix it by calculating the frequencies from SRIF PLLs if
those are used on a given board.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/4324/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/mips/ath79/clock.c                        |  109 ++++++++++++++++++------
 arch/mips/include/asm/mach-ath79/ar71xx_regs.h |   23 +++++
 2 files changed, 104 insertions(+), 28 deletions(-)

diff --git a/arch/mips/ath79/clock.c b/arch/mips/ath79/clock.c
index d272857..579f452 100644
--- a/arch/mips/ath79/clock.c
+++ b/arch/mips/ath79/clock.c
@@ -17,6 +17,8 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 
+#include <asm/div64.h>
+
 #include <asm/mach-ath79/ath79.h>
 #include <asm/mach-ath79/ar71xx_regs.h>
 #include "common.h"
@@ -166,11 +168,34 @@ static void __init ar933x_clocks_init(void)
 	ath79_uart_clk.rate = ath79_ref_clk.rate;
 }
 
+static u32 __init ar934x_get_pll_freq(u32 ref, u32 ref_div, u32 nint, u32 nfrac,
+				      u32 frac, u32 out_div)
+{
+	u64 t;
+	u32 ret;
+
+	t = ath79_ref_clk.rate;
+	t *= nint;
+	do_div(t, ref_div);
+	ret = t;
+
+	t = ath79_ref_clk.rate;
+	t *= nfrac;
+	do_div(t, ref_div * frac);
+	ret += t;
+
+	ret /= (1 << out_div);
+	return ret;
+}
+
 static void __init ar934x_clocks_init(void)
 {
-	u32 pll, out_div, ref_div, nint, frac, clk_ctrl, postdiv;
+	u32 pll, out_div, ref_div, nint, nfrac, frac, clk_ctrl, postdiv;
 	u32 cpu_pll, ddr_pll;
 	u32 bootstrap;
+	void __iomem *dpll_base;
+
+	dpll_base = ioremap(AR934X_SRIF_BASE, AR934X_SRIF_SIZE);
 
 	bootstrap = ath79_reset_rr(AR934X_RESET_REG_BOOTSTRAP);
 	if (bootstrap &	AR934X_BOOTSTRAP_REF_CLK_40)
@@ -178,33 +203,59 @@ static void __init ar934x_clocks_init(void)
 	else
 		ath79_ref_clk.rate = 25 * 1000 * 1000;
 
-	pll = ath79_pll_rr(AR934X_PLL_CPU_CONFIG_REG);
-	out_div = (pll >> AR934X_PLL_CPU_CONFIG_OUTDIV_SHIFT) &
-		  AR934X_PLL_CPU_CONFIG_OUTDIV_MASK;
-	ref_div = (pll >> AR934X_PLL_CPU_CONFIG_REFDIV_SHIFT) &
-		  AR934X_PLL_CPU_CONFIG_REFDIV_MASK;
-	nint = (pll >> AR934X_PLL_CPU_CONFIG_NINT_SHIFT) &
-	       AR934X_PLL_CPU_CONFIG_NINT_MASK;
-	frac = (pll >> AR934X_PLL_CPU_CONFIG_NFRAC_SHIFT) &
-	       AR934X_PLL_CPU_CONFIG_NFRAC_MASK;
-
-	cpu_pll = nint * ath79_ref_clk.rate / ref_div;
-	cpu_pll += frac * ath79_ref_clk.rate / (ref_div * (1 << 6));
-	cpu_pll /= (1 << out_div);
-
-	pll = ath79_pll_rr(AR934X_PLL_DDR_CONFIG_REG);
-	out_div = (pll >> AR934X_PLL_DDR_CONFIG_OUTDIV_SHIFT) &
-		  AR934X_PLL_DDR_CONFIG_OUTDIV_MASK;
-	ref_div = (pll >> AR934X_PLL_DDR_CONFIG_REFDIV_SHIFT) &
-		  AR934X_PLL_DDR_CONFIG_REFDIV_MASK;
-	nint = (pll >> AR934X_PLL_DDR_CONFIG_NINT_SHIFT) &
-	       AR934X_PLL_DDR_CONFIG_NINT_MASK;
-	frac = (pll >> AR934X_PLL_DDR_CONFIG_NFRAC_SHIFT) &
-	       AR934X_PLL_DDR_CONFIG_NFRAC_MASK;
-
-	ddr_pll = nint * ath79_ref_clk.rate / ref_div;
-	ddr_pll += frac * ath79_ref_clk.rate / (ref_div * (1 << 10));
-	ddr_pll /= (1 << out_div);
+	pll = __raw_readl(dpll_base + AR934X_SRIF_CPU_DPLL2_REG);
+	if (pll & AR934X_SRIF_DPLL2_LOCAL_PLL) {
+		out_div = (pll >> AR934X_SRIF_DPLL2_OUTDIV_SHIFT) &
+			  AR934X_SRIF_DPLL2_OUTDIV_MASK;
+		pll = __raw_readl(dpll_base + AR934X_SRIF_CPU_DPLL1_REG);
+		nint = (pll >> AR934X_SRIF_DPLL1_NINT_SHIFT) &
+		       AR934X_SRIF_DPLL1_NINT_MASK;
+		nfrac = pll & AR934X_SRIF_DPLL1_NFRAC_MASK;
+		ref_div = (pll >> AR934X_SRIF_DPLL1_REFDIV_SHIFT) &
+			  AR934X_SRIF_DPLL1_REFDIV_MASK;
+		frac = 1 << 18;
+	} else {
+		pll = ath79_pll_rr(AR934X_PLL_CPU_CONFIG_REG);
+		out_div = (pll >> AR934X_PLL_CPU_CONFIG_OUTDIV_SHIFT) &
+			AR934X_PLL_CPU_CONFIG_OUTDIV_MASK;
+		ref_div = (pll >> AR934X_PLL_CPU_CONFIG_REFDIV_SHIFT) &
+			  AR934X_PLL_CPU_CONFIG_REFDIV_MASK;
+		nint = (pll >> AR934X_PLL_CPU_CONFIG_NINT_SHIFT) &
+		       AR934X_PLL_CPU_CONFIG_NINT_MASK;
+		nfrac = (pll >> AR934X_PLL_CPU_CONFIG_NFRAC_SHIFT) &
+			AR934X_PLL_CPU_CONFIG_NFRAC_MASK;
+		frac = 1 << 6;
+	}
+
+	cpu_pll = ar934x_get_pll_freq(ath79_ref_clk.rate, ref_div, nint,
+				      nfrac, frac, out_div);
+
+	pll = __raw_readl(dpll_base + AR934X_SRIF_DDR_DPLL2_REG);
+	if (pll & AR934X_SRIF_DPLL2_LOCAL_PLL) {
+		out_div = (pll >> AR934X_SRIF_DPLL2_OUTDIV_SHIFT) &
+			  AR934X_SRIF_DPLL2_OUTDIV_MASK;
+		pll = __raw_readl(dpll_base + AR934X_SRIF_DDR_DPLL1_REG);
+		nint = (pll >> AR934X_SRIF_DPLL1_NINT_SHIFT) &
+		       AR934X_SRIF_DPLL1_NINT_MASK;
+		nfrac = pll & AR934X_SRIF_DPLL1_NFRAC_MASK;
+		ref_div = (pll >> AR934X_SRIF_DPLL1_REFDIV_SHIFT) &
+			  AR934X_SRIF_DPLL1_REFDIV_MASK;
+		frac = 1 << 18;
+	} else {
+		pll = ath79_pll_rr(AR934X_PLL_DDR_CONFIG_REG);
+		out_div = (pll >> AR934X_PLL_DDR_CONFIG_OUTDIV_SHIFT) &
+			  AR934X_PLL_DDR_CONFIG_OUTDIV_MASK;
+		ref_div = (pll >> AR934X_PLL_DDR_CONFIG_REFDIV_SHIFT) &
+			   AR934X_PLL_DDR_CONFIG_REFDIV_MASK;
+		nint = (pll >> AR934X_PLL_DDR_CONFIG_NINT_SHIFT) &
+		       AR934X_PLL_DDR_CONFIG_NINT_MASK;
+		nfrac = (pll >> AR934X_PLL_DDR_CONFIG_NFRAC_SHIFT) &
+			AR934X_PLL_DDR_CONFIG_NFRAC_MASK;
+		frac = 1 << 10;
+	}
+
+	ddr_pll = ar934x_get_pll_freq(ath79_ref_clk.rate, ref_div, nint,
+				      nfrac, frac, out_div);
 
 	clk_ctrl = ath79_pll_rr(AR934X_PLL_CPU_DDR_CLK_CTRL_REG);
 
@@ -240,6 +291,8 @@ static void __init ar934x_clocks_init(void)
 
 	ath79_wdt_clk.rate = ath79_ref_clk.rate;
 	ath79_uart_clk.rate = ath79_ref_clk.rate;
+
+	iounmap(dpll_base);
 }
 
 void __init ath79_clocks_init(void)
diff --git a/arch/mips/include/asm/mach-ath79/ar71xx_regs.h b/arch/mips/include/asm/mach-ath79/ar71xx_regs.h
index 1caa78a..b682422 100644
--- a/arch/mips/include/asm/mach-ath79/ar71xx_regs.h
+++ b/arch/mips/include/asm/mach-ath79/ar71xx_regs.h
@@ -63,6 +63,8 @@
 
 #define AR934X_WMAC_BASE	(AR71XX_APB_BASE + 0x00100000)
 #define AR934X_WMAC_SIZE	0x20000
+#define AR934X_SRIF_BASE	(AR71XX_APB_BASE + 0x00116000)
+#define AR934X_SRIF_SIZE	0x1000
 
 /*
  * DDR_CTRL block
@@ -398,4 +400,25 @@
 #define AR933X_GPIO_COUNT		30
 #define AR934X_GPIO_COUNT		23
 
+/*
+ * SRIF block
+ */
+#define AR934X_SRIF_CPU_DPLL1_REG	0x1c0
+#define AR934X_SRIF_CPU_DPLL2_REG	0x1c4
+#define AR934X_SRIF_CPU_DPLL3_REG	0x1c8
+
+#define AR934X_SRIF_DDR_DPLL1_REG	0x240
+#define AR934X_SRIF_DDR_DPLL2_REG	0x244
+#define AR934X_SRIF_DDR_DPLL3_REG	0x248
+
+#define AR934X_SRIF_DPLL1_REFDIV_SHIFT	27
+#define AR934X_SRIF_DPLL1_REFDIV_MASK	0x1f
+#define AR934X_SRIF_DPLL1_NINT_SHIFT	18
+#define AR934X_SRIF_DPLL1_NINT_MASK	0x1ff
+#define AR934X_SRIF_DPLL1_NFRAC_MASK	0x0003ffff
+
+#define AR934X_SRIF_DPLL2_LOCAL_PLL	BIT(30)
+#define AR934X_SRIF_DPLL2_OUTDIV_SHIFT	13
+#define AR934X_SRIF_DPLL2_OUTDIV_MASK	0x7
+
 #endif /* __ASM_MACH_AR71XX_REGS_H */
-- 
1.7.9.5

