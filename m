Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab0KFS0K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:26:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60924 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab0KFS0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:26:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=kMVLIFiCXf14m0DpvLFACnxA5ndIxWe6zdmPorrc7cuhwvqbie6rY1Fmp9pU3hgs2s
         A8ae6n+0DKB30b3ASsHE71S94ZGH8Gv0K1xerjFkLtRc1hLcJG0gtUeceqWQCb3iXu1T
         zbfoRfNT6E+ycBhNI8Snm8Fjb9BJjG5qb5aFY=
From: Rabin Vincent <rabin@rab.in>
To: linux-arm-kernel@lists.infradead.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tim Bird <tim.bird@am.sony.com>, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 1/6] ARM: ensure sched_clock() and children are notrace
Date: Sat,  6 Nov 2010 23:55:49 +0530
Message-Id: <1289067954-5080-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include sched.h in the files implementing sched_clock() and ensure that
any functions called from sched_clock() have the notrace annotation.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/mach-tegra/timer.c           |    3 ++-
 arch/arm/mach-u300/timer.c            |    1 +
 arch/arm/plat-iop/time.c              |    3 ++-
 arch/arm/plat-nomadik/timer.c         |    5 +++--
 arch/arm/plat-omap/counter_32k.c      |   11 ++++++-----
 arch/arm/plat-versatile/sched-clock.c |    1 +
 6 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-tegra/timer.c b/arch/arm/mach-tegra/timer.c
index 9057d6f..88ed925 100644
--- a/arch/arm/mach-tegra/timer.c
+++ b/arch/arm/mach-tegra/timer.c
@@ -21,6 +21,7 @@
 #include <linux/time.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/sched.h>
 #include <linux/clockchips.h>
 #include <linux/clocksource.h>
 #include <linux/clk.h>
@@ -89,7 +90,7 @@ static void tegra_timer_set_mode(enum clock_event_mode mode,
 	}
 }
 
-static cycle_t tegra_clocksource_read(struct clocksource *cs)
+static cycle_t notrace tegra_clocksource_read(struct clocksource *cs)
 {
 	return cnt32_to_63(timer_readl(TIMERUS_CNTR_1US));
 }
diff --git a/arch/arm/mach-u300/timer.c b/arch/arm/mach-u300/timer.c
index 3fc4472..672b28a 100644
--- a/arch/arm/mach-u300/timer.c
+++ b/arch/arm/mach-u300/timer.c
@@ -11,6 +11,7 @@
 #include <linux/interrupt.h>
 #include <linux/time.h>
 #include <linux/timex.h>
+#include <linux/sched.h>
 #include <linux/clockchips.h>
 #include <linux/clocksource.h>
 #include <linux/types.h>
diff --git a/arch/arm/plat-iop/time.c b/arch/arm/plat-iop/time.c
index 85d3e55..558cdfa 100644
--- a/arch/arm/plat-iop/time.c
+++ b/arch/arm/plat-iop/time.c
@@ -18,6 +18,7 @@
 #include <linux/time.h>
 #include <linux/init.h>
 #include <linux/timex.h>
+#include <linux/sched.h>
 #include <linux/io.h>
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
@@ -36,7 +37,7 @@
 /*
  * IOP clocksource (free-running timer 1).
  */
-static cycle_t iop_clocksource_read(struct clocksource *unused)
+static cycle_t notrace iop_clocksource_read(struct clocksource *unused)
 {
 	return 0xffffffffu - read_tcr1();
 }
diff --git a/arch/arm/plat-nomadik/timer.c b/arch/arm/plat-nomadik/timer.c
index aedf9c1..70969a7 100644
--- a/arch/arm/plat-nomadik/timer.c
+++ b/arch/arm/plat-nomadik/timer.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/sched.h>
 #include <linux/io.h>
 #include <linux/clockchips.h>
 #include <linux/clk.h>
@@ -26,13 +27,13 @@ void __iomem *mtu_base; /* ssigned by machine code */
  * Kernel assumes that sched_clock can be called early
  * but the MTU may not yet be initialized.
  */
-static cycle_t nmdk_read_timer_dummy(struct clocksource *cs)
+static cycle_t notrace nmdk_read_timer_dummy(struct clocksource *cs)
 {
 	return 0;
 }
 
 /* clocksource: MTU decrements, so we negate the value being read. */
-static cycle_t nmdk_read_timer(struct clocksource *cs)
+static cycle_t notrace nmdk_read_timer(struct clocksource *cs)
 {
 	return -readl(mtu_base + MTU_VAL(0));
 }
diff --git a/arch/arm/plat-omap/counter_32k.c b/arch/arm/plat-omap/counter_32k.c
index 155fe43..bc9bc6c 100644
--- a/arch/arm/plat-omap/counter_32k.c
+++ b/arch/arm/plat-omap/counter_32k.c
@@ -13,6 +13,7 @@
  * NOTE: This timer is not the same timer as the old OMAP1 MPU timer.
  */
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/clk.h>
 #include <linux/io.h>
@@ -44,7 +45,7 @@
 static u32 offset_32k __read_mostly;
 
 #ifdef CONFIG_ARCH_OMAP16XX
-static cycle_t omap16xx_32k_read(struct clocksource *cs)
+static cycle_t notrace omap16xx_32k_read(struct clocksource *cs)
 {
 	return omap_readl(OMAP16XX_TIMER_32K_SYNCHRONIZED) - offset_32k;
 }
@@ -53,7 +54,7 @@ static cycle_t omap16xx_32k_read(struct clocksource *cs)
 #endif
 
 #ifdef CONFIG_ARCH_OMAP2420
-static cycle_t omap2420_32k_read(struct clocksource *cs)
+static cycle_t notrace omap2420_32k_read(struct clocksource *cs)
 {
 	return omap_readl(OMAP2420_32KSYNCT_BASE + 0x10) - offset_32k;
 }
@@ -62,7 +63,7 @@ static cycle_t omap2420_32k_read(struct clocksource *cs)
 #endif
 
 #ifdef CONFIG_ARCH_OMAP2430
-static cycle_t omap2430_32k_read(struct clocksource *cs)
+static cycle_t notrace omap2430_32k_read(struct clocksource *cs)
 {
 	return omap_readl(OMAP2430_32KSYNCT_BASE + 0x10) - offset_32k;
 }
@@ -71,7 +72,7 @@ static cycle_t omap2430_32k_read(struct clocksource *cs)
 #endif
 
 #ifdef CONFIG_ARCH_OMAP3
-static cycle_t omap34xx_32k_read(struct clocksource *cs)
+static cycle_t notrace omap34xx_32k_read(struct clocksource *cs)
 {
 	return omap_readl(OMAP3430_32KSYNCT_BASE + 0x10) - offset_32k;
 }
@@ -80,7 +81,7 @@ static cycle_t omap34xx_32k_read(struct clocksource *cs)
 #endif
 
 #ifdef CONFIG_ARCH_OMAP4
-static cycle_t omap44xx_32k_read(struct clocksource *cs)
+static cycle_t notrace omap44xx_32k_read(struct clocksource *cs)
 {
 	return omap_readl(OMAP4430_32KSYNCT_BASE + 0x10) - offset_32k;
 }
diff --git a/arch/arm/plat-versatile/sched-clock.c b/arch/arm/plat-versatile/sched-clock.c
index 9768cf7..9696ddc 100644
--- a/arch/arm/plat-versatile/sched-clock.c
+++ b/arch/arm/plat-versatile/sched-clock.c
@@ -20,6 +20,7 @@
  */
 #include <linux/cnt32_to_63.h>
 #include <linux/io.h>
+#include <linux/sched.h>
 #include <asm/div64.h>
 
 #include <mach/hardware.h>
-- 
1.7.2.3

