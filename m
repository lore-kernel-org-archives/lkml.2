Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964803Ab2KHVCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:02:17 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34323 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756994Ab2KHVCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:02:14 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 02/11] time: convert arch_gettimeoffset to a pointer
Date: Thu,  8 Nov 2012 14:01:47 -0700
Message-Id: <1352408516-21988-4-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
References: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Currently, whenever CONFIG_ARCH_USES_GETTIMEOFFSET is enabled, each
arch core provides a single implementation of arch_gettimeoffset(). In
many cases, different sub-architectures, different machines, or
different timer providers exist, and so the arch ends up implementing
arch_gettimeoffset() as a call-through-pointer anyway. Examples are
ARM, Cris, M68K, and it's arguable that the remaining architectures,
M32R and Blackfin, should be doing this anyway.

Modify arch_gettimeoffset so that it itself is a function pointer, which
the arch initializes. This will allow later changes to move the
initialization of this function into individual machine support or timer
drivers. This is particularly useful for code in drivers/clocksource
which should rely on an arch-independant mechanism to register their
implementation of arch_gettimeoffset().

This patch also converts the Cris architecture to set arch_gettimeoffset
directly to the final implementation in time_init(), because Cris already
had separate time_init() functions per sub-architecture. M68K and ARM
are converted to set arch_gettimeoffset the final implementation in later
patches, because they already have function pointers in place for this
purpose.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/kernel/time.c           |    6 +++++-
 arch/blackfin/kernel/time.c      |    6 +++++-
 arch/cris/arch-v10/kernel/time.c |    6 ++++--
 arch/cris/kernel/time.c          |   11 -----------
 arch/m32r/kernel/time.c          |    4 +++-
 arch/m68k/kernel/time.c          |   16 ++++++++++------
 include/linux/time.h             |    4 +---
 kernel/time/timekeeping.c        |   20 +++++++++++++++++---
 8 files changed, 45 insertions(+), 28 deletions(-)

diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index 09be0c3..b0190b4 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -70,7 +70,7 @@ EXPORT_SYMBOL(profile_pc);
 #endif
 
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
-u32 arch_gettimeoffset(void)
+static u32 arm_gettimeoffset(void)
 {
 	if (system_timer->offset != NULL)
 		return system_timer->offset() * 1000;
@@ -164,6 +164,10 @@ device_initcall(timer_init_syscore_ops);
 
 void __init time_init(void)
 {
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
+	arch_gettimeoffset = arm_gettimeoffset;
+#endif
+
 	system_timer = machine_desc->timer;
 	system_timer->init();
 	sched_clock_postinit();
diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index 2310b24..3126b92 100644
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -85,7 +85,7 @@ time_sched_init(irqreturn_t(*timer_routine) (int, void *))
 /*
  * Should return useconds since last timer tick
  */
-u32 arch_gettimeoffset(void)
+static u32 blackfin_gettimeoffset(void)
 {
 	unsigned long offset;
 	unsigned long clocks_per_jiffy;
@@ -141,6 +141,10 @@ void read_persistent_clock(struct timespec *ts)
 
 void __init time_init(void)
 {
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
+	arch_gettimeoffset = blackfin_gettimeoffset;
+#endif
+
 #ifdef CONFIG_RTC_DRV_BFIN
 	/* [#2663] hack to filter junk RTC values that would cause
 	 * userspace to have to deal with time values greater than
diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index 162892f..fce7c54 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -55,9 +55,9 @@ unsigned long get_ns_in_jiffie(void)
 	return ns;
 }
 
-unsigned long do_slow_gettimeoffset(void)
+static u32 cris_v10_gettimeoffset(void)
 {
-	unsigned long count;
+	u32 count;
 
 	/* The timer interrupt comes from Etrax timer 0. In order to get
 	 * better precision, we check the current value. It might have
@@ -191,6 +191,8 @@ static struct irqaction irq2  = {
 void __init
 time_init(void)
 {	
+	arch_gettimeoffset = cris_v10_gettimeoffset;
+
 	/* probe for the RTC and read it if it exists 
 	 * Before the RTC can be probed the loops_per_usec variable needs 
 	 * to be initialized to make usleep work. A better value for 
diff --git a/arch/cris/kernel/time.c b/arch/cris/kernel/time.c
index b063c92..fe6acda 100644
--- a/arch/cris/kernel/time.c
+++ b/arch/cris/kernel/time.c
@@ -39,17 +39,6 @@
 extern unsigned long loops_per_jiffy; /* init/main.c */
 unsigned long loops_per_usec;
 
-
-#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
-extern unsigned long do_slow_gettimeoffset(void);
-static unsigned long (*do_gettimeoffset)(void) = do_slow_gettimeoffset;
-
-u32 arch_gettimeoffset(void)
-{
-	return do_gettimeoffset();
-}
-#endif
-
 int set_rtc_mmss(unsigned long nowtime)
 {
 	D(printk(KERN_DEBUG "set_rtc_mmss(%lu)\n", nowtime));
diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index 84dd040..1a15f81 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -57,7 +57,7 @@ extern void smp_local_timer_interrupt(void);
 
 static unsigned long latch;
 
-u32 arch_gettimeoffset(void)
+static u32 m32r_gettimeoffset(void)
 {
 	unsigned long  elapsed_time = 0;  /* [us] */
 
@@ -165,6 +165,8 @@ void read_persistent_clock(struct timespec *ts)
 
 void __init time_init(void)
 {
+	arch_gettimeoffset = m32r_gettimeoffset;
+
 #if defined(CONFIG_CHIP_M32102) || defined(CONFIG_CHIP_XNUX2) \
 	|| defined(CONFIG_CHIP_VDEC2) || defined(CONFIG_CHIP_M32700) \
 	|| defined(CONFIG_CHIP_OPSP) || defined(CONFIG_CHIP_M32104)
diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
index 5d0bcaa..c2994c8 100644
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -80,14 +80,9 @@ void read_persistent_clock(struct timespec *ts)
 	}
 }
 
-void __init time_init(void)
-{
-	mach_sched_init(timer_interrupt);
-}
-
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 
-u32 arch_gettimeoffset(void)
+static u32 m68k_gettimeoffset(void)
 {
 	return mach_gettimeoffset() * 1000;
 }
@@ -106,3 +101,12 @@ static int __init rtc_init(void)
 module_init(rtc_init);
 
 #endif /* CONFIG_ARCH_USES_GETTIMEOFFSET */
+
+void __init time_init(void)
+{
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
+	arch_gettimeoffset = m68k_gettimeoffset;
+#endif
+
+	mach_sched_init(timer_interrupt);
+}
diff --git a/include/linux/time.h b/include/linux/time.h
index 4d358e9..05e32a7 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -142,9 +142,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta);
  * finer then tick granular time.
  */
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
-extern u32 arch_gettimeoffset(void);
-#else
-static inline u32 arch_gettimeoffset(void) { return 0; }
+extern u32 (*arch_gettimeoffset)(void);
 #endif
 
 extern void do_gettimeofday(struct timeval *tv);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e424970..9d00ace 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -140,6 +140,20 @@ static void tk_setup_internals(struct timekeeper *tk, struct clocksource *clock)
 }
 
 /* Timekeeper helper functions. */
+
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
+u32 (*arch_gettimeoffset)(void);
+
+u32 gettimeoffset(void)
+{
+	if (likely(arch_gettimeoffset))
+		return arch_gettimeoffset();
+	return 0;
+}
+#else
+static inline u32 gettimeoffset(void) { return 0; }
+#endif
+
 static inline s64 timekeeping_get_ns(struct timekeeper *tk)
 {
 	cycle_t cycle_now, cycle_delta;
@@ -157,7 +171,7 @@ static inline s64 timekeeping_get_ns(struct timekeeper *tk)
 	nsec >>= tk->shift;
 
 	/* If arch requires, add in gettimeoffset() */
-	return nsec + arch_gettimeoffset();
+	return nsec + gettimeoffset();
 }
 
 static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
@@ -177,7 +191,7 @@ static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
 
 	/* If arch requires, add in gettimeoffset() */
-	return nsec + arch_gettimeoffset();
+	return nsec + gettimeoffset();
 }
 
 /* must hold write on timekeeper.lock */
@@ -211,7 +225,7 @@ static void timekeeping_forward_now(struct timekeeper *tk)
 	tk->xtime_nsec += cycle_delta * tk->mult;
 
 	/* If arch requires, add in gettimeoffset() */
-	tk->xtime_nsec += (u64)arch_gettimeoffset() << tk->shift;
+	tk->xtime_nsec += (u64)gettimeoffset() << tk->shift;
 
 	tk_normalize_xtime(tk);
 
-- 
1.7.0.4

