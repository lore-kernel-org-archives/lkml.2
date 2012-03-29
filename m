Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933705Ab2C2TEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 15:04:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:58670 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759276Ab2C2TEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 15:04:14 -0400
Date: Thu, 29 Mar 2012 21:04:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [GIT pull] Timer updates for 3.4
Message-ID: <alpine.LFD.2.02.1203292040510.2542@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

Thanks,

	tglx

------------------>
Alok Kataria (1):
      x86, tsc: Skip refined tsc calibration on systems with reliable TSC

Andy Lutomirski (2):
      x86-64: Simplify and optimize vdso clock_gettime monotonic variants
      x86-64: Inline vdso clock_gettime helpers

Cesar Eduardo Barros (1):
      time: remove no_sync_cmos_clock

Jim Cromie (1):
      kernel-time: fix s/then/than/ spelling errors

John Stultz (6):
      time: x86: Fix race switching from vsyscall to non-vsyscall clock
      time: Fix change_clocksource locking
      rtc: Provide flag for rtc devices that don't support UIE
      ntp: Fix leap-second hrtimer livelock
      alarmtimer: Make sure we initialize the rtctimer
      time: Avoid scary backtraces when warning of > 11% adj

Thomas Gleixner (7):
      time: Remove bogus comments
      x86: vdso: Remove bogus locking in update_vsyscall_tz()
      x86: vdso: Use seqcount instead of seqlock
      ia64: vsyscall: Use seqcount instead of seqlock
      x86: vdso: Put declaration before code
      alarmtimer: Don't call rtc_timer_init() when CONFIG_RTC_CLASS=n
      ia64: vsyscall: Add missing paranthesis


 arch/ia64/kernel/asm-offsets.c        |    4 +-
 arch/ia64/kernel/fsys.S               |    2 +-
 arch/ia64/kernel/fsyscall_gtod_data.h |    2 +-
 arch/ia64/kernel/time.c               |   10 +--
 arch/x86/include/asm/vgtod.h          |   17 +++--
 arch/x86/kernel/tsc.c                 |   10 +++
 arch/x86/kernel/vsyscall_64.c         |   25 +++---
 arch/x86/vdso/vclock_gettime.c        |  135 ++++++++++++++++-----------------
 drivers/rtc/interface.c               |    5 +
 drivers/rtc/rtc-mpc5121.c             |    2 +
 include/linux/rtc.h                   |    3 +-
 include/linux/time.h                  |    1 -
 include/linux/timex.h                 |    2 +-
 kernel/time.c                         |    6 --
 kernel/time/alarmtimer.c              |    8 ++
 kernel/time/clocksource.c             |    2 +-
 kernel/time/ntp.c                     |  134 ++++++++++----------------------
 kernel/time/timekeeping.c             |   51 ++++++------
 18 files changed, 193 insertions(+), 226 deletions(-)

diff --git a/arch/ia64/kernel/asm-offsets.c b/arch/ia64/kernel/asm-offsets.c
index af56501..a48bd9a 100644
--- a/arch/ia64/kernel/asm-offsets.c
+++ b/arch/ia64/kernel/asm-offsets.c
@@ -269,8 +269,8 @@ void foo(void)
 	BLANK();
 
 	/* used by fsys_gettimeofday in arch/ia64/kernel/fsys.S */
-	DEFINE(IA64_GTOD_LOCK_OFFSET,
-		offsetof (struct fsyscall_gtod_data_t, lock));
+	DEFINE(IA64_GTOD_SEQ_OFFSET,
+	       offsetof (struct fsyscall_gtod_data_t, seq));
 	DEFINE(IA64_GTOD_WALL_TIME_OFFSET,
 		offsetof (struct fsyscall_gtod_data_t, wall_time));
 	DEFINE(IA64_GTOD_MONO_TIME_OFFSET,
diff --git a/arch/ia64/kernel/fsys.S b/arch/ia64/kernel/fsys.S
index 331d42b..fa77de7 100644
--- a/arch/ia64/kernel/fsys.S
+++ b/arch/ia64/kernel/fsys.S
@@ -174,7 +174,7 @@ ENTRY(fsys_set_tid_address)
 	FSYS_RETURN
 END(fsys_set_tid_address)
 
-#if IA64_GTOD_LOCK_OFFSET !=0
+#if IA64_GTOD_SEQ_OFFSET !=0
 #error fsys_gettimeofday incompatible with changes to struct fsyscall_gtod_data_t
 #endif
 #if IA64_ITC_JITTER_OFFSET !=0
diff --git a/arch/ia64/kernel/fsyscall_gtod_data.h b/arch/ia64/kernel/fsyscall_gtod_data.h
index 57d2ee6..146b15b 100644
--- a/arch/ia64/kernel/fsyscall_gtod_data.h
+++ b/arch/ia64/kernel/fsyscall_gtod_data.h
@@ -6,7 +6,7 @@
  */
 
 struct fsyscall_gtod_data_t {
-	seqlock_t	lock;
+	seqcount_t	seq;
 	struct timespec	wall_time;
 	struct timespec monotonic_time;
 	cycle_t		clk_mask;
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 43920de..8e991a0 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -35,9 +35,7 @@
 
 static cycle_t itc_get_cycles(struct clocksource *cs);
 
-struct fsyscall_gtod_data_t fsyscall_gtod_data = {
-	.lock = __SEQLOCK_UNLOCKED(fsyscall_gtod_data.lock),
-};
+struct fsyscall_gtod_data_t fsyscall_gtod_data;
 
 struct itc_jitter_data_t itc_jitter_data;
 
@@ -460,9 +458,7 @@ void update_vsyscall_tz(void)
 void update_vsyscall(struct timespec *wall, struct timespec *wtm,
 			struct clocksource *c, u32 mult)
 {
-        unsigned long flags;
-
-        write_seqlock_irqsave(&fsyscall_gtod_data.lock, flags);
+	write_seqcount_begin(&fsyscall_gtod_data.seq);
 
         /* copy fsyscall clock data */
         fsyscall_gtod_data.clk_mask = c->mask;
@@ -485,6 +481,6 @@ void update_vsyscall(struct timespec *wall, struct timespec *wtm,
 		fsyscall_gtod_data.monotonic_time.tv_sec++;
 	}
 
-        write_sequnlock_irqrestore(&fsyscall_gtod_data.lock, flags);
+	write_seqcount_end(&fsyscall_gtod_data.seq);
 }
 
diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index 815285b..8b38be2 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -5,13 +5,8 @@
 #include <linux/clocksource.h>
 
 struct vsyscall_gtod_data {
-	seqlock_t	lock;
+	seqcount_t	seq;
 
-	/* open coded 'struct timespec' */
-	time_t		wall_time_sec;
-	u32		wall_time_nsec;
-
-	struct timezone sys_tz;
 	struct { /* extract of a clocksource struct */
 		int vclock_mode;
 		cycle_t	cycle_last;
@@ -19,8 +14,16 @@ struct vsyscall_gtod_data {
 		u32	mult;
 		u32	shift;
 	} clock;
-	struct timespec wall_to_monotonic;
+
+	/* open coded 'struct timespec' */
+	time_t		wall_time_sec;
+	u32		wall_time_nsec;
+	u32		monotonic_time_nsec;
+	time_t		monotonic_time_sec;
+
+	struct timezone sys_tz;
 	struct timespec wall_time_coarse;
+	struct timespec monotonic_time_coarse;
 };
 extern struct vsyscall_gtod_data vsyscall_gtod_data;
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index a62c201..6fcfcb3 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -932,6 +932,16 @@ static int __init init_tsc_clocksource(void)
 		clocksource_tsc.rating = 0;
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
 	}
+
+	/*
+	 * Trust the results of the earlier calibration on systems
+	 * exporting a reliable TSC.
+	 */
+	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE)) {
+		clocksource_register_khz(&clocksource_tsc, tsc_khz);
+		return 0;
+	}
+
 	schedule_delayed_work(&tsc_irqwork, 0);
 	return 0;
 }
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index b07ba93..d5c6986 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -52,10 +52,7 @@
 #include "vsyscall_trace.h"
 
 DEFINE_VVAR(int, vgetcpu_mode);
-DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
-{
-	.lock = __SEQLOCK_UNLOCKED(__vsyscall_gtod_data.lock),
-};
+DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data);
 
 static enum { EMULATE, NATIVE, NONE } vsyscall_mode = EMULATE;
 
@@ -80,20 +77,15 @@ early_param("vsyscall", vsyscall_setup);
 
 void update_vsyscall_tz(void)
 {
-	unsigned long flags;
-
-	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
-	/* sys_tz has changed */
 	vsyscall_gtod_data.sys_tz = sys_tz;
-	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
 void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
 			struct clocksource *clock, u32 mult)
 {
-	unsigned long flags;
+	struct timespec monotonic;
 
-	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
+	write_seqcount_begin(&vsyscall_gtod_data.seq);
 
 	/* copy vsyscall data */
 	vsyscall_gtod_data.clock.vclock_mode	= clock->archdata.vclock_mode;
@@ -101,12 +93,19 @@ void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
 	vsyscall_gtod_data.clock.mask		= clock->mask;
 	vsyscall_gtod_data.clock.mult		= mult;
 	vsyscall_gtod_data.clock.shift		= clock->shift;
+
 	vsyscall_gtod_data.wall_time_sec	= wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec	= wall_time->tv_nsec;
-	vsyscall_gtod_data.wall_to_monotonic	= *wtm;
+
+	monotonic = timespec_add(*wall_time, *wtm);
+	vsyscall_gtod_data.monotonic_time_sec	= monotonic.tv_sec;
+	vsyscall_gtod_data.monotonic_time_nsec	= monotonic.tv_nsec;
+
 	vsyscall_gtod_data.wall_time_coarse	= __current_kernel_time();
+	vsyscall_gtod_data.monotonic_time_coarse =
+		timespec_add(vsyscall_gtod_data.wall_time_coarse, *wtm);
 
-	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
+	write_seqcount_end(&vsyscall_gtod_data.seq);
 }
 
 static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 6bc0e72..885eff4 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -70,100 +70,98 @@ notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 	return ret;
 }
 
+notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
+{
+	long ret;
+
+	asm("syscall" : "=a" (ret) :
+	    "0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
+	return ret;
+}
+
+
 notrace static inline long vgetns(void)
 {
 	long v;
 	cycles_t cycles;
 	if (gtod->clock.vclock_mode == VCLOCK_TSC)
 		cycles = vread_tsc();
-	else
+	else if (gtod->clock.vclock_mode == VCLOCK_HPET)
 		cycles = vread_hpet();
+	else
+		return 0;
 	v = (cycles - gtod->clock.cycle_last) & gtod->clock.mask;
 	return (v * gtod->clock.mult) >> gtod->clock.shift;
 }
 
-notrace static noinline int do_realtime(struct timespec *ts)
+/* Code size doesn't matter (vdso is 4k anyway) and this is faster. */
+notrace static int __always_inline do_realtime(struct timespec *ts)
 {
 	unsigned long seq, ns;
+	int mode;
+
 	do {
-		seq = read_seqbegin(&gtod->lock);
+		seq = read_seqcount_begin(&gtod->seq);
+		mode = gtod->clock.vclock_mode;
 		ts->tv_sec = gtod->wall_time_sec;
 		ts->tv_nsec = gtod->wall_time_nsec;
 		ns = vgetns();
-	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
+
 	timespec_add_ns(ts, ns);
-	return 0;
+	return mode;
 }
 
-notrace static noinline int do_monotonic(struct timespec *ts)
+notrace static int do_monotonic(struct timespec *ts)
 {
-	unsigned long seq, ns, secs;
+	unsigned long seq, ns;
+	int mode;
+
 	do {
-		seq = read_seqbegin(&gtod->lock);
-		secs = gtod->wall_time_sec;
-		ns = gtod->wall_time_nsec + vgetns();
-		secs += gtod->wall_to_monotonic.tv_sec;
-		ns += gtod->wall_to_monotonic.tv_nsec;
-	} while (unlikely(read_seqretry(&gtod->lock, seq)));
-
-	/* wall_time_nsec, vgetns(), and wall_to_monotonic.tv_nsec
-	 * are all guaranteed to be nonnegative.
-	 */
-	while (ns >= NSEC_PER_SEC) {
-		ns -= NSEC_PER_SEC;
-		++secs;
-	}
-	ts->tv_sec = secs;
-	ts->tv_nsec = ns;
+		seq = read_seqcount_begin(&gtod->seq);
+		mode = gtod->clock.vclock_mode;
+		ts->tv_sec = gtod->monotonic_time_sec;
+		ts->tv_nsec = gtod->monotonic_time_nsec;
+		ns = vgetns();
+	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
+	timespec_add_ns(ts, ns);
 
-	return 0;
+	return mode;
 }
 
-notrace static noinline int do_realtime_coarse(struct timespec *ts)
+notrace static int do_realtime_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
-		seq = read_seqbegin(&gtod->lock);
+		seq = read_seqcount_begin(&gtod->seq);
 		ts->tv_sec = gtod->wall_time_coarse.tv_sec;
 		ts->tv_nsec = gtod->wall_time_coarse.tv_nsec;
-	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 	return 0;
 }
 
-notrace static noinline int do_monotonic_coarse(struct timespec *ts)
+notrace static int do_monotonic_coarse(struct timespec *ts)
 {
-	unsigned long seq, ns, secs;
+	unsigned long seq;
 	do {
-		seq = read_seqbegin(&gtod->lock);
-		secs = gtod->wall_time_coarse.tv_sec;
-		ns = gtod->wall_time_coarse.tv_nsec;
-		secs += gtod->wall_to_monotonic.tv_sec;
-		ns += gtod->wall_to_monotonic.tv_nsec;
-	} while (unlikely(read_seqretry(&gtod->lock, seq)));
-
-	/* wall_time_nsec and wall_to_monotonic.tv_nsec are
-	 * guaranteed to be between 0 and NSEC_PER_SEC.
-	 */
-	if (ns >= NSEC_PER_SEC) {
-		ns -= NSEC_PER_SEC;
-		++secs;
-	}
-	ts->tv_sec = secs;
-	ts->tv_nsec = ns;
+		seq = read_seqcount_begin(&gtod->seq);
+		ts->tv_sec = gtod->monotonic_time_coarse.tv_sec;
+		ts->tv_nsec = gtod->monotonic_time_coarse.tv_nsec;
+	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 
 	return 0;
 }
 
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
+	int ret = VCLOCK_NONE;
+
 	switch (clock) {
 	case CLOCK_REALTIME:
-		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE))
-			return do_realtime(ts);
+		ret = do_realtime(ts);
 		break;
 	case CLOCK_MONOTONIC:
-		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE))
-			return do_monotonic(ts);
+		ret = do_monotonic(ts);
 		break;
 	case CLOCK_REALTIME_COARSE:
 		return do_realtime_coarse(ts);
@@ -171,32 +169,33 @@ notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 		return do_monotonic_coarse(ts);
 	}
 
-	return vdso_fallback_gettime(clock, ts);
+	if (ret == VCLOCK_NONE)
+		return vdso_fallback_gettime(clock, ts);
+	return 0;
 }
 int clock_gettime(clockid_t, struct timespec *)
 	__attribute__((weak, alias("__vdso_clock_gettime")));
 
 notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
-	long ret;
-	if (likely(gtod->clock.vclock_mode != VCLOCK_NONE)) {
-		if (likely(tv != NULL)) {
-			BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
-				     offsetof(struct timespec, tv_nsec) ||
-				     sizeof(*tv) != sizeof(struct timespec));
-			do_realtime((struct timespec *)tv);
-			tv->tv_usec /= 1000;
-		}
-		if (unlikely(tz != NULL)) {
-			/* Avoid memcpy. Some old compilers fail to inline it */
-			tz->tz_minuteswest = gtod->sys_tz.tz_minuteswest;
-			tz->tz_dsttime = gtod->sys_tz.tz_dsttime;
-		}
-		return 0;
+	long ret = VCLOCK_NONE;
+
+	if (likely(tv != NULL)) {
+		BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
+			     offsetof(struct timespec, tv_nsec) ||
+			     sizeof(*tv) != sizeof(struct timespec));
+		ret = do_realtime((struct timespec *)tv);
+		tv->tv_usec /= 1000;
 	}
-	asm("syscall" : "=a" (ret) :
-	    "0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
-	return ret;
+	if (unlikely(tz != NULL)) {
+		/* Avoid memcpy. Some old compilers fail to inline it */
+		tz->tz_minuteswest = gtod->sys_tz.tz_minuteswest;
+		tz->tz_dsttime = gtod->sys_tz.tz_dsttime;
+	}
+
+	if (ret == VCLOCK_NONE)
+		return vdso_fallback_gtod(tv, tz);
+	return 0;
 }
 int gettimeofday(struct timeval *, struct timezone *)
 	__attribute__((weak, alias("__vdso_gettimeofday")));
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index dc87eda..eb415bd 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -458,6 +458,11 @@ int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled)
 	if (rtc->uie_rtctimer.enabled == enabled)
 		goto out;
 
+	if (rtc->uie_unsupported) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (enabled) {
 		struct rtc_time tm;
 		ktime_t now, onesec;
diff --git a/drivers/rtc/rtc-mpc5121.c b/drivers/rtc/rtc-mpc5121.c
index 9d3cacc..613447a 100644
--- a/drivers/rtc/rtc-mpc5121.c
+++ b/drivers/rtc/rtc-mpc5121.c
@@ -360,6 +360,8 @@ static int __devinit mpc5121_rtc_probe(struct platform_device *op)
 						&mpc5200_rtc_ops, THIS_MODULE);
 	}
 
+	rtc->rtc->uie_unsupported = 1;
+
 	if (IS_ERR(rtc->rtc)) {
 		err = PTR_ERR(rtc->rtc);
 		goto out_free_irq;
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 93f4d03..fcabfb4 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -202,7 +202,8 @@ struct rtc_device
 	struct hrtimer pie_timer; /* sub second exp, so needs hrtimer */
 	int pie_enabled;
 	struct work_struct irqwork;
-
+	/* Some hardware can't support UIE mode */
+	int uie_unsupported;
 
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	struct work_struct uie_task;
diff --git a/include/linux/time.h b/include/linux/time.h
index b306178..97734e9 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -116,7 +116,6 @@ static inline struct timespec timespec_sub(struct timespec lhs,
 extern void read_persistent_clock(struct timespec *ts);
 extern void read_boot_clock(struct timespec *ts);
 extern int update_persistent_clock(struct timespec now);
-extern int no_sync_cmos_clock __read_mostly;
 void timekeeping_init(void);
 extern int timekeeping_suspended;
 
diff --git a/include/linux/timex.h b/include/linux/timex.h
index b75e186..99bc88b 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -252,7 +252,7 @@ extern void ntp_clear(void);
 /* Returns how long ticks are at present, in ns / 2^NTP_SCALE_SHIFT. */
 extern u64 ntp_tick_length(void);
 
-extern void second_overflow(void);
+extern int second_overflow(unsigned long secs);
 extern int do_adjtimex(struct timex *);
 extern void hardpps(const struct timespec *, const struct timespec *);
 
diff --git a/kernel/time.c b/kernel/time.c
index 73e416d..ba744cf 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -163,7 +163,6 @@ int do_sys_settimeofday(const struct timespec *tv, const struct timezone *tz)
 		return error;
 
 	if (tz) {
-		/* SMP safe, global irq locking makes it work. */
 		sys_tz = *tz;
 		update_vsyscall_tz();
 		if (firsttime) {
@@ -173,12 +172,7 @@ int do_sys_settimeofday(const struct timespec *tv, const struct timezone *tz)
 		}
 	}
 	if (tv)
-	{
-		/* SMP safe, again the code in arch/foo/time.c should
-		 * globally block out interrupts when it runs.
-		 */
 		return do_settimeofday(tv);
-	}
 	return 0;
 }
 
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 8a46f5d..8a538c5 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -96,6 +96,11 @@ static int alarmtimer_rtc_add_device(struct device *dev,
 	return 0;
 }
 
+static inline void alarmtimer_rtc_timer_init(void)
+{
+	rtc_timer_init(&rtctimer, NULL, NULL);
+}
+
 static struct class_interface alarmtimer_rtc_interface = {
 	.add_dev = &alarmtimer_rtc_add_device,
 };
@@ -117,6 +122,7 @@ static inline struct rtc_device *alarmtimer_get_rtcdev(void)
 #define rtcdev (NULL)
 static inline int alarmtimer_rtc_interface_setup(void) { return 0; }
 static inline void alarmtimer_rtc_interface_remove(void) { }
+static inline void alarmtimer_rtc_timer_init(void) { }
 #endif
 
 /**
@@ -783,6 +789,8 @@ static int __init alarmtimer_init(void)
 		.nsleep		= alarm_timer_nsleep,
 	};
 
+	alarmtimer_rtc_timer_init();
+
 	posix_timers_register_clock(CLOCK_REALTIME_ALARM, &alarm_clock);
 	posix_timers_register_clock(CLOCK_BOOTTIME_ALARM, &alarm_clock);
 
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index a45ca16..c958338 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -500,7 +500,7 @@ static u32 clocksource_max_adjustment(struct clocksource *cs)
 {
 	u64 ret;
 	/*
-	 * We won't try to correct for more then 11% adjustments (110,000 ppm),
+	 * We won't try to correct for more than 11% adjustments (110,000 ppm),
 	 */
 	ret = (u64)cs->mult * 11;
 	do_div(ret,100);
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 6e039b1..f03fd83 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -34,8 +34,6 @@ unsigned long			tick_nsec;
 static u64			tick_length;
 static u64			tick_length_base;
 
-static struct hrtimer		leap_timer;
-
 #define MAX_TICKADJ		500LL		/* usecs */
 #define MAX_TICKADJ_SCALED \
 	(((MAX_TICKADJ * NSEC_PER_USEC) << NTP_SCALE_SHIFT) / NTP_INTERVAL_FREQ)
@@ -381,70 +379,63 @@ u64 ntp_tick_length(void)
 
 
 /*
- * Leap second processing. If in leap-insert state at the end of the
- * day, the system clock is set back one second; if in leap-delete
- * state, the system clock is set ahead one second.
+ * this routine handles the overflow of the microsecond field
+ *
+ * The tricky bits of code to handle the accurate clock support
+ * were provided by Dave Mills (Mills@UDEL.EDU) of NTP fame.
+ * They were originally developed for SUN and DEC kernels.
+ * All the kudos should go to Dave for this stuff.
+ *
+ * Also handles leap second processing, and returns leap offset
  */
-static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
+int second_overflow(unsigned long secs)
 {
-	enum hrtimer_restart res = HRTIMER_NORESTART;
-	unsigned long flags;
+	s64 delta;
 	int leap = 0;
+	unsigned long flags;
 
 	spin_lock_irqsave(&ntp_lock, flags);
+
+	/*
+	 * Leap second processing. If in leap-insert state at the end of the
+	 * day, the system clock is set back one second; if in leap-delete
+	 * state, the system clock is set ahead one second.
+	 */
 	switch (time_state) {
 	case TIME_OK:
+		if (time_status & STA_INS)
+			time_state = TIME_INS;
+		else if (time_status & STA_DEL)
+			time_state = TIME_DEL;
 		break;
 	case TIME_INS:
-		leap = -1;
-		time_state = TIME_OOP;
-		printk(KERN_NOTICE
-			"Clock: inserting leap second 23:59:60 UTC\n");
-		hrtimer_add_expires_ns(&leap_timer, NSEC_PER_SEC);
-		res = HRTIMER_RESTART;
+		if (secs % 86400 == 0) {
+			leap = -1;
+			time_state = TIME_OOP;
+			printk(KERN_NOTICE
+				"Clock: inserting leap second 23:59:60 UTC\n");
+		}
 		break;
 	case TIME_DEL:
-		leap = 1;
-		time_tai--;
-		time_state = TIME_WAIT;
-		printk(KERN_NOTICE
-			"Clock: deleting leap second 23:59:59 UTC\n");
+		if ((secs + 1) % 86400 == 0) {
+			leap = 1;
+			time_tai--;
+			time_state = TIME_WAIT;
+			printk(KERN_NOTICE
+				"Clock: deleting leap second 23:59:59 UTC\n");
+		}
 		break;
 	case TIME_OOP:
 		time_tai++;
 		time_state = TIME_WAIT;
-		/* fall through */
+		break;
+
 	case TIME_WAIT:
 		if (!(time_status & (STA_INS | STA_DEL)))
 			time_state = TIME_OK;
 		break;
 	}
-	spin_unlock_irqrestore(&ntp_lock, flags);
 
-	/*
-	 * We have to call this outside of the ntp_lock to keep
-	 * the proper locking hierarchy
-	 */
-	if (leap)
-		timekeeping_leap_insert(leap);
-
-	return res;
-}
-
-/*
- * this routine handles the overflow of the microsecond field
- *
- * The tricky bits of code to handle the accurate clock support
- * were provided by Dave Mills (Mills@UDEL.EDU) of NTP fame.
- * They were originally developed for SUN and DEC kernels.
- * All the kudos should go to Dave for this stuff.
- */
-void second_overflow(void)
-{
-	s64 delta;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ntp_lock, flags);
 
 	/* Bump the maxerror field */
 	time_maxerror += MAXFREQ / NSEC_PER_USEC;
@@ -481,15 +472,17 @@ void second_overflow(void)
 	tick_length += (s64)(time_adjust * NSEC_PER_USEC / NTP_INTERVAL_FREQ)
 							 << NTP_SCALE_SHIFT;
 	time_adjust = 0;
+
+
+
 out:
 	spin_unlock_irqrestore(&ntp_lock, flags);
+
+	return leap;
 }
 
 #ifdef CONFIG_GENERIC_CMOS_UPDATE
 
-/* Disable the cmos update - used by virtualization and embedded */
-int no_sync_cmos_clock  __read_mostly;
-
 static void sync_cmos_clock(struct work_struct *work);
 
 static DECLARE_DELAYED_WORK(sync_cmos_work, sync_cmos_clock);
@@ -536,35 +529,13 @@ static void sync_cmos_clock(struct work_struct *work)
 
 static void notify_cmos_timer(void)
 {
-	if (!no_sync_cmos_clock)
-		schedule_delayed_work(&sync_cmos_work, 0);
+	schedule_delayed_work(&sync_cmos_work, 0);
 }
 
 #else
 static inline void notify_cmos_timer(void) { }
 #endif
 
-/*
- * Start the leap seconds timer:
- */
-static inline void ntp_start_leap_timer(struct timespec *ts)
-{
-	long now = ts->tv_sec;
-
-	if (time_status & STA_INS) {
-		time_state = TIME_INS;
-		now += 86400 - now % 86400;
-		hrtimer_start(&leap_timer, ktime_set(now, 0), HRTIMER_MODE_ABS);
-
-		return;
-	}
-
-	if (time_status & STA_DEL) {
-		time_state = TIME_DEL;
-		now += 86400 - (now + 1) % 86400;
-		hrtimer_start(&leap_timer, ktime_set(now, 0), HRTIMER_MODE_ABS);
-	}
-}
 
 /*
  * Propagate a new txc->status value into the NTP state:
@@ -589,22 +560,6 @@ static inline void process_adj_status(struct timex *txc, struct timespec *ts)
 	time_status &= STA_RONLY;
 	time_status |= txc->status & ~STA_RONLY;
 
-	switch (time_state) {
-	case TIME_OK:
-		ntp_start_leap_timer(ts);
-		break;
-	case TIME_INS:
-	case TIME_DEL:
-		time_state = TIME_OK;
-		ntp_start_leap_timer(ts);
-	case TIME_WAIT:
-		if (!(time_status & (STA_INS | STA_DEL)))
-			time_state = TIME_OK;
-		break;
-	case TIME_OOP:
-		hrtimer_restart(&leap_timer);
-		break;
-	}
 }
 /*
  * Called with the xtime lock held, so we can access and modify
@@ -686,9 +641,6 @@ int do_adjtimex(struct timex *txc)
 		    (txc->tick <  900000/USER_HZ ||
 		     txc->tick > 1100000/USER_HZ))
 			return -EINVAL;
-
-		if (txc->modes & ADJ_STATUS && time_state != TIME_OK)
-			hrtimer_cancel(&leap_timer);
 	}
 
 	if (txc->modes & ADJ_SETOFFSET) {
@@ -1010,6 +962,4 @@ __setup("ntp_tick_adj=", ntp_tick_adj_setup);
 void __init ntp_init(void)
 {
 	ntp_clear();
-	hrtimer_init(&leap_timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
-	leap_timer.function = ntp_leap_second;
 }
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 403c2a0..51b9856 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -184,18 +184,6 @@ static void timekeeping_update(bool clearntp)
 }
 
 
-void timekeeping_leap_insert(int leapsecond)
-{
-	unsigned long flags;
-
-	write_seqlock_irqsave(&timekeeper.lock, flags);
-	timekeeper.xtime.tv_sec += leapsecond;
-	timekeeper.wall_to_monotonic.tv_sec -= leapsecond;
-	timekeeping_update(false);
-	write_sequnlock_irqrestore(&timekeeper.lock, flags);
-
-}
-
 /**
  * timekeeping_forward_now - update clock to the current time
  *
@@ -448,9 +436,12 @@ EXPORT_SYMBOL(timekeeping_inject_offset);
 static int change_clocksource(void *data)
 {
 	struct clocksource *new, *old;
+	unsigned long flags;
 
 	new = (struct clocksource *) data;
 
+	write_seqlock_irqsave(&timekeeper.lock, flags);
+
 	timekeeping_forward_now();
 	if (!new->enable || new->enable(new) == 0) {
 		old = timekeeper.clock;
@@ -458,6 +449,10 @@ static int change_clocksource(void *data)
 		if (old->disable)
 			old->disable(old);
 	}
+	timekeeping_update(true);
+
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+
 	return 0;
 }
 
@@ -827,7 +822,7 @@ static void timekeeping_adjust(s64 offset)
 	int adj;
 
 	/*
-	 * The point of this is to check if the error is greater then half
+	 * The point of this is to check if the error is greater than half
 	 * an interval.
 	 *
 	 * First we shift it down from NTP_SHIFT to clocksource->shifted nsecs.
@@ -835,7 +830,7 @@ static void timekeeping_adjust(s64 offset)
 	 * Note we subtract one in the shift, so that error is really error*2.
 	 * This "saves" dividing(shifting) interval twice, but keeps the
 	 * (error > interval) comparison as still measuring if error is
-	 * larger then half an interval.
+	 * larger than half an interval.
 	 *
 	 * Note: It does not "save" on aggravation when reading the code.
 	 */
@@ -843,7 +838,7 @@ static void timekeeping_adjust(s64 offset)
 	if (error > interval) {
 		/*
 		 * We now divide error by 4(via shift), which checks if
-		 * the error is greater then twice the interval.
+		 * the error is greater than twice the interval.
 		 * If it is greater, we need a bigadjust, if its smaller,
 		 * we can adjust by 1.
 		 */
@@ -874,13 +869,15 @@ static void timekeeping_adjust(s64 offset)
 	} else /* No adjustment needed */
 		return;
 
-	WARN_ONCE(timekeeper.clock->maxadj &&
-			(timekeeper.mult + adj > timekeeper.clock->mult +
-						timekeeper.clock->maxadj),
-			"Adjusting %s more then 11%% (%ld vs %ld)\n",
+	if (unlikely(timekeeper.clock->maxadj &&
+			(timekeeper.mult + adj >
+			timekeeper.clock->mult + timekeeper.clock->maxadj))) {
+		printk_once(KERN_WARNING
+			"Adjusting %s more than 11%% (%ld vs %ld)\n",
 			timekeeper.clock->name, (long)timekeeper.mult + adj,
 			(long)timekeeper.clock->mult +
 				timekeeper.clock->maxadj);
+	}
 	/*
 	 * So the following can be confusing.
 	 *
@@ -952,7 +949,7 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 	u64 nsecps = (u64)NSEC_PER_SEC << timekeeper.shift;
 	u64 raw_nsecs;
 
-	/* If the offset is smaller then a shifted interval, do nothing */
+	/* If the offset is smaller than a shifted interval, do nothing */
 	if (offset < timekeeper.cycle_interval<<shift)
 		return offset;
 
@@ -962,9 +959,11 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 
 	timekeeper.xtime_nsec += timekeeper.xtime_interval << shift;
 	while (timekeeper.xtime_nsec >= nsecps) {
+		int leap;
 		timekeeper.xtime_nsec -= nsecps;
 		timekeeper.xtime.tv_sec++;
-		second_overflow();
+		leap = second_overflow(timekeeper.xtime.tv_sec);
+		timekeeper.xtime.tv_sec += leap;
 	}
 
 	/* Accumulate raw time */
@@ -1018,13 +1017,13 @@ static void update_wall_time(void)
 	 * With NO_HZ we may have to accumulate many cycle_intervals
 	 * (think "ticks") worth of time at once. To do this efficiently,
 	 * we calculate the largest doubling multiple of cycle_intervals
-	 * that is smaller then the offset. We then accumulate that
+	 * that is smaller than the offset.  We then accumulate that
 	 * chunk in one go, and then try to consume the next smaller
 	 * doubled multiple.
 	 */
 	shift = ilog2(offset) - ilog2(timekeeper.cycle_interval);
 	shift = max(0, shift);
-	/* Bound shift to one less then what overflows tick_length */
+	/* Bound shift to one less than what overflows tick_length */
 	maxshift = (64 - (ilog2(ntp_tick_length())+1)) - 1;
 	shift = min(shift, maxshift);
 	while (offset >= timekeeper.cycle_interval) {
@@ -1072,12 +1071,14 @@ static void update_wall_time(void)
 
 	/*
 	 * Finally, make sure that after the rounding
-	 * xtime.tv_nsec isn't larger then NSEC_PER_SEC
+	 * xtime.tv_nsec isn't larger than NSEC_PER_SEC
 	 */
 	if (unlikely(timekeeper.xtime.tv_nsec >= NSEC_PER_SEC)) {
+		int leap;
 		timekeeper.xtime.tv_nsec -= NSEC_PER_SEC;
 		timekeeper.xtime.tv_sec++;
-		second_overflow();
+		leap = second_overflow(timekeeper.xtime.tv_sec);
+		timekeeper.xtime.tv_sec += leap;
 	}
 
 	timekeeping_update(false);
