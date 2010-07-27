Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab0G0KtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 06:49:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:34802 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab0G0KtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 06:49:02 -0400
Date: Tue, 27 Jul 2010 10:48:44 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de
In-Reply-To: <1279068988-21864-11-git-send-email-johnstul@us.ibm.com>
References: <1279068988-21864-11-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/clocksource] x86: Convert common clocksources to use clocksource_register_hz/khz
Message-ID: <tip-f12a15be63d1de9a35971f35f06b73088fa25c3a@git.kernel.org>
Git-Commit-ID: f12a15be63d1de9a35971f35f06b73088fa25c3a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Jul 2010 10:48:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f12a15be63d1de9a35971f35f06b73088fa25c3a
Gitweb:     http://git.kernel.org/tip/f12a15be63d1de9a35971f35f06b73088fa25c3a
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Tue, 13 Jul 2010 17:56:27 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 27 Jul 2010 12:40:55 +0200

x86: Convert common clocksources to use clocksource_register_hz/khz

This converts the most common of the x86 clocksources over to use
clocksource_register_hz/khz.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <1279068988-21864-11-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/hpet.c        |   13 +++++++++----
 arch/x86/kernel/tsc.c         |    5 +----
 drivers/clocksource/acpi_pm.c |    9 ++-------
 3 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ba390d7..33dbcc4 100644
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
index 9faf91a..ce8e502 100644
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
@@ -854,7 +851,7 @@ static void __init init_tsc_clocksource(void)
 		clocksource_tsc.rating = 0;
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
 	}
-	clocksource_register(&clocksource_tsc);
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
