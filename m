Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab2GQV77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 17:59:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37367 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140Ab2GQV7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:59:43 -0400
Subject: Patch "timekeeping: Maintain ktime_t based offsets for hrtimers" has been added to the 3.4-stable tree
To: johnstul@us.ibm.com, a.p.zijlstra@chello.nl, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, prarit@redhat.com,
        tglx@linutronix.de
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 17 Jul 2012 14:59:24 -0700
In-Reply-To: <1342507196-54327-4-git-send-email-johnstul@us.ibm.com>
Message-ID: <1342562364520@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    timekeeping: Maintain ktime_t based offsets for hrtimers

to the 3.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     timekeeping-maintain-ktime_t-based-offsets-for-hrtimers.patch
and it can be found in the queue-3.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From johnstul@us.ibm.com  Tue Jul 17 14:23:18 2012
From: John Stultz <johnstul@us.ibm.com>
Date: Tue, 17 Jul 2012 02:39:52 -0400
Subject: timekeeping: Maintain ktime_t based offsets for hrtimers
To: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>, Prarit Bhargava <prarit@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <1342507196-54327-4-git-send-email-johnstul@us.ibm.com>


From: Thomas Gleixner <tglx@linutronix.de>

This is a backport of 5b9fe759a678e05be4937ddf03d50e950207c1c0

We need to update the hrtimer clock offsets from the hrtimer interrupt
context. To avoid conversions from timespec to ktime_t maintain a
ktime_t based representation of those offsets in the timekeeper. This
puts the conversion overhead into the code which updates the
underlying offsets and provides fast accessible values in the hrtimer
interrupt.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1341960205-56738-4-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -70,6 +70,12 @@ struct timekeeper {
 	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
 	struct timespec raw_time;
 
+	/* Offset clock monotonic -> clock realtime */
+	ktime_t offs_real;
+
+	/* Offset clock monotonic -> clock boottime */
+	ktime_t offs_boot;
+
 	/* Seqlock for all timekeeper values */
 	seqlock_t lock;
 };
@@ -172,6 +178,14 @@ static inline s64 timekeeping_get_ns_raw
 	return clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
 }
 
+static void update_rt_offset(void)
+{
+	struct timespec tmp, *wtm = &timekeeper.wall_to_monotonic;
+
+	set_normalized_timespec(&tmp, -wtm->tv_sec, -wtm->tv_nsec);
+	timekeeper.offs_real = timespec_to_ktime(tmp);
+}
+
 /* must hold write on timekeeper.lock */
 static void timekeeping_update(bool clearntp)
 {
@@ -179,6 +193,7 @@ static void timekeeping_update(bool clea
 		timekeeper.ntp_error = 0;
 		ntp_clear();
 	}
+	update_rt_offset();
 	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
 			 timekeeper.clock, timekeeper.mult);
 }
@@ -606,6 +621,7 @@ void __init timekeeping_init(void)
 	}
 	set_normalized_timespec(&timekeeper.wall_to_monotonic,
 				-boot.tv_sec, -boot.tv_nsec);
+	update_rt_offset();
 	timekeeper.total_sleep_time.tv_sec = 0;
 	timekeeper.total_sleep_time.tv_nsec = 0;
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
@@ -614,6 +630,12 @@ void __init timekeeping_init(void)
 /* time in seconds when suspend began */
 static struct timespec timekeeping_suspend_time;
 
+static void update_sleep_time(struct timespec t)
+{
+	timekeeper.total_sleep_time = t;
+	timekeeper.offs_boot = timespec_to_ktime(t);
+}
+
 /**
  * __timekeeping_inject_sleeptime - Internal function to add sleep interval
  * @delta: pointer to a timespec delta value
@@ -632,8 +654,7 @@ static void __timekeeping_inject_sleepti
 	timekeeper.xtime = timespec_add(timekeeper.xtime, *delta);
 	timekeeper.wall_to_monotonic =
 			timespec_sub(timekeeper.wall_to_monotonic, *delta);
-	timekeeper.total_sleep_time = timespec_add(
-					timekeeper.total_sleep_time, *delta);
+	update_sleep_time(timespec_add(timekeeper.total_sleep_time, *delta));
 }
 
 


Patches currently in stable-queue which might be from johnstul@us.ibm.com are

queue-3.4/timekeeping-fix-leapsecond-triggered-load-spike-issue.patch
queue-3.4/hrtimer-update-hrtimer-base-offsets-each-hrtimer_interrupt.patch
queue-3.4/timekeeping-add-missing-update-call-in-timekeeping_resume.patch
queue-3.4/hrtimers-move-lock-held-region-in-hrtimer_interrupt.patch
queue-3.4/hrtimer-provide-clock_was_set_delayed.patch
queue-3.4/timekeeping-provide-hrtimer-update-function.patch
queue-3.4/timekeeping-maintain-ktime_t-based-offsets-for-hrtimers.patch
