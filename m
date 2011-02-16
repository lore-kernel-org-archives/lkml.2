Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab1BPGf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 01:35:28 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:56112 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab1BPGfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 01:35:00 -0500
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/6] ia64: convert to clocksource_register_hz/khz
Date: Tue, 15 Feb 2011 22:34:48 -0800
Message-Id: <1297838092-22989-3-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1297838092-22989-1-git-send-email-johnstul@us.ibm.com>
References: <1297838092-22989-1-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the ia64 clocksources to use clocksource_register_hz/khz

This is untested, so any assistance in testing would be appreciated!

CC: Tony Luck <tony.luck@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/ia64/kernel/cyclone.c      |    6 +-----
 arch/ia64/kernel/time.c         |    9 ++-------
 arch/ia64/sn/kernel/sn2/timer.c |    6 +-----
 drivers/char/hpet.c             |    6 +-----
 4 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/arch/ia64/kernel/cyclone.c b/arch/ia64/kernel/cyclone.c
index d52f1f7..f64097b 100644
--- a/arch/ia64/kernel/cyclone.c
+++ b/arch/ia64/kernel/cyclone.c
@@ -31,8 +31,6 @@ static struct clocksource clocksource_cyclone = {
         .rating         = 300,
         .read           = read_cyclone,
         .mask           = (1LL << 40) - 1,
-        .mult           = 0, /*to be caluclated*/
-        .shift          = 16,
         .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -118,9 +116,7 @@ int __init init_cyclone_clock(void)
 	/* initialize last tick */
 	cyclone_mc = cyclone_timer;
 	clocksource_cyclone.fsys_mmio = cyclone_timer;
-	clocksource_cyclone.mult = clocksource_hz2mult(CYCLONE_TIMER_FREQ,
-						clocksource_cyclone.shift);
-	clocksource_register(&clocksource_cyclone);
+	clocksource_register_hz(&clocksource_cyclone, CYCLONE_TIMER_FREQ);
 
 	return 0;
 }
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 9702fa9..41c40f0 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -73,8 +73,6 @@ static struct clocksource clocksource_itc = {
 	.rating         = 350,
 	.read           = itc_get_cycles,
 	.mask           = CLOCKSOURCE_MASK(64),
-	.mult           = 0, /*to be calculated*/
-	.shift          = 16,
 	.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
 #ifdef CONFIG_PARAVIRT
 	.resume		= paravirt_clocksource_resume,
@@ -374,11 +372,8 @@ ia64_init_itm (void)
 	ia64_cpu_local_tick();
 
 	if (!itc_clocksource) {
-		/* Sort out mult/shift values: */
-		clocksource_itc.mult =
-			clocksource_hz2mult(local_cpu_data->itc_freq,
-						clocksource_itc.shift);
-		clocksource_register(&clocksource_itc);
+		clocksource_register_hz(&clocksource_itc,
+						local_cpu_data->itc_freq);
 		itc_clocksource = &clocksource_itc;
 	}
 }
diff --git a/arch/ia64/sn/kernel/sn2/timer.c b/arch/ia64/sn/kernel/sn2/timer.c
index 21d6f09..c34efda 100644
--- a/arch/ia64/sn/kernel/sn2/timer.c
+++ b/arch/ia64/sn/kernel/sn2/timer.c
@@ -33,8 +33,6 @@ static struct clocksource clocksource_sn2 = {
         .rating         = 450,
         .read           = read_sn2,
         .mask           = (1LL << 55) - 1,
-        .mult           = 0,
-        .shift          = 10,
         .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -57,9 +55,7 @@ ia64_sn_udelay (unsigned long usecs)
 void __init sn_timer_init(void)
 {
 	clocksource_sn2.fsys_mmio = RTC_COUNTER_ADDR;
-	clocksource_sn2.mult = clocksource_hz2mult(sn_rtc_cycles_per_second,
-							clocksource_sn2.shift);
-	clocksource_register(&clocksource_sn2);
+	clocksource_register_hz(&clocksource_sn2, sn_rtc_cycles_per_second);
 
 	ia64_udelay = &ia64_sn_udelay;
 }
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 7066e80..051474c 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -84,8 +84,6 @@ static struct clocksource clocksource_hpet = {
 	.rating		= 250,
 	.read		= read_hpet,
 	.mask		= CLOCKSOURCE_MASK(64),
-	.mult		= 0,		/* to be calculated */
-	.shift		= 10,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 static struct clocksource *hpet_clocksource;
@@ -934,9 +932,7 @@ int hpet_alloc(struct hpet_data *hdp)
 	if (!hpet_clocksource) {
 		hpet_mctr = (void __iomem *)&hpetp->hp_hpet->hpet_mc;
 		CLKSRC_FSYS_MMIO_SET(clocksource_hpet.fsys_mmio, hpet_mctr);
-		clocksource_hpet.mult = clocksource_hz2mult(hpetp->hp_tick_freq,
-						clocksource_hpet.shift);
-		clocksource_register(&clocksource_hpet);
+		clocksource_register_hz(&clocksource_hpet, hpetp->hp_tick_freq);
 		hpetp->hp_clocksource = &clocksource_hpet;
 		hpet_clocksource = &clocksource_hpet;
 	}
-- 
1.7.3.2.146.gca209

