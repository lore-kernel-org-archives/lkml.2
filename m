Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1K0DlP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 22:41:15 -0500
Received: from d1.icnet.pl ([212.160.220.21]:56215 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab1K0DlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 22:41:12 -0500
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Nov 2011 22:41:12 EST
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH 1/5] ARM: OMAP1: Fix dpll1 default rate reprogramming method
Date: Sun, 27 Nov 2011 04:32:27 +0100
Message-Id: <1322364751-29980-2-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1322364751-29980-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1322364751-29980-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to comments in omap1_select_table_rate(), reprogramming dpll1
is tricky, and should always be done from SRAM.

While being at it, move OMAP730 special case handling inside
omap_sram_reprogram_clock().

Created on top of omap-fixes, not yet in mainline as of 3.2-rc3.
Tested on Amstrad Delta.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 arch/arm/mach-omap1/clock.c      |    6 +-----
 arch/arm/mach-omap1/clock_data.c |    7 +++++--
 arch/arm/plat-omap/sram.c        |    3 +++
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap1/clock.c b/arch/arm/mach-omap1/clock.c
index 84ef704..3899176 100644
--- a/arch/arm/mach-omap1/clock.c
+++ b/arch/arm/mach-omap1/clock.c
@@ -215,12 +215,8 @@ int omap1_select_table_rate(struct clk *clk, unsigned long rate)
 	/*
 	 * In most cases we should not need to reprogram DPLL.
 	 * Reprogramming the DPLL is tricky, it must be done from SRAM.
-	 * (on 730, bit 13 must always be 1)
 	 */
-	if (cpu_is_omap7xx())
-		omap_sram_reprogram_clock(ptr->dpllctl_val, ptr->ckctl_val | 0x2000);
-	else
-		omap_sram_reprogram_clock(ptr->dpllctl_val, ptr->ckctl_val);
+	omap_sram_reprogram_clock(ptr->dpllctl_val, ptr->ckctl_val);
 
 	/* XXX Do we need to recalculate the tree below DPLL1 at this point? */
 	ck_dpll1_p->rate = ptr->pll_rate;
diff --git a/arch/arm/mach-omap1/clock_data.c b/arch/arm/mach-omap1/clock_data.c
index 1297bb5..4550415 100644
--- a/arch/arm/mach-omap1/clock_data.c
+++ b/arch/arm/mach-omap1/clock_data.c
@@ -23,6 +23,7 @@
 #include <plat/clock.h>
 #include <plat/cpu.h>
 #include <plat/clkdev_omap.h>
+#include <plat/sram.h>	/* for omap_sram_reprogram_clock() */
 #include <plat/usb.h>   /* for OTG_BASE */
 
 #include "clock.h"
@@ -933,8 +934,10 @@ void __init omap1_clk_late_init(void)
 	/* Find the highest supported frequency and enable it */
 	if (omap1_select_table_rate(&virtual_ck_mpu, ~0)) {
 		pr_err("System frequencies not set, using default. Check your config.\n");
-		omap_writew(0x2290, DPLL_CTL);
-		omap_writew(cpu_is_omap7xx() ? 0x3005 : 0x1005, ARM_CKCTL);
+		/*
+		 * Reprogramming the DPLL is tricky, it must be done from SRAM.
+		 */
+		omap_sram_reprogram_clock(0x2290, 0x1005);
 		ck_dpll1.rate = OMAP1_DPLL1_SANE_VALUE;
 	}
 	propagate_rate(&ck_dpll1);
diff --git a/arch/arm/plat-omap/sram.c b/arch/arm/plat-omap/sram.c
index 8b28664..312bee8 100644
--- a/arch/arm/plat-omap/sram.c
+++ b/arch/arm/plat-omap/sram.c
@@ -224,6 +224,9 @@ static void (*_omap_sram_reprogram_clock)(u32 dpllctl, u32 ckctl);
 void omap_sram_reprogram_clock(u32 dpllctl, u32 ckctl)
 {
 	BUG_ON(!_omap_sram_reprogram_clock);
+	/* On 730, bit 13 must always be 1 */
+	if (cpu_is_omap7xx())
+		ckctl |= 0x2000;
 	_omap_sram_reprogram_clock(dpllctl, ckctl);
 }
 
-- 
1.7.3.4

