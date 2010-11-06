Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0KFAkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 20:40:07 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41644 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab0KFAkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 20:40:04 -0400
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Clark Williams <williams@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] Greatly improve TSC calibration using a delayed workqueue
Date: Fri,  5 Nov 2010 17:39:45 -0700
Message-Id: <1289003985-29060-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boot to boot the TSC calibration may vary by quite a large amount.

While normal variance of 50-100ppm can easily be seen, the quick
calibration code only requires 500ppm accuracy, which is the limit
of what NTP can correct for.

This can cause problems for systems being used as NTP servers, as
every time they reboot it can take hours for them to calculate the
new drift error caused by the calibration.

The classic trade-off here is calibration accuracy vs slow boot times,
as during the calibration nothing else can run.

This patch uses a delayed workqueue  to calibrate the TSC over the
period of a second. This allows very accurate calibration (in my
tests only varying by 1khz or 0.4ppm boot to boot). Additionally this
refined calibration step does not block the boot process, and only
delays the TSC clocksoure registration by a few seconds in early boot.

Credit to Andi Kleen who suggested using a timer quite awhile back,
but I dismissed it thinking the timer calibration would be done after
the clocksource was registered (which would break things). Forgive
me for my short-sightedness.

This patch has worked very well in my testing, but TSC hardware is
quite varied so it would probably be good to get some extended
testing, possibly pushing inclusion out to 2.6.39.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Clark Williams <williams@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>
---
 arch/x86/kernel/tsc.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 0c40d8b..e88b71e 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -885,7 +885,69 @@ __cpuinit int unsynchronized_tsc(void)
 	return tsc_unstable;
 }
 
-static void __init init_tsc_clocksource(void)
+
+static void calibrate_tsc_work(struct work_struct *work);
+static DECLARE_DELAYED_WORK(tsc_irqwork, calibrate_tsc_work);
+
+static void calibrate_tsc_work(struct work_struct *work)
+{
+	static u64 tsc_start = -1, ref_start;
+	static int hpet;
+	u64 tsc_stop, ref_stop, delta;
+	unsigned long freq;
+
+	/* Don't bother refining TSC on unstable systems */
+	if (check_tsc_unstable())
+		goto out;
+
+	/*
+	 * Since the timer is started early in boot, we may be
+	 * delayed the first time we expire. So set the timer
+	 * again once we know timers are working.
+	 */
+	if (tsc_start == -1) {
+		/*
+		 * Only set hpet once, to avoid mixing hardware
+		 * if the hpet becomes enabled later.
+		 */
+		hpet = is_hpet_enabled();
+		schedule_delayed_work(&tsc_irqwork, HZ);
+		tsc_start = tsc_read_refs(&ref_start, hpet);
+		return;
+	}
+
+	tsc_stop = tsc_read_refs(&ref_stop, hpet);
+
+	/* hpet or pmtimer available ? */
+	if (!hpet && !ref_start && !ref_stop)
+		goto out;
+
+	/* Check, whether the sampling was disturbed by an SMI */
+	if (tsc_start == ULLONG_MAX || tsc_stop == ULLONG_MAX)
+		goto out;
+
+	delta = tsc_stop - tsc_start;
+	delta *= 1000000LL;
+	if (hpet)
+		freq = calc_hpet_ref(delta, ref_start, ref_stop);
+	else
+		freq = calc_pmtimer_ref(delta, ref_start, ref_stop);
+
+	/* Make sure we're within 1% */
+	if (abs(tsc_khz - freq) > tsc_khz/100)
+		goto out;
+
+	tsc_khz = freq;
+	printk(KERN_INFO "Refined TSC clocksource calibration: "
+		"%lu.%03lu MHz.\n", (unsigned long)tsc_khz / 1000,
+					(unsigned long)tsc_khz % 1000);
+
+out:
+	clocksource_register_khz(&clocksource_tsc, tsc_khz);
+}
+
+
+static int __init init_tsc_clocksource(void)
 {
 	if (tsc_clocksource_reliable)
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
@@ -894,8 +956,10 @@ static void __init init_tsc_clocksource(void)
 		clocksource_tsc.rating = 0;
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
 	}
-	clocksource_register_khz(&clocksource_tsc, tsc_khz);
+	schedule_delayed_work(&tsc_irqwork, 0);
+	return 0;
 }
+core_initcall(init_tsc_clocksource);
 
 void __init tsc_init(void)
 {
@@ -949,6 +1013,5 @@ void __init tsc_init(void)
 		mark_tsc_unstable("TSCs unsynchronized");
 
 	check_system_tsc_reliable();
-	init_tsc_clocksource();
 }
 
-- 
1.7.3.2.146.gca209

