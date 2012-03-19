Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161376Ab2CSQJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:09:58 -0400
Received: from mail-we0-f194.google.com ([74.125.82.194]:56543 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161167Ab2CSQJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:09:51 -0400
Date: Mon, 19 Mar 2012 17:09:47 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer changes for v3.4
Message-ID: <20120319160946.GA7071@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

   HEAD: a078c6d0e6288fad6d83fb6d5edd91ddb7b6ab33 ntp: Fix integer overflow when setting time

 Thanks,

	Ingo

------------------>
Arjan van de Ven (1):
      clocksource: Load the ACPI PM clocksource asynchronously

Frederic Weisbecker (2):
      nohz: Remove ts->Einidle checks before restarting the tick
      timer: Fix bad idle check on irq entry

Ingo Molnar (1):
      clocksource: scx200_hrt: Fix the build

Jan Beulich (1):
      x86/time: Eliminate unused irq0_irqs counter

Jens Rottmann (2):
      cs5535-clockevt: Don't ignore MFGPT on SMP-capable kernels
      cs5535-clockevt: Allow the MFGPT IRQ to be shared

Jim Cromie (1):
      clocksource: scx200_hrt:  use pr_<level> instead of printk

John Stultz (12):
      rtc: Avoid setting alarm to a time in the past
      time: Move total_sleep_time into the timekeeper structure
      time: Move wall_to_monotonic into the timekeeper structure
      time: Move xtime into timekeeeper structure
      time: Move raw_time into timekeeper structure
      time: Cleanup global variables and move them to the top
      time: Add timekeeper lock
      ntp: Cleanup timex.h
      ntp: Access tick_length variable via ntp_tick_length()
      ntp: Add ntp_lock to replace xtime_locking
      time: Remove most of xtime_lock usage in timekeeping.c
      clocksource: scx200_hrt: Convert scx200 to use clocksource_register_hz

Julia Lawall (1):
      clocksource: cyclone: Add missing iounmap

Michal Hocko (1):
      nohz: Remove update_ts_time_stat from tick_nohz_start_idle

NeilBrown (1):
      rtc: Expire alarms after the time is set. (v2)

Rabin Vincent (1):
      rtc: Disable the alarm in the hardware (v2)

Sasha Levin (2):
      math: Introduce div64_long
      ntp: Fix integer overflow when setting time

Suresh Siddha (2):
      clockevents: Leave the broadcast device in shutdown mode when not needed
      x86/tsc: Reduce the TSC sync check time for core-siblings

Thomas Gleixner (2):
      time: Reorder so the hot data is together
      time: Move common updates to a function

Yong Zhang (2):
      clocksource: dbx500: convert to clocksource_register_hz()
      clocksource: Get rid of clocksource_calc_mult_shift()


 arch/x86/include/asm/hardirq.h            |    1 -
 arch/x86/kernel/time.c                    |    3 -
 arch/x86/kernel/tsc_sync.c                |   29 ++-
 drivers/clocksource/acpi_pm.c             |   24 ++-
 drivers/clocksource/clksrc-dbx500-prcmu.c |    5 +-
 drivers/clocksource/cs5535-clockevt.c     |    3 +-
 drivers/clocksource/cyclone.c             |    2 +-
 drivers/clocksource/scx200_hrt.c          |   24 +--
 drivers/rtc/interface.c                   |   30 +++-
 include/linux/clocksource.h               |    7 -
 include/linux/math64.h                    |    4 +
 include/linux/timex.h                     |   17 +--
 kernel/softirq.c                          |    2 +-
 kernel/time/ntp.c                         |   85 ++++++--
 kernel/time/tick-broadcast.c              |    4 +
 kernel/time/tick-sched.c                  |   17 +-
 kernel/time/timekeeping.c                 |  338 ++++++++++++++++-------------
 17 files changed, 343 insertions(+), 252 deletions(-)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index da0b3ca..382f75d 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -7,7 +7,6 @@
 typedef struct {
 	unsigned int __softirq_pending;
 	unsigned int __nmi_count;	/* arch dependent */
-	unsigned int irq0_irqs;
 #ifdef CONFIG_X86_LOCAL_APIC
 	unsigned int apic_timer_irqs;	/* arch dependent */
 	unsigned int irq_spurious_count;
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index dd5fbf4..c6eba2b 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -57,9 +57,6 @@ EXPORT_SYMBOL(profile_pc);
  */
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
-	/* Keep nmi watchdog up to date */
-	inc_irq_stat(irq0_irqs);
-
 	global_clock_event->event_handler(global_clock_event);
 
 	/* MCA bus quirk: Acknowledge irq0 by setting bit 7 in port 0x61 */
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 9eba29b..fc25e60 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -42,7 +42,7 @@ static __cpuinitdata int nr_warps;
 /*
  * TSC-warp measurement loop running on both CPUs:
  */
-static __cpuinit void check_tsc_warp(void)
+static __cpuinit void check_tsc_warp(unsigned int timeout)
 {
 	cycles_t start, now, prev, end;
 	int i;
@@ -51,9 +51,9 @@ static __cpuinit void check_tsc_warp(void)
 	start = get_cycles();
 	rdtsc_barrier();
 	/*
-	 * The measurement runs for 20 msecs:
+	 * The measurement runs for 'timeout' msecs:
 	 */
-	end = start + tsc_khz * 20ULL;
+	end = start + (cycles_t) tsc_khz * timeout;
 	now = start;
 
 	for (i = 0; ; i++) {
@@ -99,6 +99,25 @@ static __cpuinit void check_tsc_warp(void)
 }
 
 /*
+ * If the target CPU coming online doesn't have any of its core-siblings
+ * online, a timeout of 20msec will be used for the TSC-warp measurement
+ * loop. Otherwise a smaller timeout of 2msec will be used, as we have some
+ * information about this socket already (and this information grows as we
+ * have more and more logical-siblings in that socket).
+ *
+ * Ideally we should be able to skip the TSC sync check on the other
+ * core-siblings, if the first logical CPU in a socket passed the sync test.
+ * But as the TSC is per-logical CPU and can potentially be modified wrongly
+ * by the bios, TSC sync test for smaller duration should be able
+ * to catch such errors. Also this will catch the condition where all the
+ * cores in the socket doesn't get reset at the same time.
+ */
+static inline unsigned int loop_timeout(int cpu)
+{
+	return (cpumask_weight(cpu_core_mask(cpu)) > 1) ? 2 : 20;
+}
+
+/*
  * Source CPU calls into this - it waits for the freshly booted
  * target CPU to arrive and then starts the measurement:
  */
@@ -135,7 +154,7 @@ void __cpuinit check_tsc_sync_source(int cpu)
 	 */
 	atomic_inc(&start_count);
 
-	check_tsc_warp();
+	check_tsc_warp(loop_timeout(cpu));
 
 	while (atomic_read(&stop_count) != cpus-1)
 		cpu_relax();
@@ -183,7 +202,7 @@ void __cpuinit check_tsc_sync_target(void)
 	while (atomic_read(&start_count) != cpus)
 		cpu_relax();
 
-	check_tsc_warp();
+	check_tsc_warp(loop_timeout(smp_processor_id()));
 
 	/*
 	 * Ok, we are done:
diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 6b5cf02..82e8820 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/async.h>
 #include <asm/io.h>
 
 /*
@@ -179,17 +180,15 @@ static int verify_pmtmr_rate(void)
 /* Number of reads we try to get two different values */
 #define ACPI_PM_READ_CHECKS 10000
 
-static int __init init_acpi_pm_clocksource(void)
+static void __init acpi_pm_clocksource_async(void *unused, async_cookie_t cookie)
 {
 	cycle_t value1, value2;
 	unsigned int i, j = 0;
 
-	if (!pmtmr_ioport)
-		return -ENODEV;
 
 	/* "verify" this timing source: */
 	for (j = 0; j < ACPI_PM_MONOTONICITY_CHECKS; j++) {
-		udelay(100 * j);
+		usleep_range(100 * j, 100 * j + 100);
 		value1 = clocksource_acpi_pm.read(&clocksource_acpi_pm);
 		for (i = 0; i < ACPI_PM_READ_CHECKS; i++) {
 			value2 = clocksource_acpi_pm.read(&clocksource_acpi_pm);
@@ -203,25 +202,34 @@ static int __init init_acpi_pm_clocksource(void)
 			       " 0x%#llx, 0x%#llx - aborting.\n",
 			       value1, value2);
 			pmtmr_ioport = 0;
-			return -EINVAL;
+			return;
 		}
 		if (i == ACPI_PM_READ_CHECKS) {
 			printk(KERN_INFO "PM-Timer failed consistency check "
 			       " (0x%#llx) - aborting.\n", value1);
 			pmtmr_ioport = 0;
-			return -ENODEV;
+			return;
 		}
 	}
 
 	if (verify_pmtmr_rate() != 0){
 		pmtmr_ioport = 0;
-		return -ENODEV;
+		return;
 	}
 
-	return clocksource_register_hz(&clocksource_acpi_pm,
+	clocksource_register_hz(&clocksource_acpi_pm,
 						PMTMR_TICKS_PER_SEC);
 }
 
+static int __init init_acpi_pm_clocksource(void)
+{
+	if (!pmtmr_ioport)
+		return -ENODEV;
+
+	async_schedule(acpi_pm_clocksource_async, NULL);
+	return 0;
+}
+
 /* We use fs_initcall because we want the PCI fixups to have run
  * but we still need to load before device_initcall
  */
diff --git a/drivers/clocksource/clksrc-dbx500-prcmu.c b/drivers/clocksource/clksrc-dbx500-prcmu.c
index fb6b6d2..c26c369 100644
--- a/drivers/clocksource/clksrc-dbx500-prcmu.c
+++ b/drivers/clocksource/clksrc-dbx500-prcmu.c
@@ -52,7 +52,6 @@ static struct clocksource clocksource_dbx500_prcmu = {
 	.name		= "dbx500-prcmu-timer",
 	.rating		= 300,
 	.read		= clksrc_dbx500_prcmu_read,
-	.shift		= 10,
 	.mask		= CLOCKSOURCE_MASK(32),
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
@@ -90,7 +89,5 @@ void __init clksrc_dbx500_prcmu_init(void __iomem *base)
 	setup_sched_clock(dbx500_prcmu_sched_clock_read,
 			 32, RATE_32K);
 #endif
-	clocksource_calc_mult_shift(&clocksource_dbx500_prcmu,
-				    RATE_32K, SCHED_CLOCK_MIN_WRAP);
-	clocksource_register(&clocksource_dbx500_prcmu);
+	clocksource_register_hz(&clocksource_dbx500_prcmu, RATE_32K);
 }
diff --git a/drivers/clocksource/cs5535-clockevt.c b/drivers/clocksource/cs5535-clockevt.c
index b7dab32..540795c 100644
--- a/drivers/clocksource/cs5535-clockevt.c
+++ b/drivers/clocksource/cs5535-clockevt.c
@@ -100,7 +100,6 @@ static struct clock_event_device cs5535_clockevent = {
 	.set_mode = mfgpt_set_mode,
 	.set_next_event = mfgpt_next_event,
 	.rating = 250,
-	.cpumask = cpu_all_mask,
 	.shift = 32
 };
 
@@ -133,7 +132,7 @@ static irqreturn_t mfgpt_tick(int irq, void *dev_id)
 
 static struct irqaction mfgptirq  = {
 	.handler = mfgpt_tick,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER | IRQF_SHARED,
 	.name = DRV_NAME,
 };
 
diff --git a/drivers/clocksource/cyclone.c b/drivers/clocksource/cyclone.c
index 72f811f..9e0998f 100644
--- a/drivers/clocksource/cyclone.c
+++ b/drivers/clocksource/cyclone.c
@@ -55,11 +55,11 @@ static int __init init_cyclone_clocksource(void)
 	}
 	/* even on 64bit systems, this is only 32bits: */
 	base = readl(reg);
+	iounmap(reg);
 	if (!base) {
 		printk(KERN_ERR "Summit chipset: Could not find valid CBAR value.\n");
 		return -ENODEV;
 	}
-	iounmap(reg);
 
 	/* setup PMCC: */
 	offset = base + CYCLONE_PMCC_OFFSET;
diff --git a/drivers/clocksource/scx200_hrt.c b/drivers/clocksource/scx200_hrt.c
index 27f4d96..64f9e82 100644
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
@@ -71,7 +69,7 @@ static int __init init_hrt_clocksource(void)
 	if (!request_region(scx200_cb_base + SCx200_TIMER_OFFSET,
 			    SCx200_TIMER_SIZE,
 			    "NatSemi SCx200 High-Resolution Timer")) {
-		printk(KERN_WARNING NAME ": unable to lock timer region\n");
+		pr_warn("unable to lock timer region\n");
 		return -ENODEV;
 	}
 
@@ -79,19 +77,13 @@ static int __init init_hrt_clocksource(void)
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
-	printk(KERN_INFO "enabling scx200 high-res timer (%s MHz +%d ppm)\n",
-		mhz27 ? "27":"1", ppm);
+	freq = (HRT_FREQ + ppm);
+	if (mhz27)
+		freq *= 27;
+
+	pr_info("enabling scx200 high-res timer (%s MHz +%d ppm)\n", mhz27 ? "27":"1", ppm);
 
-	return clocksource_register(&cs_hrt);
+	return clocksource_register_hz(&cs_hrt, freq);
 }
 
 module_init(init_hrt_clocksource);
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 8a1c031..dc87eda 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -73,6 +73,8 @@ int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm)
 		err = -EINVAL;
 
 	mutex_unlock(&rtc->ops_lock);
+	/* A timer might have just expired */
+	schedule_work(&rtc->irqwork);
 	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_set_time);
@@ -112,6 +114,8 @@ int rtc_set_mmss(struct rtc_device *rtc, unsigned long secs)
 		err = -EINVAL;
 
 	mutex_unlock(&rtc->ops_lock);
+	/* A timer might have just expired */
+	schedule_work(&rtc->irqwork);
 
 	return err;
 }
@@ -380,18 +384,27 @@ EXPORT_SYMBOL_GPL(rtc_set_alarm);
 int rtc_initialize_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 {
 	int err;
+	struct rtc_time now;
 
 	err = rtc_valid_tm(&alarm->time);
 	if (err != 0)
 		return err;
 
+	err = rtc_read_time(rtc, &now);
+	if (err)
+		return err;
+
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
 		return err;
 
 	rtc->aie_timer.node.expires = rtc_tm_to_ktime(alarm->time);
 	rtc->aie_timer.period = ktime_set(0, 0);
-	if (alarm->enabled) {
+
+	/* Alarm has to be enabled & in the futrure for us to enqueue it */
+	if (alarm->enabled && (rtc_tm_to_ktime(now).tv64 <
+			 rtc->aie_timer.node.expires.tv64)) {
+
 		rtc->aie_timer.enabled = 1;
 		timerqueue_add(&rtc->timerqueue, &rtc->aie_timer.node);
 	}
@@ -763,6 +776,14 @@ static int rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
 	return 0;
 }
 
+static void rtc_alarm_disable(struct rtc_device *rtc)
+{
+	if (!rtc->ops || !rtc->ops->alarm_irq_enable)
+		return;
+
+	rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
+}
+
 /**
  * rtc_timer_remove - Removes a rtc_timer from the rtc_device timerqueue
  * @rtc rtc device
@@ -784,8 +805,10 @@ static void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer)
 		struct rtc_wkalrm alarm;
 		int err;
 		next = timerqueue_getnext(&rtc->timerqueue);
-		if (!next)
+		if (!next) {
+			rtc_alarm_disable(rtc);
 			return;
+		}
 		alarm.time = rtc_ktime_to_tm(next->expires);
 		alarm.enabled = 1;
 		err = __rtc_set_alarm(rtc, &alarm);
@@ -847,7 +870,8 @@ again:
 		err = __rtc_set_alarm(rtc, &alarm);
 		if (err == -ETIME)
 			goto again;
-	}
+	} else
+		rtc_alarm_disable(rtc);
 
 	mutex_unlock(&rtc->ops_lock);
 }
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 081147d..fbe89e1 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -319,13 +319,6 @@ static inline void __clocksource_updatefreq_khz(struct clocksource *cs, u32 khz)
 	__clocksource_updatefreq_scale(cs, 1000, khz);
 }
 
-static inline void
-clocksource_calc_mult_shift(struct clocksource *cs, u32 freq, u32 minsec)
-{
-	return clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
-				      NSEC_PER_SEC, minsec);
-}
-
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void
 update_vsyscall(struct timespec *ts, struct timespec *wtm,
diff --git a/include/linux/math64.h b/include/linux/math64.h
index 23fcdfc..b8ba855 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -6,6 +6,8 @@
 
 #if BITS_PER_LONG == 64
 
+#define div64_long(x,y) div64_s64((x),(y))
+
 /**
  * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
  *
@@ -45,6 +47,8 @@ static inline s64 div64_s64(s64 dividend, s64 divisor)
 
 #elif BITS_PER_LONG == 32
 
+#define div64_long(x,y) div_s64((x),(y))
+
 #ifndef div_u64_rem
 static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
 {
diff --git a/include/linux/timex.h b/include/linux/timex.h
index aa60fe7..b75e186 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -234,23 +234,9 @@ struct timex {
 extern unsigned long tick_usec;		/* USER_HZ period (usec) */
 extern unsigned long tick_nsec;		/* ACTHZ          period (nsec) */
 
-/*
- * phase-lock loop variables
- */
-extern int time_status;		/* clock synchronization status bits */
-
 extern void ntp_init(void);
 extern void ntp_clear(void);
 
-/**
- * ntp_synced - Returns 1 if the NTP status is not UNSYNC
- *
- */
-static inline int ntp_synced(void)
-{
-	return !(time_status & STA_UNSYNC);
-}
-
 /* Required to safely shift negative values */
 #define shift_right(x, s) ({	\
 	__typeof__(x) __x = (x);	\
@@ -264,10 +250,9 @@ static inline int ntp_synced(void)
 #define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
 
 /* Returns how long ticks are at present, in ns / 2^NTP_SCALE_SHIFT. */
-extern u64 tick_length;
+extern u64 ntp_tick_length(void);
 
 extern void second_overflow(void);
-extern void update_ntp_one_tick(void);
 extern int do_adjtimex(struct timex *);
 extern void hardpps(const struct timespec *, const struct timespec *);
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 4eb3a0f..5ace266 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -297,7 +297,7 @@ void irq_enter(void)
 	int cpu = smp_processor_id();
 
 	rcu_irq_enter();
-	if (idle_cpu(cpu) && !in_interrupt()) {
+	if (is_idle_task(current) && !in_interrupt()) {
 		/*
 		 * Prevent raise_softirq from needlessly waking up ksoftirqd
 		 * here, as softirq will be serviced on return from interrupt.
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index f6117a4..6e039b1 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -22,13 +22,16 @@
  * NTP timekeeping variables:
  */
 
+DEFINE_SPINLOCK(ntp_lock);
+
+
 /* USER_HZ period (usecs): */
 unsigned long			tick_usec = TICK_USEC;
 
 /* ACTHZ period (nsecs): */
 unsigned long			tick_nsec;
 
-u64				tick_length;
+static u64			tick_length;
 static u64			tick_length_base;
 
 static struct hrtimer		leap_timer;
@@ -49,7 +52,7 @@ static struct hrtimer		leap_timer;
 static int			time_state = TIME_OK;
 
 /* clock status bits:							*/
-int				time_status = STA_UNSYNC;
+static int			time_status = STA_UNSYNC;
 
 /* TAI offset (secs):							*/
 static long			time_tai;
@@ -133,7 +136,7 @@ static inline void pps_reset_freq_interval(void)
 /**
  * pps_clear - Clears the PPS state variables
  *
- * Must be called while holding a write on the xtime_lock
+ * Must be called while holding a write on the ntp_lock
  */
 static inline void pps_clear(void)
 {
@@ -149,7 +152,7 @@ static inline void pps_clear(void)
  * the last PPS signal. When it reaches 0, indicate that PPS signal is
  * missing.
  *
- * Must be called while holding a write on the xtime_lock
+ * Must be called while holding a write on the ntp_lock
  */
 static inline void pps_dec_valid(void)
 {
@@ -233,6 +236,17 @@ static inline void pps_fill_timex(struct timex *txc)
 
 #endif /* CONFIG_NTP_PPS */
 
+
+/**
+ * ntp_synced - Returns 1 if the NTP status is not UNSYNC
+ *
+ */
+static inline int ntp_synced(void)
+{
+	return !(time_status & STA_UNSYNC);
+}
+
+
 /*
  * NTP methods:
  */
@@ -275,7 +289,7 @@ static inline s64 ntp_update_offset_fll(s64 offset64, long secs)
 
 	time_status |= STA_MODE;
 
-	return div_s64(offset64 << (NTP_SCALE_SHIFT - SHIFT_FLL), secs);
+	return div64_long(offset64 << (NTP_SCALE_SHIFT - SHIFT_FLL), secs);
 }
 
 static void ntp_update_offset(long offset)
@@ -330,11 +344,13 @@ static void ntp_update_offset(long offset)
 
 /**
  * ntp_clear - Clears the NTP state variables
- *
- * Must be called while holding a write on the xtime_lock
  */
 void ntp_clear(void)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&ntp_lock, flags);
+
 	time_adjust	= 0;		/* stop active adjtime() */
 	time_status	|= STA_UNSYNC;
 	time_maxerror	= NTP_PHASE_LIMIT;
@@ -347,8 +363,23 @@ void ntp_clear(void)
 
 	/* Clear PPS state variables */
 	pps_clear();
+	spin_unlock_irqrestore(&ntp_lock, flags);
+
 }
 
+
+u64 ntp_tick_length(void)
+{
+	unsigned long flags;
+	s64 ret;
+
+	spin_lock_irqsave(&ntp_lock, flags);
+	ret = tick_length;
+	spin_unlock_irqrestore(&ntp_lock, flags);
+	return ret;
+}
+
+
 /*
  * Leap second processing. If in leap-insert state at the end of the
  * day, the system clock is set back one second; if in leap-delete
@@ -357,14 +388,15 @@ void ntp_clear(void)
 static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 {
 	enum hrtimer_restart res = HRTIMER_NORESTART;
+	unsigned long flags;
+	int leap = 0;
 
-	write_seqlock(&xtime_lock);
-
+	spin_lock_irqsave(&ntp_lock, flags);
 	switch (time_state) {
 	case TIME_OK:
 		break;
 	case TIME_INS:
-		timekeeping_leap_insert(-1);
+		leap = -1;
 		time_state = TIME_OOP;
 		printk(KERN_NOTICE
 			"Clock: inserting leap second 23:59:60 UTC\n");
@@ -372,7 +404,7 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 		res = HRTIMER_RESTART;
 		break;
 	case TIME_DEL:
-		timekeeping_leap_insert(1);
+		leap = 1;
 		time_tai--;
 		time_state = TIME_WAIT;
 		printk(KERN_NOTICE
@@ -387,8 +419,14 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 			time_state = TIME_OK;
 		break;
 	}
+	spin_unlock_irqrestore(&ntp_lock, flags);
 
-	write_sequnlock(&xtime_lock);
+	/*
+	 * We have to call this outside of the ntp_lock to keep
+	 * the proper locking hierarchy
+	 */
+	if (leap)
+		timekeeping_leap_insert(leap);
 
 	return res;
 }
@@ -404,6 +442,9 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 void second_overflow(void)
 {
 	s64 delta;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ntp_lock, flags);
 
 	/* Bump the maxerror field */
 	time_maxerror += MAXFREQ / NSEC_PER_USEC;
@@ -423,23 +464,25 @@ void second_overflow(void)
 	pps_dec_valid();
 
 	if (!time_adjust)
-		return;
+		goto out;
 
 	if (time_adjust > MAX_TICKADJ) {
 		time_adjust -= MAX_TICKADJ;
 		tick_length += MAX_TICKADJ_SCALED;
-		return;
+		goto out;
 	}
 
 	if (time_adjust < -MAX_TICKADJ) {
 		time_adjust += MAX_TICKADJ;
 		tick_length -= MAX_TICKADJ_SCALED;
-		return;
+		goto out;
 	}
 
 	tick_length += (s64)(time_adjust * NSEC_PER_USEC / NTP_INTERVAL_FREQ)
 							 << NTP_SCALE_SHIFT;
 	time_adjust = 0;
+out:
+	spin_unlock_irqrestore(&ntp_lock, flags);
 }
 
 #ifdef CONFIG_GENERIC_CMOS_UPDATE
@@ -663,7 +706,7 @@ int do_adjtimex(struct timex *txc)
 
 	getnstimeofday(&ts);
 
-	write_seqlock_irq(&xtime_lock);
+	spin_lock_irq(&ntp_lock);
 
 	if (txc->modes & ADJ_ADJTIME) {
 		long save_adjust = time_adjust;
@@ -705,7 +748,7 @@ int do_adjtimex(struct timex *txc)
 	/* fill PPS status fields */
 	pps_fill_timex(txc);
 
-	write_sequnlock_irq(&xtime_lock);
+	spin_unlock_irq(&ntp_lock);
 
 	txc->time.tv_sec = ts.tv_sec;
 	txc->time.tv_usec = ts.tv_nsec;
@@ -903,7 +946,7 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 	pts_norm = pps_normalize_ts(*phase_ts);
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	spin_lock_irqsave(&ntp_lock, flags);
 
 	/* clear the error bits, they will be set again if needed */
 	time_status &= ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
@@ -916,7 +959,7 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 	 * just start the frequency interval */
 	if (unlikely(pps_fbase.tv_sec == 0)) {
 		pps_fbase = *raw_ts;
-		write_sequnlock_irqrestore(&xtime_lock, flags);
+		spin_unlock_irqrestore(&ntp_lock, flags);
 		return;
 	}
 
@@ -931,7 +974,7 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 		time_status |= STA_PPSJITTER;
 		/* restart the frequency calibration interval */
 		pps_fbase = *raw_ts;
-		write_sequnlock_irqrestore(&xtime_lock, flags);
+		spin_unlock_irqrestore(&ntp_lock, flags);
 		pr_err("hardpps: PPSJITTER: bad pulse\n");
 		return;
 	}
@@ -948,7 +991,7 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 	hardpps_update_phase(pts_norm.nsec);
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	spin_unlock_irqrestore(&ntp_lock, flags);
 }
 EXPORT_SYMBOL(hardpps);
 
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index fd4a7b1..e883f57 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -575,11 +575,15 @@ void tick_broadcast_switch_to_oneshot(void)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
+	if (cpumask_empty(tick_get_broadcast_mask()))
+		goto end;
 
 	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
 	bc = tick_broadcast_device.evtdev;
 	if (bc)
 		tick_broadcast_setup_oneshot(bc);
+
+end:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 7656642..3526038 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -182,11 +182,7 @@ static void tick_nohz_stop_idle(int cpu, ktime_t now)
 
 static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
 {
-	ktime_t now;
-
-	now = ktime_get();
-
-	update_ts_time_stats(cpu, ts, now, NULL);
+	ktime_t now = ktime_get();
 
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
@@ -562,20 +558,21 @@ void tick_nohz_idle_exit(void)
 
 	local_irq_disable();
 
-	if (ts->idle_active || (ts->inidle && ts->tick_stopped))
+	WARN_ON_ONCE(!ts->inidle);
+
+	ts->inidle = 0;
+
+	if (ts->idle_active || ts->tick_stopped)
 		now = ktime_get();
 
 	if (ts->idle_active)
 		tick_nohz_stop_idle(cpu, now);
 
-	if (!ts->inidle || !ts->tick_stopped) {
-		ts->inidle = 0;
+	if (!ts->tick_stopped) {
 		local_irq_enable();
 		return;
 	}
 
-	ts->inidle = 0;
-
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 0c63581..403c2a0 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -25,6 +25,8 @@
 struct timekeeper {
 	/* Current clocksource used for timekeeping. */
 	struct clocksource *clock;
+	/* NTP adjusted clock multiplier */
+	u32	mult;
 	/* The shift value of the current clocksource. */
 	int	shift;
 
@@ -45,12 +47,47 @@ struct timekeeper {
 	/* Shift conversion between clock shifted nano seconds and
 	 * ntp shifted nano seconds. */
 	int	ntp_error_shift;
-	/* NTP adjusted clock multiplier */
-	u32	mult;
+
+	/* The current time */
+	struct timespec xtime;
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
 };
 
 static struct timekeeper timekeeper;
 
+/*
+ * This read-write spinlock protects us from races in SMP while
+ * playing with xtime.
+ */
+__cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
+
+
+/* flag for if timekeeping is suspended */
+int __read_mostly timekeeping_suspended;
+
+
+
 /**
  * timekeeper_setup_internals - Set up internals to use clocksource clock.
  *
@@ -135,47 +172,28 @@ static inline s64 timekeeping_get_ns_raw(void)
 	return clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
 }
 
-/*
- * This read-write spinlock protects us from races in SMP while
- * playing with xtime.
- */
-__cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
-
-
-/*
- * The current time
- * wall_to_monotonic is what we need to add to xtime (or xtime corrected
- * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
- * at zero at system boot time, so wall_to_monotonic will be negative,
- * however, we will ALWAYS keep the tv_nsec part positive so we can use
- * the usual normalization.
- *
- * wall_to_monotonic is moved after resume from suspend for the monotonic
- * time not to jump. We need to add total_sleep_time to wall_to_monotonic
- * to get the real boot based time offset.
- *
- * - wall_to_monotonic is no longer the boot time, getboottime must be
- * used instead.
- */
-static struct timespec xtime __attribute__ ((aligned (16)));
-static struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
-static struct timespec total_sleep_time;
-
-/*
- * The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock.
- */
-static struct timespec raw_time;
+/* must hold write on timekeeper.lock */
+static void timekeeping_update(bool clearntp)
+{
+	if (clearntp) {
+		timekeeper.ntp_error = 0;
+		ntp_clear();
+	}
+	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
+			 timekeeper.clock, timekeeper.mult);
+}
 
-/* flag for if timekeeping is suspended */
-int __read_mostly timekeeping_suspended;
 
-/* must hold xtime_lock */
 void timekeeping_leap_insert(int leapsecond)
 {
-	xtime.tv_sec += leapsecond;
-	wall_to_monotonic.tv_sec -= leapsecond;
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
-			timekeeper.mult);
+	unsigned long flags;
+
+	write_seqlock_irqsave(&timekeeper.lock, flags);
+	timekeeper.xtime.tv_sec += leapsecond;
+	timekeeper.wall_to_monotonic.tv_sec -= leapsecond;
+	timekeeping_update(false);
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+
 }
 
 /**
@@ -202,10 +220,10 @@ static void timekeeping_forward_now(void)
 	/* If arch requires, add in gettimeoffset() */
 	nsec += arch_gettimeoffset();
 
-	timespec_add_ns(&xtime, nsec);
+	timespec_add_ns(&timekeeper.xtime, nsec);
 
 	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
-	timespec_add_ns(&raw_time, nsec);
+	timespec_add_ns(&timekeeper.raw_time, nsec);
 }
 
 /**
@@ -222,15 +240,15 @@ void getnstimeofday(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqbegin(&timekeeper.lock);
 
-		*ts = xtime;
+		*ts = timekeeper.xtime;
 		nsecs = timekeeping_get_ns();
 
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&timekeeper.lock, seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -245,14 +263,16 @@ ktime_t ktime_get(void)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
-		secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
-		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
+		seq = read_seqbegin(&timekeeper.lock);
+		secs = timekeeper.xtime.tv_sec +
+				timekeeper.wall_to_monotonic.tv_sec;
+		nsecs = timekeeper.xtime.tv_nsec +
+				timekeeper.wall_to_monotonic.tv_nsec;
 		nsecs += timekeeping_get_ns();
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&timekeeper.lock, seq));
 	/*
 	 * Use ktime_set/ktime_add_ns to create a proper ktime on
 	 * 32-bit architectures without CONFIG_KTIME_SCALAR.
@@ -278,14 +298,14 @@ void ktime_get_ts(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
-		*ts = xtime;
-		tomono = wall_to_monotonic;
+		seq = read_seqbegin(&timekeeper.lock);
+		*ts = timekeeper.xtime;
+		tomono = timekeeper.wall_to_monotonic;
 		nsecs = timekeeping_get_ns();
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&timekeeper.lock, seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
 				ts->tv_nsec + tomono.tv_nsec + nsecs);
@@ -313,10 +333,10 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 	do {
 		u32 arch_offset;
 
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqbegin(&timekeeper.lock);
 
-		*ts_raw = raw_time;
-		*ts_real = xtime;
+		*ts_raw = timekeeper.raw_time;
+		*ts_real = timekeeper.xtime;
 
 		nsecs_raw = timekeeping_get_ns_raw();
 		nsecs_real = timekeeping_get_ns();
@@ -326,7 +346,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 		nsecs_raw += arch_offset;
 		nsecs_real += arch_offset;
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&timekeeper.lock, seq));
 
 	timespec_add_ns(ts_raw, nsecs_raw);
 	timespec_add_ns(ts_real, nsecs_real);
@@ -365,23 +385,19 @@ int do_settimeofday(const struct timespec *tv)
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	write_seqlock_irqsave(&timekeeper.lock, flags);
 
 	timekeeping_forward_now();
 
-	ts_delta.tv_sec = tv->tv_sec - xtime.tv_sec;
-	ts_delta.tv_nsec = tv->tv_nsec - xtime.tv_nsec;
-	wall_to_monotonic = timespec_sub(wall_to_monotonic, ts_delta);
-
-	xtime = *tv;
+	ts_delta.tv_sec = tv->tv_sec - timekeeper.xtime.tv_sec;
+	ts_delta.tv_nsec = tv->tv_nsec - timekeeper.xtime.tv_nsec;
+	timekeeper.wall_to_monotonic =
+			timespec_sub(timekeeper.wall_to_monotonic, ts_delta);
 
-	timekeeper.ntp_error = 0;
-	ntp_clear();
-
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
-				timekeeper.mult);
+	timekeeper.xtime = *tv;
+	timekeeping_update(true);
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -405,20 +421,17 @@ int timekeeping_inject_offset(struct timespec *ts)
 	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	write_seqlock_irqsave(&timekeeper.lock, flags);
 
 	timekeeping_forward_now();
 
-	xtime = timespec_add(xtime, *ts);
-	wall_to_monotonic = timespec_sub(wall_to_monotonic, *ts);
-
-	timekeeper.ntp_error = 0;
-	ntp_clear();
+	timekeeper.xtime = timespec_add(timekeeper.xtime, *ts);
+	timekeeper.wall_to_monotonic =
+				timespec_sub(timekeeper.wall_to_monotonic, *ts);
 
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
-				timekeeper.mult);
+	timekeeping_update(true);
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -490,11 +503,11 @@ void getrawmonotonic(struct timespec *ts)
 	s64 nsecs;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqbegin(&timekeeper.lock);
 		nsecs = timekeeping_get_ns_raw();
-		*ts = raw_time;
+		*ts = timekeeper.raw_time;
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&timekeeper.lock, seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -510,24 +523,30 @@ int timekeeping_valid_for_hres(void)
 	int ret;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqbegin(&timekeeper.lock);
 
 		ret = timekeeper.clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&timekeeper.lock, seq));
 
 	return ret;
 }
 
 /**
  * timekeeping_max_deferment - Returns max time the clocksource can be deferred
- *
- * Caller must observe xtime_lock via read_seqbegin/read_seqretry to
- * ensure that the clocksource does not change!
  */
 u64 timekeeping_max_deferment(void)
 {
-	return timekeeper.clock->max_idle_ns;
+	unsigned long seq;
+	u64 ret;
+	do {
+		seq = read_seqbegin(&timekeeper.lock);
+
+		ret = timekeeper.clock->max_idle_ns;
+
+	} while (read_seqretry(&timekeeper.lock, seq));
+
+	return ret;
 }
 
 /**
@@ -572,28 +591,29 @@ void __init timekeeping_init(void)
 	read_persistent_clock(&now);
 	read_boot_clock(&boot);
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	seqlock_init(&timekeeper.lock);
 
 	ntp_init();
 
+	write_seqlock_irqsave(&timekeeper.lock, flags);
 	clock = clocksource_default_clock();
 	if (clock->enable)
 		clock->enable(clock);
 	timekeeper_setup_internals(clock);
 
-	xtime.tv_sec = now.tv_sec;
-	xtime.tv_nsec = now.tv_nsec;
-	raw_time.tv_sec = 0;
-	raw_time.tv_nsec = 0;
+	timekeeper.xtime.tv_sec = now.tv_sec;
+	timekeeper.xtime.tv_nsec = now.tv_nsec;
+	timekeeper.raw_time.tv_sec = 0;
+	timekeeper.raw_time.tv_nsec = 0;
 	if (boot.tv_sec == 0 && boot.tv_nsec == 0) {
-		boot.tv_sec = xtime.tv_sec;
-		boot.tv_nsec = xtime.tv_nsec;
+		boot.tv_sec = timekeeper.xtime.tv_sec;
+		boot.tv_nsec = timekeeper.xtime.tv_nsec;
 	}
-	set_normalized_timespec(&wall_to_monotonic,
+	set_normalized_timespec(&timekeeper.wall_to_monotonic,
 				-boot.tv_sec, -boot.tv_nsec);
-	total_sleep_time.tv_sec = 0;
-	total_sleep_time.tv_nsec = 0;
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	timekeeper.total_sleep_time.tv_sec = 0;
+	timekeeper.total_sleep_time.tv_nsec = 0;
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 }
 
 /* time in seconds when suspend began */
@@ -614,9 +634,11 @@ static void __timekeeping_inject_sleeptime(struct timespec *delta)
 		return;
 	}
 
-	xtime = timespec_add(xtime, *delta);
-	wall_to_monotonic = timespec_sub(wall_to_monotonic, *delta);
-	total_sleep_time = timespec_add(total_sleep_time, *delta);
+	timekeeper.xtime = timespec_add(timekeeper.xtime, *delta);
+	timekeeper.wall_to_monotonic =
+			timespec_sub(timekeeper.wall_to_monotonic, *delta);
+	timekeeper.total_sleep_time = timespec_add(
+					timekeeper.total_sleep_time, *delta);
 }
 
 
@@ -640,17 +662,15 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 	if (!(ts.tv_sec == 0 && ts.tv_nsec == 0))
 		return;
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	write_seqlock_irqsave(&timekeeper.lock, flags);
+
 	timekeeping_forward_now();
 
 	__timekeeping_inject_sleeptime(delta);
 
-	timekeeper.ntp_error = 0;
-	ntp_clear();
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
-				timekeeper.mult);
+	timekeeping_update(true);
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -673,7 +693,7 @@ static void timekeeping_resume(void)
 
 	clocksource_resume();
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	write_seqlock_irqsave(&timekeeper.lock, flags);
 
 	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
 		ts = timespec_sub(ts, timekeeping_suspend_time);
@@ -683,7 +703,7 @@ static void timekeeping_resume(void)
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
 	timekeeper.ntp_error = 0;
 	timekeeping_suspended = 0;
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
 	touch_softlockup_watchdog();
 
@@ -701,7 +721,7 @@ static int timekeeping_suspend(void)
 
 	read_persistent_clock(&timekeeping_suspend_time);
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	write_seqlock_irqsave(&timekeeper.lock, flags);
 	timekeeping_forward_now();
 	timekeeping_suspended = 1;
 
@@ -711,7 +731,7 @@ static int timekeeping_suspend(void)
 	 * try to compensate so the difference in system time
 	 * and persistent_clock time stays close to constant.
 	 */
-	delta = timespec_sub(xtime, timekeeping_suspend_time);
+	delta = timespec_sub(timekeeper.xtime, timekeeping_suspend_time);
 	delta_delta = timespec_sub(delta, old_delta);
 	if (abs(delta_delta.tv_sec)  >= 2) {
 		/*
@@ -724,7 +744,7 @@ static int timekeeping_suspend(void)
 		timekeeping_suspend_time =
 			timespec_add(timekeeping_suspend_time, delta_delta);
 	}
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 	clocksource_suspend();
@@ -775,7 +795,7 @@ static __always_inline int timekeeping_bigadjust(s64 error, s64 *interval,
 	 * Now calculate the error in (1 << look_ahead) ticks, but first
 	 * remove the single look ahead already included in the error.
 	 */
-	tick_error = tick_length >> (timekeeper.ntp_error_shift + 1);
+	tick_error = ntp_tick_length() >> (timekeeper.ntp_error_shift + 1);
 	tick_error -= timekeeper.xtime_interval >> 1;
 	error = ((error - tick_error) >> look_ahead) + tick_error;
 
@@ -943,22 +963,22 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 	timekeeper.xtime_nsec += timekeeper.xtime_interval << shift;
 	while (timekeeper.xtime_nsec >= nsecps) {
 		timekeeper.xtime_nsec -= nsecps;
-		xtime.tv_sec++;
+		timekeeper.xtime.tv_sec++;
 		second_overflow();
 	}
 
 	/* Accumulate raw time */
 	raw_nsecs = timekeeper.raw_interval << shift;
-	raw_nsecs += raw_time.tv_nsec;
+	raw_nsecs += timekeeper.raw_time.tv_nsec;
 	if (raw_nsecs >= NSEC_PER_SEC) {
 		u64 raw_secs = raw_nsecs;
 		raw_nsecs = do_div(raw_secs, NSEC_PER_SEC);
-		raw_time.tv_sec += raw_secs;
+		timekeeper.raw_time.tv_sec += raw_secs;
 	}
-	raw_time.tv_nsec = raw_nsecs;
+	timekeeper.raw_time.tv_nsec = raw_nsecs;
 
 	/* Accumulate error between NTP and clock interval */
-	timekeeper.ntp_error += tick_length << shift;
+	timekeeper.ntp_error += ntp_tick_length() << shift;
 	timekeeper.ntp_error -=
 	    (timekeeper.xtime_interval + timekeeper.xtime_remainder) <<
 				(timekeeper.ntp_error_shift + shift);
@@ -970,17 +990,19 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 /**
  * update_wall_time - Uses the current clocksource to increment the wall time
  *
- * Called from the timer interrupt, must hold a write on xtime_lock.
  */
 static void update_wall_time(void)
 {
 	struct clocksource *clock;
 	cycle_t offset;
 	int shift = 0, maxshift;
+	unsigned long flags;
+
+	write_seqlock_irqsave(&timekeeper.lock, flags);
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
-		return;
+		goto out;
 
 	clock = timekeeper.clock;
 
@@ -989,7 +1011,8 @@ static void update_wall_time(void)
 #else
 	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #endif
-	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << timekeeper.shift;
+	timekeeper.xtime_nsec = (s64)timekeeper.xtime.tv_nsec <<
+						timekeeper.shift;
 
 	/*
 	 * With NO_HZ we may have to accumulate many cycle_intervals
@@ -1002,7 +1025,7 @@ static void update_wall_time(void)
 	shift = ilog2(offset) - ilog2(timekeeper.cycle_interval);
 	shift = max(0, shift);
 	/* Bound shift to one less then what overflows tick_length */
-	maxshift = (8*sizeof(tick_length) - (ilog2(tick_length)+1)) - 1;
+	maxshift = (64 - (ilog2(ntp_tick_length())+1)) - 1;
 	shift = min(shift, maxshift);
 	while (offset >= timekeeper.cycle_interval) {
 		offset = logarithmic_accumulation(offset, shift);
@@ -1040,8 +1063,10 @@ static void update_wall_time(void)
 	 * Store full nanoseconds into xtime after rounding it up and
 	 * add the remainder to the error difference.
 	 */
-	xtime.tv_nsec =	((s64) timekeeper.xtime_nsec >> timekeeper.shift) + 1;
-	timekeeper.xtime_nsec -= (s64) xtime.tv_nsec << timekeeper.shift;
+	timekeeper.xtime.tv_nsec = ((s64)timekeeper.xtime_nsec >>
+						timekeeper.shift) + 1;
+	timekeeper.xtime_nsec -= (s64)timekeeper.xtime.tv_nsec <<
+						timekeeper.shift;
 	timekeeper.ntp_error +=	timekeeper.xtime_nsec <<
 				timekeeper.ntp_error_shift;
 
@@ -1049,15 +1074,17 @@ static void update_wall_time(void)
 	 * Finally, make sure that after the rounding
 	 * xtime.tv_nsec isn't larger then NSEC_PER_SEC
 	 */
-	if (unlikely(xtime.tv_nsec >= NSEC_PER_SEC)) {
-		xtime.tv_nsec -= NSEC_PER_SEC;
-		xtime.tv_sec++;
+	if (unlikely(timekeeper.xtime.tv_nsec >= NSEC_PER_SEC)) {
+		timekeeper.xtime.tv_nsec -= NSEC_PER_SEC;
+		timekeeper.xtime.tv_sec++;
 		second_overflow();
 	}
 
-	/* check to see if there is a new clocksource to use */
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
-				timekeeper.mult);
+	timekeeping_update(false);
+
+out:
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+
 }
 
 /**
@@ -1074,8 +1101,10 @@ static void update_wall_time(void)
 void getboottime(struct timespec *ts)
 {
 	struct timespec boottime = {
-		.tv_sec = wall_to_monotonic.tv_sec + total_sleep_time.tv_sec,
-		.tv_nsec = wall_to_monotonic.tv_nsec + total_sleep_time.tv_nsec
+		.tv_sec = timekeeper.wall_to_monotonic.tv_sec +
+				timekeeper.total_sleep_time.tv_sec,
+		.tv_nsec = timekeeper.wall_to_monotonic.tv_nsec +
+				timekeeper.total_sleep_time.tv_nsec
 	};
 
 	set_normalized_timespec(ts, -boottime.tv_sec, -boottime.tv_nsec);
@@ -1101,13 +1130,13 @@ void get_monotonic_boottime(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
-		*ts = xtime;
-		tomono = wall_to_monotonic;
-		sleep = total_sleep_time;
+		seq = read_seqbegin(&timekeeper.lock);
+		*ts = timekeeper.xtime;
+		tomono = timekeeper.wall_to_monotonic;
+		sleep = timekeeper.total_sleep_time;
 		nsecs = timekeeping_get_ns();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&timekeeper.lock, seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec + sleep.tv_sec,
 			ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec + nsecs);
@@ -1137,19 +1166,19 @@ EXPORT_SYMBOL_GPL(ktime_get_boottime);
  */
 void monotonic_to_bootbased(struct timespec *ts)
 {
-	*ts = timespec_add(*ts, total_sleep_time);
+	*ts = timespec_add(*ts, timekeeper.total_sleep_time);
 }
 EXPORT_SYMBOL_GPL(monotonic_to_bootbased);
 
 unsigned long get_seconds(void)
 {
-	return xtime.tv_sec;
+	return timekeeper.xtime.tv_sec;
 }
 EXPORT_SYMBOL(get_seconds);
 
 struct timespec __current_kernel_time(void)
 {
-	return xtime;
+	return timekeeper.xtime;
 }
 
 struct timespec current_kernel_time(void)
@@ -1158,10 +1187,10 @@ struct timespec current_kernel_time(void)
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqbegin(&timekeeper.lock);
 
-		now = xtime;
-	} while (read_seqretry(&xtime_lock, seq));
+		now = timekeeper.xtime;
+	} while (read_seqretry(&timekeeper.lock, seq));
 
 	return now;
 }
@@ -1173,11 +1202,11 @@ struct timespec get_monotonic_coarse(void)
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqbegin(&timekeeper.lock);
 
-		now = xtime;
-		mono = wall_to_monotonic;
-	} while (read_seqretry(&xtime_lock, seq));
+		now = timekeeper.xtime;
+		mono = timekeeper.wall_to_monotonic;
+	} while (read_seqretry(&timekeeper.lock, seq));
 
 	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
 				now.tv_nsec + mono.tv_nsec);
@@ -1209,11 +1238,11 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
-		*xtim = xtime;
-		*wtom = wall_to_monotonic;
-		*sleep = total_sleep_time;
-	} while (read_seqretry(&xtime_lock, seq));
+		seq = read_seqbegin(&timekeeper.lock);
+		*xtim = timekeeper.xtime;
+		*wtom = timekeeper.wall_to_monotonic;
+		*sleep = timekeeper.total_sleep_time;
+	} while (read_seqretry(&timekeeper.lock, seq));
 }
 
 /**
@@ -1225,9 +1254,10 @@ ktime_t ktime_get_monotonic_offset(void)
 	struct timespec wtom;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
-		wtom = wall_to_monotonic;
-	} while (read_seqretry(&xtime_lock, seq));
+		seq = read_seqbegin(&timekeeper.lock);
+		wtom = timekeeper.wall_to_monotonic;
+	} while (read_seqretry(&timekeeper.lock, seq));
+
 	return timespec_to_ktime(wtom);
 }
 
