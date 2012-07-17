Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab2GQWvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:51:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64756 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab2GQWuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:50:25 -0400
Subject: Patch "timekeeping: Provide hrtimer update function" has been added to the 3.0-stable tree
To: johnstul@us.ibm.com, a.p.zijlstra@chello.nl, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, prarit@redhat.com,
        tglx@linutronix.de
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 17 Jul 2012 15:49:59 -0700
In-Reply-To: <1342546438-17534-10-git-send-email-johnstul@us.ibm.com>
Message-ID: <13425653992161@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    timekeeping: Provide hrtimer update function

to the 3.0-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     timekeeping-provide-hrtimer-update-function.patch
and it can be found in the queue-3.0 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From johnstul@us.ibm.com  Tue Jul 17 15:26:41 2012
From: John Stultz <johnstul@us.ibm.com>
Date: Tue, 17 Jul 2012 13:33:56 -0400
Subject: timekeeping: Provide hrtimer update function
To: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>, Prarit Bhargava <prarit@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <1342546438-17534-10-git-send-email-johnstul@us.ibm.com>


From: Thomas Gleixner <tglx@linutronix.de>

This is a backport of f6c06abfb3972ad4914cef57d8348fcb2932bc3b

To finally fix the infamous leap second issue and other race windows
caused by functions which change the offsets between the various time
bases (CLOCK_MONOTONIC, CLOCK_REALTIME and CLOCK_BOOTTIME) we need a
function which atomically gets the current monotonic time and updates
the offsets of CLOCK_REALTIME and CLOCK_BOOTTIME with minimalistic
overhead. The previous patch which provides ktime_t offsets allows us
to make this function almost as cheap as ktime_get() which is going to
be replaced in hrtimer_interrupt().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Link: http://lkml.kernel.org/r/1341960205-56738-7-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hrtimer.h   |    1 +
 kernel/time/timekeeping.c |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -327,6 +327,7 @@ extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_real(void);
 extern ktime_t ktime_get_boottime(void);
 extern ktime_t ktime_get_monotonic_offset(void);
+extern ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot);
 
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1126,6 +1126,40 @@ void get_xtime_and_monotonic_and_sleep_o
 	} while (read_seqretry(&xtime_lock, seq));
 }
 
+#ifdef CONFIG_HIGH_RES_TIMERS
+/**
+ * ktime_get_update_offsets - hrtimer helper
+ * @real:	pointer to storage for monotonic -> realtime offset
+ * @_boot:	pointer to storage for monotonic -> boottime offset
+ *
+ * Returns current monotonic time and updates the offsets
+ * Called from hrtimer_interupt() or retrigger_next_event()
+ */
+ktime_t ktime_get_update_offsets(ktime_t *real, ktime_t *boot)
+{
+	ktime_t now;
+	unsigned int seq;
+	u64 secs, nsecs;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+
+		secs = xtime.tv_sec;
+		nsecs = xtime.tv_nsec;
+		nsecs += timekeeping_get_ns();
+		/* If arch requires, add in gettimeoffset() */
+		nsecs += arch_gettimeoffset();
+
+		*real = offs_real;
+		*boot = offs_boot;
+	} while (read_seqretry(&xtime_lock, seq));
+
+	now = ktime_add_ns(ktime_set(secs, 0), nsecs);
+	now = ktime_sub(now, *real);
+	return now;
+}
+#endif
+
 /**
  * ktime_get_monotonic_offset() - get wall_to_monotonic in ktime_t format
  */


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
