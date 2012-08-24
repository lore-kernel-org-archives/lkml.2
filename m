Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab2HXOzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:55:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35662 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab2HXOzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:55:46 -0400
From: Vaibhav Hiremath <hvaibhav@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Vaibhav Hiremath <hvaibhav@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: [PATCH] ARM: OMAP2+: dpll: Add missing soc_is_am33xx() check for common functions
Date: Fri, 24 Aug 2012 20:24:24 +0530
Message-ID: <1345820064-5243-1-git-send-email-hvaibhav@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing soc_is_am33xx() check for DPLL common control & clock
related functions, without this dpll programmability would be broken
for am33xx family of devices.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
---
Not sure whether this should go as a fix in -rc, as AM33XX device
doesn't still boot without hwmod data (which is not yet upstream).

 arch/arm/mach-omap2/clkt_dpll.c |    4 ++--
 arch/arm/mach-omap2/dpll3xxx.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/clkt_dpll.c b/arch/arm/mach-omap2/clkt_dpll.c
index cd7fd0f..05ff99e 100644
--- a/arch/arm/mach-omap2/clkt_dpll.c
+++ b/arch/arm/mach-omap2/clkt_dpll.c
@@ -211,7 +211,7 @@ void omap2_init_dpll_parent(struct clk *clk)
 		if (v == OMAP3XXX_EN_DPLL_LPBYPASS ||
 		    v == OMAP3XXX_EN_DPLL_FRBYPASS)
 			clk_reparent(clk, dd->clk_bypass);
-	} else if (cpu_is_omap44xx()) {
+	} else if (soc_is_am33xx() || cpu_is_omap44xx()) {
 		if (v == OMAP4XXX_EN_DPLL_LPBYPASS ||
 		    v == OMAP4XXX_EN_DPLL_FRBYPASS ||
 		    v == OMAP4XXX_EN_DPLL_MNBYPASS)
@@ -257,7 +257,7 @@ u32 omap2_get_dpll_rate(struct clk *clk)
 		if (v == OMAP3XXX_EN_DPLL_LPBYPASS ||
 		    v == OMAP3XXX_EN_DPLL_FRBYPASS)
 			return dd->clk_bypass->rate;
-	} else if (cpu_is_omap44xx()) {
+	} else if (soc_is_am33xx() || cpu_is_omap44xx()) {
 		if (v == OMAP4XXX_EN_DPLL_LPBYPASS ||
 		    v == OMAP4XXX_EN_DPLL_FRBYPASS ||
 		    v == OMAP4XXX_EN_DPLL_MNBYPASS)
diff --git a/arch/arm/mach-omap2/dpll3xxx.c b/arch/arm/mach-omap2/dpll3xxx.c
index b9c8d2f..063e1f9 100644
--- a/arch/arm/mach-omap2/dpll3xxx.c
+++ b/arch/arm/mach-omap2/dpll3xxx.c
@@ -311,7 +311,7 @@ static int omap3_noncore_dpll_program(struct clk *clk, u16 m, u8 n, u16 freqsel)
 	 * Set jitter correction. No jitter correction for OMAP4 and 3630
 	 * since freqsel field is no longer present
 	 */
-	if (!cpu_is_omap44xx() && !cpu_is_omap3630()) {
+	if (!soc_is_am33xx() && !cpu_is_omap44xx() && !cpu_is_omap3630()) {
 		v = __raw_readl(dd->control_reg);
 		v &= ~dd->freqsel_mask;
 		v |= freqsel << __ffs(dd->freqsel_mask);
@@ -471,7 +471,7 @@ int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate)
 			return -EINVAL;

 		/* No freqsel on OMAP4 and OMAP3630 */
-		if (!cpu_is_omap44xx() && !cpu_is_omap3630()) {
+		if (!soc_is_am33xx() && !cpu_is_omap44xx() && !cpu_is_omap3630()) {
 			freqsel = _omap3_dpll_compute_freqsel(clk,
 						dd->last_rounded_n);
 			if (!freqsel)
--
1.7.0.4

