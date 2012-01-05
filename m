Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab2AEOPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:15:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35645 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932267Ab2AEOPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:15:33 -0500
Date: Thu, 5 Jan 2012 15:13:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer changes for v3.3
Message-ID: <20120105141326.GA329@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

 Thanks,

	Ingo

------------------>
Dan McGee (1):
      time: fix bogus comment in timekeeping_get_ns_raw

Deepak Saxena (4):
      time: x86: Remove CLOCK_TICK_RATE from tsc code
      time: x86: Remove CLOCK_TICK_RATE from mach_timer.h
      time: x86: Remove CLOCK_TICK_RATE from acpi_pm clocksource driver
      time: x86: Replace LATCH with PIT_LATCH in i8253 clocksource driver

John Stultz (7):
      time: Fix spelling mistakes in new comments
      clocksource: m86k: Convert to clocksource_register_hz/khz
      clocksource: parisc: Convert to clocksource_register_hz/khz
      clocksource: um: Convert to clocksource_register_hz/khz
      clocksource: xtensa: Convert to clocksource_register_hz/khz
      clocksource: cris: Convert to clocksource_register_khz
      clocksource: Convert tcb_clksrc to use clocksource_register_hz/khz

Suresh Siddha (1):
      x86, tsc: Skip TSC synchronization checks for tsc=reliable


 arch/cris/arch-v32/kernel/time.c        |    4 +---
 arch/m68k/platform/68328/timers.c       |    4 +---
 arch/m68k/platform/coldfire/dma_timer.c |    5 +----
 arch/m68k/platform/coldfire/pit.c       |    4 +---
 arch/m68k/platform/coldfire/sltimers.c  |    4 +---
 arch/m68k/platform/coldfire/timers.c    |    4 +---
 arch/parisc/kernel/time.c               |    6 +-----
 arch/um/kernel/time.c                   |    6 ++----
 arch/x86/include/asm/mach_timer.h       |    2 +-
 arch/x86/include/asm/tsc.h              |    2 ++
 arch/x86/kernel/tsc.c                   |    6 +++---
 arch/x86/kernel/tsc_sync.c              |    4 ++--
 arch/xtensa/kernel/time.c               |   13 +------------
 drivers/clocksource/acpi_pm.c           |    2 +-
 drivers/clocksource/i8253.c             |    6 +++---
 drivers/clocksource/tcb_clksrc.c        |    4 +---
 kernel/time/timekeeping.c               |   10 +++++-----
 17 files changed, 28 insertions(+), 58 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
index bb978ed..6773fc8 100644
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -47,14 +47,12 @@ static struct clocksource cont_rotime = {
 	.rating = 300,
 	.read   = read_cont_rotime,
 	.mask   = CLOCKSOURCE_MASK(32),
-	.shift  = 10,
 	.flags  = CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static int __init etrax_init_cont_rotime(void)
 {
-	cont_rotime.mult = clocksource_khz2mult(100000, cont_rotime.shift);
-	clocksource_register(&cont_rotime);
+	clocksource_register_khz(&cont_rotime, 100000);
 	return 0;
 }
 arch_initcall(etrax_init_cont_rotime);
diff --git a/arch/m68k/platform/68328/timers.c b/arch/m68k/platform/68328/timers.c
index 309f725..f267886 100644
--- a/arch/m68k/platform/68328/timers.c
+++ b/arch/m68k/platform/68328/timers.c
@@ -93,7 +93,6 @@ static struct clocksource m68328_clk = {
 	.name	= "timer",
 	.rating	= 250,
 	.read	= m68328_read_clk,
-	.shift	= 20,
 	.mask	= CLOCKSOURCE_MASK(32),
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 };
@@ -115,8 +114,7 @@ void hw_timer_init(void)
 
 	/* Enable timer 1 */
 	TCTL |= TCTL_TEN;
-	m68328_clk.mult = clocksource_hz2mult(TICKS_PER_JIFFY*HZ, m68328_clk.shift);
-	clocksource_register(&m68328_clk);
+	clocksource_register_hz(&m68328_clk, TICKS_PER_JIFFY*HZ);
 }
 
 /***************************************************************************/
diff --git a/arch/m68k/platform/coldfire/dma_timer.c b/arch/m68k/platform/coldfire/dma_timer.c
index a5f5628..235ad57 100644
--- a/arch/m68k/platform/coldfire/dma_timer.c
+++ b/arch/m68k/platform/coldfire/dma_timer.c
@@ -44,7 +44,6 @@ static struct clocksource clocksource_cf_dt = {
 	.rating		= 200,
 	.read		= cf_dt_get_cycles,
 	.mask		= CLOCKSOURCE_MASK(32),
-	.shift		= 20,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -60,9 +59,7 @@ static int __init  init_cf_dt_clocksource(void)
 	__raw_writeb(0x00, DTER0);
 	__raw_writel(0x00000000, DTRR0);
 	__raw_writew(DMA_DTMR_CLK_DIV_16 | DMA_DTMR_ENABLE, DTMR0);
-	clocksource_cf_dt.mult = clocksource_hz2mult(DMA_FREQ,
-						     clocksource_cf_dt.shift);
-	return clocksource_register(&clocksource_cf_dt);
+	return clocksource_register_hz(&clocksource_cf_dt, DMA_FREQ);
 }
 
 arch_initcall(init_cf_dt_clocksource);
diff --git a/arch/m68k/platform/coldfire/pit.c b/arch/m68k/platform/coldfire/pit.c
index c2b9809..02663d2 100644
--- a/arch/m68k/platform/coldfire/pit.c
+++ b/arch/m68k/platform/coldfire/pit.c
@@ -144,7 +144,6 @@ static struct clocksource pit_clk = {
 	.name	= "pit",
 	.rating	= 100,
 	.read	= pit_read_clk,
-	.shift	= 20,
 	.mask	= CLOCKSOURCE_MASK(32),
 };
 
@@ -162,8 +161,7 @@ void hw_timer_init(void)
 
 	setup_irq(MCFINT_VECBASE + MCFINT_PIT1, &pit_irq);
 
-	pit_clk.mult = clocksource_hz2mult(FREQ, pit_clk.shift);
-	clocksource_register(&pit_clk);
+	clocksource_register_hz(&pit_clk, FREQ);
 }
 
 /***************************************************************************/
diff --git a/arch/m68k/platform/coldfire/sltimers.c b/arch/m68k/platform/coldfire/sltimers.c
index 6a85daf..b7f822b 100644
--- a/arch/m68k/platform/coldfire/sltimers.c
+++ b/arch/m68k/platform/coldfire/sltimers.c
@@ -114,7 +114,6 @@ static struct clocksource mcfslt_clk = {
 	.name	= "slt",
 	.rating	= 250,
 	.read	= mcfslt_read_clk,
-	.shift	= 20,
 	.mask	= CLOCKSOURCE_MASK(32),
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 };
@@ -136,8 +135,7 @@ void hw_timer_init(void)
 
 	setup_irq(MCF_IRQ_TIMER, &mcfslt_timer_irq);
 
-	mcfslt_clk.mult = clocksource_hz2mult(MCF_BUSCLK, mcfslt_clk.shift);
-	clocksource_register(&mcfslt_clk);
+	clocksource_register_hz(&mcfslt_clk, MCF_BUSCLK);
 
 #ifdef CONFIG_HIGHPROFILE
 	mcfslt_profile_init();
diff --git a/arch/m68k/platform/coldfire/timers.c b/arch/m68k/platform/coldfire/timers.c
index 60242f6..0d90da3 100644
--- a/arch/m68k/platform/coldfire/timers.c
+++ b/arch/m68k/platform/coldfire/timers.c
@@ -88,7 +88,6 @@ static struct clocksource mcftmr_clk = {
 	.name	= "tmr",
 	.rating	= 250,
 	.read	= mcftmr_read_clk,
-	.shift	= 20,
 	.mask	= CLOCKSOURCE_MASK(32),
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 };
@@ -109,8 +108,7 @@ void hw_timer_init(void)
 	__raw_writew(MCFTIMER_TMR_ENORI | MCFTIMER_TMR_CLK16 |
 		MCFTIMER_TMR_RESTART | MCFTIMER_TMR_ENABLE, TA(MCFTIMER_TMR));
 
-	mcftmr_clk.mult = clocksource_hz2mult(FREQ, mcftmr_clk.shift);
-	clocksource_register(&mcftmr_clk);
+	clocksource_register_hz(&mcftmr_clk, FREQ);
 
 	setup_irq(MCF_IRQ_TIMER, &mcftmr_timer_irq);
 
diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index 45b7389..7c07743 100644
--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -198,8 +198,6 @@ static struct clocksource clocksource_cr16 = {
 	.rating			= 300,
 	.read			= read_cr16,
 	.mask			= CLOCKSOURCE_MASK(BITS_PER_LONG),
-	.mult			= 0, /* to be set */
-	.shift			= 22,
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -270,7 +268,5 @@ void __init time_init(void)
 
 	/* register at clocksource framework */
 	current_cr16_khz = PAGE0->mem_10msec/10;  /* kHz */
-	clocksource_cr16.mult = clocksource_khz2mult(current_cr16_khz,
-						clocksource_cr16.shift);
-	clocksource_register(&clocksource_cr16);
+	clocksource_register_khz(&clocksource_cr16, current_cr16_khz);
 }
diff --git a/arch/um/kernel/time.c b/arch/um/kernel/time.c
index a08d9fa..82a6e22 100644
--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -75,8 +75,6 @@ static struct clocksource itimer_clocksource = {
 	.rating		= 300,
 	.read		= itimer_read,
 	.mask		= CLOCKSOURCE_MASK(64),
-	.mult		= 1000,
-	.shift		= 0,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -94,9 +92,9 @@ static void __init setup_itimer(void)
 		clockevent_delta2ns(60 * HZ, &itimer_clockevent);
 	itimer_clockevent.min_delta_ns =
 		clockevent_delta2ns(1, &itimer_clockevent);
-	err = clocksource_register(&itimer_clocksource);
+	err = clocksource_register_hz(&itimer_clocksource, USEC_PER_SEC);
 	if (err) {
-		printk(KERN_ERR "clocksource_register returned %d\n", err);
+		printk(KERN_ERR "clocksource_register_hz returned %d\n", err);
 		return;
 	}
 	clockevents_register_device(&itimer_clockevent);
diff --git a/arch/x86/include/asm/mach_timer.h b/arch/x86/include/asm/mach_timer.h
index 8537285..88d0c3c 100644
--- a/arch/x86/include/asm/mach_timer.h
+++ b/arch/x86/include/asm/mach_timer.h
@@ -15,7 +15,7 @@
 
 #define CALIBRATE_TIME_MSEC 30 /* 30 msecs */
 #define CALIBRATE_LATCH	\
-	((CLOCK_TICK_RATE * CALIBRATE_TIME_MSEC + 1000/2)/1000)
+	((PIT_TICK_RATE * CALIBRATE_TIME_MSEC + 1000/2)/1000)
 
 static inline void mach_prepare_counter(void)
 {
diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 83e2efd..15d9915 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -51,6 +51,8 @@ extern int unsynchronized_tsc(void);
 extern int check_tsc_unstable(void);
 extern unsigned long native_calibrate_tsc(void);
 
+extern int tsc_clocksource_reliable;
+
 /*
  * Boot-time check whether the TSCs are synchronized across
  * all CPUs/cores:
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index db48336..2c9cf0f 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -35,7 +35,7 @@ static int __read_mostly tsc_unstable;
    erroneous rdtsc usage on !cpu_has_tsc processors */
 static int __read_mostly tsc_disabled = -1;
 
-static int tsc_clocksource_reliable;
+int tsc_clocksource_reliable;
 /*
  * Scheduler clock - returns current time in nanosec units.
  */
@@ -178,11 +178,11 @@ static unsigned long calc_pmtimer_ref(u64 deltatsc, u64 pm1, u64 pm2)
 }
 
 #define CAL_MS		10
-#define CAL_LATCH	(CLOCK_TICK_RATE / (1000 / CAL_MS))
+#define CAL_LATCH	(PIT_TICK_RATE / (1000 / CAL_MS))
 #define CAL_PIT_LOOPS	1000
 
 #define CAL2_MS		50
-#define CAL2_LATCH	(CLOCK_TICK_RATE / (1000 / CAL2_MS))
+#define CAL2_LATCH	(PIT_TICK_RATE / (1000 / CAL2_MS))
 #define CAL2_PIT_LOOPS	5000
 
 
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 0aa5fed8..9eba29b 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -113,7 +113,7 @@ void __cpuinit check_tsc_sync_source(int cpu)
 	if (unsynchronized_tsc())
 		return;
 
-	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE)) {
+	if (tsc_clocksource_reliable) {
 		if (cpu == (nr_cpu_ids-1) || system_state != SYSTEM_BOOTING)
 			pr_info(
 			"Skipped synchronization checks as TSC is reliable.\n");
@@ -172,7 +172,7 @@ void __cpuinit check_tsc_sync_target(void)
 {
 	int cpus = 2;
 
-	if (unsynchronized_tsc() || boot_cpu_has(X86_FEATURE_TSC_RELIABLE))
+	if (unsynchronized_tsc() || tsc_clocksource_reliable)
 		return;
 
 	/*
diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index f3e5eb4..ac62f9c 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -41,14 +41,6 @@ static struct clocksource ccount_clocksource = {
 	.rating = 200,
 	.read = ccount_read,
 	.mask = CLOCKSOURCE_MASK(32),
-	/*
-	 * With a shift of 22 the lower limit of the cpu clock is
-	 * 1MHz, where NSEC_PER_CCOUNT is 1000 or a bit less than
-	 * 2^10: Since we have 32 bits and the multiplicator can
-	 * already take up as much as 10 bits, this leaves us with
-	 * remaining upper 22 bits.
-	 */
-	.shift = 22,
 };
 
 static irqreturn_t timer_interrupt(int irq, void *dev_id);
@@ -66,10 +58,7 @@ void __init time_init(void)
 	printk("%d.%02d MHz\n", (int)ccount_per_jiffy/(1000000/HZ),
 			(int)(ccount_per_jiffy/(10000/HZ))%100);
 #endif
-	ccount_clocksource.mult =
-		clocksource_hz2mult(CCOUNT_PER_JIFFY * HZ,
-				ccount_clocksource.shift);
-	clocksource_register(&ccount_clocksource);
+	clocksource_register_hz(&ccount_clocksource, CCOUNT_PER_JIFFY * HZ);
 
 	/* Initialize the linux timer interrupt. */
 
diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index effe797..6b5cf02 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -143,7 +143,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_LE,
 #ifndef CONFIG_X86_64
 #include <asm/mach_timer.h>
 #define PMTMR_EXPECTED_RATE \
-  ((CALIBRATE_LATCH * (PMTMR_TICKS_PER_SEC >> 10)) / (CLOCK_TICK_RATE>>10))
+  ((CALIBRATE_LATCH * (PMTMR_TICKS_PER_SEC >> 10)) / (PIT_TICK_RATE>>10))
 /*
  * Some boards have the PMTMR running way too fast. We check
  * the PMTMR rate against PIT channel 2 to catch these cases.
diff --git a/drivers/clocksource/i8253.c b/drivers/clocksource/i8253.c
index 27c49e6..e7cab2d 100644
--- a/drivers/clocksource/i8253.c
+++ b/drivers/clocksource/i8253.c
@@ -53,7 +53,7 @@ static cycle_t i8253_read(struct clocksource *cs)
 	count |= inb_p(PIT_CH0) << 8;
 
 	/* VIA686a test code... reset the latch if count > max + 1 */
-	if (count > LATCH) {
+	if (count > PIT_LATCH) {
 		outb_p(0x34, PIT_MODE);
 		outb_p(PIT_LATCH & 0xff, PIT_CH0);
 		outb_p(PIT_LATCH >> 8, PIT_CH0);
@@ -114,8 +114,8 @@ static void init_pit_timer(enum clock_event_mode mode,
 	case CLOCK_EVT_MODE_PERIODIC:
 		/* binary, mode 2, LSB/MSB, ch 0 */
 		outb_p(0x34, PIT_MODE);
-		outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
-		outb_p(LATCH >> 8 , PIT_CH0);		/* MSB */
+		outb_p(PIT_LATCH & 0xff , PIT_CH0);	/* LSB */
+		outb_p(PIT_LATCH >> 8 , PIT_CH0);		/* MSB */
 		break;
 
 	case CLOCK_EVT_MODE_SHUTDOWN:
diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index 79c47e8..55d0f95 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -59,7 +59,6 @@ static struct clocksource clksrc = {
 	.rating         = 200,
 	.read           = tc_get_cycles,
 	.mask           = CLOCKSOURCE_MASK(32),
-	.shift          = 18,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -256,7 +255,6 @@ static int __init tcb_clksrc_init(void)
 		best_divisor_idx = i;
 	}
 
-	clksrc.mult = clocksource_hz2mult(divided_rate, clksrc.shift);
 
 	printk(bootinfo, clksrc.name, CONFIG_ATMEL_TCB_CLKSRC_BLOCK,
 			divided_rate / 1000000,
@@ -292,7 +290,7 @@ static int __init tcb_clksrc_init(void)
 	__raw_writel(ATMEL_TC_SYNC, tcaddr + ATMEL_TC_BCR);
 
 	/* and away we go! */
-	clocksource_register(&clksrc);
+	clocksource_register_hz(&clksrc, divided_rate);
 
 	/* channel 2:  periodic and oneshot timer support */
 	setup_clkevents(tc, clk32k_divisor_idx);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 2378413..0c63581 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -131,7 +131,7 @@ static inline s64 timekeeping_get_ns_raw(void)
 	/* calculate the delta since the last update_wall_time: */
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
-	/* return delta convert to nanoseconds using ntp adjusted mult. */
+	/* return delta convert to nanoseconds. */
 	return clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
 }
 
@@ -813,11 +813,11 @@ static void timekeeping_adjust(s64 offset)
 	 * First we shift it down from NTP_SHIFT to clocksource->shifted nsecs.
 	 *
 	 * Note we subtract one in the shift, so that error is really error*2.
-	 * This "saves" dividing(shifting) intererval twice, but keeps the
-	 * (error > interval) comparision as still measuring if error is
+	 * This "saves" dividing(shifting) interval twice, but keeps the
+	 * (error > interval) comparison as still measuring if error is
 	 * larger then half an interval.
 	 *
-	 * Note: It does not "save" on aggrivation when reading the code.
+	 * Note: It does not "save" on aggravation when reading the code.
 	 */
 	error = timekeeper.ntp_error >> (timekeeper.ntp_error_shift - 1);
 	if (error > interval) {
@@ -833,7 +833,7 @@ static void timekeeping_adjust(s64 offset)
 		 * nanosecond, and store the amount rounded up into
 		 * the error. This causes the likely below to be unlikely.
 		 *
-		 * The properfix is to avoid rounding up by using
+		 * The proper fix is to avoid rounding up by using
 		 * the high precision timekeeper.xtime_nsec instead of
 		 * xtime.tv_nsec everywhere. Fixing this will take some
 		 * time.
