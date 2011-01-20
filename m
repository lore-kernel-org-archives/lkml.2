Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab1ATROP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:14:15 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:40050 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752163Ab1ATROO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:14:14 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+V0cF+3jKVmcferlNnuJcV3X2mXErbABeuqUbJtE
	hZQ1/7MLoOWnNK
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Torben Hohn <torbenh@gmx.de>, Thomas Gleixner <tglx@tglx.de>
Subject: [PATCH] RFC: abstract access to xtime_lock into a set of inline functions
Date: Thu, 20 Jan 2011 18:14:08 +0100
Message-Id: <1295543648-13788-1-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the -rt patches change the xtime_lock to a raw_seqlock_t
so a pretty huge portion of the patch deals with changing
the locking functions.

this commit uses inline functions, to hide the type
of the lock.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
CC: Thomas Gleixner <tglx@tglx.de>
---
 arch/alpha/kernel/time.c         |    4 +-
 arch/arm/kernel/time.c           |    4 +-
 arch/blackfin/kernel/time.c      |    4 +-
 arch/cris/arch-v32/kernel/time.c |    4 +-
 arch/frv/kernel/time.c           |    4 +-
 arch/h8300/kernel/time.c         |    4 +-
 arch/ia64/kernel/time.c          |    4 +-
 arch/ia64/xen/time.c             |    4 +-
 arch/m68knommu/kernel/time.c     |    4 +-
 arch/mn10300/kernel/time.c       |    4 +-
 arch/parisc/kernel/time.c        |    4 +-
 arch/sparc/kernel/pcic.c         |    4 +-
 arch/sparc/kernel/time_32.c      |    4 +-
 arch/xtensa/kernel/time.c        |    4 +-
 include/linux/time.h             |   12 +++++++-
 kernel/hrtimer.c                 |    8 +++---
 kernel/time.c                    |    4 +-
 kernel/time/ntp.c                |   16 +++++-----
 kernel/time/tick-common.c        |    8 +++---
 kernel/time/tick-sched.c         |   12 ++++----
 kernel/time/timekeeping.c        |   54 +++++++++++++++++++-------------------
 21 files changed, 90 insertions(+), 80 deletions(-)

diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index c1f3e7c..35acbbd 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -172,7 +172,7 @@ irqreturn_t timer_interrupt(int irq, void *dev)
 	profile_tick(CPU_PROFILING);
 #endif
 
-	write_seqlock(&xtime_lock);
+	xtime_write_seqlock();
 
 	/*
 	 * Calculate how many ticks have passed since the last update,
@@ -189,7 +189,7 @@ irqreturn_t timer_interrupt(int irq, void *dev)
 	if (nticks)
 		do_timer(nticks);
 
-	write_sequnlock(&xtime_lock);
+	xtime_write_sequnlock();
 
 	if (test_irq_work_pending()) {
 		clear_irq_work_pending();
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index 3d76bf2..f9d87a6 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -107,9 +107,9 @@ void timer_tick(void)
 {
 	profile_tick(CPU_PROFILING);
 	do_leds();
-	write_seqlock(&xtime_lock);
+	xtime_write_seqlock();
 	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	xtime_write_sequnlock();
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index c911361..cca6829 100644
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -121,9 +121,9 @@ __attribute__((l1_text))
 #endif
 irqreturn_t timer_interrupt(int irq, void *dummy)
 {
-	write_seqlock(&xtime_lock);
+	xtime_write_seqlock();
 	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	xtime_write_sequnlock();
 
 #ifdef CONFIG_IPIPE
 	update_root_process_times(get_irq_regs());
diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
index a545211..469f2bd 100644
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -216,9 +216,9 @@ static inline irqreturn_t timer_interrupt(int irq, void *dev_id)
 		return IRQ_HANDLED;
 
 	/* Call the real timer interrupt handler */
-	write_seqlock(&xtime_lock);
+	xtime_write_seqlock();
 	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	xtime_write_sequnlock();
         return IRQ_HANDLED;
 }
 
diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
index 0ddbbae..10f5cdc 100644
--- a/arch/frv/kernel/time.c
+++ b/arch/frv/kernel/time.c
@@ -62,7 +62,7 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
 	 * the irq version of write_lock because as just said we have irq
 	 * locally disabled. -arca
 	 */
-	write_seqlock(&xtime_lock);
+	xtime_write_seqlock();
 
 	do_timer(1);
 
@@ -72,7 +72,7 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
 	__set_LEDS(n);
 #endif /* CONFIG_HEARTBEAT */
 
-	write_sequnlock(&xtime_lock);
+	xtime_write_sequnlock();
 
 	update_process_times(user_mode(get_irq_regs()));
 
diff --git a/arch/h8300/kernel/time.c b/arch/h8300/kernel/time.c
index 165005a..7405566 100644
--- a/arch/h8300/kernel/time.c
+++ b/arch/h8300/kernel/time.c
@@ -35,9 +35,9 @@ void h8300_timer_tick(void)
 {
 	if (current->pid)
 		profile_tick(CPU_PROFILING);
-	write_seqlock(&xtime_lock);
+	xtime_write_seqlock();
 	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	xtime_write_sequnlock();
 	update_process_times(user_mode(get_irq_regs()));
 }
 
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 9702fa9..333786e 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -197,10 +197,10 @@ timer_interrupt (int irq, void *dev_id)
 			 * another CPU. We need to avoid to SMP race by acquiring the
 			 * xtime_lock.
 			 */
-			write_seqlock(&xtime_lock);
+			xtime_write_seqlock();
 			do_timer(1);
 			local_cpu_data->itm_next = new_itm;
-			write_sequnlock(&xtime_lock);
+			xtime_write_sequnlock();
 		} else
 			local_cpu_data->itm_next = new_itm;
 
diff --git a/arch/ia64/xen/time.c b/arch/ia64/xen/time.c
index c1c5445..5c46438 100644
--- a/arch/ia64/xen/time.c
+++ b/arch/ia64/xen/time.c
@@ -140,10 +140,10 @@ consider_steal_time(unsigned long new_itm)
 		delta_itm += local_cpu_data->itm_delta * (stolen + blocked);
 
 		if (cpu == time_keeper_id) {
-			write_seqlock(&xtime_lock);
+			xtime_write_seqlock();
 			do_timer(stolen + blocked);
 			local_cpu_data->itm_next = delta_itm + new_itm;
-			write_sequnlock(&xtime_lock);
+			xtime_write_sequnlock();
 		} else {
 			local_cpu_data->itm_next = delta_itm + new_itm;
 		}
diff --git a/arch/m68knommu/kernel/time.c b/arch/m68knommu/kernel/time.c
index d6ac2a4..9b64b9e 100644
--- a/arch/m68knommu/kernel/time.c
+++ b/arch/m68knommu/kernel/time.c
@@ -44,11 +44,11 @@ irqreturn_t arch_timer_interrupt(int irq, void *dummy)
 	if (current->pid)
 		profile_tick(CPU_PROFILING);
 
-	write_seqlock(&xtime_lock);
+	xtime_write_seqlock();
 
 	do_timer(1);
 
-	write_sequnlock(&xtime_lock);
+	xtime_write_sequnlock();
 
 	update_process_times(user_mode(get_irq_regs()));
 
diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
index 75da468..e0c4617 100644
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -104,7 +104,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 	unsigned tsc, elapse;
 	irqreturn_t ret;
 
-	write_seqlock(&xtime_lock);
+	xtime_write_seqlock();
 
 	while (tsc = get_cycles(),
 	       elapse = tsc - mn10300_last_tsc, /* time elapsed since last
@@ -117,7 +117,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 		do_timer(1);
 	}
 
-	write_sequnlock(&xtime_lock);
+	xtime_write_sequnlock();
 
 	ret = local_timer_interrupt();
 #ifdef CONFIG_SMP
diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index 05511cc..2d8e94c 100644
--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -163,9 +163,9 @@ irqreturn_t __irq_entry timer_interrupt(int irq, void *dev_id)
 	}
 
 	if (cpu == 0) {
-		write_seqlock(&xtime_lock);
+		xtime_write_seqlock();
 		do_timer(ticks_elapsed);
-		write_sequnlock(&xtime_lock);
+		xtime_write_sequnlock();
 	}
 
 	return IRQ_HANDLED;
diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
index aeaa09a..0468374 100644
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -700,10 +700,10 @@ static void pcic_clear_clock_irq(void)
 
 static irqreturn_t pcic_timer_handler (int irq, void *h)
 {
-	write_seqlock(&xtime_lock);	/* Dummy, to show that we remember */
+	xtime_write_seqlock();	/* Dummy, to show that we remember */
 	pcic_clear_clock_irq();
 	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	xtime_write_sequnlock();
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
diff --git a/arch/sparc/kernel/time_32.c b/arch/sparc/kernel/time_32.c
index 9c743b1..f3bad3f 100644
--- a/arch/sparc/kernel/time_32.c
+++ b/arch/sparc/kernel/time_32.c
@@ -97,13 +97,13 @@ static irqreturn_t timer_interrupt(int dummy, void *dev_id)
 #endif
 
 	/* Protect counter clear so that do_gettimeoffset works */
-	write_seqlock(&xtime_lock);
+	xtime_write_seqlock();
 
 	clear_clock_irq();
 
 	do_timer(1);
 
-	write_sequnlock(&xtime_lock);
+	xtime_write_sequnlock();
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index 19df764..facc661 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -96,7 +96,7 @@ again:
 		update_process_times(user_mode(get_irq_regs()));
 #endif
 
-		write_seqlock(&xtime_lock);
+		xtime_write_seqlock();
 
 		do_timer(1); /* Linux handler in kernel/timer.c */
 
@@ -105,7 +105,7 @@ again:
 		next += CCOUNT_PER_JIFFY;
 		set_linux_timer(next);
 
-		write_sequnlock(&xtime_lock);
+		xtime_write_sequnlock();
 	}
 
 	/* Allow platform to do something useful (Wdog). */
diff --git a/include/linux/time.h b/include/linux/time.h
index 1e6d3b5..f228b07 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -113,7 +113,17 @@ static inline struct timespec timespec_sub(struct timespec lhs,
 #define timespec_valid(ts) \
 	(((ts)->tv_sec >= 0) && (((unsigned long) (ts)->tv_nsec) < NSEC_PER_SEC))
 
-extern seqlock_t xtime_lock;
+extern seqlock_t __xtime_lock;
+
+static inline void xtime_write_seqlock() { write_seqlock(&__xtime_lock); }
+static inline void xtime_write_sequnlock() { write_sequnlock(&__xtime_lock); }
+static inline void xtime_write_seqlock_irq() { write_seqlock_irq(&__xtime_lock); }
+static inline void xtime_write_sequnlock_irq() { write_sequnlock_irq(&__xtime_lock); }
+#define xtime_write_seqlock_irqsave(flags) write_seqlock_irqsave(&__xtime_lock,flags);
+#define xtime_write_sequnlock_irqrestore(flags) write_sequnlock_irqrestore(&__xtime_lock,flags);
+
+static __always_inline unsigned xtime_read_seqbegin() { return read_seqbegin(&__xtime_lock); }
+static __always_inline int xtime_read_seqretry(unsigned seq) { return read_seqretry(&__xtime_lock,seq); }
 
 extern void read_persistent_clock(struct timespec *ts);
 extern void read_boot_clock(struct timespec *ts);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0c8d7c0..490938b 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -88,10 +88,10 @@ static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = xtime_read_seqbegin();
 		xts = __current_kernel_time();
 		tom = __get_wall_to_monotonic();
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (xtime_read_seqretry(seq));
 
 	xtim = timespec_to_ktime(xts);
 	tomono = timespec_to_ktime(tom);
@@ -618,9 +618,9 @@ static void retrigger_next_event(void *arg)
 		return;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = xtime_read_seqbegin();
 		wtm = __get_wall_to_monotonic();
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (xtime_read_seqretry(seq));
 	set_normalized_timespec(&realtime_offset, -wtm.tv_sec, -wtm.tv_nsec);
 
 	base = &__get_cpu_var(hrtimer_bases);
diff --git a/kernel/time.c b/kernel/time.c
index 3217435..600756b 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -681,9 +681,9 @@ u64 get_jiffies_64(void)
 	u64 ret;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = xtime_read_seqbegin();
 		ret = jiffies_64;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (xtime_read_seqretry(seq));
 	return ret;
 }
 EXPORT_SYMBOL(get_jiffies_64);
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 5c00242..0d99803 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -356,7 +356,7 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 {
 	enum hrtimer_restart res = HRTIMER_NORESTART;
 
-	write_seqlock(&xtime_lock);
+	xtime_write_seqlock();
 
 	switch (time_state) {
 	case TIME_OK:
@@ -386,7 +386,7 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 		break;
 	}
 
-	write_sequnlock(&xtime_lock);
+	xtime_write_sequnlock();
 
 	return res;
 }
@@ -648,7 +648,7 @@ int do_adjtimex(struct timex *txc)
 
 	getnstimeofday(&ts);
 
-	write_seqlock_irq(&xtime_lock);
+	xtime_write_seqlock_irq();
 
 	if (txc->modes & ADJ_ADJTIME) {
 		long save_adjust = time_adjust;
@@ -690,7 +690,7 @@ int do_adjtimex(struct timex *txc)
 	/* fill PPS status fields */
 	pps_fill_timex(txc);
 
-	write_sequnlock_irq(&xtime_lock);
+	xtime_write_sequnlock_irq();
 
 	txc->time.tv_sec = ts.tv_sec;
 	txc->time.tv_usec = ts.tv_nsec;
@@ -888,7 +888,7 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 	pts_norm = pps_normalize_ts(*phase_ts);
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	xtime_write_seqlock_irqsave(flags);
 
 	/* clear the error bits, they will be set again if needed */
 	time_status &= ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
@@ -901,7 +901,7 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 	 * just start the frequency interval */
 	if (unlikely(pps_fbase.tv_sec == 0)) {
 		pps_fbase = *raw_ts;
-		write_sequnlock_irqrestore(&xtime_lock, flags);
+		xtime_write_sequnlock_irqrestore(flags);
 		return;
 	}
 
@@ -916,7 +916,7 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 		time_status |= STA_PPSJITTER;
 		/* restart the frequency calibration interval */
 		pps_fbase = *raw_ts;
-		write_sequnlock_irqrestore(&xtime_lock, flags);
+		xtime_write_sequnlock_irqrestore(flags);
 		pr_err("hardpps: PPSJITTER: bad pulse\n");
 		return;
 	}
@@ -933,7 +933,7 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 	hardpps_update_phase(pts_norm.nsec);
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	xtime_write_sequnlock_irqrestore(flags);
 }
 EXPORT_SYMBOL(hardpps);
 
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 051bc80..21624d7 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -60,13 +60,13 @@ int tick_is_oneshot_available(void)
 static void tick_periodic(int cpu)
 {
 	if (tick_do_timer_cpu == cpu) {
-		write_seqlock(&xtime_lock);
+		xtime_write_seqlock();
 
 		/* Keep track of the next tick event */
 		tick_next_period = ktime_add(tick_next_period, tick_period);
 
 		do_timer(1);
-		write_sequnlock(&xtime_lock);
+		xtime_write_sequnlock();
 	}
 
 	update_process_times(user_mode(get_irq_regs()));
@@ -127,9 +127,9 @@ void tick_setup_periodic(struct clock_event_device *dev, int broadcast)
 		ktime_t next;
 
 		do {
-			seq = read_seqbegin(&xtime_lock);
+			seq = xtime_read_seqbegin();
 			next = tick_next_period;
-		} while (read_seqretry(&xtime_lock, seq));
+		} while (xtime_read_seqretry(seq));
 
 		clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3e216e0..2fa2241 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -57,7 +57,7 @@ static void tick_do_update_jiffies64(ktime_t now)
 		return;
 
 	/* Reevalute with xtime_lock held */
-	write_seqlock(&xtime_lock);
+	xtime_write_seqlock();
 
 	delta = ktime_sub(now, last_jiffies_update);
 	if (delta.tv64 >= tick_period.tv64) {
@@ -80,7 +80,7 @@ static void tick_do_update_jiffies64(ktime_t now)
 		/* Keep the tick_next_period variable up to date */
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
 	}
-	write_sequnlock(&xtime_lock);
+	xtime_write_sequnlock();
 }
 
 /*
@@ -90,12 +90,12 @@ static ktime_t tick_init_jiffy_update(void)
 {
 	ktime_t period;
 
-	write_seqlock(&xtime_lock);
+	xtime_write_seqlock();
 	/* Did we start the jiffies update yet ? */
 	if (last_jiffies_update.tv64 == 0)
 		last_jiffies_update = tick_next_period;
 	period = last_jiffies_update;
-	write_sequnlock(&xtime_lock);
+	xtime_write_sequnlock();
 	return period;
 }
 
@@ -318,11 +318,11 @@ void tick_nohz_stop_sched_tick(int inidle)
 	ts->idle_calls++;
 	/* Read jiffies and the time when jiffies were updated last */
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = xtime_read_seqbegin();
 		last_update = last_jiffies_update;
 		last_jiffies = jiffies;
 		time_delta = timekeeping_max_deferment();
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (xtime_read_seqretry(seq));
 
 	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
 	    arch_needs_cpu(cpu)) {
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index d27c756..392b38c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -139,7 +139,7 @@ static inline s64 timekeeping_get_ns_raw(void)
  * This read-write spinlock protects us from races in SMP while
  * playing with xtime.
  */
-__cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
+__cacheline_aligned_in_smp DEFINE_SEQLOCK(__xtime_lock);
 
 
 /*
@@ -222,7 +222,7 @@ void getnstimeofday(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = xtime_read_seqbegin();
 
 		*ts = xtime;
 		nsecs = timekeeping_get_ns();
@@ -230,7 +230,7 @@ void getnstimeofday(struct timespec *ts)
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (xtime_read_seqretry(seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -245,12 +245,12 @@ ktime_t ktime_get(void)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = xtime_read_seqbegin();
 		secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
 		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
 		nsecs += timekeeping_get_ns();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (xtime_read_seqretry(seq));
 	/*
 	 * Use ktime_set/ktime_add_ns to create a proper ktime on
 	 * 32-bit architectures without CONFIG_KTIME_SCALAR.
@@ -276,12 +276,12 @@ void ktime_get_ts(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = xtime_read_seqbegin();
 		*ts = xtime;
 		tomono = wall_to_monotonic;
 		nsecs = timekeeping_get_ns();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (xtime_read_seqretry(seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
 				ts->tv_nsec + tomono.tv_nsec + nsecs);
@@ -309,7 +309,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 	do {
 		u32 arch_offset;
 
-		seq = read_seqbegin(&xtime_lock);
+		seq = xtime_read_seqbegin();
 
 		*ts_raw = raw_time;
 		*ts_real = xtime;
@@ -322,7 +322,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 		nsecs_raw += arch_offset;
 		nsecs_real += arch_offset;
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (xtime_read_seqretry(seq));
 
 	timespec_add_ns(ts_raw, nsecs_raw);
 	timespec_add_ns(ts_real, nsecs_real);
@@ -361,7 +361,7 @@ int do_settimeofday(struct timespec *tv)
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	xtime_write_seqlock_irqsave(flags);
 
 	timekeeping_forward_now();
 
@@ -377,7 +377,7 @@ int do_settimeofday(struct timespec *tv)
 	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
 				timekeeper.mult);
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	xtime_write_sequnlock_irqrestore(flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -450,11 +450,11 @@ void getrawmonotonic(struct timespec *ts)
 	s64 nsecs;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = xtime_read_seqbegin();
 		nsecs = timekeeping_get_ns_raw();
 		*ts = raw_time;
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (xtime_read_seqretry(seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -470,11 +470,11 @@ int timekeeping_valid_for_hres(void)
 	int ret;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = xtime_read_seqbegin();
 
 		ret = timekeeper.clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (xtime_read_seqretry(seq));
 
 	return ret;
 }
@@ -482,8 +482,8 @@ int timekeeping_valid_for_hres(void)
 /**
  * timekeeping_max_deferment - Returns max time the clocksource can be deferred
  *
- * Caller must observe xtime_lock via read_seqbegin/read_seqretry to
- * ensure that the clocksource does not change!
+ * Caller must observe xtime_lock via xtime_read_seqbegin/xtime_read_seqretry
+ * to ensure that the clocksource does not change!
  */
 u64 timekeeping_max_deferment(void)
 {
@@ -532,7 +532,7 @@ void __init timekeeping_init(void)
 	read_persistent_clock(&now);
 	read_boot_clock(&boot);
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	xtime_write_seqlock_irqsave(flags);
 
 	ntp_init();
 
@@ -553,7 +553,7 @@ void __init timekeeping_init(void)
 				-boot.tv_sec, -boot.tv_nsec);
 	total_sleep_time.tv_sec = 0;
 	total_sleep_time.tv_nsec = 0;
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	xtime_write_sequnlock_irqrestore(flags);
 }
 
 /* time in seconds when suspend began */
@@ -576,7 +576,7 @@ static int timekeeping_resume(struct sys_device *dev)
 
 	clocksource_resume();
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	xtime_write_seqlock_irqsave(flags);
 
 	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
 		ts = timespec_sub(ts, timekeeping_suspend_time);
@@ -588,7 +588,7 @@ static int timekeeping_resume(struct sys_device *dev)
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
 	timekeeper.ntp_error = 0;
 	timekeeping_suspended = 0;
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	xtime_write_sequnlock_irqrestore(flags);
 
 	touch_softlockup_watchdog();
 
@@ -606,10 +606,10 @@ static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
 
 	read_persistent_clock(&timekeeping_suspend_time);
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	xtime_write_seqlock_irqsave(flags);
 	timekeeping_forward_now();
 	timekeeping_suspended = 1;
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	xtime_write_sequnlock_irqrestore(flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 	clocksource_suspend();
@@ -921,10 +921,10 @@ struct timespec current_kernel_time(void)
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = xtime_read_seqbegin();
 
 		now = xtime;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (xtime_read_seqretry(seq));
 
 	return now;
 }
@@ -936,11 +936,11 @@ struct timespec get_monotonic_coarse(void)
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = xtime_read_seqbegin();
 
 		now = xtime;
 		mono = wall_to_monotonic;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (xtime_read_seqretry(seq));
 
 	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
 				now.tv_nsec + mono.tv_nsec);
-- 
1.7.2.3

