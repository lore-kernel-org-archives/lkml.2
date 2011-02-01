Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab1BANwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:52:35 -0500
Received: from www.tglx.de ([62.245.132.106]:47357 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757197Ab1BANwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:52:30 -0500
Message-Id: <20110201134419.584311693@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:52:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 22/28] time: Introduce timekeeping_inject_offset
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline;
	filename=time-introduce-timekeeping_inject_offset.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

This adds a kernel-internal timekeeping interface to add or subtract
a fixed amount from CLOCK_REALTIME. This makes it so kernel users or
interfaces trying to do so do not have to read the time, then add an
offset and then call settimeofday(), which adds some extra error in
comparision to just simply adding the offset in the kernel timekeeping
core.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <6aec014551fc1d34924d6a7bcf97769867c15ba9.1296124770.git.richard.cochran@omicron.at>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/time.h      |    1 +
 kernel/time/timekeeping.c |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

Index: linux-2.6-tip/include/linux/time.h
===================================================================
--- linux-2.6-tip.orig/include/linux/time.h
+++ linux-2.6-tip/include/linux/time.h
@@ -166,6 +166,7 @@ extern struct timespec timespec_trunc(st
 extern int timekeeping_valid_for_hres(void);
 extern u64 timekeeping_max_deferment(void);
 extern void timekeeping_leap_insert(int leapsecond);
+extern int timekeeping_inject_offset(struct timespec *ts);
 
 struct tms;
 extern void do_sys_times(struct tms *);
Index: linux-2.6-tip/kernel/time/timekeeping.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/timekeeping.c
+++ linux-2.6-tip/kernel/time/timekeeping.c
@@ -387,6 +387,42 @@ int do_settimeofday(const struct timespe
 
 EXPORT_SYMBOL(do_settimeofday);
 
+
+/**
+ * timekeeping_inject_offset - Adds or subtracts from the current time.
+ * @tv:		pointer to the timespec variable containing the offset
+ *
+ * Adds or subtracts an offset value from the current time.
+ */
+int timekeeping_inject_offset(struct timespec *ts)
+{
+	unsigned long flags;
+
+	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
+		return -EINVAL;
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+
+	timekeeping_forward_now();
+
+	xtime = timespec_add(xtime, *ts);
+	wall_to_monotonic = timespec_sub(wall_to_monotonic, *ts);
+
+	timekeeper.ntp_error = 0;
+	ntp_clear();
+
+	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+				timekeeper.mult);
+
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	/* signal hrtimers about time change */
+	clock_was_set();
+
+	return 0;
+}
+EXPORT_SYMBOL(timekeeping_inject_offset);
+
 /**
  * change_clocksource - Swaps clocksources if a new one is available
  *


