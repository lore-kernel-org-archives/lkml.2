Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245Ab2JAXDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:03:00 -0400
Received: from 1wt.eu ([62.212.114.60]:35600 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933151Ab2JAXCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:53 -0400
Message-Id: <20121001225158.209098938@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:11 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 014/180] 2.6.32.x: timekeeping: Maintain ktime_t based offsets for hrtimers
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

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
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1341960205-56738-4-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/time/timekeeping.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 1e9808d..c7fbc9f 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -161,18 +161,34 @@ struct timespec xtime __attribute__ ((aligned (16)));
 struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
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
 struct timespec raw_time;
 
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
 	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
 }
 
@@ -576,6 +592,7 @@ void __init timekeeping_init(void)
 	set_normalized_timespec(&wall_to_monotonic,
 				-boot.tv_sec, -boot.tv_nsec);
 	update_xtime_cache(0);
+	update_rt_offset();
 	total_sleep_time.tv_sec = 0;
 	total_sleep_time.tv_nsec = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
@@ -584,6 +601,12 @@ void __init timekeeping_init(void)
 /* time in seconds when suspend began */
 static struct timespec timekeeping_suspend_time;
 
+static void update_sleep_time(struct timespec t)
+{
+	total_sleep_time = t;
+	offs_boot = timespec_to_ktime(t);
+}
+
 /**
  * timekeeping_resume - Resumes the generic timekeeping subsystem.
  * @dev:	unused
@@ -607,7 +630,7 @@ static int timekeeping_resume(struct sys_device *dev)
 		ts = timespec_sub(ts, timekeeping_suspend_time);
 		xtime = timespec_add_safe(xtime, ts);
 		wall_to_monotonic = timespec_sub(wall_to_monotonic, ts);
-		total_sleep_time = timespec_add_safe(total_sleep_time, ts);
+		update_sleep_time(timespec_add_safe(total_sleep_time, ts));
 	}
 	update_xtime_cache(0);
 	/* re-base the last cycle value */
-- 
1.7.2.1.45.g54fbc



