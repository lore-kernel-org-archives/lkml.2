Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab1KOEE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:04:26 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:50382 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab1KOEEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:04:24 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 16/16] time: Rework update_vsyscall to pass timekeeper
Date: Mon, 14 Nov 2011 20:04:06 -0800
Message-Id: <1321329846-14755-17-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
References: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
x-cbid: 11111504-7282-0000-0000-000003C8004C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather then trying to pass fragments of values out to the
vsyscall code, pass the entire timekeeper structure.

This will allow vsyscalls to utilize the fractional shifted
nanoseconds.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/ia64/kernel/time.c       |   28 ++++++++--------
 arch/powerpc/kernel/time.c    |   25 +++++++------
 arch/s390/kernel/time.c       |   18 +++++-----
 arch/x86/kernel/vsyscall_64.c |   21 ++++++-----
 include/linux/clocksource.h   |    9 -----
 include/linux/timekeeper.h    |   75 +++++++++++++++++++++++++++++++++++++++++
 kernel/time/timekeeping.c     |   59 +-------------------------------
 7 files changed, 124 insertions(+), 111 deletions(-)
 create mode 100644 include/linux/timekeeper.h

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 43920de..170e381 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -20,6 +20,7 @@
 #include <linux/efi.h>
 #include <linux/timex.h>
 #include <linux/clocksource.h>
+#include <linux/timekeeper.h>
 #include <linux/platform_device.h>
 
 #include <asm/machvec.h>
@@ -457,27 +458,26 @@ void update_vsyscall_tz(void)
 {
 }
 
-void update_vsyscall(struct timespec *wall, struct timespec *wtm,
-			struct clocksource *c, u32 mult)
+void update_vsyscall(struct timekeeper *tk)
 {
         unsigned long flags;
 
         write_seqlock_irqsave(&fsyscall_gtod_data.lock, flags);
 
-        /* copy fsyscall clock data */
-        fsyscall_gtod_data.clk_mask = c->mask;
-        fsyscall_gtod_data.clk_mult = mult;
-        fsyscall_gtod_data.clk_shift = c->shift;
-        fsyscall_gtod_data.clk_fsys_mmio = c->archdata.fsys_mmio;
-        fsyscall_gtod_data.clk_cycle_last = c->cycle_last;
+	/* copy fsyscall clock data */
+	fsyscall_gtod_data.clk_mask = tk->clock->mask;
+	fsyscall_gtod_data.clk_mult = tk->mult;
+	fsyscall_gtod_data.clk_shift = tk->shift;
+	fsyscall_gtod_data.clk_fsys_mmio = tk->clock->archdata.fsys_mmio;
+	fsyscall_gtod_data.clk_cycle_last = tk->clock->cycle_last;
 
 	/* copy kernel time structures */
-        fsyscall_gtod_data.wall_time.tv_sec = wall->tv_sec;
-        fsyscall_gtod_data.wall_time.tv_nsec = wall->tv_nsec;
-	fsyscall_gtod_data.monotonic_time.tv_sec = wtm->tv_sec
-							+ wall->tv_sec;
-	fsyscall_gtod_data.monotonic_time.tv_nsec = wtm->tv_nsec
-							+ wall->tv_nsec;
+	fsyscall_gtod_data.wall_time.tv_sec = tk->xtime_sec;
+	fsyscall_gtod_data.wall_time.tv_nsec = tk->xtime_nsec >> tk->shift;
+	fsyscall_gtod_data.monotonic_time.tv_sec = tk->xtime_sec
+						+ tk->wall_to_monotonic.tv_sec;
+	fsyscall_gtod_data.monotonic_time.tv_nsec =
+		(tk->xtime_nsec >> tk->shift) + tk->wall_to_monotonic.tv_nsec;
 
 	/* normalize */
 	while (fsyscall_gtod_data.monotonic_time.tv_nsec >= NSEC_PER_SEC) {
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 522bb1d..1ffe695 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -54,6 +54,7 @@
 #include <linux/irq.h>
 #include <linux/delay.h>
 #include <linux/irq_work.h>
+#include <linux/timekeeper.h>
 #include <asm/trace.h>
 
 #include <asm/io.h>
@@ -811,13 +812,12 @@ static cycle_t timebase_read(struct clocksource *cs)
 	return (cycle_t)get_tb();
 }
 
-void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
-			struct clocksource *clock, u32 mult)
+void update_vsyscall(struct timekeeper *tk);
 {
 	u64 new_tb_to_xs, new_stamp_xsec;
 	u32 frac_sec;
 
-	if (clock != &clocksource_timebase)
+	if (tk->clock != &clocksource_timebase)
 		return;
 
 	/* Make userspace gettimeofday spin until we're done. */
@@ -826,14 +826,14 @@ void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
 
 	/* XXX this assumes clock->shift == 22 */
 	/* 4611686018 ~= 2^(20+64-22) / 1e9 */
-	new_tb_to_xs = (u64) mult * 4611686018ULL;
-	new_stamp_xsec = (u64) wall_time->tv_nsec * XSEC_PER_SEC;
+	new_tb_to_xs = (u64) tk->mult * 4611686018ULL;
+	new_stamp_xsec = (u64) (tk->xtime_nsec >> tk->shift) * XSEC_PER_SEC;
 	do_div(new_stamp_xsec, 1000000000);
-	new_stamp_xsec += (u64) wall_time->tv_sec * XSEC_PER_SEC;
+	new_stamp_xsec += (u64) tk->xtime_sec * XSEC_PER_SEC;
 
-	BUG_ON(wall_time->tv_nsec >= NSEC_PER_SEC);
+	BUG_ON((tk->xtime_nsec >> tk->shift) >= NSEC_PER_SEC);
 	/* this is tv_nsec / 1e9 as a 0.32 fraction */
-	frac_sec = ((u64) wall_time->tv_nsec * 18446744073ULL) >> 32;
+	frac_sec = ((u64) (tk->xtime_nsec >> tk->shift) * 18446744073ULL) >> 32;
 
 	/*
 	 * tb_update_count is used to allow the userspace gettimeofday code
@@ -846,12 +846,13 @@ void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
 	 * We expect the caller to have done the first increment of
 	 * vdso_data->tb_update_count already.
 	 */
-	vdso_data->tb_orig_stamp = clock->cycle_last;
+	vdso_data->tb_orig_stamp = tk->clock->cycle_last;
 	vdso_data->stamp_xsec = new_stamp_xsec;
 	vdso_data->tb_to_xs = new_tb_to_xs;
-	vdso_data->wtom_clock_sec = wtm->tv_sec;
-	vdso_data->wtom_clock_nsec = wtm->tv_nsec;
-	vdso_data->stamp_xtime = *wall_time;
+	vdso_data->wtom_clock_sec = tk->wall_to_monotonic.tv_sec;
+	vdso_data->wtom_clock_nsec = tk->wall_to_monotonic.tv_nsec;
+	vdso_data->stamp_xtime.tv_sec = tk->xtime_sec;
+	vdso_data->stamp_xtime.tv_nsec = (tk->xtime_nsec >> tk->shift);
 	vdso_data->stamp_sec_fraction = frac_sec;
 	smp_wmb();
 	++(vdso_data->tb_update_count);
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index ebbfab3..f624449 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -36,6 +36,7 @@
 #include <linux/timex.h>
 #include <linux/notifier.h>
 #include <linux/clocksource.h>
+#include <linux/timekeeper.h>
 #include <linux/clockchips.h>
 #include <linux/gfp.h>
 #include <linux/kprobes.h>
@@ -217,21 +218,20 @@ struct clocksource * __init clocksource_default_clock(void)
 	return &clocksource_tod;
 }
 
-void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
-			struct clocksource *clock, u32 mult)
+void update_vsyscall(struct timekeeper *tk);
 {
-	if (clock != &clocksource_tod)
+	if (tk->clock != &clocksource_tod)
 		return;
 
 	/* Make userspace gettimeofday spin until we're done. */
 	++vdso_data->tb_update_count;
 	smp_wmb();
-	vdso_data->xtime_tod_stamp = clock->cycle_last;
-	vdso_data->xtime_clock_sec = wall_time->tv_sec;
-	vdso_data->xtime_clock_nsec = wall_time->tv_nsec;
-	vdso_data->wtom_clock_sec = wtm->tv_sec;
-	vdso_data->wtom_clock_nsec = wtm->tv_nsec;
-	vdso_data->ntp_mult = mult;
+	vdso_data->xtime_tod_stamp = tk->clock->cycle_last;
+	vdso_data->xtime_clock_sec = tk->xtime_sec;
+	vdso_data->xtime_clock_nsec = (tk->xtime_nsec >> tk->shift);
+	vdso_data->wtom_clock_sec = tk->wall_to_monotonic.tv_sec;
+	vdso_data->wtom_clock_nsec = tk->wall_to_monotonic.tv_nsec;
+	vdso_data->ntp_mult = tk->mult;
 	smp_wmb();
 	++vdso_data->tb_update_count;
 }
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index e4d4a22..f78c6fd 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -27,6 +27,7 @@
 #include <linux/sysctl.h>
 #include <linux/topology.h>
 #include <linux/clocksource.h>
+#include <linux/timekeeper.h>
 #include <linux/getcpu.h>
 #include <linux/cpu.h>
 #include <linux/smp.h>
@@ -88,22 +89,22 @@ void update_vsyscall_tz(void)
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
-void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
-			struct clocksource *clock, u32 mult)
+void update_vsyscall(struct timekeeper *tk)
 {
 	unsigned long flags;
 
 	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
 
 	/* copy vsyscall data */
-	vsyscall_gtod_data.clock.vclock_mode	= clock->archdata.vclock_mode;
-	vsyscall_gtod_data.clock.cycle_last	= clock->cycle_last;
-	vsyscall_gtod_data.clock.mask		= clock->mask;
-	vsyscall_gtod_data.clock.mult		= mult;
-	vsyscall_gtod_data.clock.shift		= clock->shift;
-	vsyscall_gtod_data.wall_time_sec	= wall_time->tv_sec;
-	vsyscall_gtod_data.wall_time_nsec	= wall_time->tv_nsec;
-	vsyscall_gtod_data.wall_to_monotonic	= *wtm;
+	vsyscall_gtod_data.clock.vclock_mode	=
+						tk->clock->archdata.vclock_mode;
+	vsyscall_gtod_data.clock.cycle_last	= tk->clock->cycle_last;
+	vsyscall_gtod_data.clock.mask		= tk->clock->mask;
+	vsyscall_gtod_data.clock.mult		= tk->mult;
+	vsyscall_gtod_data.clock.shift		= tk->clock->shift;
+	vsyscall_gtod_data.wall_time_sec	= tk->xtime_sec;
+	vsyscall_gtod_data.wall_time_nsec	= tk->xtime_nsec >> tk->shift;
+	vsyscall_gtod_data.wall_to_monotonic	= tk->wall_to_monotonic;
 	vsyscall_gtod_data.wall_time_coarse	= __current_kernel_time();
 
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 139c4db..d21d5f0 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -321,17 +321,8 @@ clocksource_calc_mult_shift(struct clocksource *cs, u32 freq, u32 minsec)
 }
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
-extern void
-update_vsyscall(struct timespec *ts, struct timespec *wtm,
-			struct clocksource *c, u32 mult);
 extern void update_vsyscall_tz(void);
 #else
-static inline void
-update_vsyscall(struct timespec *ts, struct timespec *wtm,
-			struct clocksource *c, u32 mult)
-{
-}
-
 static inline void update_vsyscall_tz(void)
 {
 }
diff --git a/include/linux/timekeeper.h b/include/linux/timekeeper.h
new file mode 100644
index 0000000..89d1b0c
--- /dev/null
+++ b/include/linux/timekeeper.h
@@ -0,0 +1,75 @@
+#ifndef _LINUX_TIMEKEEPER_H
+#define _LINUX_TIMEKEEPER_H
+
+#include <linux/clocksource.h>
+
+/* 
+ * You should not include this unless you are arch 
+ * specific vsyscall code!
+ */
+
+/* Structure holding internal timekeeping values. */
+struct timekeeper {
+	/* Current clocksource used for timekeeping. */
+	struct clocksource *clock;
+	/* NTP adjusted clock multiplier */
+	u32	mult;
+	/* The shift value of the current clocksource. */
+	int	shift;
+
+	/* Number of clock cycles in one NTP interval. */
+	cycle_t cycle_interval;
+	/* Number of clock shifted nano seconds in one NTP interval. */
+	u64	xtime_interval;
+	/* shifted nano seconds left over when rounding cycle_interval */
+	s64	xtime_remainder;
+	/* Raw nano seconds accumulated per NTP interval. */
+	u32	raw_interval;
+
+	/* Current CLOCK_REALTIME time in seconds */
+	u64	xtime_sec;
+	/* Clock shifted nano seconds */
+	u64	xtime_nsec;
+
+	/* Difference between accumulated time and NTP time in ntp
+	 * shifted nano seconds. */
+	s64	ntp_error;
+	/* Shift conversion between clock shifted nano seconds and
+	 * ntp shifted nano seconds. */
+	int	ntp_error_shift;
+
+	/*
+	 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
+	 * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
+	 * at zero at system boot time, so wall_to_monotonic will be negative,
+	 * however, we will ALWAYS keep the tv_nsec part positive so we can use
+	 * the usual normalization.
+	 *
+	 * wall_to_monotonic is moved after resume from suspend for the
+	 * monotonic time not to jump. We need to add total_sleep_time to
+	 * wall_to_monotonic to get the real boot based time offset.
+	 *
+	 * - wall_to_monotonic is no longer the boot time, getboottime must be
+	 * used instead.
+	 */
+	struct timespec wall_to_monotonic;
+	/* time spent in suspend */
+	struct timespec total_sleep_time;
+	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
+	struct timespec raw_time;
+
+	/* Seqlock for all timekeeper values */
+	seqlock_t lock;
+};
+
+#ifdef CONFIG_GENERIC_TIME_VSYSCALL
+extern void
+update_vsyscall(struct timekeeper *tk);
+#else
+static inline void
+update_vsyscall(struct timekeeper *tk)
+{
+}
+#endif
+
+#endif /* _LINUX_TIMEKEEPER_H */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ba595a3..0f28d36 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -20,60 +20,7 @@
 #include <linux/time.h>
 #include <linux/tick.h>
 #include <linux/stop_machine.h>
-
-/* Structure holding internal timekeeping values. */
-struct timekeeper {
-	/* Current clocksource used for timekeeping. */
-	struct clocksource *clock;
-	/* NTP adjusted clock multiplier */
-	u32	mult;
-	/* The shift value of the current clocksource. */
-	int	shift;
-
-	/* Number of clock cycles in one NTP interval. */
-	cycle_t cycle_interval;
-	/* Number of clock shifted nano seconds in one NTP interval. */
-	u64	xtime_interval;
-	/* shifted nano seconds left over when rounding cycle_interval */
-	s64	xtime_remainder;
-	/* Raw nano seconds accumulated per NTP interval. */
-	u32	raw_interval;
-
-	/* Current CLOCK_REALTIME time in seconds */
-	u64	xtime_sec;
-	/* Clock shifted nano seconds */
-	u64	xtime_nsec;
-
-	/* Difference between accumulated time and NTP time in ntp
-	 * shifted nano seconds. */
-	s64	ntp_error;
-	/* Shift conversion between clock shifted nano seconds and
-	 * ntp shifted nano seconds. */
-	int	ntp_error_shift;
-
-	/*
-	 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
-	 * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
-	 * at zero at system boot time, so wall_to_monotonic will be negative,
-	 * however, we will ALWAYS keep the tv_nsec part positive so we can use
-	 * the usual normalization.
-	 *
-	 * wall_to_monotonic is moved after resume from suspend for the
-	 * monotonic time not to jump. We need to add total_sleep_time to
-	 * wall_to_monotonic to get the real boot based time offset.
-	 *
-	 * - wall_to_monotonic is no longer the boot time, getboottime must be
-	 * used instead.
-	 */
-	struct timespec wall_to_monotonic;
-	/* time spent in suspend */
-	struct timespec total_sleep_time;
-	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
-	struct timespec raw_time;
-
-	/* Seqlock for all timekeeper values */
-	seqlock_t lock;
-};
+#include <linux/timekeeper.h>
 
 static struct timekeeper timekeeper;
 
@@ -208,13 +155,11 @@ static inline s64 timekeeping_get_ns_raw(void)
 /* must hold write on timekeeper.lock */
 static void timekeeping_update(struct timekeeper *tk, bool clearntp)
 {
-	struct timespec xt;
 	if (clearntp) {
 		tk->ntp_error = 0;
 		ntp_clear();
 	}
-	xt = timekeeper_xtime(tk);
-	update_vsyscall(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult);
+	update_vsyscall(tk);
 }
 
 
-- 
1.7.3.2.146.gca209

