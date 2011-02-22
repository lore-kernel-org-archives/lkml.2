Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab1BVXds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 18:33:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58137 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab1BVXdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 18:33:46 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jeremy Kerr <jeremy.kerr@canonical.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] wip: convert imx27 to common struct clk
Date: Wed, 23 Feb 2011 00:33:19 +0100
Message-Id: <1298417599-23522-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1298256658.861611.43913489619.0.gpush@pororo>
References: <1298256658.861611.43913489619.0.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

on top of .38-rc6 + making the clk_{un,}prepare stubs static inline,
this patch makes use of Jeremy's common struct clk (v13) on a i.MX27 based
machine.

This is compile tested using mx21_defconfig and runtime tested using
mx27_defconfig.

I had to degrade one WARN_ON to WARN_ON_ONCE in drivers/clk/clk.c to
actually make it work.  Otherwise console output results in a warning
that results in console output ...

Best regards
Uwe

 arch/arm/mach-imx/Kconfig               |    1 +
 arch/arm/mach-imx/clock-imx27.c         |  186 ++++++++++++++++--------------
 arch/arm/plat-mxc/clock.c               |  127 +++++++++++++++++++++
 arch/arm/plat-mxc/include/mach/clkdev.h |    4 +
 arch/arm/plat-mxc/include/mach/clock.h  |   32 ++++--
 drivers/clk/clk.c                       |    2 +-
 6 files changed, 255 insertions(+), 97 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 56684b5..f2d3708 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -30,6 +30,7 @@ config SOC_IMX27
 	select IMX_HAVE_DMA_V1
 	select IMX_HAVE_IOMUX_V1
 	select MXC_AVIC
+	select USE_COMMON_STRUCT_CLK
 
 if ARCH_MX1
 
diff --git a/arch/arm/mach-imx/clock-imx27.c b/arch/arm/mach-imx/clock-imx27.c
index 583f251..f413f7b 100644
--- a/arch/arm/mach-imx/clock-imx27.c
+++ b/arch/arm/mach-imx/clock-imx27.c
@@ -68,35 +68,35 @@
 #define CCM_SPCTL1_LF           (1 << 15)
 #define CCM_SPCTL1_BRMO         (1 << 6)
 
-static struct clk mpll_main1_clk, mpll_main2_clk;
+static struct clk_mxc mpll_main1_clk, mpll_main2_clk;
 
-static int clk_pccr_enable(struct clk *clk)
+static int clk_pccr_enable(struct clk_mxc *clk_mxc)
 {
 	unsigned long reg;
 
-	if (!clk->enable_reg)
+	if (!clk_mxc->enable_reg)
 		return 0;
 
-	reg = __raw_readl(clk->enable_reg);
-	reg |= 1 << clk->enable_shift;
-	__raw_writel(reg, clk->enable_reg);
+	reg = __raw_readl(clk_mxc->enable_reg);
+	reg |= 1 << clk_mxc->enable_shift;
+	__raw_writel(reg, clk_mxc->enable_reg);
 
 	return 0;
 }
 
-static void clk_pccr_disable(struct clk *clk)
+static void clk_pccr_disable(struct clk_mxc *clk_mxc)
 {
 	unsigned long reg;
 
-	if (!clk->enable_reg)
+	if (!clk_mxc->enable_reg)
 		return;
 
-	reg = __raw_readl(clk->enable_reg);
-	reg &= ~(1 << clk->enable_shift);
-	__raw_writel(reg, clk->enable_reg);
+	reg = __raw_readl(clk_mxc->enable_reg);
+	reg &= ~(1 << clk_mxc->enable_shift);
+	__raw_writel(reg, clk_mxc->enable_reg);
 }
 
-static int clk_spll_enable(struct clk *clk)
+static int clk_spll_enable(struct clk_mxc *clk_mxc)
 {
 	unsigned long reg;
 
@@ -109,7 +109,7 @@ static int clk_spll_enable(struct clk *clk)
 	return 0;
 }
 
-static void clk_spll_disable(struct clk *clk)
+static void clk_spll_disable(struct clk_mxc *clk_mxc)
 {
 	unsigned long reg;
 
@@ -118,11 +118,11 @@ static void clk_spll_disable(struct clk *clk)
 	__raw_writel(reg, CCM_CSCR);
 }
 
-static int clk_cpu_set_parent(struct clk *clk, struct clk *parent)
+static int clk_cpu_set_parent(struct clk_mxc *clk_mxc, struct clk_mxc *parent)
 {
 	int cscr = __raw_readl(CCM_CSCR);
 
-	if (clk->parent == parent)
+	if (clk_mxc->parent == parent)
 		return 0;
 
 	if (mx27_revision() >= IMX_CHIP_REVISION_2_0) {
@@ -135,18 +135,18 @@ static int clk_cpu_set_parent(struct clk *clk, struct clk *parent)
 				return -EINVAL;
 		}
 		__raw_writel(cscr, CCM_CSCR);
-		clk->parent = parent;
+		clk_mxc->parent = parent;
 		return 0;
 	}
 	return -ENODEV;
 }
 
-static unsigned long round_rate_cpu(struct clk *clk, unsigned long rate)
+static unsigned long round_rate_cpu(struct clk_mxc *clk_mxc, unsigned long rate)
 {
 	int div;
 	unsigned long parent_rate;
 
-	parent_rate = clk_get_rate(clk->parent);
+	parent_rate = clk_get_rate(&clk_mxc->parent->clk);
 
 	div = parent_rate / rate;
 	if (parent_rate % rate)
@@ -158,13 +158,13 @@ static unsigned long round_rate_cpu(struct clk *clk, unsigned long rate)
 	return parent_rate / div;
 }
 
-static int set_rate_cpu(struct clk *clk, unsigned long rate)
+static int set_rate_cpu(struct clk_mxc *clk_mxc, unsigned long rate)
 {
 	unsigned int div;
 	uint32_t reg;
 	unsigned long parent_rate;
 
-	parent_rate = clk_get_rate(clk->parent);
+	parent_rate = clk_get_rate(&clk_mxc->parent->clk);
 
 	div = parent_rate / rate;
 
@@ -186,12 +186,12 @@ static int set_rate_cpu(struct clk *clk, unsigned long rate)
 	return 0;
 }
 
-static unsigned long round_rate_per(struct clk *clk, unsigned long rate)
+static unsigned long round_rate_per(struct clk_mxc *clk_mxc, unsigned long rate)
 {
 	u32 div;
 	unsigned long parent_rate;
 
-	parent_rate = clk_get_rate(clk->parent);
+	parent_rate = clk_get_rate(&clk_mxc->parent->clk);
 
 	div = parent_rate / rate;
 	if (parent_rate % rate)
@@ -203,15 +203,15 @@ static unsigned long round_rate_per(struct clk *clk, unsigned long rate)
 	return parent_rate / div;
 }
 
-static int set_rate_per(struct clk *clk, unsigned long rate)
+static int set_rate_per(struct clk_mxc *clk_mxc, unsigned long rate)
 {
 	u32 reg;
 	u32 div;
 	unsigned long parent_rate;
 
-	parent_rate = clk_get_rate(clk->parent);
+	parent_rate = clk_get_rate(&clk_mxc->parent->clk);
 
-	if (clk->id < 0 || clk->id > 3)
+	if (clk_mxc->id < 0 || clk_mxc->id > 3)
 		return -EINVAL;
 
 	div = parent_rate / rate;
@@ -219,30 +219,30 @@ static int set_rate_per(struct clk *clk, unsigned long rate)
 		return -EINVAL;
 	div--;
 
-	reg = __raw_readl(CCM_PCDR1) & ~(0x3f << (clk->id << 3));
-	reg |= div << (clk->id << 3);
+	reg = __raw_readl(CCM_PCDR1) & ~(0x3f << (clk_mxc->id << 3));
+	reg |= div << (clk_mxc->id << 3);
 	__raw_writel(reg, CCM_PCDR1);
 
 	return 0;
 }
 
-static unsigned long get_rate_usb(struct clk *clk)
+static unsigned long get_rate_usb(struct clk_mxc *clk_mxc)
 {
 	unsigned long usb_pdf;
 	unsigned long parent_rate;
 
-	parent_rate = clk_get_rate(clk->parent);
+	parent_rate = clk_get_rate(&clk_mxc->parent->clk);
 
 	usb_pdf = (__raw_readl(CCM_CSCR) >> 28) & 0x7;
 
 	return parent_rate / (usb_pdf + 1U);
 }
 
-static unsigned long get_rate_ssix(struct clk *clk, unsigned long pdf)
+static unsigned long get_rate_ssix(struct clk_mxc *clk_mxc, unsigned long pdf)
 {
 	unsigned long parent_rate;
 
-	parent_rate = clk_get_rate(clk->parent);
+	parent_rate = clk_get_rate(&clk_mxc->parent->clk);
 
 	if (mx27_revision() >= IMX_CHIP_REVISION_2_0)
 		pdf += 4;  /* MX27 TO2+ */
@@ -252,22 +252,22 @@ static unsigned long get_rate_ssix(struct clk *clk, unsigned long pdf)
 	return 2UL * parent_rate / pdf;
 }
 
-static unsigned long get_rate_ssi1(struct clk *clk)
+static unsigned long get_rate_ssi1(struct clk_mxc *clk_mxc)
 {
-	return get_rate_ssix(clk, (__raw_readl(CCM_PCDR0) >> 16) & 0x3f);
+	return get_rate_ssix(clk_mxc, (__raw_readl(CCM_PCDR0) >> 16) & 0x3f);
 }
 
-static unsigned long get_rate_ssi2(struct clk *clk)
+static unsigned long get_rate_ssi2(struct clk_mxc *clk_mxc)
 {
-	return get_rate_ssix(clk, (__raw_readl(CCM_PCDR0) >> 26) & 0x3f);
+	return get_rate_ssix(clk_mxc, (__raw_readl(CCM_PCDR0) >> 26) & 0x3f);
 }
 
-static unsigned long get_rate_nfc(struct clk *clk)
+static unsigned long get_rate_nfc(struct clk_mxc *clk_mxc)
 {
 	unsigned long nfc_pdf;
 	unsigned long parent_rate;
 
-	parent_rate = clk_get_rate(clk->parent);
+	parent_rate = clk_get_rate(&clk_mxc->parent->clk);
 
 	if (mx27_revision() >= IMX_CHIP_REVISION_2_0)
 		nfc_pdf = (__raw_readl(CCM_PCDR0) >> 6) & 0xf;
@@ -277,12 +277,12 @@ static unsigned long get_rate_nfc(struct clk *clk)
 	return parent_rate / (nfc_pdf + 1);
 }
 
-static unsigned long get_rate_vpu(struct clk *clk)
+static unsigned long get_rate_vpu(struct clk_mxc *clk_mxc)
 {
 	unsigned long vpu_pdf;
 	unsigned long parent_rate;
 
-	parent_rate = clk_get_rate(clk->parent);
+	parent_rate = clk_get_rate(&clk_mxc->parent->clk);
 
 	if (mx27_revision() >= IMX_CHIP_REVISION_2_0) {
 		vpu_pdf = (__raw_readl(CCM_PCDR0) >> 10) & 0x3f;
@@ -295,25 +295,25 @@ static unsigned long get_rate_vpu(struct clk *clk)
 	return 2UL * parent_rate / vpu_pdf;
 }
 
-static unsigned long round_rate_parent(struct clk *clk, unsigned long rate)
+static unsigned long round_rate_parent(struct clk_mxc *clk_mxc, unsigned long rate)
 {
-	return clk->parent->round_rate(clk->parent, rate);
+	return clk_round_rate(&clk_mxc->parent->clk, rate);
 }
 
-static unsigned long get_rate_parent(struct clk *clk)
+static unsigned long get_rate_parent(struct clk_mxc *clk_mxc)
 {
-	return clk_get_rate(clk->parent);
+	return clk_get_rate(&clk_mxc->parent->clk);
 }
 
-static int set_rate_parent(struct clk *clk, unsigned long rate)
+static int set_rate_parent(struct clk_mxc *clk_mxc, unsigned long rate)
 {
-	return clk->parent->set_rate(clk->parent, rate);
+	return clk_set_rate(&clk_mxc->parent->clk, rate);
 }
 
 /* in Hz */
 static unsigned long external_high_reference = 26000000;
 
-static unsigned long get_rate_high_reference(struct clk *clk)
+static unsigned long get_rate_high_reference(struct clk_mxc *clk)
 {
 	return external_high_reference;
 }
@@ -321,44 +321,44 @@ static unsigned long get_rate_high_reference(struct clk *clk)
 /* in Hz */
 static unsigned long external_low_reference = 32768;
 
-static unsigned long get_rate_low_reference(struct clk *clk)
+static unsigned long get_rate_low_reference(struct clk_mxc *clk_mxc)
 {
 	return external_low_reference;
 }
 
-static unsigned long get_rate_fpm(struct clk *clk)
+static unsigned long get_rate_fpm(struct clk_mxc *clk_mxc)
 {
-	return clk_get_rate(clk->parent) * 1024;
+	return clk_get_rate(&clk_mxc->parent->clk) * 1024;
 }
 
-static unsigned long get_rate_mpll(struct clk *clk)
+static unsigned long get_rate_mpll(struct clk_mxc *clk_mxc)
 {
 	return mxc_decode_pll(__raw_readl(CCM_MPCTL0),
-			clk_get_rate(clk->parent));
+			clk_get_rate(&clk_mxc->parent->clk));
 }
 
-static unsigned long get_rate_mpll_main(struct clk *clk)
+static unsigned long get_rate_mpll_main(struct clk_mxc *clk_mxc)
 {
 	unsigned long parent_rate;
 
-	parent_rate = clk_get_rate(clk->parent);
+	parent_rate = clk_get_rate(&clk_mxc->parent->clk);
 
 	/* i.MX27 TO2:
 	 * clk->id == 0: arm clock source path 1 which is from 2 * MPLL / 2
 	 * clk->id == 1: arm clock source path 2 which is from 2 * MPLL / 3
 	 */
-	if (mx27_revision() >= IMX_CHIP_REVISION_2_0 && clk->id == 1)
+	if (mx27_revision() >= IMX_CHIP_REVISION_2_0 && clk_mxc->id == 1)
 		return 2UL * parent_rate / 3UL;
 
 	return parent_rate;
 }
 
-static unsigned long get_rate_spll(struct clk *clk)
+static unsigned long get_rate_spll(struct clk_mxc *clk_mxc)
 {
 	uint32_t reg;
 	unsigned long rate;
 
-	rate = clk_get_rate(clk->parent);
+	rate = clk_get_rate(&clk_mxc->parent->clk);
 
 	reg = __raw_readl(CCM_SPCTL0);
 
@@ -371,7 +371,7 @@ static unsigned long get_rate_spll(struct clk *clk)
 	return mxc_decode_pll(reg, rate);
 }
 
-static unsigned long get_rate_cpu(struct clk *clk)
+static unsigned long get_rate_cpu(struct clk_mxc *clk_mxc)
 {
 	u32 div;
 	unsigned long rate;
@@ -381,11 +381,11 @@ static unsigned long get_rate_cpu(struct clk *clk)
 	else
 		div = (__raw_readl(CCM_CSCR) >> 13) & 0x7;
 
-	rate = clk_get_rate(clk->parent);
+	rate = clk_get_rate(&clk_mxc->parent->clk);
 	return rate / (div + 1);
 }
 
-static unsigned long get_rate_ahb(struct clk *clk)
+static unsigned long get_rate_ahb(struct clk_mxc *clk_mxc)
 {
 	unsigned long rate, bclk_pdf;
 
@@ -394,33 +394,33 @@ static unsigned long get_rate_ahb(struct clk *clk)
 	else
 		bclk_pdf = (__raw_readl(CCM_CSCR) >> 9) & 0xf;
 
-	rate = clk_get_rate(clk->parent);
+	rate = clk_get_rate(&clk_mxc->parent->clk);
 	return rate / (bclk_pdf + 1);
 }
 
-static unsigned long get_rate_ipg(struct clk *clk)
+static unsigned long get_rate_ipg(struct clk_mxc *clk_mxc)
 {
 	unsigned long rate, ipg_pdf;
 
 	if (mx27_revision() >= IMX_CHIP_REVISION_2_0)
-		return clk_get_rate(clk->parent);
+		return clk_get_rate(&clk_mxc->parent->clk);
 	else
 		ipg_pdf = (__raw_readl(CCM_CSCR) >> 8) & 1;
 
-	rate = clk_get_rate(clk->parent);
+	rate = clk_get_rate(&clk_mxc->parent->clk);
 	return rate / (ipg_pdf + 1);
 }
 
-static unsigned long get_rate_per(struct clk *clk)
+static unsigned long get_rate_per(struct clk_mxc *clk_mxc)
 {
 	unsigned long perclk_pdf, parent_rate;
 
-	parent_rate = clk_get_rate(clk->parent);
+	parent_rate = clk_get_rate(&clk_mxc->parent->clk);
 
-	if (clk->id < 0 || clk->id > 3)
+	if (clk_mxc->id < 0 || clk_mxc->id > 3)
 		return 0;
 
-	perclk_pdf = (__raw_readl(CCM_PCDR1) >> (clk->id << 3)) & 0x3f;
+	perclk_pdf = (__raw_readl(CCM_PCDR1) >> (clk_mxc->id << 3)) & 0x3f;
 
 	return parent_rate / (perclk_pdf + 1);
 }
@@ -430,11 +430,13 @@ static unsigned long get_rate_per(struct clk *clk)
  * Default case is 26MHz. Could be changed at runtime
  * with a call to change_external_high_reference()
  */
-static struct clk ckih_clk = {
+static struct clk_mxc ckih_clk = {
+	.clk = INIT_CLK_MXC(ckih_clk),
 	.get_rate	= get_rate_high_reference,
 };
 
-static struct clk mpll_clk = {
+static struct clk_mxc mpll_clk = {
+	.clk = INIT_CLK_MXC(mpll_clk),
 	.parent		= &ckih_clk,
 	.get_rate	= get_rate_mpll,
 };
@@ -442,7 +444,8 @@ static struct clk mpll_clk = {
 /* For i.MX27 TO2, it is the MPLL path 1 of ARM core
  * It provides the clock source whose rate is same as MPLL
  */
-static struct clk mpll_main1_clk = {
+static struct clk_mxc mpll_main1_clk = {
+	.clk = INIT_CLK_MXC(mpll_main1_clk),
 	.id		= 0,
 	.parent		= &mpll_clk,
 	.get_rate	= get_rate_mpll_main,
@@ -451,23 +454,27 @@ static struct clk mpll_main1_clk = {
 /* For i.MX27 TO2, it is the MPLL path 2 of ARM core
  * It provides the clock source whose rate is same MPLL * 2 / 3
  */
-static struct clk mpll_main2_clk = {
+static struct clk_mxc mpll_main2_clk = {
+	.clk = INIT_CLK_MXC(mpll_main2_clk),
 	.id		= 1,
 	.parent		= &mpll_clk,
 	.get_rate	= get_rate_mpll_main,
 };
 
-static struct clk ahb_clk = {
+static struct clk_mxc ahb_clk = {
+	.clk = INIT_CLK_MXC(ahb_clk),
 	.parent		= &mpll_main2_clk,
 	.get_rate	= get_rate_ahb,
 };
 
-static struct clk ipg_clk = {
+static struct clk_mxc ipg_clk = {
+	.clk = INIT_CLK_MXC(ipg_clk),
 	.parent		= &ahb_clk,
 	.get_rate	= get_rate_ipg,
 };
 
-static struct clk cpu_clk = {
+static struct clk_mxc cpu_clk = {
+	.clk = INIT_CLK_MXC(cpu_clk),
 	.parent = &mpll_main2_clk,
 	.set_parent = clk_cpu_set_parent,
 	.round_rate = round_rate_cpu,
@@ -475,7 +482,8 @@ static struct clk cpu_clk = {
 	.set_rate = set_rate_cpu,
 };
 
-static struct clk spll_clk = {
+static struct clk_mxc spll_clk = {
+	.clk = INIT_CLK_MXC(spll_clk),
 	.parent = &ckih_clk,
 	.get_rate = get_rate_spll,
 	.enable = clk_spll_enable,
@@ -486,12 +494,14 @@ static struct clk spll_clk = {
  * the low frequency external clock reference
  * Default case is 32.768kHz.
  */
-static struct clk ckil_clk = {
+static struct clk_mxc ckil_clk = {
+	.clk = INIT_CLK_MXC(ckil_clk),
 	.get_rate = get_rate_low_reference,
 };
 
 /* Output of frequency pre multiplier */
-static struct clk fpm_clk = {
+static struct clk_mxc fpm_clk = {
+	.clk = INIT_CLK_MXC(fpm_clk),
 	.parent = &ckil_clk,
 	.get_rate = get_rate_fpm,
 };
@@ -500,7 +510,8 @@ static struct clk fpm_clk = {
 #define PCCR1 CCM_PCCR1
 
 #define DEFINE_CLOCK(name, i, er, es, gr, s, p)		\
-	static struct clk name = {			\
+	static struct clk_mxc name = {			\
+		.clk = INIT_CLK_MXC(name),		\
 		.id		= i,			\
 		.enable_reg	= er,			\
 		.enable_shift	= es,			\
@@ -512,7 +523,8 @@ static struct clk fpm_clk = {
 	}
 
 #define DEFINE_CLOCK1(name, i, er, es, getsetround, s, p)	\
-	static struct clk name = {				\
+	static struct clk_mxc name = {				\
+		.clk = INIT_CLK_MXC(name),			\
 		.id		= i,				\
 		.enable_reg	= er,				\
 		.enable_shift	= es,				\
@@ -526,7 +538,7 @@ static struct clk fpm_clk = {
 	}
 
 /* Forward declaration to keep the following list in order */
-static struct clk slcdc_clk1, sahara2_clk1, rtic_clk1, fec_clk1, emma_clk1,
+static struct clk_mxc slcdc_clk1, sahara2_clk1, rtic_clk1, fec_clk1, emma_clk1,
 		  dma_clk1, lcdc_clk2, vpu_clk1;
 
 /* All clocks we can gate through PCCRx in the order of PCCRx bits */
@@ -620,7 +632,7 @@ DEFINE_CLOCK1(csi_clk,     0, NULL,   0, parent, &csi_clk1, &per4_clk);
 	{ \
 		.dev_id = d, \
 		.con_id = n, \
-		.clk = &c, \
+		.clk = &c.clk, \
 	},
 
 static struct clk_lookup lookups[] = {
@@ -746,16 +758,16 @@ int __init mx27_clocks_init(unsigned long fref)
 	spll_clk.disable(&spll_clk);
 
 	/* enable basic clocks */
-	clk_enable(&per1_clk);
-	clk_enable(&gpio_clk);
-	clk_enable(&emi_clk);
-	clk_enable(&iim_clk);
+	clk_enable(&per1_clk.clk);
+	clk_enable(&gpio_clk.clk);
+	clk_enable(&emi_clk.clk);
+	clk_enable(&iim_clk.clk);
 
 #if defined(CONFIG_DEBUG_LL) && !defined(CONFIG_DEBUG_ICEDCC)
-	clk_enable(&uart1_clk);
+	clk_enable(&uart1_clk.clk);
 #endif
 
-	mxc_timer_init(&gpt1_clk, MX27_IO_ADDRESS(MX27_GPT1_BASE_ADDR),
+	mxc_timer_init(&gpt1_clk.clk, MX27_IO_ADDRESS(MX27_GPT1_BASE_ADDR),
 			MX27_INT_GPT1);
 
 	return 0;
diff --git a/arch/arm/plat-mxc/clock.c b/arch/arm/plat-mxc/clock.c
index 2ed3ab1..3fc75dd 100644
--- a/arch/arm/plat-mxc/clock.c
+++ b/arch/arm/plat-mxc/clock.c
@@ -44,6 +44,131 @@
 static LIST_HEAD(clocks);
 static DEFINE_MUTEX(clocks_mutex);
 
+#ifdef CONFIG_USE_COMMON_STRUCT_CLK
+static int clk_mxc_enable(struct clk *clk)
+{
+	struct clk_mxc *clk_mxc = to_clk_mxc(clk);
+	int ret = 0;
+
+	if (clk_mxc->parent)
+		ret = clk_enable(&clk_mxc->parent->clk);
+
+	if (!ret && clk_mxc->secondary)
+		ret = clk_enable(&clk_mxc->secondary->clk);
+
+	if (!ret && clk_mxc->enable)
+		ret = clk_mxc->enable(clk_mxc);
+
+	return ret;
+}
+
+static void clk_mxc_disable(struct clk *clk)
+{
+	struct clk_mxc *clk_mxc = to_clk_mxc(clk);
+
+	if (clk_mxc->disable)
+		clk_mxc->disable(clk_mxc);
+
+	if (clk_mxc->secondary)
+		clk_disable(&clk_mxc->secondary->clk);
+
+	if (clk_mxc->parent)
+		clk_disable(&clk_mxc->parent->clk);
+}
+
+static unsigned long clk_mxc_get_rate(struct clk *clk)
+{
+	struct clk_mxc *clk_mxc = to_clk_mxc(clk);
+
+	if (clk_mxc->get_rate)
+		return clk_mxc->get_rate(clk_mxc);
+	else if (clk_mxc->parent)
+		return clk_get_rate(&clk_mxc->parent->clk);
+	else
+		return 0UL;
+}
+
+static long clk_mxc_round_rate(struct clk *clk, unsigned long rate)
+{
+	struct clk_mxc *clk_mxc = to_clk_mxc(clk);
+
+	if (clk_mxc->round_rate)
+		return clk_mxc->round_rate(clk_mxc, rate);
+
+	return 0L;
+}
+
+static int clk_mxc_set_rate(struct clk *clk, unsigned long rate)
+{
+	struct clk_mxc *clk_mxc = to_clk_mxc(clk);
+	int ret = -EINVAL;
+
+	if (clk_mxc->set_rate && rate != 0)
+		ret = clk_mxc->set_rate(clk_mxc, rate);
+
+	return ret;
+}
+
+static int clk_mxc_set_parent(struct clk *clk, struct clk *parent)
+{
+	struct clk_mxc *clk_mxc = to_clk_mxc(clk);
+	struct clk *old_parent = parent;
+	struct clk_mxc *parent_mxc = to_clk_mxc(parent);
+	int ret;
+
+	if (!clk_mxc->set_parent)
+		return -EINVAL;
+
+	if (clk->prepare_count) {
+		ret = clk_prepare(parent);
+		if (ret)
+			goto err_prepare_parent;
+	}
+
+	if (clk->enable_count) {
+		ret = clk_enable(parent);
+		if (ret)
+			goto err_enable_parent;
+	}
+
+	ret = clk_mxc->set_parent(clk_mxc, parent_mxc);
+	if (ret == 0) {
+		old_parent = &clk_mxc->parent->clk;
+		clk_mxc->parent = to_clk_mxc(parent);
+	}
+
+	if (clk->enable_count)
+		clk_disable(old_parent);
+err_enable_parent:
+
+	if (clk->prepare_count)
+		clk_unprepare(old_parent);
+err_prepare_parent:
+
+	return ret;
+}
+
+static struct clk *clk_mxc_get_parent(struct clk *clk)
+{
+	struct clk_mxc *clk_mxc = to_clk_mxc(clk);
+
+	if (clk_mxc->parent)
+		return &clk_mxc->parent->clk;
+
+	return NULL;
+}
+
+const struct clk_ops clk_mxc_ops = {
+	.enable = clk_mxc_enable,
+	.disable = clk_mxc_disable,
+	.get_rate = clk_mxc_get_rate,
+	.round_rate = clk_mxc_round_rate,
+	.set_rate = clk_mxc_set_rate,
+	.set_parent = clk_mxc_set_parent,
+	.get_parent = clk_mxc_get_parent,
+};
+#else
+
 /*-------------------------------------------------------------------------
  * Standard clock functions defined in include/linux/clk.h
  *-------------------------------------------------------------------------*/
@@ -200,6 +325,8 @@ struct clk *clk_get_parent(struct clk *clk)
 }
 EXPORT_SYMBOL(clk_get_parent);
 
+#endif
+
 /*
  * Get the resulting clock rate from a PLL register value and the input
  * frequency. PLLs with this register layout can at least be found on
diff --git a/arch/arm/plat-mxc/include/mach/clkdev.h b/arch/arm/plat-mxc/include/mach/clkdev.h
index 04b37a8..f663af3 100644
--- a/arch/arm/plat-mxc/include/mach/clkdev.h
+++ b/arch/arm/plat-mxc/include/mach/clkdev.h
@@ -1,7 +1,11 @@
 #ifndef __ASM_MACH_CLKDEV_H
 #define __ASM_MACH_CLKDEV_H
 
+#ifndef CONFIG_USE_COMMON_STRUCT_CLK
+
 #define __clk_get(clk) ({ 1; })
 #define __clk_put(clk) do { } while (0)
 
 #endif
+
+#endif
diff --git a/arch/arm/plat-mxc/include/mach/clock.h b/arch/arm/plat-mxc/include/mach/clock.h
index 753a598..d8efa77 100644
--- a/arch/arm/plat-mxc/include/mach/clock.h
+++ b/arch/arm/plat-mxc/include/mach/clock.h
@@ -23,14 +23,24 @@
 #ifndef __ASSEMBLY__
 #include <linux/list.h>
 
+#include <linux/clk.h>
+
 struct module;
 
-struct clk {
+#ifndef CONFIG_USE_COMMON_STRUCT_CLK
+#define clk_mxc clk
+#endif
+
+struct clk_mxc {
+#ifdef CONFIG_USE_COMMON_STRUCT_CLK
+	struct clk clk;
+#endif
+
 	int id;
 	/* Source clock this clk depends on */
-	struct clk *parent;
+	struct clk_mxc *parent;
 	/* Secondary clock to enable/disable with this clock */
-	struct clk *secondary;
+	struct clk_mxc *secondary;
 	/* Reference count of clock enable/disable */
 	__s8 usecount;
 	/* Register bit position for clock's enable/disable control. */
@@ -39,23 +49,27 @@ struct clk {
 	void __iomem *enable_reg;
 	u32 flags;
 	/* get the current clock rate (always a fresh value) */
-	unsigned long (*get_rate) (struct clk *);
+	unsigned long (*get_rate) (struct clk_mxc *);
 	/* Function ptr to set the clock to a new rate. The rate must match a
 	   supported rate returned from round_rate. Leave blank if clock is not
 	   programmable */
-	int (*set_rate) (struct clk *, unsigned long);
+	int (*set_rate) (struct clk_mxc *, unsigned long);
 	/* Function ptr to round the requested clock rate to the nearest
 	   supported rate that is less than or equal to the requested rate. */
-	unsigned long (*round_rate) (struct clk *, unsigned long);
+	unsigned long (*round_rate) (struct clk_mxc *, unsigned long);
 	/* Function ptr to enable the clock. Leave blank if clock can not
 	   be gated. */
-	int (*enable) (struct clk *);
+	int (*enable) (struct clk_mxc *);
 	/* Function ptr to disable the clock. Leave blank if clock can not
 	   be gated. */
-	void (*disable) (struct clk *);
+	void (*disable) (struct clk_mxc *);
 	/* Function ptr to set the parent clock of the clock. */
-	int (*set_parent) (struct clk *, struct clk *);
+	int (*set_parent) (struct clk_mxc *, struct clk_mxc *);
 };
+#define to_clk_mxc(_clk_mxc)        container_of(_clk_mxc, struct clk_mxc, clk)
+
+extern const struct clk_ops clk_mxc_ops;
+#define INIT_CLK_MXC(name)	INIT_CLK(name.clk, clk_mxc_ops)
 
 int clk_register(struct clk *clk);
 void clk_unregister(struct clk *clk);
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 0da0bb9..fbafcb6 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -47,7 +47,7 @@ int clk_enable(struct clk *clk)
 	unsigned long flags;
 	int ret = 0;
 
-	WARN_ON(clk->prepare_count == 0);
+	WARN_ON_ONCE(clk->prepare_count == 0);
 
 	spin_lock_irqsave(&clk->enable_lock, flags);
 	if (clk->enable_count == 0 && clk->ops->enable)
-- 
1.7.2.3

