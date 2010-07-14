Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab0GNA5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 20:57:48 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41334 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968Ab0GNA4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 20:56:31 -0400
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 10/11] Convert common x86 clocksources to use clocksource_register_hz/khz
Date: Tue, 13 Jul 2010 17:56:27 -0700
Message-Id: <1279068988-21864-11-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1279068988-21864-10-git-send-email-johnstul@us.ibm.com>
References: <1279068988-21864-1-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-2-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-3-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-4-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-5-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-6-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-7-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-8-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-9-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-10-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the most common of the x86 clocksources over to use
clocksource_register_hz/khz.

CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/x86/kernel/hpet.c        |   13 +++++++++----
 arch/x86/kernel/tsc.c         |    6 ++----
 drivers/clocksource/acpi_pm.c |    9 ++-------
 3 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index a198b7c..54dac04 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -16,7 +16,6 @@
 #include <asm/hpet.h>
 
 #define HPET_MASK			CLOCKSOURCE_MASK(32)
-#define HPET_SHIFT			22
 
 /* FSEC = 10^-15
    NSEC = 10^-9 */
@@ -787,7 +786,6 @@ static struct clocksource clocksource_hpet = {
 	.rating		= 250,
 	.read		= read_hpet,
 	.mask		= HPET_MASK,
-	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= hpet_resume_counter,
 #ifdef CONFIG_X86_64
@@ -798,6 +796,7 @@ static struct clocksource clocksource_hpet = {
 static int hpet_clocksource_register(void)
 {
 	u64 start, now;
+	u64 hpet_freq;
 	cycle_t t1;
 
 	/* Start the counter */
@@ -832,9 +831,15 @@ static int hpet_clocksource_register(void)
 	 *  mult = (hpet_period * 2^shift)/10^6
 	 *  mult = (hpet_period << shift)/FSEC_PER_NSEC
 	 */
-	clocksource_hpet.mult = div_sc(hpet_period, FSEC_PER_NSEC, HPET_SHIFT);
 
-	clocksource_register(&clocksource_hpet);
+	/* Need to convert hpet_period (fsec/cyc) to cyc/sec:
+	 * 
+	 * cyc/sec = FSEC_PER_SEC/hpet_period(fsec/cyc)
+	 * cyc/sec = (FSEC_PER_NSEC * NSEC_PER_SEC)/hpet_period
+	 */
+	hpet_freq = FSEC_PER_NSEC * NSEC_PER_SEC;
+	do_div(hpet_freq, hpet_period);
+	clocksource_register_hz(&clocksource_hpet, (u32)hpet_freq);
 
 	return 0;
 }
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 9faf91a..5ca6370 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -751,7 +751,6 @@ static struct clocksource clocksource_tsc = {
 	.read                   = read_tsc,
 	.resume			= resume_tsc,
 	.mask                   = CLOCKSOURCE_MASK(64),
-	.shift                  = 22,
 	.flags                  = CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
 #ifdef CONFIG_X86_64
@@ -845,8 +844,6 @@ __cpuinit int unsynchronized_tsc(void)
 
 static void __init init_tsc_clocksource(void)
 {
-	clocksource_tsc.mult = clocksource_khz2mult(tsc_khz,
-			clocksource_tsc.shift);
 	if (tsc_clocksource_reliable)
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
 	/* lower the rating if we already know its unstable: */
@@ -854,7 +851,8 @@ static void __init init_tsc_clocksource(void)
 		clocksource_tsc.rating = 0;
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
 	}
-	clocksource_register(&clocksource_tsc);
+	
+	clocksource_register_khz(&clocksource_tsc, tsc_khz);
 }
 
 #ifdef CONFIG_X86_64
diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 72a633a..cfb0f52 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -68,10 +68,7 @@ static struct clocksource clocksource_acpi_pm = {
 	.rating		= 200,
 	.read		= acpi_pm_read,
 	.mask		= (cycle_t)ACPI_PM_MASK,
-	.mult		= 0, /*to be calculated*/
-	.shift		= 22,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
-
 };
 
 
@@ -190,9 +187,6 @@ static int __init init_acpi_pm_clocksource(void)
 	if (!pmtmr_ioport)
 		return -ENODEV;
 
-	clocksource_acpi_pm.mult = clocksource_hz2mult(PMTMR_TICKS_PER_SEC,
-						clocksource_acpi_pm.shift);
-
 	/* "verify" this timing source: */
 	for (j = 0; j < ACPI_PM_MONOTONICITY_CHECKS; j++) {
 		udelay(100 * j);
@@ -220,7 +214,8 @@ static int __init init_acpi_pm_clocksource(void)
 	if (verify_pmtmr_rate() != 0)
 		return -ENODEV;
 
-	return clocksource_register(&clocksource_acpi_pm);
+	return clocksource_register_hz(&clocksource_acpi_pm,
+						PMTMR_TICKS_PER_SEC);
 }
 
 /* We use fs_initcall because we want the PCI fixups to have run
-- 
1.6.0.4

