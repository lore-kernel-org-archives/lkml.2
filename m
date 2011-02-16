Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab1BPGfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 01:35:05 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38178 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab1BPGe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 01:34:59 -0500
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Ralf Baechle <ralf@linux-mips.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/6] mips: convert to clocksource_register_hz/khz
Date: Tue, 15 Feb 2011 22:34:51 -0800
Message-Id: <1297838092-22989-6-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1297838092-22989-1-git-send-email-johnstul@us.ibm.com>
References: <1297838092-22989-1-git-send-email-johnstul@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the mips clocksources to use clocksource_register_hz/khz

This is untested, so any assistance in testing would be appreciated!

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mips/alchemy/common/time.c                 |    3 +-
 arch/mips/cavium-octeon/csrc-octeon.c           |    3 +-
 arch/mips/include/asm/time.h                    |    6 ----
 arch/mips/jz4740/time.c                         |    3 +-
 arch/mips/kernel/cevt-txx9.c                    |    3 +-
 arch/mips/kernel/csrc-bcm1480.c                 |    3 +-
 arch/mips/kernel/csrc-ioasic.c                  |    4 +--
 arch/mips/kernel/csrc-powertv.c                 |   35 ++---------------------
 arch/mips/kernel/csrc-r4k.c                     |    4 +--
 arch/mips/kernel/csrc-sb1250.c                  |    3 +-
 arch/mips/kernel/i8253.c                        |    5 +--
 arch/mips/loongson/common/cs5536/cs5536_mfgpt.c |    5 +--
 arch/mips/sgi-ip27/ip27-timer.c                 |    3 +-
 13 files changed, 14 insertions(+), 66 deletions(-)

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
index 2392a7a2..9fadd17 100644
--- a/arch/mips/kernel/i8253.c
+++ b/arch/mips/kernel/i8253.c
@@ -196,8 +196,6 @@ static struct clocksource clocksource_pit = {
 	.rating = 110,
 	.read	= pit_read,
 	.mask	= CLOCKSOURCE_MASK(32),
-	.mult	= 0,
-	.shift	= 20,
 };
 
 static int __init init_pit_clocksource(void)
@@ -205,7 +203,6 @@ static int __init init_pit_clocksource(void)
 	if (num_possible_cpus() > 1) /* PIT does not scale! */
 		return 0;
 
-	clocksource_pit.mult = clocksource_hz2mult(CLOCK_TICK_RATE, 20);
-	return clocksource_register(&clocksource_pit);
+	return clocksource_register_hz(&clocksource_pit, CLOCK_TICK_RATE);
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
index d6802d6..3cac883 100644
--- a/arch/mips/sgi-ip27/ip27-timer.c
+++ b/arch/mips/sgi-ip27/ip27-timer.c
@@ -177,8 +177,7 @@ static void __init hub_rt_clocksource_init(void)
 {
 	struct clocksource *cs = &hub_rt_clocksource;
 
-	clocksource_set_clock(cs, CYCLES_PER_SEC);
-	clocksource_register(cs);
+	clocksource_register_hz(cs, CYCLES_PER_SEC);
 }
 
 void __init plat_time_init(void)
-- 
1.7.3.2.146.gca209

