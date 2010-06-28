Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0F1GqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 02:46:21 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:43438 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab0F1GqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 02:46:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GeBDNnFj1HzAhjaCa3VLV1PNJLW/qWzRZnPHkdqpPFMRnJMpz3j22icGOAT/kIpjOD
         Yo1hqvai1pQHIpfmvI9rzEHelogMZj8KVxkZSan0Ek/RAiN+qyN559F8mFre0A3S83jx
         8wqioGptTjOa3maEo9t1Ba2x9yAsDurZIsKYg=
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: Davide Bonfanti <davide.bonfanti@bticino.it>,
       Raffaele Recalcati <raffaele.recalcati@bticino.it>,
       Russell King <linux@arm.linux.org.uk>, Sekhar Nori <nsekhar@ti.com>,
       Cyril Chemparathy <cyril@ti.com>, Sandeep Paulraj <s-paulraj@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Miguel Aguilar <miguel.aguilar@ridgerun.com>,
       Thomas Koeller <thomas.koeller@baslerweb.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] DaVinci: dm365: Added clockout2 management and set_sysclk_rate
Date: Mon, 28 Jun 2010 08:46:22 +0200
Message-Id: <1277707582-3405-1-git-send-email-lamiaposta71@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Bonfanti <davide.bonfanti@bticino.it>

    Added also possibility to set sysclk frequency.

    Added possibility to set clockout2 frequency.
    Clockout2 is a child of pll1_sysclk9, because they have
    the same pll divisor.

    This patch has been developed against the
    http://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git
    git tree and tested on bmx board.

Signed-off-by: Davide Bonfanti <davide.bonfanti@bticino.it>
Signed-off-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
---
 arch/arm/mach-davinci/clock.c              |  113 +++++++++++++++++++++++++++-
 arch/arm/mach-davinci/clock.h              |   14 ++++
 arch/arm/mach-davinci/dm365.c              |   23 +++++-
 arch/arm/mach-davinci/include/mach/clock.h |    3 +
 4 files changed, 146 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-davinci/clock.c b/arch/arm/mach-davinci/clock.c
index 054c303..464c289 100644
--- a/arch/arm/mach-davinci/clock.c
+++ b/arch/arm/mach-davinci/clock.c
@@ -144,6 +144,69 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 }
 EXPORT_SYMBOL(clk_set_rate);
 
+int clkout2_set_rate(struct clk *clk, unsigned long rate)
+{
+	unsigned long flags;
+	int ret = -EINVAL;
+	int i, err, min_err, i_min_err;
+	u32 regval;
+	struct pll_data *pll;
+	struct clk *parent = clk;
+
+	if (clk == NULL || IS_ERR(clk))
+		return ret;
+	if (!cpu_is_davinci_dm365())
+		return -ENODEV;
+
+	while (parent->parent->parent)
+		parent = parent->parent;
+
+	parent = clk->parent;
+
+	if (parent == clk)
+		return -EPERM;
+
+	pll = parent->pll_data;
+	regval = __raw_readl(IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE +
+			PERI_CLKCTL));
+
+	i_min_err = min_err = INT_MAX;
+	for (i = 0x0F; i > 0; i--) {
+		if (clk->set_rate) {
+			ret = clk_set_rate(clk, rate * i) ;
+			err = clk_get_rate(clk) - rate * i;
+			if (abs(min_err) > abs(err)) {
+				min_err = err;
+				i_min_err = i;
+			}
+		}
+	}
+	i = i_min_err;
+	ret = clk->set_rate(clk, rate * i) ;
+
+	regval &= ~(0x0F << 3);
+	regval |= (i-1) << 3;
+	regval |= 1 << CLOCKOUT2EN;
+	__raw_writel(regval, IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE +
+			PERI_CLKCTL));
+	rate *= i;
+
+	spin_lock_irqsave(&clockfw_lock, flags);
+	if (ret == 0) {
+		if (clk->recalc)
+			clk->rate = clk->recalc(clk);
+		propagate_rate(clk);
+		regval &= ~(1 << CLOCKOUT2EN);
+		__raw_writel(regval, IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE +
+			PERI_CLKCTL));
+	} else
+		return -EINVAL;
+	spin_unlock_irqrestore(&clockfw_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(clkout2_set_rate);
+
 int clk_set_parent(struct clk *clk, struct clk *parent)
 {
 	unsigned long flags;
@@ -254,7 +317,15 @@ static unsigned long clk_sysclk_recalc(struct clk *clk)
 	u32 v, plldiv;
 	struct pll_data *pll;
 	unsigned long rate = clk->rate;
+	struct clk *parent = clk;
+
+	if (clk == NULL || IS_ERR(clk))
+		return -EINVAL;
+	while (parent->parent->parent)
+		parent = parent->parent;
 
+	if (parent == clk)
+		return -EPERM;
 	/* If this is the PLL base clock, no more calculations needed */
 	if (clk->pll_data)
 		return rate;
@@ -262,13 +333,13 @@ static unsigned long clk_sysclk_recalc(struct clk *clk)
 	if (WARN_ON(!clk->parent))
 		return rate;
 
-	rate = clk->parent->rate;
+	rate = parent->rate;
+
 
 	/* Otherwise, the parent must be a PLL */
-	if (WARN_ON(!clk->parent->pll_data))
+	if (WARN_ON(!parent->pll_data))
 		return rate;
-
-	pll = clk->parent->pll_data;
+	pll = parent->pll_data;
 
 	/* If pre-PLL, source clock is before the multiplier and divider(s) */
 	if (clk->flags & PRE_PLL)
@@ -286,6 +357,7 @@ static unsigned long clk_sysclk_recalc(struct clk *clk)
 
 	return rate;
 }
+EXPORT_SYMBOL(clk_sysclk_recalc);
 
 static unsigned long clk_leafclk_recalc(struct clk *clk)
 {
@@ -433,6 +505,39 @@ int davinci_set_pllrate(struct pll_data *pll, unsigned int prediv,
 }
 EXPORT_SYMBOL(davinci_set_pllrate);
 
+int set_sysclk_rate(struct clk *clk, unsigned long rate)
+{
+	u32 clk_freq_min, clk_freq_max, plldiv;
+	struct pll_data *pll;
+	struct clk *parent = clk;
+
+	while (parent->parent->parent)
+		parent = parent->parent;
+	if (parent == clk)
+		return -EPERM;
+
+	clk_freq_max = parent->rate;
+	pll = parent->pll_data;
+	if (clk->flags & PRE_PLL)
+		clk_freq_max = pll->input_rate;
+
+	if (!clk->div_reg)
+		return -EPERM;
+
+	clk_freq_min = clk_freq_max / 0x20;
+	if ((rate < clk_freq_min) || (rate > clk_freq_max))
+		return -EINVAL;
+
+	plldiv = clk_freq_max / rate ;
+	if ((clk_freq_max % rate) < (rate >> 1))
+		plldiv--;
+	__raw_writel(plldiv & 0x1F, pll->base + clk->div_reg);
+	__raw_writel(plldiv | 0x8000, pll->base + clk->div_reg);
+	clk->rate = rate;
+	return 0;
+}
+EXPORT_SYMBOL(set_sysclk_rate);
+
 int __init davinci_clk_init(struct clk_lookup *clocks)
   {
 	struct clk_lookup *c;
diff --git a/arch/arm/mach-davinci/clock.h b/arch/arm/mach-davinci/clock.h
index 01e3648..74ba65f 100644
--- a/arch/arm/mach-davinci/clock.h
+++ b/arch/arm/mach-davinci/clock.h
@@ -50,6 +50,11 @@
 #define PLLDIV_EN       BIT(15)
 #define PLLDIV_RATIO_MASK 0x1f
 
+#define PERI_CLKCTL	0x48
+#define CLOCKOUT2EN	2
+#define CLOCKOUT1EN	1
+#define CLOCKOUT0EN	0
+
 /*
  * OMAP-L138 system reference guide recommends a wait for 4 OSCIN/CLKIN
  * cycles to ensure that the PLLC has switched to bypass mode. Delay of 1us
@@ -95,6 +100,14 @@ struct clk {
 	struct list_head	childnode;	/* parent's child list node */
 	struct pll_data         *pll_data;
 	u32                     div_reg;
+/*
+	u32		sec_div_reg;
+	u32		sec_div_reg_max;
+	u32		sec_div_reg_shift;
+	u32		out_enable_reg;
+	u32		out_enable_bit;
+*/
+
 	unsigned long (*recalc) (struct clk *);
 	int (*set_rate) (struct clk *clk, unsigned long rate);
 	int (*round_rate) (struct clk *clk, unsigned long rate);
@@ -121,6 +134,7 @@ int davinci_set_pllrate(struct pll_data *pll, unsigned int prediv,
 
 extern struct platform_device davinci_wdt_device;
 extern void davinci_watchdog_reset(struct platform_device *);
+int set_sysclk_rate(struct clk *clk, unsigned long rate);
 
 #endif
 
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 42fd4a4..1e97c62 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -40,6 +40,15 @@
 #include "mux.h"
 
 #define DM365_REF_FREQ		24000000	/* 24 MHz on the DM365 EVM */
+#define PINMUX0		0x00
+#define PINMUX1		0x04
+#define PINMUX2		0x08
+#define PINMUX3		0x0c
+#define PINMUX4		0x10
+#define INTMUX		0x18
+#define EVTMUX		0x1c
+
+
 
 static struct pll_data pll1_data = {
 	.num		= 1,
@@ -124,6 +133,7 @@ static struct clk pll1_sysclk6 = {
 	.parent		= &pll1_clk,
 	.flags		= CLK_PLL,
 	.div_reg	= PLLDIV6,
+	.set_rate	= set_sysclk_rate,
 };
 
 static struct clk pll1_sysclk7 = {
@@ -147,6 +157,15 @@ static struct clk pll1_sysclk9 = {
 	.div_reg	= PLLDIV9,
 };
 
+static struct clk clkout2_clk = {
+	.name		= "clkout2",
+	.parent		= &pll1_sysclk9,
+	.flags		= CLK_PLL,
+	.div_reg	= PLLDIV9,
+	.set_rate       = set_sysclk_rate,
+};
+
+
 static struct clk pll2_clk = {
 	.name		= "pll2",
 	.parent		= &ref_clk,
@@ -421,6 +440,7 @@ static struct clk_lookup dm365_clks[] = {
 	CLK(NULL, "pll1_sysclk7", &pll1_sysclk7),
 	CLK(NULL, "pll1_sysclk8", &pll1_sysclk8),
 	CLK(NULL, "pll1_sysclk9", &pll1_sysclk9),
+	CLK(NULL, "clkout2", &clkout2_clk),
 	CLK(NULL, "pll2", &pll2_clk),
 	CLK(NULL, "pll2_aux", &pll2_aux_clk),
 	CLK(NULL, "clkout1", &clkout1_clk),
@@ -467,9 +487,6 @@ static struct clk_lookup dm365_clks[] = {
 
 /*----------------------------------------------------------------------*/
 
-#define INTMUX		0x18
-#define EVTMUX		0x1c
-
 
 static const struct mux_config dm365_pins[] = {
 #ifdef CONFIG_DAVINCI_MUX
diff --git a/arch/arm/mach-davinci/include/mach/clock.h b/arch/arm/mach-davinci/include/mach/clock.h
index a3b0402..4296080 100644
--- a/arch/arm/mach-davinci/include/mach/clock.h
+++ b/arch/arm/mach-davinci/include/mach/clock.h
@@ -18,4 +18,7 @@ struct clk;
 extern int clk_register(struct clk *clk);
 extern void clk_unregister(struct clk *clk);
 
+int clkout2_set_rate(struct clk *clk, unsigned long rate);
+
+
 #endif
-- 
1.7.0.4

