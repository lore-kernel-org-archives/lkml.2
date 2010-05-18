Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab0ERPWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:22:40 -0400
Received: from www.tglx.de ([62.245.132.106]:49569 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab0ERPWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:22:37 -0400
Date: Tue, 18 May 2010 17:21:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT Pull] timer cleanups for 2.6.35
Message-ID: <alpine.LFD.2.00.1005181717300.3368@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus-cleanups git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus-cleanups

Mostly acked by relevant maintainers.

Thanks,

	tglx

------------------>
John Stultz (13):
      time: Clean up direct xtime usage in xen
      xtensa: Fix unnecessary setting of xtime
      alpha: Convert alpha to use read/update_persistent_clock
      mn10300: Convert mn10300 to use read/update_persistent_clock
      frv: Convert frv to use read/update_persistent_clock
      h8300: Convert h8300 to use read/update_persistent_clock
      avr32: Convert avr32 to use read/update_persistent_clock
      ia64: Convert ia64 to use read/update_persistent_clock
      blackfin: Convert blackfin to use read/update_persistent_clock
      m32r: Convert m32r to use read/update_peristent_clock
      m68k: Convert m68k to use read/update_persistent_clock
      cris: Convert cris to use read/update_persistent_clock
      sparc: Convert sparc to use read/update_persistent_clock

Peter Huewe (1):
      avr32: Fix typo in read_persistent_clock()


 arch/alpha/Kconfig               |    3 +
 arch/alpha/kernel/time.c         |  101 ++++++++++++++++++--------------------
 arch/avr32/kernel/time.c         |   12 ++--
 arch/blackfin/kernel/time-ts.c   |   13 +++--
 arch/blackfin/kernel/time.c      |   39 ++------------
 arch/cris/Kconfig                |    3 +
 arch/cris/arch-v10/kernel/time.c |   37 +-------------
 arch/cris/arch-v32/kernel/time.c |   40 +--------------
 arch/cris/kernel/time.c          |   20 ++++---
 arch/frv/kernel/time.c           |   34 +++----------
 arch/h8300/kernel/time.c         |   10 +++-
 arch/ia64/kernel/time.c          |   12 ++---
 arch/m32r/kernel/time.c          |   47 +++---------------
 arch/m68k/kernel/time.c          |   11 +++--
 arch/mn10300/Kconfig             |    3 +
 arch/mn10300/kernel/rtc.c        |   27 ++--------
 arch/mn10300/kernel/time.c       |    4 --
 arch/sparc/Kconfig               |    2 +-
 arch/sparc/kernel/time_32.c      |   18 ++-----
 arch/x86/xen/time.c              |    6 +-
 arch/xtensa/kernel/time.c        |    5 --
 21 files changed, 137 insertions(+), 310 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index bd7261e..75fff7e 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -54,6 +54,9 @@ config ARCH_USES_GETTIMEOFFSET
 	bool
 	default y
 
+config GENERIC_CMOS_UPDATE
+        def_bool y
+
 config ZONE_DMA
 	bool
 	default y
diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index 5d08266..5465e93 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -75,8 +75,6 @@ static struct {
 	__u32 last_time;
 	/* ticks/cycle * 2^48 */
 	unsigned long scaled_ticks_per_cycle;
-	/* last time the CMOS clock got updated */
-	time_t last_rtc_update;
 	/* partial unused tick */
 	unsigned long partial_tick;
 } state;
@@ -91,6 +89,52 @@ static inline __u32 rpcc(void)
     return result;
 }
 
+int update_persistent_clock(struct timespec now)
+{
+	return set_rtc_mmss(now.tv_sec);
+}
+
+void read_persistent_clock(struct timespec *ts)
+{
+	unsigned int year, mon, day, hour, min, sec, epoch;
+
+	sec = CMOS_READ(RTC_SECONDS);
+	min = CMOS_READ(RTC_MINUTES);
+	hour = CMOS_READ(RTC_HOURS);
+	day = CMOS_READ(RTC_DAY_OF_MONTH);
+	mon = CMOS_READ(RTC_MONTH);
+	year = CMOS_READ(RTC_YEAR);
+
+	if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
+		sec = bcd2bin(sec);
+		min = bcd2bin(min);
+		hour = bcd2bin(hour);
+		day = bcd2bin(day);
+		mon = bcd2bin(mon);
+		year = bcd2bin(year);
+	}
+
+	/* PC-like is standard; used for year >= 70 */
+	epoch = 1900;
+	if (year < 20)
+		epoch = 2000;
+	else if (year >= 20 && year < 48)
+		/* NT epoch */
+		epoch = 1980;
+	else if (year >= 48 && year < 70)
+		/* Digital UNIX epoch */
+		epoch = 1952;
+
+	printk(KERN_INFO "Using epoch = %d\n", epoch);
+
+	if ((year += epoch) < 1970)
+		year += 100;
+
+	ts->tv_sec = mktime(year, mon, day, hour, min, sec);
+}
+
+
+
 /*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
@@ -123,19 +167,6 @@ irqreturn_t timer_interrupt(int irq, void *dev)
 	if (nticks)
 		do_timer(nticks);
 
-	/*
-	 * If we have an externally synchronized Linux clock, then update
-	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
-	 * called as close as possible to 500 ms before the new second starts.
-	 */
-	if (ntp_synced()
-	    && xtime.tv_sec > state.last_rtc_update + 660
-	    && xtime.tv_nsec >= 500000 - ((unsigned) TICK_SIZE) / 2
-	    && xtime.tv_nsec <= 500000 + ((unsigned) TICK_SIZE) / 2) {
-		int tmp = set_rtc_mmss(xtime.tv_sec);
-		state.last_rtc_update = xtime.tv_sec - (tmp ? 600 : 0);
-	}
-
 	write_sequnlock(&xtime_lock);
 
 #ifndef CONFIG_SMP
@@ -304,7 +335,7 @@ rpcc_after_update_in_progress(void)
 void __init
 time_init(void)
 {
-	unsigned int year, mon, day, hour, min, sec, cc1, cc2, epoch;
+	unsigned int cc1, cc2;
 	unsigned long cycle_freq, tolerance;
 	long diff;
 
@@ -348,43 +379,6 @@ time_init(void)
 	   bogomips yet, but this is close on a 500Mhz box.  */
 	__delay(1000000);
 
-	sec = CMOS_READ(RTC_SECONDS);
-	min = CMOS_READ(RTC_MINUTES);
-	hour = CMOS_READ(RTC_HOURS);
-	day = CMOS_READ(RTC_DAY_OF_MONTH);
-	mon = CMOS_READ(RTC_MONTH);
-	year = CMOS_READ(RTC_YEAR);
-
-	if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		sec = bcd2bin(sec);
-		min = bcd2bin(min);
-		hour = bcd2bin(hour);
-		day = bcd2bin(day);
-		mon = bcd2bin(mon);
-		year = bcd2bin(year);
-	}
-
-	/* PC-like is standard; used for year >= 70 */
-	epoch = 1900;
-	if (year < 20)
-		epoch = 2000;
-	else if (year >= 20 && year < 48)
-		/* NT epoch */
-		epoch = 1980;
-	else if (year >= 48 && year < 70)
-		/* Digital UNIX epoch */
-		epoch = 1952;
-
-	printk(KERN_INFO "Using epoch = %d\n", epoch);
-
-	if ((year += epoch) < 1970)
-		year += 100;
-
-	xtime.tv_sec = mktime(year, mon, day, hour, min, sec);
-	xtime.tv_nsec = 0;
-
-        wall_to_monotonic.tv_sec -= xtime.tv_sec;
-        wall_to_monotonic.tv_nsec = 0;
 
 	if (HZ > (1<<16)) {
 		extern void __you_loose (void);
@@ -394,7 +388,6 @@ time_init(void)
 	state.last_time = cc1;
 	state.scaled_ticks_per_cycle
 		= ((unsigned long) HZ << FIX_SHIFT) / cycle_freq;
-	state.last_rtc_update = 0;
 	state.partial_tick = 0L;
 
 	/* Startup the timer source. */
diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
index f27aa3b..668ed28 100644
--- a/arch/avr32/kernel/time.c
+++ b/arch/avr32/kernel/time.c
@@ -110,17 +110,17 @@ static struct clock_event_device comparator = {
 	.set_mode	= comparator_mode,
 };
 
+void read_persistent_clock(struct timespec *ts)
+{
+	ts->tv_sec = mktime(2007, 1, 1, 0, 0, 0);
+	ts->tv_nsec = 0;
+}
+
 void __init time_init(void)
 {
 	unsigned long counter_hz;
 	int ret;
 
-	xtime.tv_sec = mktime(2007, 1, 1, 0, 0, 0);
-	xtime.tv_nsec = 0;
-
-	set_normalized_timespec(&wall_to_monotonic,
-				-xtime.tv_sec, -xtime.tv_nsec);
-
 	/* figure rate for counter */
 	counter_hz = clk_get_rate(boot_cpu_data.clk);
 	counter.mult = clocksource_hz2mult(counter_hz, counter.shift);
diff --git a/arch/blackfin/kernel/time-ts.c b/arch/blackfin/kernel/time-ts.c
index 17c38c5..08dd3e8 100644
--- a/arch/blackfin/kernel/time-ts.c
+++ b/arch/blackfin/kernel/time-ts.c
@@ -348,9 +348,15 @@ static int __init bfin_clockevent_init(void)
 	return 0;
 }
 
-void __init time_init(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	time_t secs_since_1970 = (365 * 37 + 9) * 24 * 60 * 60;	/* 1 Jan 2007 */
+	ts->tv_sec = secs_since_1970;
+	ts->tv_nsec = 0;
+}
+
+void __init time_init(void)
+{
 
 #ifdef CONFIG_RTC_DRV_BFIN
 	/* [#2663] hack to filter junk RTC values that would cause
@@ -363,11 +369,6 @@ void __init time_init(void)
 	}
 #endif
 
-	/* Initialize xtime. From now on, xtime is updated with timer interrupts */
-	xtime.tv_sec = secs_since_1970;
-	xtime.tv_nsec = 0;
-	set_normalized_timespec(&wall_to_monotonic, -xtime.tv_sec, -xtime.tv_nsec);
-
 	bfin_cs_cycles_init();
 	bfin_cs_gptimer0_init();
 	bfin_clockevent_init();
diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index 13c1ee3..c911361 100644
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -112,11 +112,6 @@ u32 arch_gettimeoffset(void)
 }
 #endif
 
-static inline int set_rtc_mmss(unsigned long nowtime)
-{
-	return 0;
-}
-
 /*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
@@ -126,29 +121,8 @@ __attribute__((l1_text))
 #endif
 irqreturn_t timer_interrupt(int irq, void *dummy)
 {
-	/* last time the cmos clock got updated */
-	static long last_rtc_update;
-
 	write_seqlock(&xtime_lock);
 	do_timer(1);
-
-	/*
-	 * If we have an externally synchronized Linux clock, then update
-	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
-	 * called as close as possible to 500 ms before the new second starts.
-	 */
-	if (ntp_synced() &&
-	    xtime.tv_sec > last_rtc_update + 660 &&
-	    (xtime.tv_nsec / NSEC_PER_USEC) >=
-	    500000 - ((unsigned)TICK_SIZE) / 2
-	    && (xtime.tv_nsec / NSEC_PER_USEC) <=
-	    500000 + ((unsigned)TICK_SIZE) / 2) {
-		if (set_rtc_mmss(xtime.tv_sec) == 0)
-			last_rtc_update = xtime.tv_sec;
-		else
-			/* Do it again in 60s. */
-			last_rtc_update = xtime.tv_sec - 600;
-	}
 	write_sequnlock(&xtime_lock);
 
 #ifdef CONFIG_IPIPE
@@ -161,10 +135,15 @@ irqreturn_t timer_interrupt(int irq, void *dummy)
 	return IRQ_HANDLED;
 }
 
-void __init time_init(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	time_t secs_since_1970 = (365 * 37 + 9) * 24 * 60 * 60;	/* 1 Jan 2007 */
+	ts->tv_sec = secs_since_1970;
+	ts->tv_nsec = 0;
+}
 
+void __init time_init(void)
+{
 #ifdef CONFIG_RTC_DRV_BFIN
 	/* [#2663] hack to filter junk RTC values that would cause
 	 * userspace to have to deal with time values greater than
@@ -176,11 +155,5 @@ void __init time_init(void)
 	}
 #endif
 
-	/* Initialize xtime. From now on, xtime is updated with timer interrupts */
-	xtime.tv_sec = secs_since_1970;
-	xtime.tv_nsec = 0;
-
-	wall_to_monotonic.tv_sec = -xtime.tv_sec;
-
 	time_sched_init(timer_interrupt);
 }
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 059eac6..e25bf44 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -23,6 +23,9 @@ config RWSEM_XCHGADD_ALGORITHM
 config GENERIC_TIME
 	def_bool y
 
+config GENERIC_CMOS_UPDATE
+	def_bool y
+
 config ARCH_USES_GETTIMEOFFSET
 	def_bool y
 
diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index 31ca141..30adae5 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -26,7 +26,6 @@
 /* it will make jiffies at 96 hz instead of 100 hz though */
 #undef USE_CASCADE_TIMERS
 
-extern void update_xtime_from_cmos(void);
 extern int set_rtc_mmss(unsigned long nowtime);
 extern int have_rtc;
 
@@ -188,8 +187,6 @@ stop_watchdog(void)
 #endif	
 }
 
-/* last time the cmos clock got updated */
-static long last_rtc_update = 0;
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
@@ -232,24 +229,6 @@ timer_interrupt(int irq, void *dev_id)
 	do_timer(1);
 	
         cris_do_profile(regs); /* Save profiling information */
-
-	/*
-	 * If we have an externally synchronized Linux clock, then update
-	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
-	 * called as close as possible to 500 ms before the new second starts.
-	 *
-	 * The division here is not time critical since it will run once in 
-	 * 11 minutes
-	 */
-	if (ntp_synced() &&
-	    xtime.tv_sec > last_rtc_update + 660 &&
-	    (xtime.tv_nsec / 1000) >= 500000 - (tick_nsec / 1000) / 2 &&
-	    (xtime.tv_nsec / 1000) <= 500000 + (tick_nsec / 1000) / 2) {
-		if (set_rtc_mmss(xtime.tv_sec) == 0)
-			last_rtc_update = xtime.tv_sec;
-		else
-			last_rtc_update = xtime.tv_sec - 600; /* do it again in 60 s */
-	}
         return IRQ_HANDLED;
 }
 
@@ -274,22 +253,10 @@ time_init(void)
 	 */
 	loops_per_usec = 50;
 
-	if(RTC_INIT() < 0) {
-		/* no RTC, start at 1980 */
-		xtime.tv_sec = 0;
-		xtime.tv_nsec = 0;
+	if(RTC_INIT() < 0)
 		have_rtc = 0;
-	} else {		
-		/* get the current time */
+	else
 		have_rtc = 1;
-		update_xtime_from_cmos();
-	}
-
-	/*
-	 * Initialize wall_to_monotonic such that adding it to xtime will yield zero, the
-	 * tv_nsec field must be normalized (i.e., 0 <= nsec < NSEC_PER_SEC).
-	 */
-	set_normalized_timespec(&wall_to_monotonic, -xtime.tv_sec, -xtime.tv_nsec);
 
 	/* Setup the etrax timers
 	 * Base frequency is 25000 hz, divider 250 -> 100 HZ
diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
index b1920d8..1ee0e10 100644
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -44,7 +44,6 @@ unsigned long timer_regs[NR_CPUS] =
 #endif
 };
 
-extern void update_xtime_from_cmos(void);
 extern int set_rtc_mmss(unsigned long nowtime);
 extern int have_rtc;
 
@@ -198,9 +197,6 @@ handle_watchdog_bite(struct pt_regs* regs)
 #endif
 }
 
-/* Last time the cmos clock got updated. */
-static long last_rtc_update = 0;
-
 /*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick.
@@ -238,25 +234,6 @@ timer_interrupt(int irq, void *dev_id)
 
 	/* Call the real timer interrupt handler */
 	do_timer(1);
-
-	/*
-	 * If we have an externally synchronized Linux clock, then update
-	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
-	 * called as close as possible to 500 ms before the new second starts.
-	 *
-	 * The division here is not time critical since it will run once in
-	 * 11 minutes
-	 */
-	if ((time_status & STA_UNSYNC) == 0 &&
-	    xtime.tv_sec > last_rtc_update + 660 &&
-	    (xtime.tv_nsec / 1000) >= 500000 - (tick_nsec / 1000) / 2 &&
-	    (xtime.tv_nsec / 1000) <= 500000 + (tick_nsec / 1000) / 2) {
-		if (set_rtc_mmss(xtime.tv_sec) == 0)
-			last_rtc_update = xtime.tv_sec;
-		else
-			/* Do it again in 60 s */
-			last_rtc_update = xtime.tv_sec - 600;
-	}
         return IRQ_HANDLED;
 }
 
@@ -309,23 +286,10 @@ time_init(void)
 	 */
 	loops_per_usec = 50;
 
-	if(RTC_INIT() < 0) {
-		/* No RTC, start at 1980 */
-		xtime.tv_sec = 0;
-		xtime.tv_nsec = 0;
+	if(RTC_INIT() < 0)
 		have_rtc = 0;
-	} else {
-		/* Get the current time */
+	else
 		have_rtc = 1;
-		update_xtime_from_cmos();
-	}
-
-	/*
-	 * Initialize wall_to_monotonic such that adding it to
-	 * xtime will yield zero, the tv_nsec field must be normalized
-	 * (i.e., 0 <= nsec < NSEC_PER_SEC).
-	 */
-	set_normalized_timespec(&wall_to_monotonic, -xtime.tv_sec, -xtime.tv_nsec);
 
 	/* Start CPU local timer. */
 	cris_timer_init();
diff --git a/arch/cris/kernel/time.c b/arch/cris/kernel/time.c
index a05dd31..c72730d 100644
--- a/arch/cris/kernel/time.c
+++ b/arch/cris/kernel/time.c
@@ -98,6 +98,8 @@ unsigned long
 get_cmos_time(void)
 {
 	unsigned int year, mon, day, hour, min, sec;
+	if(!have_rtc)
+		return 0;
 
 	sec = CMOS_READ(RTC_SECONDS);
 	min = CMOS_READ(RTC_MINUTES);
@@ -119,19 +121,19 @@ get_cmos_time(void)
 	return mktime(year, mon, day, hour, min, sec);
 }
 
-/* update xtime from the CMOS settings. used when /dev/rtc gets a SET_TIME.
- * TODO: this doesn't reset the fancy NTP phase stuff as do_settimeofday does.
- */
 
-void
-update_xtime_from_cmos(void)
+int update_persistent_clock(struct timespec now)
 {
-	if(have_rtc) {
-		xtime.tv_sec = get_cmos_time();
-		xtime.tv_nsec = 0;
-	}
+	return set_rtc_mmss(now.tv_sec);
 }
 
+void read_persistent_clock(struct timespec *ts)
+{
+	ts->tv_sec = get_cmos_time();
+	ts->tv_nsec = 0;
+}
+
+
 extern void cris_profile_sample(struct pt_regs* regs);
 
 void
diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
index fb0ce75..0ddbbae 100644
--- a/arch/frv/kernel/time.c
+++ b/arch/frv/kernel/time.c
@@ -48,20 +48,12 @@ static struct irqaction timer_irq  = {
 	.name = "timer",
 };
 
-static inline int set_rtc_mmss(unsigned long nowtime)
-{
-	return -1;
-}
-
 /*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
  */
 static irqreturn_t timer_interrupt(int irq, void *dummy)
 {
-	/* last time the cmos clock got updated */
-	static long last_rtc_update = 0;
-
 	profile_tick(CPU_PROFILING);
 	/*
 	 * Here we are in the timer irq handler. We just have irqs locally
@@ -74,22 +66,6 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
 
 	do_timer(1);
 
-	/*
-	 * If we have an externally synchronized Linux clock, then update
-	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
-	 * called as close as possible to 500 ms before the new second starts.
-	 */
-	if (ntp_synced() &&
-	    xtime.tv_sec > last_rtc_update + 660 &&
-	    (xtime.tv_nsec / 1000) >= 500000 - ((unsigned) TICK_SIZE) / 2 &&
-	    (xtime.tv_nsec / 1000) <= 500000 + ((unsigned) TICK_SIZE) / 2
-	    ) {
-		if (set_rtc_mmss(xtime.tv_sec) == 0)
-			last_rtc_update = xtime.tv_sec;
-		else
-			last_rtc_update = xtime.tv_sec - 600; /* do it again in 60 s */
-	}
-
 #ifdef CONFIG_HEARTBEAT
 	static unsigned short n;
 	n++;
@@ -119,7 +95,8 @@ void time_divisor_init(void)
 	__set_TCSR_DATA(0, base >> 8);
 }
 
-void time_init(void)
+
+void read_persistent_clock(struct timespec *ts)
 {
 	unsigned int year, mon, day, hour, min, sec;
 
@@ -135,9 +112,12 @@ void time_init(void)
 
 	if ((year += 1900) < 1970)
 		year += 100;
-	xtime.tv_sec = mktime(year, mon, day, hour, min, sec);
-	xtime.tv_nsec = 0;
+	ts->tv_sec = mktime(year, mon, day, hour, min, sec);
+	ts->tv_nsec = 0;
+}
 
+void time_init(void)
+{
 	/* install scheduling interrupt handler */
 	setup_irq(IRQ_CPU_TIMER0, &timer_irq);
 
diff --git a/arch/h8300/kernel/time.c b/arch/h8300/kernel/time.c
index 7f2d6cf..165005a 100644
--- a/arch/h8300/kernel/time.c
+++ b/arch/h8300/kernel/time.c
@@ -41,7 +41,7 @@ void h8300_timer_tick(void)
 	update_process_times(user_mode(get_irq_regs()));
 }
 
-void __init time_init(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	unsigned int year, mon, day, hour, min, sec;
 
@@ -56,8 +56,12 @@ void __init time_init(void)
 #endif
 	if ((year += 1900) < 1970)
 		year += 100;
-	xtime.tv_sec = mktime(year, mon, day, hour, min, sec);
-	xtime.tv_nsec = 0;
+	ts->tv_sec = mktime(year, mon, day, hour, min, sec);
+	ts->tv_nsec = 0;
+}
+
+void __init time_init(void)
+{
 
 	h8300_timer_setup();
 }
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 47a1927..653b3c4 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -430,18 +430,16 @@ static int __init rtc_init(void)
 }
 module_init(rtc_init);
 
+void read_persistent_clock(struct timespec *ts)
+{
+	efi_gettimeofday(ts);
+}
+
 void __init
 time_init (void)
 {
 	register_percpu_irq(IA64_TIMER_VECTOR, &timer_irqaction);
-	efi_gettimeofday(&xtime);
 	ia64_init_itm();
-
-	/*
-	 * Initialize wall_to_monotonic such that adding it to xtime will yield zero, the
-	 * tv_nsec field must be normalized (i.e., 0 <= nsec < NSEC_PER_SEC).
-	 */
-	set_normalized_timespec(&wall_to_monotonic, -xtime.tv_sec, -xtime.tv_nsec);
 }
 
 /*
diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index 9cedcef..bda8682 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -106,24 +106,6 @@ u32 arch_gettimeoffset(void)
 }
 
 /*
- * In order to set the CMOS clock precisely, set_rtc_mmss has to be
- * called 500 ms after the second nowtime has started, because when
- * nowtime is written into the registers of the CMOS clock, it will
- * jump to the next second precisely 500 ms later. Check the Motorola
- * MC146818A or Dallas DS12887 data sheet for details.
- *
- * BUG: This routine does not handle hour overflow properly; it just
- *      sets the minutes. Usually you won't notice until after reboot!
- */
-static inline int set_rtc_mmss(unsigned long nowtime)
-{
-	return 0;
-}
-
-/* last time the cmos clock got updated */
-static long last_rtc_update = 0;
-
-/*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
  */
@@ -138,23 +120,6 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
-	/*
-	 * If we have an externally synchronized Linux clock, then update
-	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
-	 * called as close as possible to 500 ms before the new second starts.
-	 */
-	write_seqlock(&xtime_lock);
-	if (ntp_synced()
-		&& xtime.tv_sec > last_rtc_update + 660
-		&& (xtime.tv_nsec / 1000) >= 500000 - ((unsigned)TICK_SIZE) / 2
-		&& (xtime.tv_nsec / 1000) <= 500000 + ((unsigned)TICK_SIZE) / 2)
-	{
-		if (set_rtc_mmss(xtime.tv_sec) == 0)
-			last_rtc_update = xtime.tv_sec;
-		else	/* do it again in 60 s */
-			last_rtc_update = xtime.tv_sec - 600;
-	}
-	write_sequnlock(&xtime_lock);
 	/* As we return to user mode fire off the other CPU schedulers..
 	   this is basically because we don't yet share IRQ's around.
 	   This message is rigged to be safe on the 386 - basically it's
@@ -174,7 +139,7 @@ static struct irqaction irq0 = {
 	.name = "MFT2",
 };
 
-void __init time_init(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	unsigned int epoch, year, mon, day, hour, min, sec;
 
@@ -194,11 +159,13 @@ void __init time_init(void)
 		epoch = 1952;
 	year += epoch;
 
-	xtime.tv_sec = mktime(year, mon, day, hour, min, sec);
-	xtime.tv_nsec = (INITIAL_JIFFIES % HZ) * (NSEC_PER_SEC / HZ);
-	set_normalized_timespec(&wall_to_monotonic,
-		-xtime.tv_sec, -xtime.tv_nsec);
+	ts->tv_sec = mktime(year, mon, day, hour, min, sec);
+	ts->tv_nsec = (INITIAL_JIFFIES % HZ) * (NSEC_PER_SEC / HZ);
+}
 
+
+void __init time_init(void)
+{
 #if defined(CONFIG_CHIP_M32102) || defined(CONFIG_CHIP_XNUX2) \
 	|| defined(CONFIG_CHIP_VDEC2) || defined(CONFIG_CHIP_M32700) \
 	|| defined(CONFIG_CHIP_OPSP) || defined(CONFIG_CHIP_M32104)
diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
index 17dc2a3..4926b38 100644
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -73,21 +73,24 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
 	return IRQ_HANDLED;
 }
 
-void __init time_init(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	struct rtc_time time;
+	ts->tv_sec = 0;
+	ts->tv_nsec = 0;
 
 	if (mach_hwclk) {
 		mach_hwclk(0, &time);
 
 		if ((time.tm_year += 1900) < 1970)
 			time.tm_year += 100;
-		xtime.tv_sec = mktime(time.tm_year, time.tm_mon, time.tm_mday,
+		ts->tv_sec = mktime(time.tm_year, time.tm_mon, time.tm_mday,
 				      time.tm_hour, time.tm_min, time.tm_sec);
-		xtime.tv_nsec = 0;
 	}
-	wall_to_monotonic.tv_sec = -xtime.tv_sec;
+}
 
+void __init time_init(void)
+{
 	mach_sched_init(timer_interrupt);
 }
 
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 89faaca..1c4565a 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -37,6 +37,9 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
+config GENERIC_CMOS_UPDATE
+        def_bool y
+
 config GENERIC_FIND_NEXT_BIT
 	def_bool y
 
diff --git a/arch/mn10300/kernel/rtc.c b/arch/mn10300/kernel/rtc.c
index 7978470..815a933 100644
--- a/arch/mn10300/kernel/rtc.c
+++ b/arch/mn10300/kernel/rtc.c
@@ -26,17 +26,15 @@ static long last_rtc_update;
 /* time for RTC to update itself in ioclks */
 static unsigned long mn10300_rtc_update_period;
 
-/*
- * read the current RTC time
- */
-unsigned long __init get_initial_rtc_time(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	struct rtc_time tm;
 
 	get_rtc_time(&tm);
 
-	return mktime(tm.tm_year, tm.tm_mon, tm.tm_mday,
+	ts->tv_sec = mktime(tm.tm_year, tm.tm_mon, tm.tm_mday,
 		      tm.tm_hour, tm.tm_min, tm.tm_sec);
+	ts->tv_nsec = 0;
 }
 
 /*
@@ -110,24 +108,9 @@ static int set_rtc_mmss(unsigned long nowtime)
 	return retval;
 }
 
-void check_rtc_time(void)
+int update_persistent_clock(struct timespec now)
 {
-	/* the RTC clock just finished ticking over again this second
-	 * - if we have an externally synchronized Linux clock, then update
-	 *   RTC clock accordingly every ~11 minutes. set_rtc_mmss() has to be
-	 *   called as close as possible to 500 ms before the new second starts.
-	 */
-	if ((time_status & STA_UNSYNC) == 0 &&
-	    xtime.tv_sec > last_rtc_update + 660 &&
-	    xtime.tv_nsec / 1000 >= 500000 - ((unsigned) TICK_SIZE) / 2 &&
-	    xtime.tv_nsec / 1000 <= 500000 + ((unsigned) TICK_SIZE) / 2
-	    ) {
-		if (set_rtc_mmss(xtime.tv_sec) == 0)
-			last_rtc_update = xtime.tv_sec;
-		else
-			/* do it again in 60s */
-			last_rtc_update = xtime.tv_sec - 600;
-	}
+	return set_rtc_mms(now.tv_sec);
 }
 
 /*
diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
index 395caf0..8f7f6d2 100644
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -111,7 +111,6 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 		/* advance the kernel's time tracking system */
 		profile_tick(CPU_PROFILING);
 		do_timer(1);
-		check_rtc_time();
 	}
 
 	write_sequnlock(&xtime_lock);
@@ -139,9 +138,6 @@ void __init time_init(void)
 	       " (calibrated against RTC)\n",
 	       MN10300_TSCCLK / 1000000, (MN10300_TSCCLK / 10000) % 100);
 
-	xtime.tv_sec = get_initial_rtc_time();
-	xtime.tv_nsec = 0;
-
 	mn10300_last_tsc = TMTSCBC;
 
 	/* use timer 0 & 1 cascaded to tick at as close to HZ as possible */
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 4097f6a..0e8ec2a 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -72,7 +72,7 @@ config ARCH_USES_GETTIMEOFFSET
 
 config GENERIC_CMOS_UPDATE
 	bool
-	default y if SPARC64
+	default y
 
 config GENERIC_CLOCKEVENTS
 	bool
diff --git a/arch/sparc/kernel/time_32.c b/arch/sparc/kernel/time_32.c
index 0d4c09b..4453003 100644
--- a/arch/sparc/kernel/time_32.c
+++ b/arch/sparc/kernel/time_32.c
@@ -78,6 +78,11 @@ __volatile__ unsigned int *master_l10_counter;
 
 u32 (*do_arch_gettimeoffset)(void);
 
+int update_persistent_clock(struct timespec now)
+{
+	return set_rtc_mmss(now.tv_sec);
+}
+
 /*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
@@ -87,9 +92,6 @@ u32 (*do_arch_gettimeoffset)(void);
 
 static irqreturn_t timer_interrupt(int dummy, void *dev_id)
 {
-	/* last time the cmos clock got updated */
-	static long last_rtc_update;
-
 #ifndef CONFIG_SMP
 	profile_tick(CPU_PROFILING);
 #endif
@@ -101,16 +103,6 @@ static irqreturn_t timer_interrupt(int dummy, void *dev_id)
 
 	do_timer(1);
 
-	/* Determine when to update the Mostek clock. */
-	if (ntp_synced() &&
-	    xtime.tv_sec > last_rtc_update + 660 &&
-	    (xtime.tv_nsec / 1000) >= 500000 - ((unsigned) TICK_SIZE) / 2 &&
-	    (xtime.tv_nsec / 1000) <= 500000 + ((unsigned) TICK_SIZE) / 2) {
-	  if (set_rtc_mmss(xtime.tv_sec) == 0)
-	    last_rtc_update = xtime.tv_sec;
-	  else
-	    last_rtc_update = xtime.tv_sec - 600; /* do it again in 60 s */
-	}
 	write_sequnlock(&xtime_lock);
 
 #ifndef CONFIG_SMP
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 0d3f07c..6365df9 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -475,6 +475,7 @@ void xen_timer_resume(void)
 __init void xen_time_init(void)
 {
 	int cpu = smp_processor_id();
+	struct timespec tp;
 
 	clocksource_register(&xen_clocksource);
 
@@ -486,9 +487,8 @@ __init void xen_time_init(void)
 	}
 
 	/* Set initial system time with full resolution */
-	xen_read_wallclock(&xtime);
-	set_normalized_timespec(&wall_to_monotonic,
-				-xtime.tv_sec, -xtime.tv_nsec);
+	xen_read_wallclock(&tp);
+	do_settimeofday(&tp);
 
 	setup_force_cpu_cap(X86_FEATURE_TSC);
 
diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index 19f7df3..19df764 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -60,11 +60,6 @@ static struct irqaction timer_irqaction = {
 
 void __init time_init(void)
 {
-	/* FIXME: xtime&wall_to_monotonic are set in timekeeping_init. */
-	read_persistent_clock(&xtime);
-	set_normalized_timespec(&wall_to_monotonic,
-		-xtime.tv_sec, -xtime.tv_nsec);
-
 #ifdef CONFIG_XTENSA_CALIBRATE_CCOUNT
 	printk("Calibrating CPU frequency ");
 	platform_calibrate_ccount();
