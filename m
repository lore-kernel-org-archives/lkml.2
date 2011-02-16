Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab1BPGfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 01:35:33 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:56012 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab1BPGfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 01:35:02 -0500
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6/6] blackfin: convert to clocksource_register_hz
Date: Tue, 15 Feb 2011 22:34:52 -0800
Message-Id: <1297838092-22989-7-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1297838092-22989-1-git-send-email-johnstul@us.ibm.com>
References: <1297838092-22989-1-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the blackfin clocksource to use clocksource_register_hz.

This is untested, so any assistance in testing would be appreciated!

CC: Mike Frysinger <vapier@gentoo.org>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/blackfin/kernel/time-ts.c |   35 ++---------------------------------
 1 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/arch/blackfin/kernel/time-ts.c b/arch/blackfin/kernel/time-ts.c
index 8c9a43d..4a01371 100644
--- a/arch/blackfin/kernel/time-ts.c
+++ b/arch/blackfin/kernel/time-ts.c
@@ -23,29 +23,6 @@
 #include <asm/gptimers.h>
 #include <asm/nmi.h>
 
-/* Accelerators for sched_clock()
- * convert from cycles(64bits) => nanoseconds (64bits)
- *  basic equation:
- *		ns = cycles / (freq / ns_per_sec)
- *		ns = cycles * (ns_per_sec / freq)
- *		ns = cycles * (10^9 / (cpu_khz * 10^3))
- *		ns = cycles * (10^6 / cpu_khz)
- *
- *	Then we use scaling math (suggested by george@mvista.com) to get:
- *		ns = cycles * (10^6 * SC / cpu_khz) / SC
- *		ns = cycles * cyc2ns_scale / SC
- *
- *	And since SC is a constant power of two, we can convert the div
- *  into a shift.
- *
- *  We can use khz divisor instead of mhz to keep a better precision, since
- *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
- *  (mathieu.desnoyers@polymtl.ca)
- *
- *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
- */
-
-#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
 
 #if defined(CONFIG_CYCLES_CLOCKSOURCE)
 
@@ -63,7 +40,6 @@ static struct clocksource bfin_cs_cycles = {
 	.rating		= 400,
 	.read		= bfin_read_cycles,
 	.mask		= CLOCKSOURCE_MASK(64),
-	.shift		= CYC2NS_SCALE_FACTOR,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -75,10 +51,7 @@ static inline unsigned long long bfin_cs_cycles_sched_clock(void)
 
 static int __init bfin_cs_cycles_init(void)
 {
-	bfin_cs_cycles.mult = \
-		clocksource_hz2mult(get_cclk(), bfin_cs_cycles.shift);
-
-	if (clocksource_register(&bfin_cs_cycles))
+	if (clocksource_register_hz(&bfin_cs_cycles, get_cclk()))
 		panic("failed to register clocksource");
 
 	return 0;
@@ -111,7 +84,6 @@ static struct clocksource bfin_cs_gptimer0 = {
 	.rating		= 350,
 	.read		= bfin_read_gptimer0,
 	.mask		= CLOCKSOURCE_MASK(32),
-	.shift		= CYC2NS_SCALE_FACTOR,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -125,10 +97,7 @@ static int __init bfin_cs_gptimer0_init(void)
 {
 	setup_gptimer0();
 
-	bfin_cs_gptimer0.mult = \
-		clocksource_hz2mult(get_sclk(), bfin_cs_gptimer0.shift);
-
-	if (clocksource_register(&bfin_cs_gptimer0))
+	if (clocksource_register_hz(&bfin_cs_gptimer0, get_sclk()))
 		panic("failed to register clocksource");
 
 	return 0;
-- 
1.7.3.2.146.gca209

