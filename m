Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab1LUVS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:18:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab1LUVS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:18:28 -0500
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        avi@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        tglx@linutronix.de, Anton Blanchard <anton@samba.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 4/5] watchdog: Softlockup has regular windows where it is not armed
Date: Wed, 21 Dec 2011 16:17:44 -0500
Message-Id: <1324502265-24521-5-git-send-email-dzickus@redhat.com>
In-Reply-To: <1324502265-24521-1-git-send-email-dzickus@redhat.com>
References: <1324502265-24521-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

The softlockup watchdog has a two stage sync - touch_softlockup_watchdog
simply sets the timestamp to 0 and later on the timer routine notices
this and sets the timestamp.

The problem is this timer goes off every 4 seconds by default, so
each time we call touch_softlockup_watchdog there is a period
of up to 4 seconds where the softlockup watchdog is not armed.

We call touch_softlockup_watchdog very often in the NO_HZ code and
end up hitting this issue every time we go in and out of idle.

I wrote a simple test case:

http://ozlabs.org/~anton/junkcode/badguy.tar.gz

That disables interrupts on selected CPUs for a period of time. Don't
run it on a machine you care about. When I disable interrupts for 30
seconds on a previously idle CPU I get no warning:

insmod ./badguy.ko timeout=30 cpus=4

However if I keep the CPU busy so we don't switch in and out of NO_HZ
mode I get a warning as expected:

taskset -c 4 yes > /dev/null &
insmod ./badguy.ko timeout=30 cpus=4

With the following patch I get a warning even on a previously idle
CPU.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   22 ++++------------------
 1 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index d63975f..4d242f5 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -33,7 +33,6 @@ int __read_mostly watchdog_thresh = 10;
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
 static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
 static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
-static DEFINE_PER_CPU(bool, softlockup_touch_sync);
 static DEFINE_PER_CPU(bool, soft_watchdog_warn);
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 static DEFINE_PER_CPU(bool, hard_watchdog_warn);
@@ -134,7 +133,7 @@ static void __touch_watchdog(void)
 
 void touch_softlockup_watchdog(void)
 {
-	__this_cpu_write(watchdog_touch_ts, 0);
+	__touch_watchdog();
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -157,8 +156,8 @@ EXPORT_SYMBOL(touch_nmi_watchdog);
 
 void touch_softlockup_watchdog_sync(void)
 {
-	__raw_get_cpu_var(softlockup_touch_sync) = true;
-	__raw_get_cpu_var(watchdog_touch_ts) = 0;
+	sched_clock_tick();
+	__touch_watchdog();
 }
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
@@ -258,19 +257,6 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	/* .. and repeat */
 	hrtimer_forward_now(hrtimer, ns_to_ktime(get_sample_period()));
 
-	if (touch_ts == 0) {
-		if (unlikely(__this_cpu_read(softlockup_touch_sync))) {
-			/*
-			 * If the time stamp was touched atomically
-			 * make sure the scheduler tick is up to date.
-			 */
-			__this_cpu_write(softlockup_touch_sync, false);
-			sched_clock_tick();
-		}
-		__touch_watchdog();
-		return HRTIMER_RESTART;
-	}
-
 	/* check for a softlockup
 	 * This is done by making sure a high priority task is
 	 * being scheduled.  The task touches the watchdog to
@@ -438,7 +424,7 @@ static int watchdog_enable(int cpu)
 			goto out;
 		}
 		kthread_bind(p, cpu);
-		per_cpu(watchdog_touch_ts, cpu) = 0;
+		__touch_watchdog();
 		per_cpu(softlockup_watchdog, cpu) = p;
 		wake_up_process(p);
 	}
-- 
1.7.7.4

