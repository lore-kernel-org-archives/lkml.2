Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab0HEWQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:16:52 -0400
Received: from www.tglx.de ([62.245.132.106]:48236 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab0HEWQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:16:49 -0400
Date: Fri, 6 Aug 2010 00:16:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timers core for 2.6.36
Message-ID: <alpine.LFD.2.00.1008060013210.3225@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus

It contains a revert because an updated version of the patch surfaced
after a discussion with akpm and I did not want to rebase everything.

Thanks,

	tglx

------------------>
Andrey Vagin (1):
      posix_timer: Move copy_to_user(created_timer_id) down in timer_create()

Arjan van de Ven (1):
      clockevents: Remove the per cpu tick skew

J. Bruce Fields (1):
      timers: Document meaning of deferrable timer

Patrick Pannuto (3):
      timer: Added usleep[_range] timer
      timer: Added usleep_range timer
      Documentation: Add timers/timers-howto.txt

Thomas Gleixner (1):
      Revert "timer: Added usleep[_range] timer"


 Documentation/timers/timers-howto.txt |  105 +++++++++++++++++++++++++++++++++
 include/linux/delay.h                 |    1 +
 kernel/posix-timers.c                 |   11 ++--
 kernel/time/tick-sched.c              |    5 --
 kernel/timer.c                        |   31 +++++++++-
 5 files changed, 141 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/timers/timers-howto.txt

diff --git a/Documentation/timers/timers-howto.txt b/Documentation/timers/timers-howto.txt
new file mode 100644
index 0000000..c9ef29d
--- /dev/null
+++ b/Documentation/timers/timers-howto.txt
@@ -0,0 +1,105 @@
+delays - Information on the various kernel delay / sleep mechanisms
+-------------------------------------------------------------------
+
+This document seeks to answer the common question: "What is the
+RightWay (TM) to insert a delay?"
+
+This question is most often faced by driver writers who have to
+deal with hardware delays and who may not be the most intimately
+familiar with the inner workings of the Linux Kernel.
+
+
+Inserting Delays
+----------------
+
+The first, and most important, question you need to ask is "Is my
+code in an atomic context?"  This should be followed closely by "Does
+it really need to delay in atomic context?" If so...
+
+ATOMIC CONTEXT:
+	You must use the *delay family of functions. These
+	functions use the jiffie estimation of clock speed
+	and will busy wait for enough loop cycles to achieve
+	the desired delay:
+
+	ndelay(unsigned long nsecs)
+	udelay(unsigned long usecs)
+	mdelay(unsgined long msecs)
+
+	udelay is the generally preferred API; ndelay-level
+	precision may not actually exist on many non-PC devices.
+
+	mdelay is macro wrapper around udelay, to account for
+	possible overflow when passing large arguments to udelay.
+	In general, use of mdelay is discouraged and code should
+	be refactored to allow for the use of msleep.
+
+NON-ATOMIC CONTEXT:
+	You should use the *sleep[_range] family of functions.
+	There are a few more options here, while any of them may
+	work correctly, using the "right" sleep function will
+	help the scheduler, power management, and just make your
+	driver better :)
+
+	-- Backed by busy-wait loop:
+		udelay(unsigned long usecs)
+	-- Backed by hrtimers:
+		usleep_range(unsigned long min, unsigned long max)
+	-- Backed by jiffies / legacy_timers
+		msleep(unsigned long msecs)
+		msleep_interruptible(unsigned long msecs)
+
+	Unlike the *delay family, the underlying mechanism
+	driving each of these calls varies, thus there are
+	quirks you should be aware of.
+
+
+	SLEEPING FOR "A FEW" USECS ( < ~10us? ):
+		* Use udelay
+
+		- Why not usleep?
+			On slower systems, (embedded, OR perhaps a speed-
+			stepped PC!) the overhead of setting up the hrtimers
+			for usleep *may* not be worth it. Such an evaluation
+			will obviously depend on your specific situation, but
+			it is something to be aware of.
+
+	SLEEPING FOR ~USECS OR SMALL MSECS ( 10us - 20ms):
+		* Use usleep_range
+
+		- Why not msleep for (1ms - 20ms)?
+			Explained originally here:
+				http://lkml.org/lkml/2007/8/3/250
+			msleep(1~20) may not do what the caller intends, and
+			will often sleep longer (~20 ms actual sleep for any
+			value given in the 1~20ms range). In many cases this
+			is not the desired behavior.
+
+		- Why is there no "usleep" / What is a good range?
+			Since usleep_range is built on top of hrtimers, the
+			wakeup will be very precise (ish), thus a simple
+			usleep function would likely introduce a large number
+			of undesired interrupts.
+
+			With the introduction of a range, the scheduler is
+			free to coalesce your wakeup with any other wakeup
+			that may have happened for other reasons, or at the
+			worst case, fire an interrupt for your upper bound.
+
+			The larger a range you supply, the greater a chance
+			that you will not trigger an interrupt; this should
+			be balanced with what is an acceptable upper bound on
+			delay / performance for your specific code path. Exact
+			tolerances here are very situation specific, thus it
+			is left to the caller to determine a reasonable range.
+
+	SLEEPING FOR LARGER MSECS ( 10ms+ )
+		* Use msleep or possibly msleep_interruptible
+
+		- What's the difference?
+			msleep sets the current task to TASK_UNINTERRUPTIBLE
+			whereas msleep_interruptible sets the current task to
+			TASK_INTERRUPTIBLE before scheduling the sleep. In
+			short, the difference is whether the sleep can be ended
+			early by a signal. In general, just use msleep unless
+			you know you have a need for the interruptible variant.
diff --git a/include/linux/delay.h b/include/linux/delay.h
index fd832c6..a6ecb34 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -45,6 +45,7 @@ extern unsigned long lpj_fine;
 void calibrate_delay(void);
 void msleep(unsigned int msecs);
 unsigned long msleep_interruptible(unsigned int msecs);
+void usleep_range(unsigned long min, unsigned long max);
 
 static inline void ssleep(unsigned int seconds)
 {
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index ad72342..9ca4973 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -560,11 +560,6 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	new_timer->it_clock = which_clock;
 	new_timer->it_overrun = -1;
 
-	if (copy_to_user(created_timer_id,
-			 &new_timer_id, sizeof (new_timer_id))) {
-		error = -EFAULT;
-		goto out;
-	}
 	if (timer_event_spec) {
 		if (copy_from_user(&event, timer_event_spec, sizeof (event))) {
 			error = -EFAULT;
@@ -590,6 +585,12 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	new_timer->sigq->info.si_tid   = new_timer->it_id;
 	new_timer->sigq->info.si_code  = SI_TIMER;
 
+	if (copy_to_user(created_timer_id,
+			 &new_timer_id, sizeof (new_timer_id))) {
+		error = -EFAULT;
+		goto out;
+	}
+
 	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
 	if (error)
 		goto out;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 813993b..74644cc 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -780,7 +780,6 @@ void tick_setup_sched_timer(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t now = ktime_get();
-	u64 offset;
 
 	/*
 	 * Emulate tick processing via per-CPU hrtimers:
@@ -790,10 +789,6 @@ void tick_setup_sched_timer(void)
 
 	/* Get the next period (per cpu) */
 	hrtimer_set_expires(&ts->sched_timer, tick_init_jiffy_update());
-	offset = ktime_to_ns(tick_period) >> 1;
-	do_div(offset, num_possible_cpus());
-	offset *= smp_processor_id();
-	hrtimer_add_expires_ns(&ts->sched_timer, offset);
 
 	for (;;) {
 		hrtimer_forward(&ts->sched_timer, now, tick_period);
diff --git a/kernel/timer.c b/kernel/timer.c
index ee305c8..723a62e 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -90,8 +90,13 @@ static DEFINE_PER_CPU(struct tvec_base *, tvec_bases) = &boot_tvec_bases;
 
 /*
  * Note that all tvec_bases are 2 byte aligned and lower bit of
- * base in timer_list is guaranteed to be zero. Use the LSB for
- * the new flag to indicate whether the timer is deferrable
+ * base in timer_list is guaranteed to be zero. Use the LSB to
+ * indicate whether the timer is deferrable.
+ *
+ * A deferrable timer will work normally when the system is busy, but
+ * will not cause a CPU to come out of idle just to service it; instead,
+ * the timer will be serviced when the CPU eventually wakes up with a
+ * subsequent non-deferrable timer.
  */
 #define TBASE_DEFERRABLE_FLAG		(0x1)
 
@@ -1750,3 +1755,25 @@ unsigned long msleep_interruptible(unsigned int msecs)
 }
 
 EXPORT_SYMBOL(msleep_interruptible);
+
+static int __sched do_usleep_range(unsigned long min, unsigned long max)
+{
+	ktime_t kmin;
+	unsigned long delta;
+
+	kmin = ktime_set(0, min * NSEC_PER_USEC);
+	delta = (max - min) * NSEC_PER_USEC;
+	return schedule_hrtimeout_range(&kmin, delta, HRTIMER_MODE_REL);
+}
+
+/**
+ * usleep_range - Drop in replacement for udelay where wakeup is flexible
+ * @min: Minimum time in usecs to sleep
+ * @max: Maximum time in usecs to sleep
+ */
+void usleep_range(unsigned long min, unsigned long max)
+{
+	__set_current_state(TASK_UNINTERRUPTIBLE);
+	do_usleep_range(min, max);
+}
+EXPORT_SYMBOL(usleep_range);
