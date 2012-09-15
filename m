Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab2IOBGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 21:06:50 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35826 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab2IOBGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 21:06:04 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/3] jiffies: Remove compile time assumptions about CLOCK_TICK_RATE
Date: Fri, 14 Sep 2012 21:05:29 -0400
Message-Id: <1347671130-22095-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347671130-22095-1-git-send-email-john.stultz@linaro.org>
References: <1347671130-22095-1-git-send-email-john.stultz@linaro.org>
x-cbid: 12091501-7182-0000-0000-000002A23CB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CLOCK_TICK_RATE is used to accurately caclulate exactly how
a tick will be at a given HZ.

This is useful, because while we'd expect NSEC_PER_SEC/HZ,
the underlying hardware will have some granularity limit,
so we won't be able to have exactly HZ ticks per second.

This slight error can cause timekeeping quality problems
when using the jiffies or other jiffies driven clocksources.
Thus we currently use compile time CLOCK_TICK_RATE value to
generate SHIFTED_HZ and NSEC_PER_JIFFIES, which we then use
to adjust the jiffies clocksource to correct this error.

Unfortunately though, since CLOCK_TICK_RATE is a compile
time value, and the jiffies clocksource is registered very
early during boot, there are a number of cases where there
are different possible hardware timers that have different
tick rates. This causes problems in cases like ARM where
there are numerous different types of hardware, each having
their own compile-time CLOCK_TICK_RATE, making it hard to
accurately support different hardware with a single kernel.

For the most part, this doesn't matter all that much, as not
too many systems actually utilize the jiffies or jiffies driven
clocksource. Usually there are other highres clocksources
who's granularity error is negligable.

Even so, we have some complicated calcualtions that we do
everywhere to handle these edge cases.

This patch removes the compile time SHIFTED_HZ value, and
introduces a register_refined_jiffies() function. This results
in the default jiffies clock as being assumed a perfect HZ
freq, and allows archtectures that care about jiffies accuracy
to call register_refined_jiffies() with the tick rate, specified
dynamically at boot.

This allows us, where necessary, to not have a compile time
CLOCK_TICK_RATE constant, simplifies the jiffies code, and
still provides a way to have an accurate jiffies clock.

NOTE: Since this patch does not add register_refinied_jiffies()
calls for every arch, it may cause time quality regressions
in some cases. Its likely these will not be noticable, but
if they are an issue, adding the following to the end of
setup_arch() should resolve the regression:
	register_refinied_jiffies(CLOCK_TICK_RATE)

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/x86/kernel/setup.c |    3 +++
 include/linux/jiffies.h |   15 ++-------------
 kernel/time/jiffies.c   |   32 +++++++++++++++++++++++++++++++-
 3 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f4b9b80..4062f15 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -68,6 +68,7 @@
 #include <linux/percpu.h>
 #include <linux/crash_dump.h>
 #include <linux/tboot.h>
+#include <linux/jiffies.h>
 
 #include <video/edid.h>
 
@@ -1034,6 +1035,8 @@ void __init setup_arch(char **cmdline_p)
 	mcheck_init();
 
 	arch_init_ideal_nops();
+
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 #ifdef CONFIG_X86_32
diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 4a7e386..388edb5 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -51,21 +51,10 @@
 #define SH_DIV(NOM,DEN,LSH) (   (((NOM) / (DEN)) << (LSH))              \
                              + ((((NOM) % (DEN)) << (LSH)) + (DEN) / 2) / (DEN))
 
-#ifdef CLOCK_TICK_RATE
-/* LATCH is used in the interval timer and ftape setup. */
-# define LATCH ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
-
-/*
- * HZ is the requested value. However the CLOCK_TICK_RATE may not allow
- * for exactly HZ. So SHIFTED_HZ is high res HZ ("<< 8" is for accuracy)
- */
-# define SHIFTED_HZ (SH_DIV(CLOCK_TICK_RATE, LATCH, 8))
-#else
-# define SHIFTED_HZ (HZ << 8)
-#endif
+extern int register_refined_jiffies(long clock_tick_rate);
 
 /* TICK_NSEC is the time between ticks in nsec assuming SHIFTED_HZ */
-#define TICK_NSEC (SH_DIV(1000000UL * 1000, SHIFTED_HZ, 8))
+#define TICK_NSEC ((NSEC_PER_SEC+HZ/2)/HZ)
 
 /* TICK_USEC is the time between ticks in usec assuming fake USER_HZ */
 #define TICK_USEC ((1000000UL + USER_HZ/2) / USER_HZ)
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 46da053..6629bf7 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -37,7 +37,7 @@
  * requested HZ value. It is also not recommended
  * for "tick-less" systems.
  */
-#define NSEC_PER_JIFFY	((u32)((((u64)NSEC_PER_SEC)<<8)/SHIFTED_HZ))
+#define NSEC_PER_JIFFY	((NSEC_PER_SEC+HZ/2)/HZ)
 
 /* Since jiffies uses a simple NSEC_PER_JIFFY multiplier
  * conversion, the .shift value could be zero. However
@@ -95,3 +95,33 @@ struct clocksource * __init __weak clocksource_default_clock(void)
 {
 	return &clocksource_jiffies;
 }
+
+struct clocksource refined_jiffies;
+
+int register_refined_jiffies(long cycles_per_second)
+{
+	u64 nsec_per_tick, shift_hz;
+	long cycles_per_tick;
+
+
+
+	refined_jiffies = clocksource_jiffies;
+	refined_jiffies.name = "refined-jiffies";
+	refined_jiffies.rating++;
+
+	/* Calc cycles per tick */
+	cycles_per_tick = (cycles_per_second + HZ/2)/HZ;
+	/* shift_hz stores hz<<8 for extra accuracy */
+	shift_hz = (u64)cycles_per_second << 8;
+	shift_hz += cycles_per_tick/2;
+	do_div(shift_hz, cycles_per_tick);
+	/* Calculate nsec_per_tick using shift_hz */
+	nsec_per_tick = (u64)NSEC_PER_SEC << 8;
+	nsec_per_tick += (u32)shift_hz/2;
+	do_div(nsec_per_tick, (u32)shift_hz);
+
+	refined_jiffies.mult = ((u32)nsec_per_tick) << JIFFIES_SHIFT;
+
+	clocksource_register(&refined_jiffies);
+	return 0;
+}
-- 
1.7.9.5

