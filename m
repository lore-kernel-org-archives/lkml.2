Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab1KXDyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 22:54:45 -0500
Received: from ozlabs.org ([203.10.76.45]:44855 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab1KXDyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 22:54:43 -0500
Date: Thu, 24 Nov 2011 14:54:41 +1100
From: Anton Blanchard <anton@samba.org>
To: Don Zickus <dzickus@redhat.com>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] watchdog: Softlockup has regular windows where it is
 not armed
Message-ID: <20111124145441.13d715bb@kryten>
In-Reply-To: <20111124145315.5d0c4686@kryten>
References: <20111124145315.5d0c4686@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
---

There might be a reason for this two stage sync but I haven't been
able to find it yet. Perhaps the unsynced versions of cpu_clock() and
sched_clock_tick() are not safe to call from all contexts?

Index: linux-build/kernel/watchdog.c
===================================================================
--- linux-build.orig/kernel/watchdog.c	2011-11-16 08:04:56.274478516 +1100
+++ linux-build/kernel/watchdog.c	2011-11-16 08:04:59.278533261 +1100
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
@@ -258,19 +257,6 @@ static enum hrtimer_restart watchdog_tim
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
