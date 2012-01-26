Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab2AZROD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:14:03 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:12705 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab2AZRNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:13:07 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/6] ARM: at91/at91sam9x5: clock management for at91sam9x5 chip family
Date: Thu, 26 Jan 2012 18:12:34 +0100
Message-Id: <ed361827f58fb20a3e281717a3573a027d4ce928.1327596859.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327597957-32662-1-git-send-email-nicolas.ferre@atmel.com>
References: <1327597957-32662-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <15809998b6ca8f1bf69546bfcac18301a70625ef.1327596859.git.nicolas.ferre@atmel.com>
References: <15809998b6ca8f1bf69546bfcac18301a70625ef.1327596859.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several changes to PMC have to be managed for adding this support:
- alternate prescaler location for both MCKR and PCKR
- alternate CSS length for PCKR
- added cpu_is_at91sam9x5() to functional switches
- manage UTMI bias like sam9g45 chip family

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 arch/arm/mach-at91/clock.c |   83 ++++++++++++++++++++++++++++++++++----------
 1 files changed, 64 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index aa04e22..a5291e0 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -48,24 +48,37 @@
  * Chips have some kind of clocks : group them by functionality
  */
 #define cpu_has_utmi()		(  cpu_is_at91sam9rl() \
-				|| cpu_is_at91sam9g45())
+				|| cpu_is_at91sam9g45() \
+				|| cpu_is_at91sam9x5())
 
 #define cpu_has_800M_plla()	(  cpu_is_at91sam9g20() \
-				|| cpu_is_at91sam9g45())
+				|| cpu_is_at91sam9g45() \
+				|| cpu_is_at91sam9x5())
 
 #define cpu_has_300M_plla()	(cpu_is_at91sam9g10())
 
 #define cpu_has_pllb()		(!(cpu_is_at91sam9rl() \
-				|| cpu_is_at91sam9g45()))
+				|| cpu_is_at91sam9g45() \
+				|| cpu_is_at91sam9x5()))
 
-#define cpu_has_upll()		(cpu_is_at91sam9g45())
+#define cpu_has_upll()		(cpu_is_at91sam9g45() \
+				|| cpu_is_at91sam9x5())
 
 /* USB host HS & FS */
 #define cpu_has_uhp()		(!cpu_is_at91sam9rl())
 
 /* USB device FS only */
 #define cpu_has_udpfs()		(!(cpu_is_at91sam9rl() \
-				|| cpu_is_at91sam9g45()))
+				|| cpu_is_at91sam9g45() \
+				|| cpu_is_at91sam9x5()))
+
+#define cpu_has_plladiv2()	(cpu_is_at91sam9g45() \
+				|| cpu_is_at91sam9x5())
+
+#define cpu_has_mdiv3()		(cpu_is_at91sam9g45() \
+				|| cpu_is_at91sam9x5())
+
+#define cpu_has_alt_prescaler()	(cpu_is_at91sam9x5())
 
 static LIST_HEAD(clocks);
 static DEFINE_SPINLOCK(clk_lock);
@@ -138,13 +151,6 @@ static void pmc_uckr_mode(struct clk *clk, int is_on)
 {
 	unsigned int uckr = at91_sys_read(AT91_CKGR_UCKR);
 
-	if (cpu_is_at91sam9g45()) {
-		if (is_on)
-			uckr |= AT91_PMC_BIASEN;
-		else
-			uckr &= ~AT91_PMC_BIASEN;
-	}
-
 	if (is_on) {
 		is_on = AT91_PMC_LOCKU;
 		at91_sys_write(AT91_CKGR_UCKR, uckr | clk->pmc_mask);
@@ -209,11 +215,24 @@ static struct clk __init *at91_css_to_clk(unsigned long css)
 				return &utmi_clk;
 			else if (cpu_has_pllb())
 				return &pllb;
+			break;
+		/* alternate PMC: can use master clock */
+		case AT91_PMC_CSS_MASTER:
+			return &mck;
 	}
 
 	return NULL;
 }
 
+static int pmc_prescaler_divider(u32 reg)
+{
+	if (cpu_has_alt_prescaler()) {
+		return 1 << ((reg & AT91_PMC_ALT_PRES) >> PMC_ALT_PRES_OFFSET);
+	} else {
+		return 1 << ((reg & AT91_PMC_PRES) >> PMC_PRES_OFFSET);
+	}
+}
+
 static void __clk_enable(struct clk *clk)
 {
 	if (clk->parent)
@@ -315,12 +334,22 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 {
 	unsigned long	flags;
 	unsigned	prescale;
+	unsigned long	prescale_offset, css_mask;
 	unsigned long	actual;
 
 	if (!clk_is_programmable(clk))
 		return -EINVAL;
 	if (clk->users)
 		return -EBUSY;
+
+	if (cpu_has_alt_prescaler()) {
+		prescale_offset = PMC_ALT_PRES_OFFSET;
+		css_mask = AT91_PMC_ALT_PCKR_CSS;
+	} else {
+		prescale_offset = PMC_PRES_OFFSET;
+		css_mask = AT91_PMC_CSS;
+	}
+
 	spin_lock_irqsave(&clk_lock, flags);
 
 	actual = clk->parent->rate_hz;
@@ -329,8 +358,8 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 			u32	pckr;
 
 			pckr = at91_sys_read(AT91_PMC_PCKR(clk->id));
-			pckr &= AT91_PMC_CSS;	/* clock selection */
-			pckr |= prescale << 2;
+			pckr &= css_mask;	/* keep clock selection */
+			pckr |= prescale << prescale_offset;
 			at91_sys_write(AT91_PMC_PCKR(clk->id), pckr);
 			clk->rate_hz = actual;
 			break;
@@ -377,11 +406,17 @@ static void __init init_programmable_clock(struct clk *clk)
 {
 	struct clk	*parent;
 	u32		pckr;
+	unsigned int	css_mask;
+
+	if (cpu_has_alt_prescaler())
+		css_mask = AT91_PMC_ALT_PCKR_CSS;
+	else
+		css_mask = AT91_PMC_CSS;
 
 	pckr = at91_sys_read(AT91_PMC_PCKR(clk->id));
-	parent = at91_css_to_clk(pckr & AT91_PMC_CSS);
+	parent = at91_css_to_clk(pckr & css_mask);
 	clk->parent = parent;
-	clk->rate_hz = parent->rate_hz / (1 << ((pckr & AT91_PMC_PRES) >> 2));
+	clk->rate_hz = parent->rate_hz / pmc_prescaler_divider(pckr);
 }
 
 #endif	/* CONFIG_AT91_PROGRAMMABLE_CLOCKS */
@@ -663,7 +698,7 @@ int __init at91_clock_init(unsigned long main_clock)
 	if (pll_overclock)
 		pr_info("Clocks: PLLA overclocked, %ld MHz\n", plla.rate_hz / 1000000);
 
-	if (cpu_is_at91sam9g45()) {
+	if (cpu_has_plladiv2()) {
 		mckr = at91_sys_read(AT91_PMC_MCKR);
 		plla.rate_hz /= (1 << ((mckr & AT91_PMC_PLLADIV2) >> 12));	/* plla divisor by 2 */
 	}
@@ -685,6 +720,10 @@ int __init at91_clock_init(unsigned long main_clock)
 		 * (obtain the USB High Speed 480 MHz when input is 12 MHz)
 		 */
 		utmi_clk.rate_hz = 40 * utmi_clk.parent->rate_hz;
+
+		/* UTMI bias and PLL are managed at the same time */
+		if (cpu_has_upll())
+			utmi_clk.pmc_mask |= AT91_PMC_BIASEN;
 	}
 
 	/*
@@ -703,7 +742,7 @@ int __init at91_clock_init(unsigned long main_clock)
 	mckr = at91_sys_read(AT91_PMC_MCKR);
 	mck.parent = at91_css_to_clk(mckr & AT91_PMC_CSS);
 	freq = mck.parent->rate_hz;
-	freq /= (1 << ((mckr & AT91_PMC_PRES) >> 2));				/* prescale */
+	freq /= pmc_prescaler_divider(mckr);					/* prescale */
 	if (cpu_is_at91rm9200()) {
 		mck.rate_hz = freq / (1 + ((mckr & AT91_PMC_MDIV) >> 8));	/* mdiv */
 	} else if (cpu_is_at91sam9g20()) {
@@ -711,13 +750,19 @@ int __init at91_clock_init(unsigned long main_clock)
 			freq / ((mckr & AT91_PMC_MDIV) >> 7) : freq;	/* mdiv ; (x >> 7) = ((x >> 8) * 2) */
 		if (mckr & AT91_PMC_PDIV)
 			freq /= 2;		/* processor clock division */
-	} else if (cpu_is_at91sam9g45()) {
+	} else if (cpu_has_mdiv3()) {
 		mck.rate_hz = (mckr & AT91_PMC_MDIV) == AT91SAM9_PMC_MDIV_3 ?
 			freq / 3 : freq / (1 << ((mckr & AT91_PMC_MDIV) >> 8));	/* mdiv */
 	} else {
 		mck.rate_hz = freq / (1 << ((mckr & AT91_PMC_MDIV) >> 8));		/* mdiv */
 	}
 
+	if (cpu_has_alt_prescaler()) {
+		/* Programmable clocks can use MCK */
+		mck.type |= CLK_TYPE_PRIMARY;
+		mck.id = 4;
+	}
+
 	/* Register the PMC's standard clocks */
 	for (i = 0; i < ARRAY_SIZE(standard_pmc_clocks); i++)
 		at91_clk_add(standard_pmc_clocks[i]);
-- 
1.7.5.4

