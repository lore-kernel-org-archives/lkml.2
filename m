Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab0EABgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 21:36:51 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37381 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758960Ab0EABga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 21:36:30 -0400
From: John Stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Ralf Baechle <ralf@linux-mips.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>, Jim Cromie <jim.cromie@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC][PATCH 3/3] Try to convert non-trivial clocksources to clocksource_register_hz
Date: Fri, 30 Apr 2010 18:36:25 -0700
Message-Id: <1272677785-23881-3-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1272677785-23881-2-git-send-email-johnstul@us.ibm.com>
References: <1272677785-23881-1-git-send-email-johnstul@us.ibm.com>
 <1272677785-23881-2-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOT FOR INCLUSION!
NOT FOR INCLUSION!

I've already gone through and converted the rest of the clocksources 
to use clocksource_register_hz, and I'll be hopefully pushing those 
to arch maintainers for 2.6.36-2.6.37.

However, in going through all the clocksources, I hit a few
non-trivial conversions and wanted to bring them up on the list
early so they can be handled soon.

The following patch tries to convert the non-trival clocksources
to use clocksource_register_hz/khz. It is likely broken. I will
need arch maintainer help to figure out the best way to resovle 
these clocksources.

This patch requires the previous "Add clocksource_register_hz/khz 
interface" patch to build. 

So any help maintainers can provide in finding solutions to
break the mult/shift assumptions in the arch code would be
greatly appreciated!

thanks
-john

NOT FOR INCLUSION!
NOT FOR INCLUSION!

CC: Ralf Baechle <ralf@linux-mips.org>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mundt <lethal@linux-sh.org>
CC: Jim Cromie <jim.cromie@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/mips/nxp/pnx8550/common/time.c |    7 ++++++-
 arch/powerpc/kernel/time.c          |   14 +++++++-------
 arch/s390/kernel/time.c             |   13 ++++++++++---
 drivers/clocksource/scx200_hrt.c    |   19 ++++++-------------
 drivers/clocksource/sh_cmt.c        |    4 ++--
 drivers/clocksource/sh_tmu.c        |    4 ++--
 kernel/time/jiffies.c               |    3 ++-
 7 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/arch/mips/nxp/pnx8550/common/time.c b/arch/mips/nxp/pnx8550/common/time.c
index 8836c62..a4420f0 100644
--- a/arch/mips/nxp/pnx8550/common/time.c
+++ b/arch/mips/nxp/pnx8550/common/time.c
@@ -104,7 +104,12 @@ __init void plat_time_init(void)
 
 	pnx8xxx_clockevent.cpumask = cpu_none_mask;
 	clockevents_register_device(&pnx8xxx_clockevent);
-	clocksource_register(&pnx_clocksource);
+	
+	/*
+	 * XXX - Nothing seems to set pnx_clocksource mult/shift! 
+	 * So I don't know what freq to use here. Help! -johnstul
+	 */
+	clocksource_register_hz(&pnx_clocksource, 0);
 
 	/* Timer 1 start */
 	configPR = read_c0_config7();
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 1b16b9a..827abe6 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -86,8 +86,6 @@ static struct clocksource clocksource_rtc = {
 	.rating       = 400,
 	.flags        = CLOCK_SOURCE_IS_CONTINUOUS,
 	.mask         = CLOCKSOURCE_MASK(64),
-	.shift        = 22,
-	.mult         = 0,	/* To be filled in */
 	.read         = rtc_read,
 };
 
@@ -97,8 +95,6 @@ static struct clocksource clocksource_timebase = {
 	.rating       = 400,
 	.flags        = CLOCK_SOURCE_IS_CONTINUOUS,
 	.mask         = CLOCKSOURCE_MASK(64),
-	.shift        = 22,
-	.mult         = 0,	/* To be filled in */
 	.read         = timebase_read,
 };
 
@@ -848,6 +844,12 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
 	/* Make userspace gettimeofday spin until we're done. */
 	++vdso_data->tb_update_count;
 	smp_mb();
+	
+	/*
+	 * XXX UGH! the below assumes  clock->shift == 22. 
+	 * This will no longer be the case with clocksource_register_hz
+	 * HELP! -johnstul
+	 */
 
 	/* XXX this assumes clock->shift == 22 */
 	/* 4611686018 ~= 2^(20+64-22) / 1e9 */
@@ -878,9 +880,7 @@ static void __init clocksource_init(void)
 	else
 		clock = &clocksource_timebase;
 
-	clock->mult = clocksource_hz2mult(tb_ticks_per_sec, clock->shift);
-
-	if (clocksource_register(clock)) {
+	if (clocksource_register_hz(clock, tb_ticks_per_sec)) {
 		printk(KERN_ERR "clocksource: %s is already registered\n",
 		       clock->name);
 		return;
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index d906bf1..6412752 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -197,8 +197,6 @@ static struct clocksource clocksource_tod = {
 	.rating		= 400,
 	.read		= read_tod_clock,
 	.mask		= -1ULL,
-	.mult		= 1000,
-	.shift		= 12,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -257,7 +255,16 @@ void __init time_init(void)
 	if (register_external_interrupt(0x1406, timing_alert_interrupt))
 		panic("Couldn't request external interrupt 0x1406");
 
-	if (clocksource_register(&clocksource_tod) != 0)
+	/* 
+	 * XXX - Brute forced tod freq from:
+	 *    2^shift/mult * NSEC_PER_SEC	= cyc/sec
+	 *    2^12 / 1000  * 1000000000		= cyc/sec
+	 *    2^12 * 1000000			= cyc/sec
+	 *    2^12 * 1000			= kcyc/sec
+	 *    1000<<12				= kcyc/sec
+	 * Could be totally wrong. -johnstul
+	 */
+	if (clocksource_register_khz(&clocksource_tod, (1000<<12) ) != 0)
 		panic("Could not register TOD clock source");
 
 	/* Enable TOD clock interrupts on the boot cpu. */
diff --git a/drivers/clocksource/scx200_hrt.c b/drivers/clocksource/scx200_hrt.c
index 27f4d96..24f884c 100644
--- a/drivers/clocksource/scx200_hrt.c
+++ b/drivers/clocksource/scx200_hrt.c
@@ -49,9 +49,6 @@ static cycle_t read_hrt(struct clocksource *cs)
 	return (cycle_t) inl(scx200_cb_base + SCx200_TIMER_OFFSET);
 }
 
-#define HRT_SHIFT_1	22
-#define HRT_SHIFT_27	26
-
 static struct clocksource cs_hrt = {
 	.name		= "scx200_hrt",
 	.rating		= 250,
@@ -63,6 +60,7 @@ static struct clocksource cs_hrt = {
 
 static int __init init_hrt_clocksource(void)
 {
+	u32 freq;
 	/* Make sure scx200 has initialized the configuration block */
 	if (!scx200_cb_present())
 		return -ENODEV;
@@ -79,19 +77,14 @@ static int __init init_hrt_clocksource(void)
 	outb(HR_TMEN | (mhz27 ? HR_TMCLKSEL : 0),
 	     scx200_cb_base + SCx200_TMCNFG_OFFSET);
 
-	if (mhz27) {
-		cs_hrt.shift = HRT_SHIFT_27;
-		cs_hrt.mult = clocksource_hz2mult((HRT_FREQ + ppm) * 27,
-						  cs_hrt.shift);
-	} else {
-		cs_hrt.shift = HRT_SHIFT_1;
-		cs_hrt.mult = clocksource_hz2mult(HRT_FREQ + ppm,
-						  cs_hrt.shift);
-	}
+	freq = (HRT_FREQ + ppm);
+	if (mhz27)
+		freq *= 27;
+
 	printk(KERN_INFO "enabling scx200 high-res timer (%s MHz +%d ppm)\n",
 		mhz27 ? "27":"1", ppm);
 
-	return clocksource_register(&cs_hrt);
+	return clocksource_register_hz(&cs_hrt, freq);
 }
 
 module_init(init_hrt_clocksource);
diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 744f748..23bb543 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -422,7 +422,6 @@ static int sh_cmt_clocksource_enable(struct clocksource *cs)
 		return ret;
 
 	/* TODO: calculate good shift from rate and counter bit width */
-	cs->shift = 0;
 	cs->mult = clocksource_hz2mult(p->rate, cs->shift);
 	return 0;
 }
@@ -452,7 +451,8 @@ static int sh_cmt_register_clocksource(struct sh_cmt_priv *p,
 	cs->mask = CLOCKSOURCE_MASK(sizeof(unsigned long) * 8);
 	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
 	pr_info("sh_cmt: %s used as clock source\n", cs->name);
-	clocksource_register(cs);
+	/* XXX - What do we do about rate changes? -johnstul */
+	clocksource_register_hz(cs, p->rate);
 	return 0;
 }
 
diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index fc9ff1e..5d7f947 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -207,7 +207,6 @@ static int sh_tmu_clocksource_enable(struct clocksource *cs)
 		return ret;
 
 	/* TODO: calculate good shift from rate and counter bit width */
-	cs->shift = 10;
 	cs->mult = clocksource_hz2mult(p->rate, cs->shift);
 	return 0;
 }
@@ -230,7 +229,8 @@ static int sh_tmu_register_clocksource(struct sh_tmu_priv *p,
 	cs->mask = CLOCKSOURCE_MASK(32);
 	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
 	pr_info("sh_tmu: %s used as clock source\n", cs->name);
-	clocksource_register(cs);
+	/* XXX - What do we do about the rate changes in enable/disable? */
+	clocksource_register_hz(cs, p->rate);
 	return 0;
 }
 
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 5404a84..73b0a86 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -66,7 +66,8 @@ struct clocksource clocksource_jiffies = {
 
 static int __init init_jiffies_clocksource(void)
 {
-	return clocksource_register(&clocksource_jiffies);
+	/* XXX - HRMMM.. we're losing some precision since ACTHZ>>8 != HZ */
+	return clocksource_register_hz(&clocksource_jiffies, HZ);
 }
 
 core_initcall(init_jiffies_clocksource);
-- 
1.6.0.4

