Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab0G1CGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 22:06:49 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46065 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab0G1CGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 22:06:44 -0400
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Clark Williams <williams@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: [RFC][PATCH 2/2] Greatly improve TSC calibration using a timer
Date: Tue, 27 Jul 2010 19:06:42 -0700
Message-Id: <1280282802-10618-2-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1280282802-10618-1-git-send-email-johnstul@us.ibm.com>
References: <1280282802-10618-1-git-send-email-johnstul@us.ibm.com>
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

This patch uses a timer later in the boot process to calibrate the TSC
over a two second period. This allows very accurate calibration (in my
tests only varying by 1khz or 0.4ppm boot to boot). Additionally this
refined calibration step does not block the boot process, and only
delays the TSC clocksoure registration by a few seconds in early boot.

Credit to Andi Kleen who suggested this idea quite awhile back, but
I dismissed it thinking the timer calibration would be done after
the clocksource was registered (which would break things). Forgive
me for my short-sightedness.

This patch has worked very well in my testing, but TSC hardware is
quite varied so it would probably be good to get some extended
testing, possibly pushing inclusion out to 2.6.37.

These two patches also apply onto the changes already picked up in the
-tip timers/clocksource branch.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Clark Williams <williams@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>
---
 arch/x86/kernel/tsc.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 5ca6370..28bde64 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -842,6 +842,70 @@ __cpuinit int unsynchronized_tsc(void)
 	return tsc_unstable;
 }
 
+
+static struct timer_list tsc_calibrate_timer;
+
+static void calibrate_tsc_timer(unsigned long dummy)
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
+
+		/* We limit it to 2 seconds as pmtmr wraps quickly */
+		tsc_calibrate_timer.expires = jiffies + HZ*2;
+		add_timer(&tsc_calibrate_timer);
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
+	printk(KERN_INFO, "Refined TSC clocksource calibration: "
+		"%lu.%03lu MHz.\n", (unsigned long)tsc_khz / 1000,
+					(unsigned long)tsc_khz % 1000);
+
+out:
+	clocksource_register_khz(&clocksource_tsc, tsc_khz);
+}
+
+
 static void __init init_tsc_clocksource(void)
 {
 	if (tsc_clocksource_reliable)
@@ -851,8 +915,11 @@ static void __init init_tsc_clocksource(void)
 		clocksource_tsc.rating = 0;
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
 	}
-	
-	clocksource_register_khz(&clocksource_tsc, tsc_khz);
+
+	init_timer(&tsc_calibrate_timer);
+	tsc_calibrate_timer.function = calibrate_tsc_timer;
+	tsc_calibrate_timer.expires = jiffies + 1;
+	add_timer(&tsc_calibrate_timer);
 }
 
 #ifdef CONFIG_X86_64
-- 
1.6.0.4

