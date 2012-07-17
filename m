Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab2GQWue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:50:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59255 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757426Ab2GQWu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:50:28 -0400
Subject: Patch "timekeeping: Maintain ktime_t based offsets for hrtimers" has been added to the 3.0-stable tree
To: johnstul@us.ibm.com, a.p.zijlstra@chello.nl, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, prarit@redhat.com,
        tglx@linutronix.de
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 17 Jul 2012 15:49:59 -0700
In-Reply-To: <1342546438-17534-8-git-send-email-johnstul@us.ibm.com>
Message-ID: <1342565399416@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    timekeeping: Maintain ktime_t based offsets for hrtimers

to the 3.0-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     timekeeping-maintain-ktime_t-based-offsets-for-hrtimers.patch
and it can be found in the queue-3.0 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From johnstul@us.ibm.com  Tue Jul 17 15:26:11 2012
From: John Stultz <johnstul@us.ibm.com>
Date: Tue, 17 Jul 2012 13:33:54 -0400
Subject: timekeeping: Maintain ktime_t based offsets for hrtimers
To: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>, Prarit Bhargava <prarit@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <1342546438-17534-8-git-send-email-johnstul@us.ibm.com>


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
 kernel/time/timekeeping.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -161,18 +161,34 @@ static struct timespec xtime __attribute
 static struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
 static struct timespec total_sleep_time;
 
+/* Offset clock monotonic -> clock realtime */
+static ktime_t offs_real;
+
+/* Offset clock monotonic -> clock boottime */
+static ktime_t offs_boot;
+
 /*
  * The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock.
  */
 static struct timespec raw_time;
 
 /* must hold write on xtime_lock */
+static void update_rt_offset(void)
+{
+	struct timespec tmp, *wtm = &wall_to_monotonic;
+
+	set_normalized_timespec(&tmp, -wtm->tv_sec, -wtm->tv_nsec);
+	offs_real = timespec_to_ktime(tmp);
+}
+
+/* must hold write on xtime_lock */
 static void timekeeping_update(bool clearntp)
 {
 	if (clearntp) {
 		timekeeper.ntp_error = 0;
 		ntp_clear();
 	}
+	update_rt_offset();
 	update_vsyscall(&xtime, &wall_to_monotonic,
 			 timekeeper.clock, timekeeper.mult);
 }
@@ -587,6 +603,7 @@ void __init timekeeping_init(void)
 	}
 	set_normalized_timespec(&wall_to_monotonic,
 				-boot.tv_sec, -boot.tv_nsec);
+	update_rt_offset();
 	total_sleep_time.tv_sec = 0;
 	total_sleep_time.tv_nsec = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
@@ -595,6 +612,12 @@ void __init timekeeping_init(void)
 /* time in seconds when suspend began */
 static struct timespec timekeeping_suspend_time;
 
+static void update_sleep_time(struct timespec t)
+{
+	total_sleep_time = t;
+	offs_boot = timespec_to_ktime(t);
+}
+
 /**
  * __timekeeping_inject_sleeptime - Internal function to add sleep interval
  * @delta: pointer to a timespec delta value
@@ -606,7 +629,7 @@ static void __timekeeping_inject_sleepti
 {
 	xtime = timespec_add(xtime, *delta);
 	wall_to_monotonic = timespec_sub(wall_to_monotonic, *delta);
-	total_sleep_time = timespec_add(total_sleep_time, *delta);
+	update_sleep_time(timespec_add(total_sleep_time, *delta));
 }
 
 


Patches currently in stable-queue which might be from johnstul@us.ibm.com are

queue-3.0/timekeeping-fix-leapsecond-triggered-load-spike-issue.patch
queue-3.0/time-move-common-updates-to-a-function.patch
queue-3.0/timekeeping-fix-clock_monotonic-inconsistency-during-leapsecond.patch
queue-3.0/hrtimer-update-hrtimer-base-offsets-each-hrtimer_interrupt.patch
queue-3.0/timekeeping-add-missing-update-call-in-timekeeping_resume.patch
queue-3.0/hrtimers-move-lock-held-region-in-hrtimer_interrupt.patch
queue-3.0/hrtimer-provide-clock_was_set_delayed.patch
queue-3.0/ntp-fix-leap-second-hrtimer-livelock.patch
queue-3.0/timekeeping-provide-hrtimer-update-function.patch
queue-3.0/timekeeping-maintain-ktime_t-based-offsets-for-hrtimers.patch
queue-3.0/ntp-correct-tai-offset-during-leap-second.patch
