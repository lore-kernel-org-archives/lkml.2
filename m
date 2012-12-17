Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab2LQMJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 07:09:45 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4909 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab2LQMJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 07:09:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 17 Dec 2012 04:07:09 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/4] ARM: tegra30: Add support for Uart clock source divider as 15.1
Date: Mon, 17 Dec 2012 17:38:18 +0530
Message-ID: <1355746101-15291-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1355746101-15291-1-git-send-email-ldewangan@nvidia.com>
References: <1355746101-15291-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra20 uart clock source have the 15.1 clock divider in place of
7.1. Add support for 15.1 clock divider and change the uart clock divider
flag to DIV_U151.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/mach-tegra/clock.h               |    3 +-
 arch/arm/mach-tegra/tegra30_clocks.c      |   70 ++++++++++++++++++++++------
 arch/arm/mach-tegra/tegra30_clocks_data.c |   10 ++--
 3 files changed, 62 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-tegra/clock.h b/arch/arm/mach-tegra/clock.h
index 2aa37f5..26e9253 100644
--- a/arch/arm/mach-tegra/clock.h
+++ b/arch/arm/mach-tegra/clock.h
@@ -45,11 +45,12 @@
 #define PLLX                    (1 << 15)
 #define MUX_PWM                 (1 << 16)
 #define MUX8                    (1 << 17)
-#define DIV_U71_UART            (1 << 18)
+#define DIV_U151_UART           (1 << 18)
 #define MUX_CLK_OUT             (1 << 19)
 #define PLLM                    (1 << 20)
 #define DIV_U71_INT             (1 << 21)
 #define DIV_U71_IDLE            (1 << 22)
+#define DIV_U151                (1 << 23)
 #define ENABLE_ON_INIT		(1 << 28)
 #define PERIPH_ON_APB           (1 << 29)
 
diff --git a/arch/arm/mach-tegra/tegra30_clocks.c b/arch/arm/mach-tegra/tegra30_clocks.c
index d714777..795ea87 100644
--- a/arch/arm/mach-tegra/tegra30_clocks.c
+++ b/arch/arm/mach-tegra/tegra30_clocks.c
@@ -466,28 +466,45 @@ static unsigned long clk_measure_input_freq(void)
 	}
 }
 
-static int clk_div71_get_divider(unsigned long parent_rate, unsigned long rate,
-				 u32 flags, u32 round_mode)
+static int clk_div_x1_get_divider(unsigned long parent_rate, unsigned long rate,
+			u32 max_x, u32 flags, u32 round_mode)
 {
-	s64 divider_u71 = parent_rate;
+	s64 divider_ux1 = parent_rate;
+
 	if (!rate)
 		return -EINVAL;
 
 	if (!(flags & DIV_U71_INT))
-		divider_u71 *= 2;
+		divider_ux1 *= 2;
+
 	if (round_mode == ROUND_DIVIDER_UP)
-		divider_u71 += rate - 1;
-	do_div(divider_u71, rate);
+		divider_ux1 += rate - 1;
+	do_div(divider_ux1, rate);
+
 	if (flags & DIV_U71_INT)
-		divider_u71 *= 2;
+		divider_ux1 *= 2;
 
-	if (divider_u71 - 2 < 0)
+	if (divider_ux1 - 2 < 0)
 		return 0;
 
-	if (divider_u71 - 2 > 255)
+	if (divider_ux1 - 2 > max_x)
 		return -EINVAL;
 
-	return divider_u71 - 2;
+	return divider_ux1 - 2;
+}
+
+static int clk_div71_get_divider(unsigned long parent_rate, unsigned long rate,
+				 u32 flags, u32 round_mode)
+{
+	return clk_div_x1_get_divider(parent_rate, rate, 0xFF,
+			flags, round_mode);
+}
+
+static int clk_div151_get_divider(unsigned long parent_rate, unsigned long rate,
+				 u32 flags, u32 round_mode)
+{
+	return clk_div_x1_get_divider(parent_rate, rate, 0xFFFF,
+			flags, round_mode);
 }
 
 static int clk_div16_get_divider(unsigned long parent_rate, unsigned long rate)
@@ -1936,7 +1953,19 @@ static int tegra30_periph_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 			val = clk_readl(c->reg);
 			val &= ~PERIPH_CLK_SOURCE_DIVU71_MASK;
 			val |= divider;
-			if (c->flags & DIV_U71_UART) {
+			clk_writel_delay(val, c->reg);
+			c->div = divider + 2;
+			c->mul = 2;
+			return 0;
+		}
+	} else if (c->flags & DIV_U151) {
+		divider = clk_div151_get_divider(
+			parent_rate, rate, c->flags, ROUND_DIVIDER_UP);
+		if (divider >= 0) {
+			val = clk_readl(c->reg);
+			val &= ~PERIPH_CLK_SOURCE_DIVU16_MASK;
+			val |= divider;
+			if (c->flags & DIV_U151_UART) {
 				if (divider)
 					val |= PERIPH_CLK_UART_DIV_ENB;
 				else
@@ -1983,6 +2012,13 @@ static long tegra30_periph_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 			return divider;
 
 		return DIV_ROUND_UP(parent_rate * 2, divider + 2);
+	} else if (c->flags & DIV_U151) {
+		divider = clk_div151_get_divider(
+			parent_rate, rate, c->flags, ROUND_DIVIDER_UP);
+		if (divider < 0)
+			return divider;
+
+		return DIV_ROUND_UP(parent_rate * 2, divider + 2);
 	} else if (c->flags & DIV_U16) {
 		divider = clk_div16_get_divider(parent_rate, rate);
 		if (divider < 0)
@@ -2001,10 +2037,6 @@ static unsigned long tegra30_periph_clk_recalc_rate(struct clk_hw *hw,
 
 	if (c->flags & DIV_U71) {
 		u32 divu71 = val & PERIPH_CLK_SOURCE_DIVU71_MASK;
-		if ((c->flags & DIV_U71_UART) &&
-		    (!(val & PERIPH_CLK_UART_DIV_ENB))) {
-			divu71 = 0;
-		}
 		if (c->flags & DIV_U71_IDLE) {
 			val &= ~(PERIPH_CLK_SOURCE_DIVU71_MASK <<
 				PERIPH_CLK_SOURCE_DIVIDLE_SHIFT);
@@ -2014,6 +2046,14 @@ static unsigned long tegra30_periph_clk_recalc_rate(struct clk_hw *hw,
 		}
 		c->div = divu71 + 2;
 		c->mul = 2;
+	} else if (c->flags & DIV_U151) {
+		u32 divu151 = val & PERIPH_CLK_SOURCE_DIVU16_MASK;
+		if ((c->flags & DIV_U151_UART) &&
+		    (!(val & PERIPH_CLK_UART_DIV_ENB))) {
+			divu151 = 0;
+		}
+		c->div = divu151 + 2;
+		c->mul = 2;
 	} else if (c->flags & DIV_U16) {
 		u32 divu16 = val & PERIPH_CLK_SOURCE_DIVU16_MASK;
 		c->div = divu16 + 1;
diff --git a/arch/arm/mach-tegra/tegra30_clocks_data.c b/arch/arm/mach-tegra/tegra30_clocks_data.c
index 6942c7a..e2e6022 100644
--- a/arch/arm/mach-tegra/tegra30_clocks_data.c
+++ b/arch/arm/mach-tegra/tegra30_clocks_data.c
@@ -1120,11 +1120,11 @@ PERIPH_CLK(i2c2,	"tegra-i2c.1",		"div-clk", 54,	0x198,	26000000,  mux_pllp_clkm,
 PERIPH_CLK(i2c3,	"tegra-i2c.2",		"div-clk", 67,	0x1b8,	26000000,  mux_pllp_clkm,		MUX | DIV_U16 | PERIPH_ON_APB);
 PERIPH_CLK(i2c4,	"tegra-i2c.3",		"div-clk", 103,	0x3c4,	26000000,  mux_pllp_clkm,		MUX | DIV_U16 | PERIPH_ON_APB);
 PERIPH_CLK(i2c5,	"tegra-i2c.4",		"div-clk", 47,	0x128,	26000000,  mux_pllp_clkm,		MUX | DIV_U16 | PERIPH_ON_APB);
-PERIPH_CLK(uarta,	"tegra-uart.0",		NULL,	6,	0x178,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71 | DIV_U71_UART | PERIPH_ON_APB);
-PERIPH_CLK(uartb,	"tegra-uart.1",		NULL,	7,	0x17c,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71 | DIV_U71_UART | PERIPH_ON_APB);
-PERIPH_CLK(uartc,	"tegra-uart.2",		NULL,	55,	0x1a0,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71 | DIV_U71_UART | PERIPH_ON_APB);
-PERIPH_CLK(uartd,	"tegra-uart.3",		NULL,	65,	0x1c0,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71 | DIV_U71_UART | PERIPH_ON_APB);
-PERIPH_CLK(uarte,	"tegra-uart.4",		NULL,	66,	0x1c4,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71 | DIV_U71_UART | PERIPH_ON_APB);
+PERIPH_CLK(uarta,	"tegra-uart.0",		NULL,	6,	0x178,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U151 | DIV_U151_UART | PERIPH_ON_APB);
+PERIPH_CLK(uartb,	"tegra-uart.1",		NULL,	7,	0x17c,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U151 | DIV_U151_UART | PERIPH_ON_APB);
+PERIPH_CLK(uartc,	"tegra-uart.2",		NULL,	55,	0x1a0,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U151 | DIV_U151_UART | PERIPH_ON_APB);
+PERIPH_CLK(uartd,	"tegra-uart.3",		NULL,	65,	0x1c0,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U151 | DIV_U151_UART | PERIPH_ON_APB);
+PERIPH_CLK(uarte,	"tegra-uart.4",		NULL,	66,	0x1c4,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U151 | DIV_U151_UART | PERIPH_ON_APB);
 PERIPH_CLK(vi,		"tegra_camera",		"vi",	20,	0x148,	425000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71 | DIV_U71_INT);
 PERIPH_CLK(3d,		"3d",			NULL,	24,	0x158,	520000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71 | DIV_U71_INT | DIV_U71_IDLE | PERIPH_MANUAL_RESET);
 PERIPH_CLK(3d2,		"3d2",			NULL,	98,	0x3b0,	520000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71 | DIV_U71_INT | DIV_U71_IDLE | PERIPH_MANUAL_RESET);
-- 
1.7.1.1

