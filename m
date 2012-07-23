Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab2GWBnC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:43:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54205 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753221Ab2GWBm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:56 -0400
Message-Id: <20120723010703.589378557@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:11 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [ 080/108] timekeeping: Maintain ktime_t based offsets for hrtimers
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Link: http://lkml.kernel.org/r/1341960205-56738-4-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[John Stultz: Backported to 3.2]
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/time/timekeeping.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 8958ad7..d5d0e5d 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -161,18 +161,34 @@ static struct timespec xtime __attribute__ ((aligned (16)));
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
@@ -612,7 +635,7 @@ static void __timekeeping_inject_sleeptime(struct timespec *delta)
 
 	xtime = timespec_add(xtime, *delta);
 	wall_to_monotonic = timespec_sub(wall_to_monotonic, *delta);
-	total_sleep_time = timespec_add(total_sleep_time, *delta);
+	update_sleep_time(timespec_add(total_sleep_time, *delta));
 }
 
 


