Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab0CZPe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 11:34:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46621 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab0CZPe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 11:34:56 -0400
Date: Fri, 26 Mar 2010 16:34:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fixes
Message-ID: <20100326153423.GA4044@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Andrew Morton (1):
      timer stats: Fix del_timer_sync() and try_to_del_timer_sync()

John Stultz (1):
      time: Fix accumulation bug triggered by long delay.

Stanislaw Gruszka (1):
      posix-cpu-timers: Reset expire cache when no timer is running

Thomas Gleixner (1):
      clockevents: Sanitize min_delta_ns adjustment and prevent overflows


 include/linux/clockchips.h |    2 +
 kernel/posix-cpu-timers.c  |   10 ++++++--
 kernel/time/tick-oneshot.c |   52 +++++++++++++++++++++++++++++++++----------
 kernel/time/timekeeping.c  |    3 +-
 kernel/time/timer_list.c   |    3 +-
 kernel/timer.c             |    1 +
 6 files changed, 54 insertions(+), 17 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 0cf725b..fc53492 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -73,6 +73,7 @@ enum clock_event_nofitiers {
  * @list:		list head for the management code
  * @mode:		operating mode assigned by the management code
  * @next_event:		local storage for the next event in oneshot mode
+ * @retries:		number of forced programming retries
  */
 struct clock_event_device {
 	const char		*name;
@@ -93,6 +94,7 @@ struct clock_event_device {
 	struct list_head	list;
 	enum clock_event_mode	mode;
 	ktime_t			next_event;
+	unsigned long		retries;
 };
 
 /*
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 438ff45..edec25a 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1060,9 +1060,9 @@ static void check_thread_timers(struct task_struct *tsk,
 	}
 }
 
-static void stop_process_timers(struct task_struct *tsk)
+static void stop_process_timers(struct signal_struct *sig)
 {
-	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
+	struct thread_group_cputimer *cputimer = &sig->cputimer;
 	unsigned long flags;
 
 	if (!cputimer->running)
@@ -1071,6 +1071,10 @@ static void stop_process_timers(struct task_struct *tsk)
 	spin_lock_irqsave(&cputimer->lock, flags);
 	cputimer->running = 0;
 	spin_unlock_irqrestore(&cputimer->lock, flags);
+
+	sig->cputime_expires.prof_exp = cputime_zero;
+	sig->cputime_expires.virt_exp = cputime_zero;
+	sig->cputime_expires.sched_exp = 0;
 }
 
 static u32 onecputick;
@@ -1131,7 +1135,7 @@ static void check_process_timers(struct task_struct *tsk,
 	    list_empty(&timers[CPUCLOCK_VIRT]) &&
 	    cputime_eq(sig->it[CPUCLOCK_VIRT].expires, cputime_zero) &&
 	    list_empty(&timers[CPUCLOCK_SCHED])) {
-		stop_process_timers(tsk);
+		stop_process_timers(sig);
 		return;
 	}
 
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 0a8a213..aada0e5 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -22,6 +22,29 @@
 
 #include "tick-internal.h"
 
+/* Limit min_delta to a jiffie */
+#define MIN_DELTA_LIMIT		(NSEC_PER_SEC / HZ)
+
+static int tick_increase_min_delta(struct clock_event_device *dev)
+{
+	/* Nothing to do if we already reached the limit */
+	if (dev->min_delta_ns >= MIN_DELTA_LIMIT)
+		return -ETIME;
+
+	if (dev->min_delta_ns < 5000)
+		dev->min_delta_ns = 5000;
+	else
+		dev->min_delta_ns += dev->min_delta_ns >> 1;
+
+	if (dev->min_delta_ns > MIN_DELTA_LIMIT)
+		dev->min_delta_ns = MIN_DELTA_LIMIT;
+
+	printk(KERN_WARNING "CE: %s increased min_delta_ns to %llu nsec\n",
+	       dev->name ? dev->name : "?",
+	       (unsigned long long) dev->min_delta_ns);
+	return 0;
+}
+
 /**
  * tick_program_event internal worker function
  */
@@ -37,23 +60,28 @@ int tick_dev_program_event(struct clock_event_device *dev, ktime_t expires,
 		if (!ret || !force)
 			return ret;
 
+		dev->retries++;
 		/*
-		 * We tried 2 times to program the device with the given
-		 * min_delta_ns. If that's not working then we double it
+		 * We tried 3 times to program the device with the given
+		 * min_delta_ns. If that's not working then we increase it
 		 * and emit a warning.
 		 */
 		if (++i > 2) {
 			/* Increase the min. delta and try again */
-			if (!dev->min_delta_ns)
-				dev->min_delta_ns = 5000;
-			else
-				dev->min_delta_ns += dev->min_delta_ns >> 1;
-
-			printk(KERN_WARNING
-			       "CE: %s increasing min_delta_ns to %llu nsec\n",
-			       dev->name ? dev->name : "?",
-			       (unsigned long long) dev->min_delta_ns << 1);
-
+			if (tick_increase_min_delta(dev)) {
+				/*
+				 * Get out of the loop if min_delta_ns
+				 * hit the limit already. That's
+				 * better than staying here forever.
+				 *
+				 * We clear next_event so we have a
+				 * chance that the box survives.
+				 */
+				printk(KERN_WARNING
+				       "CE: Reprogramming failure. Giving up\n");
+				dev->next_event.tv64 = KTIME_MAX;
+				return -ETIME;
+			}
 			i = 0;
 		}
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 1673637..39f6177 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -818,7 +818,8 @@ void update_wall_time(void)
 	shift = min(shift, maxshift);
 	while (offset >= timekeeper.cycle_interval) {
 		offset = logarithmic_accumulation(offset, shift);
-		shift--;
+		if(offset < timekeeper.cycle_interval<<shift)
+			shift--;
 	}
 
 	/* correct the clock when NTP error is too big */
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index bdfb8dd..1a4a7dd 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -228,6 +228,7 @@ print_tickdevice(struct seq_file *m, struct tick_device *td, int cpu)
 	SEQ_printf(m, " event_handler:  ");
 	print_name_offset(m, dev->event_handler);
 	SEQ_printf(m, "\n");
+	SEQ_printf(m, " retries:        %lu\n", dev->retries);
 }
 
 static void timer_list_show_tickdevices(struct seq_file *m)
@@ -257,7 +258,7 @@ static int timer_list_show(struct seq_file *m, void *v)
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Timer List Version: v0.5\n");
+	SEQ_printf(m, "Timer List Version: v0.6\n");
 	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
 	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
 
diff --git a/kernel/timer.c b/kernel/timer.c
index c61a794..fc965ea 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -880,6 +880,7 @@ int try_to_del_timer_sync(struct timer_list *timer)
 	if (base->running_timer == timer)
 		goto out;
 
+	timer_stats_timer_clear_start_info(timer);
 	ret = 0;
 	if (timer_pending(timer)) {
 		detach_timer(timer, 1);
