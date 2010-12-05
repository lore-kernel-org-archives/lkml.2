Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab0LELTn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 06:19:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:37459 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab0LELTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 06:19:42 -0500
Date: Sun, 5 Dec 2010 11:18:53 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andi@firstfloor.org, williams@redhat.com, johnstul@us.ibm.com,
        schwidefsky@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, johnstul@us.ibm.com, williams@redhat.com,
        schwidefsky@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1289003985-29060-1-git-send-email-johnstul@us.ibm.com>
References: <1289003985-29060-1-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/tsc] x86: Improve TSC calibration using a delayed workqueue
Message-ID: <tip-08ec0c58fb8a05d3191d5cb6f5d6f81adb419798@git.kernel.org>
Git-Commit-ID: 08ec0c58fb8a05d3191d5cb6f5d6f81adb419798
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 05 Dec 2010 11:18:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08ec0c58fb8a05d3191d5cb6f5d6f81adb419798
Gitweb:     http://git.kernel.org/tip/08ec0c58fb8a05d3191d5cb6f5d6f81adb419798
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Tue, 27 Jul 2010 17:00:00 -0700
Committer:  John Stultz <john.stultz@linaro.org>
CommitDate: Thu, 2 Dec 2010 16:48:37 -0800

x86: Improve TSC calibration using a delayed workqueue

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
If the refined calibration strays 1% from the early boot calibration
value, the system will fall back to already calculated early boot
calibration.

Credit to Andi Kleen who suggested using a timer quite awhile back,
but I dismissed it thinking the timer calibration would be done after
the clocksource was registered (which would break things). Forgive
me for my short-sightedness.

This patch has worked very well in my testing, but TSC hardware is
quite varied so it would probably be good to get some extended
testing, possibly pushing inclusion out to 2.6.39.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <1289003985-29060-1-git-send-email-johnstul@us.ibm.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Clark Williams <williams@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>
---
 arch/x86/kernel/tsc.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 83 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index bb64beb..dc1393e 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -888,7 +888,82 @@ __cpuinit int unsynchronized_tsc(void)
 	return 0;
 }
 
-static void __init init_tsc_clocksource(void)
+
+static void tsc_refine_calibration_work(struct work_struct *work);
+static DECLARE_DELAYED_WORK(tsc_irqwork, tsc_refine_calibration_work);
+/**
+ * tsc_refine_calibration_work - Further refine tsc freq calibration
+ * @work - ignored.
+ *
+ * This functions uses delayed work over a period of a
+ * second to further refine the TSC freq value. Since this is
+ * timer based, instead of loop based, we don't block the boot
+ * process while this longer calibration is done.
+ *
+ * If there are any calibration anomolies (too many SMIs, etc),
+ * or the refined calibration is off by 1% of the fast early
+ * calibration, we throw out the new calibration and use the
+ * early calibration.
+ */
+static void tsc_refine_calibration_work(struct work_struct *work)
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
+	 * Since the work is started early in boot, we may be
+	 * delayed the first time we expire. So set the workqueue
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
@@ -897,8 +972,14 @@ static void __init init_tsc_clocksource(void)
 		clocksource_tsc.rating = 0;
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
 	}
-	clocksource_register_khz(&clocksource_tsc, tsc_khz);
+	schedule_delayed_work(&tsc_irqwork, 0);
+	return 0;
 }
+/*
+ * We use device_initcall here, to ensure we run after the hpet
+ * is fully initialized, which may occur at fs_initcall time.
+ */
+device_initcall(init_tsc_clocksource);
 
 void __init tsc_init(void)
 {
@@ -952,6 +1033,5 @@ void __init tsc_init(void)
 		mark_tsc_unstable("TSCs unsynchronized");
 
 	check_system_tsc_reliable();
-	init_tsc_clocksource();
 }
 
