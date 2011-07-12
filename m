Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1GLFvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 01:51:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45941 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab1GLFvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 01:51:00 -0400
X-AuditID: cbfee61b-b7bfdae000006d51-30-4e1be0bac649
Date: Tue, 12 Jul 2011 14:51:11 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] clocksource: convert S5PV210 32-bit down counting clocksource
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <4E1BE0CF.7060207@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
X-OriginalArrivalTime: 12 Jul 2011 05:51:00.0625 (UTC)
 FILETIME=[ADA11810:01CC4057]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the S5PV210 32-bit down-counting clocksource to the generic
mmio clocksource infrastructure

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/Kconfig             |    1 +
 arch/arm/plat-s5p/s5p-time.c |   20 +++-----------------
 2 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9adc278..d7cd6f9 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -749,6 +749,7 @@ config ARCH_S5PV210
 	bool "Samsung S5PV210/S5PC110"
 	select CPU_V7
 	select ARCH_SPARSEMEM_ENABLE
+	select CLKSRC_MMIO
 	select GENERIC_GPIO
 	select HAVE_CLK
 	select ARM_L1_CACHE_SHIFT_6
diff --git a/arch/arm/plat-s5p/s5p-time.c b/arch/arm/plat-s5p/s5p-time.c
index 612934c..5666f55 100644
--- a/arch/arm/plat-s5p/s5p-time.c
+++ b/arch/arm/plat-s5p/s5p-time.c
@@ -314,13 +314,6 @@ static void __iomem *s5p_timer_reg(void)
 	return S3C_TIMERREG(offset);
 }
 
-static cycle_t s5p_timer_read(struct clocksource *cs)
-{
-	void __iomem *reg = s5p_timer_reg();
-
-	return (cycle_t) (reg ? ~__raw_readl(reg) : 0);
-}
-
 /*
  * Override the global weak sched_clock symbol with this
  * local implementation which uses the clocksource to get some
@@ -350,14 +343,6 @@ static void notrace s5p_update_sched_clock(void)
 	update_sched_clock(&cd, ~__raw_readl(reg), (u32)~0);
 }
 
-struct clocksource time_clocksource = {
-	.name		= "s5p_clocksource_timer",
-	.rating		= 250,
-	.read		= s5p_timer_read,
-	.mask		= CLOCKSOURCE_MASK(32),
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
-};
-
 static void __init s5p_clocksource_init(void)
 {
 	unsigned long pclk;
@@ -375,8 +360,9 @@ static void __init s5p_clocksource_init(void)
 
 	init_sched_clock(&cd, s5p_update_sched_clock, 32, clock_rate);
 
-	if (clocksource_register_hz(&time_clocksource, clock_rate))
-		panic("%s: can't register clocksource\n", time_clocksource.name);
+	if (clocksource_mmio_init(s5p_timer_reg(), "s5p_clocksource_timer",
+			clock_rate, 250, 32, clocksource_mmio_readl_down))
+		panic("s5p_clocksource_timer: can't register clocksource\n");
 }
 
 static void __init s5p_timer_resources(void)
-- 
1.7.0.4

