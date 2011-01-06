Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab1AFKQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:16:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50208 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514Ab1AFKQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:16:03 -0500
Date: Thu, 6 Jan 2011 11:15:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/tsc changes for v2.6.38
Message-ID: <20110106101555.GA22750@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-tsc-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-tsc-for-linus

 Thanks,

	Ingo

------------------>
John Stultz (2):
      x86: Make tsc=reliable override boot time stability checks
      x86: Improve TSC calibration using a delayed workqueue

Thomas Gleixner (1):
      x86: Check tsc available/disabled in the delayed init function


 Documentation/kernel-parameters.txt |    9 ++--
 arch/x86/kernel/tsc.c               |   96 +++++++++++++++++++++++++++++++++--
 2 files changed, 96 insertions(+), 9 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 92e83e5..c7c8eca 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2467,12 +2467,13 @@ and is between 256 and 4096 characters. It is defined in the file
 			to facilitate early boot debugging.
 			See also Documentation/trace/events.txt
 
-	tsc=		Disable clocksource-must-verify flag for TSC.
+	tsc=		Disable clocksource stability checks for TSC.
 			Format: <string>
 			[x86] reliable: mark tsc clocksource as reliable, this
-			disables clocksource verification at runtime.
-			Used to enable high-resolution timer mode on older
-			hardware, and in virtualized environment.
+			disables clocksource verification at runtime, as well
+			as the stability checks done at bootup.	Used to enable
+			high-resolution timer mode on older hardware, and in
+			virtualized environment.
 			[x86] noirqtime: Do not use TSC to do irq accounting.
 			Used to run time disable IRQ_TIME_ACCOUNTING on any
 			platforms where RDTSC is slow and this accounting
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 0c40d8b..356a0d4 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -872,6 +872,9 @@ __cpuinit int unsynchronized_tsc(void)
 
 	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		return 0;
+
+	if (tsc_clocksource_reliable)
+		return 0;
 	/*
 	 * Intel systems are normally all synchronized.
 	 * Exceptions must mark TSC as unstable:
@@ -879,14 +882,92 @@ __cpuinit int unsynchronized_tsc(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
 		/* assume multi socket systems are not synchronized: */
 		if (num_possible_cpus() > 1)
-			tsc_unstable = 1;
+			return 1;
 	}
 
-	return tsc_unstable;
+	return 0;
+}
+
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
 }
 
-static void __init init_tsc_clocksource(void)
+
+static int __init init_tsc_clocksource(void)
 {
+	if (!cpu_has_tsc || tsc_disabled > 0)
+		return 0;
+
 	if (tsc_clocksource_reliable)
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
 	/* lower the rating if we already know its unstable: */
@@ -894,8 +975,14 @@ static void __init init_tsc_clocksource(void)
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
@@ -949,6 +1036,5 @@ void __init tsc_init(void)
 		mark_tsc_unstable("TSCs unsynchronized");
 
 	check_system_tsc_reliable();
-	init_tsc_clocksource();
 }
 
