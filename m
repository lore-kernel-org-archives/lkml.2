Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934683Ab1ESUc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:32:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50201 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933813Ab1ESUcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:32:55 -0400
Date: Thu, 19 May 2011 22:32:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timers/clocksource changes for v2.6.40
Message-ID: <20110519203236.GA21843@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-clocksource-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-clocksource-for-linus

 Thanks,

	Ingo

------------------>
John Stultz (7):
      x86: Convert remaining x86 clocksources to clocksource_register_hz/khz
      ia64: convert to clocksource_register_hz/khz
      microblaze: convert to clocksource_register_hz/khz
      alpha: convert to clocksource_register_hz
      sparc: convert to clocksource_register_hz/khz
      mips: convert to clocksource_register_hz/khz
      blackfin: convert to clocksource_register_hz

Russell King (4):
      clocksource: add common i8253 PIT clocksource
      clocksource: convert footbridge to generic i8253 clocksource
      clocksource: convert x86 to generic i8253 clocksource
      clocksource: convert mips to generic i8253 clocksource

Russell King - ARM Linux (1):
      Make clocksource name const


 arch/alpha/kernel/time.c                        |    3 +-
 arch/arm/include/asm/i8253.h                    |   15 ++++
 arch/arm/mach-footbridge/Kconfig                |    2 +
 arch/arm/mach-footbridge/isa-timer.c            |   45 +-----------
 arch/blackfin/kernel/time-ts.c                  |   35 +---------
 arch/ia64/kernel/cyclone.c                      |    6 +--
 arch/ia64/kernel/time.c                         |    9 +--
 arch/ia64/sn/kernel/sn2/timer.c                 |    6 +--
 arch/microblaze/kernel/timer.c                  |    6 +--
 arch/mips/Kconfig                               |    1 +
 arch/mips/alchemy/common/time.c                 |    3 +-
 arch/mips/cavium-octeon/csrc-octeon.c           |    3 +-
 arch/mips/include/asm/i8253.h                   |    5 ++
 arch/mips/include/asm/time.h                    |    6 --
 arch/mips/jz4740/time.c                         |    3 +-
 arch/mips/kernel/cevt-txx9.c                    |    3 +-
 arch/mips/kernel/csrc-bcm1480.c                 |    3 +-
 arch/mips/kernel/csrc-ioasic.c                  |    4 +-
 arch/mips/kernel/csrc-powertv.c                 |   35 +--------
 arch/mips/kernel/csrc-r4k.c                     |    4 +-
 arch/mips/kernel/csrc-sb1250.c                  |    3 +-
 arch/mips/kernel/i8253.c                        |   78 +--------------------
 arch/mips/loongson/common/cs5536/cs5536_mfgpt.c |    5 +-
 arch/mips/sgi-ip27/ip27-timer.c                 |    3 +-
 arch/x86/Kconfig                                |    1 +
 arch/x86/include/asm/i8253.h                    |    2 +
 arch/x86/kernel/apb_timer.c                     |   10 +---
 arch/x86/kernel/i8253.c                         |   80 +--------------------
 arch/x86/kernel/kvmclock.c                      |    6 +--
 arch/x86/lguest/boot.c                          |    4 +-
 arch/x86/platform/uv/uv_time.c                  |    6 +--
 arch/x86/xen/time.c                             |    6 +--
 drivers/Kconfig                                 |    3 +
 drivers/char/hpet.c                             |    6 +--
 drivers/clocksource/Kconfig                     |    2 +
 drivers/clocksource/Makefile                    |    1 +
 drivers/clocksource/cyclone.c                   |   10 +--
 drivers/clocksource/i8253.c                     |   88 +++++++++++++++++++++++
 include/linux/clocksource.h                     |    4 +-
 39 files changed, 158 insertions(+), 357 deletions(-)
 create mode 100644 arch/arm/include/asm/i8253.h
 create mode 100644 drivers/clocksource/Kconfig
 create mode 100644 drivers/clocksource/i8253.c

diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index 918e8e0..818e74e 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -375,8 +375,7 @@ static struct clocksource clocksource_rpcc = {
 
 static inline void register_rpcc_clocksource(long cycle_freq)
 {
-	clocksource_calc_mult_shift(&clocksource_rpcc, cycle_freq, 4);
-	clocksource_register(&clocksource_rpcc);
+	clocksource_register_hz(&clocksource_rpcc, cycle_freq);
 }
 #else /* !CONFIG_SMP */
 static inline void register_rpcc_clocksource(long cycle_freq)
diff --git a/arch/arm/include/asm/i8253.h b/arch/arm/include/asm/i8253.h
new file mode 100644
index 0000000..70656b6
--- /dev/null
+++ b/arch/arm/include/asm/i8253.h
@@ -0,0 +1,15 @@
+#ifndef __ASMARM_I8253_H
+#define __ASMARM_I8253_H
+
+/* i8253A PIT registers */
+#define PIT_MODE	0x43
+#define PIT_CH0		0x40
+
+#define PIT_LATCH	((PIT_TICK_RATE + HZ / 2) / HZ)
+
+extern raw_spinlock_t i8253_lock;
+
+#define outb_pit	outb_p
+#define inb_pit		inb_p
+
+#endif
diff --git a/arch/arm/mach-footbridge/Kconfig b/arch/arm/mach-footbridge/Kconfig
index bdd2579..46adca0 100644
--- a/arch/arm/mach-footbridge/Kconfig
+++ b/arch/arm/mach-footbridge/Kconfig
@@ -4,6 +4,7 @@ menu "Footbridge Implementations"
 
 config ARCH_CATS
 	bool "CATS"
+	select CLKSRC_I8253
 	select FOOTBRIDGE_HOST
 	select ISA
 	select ISA_DMA
@@ -59,6 +60,7 @@ config ARCH_EBSA285_HOST
 
 config ARCH_NETWINDER
 	bool "NetWinder"
+	select CLKSRC_I8253
 	select FOOTBRIDGE_HOST
 	select ISA
 	select ISA_DMA
diff --git a/arch/arm/mach-footbridge/isa-timer.c b/arch/arm/mach-footbridge/isa-timer.c
index 441c6ce..7020f1a 100644
--- a/arch/arm/mach-footbridge/isa-timer.c
+++ b/arch/arm/mach-footbridge/isa-timer.c
@@ -10,53 +10,16 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/io.h>
+#include <linux/spinlock.h>
 #include <linux/timex.h>
 
 #include <asm/irq.h>
-
+#include <asm/i8253.h>
 #include <asm/mach/time.h>
 
 #include "common.h"
 
-#define PIT_MODE	0x43
-#define PIT_CH0		0x40
-
-#define PIT_LATCH	((PIT_TICK_RATE + HZ / 2) / HZ)
-
-static cycle_t pit_read(struct clocksource *cs)
-{
-	unsigned long flags;
-	static int old_count;
-	static u32 old_jifs;
-	int count;
-	u32 jifs;
-
-	raw_local_irq_save(flags);
-
-	jifs = jiffies;
-	outb_p(0x00, PIT_MODE);		/* latch the count */
-	count = inb_p(PIT_CH0);		/* read the latched count */
-	count |= inb_p(PIT_CH0) << 8;
-
-	if (count > old_count && jifs == old_jifs)
-		count = old_count;
-
-	old_count = count;
-	old_jifs = jifs;
-
-	raw_local_irq_restore(flags);
-
-	count = (PIT_LATCH - 1) - count;
-
-	return (cycle_t)(jifs * PIT_LATCH) + count;
-}
-
-static struct clocksource pit_cs = {
-	.name		= "pit",
-	.rating		= 110,
-	.read		= pit_read,
-	.mask		= CLOCKSOURCE_MASK(32),
-};
+DEFINE_RAW_SPINLOCK(i8253_lock);
 
 static void pit_set_mode(enum clock_event_mode mode,
 	struct clock_event_device *evt)
@@ -121,7 +84,7 @@ static void __init isa_timer_init(void)
 	pit_ce.max_delta_ns = clockevent_delta2ns(0x7fff, &pit_ce);
 	pit_ce.min_delta_ns = clockevent_delta2ns(0x000f, &pit_ce);
 
-	clocksource_register_hz(&pit_cs, PIT_TICK_RATE);
+	clocksource_i8253_init();
 
 	setup_irq(pit_ce.irq, &pit_timer_irq);
 	clockevents_register_device(&pit_ce);
diff --git a/arch/blackfin/kernel/time-ts.c b/arch/blackfin/kernel/time-ts.c
index cdb4beb..9e9b60d 100644
--- a/arch/blackfin/kernel/time-ts.c
+++ b/arch/blackfin/kernel/time-ts.c
@@ -23,29 +23,6 @@
 #include <asm/gptimers.h>
 #include <asm/nmi.h>
 
-/* Accelerators for sched_clock()
- * convert from cycles(64bits) => nanoseconds (64bits)
- *  basic equation:
- *		ns = cycles / (freq / ns_per_sec)
- *		ns = cycles * (ns_per_sec / freq)
- *		ns = cycles * (10^9 / (cpu_khz * 10^3))
- *		ns = cycles * (10^6 / cpu_khz)
- *
- *	Then we use scaling math (suggested by george@mvista.com) to get:
- *		ns = cycles * (10^6 * SC / cpu_khz) / SC
- *		ns = cycles * cyc2ns_scale / SC
- *
- *	And since SC is a constant power of two, we can convert the div
- *  into a shift.
- *
- *  We can use khz divisor instead of mhz to keep a better precision, since
- *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
- *  (mathieu.desnoyers@polymtl.ca)
- *
- *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
- */
-
-#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
 
 #if defined(CONFIG_CYCLES_CLOCKSOURCE)
 
@@ -63,7 +40,6 @@ static struct clocksource bfin_cs_cycles = {
 	.rating		= 400,
 	.read		= bfin_read_cycles,
 	.mask		= CLOCKSOURCE_MASK(64),
-	.shift		= CYC2NS_SCALE_FACTOR,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -75,10 +51,7 @@ static inline unsigned long long bfin_cs_cycles_sched_clock(void)
 
 static int __init bfin_cs_cycles_init(void)
 {
-	bfin_cs_cycles.mult = \
-		clocksource_hz2mult(get_cclk(), bfin_cs_cycles.shift);
-
-	if (clocksource_register(&bfin_cs_cycles))
+	if (clocksource_register_hz(&bfin_cs_cycles, get_cclk()))
 		panic("failed to register clocksource");
 
 	return 0;
@@ -111,7 +84,6 @@ static struct clocksource bfin_cs_gptimer0 = {
 	.rating		= 350,
 	.read		= bfin_read_gptimer0,
 	.mask		= CLOCKSOURCE_MASK(32),
-	.shift		= CYC2NS_SCALE_FACTOR,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -125,10 +97,7 @@ static int __init bfin_cs_gptimer0_init(void)
 {
 	setup_gptimer0();
 
-	bfin_cs_gptimer0.mult = \
-		clocksource_hz2mult(get_sclk(), bfin_cs_gptimer0.shift);
-
-	if (clocksource_register(&bfin_cs_gptimer0))
+	if (clocksource_register_hz(&bfin_cs_gptimer0, get_sclk()))
 		panic("failed to register clocksource");
 
 	return 0;
diff --git a/arch/ia64/kernel/cyclone.c b/arch/ia64/kernel/cyclone.c
index 1b811c6..f64097b 100644
--- a/arch/ia64/kernel/cyclone.c
+++ b/arch/ia64/kernel/cyclone.c
@@ -31,8 +31,6 @@ static struct clocksource clocksource_cyclone = {
         .rating         = 300,
         .read           = read_cyclone,
         .mask           = (1LL << 40) - 1,
-        .mult           = 0, /*to be calculated*/
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
index 156ad80..04440cc 100644
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
@@ -365,11 +363,8 @@ ia64_init_itm (void)
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
diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
index d8a214f..e5550ce 100644
--- a/arch/microblaze/kernel/timer.c
+++ b/arch/microblaze/kernel/timer.c
@@ -217,16 +217,12 @@ static struct clocksource clocksource_microblaze = {
 	.rating		= 300,
 	.read		= microblaze_read,
 	.mask		= CLOCKSOURCE_MASK(32),
-	.shift		= 8, /* I can shift it */
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static int __init microblaze_clocksource_init(void)
 {
-	clocksource_microblaze.mult =
-			clocksource_hz2mult(timer_clock_freq,
-						clocksource_microblaze.shift);
-	if (clocksource_register(&clocksource_microblaze))
+	if (clocksource_register_hz(&clocksource_microblaze, timer_clock_freq))
 		panic("failed to register clocksource");
 
 	/* stop timer1 */
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 8e256cc..f7f6419 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2339,6 +2339,7 @@ config MMU
 
 config I8253
 	bool
+	select CLKSRC_I8253
 	select MIPS_EXTERNAL_TIMER
 
 config ZONE_DMA32
diff --git a/arch/mips/alchemy/common/time.c b/arch/mips/alchemy/common/time.c
index 2aecb2f..d5da6ad 100644
--- a/arch/mips/alchemy/common/time.c
+++ b/arch/mips/alchemy/common/time.c
@@ -141,8 +141,7 @@ static int __init alchemy_time_init(unsigned int m2int)
 		goto cntr_err;
 
 	/* register counter1 clocksource and event device */
-	clocksource_set_clock(&au1x_counter1_clocksource, 32768);
-	clocksource_register(&au1x_counter1_clocksource);
+	clocksource_register_hz(&au1x_counter1_clocksource, 32768);
 
 	cd->shift = 32;
 	cd->mult = div_sc(32768, NSEC_PER_SEC, cd->shift);
diff --git a/arch/mips/cavium-octeon/csrc-octeon.c b/arch/mips/cavium-octeon/csrc-octeon.c
index 26bf711..29d56af 100644
--- a/arch/mips/cavium-octeon/csrc-octeon.c
+++ b/arch/mips/cavium-octeon/csrc-octeon.c
@@ -105,8 +105,7 @@ unsigned long long notrace sched_clock(void)
 void __init plat_time_init(void)
 {
 	clocksource_mips.rating = 300;
-	clocksource_set_clock(&clocksource_mips, octeon_get_clock_rate());
-	clocksource_register(&clocksource_mips);
+	clocksource_register_hz(&clocksource_mips, octeon_get_clock_rate());
 }
 
 static u64 octeon_udelay_factor;
diff --git a/arch/mips/include/asm/i8253.h b/arch/mips/include/asm/i8253.h
index 48bb823..9ad0113 100644
--- a/arch/mips/include/asm/i8253.h
+++ b/arch/mips/include/asm/i8253.h
@@ -12,8 +12,13 @@
 #define PIT_CH0			0x40
 #define PIT_CH2			0x42
 
+#define PIT_LATCH		LATCH
+
 extern raw_spinlock_t i8253_lock;
 
 extern void setup_pit_timer(void);
 
+#define inb_pit inb_p
+#define outb_pit outb_p
+
 #endif /* __ASM_I8253_H */
diff --git a/arch/mips/include/asm/time.h b/arch/mips/include/asm/time.h
index c7f1bfe..bc14447 100644
--- a/arch/mips/include/asm/time.h
+++ b/arch/mips/include/asm/time.h
@@ -84,12 +84,6 @@ static inline int init_mips_clocksource(void)
 #endif
 }
 
-static inline void clocksource_set_clock(struct clocksource *cs,
-					 unsigned int clock)
-{
-	clocksource_calc_mult_shift(cs, clock, 4);
-}
-
 static inline void clockevent_set_clock(struct clock_event_device *cd,
 					unsigned int clock)
 {
diff --git a/arch/mips/jz4740/time.c b/arch/mips/jz4740/time.c
index fe01678..03dfd4e 100644
--- a/arch/mips/jz4740/time.c
+++ b/arch/mips/jz4740/time.c
@@ -121,8 +121,7 @@ void __init plat_time_init(void)
 
 	clockevents_register_device(&jz4740_clockevent);
 
-	clocksource_set_clock(&jz4740_clocksource, clk_rate);
-	ret = clocksource_register(&jz4740_clocksource);
+	ret = clocksource_register_hz(&jz4740_clocksource, clk_rate);
 
 	if (ret)
 		printk(KERN_ERR "Failed to register clocksource: %d\n", ret);
diff --git a/arch/mips/kernel/cevt-txx9.c b/arch/mips/kernel/cevt-txx9.c
index 0b73773..f0ab92a 100644
--- a/arch/mips/kernel/cevt-txx9.c
+++ b/arch/mips/kernel/cevt-txx9.c
@@ -51,8 +51,7 @@ void __init txx9_clocksource_init(unsigned long baseaddr,
 {
 	struct txx9_tmr_reg __iomem *tmrptr;
 
-	clocksource_set_clock(&txx9_clocksource.cs, TIMER_CLK(imbusclk));
-	clocksource_register(&txx9_clocksource.cs);
+	clocksource_register_hz(&txx9_clocksource.cs, TIMER_CLK(imbusclk));
 
 	tmrptr = ioremap(baseaddr, sizeof(struct txx9_tmr_reg));
 	__raw_writel(TCR_BASE, &tmrptr->tcr);
diff --git a/arch/mips/kernel/csrc-bcm1480.c b/arch/mips/kernel/csrc-bcm1480.c
index 51489f8..f96f99c 100644
--- a/arch/mips/kernel/csrc-bcm1480.c
+++ b/arch/mips/kernel/csrc-bcm1480.c
@@ -49,6 +49,5 @@ void __init sb1480_clocksource_init(void)
 
 	plldiv = G_BCM1480_SYS_PLL_DIV(__raw_readq(IOADDR(A_SCD_SYSTEM_CFG)));
 	zbbus = ((plldiv >> 1) * 50000000) + ((plldiv & 1) * 25000000);
-	clocksource_set_clock(cs, zbbus);
-	clocksource_register(cs);
+	clocksource_register_hz(cs, zbbus);
 }
diff --git a/arch/mips/kernel/csrc-ioasic.c b/arch/mips/kernel/csrc-ioasic.c
index 23da108..46bd7fa 100644
--- a/arch/mips/kernel/csrc-ioasic.c
+++ b/arch/mips/kernel/csrc-ioasic.c
@@ -59,7 +59,5 @@ void __init dec_ioasic_clocksource_init(void)
 	printk(KERN_INFO "I/O ASIC clock frequency %dHz\n", freq);
 
 	clocksource_dec.rating = 200 + freq / 10000000;
-	clocksource_set_clock(&clocksource_dec, freq);
-
-	clocksource_register(&clocksource_dec);
+	clocksource_register_hz(&clocksource_dec, freq);
 }
diff --git a/arch/mips/kernel/csrc-powertv.c b/arch/mips/kernel/csrc-powertv.c
index a27c16c..2e7c523 100644
--- a/arch/mips/kernel/csrc-powertv.c
+++ b/arch/mips/kernel/csrc-powertv.c
@@ -78,9 +78,7 @@ static void __init powertv_c0_hpt_clocksource_init(void)
 
 	clocksource_mips.rating = 200 + mips_hpt_frequency / 10000000;
 
-	clocksource_set_clock(&clocksource_mips, mips_hpt_frequency);
-
-	clocksource_register(&clocksource_mips);
+	clocksource_register_hz(&clocksource_mips, mips_hpt_frequency);
 }
 
 /**
@@ -130,43 +128,16 @@ static struct clocksource clocksource_tim_c = {
 /**
  * powertv_tim_c_clocksource_init - set up a clock source for the TIM_C clock
  *
- * The hard part here is coming up with a constant k and shift s such that
- * the 48-bit TIM_C value multiplied by k doesn't overflow and that value,
- * when shifted right by s, yields the corresponding number of nanoseconds.
  * We know that TIM_C counts at 27 MHz/8, so each cycle corresponds to
- * 1 / (27,000,000/8) seconds. Multiply that by a billion and you get the
- * number of nanoseconds. Since the TIM_C value has 48 bits and the math is
- * done in 64 bits, avoiding an overflow means that k must be less than
- * 64 - 48 = 16 bits.
+ * 1 / (27,000,000/8) seconds.
  */
 static void __init powertv_tim_c_clocksource_init(void)
 {
-	int			prescale;
-	unsigned long		dividend;
-	unsigned long		k;
-	int			s;
-	const int		max_k_bits = (64 - 48) - 1;
-	const unsigned long	billion = 1000000000;
 	const unsigned long	counts_per_second = 27000000 / 8;
 
-	prescale = BITS_PER_LONG - ilog2(billion) - 1;
-	dividend = billion << prescale;
-	k = dividend / counts_per_second;
-	s = ilog2(k) - max_k_bits;
-
-	if (s < 0)
-		s = prescale;
-
-	else {
-		k >>= s;
-		s += prescale;
-	}
-
-	clocksource_tim_c.mult = k;
-	clocksource_tim_c.shift = s;
 	clocksource_tim_c.rating = 200;
 
-	clocksource_register(&clocksource_tim_c);
+	clocksource_register_hz(&clocksource_tim_c, counts_per_second);
 	tim_c = (struct tim_c *) asic_reg_addr(tim_ch);
 }
 
diff --git a/arch/mips/kernel/csrc-r4k.c b/arch/mips/kernel/csrc-r4k.c
index e95a3cd..decd1fa 100644
--- a/arch/mips/kernel/csrc-r4k.c
+++ b/arch/mips/kernel/csrc-r4k.c
@@ -30,9 +30,7 @@ int __init init_r4k_clocksource(void)
 	/* Calculate a somewhat reasonable rating value */
 	clocksource_mips.rating = 200 + mips_hpt_frequency / 10000000;
 
-	clocksource_set_clock(&clocksource_mips, mips_hpt_frequency);
-
-	clocksource_register(&clocksource_mips);
+	clocksource_register_hz(&clocksource_mips, mips_hpt_frequency);
 
 	return 0;
 }
diff --git a/arch/mips/kernel/csrc-sb1250.c b/arch/mips/kernel/csrc-sb1250.c
index d14d3d1..e9606d9 100644
--- a/arch/mips/kernel/csrc-sb1250.c
+++ b/arch/mips/kernel/csrc-sb1250.c
@@ -65,6 +65,5 @@ void __init sb1250_clocksource_init(void)
 		     IOADDR(A_SCD_TIMER_REGISTER(SB1250_HPT_NUM,
 						 R_SCD_TIMER_CFG)));
 
-	clocksource_set_clock(cs, V_SCD_TIMER_FREQ);
-	clocksource_register(cs);
+	clocksource_register_hz(cs, V_SCD_TIMER_FREQ);
 }
diff --git a/arch/mips/kernel/i8253.c b/arch/mips/kernel/i8253.c
index 2392a7a2..391221b 100644
--- a/arch/mips/kernel/i8253.c
+++ b/arch/mips/kernel/i8253.c
@@ -125,87 +125,11 @@ void __init setup_pit_timer(void)
 	setup_irq(0, &irq0);
 }
 
-/*
- * Since the PIT overflows every tick, its not very useful
- * to just read by itself. So use jiffies to emulate a free
- * running counter:
- */
-static cycle_t pit_read(struct clocksource *cs)
-{
-	unsigned long flags;
-	int count;
-	u32 jifs;
-	static int old_count;
-	static u32 old_jifs;
-
-	raw_spin_lock_irqsave(&i8253_lock, flags);
-	/*
-	 * Although our caller may have the read side of xtime_lock,
-	 * this is now a seqlock, and we are cheating in this routine
-	 * by having side effects on state that we cannot undo if
-	 * there is a collision on the seqlock and our caller has to
-	 * retry.  (Namely, old_jifs and old_count.)  So we must treat
-	 * jiffies as volatile despite the lock.  We read jiffies
-	 * before latching the timer count to guarantee that although
-	 * the jiffies value might be older than the count (that is,
-	 * the counter may underflow between the last point where
-	 * jiffies was incremented and the point where we latch the
-	 * count), it cannot be newer.
-	 */
-	jifs = jiffies;
-	outb_p(0x00, PIT_MODE);	/* latch the count ASAP */
-	count = inb_p(PIT_CH0);	/* read the latched count */
-	count |= inb_p(PIT_CH0) << 8;
-
-	/* VIA686a test code... reset the latch if count > max + 1 */
-	if (count > LATCH) {
-		outb_p(0x34, PIT_MODE);
-		outb_p(LATCH & 0xff, PIT_CH0);
-		outb(LATCH >> 8, PIT_CH0);
-		count = LATCH - 1;
-	}
-
-	/*
-	 * It's possible for count to appear to go the wrong way for a
-	 * couple of reasons:
-	 *
-	 *  1. The timer counter underflows, but we haven't handled the
-	 *     resulting interrupt and incremented jiffies yet.
-	 *  2. Hardware problem with the timer, not giving us continuous time,
-	 *     the counter does small "jumps" upwards on some Pentium systems,
-	 *     (see c't 95/10 page 335 for Neptun bug.)
-	 *
-	 * Previous attempts to handle these cases intelligently were
-	 * buggy, so we just do the simple thing now.
-	 */
-	if (count > old_count && jifs == old_jifs) {
-		count = old_count;
-	}
-	old_count = count;
-	old_jifs = jifs;
-
-	raw_spin_unlock_irqrestore(&i8253_lock, flags);
-
-	count = (LATCH - 1) - count;
-
-	return (cycle_t)(jifs * LATCH) + count;
-}
-
-static struct clocksource clocksource_pit = {
-	.name	= "pit",
-	.rating = 110,
-	.read	= pit_read,
-	.mask	= CLOCKSOURCE_MASK(32),
-	.mult	= 0,
-	.shift	= 20,
-};
-
 static int __init init_pit_clocksource(void)
 {
 	if (num_possible_cpus() > 1) /* PIT does not scale! */
 		return 0;
 
-	clocksource_pit.mult = clocksource_hz2mult(CLOCK_TICK_RATE, 20);
-	return clocksource_register(&clocksource_pit);
+	return clocksource_i8253_init();
 }
 arch_initcall(init_pit_clocksource);
diff --git a/arch/mips/loongson/common/cs5536/cs5536_mfgpt.c b/arch/mips/loongson/common/cs5536/cs5536_mfgpt.c
index 8c807c9..0cb1b97 100644
--- a/arch/mips/loongson/common/cs5536/cs5536_mfgpt.c
+++ b/arch/mips/loongson/common/cs5536/cs5536_mfgpt.c
@@ -201,8 +201,6 @@ static struct clocksource clocksource_mfgpt = {
 	.rating = 120, /* Functional for real use, but not desired */
 	.read = mfgpt_read,
 	.mask = CLOCKSOURCE_MASK(32),
-	.mult = 0,
-	.shift = 22,
 };
 
 int __init init_mfgpt_clocksource(void)
@@ -210,8 +208,7 @@ int __init init_mfgpt_clocksource(void)
 	if (num_possible_cpus() > 1)	/* MFGPT does not scale! */
 		return 0;
 
-	clocksource_mfgpt.mult = clocksource_hz2mult(MFGPT_TICK_RATE, 22);
-	return clocksource_register(&clocksource_mfgpt);
+	return clocksource_register_hz(&clocksource_mfgpt, MFGPT_TICK_RATE);
 }
 
 arch_initcall(init_mfgpt_clocksource);
diff --git a/arch/mips/sgi-ip27/ip27-timer.c b/arch/mips/sgi-ip27/ip27-timer.c
index a152538..8d0d269 100644
--- a/arch/mips/sgi-ip27/ip27-timer.c
+++ b/arch/mips/sgi-ip27/ip27-timer.c
@@ -174,8 +174,7 @@ static void __init hub_rt_clocksource_init(void)
 {
 	struct clocksource *cs = &hub_rt_clocksource;
 
-	clocksource_set_clock(cs, CYCLES_PER_SEC);
-	clocksource_register(cs);
+	clocksource_register_hz(cs, CYCLES_PER_SEC);
 }
 
 void __init plat_time_init(void)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc6c53a..01115d5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -8,6 +8,7 @@ config 64BIT
 
 config X86_32
 	def_bool !64BIT
+	select CLKSRC_I8253
 
 config X86_64
 	def_bool 64BIT
diff --git a/arch/x86/include/asm/i8253.h b/arch/x86/include/asm/i8253.h
index fc1f579..65aaa91 100644
--- a/arch/x86/include/asm/i8253.h
+++ b/arch/x86/include/asm/i8253.h
@@ -6,6 +6,8 @@
 #define PIT_CH0			0x40
 #define PIT_CH2			0x42
 
+#define PIT_LATCH	LATCH
+
 extern raw_spinlock_t i8253_lock;
 
 extern struct clock_event_device *global_clock_event;
diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index cd1ffed..289e928 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -177,7 +177,6 @@ static struct clocksource clocksource_apbt = {
 	.rating		= APBT_CLOCKSOURCE_RATING,
 	.read		= apbt_read_clocksource,
 	.mask		= APBT_MASK,
-	.shift		= APBT_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= apbt_restart_clocksource,
 };
@@ -543,14 +542,7 @@ static int apbt_clocksource_register(void)
 	if (t1 == apbt_read_clocksource(&clocksource_apbt))
 		panic("APBT counter not counting. APBT disabled\n");
 
-	/*
-	 * initialize and register APBT clocksource
-	 * convert that to ns/clock cycle
-	 * mult = (ns/c) * 2^APBT_SHIFT
-	 */
-	clocksource_apbt.mult = div_sc(MSEC_PER_SEC,
-				       (unsigned long) apbt_freq, APBT_SHIFT);
-	clocksource_register(&clocksource_apbt);
+	clocksource_register_khz(&clocksource_apbt, (u32)apbt_freq*1000);
 
 	return 0;
 }
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index 2dfd315..577e90c 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -117,81 +117,6 @@ void __init setup_pit_timer(void)
 }
 
 #ifndef CONFIG_X86_64
-/*
- * Since the PIT overflows every tick, its not very useful
- * to just read by itself. So use jiffies to emulate a free
- * running counter:
- */
-static cycle_t pit_read(struct clocksource *cs)
-{
-	static int old_count;
-	static u32 old_jifs;
-	unsigned long flags;
-	int count;
-	u32 jifs;
-
-	raw_spin_lock_irqsave(&i8253_lock, flags);
-	/*
-	 * Although our caller may have the read side of xtime_lock,
-	 * this is now a seqlock, and we are cheating in this routine
-	 * by having side effects on state that we cannot undo if
-	 * there is a collision on the seqlock and our caller has to
-	 * retry.  (Namely, old_jifs and old_count.)  So we must treat
-	 * jiffies as volatile despite the lock.  We read jiffies
-	 * before latching the timer count to guarantee that although
-	 * the jiffies value might be older than the count (that is,
-	 * the counter may underflow between the last point where
-	 * jiffies was incremented and the point where we latch the
-	 * count), it cannot be newer.
-	 */
-	jifs = jiffies;
-	outb_pit(0x00, PIT_MODE);	/* latch the count ASAP */
-	count = inb_pit(PIT_CH0);	/* read the latched count */
-	count |= inb_pit(PIT_CH0) << 8;
-
-	/* VIA686a test code... reset the latch if count > max + 1 */
-	if (count > LATCH) {
-		outb_pit(0x34, PIT_MODE);
-		outb_pit(LATCH & 0xff, PIT_CH0);
-		outb_pit(LATCH >> 8, PIT_CH0);
-		count = LATCH - 1;
-	}
-
-	/*
-	 * It's possible for count to appear to go the wrong way for a
-	 * couple of reasons:
-	 *
-	 *  1. The timer counter underflows, but we haven't handled the
-	 *     resulting interrupt and incremented jiffies yet.
-	 *  2. Hardware problem with the timer, not giving us continuous time,
-	 *     the counter does small "jumps" upwards on some Pentium systems,
-	 *     (see c't 95/10 page 335 for Neptun bug.)
-	 *
-	 * Previous attempts to handle these cases intelligently were
-	 * buggy, so we just do the simple thing now.
-	 */
-	if (count > old_count && jifs == old_jifs)
-		count = old_count;
-
-	old_count = count;
-	old_jifs = jifs;
-
-	raw_spin_unlock_irqrestore(&i8253_lock, flags);
-
-	count = (LATCH - 1) - count;
-
-	return (cycle_t)(jifs * LATCH) + count;
-}
-
-static struct clocksource pit_cs = {
-	.name		= "pit",
-	.rating		= 110,
-	.read		= pit_read,
-	.mask		= CLOCKSOURCE_MASK(32),
-	.mult		= 0,
-	.shift		= 20,
-};
-
 static int __init init_pit_clocksource(void)
 {
 	 /*
@@ -205,10 +130,7 @@ static int __init init_pit_clocksource(void)
 	    pit_ce.mode != CLOCK_EVT_MODE_PERIODIC)
 		return 0;
 
-	pit_cs.mult = clocksource_hz2mult(CLOCK_TICK_RATE, pit_cs.shift);
-
-	return clocksource_register(&pit_cs);
+	return clocksource_i8253_init();
 }
 arch_initcall(init_pit_clocksource);
-
 #endif /* !CONFIG_X86_64 */
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index f98d3ea..6389a6b 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -26,8 +26,6 @@
 #include <asm/x86_init.h>
 #include <asm/reboot.h>
 
-#define KVM_SCALE 22
-
 static int kvmclock = 1;
 static int msr_kvm_system_time = MSR_KVM_SYSTEM_TIME;
 static int msr_kvm_wall_clock = MSR_KVM_WALL_CLOCK;
@@ -120,8 +118,6 @@ static struct clocksource kvm_clock = {
 	.read = kvm_clock_get_cycles,
 	.rating = 400,
 	.mask = CLOCKSOURCE_MASK(64),
-	.mult = 1 << KVM_SCALE,
-	.shift = KVM_SCALE,
 	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -203,7 +199,7 @@ void __init kvmclock_init(void)
 	machine_ops.crash_shutdown  = kvm_crash_shutdown;
 #endif
 	kvm_get_preset_lpj();
-	clocksource_register(&kvm_clock);
+	clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);
 	pv_info.paravirt_enabled = 1;
 	pv_info.name = "KVM";
 
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 1cd6089..4e0068e 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -913,8 +913,6 @@ static struct clocksource lguest_clock = {
 	.rating		= 200,
 	.read		= lguest_clock_read,
 	.mask		= CLOCKSOURCE_MASK(64),
-	.mult		= 1 << 22,
-	.shift		= 22,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -997,7 +995,7 @@ static void lguest_time_init(void)
 	/* Set up the timer interrupt (0) to go to our simple timer routine */
 	irq_set_handler(0, lguest_time_irq);
 
-	clocksource_register(&lguest_clock);
+	clocksource_register_hz(&lguest_clock, NSEC_PER_SEC);
 
 	/* We can't set cpumask in the initializer: damn C limitations!  Set it
 	 * here and register our timer device. */
diff --git a/arch/x86/platform/uv/uv_time.c b/arch/x86/platform/uv/uv_time.c
index 9daf5d1..0eb9018 100644
--- a/arch/x86/platform/uv/uv_time.c
+++ b/arch/x86/platform/uv/uv_time.c
@@ -40,7 +40,6 @@ static struct clocksource clocksource_uv = {
 	.rating		= 400,
 	.read		= uv_read_rtc,
 	.mask		= (cycle_t)UVH_RTC_REAL_TIME_CLOCK_MASK,
-	.shift		= 10,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -372,14 +371,11 @@ static __init int uv_rtc_setup_clock(void)
 	if (!is_uv_system())
 		return -ENODEV;
 
-	clocksource_uv.mult = clocksource_hz2mult(sn_rtc_cycles_per_second,
-				clocksource_uv.shift);
-
 	/* If single blade, prefer tsc */
 	if (uv_num_possible_blades() == 1)
 		clocksource_uv.rating = 250;
 
-	rc = clocksource_register(&clocksource_uv);
+	rc = clocksource_register_hz(&clocksource_uv, sn_rtc_cycles_per_second);
 	if (rc)
 		printk(KERN_INFO "UV RTC clocksource failed rc %d\n", rc);
 	else
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 2e2d370..c532d28 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -26,8 +26,6 @@
 
 #include "xen-ops.h"
 
-#define XEN_SHIFT 22
-
 /* Xen may fire a timer up to this many ns early */
 #define TIMER_SLOP	100000
 #define NS_PER_TICK	(1000000000LL / HZ)
@@ -211,8 +209,6 @@ static struct clocksource xen_clocksource __read_mostly = {
 	.rating = 400,
 	.read = xen_clocksource_get_cycles,
 	.mask = ~0,
-	.mult = 1<<XEN_SHIFT,		/* time directly in nanoseconds */
-	.shift = XEN_SHIFT,
 	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -448,7 +444,7 @@ static __init void xen_time_init(void)
 	int cpu = smp_processor_id();
 	struct timespec tp;
 
-	clocksource_register(&xen_clocksource);
+	clocksource_register_hz(&xen_clocksource, NSEC_PER_SEC);
 
 	if (HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL) == 0) {
 		/* Successfully turned off 100Hz tick, so we have the
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 177c7d1..557a469 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -119,4 +119,7 @@ source "drivers/platform/Kconfig"
 source "drivers/clk/Kconfig"
 
 source "drivers/hwspinlock/Kconfig"
+
+source "drivers/clocksource/Kconfig"
+
 endmenu
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
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
new file mode 100644
index 0000000..110aeeb
--- /dev/null
+++ b/drivers/clocksource/Kconfig
@@ -0,0 +1,2 @@
+config CLKSRC_I8253
+	bool
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index be61ece..cfb6383 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_CS5535_CLOCK_EVENT_SRC)	+= cs5535-clockevt.o
 obj-$(CONFIG_SH_TIMER_CMT)	+= sh_cmt.o
 obj-$(CONFIG_SH_TIMER_MTU2)	+= sh_mtu2.o
 obj-$(CONFIG_SH_TIMER_TMU)	+= sh_tmu.o
+obj-$(CONFIG_CLKSRC_I8253)	+= i8253.o
diff --git a/drivers/clocksource/cyclone.c b/drivers/clocksource/cyclone.c
index 64e528e..72f811f 100644
--- a/drivers/clocksource/cyclone.c
+++ b/drivers/clocksource/cyclone.c
@@ -29,8 +29,6 @@ static struct clocksource clocksource_cyclone = {
 	.rating		= 250,
 	.read		= read_cyclone,
 	.mask		= CYCLONE_TIMER_MASK,
-	.mult		= 10,
-	.shift		= 0,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -108,12 +106,8 @@ static int __init init_cyclone_clocksource(void)
 	}
 	cyclone_ptr = cyclone_timer;
 
-	/* sort out mult/shift values: */
-	clocksource_cyclone.shift = 22;
-	clocksource_cyclone.mult = clocksource_hz2mult(CYCLONE_TIMER_FREQ,
-						clocksource_cyclone.shift);
-
-	return clocksource_register(&clocksource_cyclone);
+	return clocksource_register_hz(&clocksource_cyclone,
+					CYCLONE_TIMER_FREQ);
 }
 
 arch_initcall(init_cyclone_clocksource);
diff --git a/drivers/clocksource/i8253.c b/drivers/clocksource/i8253.c
new file mode 100644
index 0000000..225c176
--- /dev/null
+++ b/drivers/clocksource/i8253.c
@@ -0,0 +1,88 @@
+/*
+ * i8253 PIT clocksource
+ */
+#include <linux/clocksource.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/spinlock.h>
+#include <linux/timex.h>
+
+#include <asm/i8253.h>
+
+/*
+ * Since the PIT overflows every tick, its not very useful
+ * to just read by itself. So use jiffies to emulate a free
+ * running counter:
+ */
+static cycle_t i8253_read(struct clocksource *cs)
+{
+	static int old_count;
+	static u32 old_jifs;
+	unsigned long flags;
+	int count;
+	u32 jifs;
+
+	raw_spin_lock_irqsave(&i8253_lock, flags);
+	/*
+	 * Although our caller may have the read side of xtime_lock,
+	 * this is now a seqlock, and we are cheating in this routine
+	 * by having side effects on state that we cannot undo if
+	 * there is a collision on the seqlock and our caller has to
+	 * retry.  (Namely, old_jifs and old_count.)  So we must treat
+	 * jiffies as volatile despite the lock.  We read jiffies
+	 * before latching the timer count to guarantee that although
+	 * the jiffies value might be older than the count (that is,
+	 * the counter may underflow between the last point where
+	 * jiffies was incremented and the point where we latch the
+	 * count), it cannot be newer.
+	 */
+	jifs = jiffies;
+	outb_pit(0x00, PIT_MODE);	/* latch the count ASAP */
+	count = inb_pit(PIT_CH0);	/* read the latched count */
+	count |= inb_pit(PIT_CH0) << 8;
+
+	/* VIA686a test code... reset the latch if count > max + 1 */
+	if (count > LATCH) {
+		outb_pit(0x34, PIT_MODE);
+		outb_pit(PIT_LATCH & 0xff, PIT_CH0);
+		outb_pit(PIT_LATCH >> 8, PIT_CH0);
+		count = PIT_LATCH - 1;
+	}
+
+	/*
+	 * It's possible for count to appear to go the wrong way for a
+	 * couple of reasons:
+	 *
+	 *  1. The timer counter underflows, but we haven't handled the
+	 *     resulting interrupt and incremented jiffies yet.
+	 *  2. Hardware problem with the timer, not giving us continuous time,
+	 *     the counter does small "jumps" upwards on some Pentium systems,
+	 *     (see c't 95/10 page 335 for Neptun bug.)
+	 *
+	 * Previous attempts to handle these cases intelligently were
+	 * buggy, so we just do the simple thing now.
+	 */
+	if (count > old_count && jifs == old_jifs)
+		count = old_count;
+
+	old_count = count;
+	old_jifs = jifs;
+
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
+
+	count = (PIT_LATCH - 1) - count;
+
+	return (cycle_t)(jifs * PIT_LATCH) + count;
+}
+
+static struct clocksource i8253_cs = {
+	.name		= "pit",
+	.rating		= 110,
+	.read		= i8253_read,
+	.mask		= CLOCKSOURCE_MASK(32),
+};
+
+int __init clocksource_i8253_init(void)
+{
+	return clocksource_register_hz(&i8253_cs, PIT_TICK_RATE);
+}
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index c37b21a..0fb0b7e 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -161,7 +161,7 @@ struct clocksource {
 	/*
 	 * First part of structure is read mostly
 	 */
-	char *name;
+	const char *name;
 	struct list_head list;
 	int rating;
 	cycle_t (*read)(struct clocksource *cs);
@@ -341,4 +341,6 @@ static inline void update_vsyscall_tz(void)
 
 extern void timekeeping_notify(struct clocksource *clock);
 
+extern int clocksource_i8253_init(void);
+
 #endif /* _LINUX_CLOCKSOURCE_H */
